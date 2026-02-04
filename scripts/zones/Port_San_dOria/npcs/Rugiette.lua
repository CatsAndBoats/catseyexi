-----------------------------------
-- Area: Port San d'Oria
--  NPC: Rugiette
-- Involved in Quests: Riding on the Clouds, Lure of the Wildcat (San d'Oria)
-- !pos 71 -9 -73 232
-----------------------------------
---@type TNpcEntity
local entity = {}

entity.onTrigger = function(player, npc)
    if player:getQuestStatus(xi.questLog.SANDORIA, xi.quest.id.sandoria.LURE_OF_THE_WILDCAT) == xi.questStatus.QUEST_ACCEPTED then
        player:startEvent(746)
    else
        player:startEvent(601)
    end
end

entity.onEventFinish = function(player, csid, option, npc)
    if csid == 746 then
        local wildcatSandy = player:getCharVar('WildcatSandy')
        if not utils.mask.getBit(wildcatSandy, 14) then
            player:setCharVar('WildcatSandy', utils.mask.setBit(wildcatSandy, 14, true))
            npcUtil.giveQuestItem(player, xi.questLog.SANDORIA, xi.quest.id.sandoria.LURE_OF_THE_WILDCAT, 1)
        end
    end
end

return entity
