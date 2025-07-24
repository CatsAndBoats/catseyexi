require("test/scripts/assertions")


---@type TestSuite
local suite = {}

suite['Ancient Flames Beckon'] = function(world)
    local client, player = world:spawnPlayer()

    player:addMission(xi.mission.log_id.COP, xi.mission.id.cop.ANCIENT_FLAMES_BECKON)

    -- # COP 0
    -- zone into Lower Delkfutts Tower for a series of CS's
    client:gotoZone(xi.zone.Qufim_Island)
    client:gotoZone(xi.zone.Lower_Delkfutts_Tower)
    client:expectEvent({ eventId = 22 })
    client:expectEvent({ eventId = 36 })
    client:expectEvent({ eventId = 37 })
    client:expectEvent({ eventId = 38 })
    client:expectEvent({ eventId = 39 })
    assertOnMission(player, xi.mission.log_id.COP, xi.mission.id.cop.THE_RITES_OF_LIFE)
end

suite['the Rites of Life'] = function(world)
    local client, player = world:spawnPlayer()

    player:addMission(xi.mission.log_id.COP, xi.mission.id.cop.THE_RITES_OF_LIFE)
    -- # COP 1
    -- Zone into Upper Jueno for a CS
    client:gotoZone(xi.zone.Upper_Jeuno)
    client:expectEvent({ eventId = 2 })

    -- trigger Monberaux for a series of CS's complete quest and get KI
    client:gotoAndTriggerEntity("Monberaux", { eventId = 10 })
    client:expectEvent({ eventId = 206 })
    client:expectEvent({ eventId = 207 })
    assertOnMission(player, xi.mission.log_id.COP, xi.mission.id.cop.BELOW_THE_ARKS)
    assertKeyItem(player, xi.ki.MYSTERIOUS_AMULET, true)
end

suite['Below the Arks - Holla'] = function(world)
    local client, player = world:spawnPlayer()

    player:addMission(xi.mission.log_id.COP, xi.mission.id.cop.BELOW_THE_ARKS)

    -- trigger Pherimociel to goto next Prog
    client:gotoZone(xi.zone.Upper_Jeuno)
    client:gotoAndTriggerEntity("Monberaux", { eventId = 9 })

    client:gotoZone(xi.zone.RuLude_Gardens)
    client:gotoAndTriggerEntity("High_Wind", { eventId = 33 })
    client:gotoAndTriggerEntity("Rainhard", { eventId = 34 })
    client:gotoAndTriggerEntity("Pherimociel", { eventId = 24 })

    -- optional dialog
    client:gotoAndTriggerEntity("Pherimociel", { eventId = 25 })

    -- entering hall of transference -> Promy Holla
    client:gotoZone(xi.zone.Hall_of_Transference)
    client:gotoAndTriggerEntity("_0e3", { eventId = 160 })
    -- Is ported to promyvion after event.

    assertInZone(player, xi.zone.PromyvionHolla)
    -- 1st time entering gets a CS
    client:expectEvent({ eventId = 50 })

    -- Spire of Holla, trigger and enter BCNM, winning grants next mission
    client:gotoZone(xi.zone.Spire_of_Holla)
    client:enterBcnmViaNpc("_0h0", xi.bcnm.ANCIENT_FLAMES_BECKON_HOLLA)
    client:killBattlefieldMobs()
    player:setLocalVar("belowTheArks", 1)
    client:expectBcnmWin({ finishOption = 2 })
    assertKeyItem(player, xi.ki.LIGHT_OF_HOLLA, true)
    assertOnMission(player, xi.mission.log_id.COP, xi.mission.id.cop.THE_MOTHERCRYSTALS)
end

suite['The Mothercrystals'] = function(world)
    local client, player = world:spawnPlayer()

    player:addMission(xi.mission.log_id.COP, xi.mission.id.cop.THE_MOTHERCRYSTALS)
    player:addKeyItem(xi.ki.LIGHT_OF_HOLLA)
    player:setVar('M[6][3]Prog', 1) -- set at end of last mission

    client:gotoZone(xi.zone.RuLude_Gardens)
    client:gotoAndTriggerEntity("Chapi_Galepilai", { eventId = 11 })

    -- entering next promy
    client:gotoZone(xi.zone.Konschtat_Highlands)
    client:gotoAndTriggerEntity('Shattered_Telepoint')
    client:expectEvent({ eventId = 912 })

    -- CS on entering promy
    client:gotoZone(xi.zone.Hall_of_Transference)
    client:gotoZone(xi.zone.PromyvionDem)
    client:expectEvent({ eventId = 51 })

    -- Fight at BCNM
    client:gotoZone(xi.zone.Spire_of_Dem)
    client:enterBcnmViaNpc("_0j0", xi.bcnm.ANCIENT_FLAMES_BECKON_DEM)
    client:killBattlefieldMobs()
    client:expectBcnmWin({ finishOption = 2 })
    assertKeyItem(player, xi.ki.LIGHT_OF_DEM, true)

    -- going to next promy, cs inside hall of transference
    client:gotoZone(xi.zone.Tahrongi_Canyon)
    client:gotoAndTriggerEntity('Shattered_Telepoint', { eventId = 913, finishOption = 0 })

    client:gotoZone(xi.zone.Hall_of_Transference)
    -- event upon entering hall
    client:expectEvent({ eventId = 155 })

    -- Player is automatically zoned at the end of last event.
    assertInZone(player, xi.zone.PromyvionMea)
    -- Event upon entering promy
    client:expectEvent({ eventId = 52 })

    -- enter and beat BCNM
    client:gotoZone(xi.zone.Spire_of_Mea)
    client:enterBcnmViaNpc("_0l0", xi.bcnm.ANCIENT_FLAMES_BECKON_MEA)
    client:killBattlefieldMobs()
    client:expectBcnmWin({ finishOption = 2 })
    assertKeyItem(player, xi.ki.LIGHT_OF_MEA, true)

    -- check if mission completes
    assertOnMission(player, xi.mission.log_id.COP, xi.mission.id.cop.AN_INVITATION_WEST)

    -- Mission complete check if new teleports work
    -- zone in cs
    client:gotoZone(xi.zone.Lufaise_Meadows)
    client:gotoAndTriggerEntity("Swirling_Vortex")
    client:expectEvent({ eventId = 100 })

    client:gotoZone(xi.zone.Misareaux_Coast)
    client:gotoAndTriggerEntity("Swirling_Vortex")
    client:expectEvent({ eventId = 554 })

    client:gotoZone(xi.zone.Qufim_Island)
    client:gotoAndTriggerEntity("Swirling_Vortex")
    client:expectEvent({ eventId = 300 })

    client:gotoZone(xi.zone.Valkurm_Dunes)
    client:gotoAndTriggerEntity("Swirling_Vortex")
    client:expectEvent({ eventId = 12 })
