-----------------------------------
-- Area: Throne Room
--  Mob: Zeid (Phase 2)
-- Bastok mission 9-2 BCNM Fight (Phase 2)
-----------------------------------
mixins = { require('scripts/mixins/job_special') }
-----------------------------------
---@type TMobEntity
local entity = {}

entity.onMobInitialize = function(mob)
    mob:addImmunity(xi.immunity.PETRIFY)
    mob:addImmunity(xi.immunity.LIGHT_SLEEP)
    mob:addImmunity(xi.immunity.DARK_SLEEP)
end

entity.onMobSpawn = function(mob)
    xi.mix.jobSpecial.config(mob, {
        specials =
        {
            { id = xi.jsa.BLOOD_WEAPON, hpp = math.random(20, 50) },
        },
    })
end

entity.onMobFight = function(mob, target)
    local zeid    = mob:getID()
    local shadow1 = GetMobByID(zeid + 1)
    local shadow2 = GetMobByID(zeid + 2)

    if
        mob:getHPP() <= 77 and
        shadow1 and shadow1:isDead() and
        shadow2 and shadow2:isDead()
    then
        mob:useMobAbility(xi.mobSkill.ZEID_SUMMON_SHADOWS_2)
    end
end

entity.onMobDeath = function(mob, player, optParams)
    local mobId = mob:getID()
    DespawnMob(mobId + 1)
    DespawnMob(mobId + 2)
end

return entity
