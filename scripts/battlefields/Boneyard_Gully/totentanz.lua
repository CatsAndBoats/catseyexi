-----------------------------------
-- Totentanz
-- Boneyard Gully ENM, Miasma Filter
-- !addkeyitem MIASMA_FILTER
-- !pos -615.19 -1.816 502.20 8
-----------------------------------
local boneyardGullyID = zones[xi.zone.BONEYARD_GULLY]
-----------------------------------

local content = Battlefield:new({
    zoneId           = xi.zone.BONEYARD_GULLY,
    battlefieldId    = xi.battlefield.id.TOTENTANZ,
    maxPlayers       = 18,
    levelCap         = 75,
    timeLimit        = utils.minutes(15),
    index            = 4,
    entryNpc         = '_081',
    exitNpcs         = { '_082', '_084', '_086' },
    requiredKeyItems = { xi.ki.MIASMA_FILTER },
    armouryCrates    =
    {
        boneyardGullyID.mob.TUCHULCHA + 4,
        boneyardGullyID.mob.TUCHULCHA + 9,
        boneyardGullyID.mob.TUCHULCHA + 14,
    },

    grantXP = 2500,
})

local GWYN_AP_KNUDD = boneyardGullyID.mob.TUCHULCHA + 50

content.groups =
{
    {
        mobs      = { 'Gwyn_Ap_Knudd' },
        superlink = true,
        death     = utils.bind(content.handleAllMonstersDefeated, content),
    },

    {
        mobs      = { 'Cadaver_Warrior' },
        spawned   = true,
        superlink = true,
    },

    {
        mobs      = { 'Cadaver_Witch' },
        spawned   = true,
        superlink = true,
    },

    {
        mobs      = { 'Erdgeist' },
        spawned   = true,
        superlink = true,
    },
}

content.loot =
{
    {
        { item = xi.item.NONE,         weight = 800 },
        { item = xi.item.CLOUD_EVOKER, weight = 200 },
    },
    {
        { item = xi.item.NONE,           weight = 325 },
        { item = xi.item.ONIMARU,        weight = 100 },
        { item = xi.item.BLAU_DOLCH,     weight = 250 },
        { item = xi.item.STONE_SPLITTER, weight = 150 },
        { item = xi.item.FRENZY_FIFE,    weight = 175 },
    },
    {
        { item = xi.item.NONE,           weight = 670 },
        { item = xi.item.MANEATER,       weight = 100 },
        { item = xi.item.WAGH_BAGHNAKHS, weight =  65 },
        { item = xi.item.RAISE_II_ROD,   weight =  65 },
        { item = xi.item.CORSE_CAPE,     weight = 100 },
    },
    {
        { item = xi.item.NONE,                     weight = 325 },
        { item = xi.item.POT_OF_VIRIDIAN_URUSHI,   weight = 350 },
        { item = xi.item.SQUARE_OF_ELTORO_LEATHER, weight = 325 },
    },
    {
        { item = xi.item.NONE,                   weight = 150 },
        { item = xi.item.UNICORN_HORN,           weight = 225 },
        { item = xi.item.PIECE_OF_CASSIA_LUMBER, weight = 375 },
        { item = xi.item.DRAGON_BONE,            weight = 250 },
    },
}

return content:register()
