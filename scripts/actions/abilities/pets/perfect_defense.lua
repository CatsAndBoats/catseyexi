-----------------------------------
-- Perfect Defense
-----------------------------------
---@type TAbilityPet
local abilityObject = {}

abilityObject.onAbilityCheck = function(player, target, ability)
    return 0, 0
end

abilityObject.onPetAbility = function(target, pet, skill, master, action)
    local power = 10000 * (master:getMP() / master:getMaxMP())
    local duration = 60

    if master ~= nil then
        local summoningSkill = master:getSkillLevel(xi.skill.SUMMONING_MAGIC)
        if summoningSkill > 600 then
            summoningSkill = 600
        end

        duration = 30 + summoningSkill / 20
        master:setMP(0)
        master:delStatusEffect(xi.effect.ASTRAL_FLOW)
    end

    target:delStatusEffect(xi.effect.PERFECT_DEFENSE)
    target:addStatusEffect(xi.effect.PERFECT_DEFENSE, power, 3, duration)

    -- Despawn Alexander after 6 seconds.
    pet:timer(6000, function()
        if master then
            master:despawnPet()
        end
    end)

    if target:getID() == action:getPrimaryTargetID() then
        skill:setMsg(xi.msg.basic.SKILL_GAIN_EFFECT_2)
    else
        skill:setMsg(xi.msg.basic.JA_GAIN_EFFECT)
    end

    return xi.effect.PERFECT_DEFENSE
end

return abilityObject
