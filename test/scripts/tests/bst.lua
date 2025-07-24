
---@type TestSuite
local suite = {}

suite['Mob uncharms upon zoning'] = function(world)
    local client, player = world:spawnPlayer()

    -- Sylvestre
    local sylvestre = player:getZone():insertExtra(6470, xi.zone.Buburimu_Peninsula)

    assert(sylvestre, "Sylvestre not inserted")

    sylvestre:spawn()

    player:changeJob(xi.job.BST)
    player:setLevel(18)

    client:useAbility(sylvestre, xi.jobAbility.CHARM)
    world:tick()

    if not sylvestre:isCharmed() then
        player:charm(sylvestre, 100)
    end

    assert(sylvestre:isCharmed() == true)
    client:gotoZone(xi.zone.Tahrongi_Canyon)
    assert(sylvestre:isCharmed() == false)
end


return suite
