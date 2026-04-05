/*
===========================================================================

  Copyright (c) 2026 LandSandBoat Dev Teams

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see http://www.gnu.org/licenses/

===========================================================================
*/

#include "zone_mesh.h"

#include "common/logging.h"
#include "common/tracy.h"
#include "common/utils.h"

#include <DetourCommon.h>
#include <array>
#include <fstream>
#include <span>
#include <unordered_map>
#include <zlib.h>

namespace
{
template <typename T>
auto readAt(const std::span<const uint8> buf, const uint32 offset) -> T
{
    if (offset + sizeof(T) > buf.size())
    {
        return T{};
    }

    T val{};
    std::memcpy(&val, buf.data() + offset, sizeof(T));
    return val;
}

constexpr uint32 BYTES_PER_VERTEX   = 3 * sizeof(float);  // x, y, z
constexpr uint32 BYTES_PER_TRIANGLE = 3 * sizeof(uint16); // 3 indices

auto zlibDecompress(std::vector<uint8>& rawData) -> std::vector<uint8>
{
    constexpr size_t CHUNK_SIZE            = 32 * 1024;        // 32 KB
    constexpr size_t MAX_DECOMPRESSED_SIZE = 64 * 1024 * 1024; // 64 MB

    z_stream stream{};
    if (inflateInit(&stream) != Z_OK)
    {
        return {};
    }

    stream.next_in  = rawData.data();
    stream.avail_in = static_cast<uInt>(rawData.size());

    std::vector<uint8> result;
    result.reserve(rawData.size() * 4);
    std::array<uint8, CHUNK_SIZE> chunk{};

    int rc = Z_OK;
    while (rc != Z_STREAM_END)
    {
        stream.next_out  = chunk.data();
        stream.avail_out = static_cast<uInt>(chunk.size());

        rc = inflate(&stream, Z_NO_FLUSH);
        if (rc != Z_OK && rc != Z_STREAM_END)
        {
            inflateEnd(&stream);
            return {};
        }

        const size_t bytesWritten = chunk.size() - stream.avail_out;
        result.insert(result.end(), chunk.data(), chunk.data() + bytesWritten);

        if (result.size() > MAX_DECOMPRESSED_SIZE)
        {
            inflateEnd(&stream);
            return {};
        }
    }

    inflateEnd(&stream);
    return result;
}

// Local to world space.
auto transform(const std::array<float, 9>& rot, const std::array<float, 3>& trans, const float* vertex) -> std::array<float, 3>
{
    return {
        rot[0] * vertex[0] + rot[3] * vertex[1] + rot[6] * vertex[2] + trans[0],
        rot[1] * vertex[0] + rot[4] * vertex[1] + rot[7] * vertex[2] + trans[1],
        rot[2] * vertex[0] + rot[5] * vertex[1] + rot[8] * vertex[2] + trans[2],
    };
}

} // namespace

