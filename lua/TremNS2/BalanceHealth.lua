-- ======= Copyright (c) 2003-2012, Unknown Worlds Entertainment, Inc. All rights reserved. =======
--
-- lua\BalanceHealth.lua
--
--    Created by:   Charlie Cleveland (charlie@unknownworlds.com)
--
-- ========= For more information, visit us at http://www.unknownworlds.com =====================

--Time interval allowed for healing to be clamped
kHealingClampInterval = 2
kHealingClampMaxHPAmount = 0.2
kHealingClampReductionScalar = 0.2

--Credit Conversion: 200c = 5 points
--Also remember that the stuff are stacked except jetpack is its own class
k1fragValue = 5
kmaxfragValue = 40 --20

-- HEALTH AND ARMOR
--Weapons and upgrades are added upon base value (e.g. shotgun = 3 + 5)
kMarineHealth = 100    kMarineArmor = 0    kMarinePointValue = 5
kJetpackHealth = 100    kJetpackArmor = 0    kJetpackPointValue = 8--10
kExosuitHealth = 100    kExosuitArmor = 250    kExosuitPointValue = 10--20
kArmorPerUpgradeLevel = 39--78 effective, totallying 334 equivalent health
kExosuitArmorPerUpgradeLevel = 0--30
kArmorHealScalar = 1 -- 0.75

--Medpack
kMedpackHeal = 1--25
kMedpackArmour = 59--29
kMedpackExo = 160
kMedpackPickupDelay = 0.25 --0.45
kMarineRegenerationHeal = 100 --Amount of hp extra over 0.45s

--Personal Use medpacks
kMedpackUseCooldown = 20--Delay between using medpacks
kMedpackUseCost = 100
kMedpackExoUseCooldown = 8
--unused and TODO: kMarineRegenerationTime = 9

--Calculate values + armour minus 5 points for base reward
--(weapon value + 160)/200 * 5 - 5
kLayMinesPointValue = 7.5--2
kGrenadeLauncherPointValue = 14--20
kShotgunPointValue = 3.75 --5 --3.75 desired but rewards too much with bots in particular
kHeavyMachineGunValue = 9--5
kFlamethrowerPointValue = 10.25--7

kMinigunPointValue = 10
kRailgunPointValue = 8.75
--Health take one biomass
kSkulkHealth = 23    kSkulkArmor = 0    kSkulkPointValue = 4.5--[[7]]     kSkulkHealthPerBioMass = 1
kGorgeHealth = 69   kGorgeArmor = 0    kGorgePointValue = 6.25--[[10]]    kGorgeHealthPerBioMass = 3
kLerkHealth = 65    kLerkArmor = 0     kLerkPointValue = 7.5--[[15]]    kLerkHealthPerBioMass = 5
kFadeHealth = 184    kFadeArmor = 0     kFadePointValue = 14--[[20]]    kFadeHealthPerBioMass = 8
kOnosHealth = 275    kOnosArmor = 0   kOnosPointValue = 20--[[30]]      kOnosHealtPerBioMass = 25

kMarineWeaponHealth = 100 --400

kEggHealth = 250    kEggArmor = 0    kEggPointValue = 2
kMatureEggHealth = 250    kMatureEggArmor = 0

kBabblerHealth = 8    kBabblerArmor = 0    kBabblerPointValue = 1
kBabblerEggHealth = 30    kBabblerEggArmor = 0    kBabblerEggPointValue = 3

kParasitePlayerPointValue = 1
kBuildPointValue = 5
kRecyclePaybackScalar = 0.75

kCarapaceHealReductionPerLevel = -0.2 --0

--Only because carapiece would do nothing elsewise
kSkulkArmorFullyUpgradedAmount = 3
kGorgeArmorFullyUpgradedAmount = 6
kLerkArmorFullyUpgradedAmount = 9
kFadeArmorFullyUpgradedAmount = 13
kOnosArmorFullyUpgradedAmount = 50

kBalanceInfestationHurtPercentPerSecond = 3
kMinHurtPerSecond = 5--20

-- used for structures
kStartHealthScalar = 0.1--0.3

