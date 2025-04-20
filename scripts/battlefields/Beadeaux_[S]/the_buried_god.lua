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
        { item = xi.item.PINNACLE_CELETA,   weight = 200 },
        { item = xi.item.PINNACLE_CUIRASS,  weight = 200 },
        { item = xi.item.PINNACLE_DASTANAS, weight = 200 },
        { item = xi.item.PINNACLE_CUISSES,  weight = 200 },
        { item = xi.item.PINNACLE_SABATONS, weight = 200 },
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
