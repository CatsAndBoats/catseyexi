-----------------------------------
-- Transport
-----------------------------------
xi = xi or {}
xi.transport = xi.transport or {}

-----------------------------------
-- Enums
-----------------------------------
xi.transport.message =
{
    NEARING = 0,
    DOCKING = 1,
}

xi.transport.epochOffset =
{
    NEARING = 265,
    DOCKING = 290,
}

xi.transport.messageTime =
{
    SILVER_SEA = 480,
}

xi.transport.trigger =
{
    mhaura =
    {
        FERRY_ARRIVING_FROM_ALZAHBI = 0,
        FERRY_DEPARTING_TO_ALZAHBI  = 1,
        FERRY_ARRIVING_FROM_SELBINA = 2,
        FERRY_DEPARTING_TO_SELBINA  = 3,
    },
    selbina =
    {
        FERRY_ARRIVING_FROM_MHAURA = 0,
        FERRY_DEPARTING_TO_MHAURA  = 1,
    },
}

xi.transport.interval =
{
    mhaura =
    {
        FROM_TO_ALZAHBI = 480,
        FROM_TO_SELBINA = 480,
    },
    selbina =
    {
        FROM_TO_MHAURA = 480,
    },
}

xi.transport.offset =
{
    mhaura =
    {
        FERRY_ARRIVING_FROM_ALZAHBI = 159,
        FERRY_DEPARTING_TO_ALZAHBI  = 239,
        FERRY_ARRIVING_FROM_SELBINA = 399,
        FERRY_DEPARTING_TO_SELBINA  = 479,
    },
    selbina =
    {
        FERRY_ARRIVING_FROM_MHAURA = 399,
        FERRY_DEPARTING_TO_MHAURA  = 479,
    },
}

local direction =
{
    ARRIVE = 0,
    DEPART = 1,
}

local destination =
{
    MHAURA   = 0,
    SELBINA  = 0,
    AL_ZAHBI = 1,
}

xi.transport.routes =
{
    SELBINA_MHAURA          = 0,
    OPEN_SEA                = 1,
    SILVER_SEA              = 2,
    SELBINA_MHAURA_OPEN_SEA = 3,
}

-----------------------------------
-- Tables
-----------------------------------
local dockTable =
{
    -- ['npc_name'] = { eventId, route },
    ['Baya_Hiramayuh' ] = { 232, xi.transport.routes.OPEN_SEA                }, -- Aht Urhgan Whitegate to Mhaura
    ['Dieh_Yamilsiah' ] = { 231, xi.transport.routes.SELBINA_MHAURA_OPEN_SEA }, -- Mhaura to Aht Urhgan Whitegate or Selbina
    ['Humilitie'      ] = { 231, xi.transport.routes.SELBINA_MHAURA          }, -- Selbina to Mhaura
    ['Kuhn_Tsahnpri'  ] = { 236, xi.transport.routes.SILVER_SEA              }, -- Aht Urhgan Whitegate to Nashmau
    ['Laughing_Bison' ] = { 333, xi.transport.routes.SELBINA_MHAURA_OPEN_SEA }, -- Mhaura to Aht Urhgan Whitegate or Selbina
    ['Yohj_Dukonlhy'  ] = { 231, xi.transport.routes.SILVER_SEA              }, -- Nashmau to Aht Urhgan Whitegate
}

