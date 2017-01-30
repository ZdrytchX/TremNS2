-- ======= Copyright (c) 2003-2011, Unknown Worlds Entertainment, Inc. All rights reserved. =======
--
-- lua\BalanceMisc.lua
--
--    Created by:   Charlie Cleveland (charlie@unknownworlds.com)
--
-- ========= For more information, visit us at http://www.unknownworlds.com =====================

kAlienStructureMoveSpeed = 3--1.5
kShiftStructurespeedScalar = 1

kPoisonDamageThreshhold = 5

kSpawnBlockRange = 5

kInfestationBuildModifier = 0.5--0.75

-- Time spawning alien player must be in egg before hatching
kAlienSpawnTime = 9
kInitialMACs = 1--0
-- Construct at a slower rate than players
kMACConstructEfficacy = 1--.3
kFlamethrowerAltTechResearchCost = 20
--FOV can be increased by 20 by client settings
kDefaultFov = 90
kEmbryoFov = 130
kSkulkFov = 120
kGorgeFov = 75
kLerkFov = 105
kFadeFov = 100
kOnosFov = 95
kExoFov = 95

kNanoArmorHealPerSecond = 0.5

kResearchMod = 1

kMinSupportedRTs = 0
kRTsPerTechpoint = 3

kEMPBlastEnergyDamage = 50

kEnzymeAttackSpeed = 1.25
kElectrifiedAttackSpeed = 0.8
kElectrifiedDuration = 5

kHallucinationHealthFraction = 0.25--0.20
kHallucinationArmorFraction = 0
kHallucinationMaxHealth = 700

-- set to -1 for no time limit
kParasiteDuration = 44

-- increases max speed by 1.5 m/s
kCelerityAddSpeed = 2 --1.5

-- add delay between attacks equal to this value times the attack duration.  A value of 1 will half the effective attack speed.
-- 'at max' refers to # of veils.  3 = max, 0 = no effect.
kFocusAttackSlowAtMax = 0.5

kHydrasPerHive = 3
kClogsPerHive = 10
kNumWebsPerGorge = 3
kCystInfestDuration = 37.5

kSentriesPerBattery = 8--3

kStructureCircleRange = 5--4
kInfantryPortalAttachRange = 40 --10
kArmoryWeaponAttachRange = 40
-- Minimum distance that initial IP spawns away from team location
kInfantryPortalMinSpawnDistance = 4
kItemStayTime = 15--30 ns1
kWeaponStayTime = 5 --25

-- For power points
kMarineRepairHealthPerSecond = 20 --600
-- The base weapons need to cost a small amount otherwise they can
-- be spammed.
kRifleCost = 0
kPistolCost = 0
kAxeCost = 0
kInitialDrifters = 0
kSkulkCost = 0

kMACSpeedAmount = .5
-- How close should MACs/Drifters fly to operate on target
kCommandStationEngagementDistance = 4
kInfantryPortalEngagementDistance = 2
kArmoryEngagementDistance = 3
kArmsLabEngagementDistance = 3
kExtractorEngagementDistance = 2
kObservatoryEngagementDistance = 1
kPhaseGateEngagementDistance = 2
kRoboticsFactorEngagementDistance = 5
kARCEngagementDistance = 2
kSentryEngagementDistance = 2
kPlayerEngagementDistance = 1
kExoEngagementDistance = 1.5
kOnosEngagementDistance = 2
kLerkSporeShootRange = 10

-- entrance and exit
kNumGorgeTunnels = 2

-- maturation time for alien buildings
kHiveMaturationTime = 600--180 --300
kHarvesterMaturationTime = 150 --150
kWhipMaturationTime = 250--120
kCragMaturationTime = 180--120
kShiftMaturationTime = 120--90
kShadeMaturationTime = 210--120
kVeilMaturationTime = 150--60
kSpurMaturationTime = 90--60
kShellMaturationTime = 270--60
kCystMaturationTime = 60--45
kHydraMaturationTime = 60--140
kEggMaturationTime = 60--100
kTunnelEntranceMaturationTime = 35

kNutrientMistMaturitySpeedup = 5--2
kNutrientMistAutobuildMultiplier = 2--1

kMinBuildTimePerHealSpray = 0.9
kMaxBuildTimePerHealSpray = 1.8

-- Scanner sweep
kScanDuration = 10
kScanRadius = 20

-- Distress Beacon (from NS1)
kDistressBeaconRange = 25
kDistressBeaconTime = 3

kEnergizeRange = 17
-- per stack
kEnergizeEnergyIncrease = .25
kStructureEnergyPerEnergize = 0.15
kPlayerEnergyPerEnergize = 15
kEnergizeUpdateRate = 1

kEchoRange = 20--8

