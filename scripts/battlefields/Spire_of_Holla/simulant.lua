-----------------------------------
-- ENM: Simulant
-- Spire of Holla
-----------------------------------
require('scripts/missions/cop/helpers')
local spireofHollaID = zones[xi.zone.SPIRE_OF_HOLLA]
-----------------------------------

local content = Battlefield:new({
    zoneId           = xi.zone.SPIRE_OF_HOLLA,
    battlefieldId    = xi.battlefield.id.SIMULANT,
    maxPlayers       = 18,
    levelCap         = 30,
    timeLimit        = utils.minutes(30),
    index            = 1,
    entryNpc         = '_0h0',
    exitNpcs         = { '_0j1', '_0j2', '_0j3' },
    requiredKeyItems = { xi.ki.CENSER_OF_ABANDONMENT, message = spireofHollaID.text.THE_PARTY_WILL_BE_REMOVED + 8 },
    grantXP          = 1500,
    armouryCrates    =
    {
        spireofHollaID.mob.WREAKER + 7,
        spireofHollaID.mob.WREAKER + 12,
        spireofHollaID.mob.WREAKER + 17,
    },
})

function content:entryRequirement(player, npc, isRegistrant, trade)
    local currentRequirements = player:hasCompletedMission(xi.mission.log_id.COP, xi.mission.id.cop.THE_MOTHERCRYSTALS)
    return currentRequirements
end

function content:checkSkipCutscene(player)
    return player:hasCompletedMission(xi.mission.log_id.COP, xi.mission.id.cop.THE_MOTHERCRYSTALS)
end

content:addEssentialMobs({ 'Cogitator' })

content.groups =
{
    {
        mobs = { 'Cogitator' },
        superlink = true,
        spawned = true,
        death = utils.bind(content.handleAllMonstersDefeated, content),
    },
    {
        mobs = { 'Weeper' },
        superlink = true,
        spawned = false,
    },
}

content.loot =
{
    {
        { itemId =    0, weight = 200 }, --  Nothing
        { itemId = 5287, weight = 100 }, --  Bitter Cluster
        { itemId = 5286, weight = 100 }, --  Burning Cluster
        { itemId = 5288, weight = 100 }, --  Fleeting Cluster
        { itemId = 5289, weight = 100 }, --  Profane Cluster
        { itemId = 5290, weight = 100 }, --  Startling Cluster
        { itemId = 5291, weight = 100 }, --  Somber Cluster
        { itemId = 5292, weight = 100 }, --  Radiant Cluster
        { itemId = 5293, weight = 100 }, --  Malevolent Cluster
    },
    {
        { itemId =    0, weight = 200 }, --  Nothing
        { itemId = 5287, weight = 100 }, --  Bitter Cluster
        { itemId = 5286, weight = 100 }, --  Burning Cluster
        { itemId = 5288, weight = 100 }, --  Fleeting Cluster
        { itemId = 5293, weight = 100 }, --  Malevolent Cluster
        { itemId = 5289, weight = 100 }, --  Profane Cluster
        { itemId = 5292, weight = 100 }, --  Radiant Cluster
        { itemId = 5291, weight = 100 }, --  Somber Cluster
        { itemId = 5290, weight = 100 }, --  Startling Cluster
    },
    {
        { itemId =    0, weight = 200 }, --  Nothing
        { itemId = 5287, weight = 100 }, --  Bitter Cluster
        { itemId = 5286, weight = 100 }, --  Burning Cluster
        { itemId = 5288, weight = 100 }, --  Fleeting Cluster
        { itemId = 5293, weight = 100 }, --  Malevolent Cluster
        { itemId = 5289, weight = 100 }, --  Profane Cluster
        { itemId = 5292, weight = 100 }, --  Radiant Cluster
        { itemId = 5291, weight = 100 }, --  Somber Cluster
        { itemId = 5290, weight = 100 }, --  Startling Cluster
    },
    {
        { itemId =    0, weight = 500 }, --  Nothing
        { itemId = 1798, weight = 100 }, --  Vernal Vision (Evasion Earring)
        { itemId = 1799, weight = 100 }, --  Punctilious Vision (Parrying Earring)
        { itemId = 1802, weight = 100 }, --  Audacious Vision (Divine Earring)
        { itemId = 1807, weight = 100 }, --  Vivid Vision (Healing Earring)
        { itemId = 1810, weight = 100 }, --  Endearing Vision (Singing Earring)
    },
}

return content:register()
