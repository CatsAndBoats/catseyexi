-----------------------------------
--  Malevolent Blessing
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local info = xi.mobskills.mobMagicalMove(mob, target, skill, mob:getMainLvl() + 2, xi.element.DARK, 3, xi.mobskills.magicalTpBonus.MAB_BONUS, 1)
    local damage = xi.mobskills.mobFinalAdjustments(info, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.DARK, xi.mobskills.shadowBehavior.NUMSHADOWS_2)

    target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.DARK)

    xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.CURSE_I, 35, 0, 45)

    return damage
end

return mobskillObject
