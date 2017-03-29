--local kInfestationDecalSimpleMaterial = PrecacheAsset("materials/infestation/infestation_decal_simple.material")

function GetMaxSupplyForTeam(teamNumber)

    --return kMaxSupply

    --doesn't work apparently
    local maxSupply = kMaxSupply

    if Server then

        local team = GetGamerules():GetTeam(teamNumber)
        if team and team.GetNumCapturedTechPoints then
            maxSupply = team:GetNumCapturedTechPoints() * kSupplyPerTechpoint + kMaxSupply
        end

    else

        local teamInfoEnt = GetTeamInfoEntity(teamNumber)
        if teamInfoEnt and teamInfoEnt.GetNumCapturedTechPoints then
            maxSupply = teamInfoEnt:GetNumCapturedTechPoints() * kSupplyPerTechpoint + kMaxSupply
        end

    end

    return maxSupply

end

function GetTexCoordsForTechId(techId)

    local x1 = 0
    local y1 = 0
    local x2 = kInventoryIconTextureWidth
    local y2 = kInventoryIconTextureHeight

    if not gTechIdPosition then

        gTechIdPosition = {}

       -- marine weapons
        gTechIdPosition[kTechId.Rifle] = kDeathMessageIcon.Rifle
        gTechIdPosition[kTechId.HeavyRifle] = kDeathMessageIcon.Rifle
        gTechIdPosition[kTechId.HeavyMachineGun] = kDeathMessageIcon.HeavyMachineGun
        gTechIdPosition[kTechId.Pistol] = kDeathMessageIcon.Pistol
        gTechIdPosition[kTechId.Axe] = kDeathMessageIcon.Axe
        gTechIdPosition[kTechId.Shotgun] = kDeathMessageIcon.Shotgun
        gTechIdPosition[kTechId.Flamethrower] = kDeathMessageIcon.Flamethrower
        gTechIdPosition[kTechId.GrenadeLauncher] = kDeathMessageIcon.GL
        gTechIdPosition[kTechId.Welder] = kDeathMessageIcon.Welder
        gTechIdPosition[kTechId.LayMines] = kDeathMessageIcon.Mine
        gTechIdPosition[kTechId.ClusterGrenade] = kDeathMessageIcon.ClusterGrenade
        gTechIdPosition[kTechId.GasGrenade] = kDeathMessageIcon.GasGrenade
        gTechIdPosition[kTechId.PulseGrenade] = kDeathMessageIcon.PulseGrenade
        gTechIdPosition[kTechId.Exo] = kDeathMessageIcon.Crush
        gTechIdPosition[kTechId.PowerSurge] = kDeathMessageIcon.EMPBlast

       -- alien abilities
        gTechIdPosition[kTechId.Bite] = kDeathMessageIcon.Bite
        gTechIdPosition[kTechId.Leap] = kDeathMessageIcon.Leap
        gTechIdPosition[kTechId.Parasite] = kDeathMessageIcon.Parasite
        gTechIdPosition[kTechId.Xenocide] = kDeathMessageIcon.Xenocide

        gTechIdPosition[kTechId.Spit] = kDeathMessageIcon.Spit
        gTechIdPosition[kTechId.BuildAbility] = kDeathMessageIcon.BuildAbility
        gTechIdPosition[kTechId.Spray] = kDeathMessageIcon.Spray
        gTechIdPosition[kTechId.BileBomb] = kDeathMessageIcon.BileBomb
        gTechIdPosition[kTechId.WhipBomb] = kDeathMessageIcon.WhipBomb
        gTechIdPosition[kTechId.BabblerAbility] = kDeathMessageIcon.BabblerAbility

        gTechIdPosition[kTechId.LerkBite] = kDeathMessageIcon.LerkBite
        gTechIdPosition[kTechId.Spikes] = kDeathMessageIcon.Spikes
        gTechIdPosition[kTechId.Spores] = kDeathMessageIcon.SporeCloud
        gTechIdPosition[kTechId.Umbra] = kDeathMessageIcon.Umbra

        gTechIdPosition[kTechId.Swipe] = kDeathMessageIcon.Swipe
        gTechIdPosition[kTechId.Stab] = kDeathMessageIcon.Stab
        gTechIdPosition[kTechId.Blink] = kDeathMessageIcon.Blink
        gTechIdPosition[kTechId.Vortex] = kDeathMessageIcon.Vortex
        --gTechIdPosition[kTechId.ShadowStep] = kDeathMessageIcon.ShadowStep
        gTechIdPosition[kTechId.MetabolizeEnergy] = kDeathMessageIcon.Metabolize
        gTechIdPosition[kTechId.MetabolizeHealth] = kDeathMessageIcon.Metabolize

        gTechIdPosition[kTechId.Gore] = kDeathMessageIcon.Gore
        gTechIdPosition[kTechId.Stomp] = kDeathMessageIcon.Stomp
        gTechIdPosition[kTechId.BoneShield] = kDeathMessageIcon.BoneShield

        gTechIdPosition[kTechId.GorgeTunnelTech] = kDeathMessageIcon.GorgeTunnel

    end

    local position = gTechIdPosition[techId]

    if position then

        y1 = (position - 1) * kInventoryIconTextureHeight
        y2 = y1 + kInventoryIconTextureHeight

    end

    return x1, y1, x2, y2

