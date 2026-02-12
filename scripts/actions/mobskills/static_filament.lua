-----------------------------------
--  Static Filament
--  Zedi, while in Animation form 2 (Bars)
--  Blinkable 1-2 hit, addtional effect stun on hit.
-----------------------------------
---@type TMobSkill
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local info = xi.mobskills.mobMagicalMove(mob, target, skill, mob:getMainLvl() + 2, xi.element.THUNDER, math.random(1, 2), xi.mobskills.magicalTpBonus.MAB_BONUS, 1)
    local damage = xi.mobskills.mobFinalAdjustments(info, mob, skill, target, xi.attackType.MAGICAL, xi.damageType.THUNDER, xi.mobskills.shadowBehavior.NUMSHADOWS_2)

    target:takeDamage(damage, mob, xi.attackType.MAGICAL, xi.damageType.THUNDER)

    xi.mobskills.mobStatusEffectMove(mob, target, xi.effect.STUN, 1, 0, 4)

    return damage
end

return mobskillObject
