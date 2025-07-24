require("test/scripts/simulation_world")

local function runTestcase(simulation, testcase)
    testcase(SimulationWorld:new(simulation))
end

return runTestcase
