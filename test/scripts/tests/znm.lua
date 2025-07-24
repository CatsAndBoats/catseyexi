
---@type TestSuite
local suite = {}

suite['Soultrapper usage'] = function(world)
    local client, player = world:spawnPlayer({ zone = xi.zone.ALTAIEU })

    local soultrapper = player:addItem(xi.items.SOULTRAPPER_2000)
    assert(soultrapper, "Did not get soultrapper")
    player:addItem(xi.items.BLANK_SOUL_PLATE, 12)

    -- Equip soultrapper and plates
    player:equipItem(xi.items.SOULTRAPPER_2000)
    player:equipItem(xi.items.BLANK_SOUL_PLATE)

    -- Remove soultrapper randomness for testing purpose
    xi.znm.SOULTRAPPER_SUCCESS = 100

    local euvhi = client:gotoEntity("Aweuvhi")

    -- Can't use item before it's ready for use
    client:useItem(euvhi, soultrapper:getSlotID())
    world:skipTime(1)
    world:tickEntity(player)
    assert(not player:delItem(xi.items.SOUL_PLATE), "Did get a soul place")

    -- Wait for use time
    world:skipTime(30)

    -- Can use once it's ready
    client:useItem(euvhi, soultrapper:getSlotID())
    world:skipTime(1)
    world:tickEntity(player)
    assert(player:delItem(xi.items.SOUL_PLATE), "Did not get a soul place")

    -- Try to use soon after and not be allowed
    world:skipTime(5)

    client:useItem(euvhi, soultrapper:getSlotID())
    world:skipTime(1)
    world:tickEntity(player)
    assert(not player:delItem(xi.items.SOUL_PLATE), "Did get a soul place")

    -- Wait for reuse time
    world:skipTime(30)

    -- Can use once it's ready
    client:useItem(euvhi, soultrapper:getSlotID())
    world:skipTime(1)
    world:tickEntity(player)
    assert(player:delItem(xi.items.SOUL_PLATE), "Did not get a soul place")
end

return suite
