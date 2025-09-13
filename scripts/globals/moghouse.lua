-----------------------------------
-- Mog House related functions
-----------------------------------
require('scripts/globals/npc_util')
require('scripts/globals/quests')
-----------------------------------
xi = xi or {}
xi.moghouse = xi.moghouse or {}

-----------------------------------
-- Mog Locker constants
-----------------------------------
local mogLockerStartTimestamp   = 1009810800 -- unix timestamp for 2001/12/31 15:00
local mogLockerTimestampVarName = 'mog-locker-expiry-timestamp'

xi.moghouse.MOGLOCKER_ALZAHBI_VALID_DAYS    = 7
xi.moghouse.MOGLOCKER_ALLAREAS_VALID_DAYS   = 5
xi.moghouse.MOGLOCKER_PLAYERVAR_ACCESS_TYPE = 'mog-locker-access-type'

xi.moghouse.lockerAccessType =
{
    ALZAHBI  = 0,
    ALLAREAS = 1,
}

xi.moghouse.moghouseZones =
{
    xi.zone.AL_ZAHBI,             -- 49
    xi.zone.AHT_URHGAN_WHITEGATE, -- 50
    xi.zone.SOUTHERN_SAN_DORIA_S, -- 80
    xi.zone.BASTOK_MARKETS_S,     -- 87
    xi.zone.WINDURST_WATERS_S,    -- 94
    xi.zone.RESIDENTIAL_AREA,     -- 219
    xi.zone.SOUTHERN_SAN_DORIA,   -- 230
    xi.zone.NORTHERN_SAN_DORIA,   -- 231
    xi.zone.PORT_SAN_DORIA,       -- 232
    xi.zone.BASTOK_MINES,         -- 234
    xi.zone.BASTOK_MARKETS,       -- 235
    xi.zone.PORT_BASTOK,          -- 236
    xi.zone.WINDURST_WATERS,      -- 238
    xi.zone.WINDURST_WALLS,       -- 239
    xi.zone.PORT_WINDURST,        -- 240
    xi.zone.WINDURST_WOODS,       -- 241
    xi.zone.RULUDE_GARDENS,       -- 243
    xi.zone.UPPER_JEUNO,          -- 244
    xi.zone.LOWER_JEUNO,          -- 245
    xi.zone.PORT_JEUNO,           -- 246
    xi.zone.WESTERN_ADOULIN,      -- 256
    xi.zone.EASTERN_ADOULIN,      -- 257
}

xi.moghouse.moghouse2FUnlockCSs =
{
    [xi.zone.SOUTHERN_SAN_DORIA] = 3535,
    [xi.zone.NORTHERN_SAN_DORIA] = 904,
    [xi.zone.PORT_SAN_DORIA]     = 820,
    [xi.zone.BASTOK_MINES]       = 610,
    [xi.zone.BASTOK_MARKETS]     = 604,
    [xi.zone.PORT_BASTOK]        = 456,
    [xi.zone.WINDURST_WATERS]    = 1086,
    [xi.zone.WINDURST_WALLS]     = 547,
    [xi.zone.PORT_WINDURST]      = 903,
    [xi.zone.WINDURST_WOODS]     = 885,
}

local offsetAxis =
{
    X = 1,
    Z = 3,
}

