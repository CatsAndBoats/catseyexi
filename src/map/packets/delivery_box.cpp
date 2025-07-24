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

#include "utils/itemutils.h"

#include <cstring>

#include "delivery_box.h"

#include "c2s/0x04d_pbx.h"

CDeliveryBoxPacket::CDeliveryBoxPacket(GP_CLI_COMMAND_PBX_COMMAND action, GP_CLI_COMMAND_PBX_BOXNO boxid, const uint8 count, const uint8 param)
{
    this->setType(0x4B);
    this->setSize(0x14);

    std::memset(buffer_.data() + 4, 0xFF, 12);

    ref<uint8>(0x04) = static_cast<uint8_t>(action);
    ref<uint8>(0x05) = static_cast<int8_t>(boxid);

    if (action == GP_CLI_COMMAND_PBX_COMMAND::Check)
    {
        if (boxid == GP_CLI_COMMAND_PBX_BOXNO::Incoming)
        {
            ref<uint8>(0x0E) = count;
        }
        else
        {
            ref<uint8>(0x0F) = count;
        }
    }
    else if (action == GP_CLI_COMMAND_PBX_COMMAND::Query)
    {
        ref<uint8>(0x0D) = count;
    }

    ref<uint8>(0x0C) = param;
}

CDeliveryBoxPacket::CDeliveryBoxPacket(GP_CLI_COMMAND_PBX_COMMAND action, GP_CLI_COMMAND_PBX_BOXNO boxid, CItem* PItem, uint8 slotid, uint8 count, uint8 message)
{
    this->setType(0x4B);
    this->setSize(0x58);

    std::memset(buffer_.data() + 4, 0xFF, 12);

    ref<uint8>(0x04) = static_cast<uint8_t>(action);
    ref<uint8>(0x05) = static_cast<int8_t>(boxid);
    ref<uint8>(0x06) = slotid;
    ref<uint8>(0x0C) = message; // success: 0x01, else error message
    ref<uint8>(0x0D) = count;

    if (PItem)
    {
        if ((action != GP_CLI_COMMAND_PBX_COMMAND::Get &&
             action != GP_CLI_COMMAND_PBX_COMMAND::Clear &&
             action != GP_CLI_COMMAND_PBX_COMMAND::Reject) ||
            message > 1)
        {
            if (boxid == GP_CLI_COMMAND_PBX_BOXNO::Incoming)
            {
                ref<uint8>(0x10) = 0x07;
                std::memcpy(buffer_.data() + 0x14, PItem->getSender().c_str(),
                            PItem->getSender().size()); // Sender's name.  Client disables "Return" if it starts with "AH"
            }
            else
            {
                ref<uint8>(0x10) = PItem->isSent() ? 0x03 : 0x05; // 0x05 in send: canceled. other values are unknown
                std::memcpy(buffer_.data() + 0x14, PItem->getReceiver().c_str(),
                            PItem->getReceiver().size()); // Receiver's name.  Client disables "Return" if it starts with "AH"
            }
        }
        if (action == GP_CLI_COMMAND_PBX_COMMAND::Set)
        {
            ref<uint8>(0x10) = 0x01;
            ref<uint8>(0x07) = PItem->getSlotID();
        }
        else if (action == GP_CLI_COMMAND_PBX_COMMAND::Send)
        {
            ref<uint8>(0x07) = PItem->getSlotID();
        }
        else if (action == GP_CLI_COMMAND_PBX_COMMAND::Cancel)
        {
            if (message == 0x01)
            {
                ref<uint8>(0x10) = 0x05;
            }
            else if (message == 0x02)
            {
                ref<uint8>(0x10) = 0x04;
            }
        }

        ref<uint16>(0x2C) = PItem->getSubID(); // Only used to display which item was sold on the AH
        ref<uint16>(0x30) = PItem->getID();
        ref<uint32>(0x38) = PItem->getQuantity();
        std::memcpy(buffer_.data() + 0x3C, PItem->m_extra, sizeof(PItem->m_extra));
    }
}