end

suite['An Invitiation West'] = function(world)
    local client, player = world:spawnPlayer()
    -- setup mission
    player:addMission(xi.mission.log_id.COP, xi.mission.id.cop.AN_INVITATION_WEST)
    player:addKeyItem(xi.ki.MYSTERIOUS_AMULET)

    -- zone in and lose amulet
    client:gotoZone(xi.zone.Lufaise_Meadows)
    client:expectEvent({ eventId = 110 })
    assertKeyItem(player, xi.ki.MYSTERIOUS_AMULET, false)

    -- zone in to gain next mission
    client:gotoZone(xi.zone.Tavnazian_Safehold)
    client:expectEvent({ eventId = 101 })

    -- check if mission completes
    assertOnMission(player, xi.mission.log_id.COP, xi.mission.id.cop.THE_LOST_CITY)
end

suite['The Lost City'] = function(world)
    local client, player = world:spawnPlayer()
    -- setup mission
    player:addMission(xi.mission.log_id.COP, xi.mission.id.cop.THE_LOST_CITY)

    client:gotoZone(xi.zone.Tavnazian_Safehold)
    client:gotoAndTriggerEntity("Despachiaire")
    client:expectEvent({ eventId = 102 })

    client:gotoAndTriggerEntity("Liphatte")
    client:expectEvent({ eventId = 301 })

    client:gotoAndTriggerEntity("Justinius")
    client:expectEvent({ eventId = 360 })

    client:gotoAndTriggerEntity("_0q1")
    client:expectEvent({ eventId = 103 })

    -- check if mission completes
    assertOnMission(player, xi.mission.log_id.COP, xi.mission.id.cop.DISTANT_BELIEFS)
end

suite['Distant Beliefs'] = function(world)
    local client, player = world:spawnPlayer()
    local ID = zones[xi.zone.Phomiuna_Aqueducts]

    -- setup mission
    player:addMission(xi.mission.log_id.COP, xi.mission.id.cop.DISTANT_BELIEFS)

    client:gotoZone(xi.zone.Tavnazian_Safehold)
    client:gotoAndTriggerEntity("Justinius")
    client:expectEvent({ eventId = 123 })
    client:gotoAndTriggerEntity("_0q1")
    client:expectEvent({ eventId = 502 })

    client:gotoZone(xi.zone.Phomiuna_Aqueducts)
    world:skipTime(900)
    world:tick()
    client:claimAndKillMob(ID.mob.MINOTOUR)

    client:gotoAndTriggerEntity(ID.npc.WOODEN_LADDER)
    client:expectEvent({ eventId = 35 })

    client:gotoAndTriggerEntity("_0r5")
    client:expectEvent({ eventId = 36 })

    client:gotoZone(xi.zone.Tavnazian_Safehold)
    client:gotoAndTriggerEntity("Justinius")
    client:expectEvent({ eventId = 113 })

    -- check if mission completes
    assertOnMission(player, xi.mission.log_id.COP, xi.mission.id.cop.AN_ETERNAL_MELODY)
end

suite['An Eternal Melody'] = function(world)
    local client, player = world:spawnPlayer()

    -- setup mission
    player:addMission(xi.mission.log_id.COP, xi.mission.id.cop.AN_ETERNAL_MELODY)

    client:gotoZone(xi.zone.Tavnazian_Safehold)
    client:gotoAndTriggerEntity("Calengeard")
    client:expectEvent({ eventId = 395 })
    client:gotoAndTriggerEntity("Reaugettie")
    client:expectEvent({ eventId = 292 })
    client:gotoAndTriggerEntity("Justinius")
    client:expectEvent({ eventId = 125 })
    client:gotoAndTriggerEntity("_0qa")
    client:expectEvent({ eventId = 104 })
    assertKeyItem(player, xi.ki.MYSTERIOUS_AMULET, true)

    client:gotoZone(xi.zone.Misareaux_Coast)
    client:gotoAndTriggerEntity("_0p0")
    client:expectEvent({ eventId = 5 })

    client:gotoZone(xi.zone.Tavnazian_Safehold, { x = -5, y = -24, z = 18 })
    world:skipTime(1)
    world:tick()
    client:expectEvent({ eventId = 105 })

    -- check if mission completes
    assertOnMission(player, xi.mission.log_id.COP, xi.mission.id.cop.ANCIENT_VOWS)
end

suite['Ancient Vows'] = function(world)
    local client, player = world:spawnPlayer()
    local ID = zones[xi.zone.Monarch_Linn]

    -- setup mission
    player:addMission(xi.mission.log_id.COP, xi.mission.id.cop.ANCIENT_VOWS)

    client:gotoZone(xi.zone.Misareaux_Coast)
    client:gotoAndTriggerEntity("_0p2")
    client:expectEvent({ eventId = 6 })

    client:gotoZone(xi.zone.RiverneSite_A01)
    client:expectEvent({ eventId = 100 })

    client:gotoZone(xi.zone.Monarch_Linn)
    client:enterBcnmViaNpc(ID.npc.BCNM_ENTRY, xi.bcnm.ANCIENT_VOWS)
    client:killBattlefieldMobs()
    client:expectBcnmWin({ finishOption = 2 })

    assertOnMission(player, xi.mission.log_id.COP, xi.mission.id.cop.A_TRANSIENT_DREAM)

    client:expectEvent({ eventId = 906 })

    assertOnMission(player, xi.mission.log_id.COP, xi.mission.id.cop.THE_CALL_OF_THE_WYRMKING)
end

