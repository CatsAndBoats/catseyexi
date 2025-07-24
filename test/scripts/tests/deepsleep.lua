
---@type TestSuite
local suite = {}

suite["Monster Deep Sleep targets aren't woken by any damage"] = function(world)
    local _client, player = world:spawnPlayer()

    assert(player:hasPreventActionEffect() == false, "Player can't perform an action")

    -- Tier 1 is mob version
    player:addStatusEffect({
        effect = xi.effect.DEEPSLEEP,
        icon = xi.effect.SLEEP_I,
        power = 1,
        duration = 90,
        tier = 1,
    })
    assert(player:hasPreventActionEffect() == true, "Player is awake when it shouldn't be")

    -- Does not wake from DoT
    player:addStatusEffect({
        effect = xi.effect.POISON,
        power = 10,
        duration = 90,
    })
    world:skipTime(5)
    world:tick()
    assert(player:hasPreventActionEffect() == true, "Player is awake after DoT, when it shouldn't be")

    -- Does not wake from regular damage
    player:takeDamage(10, player)
    world:skipTime(5)
    world:tick()
    assert(player:hasPreventActionEffect() == true, "Player is awake after taking damage, when it shouldn't be")
end

suite["Pet Deep Sleep targets aren't woken by DoT damage, but are woken by regular damage"] = function(world)
    local _client, player = world:spawnPlayer()

    assert(player:hasPreventActionEffect() == false, "Player can't perform an action")

    -- Tier 0 is pet version
    player:addStatusEffect({
        effect = xi.effect.DEEPSLEEP,
        icon = xi.effect.SLEEP_I,
        power = 1,
        duration = 90,
        tier = 0,
    })
    assert(player:hasPreventActionEffect() == true, "Player is awake when it shouldn't be")

    -- Does not wake from DoT
    player:addStatusEffect({
        effect = xi.effect.POISON,
        power = 10,
        duration = 90,
    })
    world:skipTime(5)
    world:tick()
    assert(player:hasPreventActionEffect() == true, "Player is awake after DoT, when it shouldn't be")

    -- DOES wake from regular damage
    player:takeDamage(10, player)
    world:skipTime(5)
    world:tick()
    assert(player:hasPreventActionEffect() == false, "Player is still asleep after taking damage, when it shouldn't be")
end

suite["Deep Sleep can be ovewritten by Sleep II"] = function(world)
    local _client, player = world:spawnPlayer()

    -- Add initial Deep Sleep effect
    player:addStatusEffect({
        effect = xi.effect.DEEPSLEEP,
        icon = xi.effect.SLEEP_I,
        power = 1,
        duration = 90,
    })
    assert(player:hasStatusEffect(xi.effect.DEEPSLEEP), "Player does not have Deep Sleep, when it should have")

    -- Sleep I does not overwrite, and is not itself applied
    player:addStatusEffect({
        effect = xi.effect.SLEEP_I,
        power = 1,
        duration = 90,
    })
    assert(player:hasStatusEffect(xi.effect.DEEPSLEEP), "Player does not have Deep Sleep, when it should have")
    assert(not player:hasStatusEffect(xi.effect.SLEEP_I), "Player has Sleep I, when it should not have")

    -- Sleep II overwrites
    player:addStatusEffect({
        effect = xi.effect.SLEEP_II,
        power = 1,
        duration = 90,
    })
    assert(not player:hasStatusEffect(xi.effect.DEEPSLEEP), "Player has Deep Sleep, when it should not have")
    assert(player:hasStatusEffect(xi.effect.SLEEP_II), "Player does not have Sleep II, when it should have")
end

suite["Deep Sleep stops a monster from attacking"] = function(world)
    local client, player = world:spawnPlayer({ zone = xi.zone.East_Sarutabaruta })

    -- Find a mob that can attack the player
    local mob = client:getEntity("Carrion_Crow")

    -- Respawn it to ensure it's reset from any other tests
    mob:despawn()
    world:skipTime(20)
    world:tick()
    mob:spawn()
    assert(mob:isSpawned(), string.format("%s is not spawned", mob:getName()))
    assert(mob:isAlive(), string.format("%s is not alive", mob:getName()))
    assert(not mob:hasPreventActionEffect(), string.format("%s is prevented from taking actions", mob:getName()))

     -- Claim and add enmity to the player
    mob:addEnmity(player, 10, 10)
    world:skipTime(1)
    world:tick()

    -- Mob is now in attack state
    assert(mob:getCurrentAction() == 1, "Mob is not attacking as expected. Is in state: " .. mob:getCurrentAction())

    -- Add Deep Sleep
    mob:addStatusEffect({
        effect = xi.effect.DEEPSLEEP,
        icon = xi.effect.SLEEP_I,
        power = 1,
        duration = 90,
    })
    world:skipTime(1)
    world:tick()

    -- Mob is now in an inactive state
    assert(mob:getCurrentAction() == 27, "Mob is not inactive as expected. Is in state: " .. mob:getCurrentAction())
end

return suite
