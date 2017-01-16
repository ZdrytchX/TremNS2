--globals for balance-extension tweaking
kAlienCrushDamagePercentByLevel = 0.3334--0.07  --Max 21%
kAlienVampirismHealingScalarPerLevel = 0.3334

kLifeformVampirismScalars = {} --FIXME change to Weapon/Doer classnames, not lifeform
kLifeformVampirismScalars["Skulk"] = 3--14 Tremulous gpp-1.1 approximate values, kinda forgot actual values
kLifeformVampirismScalars["Gorge"] = 4--15
kLifeformVampirismScalars["LerkBite"] = 9--10
kLifeformVampirismScalars["LerkSpikes"] = 5--2 5 is an arbitary number
kLifeformVampirismScalars["Fade"] = 16--20
kLifeformVampirismScalars["Onos"] = 20--40  --Stomp?

kSpreadingDamageScalar = 0.75

kBaseArmorUseFraction = 0.67--0.7
kExosuitArmorUseFraction = 1 -- exos have no health

--These don't work?
kStructuralDamageScalar = 2
kPuncturePlayerDamageScalar = 2
kGLPlayerDamageReduction = 0.8 --doesn't work
kFTStructureDamage = 1--1.125

kLightHealthPerArmor = 2--4
kHealthPointsPerArmor = 2
kHeavyHealthPerArmor = 1

kFlameableMultiplier = 1.5--1.125
--bile bomb modifiers
kCorrodeDamagePlayerArmorScalar = 0.5--0.12
kCorrodeDamageExoArmorScalar = 0.5--0.4

kStructureLightHealthPerArmor = 9
kStructureLightArmorUseFraction = 0.9

-- deal only 33% of damage to friendlies
kFriendlyFireScalar = 0.5--0.33
