--Conversion Q3 units to Spark meters:
--32	1
--64	2
--96	3
--128	4
--160	5
--192	6
--224	7
--256	8
--288	9
--320 10
--352 11
--384 12
--416 13
--448 14
--480 15
--512 16
--544 17
--576 18
--608 19
--640 20

kAutoBuildRate = 0.5 --0.3
kAutoBuildRateMarine = 0.3

-- setting to true will prevent any placement and construction of marine structures on infested areas
kPreventMarineStructuresOnInfestation = false
kCorrodeMarineStructureArmorOnInfestation = true

kInfestationCorrodeDamagePerSecond = 5--30

kGorgeArmorTunnelDamagePerSecond = 10

--'Metal'/ bp
kMaxSupply =300--200
kSupplyPerTechpoint = 20

-- used as fallback
kDefaultBuildTime = 8

-- MARINE COSTS
--Weapon Stage
--Aim to approx 75 res per stage up for researching weapons alone
--Upgraind armour/biomass/upgrade spurs or the alike later also about 50 res per stage up
--tres = bp

--Upgrades
kWeapons1ResearchCost = 150
kWeapons2ResearchCost = 175
kWeapons3ResearchCost = 200

--helthpool of tremulous: naked 100 armour 333 bsuit 500
--NS2 uses exosuits and seems op to have at 220 so i'll dumb it down lower
--healthpool of TremNS2: 100/178/256/334
--Costs were 20/30/40
kArmor1ResearchCost = 15 --take 5 because arms lab cost increased
kArmor2ResearchCost = 25
kArmor3ResearchCost = 45

--weapons and armour upgrade times
kWeapons1ResearchTime = 60
kWeapons2ResearchTime = 90
kWeapons3ResearchTime = 120
kArmor1ResearchTime = 6
kArmor2ResearchTime = 9
kArmor3ResearchTime = 12

--Increase weapon costs by this amount on stages
--kArmor1WeapCost = 70
--kArmor2WeapCost = 90
--kArmor3WeapCost = 160

--Research (weapons)					SUM
kAdvancedArmoryUpgradeCost = 30 --20	--30
kMineResearchCost  = 15 --10			--40
kShotgunTechResearchCost = 5 --20		--50
kHeavyMachineGunTechResearchCost = 5	--70 --no longer used
--kHeavyRifleTechResearchCost = 30 --Not a valid weapon yet, though i'll use this later
kGrenadeTechResearchCost = 20 --10		--90
kJetpackTechResearchCost = 20	--25	--115
kExosuitTechResearchCost = 35	--20	--140
kPhaseTechResearchCost = 15				--150

kUpgradeRoboticsFactoryCost = 10 --5	--110
kUpgradeRoboticsFactoryTime = 20

--Structure Costs
kCommandStationCost = 40 --15
kExtractorCost = 10
kInfantryPortalCost = 10 --20
kArmoryCost = 10
kArmsLabCost = 20 -- price increase due to decrease in armour 1 cost 15
kPrototypeLabCost = 10 --40
kSentryCost = 8 --5
kPowerNodeCost = 0
kMACCost = 5
kRoboticsFactoryCost = 15
kARCCost = 20 --10

--Weapons
--We'll use tremulous bank of 2000 instead of regular 100
--Conversion to Bp/TeamRes is / 10 for now
kMineCost = 600 --10
kDropMineCost = 40 --15
kGrenadeTechResearchTime = 45

--Weapon Costs are calculated by the tremulous weapon costs + 170 for armour
--Although this seems like a lot, it shouldn't be because weaopns are pick-up-able
kShotgunCost = 310 --20
kShotgunDropCost = 15 --20
--HMG is our lasgun
kHeavyMachineGunCost = 560 --25
kHeavyMachineGunDropCost = 40 --40
--Grenades all price 2
--A litte more expensive than tremulous becuase they explode upon impact
kClusterGrenadeCost = 300
kGasGrenadeCost = 200
kPulseGrenadeCost = 150
--GL is our luci cannon for now
kGrenadeLauncherCost = 760
kGrenadeLauncherDropCost = 60 --20
-- Was 12 creds, but is useful now
kFlamethrowerCost = 610
kFlamethrowerDropCost = 45 --15

