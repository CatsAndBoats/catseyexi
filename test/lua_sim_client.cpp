#include "lua_sim_client.h"

#include "game/entities/charentity.h"
#include "game/enums/gen/item_container.hpp"
#include "game/item_container.h"
#include "game/items/item.h"
#include "game/lua/lua_baseentity.h"
#include "game/packet_system.h"
#include "game/utils/charutils.h"
#include "game/utils/zoneutils.h"
#include "game/zone.h"

#include "lua_simulation.h"
#include "test_char.h"

CLuaSimClient::CLuaSimClient(std::unique_ptr<TestChar> _testChar, CLuaSimulation* _simulation)
: testChar(std::move(_testChar))
, simulation(_simulation)
{
}

CLuaSimClient::~CLuaSimClient()
{
    testChar->session->PChar->clearPacketList();

    if (testChar->session->PChar->isInEvent())
    {
        LogError("Player was in event %u while logging out in %s",
            testChar->session->PChar->currentEvent->eventId,
            testChar->session->PChar->loc.zone->GetName());
    }

    auto zoneOutPacket = createPacket(0x0D);
    sendBasicPacket(zoneOutPacket);
    engine->close_session(testChar->session, testChar->ipp);
}

CBasicPacket CLuaSimClient::createPacket(uint16 packetType)
{
    if (packetType >= 512)
    {
        LogError("Packet type has too big value: %u", packetType);
        return CBasicPacket();
    }

    auto size = PacketSize[packetType];

    auto packet              = CBasicPacket();
    packet.ref<uint8>(0x00)  = (uint8)packetType;
    packet.ref<uint8>(0x01)  = size;
    packet.ref<uint16>(0x02) = this->sequenceNum++;

    return packet;
}

void CLuaSimClient::sendBasicPacket(CBasicPacket& packet)
{
    PacketParser[packet.ref<uint8>(0x00)](testChar->session, testChar->session->PChar, packet);
}

void CLuaSimClient::sendPacket(sol::table dataTable)
{
    uint16 packetType = dataTable[1];
    auto packet       = createPacket(packetType);

    for (auto&& entry : dataTable)
    {
        packet.ref<uint8>(entry.first.as<uint8>()) = entry.second.as<uint8>();
    }

    sendBasicPacket(packet);
}

void CLuaSimClient::sendZonePackets()
{
    testChar->session->PChar->clearPacketList();

    auto zoneOutPacket = createPacket(0x0D);
    sendBasicPacket(zoneOutPacket);
    testChar->session->PChar->loc.zone = nullptr;

    auto zoneInPacket = createPacket(0x0A);
    sendBasicPacket(zoneInPacket);

    // Tick to allow AfterZoneIn action to trigger
    simulation->tick(1);
}

void CLuaSimClient::parseIncomingPackets()
{
    bool foundZonePacket = false;

    for (auto&& packet : testChar->session->PChar->getPacketList())
    {
        switch (packet->id())
        {
        case 0x0B: // CServerIPPacket: request from server to change zone
        {
            foundZonePacket = true;
            break;
        }
        default:
            break;
        }
    }

    if (foundZonePacket)
    {
        sendZonePackets();
    }
}

void CLuaSimClient::tick()
{
    testChar->session->last_update = engine->getTimestamp();
    parseIncomingPackets();
}

CLuaBaseEntity CLuaSimClient::getPlayer()
{
    return CLuaBaseEntity(testChar->session->PChar);
}

uint16 CLuaSimClient::getCurrentEventId()
{
    return testChar->session->PChar->currentEvent->eventId;
}

std::optional<uint16> CLuaSimClient::getItemInvSlot(uint16 itemId, uint8 quantity)
{
    uint8 slotId = 0;
    testChar->session->PChar->getStorage(ItemContainer::Inventory)->ForEachItem([&](CItem* item)
        {
            if (item->getID() == itemId && item->getQuantity() >= quantity)
            {
                slotId = item->getSlotID();
            }
        });

    if (slotId != 0)
    {
        return std::make_optional(slotId);
    }

    return std::nullopt;
}

void CLuaSimClient::gotoZone(Zone zoneId)
{
    if (zoneutils::GetZone(zoneId) == nullptr)
    {
        zoneutils::LoadZones({ zoneId });
    }

    testChar->session->PChar->loc.destination = zoneId;

    sendZonePackets();
}

void CLuaSimClient::SolRegister(sol::state& lua)
{
    SOL_USERTYPE(lua, "SimClient", CLuaSimClient);

    SOL_REGISTER(CLuaSimClient, sendPacket);
    SOL_REGISTER(CLuaSimClient, parseIncomingPackets);
    SOL_REGISTER(CLuaSimClient, getPlayer);
    SOL_REGISTER(CLuaSimClient, getCurrentEventId);
    SOL_REGISTER(CLuaSimClient, getItemInvSlot);
    SOL_REGISTER(CLuaSimClient, gotoZone);
}
