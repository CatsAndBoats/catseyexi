-----------------------------------
-- Area: Monarch Linn
-- Name: Fire in the Sky
-----------------------------------
local content = Battlefield:new({
    zoneId           = xi.zone.MONARCH_LINN,
    battlefieldId    = xi.battlefield.id.FIRE_IN_THE_SKY,
    maxPlayers       = 3,
    levelCap         = 40,
    timeLimit        = utils.minutes(15),
    index            = 2,
    entryNpc         = 'SD_Entrance',
    exitNpcs         = { 'SD_BCNM_Exit_1', 'SD_BCNM_Exit_2', 'SD_BCNM_Exit_3' },
    requiredKeyItems = { xi.ki.MONARCH_BEARD },
    grantXP          = 1500,
})

content:addEssentialMobs({ 'Razon' })

content.loot =
{
    {
        { itemId = xi.item.NONE,         weight = 950 }, -- Nothing
        { itemId = xi.item.CLOUD_EVOKER, weight =  50 }, -- Cloud Evoker
    },
    {
        { itemId = xi.item.NOTHING,        weight = 500 }, -- Nothing
        { itemId = xi.item.THUGS_ZAMBURAK, weight = 250 }, -- Thug's Zamburak
        { itemId = xi.item.HORROR_VOULGE , weight = 250 }, -- Horror Voulge
    },
    {
        { itemId = xi.item.NONE,              weight = 350 }, -- Nothing
        { itemId = xi.item.CROSSBOWMANS_RING, weight = 200 }, -- Crossbowman's Ring
        { itemId = xi.item.WOODSMAN_RING,     weight = 150 }, -- Woodsman Ring
        { itemId = xi.item.ETHER_RING,        weight = 300 }, -- Ether Ring
    },
}

return content:register()
