require("test/scripts/assertions")


---@type TestSuite
local suite = {}

---@param world SimulationWorld
---@param player LuaBaseEntity
---@param cost integer
local function verifyPerpetuationCost(world, player, cost)
    player:setMP(player:getMaxMP())

    local petName = player:getPetName() or "avatar"
    for _ = 1,5 do
        local startMP = player:getMP()
        world:skipTime(10)
        world:tick()
        local lostMP = startMP - player:getMP()
        assert(
            lostMP == cost,
            string.format("Player did not lose expected MP from having %s summoned. Player lost %u, expected %u.", petName, lostMP, cost)
        )
    end
end

local specialBaseCost = {
    [xi.petId.CARBUNCLE] = 9,
    [xi.petId.FENRIR] = 11,
}

suite['Basic avatar perpetuation cost'] = function(world)
    local client, player = world:spawnPlayer()

    player:changeJob(xi.job.SMN)
    player:setLevel(75)
    player:setMod(xi.mod.REFRESH, 0)

    -- Verify no gain or loss of MP without avatar
    verifyPerpetuationCost(world, player, 0)

    -- Verify losing MP according to avatar perpetuation
    world:skipToVanaDay(xi.day.DARKSDAY)
    player:spawnPet(xi.petId.GARUDA)
    verifyPerpetuationCost(world, player, 13)

    player:despawnPet()
    player:spawnPet(xi.petId.CARBUNCLE)
    verifyPerpetuationCost(world, player, 9)
end

suite['Elemenal staff perpetuation cost'] = function(world)
    local client, player = world:spawnPlayer()

    player:changeJob(xi.job.SMN)
    player:setLevel(75)
    player:setMod(xi.mod.REFRESH, 0)

    -- Increases and decreases for each staff
    local staves = {
        {
            itemId = xi.items.FIRE_STAFF,
            reduction = xi.petId.IFRIT,
            increase = xi.petId.SHIVA,
        },
        {
            itemId = xi.items.EARTH_STAFF,
            reduction = xi.petId.TITAN,
            increase = xi.petId.RAMUH,
        },
        {
            itemId = xi.items.WATER_STAFF,
            reduction = xi.petId.LEVIATHAN,
            increase = xi.petId.IFRIT,
        },
        {
            itemId = xi.items.WIND_STAFF,
            reduction = xi.petId.GARUDA,
            increase = xi.petId.TITAN,
        },
        {
            itemId = xi.items.ICE_STAFF,
            reduction = xi.petId.SHIVA,
            increase = xi.petId.GARUDA,
        },
        {
            itemId = xi.items.THUNDER_STAFF,
            reduction = xi.petId.RAMUH,
            increase = xi.petId.LEVIATHAN,
        },
        {
            itemId = xi.items.LIGHT_STAFF,
            reduction = xi.petId.CARBUNCLE,
            increase = xi.petId.FENRIR,
        },
        {
            itemId = xi.items.DARK_STAFF,
            reduction = xi.petId.FENRIR,
            increase = xi.petId.CARBUNCLE,
        },
    }

    -- Run through each staff and verify
    for _, staff in ipairs(staves) do
        player:addItem(staff.itemId)
        player:equipItem(staff.itemId)

        -- Verify the staff increases cost for same element
        player:despawnPet()
        player:spawnPet(staff.reduction)
        verifyPerpetuationCost(world, player, (specialBaseCost[staff.reduction] or 13) - 2)

        -- Verify the staff increases cost for opposite element
        player:despawnPet()
        player:spawnPet(staff.increase)
        verifyPerpetuationCost(world, player, (specialBaseCost[staff.increase] or 13) + 2)
    end
end