suite['The Call of the Wyrmking'] = function(world)
    local client, player = world:spawnPlayer()

    -- setup mission
    player:addMission(xi.mission.log_id.COP, xi.mission.id.cop.THE_CALL_OF_THE_WYRMKING)

    client:gotoZone(xi.zone.Port_Bastok, { x = -100, y = 0, z = -10 })
    world:skipTime(1)
    world:tick()
    client:expectEvent({ eventId = 305 })

    client:gotoZone(xi.zone.Metalworks)
    client:gotoAndTriggerEntity("Cid")
    client:expectEvent({ eventId = 845 })

    assertOnMission(player, xi.mission.log_id.COP, xi.mission.id.cop.A_VESSEL_WITHOUT_A_CAPTAIN)
end

suite['A Vessel Without a Captain'] = function(world)
    local client, player = world:spawnPlayer()

    -- setup mission
    player:addMission(xi.mission.log_id.COP, xi.mission.id.cop.A_VESSEL_WITHOUT_A_CAPTAIN)

    client:gotoZone(xi.zone.Lower_Jeuno)
    client:gotoAndTriggerEntity("_6tc")
    client:expectEvent({ eventId = 86 })

    client:gotoZone(xi.zone.RuLude_Gardens)
    client:gotoAndTriggerEntity("Auchefort")
    client:expectEvent({ eventId = 6 })
    client:gotoAndTriggerEntity("Pherimociel")
    client:expectEvent({ eventId = 26 })

    client:gotoZone(xi.zone.RuLude_Gardens, { x = 0, y = 0, z = 45 })
    world:skipTime(1)
    world:tick()
    client:expectEvent({ eventId = 65 })

    assertOnMission(player, xi.mission.log_id.COP, xi.mission.id.cop.THE_ROAD_FORKS)
end

suite['The Road Forks'] = function(world)
    local client, player = world:spawnPlayer()
    local carpenterID = zones[xi.zone.Carpenters_Landing]
    local chasmID = zones[xi.zone.Attohwa_Chasm]

    -- setup mission
    player:addMission(xi.mission.log_id.COP, xi.mission.id.cop.THE_ROAD_FORKS)
    player:setVar('M[6][28]Path1', 1)
    player:setVar('M[6][28]Path2', 1)

    -- 1st Path
    client:gotoZone(xi.zone.Northern_San_dOria)
    world:tick()
    client:expectEvent({ event = 14 })
    client:gotoAndTriggerEntity("Arnau")
    client:expectEvent({ eventId = 51 })
    client:gotoAndTriggerEntity("Chasalvige")
    client:expectEvent({ eventId = 38 })

    client:gotoZone(xi.zone.Carpenters_Landing)
    client:gotoAndTriggerEntity("Guilloud")
    world:tick()
    local ivy = client:getEntity(carpenterID.mob.OVERGROWN_IVY)
    assert(ivy:isSpawned())

    client:claimAndKillMob(ivy)
    world:tick()

    client:gotoAndTriggerEntity("Guilloud")
    client:expectEvent({ event = 0 })

    client:gotoZone(xi.zone.Southern_San_dOria)
    client:gotoAndTriggerEntity("Hinaree")
    client:expectEvent({ event = 23 })
    client:gotoAndTriggerEntity("Hinaree")
    client:expectEvent({ event = 24 })

    -- 2nd Path
    client:gotoZone(xi.zone.Windurst_Waters)
    world:tick()
    client:expectEvent({ event = 871 })
    client:gotoAndTriggerEntity("Ohbiru-Dohbiru")
    client:expectEvent({ event = 872 })

    client:gotoZone(xi.zone.Windurst_Walls)
    client:gotoAndTriggerEntity("Yoran-Oran")
    client:expectEvent({ event = 469 })

    client:gotoZone(xi.zone.Windurst_Waters)
    client:gotoAndTriggerEntity("Kyume-Romeh", { event = 873 })
    client:gotoAndTriggerEntity("Honoi-Gomoi", { event = 874 })
    assertKeyItem(player, xi.ki.CRACKED_MIMEO_MIRROR, true)

    client:gotoZone(xi.zone.Windurst_Walls)
    client:gotoAndTriggerEntity("Yoran-Oran", { eventId = 470 })
    assertKeyItem(player, xi.ki.CRACKED_MIMEO_MIRROR, false)

    client:gotoZone(xi.zone.Attohwa_Chasm)
    client:gotoAndTriggerEntity("Loose_Sand")
    world:tick()
    local mob2 = client:getEntity(chasmID.mob.LIOUMERE)
    assert(mob2:isSpawned())

    client:claimAndKillMob(mob2)
    world:tick()

    client:gotoAndTriggerEntity("Loose_Sand")
    assertKeyItem(player, xi.ki.MIMEO_JEWEL, true)

    client:gotoAndTriggerEntity("Cradle_of_Rebirth")
    client:expectEvent({ event = 2 })
    assertKeyItem(player, xi.ki.MIMEO_JEWEL, false)
    assertKeyItem(player, xi.ki.MIMEO_FEATHER, true)
    assertKeyItem(player, xi.ki.SECOND_MIMEO_FEATHER, true)
    assertKeyItem(player, xi.ki.THIRD_MIMEO_FEATHER, true)

    client:gotoZone(xi.zone.Windurst_Walls)
    client:gotoAndTriggerEntity("Yoran-Oran")
    client:expectEvent({ event = 471 })
    assertKeyItem(player, xi.ki.MIMEO_FEATHER, false)
    assertKeyItem(player, xi.ki.SECOND_MIMEO_FEATHER, false)
    assertKeyItem(player, xi.ki.THIRD_MIMEO_FEATHER, false)

    client:gotoZone(xi.zone.Port_Windurst)
    client:gotoAndTriggerEntity("Yujuju")
    client:expectEvent({ event = 592 })

    client:gotoZone(xi.zone.Windurst_Waters)
    client:gotoAndTriggerEntity("Tosuka-Porika")
    client:expectEvent({ event = 875 })

    client:gotoZone(xi.zone.Windurst_Walls)
    client:gotoAndTriggerEntity("Yoran-Oran")
    client:expectEvent({ event = 472 })

    client:gotoZone(xi.zone.Metalworks)
    client:gotoAndTriggerEntity("Cid")
    client:expectEvent({ event = 847 })

    assertOnMission(player, xi.mission.log_id.COP, xi.mission.id.cop.TENDING_AGED_WOUNDS)
end

