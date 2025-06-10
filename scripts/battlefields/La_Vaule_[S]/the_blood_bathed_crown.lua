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
    zoneId             = xi.zone.LA_VAULE_S,
    battlefieldId      = 3001,
    maxPlayers         = 18,
    allowTrusts        = false,
    levelCap           = 75,
    allowSubjob        = true,
    timeLimit          = utils.minutes(30),
    index              = 2,
    entryNpc           = '_2d1',
    exitNpcs           = { '_2d3', '_2d5', '_2d7' },
    experimental       = false,
    armouryCrates      = { ID.mob.BLOODCROWN_BRRADHOD + 5 },
    keyItemLostMessage = ID.text.PARTY_MEMBERS_HAVE_FALLEN + 16,
})

local requiredKIs =
{
    xi.ki.IMPERIAL_LINEAGE_CHAPTER_I,
    xi.ki.IMPERIAL_LINEAGE_CHAPTER_II,
    xi.ki.IMPERIAL_LINEAGE_CHAPTER_III,
    xi.ki.IMPERIAL_LINEAGE_CHAPTER_IV,
    xi.ki.IMPERIAL_LINEAGE_CHAPTER_V,
    xi.ki.IMPERIAL_LINEAGE_CHAPTER_VI,
    xi.ki.IMPERIAL_LINEAGE_CHAPTER_VII,
    xi.ki.IMPERIAL_LINEAGE_CHAPTER_VIII,
}

function content:onBattlefieldRegister(player, battlefield)
    -- Mark the registrant
    battlefield:setLocalVar("registrantId", player:getID())
end

function content:entryRequirement(player, npc, isRegistrant, trade)
    if isRegistrant then
        for _, ki in ipairs(requiredKIs) do
            if not player:hasKeyItem(ki) then
                return false
            end
        end
    end
    return true
end

function content:onBattlefieldEnter(player, battlefield)
    if player:getID() == battlefield:getLocalVar("registrantId") then
        for _, ki in ipairs(requiredKIs) do
            player:delKeyItem(ki)
        end
        player:messageSpecial(ID.text.PARTY_MEMBERS_HAVE_FALLEN + 16)
    end
end

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
    }
}