--  [zoneId]                       = {      x,      y,      z, rot, offsetAxis  , max }
xi.moghouse.exits =
{
    [xi.zone.AL_ZAHBI]             = {     37,      0,    -62, 192, offsetAxis.X, 5.0 },
    [xi.zone.AHT_URHGAN_WHITEGATE] = {   -100,      0,    -83,   0, offsetAxis.Z, 5.0 },
    [xi.zone.SOUTHERN_SAN_DORIA_S] = {    147,     -2,    116,  95, offsetAxis.X, 5.0 },
    [xi.zone.BASTOK_MARKETS_S]     = {   -177,     -8,    -33, 128, offsetAxis.Z, 5.0 },
    [xi.zone.WINDURST_WATERS_S]    = {    157,      0,     -8, 191, offsetAxis.X, 5.0 },
    [xi.zone.SOUTHERN_SAN_DORIA]   = {    161,     -2,  162.1,  95, offsetAxis.Z, 3.0 },
    [xi.zone.NORTHERN_SAN_DORIA]   = {    130,   -0.2,     -3, 160, offsetAxis.X, 3.0 },
    [xi.zone.PORT_SAN_DORIA]       = {     78,    -16, -135.9, 165, offsetAxis.X, 2.0 },
    [xi.zone.BASTOK_MINES]         = {    116,   0.99,    -75, 127, offsetAxis.Z, 5.0 },
    [xi.zone.BASTOK_MARKETS]       = {   -177,     -8,    -33, 127, offsetAxis.Z, 5.0 },
    [xi.zone.PORT_BASTOK]          = {     57,    8.5,   -239, 192, offsetAxis.X, 5.0 },
    [xi.zone.WINDURST_WATERS]      = {    157,     -5,    -62, 192, offsetAxis.X, 5.0 },
    [xi.zone.WINDURST_WALLS]       = { -257.5,  -5.05,   -123,   0, offsetAxis.Z, 5.0 },
    [xi.zone.PORT_WINDURST]        = {    195, -15.56,    258,  65, offsetAxis.X, 5.0 },
    [xi.zone.WINDURST_WOODS]       = {   -138,    -10,     37,   0, offsetAxis.Z, 5.0 },
    [xi.zone.RULUDE_GARDENS]       = {     45,     10,    -73, 192, offsetAxis.X, 5.0 },
    [xi.zone.UPPER_JEUNO]          = {     45,     -5,    -78, 172, offsetAxis.X, 2.5 },
    [xi.zone.LOWER_JEUNO]          = {   41.2,     -5,     84,  85, offsetAxis.X, 2.5 },
    [xi.zone.PORT_JEUNO]           = { -192.5,     -5,   -1.3,   0, offsetAxis.Z, 2.5 },
    [xi.zone.WESTERN_ADOULIN]      = {     -0,     -0,   -144, 223, offsetAxis.Z, 5.0 },
    [xi.zone.EASTERN_ADOULIN]      = {  -59.3,      0, -128.5, 191, offsetAxis.X, 5.0 },
}

xi.moghouse.isInMogHouseInHomeNation = function(player)
    if not player:isInMogHouse() then
        return false
    end

    local currentZone = player:getZoneID()
    local nation      = player:getNation()

    -- TODO: Simplify nested conditions
    if nation == xi.nation.BASTOK then
        if
            currentZone >= xi.zone.BASTOK_MINES and
            currentZone <= xi.zone.PORT_BASTOK
        then
            return true
        end
    elseif nation == xi.nation.SANDORIA then
        if
            currentZone >= xi.zone.SOUTHERN_SAN_DORIA and
            currentZone <= xi.zone.PORT_SAN_DORIA
        then
            return true
        end
    else
        if
            currentZone >= xi.zone.WINDURST_WATERS and
            currentZone <= xi.zone.WINDURST_WOODS
        then
            return true
        end
    end

    return false
end

xi.moghouse.set2ndFloorStyle = function(player, style)
    -- 0x0080: This bit and the next track which 2F decoration style is being used (0: SANDORIA, 1: BASTOK, 2: WINDURST, 3: PATIO)
    -- 0x0100: ^ As above
    local mhflag = player:getMoghouseFlag()
    utils.mask.setBit(mhflag, 0x0080, utils.mask.getBit(style, 0))
    utils.mask.setBit(mhflag, 0x0100, utils.mask.getBit(style, 1))
    player:setMoghouseFlag(mhflag)
end

