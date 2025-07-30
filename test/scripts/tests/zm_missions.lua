require("test/scripts/assertions")


local YuhtungaID = zones[xi.zone.Yuhtunga_Jungle]
local CapeTerigganID = zones[xi.zone.Cape_Teriggan]
local BehemothDominionID = zones[xi.zone.Behemoths_Dominion]
local ZitahID = zones[xi.zone.The_Sanctuary_of_ZiTah]
local ChamberOfOraclesID = zones[xi.zone.Chamber_of_Oracles]
local CelestialNexusID = zones[xi.zone.The_Celestial_Nexus]

---@type TestSuite
local suite = {}

suite['ZM1 to ZM3'] = function(world)
    local client, player = world:spawnPlayer()

    player:addMission(xi.mission.log_id.ZILART, xi.mission.id.zilart.THE_NEW_FRONTIER)
    player:setRank(6)

    -- # ZM 1
    -- After defeating the Shadow Lord and gaining rank 6, head to Norg for a cut-scene.
    client:gotoZone(xi.zone.Norg)
    client:expectEvent({ eventId = 1 })
    assertOnMission(player, xi.mission.log_id.ZILART, xi.mission.id.zilart.WELCOME_TNORG)

    -- # ZM 2
    -- Go to L-8 and click on the "Oaken Door" to get a cutscene with Gilgamesh.
    client:gotoAndTriggerEntity("_700", { eventId = 2 }) -- Oaken Door
    assertOnMission(player, xi.mission.log_id.ZILART, xi.mission.id.zilart.KAZHAMS_CHIEFTAINESS)

    -- # ZM 3
    -- Talk to Jakoh Wahcondalo at (J-9) in Kazham to obtain the Key ItemSacrificial Chamber Key,
    -- which is required to enter the deeper areas of the Temple of Uggalepih.
    client:gotoZone(xi.zone.Kazham)
    client:gotoAndTriggerEntity("Jakoh_Wahcondalo", { eventId = 114 })
    assertKeyItem(player, xi.ki.SACRIFICIAL_CHAMBER_KEY, true)
    assertOnMission(player, xi.mission.log_id.ZILART, xi.mission.id.zilart.THE_TEMPLE_OF_UGGALEPIH)

end

suite['ZM4'] = function(world)
    local client, player = world:spawnPlayer()

    player:addMission(xi.mission.log_id.ZILART, xi.mission.id.zilart.THE_TEMPLE_OF_UGGALEPIH)
    player:addKeyItem(xi.ki.SACRIFICIAL_CHAMBER_KEY)

    -- After entering the Sacrificial Chamber, examine the heavy door to enter the Battlefield.
    client:gotoZone(xi.zone.Sacrificial_Chamber)
    client:enterBcnmViaNpc("_4j0", xi.bcnm.TEMPLE_OF_UGGALEPIH)
    client:killBattlefieldMobs()
    client:expectBcnmWin()

    -- On clearing the Battlefield, you will receive a cutscene and exit in a different location to the entrance.
    client:expectEvent({ eventId = 7 })
    client:expectEvent({ eventId = 8 })

    assertKeyItem(player, xi.ki.SACRIFICIAL_CHAMBER_KEY, false)
    assertKeyItem(player, xi.ki.DARK_FRAGMENT, true)
    assertOnMission(player, xi.mission.log_id.ZILART, xi.mission.id.zilart.HEADSTONE_PILGRIMAGE)
end

