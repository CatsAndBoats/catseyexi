#pragma once

class CLuaSimClient;
class CLuaBaseEntity;

enum class RegionType : uint8;

class CLuaSimulation
{
private:
    std::vector<std::unique_ptr<CLuaSimClient>> clients;

public:
    static void SolRegister(sol::state& lua);

    CLuaSimulation();

    CLuaSimClient* createPlayerClient(std::optional<uint8> zoneId);
    void loadZones(sol::variadic_args va);

    void clean();

    void tick(std::optional<uint32> timeSeconds);
    void tickEntity(CLuaBaseEntity& entity);

    void addSeconds(uint32 seconds);
    void setRegionOwner(RegionType region, uint8 nation);
};
