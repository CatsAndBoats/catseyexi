-----------------------------------
-- Geotic Breath
-- Family: Wyrms
-- Description: Deals Earth damage to enemies within a fan-shaped area.
-- Notes: Used by Ouryu.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    if mob:hasStatusEffect(xi.effect.INVINCIBLE) then
        return 1
    elseif not target:isInfront(mob, 128) then
        return 1
    elseif mob:getAnimationSub() == 1 then -- Not used while flying.
        return 1
    end

    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.percentMultipier  = 0.15
    params.element           = xi.element.EARTH
    params.damageCap         = 1150
    params.bonusDamage       = 0
    params.mAccuracyBonus    = { 0, 0, 0 }
    params.resistStat        = xi.mod.INT

    local info = xi.mobskills.mobBreathMove(mob, target, skill, params)
    info.damage = utils.conalDamageAdjustment(mob, target, skill, info.damage, 0.2)
    local damage = xi.mobskills.mobFinalAdjustments(info, mob, skill, target, xi.attackType.BREATH, xi.damageType.EARTH, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, 1)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.BREATH, xi.damageType.EARTH)
    end

    return damage
end

return mobskillObject