suite['ZM5'] = function(world)
    local client, player = world:spawnPlayer()

    player:addMission(xi.mission.log_id.ZILART, xi.mission.id.zilart.HEADSTONE_PILGRIMAGE)

    -- Water fragment
    client:gotoZone(xi.zone.La_Theine_Plateau)
    client:gotoAndTriggerEntity("Cermet_Headstone", { eventId = 200, finishOption = 1 })
    assertKeyItem(player, xi.ki.WATER_FRAGMENT, true)
    client:gotoAndTriggerEntity("Cermet_Headstone")
    client:expectNotInEvent()


    -- Ice fragment
    client:gotoZone(xi.zone.Cloister_of_Frost)
    client:gotoAndTriggerEntity("Cermet_Headstone", { eventId = 200, finishOption = 1 })
    assertKeyItem(player, xi.ki.ICE_FRAGMENT, true)
    client:gotoAndTriggerEntity("Cermet_Headstone")
    client:expectNotInEvent()


    -- Earth fragment
    client:gotoZone(xi.zone.Western_Altepa_Desert)
    client:gotoAndTriggerEntity("Cermet_Headstone", { eventId = 200, finishOption = 1 })
    assertKeyItem(player, xi.ki.EARTH_FRAGMENT, true)
    client:gotoAndTriggerEntity("Cermet_Headstone")
    client:expectNotInEvent()


    -- Fire fragment
    client:gotoZone(xi.zone.Yuhtunga_Jungle)
    local tipha = client:getEntity(YuhtungaID.mob.TIPHA)
    local carthi = client:getEntity(YuhtungaID.mob.CARTHI)
    assert(not tipha:isSpawned(), "Tipha already spawned")
    assert(not carthi:isSpawned(), "Carthi already spawned")

    -- Ensure repeated test runs don't prevent respawn from cooldown
    local yuhtungaHeadstone = client:getEntity("Cermet_Headstone")
    yuhtungaHeadstone:setLocalVar("cooldown", 0)

    client:gotoAndTriggerEntity(yuhtungaHeadstone, { eventId = 200, finishOption = 1 })
    assert(tipha:isSpawned(), "Tipha did not spawn")
    assert(carthi:isSpawned(), "Carthi did not spawn")

    client:claimAndKillMob(tipha)
    client:claimAndKillMob(carthi)

    client:gotoAndTriggerEntity(yuhtungaHeadstone, { finishOption = 1 })
    assertKeyItem(player, xi.ki.FIRE_FRAGMENT, true)
    client:expectNotInEvent()
    assert(not tipha:isSpawned(), "Tipha spawned again")
    assert(not carthi:isSpawned(), "Carthi spawned again")


    -- Wind fragment
    client:gotoZone(xi.zone.Cape_Teriggan)
    local axesarion = client:getEntity(CapeTerigganID.mob.AXESARION_THE_WANDERER)
    assert(not axesarion:isSpawned(), "Axesarion already spawned")

    -- Ensure repeated test runs don't prevent respawn from cooldown
    local terigganHeadstone = client:getEntity("Cermet_Headstone")
    terigganHeadstone:setLocalVar("cooldown", 0)

    client:gotoAndTriggerEntity(terigganHeadstone, { eventId = 200, finishOption = 1 })
    assert(axesarion:isSpawned(), "Axesarion did not spawn")

    client:claimAndKillMob(axesarion)

    client:gotoAndTriggerEntity(terigganHeadstone, { eventId = 201, finishOption = 1 })
    assertKeyItem(player, xi.ki.WIND_FRAGMENT, true)
    client:expectNotInEvent()
    assert(not axesarion:isSpawned(), "Axesarion spawned again")


    -- Lightning fragment
    client:gotoZone(xi.zone.Behemoths_Dominion)
    local legWeapon = client:getEntity(BehemothDominionID.mob.LEGENDARY_WEAPON)
    local ancWeapon = client:getEntity(BehemothDominionID.mob.ANCIENT_WEAPON)
    assert(not legWeapon:isSpawned(), "Legendary Weapon already spawned")
    assert(not ancWeapon:isSpawned(), "Ancient Weapon already spawned")

    -- Ensure repeated test runs don't prevent respawn from cooldown
    local bdHeadstone = client:getEntity("Cermet_Headstone")
    bdHeadstone:setLocalVar("cooldown", 0)

    client:gotoAndTriggerEntity(bdHeadstone, { eventId = 200, finishOption = 1 })
    assert(legWeapon:isSpawned(), "Legendary Weapon did not spawn")
    assert(ancWeapon:isSpawned(), "Ancient Weapon did not spawn")

    client:claimAndKillMob(legWeapon)
    client:claimAndKillMob(ancWeapon)

    client:gotoAndTriggerEntity(bdHeadstone, { eventId = 201, finishOption = 1 })
    assertKeyItem(player, xi.ki.LIGHTNING_FRAGMENT, true)
    client:expectNotInEvent()
    assert(not legWeapon:isSpawned(), "Legendary Weapon spawned again")
    assert(not ancWeapon:isSpawned(), "Ancient Weapon spawned again")


    -- Light fragment
    client:gotoZone(xi.zone.The_Sanctuary_of_ZiTah)
    local pilgrim = client:getEntity(ZitahID.mob.DOOMED_PILGRIMS)
    assert(not pilgrim:isSpawned(), "Doomed Pilgrem already spawned")

    -- Ensure repeated test runs don't prevent respawn from cooldown
    local zitahHeadstone = client:getEntity("Cermet_Headstone")
    zitahHeadstone:setLocalVar("cooldown", 0)

    client:gotoAndTriggerEntity(zitahHeadstone, { eventId = 200, finishOption = 1 })
    assert(pilgrim:isSpawned(), "Doomed Pilgrem did not spawn")

    client:claimAndKillMob(pilgrim)

    client:gotoAndTriggerEntity(zitahHeadstone, { eventId = 201, finishOption = 1 })
    assertKeyItem(player, xi.ki.LIGHTNING_FRAGMENT, true)
    client:expectNotInEvent()
    assert(not pilgrim:isSpawned(), "Doomed Pilgrems spawned again")

    assertOnMission(player, xi.mission.log_id.ZILART, xi.mission.id.zilart.THROUGH_THE_QUICKSAND_CAVES)
