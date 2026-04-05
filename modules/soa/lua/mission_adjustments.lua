-----------------------------------
-- Mission Adjustments
-- Reverts mission changes that were made during the SoA era
-----------------------------------
require('modules/module_utils')
-----------------------------------
local m = Module:new('soa_mission_adjustments')

m:addOverride('xi.server.onServerStart', function()
    super()

    -----------------------------------
    -- TOAU Mission 4 "Knight of Gold": Adds a forced JST midnight wait to begin Mission 4 (Knight of Gold)
    -- Source: https://forum.square-enix.com/ffxi/threads/42614-Jun-17-2014-%28JST%29-Version-Update
    -----------------------------------
    xi.module.modifyInteractionEntry('scripts/missions/toau/03_President_Salaheem', function(mission)
        local whitegate = mission.sections[1][xi.zone.AHT_URHGAN_WHITEGATE]

        whitegate['Naja_Salaheem'].onTrigger = function(player, npc)
            if player:getMissionStatus(mission.areaId) == 1 then
                if
                    not mission:getMustZone(player) and
                    mission:getVar(player, 'Timer') == 0 -- Module change: Check JST midnight timer
                then
                    return mission:progressEvent(3020, { text_table = 0 }) -- Enter Not-Trion.
                else
                    return mission:event(3003, { [0] = xi.besieged.getMercenaryRank(player), text_table = 0 }) -- Default Dialog.
                end
            else
                return mission:progressEvent(73, { text_table = 0 }) -- Mog Locker scam.
            end
        end

        whitegate.onEventFinish[73] = function(player, csid, option, npc)
            player:setMissionStatus(mission.areaId, 1)
            mission:setMustZone(player)
            mission:setVar(player, 'Timer', 1, JstMidnight()) -- Module change: Start JST midnight timer
        end
    end)

    -----------------------------------
    -- ToAU Mission 6 "Easterly Winds": Adds a forced JST midnight wait to begin Mission 6 (Easterly Winds)
    -- Source: https://forum.square-enix.com/ffxi/threads/44090-Sep-9-2014-%28JST%29-Version-Update
    -----------------------------------
    xi.module.modifyInteractionEntry('scripts/missions/toau/05_Confessions_of_Royalty', function(mission)
        local chateau = mission.sections[1][xi.zone.CHATEAU_DORAGUILLE]

        chateau.onEventFinish[564] = function(player, csid, option, npc)
            if option == 1 then
                player:delKeyItem(xi.ki.RAILLEFALS_LETTER)
                if mission:complete(player) then
                    player:setVar('Mission[4][5]Timer', 1, JstMidnight()) -- Module change: Start JST midnight timer
                end
            end
        end
    end)

    xi.module.modifyInteractionEntry('scripts/missions/toau/06_Easterly_Winds', function(mission)
        local rulude = mission.sections[1][xi.zone.RULUDE_GARDENS]

        rulude.onTriggerAreaEnter[1] = function(player, triggerArea)
            -- Module change: Check JST midnight timer before allowing player to progress the mission
            if mission:getVar(player, 'Timer') == 0 then
                return mission:progressEvent(10094)
            end
        end
    end)

    -----------------------------------
    -- TOAU Mission 8 "A Mercenary Life": Adds a forced JST midnight wait to begin Mission 8 (A Mercenary Life)
    -- Source: https://forum.square-enix.com/ffxi/threads/42614-Jun-17-2014-%28JST%29-Version-Update
    -----------------------------------
    xi.module.modifyInteractionEntry('scripts/missions/toau/07_Westerly_Winds', function(mission)
        local whitegate = mission.sections[1][xi.zone.AHT_URHGAN_WHITEGATE]

        whitegate.onEventFinish[3028] = function(player, csid, option, npc)
            if mission:complete(player) then
                player:delKeyItem(xi.ki.RAILLEFALS_NOTE)
                player:setLocalVar('Mission[4][7]mustZone', 1)
                player:setCharVar('Mission[4][7]Timer', 1, JstMidnight()) -- Module change: Start JST midnight timer
            end
        end
    end)

    xi.module.modifyInteractionEntry('scripts/missions/toau/08_A_Mercenary_Life', function(mission)
        local whitegate = mission.sections[2][xi.zone.AHT_URHGAN_WHITEGATE]

        whitegate.onTriggerAreaEnter[3] = function(player, triggerArea)
            -- Module change: Check JST midnight timer before allowing player to progress the mission
            if mission:getVar(player, 'Timer') == 0 then
                return mission:progressEvent(3050, 3, 3, 3, 3, 3, 3, 3, 3, 0)
            end
        end
    end)
end)

return m
