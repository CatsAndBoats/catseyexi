require("test/scripts/packet_builder")

--- Wrapper around the C++ interface lua_sim_client for acting like a player client.
---@class SimulationClient
---
---@field rawClient LuaSimClient
---@field world SimulationWorld
SimulationClient = {}

---@private
SimulationClient.__index = SimulationClient

---@param simClient LuaSimClient
---@return SimulationClient
function SimulationClient:new(simClient, world)
    local obj = {}
    setmetatable(obj, self)
    obj.rawClient = simClient
    obj.world = world
    return obj
end

---@param zoneId xi.zone
---@param pos Position?
function SimulationClient:gotoZone(zoneId, pos)
    if self:getPlayer():isInEvent() then
        error(string.format("Player is in event %u while zoning to %u.",
            self.rawClient:getCurrentEventId(),
            zoneId
        ))
    end

    if pos then
        self:getPlayer():setPos(pos)
    end
    self.rawClient:gotoZone(zoneId)
end

function SimulationClient:getPlayer()
    return self.rawClient:getPlayer()
end

function SimulationClient:sendPacket(...)
    return self.rawClient:sendPacket(...)
end

function SimulationClient:getCurrentEventId()
    return self.rawClient:getCurrentEventId()
end

---@param target LuaBaseEntity
---@param expectedEvent ExpectedEvent?
function SimulationClient:trigger(target, expectedEvent)

    local packet = PacketBuilder:new(0x1A)
    packet:setU16(0x08, target:getTargID())
    packet:setU8(0x0A, 0x00) -- Trigger

    self.rawClient:sendPacket(packet.data)

    if expectedEvent then
        self:expectEvent(expectedEvent)
    end
end

---@param target LuaBaseEntity
---@param spellId integer
function SimulationClient:useSpell(target, spellId)

    local packet = PacketBuilder:new(0x1A)
    packet:setU16(0x08, target:getTargID())
    packet:setU8(0x0A, 0x03) -- Spell cast
    packet:setU16(0x0C, spellId)

    self.rawClient:sendPacket(packet.data)
end

---@param target LuaBaseEntity
---@param wsId integer
function SimulationClient:useWeaponskill(target, wsId)

    local packet = PacketBuilder:new(0x1A)
    packet:setU16(0x08, target:getTargID())
    packet:setU8(0x0A, 0x07) -- Weapon skill usage
    packet:setU16(0x0C, wsId)

    self.rawClient:sendPacket(packet.data)
end

---@param target LuaBaseEntity
---@param abilityId integer
function SimulationClient:useAbility(target, abilityId)

    local packet = PacketBuilder:new(0x1A)
    packet:setU16(0x08, target:getTargID())
    packet:setU8(0x0A, 0x09) -- Job ability
    packet:setU16(0x0C, abilityId + 16)

    self.rawClient:sendPacket(packet.data)
end

---@param target LuaBaseEntity
function SimulationClient:changeTarget(target)

    local packet = PacketBuilder:new(0x1A)
    packet:setU16(0x08, target:getTargID())
    packet:setU8(0x0A, 0x0F) -- Change target

    self.rawClient:sendPacket(packet.data)
end

---@param target LuaBaseEntity
function SimulationClient:rangedAttack(target)

    local packet = PacketBuilder:new(0x1A)
    packet:setU16(0x08, target:getTargID())
    packet:setU8(0x0A, 0x10) -- Ranged attack

    self.rawClient:sendPacket(packet.data)
end

function SimulationClient:requestEntityUpdate()

    local packet = PacketBuilder:new(0x1A)
    packet:setU8(0x0A, 0x14) -- Request update for entities

    self.rawClient:sendPacket(packet.data)
end

---@param target LuaBaseEntity
---@param slotId integer
---@param storageId integer?
function SimulationClient:useItem(target, slotId, storageId)

    local packet = PacketBuilder:new(0x37)
    packet:setU16(0x0C, target:getTargID())
    packet:setU8(0x0E, slotId)
    packet:setU8(0x10, storageId or xi.inv.INVENTORY)

    self.rawClient:sendPacket(packet.data)
end

---@class EventParams
---@field eventId integer?
---@field option integer?

