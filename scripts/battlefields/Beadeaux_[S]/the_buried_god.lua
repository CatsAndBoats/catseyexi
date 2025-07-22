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
    zoneId             = xi.zone.BEADEAUX_S,
    battlefieldId      = 3002,
    maxPlayers         = 18,
    allowTrusts        = false,
    levelCap           = 75,
    allowSubjob        = true,
    timeLimit          = utils.minutes(30),
    index              = 1,
    entryNpc           = '_2k5',
    exitNpcs           = { '_2k6', '_2k8', '_2ka' },
    experimental       = false,
    armouryCrates      = { ID.mob.ZADHA_ADAMANTKING + 5 },
    keyItemLostMessage = ID.text.PARTY_MEMBERS_HAVE_FALLEN + 16,
})

local requiredKIs =
{
    xi.ki.THE_WORDS_OF_DONHU_I,
    xi.ki.THE_WORDS_OF_DONHU_II,
    xi.ki.THE_WORDS_OF_DONHU_III,
    xi.ki.THE_WORDS_OF_DONHU_IV,
    xi.ki.THE_WORDS_OF_DONHU_V,
    xi.ki.THE_WORDS_OF_DONHU_VI,
    xi.ki.THE_WORDS_OF_DONHU_VII,
    xi.ki.THE_WORDS_OF_DONHU_VIII,
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
                ID.mob.ZADHA_ADAMANTKING,
                ID.mob.ZADHA_ADAMANTKING + 1,
                ID.mob.ZADHA_ADAMANTKING + 2,
                ID.mob.ZADHA_ADAMANTKING + 3,
                ID.mob.ZADHA_ADAMANTKING + 4,
            },
        },

        superlink = true,
        allDeath  = utils.bind(content.handleAllMonstersDefeated, content),
    }
}

content.loot =
{
    {
        { item = xi.item.GIL, weight = 1000, amount = 1000000 },
    },
    {
        { item = xi.item.APEX_TOKEN,     weight = 333 },
        { item = xi.item.PINNACLE_TOKEN, weight = 333 },
        { item = xi.item.APOGEE_TOKEN,   weight = 334 },
    },
    {
        { item = xi.item.APEX_TOKEN,     weight = 334 },
        { item = xi.item.PINNACLE_TOKEN, weight = 333 },
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
        { item = xi.item.ASCENSION_STONE,   weight = 500 },
        { item = xi.item.PINNACLE_CELATA,   weight = 40 },
        { item = xi.item.PINNACLE_CUIRASS,  weight = 40 },
        { item = xi.item.PINNACLE_DASTANAS, weight = 40 },
        { item = xi.item.PINNACLE_CUISSES,  weight = 40 },
        { item = xi.item.PINNACLE_SABATONS, weight = 40 },
        { item = xi.item.APOGEE_PETASOS,    weight = 30 },
        { item = xi.item.APOGEE_COAT,       weight = 30 },
        { item = xi.item.APOGEE_CUFFS,      weight = 30 },
        { item = xi.item.APOGEE_TONBAN,     weight = 30 },
        { item = xi.item.APOGEE_SABOTS,     weight = 30 },
        { item = xi.item.APEX_HATSUBURI,    weight = 30 },
        { item = xi.item.APEX_TOGI,         weight = 30 },
        { item = xi.item.APEX_KOTE,         weight = 30 },
        { item = xi.item.APEX_HAIDATE,      weight = 30 },
        { item = xi.item.APEX_SUNE_ATE,     weight = 30 },
    },
    {
        { item = xi.item.PINNACLE_CELATA,   weight = 200 },
        { item = xi.item.PINNACLE_CUIRASS,  weight = 200 },
        { item = xi.item.PINNACLE_DASTANAS, weight = 200 },
        { item = xi.item.PINNACLE_CUISSES,  weight = 200 },
        { item = xi.item.PINNACLE_SABATONS, weight = 200 },
    },
    {
        { item = xi.item.PINNACLE_CELATA,   weight = 80 },
        { item = xi.item.PINNACLE_CUIRASS,  weight = 80 },
        { item = xi.item.PINNACLE_DASTANAS, weight = 80 },
        { item = xi.item.PINNACLE_CUISSES,  weight = 80 },
        { item = xi.item.PINNACLE_SABATONS, weight = 80 },
        { item = xi.item.APOGEE_PETASOS,    weight = 60 },
        { item = xi.item.APOGEE_COAT,       weight = 60 },
        { item = xi.item.APOGEE_CUFFS,      weight = 60 },
        { item = xi.item.APOGEE_TONBAN,     weight = 60 },
        { item = xi.item.APOGEE_SABOTS,     weight = 60 },
        { item = xi.item.APEX_HATSUBURI,    weight = 60 },
        { item = xi.item.APEX_TOGI,         weight = 60 },
        { item = xi.item.APEX_KOTE,         weight = 60 },
        { item = xi.item.APEX_HAIDATE,      weight = 60 },
        { item = xi.item.APEX_SUNE_ATE,     weight = 60 },
    },
    -- original drops
    {
        { item = xi.item.PARAMOUNT_EARRING,    weight = 500 },
        { item = xi.item.ZHAGOS_BARBUT,        weight = 500 },
    },
    {
        { item = 15832,            weight = 333 }, -- headsmans ring
        { item = 15034,            weight = 333 }, -- stone mufflers
        { item = 18501,            weight = 334 }, -- seismic axe
    },
}

return content:register()
