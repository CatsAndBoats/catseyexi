-----------------------------------
-- Geush Urvan Auto Attack
-- Deals damage to a single target. Additional effect: Knockback but only on hit.
-- Used by Geush Urvan in Uleguerand Range.
-- To do: Make knockback only apply on successful hit.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(mob, target, skill, action)
    local numhits = 1
    local accmod  = 1
    local ftp     = 8.0
    local info    = xi.mobskills.mobPhysicalMove(mob, target, skill, numhits, accmod, ftp, xi.mobskills.physicalTpBonus.NO_EFFECT)
    local dmg     = xi.mobskills.mobFinalAdjustments(info, mob, skill, target, xi.attackType.PHYSICAL, xi.damageType.BLUNT, xi.mobskills.shadowBehavior.WIPE_SHADOWS)
    target:takeDamage(dmg, mob, xi.attackType.PHYSICAL, xi.damageType.BLUNT)

    if dmg > 0 then
        skill:setMsg(xi.msg.basic.HIT_DMG)
    else
        skill:setMsg(xi.msg.basic.HIT_MISS)
    end

    return dmg
end

return mobskillObject