--Wielder = painsaw ckit (temporary, prefer painsaw to take primary slot)
kWelderCost = 260 --3 260 100c is too cheap considering how much armour you get for free, and it has such a long range in this game too
kWelderDropCost = 10 --5

--no such thing as a pulse/gas grenade in trem, make up values
kPulseGrenadeDamageRadius = 0.1 --6
kPulseGrenadeEnergyDamageRadius = 6 --10
kPulseGrenadeDamage = 155 --110
kPulseGrenadeEnergyDamage = 0
kPulseGrenadeDamageType = kDamageType.Normal

--Cluster Grenade -> Kinda a regular grenade I guess
kClusterGrenadeDamageRadius = 6 --10
kClusterGrenadeDamage = 310 --55
--little fireworks?
kClusterFragmentDamageRadius = 6 --6
kClusterFragmentDamage = 3 --20
kClusterGrenadeDamageType = kDamageType.Flame --Flame

--doesn't do much by draining armour so i'm changing it to flame type
kNerveGasDamagePerSecond = 16 --50 --get the nervegas to simulate regular poison lasts 9 seconds
kNerveGasDamageType = kDamageType.Flame --NerveGas

--Jetpacks
--Instead of regular 120c, I'm bumping it up since it's quite powerful
kJetpackCost = 280 --15 --120 + 160
kJetpackDropCost = 20 --15

--Battlesuits, but with weapons so instead of 400c, increaseup depending on weapon
--kExosuitCost = 800 --40 I WANT THIS TO WORK AGAIN but oh well
--kClawRailgunExosuitCost = 40 I WANT THIS TO WORK AGAIN but oh well
kDualExosuitCost = 800 --45
kDualRailgunExosuitCost = 750 --mass driver, non rechargable, else if luci then 1000

--don't exist
--kUpgradeToDualMinigunCost = 20
--kUpgradeToDualRailgunCost = 20

--catpack is a little nitpick i won't worry about
--kCatPackTechResearchCost = 15

--kNanoArmorResearchCost = 20

--kRifleUpgradeTechResearchCost = 10

kObservatoryCost = 9 --10 90c for helmet radar
kPhaseGateCost = 10 --15 Teleporters weren't a thing in trem, but they were in korx in the dual form of telenodes

--ALIEN biomass upgrades are honestly a bit expensive
--Adjusted to fit with the armour upgrades
kResearchBioMassOneCost = 10 --15
kResearchBioMassTwoCost = 20 --20
kBioMassOneTime =10
kBioMassTwoTime = 30-- unused?
kBioMassThreeTime = 60


--Upgrades must total around 90 with the remaining abilities 60 tres
--Meaning each upgrdae shells are 10 res each
--Shells
kShellCost = 13--15
kSpurCost = 10--15
kVeilCost = 7 --15

--Structures
kHiveCost = 40
kHarvesterCost = 8

kShiftCost = 10 --13
kShadeCost = 8 --13
kCragCost = 12--13

kWhipCost = 8 --13

--Evolution Classes
--Remember the cap was increased to 2000 so 200 creds per evo
kGorgeCost = 150 --8 --Gorge is special since its a builder so it'll have a mix of basilisk and granger stats
kGorgeEggCost = 15 --15
kLerkCost = 200--375 --18 --Lerk will have mara stats
kLerkEggCost = 40 --30
kFadeCost = 600 --35
kFadeEggCost = 60 --70
kOnosCost = 1000 --62
kOnosEggCost = 100
--Advance upgrades 0/1/3/5/8
--these are also used for scores
kSkulkUpgradeCost = 0--can be increased once marines buy their own armour
kGorgeUpgradeCost = 50
kLerkUpgradeCost = 67
kFadeUpgradeCost = 100
kOnosUpgradeCost = 270	--4 evos upgrade for advance tyrant

--gorge stuff
kHydraCost = 80 --3
kClogCost = 8 --0
kGorgeTunnelCost = 100 --3
kGorgeTunnelBuildTime = 20 --10

kEnzymeCloudDuration = 5 --3

