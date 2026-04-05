-----------------------------------
-- Mission Adjustments
-- Reverts mission changes that were made during the RoV era
--- Source: https://forum.square-enix.com/ffxi/threads/51154-Aug.-3-2016-%28JST%29-Version-Update
-----------------------------------
require('modules/module_utils')
-----------------------------------
local m = Module:new('rov_mission_adjustments')

m:addOverride('xi.server.onServerStart', function()
    super()

    ------------------------------------
    --- ToAU Mission 18 "Passing Glory": Adds a forced JST midnight wait to begin Mission 18 (Passing Glory)
    ------------------------------------
    xi.module.modifyInteractionEntry('scripts/missions/toau/17_Guests_of_the_Empire', function(mission)
        local whitegate = mission.sections[1][xi.zone.AHT_URHGAN_WHITEGATE]

        whitegate.onEventFinish[3078] = function(player, csid, option, npc)
            if mission:complete(player) then
                player:setLocalVar('Mission[4][17]mustZone', 1)
                player:setCharVar('Mission[4][17]Timer', 1, JstMidnight()) -- Module change: Start JST midnight timer
            end
        end
    end)

    xi.module.modifyInteractionEntry('scripts/missions/toau/18_Passing_Glory', function(mission)
        mission.sections[1].check = function(player, currentMission, missionStatus, vars)
            return currentMission == mission.missionId and
                not mission:getMustZone(player) and
                mission:getVar(player, 'Timer') == 0
        end
    end)

    ------------------------------------
    --- ToAU Mission 25 "Playing the Part": Adds a forced JST midnight wait to begin Mission 25 (Playing the Part)
    ------------------------------------
    xi.module.modifyInteractionEntry('scripts/missions/toau/24_Foiled_Ambition', function(mission)
        local whitegate = mission.sections[1][xi.zone.AHT_URHGAN_WHITEGATE]

        whitegate.onEventFinish[3097] = function(player, csid, option, npc)
            if mission:complete(player) then
                player:setLocalVar('Mission[4][24]mustZone', 1)
                player:setCharVar('Mission[4][24]Timer', 1, JstMidnight()) -- Module change: Start JST midnight timer
            end
        end
    end)

    xi.module.modifyInteractionEntry('scripts/missions/toau/25_Playing_the_Part', function(mission)
        local whitegate = mission.sections[1][xi.zone.AHT_URHGAN_WHITEGATE]

        whitegate['Naja_Salaheem'].onTrigger = function(player, npc)
            if
                not mission:getMustZone(player) and
                mission:getVar(player, 'Timer') == 0 -- Module change: Check JST midnight timer
            then
                return mission:progressEvent(3110)
            else
                local dialog = mission:getVar(player, 'Option') + 1 -- Captured values 1 and 2
                if dialog == 1 then
                    mission:setVar(player, 'Option', 1)
                else
                    mission:setVar(player, 'Option', 0)
                end

                return mission:event(3098, xi.besieged.getMercenaryRank(player), 1, 0, 0, 0, 0, 0, dialog, 0)
            end
        end
    end)

    ------------------------------------
    --- ToAU Mission 33 "Sentinels' Honor": Adds a forced JST midnight wait to begin Mission 33 (Sentinels' Honor)
    ------------------------------------
    xi.module.modifyInteractionEntry('scripts/missions/toau/32_In_the_Blood', function(mission)
        local whitegate = mission.sections[1][xi.zone.AHT_URHGAN_WHITEGATE]

        whitegate.onEventFinish[3113] = function(player, csid, option, npc)
            if mission:complete(player) then
                player:setLocalVar('Mission[4][32]mustZone', 1)
                player:setCharVar('Mission[4][32]Timer', 1, JstMidnight()) -- Module change: Start JST midnight timer
            end
        end
    end)

    xi.module.modifyInteractionEntry('scripts/missions/toau/33_Sentinels_Honor', function(mission)
        local whitegate = mission.sections[1][xi.zone.AHT_URHGAN_WHITEGATE]

        whitegate['Naja_Salaheem'].onTrigger = function(player, npc)
            local hasZoned      = not mission:getMustZone(player)
            local hasTimePassed = mission:getVar(player, 'Timer') == 0 -- Module change: Check JST midnight timer

            -- Calculate event.
            local eventId = (hasZoned and hasTimePassed) and 3130 or 3120

            -- Calculate dialog.
            local dialog = 2

            if not hasTimePassed then -- Dialog parameter cycles between 0 and 2 until time lockout is over. At that point, option 0 stops happening.
                dialog = mission:getVar(player, 'Option')
                if dialog == 0 then
                    mission:setVar(player, 'Option', 2)
                else
                    mission:setVar(player, 'Option', 0)
                end
            end

            return mission:event(eventId, xi.besieged.getMercenaryRank(player), 1, 0, 0, 0, 0, 0, dialog, 0)
        end
    end)

    ------------------------------------
    --- ToAU Mission 38 "Stirrings of War": Adds a forced JST midnight wait to begin Mission 38 (Stirrings of War)
    ------------------------------------
    xi.module.modifyInteractionEntry('scripts/missions/toau/37_Path_of_Blood', function(mission)
        local whitegate = mission.sections[1][xi.zone.AHT_URHGAN_WHITEGATE]

        whitegate.onEventFinish[3220] = function(player, csid, option, npc)
            if mission:complete(player) then
                player:setLocalVar('Mission[4][37]mustZone', 1)
                player:setCharVar('Mission[4][37]Timer', 1, JstMidnight()) -- Module change: Start JST midnight timer
            end
        end
    end)

    xi.module.modifyInteractionEntry('scripts/missions/toau/38_Stirrings_of_War', function(mission)
        mission.sections[1].check = function(player, currentMission, missionStatus, vars)
            return currentMission == mission.missionId and
                not mission:getMustZone(player) and
                mission:getVar(player, 'Timer') == 0 -- Module change: Check JST midnight timer
        end
    end)
end)

return m
