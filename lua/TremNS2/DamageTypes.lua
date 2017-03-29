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

kLightHealthPerArmor = 4 --effects mines and parasite
kHealthPointsPerArmor = 2
kHeavyHealthPerArmor = 1

kFlameableMultiplier = 1.5--1.125
--bile bomb modifiers
kCorrodeDamagePlayerArmorScalar = 0.5--0.12
kCorrodeDamageExoArmorScalar = 0.5--0.4

kStructureLightHealthPerArmor = 9
kStructureLightArmorUseFraction = 0.9

-- deal only 33% of damage to friendlies
kFriendlyFireScalar = 1--0.33

--local function spam--


local function ApplyDefaultArmorUseFraction(target, attacker, doer, damage, armorFractionUsed, healthPerArmor, damageType, hitPoint)
    return damage, kBaseArmorUseFraction, healthPerArmor
end

local function ApplyHighArmorUseFractionForExos(target, attacker, doer, damage, armorFractionUsed, healthPerArmor, damageType, hitPoint)

    if target:isa("Exo") then
        armorFractionUsed = kExosuitArmorUseFraction
    end

    return damage, armorFractionUsed, healthPerArmor

end

local function ApplyDefaultHealthPerArmor(target, attacker, doer, damage, armorFractionUsed, healthPerArmor, damageType, hitPoint)
    return damage, armorFractionUsed, kHealthPointsPerArmor
end

local function DoubleHealthPerArmor(target, attacker, doer, damage, armorFractionUsed, healthPerArmor, damageType, hitPoint)
    return damage, armorFractionUsed, healthPerArmor * (kLightHealthPerArmor / kHealthPointsPerArmor)
end

local function HalfHealthPerArmor(target, attacker, doer, damage, armorFractionUsed, healthPerArmor, damageType, hitPoint)
    return damage, armorFractionUsed, healthPerArmor * (kHeavyHealthPerArmor / kHealthPointsPerArmor)
end

local function ApplyAttackerModifiers(target, attacker, doer, damage, armorFractionUsed, healthPerArmor, damageType, hitPoint)

    damage = NS2Gamerules_GetUpgradedDamage(attacker, doer, damage, damageType, hitPoint)
    damage = damage * Gamerules_GetDamageMultiplier()

    if attacker and attacker.ComputeDamageAttackerOverride then
        damage = attacker:ComputeDamageAttackerOverride(attacker, damage, damageType, doer, hitPoint)
    end

    if doer and doer.ComputeDamageAttackerOverride then
        damage = doer:ComputeDamageAttackerOverride(attacker, damage, damageType)
    end

    if attacker and attacker.ComputeDamageAttackerOverrideMixin then
        damage = attacker:ComputeDamageAttackerOverrideMixin(attacker, damage, damageType, doer, hitPoint)
    end

    if doer and doer.ComputeDamageAttackerOverrideMixin then
        damage = doer:ComputeDamageAttackerOverrideMixin(attacker, damage, damageType, doer, hitPoint)
    end

    return damage, armorFractionUsed, healthPerArmor

end

local function ApplyTargetModifiers(target, attacker, doer, damage, armorFractionUsed, healthPerArmor,  damageType, hitPoint)

    -- The host can provide an override for this function.
    if target.ComputeDamageOverride then
        damage = target:ComputeDamageOverride(attacker, damage, damageType, hitPoint)
    end

    -- Used by mixins.
    if target.ComputeDamageOverrideMixin then
        damage = target:ComputeDamageOverrideMixin(attacker, damage, damageType, hitPoint)
    end

    if target.GetArmorUseFractionOverride then
        armorFractionUsed = target:GetArmorUseFractionOverride(damageType, armorFractionUsed, hitPoint)
    end

    if target.GetHealthPerArmorOverride then
        healthPerArmor = target:GetHealthPerArmorOverride(damageType, healthPerArmor, hitPoint)
    end

    local damageTable = {}
    damageTable.damage = damage
    damageTable.armorFractionUsed = armorFractionUsed
    damageTable.healthPerArmor = healthPerArmor

    if target.ModifyDamageTaken then
        target:ModifyDamageTaken(damageTable, attacker, doer, damageType, hitPoint)
    end

    return damageTable.damage, damageTable.armorFractionUsed, damageTable.healthPerArmor

end

local function ApplyFriendlyFireModifier(target, attacker, doer, damage, armorFractionUsed, healthPerArmor,  damageType, hitPoint)

    if target and attacker and target ~= attacker and HasMixin(target, "Team") and HasMixin(attacker, "Team") and target:GetTeamNumber() == attacker:GetTeamNumber() then
        damage = damage * kFriendlyFireScalar
    end

    return damage, armorFractionUsed, healthPerArmor