--TEAM START
--Commanders
kPlayingTeamInitialTeamRes = 80 --60
kMaxTeamResources = 200
--Players
kMarineInitialIndivRes = 0 --15
kAlienInitialIndivRes = 0 --12
kCommanderInitialIndivRes = 0
kMaxPersonalResources = 2000
--Resource Gain per RT
kResourceTowerResourceInterval = 4 --6
kTeamResourcePerTick = 0.5 --1 --0.2 works out to 12 res/min/RT, default was 10/min/RT, but since this will be a fast paced mod and games in tremulous usually stage up within minutes. GPP had 1 BP/8sec, while KoRx had 1 bp/2sec. I think 1bp/4sec is more logical, but this means this value will result in 60 res/min.

kPlayerResPerInterval = 3 --0.125 	--'15' @ interval '5' works out to be 180c per minute per RT
							--so 1 @ 1s interval = 60c per minute per RT

kKillTeamReward = 4 --tres awarded to the commander for team doing well

--find enemy, gain their status worth instead of a fixed value of 175 for both onos and skulk. Conversion value respecting Tremulous: 200
kPersonalResPerKill = 200

-- WEAPON DAMAGE
-- MARINE DAMAGE
kRifleDamage = 5
kRifleDamageType = kDamageType.Normal
kRifleClipSize = 30
kRifleMeleeDamage = 8 --10
kRifleMeleeDamageType = kDamageType.Normal
kRifleSpread = Math.Radians(4)--Math.Radians(2.8)

--kHeavyRifleCost = 30

--kHeavyRifleDamage = 10
--kHeavyRifleDamageType = kDamageType.Puncture
--kHeavyRifleClipSize = 75

--LASGUN - HMG fires approx. 18/s so let's put the damage at 2 -> 50 DPS, which is close enough to 45 DPS
--PULSERIFLE
kHeavyMachineGunDamage = 9 --5
kHeavyMachineGunDamageType = kDamageType.Normal--kDamageType.Puncture
kHeavyMachineGunClipSize = 90 --125 9*75 = 5*135
kHeavyMachineGunClipNum = 4 --4
kHeavyMachineGunRange = 200
--kHeavyMachineGunSecondaryRange = 1.1
kHeavyMachineGunSpread = Math.Radians(12) --Math.Radians(4) preferred 8  --prifle has 0 but oh well --12 deg is chaingun


-- 10 bullets per second
kPistolRateOfFire = 0.25 --0.1 0.7 is tremulous balance but feels bad because you have to tap continously
kPistolDamage = 9 --25
kPistolDamageType = kDamageType.Normal--kDamageType.Light
kPistolClipSize = 7--99 --10
kPistolSpread = Math.Radians(1) --0 --mathradians 0.4

--Painsaw/Ckit KoRx Vampire Extreme Sudden Death style
kWelderDamagePerSecond = 147--147 --30 200 DPS is kinda OP for this game, so i'll use GPP's value of 146.7 DPS
kWelderDamageType = kDamageType.Flame --additional damage to structures
kWelderFireDelay = 0.05 --0.2 --GPP: 0.075 // reduced to 0.05 to reduce effectiveness against skulks and lerks and fades

kSelfWeldAmount = 13 --5
kPlayerArmorWeldRate = 40 --20
kSelfHealWeldAmount = 11--6
kPlayerHealWeldRate = 13

kAxeDamage = 8 --25
kAxeDamageType = kDamageType.Structural

--Lucifer Cannon
kGrenadeLauncherGrenadeDamage = 320 --165 256 * 0.8 = 204 damage to players
kGrenadeLauncherGrenadeDamageType = kDamageType.GrenadeLauncher
kGrenadeLauncherClipSize = 1 --4
kGrenadeLauncherGrenadeDamageRadius = 4.7 --4.8 4.7 = 150 units
kGrenadeLifetime = 10 --2

--Shotgun
kShotgunFireRate = 1 --0.88
kShotgunDamage = 4 --10 --7
kShotgunDamageType = kDamageType.Normal
kShotgunClipSize = 8 --6
kShotgunBulletsPerShot = 14 --17 --8 max out at 17 shots since that's all that is defined
kShotgunSpreadDistance = 8.5 --8.5 Gets used as z-axis value for spread vectors before normalization

