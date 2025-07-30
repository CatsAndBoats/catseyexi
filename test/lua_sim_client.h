#pragma once

class CBasicPacket;
class CLuaBaseEntity;
class CLuaSimulation;
class TestChar;

enum class Zone : uint16;

class CLuaSimClient
{
private:
    std::unique_ptr<TestChar> testChar;
    CLuaSimulation* simulation;
    uint16 sequenceNum = 0;

public:
    static void SolRegister(sol::state& lua);

    CLuaSimClient(std::unique_ptr<TestChar> testChar, CLuaSimulation* simulation);
    ~CLuaSimClient();

    CBasicPacket createPacket(uint16 packetType);
    void sendBasicPacket(CBasicPacket& packet);
    void sendPacket(sol::table dataTable);
    void sendZonePackets();
    void parseIncomingPackets();
    void tick();

    CLuaBaseEntity getPlayer();
    uint16 getCurrentEventId();

    std::optional<uint16> getItemInvSlot(uint16 itemId, uint8 quantity);

    void gotoZone(Zone zoneId);
};