auto CZoneMesh::load(const std::string& filename) -> bool
{
    TracyZoneScoped;

    // Step 1. Read the file
    std::ifstream file(filename, std::ios::binary | std::ios::ate);
    if (!file.good())
    {
        return false;
    }

    auto fileSize = static_cast<size_t>(file.tellg());
    file.seekg(0, std::ios::beg);

    std::vector<uint8> rawData(fileSize);
    file.read(reinterpret_cast<char*>(rawData.data()), fileSize);
    if (file.fail())
    {
        ShowErrorFmt("CZoneMesh::load: Failed to read file ({})", filename);
        return false;
    }

    // Step 2. Decompress ximesh zlib
    const std::vector<uint8> decompressed = zlibDecompress(rawData);
    if (decompressed.empty())
    {
        ShowErrorFmt("CZoneMesh::load: zlib decompression failed ({})", filename);
        return false;
    }

    const std::span buf = decompressed;

    // Step 3. Load in the header containing the size of the grid and prepare final vector
    if (buf.size() < sizeof(XimeshHeader))
    {
        ShowErrorFmt("CZoneMesh::load: File too small ({})", filename);
        return false;
    }

    std::memcpy(&header_, buf.data(), sizeof(XimeshHeader));
    if (header_.gridWidth == 0 || header_.gridHeight == 0)
    {
        ShowErrorFmt("CZoneMesh::load: Invalid grid {}x{} ({})", header_.gridWidth, header_.gridHeight, filename);
        return false;
    }

    const uint32 cellCount = static_cast<uint32>(header_.gridWidth) * header_.gridHeight;
    cells_.resize(cellCount);
    blocks_.reserve(header_.blockCount);
    placements_.reserve(header_.placementCount);

    uint32 totalEntries = 0;
    for (uint32 cellIndex = 0; cellIndex < cellCount; ++cellIndex)
    {
        const uint32 cellDataOffset = readAt<uint32>(buf, sizeof(XimeshHeader) + cellIndex * 4);
        if (cellDataOffset != 0 && cellDataOffset + sizeof(XimeshCellHeader) <= buf.size())
        {
            totalEntries += readAt<XimeshCellHeader>(buf, cellDataOffset).entryCount;
        }
    }
    entries_.reserve(totalEntries);

    // Step 3a. Define block and placement parsers (deduplicated by file offset)
    std::unordered_map<uint32, uint16> blockCache;
    std::unordered_map<uint32, uint16> placeCache;

    auto getOrParseBlock = [&](const uint32 fileOffset) -> std::optional<uint16>
    {
        auto [it, inserted] = blockCache.try_emplace(fileOffset, static_cast<uint16>(blocks_.size()));
        if (!inserted)
        {
            return it->second;
        }

        MeshBlock    block;
        const uint16 vertexCount   = readAt<uint16>(buf, fileOffset);
        const uint16 triangleCount = readAt<uint16>(buf, fileOffset + 2);
        const uint16 barrierFlag   = readAt<uint16>(buf, fileOffset + 4);
        block.hasBarriers          = barrierFlag > 0;

        const uint32 vertexBytes = vertexCount * BYTES_PER_VERTEX;
        const uint32 indexBytes  = triangleCount * BYTES_PER_TRIANGLE;
        const uint32 metaBytes   = triangleCount; // 1 byte per triangle

        const uint32 vertexOffset = fileOffset + 8;
        const uint32 indexOffset  = roundUpToNearestFour(vertexOffset + vertexBytes);
        const uint32 metaOffset   = roundUpToNearestFour(indexOffset + indexBytes);

        if (vertexOffset + vertexBytes > buf.size() ||
            indexOffset + indexBytes > buf.size() ||
            metaOffset + metaBytes > buf.size())
        {
            ShowErrorFmt("CZoneMesh: Block OOB at offset 0x{:X} (bufSize={})", fileOffset, buf.size());
            return std::nullopt;
        }

        block.vertices.resize(vertexCount * 3);
        std::memcpy(block.vertices.data(), buf.data() + vertexOffset, vertexBytes);

        block.indices.resize(triangleCount * 3);
        std::memcpy(block.indices.data(), buf.data() + indexOffset, indexBytes);

        block.metas.resize(metaBytes);
        std::memcpy(block.metas.data(), buf.data() + metaOffset, metaBytes);

        blocks_.emplace_back(std::move(block));
        return it->second;
    };

    auto getOrParsePlacement = [&](const uint32 fileOffset) -> std::optional<uint16>
    {
        auto [it, inserted] = placeCache.try_emplace(fileOffset, static_cast<uint16>(placements_.size()));
        if (!inserted)
        {
            return it->second;
        }

        const auto    flags = readAt<PlacementFlags>(buf, fileOffset);
        MeshPlacement placement{
            .mapId  = static_cast<uint8>(flags.mapIdHigh << 3 | flags.mapIdLow),
            .roofed = flags.roofed != 0,
        };

        constexpr size_t TRANSFORM_BYTES = sizeof(placement.rotation) + sizeof(placement.translation);
        if (fileOffset + 4 + TRANSFORM_BYTES > buf.size())
        {
            ShowErrorFmt("CZoneMesh: Placement OOB at offset 0x{:X} (bufSize={})", fileOffset, buf.size());
            return std::nullopt;
        }

        std::memcpy(placement.rotation.data(), buf.data() + fileOffset + 4, TRANSFORM_BYTES);

        placements_.emplace_back(placement);
        return it->second;
    };

    // Step 3b. Parse cells
    for (uint32 cellIndex = 0; cellIndex < cellCount; ++cellIndex)
    {
        const uint32 cellDataOffset = readAt<uint32>(buf, sizeof(XimeshHeader) + cellIndex * 4);
        if (cellDataOffset == 0 || cellDataOffset + sizeof(XimeshCellHeader) > buf.size())
        {
            continue;
        }

        const auto cellHeader = readAt<XimeshCellHeader>(buf, cellDataOffset);
        auto&      cell       = cells_[cellIndex];
        cell.offset           = static_cast<uint32>(entries_.size());
        cell.count            = 0;

        for (uint16 entryIndex = 0; entryIndex < cellHeader.entryCount; ++entryIndex)
        {
            const uint32 entryOffset = cellDataOffset + sizeof(XimeshCellHeader) + entryIndex * sizeof(XimeshCellEntry);
            if (entryOffset + sizeof(XimeshCellEntry) > buf.size())
            {
                break;
            }

            const auto rawEntry     = readAt<XimeshCellEntry>(buf, entryOffset);
            const auto blockIdx     = getOrParseBlock(rawEntry.blockOffset);
            const auto placementIdx = getOrParsePlacement(rawEntry.placementOffset);
            if (!blockIdx || !placementIdx)
            {
                ShowErrorFmt("CZoneMesh::load: Corrupt block/placement data ({})", filename);
                return false;
            }

            entries_.push_back({ *blockIdx, *placementIdx });
            cell.count++;
        }
    }

    // Step 4. Pre-compute Y bounds per placement
    for (uint32 cellIndex = 0; cellIndex < cellCount; ++cellIndex)
    {
        const auto& cell = cells_[cellIndex];
        for (uint16 ref = 0; ref < cell.count; ++ref)
        {
            const auto& [blockIdx, placementIdx] = entries_[cell.offset + ref];
            const auto& block                    = blocks_[blockIdx];
            auto&       place                    = placements_[placementIdx];

            for (size_t v = 0; v < block.vertices.size(); v += 3)
            {
                const auto  world = transform(place.rotation, place.translation, &block.vertices[v]);
                const float wy    = world[1];

                place.yMin = std::min(place.yMin, wy);
                place.yMax = std::max(place.yMax, wy);
            }
        }
    }

    loaded_ = true;
    return true;
}

