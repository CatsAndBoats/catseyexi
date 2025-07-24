

---@param value integer
---@param expected integer
function assertEq(value, expected)
    assert(value == expected, string.format("Values are not equal: %s ~= %s", value, expected))
end

---@param player LuaBaseEntity
---@param missionLogId integer
---@param missionId integer
function assertOnMission(player, missionLogId, missionId)
    local currentMission = player:getCurrentMission(missionLogId)
    assert(currentMission == missionId, string.format("Expected to be on mission %s, but was on mission %s.", missionId, currentMission))
end

---@param player LuaBaseEntity
---@param zoneId xi.zone
function assertInZone(player, zoneId)
    local currentZoneId = player:getZoneID()
    assert(currentZoneId == zoneId,
        string.format("Expected to be in zone %u, but was in zone %u (%s).",
            zoneId,
            currentZoneId,
            player:getZoneName()
        )
    )
end

---@param player LuaBaseEntity
---@param keyItemId integer
---@param mustHave boolean
function assertKeyItem(player, keyItemId, mustHave)
    if mustHave then
        assert(player:hasKeyItem(keyItemId), string.format("Player does not have key item %u", keyItemId))
    else
        assert(not player:hasKeyItem(keyItemId), string.format("Player has key item %u", keyItemId))
    end
end
