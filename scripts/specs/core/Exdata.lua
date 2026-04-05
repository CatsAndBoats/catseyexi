---@meta

---@class ExdataLegionPass
---@field timestamp? integer                                    # How long until the pass expires. Usually 5 minutes from creation.
---@field title?     xi.legion.title                            # Legion chamber
---@field signature? string                                     # 12 characters pass owner name

---@class ExdataPerpetualHourglass
---@field flags?     integer                                    # Undocumented flags. Changes Hourglass text color to denote status.
---@field startTime? integer                                    # Reservation start time
---@field endTime?   integer                                    # Reservation end time
---@field zoneId?    xi.zone                                    # Zone reserved by Hourglass

---@class ExdataBettingSlip
---@field raceId?       integer                                 # Chocobo race ID [0-262143]
---@field raceGrade?    xi.chocoboRacing.raceGrade
---@field racePairingL? integer                                 # [0-7], 0-indexed chocobo entry
---@field racePairingR? integer                                 # [0-7], 0-indexed chocobo entry
---@field quills?       integer                                 # [0-999]

---@class ExdataAssaultLog
---@field flags? boolean[]                                      # 10 flags indexed [1-10] representing completed assaults.

---@class ExdataBrennerBook
---@field timeValue? integer                                    # Seconds since epoch 1009929600 (Jan 2, 2002 00:00 UTC)
---@field level?     xi.brenner.levelCap

---@class ExdataMeebleGrimoire
---@field clears? table<xi.meeble.expeditionType, integer[]>    # clears[expeditionType][level] = count (0-7)
---@field count?  integer                                       # Distinct expedition count
---@field zone?   xi.meeble.zone

---@class ExdataHoneymoonTicket
---@field plan? xi.chocoboRaising.honeymoonPlan

---@class ExdataRaceCertificate
---@field raceId?    integer                                    # [0-262143]
---@field raceGrade? xi.chocoboRacing.raceGrade

---@class ExdataLotteryTicket
---@field number? integer                                       # [0-16777215]
---@field title?  xi.bonanza.eventId

---@class ExdataTabulaRune
---@field id?       xi.maze.rune
---@field rotation? integer                                     # Rune rotation [0-3]
---@field position? integer                                     # Grid index [0-24] on the 5x5 board

---@class ExdataTabula
---@field voucher? xi.maze.voucher
---@field runes?   ExdataTabulaRune[]                           # Up to 12 runes
---@field uses?    integer                                      # Uses count [0-127] (Tabula R only)

---@class ExdataEvolith
---@field augment?   integer                                    # Augment ID [0-1023]
---@field shape?     xi.evolith.shape
---@field element?   xi.evolith.element
---@field bonus?     integer                                    # Bonus [0-15]
---@field signature? string                                     # 12 characters

---@class ExdataCraftingSet
---@field quality?   integer
---@field signature? string                                     # 12 characters

---@class ExdataGlowingLamp
---@field chamberId? xi.einherjar.chamber
---@field flags?     integer                                    # Undocumented flags
---@field startTime? integer                                    # Reservation start time
---@field endTime?   integer                                    # Reservation end time

---@class ExdataChocoboEgg
---@field dna?      integer[]                                   # 3 color genes indexed [1-3], each [0-7]
---@field ability?  xi.chocoboRaising.ability
---@field plan?     xi.chocoboRaising.honeymoonPlan
---@field isBred?   boolean                                     # Whether the egg is from breeding

---@class ExdataChocoboStatByte
---@field trait? boolean                                        # Physical trait flag (legs/tail/head)
---@field rp?    integer
---@field rank?  xi.chocoboRaising.statRank

---@class ExdataChocoboStatByteRCP
---@field rp?   integer
---@field rank? xi.chocoboRaising.statRank

---@class ExdataChocoboCard
---@field strength?    ExdataChocoboStatByte                    # Strength (legs trait)
---@field endurance?   ExdataChocoboStatByte                    # Endurance (tail trait)
---@field discernment? ExdataChocoboStatByte                    # Discernment (head trait)
---@field receptivity? ExdataChocoboStatByteRCP
---@field dna?         integer[]                                # 3 color genes indexed [1-3], each [0-7]
---@field abilities?   xi.chocoboRaising.ability[]
---@field temperament? xi.chocoboRaising.temperament
---@field weather?     xi.chocoboRaising.weather
---@field gender?      xi.chocoboRaising.gender
---@field color?       xi.chocoboRaising.color
---@field size?        xi.chocoboRacing.jockeySize
---@field name?        string                                    # 12 characters chocobo name

---@class ExdataFish
---@field size?     integer                                      # Im, [0-65535]
---@field weight?   integer                                      # Pz, [0-65535]
---@field isRanked? boolean

---@class ExdataEscutcheon
---@field status?             integer                            # 0 = no craftsmanship data
---@field bonusObjective?     xi.escutcheon.bonusObjective
---@field craftsmanship?      integer                            # Raw craftsmanship accumulator
---@field stage?              xi.escutcheon.stage
---@field successDownPenalty? integer                            # Scutum only. Accumulated penalty [0-65535]. Client display = (value-128)/3, capped at -30
---@field signature?          string                             # 12 characters

---@class ExdataSoulPlate
---@field signature?     string                                  # 14 characters mob name
---@field zoneId?        xi.zone
---@field superFamilyId? xi.mobSuperFamily
---@field poolId?        xi.mobPool
---@field level?         integer
---@field feralSkill?    xi.pankration.feralSkill
---@field feralPoints?   integer
---@field quality?       integer                                 # Zeni score based on distance, facing, HP%, claim [0-63]

---@class ExdataFeralSkillSlot
---@field skillId? xi.pankration.feralSkill|integer
---@field level?   integer

---@class ExdataSoulReflector
---@field nameFirst?      xi.pankration.firstName
---@field nameLast?       xi.pankration.secondName
---@field poolId?         xi.mobPool|integer
---@field exp?            integer                                # Experience points [0-200]
---@field discipline?     integer                                # Discipline accumulator [0-255]. /16 = xi.pankration.discipline
---@field temperament?    integer                                # Tame/wild axis [0-15]. /2 = xi.pankration.temperament
---@field aggressiveness? integer                                # Aggressive/defensive axis [0-15]. /2 = xi.pankration.aggressiveness
---@field level?          integer                                # Monster level [1-50]
---@field feralSkills?    ExdataFeralSkillSlot[]                 # 7 slots: 1-5 equipped, 6-7 innate

---@class ExdataWeaponUnlock
---@field unlockPoints? integer

---@alias Exdata ExdataLegionPass|ExdataPerpetualHourglass|ExdataBettingSlip|ExdataAssaultLog|ExdataBrennerBook|ExdataMeebleGrimoire|ExdataHoneymoonTicket|ExdataRaceCertificate|ExdataLotteryTicket|ExdataTabula|ExdataEvolith|ExdataCraftingSet|ExdataGlowingLamp|ExdataChocoboEgg|ExdataChocoboCard|ExdataFish|ExdataEscutcheon|ExdataSoulPlate|ExdataSoulReflector|ExdataWeaponUnlock
