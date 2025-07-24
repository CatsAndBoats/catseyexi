
---@type TestSuite
local suite = {}

suite['Quest: The Pickpocket'] = function(world)
    local client, player = world:spawnPlayer({ zone = xi.zone.PORT_SAN_DORIA })

    assert(player:getQuestStatus(xi.quest.Sandoria.THE_PICKPOCKET) == xi.quest.status.AVAILABLE, "Quest is not available")

    -- Pre-requisite event
    client:gotoAndTriggerEntity('Altiret', { eventId = 559 })
    client:gotoAndTriggerEntity('Miene', { eventId = 502 })

    -- Starts quest
    client:gotoAndTriggerEntity('Miene', { eventId = 554 })
    client:gotoAndTriggerEntity('Altiret', { eventId = 547 })
    assert(player:getQuestStatus(xi.quest.Sandoria.THE_PICKPOCKET) == xi.quest.status.ACCEPTED, "Quest is not accepted")

    client:gotoAndTriggerEntity('Miene', { eventId = 549 })
    assert(player:hasItem(xi.items.EAGLE_BUTTON), "Player did not get eagle button")
    -- TODO: add checks for tossing and reacquiring button

    client:gotoZone(xi.zone.WEST_RONFAURE)
    client:tradeNpc('Esca', { xi.items.EAGLE_BUTTON }, { eventId = 121 })
    assert(not player:hasItem(xi.items.EAGLE_BUTTON), "Player still has eagle button")
    assert(player:hasItem(xi.items.GILT_GLASSES), "Player did not get gilt glasses")

    client:gotoZone(xi.zone.PORT_SAN_DORIA)
    client:tradeNpc('Altiret', { xi.items.GILT_GLASSES }, { eventId = 550 })
    assert(player:getQuestStatus(xi.quest.Sandoria.THE_PICKPOCKET) == xi.quest.status.COMPLETED, "Quest is not completed")
end

return suite