suite['Tending Aged Wounds'] = function(world)
    local client, player = world:spawnPlayer()

    -- setup mission
    player:addMission(xi.mission.log_id.COP, xi.mission.id.cop.TENDING_AGED_WOUNDS)

    client:gotoZone(xi.zone.Lower_Jeuno)
    world:tick()
    client:expectEvent({ event = 70 })

    client:gotoAndTriggerEntity("_6tc")
    client:expectEvent({ event = 22 })

    assertOnMission(player, xi.mission.log_id.COP, xi.mission.id.cop.DARKNESS_NAMED)

    client:expectEvent({ event = 10 })
end

suite['Darkness Named'] = function(world)
    local client, player = world:spawnPlayer()
    local ID = zones[xi.zone.The_Shrouded_Maw]

    -- setup mission
    player:addMission(xi.mission.log_id.COP, xi.mission.id.cop.DARKNESS_NAMED)

    client:gotoZone(xi.zone.Upper_Jeuno)
    client:gotoAndTriggerEntity("Monberaux")
    client:expectEvent({ event = 82 })

    client:gotoZone(xi.zone.Lower_Jeuno)
    client:gotoAndTriggerEntity("Ghebi_Damomohe")
    client:expectEvent({ event = 54 })
    client:gotoAndTriggerEntity("Ghebi_Damomohe")
    client:expectEvent({ event = 53 })

    player:addItem(xi.items.GRAY_CHIP)
    client:tradeNpc('Ghebi_Damomohe', { xi.items.GRAY_CHIP }, { eventId = 52 })
    assertKeyItem(player, xi.ki.PSOXJA_PASS, true)

    client:gotoZone(xi.zone.The_Shrouded_Maw)
    world:tick()
    client:expectEvent({ event = 2 })

    client:enterBcnmViaNpc(ID.npc.BCNM_ENTRY, xi.bcnm.DARKNESS_NAMED)
    client:killBattlefieldMobs()
    client:expectBcnmWin({ finishOption = 2 })

    client:gotoZone(xi.zone.Upper_Jeuno)
    client:gotoAndTriggerEntity("Monberaux")
    client:expectEvent({ event = 75 })

    assertOnMission(player, xi.mission.log_id.COP, xi.mission.id.cop.SHELTERING_DOUBT)
end

suite['Sheltering Doubt'] = function(world)
    local client, player = world:spawnPlayer()

    -- setup mission
    player:addMission(xi.mission.log_id.COP, xi.mission.id.cop.SHELTERING_DOUBT)

    client:gotoZone(xi.zone.Tavnazian_Safehold)
    world:tick()
    client:expectEvent({ event = 107 })

    client:gotoAndTriggerEntity("Justinius")
    client:expectEvent({ event = 129 })

    client:gotoAndTriggerEntity("Despachiaire")
    client:expectEvent({ event = 108 })

    client:gotoAndTriggerEntity("Justinius")
    client:expectEvent({ event = 109 })

    client:gotoZone(xi.zone.Misareaux_Coast)
    client:gotoAndTriggerEntity("_0p0")
    client:expectEvent({ event = 7 })

    assertOnMission(player, xi.mission.log_id.COP, xi.mission.id.cop.THE_SAVAGE)
end

suite['The Savage'] = function(world)
    local client, player = world:spawnPlayer()
    local ID = zones[xi.zone.Monarch_Linn]

    -- setup mission
    player:addMission(xi.mission.log_id.COP, xi.mission.id.cop.THE_SAVAGE)

    client:gotoZone(xi.zone.Misareaux_Coast)
    client:gotoAndTriggerEntity("_0p2", { eventId = 8, finishOption = 1 })

    client:gotoZone(xi.zone.RiverneSite_B01)

    client:gotoZone(xi.zone.Monarch_Linn)
    client:enterBcnmViaNpc(ID.npc.BCNM_ENTRY, xi.bcnm.SAVAGE)
    client:killBattlefieldMobs()
    client:expectBcnmWin({ finishOption = 2 })

    client:gotoZone(xi.zone.Tavnazian_Safehold)
    client:gotoAndTriggerEntity("Justinius", { eventId = 110 })

    assertOnMission(player, xi.mission.log_id.COP, xi.mission.id.cop.THE_SECRETS_OF_WORSHIP)
end

suite['The Secrets of Worship'] = function(world)
    local client, player = world:spawnPlayer()
    local ID = zones[xi.zone.Sacrarium]

    -- setup mission
    player:addMission(xi.mission.log_id.COP, xi.mission.id.cop.THE_SECRETS_OF_WORSHIP)

    client:gotoZone(xi.zone.Tavnazian_Safehold)
    client:gotoAndTriggerEntity("_0qa", { eventId = 111 })

    client:gotoZone(xi.zone.Misareaux_Coast)
    client:gotoAndTriggerEntity("_0p8", { eventId = 9, finishOption = 1 })

    client:gotoZone(xi.zone.Sacrarium)
    client:gotoAndTriggerEntity("_0s8", { eventId = 6 })
    SetServerVariable("Old_Prof_Spawn_Location", 3)

    client:gotoAndTriggerEntity("qm3")
    world:tick()
    local professor = client:getEntity(ID.mob.OLD_PROFESSOR_MARISELLE)
    assert(professor:isSpawned())

    client:claimAndKillMob(professor)
    world:tick()
    client:gotoAndTriggerEntity("qm3")
    assertKeyItem(player, xi.ki.RELIQUIARIUM_KEY, true)

    client:gotoAndTriggerEntity("_0s8", { eventId = 5 })

    assertOnMission(player, xi.mission.log_id.COP, xi.mission.id.cop.SLANDEROUS_UTTERINGS)
end

suite['Slanderous Utterings'] = function(world)
    local client, player = world:spawnPlayer()

    -- setup mission
    player:addMission(xi.mission.log_id.COP, xi.mission.id.cop.SLANDEROUS_UTTERINGS)

    client:gotoZone(xi.zone.Tavnazian_Safehold, { x = 106, y = -40, z = -80 })
    world:skipTime(1)
    world:tick()
    client:expectEvent({ eventId = 112 })

    client:gotoZone(xi.zone.Sealions_Den)
    client:gotoAndTriggerEntity("_0w0", { eventId = 13 })

    assertOnMission(player, xi.mission.log_id.COP, xi.mission.id.cop.THE_ENDURING_TUMULT_OF_WAR)
end

