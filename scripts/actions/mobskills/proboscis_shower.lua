-----------------------------------
-- Proboscis Shower
-- Description: Restores HP.
-- Copied from Healing Breeze: needs retail calculations
-----------------------------------
local mobskillObject = {}

mobskillObject.onMobSkillCheck = function(target, mob, skill)
    return 0
end

mobskillObject.onMobWeaponSkill = function(target, mob, skill)
    local potency = skill:getParam()

    if potency == 0 then
        potency = 13
    end

    potency = potency - math.random(0, potency / 4)

    skill:setMsg(xi.msg.basic.SELF_HEAL)
	
	if GetMobByID(16986429) then
	    return xi.mobskills.mobHealMove(mob, mob:getMaxHP() * potency / 1000)
	else
        return xi.mobskills.mobHealMove(mob, mob:getMaxHP() * potency / 100)
    end	
end

return mobskillObject
