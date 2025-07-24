require("test/scripts/assertions")


---@type TestSuite
local suite = {}

local crystalToElement = {
    [xi.items.FIRE_CRYSTAL] = xi.element.FIRE,
    [xi.items.EARTH_CRYSTAL] = xi.element.EARTH,
    [xi.items.WATER_CRYSTAL] = xi.element.WATER,
    [xi.items.WIND_CRYSTAL] = xi.element.WIND,
    [xi.items.ICE_CRYSTAL] = xi.element.ICE,
    [xi.items.LIGHTNING_CRYSTAL] = xi.element.LIGHTNING,
    [xi.items.LIGHT_CRYSTAL] = xi.element.LIGHT,
    [xi.items.DARK_CRYSTAL] = xi.element.DARK,
}

---@param client SimulationClient
---@param mob LuaBaseEntity
---@param crystal integer
local function verifyCrystalDrop(client, mob, crystal)
    local element = crystalToElement[crystal]
    assertEq(mob:getElement(), element)

    local player = client:getPlayer()

    local gotCrystal = false
    for _ = 1, 100 do
        player:clearInventory()
        player:setLevel(1)
        assert(#player:getItems() == 1, "Player inventory is not empty")

        mob:spawn()
        assert(mob:isAlive(), "Mob is not alive")

        client:claimAndKillMob(mob, { waitForDespawn = true })
        for _, itemID in ipairs(player:getItems()) do
            ---@cast itemID integer

            if itemID == crystal then
                gotCrystal = true
                break
            end

            if crystalToElement[itemID] then
                error(string.format("%s dropped crystal %u, but was expecting %u.", mob:getName(), itemID, crystal))
            end
        end

        if gotCrystal then
            break
        end
    end

    assert(gotCrystal, string.format("%s did not drop expected crystal in 100 kills", mob:getName()))
end

---@param client SimulationClient
---@param mobTable table<string, integer>
local function verifyCrystalDropsInZone(client, mobTable)
    local clientZoneId = client:getPlayer():getZoneID()

    for mobName, crystal in pairs(mobTable) do
        local mobs = SearchEntitiesByName(mobName, clientZoneId, 30)

        -- Find a mob that can drop crystals
        local validMob = nil
        for _, mob in ipairs(mobs) do
            ---@cast mob LuaBaseEntity
            if mob:getMobType() == xi.mobType.Normal and mob:getName() == mobName and mob:getZoneID() == clientZoneId then
                validMob = mob
                break
            end
        end

        if validMob == nil then
            error(string.format("No normal mobs found with name: %s", mobName))
        end

        verifyCrystalDrop(client, validMob, crystal)
    end
end


suite['Crystals drop corresponding to element'] = function(world)
    local client, player = world:spawnPlayer({ zone = xi.zone.East_Sarutabaruta })

    player:addStatusEffect(xi.effect.SIGNET, 0, 0, 0)

    local sarutabarutaMobs = {
        ["Carrion_Crow"] = xi.items.FIRE_CRYSTAL,
        ["Mandragora"] = xi.items.EARTH_CRYSTAL,
        ["Yagudo_Acolyte"] = xi.items.WIND_CRYSTAL,
        ["Pug_Pugil"] = xi.items.WATER_CRYSTAL,
        ["Goblin_Fisher"] = xi.items.LIGHTNING_CRYSTAL,
        ["Mad_Fox"] = xi.items.DARK_CRYSTAL,
    }

    world.simulation:setRegionOwner(xi.region.SARUTABARUTA, xi.nation.WINDURST)
    client:gotoZone(xi.zone.East_Sarutabaruta)
    verifyCrystalDropsInZone(client, sarutabarutaMobs)

    local templeMobs = {
        ["Iron_Maiden"] = xi.items.ICE_CRYSTAL,
        ["Tonberry_Cutter"] = xi.items.LIGHT_CRYSTAL,
    }

    world.simulation:setRegionOwner(xi.region.ELSHIMOUPLANDS, xi.nation.WINDURST)
    client:gotoZone(xi.zone.Temple_of_Uggalepih)
    verifyCrystalDropsInZone(client, templeMobs)
end

---
---@param world SimulationWorld
---@param ... LuaBaseEntity
local function waitForDespawn(world, ...)
    local stillSpawned = true
    local ticks = 0
    while stillSpawned do
        stillSpawned = false
        for _, entity in ipairs({...}) do
            if entity:isSpawned() then
               stillSpawned = true
               break
            end
        end

        if stillSpawned then
            world:skipTime(5)
            world:tick()
            ticks = ticks + 1
        end

        if ticks >= 20 then
            error("Entities did not spawn as expected.")
        end
    end
end

suite['Elementals spawn during matching weather element'] = function(world)
    local client, player = world:spawnPlayer({ zone = xi.zone.Konschtat_Highlands })

    local thunderEle = assert(SearchEntitiesByName("Thunder_Elemental", xi.zone.Konschtat_Highlands)[1]) --[[@as LuaBaseEntity]]
    local earthEle = assert(SearchEntitiesByName("Earth_Elemental", xi.zone.Konschtat_Highlands)[1]) --[[@as LuaBaseEntity]]

    -- Ensure no weather to begin with
    player:setWeather(xi.weather.NONE)
    waitForDespawn(world, thunderEle, earthEle)

    assert(not thunderEle:isAlive(), "Thunder Elemental is alive when it shouldn't be")
    assert(not earthEle:isAlive(), "Earth Elemental is alive when it shouldn't be")

    -- Earth weather spawns only Thunder Elemental
    player:setWeather(xi.weather.THUNDER)
    assert(thunderEle:isAlive(), "Thunder Elemental isn't alive when it should be")
    assert(not earthEle:isAlive(), "Earth Elemental is alive when it shouldn't be")

    -- Earth weather spawns only Earth Elemental
    player:setWeather(xi.weather.DUST_STORM)
    waitForDespawn(world, thunderEle)

    assert(not thunderEle:isAlive(), "Thunder Elemental is alive when it shouldn't be")
    assert(earthEle:isAlive(), "Earth Elemental isn't alive when it should be")

    -- Other weather has none of them
    player:setWeather(xi.weather.FOG)
    waitForDespawn(world, thunderEle, earthEle)

    assert(not thunderEle:isAlive(), "Thunder Elemental is alive when it shouldn't be")
    assert(not earthEle:isAlive(), "Earth Elemental is alive when it shouldn't be")
end

return suite