// World position to cell grid index. Each cell covers 4x4 world units.
auto CZoneMesh::worldToCell(const float x, const float z) const -> std::pair<int, int>
{
    return {
        static_cast<int>(std::floor(x / 4.0f)) + header_.gridWidth / 2,
        static_cast<int>(std::floor(z / 4.0f)) + header_.gridHeight / 2,
    };
}

// Returns the triangle under (x, z) closest above y.
auto CZoneMesh::query(const float x, const float y, const float z) const -> std::optional<CellHit>
{
    const auto [cx, cz]    = worldToCell(x, z);
    const std::array point = { x, 0.0f, z };

    auto searchCell = [&](const int cellX, const int cellZ) -> std::optional<CellHit>
    {
        if (cellX < 0 || cellX >= header_.gridWidth || cellZ < 0 || cellZ >= header_.gridHeight)
        {
            return std::nullopt;
        }

        const auto& cell = cells_[static_cast<uint32>(cellZ) * header_.gridWidth + cellX];
        if (cell.count == 0)
        {
            return std::nullopt;
        }

        std::optional<CellHit> best;
        for (uint16 ref = 0; ref < cell.count; ++ref)
        {
            constexpr float EPSILON              = 0.01f;
            const auto& [blockIdx, placementIdx] = entries_[cell.offset + ref];
            const auto& block                    = blocks_[blockIdx];
            const auto& place                    = placements_[placementIdx];

            // Skip placements entirely above query point
            if (place.yMax < y - EPSILON)
            {
                continue;
            }

            for (size_t triIdx = 0; triIdx < block.metas.size(); ++triIdx)
            {
                const uint16 i0 = block.indices[triIdx * 3 + 0];
                const uint16 i1 = block.indices[triIdx * 3 + 1];
                const uint16 i2 = block.indices[triIdx * 3 + 2];

                const auto world0 = transform(place.rotation, place.translation, &block.vertices[i0 * 3]);
                const auto world1 = transform(place.rotation, place.translation, &block.vertices[i1 * 3]);
                const auto world2 = transform(place.rotation, place.translation, &block.vertices[i2 * 3]);

                float triY = 0.0f;
                if (!dtClosestHeightPointTriangle(point.data(), world0.data(), world1.data(), world2.data(), triY))
                {
                    continue;
                }

                // Pick the closest triangle above the query point (Y is negative-up).
                if (triY >= y - EPSILON && (!best || triY < best->y))
                {
                    const auto& meta = block.metas[triIdx];
                    best             = CellHit{
                                    .type    = static_cast<TerrainType>(meta.material),
                                    .mapId   = place.mapId,
                                    .roofed  = place.roofed,
                                    .barrier = meta.barrier != 0,
                                    .y       = triY,
                    };
                }
            }
        }

        return best;
    };

    // Check target cell first
    if (const auto best = searchCell(cx, cz))
    {
        return best;
    }

    // Miss — check neighbors
    std::optional<CellHit> best;
    for (int dz = -1; dz <= 1; ++dz)
    {
        for (int dx = -1; dx <= 1; ++dx)
        {
            if (dx == 0 && dz == 0)
            {
                continue;
            }

            if (const auto hit = searchCell(cx + dx, cz + dz))
            {
                if (!best || hit->y < best->y)
                {
                    best = hit;
                }
            }
        }
    }

    return best;
}

auto CZoneMesh::getTerrainAt(const float x, const float y, const float z) const -> TerrainType
{
    TracyZoneScoped;

    if (!loaded_)
    {
        return TerrainType::None;
    }

    if (const auto hit = query(x, y, z))
    {
        return hit->type;
    }

    return TerrainType::None;
}

auto CZoneMesh::getFloorId(const float x, const float y, const float z) const -> uint8
{
    TracyZoneScoped;

    if (!loaded_)
    {
        return 0;
    }

    if (const auto hit = query(x, y, z))
    {
        return hit->mapId;
    }

    return 0;
}