content.loot =
{
    {
        { item = 2763, weight = 40 }, -- Swamp Ore
        { item = 737,  weight = 40 }, -- Gold Ore
        { item = 1858, weight = 40 }, -- Moblumin Ingot
        { item = 2761, weight = 40 }, -- Feyweald Log
        { item = 703,  weight = 40 }, -- Petrified Log
        { item = 2831, weight = 40 }, -- Yellow Brass Chain
        { item = 1861, weight = 40 }, -- Moblin Sheepskin
        { item = 2518, weight = 40 }, -- Smilodon Hide
        { item = 844,  weight = 40 }, -- Phoenix Feather
        { item = 5651, weight = 40 }, -- Burdock
        { item = 6393, weight = 40 }, -- Porxie Pork
        { item = 738,  weight = 40 }, -- Platinum Ore
        { item = 2755, weight = 40 }, -- Ruszor Hide
        { item = 915,  weight = 40 }, -- Toad Oil
        { item = 1465, weight = 40 }, -- Granite
        { item = 1622, weight = 40 }, -- Bugard Tusk
        { item = 828,  weight = 40 }, -- Velvet Cloth
        { item = 1641, weight = 40 }, -- Fire Anima
        { item = 1644, weight = 40 }, -- Earth Anima
        { item = 1646, weight = 40 }, -- Water Anima
        { item = 1643, weight = 40 }, -- Wind Anima
        { item = 1642, weight = 40 }, -- Ice Anima
        { item = 1645, weight = 40 }, -- Lightning Anima
        { item = 1647, weight = 40 }, -- Light Anima
        { item = 1648, weight = 40 }, -- Dark Anima
    },
    {
        { item = 2763, weight = 40 }, -- Swamp Ore
        { item = 737,  weight = 40 }, -- Gold Ore
        { item = 1858, weight = 40 }, -- Moblumin Ingot
        { item = 2761, weight = 40 }, -- Feyweald Log
        { item = 703,  weight = 40 }, -- Petrified Log
        { item = 2831, weight = 40 }, -- Yellow Brass Chain
        { item = 1861, weight = 40 }, -- Moblin Sheepskin
        { item = 2518, weight = 40 }, -- Smilodon Hide
        { item = 844,  weight = 40 }, -- Phoenix Feather
        { item = 5651, weight = 40 }, -- Burdock
        { item = 6393, weight = 40 }, -- Porxie Pork
        { item = 738,  weight = 40 }, -- Platinum Ore
        { item = 2755, weight = 40 }, -- Ruszor Hide
        { item = 915,  weight = 40 }, -- Toad Oil
        { item = 1465, weight = 40 }, -- Granite
        { item = 1622, weight = 40 }, -- Bugard Tusk
        { item = 828,  weight = 40 }, -- Velvet Cloth
        { item = 1641, weight = 40 }, -- Fire Anima
        { item = 1644, weight = 40 }, -- Earth Anima
        { item = 1646, weight = 40 }, -- Water Anima
        { item = 1643, weight = 40 }, -- Wind Anima
        { item = 1642, weight = 40 }, -- Ice Anima
        { item = 1645, weight = 40 }, -- Lightning Anima
        { item = 1647, weight = 40 }, -- Light Anima
        { item = 1648, weight = 40 }, -- Dark Anima
    },
    {
        { item = xi.item.APEX_TOKEN,     weight = 334 },
        { item = xi.item.PINNACLE_TOKEN, weight = 333 },
        { item = xi.item.APOGEE_TOKEN,   weight = 333 },
    },
    {
        { item = xi.item.APEX_TOKEN,     weight = 333 },
        { item = xi.item.PINNACLE_TOKEN, weight = 334 },
        { item = xi.item.APOGEE_TOKEN,   weight = 333 },
    },
    {
        { item = xi.item.NONE,           weight = 700 },
        { item = xi.item.APEX_TOKEN,     weight = 100 },
        { item = xi.item.PINNACLE_TOKEN, weight = 100 },
        { item = xi.item.APOGEE_TOKEN,   weight = 100 },
    },
    {
        { item = xi.item.NONE,           weight = 700 },
        { item = xi.item.APEX_TOKEN,     weight = 100 },
        { item = xi.item.PINNACLE_TOKEN, weight = 100 },
        { item = xi.item.APOGEE_TOKEN,   weight = 100 },
    },
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
        { item = xi.item.PINNACLE_CELATA,   weight = 60 },
        { item = xi.item.PINNACLE_CUIRASS,  weight = 60 },
        { item = xi.item.PINNACLE_DASTANAS, weight = 60 },
        { item = xi.item.PINNACLE_CUISSES,  weight = 60 },
        { item = xi.item.PINNACLE_SABATONS, weight = 60 },
        { item = xi.item.APOGEE_PETASOS,    weight = 80 },
        { item = xi.item.APOGEE_COAT,       weight = 80 },
        { item = xi.item.APOGEE_CUFFS,      weight = 80 },
        { item = xi.item.APOGEE_TONBAN,     weight = 80 },
        { item = xi.item.APOGEE_SABOTS,     weight = 80 },
        { item = xi.item.APEX_HATSUBURI,    weight = 60 },
        { item = xi.item.APEX_TOGI,         weight = 60 },
        { item = xi.item.APEX_KOTE,         weight = 60 },
        { item = xi.item.APEX_HAIDATE,      weight = 60 },
        { item = xi.item.APEX_SUNE_ATE,     weight = 60 },
    },
    -- original drops
    {
        { item = xi.item.NONE,                 weight = 250 },
        { item = xi.item.SUPREMACY_EARRING,    weight = 375 },
        { item = xi.item.GNADBHODS_HELM,       weight = 375 },
    },
    {
        { item = xi.item.NONE,     weight = 250 },
        { item = 15831,            weight = 250 }, -- fenian ring
        { item = 16356,            weight = 250 }, -- nimue's tights
        { item = 17758,            weight = 250 }, -- ruler
    },
}

return content:register()