kArmoryHealth = 380    kArmoryArmor = 380    kArmoryPointValue = 5
kAdvancedArmoryHealth = 420    kAdvancedArmoryArmor = 420    kAdvancedArmoryPointValue = 10
kCommandStationHealth = 930    kCommandStationArmor = 930    kCommandStationPointValue = 20
kObservatoryHealth = 150    kObservatoryArmor = 50    kObservatoryPointValue = 10
kPhaseGateHealth = 190    kPhaseGateArmor = 190    kPhaseGatePointValue = 10
kRoboticsFactoryHealth = 200    kRoboticsFactoryArmor = 60    kRoboticsFactoryPointValue = 5
kARCRoboticsFactoryHealth = 200    kARCRoboticsFactoryArmor = 280    kARCRoboticsFactoryPointValue = 7
kPrototypeLabHealth = 250    kPrototypeLabArmor = 250    kPrototypeLabPointValue = 15
kInfantryPortalHealth = 310    kInfantryPortalArmor = 310    kInfantryPortalPointValue = 10
kArmsLabHealth = 800    kArmsLabArmor = 900    kArmsLabPointValue = 25
kSentryBatteryHealth = 750    kSentryBatteryArmor = 50    kSentryBatteryPointValue = 5

-- ALIEN STRUCTURES
kHiveHealth = 750    kHiveArmor = 15    kHivePointValue = 30
kBioMassUpgradePointValue = 5 kUgradedHivePointValue = 5
kMatureHiveHealth = 850 kMatureHiveArmor = 850

kDrifterHealth = 50    kDrifterArmor = 20    kDrifterPointValue = 2--5
kMACHealth = 50    kMACArmor = 50    kMACPointValue = 2
kMineHealth = 20    kMineArmor = 5    kMinePointValue = 1

kExtractorHealth = 280 kExtractorArmor = 185 kExtractorPointValue = 10

-- (2500 = NS1)
kHarvesterHealth = 125 kHarvesterArmor = 0 kHarvesterPointValue = 15
kMatureHarvesterHealth = 200 kMatureHarvesterArmor = 180

kSentryHealth = 70    kSentryArmor = 60    kSentryPointValue = 4
kARCHealth = 210    kARCArmor = 380    kARCPointValue = 5
kARCDeployedHealth = 210    kARCDeployedArmor = 0

kShellHealth = 90     kShellArmor = 50     kShellPointValue = 12
kMatureShellHealth = 180     kMatureShellArmor = 105

kCragHealth = 125    kCragArmor = 0    kCragPointValue = 10
kMatureCragHealth = 150    kMatureCragArmor = 20    kMatureCragPointValue = 12

kWhipHealth = 125    kWhipArmor = 0    kWhipPointValue = 5
kMatureWhipHealth = 150    kMatureWhipArmor = 50    kMatureWhipPointValue = 8

kSpurHealth = 80     kSpurArmor = 0     kSpurPointValue = 12
kMatureSpurHealth = 90  kMatureSpurArmor = 0  kMatureSpurPointValue = 12

kShiftHealth = 75    kShiftArmor = 50    kShiftPointValue = 8
kMatureShiftHealth = 110    kMatureShiftArmor = 50    kMatureShiftPointValue = 10

kVeilHealth = 90     kVeilArmor = 0     kVeilPointValue = 12
kMatureVeilHealth = 110     kMatureVeilArmor = 0     kVeilPointValue = 12

kShadeHealth = 75    kShadeArmor = 0    kShadePointValue = 8
kMatureShadeHealth = 160    kMatureShadeArmor = 0    kMatureShadePointValue = 10

kHydraHealth = 50    kHydraArmor = 0    kHydraPointValue = 2
kMatureHydraHealth = 90    kMatureHydraArmor = 0    kMatureHydraPointValue = 2

kClogHealth = 300  kClogArmor = 0 kClogPointValue = 0
kWebHealth = 50

kCystHealth = 3    kCystArmor = 0
kMatureCystHealth = 60    kMatureCystArmor = 0    kCystPointValue = 1
kMinMatureCystHealth = 50 kMinCystScalingDistance = 48 kMaxCystScalingDistance = 168

kBoneWallHealth = 50 kBoneWallArmor = 25    kBoneWallHealthPerBioMass = 50
kContaminationHealth = 250 kContaminationArmor = 125    kContaminationPointValue = 2

kPowerPointHealth = 430    kPowerPointArmor = 250    kPowerPointPointValue = 10
kDoorHealth = 300    kDoorArmor = 200    kDoorPointValue = 0

kTunnelEntranceHealth = 100    kTunnelEntranceArmor = 0    kTunnelEntrancePointValue = 15
kMatureTunnelEntranceHealth = 380    kMatureTunnelEntranceArmor = 0