suite['The Enduring Tumult of War'] = function(world)
    local client, player = world:spawnPlayer()
    local ID = zones[xi.zone.PsoXja]

    -- setup mission
    player:addMission(xi.mission.log_id.COP, xi.mission.id.cop.THE_ENDURING_TUMULT_OF_WAR)

    client:gotoZone(xi.zone.Port_Bastok)
    world:skipTime(1)
    world:tick()
    client:expectEvent({ eventId = 306 })

    client:gotoZone(xi.zone.Metalworks)
    client:gotoAndTriggerEntity('Cid', { eventId = 849 })
    client:gotoAndTriggerEntity('Cid', { eventId = 863 })

    client:gotoZone(xi.zone.PsoXja, { x = -300, y = 0, z = 0 })
    world:skipTime(1)
    world:tick()
    client:expectEvent({ eventId = 1 })

    client:gotoAndTriggerEntity('_i98')
    local golem = client:getEntity(ID.mob.NUNYUNUWI)
    assert(golem:isSpawned())

    client:claimAndKillMob(golem)

    client:gotoAndTriggerEntity('_i99', { eventId = 2 })

    assertOnMission(player, xi.mission.log_id.COP, xi.mission.id.cop.DESIRES_OF_EMPTINESS)
    assertKeyItem(player, xi.ki.LIGHT_OF_VAHZL, true)

    client:expectEvent({ eventId = 50 })
end

suite['Desires of Emptiness'] = function(world)
    local client, player = world:spawnPlayer()
    local ID = zones[xi.zone.PromyvionVahzl]

    -- setup mission
    player:addMission(xi.mission.log_id.COP, xi.mission.id.cop.DESIRES_OF_EMPTINESS)

    client:gotoZone(xi.zone.PromyvionVahzl)
    world:skipTime(1)
    world:tick()
    client:expectEvent({ eventId = 50 })

    client:gotoAndTriggerEntity('_0mc')
    local Propagator = client:getEntity(ID.mob.PROPAGATOR)
    assert(Propagator:isSpawned())
    client:claimAndKillMob(Propagator)
    client:gotoAndTriggerEntity('_0mc', { eventId = 51 })

    client:gotoAndTriggerEntity('_0md')
    local Policitor = client:getEntity(ID.mob.SOLICITOR)
    assert(Policitor:isSpawned())
    client:claimAndKillMob(Policitor)
    client:gotoAndTriggerEntity('_0md', { eventId = 52 })

    client:gotoAndTriggerEntity('_0m0')
    local Ponderer = client:getEntity(ID.mob.PONDERER)
    assert(Ponderer:isSpawned())
    client:claimAndKillMob(Ponderer)
    client:gotoAndTriggerEntity('_0m0', { eventId = 53 })

    client:gotoZone(xi.zone.Spire_of_Vahzl)
    world:tick()
    client:expectEvent({ eventId = 20 })

    client:enterBcnmViaNpc("_0n0", xi.bcnm.DESIRES_OF_EMPTINESS)
    client:killBattlefieldMobs()
    world:skipTime(15)
    world:tick()
    client:expectBcnmWin({ finishOption = 2 })
    -- player is sent to Beaucedine Glacier at end of event
    world:skipTime(1)
    world:tick()
    client:expectEvent({ eventId = 206 })

    client:gotoZone(xi.zone.Metalworks)
    client:gotoAndTriggerEntity("Cid", { eventId = 850 })

    assertOnMission(player, xi.mission.log_id.COP, xi.mission.id.cop.THREE_PATHS)
end

suite['Three Paths'] = function(world)
    local client, player = world:spawnPlayer()
    local upperID = zones[xi.zone.Lower_Delkfutts_Tower]
    local bearclawID = zones[xi.zone.Bearclaw_Pinnacle]

    -- setup mission
    player:addMission(xi.mission.log_id.COP, xi.mission.id.cop.THREE_PATHS)

    -- Louverance's Path
    client:gotoZone(xi.zone.Tavnazian_Safehold)
    client:gotoAndTriggerEntity('Despachiaire', { eventId = 118 })

    client:gotoZone(xi.zone.Windurst_Woods)
    client:gotoAndTriggerEntity('Perih_Vashai', { eventId = 686 })

    client:gotoZone(xi.zone.Bibiki_Bay)
    client:gotoAndTriggerEntity('Warmachine', { eventId = 33 })

    client:gotoZone(xi.zone.Windurst_Walls)
    client:gotoAndTriggerEntity('Yoran-Oran', { eventId = 481 })

    client:gotoZone(xi.zone.Oldton_Movalpolos)
    world:tick()
    client:expectEvent({ eventId = 1 })

    client:gotoZone(xi.zone.Mine_Shaft_2716)
    client:enterBcnmViaNpc("_0d0", xi.bcnm.CENTURY_OF_HARDSHIP)
    client:killBattlefieldMobs()
    client:expectBcnmWin({ finishOption = 2 })

    client:gotoZone(xi.zone.Metalworks)
    client:gotoAndTriggerEntity('Cid', { eventId = 852 })

    client:gotoZone(xi.zone.Oldton_Movalpolos)
    client:gotoAndTriggerEntity('Tarnotik', { eventId = 34 })

    player:addItem(xi.items.GOLD_KEY)
    client:gotoZone(xi.zone.Mine_Shaft_2716)
    client:tradeNpc('_0d0', { xi.items.GOLD_KEY }, { eventId = 3 })

    client:gotoZone(xi.zone.Metalworks)
    client:gotoAndTriggerEntity('Cid', { eventId = 853 })

    -- Tenzen's Path
    client:gotoZone(xi.zone.La_Theine_Plateau)
    client:gotoAndTriggerEntity('qm3', { eventId = 203 })

    client:gotoZone(xi.zone.PsoXja)
    client:gotoAndTriggerEntity('_09g', { eventId = 3 })

    client:gotoZone(xi.zone.Upper_Jeuno)
    client:gotoAndTriggerEntity('Monberaux', { eventId = 74 })

    client:gotoZone(xi.zone.RuLude_Gardens)
    client:gotoAndTriggerEntity('Pherimociel', { eventId = 58 })

    client:gotoZone(xi.zone.Upper_Jeuno)
    client:gotoAndTriggerEntity('Monberaux', { eventId = 6 })

    client:gotoZone(xi.zone.Batallia_Downs)
    client:gotoAndTriggerEntity('qm4', { eventId = 0 })
    client:gotoAndTriggerEntity('qm4')
    assertKeyItem(player, xi.ki.DELKFUTT_RECOGNITION_DEVICE, true)

    client:gotoZone(xi.zone.Lower_Delkfutts_Tower)
    client:gotoAndTriggerEntity('_545')
    local idol = client:getEntity(upperID.mob.DISASTER_IDOL)
    assert(idol:isSpawned())
    client:claimAndKillMob(idol)
    world:tick()
    client:gotoAndTriggerEntity('_545', { eventId = 25 })
    assertKeyItem(player, xi.ki.DELKFUTT_RECOGNITION_DEVICE, false)

    client:gotoZone(xi.zone.PsoXja, { x = 220, y = -8, z = -282 })
    world:tick()
    client:expectEvent({ eventId = 4 })

    client:gotoAndTriggerEntity('_09h', { eventId = 5 })

    client:gotoZone(xi.zone.Metalworks)
    client:gotoAndTriggerEntity('Cid', { eventId = 854 })

    -- Ulmia's Path
    client:gotoZone(xi.zone.Southern_San_dOria)
    client:gotoAndTriggerEntity('Hinaree', { eventId = 22 })

    client:gotoZone(xi.zone.Port_San_dOria)
    world:tick()
    client:expectEvent({ eventId = 4 })

    client:gotoZone(xi.zone.Northern_San_dOria)
    client:gotoAndTriggerEntity('Chasalvige', { eventId = 762 })

    client:gotoZone(xi.zone.Windurst_Waters)
    client:gotoAndTriggerEntity('Kerutoto', { eventId = 876 })

    client:gotoZone(xi.zone.Windurst_Walls)
    client:gotoAndTriggerEntity('Yoran-Oran', { eventId = 473 })

    client:gotoZone(xi.zone.Boneyard_Gully)
    client:enterBcnmViaNpc('_081', xi.bcnm.HEAD_WIND)
    client:killBattlefieldMobs()
    client:expectBcnmWin({ finishOption = 2 })

    client:gotoZone(xi.zone.Bearclaw_Pinnacle)
    client:enterBcnmViaNpc(bearclawID.npc.PILLAR_1, xi.bcnm.FLAMES_FOR_THE_DEAD)
    client:killBattlefieldMobs()
    client:expectBcnmWin({ finishOption = 2 })

    client:gotoZone(xi.zone.Metalworks)
    client:gotoAndTriggerEntity('Cid', { eventId = 855 })

    assertOnMission(player, xi.mission.log_id.COP, xi.mission.id.cop.FOR_WHOM_THE_VERSE_IS_SUNG)
