-----------------------------------
-- Area: La Vaule [S]
-- BCNM: The Blood-bathed Crown
-----------------------------------
local ID = zones[xi.zone.LA_VAULE_S]
-----------------------------------
ID.text.MEMBERS_OF_YOUR_ALLIANCE      = ID.text.PARTY_MEMBERS_HAVE_FALLEN - 38 -- 7998
ID.text.TIME_LIMIT_FOR_THIS_BATTLE_IS = ID.text.PARTY_MEMBERS_HAVE_FALLEN - 36 -- 8004
ID.text.ENTERING_THE_BATTLEFIELD_FOR  = ID.text.PARTY_MEMBERS_HAVE_FALLEN + 29 -- 8069
ID.text.TIME_IN_THE_BATTLEFIELD_IS_UP = ID.text.PARTY_MEMBERS_HAVE_FALLEN + 55 -- 8095
ID.mob.BLOODCROWN_BRRADHOD            = ID.mob.HAWKEYED_DNATBAT + 251

local content = Battlefield:new({
    zoneId           = xi.zone.LA_VAULE_S,
    battlefieldId    = 3001,
    maxPlayers       = 18,
    allowTrusts      = false,
    levelCap         = 75,
    allowSubjob      = true,
    timeLimit        = utils.minutes(30),
    index            = 2,
    entryNpc         = '_2d1',
    exitNpcs         = { '_2d3', '_2d5', '_2d7' },
    requiredKeyItems =
    {
        xi.ki.IMPERIAL_LINEAGE_CHAPTER_I,
        xi.ki.IMPERIAL_LINEAGE_CHAPTER_II,
        xi.ki.IMPERIAL_LINEAGE_CHAPTER_III,
        xi.ki.IMPERIAL_LINEAGE_CHAPTER_IV,
        xi.ki.IMPERIAL_LINEAGE_CHAPTER_V,
        xi.ki.IMPERIAL_LINEAGE_CHAPTER_VI,
        xi.ki.IMPERIAL_LINEAGE_CHAPTER_VII,
        xi.ki.IMPERIAL_LINEAGE_CHAPTER_VIII,
        message = ID.text.PARTY_MEMBERS_HAVE_FALLEN + 16, -- All of the Imperial Lineage chapters disappear!
    },

    experimental  = false,
    armouryCrates =
    {
        ID.mob.BLOODCROWN_BRRADHOD + 5,
    }
})

content.groups =
{
    {
        mobIds =
        {
            {
                ID.mob.BLOODCROWN_BRRADHOD,
                ID.mob.BLOODCROWN_BRRADHOD + 1,
                ID.mob.BLOODCROWN_BRRADHOD + 2,
                ID.mob.BLOODCROWN_BRRADHOD + 3,
                ID.mob.BLOODCROWN_BRRADHOD + 4,
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
            { item = xi.item.APOGEE_PETASOS,    weight = 200 },
            { item = xi.item.APOGEE_COAT,       weight = 200 },
            { item = xi.item.APOGEE_CUFFS,      weight = 200 },
            { item = xi.item.APOGEE_TONBAN,     weight = 200 },
            { item = xi.item.APOGEE_SABOTS,     weight = 200 },
        },
        {
            { item = xi.item.PINNACLE_CELETA,   weight = 67 },
            { item = xi.item.PINNACLE_CUIRASS,  weight = 66 },
            { item = xi.item.PINNACLE_DASTANAS, weight = 66 },
            { item = xi.item.PINNACLE_CUISSES,  weight = 66 },
            { item = xi.item.PINNACLE_SABATONS, weight = 66 },
            { item = xi.item.APOGEE_PETASOS,    weight = 66 },
            { item = xi.item.APOGEE_COAT,       weight = 66 },
            { item = xi.item.APOGEE_CUFFS,      weight = 66 },
            { item = xi.item.APOGEE_TONBAN,     weight = 66 },
            { item = xi.item.APOGEE_SABOTS,     weight = 66 },
            { item = xi.item.APEX_HATSUBURI,    weight = 66 },
            { item = xi.item.APEX_TOGI,         weight = 66 },
            { item = xi.item.APEX_KOTE,         weight = 66 },
            { item = xi.item.APEX_HAIDATE,      weight = 66 },
            { item = xi.item.APEX_SUNE_ATE,     weight = 66 },
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
    }

return content:register()