kSprayDouseOnFireChance = .5

-- Players get energy back at this rate when on fire
kOnFireEnergyRecuperationScalar = 0.75--1

-- Players get energy back at this rate when electrified
kElectrifiedEnergyRecuperationScalar = 0.5--.7

-- Infestation
kStructureInfestationRadius = 2
kHiveInfestationRadius = 30--20
kInfestationRadius = 9.5--7.5
kMarineInfestationSpeedScalar = .5--.1

kDamageVelocityScalar = 2.5

-- Each upgrade costs this much extra evolution time
kUpgradeGestationTime = 1--2

-- Cyst parent ranges, how far a cyst can support another cyst
--
-- NOTE: I think the range is a bit long for kCystMaxParentRange, there will be gaps between the
-- infestation patches if the range is > kInfestationRadius * 1.75 (about).
--
kHiveCystParentRange = 24 -- distance from a hive a cyst can be connected
kCystMaxParentRange = 24 -- distance from a cyst another cyst can be placed
kCystRedeployRange = 7 -- distance from existing Cysts that will cause redeployment

-- Damage over time that all cysts take when not connected
kCystUnconnectedDamage = 3--12

-- Jetpack
--kUpgradedJetpackUseFuelRate = .19
kJetpackingAccel = 0.8
kJetpackUseFuelRate = 0.3--.21
kJetpackReplenishFuelRate = 0.2--.11

-- Mines
kNumMines = 2
kMineActiveTime = 2--4
kMineAlertTime = 5--8
kMineDetonateRange = 5
kMineTriggerRange = 4.5--1.5

-- Onos
kGoreMarineFallTime = 1
kDisruptTime = 5

kEncrustMaxLevel = 5
kSpitObscureTime = 8
kGorgeCreateDistance = 6.5

kMaxTimeToSprintAfterAttack = .2

-- Welding variables
-- Also: MAC.kRepairHealthPerSecond
-- Also: Exo -> kArmorWeldRate
kWelderPowerRepairRate = 120--220
kBuilderPowerRepairRate = 60--220
kWelderSentryRepairRate = 60--150
kPlayerWeldRate = 30
kStructureWeldRate = 60--90
kDoorWeldTime = 15

kHatchCooldown = 8--4
kEggsPerHatch = 5--2

kAlienRegenerationTime = 1 --2

-- Non-upgraded regeneration
kAlienInnateRegenerationPercentage  = 0.03 --gives 12hp for 400hp, 7.5hp for 250hp, 6hp for 200hp
--min/max raw regneeration values
kAlienMinInnateRegeneration = 1
kAlienMaxInnateRegeneration = 14--20

-- boosted regenreation assuming 3 shells
kAlienRegenerationPercentage = 0.03
kAlienMinRegeneration = 3--6
kAlienMaxRegeneration = 21--80

-- when in combat self healing (innate healing or through upgrade) is multiplied with this value
kAlienRegenerationCombatModifier = 0.5

kAlienHealRateTimeLimit = 1
kAlienHealRateLimit = 1000
kAlienHealRatePercentLimit = 2--1
kAlienHealRateOverLimitReduction = 1
kOnFireHealingScalar = 0.5
-- Carries the umbra cloud for x additional seconds
kUmbraRetainTime = 2--0.25

--Special Movement Ability energy costs
kBellySlideCost = 25
kLerkFlapEnergyCost = 4--3
kFadeShadowStepCost = 10--11
kChargeEnergyCost = 30 -- per second

kAbilityMaxEnergy = 100
kAdrenalineAbilityMaxEnergy = 130

--No weights for weapons
kPistolWeight = 0
kRifleWeight = 0
kHeavyRifleWeight = 0
kHeavyMachineGunWeight = 0
kGrenadeLauncherWeight = 0
kFlamethrowerWeight = 0
kShotgunWeight = 0

kJetpackWeightLiftForce = 0.13 --How much weight the jetpack lifts
kMinWeightJetpackFuelFactor = 0.8 --Min factor that gets applied on fuel usage of jetpack

kHandGrenadeWeight = 0
kLayMineWeight = 0

kClawWeight = 0
kMinigunWeight = 0
kRailgunWeight = 0

kMinWebLength = 0.5
kMaxWebLength = 10--8
--Metal stuff that limits per-map
kMACSupply = 2--10
kArmorySupply = 2--5
kARCSupply = 20
kSentrySupply = 8--10
kRoboticsFactorySupply = 3--5
kInfantryPortalSupply = 10--0
kPhaseGateSupply = 2--0

kDrifterSupply = 2--10
kWhipSupply = 6--5
kCragSupply = 5
kShadeSupply = 5--2
kShiftSupply = 2--5
