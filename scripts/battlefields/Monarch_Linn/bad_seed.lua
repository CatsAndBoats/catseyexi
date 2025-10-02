-----------------------------------
-- Area: Monarch Linn
-- Name: Bad Seed
-----------------------------------
local content = Battlefield:new({
    zoneId           = xi.zone.MONARCH_LINN,
    battlefieldId    = xi.battlefield.id.BAD_SEED,
    maxPlayers       = 18,
    levelCap         = 40,
    timeLimit        = utils.minutes(30),
    index            = 3,
    entryNpc         = 'SD_Entrance',
    exitNpcs         = { 'SD_BCNM_Exit_1', 'SD_BCNM_Exit_2', 'SD_BCNM_Exit_3' },
    requiredKeyItems = { xi.ki.MONARCH_BEARD },
    grantXP          = 1500,
})

content:addEssentialMobs({ 'Hamadryad' })

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