---@private
---@param params EventParams?
---@param isUpdate boolean?
function SimulationClient:sendEventPacket(params, isUpdate)
    params = params or {}
    assert(
        self:getCurrentEventId() ~= 65535,
        "Not currently in an event" .. (params.eventId and (", expected: " .. params.eventId) or "")
    )

    assert(
        params.eventId == nil or params.eventId == self:getCurrentEventId(),
        string.format("Expected event %s, but current event is %s.", tostring(params.eventId), self:getCurrentEventId())
    )

    local packet = PacketBuilder:new(0x5B)
    packet:setU32(0x08, params.option or 0)
    if isUpdate then
        packet:setU8(0x0E, 1)
    end
    packet:setU16(0x12, params.eventId or self:getCurrentEventId())

    self.rawClient:sendPacket(packet.data)
    self.rawClient:parseIncomingPackets()
end

function SimulationClient:expectNotInEvent()
    assert(
        self:getCurrentEventId() == 65535,
        "Currently in an event: " .. self:getCurrentEventId()
    )
end

---@class ExpectedEvent
---@field eventId? integer
---@field updates? integer[]
---@field finishOption? integer

---@param expectedEvent ExpectedEvent
function SimulationClient:expectEvent(expectedEvent)
    expectedEvent.updates = expectedEvent.updates or {}
    for _, updateOption in ipairs(expectedEvent.updates) do
        self:eventUpdate({ eventId = expectedEvent.eventId, option = updateOption })
    end
    self:eventFinish({ eventId = expectedEvent.eventId, option = expectedEvent.finishOption })
end

---@param params EventParams?
function SimulationClient:eventFinish(params)
    self:sendEventPacket(params, false)
end

---@param params EventParams?
function SimulationClient:eventUpdate(params)
    self:sendEventPacket(params, true)
end

