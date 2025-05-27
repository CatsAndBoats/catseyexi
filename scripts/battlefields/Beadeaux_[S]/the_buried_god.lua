-----------------------------------
-- Area: Beadeaux [S]
-- BCNM: The Buried God
-----------------------------------
local ID = zones[xi.zone.BEADEAUX_S]
-----------------------------------
ID.text.KEYITEM_LOST                  = ID.text.ITEM_OBTAINED + 3
ID.text.MEMBERS_OF_YOUR_ALLIANCE      = ID.text.PARTY_MEMBERS_HAVE_FALLEN - 38
ID.text.TIME_LIMIT_FOR_THIS_BATTLE_IS = ID.text.PARTY_MEMBERS_HAVE_FALLEN - 36
ID.text.ENTERING_THE_BATTLEFIELD_FOR  = ID.text.PARTY_MEMBERS_HAVE_FALLEN + 29
ID.text.TIME_IN_THE_BATTLEFIELD_IS_UP = ID.text.PARTY_MEMBERS_HAVE_FALLEN + 55
ID.mob.ZADHA_ADAMANTKING              = ID.mob.BATHO_MERCIFULHEART + 239

local content = Battlefield:new({
    zoneId                = xi.zone.BEADEAUX_S,
    battlefieldId         = 3002,
    maxPlayers            = 18,
    allowTrusts           = false,
    levelCap              = 75,
    allowSubjob           = true,
    timeLimit             = utils.minutes(30),
    index                 = 1,
    entryNpc              = '_2k5',
    exitNpcs              = { '_2k6', '_2k8', '_2ka' },
    requiredKeyItems =
    {
        xi.ki.THE_WORDS_OF_DONHU_I,
        xi.ki.THE_WORDS_OF_DONHU_II,
        xi.ki.THE_WORDS_OF_DONHU_III,
        xi.ki.THE_WORDS_OF_DONHU_IV,
        xi.ki.THE_WORDS_OF_DONHU_V,
        xi.ki.THE_WORDS_OF_DONHU_VI,
        xi.ki.THE_WORDS_OF_DONHU_VII,
        xi.ki.THE_WORDS_OF_DONHU_VIII,
        message = ID.text.PARTY_MEMBERS_HAVE_FALLEN + 16, -- All of the “Words of Do'Nhu” tablets disappear!
    },
    experimental  = false,
    armouryCrates =
    {
        ID.mob.ZADHA_ADAMANTKING + 5,
    }
})

content.groups =
{
    {
        mobIds =
        {
            {
                ID.mob.ZADHA_ADAMANTKING,
                ID.mob.ZADHA_ADAMANTKING + 1,
                ID.mob.ZADHA_ADAMANTKING + 2,
                ID.mob.ZADHA_ADAMANTKING + 3,
                ID.mob.ZADHA_ADAMANTKING + 4,
            },
        },

        superlink = true,
        allDeath  = utils.bind(content.handleAllMonstersDefeated, content),
    }}

content.loot =
{
    {
        { item = xi.item.ASCENSION_STONE, weight = 1000 },
    },
    {
        { item = xi.item.PINNACLE_CELATA,   weight = 200 },
        { item = xi.item.PINNACLE_CUIRASS,  weight = 200 },
        { item = xi.item.PINNACLE_DASTANAS, weight = 200 },
        { item = xi.item.PINNACLE_CUISSES,  weight = 200 },
        { item = xi.item.PINNACLE_SABATONS, weight = 200 },
    },
    {
        { item = xi.item.PINNACLE_CELATA,   weight = 80 },
        { item = xi.item.PINNACLE_CUIRASS,  weight = 80 },
        { item = xi.item.PINNACLE_DASTANAS, weight = 80 },
        { item = xi.item.PINNACLE_CUISSES,  weight = 80 },
        { item = xi.item.PINNACLE_SABATONS, weight = 80 },
        { item = xi.item.APOGEE_PETASOS,    weight = 60 },
        { item = xi.item.APOGEE_COAT,       weight = 60 },
        { item = xi.item.APOGEE_CUFFS,      weight = 60 },
        { item = xi.item.APOGEE_TONBAN,     weight = 60 },
        { item = xi.item.APOGEE_SABOTS,     weight = 60 },
        { item = xi.item.APEX_HATSUBURI,    weight = 60 },
        { item = xi.item.APEX_TOGI,         weight = 60 },
        { item = xi.item.APEX_KOTE,         weight = 60 },
        { item = xi.item.APEX_HAIDATE,      weight = 60 },
        { item = xi.item.APEX_SUNE_ATE,     weight = 60 },
    },
    {
        { item = xi.item.APEX_TOKEN,     weight = 333 },
        { item = xi.item.PINNACLE_TOKEN, weight = 333 },
        { item = xi.item.APOGEE_TOKEN,   weight = 334 },
    },
    {
        { item = xi.item.APEX_TOKEN,     weight = 334 },
        { item = xi.item.PINNACLE_TOKEN, weight = 333 },
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
        { item = xi.item.PARAMOUNT_EARRING,    weight = 375 },
        { item = xi.item.ZHAGOS_BARBUT,        weight = 375 },
    },
    {
        { item = xi.item.NONE,     weight = 250 },
        { item = 15832,            weight = 250 }, -- headsmans ring
        { item = 15034,            weight = 250 }, -- stone mufflers
        { item = 18501,            weight = 250 }, -- seismic axe
    },
}

return content:register()