--FLAMETHROWER
kFlamethrowerDamage = 20 --8 fires 5/sec
kFlameThrowerEnergyDamage = 3
kBurnDamagePerSecond = 1
kCompoundFireDamageDelay = 2
kCompundFireDamageScalar = 0.5
kFlamethrowerDamageType = kDamageType.Flame
kFlamethrowerClipSize = 100--50
--Flamethrower range: 300 speed, 0.8s, and s = ut giving s = 240 units, or 7.5m. GPP has 400*0.7 = 280 = 8.75m
kFlamethrowerRange = 10 --9 might be op because flamer in tremulous uses projectiles and not hitscan like ns2 does

--kBurnDamagePerStackPerSecond = 3
--kFlamethrowerMaxStacks = 30
kFlamethrowerBurnDuration = 6
--kFlamethrowerStackRate = 0.4
kFlameRadius = 1.8
--kFlameDamageStackWeight = 0.5

-- affects dual minigun and dual railgun damage output
--kExoDualMinigunModifier = 1
--kExoDualRailgunModifier = 1

-- CHAINGUN BATTLESUIT
-- heatup rate 0.3/s, cooldown 0.4/s, fires at 0.15s intervals
kMinigunDamage = 6 --10 // 3 * this value at 0.15s intervals... what the fuck, but anyway, 4dmg ~= 80 DPS
kMinigunDamageType = kDamageType.Normal
--not used:
--kMinigunClipSize = 3750 --250 --spits out like 100 rounds per second or something // not used
--melee damage not used
--kClawDamage = 50

--Mass Driver
kRailgunDamage = 38 --33 // 38 1.1 damage 40 GPP damage
kRailgunChargeDamage = 42 --140 // feel bad for not having any boosted damage with charge
kRailgunDamageType = kDamageType.Structural

kMineDamage = 310 --125
kMineDamageType = kDamageType.Light

kSentryAttackDamageType = kDamageType.Normal
kSentryAttackBaseROF = .15
--kSentryAttackRandROF = 0.0
--kSentryAttackBulletsPerSalvo = 1
--kConfusedSentryBaseROF = 2.0

kSentryDamage = 6 --5

kARCDamage = 60 --450 --was 70 in trmens2
kARCDamageType = kDamageType.Structural--kDamageType.Splash -- splash damage hits friendly arcs as well
kARCRange = 20--26
kARCMinRange = 2 --7

local kDamagePerUpgradeScalar = 0.2 --0.1
kWeapons1DamageScalar = 1 + kDamagePerUpgradeScalar
kWeapons2DamageScalar = 1 + kDamagePerUpgradeScalar * 2
kWeapons3DamageScalar = 1 + kDamagePerUpgradeScalar * 3

kNanoShieldDamageReductionDamage = 0.5 --0.68


-- ALIEN DAMAGE

kAlienFocusUpgradeAttackDelay = 1 --FIXME Does not account for variable attack-rates
--(i.e. different attack rates of various alien abilities: Bite ~= Swipe)

--Skulk
kBiteDamage = 96 --75
kBiteDamageType = kDamageType.StructuresOnlyLight --note: it goes back to 96 damage if structure has no armour
kBiteEnergyCost = 6 --5.85

kLeapEnergyCost = 35 --45

kParasiteDamage = 8 --10
kParasiteDamageType = kDamageType.Light --Normal
kParasiteEnergyCost = 30 --30

kXenocideDamage = 200
kXenocideDamageType = kDamageType.Structural --korx: kDamageType.Puncture
kXenocideRange = 7 --14
kXenocideEnergyCost = 2--30


kSpitDamage = 20 --30
--kSpitDamageType = kDamageType.Light
--kSpitEnergyCost = 7

--kBabblerPheromoneEnergyCost = 7
kBabblerDamage = 24 --8 --20
kBabblerDamageType = kDamageType.Normal--kDamageType.Structural

kBabblerCost = 300 --1
--kBabblerEggBuildTime = 6
--kNumBabblerEggsPerGorge = 1
kNumBabblersPerEgg = 6