---@param entityQuery LuaBaseEntity | integer | string
---@return LuaBaseEntity
function SimulationClient:getEntity(entityQuery)
    if type(entityQuery) == "number" then
        zoneId = bit.band(bit.rshift(entityQuery, 12), 0xFFF)

        if self:getPlayer():getZoneID() ~= zoneId then
            self:gotoZone(zoneId)
        end
        return GetEntityByID(entityQuery)

    elseif type(entityQuery) == "string" then
        local result = SearchEntitiesByName(entityQuery, self:getPlayer():getZoneID(), 1)
        assert(#result > 0, "Could not find entity matching: " .. entityQuery)
        return result[1]

    elseif type(entityQuery) == "userdata" or type(entityQuery) == "lightuserdata" then
        return entityQuery --[[@as LuaBaseEntity]]
    else
        error("Invalid entity query.")
    end
end

---@class ItemQty
---@field itemId integer
---@field quantity integer?

---@param npcQuery LuaBaseEntity | integer | string
---@param items (integer | ItemQty)[]
---@param expectedEvent ExpectedEvent?
function SimulationClient:tradeNpc(npcQuery, items, expectedEvent)
    local npc = self:gotoEntity(npcQuery)

    assert(#items > 0, 'Number of items in trade is 0')
    local packet = PacketBuilder:new(0x36)
    packet:setU32(0x04, npc:getID())
    packet:setU16(0x3A, npc:getTargID())
    packet:setU8(0x3C, #items)

    for idx, item in ipairs(items) do
        local itemId
        local quantity = 1
        if type(item) == "number" then
            itemId = item
        else
            itemId = item.itemId
            quantity = item.quantity or 1
        end

        local invSlot = self.rawClient:getItemInvSlot(itemId, quantity)
        assert(invSlot, string.format("Could not find item with ID %u in inventory with needed quantity.", itemId))

        packet:setU8(0x30 + (idx - 1), invSlot)
        packet:setU8(0x08 + (idx - 1) * 4, quantity)
    end

    self.rawClient:sendPacket(packet.data)
    if expectedEvent then
        self:expectEvent(expectedEvent)
    end
end

---@param entityQuery LuaBaseEntity | integer | string
function SimulationClient:gotoEntity(entityQuery)
    local entity = self:getEntity(entityQuery)
    self:getPlayer():setPos(entity:getPos())
    return entity
end


---@param entityQuery LuaBaseEntity | integer | string
---@param expectedEvent ExpectedEvent?
function SimulationClient:gotoAndTriggerEntity(entityQuery, expectedEvent)
    local entity = self:gotoEntity(entityQuery)
    self:trigger(entity, expectedEvent)
    return entity
end


---@class KillMobParams
---@field expectDeath boolean?
---@field waitForDespawn boolean?

---@param mobQuery LuaBaseEntity | integer | string
---@param params KillMobParams?
function SimulationClient:claimAndKillMob(mobQuery, params)
    params = params or {}
    local mob = self:getEntity(mobQuery)
    assert(mob:isSpawned(), string.format("%s is not spawned", mob:getName()))

     -- Claim and add enmity to
    mob:addEnmity(self:getPlayer(), 10, 10)

    -- Deal a lot of damage
    mob:takeDamage(2000000000, self:getPlayer())
    if params.expectDeath == nil or params.expectDeath then
        assert(mob:getHP() == 0, string.format("%s did not die.", mob:getName()))
    end
    self.world:tickEntity(mob) -- Trigger death
    self.world:skipTime(1) -- Wait for mob to die
    self.world:tickEntity(mob) -- Trigger post-death

    -- Also wait for mob to despawn if not in battlefield
    if params.waitForDespawn or not mob:getBattlefield() then
        self.world:skipTime(15) -- Wait for despawn
        self.world:tickEntity(mob) -- Trigger despawn
        self.world:skipTime(4) -- Wait for despawn to finish
        self.world:tickEntity(mob) -- Finish despawn
        assert(not mob:isSpawned(), string.format("%s did not despawn. Current state is: %u", mob:getName(), mob:getCurrentAction()))
    end
end

---@param ... (LuaBaseEntity | integer | string)...
function SimulationClient:claimAndKillMobs(...)
    for _, mobQuery in ipairs({...}) do
        local mob = self:getEntity(mobQuery)
        assert(mob:isSpawned(), string.format("%s is not spawned", mob:getName()))
        self:claimAndKillMob(mob)
    end
end

---@param params KillMobParams?
function SimulationClient:killBattlefieldMobs(params)
    local battlefield = self:getPlayer():getBattlefield()
    assert(battlefield, "Player not currently in a battlefield")
    for _, mob in ipairs(battlefield:getEnemies()) do
        if mob:isSpawned() then
            self:claimAndKillMob(mob, params)
        end
    end
end

---@param npcQuery LuaBaseEntity | integer | string
---@param bcnmId integer
---@param items? (integer | ItemQty)[]
function SimulationClient:enterBcnmViaNpc(npcQuery, bcnmId, items)
    local player = self:getPlayer()
    local bcnmIndex = nil
    for idx, bcnmInfo in ipairs(bcnminfo[player:getZoneID()]) do
        if bcnmInfo.id == bcnmId then
            bcnmIndex = idx - 1
            break
        end
    end
    assert(bcnmIndex ~= nil, "BCNM not found")

    local option = bit.lshift(bcnmIndex, 4) + 1
    if items then
        self:tradeNpc(npcQuery, items, { eventId = 32000, updates = { option } })
    else
        self:gotoAndTriggerEntity(npcQuery, { eventId = 32000, updates = { option } })
    end

    assertEq(player:getVar("[BCNM]index"), bcnmIndex)
    assert(player:hasStatusEffect(xi.effect.BATTLEFIELD), "Player did not enter battlefield")
end

---@class BcnmFinishParam
---@field delayedWin boolean? If the winning cutscene is delayed for the BCNM
---@field finishOption integer? Option value provided in finishing event

---@param params BcnmFinishParam?
function SimulationClient:expectBcnmWin(params)
    params = params or {}
    self.world:tick()

    if params.delayedWin == nil or params.delayedWin then
        -- BCNM plays 7 seconds after win
        self:expectNotInEvent()

        self.world:skipTime({ seconds = 7 })
        self.world:tick()
    end

    self:expectEvent({ eventId = 32001, finishOption = params.finishOption })
end

---@param isLeader boolean?
function SimulationClient:enterDynamis(isLeader)
    local player = self:getPlayer()
    local destination = dynamis.zonemap(player:getZoneID())

    local csMap =
    {
        [dynamis.zone.VALKURM]     = 16,
        [dynamis.zone.BUBURIMU]    = 22,
        [dynamis.zone.QUFIM]       = 3,
        [dynamis.zone.TAVNAZIA]    = 588,
        [dynamis.zone.BEAUCEDINE]  = 119,
        [dynamis.zone.XARCABARD]   = 16,
        [dynamis.zone.SANDORIA]    = 685,
        [dynamis.zone.BASTOK]      = 201,
        [dynamis.zone.WINDURST]    = 452,
        [dynamis.zone.JEUNO]       = 10012,
    }

    local function addKeyItemsInRange(player, startID, endID)
        for id = startID, endID do
            if not player:hasKeyItem(id) then
                player:addKeyItem(id)
            end
        end
    end

    local function completeDarknessNamed(player)
        if not player:hasCompletedMission(xi.mission.log_id.COP, xi.mission.id.cop.DARKNESS_NAMED) then
            player:addMission(xi.mission.log_id.COP, xi.mission.id.cop.DARKNESS_NAMED)
            player:completeMission(xi.mission.log_id.COP, xi.mission.id.cop.DARKNESS_NAMED)
            player:addMission(xi.mission.log_id.COP, xi.mission.id.cop.SHELTERING_DOUBT)
        end
    end

    local additionalReq =
    {
        [dynamis.zone.BEAUCEDINE] = function(player) addKeyItemsInRange(player, xi.ki.HYDRA_CORPS_COMMAND_SCEPTER, xi.ki.HYDRA_CORPS_TACTICAL_MAP) end,

        [dynamis.zone.XARCABARD]  = function(player) addKeyItemsInRange(player, xi.ki.HYDRA_CORPS_COMMAND_SCEPTER, xi.ki.HYDRA_CORPS_INSIGNIA) end,

        [dynamis.zone.VALKURM]    = function(player) completeDarknessNamed(player) end,

        [dynamis.zone.BUBURIMU]   = function(player) completeDarknessNamed(player) end,

        [dynamis.zone.QUFIM]      = function(player) completeDarknessNamed(player) end,

        [dynamis.zone.TAVNAZIA]   = function(player) addKeyItemsInRange(player, xi.ki.DYNAMIS_VALKURM_SLIVER, xi.ki.DYNAMIS_QUFIM_SLIVER) end,
    }

    assert(destination ~= 0, 'Player is not in a dynamis entry zone '..player:getID())

    if additionalReq[destination] then
        additionalReq[destination](player)
    end

    local startNPC = destination <= dynamis.zone.TAVNAZIA and 'Hieroglyphics' or 'Trail_Markings'

    if isLeader then
        SetServerVariable('[DYNAMIS]RES_ENTRY_'..destination, 0)
        SetServerVariable('[DYNAMIS]RES_EXIT_'..destination, 0)
        SetServerVariable('[DYNAMIS]RES_COUNT_'..destination, 0)

        player:addItem({id = xi.items.TIMELESS_HOURGLASS})
        assert(player:hasItem(xi.items.TIMELESS_HOURGLASS), 'Leader did not receive a timeless hourglass')

        self:tradeNpc(startNPC, {{itemId = xi.items.TIMELESS_HOURGLASS}})
        self:eventUpdate({ eventId = destination == dynamis.zone.SANDORIA and 184 or csMap[destination] - 1, option = 0 }) -- Dynamis global does a release() so we have to update here manually
        assert(not player:hasItem(xi.items.TIMELESS_HOURGLASS), 'Leader still has timeless hourglass')
        assert(player:hasItem(xi.items.PERPETUAL_HOURGLASS), 'Leader did not receive perpetual hourglass')

        self:expectNotInEvent()
        self.world:tick()
    else
        local ts = GetServerVariable('[DYNAMIS]RES_ENTRY_'..destination)
        local tsExit = GetServerVariable('[DYNAMIS]RES_EXIT_'..destination)
        local expectedResTime = destination == dynamis.zone.TAVNAZIA and 900 or 3600

        assert(tsExit - ts == expectedResTime, 'Reservation time incorrect')
        player:addItem({id = xi.items.PERPETUAL_HOURGLASS, exdata = utils.encodeValues({
            {2, 0},
            {2, 1},
            {4, 0},
            {4, tsExit},
            {4, ts},
            {2, destination}, })
        })
    end

    assert(player:hasItem(xi.items.PERPETUAL_HOURGLASS), 'Member did not receive a perpetual hourglass')
    self:tradeNpc(startNPC, {{itemId = xi.items.PERPETUAL_HOURGLASS}}, { eventId = csMap[destination], finishOption = 0 })

    assert(player:getZoneID() == destination, "Player did not enter dynamis")
end

---@param player LuaBaseEntity
function SimulationClient:inviteToParty(player)
    local packet = PacketBuilder:new(0x6E)
    packet:setU32(0x04, player:getID())
    packet:setU16(0x08, player:getTargID())
    self.rawClient:sendPacket(packet.data)
end

---@param player LuaBaseEntity
function SimulationClient:formAlliance(player)
    local packet = PacketBuilder:new(0x6E)
    packet:setU32(0x04, player:getID())
    packet:setU16(0x08, player:getTargID())
    packet:setU8(0x0A, 5)
    self.rawClient:sendPacket(packet.data)
end

function SimulationClient:acceptPartyInvite()
    local packet = PacketBuilder:new(0x74)
    packet:setU8(0x04, 1)
    self.rawClient:sendPacket(packet.data)
end

return SimulationClient