local scheduleTable =
{
    -- used by ship and selbina dock timekeepers
    [xi.transport.routes.SELBINA_MHAURA] = -- Ship bound for [Mhaura/Selbina]
    {
        { startTime =    0, endTime = utils.timeStringToMinutes('06:40'),    action = direction.ARRIVE, target = 0 }, -- (from dock) arrives at SELBINA
        { startTime =  400, endTime = utils.timeStringToMinutes('08:00'),    action = direction.DEPART, target = 0 }, -- (from dock) headed to MHAURA
        { startTime =  480, endTime = utils.timeStringToMinutes('14:40'),    action = direction.ARRIVE, target = 0 }, -- (from dock) arrives at SELBINA
        { startTime =  880, endTime = utils.timeStringToMinutes('16:00'),    action = direction.DEPART, target = 0 }, -- (from dock) headed to MHAURA
        { startTime =  960, endTime = utils.timeStringToMinutes('22:40'),    action = direction.ARRIVE, target = 0 }, -- (from dock) arrives at SELBINA
        { startTime = 1360, endTime = utils.timeStringToMinutes('00:00', 1), action = direction.DEPART, target = 0 }, -- (from dock) headed to MHAURA
    },

    -- used by ship and southern whitegate dock timekeepers
    [xi.transport.routes.OPEN_SEA] = -- Open sea route to [Al Zahbi/Mhaura]
    {
        { startTime =    0, endTime = utils.timeStringToMinutes('02:40'),    action = direction.ARRIVE, target = 0 }, -- (from dock) arrives at AL_ZAHBI
        { startTime =  160, endTime = utils.timeStringToMinutes('04:00'),    action = direction.DEPART, target = 0 }, -- (from dock) headed to MHAURA
        { startTime =  240, endTime = utils.timeStringToMinutes('10:40'),    action = direction.ARRIVE, target = 0 }, -- (from dock) arrives at AL_ZAHBI
        { startTime =  640, endTime = utils.timeStringToMinutes('12:00'),    action = direction.DEPART, target = 0 }, -- (from dock) headed to MHAURA
        { startTime =  720, endTime = utils.timeStringToMinutes('18:40'),    action = direction.ARRIVE, target = 0 }, -- (from dock) arrives at AL_ZAHBI
        { startTime = 1120, endTime = utils.timeStringToMinutes('20:00'),    action = direction.DEPART, target = 0 }, -- (from dock) headed to MHAURA
        { startTime = 1200, endTime = utils.timeStringToMinutes('02:40', 1), action = direction.ARRIVE, target = 0 },
    },

    -- used by ship and nashmau/whitegate dock timekeepers
    [xi.transport.routes.SILVER_SEA] = -- Silver Sea route to [Al Zahbi/Nashmau]
    {
        { startTime =    0, endTime = utils.timeStringToMinutes('05:00'),    action = direction.ARRIVE, target = 0 },
        { startTime =  300, endTime = utils.timeStringToMinutes('08:00'),    action = direction.DEPART, target = 0 },
        { startTime =  480, endTime = utils.timeStringToMinutes('13:00'),    action = direction.ARRIVE, target = 0 },
        { startTime =  780, endTime = utils.timeStringToMinutes('16:00'),    action = direction.DEPART, target = 0 },
        { startTime =  960, endTime = utils.timeStringToMinutes('21:00'),    action = direction.ARRIVE, target = 0 },
        { startTime = 1260, endTime = utils.timeStringToMinutes('00:00', 1), action = direction.DEPART, target = 0 },
    },

    -- used by Dieh Yamilsiah and Laughin Bison (Mhaura dock only)
    [xi.transport.routes.SELBINA_MHAURA_OPEN_SEA] = -- Combination of Ship bound for [Mhaura/Selbina] and Open sea route to [Al Zahbi/Mhaura]
    {
        { startTime =    0, endTime = utils.timeStringToMinutes('02:40'),    action = direction.ARRIVE, target = destination.AL_ZAHBI },
        { startTime =  160, endTime = utils.timeStringToMinutes('04:00'),    action = direction.DEPART, target = destination.AL_ZAHBI },
        { startTime =  240, endTime = utils.timeStringToMinutes('06:40'),    action = direction.ARRIVE, target = destination.SELBINA  },
        { startTime =  400, endTime = utils.timeStringToMinutes('08:00'),    action = direction.DEPART, target = destination.SELBINA  },
        { startTime =  480, endTime = utils.timeStringToMinutes('10:40'),    action = direction.ARRIVE, target = destination.AL_ZAHBI },
        { startTime =  640, endTime = utils.timeStringToMinutes('12:00'),    action = direction.DEPART, target = destination.AL_ZAHBI },
        { startTime =  720, endTime = utils.timeStringToMinutes('14:40'),    action = direction.ARRIVE, target = destination.SELBINA  },
        { startTime =  880, endTime = utils.timeStringToMinutes('16:00'),    action = direction.DEPART, target = destination.SELBINA  },
        { startTime =  960, endTime = utils.timeStringToMinutes('18:40'),    action = direction.ARRIVE, target = destination.AL_ZAHBI },
        { startTime = 1120, endTime = utils.timeStringToMinutes('20:00'),    action = direction.DEPART, target = destination.AL_ZAHBI },
        { startTime = 1200, endTime = utils.timeStringToMinutes('22:40'),    action = direction.ARRIVE, target = destination.SELBINA  },
        { startTime = 1360, endTime = utils.timeStringToMinutes('00:00', 1), action = direction.DEPART, target = destination.SELBINA  },
    },
}