end

local function IgnoreArmor(target, attacker, doer, damage, armorFractionUsed, healthPerArmor, damageType, hitPoint)
    return damage, 0, healthPerArmor
end

local function MultiplyForStructures(target, attacker, doer, damage, armorFractionUsed, healthPerArmor, damageType, hitPoint)

    if target.GetReceivesStructuralDamage and target:GetReceivesStructuralDamage(damageType) then
        if doer:isa("Flamethrower") then
            damage = damage * kFTStructureDamage
        else
            damage = damage * kStructuralDamageScalar
        end
    end

    return damage, armorFractionUsed, healthPerArmor
end

local function ReduceForPlayersDoubleStructure(target, attacker, doer, damage, armorFractionUsed, healthPerArmor, damageType, hitPoint)
    --if target.GetReceivesStructuralDamage and target:GetReceivesStructuralDamage(damageType) then
        --damage = damage * kStructuralDamageScalar
    --elseif target:isa("Player") then
    if target:isa("Player") then
        damage = damage * kGLPlayerDamageReduction
    end

    return damage, armorFractionUsed, healthPerArmor
end

local function MultiplyForPlayers(target, attacker, doer, damage, armorFractionUsed, healthPerArmor, damageType, hitPoint)
    return ConditionalValue(target:isa("Player") or target:isa("Exosuit"), damage * kPuncturePlayerDamageScalar, damage), armorFractionUsed, healthPerArmor
end

local function ReducedDamageAgainstSmall(target, attacker, doer, damage, armorFractionUsed, healthPerArmor, damageType, hitPoint)

    if target.GetIsSmallTarget and target:GetIsSmallTarget() then
        damage = damage * kSpreadingDamageScalar
    end

    return damage, armorFractionUsed, healthPerArmor
end

local function IgnoreHealthForPlayers(target, attacker, doer, damage, armorFractionUsed, healthPerArmor, damageType, hitPoint)
    if target:isa("Player") then
        local maxDamagePossible = healthPerArmor * target.armor
        damage = math.min(damage, maxDamagePossible)
        armorFractionUsed = 1
    end

    return damage, armorFractionUsed, healthPerArmor
end

local function IgnoreHealthForPlayersUnlessExo(target, attacker, doer, damage, armorFractionUsed, healthPerArmor, damageType, hitPoint)
    if target:isa("Player") and not target:isa("Exo") then
        local maxDamagePossible = healthPerArmor * target.armor
        damage = math.min(damage, maxDamagePossible)
        armorFractionUsed = 1
    end

    return damage, armorFractionUsed, healthPerArmor
end

local function IgnoreHealth(target, attacker, doer, damage, armorFractionUsed, healthPerArmor, damageType, hitPoint)
    local maxDamagePossible = healthPerArmor * target.armor
    damage = math.min(damage, maxDamagePossible)

    return damage, 1, healthPerArmor
end

local function ReduceGreatlyForPlayers(target, attacker, doer, damage, armorFractionUsed, healthPerArmor, damageType, hitPoint)
    if target:isa("Exo") or target:isa("Exosuit") then
        damage = damage * kCorrodeDamageExoArmorScalar
    elseif target:isa("Player") then
        damage = damage * kCorrodeDamagePlayerArmorScalar
    end
    return damage, armorFractionUsed, healthPerArmor
end

local function IgnorePlayersUnlessExo(target, attacker, doer, damage, armorFractionUsed, healthPerArmor, damageType, hitPoint)
    return ConditionalValue(target:isa("Player") and not target:isa("Exo") , 0, damage), armorFractionUsed, healthPerArmor
end

local function DamagePlayersOnly(target, attacker, doer, damage, armorFractionUsed, healthPerArmor, damageType, hitPoint)
    return ConditionalValue(target:isa("Player") or target:isa("Exosuit"), damage, 0), armorFractionUsed, healthPerArmor
end

local function DamageAlienOnly(target, attacker, doer, damage, armorFractionUsed, healthPerArmor, damageType, hitPoint)
    return ConditionalValue(HasMixin(target, "Team") and target:GetTeamType() == kAlienTeamType, damage, 0), armorFractionUsed, healthPerArmor
end

local function DamageStructuresOnly(target, attacker, doer, damage, armorFractionUsed, healthPerArmor, damageType, hitPoint)
    if not target.GetReceivesStructuralDamage or not target:GetReceivesStructuralDamage(damageType) then
        damage = 0
    end

    return damage, armorFractionUsed, healthPerArmor
end

