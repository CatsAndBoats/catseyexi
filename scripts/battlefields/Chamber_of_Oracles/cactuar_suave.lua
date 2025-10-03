-----------------------------------
-- Cactuar Suave
-- Chamber of Oracles KSNM30, Clotho Orb
-- !additem 1175
-----------------------------------
local chamberOfOraclesID = zones[xi.zone.CHAMBER_OF_ORACLES]
-----------------------------------

local content = Battlefield:new({
    zoneId           = xi.zone.CHAMBER_OF_ORACLES,
    battlefieldId    = xi.battlefield.id.CACTUAR_SUAVE,
    maxPlayers       = 6,
    timeLimit        = utils.minutes(30),
    index            = 5,
    entryNpc         = 'SC_Entrance',
    exitNpc          = 'Shimmering_Circle',
    requiredItems    = { xi.item.CLOTHO_ORB, wearMessage = chamberOfOraclesID.text.A_CRACK_HAS_FORMED, wornMessage = chamberOfOraclesID.text.ORB_IS_CRACKED },
    armouryCrates    =
    {
        chamberOfOraclesID.mob.SECUTOR_XI_XXXII + 4,
        chamberOfOraclesID.mob.SECUTOR_XI_XXXII + 9,
        chamberOfOraclesID.mob.SECUTOR_XI_XXXII + 14,
    },
})

content:addEssentialMobs({ 'Sabotender_Campeon', 'Sabotender_Amante' })

content.loot =
{
    {
        { itemId = 916,  weight = 700 }, -- Cactuar Needle
        { itemId = 1236, weight = 250 }, -- Cactus Stems
        { itemId = 1592, weight =  50 }, -- Cactuar Root
    },
    {
        { itemId = 15152, weight = 250 }, -- Cactuar Ribbon
        { itemId = 17577, weight = 250 }, -- Capricorn staff
        { itemId = 17997, weight = 250 }, -- Argent Dagger
        { itemId = 18372, weight = 250 }, -- Balan's Sword
    },
    {
        { itemId = 17246, weight = 200 }, -- Ziska's Crossbow
        { itemId = 17825, weight = 200 }, -- Honebami
        { itemId = 17790, weight = 200 }, -- Unji
        { itemId = 17999, weight = 200 }, -- Taillefer's Dagger
        { itemId = 18089, weight = 200 }, -- Schiltron Spear
    },
    {
        { itemId = 644,  weight = 50 }, -- Chunk Of Mythril Ore
        { itemId = 645,  weight = 50 }, -- Chunk Of Darksteel Ore
        { itemId = 700,  weight = 50 }, -- Mahogany Log
        { itemId = 702,  weight = 50 }, -- Ebony Log
        { itemId = 703,  weight = 50 }, -- Petrified Log
        { itemId = 823,  weight = 50 }, -- Spool Of Gold Thread
        { itemId = 830,  weight = 50 }, -- Square Of Rainbow Cloth
        { itemId = 844,  weight = 50 }, -- Phoenix Feather
        { itemId = 866,  weight = 50 }, -- Handful Of Wyvern Scales
        { itemId = 887,  weight = 50 }, -- Coral Fragment
        { itemId = 895,  weight = 50 }, -- Ram Horn
        { itemId = 902,  weight = 50 }, -- Demon Horn
        { itemId = 942,  weight = 50 }, -- Philosophers Stone
        { itemId = 1465, weight = 50 }, -- Slab Of Granite
        { itemId = 1132, weight = 50 }, -- Square Of Raxa
        { itemId = 4174, weight = 50 }, -- Vile Elixir
        { itemId = 4175, weight = 50 }, -- Vile Elixir +1
        { itemId = 4613, weight = 50 }, -- Cure V
        { itemId = 4659, weight = 50 }, -- Shell IV
        { itemId = 4774, weight = 50 }, -- Thunder III
    },
    {
        { itemId = 0,    weight = 250 }, -- Nothing
        { itemId = 658,  weight = 100 }, -- Damascus Ingot
        { itemId = 836,  weight = 150 }, -- Square Of Damascene Cloth
        { itemId = 837,  weight = 100 }, -- Spool Of Malboro Fiber
        { itemId = 942,  weight = 100 }, -- Philosophers Stone
        { itemId = 844,  weight =  50 }, -- Phoenix Feather
        { itemId = 1132, weight = 250 }, -- Square Of Raxa
    },
}

return content:register()
