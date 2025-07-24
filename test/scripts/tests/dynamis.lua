require("test/scripts/assertions")

---@type TestSuite
local suite = {}

suite['Enter Dynamis with full alliance'] = function(world)
    local entryZoneList =
    {
        xi.zone.SOUTHERN_SAN_DORIA,
        xi.zone.BASTOK_MINES,
        xi.zone.WINDURST_WALLS,
        xi.zone.RULUDE_GARDENS,
        xi.zone.BEAUCEDINE_GLACIER,
        xi.zone.XARCABARD,
        xi.zone.VALKURM_DUNES,
        xi.zone.BUBURIMU_PENINSULA,
        xi.zone.QUFIM_ISLAND,
    }

    for _, entryZone in pairs(entryZoneList) do
        local client1, player1   = world:spawnPlayer({ zone = entryZone })
        local client2, player2   = world:spawnPlayer({ zone = entryZone })
        local client3, player3   = world:spawnPlayer({ zone = entryZone })
        local client4, player4   = world:spawnPlayer({ zone = entryZone })
        local client5, player5   = world:spawnPlayer({ zone = entryZone })
        local client6, player6   = world:spawnPlayer({ zone = entryZone })

        local client7, player7   = world:spawnPlayer({ zone = entryZone })
        local client8, player8   = world:spawnPlayer({ zone = entryZone })
        local client9, player9   = world:spawnPlayer({ zone = entryZone })
        local client10, player10 = world:spawnPlayer({ zone = entryZone })
        local client11, player11 = world:spawnPlayer({ zone = entryZone })
        local client12, player12 = world:spawnPlayer({ zone = entryZone })

        local client13, player13 = world:spawnPlayer({ zone = entryZone })
        local client14, player14 = world:spawnPlayer({ zone = entryZone })
        local client15, player15 = world:spawnPlayer({ zone = entryZone })
        local client16, player16 = world:spawnPlayer({ zone = entryZone })
        local client17, player17 = world:spawnPlayer({ zone = entryZone })
        local client18, player18 = world:spawnPlayer({ zone = entryZone })

        local alli =
        {
            {
                { p = player1, c = client1, },
                { p = player2, c = client2, },
                { p = player3, c = client3, },
                { p = player4, c = client4, },
                { p = player5, c = client5, },
                { p = player6, c = client6, },
            },
            {
                { p = player7,  c = client7, },
                { p = player8,  c = client8, },
                { p = player9,  c = client9, },
                { p = player10, c = client10, },
                { p = player11, c = client11, },
                { p = player12, c = client12, },
            },
            {
                { p = player13, c = client13, },
                { p = player14, c = client14, },
                { p = player15, c = client15, },
                { p = player16, c = client16, },
                { p = player17, c = client17, },
                { p = player18, c = client18, },
            },
        }

        local allianceLeader = alli[1][1]

        -- Form alliance

        for partyNum = 1, 3 do
            for memberNum = 2, 6 do
                alli[partyNum][1].c:inviteToParty(alli[partyNum][memberNum].p)
                alli[partyNum][memberNum].c:acceptPartyInvite()
            end
        end

        for partyNum = 1, 3 do
            for memberNum = 1, 6 do
                assertEq(alli[partyNum][memberNum].p:getPartySize(), 6)
            end
        end

        for partyNum = 1, 3 do
            for memberNum = 1, 6 do
                assert(alli[partyNum][memberNum].p:getPartyLeader() == alli[partyNum][1].p, 'Party formation failed')
            end
        end

        for partyNum = 2, 3 do
            alli[1][1].c:formAlliance(alli[partyNum][1].p)
            alli[partyNum][1].c:acceptPartyInvite()
        end

        for partyNum = 1, 3 do
            for memberNum = 1, 6 do
                assert(alli[partyNum][memberNum].p:inAlliance(), 'Alliance formation failed')
                assertEq(alli[partyNum][memberNum].p:checkSoloPartyAlliance(), 2)
            end
        end

        for partyNum = 1, 3 do
            for memberNum = 1, 6 do
                local player = alli[partyNum][memberNum].p

                player:setRank(6)
                player:setLevel(75)
                player:setVar( "Dynamis_Status", 1)
                player:addKeyItem(xi.ki.VIAL_OF_SHROUDED_SAND)
            end
        end

        for partyNum = 1, 3 do
            for memberNum = 1, 6 do
                local isLeader = alli[partyNum][memberNum].p:getID() == allianceLeader.p:getID()

                alli[partyNum][memberNum].c:enterDynamis(isLeader)
                alli[partyNum][memberNum].p:wait(10)
            end
        end

        for partyNum = 1, 3 do
            for memberNum = 1, 6 do
                alli[partyNum][memberNum].c:gotoZone(entryZone)
                assert(alli[partyNum][memberNum].p:getZoneID() == entryZone, 'Player did not zone out of dynamis')
            end
        end

        SetServerVariable('[DYNAMIS]RES_ENTRY_'..dynamis.zonemap(entryZone), 0)
        SetServerVariable('[DYNAMIS]RES_EXIT_'..dynamis.zonemap(entryZone), 0)
        SetServerVariable('[DYNAMIS]RES_COUNT_'..dynamis.zonemap(entryZone), 0)
    end
end

return suite
