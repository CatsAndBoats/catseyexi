require("test/scripts/assertions")


---@type TestSuite
local suite = {}

---@param client SimulationClient
---@param mob LuaBaseEntity
---@param kills integer
---@return { [number]: number }
local function simulateDrops(client, mob, kills)
    local player = client:getPlayer()
    local dropsGotten = {}

    for _ = 1, kills do
        player:clearInventory()
        assert(#player:getItems() == 1, "Player inventory is not empty")

        mob:spawn()
        assert(mob:isAlive(), "Mob is not alive")

        client:claimAndKillMob(mob, { waitForDespawn = true })
        for _, itemID in ipairs(player:getItems()) do
            dropsGotten[itemID] = (dropsGotten[itemID] or 0) + 1
        end
    end

    return dropsGotten
end

local function verifyDropRateWithin(samples, drops, expectedRate, deviation)
    local observedRate = drops / samples * 100.0
    local diff = math.abs(expectedRate - observedRate)

    if diff > deviation then
        error(string.format("Expected droprate of %.2f%%, but observed %.2f%%", expectedRate, observedRate))
    end
end

suite["_skip"] = {
    ["Verify drop rates (Devil Manta)"] = "Long test case",
}

suite['Verify drop rates (Devil Manta)'] = function(world)
    local client, player = world:spawnPlayer({ zone = xi.zone.Cape_Terrigan })

    -- Setup TH4
    player:changeJob(xi.job.THF)
    player:setLevel(75)

    assert(
        player:getMod(xi.mod.TREASURE_HUNTER) == 2,
        string.format("Player expected to have TH2, but had TH%d", player:getMod(xi.mod.TREASURE_HUNTER))
    )

    player:addItem(xi.items.THIEFS_KNIFE)
    player:equipItem(xi.items.THIEFS_KNIFE, nil, xi.itemSlot.Main)

    assert(
        player:getMod(xi.mod.TREASURE_HUNTER) == 3,
        string.format("Player expected to have TH3, but had TH%d", player:getMod(xi.mod.TREASURE_HUNTER))
    )

    player:addItem(xi.items.ASSASSINS_ARMLETS)
    player:equipItem(xi.items.ASSASSINS_ARMLETS)

    assert(
        player:getMod(xi.mod.TREASURE_HUNTER) == 4,
        string.format("Player expected to have TH4, but had TH%d", player:getMod(xi.mod.TREASURE_HUNTER))
    )

    local kills = 10000
    local devilManta = client:getEntity(17240070)
    local dropsGotten = simulateDrops(client, devilManta, kills)

    -- Expect 18% angel skins (10% base)
    verifyDropRateWithin(kills, dropsGotten[xi.items.PIECE_OF_ANGEL_SKIN], 18.0, 1.0)

    -- Expect 45% shall shells (15% base)
    verifyDropRateWithin(kills, dropsGotten[xi.items.SHALL_SHELL], 45.0, 1.0)

    -- Expect 64% manta skins (24% base)
    verifyDropRateWithin(kills, dropsGotten[xi.items.MANTA_SKIN], 64.0, 1.0)
end

return suite