end

suite['For Whom the Verse is Sung'] = function(world)
    local client, player = world:spawnPlayer()

    -- setup mission
    player:addMission(xi.mission.log_id.COP, xi.mission.id.cop.FOR_WHOM_THE_VERSE_IS_SUNG)

    client:gotoZone(xi.zone.RuLude_Gardens)
    client:gotoAndTriggerEntity('Pherimociel', { eventId = 10046 })

    client:gotoZone(xi.zone.Upper_Jeuno)
    client:gotoAndTriggerEntity('_6s1', { eventId = 10011 })

    client:gotoZone(xi.zone.RuLude_Gardens)
    world:tick()
    client:expectEvent({ eventId = 10047 })

    assertOnMission(player, xi.mission.log_id.COP, xi.mission.id.cop.A_PLACE_TO_RETURN)
end

suite['A Place to Return'] = function(world)
    local client, player = world:spawnPlayer()
    local ID = zones[xi.zone.Misareaux_Coast]
    local mob1 = client:getEntity(ID.mob.PM6_2_MOB_OFFSET)
    local mob2 = client:getEntity(ID.mob.PM6_2_MOB_OFFSET + 1)
    local mob3 = client:getEntity(ID.mob.PM6_2_MOB_OFFSET + 2)

    -- setup mission
    player:addMission(xi.mission.log_id.COP, xi.mission.id.cop.A_PLACE_TO_RETURN)

    client:gotoZone(xi.zone.RuLude_Gardens, { x = 0, y = 0, z = 45 })
    world:tick()
    world:skipTime(2)
    client:expectEvent({ eventId = 10048 })

    client:gotoZone(xi.zone.Misareaux_Coast)
    client:gotoAndTriggerEntity('_0p0')
    assert(mob1:isSpawned())
    client:claimAndKillMob(mob1)
    assert(mob2:isSpawned())
    client:claimAndKillMob(mob2)
    assert(mob3:isSpawned())
    client:claimAndKillMob(mob3)
    world:tick()

    client:gotoAndTriggerEntity('_0p0', { eventId = 10 })

    assertOnMission(player, xi.mission.log_id.COP, xi.mission.id.cop.MORE_QUESTIONS_THAN_ANSWERS)
end

suite['More Questions Than Answers'] = function(world)
    local client, player = world:spawnPlayer()

    -- setup mission
    player:addMission(xi.mission.log_id.COP, xi.mission.id.cop.MORE_QUESTIONS_THAN_ANSWERS)

    client:gotoZone(xi.zone.RuLude_Gardens)
    client:gotoAndTriggerEntity('Pherimociel', { eventId = 10049 })

    client:gotoAndTriggerEntity('_6r9', { eventId = 10050 })

    client:gotoZone(xi.zone.Selbina)
    client:gotoAndTriggerEntity('Mathilde', { eventId = 10005 })

    assertOnMission(player, xi.mission.log_id.COP, xi.mission.id.cop.ONE_TO_BE_FEARED)
end

