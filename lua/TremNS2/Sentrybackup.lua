local kAnimationGraph = PrecacheAsset("models/marine/sentry/sentry.animation_graph")

-- Balance
Sentry.kPingInterval = 4
Sentry.kFov = 180--160
Sentry.kMaxPitch = 90 -- 160 total
Sentry.kMaxYaw = Sentry.kFov / 2

Sentry.kBaseROF = kSentryAttackBaseROF
Sentry.kRandROF = kSentryAttackRandROF
Sentry.kSpread = Math.Radians(3)
Sentry.kBulletsPerSalvo = kSentryAttackBulletsPerSalvo
Sentry.kBarrelScanRate = 60      -- Degrees per second to scan back and forth with no target
Sentry.kBarrelMoveRate = 150    -- Degrees per second to move sentry orientation towards target or back to flat when targeted
Sentry.kRange = 12.5--20 12.5 = gpp, 0.9375 = 1.1
Sentry.kReorientSpeed = .05

Sentry.kTargetAcquireTime = 0.15
Sentry.kConfuseDuration = 4
Sentry.kAttackEffectIntervall = 0.2
Sentry.kConfusedAttackEffectInterval = kConfusedSentryBaseROF

-- prevents attacking during deploy animation for kDeployTime seconds
local kDeployTime = 3.5

local networkVars =
{
    -- So we can update angles and pose parameters smoothly on client
    targetDirection = "vector",

    confused = "boolean",

    deployed = "boolean",

    attacking = "boolean",

    attachedToBattery = "boolean"
}

function Sentry:OnInitialized()

    ScriptActor.OnInitialized(self)

    InitMixin(self, NanoShieldMixin)
    InitMixin(self, WeldableMixin)

    --InitMixin(self, LaserMixin)

    self:SetModel(Sentry.kModelName, kAnimationGraph)

    self:SetUpdates(true)

    if Server then

        InitMixin(self, SleeperMixin)

        self.timeLastTargetChange = Shared.GetTime()

        -- This Mixin must be inited inside this OnInitialized() function.
        if not HasMixin(self, "MapBlip") then
            InitMixin(self, MapBlipMixin)
        end

        -- TargetSelectors require the TargetCacheMixin for cleanup.
        InitMixin(self, TargetCacheMixin)
        InitMixin(self, SupplyUserMixin)

        -- configure how targets are selected and validated
        self.targetSelector = TargetSelector():Init(
            self,
            Sentry.kRange,
            true,
            { kMarineStaticTargets, kMarineMobileTargets },
            { PitchTargetFilter(self, -Sentry.kMaxPitch, Sentry.kMaxPitch), CloakTargetFilter() },
            { function(target) return not target:isa("Cyst") end } )

        InitMixin(self, StaticTargetMixin)
        InitMixin(self, InfestationTrackerMixin)

    elseif Client then

        InitMixin(self, UnitStatusMixin)
        InitMixin(self, HiveVisionMixin)

    end

end

function Sentry:GetFov()
    return Sentry.kFov
end

function Sentry:OverrideLaserLength()
    return Sentry.kRange
end
--[[
if Server then

    local function OnDeploy(self)

        self.attacking = false
        self.deployed = true
        return false

    end

    function Sentry:OnConstructionComplete()
        self:AddTimedCallback(OnDeploy, kDeployTime)
    end

    function Sentry:OnStun(duration)
        self:Confuse(duration)
    end

    function Sentry:GetDamagedAlertId()
        return kTechId.MarineAlertSentryUnderAttack
    end

    function Sentry:FireBullets()

        local fireCoords = Coords.GetLookIn(Vector(0,0,0), self.targetDirection)
        local startPoint = self:GetBarrelPoint()

        for bullet = 1, Sentry.kBulletsPerSalvo do

            local spreadDirection = CalculateSpread(fireCoords, Sentry.kSpread, math.random)

            local endPoint = startPoint + spreadDirection * Sentry.kRange

            local trace = Shared.TraceRay(startPoint, endPoint, CollisionRep.Damage, PhysicsMask.Bullets, EntityFilterOne(self))
]]
          --  if trace.fraction < Sentry.kRange--[[1]] then --hax!
