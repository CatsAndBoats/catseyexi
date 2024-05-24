-----------------------------------
-- The Sand Charm
-----------------------------------
-- Log ID: 4, Quest ID: 8
-- Blandine  : !pos 23.118 -7.758 39.575 249
-- Zexu      : !pos 31.511 -9.001 23.496 249
-- Celestina : !pos -37.624 -16.050 75.681 249
-----------------------------------
require('scripts/globals/quests')
require('scripts/globals/interaction/quest')
-----------------------------------

local quest = Quest:new(xi.questLog.OTHER_AREAS, xi.quest.id.otherAreas.THE_SAND_CHARM)

quest.reward = {}

quest.sections =
{
    {
        check = function(player, status, vars)
            return status == xi.questStatus.QUEST_AVAILABLE and
            player:getFameLevel(xi.fameArea.WINDURST) >= 4
        end,

        [xi.zone.MHAURA] =
        {
            ['Blandine'] =
            {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'status') == 0 then
                        return quest:progressEvent(125)
                    elseif quest:getVar(player, 'status') == 2 then
                        return quest:progressEvent(124)
                    end
                end,
            },
            ['Zexu'] =
            {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'status') == 1 then
                        return quest:progressEvent(123)
                    end
                end,
            },
            ['Celestina'] =
            {
                onTrigger = function(player, npc)
                    if quest:getVar(player, 'status') == 3 then
                        return quest:progressEvent(126, xi.item.SAND_CHARM)
                    end
                end,
            },

            onEventFinish =
            {
                [123] = function(player, csid, option, npc)
                    quest:incrementVar(player, 'status', 1)
                end,

                [124] = function(player, csid, option, npc)
                    quest:incrementVar(player, 'status', 1)
                end,

                [125] = function(player, csid, option, npc)
                    quest:incrementVar(player, 'status', 1)
                end,

                [126] = function(player, csid, option, npc)
                    if option == 70 then
                        quest:begin(player)
                    end
                end,
            },
        },
    },

    {
        check = function(player, status, vars)
            return status == xi.questStatus.QUEST_ACCEPTED
        end,

        [xi.zone.MHAURA] =
        {

            ['Celestina'] =
            {
                onTrade = function(player, npc, trade)
                    if npcUtil.tradeHas(trade, xi.item.SAND_CHARM) then
                        return quest:event(127, 0, xi.item.SAND_CHARM)
                    end
                end,
            },

            onEventFinish =
            {
                [127] = function(player, csid, option, npc)
                    npcUtil.giveKeyItem(player, xi.keyItem.MAP_OF_BOSTAUNIEUX_OUBLIETTE)
                    player:setCharVar('blandineThanks', 1)
                    player:tradeComplete()
                    quest:complete(player)
                end,
            },
        },
    },
    {
        {
            check = function(player, status, vars)
                return status == xi.questStatus.QUEST_COMPLETED
            end,

            [xi.zone.MHAURA] =
            {
                ['Blandine'] =
                {
                    onTrigger = function(player, npc)
                        if player:getCharVar('blandineThanks') == 1 then
                            return quest:event(128)
                        else
                            return quest:event(129):replaceDefault()
                        end
                    end,
                },

                onEventFinish =
                {
                    [128] = function(player, csid, option, npc)
                        player:setCharVar('blandineThanks', 0)
                    end,
                },
            },
        },
    },
}

return quest
