-----------------------------------
-- Today's Horoscope
-- Horlais Peak KS30, Lachesis Orb
-- !additem 1178
-----------------------------------
local horlaisID = zones[xi.zone.HORLAIS_PEAK]
-----------------------------------

local content = Battlefield:new({
    zoneId           = xi.zone.HORLAIS_PEAK,
    battlefieldId    = xi.battlefield.id.TODAYS_HOROSCOPE,
    maxPlayers       = 6,
    timeLimit        = utils.minutes(30),
    index            = 16,
    entryNpc         = 'BC_Entrance',
    exitNpc          = 'Burning_Circle',
    requiredItems    = { xi.item.LACHESIS_ORB, wearMessage = horlaisID.text.A_CRACK_HAS_FORMED, wornMessage = horlaisID.text.ORB_IS_CRACKED },
})

content:addEssentialMobs({ 'Aries' })

content.loot =
{
    {
        { itemId = 65535, weight = 1000, amount = 24000 }, -- Gil
    },
    {
        { itemId =  1474, weight = 1000 }, -- Infinity Core (custom drop)
    },
    {
        { itemId = 18053, weight =  222 }, -- Gravedigger
        { itemId = 18097, weight =  302 }, -- Gondo-Shizunori
        { itemId = 18217, weight =  245 }, -- Rampager
        { itemId = 17944, weight =  231 }, -- Retributor
    },
    {
        { itemId = 15295, weight = 250 }, -- Hierarch Belt
        { itemId = 15294, weight = 338 }, -- Warwolf Belt
        { itemId = 12407, weight = 206 }, -- Palmerin's Shield
        { itemId = 14871, weight = 206 }, -- Trainer's Gloves
    },
    {
        { itemId =     0, weight = 342 },   -- Nothing
        { itemId = 13693, weight = 250 },   -- Aries Mantle
        { itemId =   655, weight = 230 },   -- Adaman Ingot
        { itemId =   747, weight = 178 },   -- Orichalcum Ingot
    },
    {
        { itemId =   911, weight = 292 },   -- Rampaging Horn
        { itemId =   910, weight = 265 },   -- Lumbering Horn
        { itemId = 19024, weight = 354 }, -- Sword Strap
        { itemId = 19027, weight =  89 },  -- Claymore Grip
    },
    {
        { itemId =  737, weight = 109 },   -- Chunk Of Gold Ore
        { itemId = 4172, weight =  34 },   -- Reraiser
        { itemId =  644, weight =  41 },    -- Chunk Of Mythril Ore
        { itemId =  902, weight =  61 },    -- Demon Horn
        { itemId =  702, weight = 121 },   -- Ebony Log
        { itemId =  866, weight =  44 },    -- Handful Of Wyvern Scales
        { itemId = 4175, weight =  27 },   -- Vile Elixir +1
        { itemId =  700, weight =  41 },    -- Mahogany Log
        { itemId =  887, weight =  80 },    -- Coral Fragment
        { itemId =  703, weight =  72 },    -- Petrified Log
        { itemId =  844, weight = 111 },   -- Phoenix Feather
        { itemId =  738, weight =  44 },    -- Chunk Of Platinum Ore
        { itemId =  895, weight =  14 },    -- Ram Horn
        { itemId =  830, weight =  14 },    -- Square Of Rainbow Cloth
        { itemId =  645, weight =  68 },    -- Chunk Of Darksteel Ore
        { itemId = 4173, weight =  14 },   -- Hi-reraiser
        { itemId = 1132, weight = 105 },  -- Square Of Raxa
    },
    {
        { itemId =   0, weight =  150 },     -- Nothing
        { itemId =  836, weight =  90 },    -- Square Of Damascene Cloth
        { itemId =  658, weight =  29 },    -- Damascus Ingot
        { itemId =  942, weight = 148 },   -- Philosophers Stone
        { itemId =  844, weight = 234 },   -- Phoenix Feather
        { itemId =  837, weight =  76 },    -- Spool Of Malboro Fiber
        { itemId = 1132, weight = 232 },  -- Square Of Raxa
        { itemId = 1110, weight =  41 },   -- Vial Of Black Beetle Blood
    },
}

return content:register()
