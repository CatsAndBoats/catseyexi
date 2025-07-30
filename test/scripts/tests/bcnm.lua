require("test/scripts/assertions")


local BalgasDiasID = zones[xi.zone.Balgas_Dais]

---@type TestSuite
local suite = {}

--- Get the option needed to enter a specific BCNM
---@param player LuaBaseEntity
---@param bcnmId integer
local function getBcnmOption(player, bcnmId)
    local bcnmIndex = nil
    for idx, bcnmInfo in ipairs(bcnminfo[player:getZoneID()]) do
        if bcnmInfo.id == bcnmId then
            bcnmIndex = idx - 1
            break
        end
    end
    assert(bcnmIndex ~= nil, "BCNM not found")

    return bit.lshift(bcnmIndex, 4) + 1
end

suite["BCNM entry denied without required item"] = function(world)
    local client, player = world:spawnPlayer({ zone = xi.zone.Balgas_Dais })

    -- Add key item so the burning circle opens BCNM menu when triggered.
    player:addKeyItem(xi.ki.DARK_KEY)

    -- Get the option needed to enter a specific orb BCNM instead
    local option = getBcnmOption(player, xi.bcnm.TREASURE_AND_TRIBULATIONS)

    -- Try to enter the orb BCNM instead of mission bcnm (which is the only one in the menu)
    client:gotoAndTriggerEntity(BalgasDiasID.npc.BCNM_ENTRY, { eventId = 32000, updates = { option }})

    assert(not player:hasStatusEffect(xi.effect.BATTLEFIELD), "Player did enter battlefield")
    assertEq(player:getVar("[BCNM]index"), 0)
end

suite["BCNM entry by trading required item"] = function(world)
    local client1, player1 = world:spawnPlayer({ zone = xi.zone.Balgas_Dais })
    local client2, player2 = world:spawnPlayer({ zone = xi.zone.Balgas_Dais })

    client1:inviteToParty(player2)
    client2:acceptPartyInvite()

    assertEq(#player1:getParty(), 2)

    -- Get the option needed to enter a specific orb BCNM
    local option = getBcnmOption(player1, xi.bcnm.TREASURE_AND_TRIBULATIONS)

    -- Try to enter the orb BCNM via trade
    player1:addItem(xi.items.COMET_ORB)
    client1:tradeNpc(BalgasDiasID.npc.BCNM_ENTRY, { xi.items.COMET_ORB }, { eventId = 32000, updates = { option }})

    assert(player1:hasStatusEffect(xi.effect.BATTLEFIELD), "Player did not enter battlefield")
    assertEq(player1:getVar("[BCNM]index"), 4)

    -- Partied member can now also enter by just triggering without the item
    client2:enterBcnmViaNpc(BalgasDiasID.npc.BCNM_ENTRY, xi.bcnm.TREASURE_AND_TRIBULATIONS)
end


return suite
