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

#include "map_socket.h"

#include <common/logging.h>

MapSocket::MapSocket(Scheduler& scheduler, const uint16 port, ReceiveFn onReceiveFn)
: scheduler_(scheduler)
, port_(port)
, socket_(scheduler_.mainContext())
, buffer_{}
, onReceiveFn_(std::move(onReceiveFn))
{
    TracyZoneScoped;

    ShowInfoFmt("MapSocket: Starting on port {}", port_);

    asio::ip::udp::endpoint listen_endpoint(asio::ip::udp::v4(), port_);
    socket_.open(listen_endpoint.protocol());
    socket_.bind(listen_endpoint);

    receive(); // begin receiving loop
}

MapSocket::~MapSocket()
{
    TracyZoneScoped;

    if (socket_.is_open())
    {
        socket_.close();
    }
}

void MapSocket::receive()
{
    TracyZoneScoped;

    socket_.async_receive_from(
        asio::buffer(buffer_), remoteEndpoint_, [this](const std::error_code& ec, std::size_t bytesRecvd)
        {
            // NOTE: ASIO returns the address in host byte order, but we store it in network byte order,
            //     : so we convert it back.
            const auto senderIP   = htonl(remoteEndpoint_.address().to_v4().to_uint());
            const auto senderPort = remoteEndpoint_.port();
            const auto ipp        = IPP(senderIP, senderPort);

            const auto sizedBuffer = ByteSpan(buffer_.data(), bytesRecvd);

            DebugPacketsFmt("Received {} bytes from {}", sizedBuffer.size(), ipp.toString());

            if (ec)
            {
                ShowErrorFmt("Receive error from {}: {}", ipp.toString(), ec.message());
            }
            else if (sizedBuffer.empty())
            {
                ShowErrorFmt("Received empty buffer from {}", ipp.toString());
            }
            else // Everything is OK
            {
                onReceiveFn_(sizedBuffer, ipp);
            }

            if (!scheduler_.closeRequested() && socket_.is_open())
            {
                receive(); // Queue up more work
            }
        });
}

void MapSocket::send(const IPP& ipp, ByteSpan buffer)
{
    TracyZoneScoped;

    DebugPacketsFmt("Sending {} bytes to {}", buffer.size(), ipp.toString());

    // Like with the ip from startReceive(), ASIO is expecting us to be handling it
    // in host byte order, but we store it in network byte order. So, we need to convert it.
    const auto ip       = ntohl(ipp.getIP());
    const auto endpoint = asio::ip::udp::endpoint(asio::ip::address_v4(ip), ipp.getPort());

    socket_.async_send_to(
        asio::buffer(buffer),
        endpoint,
        [](const std::error_code& ec, std::size_t /*bytes_sent*/)
        {
            if (ec)
            {
                ShowErrorFmt("Error sending data: {}", ec.message());
            }
        });

    // This will only be called in the middle of a doSocketsFor() call, so we don't
    // need to enqueue more work when we're done here.
}
