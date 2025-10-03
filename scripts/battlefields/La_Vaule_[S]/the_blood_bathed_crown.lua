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
        { itemId = xi.item.GIL, weight = 1000, amount = 1000000 },
    },
    {
        { itemId = xi.item.APEX_TOKEN,     weight = 334 },
        { itemId = xi.item.PINNACLE_TOKEN, weight = 333 },
        { itemId = xi.item.APOGEE_TOKEN,   weight = 333 },
    },
    {
        { itemId = xi.item.APEX_TOKEN,     weight = 333 },
        { itemId = xi.item.PINNACLE_TOKEN, weight = 334 },
        { itemId = xi.item.APOGEE_TOKEN,   weight = 333 },
    },
    {
        { itemId = xi.item.NONE,           weight = 700 },
        { itemId = xi.item.APEX_TOKEN,     weight = 100 },
        { itemId = xi.item.PINNACLE_TOKEN, weight = 100 },
        { itemId = xi.item.APOGEE_TOKEN,   weight = 100 },
    },
    {
        { itemId = xi.item.NONE,           weight = 700 },
        { itemId = xi.item.APEX_TOKEN,     weight = 100 },
        { itemId = xi.item.PINNACLE_TOKEN, weight = 100 },
        { itemId = xi.item.APOGEE_TOKEN,   weight = 100 },
    },
    {
        { itemId = xi.item.ASCENSION_STONE, weight = 1000 },
    },
    {
        { itemId = xi.item.ASCENSION_STONE,   weight = 500 },
        { itemId = xi.item.PINNACLE_CELATA,   weight = 30 },
        { itemId = xi.item.PINNACLE_CUIRASS,  weight = 30 },
        { itemId = xi.item.PINNACLE_DASTANAS, weight = 30 },
        { itemId = xi.item.PINNACLE_CUISSES,  weight = 30 },
        { itemId = xi.item.PINNACLE_SABATONS, weight = 30 },
        { itemId = xi.item.APOGEE_PETASOS,    weight = 40 },
        { itemId = xi.item.APOGEE_COAT,       weight = 40 },
        { itemId = xi.item.APOGEE_CUFFS,      weight = 40 },
        { itemId = xi.item.APOGEE_TONBAN,     weight = 40 },
        { itemId = xi.item.APOGEE_SABOTS,     weight = 40 },
        { itemId = xi.item.APEX_HATSUBURI,    weight = 30 },
        { itemId = xi.item.APEX_TOGI,         weight = 30 },
        { itemId = xi.item.APEX_KOTE,         weight = 30 },
        { itemId = xi.item.APEX_HAIDATE,      weight = 30 },
        { itemId = xi.item.APEX_SUNE_ATE,     weight = 30 },
    },
    {
        { itemId = xi.item.APOGEE_PETASOS,    weight = 200 },
        { itemId = xi.item.APOGEE_COAT,       weight = 200 },
        { itemId = xi.item.APOGEE_CUFFS,      weight = 200 },
        { itemId = xi.item.APOGEE_TONBAN,     weight = 200 },
        { itemId = xi.item.APOGEE_SABOTS,     weight = 200 },
    },
    {
        { itemId = xi.item.PINNACLE_CELATA,   weight = 60 },
        { itemId = xi.item.PINNACLE_CUIRASS,  weight = 60 },
        { itemId = xi.item.PINNACLE_DASTANAS, weight = 60 },
        { itemId = xi.item.PINNACLE_CUISSES,  weight = 60 },
        { itemId = xi.item.PINNACLE_SABATONS, weight = 60 },
        { itemId = xi.item.APOGEE_PETASOS,    weight = 80 },
        { itemId = xi.item.APOGEE_COAT,       weight = 80 },
        { itemId = xi.item.APOGEE_CUFFS,      weight = 80 },
        { itemId = xi.item.APOGEE_TONBAN,     weight = 80 },
        { itemId = xi.item.APOGEE_SABOTS,     weight = 80 },
        { itemId = xi.item.APEX_HATSUBURI,    weight = 60 },
        { itemId = xi.item.APEX_TOGI,         weight = 60 },
        { itemId = xi.item.APEX_KOTE,         weight = 60 },
        { itemId = xi.item.APEX_HAIDATE,      weight = 60 },
        { itemId = xi.item.APEX_SUNE_ATE,     weight = 60 },
    },
    -- original drops
    {
        { itemId = xi.item.SUPREMACY_EARRING,    weight = 500 },
        { itemId = xi.item.GNADBHODS_HELM,       weight = 500 },
    },
    {
        { itemId = 15831,            weight = 333 }, -- fenian ring
        { itemId = 16356,            weight = 333 }, -- nimue's tights
        { itemId = 17758,            weight = 334 }, -- ruler
    },
}

return content:register()