xi.moghouse.getAvailableMusic = function(player)
    -- See documentation/songdata.txt or documentation/MusicIDs.txt for song data.
    local possibleSongs = {}

    local orchestrion  = player:findItem(xi.item.ORCHESTRION)
    local spinet       = player:findItem(xi.item.SPINET)
    local nanaaStatue1 = player:findItem(xi.item.NANAA_MIHGO_STATUE)
    local nanaaStatue2 = player:findItem(xi.item.NANAA_MIHGO_STATUE_II)

    local hasOrchestrion  = orchestrion and orchestrion:isInstalled()
    local hasSpinet       = spinet and spinet:isInstalled()
    local hasNanaaStatue1 = nanaaStatue1 and nanaaStatue1:isInstalled()
    local hasNanaaStatue2 = nanaaStatue2 and nanaaStatue2:isInstalled()

    -- NOTE: Since Spinet, Nanaa Mihgo Statue I, and Nanaa Mihgo Statue II are promotional-only items,
    --     : it is extremely difficult to get them and test what they do when used together.
    --     : We're completely guessing how they interact with each other.
    --     : TODO: Do these overwrite eachother in some way, or do they work together (as we've implemented
    --     : them here)?
    if not hasOrchestrion then
        -- https://www.bg-wiki.com/ffxi/Orchestrion
        if hasSpinet then
            table.insert(possibleSongs, 112) -- Selbina
            table.insert(possibleSongs, 196) -- Fighters of the Crystal
            table.insert(possibleSongs, 230) -- A New Horizon
            table.insert(possibleSongs, 187) -- Ragnarok
            table.insert(possibleSongs, 215) -- Clash of Standards
            table.insert(possibleSongs, 47)  -- Echoes of Creation
            table.insert(possibleSongs, 49)  -- Luck of the Mog
            table.insert(possibleSongs, 50)  -- Feast of the Ladies
            table.insert(possibleSongs, 51)  -- Abyssea
            table.insert(possibleSongs, 52)  -- Melodies Errant
            table.insert(possibleSongs, 109) -- Ronfaure
            table.insert(possibleSongs, 251) -- Autumn Footfalls
            table.insert(possibleSongs, 48)  -- Main Theme
            table.insert(possibleSongs, 126) -- Mog House
        end

        if hasNanaaStatue1 then
            table.insert(possibleSongs, 69) -- Distant Worlds (Nanaa Mihgo's Version)
        end

        if hasNanaaStatue2 then
            table.insert(possibleSongs, 59) -- The Pioneers (Nanaa Mihgo's Version)
        end
    end

    return possibleSongs
end

xi.moghouse.trySetMusic = function(player)
    local possibleSongs = xi.moghouse.getAvailableMusic(player)

    if #possibleSongs > 0 then
        -- This needs a moment before music changes can take effect
        player:timer(1000, function(playerArg)
            playerArg:changeMusic(6, utils.randomEntry(possibleSongs))
        end)
    end
end

xi.moghouse.onMoghouseZoneEvent = function(player, prevZone)
    -- Handle players zoning in their Mog House
    if player:isInMogHouse() then
        return xi.moghouse.onMoghouseZoneIn(player, prevZone)
    end

    -- Handle players zoning out of their Mog House
    if
        player:getXPos() == 0 and
        player:getYPos() == 0 and
        player:getZPos() == 0
    then
        local x, y, z, r, randomizedAxis, randomMax = unpack(xi.moghouse.exits[player:getZoneID()])
        local randomOffset                          = math.random(randomMax * 1000)

        -- 0.000 - N.N00 variance
        if randomizedAxis == offsetAxis.X then
            x = x + (randomOffset / 1000)
        elseif randomizedAxis == offsetAxis.Z then
            z = z + (randomOffset / 1000)
        end

        player:setPos(x, y, z, r)
    end

    return -1
end

xi.moghouse.onMoghouseZoneIn = function(player, prevZone)
    local cs = -1

    player:eraseAllStatusEffect()
    player:delStatusEffectSilent(xi.effect.POISON)
    player:delStatusEffectSilent(xi.effect.BLINDNESS)
    player:delStatusEffectSilent(xi.effect.PARALYSIS)
    player:delStatusEffectSilent(xi.effect.SILENCE)

    player:setPos(0, 0, 0, 192)

    -- Moghouse data (bit-packed)
    -- 0x0001: SANDORIA exit quest flag
    -- 0x0002: BASTOK exit quest flag
    -- 0x0004: WINDURST exit quest flag
    -- 0x0008: JEUNO exit quest flag
    -- 0x0010: WEST_AHT_URHGAN exit quest flag
    -- 0x0020: Unlocked Moghouse2F flag
    -- 0x0040: Moghouse 2F tracker flag (0: default, 1: using 2F)
    -- 0x0080: This bit and the next track which 2F decoration style is being used (0: SANDORIA, 1: BASTOK, 2: WINDURST, 3: PATIO)
    -- 0x0100: ^ As above
    local mhflag = player:getMoghouseFlag()

    local growingFlowers   = bit.band(mhflag, 0x0001) > 0
    local aLadysHeart      = bit.band(mhflag, 0x0002) > 0
    local flowerChild      = bit.band(mhflag, 0x0004) > 0
    local unlocked2ndFloor = bit.band(mhflag, 0x0020) > 0
    local using2ndFloor    = bit.band(mhflag, 0x0040) > 0

    -- NOTE: You can test these quest conditions with:
    -- Reset: !exec player:setMoghouseFlag(0)
    -- Complete quests: !exec player:setMoghouseFlag(7)
    if
        xi.moghouse.isInMogHouseInHomeNation(player) and
        growingFlowers and
        aLadysHeart and
        flowerChild and
        not unlocked2ndFloor and
        not using2ndFloor
    then
        cs = xi.moghouse.moghouse2FUnlockCSs[player:getZoneID()]

        player:setMoghouseFlag(mhflag + 0x0020) -- Set unlock flag now, rather than in onEventFinish

        local nation = player:getNation()
        xi.moghouse.set2ndFloorStyle(player, nation)
    end

    xi.moghouse.trySetMusic(player)

    return cs
end

xi.moghouse.moogleTrade = function(player, npc, trade)
    if player:isInMogHouse() then
        local numBronze = trade:getItemQty(xi.item.IMPERIAL_BRONZE_PIECE)

        if numBronze > 0 then
            if xi.moghouse.addMogLockerExpiryTime(player, numBronze) then
                player:tradeComplete()
                player:messageSpecial(zones[player:getZoneID()].text.MOG_LOCKER_OFFSET + 2, xi.moghouse.getMogLockerExpiryTimestamp(player))
            end
        end

        local eggComponents =
        {
            xi.item.EGG_LOCKER,
            xi.item.EGG_TABLE,
            xi.item.EGG_STOOL,
            xi.item.EGG_LANTERN,
        }

        if npcUtil.tradeHasExactly(trade, eggComponents) then
            if npcUtil.giveItem(player, xi.item.EGG_BUFFET) then
                player:confirmTrade()
            end

        elseif npcUtil.tradeHasExactly(trade, xi.item.EGG_BUFFET) then
            if npcUtil.giveItem(player, eggComponents) then
                player:confirmTrade()
            end
        end
    end
end

xi.moghouse.moogleTrigger = function(player, npc)
    if player:isInMogHouse() then
        local lockerTs = xi.moghouse.getMogLockerExpiryTimestamp(player)

        if lockerTs ~= nil then
            if lockerTs == -1 then -- Expired
                player:messageSpecial(zones[player:getZoneID()].text.MOG_LOCKER_OFFSET + 1, xi.item.IMPERIAL_BRONZE_PIECE)
            else
                player:messageSpecial(zones[player:getZoneID()].text.MOG_LOCKER_OFFSET, lockerTs)
            end
        end

        player:sendMenu(xi.menuType.MOOGLE)
    end
end

xi.moghouse.moogleEventUpdate = function(player, csid, option, npc)
end

xi.moghouse.moogleEventFinish = function(player, csid, option, npc)
end

-- Unlocks a mog locker for a player. Returns the 'expired' timestamp (-1)
xi.moghouse.unlockMogLocker = function(player)
    player:setCharVar(mogLockerTimestampVarName, -1)

    -- Safety check in case some servers auto-set 80 slots for mog locker items.
    if player:getContainerSize(xi.inv.MOGLOCKER) == 0 then
        player:changeContainerSize(xi.inv.MOGLOCKER, 30)
    end

    return -1
end

-- Sets the mog locker access type (all area or alzahbi only). Returns the new access type.
xi.moghouse.setMogLockerAccessType = function(player, accessType)
    player:setCharVar(xi.moghouse.MOGLOCKER_PLAYERVAR_ACCESS_TYPE, accessType)

    return accessType
end

-- Gets the mog locker access type (all area or alzahbi only). Returns the new access type.
xi.moghouse.getMogLockerAccessType = function(player)
    return player:getCharVar(xi.moghouse.MOGLOCKER_PLAYERVAR_ACCESS_TYPE)
end

-- Gets the expiry time for your locker. A return value of -1 is expired. A return value of nil means mog locker hasn't been unlocked.
xi.moghouse.getMogLockerExpiryTimestamp = function(player)
    local expiryTime = player:getCharVar(mogLockerTimestampVarName)

    if expiryTime == 0 then
        return nil
    end

    local now = GetSystemTime() - mogLockerStartTimestamp

    if now > expiryTime then
        player:setCharVar(mogLockerTimestampVarName, -1)

        return -1
    end

    return expiryTime
end

-- Adds time to your mog locker, given the number of bronze coins.
-- The amount of time per bronze is affected by the access type
-- The expiry time itself is the number of seconds past 2001/12/31 15:00
-- Returns true if time was added successfully, false otherwise.
xi.moghouse.addMogLockerExpiryTime = function(player, numBronze)
    local accessType       = xi.moghouse.getMogLockerAccessType(player)
    local numDaysPerBronze = 5

    if accessType == xi.moghouse.lockerAccessType.ALZAHBI then
        numDaysPerBronze = 7
    end

    local currentTs = xi.moghouse.getMogLockerExpiryTimestamp(player)

    if currentTs == nil then
        return false
    end

    if currentTs == -1 then
        currentTs = GetSystemTime() - mogLockerStartTimestamp
    end

    local timeIncrease = 60 * 60 * 24 * numDaysPerBronze * numBronze
    local newTs        = currentTs + timeIncrease

    player:setCharVar(mogLockerTimestampVarName, newTs)

    -- Send an invent size packet to enable the items if they weren't.
    player:changeContainerSize(xi.inv.MOGLOCKER, 0)

    return true
end
