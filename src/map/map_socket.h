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

#pragma once

#include <common/blowfish.h>
#include <common/cbasetypes.h>
#include <common/ipp.h>
#include <common/scheduler.h>

#include "map_constants.h"

#include <asio/ip/network_v4.hpp>
#include <asio/ip/udp.hpp>
#include <asio/ts/buffer.hpp>
#include <asio/ts/internet.hpp>

class MapSocket
{
public:
    using ReceiveFn = std::function<void(ByteSpan, const IPP&)>;

    MapSocket(Scheduler& scheduler, uint16 port, ReceiveFn onReceiveFn);
    ~MapSocket();

    void send(const IPP& ipp, ByteSpan buffer);

private:
    void receive();

    Scheduler&              scheduler_;
    uint16                  port_;
    asio::ip::udp::socket   socket_;
    NetworkBuffer           buffer_; // TODO: Pass in the global buffer, or only use this one
    asio::ip::udp::endpoint remoteEndpoint_;

    ReceiveFn onReceiveFn_;
};
