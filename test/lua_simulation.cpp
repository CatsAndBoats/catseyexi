#include "lua_simulation.h"

#include "game/ai/ai_container.h"
#include "game/battlefield_handler.h"
#include "game/entities/charentity.h"
#include "game/enums/gen/region_type.hpp"
#include "game/enums/gen/status.hpp"
#include "game/lua/lua_baseentity.h"
#include "game/utils/charutils.h"
#include "game/utils/zoneutils.h"
#include "game/zone.h"

#include "test_char.h"

#include "lua_sim_client.h"

CLuaSimulation::CLuaSimulation()
{
}

CLuaSimClient* CLuaSimulation::createPlayerClient(std::optional<uint8> zoneId)
{
    auto testChar = TestChar::create(zoneId.value_or(210));

    if (!testChar)
    {
        return nullptr;
    }

    auto player           = new CCharEntity();
    player->id            = testChar->charId;
    player->accid         = testChar->accountId;
    player->clientVersion = 0;
    player->status        = Status::Disappear;
    player->loc.zone      = nullptr;
    player->SetPlayTime(INT32_MAX);

    // Create session
    uint32 ip   = testChar->charId;
    uint16 port = 12345;
    uint64 ipp  = ip;
    ipp |= (uint64)port << 32;

    testChar->ipp = ipp;

    auto session = engine->create_session(ip, port, ipp, 0);

    session->client_packet_id = 0;
    session->server_packet_id = 0;

    // Load char
    charutils::LoadChar(player);
    session->PChar = player;

    testChar->session = session;

    // Insert account session with dummy values
    uint8 key3[20];
    char session_key[sizeof(key3) * 2 + 1];
    bin2hex(session_key, key3, sizeof(key3));

    auto query = "INSERT INTO accounts_sessions(accid,charid,session_key,server_addr,server_port,client_addr, client_version, version_mismatch) VALUES(%u,%u,x'%s',%u,%u,%u,%u,%u)";
    if (Sql_Query(SqlHandle, query, testChar->accountId, testChar->charId, session_key, 0, 0, 0, player->clientVersion, 0) == SQL_ERROR)
    {
        LogError("Unable to create session for account.");
    }

    auto client        = std::make_unique<CLuaSimClient>(std::move(testChar), this);
    auto clientPointer = client.get();
    this->clients.push_back(std::move(client));
    return clientPointer;
}

void CLuaSimulation::loadZones(sol::variadic_args va)
{
    std::vector<Zone> zoneIds;
    for (auto&& zoneId : va)
    {
        if (zoneId.is<Zone>())
        {
            zoneIds.push_back(zoneId.as<Zone>());
        }
        else
        {
            LogError("Invalid zone ID provided.");
        }
    }

    zoneutils::LoadZones(zoneIds);
}

void CLuaSimulation::clean()
{
    clients.clear();
    zoneutils::ForEachZone([](CZone* zone)
        {
            if (zone->m_BattlefieldHandler)
            {
                zone->m_BattlefieldHandler->cleanupBattlefields();
            }
        });
}

void CLuaSimulation::tick(std::optional<uint32> timeSeconds)
{
    if (timeSeconds.has_value())
    {
        engine->setTime(engine->getTime() + std::chrono::seconds(timeSeconds.value()));
    }

    for (auto&& client : clients)
    {
        client->tick();
    }

    CTaskMgr::getInstance()->DoTimer(engine->getTime());
}

void CLuaSimulation::tickEntity(CLuaBaseEntity& entity)
{
    entity.GetBaseEntity()->PAI->Tick(engine->getTime());
}

void CLuaSimulation::addSeconds(uint32 seconds)
{
    engine->setTime(engine->getTime() + std::chrono::seconds(seconds));
}

void CLuaSimulation::setRegionOwner(RegionType region, uint8 nation)
{
    auto query = "UPDATE server_conquest SET region_control = %u WHERE region_id = %u;";

    if (Sql_Query(SqlHandle, query, nation, (uint8)region) == SQL_ERROR)
    {
        LogError("Unable to update region owner. %u", Sql_AffectedRows(SqlHandle));
    }
}

void CLuaSimulation::SolRegister(sol::state& lua)
{
    SOL_USERTYPE(lua, "Simulation", CLuaSimulation);

    SOL_REGISTER(CLuaSimulation, createPlayerClient);
    SOL_REGISTER(CLuaSimulation, tick);
    SOL_REGISTER(CLuaSimulation, tickEntity);
    SOL_REGISTER(CLuaSimulation, addSeconds);

    SOL_REGISTER(CLuaSimulation, setRegionOwner);
}