end

--sample for skulks' triggerbot
--[[
function AttackMeleeCapsule(weapon, player, damage, range, optionalCoords, altMode, filter)

    local targets = {}
    local didHit, target, endPoint, direction, surface, startPoint, trace

    if not filter then
        filter = EntityFilterTwo(player, weapon)
    end

   -- loop upto 20 times just to go through any soft targets.
   -- Stops as soon as nothing is hit or a non-soft target is hit
    for i = 1, 20 do

        local traceFilter = function(test)
            return EntityFilterList(targets)(test) or filter(test)
        end

       -- Enable tracing on this capsule check, last argument.
        didHit, target, endPoint, direction, surface, startPoint, trace = CheckMeleeCapsule(weapon, player, damage, range, optionalCoords, true, 1, nil, traceFilter)
        local alreadyHitTarget = target ~= nil and table.contains(targets, target)

        if didHit and not alreadyHitTarget then
            weapon:DoDamage(damage, target, endPoint, direction, surface, altMode)
        end

        if target and not alreadyHitTarget then
            table.insert(targets, target)
        end

        if not target or not HasMixin(target, "SoftTarget") then
            break
        end

    end

    HandleHitregAnalysis(player, startPoint, endPoint, trace)

    return didHit, targets[#targets], endPoint, surface

end]]
--Trigger bite
--[[
function TraceMeleeCapsule(weapon, player, damage, range, optionalCoords, altMode, filter)

    local targets = {}
    local didHit, target, endPoint, direction, surface, startPoint, trace

    if not filter then
        filter = EntityFilterTwo(player, weapon)
    end

   -- loop upto 20 times just to go through any soft targets.
   -- Stops as soon as nothing is hit or a non-soft target is hit
    for i = 1, 20 do

        local traceFilter = function(test)
            return EntityFilterList(targets)(test) or filter(test)
        end

       -- Enable tracing on this capsule check, last argument.
        didHit, target, endPoint, direction, surface, startPoint, trace = CheckMeleeCapsule(weapon, player, damage, range, optionalCoords, true, 1, nil, traceFilter)
        local alreadyHitTarget = target ~= nil and table.contains(targets, target)

        if didHit and not alreadyHitTarget then
            weapon:DoDamage(damage, target, endPoint, direction, surface, altMode)
        end

        if target and not alreadyHitTarget then
            table.insert(targets, target)
            --triggerbot
            local hasEnergy = player:GetEnergy() >= self:GetEnergyCost()
            local cooledDown = (not self.nextAttackTime) or (Shared.GetTime() >= self.nextAttackTime)
            if hasEnergy and cooledDown then
                self.primaryAttacking = true
            else
                self.primaryAttacking = false
            end
            --endtriggerbot
        end

        if not target or not HasMixin(target, "SoftTarget") then
            break
        end

    end

    HandleHitregAnalysis(player, startPoint, endPoint, trace)

    return didHit, targets[#targets], endPoint, surface

end]]
