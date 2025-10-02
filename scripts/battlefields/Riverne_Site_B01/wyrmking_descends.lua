-----------------------------------
-- Area: Riverne Site #B01
-- Name: The Wyrmking Descends
-- !pos -612.800 1.750 693.190 29
-----------------------------------
local riverneID = zones[xi.zone.RIVERNE_SITE_B01]
-----------------------------------

local content = Battlefield:new({
    zoneId        = xi.zone.RIVERNE_SITE_B01,
    battlefieldId = xi.battlefield.id.WYRMKING_DESCENDS,
    maxPlayers    = 18,
    levelCap      = 75,
    timeLimit     = utils.minutes(60),
    index         = 1,
    area          = 1,
    entryNpc      = 'Unstable_Displacement',
    exitNpc       = 'SD_BCNM_Exit',
    requiredItems =
    {
        xi.item.MONARCHS_ORB,
        wearMessage = riverneID.text.TIME_LIMIT_FOR_THIS_BATTLE_IS + 2,
        wornMessage = riverneID.text.TIME_LIMIT_FOR_THIS_BATTLE_IS + 1,
    },
    grantXP          = 1500,
})

content:addEssentialMobs({ 'Bahamut' })

content.groups =
{
    {
        mobIds =
        {
            riverneID.mob.BAHAMUT + 1,
        },

        allDeath = utils.bind(content.handleAllMonstersDefeated, content),
    },
    {
        mobs = { 'Ouryu' },
        superlink = true,
        spawned = false,
    },
    {
        mobs = { 'Tiamat' },
        superlink = true,
        spawned = false,
    },
    {
        mobs = { 'Jormungand' },
        superlink = true,
        spawned = false,
    },
    {
        mobs = { 'Vrtra' },
        superlink = true,
        spawned = false,
    },
    {
        mobs = { 'Ziryu' },
        superlink = true,
        spawned = false,
    },
    {
        mobs = { 'Water_Elemental' },
        superlink = true,
        spawned = false,
    },
    {
        mobs = { 'Earth_Elemental' },
        superlink = true,
        spawned = false,
    },
    {
        mobs = { 'Pey' },
        superlink = true,
        spawned = false,
    },
    {
        mobs = { 'Iruci' },
        superlink = true,
        spawned = false,
    },
    {
        mobs = { 'Airi' },
        superlink = true,
        spawned = false,
    },
}

content.loot =
{
    {
        { itemId =    0, weight = 950 }, -- Nothing
        { itemId = 1842, weight =  50 }, -- Cloud Evoker
    },
    {
        { itemId =     0, weight = 500 }, -- Nothing
        { itemId = 15433, weight = 250 }, -- Reverend Sash
        { itemId = 15434, weight = 250 }, -- Vanguard Belt
    },
    {
        { itemId =     0, weight = 350 }, -- Nothing
        { itemId = 13550, weight = 200 }, -- Crossbowman's Ring
        { itemId = 14675, weight = 150 }, -- Woodsman Ring
        { itemId = 13549, weight = 300 }, -- Ether Ring
    },
}

return content:register()
