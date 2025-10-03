-----------------------------------
-- Bionic Bug
-- Mine Shaft #2716 battlefield
-----------------------------------
local ID = zones[xi.zone.MINE_SHAFT_2716]
-----------------------------------

local content = Battlefield:new({
    zoneId           = xi.zone.MINE_SHAFT_2716,
    battlefieldId    = xi.battlefield.id.BIONIC_BUG,
    maxPlayers       = 18,
    levelCap         = 75,
    timeLimit        = utils.minutes(30),
    index            = 2,
    entryNpc         = '_0d0',
    exitNpc          = { '_0d1', '_0d2', '_0d3'  }, -- copied from existing mine shaft 2716 battlefield
    requiredKeyItems = { xi.ki.SHAFT_2716_OPERATING_LEVER, message = ID.text.THE_PARTY_WILL_BE_REMOVED + 8 },
    experimental     = true,
})

content:addEssentialMobs({ 'Bugboy' })

content.loot =
{
    {
        { itemId =    0, weight = 900 }, -- Nothing
        { itemId = 1842, weight = 100 }, -- Cloud Evoker
    },
    {
        { itemId = 1767, weight = 333 }, -- Eltoro Leather
        { itemId = 1762, weight = 333 }, -- Cassia Lumber
        { itemId = 1771, weight = 334 }, -- Dragon Bone
    },
    {
        { itemId =     0, weight = 625 }, -- nothing
        { itemId = 18009, weight =  75 }, -- Martial Knife
        { itemId = 18056, weight =  75 }, -- Martial Scythe
        { itemId = 13695, weight =  75 }, -- Commander's Cape
        { itemId = 15195, weight = 100 }, -- Faerie Hairpin
        { itemId =  4748, weight =  50 }, -- Raise III
    },
    {
        { itemId =     0, weight = 625 }, -- nothing
        { itemId = 18009, weight =  75 }, -- Martial Knife
        { itemId = 18056, weight =  75 }, -- Martial Scythe
        { itemId = 13695, weight =  75 }, -- Commander's Cape
        { itemId = 15195, weight = 100 }, -- Faerie Hairpin
        { itemId =  4748, weight =  50 }, -- Raise III
    },
}

return content:register()