end

suite['ZM6 and ZM7'] = function(world)
    local client, player = world:spawnPlayer()

    player:addMission(xi.mission.log_id.ZILART, xi.mission.id.zilart.THROUGH_THE_QUICKSAND_CAVES)
    local pedestals_and_fragments = {
        { xi.ki.FIRE_FRAGMENT, "Pedestal_of_Fire" },
        { xi.ki.EARTH_FRAGMENT, "Pedestal_of_Earth" },
        { xi.ki.WATER_FRAGMENT, "Pedestal_of_Water" },
        { xi.ki.WIND_FRAGMENT, "Pedestal_of_Wind" },
        { xi.ki.ICE_FRAGMENT, "Pedestal_of_Ice" },
        { xi.ki.LIGHTNING_FRAGMENT, "Pedestal_of_Lightning" },
        { xi.ki.LIGHT_FRAGMENT, "Pedestal_of_Light" },
        { xi.ki.DARK_FRAGMENT, "Pedestal_of_Dark" },
    }
    for _, info in ipairs(pedestals_and_fragments) do
        player:addKeyItem(info[1])
    end

    -- Enter the Chamber of Oracles.
    client:gotoZone(xi.zone.Chamber_of_Oracles)
    client:enterBcnmViaNpc(ChamberOfOraclesID.npc.BCNM_ENTRY, xi.bcnm.THROUGH_THE_QUICKSAND_CAVES)
    client:killBattlefieldMobs()
    client:expectBcnmWin()

    -- Upon defeating the 3 NM Anticans you will be appear in another area of the Chamber of Oracles;
    -- this is the start of "ZM7 - The Chamber of Oracles".
    -- Place the fragments in the pedestals for cutscene.
    client:expectNotInEvent()
    assertOnMission(player, xi.mission.log_id.ZILART, xi.mission.id.zilart.THE_CHAMBER_OF_ORACLES)

    -- Place a fragment on each pedestal
    for idx, info in ipairs(pedestals_and_fragments) do
        assertKeyItem(player, info[1], true)
        client:gotoAndTriggerEntity(info[2])
        assertKeyItem(player, info[1], false)

        if idx ~= #pedestals_and_fragments then
            -- Is not the last pedestal, so just a message is given
            client:expectNotInEvent()
        else
            -- Clicking the last pedestal starts cutscene
            client:expectEvent({ eventId = 1 })
        end
    end

    assertKeyItem(player, xi.ki.PRISMATIC_FRAGMENT, true)
    assertOnMission(player, xi.mission.log_id.ZILART, xi.mission.id.zilart.RETURN_TO_DELKFUTTS_TOWER)
end

suite['ZM8'] = function(world)
    local client, player = world:spawnPlayer()

    player:addMission(xi.mission.log_id.ZILART, xi.mission.id.zilart.RETURN_TO_DELKFUTTS_TOWER)

    -- Zone into Lower Delkfutt's Tower for a cutscene (this is possibly optional).
    client:gotoZone(xi.zone.Lower_Delkfutts_Tower)
    client:expectEvent({ eventId = 15 })

    -- Go through the portal to Stellar Fulcrum. You will receive a cutscene.
    client:gotoZone(xi.zone.Stellar_Fulcrum)
    client:expectEvent({ eventId = 0 })

    -- Fight and defeat Archduke Kam'lanaut.
    client:enterBcnmViaNpc("_4z0", xi.bcnm.RETURN_TO_DELKFUTTS_TOWER)
    client:killBattlefieldMobs()
    client:expectBcnmWin({ finishOption = 1 })

    -- When the battle has concluded, be prepared for a long cutscene (approx. 6 minutes).
    client:expectEvent({ eventId = 17 })
