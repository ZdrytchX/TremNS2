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
kmaxfragValue = 20--4000 / kPersonalResPerKill --40 --20

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
kMedpackPickupDelay = 5--0.25 --0.45 --prevent spammed medpacks from forever healing a player
kMarineRegenerationHeal = 100 --Amount of hp extra over 0.45s

--Personal Use medpacks
kMedpackUseCooldown = 30--Delay between using medpacks
kMedpackUseCost = 100
kMedpackExoUseCooldown = 20
--unused and TODO: kMarineRegenerationTime = 9

--Calculate values + armour minus 5 points for base reward
--(weapon value + 160)/200 * 5 - 5
kLayMinesPointValue = 6--2
kGrenadeLauncherPointValue = 14--20
kShotgunPointValue = 3.75 --5 --3.75 desired but rewards too much with bots in particular
kHeavyMachineGunValue = 9--5
kFlamethrowerPointValue = 10.25--7

kMinigunPointValue = 10
kRailgunPointValue = 8.75
--Health take two biomass. Start health is at biomass level 1
--1.1 rewards:
--[[Granger 200
Adv Granger 250
Dretch 175 / 180
Basi 225-----\
Adv Basi 275--\___ Average 325
Mara 350------/
Adv Mara 450-/
Goon 500
Adv Goon 600
Tyrant 800
--]]
kSkulkHealth = 21    kSkulkArmor = 0    kSkulkPointValue = 4.5--[[180]]     kSkulkHealthPerBioMass = 2
kGorgeHealth = 43   kGorgeArmor = 0    kGorgePointValue = 6.25--[[250]]    kGorgeHealthPerBioMass = 4
kLerkHealth = 65    kLerkArmor = 0     kLerkPointValue = 7.5--[[325]]    kLerkHealthPerBioMass = 5
kFadeHealth = 184    kFadeArmor = 0     kFadePointValue = 14--[[550]]    kFadeHealthPerBioMass = 8
--Onos synced for 400hp @ biomass level 6. Avialable at level 4
kOnosHealth = 325    kOnosArmor = 0   kOnosPointValue = 20--[[800]]      kOnosHealtPerBioMass = 15

kMarineWeaponHealth = 100 --400

kEggHealth = 250    kEggArmor = 0    kEggPointValue = 2
kMatureEggHealth = 250    kMatureEggArmor = 0

kBabblerHealth = 8    kBabblerArmor = 0    kBabblerPointValue = 1
kBabblerEggHealth = 30    kBabblerEggArmor = 0    kBabblerEggPointValue = 3

kParasitePlayerPointValue = 1
kBuildPointValue = 5
kRecyclePaybackScalar = 0.75

kCarapaceHealReductionPerLevel = 0--0.2 --0

--Only because carapiece would do nothing elsewise
kSkulkArmorFullyUpgradedAmount = 3
kGorgeArmorFullyUpgradedAmount = 8--6
kLerkArmorFullyUpgradedAmount = 13--9
kFadeArmorFullyUpgradedAmount = 25--13
kOnosArmorFullyUpgradedAmount = 50

kBalanceInfestationHurtPercentPerSecond = 3
kMinHurtPerSecond = 5--20

-- used for structures
kStartHealthScalar = 0.2--0.3 --has issues with welder

kArmoryHealth = 190    kArmoryArmor = 95    kArmoryPointValue = 5
kAdvancedArmoryHealth = 210    kAdvancedArmoryArmor = 105    kAdvancedArmoryPointValue = 10
kCommandStationHealth = 930    kCommandStationArmor = 620    kCommandStationPointValue = 40
kObservatoryHealth = 100    kObservatoryArmor = 75    kObservatoryPointValue = 10
kPhaseGateHealth = 190    kPhaseGateArmor = 190    kPhaseGatePointValue = 10
kRoboticsFactoryHealth = 200    kRoboticsFactoryArmor = 60    kRoboticsFactoryPointValue = 5
kARCRoboticsFactoryHealth = 200    kARCRoboticsFactoryArmor = 180    kARCRoboticsFactoryPointValue = 7
kPrototypeLabHealth = 250    kPrototypeLabArmor = 125    kPrototypeLabPointValue = 15
kInfantryPortalHealth = 310    kInfantryPortalArmor = 78    kInfantryPortalPointValue = 10
kArmsLabHealth = 800    kArmsLabArmor = 860    kArmsLabPointValue = 25
kSentryBatteryHealth = 250    kSentryBatteryArmor = 125    kSentryBatteryPointValue = 5

