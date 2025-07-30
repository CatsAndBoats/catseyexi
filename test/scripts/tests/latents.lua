require("test/scripts/assertions")


---@type TestSuite
local suite = {}

suite['Weather element present'] = function(world)
    local client, player = world:spawnPlayer()

    player:changeJob(xi.job.NIN)
    player:setLevel(75)

    local baseEva = player:getEVA()

    player:setWeather(xi.weather.RAIN)
    assert(baseEva == player:getEVA(), "Player gained evasion from rainy weather without any equipment")

    player:setWeather(xi.weather.NONE)
    assert(baseEva == player:getEVA(), "Player gained evasion from switch to clear weather")

    player:addItem(xi.items.MONSOON_JINPACHI)
    player:equipItem(xi.items.MONSOON_JINPACHI)

    assert(baseEva == player:getEVA(), "Player gained evasion from gear that should only be active during to rainy weather")

    player:setWeather(xi.weather.RAIN)
    assert(player:getEVA() - baseEva == 8, "Player did not gain expected evasion from rainy weather")
end

return suite
