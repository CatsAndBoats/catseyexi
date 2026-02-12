-----------------------------------
-- Counterspore
-- Deals Water damage to a single target from up to 15 yalms away. Additional effect: Knockback
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local dmgMod = 3.0

    local info = xi.mobskills.mobMagicalMove(mob, target, skill, mob:getMainLvl() + 2, xi.element.WATER, dmgMod, xi.mobskills.magicalTpBonus.NO_EFFECT)
    local damage = xi.mobskills.mobFinalAdjustments(info, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.WATER, xi.mobskills.shadowBehavior.IGNORE_SHADOWS)

    target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.WATER)

    skill:setMsg(xi.msg.basic.HIT_DMG)

    return damage
end

return mobskillObject
