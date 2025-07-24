/*
===========================================================================

  Copyright (c) 2025 LandSandBoat Dev Teams

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

#include "0x03d_black_edit.h"

#include "common/database.h"
#include "packets/blacklist_edit_response.h"
#include "utils/blacklistutils.h"
#include "utils/charutils.h"

namespace
{
    const auto sendFailPacket = [](CCharEntity* PChar)
    {
        PChar->pushPacket<CBlacklistEditResponsePacket>(0, "", 0x02);
    };
} // namespace

auto GP_CLI_COMMAND_BLACK_EDIT::validate(MapSession* PSession, const CCharEntity* PChar) const -> PacketValidationResult
{
    return PacketValidator()
        .oneOf<GP_CLI_COMMAND_BLACK_EDIT_MODE>(Mode);
}

void GP_CLI_COMMAND_BLACK_EDIT::process(MapSession* PSession, CCharEntity* PChar) const
{
    const auto name = db::escapeString(asStringFromUntrustedSource(Data.Name, 15));

    const auto [charid, accid] = charutils::getCharIdAndAccountIdFromName(name);
    if (!charid)
    {
        sendFailPacket(PChar);
        return;
    }

    switch (static_cast<GP_CLI_COMMAND_BLACK_EDIT_MODE>(Mode))
    {
        case GP_CLI_COMMAND_BLACK_EDIT_MODE::Add:
        {
            if (blacklistutils::AddBlacklisted(PChar->id, charid))
            {
                PChar->pushPacket<CBlacklistEditResponsePacket>(accid, name, Mode);
            }
            else
            {
                sendFailPacket(PChar);
            }
        }
        break;
        case GP_CLI_COMMAND_BLACK_EDIT_MODE::Remove:
        {
            if (blacklistutils::DeleteBlacklisted(PChar->id, charid))
            {
                PChar->pushPacket<CBlacklistEditResponsePacket>(accid, name, Mode);
            }
            else
            {
                sendFailPacket(PChar);
            }
        }
        break;
    }
}
