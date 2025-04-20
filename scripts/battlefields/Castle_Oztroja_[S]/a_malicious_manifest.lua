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
        { item = xi.item.APEX_HATSUBURI,    weight = 66 },
        { item = xi.item.APEX_TOGI,         weight = 66 },
        { item = xi.item.APEX_KOTE,         weight = 66 },
        { item = xi.item.APEX_HAIDATE,      weight = 66 },
        { item = xi.item.APEX_SUNE_ATE,     weight = 66 },

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
