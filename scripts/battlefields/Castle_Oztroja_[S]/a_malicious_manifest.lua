-----------------------------------
-- A Malicious Manifest
-- Stronghold Battlefield
-----------------------------------
local ID = zones[xi.zone.CASTLE_OZTROJA_S]
-----------------------------------
-- ID.text.PARTY_MEMBERS_HAVE_FALLEN = 8040
ID.text.MEMBERS_OF_YOUR_ALLIANCE      = ID.text.PARTY_MEMBERS_HAVE_FALLEN - 38 -- 7998
ID.text.TIME_LIMIT_FOR_THIS_BATTLE_IS = ID.text.PARTY_MEMBERS_HAVE_FALLEN - 36 -- 8004
ID.text.ENTERING_THE_BATTLEFIELD_FOR  = ID.text.PARTY_MEMBERS_HAVE_FALLEN + 29 -- 8069
ID.text.TIME_IN_THE_BATTLEFIELD_IS_UP = ID.text.PARTY_MEMBERS_HAVE_FALLEN + 55 -- 8095
ID.mob.TZEE_XICU_THE_MANIFEST         = ID.mob.SUU_XICU_THE_CANTABILE + 24

local content = Battlefield:new({
    zoneId           = xi.zone.CASTLE_OZTROJA_S,
    battlefieldId    = 3000,
    maxPlayers       = 18,
    allowTrusts      = false,
    levelCap         = 75,
    allowSubjob      = true,
    timeLimit        = utils.minutes(30),
    index            = 1,
    grantXP          = 2000,
    entryNpc         = '_2r8',
    exitNpc          = { '_2r8' },
    requiredKeyItems =
    {
        xi.ki.HABALOS_ECLOGUE_VERSE_I,
        xi.ki.HABALOS_ECLOGUE_VERSE_II,
        xi.ki.HABALOS_ECLOGUE_VERSE_III,
        xi.ki.HABALOS_ECLOGUE_VERSE_IV,
        xi.ki.HABALOS_ECLOGUE_VERSE_V,
        xi.ki.HABALOS_ECLOGUE_VERSE_VI,
        xi.ki.HABALOS_ECLOGUE_VERSE_VII,
        xi.ki.HABALOS_ECLOGUE_VERSE_VIII,
        message = ID.text.THE_PARTY_WILL_BE_REMOVED + 9, -- All of the Habalo's Eclogue parchments disappear!
    },
    experimental  = false,
    armouryCrates =
    {
        ID.mob.TZEE_XICU_THE_MANIFEST + 5,
    }
})

content.groups =
{
    {
        mobIds =
        {
            { 
                ID.mob.TZEE_XICU_THE_MANIFEST, 
                ID.mob.TZEE_XICU_THE_MANIFEST + 1,
                ID.mob.TZEE_XICU_THE_MANIFEST + 2,
                ID.mob.TZEE_XICU_THE_MANIFEST + 3,
                ID.mob.TZEE_XICU_THE_MANIFEST + 4,
            },
        },

        superlink = true,
        allDeath  = utils.bind(content.handleAllMonstersDefeated, content),
    },
}