suite['One to be Feared'] = function(world)
    local client, player = world:spawnPlayer()

    -- setup mission
    player:addMission(xi.mission.log_id.COP, xi.mission.id.cop.ONE_TO_BE_FEARED)

    client:gotoZone(xi.zone.Selbina)
    client:gotoAndTriggerEntity('Mathilde', { eventId = 173 })
    client:gotoAndTriggerEntity('Mathilde', { eventId = 174 })

    client:gotoZone(xi.zone.Metalworks)
    client:gotoAndTriggerEntity('Cid', { eventId = 856 })

    client:gotoZone(xi.zone.Sealions_Den)
    client:expectEvent({ eventId = 15 })

    client:gotoAndTriggerEntity('_0w0', { eventId = 31 })

    client:enterBcnmViaNpc('_0w0', xi.bcnm.ONE_TO_BE_FEARED)
    client:gotoAndTriggerEntity('Airship_Door', { eventId = 32003, finishOption = 100 })
    client:expectEvent({ eventId = 0 })

    client:killBattlefieldMobs() -- Kill mammets
    client:expectEvent({ eventId = 10 }) -- Move outside battlfield

    -- Click door to enter next phase
    client:gotoAndTriggerEntity('Airship_Door', { eventId = 32003, finishOption = 100 })
    client:expectEvent({ eventId = 1 })
    client:killBattlefieldMobs() -- Kill Omega
    client:expectEvent({ eventId = 11 }) -- Move outside battlfield again

    -- Click door to enter next phase
    client:gotoAndTriggerEntity('Airship_Door', { eventId = 32003, finishOption = 100 })
    client:expectEvent({ eventId = 2 })

    client:killBattlefieldMobs() -- Kill Ultima
    client:expectBcnmWin({ finishOption = 2 })

    client:expectEvent({ eventId = 33 })

    assertInZone(player, xi.zone.Lufaise_Meadows)
    client:expectEvent({ eventId = 111 })

    assertOnMission(player, xi.mission.log_id.COP, xi.mission.id.cop.CHAINS_AND_BONDS)
end

suite['Chains and Bonds'] = function(world)
    local client, player = world:spawnPlayer()

    -- setup mission
    player:addMission(xi.mission.log_id.COP, xi.mission.id.cop.CHAINS_AND_BONDS)

    client:gotoZone(xi.zone.Lufaise_Meadows)
    world:tick()
    client:expectEvent({ eventId = 111 })

    client:gotoZone(xi.zone.Tavnazian_Safehold)
    world:tick()
    world:skipTime(2)
    client:expectEvent({ eventId = 114 })
    client:gotoAndTriggerEntity('_0q1', { eventId = 116 })

    client:gotoZone(xi.zone.Sealions_Den)
    world:tick()
    client:expectEvent({ eventId = 14 })

    client:gotoZone(xi.zone.Tavnazian_Safehold)
    client:gotoAndTriggerEntity('_0qa', { eventId = 115 })

    assertOnMission(player, xi.mission.log_id.COP, xi.mission.id.cop.FLAMES_IN_THE_DARKNESS)
end

suite['Flames in the Darkness'] = function(world)
    local client, player = world:spawnPlayer()

    -- setup mission
    player:addMission(xi.mission.log_id.COP, xi.mission.id.cop.FLAMES_IN_THE_DARKNESS)

    client:gotoZone(xi.zone.Misareaux_Coast)
    client:gotoAndTriggerEntity('_0p2', { eventId = 12 })

    client:gotoZone(xi.zone.Sealions_Den)
    client:gotoAndTriggerEntity('Sueleen', { eventId = 16 })

    client:gotoZone(xi.zone.RuLude_Gardens, { x= 0, y = 0, z = 45 })
    world:skipTime(1)
    world:tick()
    client:expectEvent({ eventId = 10051 })

    client:gotoZone(xi.zone.Upper_Jeuno)
    client:gotoAndTriggerEntity('_6s1', { eventId = 10012 })

    assertOnMission(player, xi.mission.log_id.COP, xi.mission.id.cop.FIRE_IN_THE_EYES_OF_MEN)
end

suite['Fire in the Eyes of Men'] = function(world)
    local client, player = world:spawnPlayer()

    -- setup mission
    player:addMission(xi.mission.log_id.COP, xi.mission.id.cop.FIRE_IN_THE_EYES_OF_MEN)

    client:gotoZone(xi.zone.Mine_Shaft_2716)
    client:gotoAndTriggerEntity('_0d0', { eventId = 4 })

    client:gotoZone(xi.zone.Metalworks)
    client:gotoAndTriggerEntity('Cid', { eventId = 857 })

    world:skipTime(86405)
    world:tick()

    client:gotoAndTriggerEntity('Cid', { eventId = 890 })

    assertOnMission(player, xi.mission.log_id.COP, xi.mission.id.cop.CALM_BEFORE_THE_STORM)
end

suite['Calm Before the Storm'] = function(world)
    local client, player = world:spawnPlayer()
    local coastID   = zones[xi.zone.Misareaux_Coast]
    local landingID = zones[xi.zone.Carpenters_Landing]
    local bayID     = zones[xi.zone.Bibiki_Bay]

    local Boggelmann = client:getEntity(coastID.mob.BOGGELMANN)
    local Crypton = client:getEntity(landingID.mob.CRYPTONBERRY_EXECUTOR)
    local Crypton1 = client:getEntity(landingID.mob.CRYPTONBERRY_EXECUTOR +1)
    local Crypton2 = client:getEntity(landingID.mob.CRYPTONBERRY_EXECUTOR +2)
    local Crypton3 = client:getEntity(landingID.mob.CRYPTONBERRY_EXECUTOR +3)
    local Dalham = client:getEntity(bayID.mob.DALHAM)

    -- setup mission
    player:addMission(xi.mission.log_id.COP, xi.mission.id.cop.CALM_BEFORE_THE_STORM)

    client:gotoZone(xi.zone.Misareaux_Coast)
    client:gotoAndTriggerEntity('_0p4')
    assert(Boggelmann:isSpawned())
    client:claimAndKillMob(Boggelmann)
    client:gotoAndTriggerEntity('_0p4', { eventId = 13 })
    assertKeyItem(player, xi.ki.VESSEL_OF_LIGHT_KI, true)

    client:gotoZone(xi.zone.Carpenters_Landing)
    client:gotoAndTriggerEntity('qm8')
    assert(Crypton:isSpawned())
    client:claimAndKillMob(Crypton)
    player:setVar('Cryptonberry_Assassins-1_KILL', 1)
    player:setVar('Cryptonberry_Assassins-2_KILL', 1)
    player:setVar('Cryptonberry_Assassins-3_KILL', 1)
    client:gotoAndTriggerEntity('qm8', { eventId = 37 })

    client:gotoZone(xi.zone.Bibiki_Bay)
    client:gotoAndTriggerEntity('qm4')
    assert(Dalham:isSpawned())
    client:claimAndKillMob(Dalham)
    client:gotoAndTriggerEntity('qm4', { eventId = 41 })

    client:gotoZone(xi.zone.Metalworks)
    client:gotoAndTriggerEntity('Cid', { eventId = 891 })
    client:gotoAndTriggerEntity('Cid', { eventId = 892 })
    assertKeyItem(player, xi.ki.LETTERS_FROM_ULMIA_AND_PRISHE, true)

    client:gotoZone(xi.zone.Sealions_Den)
    client:gotoAndTriggerEntity('Sueleen', { eventId = 17 })

    assertOnMission(player, xi.mission.log_id.COP, xi.mission.id.cop.THE_WARRIOR_S_PATH)
