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

#pragma once

#include "common/cbasetypes.h"
#include "enums/terrain_type.h"
#include "ximesh.h"

#include <array>
#include <limits>
#include <optional>
#include <string>
#include <vector>

struct MeshBlock
{
    std::vector<float>        vertices;      // x,y,z interleaved (vertexCount * 3)
    std::vector<uint16>       indices;       // 3 per triangle
    std::vector<TriangleMeta> metas;         // 1 per triangle
    bool                      hasBarriers{}; // true if any triangle in this block is a barrier
};

struct MeshPlacement
{
    std::array<float, 9> rotation{}; // 3x3 column-major
    std::array<float, 3> translation{};
    uint8                mapId{};
    bool                 roofed{};
    float                yMin{ std::numeric_limits<float>::max() };
    float                yMax{ std::numeric_limits<float>::lowest() };
};

struct CellEntry
{
    uint16 blockIdx;
    uint16 placementIdx;
};

struct CellSpan
{
    uint32 offset : 24;
    uint32 count : 8;
};

struct CellHit
{
    TerrainType type{ TerrainType::None };
    uint8       mapId{};
    bool        roofed{};
    bool        barrier{};
    float       y{};
};

class CZoneMesh
{
public:
    CZoneMesh() = default;

    auto load(const std::string& filename) -> bool;
    auto query(float x, float y, float z) const -> std::optional<CellHit>;
    auto getTerrainAt(float x, float y, float z) const -> TerrainType;
    auto getFloorId(float x, float y, float z) const -> uint8;
    auto isLoaded() const -> bool
    {
        return loaded_;
    }

private:
    auto worldToCell(float x, float z) const -> std::pair<int, int>;

    bool         loaded_{};
    XimeshHeader header_{};

    std::vector<MeshBlock>     blocks_;
    std::vector<MeshPlacement> placements_;
    std::vector<CellEntry>     entries_;
    std::vector<CellSpan>      cells_;
};