end

suite['ZM9 to ZM13'] = function(world)
    local client, player = world:spawnPlayer()

    player:addMission(xi.mission.log_id.ZILART, xi.mission.id.zilart.ROMAEVE)

    -- # ZM 9
    -- Next head to Norg to talk to Gilgamesh.
    client:gotoZone(xi.zone.Norg)
    client:expectNotInEvent()
    client:gotoAndTriggerEntity("_700", { eventId = 3 }) -- Oaken Door
    assertOnMission(player, xi.mission.log_id.ZILART, xi.mission.id.zilart.THE_TEMPLE_OF_DESOLATION)

    -- # ZM 10
    -- Observe the gate at the other end of Hall of the Gods twice. [why does wiki list twice?]
    client:gotoZone(xi.zone.Hall_of_the_Gods)
    client:expectNotInEvent()
    client:gotoAndTriggerEntity("_6z0", { eventId = 1 })
    assertOnMission(player, xi.mission.log_id.ZILART, xi.mission.id.zilart.THE_HALL_OF_THE_GODS)

    -- # ZM 11
    -- .. go back to Norg and talk to Gilgamesh.
    client:gotoZone(xi.zone.Norg)
    client:expectNotInEvent()
    client:gotoAndTriggerEntity("_700", { eventId = 169 }) -- Oaken Door
    assertOnMission(player, xi.mission.log_id.ZILART, xi.mission.id.zilart.THE_MITHRA_AND_THE_CRYSTAL)

    -- # ZM 12
    -- Go to Rabao and talk to Maryoh Comyujah, who's standing in front of the windmill at G-7.
    client:gotoZone(xi.zone.Rabao)
    client:expectNotInEvent()
    client:gotoAndTriggerEntity("Maryoh_Comyujah", { eventId = 81, finishOption = 1 })

    -- .. zone into Quicksand Caves.
    client:gotoZone(xi.zone.Quicksand_Caves)
    -- Touch the ??? and select Yes to spawn the Ancient Vessel.
    client:gotoAndTriggerEntity("qm7", { eventId = 12, finishOption = 1 })
    assertKeyItem(player, xi.ki.SCRAP_OF_PAPYRUS, false)

    -- Kill the Ancient Vessel and inspect the ??? again to dig out the Scrap of Papyrus (key item).
    client:claimAndKillMob("Ancient_Vessel")
    client:gotoAndTriggerEntity("qm7", { eventId = 13, finishOption = 1 })
    assertKeyItem(player, xi.ki.SCRAP_OF_PAPYRUS, true)

    -- Return it to Maryoh Comyujah who will give you the Cerulean Crystal (key item).
    client:gotoZone(xi.zone.Rabao)
    client:expectNotInEvent()
    client:gotoAndTriggerEntity("Maryoh_Comyujah", { eventId = 83 })
    assertKeyItem(player, xi.ki.SCRAP_OF_PAPYRUS, false)
    assertKeyItem(player, xi.ki.CERULEAN_CRYSTAL, true)

    -- # ZM 13
    -- Head back to the Hall of the Gods and touch the sealed gate and watch the cutscenes.
    client:gotoZone(xi.zone.Hall_of_the_Gods)
    client:expectNotInEvent()
    client:gotoAndTriggerEntity("_6z0", { eventId = 4 })
    -- There's two Shimmering Circles, so have to pick the lower one.
    client:gotoAndTriggerEntity(17805319, { eventId = 3 })
    assertOnMission(player, xi.mission.log_id.ZILART, xi.mission.id.zilart.THE_GATE_OF_THE_GODS)

    -- Note: You will also have to touch the Portal to Sky for the last CS.
    client:gotoZone(xi.zone.RuAun_Gardens)
    client:expectEvent({ eventId = 51 })
    assertOnMission(player, xi.mission.log_id.ZILART, xi.mission.id.zilart.ARK_ANGELS)
end


