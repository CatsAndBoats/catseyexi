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

// Ximesh binary format -- zlib-compressed zone collision geometry.
// Reference: https://github.com/InoUno/xi-visualizer/blob/main/src/graphics/ximesh.ts
//
// After decompression:
//   [XimeshHeader]                        20 bytes
//   [u32 x cellCount]                     cell offset table
//   ...
//
// Cell (at offset):
//   [XimeshCellHeader]                    reserved u32 + entry count u16
//   [XimeshCellEntry x entryCount]        block offset + placement offset
//
// Block (at blockOffset):
//   [u16 vertexCount] [u16 triangleCount] [u16 barrierFlag] [u16 pad]
//   [float x vertexCount x 3]             local-space xyz
//   [u16 x triangleCount x 3]             indices (4-byte aligned)
//   [TriangleMeta x triangleCount]        material + barrier per tri
//
// Placement (at placementOffset):
//   [PlacementFlags]                      u32 bitfield
//   [float x 12]                          3x3 rotation (col-major) + vec3 translation

#pragma pack(push, 1)
struct XimeshHeader
{
    uint16 gridWidth{};
    uint16 gridHeight{};
    uint32 blockSectionOffset{};
    uint32 placementSectionOffset{};
    uint16 blockCount{};
    uint16 placementCount{};
    uint32 wideSearch{};
};

struct XimeshCellHeader
{
    uint32 reserved{};
    uint16 entryCount{};
};

struct XimeshCellEntry
{
    uint32 blockOffset{};
    uint32 placementOffset{};
};

struct TriangleMeta
{
    uint8 material : 4;
    uint8 barrier : 1;
    uint8 padding : 3;
};

struct PlacementFlags
{
    uint32 padding0 : 2;
    uint32 roofed : 1;
    uint32 mapIdLow : 3;
    uint32 padding1 : 20;
    uint32 mapIdHigh : 2;
    uint32 padding2 : 4;
};
#pragma pack(pop)
