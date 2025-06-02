-----------------------------------
-- Area: Boneyard_Gully
--  Mob: Shikaree X's Rabbit
-----------------------------------
---@type TMobEntity
local entity = {}

-----------------------------------
-- Sets initial mob-specific immunities.
-----------------------------------
entity.onMobInitialize = function(mob)
    mob:addImmunity(xi.immunity.DARK_SLEEP)
    mob:addImmunity(xi.immunity.LIGHT_SLEEP)
    mob:addImmunity(xi.immunity.PETRIFY)
end

return entity
