-----------------------------------
-- Area: Ifrit's Cauldron
--   NM: Bomb Queen
--  Vid: https://www.youtube.com/watch?v=AVsEbYjSAHM
-----------------------------------
mixins = { require('scripts/mixins/draw_in') }
-----------------------------------
---@type TMobEntity
local entity = {}

entity.onMobInitialize = function(mob)
    mob:setMobMod(xi.mobMod.IDLE_DESPAWN, 900)
    mob:setMobMod(xi.mobMod.HP_STANDBACK, -1)
    mob:setMobMod(xi.mobMod.GIL_MIN, 15000)
    mob:setMobMod(xi.mobMod.GIL_MAX, 18000)
    mob:setMobMod(xi.mobMod.MUG_GIL, 3370)
    mob:setMod(xi.mod.STUN_MEVA, 50)
end

entity.onMobSpawn = function(mob)
    mob:addImmunity(xi.immunity.STUN)
    mob:setLocalVar('spawn_time', GetSystemTime() + 5) -- five seconds for first pet
end

entity.onMobFight = function(mob, target)
    -- Every 30 seconds spawn a random Prince or Princess. If none remain then summon the Bastard.
    -- Retail confirmed
    if
        not xi.combat.behavior.isEntityBusy(mob) and
        GetSystemTime() >= mob:getLocalVar('spawn_time')
    then
        mob:setLocalVar('spawn_time', GetSystemTime() + 30)
        local mobId = mob:getID()
        -- Pick a random Prince or Princess
        local petId = 0
        local offsets = utils.shuffle({ 1, 2, 3, 4 })
        -- and finally if none are available, the Bastard
        table.insert(offsets, 5)
        for _, petOffset in ipairs(offsets) do
            local id = mobId + petOffset
            if not GetMobByID(id):isSpawned() then
                petId = id
                break
            end
        end

        if petId > 0 then
            xi.mob.callPets(mob, petId, { inactiveTime = 5000, dieWithOwner = true })
        end
    end
end

entity.onMobDeath = function(mob, player, optParams)
end

return entity
