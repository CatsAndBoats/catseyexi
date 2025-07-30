/*
===========================================================================

  Copyright (c) 2010-2015 Darkstar Dev Teams

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

#ifndef _CDELIVERYBOXPACKET_H
#define _CDELIVERYBOXPACKET_H

#include "common/cbasetypes.h"

#include "basic.h"

#define AH_SANDORIA "AH-SandOria"
#define AH_JEUNO    "AH-Jeuno"
#define AH_WINDURST "AH-Windurst"
#define AH_BASTOK   "AH-Bastok"

enum class GP_CLI_COMMAND_PBX_BOXNO : int8_t;
enum class GP_CLI_COMMAND_PBX_COMMAND : uint8_t;
class CDeliveryBoxPacket : public CBasicPacket
{
public:
    CDeliveryBoxPacket(GP_CLI_COMMAND_PBX_COMMAND action, GP_CLI_COMMAND_PBX_BOXNO boxid, uint8 count, uint8 param);
    CDeliveryBoxPacket(GP_CLI_COMMAND_PBX_COMMAND action, GP_CLI_COMMAND_PBX_BOXNO boxid, CItem* PItem, uint8 slotid, uint8 count, uint8 message);
};

#endif
