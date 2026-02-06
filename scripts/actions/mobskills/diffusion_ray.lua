-----------------------------------
-- Diffusion Ray
-- Family: Chariots
-- Description: Deals damage to enemies within a fan-shaped area originating from the caster.
-- Type: Magical Light (Element)
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.percentMultipier  = 0.20
    params.element           = xi.element.LIGHT
    params.damageCap         = 500
    params.bonusDamage       = 0
    params.mAccuracyBonus    = { 0, 0, 0 }
    params.resistStat        = xi.mod.MND

    local info = xi.mobskills.mobBreathMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info, mob, skill, target, xi.attackType.BREATH, xi.damageType.LIGHT, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, 1)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.BREATH, xi.damageType.LIGHT)
    end

    return damage
end

return mobskillObject