-- Also see kHealsprayHealStructureRate
kHealsprayDamage = 20 --8
kHealsprayDamageType = kDamageType.Biological
kHealsprayFireDelay = 1 --0.8
kHealsprayEnergyCost = 15 --12
kHealsprayRadius = 3.5
kHealspraySelf = 0.2 --0.5

kBileBombDamage = 16 --this is per interval
kBileBombDamageType = kDamageType.Structural --kDamageType.Corrode
kBileBombEnergyCost = 45
kBileBombDuration = 10 --5
-- 200 inches in NS1 = 5 meters
kBileBombSplashRadius = 6
kBileBombDotInterval = 0.25 --0.4

--Webs become disposable Trappers
kWebBuildCost = 10 --0
kWebbedDuration = 5 --
kWebbedParasiteDuration = 10
kWebSlowVelocityScalar = 0 --0.75Note: Exos override this

--LERK
--will be replacing Marauder instead of basilisk
kLerkBiteDamage = 40 --60
kBitePoisonDamage = 5 --6 per second
kPoisonBiteDuration = 5 --6
kLerkBiteEnergyCost = 5
kLerkBiteDamageType = kDamageType.Puncture--kDamageType.Normal

--kUmbraEnergyCost = 27
--kUmbraMaxRange = 17
--kUmbraDuration = 4
--kUmbraRadius = 4
--modifiers previously 0.75
kUmbraShotgunModifier = 0.5
kUmbraBulletModifier = 0.5
kUmbraMinigunModifier = 0.5
kUmbraRailgunModifier = 0.5

--KoRx style marauder snipe
kSpikeMaxDamage = 15 --7
kSpikeMinDamage = 4 --7
kSpikeDamageType = kDamageType.Structural--Puncture
kSpikeEnergyCost = 15 --1.4
kSpikesAttackDelay = 0.7 --unused
kSpikeMinDamageRange = 40 --9
kSpikeMaxDamageRange = 2
kSpikesRange = 50
kSpikesPerShot = 1

--Spores = KoRx style AIDS
kSporesDamageType = kDamageType.Normal--kDamageType.Gas
kSporesDustDamagePerSecond = 5 --15
kSporesDustFireDelay = 1 --0.36
kSporesMaxRange = 17 --3
kSporesDustEnergyCost = 10 --27
kSporesDustCloudRadius = 10 --4
kSporesDustCloudLifetime = 10 --4

--FADE - Dragoon
kSwipeDamageType = kDamageType.Puncture--kDamageType.StructuresOnlyLight
kSwipeDamage = 80 --75
kSwipeEnergyCost = 7
kMetabolizeEnergyCost = 20 --25

kStabDamage = 110 --160
kStabDamageType = kDamageType.Puncture--kDamageType.Normal
kStabEnergyCost = 50--30

--kVortexEnergyCost = 20
--kVortexDuration = 3

kStartBlinkEnergyCost = 10 --14
kBlinkEnergyCost = 36 --32
kHealthOnBlink = 0

kShadowStepCooldown = 0.4--0.73
kShadowStepForce = 9--21
kShadowStepLimitForce = 1

kGoreDamage = 100 --90
kGoreDamageType = kDamageType.Puncture--kDamageType.Normal--kDamageType.Structural
kGoreEnergyCost = 10

kBoneShieldDamageReduction = 0.4--0.5
--kBoneShieldCooldown = 12.5
--kBoneShieldInitialEnergyCost = 20
kBoneShieldHealPerSecond = 28--14
kBoneShieldArmorPerSecond = 5
kBoneShieldMaxDuration = 10
kBoneShieldMoveFraction = 0
kBoneShieldMinimumFuel = 0.5 --otherwise you can trigger it for a frame and it feels bad

kStompEnergyCost = 30
kStompDamageType = kDamageType.Normal--kDamageType.Heavy
kStompDamage = 111 --40
kStompRange = 10 --12
kDisruptMarineTime = 1--2
kDisruptMarineTimeout = 3--4

--we don't have bonus damage for aliens either
kMelee1DamageScalar = 1
kMelee2DamageScalar = 1
kMelee3DamageScalar = 1