-- ALIEN STRUCTURES
kHiveHealth = 750    kHiveArmor = 0    kHivePointValue = 40
kBioMassUpgradePointValue = 20 kUgradedHivePointValue = 20
kMatureHiveHealth = 850 kMatureHiveArmor = 350

kDrifterHealth = 50    kDrifterArmor = 20    kDrifterPointValue = 2--5
kMACHealth = 80    kMACArmor = 50    kMACPointValue = 2
kMineHealth = 20    kMineArmor = 5    kMinePointValue = 1

kExtractorHealth = 280 kExtractorArmor = 185 kExtractorPointValue = 10

-- (2500 = NS1)
kHarvesterHealth = 125 kHarvesterArmor = 0 kHarvesterPointValue = 15
kMatureHarvesterHealth = 200 kMatureHarvesterArmor = 180

kSentryHealth = 70    kSentryArmor = 60    kSentryPointValue = 4
kARCHealth = 210    kARCArmor = 220    kARCPointValue = 5
kARCDeployedHealth = 210    kARCDeployedArmor = 0

kShellHealth = 90     kShellArmor = 50     kShellPointValue = 12
kMatureShellHealth = 180     kMatureShellArmor = 105

kCragHealth = 125    kCragArmor = 0    kCragPointValue = 10
kMatureCragHealth = 150    kMatureCragArmor = 20    kMatureCragPointValue = 12

kWhipHealth = 80    kWhipArmor = 0    kWhipPointValue = 5
kMatureWhipHealth = 125    kMatureWhipArmor = 0    kMatureWhipPointValue = 8

kSpurHealth = 80     kSpurArmor = 0     kSpurPointValue = 12
kMatureSpurHealth = 90  kMatureSpurArmor = 0  kMatureSpurPointValue = 12

kShiftHealth = 150    kShiftArmor = 25    kShiftPointValue = 8
kMatureShiftHealth = 110    kMatureShiftArmor = 115    kMatureShiftPointValue = 10

kVeilHealth = 90     kVeilArmor = 0     kVeilPointValue = 12
kMatureVeilHealth = 125     kMatureVeilArmor = 0     kVeilPointValue = 12

kShadeHealth = 75    kShadeArmor = 0    kShadePointValue = 8
kMatureShadeHealth = 160    kMatureShadeArmor = 0    kMatureShadePointValue = 10

kHydraHealth = 50    kHydraArmor = 0    kHydraPointValue = 2
kMatureHydraHealth = 180    kMatureHydraArmor = 0    kMatureHydraPointValue = 2

kClogHealth = 200  kClogArmor = 0 kClogPointValue = 0
kWebHealth = 50

kCystHealth = 3    kCystArmor = 0
kMatureCystHealth = 60    kMatureCystArmor = 0    kCystPointValue = 1
kMinMatureCystHealth = 50 kMinCystScalingDistance = 48 kMaxCystScalingDistance = 168

kBoneWallHealth = 50 kBoneWallArmor = 50    kBoneWallHealthPerBioMass = 25
kContaminationHealth = 250 kContaminationArmor = 125    kContaminationPointValue = 2

kPowerPointHealth = 430    kPowerPointArmor = 250    kPowerPointPointValue = 10
kDoorHealth = 300    kDoorArmor = 200    kDoorPointValue = 0

kTunnelEntranceHealth = 100    kTunnelEntranceArmor = 0    kTunnelEntrancePointValue = 15
kMatureTunnelEntranceHealth = 380    kMatureTunnelEntranceArmor = 0