local function IgnoreDoors(target, attacker, doer, damage, armorFractionUsed, healthPerArmor, damageType, hitPoint)
    return ConditionalValue(target:isa("Door"), 0, damage), armorFractionUsed, healthPerArmor
end

local function DamageBiologicalOnly(target, attacker, doer, damage, armorFractionUsed, healthPerArmor, damageType, hitPoint)
    if not target.GetReceivesBiologicalDamage or not target:GetReceivesBiologicalDamage(damageType) then
        damage = 0
    end

    return damage, armorFractionUsed, healthPerArmor
end

local function DamageBreathingOnly(target, attacker, doer, damage, armorFractionUsed, healthPerArmor, damageType, hitPoint)
    if not target.GetReceivesVaporousDamage or not target:GetReceivesVaporousDamage(damageType) then
        damage = 0
    end

    return damage, armorFractionUsed, healthPerArmor
end

local function MultiplyFlameAble(target, attacker, doer, damage, armorFractionUsed, healthPerArmor, damageType, hitPoint)
    if target.GetIsFlameAble and target:GetIsFlameAble(damageType) then
        damage = damage * kFlameableMultiplier
    end

    return damage, armorFractionUsed, healthPerArmor
end

local function DoubleHealthPerArmorForStructures(target, attacker, doer, damage, armorFractionUsed, healthPerArmor, damageType, hitPoint)
    if target.GetReceivesStructuralDamage and target:GetReceivesStructuralDamage(damageType) then
        healthPerArmor = healthPerArmor * (kStructureLightHealthPerArmor / kHealthPointsPerArmor)
        armorFractionUsed = kStructureLightArmorUseFraction
        damage = damage * 0.25-- used for the skulk
    end
    return damage, armorFractionUsed, healthPerArmor
end


--


--[[
 * Define any new damage type behavior in this function
 --]]
local function BuildDamageTypeRules()

    kDamageTypeGlobalRules = {}
    kDamageTypeRules = {}

    -- global rules
    table.insert(kDamageTypeGlobalRules, ApplyDefaultArmorUseFraction)
    table.insert(kDamageTypeGlobalRules, ApplyHighArmorUseFractionForExos)
    table.insert(kDamageTypeGlobalRules, ApplyDefaultHealthPerArmor)
    table.insert(kDamageTypeGlobalRules, ApplyAttackerModifiers)
    table.insert(kDamageTypeGlobalRules, ApplyTargetModifiers)
    table.insert(kDamageTypeGlobalRules, ApplyFriendlyFireModifier)
    -- ------------------------------

    -- normal damage rules
    kDamageTypeRules[kDamageType.Normal] = {}

    -- light damage rules
    kDamageTypeRules[kDamageType.Light] = {}
    table.insert(kDamageTypeRules[kDamageType.Light], DoubleHealthPerArmor)
    -- ------------------------------

    -- heavy damage rules
    kDamageTypeRules[kDamageType.Heavy] = {}
    table.insert(kDamageTypeRules[kDamageType.Heavy], HalfHealthPerArmor)
    -- ------------------------------

    -- Puncture damage rules
    kDamageTypeRules[kDamageType.Puncture] = {}
    table.insert(kDamageTypeRules[kDamageType.Puncture], MultiplyForPlayers)
    -- ------------------------------

    -- Spreading damage rules
    kDamageTypeRules[kDamageType.Spreading] = {}
    table.insert(kDamageTypeRules[kDamageType.Spreading], ReducedDamageAgainstSmall)
    -- ------------------------------

    -- structural rules
    kDamageTypeRules[kDamageType.Structural] = {}
    table.insert(kDamageTypeRules[kDamageType.Structural], MultiplyForStructures)
    -- ------------------------------

    -- Grenade Launcher rules
    kDamageTypeRules[kDamageType.GrenadeLauncher] = {}
    table.insert(kDamageTypeRules[kDamageType.GrenadeLauncher], ReduceForPlayersDoubleStructure)
    -- ------------------------------

    -- structural heavy rules
    kDamageTypeRules[kDamageType.StructuralHeavy] = {}
    table.insert(kDamageTypeRules[kDamageType.StructuralHeavy], HalfHealthPerArmor)
    table.insert(kDamageTypeRules[kDamageType.StructuralHeavy], MultiplyForStructures)
    -- ------------------------------

    -- gas damage rules
    kDamageTypeRules[kDamageType.Gas] = {}
    table.insert(kDamageTypeRules[kDamageType.Gas], IgnoreArmor)
    table.insert(kDamageTypeRules[kDamageType.Gas], DamageBreathingOnly)
    -- ------------------------------

    -- structures only rules
    kDamageTypeRules[kDamageType.StructuresOnly] = {}
    table.insert(kDamageTypeRules[kDamageType.StructuresOnly], DamageStructuresOnly)
    -- ------------------------------

     -- Splash rules
    kDamageTypeRules[kDamageType.Splash] = {}
    table.insert(kDamageTypeRules[kDamageType.Splash], DamageStructuresOnly)
    -- ------------------------------

    -- fall damage rules
    kDamageTypeRules[kDamageType.Falling] = {}
    table.insert(kDamageTypeRules[kDamageType.Falling], IgnoreArmor)
    -- ------------------------------

    -- Door damage rules
    kDamageTypeRules[kDamageType.Door] = {}
    table.insert(kDamageTypeRules[kDamageType.Door], MultiplyForStructures)
    table.insert(kDamageTypeRules[kDamageType.Door], HalfHealthPerArmor)
    -- ------------------------------

    -- Flame damage rules
    kDamageTypeRules[kDamageType.Flame] = {}
    table.insert(kDamageTypeRules[kDamageType.Flame], MultiplyFlameAble)
    table.insert(kDamageTypeRules[kDamageType.Flame], MultiplyForStructures)
    -- ------------------------------

    -- Corrode damage rules
    kDamageTypeRules[kDamageType.Corrode] = {}
    table.insert(kDamageTypeRules[kDamageType.Corrode], ReduceGreatlyForPlayers)
    table.insert(kDamageTypeRules[kDamageType.Corrode], IgnoreHealthForPlayersUnlessExo)
    -- ------------------------------

    -- nerve gas rules
    kDamageTypeRules[kDamageType.NerveGas] = {}
    table.insert(kDamageTypeRules[kDamageType.NerveGas], DamageAlienOnly)
    table.insert(kDamageTypeRules[kDamageType.NerveGas], IgnoreHealth)
    -- ------------------------------

    -- StructuresOnlyLight damage rules
    kDamageTypeRules[kDamageType.StructuresOnlyLight] = {}
    table.insert(kDamageTypeRules[kDamageType.StructuresOnlyLight], DoubleHealthPerArmorForStructures)
    -- ------------------------------

    -- ArmorOnly damage rules
    kDamageTypeRules[kDamageType.ArmorOnly] = {}
    table.insert(kDamageTypeRules[kDamageType.ArmorOnly], ReduceGreatlyForPlayers)
    table.insert(kDamageTypeRules[kDamageType.ArmorOnly], IgnoreHealth)
    -- ------------------------------

    -- Biological damage rules
    kDamageTypeRules[kDamageType.Biological] = {}
    table.insert(kDamageTypeRules[kDamageType.Biological], DamageBiologicalOnly)
    -- ------------------------------

