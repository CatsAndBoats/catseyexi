-----------------------------------
-- Nightmare - Player's Avatar
-- AoE Sleep
-- Sleep that is not broken from DoT effects (any dmg source that doesn't break bind).
-- This version of it is from a player's avatar. The sleep is broken by most damage sources except other DoTs
--
-- see mobskills/nightmare.lua for full explanation
-----------------------------------
---@type TAbilityPet
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return xi.job_utils.summoner.canUseBloodPact(player, player:getPet(), target, ability)
end

abilityObject.onPetAbility = function(target, pet, petskill, summoner, action)
    xi.job_utils.summoner.onUseBloodPact(target, petskill, summoner, action)
    local duration  = 90
    local dotdamage = 2
    local dINT      = pet:getStat(xi.mod.INT) - target:getStat(xi.mod.INT)
    local bonus     = xi.summon.getSummoningSkillOverCap(pet)
    local tier      = 4
    local resist    = xi.mobskills.applyPlayerResistance(pet, -1, target, dINT, bonus, xi.element.DARK)
    if resist < 0.5 then
        petskill:setMsg(xi.msg.basic.JA_MISS_2) -- resist message
        return xi.effect.SLEEP_I
    end

    duration = math.floor(duration * resist)

    --No effect
    if
        target:hasImmunity(xi.immunity.DARK_SLEEP) or
        target:hasStatusEffect(xi.effect.SLEEP_I) or
        target:hasStatusEffect(xi.effect.SLEEP_II) or
        target:hasStatusEffect(xi.effect.LULLABY)
    then
        petskill:setMsg(xi.msg.basic.JA_NO_EFFECT_2)

    -- Apply sleep and bio
    elseif target:addStatusEffect(xi.effect.SLEEP_I, 1, 0, duration, 0, dotdamage, tier) then
        petskill:setMsg(xi.msg.basic.JA_GAIN_EFFECT)
        target:delStatusEffectSilent(xi.effect.BIO)
        target:addStatusEffect(xi.effect.BIO, dotdamage, 3, duration, 0, 10, 5)

    -- Miss
    else
        petskill:setMsg(xi.msg.basic.JA_MISS_2)
    end

    return xi.effect.SLEEP_I
end

return abilityObject
