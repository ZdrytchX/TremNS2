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
