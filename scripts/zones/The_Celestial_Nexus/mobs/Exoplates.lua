-----------------------------------
-- Area: The Celestial Nexus
--  Mob: Exoplates
-- Zilart Mission 16 BCNM Fight
-----------------------------------
---@type TMobEntity
local entity = {}

entity.onMobInitialize = function(mob)
    mob:addImmunity(xi.immunity.SILENCE)
    mob:addImmunity(xi.immunity.PETRIFY)
    mob:addImmunity(xi.immunity.LIGHT_SLEEP)
    mob:addImmunity(xi.immunity.DARK_SLEEP)
    mob:addMod(xi.mod.REGAIN, 50)
end

entity.onMobSpawn = function(mob)
    mob:setAnimationSub(0)
    mob:setAutoAttackEnabled(false)
    mob:setUnkillable(true)
end

entity.onMobFight = function(mob, target)
    local animationSub = mob:getAnimationSub()
    local mobHPP       = mob:getHPP()
    local shifts       = mob:getLocalVar('shifts')
    local shiftTime    = mob:getLocalVar('shiftTime')
    local battleTime   = mob:getBattleTime()

    if animationSub == 0 and mobHPP <= 66 then
        if shifts == 0 then
            mob:useMobAbility(xi.mobSkill.PHASE_SHIFT_1_EXOPLATES)
            mob:setLocalVar('shifts', shifts + 1)
            mob:setLocalVar('shiftTime', battleTime + 5)
        elseif battleTime >= shiftTime then
            mob:setAnimationSub(1)
        end
    elseif animationSub == 1 and mobHPP <= 33 then
        if shifts == 1 then
            mob:useMobAbility(xi.mobSkill.PHASE_SHIFT_2_EXOPLATES)
            mob:setLocalVar('shifts', shifts + 1)
            mob:setLocalVar('shiftTime', battleTime + 5)
        elseif battleTime >= shiftTime then
            mob:setAnimationSub(2)
        end
    elseif animationSub == 2 and mobHPP <= 2 then
        if shifts == 2 then
            mob:useMobAbility(xi.mobSkill.PHASE_SHIFT_2_EXOPLATES)
            mob:setLocalVar('shifts', shifts + 1)
        end
    end
end

entity.onMobWeaponSkill = function(target, mob, skill)
    if skill:getID() == xi.mobSkill.PHASE_SHIFT_3_EXOPLATES then
        mob:setUnkillable(false)
    end
end

entity.onMobDeath = function(mob, player, optParams)
    local ealdnarche = GetMobByID(mob:getID() - 1)

    if ealdnarche then
        ealdnarche:delStatusEffect(xi.effect.PHYSICAL_SHIELD)
        ealdnarche:delStatusEffect(xi.effect.ARROW_SHIELD)
        ealdnarche:delStatusEffect(xi.effect.MAGIC_SHIELD)
    end
end

return entity
