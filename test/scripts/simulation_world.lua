require("test/scripts/simulation_client")
require("test/scripts/packet_builder")

--- Wrapper around the C++ interface lua_simulation into controlling the simulation and the world.
---@class SimulationWorld
---
---@field simulation LuaSimulation
SimulationWorld = {}

---@private
SimulationWorld.__index = SimulationWorld

---@return SimulationWorld
function SimulationWorld:new(simulation)
    local obj = {}
    setmetatable(obj, self)
    obj.simulation = simulation
    return obj
end

---@class SpawnPlayerParams
---@field zone xi.zone?
---@field pos PositionRot?

---@param params SpawnPlayerParams?
function SimulationWorld:spawnPlayer(params)
    local zone = params and params.zone

    local client = SimulationClient:new(self.simulation:createPlayerClient(zone), self)

    -- Send log in packet
    local packet = PacketBuilder:new(0x0A)
    client.rawClient:sendPacket(packet.data)

    return client, client:getPlayer()
end

---@param times integer? Amount of times to tick in a row
function SimulationWorld:tick(times)
    for _=1, times or 1 do
        self.simulation:tick()
    end
end

---@param entity LuaBaseEntity
function SimulationWorld:tickEntity(entity)
    self.simulation:tickEntity(entity)
end


---@class TimePeriod
---@field seconds integer?
---@field minutes integer?
---@field hours integer?
---@field days integer?

---@param time integer|TimePeriod Amount of seconds or table defining how much time to skip
function SimulationWorld:skipTime(time)
    if type(time) == 'number' then
        self.simulation:addSeconds(time)
    else
        local seconds = (time.seconds or 0) + 60 * ((time.minutes or 0) + 60 * ((time.hours or 0) + 24 * (time.days or 0)))
        self.simulation:addSeconds(seconds)
    end
end

local function getSecondsToVanaTime(vanaHour, vanaMinute)

    local targetMinuteOfDay = vanaHour * 60 + (vanaMinute or 0)
    local currentMinuteOfDay = VanadielHour() * 60 + VanadielMinute()

    local vanaMinutesToSkip = targetMinuteOfDay - currentMinuteOfDay
    if vanaMinutesToSkip < 0 then
        vanaMinutesToSkip = vanaMinutesToSkip + 24 * 60
    end

    return vanaMinutesToSkip * 60 / 25
end

--- Skip time until the in-game hour matches the passed in one.
---@param vanaHour integer
function SimulationWorld:skipToVanaTime(vanaHour, vanaMinute)
    self:skipTime(getSecondsToVanaTime(vanaHour, vanaMinute))
end

--- Skip time until the in-game day matches the passed in one.
---@param day integer
function SimulationWorld:skipToVanaDay(day)
    self:skipTime(getSecondsToVanaTime(1))
    self:tick()

    local daysToSkip = day - VanadielDayElement()
    if daysToSkip < 0 then
        daysToSkip = daysToSkip + 8
    end

    if daysToSkip > 0 then
        self:skipTime(daysToSkip * 3456) -- 3456 is Earth seconds per Vanadiel day
    end
    self:tick()

    assert(VanadielDayElement() == day, string.format("Did not skip to correct day. Expected day %u, got %u.", day, VanadielDayElement()))
    assert(VanadielHour() == 1, string.format("Did not skip to correct hour of day. Expected hour 1, got %u.", VanadielHour()))
    assert(VanadielMinute() == 0, string.format("Did not skip to correct minute of day. Expected minute 0, got %u", VanadielMinute()))
end


return SimulationWorld
