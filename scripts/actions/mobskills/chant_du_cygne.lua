-----------------------------------
-- Chant du Cygne
-- Description: Delivers a threefold attack. Chance of critical hit varies with TP.
-- Type: Physical
-- Element: None
-- Stat Modifier: 80% DEX
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(mob, target, skill, action)
    local numhits = 3
    local accmod  = 1
    local ftp     = 1.6328125

    local info = xi.mobskills.mobPhysicalMove(mob, target, skill, numhits, accmod, ftp, xi.mobskills.physicalTpBonus.CRIT_VARIES, 0.15, 0.25, 0.40)
    local dmg = xi.mobskills.mobFinalAdjustments(info, mob, skill, target, xi.attackType.PHYSICAL, xi.damageType.SLASHING, info.hitslanded)

    target:takeDamage(dmg, mob, xi.attackType.PHYSICAL, xi.damageType.SLASHING)
    return dmg
end

return mobskillObject
