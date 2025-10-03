-----------------------------------
-- Copycat
-- Waughroon Shrine KSNM30, Clotho Orb
-- !additem 1180
-----------------------------------
local waughroonID = zones[xi.zone.WAUGHROON_SHRINE]
-----------------------------------

local content = Battlefield:new({
    zoneId           = xi.zone.WAUGHROON_SHRINE,
    battlefieldId    = xi.battlefield.id.COPYCAT,
    maxPlayers       = 18,
    timeLimit        = utils.minutes(30),
    index            = 16,
    entryNpc         = 'BC_Entrance',
    exitNpc          = 'Burning_Circle',
    requiredItems    = { xi.item.CLOTHO_ORB, wearMessage = waughroonID.text.A_CRACK_HAS_FORMED, wornMessage = waughroonID.text.ORB_IS_CRACKED },

    experimental = true,
})

-- TODO get the rest of the pets to work

content.groups =
{
    {
        mobIds =
        {
            {
                17367248,
            },

            {
                17367254,
            },

            {
                17367260,
            },
        },

        allDeath = utils.bind(content.handleAllMonstersDefeated, content),
    },
}

content.armouryCrates =
{
    17367249,
    17367255,
    17367261,
}

content.loot =
{
    {
        { itemId =   655, weight = 1000 }, -- Adaman Ingot
    },
    {
        { itemId =  1474, weight = 1000 }, -- Infinity Core (custom drop)
    },
    {
        { itemId =   557, weight =  250 }, -- Ahriman Lens
        { itemId =   935, weight =  250 }, -- Ahriman Wing
        { itemId = 19025, weight =   50 }, -- Pole Grip
        { itemId = 19024, weight =   15 }, -- Sword Strap
        { itemId = 19026, weight =  250 }, -- Spear Strap
    },
    {
        { itemId = 17275, weight =  250 }, -- Coffinmaker
        { itemId = 17509, weight =  250 }, -- Destroyers
        { itemId = 17207, weight =  250 }, -- Expunger
        { itemId = 17944, weight =  250 }, -- Retributor
    },
    {
        { itemId = 14762, weight =  250 }, -- Atillas Earring
        { itemId = 17700, weight =  250 }, -- Durandal
        { itemId = 18006, weight =  250 }, -- Hoplites Harpe
        { itemId = 17842, weight =  250 }, -- Sorrowful Harpe
    },
    {
        { itemId = 15327, weight =  550 }, -- Fuma Sune-ate
        { itemId =   646, weight =  200 }, -- Chunk of Adaman Ore
        { itemId =   747, weight =  250 }, -- Orichalcum Ingot
    },
    {
        { itemId =   887, weight =   50 }, -- Coral Fragment
        { itemId =   645, weight =   50 }, -- Chunk of Darksteel Ore
        { itemId =   902, weight =   50 }, -- Demon Horn
        { itemId =   702, weight =   50 }, -- Ebony Log
        { itemId =   737, weight =   50 }, -- Chunk of Gold Ore
        { itemId =   823, weight =   50 }, -- Spool of Gold Thread
        { itemId =  4173, weight =   50 }, -- Hi-Reraiser
        { itemId =   738, weight =   50 }, -- Chunk of Platinum Ore
        { itemId =   700, weight =   50 }, -- Mahogany Log
        { itemId =   837, weight =   50 }, -- Spool of Malboro Fiber
        { itemId =   644, weight =   50 }, -- Chunk of Mythril Ore
        { itemId =   703, weight =   50 }, -- Petrified Log
        { itemId =   830, weight =   50 }, -- Square of Rainbow Cloth
        { itemId =   895, weight =   50 }, -- Ram Horn
        { itemId =  1132, weight =   50 }, -- Square of Raxa
        { itemId =  4172, weight =   50 }, -- Reraiser
        { itemId =  4174, weight =   50 }, -- Vile Elixier
        { itemId =  4175, weight =   50 }, -- Vile Elixir +1
        { itemId =  2142, weight =   50 }, -- Wailing Ram Horn
        { itemId =  866,  weight =   50 }, -- Handful of Wyvern Scales
        { itemId =  942,  weight =   50 }, -- Philosophers Stone
    },
    {
        { itemId = 1110,  weight =   50 }, -- Vial of Black Beetle Blood
        { itemId =  836,  weight =   50 }, -- Square of Damascene Cloth
        { itemId =  658,  weight =   50 }, -- Damascus Ingot
        { itemId =  837,  weight =   50 }, -- Spool of Malboro Fiber
        { itemId =  942,  weight =  300 }, -- Philosophers Stone
        { itemId =  844,  weight =  300 }, -- Phoenix Feather
        { itemId =  1132, weight =  200 }, -- Square of Raxa
    },
}

return content:register()
