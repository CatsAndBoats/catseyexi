-----------------------------------
-- Magma Fan
-- Family: Wamoura
-- Description: Deals Fire damage to enemies within a fan-shaped area originating from the caster.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local params = {}

    params.percentMultipier  = 0.0833
    params.element           = xi.element.FIRE
    params.damageCap         = 600 -- TODO: Capture cap
    params.bonusDamage       = 0
    params.mAccuracyBonus    = { 0, 0, 0 }
    params.resistStat        = xi.mod.INT
    -- https://docs.google.com/spreadsheets/d/1YBoveP-weMdidrirY-vPDzHyxbEI2ryECINlfCnFkLI/edit?pli=1&gid=57955395#gid=57955395&range=A566
    -- TODO: Spreadsheet states this can crit.

    local info = xi.mobskills.mobBreathMove(mob, target, skill, params)
    local damage = xi.mobskills.mobFinalAdjustments(info, mob, skill, target, xi.attackType.BREATH, xi.damageType.FIRE, xi.mobskills.shadowBehavior.IGNORE_SHADOWS, 1)

    if not xi.mobskills.hasMissMessage(mob, target, skill, damage) then
        target:takeDamage(damage, mob, xi.attackType.BREATH, xi.damageType.FIRE)
    end

    return damage
end

return mobskillObject