kWhipSlapDamage = 60--50
kWhipBombardDamage = 160 --250
--kWhipBombardDamageType = kDamageType.Corrode
--kWhipBombardRadius = 6
kWhipBombardRange = 15 --10
kWhipBombardROF = 3--6





-- SPAWN TIMES
kMarineRespawnTime = 10 --9

kAlienSpawnTime = 1 --10
kEggGenerationRate = 10--13
kAlienEggsPerHive = 3

-- BUILD/RESEARCH TIMES
kRecycleTime = 5 --12
--kArmoryBuildTime = 12
kAdvancedArmoryResearchTime = 9 --90
kWeaponsModuleAddonTime = 4 --40
kPrototypeLabBuildTime = 13
--kArmsLabBuildTime = 17

kExtractorBuildTime = 7--11

kInfantryPortalBuildTime = 9 --7

kShotgunTechResearchTime = 3 --30
--kHeavyRifleTechResearchTime = 60
kHeavyMachineGunTechResearchTime = 3 --30
kGrenadeLauncherTechResearchTime = 2 --20

kCommandStationBuildTime = 20 --15

kSentryBuildTime = 8 --3 --10
kSentryBatteryCost = 25--10
kSentryBatteryBuildTime = 20 --5

kRoboticsFactoryBuildTime = 8
kMACBuildTime = 10--5
kARCBuildTime = 7
--kARCSplashTechResearchTime = 3 --30
--kARCArmorTechResearchTime = 3 --30

kNanoShieldDuration = 10--5

kNanoShieldResearchCost = 15
kNanoSnieldResearchTime = 60 --command station upgrades can take as long as they want as it isn't essential to the gameplay

kMineResearchTime  = 2 --20
kTechEMPResearchTime = 6 --60
-- I cbf commenting the rest, they are all divided by 10
kJetpackTechResearchTime = 15--9
kExosuitTechResearchTime = 90

kFlamethrowerTechResearchTime = 6

kCatPackTechResearchTime = 45

kObservatoryBuildTime = 15
kPhaseTechResearchTime = 45
kPhaseGateBuildTime = 12

kNanoArmorResearchTime = 60

--ALIEN STRUCTURES
--These times are for drifter build times I believe (without drifter: 30% -> 50% rate)
kHiveBuildTime = 60 --180

kDrifterBuildTime = 10 --4
kHarvesterBuildTime = 20--38

--kShellBuildTime = 18
--kCragBuildTime = 25

kWhipBuildTime = 9 --20
--kEvolveBombardResearchTime = 15

kSpurBuildTime = 8
kShiftBuildTime = 9

kVeilBuildTime = 7
kShadeBuildTime = 9

kHydraBuildTime = 13
kCystBuildTime = 5

kSkulkGestateTime = 0.1--3
kGorgeGestateTime = 1--7
kLerkGestateTime = 3--15
kFadeGestateTime = 6--25
kOnosGestateTime = 10--30

kEggGestateTime = 5--45

kEvolutionGestateTime = 1--3

-- alien ability research cost / time
kChargeResearchCost = 2
kChargeResearchTime = 4
kLeapResearchCost = 3
kLeapResearchTime = 4
kBileBombResearchCost = 1
kBileBombResearchTime = 4
kShadowStepResearchCost = 5
kShadowStepResearchTime = 4
kUmbraResearchCost = 22 --2
kUmbraResearchTime = 4
kBoneShieldResearchCost = 22
kBoneShieldResearchTime = 4
kSporesResearchCost =  2
kSporesResearchTime = 6
kStompResearchCost = 32--2
kStompResearchTime = 6
kStabResearchCost = 22--2
kStabResearchTime = 6
kMetabolizeEnergyResearchCost = 2
kMetabolizeEnergyResearchTime = 4
kMetabolizeHealthResearchCost = 3
kMetabolizeHealthResearchTime = 4
kXenocideResearchCost = 25--5
kXenocideResearchTime = 6

kNanoShieldCost = 5
kNanoShieldCooldown = 20 --10
kEMPCost = 10

kPowerSurgeResearchCost = 15
kPowerSurgeResearchTime = 4
kPowerSurgeCooldown = 10--20
kPowerSurgeDuration = 20
kPowerSurgeCost = 5
kPowerSurgeDamage = 25
kPowerSurgeDamageRadius = 6
kPowerSurgeElectrifiedDuration = 6

