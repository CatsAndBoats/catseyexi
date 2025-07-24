
---@type TestSuite
local suite = {}

suite["Midnight delay is respected"] = function(world)
    local client, player = world:spawnPlayer({ zone = xi.zone.Aht_Urhgan_Whitegate })

    local timeToMidnight = GetMidnightTimestamp() - GetTimestamp()
    assert(timeToMidnight > 0, "A negative amount of seconds to midnight is invalid.")

    -- Check if test is being run very close to midnight, and skip to next day/midnight if that's the case.
    if timeToMidnight < 60 then
        world:skipTime(180)
    end

    player:addMission(xi.mission.log_id.TOAU, xi.mission.id.toau.PRESIDENT_SALAHEEM)

    -- Talk to Rytaal at the Commission Agency (K-10).
    client:gotoAndTriggerEntity('Rytaal', { eventId = 269 })

    -- Return to Naja Salaheem who will tell you to talk to Fubruhn (F-11).
    client:gotoAndTriggerEntity('Naja_Salaheem', { eventId = 73 })

    -- Zone before talking to Naja again.
    client:gotoZone(xi.zone.Al_Zahbi)
    client:gotoZone(xi.zone.Aht_Urhgan_Whitegate)

    -- Still need to wait for midnight
    client:gotoAndTriggerEntity('Naja_Salaheem', { eventId = 3003 })

    -- Calculate seconds to next midnight
    timeToMidnight = GetMidnightTimestamp() - GetTimestamp()
    assert(timeToMidnight > 0, "A negative amount of seconds to midnight is invalid.")

    world:skipTime(timeToMidnight - 5)
    client:gotoAndTriggerEntity('Naja_Salaheem', { eventId = 3003 })

    -- Right after midnight, the mission progresses
    world:skipTime(10)
    client:gotoAndTriggerEntity('Naja_Salaheem', { eventId = 3020 })
end

return suite
