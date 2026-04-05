-----------------------------------
-- Trust: AAEV
-----------------------------------
---@type TSpellTrust
local spellObject = {}

spellObject.onMagicCastingCheck = function(caster, target, spell)
    return xi.trust.canCast(caster, spell)
end

spellObject.onSpellCast = function(caster, target, spell)
    return xi.trust.spawn(caster, spell)
end

spellObject.onMobSpawn = function(mob)
    xi.trust.message(mob, xi.trust.messageOffset.SPAWN)

    mob:setMobMod(xi.mobMod.CAN_SHIELD_BLOCK, 1)
    mob:setMobMod(xi.mobMod.CAN_PARRY, 3)

    local lvl = mob:getMainLvl()
    local shieldMasteryPower = 0

    if lvl >= 96 then
        shieldMasteryPower = 40
    elseif lvl >= 75 then
        shieldMasteryPower = 30
    elseif lvl >= 50 then
        shieldMasteryPower = 20
    elseif lvl >= 25 then
        shieldMasteryPower = 10
    end

    mob:setMod(xi.mod.SHIELD_MASTERY_TP, shieldMasteryPower)
    mob:setMod(xi.mod.SHIELDBLOCKRATE, 45) -- 45% base block rate
    mob:addMod(xi.mod.FASTCAST, 30)
    mob:addMod(xi.mod.CURE_POTENCY, 50)
    mob:addMod(xi.mod.DMG, -10)
    mob:addMod(xi.mod.HPP, 20)
    mob:addMod(xi.mod.ABSORB_PHYSDMG_TO_MP, 5)
    local lastSynergyBonus = 0

    -- Dynamic modifier that checks party member list on tick to apply
    mob:addListener('COMBAT_TICK', 'AAEV_CTICK', function(mobArg)
        local synergyMembers =
        {
            xi.magic.spell.AAHM,
            xi.magic.spell.AAMR,
            xi.magic.spell.AATT,
            xi.magic.spell.AAGK
        }

        local synergyCount = 0
        local party = mobArg:getMaster():getPartyWithTrusts()

        for _, member in pairs(party) do
            if member:getObjType() == xi.objType.TRUST then
                local trustId = member:getTrustID()
                for _, sId in ipairs(synergyMembers) do
                    if trustId == sId then
                        synergyCount = synergyCount + 1
                        break
                    end
                end
            end
        end

        -- Determine what the bonus should be
        local targetBonus = (synergyCount == #synergyMembers) and 50 or 0

        -- Only update if the state has changed
        if targetBonus ~= lastSynergyBonus then
            -- AAEV already has a MEVA value so we just manipulate it
            -- Subtract exactly what we added last time
            mobArg:delMod(xi.mod.MEVA, lastSynergyBonus)
            -- Add the new bonus
            mobArg:addMod(xi.mod.MEVA, targetBonus)

            -- Update lastSynergyBonus
            lastSynergyBonus = targetBonus
        end
    end)

    -----------------------------------
    -- Gambits
    -----------------------------------
    -- 1 condition
    mob:addGambit(ai.t.TARGET,  { ai.c.NOT_STATUS,         xi.effect.FLASH         }, { ai.r.MA, ai.s.SPECIFIC,        xi.magic.spell.FLASH      })
    mob:addGambit(ai.t.SELF,    { ai.c.HPP_LT,             75                      }, { ai.r.MA, ai.s.HIGHEST,         xi.magic.spellFamily.CURE })
    mob:addGambit(ai.t.PARTY,   { ai.c.HPP_LT,             50                      }, { ai.r.MA, ai.s.HIGHEST,         xi.magic.spellFamily.CURE })
    mob:addGambit(ai.t.TARGET,  { ai.c.CASTING_ELE_MA_AOE, 0                       }, { ai.r.MS, ai.s.SPECIFIC,        3714                      }) -- Shield Strike
    mob:addGambit(ai.t.TARGET,  { ai.c.STATUS,             xi.effect.MANAFONT      }, { ai.r.JA, ai.s.SPECIFIC,        xi.ja.RAMPART             })
    mob:addGambit(ai.t.TARGET,  { ai.c.STATUS,             xi.effect.CHAINSPELL    }, { ai.r.JA, ai.s.SPECIFIC,        xi.ja.RAMPART             })
    mob:addGambit(ai.t.TARGET,  { ai.c.STATUS,             xi.effect.ASTRAL_FLOW   }, { ai.r.JA, ai.s.SPECIFIC,        xi.ja.RAMPART             })
    mob:addGambit(ai.t.SELF,    { ai.c.NOT_STATUS,         xi.effect.PHALANX       }, { ai.r.MA, ai.s.SPECIFIC,        xi.magic.spell.PHALANX    })
    mob:addGambit(ai.t.SELF,    { ai.c.NOT_STATUS,         xi.effect.REPRISAL      }, { ai.r.MA, ai.s.SPECIFIC,        xi.magic.spell.REPRISAL   })
    mob:addGambit(ai.t.SELF,    { ai.c.NOT_STATUS,         xi.effect.SENTINEL      }, { ai.r.JA, ai.s.SPECIFIC,        xi.ja.SENTINEL            })
    mob:addGambit(ai.t.SELF,    { ai.c.NOT_STATUS,         xi.effect.ENLIGHT       }, { ai.r.MA, ai.s.SPECIFIC,        xi.magic.spell.ENLIGHT    })
    mob:addGambit(ai.t.SELF,    { ai.c.NOT_STATUS,         xi.effect.DIVINE_EMBLEM }, { ai.r.JA, ai.s.SPECIFIC,        xi.ja.DIVINE_EMBLEM       })
    mob:addGambit(ai.t.SELF,    { ai.c.NOT_STATUS,         xi.effect.PALISADE      }, { ai.r.JA, ai.s.SPECIFIC,        xi.ja.PALISADE            })

    -- 2 conditions
    mob:addGambit(ai.t.SELF,    { { ai.c.MPP_LT,           25                      }, { ai.c.TP_GTE,           1000 }, }, { ai.r.JA, ai.s.SPECIFIC,        xi.ja.CHIVALRY })

    mob:setTrustTPSkillSettings(ai.tp.CLOSER_UNTIL_TP, ai.s.RANDOM, 2000)

    mob:addListener('WEAPONSKILL_USE', 'AAEV_WEAPONSKILL_USE', function(mobArg, target, skill, tp, action)
        local skillId = skill:getID()
        if skillId == xi.mobSkill.ARROGANCE_INCARNATE_2 then
            xi.trust.message(mobArg, xi.trust.messageOffset.SPECIAL_MOVE_1)
        elseif skillId == xi.mobSkill.DOMINION_SLASH_2 then
            xi.trust.message(mobArg, xi.trust.messageOffset.SPECIAL_MOVE_2)
        end
    end)
end

spellObject.onMobDespawn = function(mob)
    xi.trust.message(mob, xi.trust.messageOffset.DESPAWN)
end

spellObject.onMobDeath = function(mob)
    xi.trust.message(mob, xi.trust.messageOffset.DEATH)
end

return spellObject