--[[
                local damage = kSentryDamage
                local surface = trace.surface

                -- Disable friendly fire.
                trace.entity = (not trace.entity or GetAreEnemies(trace.entity, self)) and trace.entity or nil

                local blockedByUmbra = trace.entity and GetBlockedByUmbra(trace.entity) or false

                if blockedByUmbra then
                    surface = "umbra"
                end

                local direction = (trace.endPoint - startPoint):GetUnit()
                --Print("Sentry %d doing %.2f damage to %s (ramp up %.2f)", self:GetId(), damage, SafeClassName(trace.entity), rampUpFraction)
                self:DoDamage(damage, trace.entity, trace.endPoint, direction, surface, false, math.random() < 0.2)

            end

            bulletsFired = true

        end

    end

    -- checking at range 1.8 for overlapping the radius a bit. no LOS check here since i think it would become too expensive with multiple sentries
    function Sentry:GetFindsSporesAt(position)
        return #GetEntitiesWithinRange("SporeCloud", position, 1.8) > 0
    end

    function Sentry:Confuse(duration)

        if not self.confused then

            self.confused = true
            self.timeConfused = Shared.GetTime() + duration

            StartSoundEffectOnEntity(Sentry.kConfusedSound, self)

        end

    end

    -- check for spores in our way every 0.3 seconds
    local function UpdateConfusedState(self, target)

        if not self.confused and target then

            if not self.timeCheckedForSpores then
                self.timeCheckedForSpores = Shared.GetTime() - 0.3
            end

            if self.timeCheckedForSpores + 0.3 < Shared.GetTime() then

                self.timeCheckedForSpores = Shared.GetTime()

                local eyePos = self:GetEyePos()
                local toTarget = target:GetOrigin() - eyePos
                local distanceToTarget = toTarget:GetLength()
                toTarget:Normalize()

                local stepLength = 3
                local numChecks = math.ceil(Sentry.kRange/stepLength)

                -- check every few meters for a spore in the way, min distance 3 meters, max 12 meters (but also check sentry eyepos)
                for i = 0, numChecks do

                    -- stop when target has reached, any spores would be behind
                    if distanceToTarget < (i * stepLength) then
                        break
                    end

                    local checkAtPoint = eyePos + toTarget * i * stepLength
                    if self:GetFindsSporesAt(checkAtPoint) then
                        self:Confuse(Sentry.kConfuseDuration)
                        break
                    end

                end

            end

        elseif self.confused then

            if self.timeConfused < Shared.GetTime() then
                self.confused = false
            end

        end

    end

    local function UpdateBatteryState(self)

        local time = Shared.GetTime()

        if self.lastBatteryCheckTime == nil or (time > self.lastBatteryCheckTime + 0.5) then

            -- Update if we're powered or not
            self.attachedToBattery = false

            local ents = GetEntitiesForTeamWithinRange("SentryBattery", self:GetTeamNumber(), self:GetOrigin(), SentryBattery.kRange)
            for index, ent in ipairs(ents) do

                if GetIsUnitActive(ent) and ent:GetLocationName() == self:GetLocationName() then

                    self.attachedToBattery = true
                    break

                end

            end

            self.lastBatteryCheckTime = time

        end

    end

    function Sentry:OnUpdate(deltaTime)

        PROFILE("Sentry:OnUpdate")

        ScriptActor.OnUpdate(self, deltaTime)

        UpdateBatteryState(self)

        if self.timeNextAttack == nil or (Shared.GetTime() > self.timeNextAttack) then

            local initialAttack = self.target == nil

            local prevTarget = nil
            if self.target then
                prevTarget = self.target
            end

            self.target = nil

            if GetIsUnitActive(self) and self.attachedToBattery and self.deployed then
                self.target = self.targetSelector:AcquireTarget()
            end

            if self.target then

                local previousTargetDirection = self.targetDirection
                self.targetDirection = GetNormalizedVector(self.target:GetEngagementPoint() - self:GetAttachPointOrigin(Sentry.kMuzzleNode))

                -- Reset damage ramp up if we moved barrel at all
                if previousTargetDirection then
                    local dotProduct = previousTargetDirection:DotProduct(self.targetDirection)
                    if dotProduct < .99 then

                        self.timeLastTargetChange = Shared.GetTime()

                    end
                end

                -- Or if target changed, reset it even if we're still firing in the exact same direction
                if self.target ~= prevTarget then
                    self.timeLastTargetChange = Shared.GetTime()
                end

                -- don't shoot immediately
                if not initialAttack then

                    self.attacking = true
                    self:FireBullets()

                end

            else

                self.attacking = false
                self.timeLastTargetChange = Shared.GetTime()

            end

            UpdateConfusedState(self, self.target)
            -- slower fire rate when confused
            local confusedTime = ConditionalValue(self.confused, kConfusedSentryBaseROF, 0)

            -- Random rate of fire so it can't be gamed

            if initialAttack and self.target then
                self.timeNextAttack = Shared.GetTime() + Sentry.kTargetAcquireTime
            else
                self.timeNextAttack = confusedTime + Shared.GetTime() + Sentry.kBaseROF + math.random() * Sentry.kRandROF
            end

            if not GetIsUnitActive() or self.confused or not self.attacking or not self.attachedToBattery then

                if self.attackSound:GetIsPlaying() then
                    self.attackSound:Stop()
                end

            elseif self.attacking then

                if not self.attackSound:GetIsPlaying() then
                    self.attackSound:Start()
                end

            end

        end

    end

elseif Client then

    local function UpdateAttackEffects(self, deltaTime)

        local intervall = ConditionalValue(self.confused, Sentry.kConfusedAttackEffectInterval, Sentry.kAttackEffectIntervall)
        if self.attacking and (self.timeLastAttackEffect + intervall < Shared.GetTime()) then

            if self.confused then
                self:TriggerEffects("sentry_single_attack")
            end

            -- plays muzzle flash and smoke
            self:TriggerEffects("sentry_attack")

            self.timeLastAttackEffect = Shared.GetTime()

        end

    end

    function Sentry:OnUpdate(deltaTime)

        ScriptActor.OnUpdate(self, deltaTime)

        if GetIsUnitActive(self) and self.deployed and self.attachedToBattery then

            -- Swing barrel yaw towards target
            if self.attacking then

                if self.targetDirection then

                    local invSentryCoords = self:GetAngles():GetCoords():GetInverse()
                    self.relativeTargetDirection = GetNormalizedVector( invSentryCoords:TransformVector( self.targetDirection ) )
                    self.desiredYawDegrees = Clamp(math.asin(-self.relativeTargetDirection.x) * 180 / math.pi, -Sentry.kMaxYaw, Sentry.kMaxYaw)
                    self.desiredPitchDegrees = Clamp(math.asin(self.relativeTargetDirection.y) * 180 / math.pi, -Sentry.kMaxPitch, Sentry.kMaxPitch)

                end

                UpdateAttackEffects(self, deltaTime)

            -- Else when we have no target, swing it back and forth looking for targets
            else

                local sin = math.sin(math.rad((Shared.GetTime() + self:GetId() * .3) * Sentry.kBarrelScanRate))
                self.desiredYawDegrees = sin * self:GetFov() / 2

                -- Swing barrel pitch back to flat
                self.desiredPitchDegrees = 0

            end

            -- swing towards desired direction
            self.barrelPitchDegrees = Slerp(self.barrelPitchDegrees, self.desiredPitchDegrees, Sentry.kBarrelMoveRate * deltaTime)
            self.barrelYawDegrees = Slerp(self.barrelYawDegrees , self.desiredYawDegrees, Sentry.kBarrelMoveRate * deltaTime)

        end

    end

end

function GetCheckSentryLimit(techId, origin, normal, commander)

    -- Prevent the case where a Sentry in one room is being placed next to a
    -- SentryBattery in another room.
    local battery = GetSentryBatteryInRoom(origin)
    if battery then

        if (battery:GetOrigin() - origin):GetLength() > SentryBattery.kRange then
            return false
        end

    else
        return false
    end

    local location = GetLocationForPoint(origin)
    local locationName = location and location:GetName() or nil
    local numInRoom = 0
    local validRoom = false

    if locationName then

        validRoom = true

        for index, sentry in ientitylist(Shared.GetEntitiesWithClassname("Sentry")) do

            if sentry:GetLocationName() == locationName then
                numInRoom = numInRoom + 1
            end

        end

    end

    return validRoom and numInRoom < kSentriesPerBattery

end
--TODO: Or allow for power node
function GetBatteryInRange(commander)

    local batteries = {}
    for _, battery in ipairs(GetEntitiesForTeam("SentryBattery", commander:GetTeamNumber())) do
        batteries[battery] = SentryBattery.kRange
    end

    return batteries

end
]]
