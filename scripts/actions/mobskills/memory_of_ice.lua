-----------------------------------
--  Memory Of Ice
--  Description: Deals ice damage.
--  Type: Magical (Ice)
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local ftp = 3
    local info = xi.mobskills.mobMagicalMove(mob, target, skill, mob:getMainLvl() + 2, xi.element.ICE, ftp, xi.mobskills.magicalTpBonus.NO_EFFECT)
    local damage = xi.mobskills.mobFinalAdjustments(info, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.ICE, xi.mobskills.shadowBehavior.WIPE_SHADOWS)

    target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.ICE)

    return damage
end

return mobskillObject
