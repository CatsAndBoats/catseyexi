-----------------------------------
-- Sand Breath
-- Family: Pet Wyverns
-- Description: Deals Earth breath damage to enemies within a fan-shaped area originating from the caster.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.percentMultipier  = 0.13
    params.element           = xi.element.EARTH
    params.damageCap         = 400 -- TODO: Capture cap
    params.bonusDamage       = 0
    params.mAccuracyBonus    = { 0, 0, 0 }
    params.resistStat        = xi.mod.INT

    local info = xi.mobskills.mobBreathMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info, mob, skill, target, xi.attackType.BREATH, xi.damageType.EARTH, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, 1)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.BREATH, xi.damageType.EARTH)
    end

    return damage
end

return mobskillObject