content.loot =
{
    {
        { item = xi.item.ASCENSION_STONE, weight = 1000 },
    },
    {
        { item = xi.item.APEX_HATSUBURI,   weight = 200 },
        { item = xi.item.APEX_TOGI,        weight = 200 },
        { item = xi.item.APEX_KOTE,        weight = 200 },
        { item = xi.item.APEX_HAIDATE,     weight = 200 },
        { item = xi.item.APEX_SUNE_ATE,    weight = 200 },
    },
    {
        { item = xi.item.PINNACLE_CELATA,   weight = 60 },
        { item = xi.item.PINNACLE_CUIRASS,  weight = 60 },
        { item = xi.item.PINNACLE_DASTANAS, weight = 60 },
        { item = xi.item.PINNACLE_CUISSES,  weight = 60 },
        { item = xi.item.PINNACLE_SABATONS, weight = 60 },
        { item = xi.item.APOGEE_PETASOS,    weight = 60 },
        { item = xi.item.APOGEE_COAT,       weight = 60 },
        { item = xi.item.APOGEE_CUFFS,      weight = 60 },
        { item = xi.item.APOGEE_TONBAN,     weight = 60 },
        { item = xi.item.APOGEE_SABOTS,     weight = 60 },
        { item = xi.item.APEX_HATSUBURI,    weight = 80 },
        { item = xi.item.APEX_TOGI,         weight = 80 },
        { item = xi.item.APEX_KOTE,         weight = 80 },
        { item = xi.item.APEX_HAIDATE,      weight = 80 },
        { item = xi.item.APEX_SUNE_ATE,     weight = 80 },
    },
    {
        { item = xi.item.APEX_TOKEN,     weight = 333 },
        { item = xi.item.PINNACLE_TOKEN, weight = 333 },
        { item = xi.item.APOGEE_TOKEN,   weight = 334 },
    },
    {
        { item = xi.item.APEX_TOKEN,     weight = 333 },
        { item = xi.item.PINNACLE_TOKEN, weight = 334 },
        { item = xi.item.APOGEE_TOKEN,   weight = 333 },
    },
    {
        { item = xi.item.NONE,           weight = 700 },
        { item = xi.item.APEX_TOKEN,     weight = 100 },
        { item = xi.item.PINNACLE_TOKEN, weight = 100 },
        { item = xi.item.APOGEE_TOKEN,   weight = 100 },
    },
    {
        { item = xi.item.NONE,           weight = 700 },
        { item = xi.item.APEX_TOKEN,     weight = 100 },
        { item = xi.item.PINNACLE_TOKEN, weight = 100 },
        { item = xi.item.APOGEE_TOKEN,   weight = 100 },
    },
    {
        { item = 2763, weight = 40 }, -- Swamp Ore
        { item = 737,  weight = 40 }, -- Gold Ore
        { item = 1858, weight = 40 }, -- Moblumin Ingot
        { item = 2761, weight = 40 }, -- Feyweald Log
        { item = 703,  weight = 40 }, -- Petrified Log
        { item = 2831, weight = 40 }, -- Yellow Brass Chain
        { item = 1861, weight = 40 }, -- Moblin Sheepskin
        { item = 2518, weight = 40 }, -- Smilodon Hide
        { item = 844,  weight = 40 }, -- Phoenix Feather
        { item = 5651, weight = 40 }, -- Burdock
        { item = 6393, weight = 40 }, -- Porxie Pork
        { item = 738,  weight = 40 }, -- Platinum Ore
        { item = 2755, weight = 40 }, -- Ruszor Hide
        { item = 915,  weight = 40 }, -- Toad Oil
        { item = 1465, weight = 40 }, -- Granite
        { item = 1622, weight = 40 }, -- Bugard Tusk
        { item = 828,  weight = 40 }, -- Velvet Cloth
        { item = 1641, weight = 40 }, -- Fire Anima
        { item = 1644, weight = 40 }, -- Earth Anima
        { item = 1646, weight = 40 }, -- Water Anima
        { item = 1643, weight = 40 }, -- Wind Anima
        { item = 1642, weight = 40 }, -- Ice Anima
        { item = 1645, weight = 40 }, -- Lightning Anima
        { item = 1647, weight = 40 }, -- Light Anima
        { item = 1648, weight = 40 }, -- Dark Anima
    },
    {
        { item = 2763, weight = 40 }, -- Swamp Ore
        { item = 737,  weight = 40 }, -- Gold Ore
        { item = 1858, weight = 40 }, -- Moblumin Ingot
        { item = 2761, weight = 40 }, -- Feyweald Log
        { item = 703,  weight = 40 }, -- Petrified Log
        { item = 2831, weight = 40 }, -- Yellow Brass Chain
        { item = 1861, weight = 40 }, -- Moblin Sheepskin
        { item = 2518, weight = 40 }, -- Smilodon Hide
        { item = 844,  weight = 40 }, -- Phoenix Feather
        { item = 5651, weight = 40 }, -- Burdock
        { item = 6393, weight = 40 }, -- Porxie Pork
        { item = 738,  weight = 40 }, -- Platinum Ore
        { item = 2755, weight = 40 }, -- Ruszor Hide
        { item = 915,  weight = 40 }, -- Toad Oil
        { item = 1465, weight = 40 }, -- Granite
        { item = 1622, weight = 40 }, -- Bugard Tusk
        { item = 828,  weight = 40 }, -- Velvet Cloth
        { item = 1641, weight = 40 }, -- Fire Anima
        { item = 1644, weight = 40 }, -- Earth Anima
        { item = 1646, weight = 40 }, -- Water Anima
        { item = 1643, weight = 40 }, -- Wind Anima
        { item = 1642, weight = 40 }, -- Ice Anima
        { item = 1645, weight = 40 }, -- Lightning Anima
        { item = 1647, weight = 40 }, -- Light Anima
        { item = 1648, weight = 40 }, -- Dark Anima
    },
    -- original drops
    {
        { item = xi.item.NONE,                 weight = 250 },
        { item = xi.item.BRILLIANT_EARRING,    weight = 375 },
        { item = xi.item.REE_HABALOS_HEADGEAR, weight = 375 },
    },
    {
        { item = xi.item.NONE,     weight = 250 },
        { item = 15833,            weight = 250 }, -- diverters ring
        { item = 11392,            weight = 250 }, -- koschei crackows
        { item = xi.item.PRESTER,  weight = 250 }, -- prester
    },
}

return content:register()
