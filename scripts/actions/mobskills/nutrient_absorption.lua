-----------------------------------
-- Nutrient Absorption
-- Family: Euvhi
-- Steals HP from a single target.
-- Type: Drain
-- Utsusemi/Blink absorb: 1 shadow
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    -- Damage is 300 + dINT
    local info = xi.mobskills.mobMagicalMove(mob, target, skill, 300, xi.element.DARK, 1, xi.mobskills.magicalTpBonus.NO_EFFECT)
    local damage = xi.mobskills.mobFinalAdjustments(info, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.DARK, xi.mobskills.shadowBehavior.NUMSHADOWS_1)

    skill:setMsg(xi.mobskills.mobPhysicalDrainMove(mob, target, skill, xi.mobskills.drainType.HP, damage))

    return damage
end

return mobskillObject
