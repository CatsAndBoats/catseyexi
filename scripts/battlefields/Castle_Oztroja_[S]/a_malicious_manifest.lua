-----------------------------------
-- A Malicious Manifest
-- Stronghold Battlefield
-----------------------------------
local ID = zones[xi.zone.CASTLE_OZTROJA_S]
-----------------------------------
-- ID.text.PARTY_MEMBERS_HAVE_FALLEN = 8040
ID.text.MEMBERS_OF_YOUR_ALLIANCE      = ID.text.PARTY_MEMBERS_HAVE_FALLEN - 38 -- 7998
ID.text.TIME_LIMIT_FOR_THIS_BATTLE_IS = ID.text.PARTY_MEMBERS_HAVE_FALLEN - 36 -- 8004
ID.text.ENTERING_THE_BATTLEFIELD_FOR  = ID.text.PARTY_MEMBERS_HAVE_FALLEN + 29 -- 8069
ID.text.TIME_IN_THE_BATTLEFIELD_IS_UP = ID.text.PARTY_MEMBERS_HAVE_FALLEN + 55 -- 8095
ID.mob.TZEE_XICU_THE_MANIFEST         = ID.mob.SUU_XICU_THE_CANTABILE + 24

local content = Battlefield:new({
    zoneId             = xi.zone.CASTLE_OZTROJA_S,
    battlefieldId      = 3000,
    maxPlayers         = 18,
    allowTrusts        = false,
    levelCap           = 75,
    allowSubjob        = true,
    timeLimit          = utils.minutes(30),
    index              = 1,
    grantXP            = 2000,
    entryNpc           = '_2r8',
    exitNpc            = { '_2r8' },
    experimental       = false,
    armouryCrates      = { ID.mob.TZEE_XICU_THE_MANIFEST + 5 },
    keyItemLostMessage = ID.text.THE_PARTY_WILL_BE_REMOVED + 9,
})

local requiredKIs =
{
    xi.ki.HABALOS_ECLOGUE_VERSE_I,
    xi.ki.HABALOS_ECLOGUE_VERSE_II,
    xi.ki.HABALOS_ECLOGUE_VERSE_III,
    xi.ki.HABALOS_ECLOGUE_VERSE_IV,
    xi.ki.HABALOS_ECLOGUE_VERSE_V,
    xi.ki.HABALOS_ECLOGUE_VERSE_VI,
    xi.ki.HABALOS_ECLOGUE_VERSE_VII,
    xi.ki.HABALOS_ECLOGUE_VERSE_VIII,
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
        player:messageSpecial(ID.text.THE_PARTY_WILL_BE_REMOVED + 9)
    end
end

content.groups =
{
    {
        mobIds =
        {
            { 
                ID.mob.TZEE_XICU_THE_MANIFEST, 
                ID.mob.TZEE_XICU_THE_MANIFEST + 1,
                ID.mob.TZEE_XICU_THE_MANIFEST + 2,
                ID.mob.TZEE_XICU_THE_MANIFEST + 3,
                ID.mob.TZEE_XICU_THE_MANIFEST + 4,
            },
        },

        superlink = true,
        allDeath  = utils.bind(content.handleAllMonstersDefeated, content),
    },
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
        { item = xi.item.ASCENSION_STONE,   weight = 500 },
        { item = xi.item.PINNACLE_CELATA,   weight = 30 },
        { item = xi.item.PINNACLE_CUIRASS,  weight = 30 },
        { item = xi.item.PINNACLE_DASTANAS, weight = 30 },
        { item = xi.item.PINNACLE_CUISSES,  weight = 30 },
        { item = xi.item.PINNACLE_SABATONS, weight = 30 },
        { item = xi.item.APOGEE_PETASOS,    weight = 30 },
        { item = xi.item.APOGEE_COAT,       weight = 30 },
        { item = xi.item.APOGEE_CUFFS,      weight = 30 },
        { item = xi.item.APOGEE_TONBAN,     weight = 30 },
        { item = xi.item.APOGEE_SABOTS,     weight = 30 },
        { item = xi.item.APEX_HATSUBURI,    weight = 40 },
        { item = xi.item.APEX_TOGI,         weight = 40 },
        { item = xi.item.APEX_KOTE,         weight = 40 },
        { item = xi.item.APEX_HAIDATE,      weight = 40 },
        { item = xi.item.APEX_SUNE_ATE,     weight = 40 },
    },
    {
        { item = xi.item.APEX_HATSUBURI,   weight = 200 },
        { item = xi.item.APEX_TOGI,        weight = 200 },
        { item = xi.item.APEX_KOTE,        weight = 200 },
        { item = xi.item.APEX_HAIDATE,     weight = 200 },
        { item = xi.item.APEX_SUNE_ATE,    weight = 200 },
    },
    {
        { item = xi.item.PINNACLE_CELATA,   weight = 60 },
        { item = xi.item.PINNACLE_CUIRASS,  weight = 60 },
        { item = xi.item.PINNACLE_DASTANAS, weight = 60 },
        { item = xi.item.PINNACLE_CUISSES,  weight = 60 },
        { item = xi.item.PINNACLE_SABATONS, weight = 60 },
        { item = xi.item.APOGEE_PETASOS,    weight = 60 },
        { item = xi.item.APOGEE_COAT,       weight = 60 },
        { item = xi.item.APOGEE_CUFFS,      weight = 60 },
        { item = xi.item.APOGEE_TONBAN,     weight = 60 },
        { item = xi.item.APOGEE_SABOTS,     weight = 60 },
        { item = xi.item.APEX_HATSUBURI,    weight = 80 },
        { item = xi.item.APEX_TOGI,         weight = 80 },
        { item = xi.item.APEX_KOTE,         weight = 80 },
        { item = xi.item.APEX_HAIDATE,      weight = 80 },
        { item = xi.item.APEX_SUNE_ATE,     weight = 80 },
    },
    -- original drops
    {
        { item = xi.item.BRILLIANT_EARRING,    weight = 500 },
        { item = xi.item.REE_HABALOS_HEADGEAR, weight = 500 },
    },
    {
        { item = 15833,            weight = 333 }, -- diverters ring
        { item = 11392,            weight = 333 }, -- koschei crackows
        { item = xi.item.PRESTER,  weight = 334 }, -- prester
    },
}

return content:register()
