-----------------------------------
-- Area: Port Windurst
--  NPC: Khel Pahlhama
--  Linkshell Merchant
-- !pos 21 -2 -20 240
-----------------------------------
---@type TNpcEntity
local entity = {}

entity.onTrigger = function(player, npc)
    local stock =
    {
        { xi.item.NEW_LINKSHELL,   6000 },
        { xi.item.PENDANT_COMPASS,  375 },
    }

    -- TODO: This shop is only open from 12 to 20.

    player:showText(npc, zones[xi.zone.PORT_WINDURST].text.KHEL_PAHLHAMA_SHOP_DIALOG, 513)
    xi.shop.general(player, stock)
end

return entity