suite['ZM14 via DivineMight'] = function(world)
    local client, player = world:spawnPlayer()

    player:addMission(xi.mission.log_id.ZILART, xi.mission.id.zilart.ARK_ANGELS)
    player:addQuest(xi.quest.log_id.OUTLANDS, xi.quest.id.outlands.DIVINE_MIGHT)

    -- Take the main entrance to the Shrine of Ru'Avitau and run straight until you find an unmarked target. Examine the unmarked target for a cutscene.
    client:gotoZone(xi.zone.The_Shrine_of_RuAvitau)
    client:gotoAndTriggerEntity("blank_4", { eventId = 53 })

    player:addItem(xi.items.ARK_PENTASPHERE)

    -- Go to La'Loff Amphitheater and use the Ark Pentasphere to enter a BC where you will confront and defeat all 5 Ark Angels.
    client:gotoZone(xi.zone.LaLoff_Amphitheater)
    client:enterBcnmViaNpc("qm1_1", xi.bcnm.DIVINE_MIGHT, { xi.items.ARK_PENTASPHERE })
    client:killBattlefieldMobs()
    client:expectBcnmWin()

    assertKeyItem(player, xi.ki.SHARD_OF_APATHY, true)
    assertOnMission(player, xi.mission.log_id.ZILART, xi.mission.id.zilart.THE_SEALED_SHRINE)
end

suite['ZM15 to ZM17'] = function(world)
    local client, player = world:spawnPlayer()

    player:addMission(xi.mission.log_id.ZILART, xi.mission.id.zilart.THE_SEALED_SHRINE)

    -- Now go to Norg and talk to Gilgamesh.
    client:gotoZone(xi.zone.Norg)
    client:expectNotInEvent()
    client:gotoAndTriggerEntity("_700", { eventId = 172 }) -- Oaken Door

    -- Then go to Lower Jeuno and talk to Aldo in Tenshodo HQ J-8 for a cutscene.
    client:gotoZone(xi.zone.Lower_Jeuno)
    client:expectNotInEvent()
    client:gotoAndTriggerEntity("Aldo", { eventId = 111 })

    -- Enter Shrine of Ru'Avitau again from the (H-8) entrance for a cutscene with Lion.
    client:gotoZone(xi.zone.The_Shrine_of_RuAvitau, { x = -40, y = -2, z = -230 })
    client:expectEvent({ eventId = 51 })
    assertOnMission(player, xi.mission.log_id.ZILART, xi.mission.id.zilart.THE_CELESTIAL_NEXUS)

    -- ZM 15 battlefield
    client:gotoZone(xi.zone.The_Celestial_Nexus)
    client:enterBcnmViaNpc("_513", xi.bcnm.CELESTIAL_NEXUS)

    -- Phase 1
    local eald = client:getEntity(CelestialNexusID.mob.CELESTIAL_NEXUS_OFFSET)
    local exoplates = client:getEntity(CelestialNexusID.mob.CELESTIAL_NEXUS_OFFSET+1)
    exoplates:setUnkillable(false)

    client:claimAndKillMob(exoplates)
    client:claimAndKillMob(eald)
    client:expectEvent({ eventId = 32004 })

    -- Phase 2
    local eald2 = client:getEntity(CelestialNexusID.mob.CELESTIAL_NEXUS_OFFSET+2)
    client:claimAndKillMob(eald2)
    client:expectBcnmWin()

    -- After the final cutscene, you appear in Hall of the Gods.
    assertEq(player:getZoneID(), xi.zone.Hall_of_the_Gods)

    assertOnMission(player, xi.mission.log_id.ZILART, xi.mission.id.zilart.AWAKENING)

    -- # ZM 17
    -- Zone into Norg for a cutscene with Gilgamesh.
    client:gotoZone(xi.zone.Norg)
    client:expectEvent({ eventId = 176 })

    -- Enter the Neptune's Spire in Lower Jeuno for a cutscene with Aldo.
    client:gotoZone(xi.zone.Lower_Jeuno)
    client:gotoAndTriggerEntity("_6tc", { eventId = 20 }) -- Door to Neptune's Spire

    -- # Start of Shadows of the Departed
    -- After the conquest tally walk back into the Ducal palace for a cutscene.
    player:completeQuest(xi.quest.log_id.JEUNO, xi.quest.id.jeuno.STORMS_OF_FATE)
    client:gotoZone(xi.zone.RuLude_Gardens, { x = 0, y = 0, z = 45 })
    world:tick() -- Trigger region check
    client:expectEvent({ eventId = 161 })
end

return suite
