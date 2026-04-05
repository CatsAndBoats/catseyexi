describe('Exdata', function()
    ---@type CClientEntityPair
    local player

    before_each(function()
        player = xi.test.world:spawnPlayer(
            {
                zone = xi.zone.SOUTHERN_SAN_DORIA,
            })
    end)

    it('can get and set Legion Pass exdata', function()
        local item = player:addItem({ id = xi.item.LEGION_PASS, quantity = 1 })
        assert(item)

        local now = GetSystemTime()
        item:setExData(
            {
                timestamp = now + 300,
                title     = xi.legion.title.HALL_OF_AN_36,
                signature = player:getName(),
            })

        local ex = item:getExData()
        assert(ex.timestamp == now + 300)
        assert(ex.title == xi.legion.title.HALL_OF_AN_36)
        assert(ex.signature == player:getName())
    end)

    it('can get and set Perpetual Hourglass exdata', function()
        local item = player:addItem({ id = xi.item.PERPETUAL_HOURGLASS, quantity = 1 })
        assert(item)

        local now = GetSystemTime()
        item:setExData(
            {
                flags     = 0x01,
                startTime = now,
                endTime   = now + 1800,
                zoneId    = xi.zone.DYNAMIS_SAN_DORIA,
            })

        local ex = item:getExData()
        assert(ex.flags == 0x01)
        assert(ex.startTime == now)
        assert(ex.endTime == now + 1800)
        assert(ex.zoneId == xi.zone.DYNAMIS_SAN_DORIA)
    end)

    it('preserves unchanged fields on write-back', function()
        local item = player:addItem({ id = xi.item.LEGION_PASS, quantity = 1 })
        assert(item)

        item:setExData(
            {
                timestamp = 1000,
                title     = xi.legion.title.HALL_OF_KI_18,
                signature = 'TestPlayer',
            })

        local ex = item:getExData()
        ex.title = xi.legion.title.HALL_OF_MURU_36
        item:setExData(ex)

        local ex2 = item:getExData()
        assert(ex2.timestamp == 1000)
        assert(ex2.title == xi.legion.title.HALL_OF_MURU_36)
        assert(ex2.signature == 'TestPlayer')
    end)

    it('addItem accepts exdata table', function()
        local now = GetSystemTime()
        local item = player:addItem(
            {
                id       = xi.item.LEGION_PASS,
                quantity = 1,
                exdata   =
                {
                    timestamp = now + 300,
                    title     = xi.legion.title.HALL_OF_AN_36,
                    signature = 'AddItemTest',
                },
            })
        assert(item)

        local ex = item:getExData()
        assert(ex.timestamp == now + 300)
        assert(ex.title == xi.legion.title.HALL_OF_AN_36)
        assert(ex.signature == 'AddItemTest')
    end)

    it('addItem accepts raw exdata bytes', function()
        local item = player:addItem(
            {
                id       = xi.item.FIRE_CRYSTAL,
                quantity = 1,
                exdata   = { [0] = 0x42, [5] = 0xCD },
            })
        assert(item)

        local ex = item:getExDataRaw()
        assert(ex[0] == 0x42)
        assert(ex[5] == 0xCD)
    end)

    it('raw functions bypass typed dispatch', function()
        local item = player:addItem({ id = xi.item.LEGION_PASS, quantity = 1 })
        assert(item)

        item:setExDataRaw({ [0] = 0xF4, [1] = 0x01 })

        local ex = item:getExData()
        assert(ex.timestamp == 500)
    end)

    it('can get and set Betting Slip exdata', function()
        local item = player:addItem({ id = xi.item.CHOCOBET_TICKET, quantity = 1 })
        assert(item)

        item:setExData(
            {
                raceId       = 12345,
                raceGrade    = xi.chocoboRacing.raceGrade.C1,
                racePairingL = 3,
                racePairingR = 5,
                quills       = 500,
            })

        local ex = item:getExData()
        assert(ex.raceId == 12345)
        assert(ex.raceGrade == xi.chocoboRacing.raceGrade.C1)
        assert(ex.racePairingL == 3)
        assert(ex.racePairingR == 5)
        assert(ex.quills == 500)
    end)

    it('can get and set Race Certificate exdata', function()
        local item = player:addItem({ id = xi.item.RACE_COMPLETION_CERTIFICATE, quantity = 1 })
        assert(item)

        item:setExData(
            {
                raceId    = 99999,
                raceGrade = xi.chocoboRacing.raceGrade.C3,
            })

        local ex = item:getExData()
        assert(ex.raceId == 99999)
        assert(ex.raceGrade == xi.chocoboRacing.raceGrade.C3)
    end)

    it('can get and set Assault Log exdata', function()
        local item = player:addItem({ id = xi.item.LEUJAOAM_OBSERVATION_LOG, quantity = 1 })
        assert(item)

        item:setExData(
            {
                flags =
                {
                    [1]  = true,
                    [2]  = false,
                    [3]  = true,
                    [4]  = false,
                    [5]  = true,
                    [6]  = false,
                    [7]  = true,
                    [8]  = false,
                    [9]  = true,
                    [10] = false,
                },
            })

        local ex = item:getExData()
        assert(ex.flags[1] == true)
        assert(ex.flags[2] == false)
        assert(ex.flags[3] == true)
        assert(ex.flags[7] == true)
        assert(ex.flags[10] == false)
    end)

    it('can get and set Brenner Book exdata', function()
        local item = player:addItem({ id = xi.item.COPY_OF_THE_BRENNER_BLUEBOOK, quantity = 1 })
        assert(item)

        item:setExData(
            {
                timeValue = 1000000,
                level     = xi.brenner.levelCap.LV50,
            })

        local ex = item:getExData()
        assert(ex.timeValue == 1000000)
        assert(ex.level == xi.brenner.levelCap.LV50)
    end)

    it('can get and set Meeble Grimoire exdata', function()
        local item = player:addItem({ id = xi.item.DILIGENCE_GRIMOIRE, quantity = 1 })
        assert(item)

        item:setExData(
            {
                clears =
                {
                    [xi.meeble.expeditionType.ADJUNCT]        = { [1] = 3, [2] = 2, [3] = 1, [4] = 0 },
                    [xi.meeble.expeditionType.ASSISTANT]      = { [1] = 1, [2] = 0, [3] = 0, [4] = 0 },
                    [xi.meeble.expeditionType.INSTRUCTOR]     = { [1] = 0, [2] = 0, [3] = 0, [4] = 0 },
                    [xi.meeble.expeditionType.ASC_RESEARCHER] = { [1] = 0, [2] = 0, [3] = 0, [4] = 0 },
                    [xi.meeble.expeditionType.RESEARCHER]     = { [1] = 0, [2] = 0, [3] = 0, [4] = 0 },
                },
                count  = 5,
                zone   = xi.meeble.zone.SAUROMUGUE_CHAMPAIGN,
            })

        local ex = item:getExData()
        assert(ex.clears[xi.meeble.expeditionType.ADJUNCT][1] == 3)
        assert(ex.clears[xi.meeble.expeditionType.ADJUNCT][2] == 2)
        assert(ex.clears[xi.meeble.expeditionType.ADJUNCT][3] == 1)
        assert(ex.clears[xi.meeble.expeditionType.ADJUNCT][4] == 0)
        assert(ex.clears[xi.meeble.expeditionType.ASSISTANT][1] == 1)
        assert(ex.count == 5)
        assert(ex.zone == xi.meeble.zone.SAUROMUGUE_CHAMPAIGN)
    end)

    it('can get and set Honeymoon Ticket exdata', function()
        local item = player:addItem({ id = xi.item.VCS_HONEYMOON_TICKET, quantity = 1 })
        assert(item)

        item:setExData(
            {
                plan = xi.chocoboRaising.honeymoonPlan.HIKING,
            })

        local ex = item:getExData()
        assert(ex.plan == xi.chocoboRaising.honeymoonPlan.HIKING)
    end)

    it('can get and set Lottery Ticket exdata', function()
        local item = player:addItem({ id = xi.item.BONANZA_PEARL, quantity = 1 })
        assert(item)

        item:setExData(
            {
                number = 123456,
                title  = xi.bonanza.eventId.TWENTY_FIRST_VANAVERSARY_NOMAD,
            })

        local ex = item:getExData()
        assert(ex.number == 123456)
        assert(ex.title == xi.bonanza.eventId.TWENTY_FIRST_VANAVERSARY_NOMAD)
    end)

    it('can get and set Tabula exdata', function()
        local item = player:addItem({ id = xi.item.MAZE_TABULA_M01, quantity = 1 })
        assert(item)

        item:setExData(
            {
                voucher = xi.maze.voucher.ACTUALIZATION_TEAM,
                runes   =
                {
                    { id = xi.maze.rune.AQUAN,  rotation = 2, position = 0 },
                    { id = xi.maze.rune.DRAGON, rotation = 1, position = 13 },
                },
                uses    = 10,
            })

        local ex = item:getExData()
        assert(ex.voucher == xi.maze.voucher.ACTUALIZATION_TEAM)
        assert(#ex.runes == 2)
        assert(ex.runes[1].id == xi.maze.rune.AQUAN)
        assert(ex.runes[1].rotation == 2)
        assert(ex.runes[1].position == 0)
        assert(ex.runes[2].id == xi.maze.rune.DRAGON)
        assert(ex.runes[2].rotation == 1)
        assert(ex.runes[2].position == 13)
        assert(ex.uses == 10)
    end)

    it('can get and set Evolith exdata', function()
        local item = player:addItem({ id = xi.item.EVOLITH, quantity = 1 })
        assert(item)

        item:setExData(
            {
                augment   = 120,
                shape     = xi.evolith.shape.DOWN_FILLED,
                element   = xi.evolith.element.FIRE,
                bonus     = 3,
                signature = 'TestCrafter',
            })

        local ex = item:getExData()
        assert(ex.augment == 120)
        assert(ex.shape == xi.evolith.shape.DOWN_FILLED)
        assert(ex.element == xi.evolith.element.FIRE)
        assert(ex.bonus == 3)
        assert(ex.signature == 'TestCrafter')
    end)

    it('can get and set Crafting Set exdata', function()
        local item = player:addItem({ id = xi.item.WOODWORKING_SET_25, quantity = 1 })
        assert(item)

        item:setExData(
            {
                quality   = 100,
                signature = 'Test',
            })

        local ex = item:getExData()
        assert(ex.quality == 100)
        assert(ex.signature == 'Test')
    end)

    it('can get and set Glowing Lamp exdata', function()
        local item = player:addItem({ id = xi.item.GLOWING_LAMP, quantity = 1 })
        assert(item)

        local now = GetSystemTime()
        item:setExData(
            {
                chamberId = xi.einherjar.chamber.SCHWERTLEITE,
                flags     = 3,
                startTime = now,
                endTime   = now + 1800,
            })

        local ex = item:getExData()
        assert(ex.chamberId == xi.einherjar.chamber.SCHWERTLEITE)
        assert(ex.flags == 3)
        assert(ex.startTime == now)
        assert(ex.endTime == now + 1800)
    end)

    it('can get and set Chocobo Egg exdata', function()
        local item = player:addItem({ id = xi.item.CHOCOBO_EGG_FAINTLY_WARM, quantity = 1 })
        assert(item)

        item:setExData(
            {
                dna     = { 3, 5, 7 },
                ability = xi.chocoboRaising.ability.TREASURE_FINDER,
                plan    = xi.chocoboRaising.honeymoonPlan.SPORTS,
                isBred  = true,
            })

        local ex = item:getExData()
        assert(ex.dna[1] == 3)
        assert(ex.dna[2] == 5)
        assert(ex.dna[3] == 7)
        assert(ex.ability == xi.chocoboRaising.ability.TREASURE_FINDER)
        assert(ex.plan == xi.chocoboRaising.honeymoonPlan.SPORTS)
        assert(ex.isBred == true)
    end)

    it('can get and set Chocobo Card exdata', function()
        local item = player:addItem({ id = xi.item.VCS_REGISTRATION_FORM, quantity = 1 })
        assert(item)

        item:setExData(
            {
                strength    = { trait = true, rp = 8, rank = xi.chocoboRaising.statRank.IMPRESSIVE },
                endurance   = { trait = false, rp = 4, rank = xi.chocoboRaising.statRank.AVERAGE },
                discernment = { trait = true, rp = 12, rank = xi.chocoboRaising.statRank.OUTSTANDING },
                receptivity = { rp = 20, rank = xi.chocoboRaising.statRank.FIRST_CLASS },
                dna         = { 2, 4, 6 },
                abilities   = { xi.chocoboRaising.ability.GALLOP, xi.chocoboRaising.ability.CANTER },
                temperament = xi.chocoboRaising.temperament.ENIGMATIC,
                weather     = xi.chocoboRaising.weather.CLOUDY,
                gender      = xi.chocoboRaising.gender.FEMALE,
                color       = xi.chocoboRaising.color.RED,
                size        = xi.chocoboRacing.jockeySize.HUME_F,
                name        = 'ChocoTest',
            })

        local ex = item:getExData()
        assert(ex.strength.trait == true)
        assert(ex.strength.rp == 8)
        assert(ex.strength.rank == xi.chocoboRaising.statRank.IMPRESSIVE)
        assert(ex.endurance.trait == false)
        assert(ex.endurance.rp == 4)
        assert(ex.endurance.rank == xi.chocoboRaising.statRank.AVERAGE)
        assert(ex.discernment.trait == true)
        assert(ex.discernment.rp == 12)
        assert(ex.discernment.rank == xi.chocoboRaising.statRank.OUTSTANDING)
        assert(ex.receptivity.rp == 20)
        assert(ex.receptivity.rank == xi.chocoboRaising.statRank.FIRST_CLASS)
        assert(ex.dna[1] == 2)
        assert(ex.dna[2] == 4)
        assert(ex.dna[3] == 6)
        assert(ex.abilities[1] == xi.chocoboRaising.ability.GALLOP)
        assert(ex.abilities[2] == xi.chocoboRaising.ability.CANTER)
        assert(ex.temperament == xi.chocoboRaising.temperament.ENIGMATIC)
        assert(ex.weather == xi.chocoboRaising.weather.CLOUDY)
        assert(ex.gender == xi.chocoboRaising.gender.FEMALE)
        assert(ex.color == xi.chocoboRaising.color.RED)
        assert(ex.size == xi.chocoboRacing.jockeySize.HUME_F)
        assert(ex.name == 'ChocoTest')
    end)

    it('can get and set Fish exdata', function()
        local item = player:addItem({ id = xi.item.LIK, quantity = 1 })
        assert(item)

        item:setExData(
            {
                size     = 300,
                weight   = 1500,
                isRanked = true,
            })

        local ex = item:getExData()
        assert(ex.size == 300)
        assert(ex.weight == 1500)
        assert(ex.isRanked == true)
    end)

    it('can get and set Escutcheon exdata', function()
        local item = player:addItem({ id = xi.item.JOINERS_ASPIS, quantity = 1 })
        assert(item)

        item:setExData(
            {
                status             = 1,
                bonusObjective     = xi.escutcheon.bonusObjective.CRAFT_DAYTIME,
                craftsmanship      = 2500,
                stage              = xi.escutcheon.stage.ASPIS,
                successDownPenalty = 0,
                signature          = 'TestCrafter',
            })

        local ex = item:getExData()
        assert(ex.status == 1)
        assert(ex.bonusObjective == xi.escutcheon.bonusObjective.CRAFT_DAYTIME)
        assert(ex.craftsmanship == 2500)
        assert(ex.stage == xi.escutcheon.stage.ASPIS)
        assert(ex.successDownPenalty == 0)
        assert(ex.signature == 'TestCrafter')
    end)

    it('can get and set Soul Plate exdata', function()
        local item = player:addItem({ id = xi.item.SOUL_PLATE, quantity = 1 })
        assert(item)

        item:setExData(
            {
                signature     = 'Goblin_Bounty_Hunter',
                zoneId        = xi.zone.QUFIM_ISLAND,
                superFamilyId = xi.mobSuperFamily.GOBLIN,
                poolId        = xi.mobPool.BUGBEAR_MATMAN,
                level         = 12,
                feralSkill    = xi.pankration.feralSkill.MAIN_JOB_WARRIOR,
                feralPoints   = 50,
                quality       = 42,
            })

        local ex = item:getExData()
        assert(ex.signature == 'GoblinBountyH')
        assert(ex.zoneId == xi.zone.QUFIM_ISLAND)
        assert(ex.superFamilyId == xi.mobSuperFamily.GOBLIN)
        assert(ex.poolId == xi.mobPool.BUGBEAR_MATMAN)
        assert(ex.level == 12)
        assert(ex.feralSkill == xi.pankration.feralSkill.MAIN_JOB_WARRIOR)
        assert(ex.feralPoints == 50)
        assert(ex.quality == 42)
    end)

    it('soul plate signature encodes and truncates correctly', function()
        local item = player:addItem({ id = xi.item.SOUL_PLATE, quantity = 1 })
        assert(item)

        -- Goblin_Bounty_Hunter -> Goblin_Bounty_H -> GoblinBountyH
        item:setExData({ signature = 'Goblin_Bounty_Hunter' })
        assert(item:getExData().signature == 'GoblinBountyH')

        -- Thunder_Elemental -> Thunder_Element -> ThunderElement
        item:setExData({ signature = 'Thunder_Elemental' })
        assert(item:getExData().signature == 'ThunderElement')

        item:setExData({ signature = 'Crab' })
        assert(item:getExData().signature == 'Crab')
    end)

    it('can get and set Soul Reflector exdata', function()
        local item = player:addItem({ id = xi.item.SOUL_REFLECTOR, quantity = 1 })
        assert(item)

        item:setExData(
            {
                nameFirst      = xi.pankration.firstName.BLOODY,
                nameLast       = xi.pankration.secondName.BEAST,
                poolId         = 200,
                exp            = 150,
                discipline     = 112,
                temperament    = 10,
                aggressiveness = 8,
                level          = 60,
                feralSkills    =
                {
                    { skillId = xi.pankration.feralSkill.MAIN_JOB_WARRIOR, level = 5 },
                    { skillId = xi.pankration.feralSkill.SUPPORT_JOB_MONK, level = 3 },
                },
            })

        local ex = item:getExData()
        assert(ex.nameFirst == xi.pankration.firstName.BLOODY)
        assert(ex.nameLast == xi.pankration.secondName.BEAST)
        assert(ex.poolId == 200)
        assert(ex.exp == 150)
        assert(ex.discipline == 112)
        assert(ex.temperament == 10)
        assert(ex.aggressiveness == 8)
        assert(ex.level == 60)
        assert(#ex.feralSkills == 7)
        assert(ex.feralSkills[1].skillId == xi.pankration.feralSkill.MAIN_JOB_WARRIOR)
        assert(ex.feralSkills[1].level == 5)
        assert(ex.feralSkills[2].skillId == xi.pankration.feralSkill.SUPPORT_JOB_MONK)
        assert(ex.feralSkills[2].level == 3)
    end)

    it('unhandled items fall back to raw bytes', function()
        local item = player:addItem({ id = xi.item.FIRE_CRYSTAL, quantity = 1 })
        assert(item)

        item:setExDataRaw({ [0] = 0xAB, [5] = 0xCD })

        local ex = item:getExData()
        assert(ex[0] == 0xAB)
        assert(ex[5] == 0xCD)
    end)
end)