end

suite['The Warriors Path'] = function(world)
    local client, player = world:spawnPlayer()

    -- setup mission
    player:addMission(xi.mission.log_id.COP, xi.mission.id.cop.THE_WARRIOR_S_PATH)

    client:gotoZone(xi.zone.Sealions_Den)
    client:gotoAndTriggerEntity("_0w0", { eventId = 32 })

    client:enterBcnmViaNpc('_0w0', xi.bcnm.WARRIORS_PATH)
    client:killBattlefieldMobs()
    client:expectBcnmWin({ finishOption = 2 })

    assertOnMission(player, xi.mission.log_id.COP, xi.mission.id.cop.GARDEN_OF_ANTIQUITY)
end

suite['Garden of Antiquity'] = function(world)
    local client, player = world:spawnPlayer()
    local ID = zones[xi.zone.AlTaieu]

    -- setup mission
    player:addMission(xi.mission.log_id.COP, xi.mission.id.cop.GARDEN_OF_ANTIQUITY)

    client:gotoZone(xi.zone.AlTaieu)
    world:tick()
    client:expectEvent({ eventId = 1 })
    client:gotoAndTriggerEntity("_0x0", { eventId = 164 })

    local southMob1 = client:getEntity(ID.mob.AERNS_TOWER_SOUTH)
    local southMob2 = client:getEntity(ID.mob.AERNS_TOWER_SOUTH +1)
    local southMob3 = client:getEntity(ID.mob.AERNS_TOWER_SOUTH +2)
    client:gotoAndTriggerEntity("_0x1")
    assert(southMob1:isSpawned())
    assert(southMob2:isSpawned())
    assert(southMob3:isSpawned())
    client:claimAndKillMob(southMob1)
    client:claimAndKillMob(southMob2)
    client:claimAndKillMob(southMob3)
    client:gotoAndTriggerEntity("_0x1", { eventId = 161 })

    local westMob1 = client:getEntity(ID.mob.AERNS_TOWER_WEST)
    local westMob2 = client:getEntity(ID.mob.AERNS_TOWER_WEST +1)
    local westMob3 = client:getEntity(ID.mob.AERNS_TOWER_WEST +2)
    client:gotoAndTriggerEntity("_0x2")
    assert(westMob1:isSpawned())
    assert(westMob2:isSpawned())
    assert(westMob3:isSpawned())
    client:claimAndKillMob(westMob1)
    client:claimAndKillMob(westMob2)
    client:claimAndKillMob(westMob3)
    client:gotoAndTriggerEntity("_0x2", { eventId = 162 })

    local eastMob1 = client:getEntity(ID.mob.AERNS_TOWER_EAST)
    local eastMob2 = client:getEntity(ID.mob.AERNS_TOWER_EAST +1)
    local eastMob3 = client:getEntity(ID.mob.AERNS_TOWER_EAST +2)
    client:gotoAndTriggerEntity("_0x3")
    assert(eastMob1:isSpawned())
    assert(eastMob2:isSpawned())
    assert(eastMob3:isSpawned())
    client:claimAndKillMob(eastMob1)
    client:claimAndKillMob(eastMob2)
    client:claimAndKillMob(eastMob3)
    client:gotoAndTriggerEntity("_0x3", { eventId = 163 })

    client:gotoAndTriggerEntity("_0x0", { eventId = 100 })

    client:gotoZone(xi.zone.Grand_Palace_of_HuXzoi)
    world:tick()
    client:gotoAndTriggerEntity("_iya", { eventId = 1 })

    assertOnMission(player, xi.mission.log_id.COP, xi.mission.id.cop.A_FATE_DECIDED)
end

suite['A Fate Decided'] = function(world)
    local client, player = world:spawnPlayer()
    local ID = zones[xi.zone.Grand_Palace_of_HuXzoi]

    -- setup mission
    player:addMission(xi.mission.log_id.COP, xi.mission.id.cop.A_FATE_DECIDED)

    client:gotoZone(xi.zone.Grand_Palace_of_HuXzoi)
    client:gotoAndTriggerEntity("_iyb", { eventId = 2 })

    client:gotoAndTriggerEntity("_iyq")
    local mob = client:getEntity(ID.mob.IXGHRAH)
    assert(mob:isSpawned())
    client:claimAndKillMob(mob)
    client:gotoAndTriggerEntity("_iyq", { eventId = 3 })

    assertOnMission(player, xi.mission.log_id.COP, xi.mission.id.cop.WHEN_ANGELS_FALL)
end

suite['When Angels Fall'] = function(world)
    local client, player = world:spawnPlayer()

    -- setup mission
    player:addMission(xi.mission.log_id.COP, xi.mission.id.cop.WHEN_ANGELS_FALL)
    player:addKeyItem(xi.ki.BRAND_OF_DAWN)
    player:addKeyItem(xi.ki.BRAND_OF_TWILIGHT)

    client:gotoZone(xi.zone.The_Garden_of_RuHmet)
    world:tick()
    client:expectEvent({ eventId = 201 })
    assertKeyItem(player, xi.ki.MYSTERIOUS_AMULET, true)

    client:gotoAndTriggerEntity("_iz2", { eventId = 202 })

    player:setVar('M[6][91]Prog', 3)

    client:gotoAndTriggerEntity("_0z0", { eventId = 203 })

    client:enterBcnmViaNpc('_0z0', xi.bcnm.WHEN_ANGELS_FALL)
    client:killBattlefieldMobs()
    client:expectBcnmWin({ finishOption = 2 })

    client:gotoAndTriggerEntity("_0zt", { eventId = 204 })

    assertOnMission(player, xi.mission.log_id.COP, xi.mission.id.cop.DAWN)
end

return suite
