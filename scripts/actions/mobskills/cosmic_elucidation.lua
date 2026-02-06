-----------------------------------
--  Cosmic Elucidation
--  Description: Cosmic Elucidation inflicts heavy AOE damage to everyone in the battle.
--  Type:
--  Utsusemi/Blink absorb: Ignores shadows
--  Range:
--  Notes: Ejects all combatants from the battlefield, resulting in a failure.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 1 -- only scripted use
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local info = xi.mobskills.mobMagicalMove(mob, target, skill, mob:getMainLvl() + 2, xi.element.LIGHT, 14, xi.mobskills.magicalTpBonus.NO_EFFECT, 1)
    local damage = xi.mobskills.mobFinalAdjustments(info, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.LIGHT, 0)

    target:takeDamage(damage, mob, xi.attackType.SPECIAL, xi.damageType.ELEMENTAL)
    skill:setMsg(xi.msg.basic.SKILLCHAIN_COSMIC_ELUCIDATION)

    return damage
end

return mobskillObject