-----------------------------------
-- public functions
-----------------------------------

xi.transport.captainMessage = function(npc, triggerID, messages)
    local playersInZone = npc:getZone():getPlayers()
    for _, player in pairs(playersInZone) do
        player:showText(player, messages[triggerID])
    end
end

local dockNpcPos =
{
    mhaura =
    {
        ARRIVING  =
        {
            { x = 7.06, y = -1.36, z = 2.20, rotation = 211 },
        },
        DEPARTING =
        {
            { x = 8.26, y = -1.36, z = 2.20, rotation = 193 },
        },
    },
    selbina =
    {
        ARRIVING  =
        {
            { x = 16.768, y = -1.38, z = -58.843, rotation = 209 },
        },
        DEPARTING =
        {
            { x = 17.979, y = -1.389, z = -58.800, rotation = 191 },
        },
    },
}

xi.transport.dockMessage = function(npc, triggerID, messages, dock)
    npc:showText(npc, messages[triggerID])
    if (triggerID % 2) == 0 then
        npc:pathThrough(dockNpcPos[dock].ARRIVING, bit.bor(xi.path.flag.PATROL, xi.path.flag.WALLHACK))
    else
        npc:pathThrough(dockNpcPos[dock].DEPARTING, bit.bor(xi.path.flag.PATROL, xi.path.flag.WALLHACK))
    end
end

-----------------------------------
-- NPC functions
-----------------------------------
xi.transport.onBoatTimekeeperTrigger = function(player, route, travelMessage, arrivingMessage)
    local currentTime = VanadielHour() * 60 + VanadielMinute()
    local timeDiff    = 0

    for i = 1, #scheduleTable[route] do
        if
            currentTime >= scheduleTable[route][i].startTime and
            currentTime < scheduleTable[route][i].endTime
        then
            timeDiff = scheduleTable[route][i].endTime - currentTime

            break
        end
    end

    local message   = timeDiff < 30 and arrivingMessage or travelMessage
    local earthMins = math.ceil(timeDiff / 25)
    local gameHours = math.floor(timeDiff / 60)

    player:messageSpecial(message, earthMins, gameHours)
end

xi.transport.onDockTimekeeperTrigger = function(player, npc)
    -- Fetch NPC data.
    local npcName = npc:getName()
    local eventId = dockTable[npcName][1]
    local route   = dockTable[npcName][2]

    -- Fetch Schedule
    local currentTime  = VanadielHour() * 60 + VanadielMinute()
    local scheduleStep = 0

    for i = 1, #scheduleTable[route] do
        if
            currentTime >= scheduleTable[route][i].startTime and
            currentTime < scheduleTable[route][i].endTime
        then
            scheduleStep = i

            break
        end
    end

    local timeLeft = math.floor((scheduleTable[route][scheduleStep].endTime - currentTime) * 60 / 25)

    player:startEvent(eventId, timeLeft, scheduleTable[route][scheduleStep].action, 0, scheduleTable[route][scheduleStep].target)
end
