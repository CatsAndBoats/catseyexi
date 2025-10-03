-----------------------------------
-- ENM: Playing Host
-- Spire of Mea
-----------------------------------
require('scripts/missions/cop/helpers')
local spireOfMeaID = zones[xi.zone.SPIRE_OF_MEA]
-----------------------------------

local content = Battlefield:new({
    zoneId           = xi.zone.SPIRE_OF_MEA,
    battlefieldId    = xi.battlefield.id.PLAYING_HOST,
    maxPlayers       = 18,
    levelCap         = 30,
    timeLimit        = utils.minutes(30),
    index            = 1,
    entryNpc         = '_0l0',
    exitNpcs         = { '_0j1', '_0j2', '_0j3' },
    requiredKeyItems = { xi.ki.CENSER_OF_ANIMUS, message = spireOfMeaID.text.THE_PARTY_WILL_BE_REMOVED + 8 },
    grantXP          = 1500,
    armouryCrates    =
    {
        spireOfMeaID.mob.DELVER + 7,
        spireOfMeaID.mob.DELVER + 12,
        spireOfMeaID.mob.DELVER + 17,
    },
})

function content:entryRequirement(player, npc, isRegistrant, trade)
    local currentRequirements = player:hasCompletedMission(xi.mission.log_id.COP, xi.mission.id.cop.THE_MOTHERCRYSTALS)
    return currentRequirements
end

function content:checkSkipCutscene(player)
    return player:hasCompletedMission(xi.mission.log_id.COP, xi.mission.id.cop.THE_MOTHERCRYSTALS)
end

content:addEssentialMobs({ 'Envier' })

content.groups =
{
    {
        mobs = { 'Envier' },
        superlink = true,
        spawned = true,
        death = utils.bind(content.handleAllMonstersDefeated, content),
    },
    {
        mobs = { 'Seether' },
        superlink = true,
        spawned = false,
    },
}

content.loot =
{
    {
        { itemId =    0, weight = 200 }, -- Nothing
        { itemId = 5287, weight = 100 }, -- Bitter Cluster
        { itemId = 5286, weight = 100 }, -- Burning Cluster
        { itemId = 5288, weight = 100 }, -- Fleeting Cluster
        { itemId = 5293, weight = 100 }, -- Malevolent Cluster
        { itemId = 5289, weight = 100 }, -- Profane Cluster
        { itemId = 5292, weight = 100 }, -- Radiant Cluster
        { itemId = 5291, weight = 100 }, -- Somber Cluster
        { itemId = 5290, weight = 100 }, -- Startling Cluster
    },
    {
        { itemId =    0, weight = 200 }, -- Nothing
        { itemId = 5287, weight = 100 }, -- Bitter Cluster
        { itemId = 5286, weight = 100 }, -- Burning Cluster
        { itemId = 5288, weight = 100 }, -- Fleeting Cluster
        { itemId = 5293, weight = 100 }, -- Malevolent Cluster
        { itemId = 5289, weight = 100 }, -- Profane Cluster
        { itemId = 5292, weight = 100 }, -- Radiant Cluster
        { itemId = 5291, weight = 100 }, -- Somber Cluster
        { itemId = 5290, weight = 100 }, -- Startling Cluster
    },
    {
        { itemId =    0, weight = 200 }, -- Nothing
        { itemId = 5287, weight = 100 }, -- Bitter Cluster
        { itemId = 5286, weight = 100 }, -- Burning Cluster
        { itemId = 5288, weight = 100 }, -- Fleeting Cluster
        { itemId = 5293, weight = 100 }, -- Malevolent Cluster
        { itemId = 5289, weight = 100 }, -- Profane Cluster
        { itemId = 5292, weight = 100 }, -- Radiant Cluster
        { itemId = 5291, weight = 100 }, -- Somber Cluster
        { itemId = 5290, weight = 100 }, -- Startling Cluster
    },
    {
        { itemId =    0, weight = 500 }, -- Nothing
        { itemId = 1801, weight = 100 }, -- Solemn Vision (Guarding Earring)
        { itemId = 1804, weight = 100 }, -- Valiant Vision (Augmenting Earring)
        { itemId = 1806, weight = 100 }, -- Pretentious Vision (Elemental Earring)
        { itemId = 1809, weight = 100 }, -- Malicious Vision (Ninjutsu Earring)
        { itemId = 1812, weight = 100 }, -- Pristine Vision (Wind Earring)
    },
}

return content:register()