kAmmoPackCost = 1
kMedPackCost = 3
kMedPackCooldown = 2
kCatPackCost = 5
kCatPackMoveAddSpeed = 1.2 --1.25
kCatPackWeaponSpeed = 1.5
kCatPackDuration = 10--12

kCystCost = 1
kCystCooldown = 0.0

kEnzymeCloudCost = 2
kHallucinationCloudCost = 3--2
kMucousMembraneCost = 2
kStormCost = 2

kMucousShieldCooldown = 10--5
kMucousShieldPercent = 0.5 --0.15
kMucousShieldDuration = 5

kHallucinationLifeTime = 30

-- only allow x% of affected players to create a hallucination
kPlayerHallucinationNumFraction = 0.34
-- cooldown per entity
kHallucinationCloudCooldown = 10--3
kDrifterAbilityCooldown = 0
kHallucinationCloudAbilityCooldown = 12
kMucousMembraneAbilityCooldown = 1
kEnzymeCloudAbilityCooldown = 1

kNutrientMistCost = 3--2
kNutrientMistCooldown = 5--2
-- Note: If kNutrientMistDuration changes, there is a tooltip that needs to be updated.
kNutrientMistDuration = 15

kRuptureCost = 1--3
kRuptureCooldown = 3--4
kRuptureParasiteTime = 10
kRuptureBurstTime = 1.25 --Time before rupture "pops"
kRuptureEffectTime = 1.5
kRuptureEffectDuration = 3
kRuptureEffectRadius = 8.7

kBoneWallCost = 10--3
kBoneWallCooldown = 16--10

kContaminationCost = 15--5
kContaminationCooldown = 12--6 increase cooldown due to increased lifespan and encouraging camping
kContaminationLifeSpan = 120 --20
kContaminationBileInterval = 2
kContaminationBileSpewCount = 16--3


-- 100% + X (increases by 66%, which is 10 second reduction over 15 seconds)
kNutrientMistPercentageIncrease = 66
kNutrientMistMaturingIncrease = 66

kObservatoryInitialEnergy = 25  kObservatoryMaxEnergy = 100
kObservatoryScanCost = 3
kObservatoryDistressBeaconCost = 10

kMACInitialEnergy = 50  kMACMaxEnergy = 150
kDrifterCost = 8
kDrifterCooldown = 0
kDrifterHatchTime = 7

kCragInitialEnergy = 25  kCragMaxEnergy = 100
kCragHealWaveCost = 3
kHealWaveCooldown = 6
kMatureCragMaxEnergy = 150

kHydraDamage = 40--15 -- From NS1
kHydraAttackDamageType = kDamageType.Normal

kWhipInitialEnergy = 25  kWhipMaxEnergy = 100
kMatureWhipMaxEnergy = 150

kShiftInitialEnergy = 50  kShiftMaxEnergy = 150
kShiftHatchCost = 5
kShiftHatchRange = 11
kMatureShiftMaxEnergy = 200

kEchoHydraCost = 1
kEchoWhipCost = 3--2
kEchoTunnelCost = 5
kEchoCragCost = 1
kEchoShadeCost = 1
kEchoShiftCost = 1
kEchoVeilCost = 1
kEchoSpurCost = 1
kEchoShellCost = 1
kEchoHiveCost = 10
kEchoEggCost = 2
kEchoHarvesterCost = 1--2

kShadeInitialEnergy = 25  kShadeMaxEnergy = 100
kShadeInkCost = 3
kShadeInkCooldown = 16
kShadeInkDuration = 10--6.3
kMatureShadeMaxEnergy = 150

kEnergyUpdateRate = 0.5

-- This is for CragHive, ShadeHive and ShiftHive
kUpgradeHiveCost = 10
kUpgradeHiveResearchTime = 20

kHiveBiomass = 1

kCragBiomass = 0
kShadeBiomass = 0
kShiftBiomass = 0
kWhipBiomass = 0
kHarvesterBiomass = 0
kShellBiomass = 0
kVeilBiomass = 0
kSpurBiomass = 0
