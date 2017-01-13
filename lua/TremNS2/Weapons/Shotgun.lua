local kBulletSize = 0.05--0.016

Shotgun.kSpreadVectors =
{
    GetNormalizedVector(Vector(-0.01, 0.01, kShotgunSpreadDistance)),
--box
    GetNormalizedVector(Vector(-0.25, 0.25, kShotgunSpreadDistance)),
    GetNormalizedVector(Vector(0.25, 0.25, kShotgunSpreadDistance)),
    GetNormalizedVector(Vector(0.25, -0.25, kShotgunSpreadDistance)),
    GetNormalizedVector(Vector(-0.25, -0.25, kShotgunSpreadDistance)),
--diamond
    GetNormalizedVector(Vector(-0.35, 0, kShotgunSpreadDistance)),
    GetNormalizedVector(Vector(0.35, 0, kShotgunSpreadDistance)),
    GetNormalizedVector(Vector(0, -0.35, kShotgunSpreadDistance)),
    GetNormalizedVector(Vector(0, 0.35, kShotgunSpreadDistance)),

--pentagon bottom 4
    GetNormalizedVector(Vector(-0.81, -0.59, kShotgunSpreadDistance)),
    GetNormalizedVector(Vector(-0.81, 0.59, kShotgunSpreadDistance)),
    GetNormalizedVector(Vector(0.31, 0.95, kShotgunSpreadDistance)),
    GetNormalizedVector(Vector(0.31, -0.95, kShotgunSpreadDistance)),
--pentagon top
    GetNormalizedVector(Vector(1, 0, kShotgunSpreadDistance)),

    --not used below but keeping as backup
    --GetNormalizedVector(Vector(1, 0, kShotgunSpreadDistance)),
    --GetNormalizedVector(Vector(0, -1, kShotgunSpreadDistance)),
    --GetNormalizedVector(Vector(0, 1, kShotgunSpreadDistance)),
}

function Shotgun:GetMaxClips()
    return 3
end

local function LoadBullet(self)

    if self.ammo > 0 and self.clip < self:GetClipSize() then

        self.clip = self.clip + 1
        self.ammo = self.ammo - 1

    end

end


function Shotgun:OnTag(tagName)

    PROFILE("Shotgun:OnTag")

    local continueReloading = false
    if self:GetIsReloading() and tagName == "reload_end" then

        continueReloading = true
        self.reloading = false

    end

    ClipWeapon.OnTag(self, tagName)

    if tagName == "load_shell" and self.clip < self:GetClipSize() then
        LoadBullet(self)
    elseif tagName == "reload_shotgun_start" then
        self:TriggerEffects("shotgun_reload_start")
    elseif tagName == "reload_shotgun_shell" then
        self:TriggerEffects("shotgun_reload_shell")
    elseif tagName == "reload_shotgun_end" then
        self:TriggerEffects("shotgun_reload_end")
    end

    if continueReloading then

        local player = self:GetParent()
        if player then
            player:Reload()
        end

    end

end

function Shotgun:FirePrimary(player)

    local viewAngles = player:GetViewAngles()
    viewAngles.roll = NetworkRandom() * math.pi * 2

    local shootCoords = viewAngles:GetCoords()

    -- Filter ourself out of the trace so that we don't hit ourselves.
    local filter = EntityFilterTwo(player, self)
    local range = self:GetRange()

    if GetIsVortexed(player) then
        range = 5
    end

    local numberBullets = self:GetBulletsPerShot()
    local startPoint = player:GetEyePos()

    self:TriggerEffects("shotgun_attack_sound")
    self:TriggerEffects("shotgun_attack")

    for bullet = 1, math.min(numberBullets, #self.kSpreadVectors) do

        if not self.kSpreadVectors[bullet] then
            break
        end

        local spreadDirection = shootCoords:TransformVector(self.kSpreadVectors[bullet])

        local endPoint = startPoint + spreadDirection * range
        startPoint = player:GetEyePos() + shootCoords.xAxis * self.kSpreadVectors[bullet].x * self.kStartOffset + shootCoords.yAxis * self.kSpreadVectors[bullet].y * self.kStartOffset

        local targets, trace, hitPoints = GetBulletTargets(startPoint, endPoint, spreadDirection, kBulletSize, filter)

        local damage = 0

        HandleHitregAnalysis(player, startPoint, endPoint, trace)

        local direction = (trace.endPoint - startPoint):GetUnit()
        local hitOffset = direction * kHitEffectOffset
        local impactPoint = trace.endPoint - hitOffset
        local effectFrequency = self:GetTracerEffectFrequency()
        local showTracer = bullet % effectFrequency == 0

        local numTargets = #targets

        if numTargets == 0 then
            self:ApplyBulletGameplayEffects(player, nil, impactPoint, direction, 0, trace.surface, showTracer)
        end

        if Client and showTracer then
            TriggerFirstPersonTracer(self, impactPoint)
        end

        for i = 1, numTargets do

            local target = targets[i]
            local hitPoint = hitPoints[i]

            self:ApplyBulletGameplayEffects(player, target, hitPoint - hitOffset, direction, kShotgunDamage, "", showTracer and i == numTargets)

            local client = Server and player:GetClient() or Client
            if not Shared.GetIsRunningPrediction() and client.hitRegEnabled then
                RegisterHitEvent(player, bullet, startPoint, trace, damage)
            end

        end

    end

end
