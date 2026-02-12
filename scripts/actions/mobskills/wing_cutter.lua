-----------------------------------
-- Wing Cutter
-- Deals Wind damage to targets in a fan-shaped area of effect.
-- TODO: Capture Wing Cutter in Nightmare Dynamis, was unable to verify a difference. fTP looked similar.
-- Type: Magical (Wind)
-- Utsusemi/Blink absorb: Ignores shadows
-- Range: Melee
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local info   = xi.mobskills.mobMagicalMove(mob, target, skill, mob:getMainLvl() + 2, xi.element.WIND, 3, xi.mobskills.magicalTpBonus.MAB_BONUS, 1)
    local damage = xi.mobskills.mobFinalAdjustments(info, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.WIND, xi.mobskills.shadowBehavior.IGNORE_SHADOWS)

    target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.WIND)
    return damage
end

return mobskillObject
