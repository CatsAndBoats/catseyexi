-----------------------------------
-- Area: Throne Room
--  Mob: Shadow of Rage
-- Bastok mission 9-2 BCNM Fight (Phase 2)
-----------------------------------
---@type TMobEntity
local entity = {}

entity.onMobInitialize = function(mob)
    mob:addImmunity(xi.immunity.PETRIFY)
    mob:addImmunity(xi.immunity.LIGHT_SLEEP)
    mob:addImmunity(xi.immunity.DARK_SLEEP)
end

return entity