suite['Avatar perpetuation cost reduction by day'] = function(world)
    local client, player = world:spawnPlayer()

    player:changeJob(xi.job.SMN)
    player:setLevel(75)
    player:setMod(xi.mod.REFRESH, 0)

    -- Add item that gives reduction for avatar matching day
    player:addItem(xi.items.SUMMONERS_DOUBLET)
    player:equipItem(xi.items.SUMMONERS_DOUBLET)

    -- Test with avatar matching each day, and one that doesn't
    local cases = {
        {
            day = xi.day.FIRESDAY,
            matching = xi.petId.IFRIT,
            notMatching = xi.petId.GARUDA,
        },
        {
            day = xi.day.EARTHSDAY,
            matching = xi.petId.TITAN,
            notMatching = xi.petId.GARUDA,
        },
        {
            day = xi.day.WATERSDAY,
            matching = xi.petId.LEVIATHAN,
            notMatching = xi.petId.GARUDA,
        },
        {
            day = xi.day.WINDSDAY,
            matching = xi.petId.GARUDA,
            notMatching = xi.petId.IFRIT,
        },
        {
            day = xi.day.ICEDAY,
            matching = xi.petId.SHIVA,
            notMatching = xi.petId.GARUDA,
        },
        {
            day = xi.day.LIGHTNINGDAY,
            matching = xi.petId.RAMUH,
            notMatching = xi.petId.GARUDA,
        },
        {
            day = xi.day.LIGHTSDAY,
            matching = xi.petId.CARBUNCLE,
            notMatching = xi.petId.GARUDA,
        },
        {
            day = xi.day.DARKSDAY,
            matching = xi.petId.FENRIR,
            notMatching = xi.petId.GARUDA,
        },
    }

    for _, case in ipairs(cases) do
        world:skipToVanaDay(case.day)

        player:despawnPet()
        -- Reduced cost with avatar matching day
        player:spawnPet(case.matching)
        local cost = (specialBaseCost[case.matching] or 13) - 3
        verifyPerpetuationCost(world, player, cost)

        player:despawnPet()
        -- Regular cost with avatar not matching day
        player:spawnPet(case.notMatching)
        cost = specialBaseCost[case.notMatching] or 13
        verifyPerpetuationCost(world, player, cost)
    end
end


suite['Avatar perpetuation cost reduction by weather'] = function(world)
    local client, player = world:spawnPlayer()

    player:changeJob(xi.job.SMN)
    player:setLevel(75)
    player:setMod(xi.mod.REFRESH, 0)

    -- Add item that gives reduction for avatar matching weather
    player:addItem(xi.items.SUMMONERS_HORN)
    player:equipItem(xi.items.SUMMONERS_HORN)

    -- Test with avatar matching each day, and one that doesn't
    local cases = {
        {
            weather = xi.weather.HEAT_WAVE,
            matching = xi.petId.IFRIT,
            notMatching = xi.petId.GARUDA,
        },
        {
            weather = xi.weather.DUST_STORM,
            matching = xi.petId.TITAN,
            notMatching = xi.petId.GARUDA,
        },
        {
            weather = xi.weather.RAIN,
            matching = xi.petId.LEVIATHAN,
            notMatching = xi.petId.GARUDA,
        },
        {
            weather = xi.weather.GALES,
            matching = xi.petId.GARUDA,
            notMatching = xi.petId.IFRIT,
        },
        {
            weather = xi.weather.SNOW,
            matching = xi.petId.SHIVA,
            notMatching = xi.petId.GARUDA,
        },
        {
            weather = xi.weather.THUNDER,
            matching = xi.petId.RAMUH,
            notMatching = xi.petId.GARUDA,
        },
        {
            weather = xi.weather.AURORAS,
            matching = xi.petId.CARBUNCLE,
            notMatching = xi.petId.GARUDA,
        },
        {
            weather = xi.weather.DARKNESS,
            matching = xi.petId.FENRIR,
            notMatching = xi.petId.GARUDA,
        },
    }

    for _, case in ipairs(cases) do
        player:setWeather(case.weather)

        player:despawnPet()
        -- Reduced cost with avatar matching day
        player:spawnPet(case.matching)
        local cost = (specialBaseCost[case.matching] or 13) - 3
        verifyPerpetuationCost(world, player, cost)

        player:despawnPet()
        -- Regular cost with avatar not matching day
        player:spawnPet(case.notMatching)
        cost = specialBaseCost[case.notMatching] or 13
        verifyPerpetuationCost(world, player, cost)
    end
end

return suite
