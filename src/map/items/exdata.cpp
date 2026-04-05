/*
===========================================================================

  Copyright (c) 2026 LandSandBoat Dev Teams

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see http://www.gnu.org/licenses/

===========================================================================
*/

#include "exdata.h"

#include "item.h"
#include "item_weapon.h"

#include "items.h"
#include "utils/fishingutils.h"
#include <sol/sol.hpp>

namespace Exdata
{

// Returns Exdata type for an item based on type or item ID.
// This loosely follows client logic for rendering exdata.
auto getType(const CItem* item) -> Type
{
    if (!item)
    {
        return Type::None;
    }

    const auto itemId = item->getID();

    if (fishingutils::IsFish(item))
    {
        return Type::Fish;
    }

    if (itemId == LEGION_PASS)
    {
        return Type::LegionPass;
    }

    if (itemId == PERPETUAL_HOURGLASS)
    {
        return Type::PerpetualHourglass;
    }

    if (itemId == COPY_OF_THE_WYVERN_CODEX || itemId == COPY_OF_THE_GRIFFON_CODEX ||
        (itemId >= COPY_OF_THE_BALLISTA_REDBOOK && itemId <= PAGE_OF_THE_BALLISTA_WHITEBOOK) ||
        (itemId >= COPY_OF_THE_BRENNER_BLUEBOOK && itemId <= PAGE_OF_THE_BRENNER_BLACKBOOK))
    {
        return Type::BrennerBook;
    }

    if (itemId == SOUL_PLATE || itemId == GAUGER_PLATE || itemId == FIEND_PLATE)
    {
        return Type::SoulPlate;
    }

    if (itemId == SOUL_REFLECTOR || itemId == OFFICIAL_SOUL_REFLECTOR)
    {
        return Type::SoulReflector;
    }

    if (itemId == CHOCOBET_TICKET)
    {
        return Type::BettingSlip;
    }

    if (itemId == RACE_COMPLETION_CERTIFICATE)
    {
        return Type::RaceCertificate;
    }

    if (itemId == VCS_HONEYMOON_TICKET)
    {
        return Type::HoneymoonTicket;
    }

    if (itemId >= DILIGENCE_GRIMOIRE && itemId <= SANCTITY_GRIMOIRE)
    {
        return Type::MeebleGrimoire;
    }

    if (itemId >= LEUJAOAM_OBSERVATION_LOG && itemId <= ILRUSI_TRAVEL_LEDGER)
    {
        return Type::AssaultLog;
    }

    if (itemId == BONANZA_PEARL || itemId == MOG_BONANZA_MARBLE)
    {
        return Type::LotteryTicket;
    }

    if ((itemId >= MAZE_TABULA_M01 && itemId <= MAZE_TABULA_M03) ||
        (itemId >= MAZE_TABULA_R01 && itemId <= MAZE_TABULA_R03))
    {
        return Type::Tabula;
    }

    if (itemId == EVOLITH)
    {
        return Type::Evolith;
    }

    if (itemId >= WOODWORKING_SET_25 && itemId <= COOKING_SET_95)
    {
        return Type::CraftingSet;
    }

    if (itemId == GLOWING_LAMP)
    {
        return Type::GlowingLamp;
    }

    if (itemId == CHOCOBO_EGG_FAINTLY || itemId == CHOCOBO_EGG_SLIGHTLY ||
        (itemId >= CHOCOBO_EGG_A_BIT && itemId <= CHOCOBO_EGG_SOMEWHAT))
    {
        return Type::ChocoboEgg;
    }

    if (itemId == VCS_REGISTRATION_CARD || itemId == CHOCOCARD_M ||
        itemId == CHOCOCARD_F || itemId == CRA_RACING_FORM)
    {
        return Type::ChocoboCard;
    }

    // Escutcheon (+4 is the finished item, no crafting exdata)
    if (itemId >= JOINERS_ASPIS && itemId <= CHEFS_SHIELD &&
        (itemId - JOINERS_ASPIS) % 5 != 4)
    {
        return Type::Escutcheon;
    }

    // Unlockable weapons use specific exdata
    // Must be checked before augments
    if (item->isType(ITEM_WEAPON))
    {
        auto* PWeapon = static_cast<const CItemWeapon*>(item);
        if (PWeapon->isUnlockable())
        {
            return Type::WeaponUnlock;
        }
    }

    return Type::None;
}

// Fills the table with appropriate keys according to exdata type
auto toTable(const CItem* item, sol::table& table) -> bool
{
    switch (Exdata::getType(item))
    {
        case Type::LegionPass:
            item->exdata<LegionPass>().toTable(table);
            return true;
        case Type::PerpetualHourglass:
            item->exdata<PerpetualHourglass>().toTable(table);
            return true;
        case Type::BettingSlip:
            item->exdata<BettingSlip>().toTable(table);
            return true;
        case Type::AssaultLog:
            item->exdata<AssaultLog>().toTable(table);
            return true;
        case Type::BrennerBook:
            item->exdata<BrennerBook>().toTable(table);
            return true;
        case Type::MeebleGrimoire:
            item->exdata<MeebleGrimoire>().toTable(table);
            return true;
        case Type::HoneymoonTicket:
            item->exdata<HoneymoonTicket>().toTable(table);
            return true;
        case Type::RaceCertificate:
            item->exdata<RaceCertificate>().toTable(table);
            return true;
        case Type::LotteryTicket:
            item->exdata<LotteryTicket>().toTable(table);
            return true;
        case Type::Tabula:
            item->exdata<Tabula>().toTable(table);
            return true;
        case Type::Evolith:
            item->exdata<Evolith>().toTable(table);
            return true;
        case Type::CraftingSet:
            item->exdata<CraftingSet>().toTable(table);
            return true;
        case Type::GlowingLamp:
            item->exdata<GlowingLamp>().toTable(table);
            return true;
        case Type::ChocoboEgg:
            item->exdata<ChocoboEgg>().toTable(table);
            return true;
        case Type::ChocoboCard:
            item->exdata<ChocoboCard>().toTable(table);
            return true;
        case Type::Fish:
            item->exdata<Fish>().toTable(table);
            return true;
        case Type::Escutcheon:
            item->exdata<Escutcheon>().toTable(table);
            return true;
        case Type::SoulPlate:
            item->exdata<SoulPlate>().toTable(table);
            return true;
        case Type::SoulReflector:
            item->exdata<SoulReflector>().toTable(table);
            return true;
        case Type::WeaponUnlock:
            item->exdata<WeaponUnlock>().toTable(table);
            return true;
        default:
            return false;
    }
}

// Updates item exdata using values from passed table matching exdata type
auto fromTable(CItem* item, const sol::table& data) -> bool
{
    switch (Exdata::getType(item))
    {
        case Type::LegionPass:
            item->exdata<LegionPass>().fromTable(data);
            return true;
        case Type::PerpetualHourglass:
            item->exdata<PerpetualHourglass>().fromTable(data);
            return true;
        case Type::BettingSlip:
            item->exdata<BettingSlip>().fromTable(data);
            return true;
        case Type::AssaultLog:
            item->exdata<AssaultLog>().fromTable(data);
            return true;
        case Type::BrennerBook:
            item->exdata<BrennerBook>().fromTable(data);
            return true;
        case Type::MeebleGrimoire:
            item->exdata<MeebleGrimoire>().fromTable(data);
            return true;
        case Type::HoneymoonTicket:
            item->exdata<HoneymoonTicket>().fromTable(data);
            return true;
        case Type::RaceCertificate:
            item->exdata<RaceCertificate>().fromTable(data);
            return true;
        case Type::LotteryTicket:
            item->exdata<LotteryTicket>().fromTable(data);
            return true;
        case Type::Tabula:
            item->exdata<Tabula>().fromTable(data);
            return true;
        case Type::Evolith:
            item->exdata<Evolith>().fromTable(data);
            return true;
        case Type::CraftingSet:
            item->exdata<CraftingSet>().fromTable(data);
            return true;
        case Type::GlowingLamp:
            item->exdata<GlowingLamp>().fromTable(data);
            return true;
        case Type::ChocoboEgg:
            item->exdata<ChocoboEgg>().fromTable(data);
            return true;
        case Type::ChocoboCard:
            item->exdata<ChocoboCard>().fromTable(data);
            return true;
        case Type::Fish:
            item->exdata<Fish>().fromTable(data);
            return true;
        case Type::Escutcheon:
            item->exdata<Escutcheon>().fromTable(data);
            return true;
        case Type::SoulPlate:
            item->exdata<SoulPlate>().fromTable(data);
            return true;
        case Type::SoulReflector:
            item->exdata<SoulReflector>().fromTable(data);
            return true;
        case Type::WeaponUnlock:
            item->exdata<WeaponUnlock>().fromTable(data);
            return true;
        default:
            return false;
    }
}

} // namespace Exdata