end

-- applies all rules and returns damage, armorUsed, healthUsed
function GetDamageByType(target, attacker, doer, damage, damageType, hitPoint, weapon)

    assert(target)

    if not kDamageTypeGlobalRules or not kDamageTypeRules then
        BuildDamageTypeRules()
    end

    -- at first check if damage is possible, if not we can skip the rest
    if not CanEntityDoDamageTo(attacker, target, Shared.GetCheatsEnabled(), Shared.GetDevMode(), GetFriendlyFire(), damageType) then
        return 0, 0, 0
    end

    local armorUsed = 0
    local healthUsed = 0

    local armorFractionUsed, healthPerArmor = 0

    -- apply global rules at first
    for _, rule in ipairs(kDamageTypeGlobalRules) do
        damage, armorFractionUsed, healthPerArmor = rule(target, attacker, doer, damage, armorFractionUsed, healthPerArmor, damageType, hitPoint)
    end

    --Account for Alien Chamber Upgrades damage modifications (must be before damage-type rules)
    if attacker:GetTeamType() == kAlienTeamType and attacker:isa("Player") then
        damage, armorFractionUsed = NS2Gamerules_GetUpgradedAlienDamage( target, attacker, doer, damage, armorFractionUsed, healthPerArmor, damageType, hitPoint, weapon )
    end

    -- apply damage type specific rules
    for _, rule in ipairs(kDamageTypeRules[damageType]) do
        damage, armorFractionUsed, healthPerArmor = rule(target, attacker, doer, damage, armorFractionUsed, healthPerArmor, damageType, hitPoint)
    end

    if damage > 0 and healthPerArmor > 0 then

        -- Each point of armor blocks a point of health but is only destroyed at half that rate (like NS1)
        -- Thanks Harimau!
        local healthPointsBlocked = math.min(healthPerArmor * target.armor, armorFractionUsed * damage)
        armorUsed = healthPointsBlocked / healthPerArmor

        -- Anything left over comes off of health
        healthUsed = damage - healthPointsBlocked

    end

    return damage, armorUsed, healthUsed

end
