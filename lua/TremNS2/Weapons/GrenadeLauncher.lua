local kGrenadeSpeed = 10.32--25

function GrenadeLauncher:GetMaxClips()
    return 12--7
end

local function ShootGrenade(self, player)

    PROFILE("ShootGrenade")

    self:TriggerEffects("grenadelauncher_attack")

    if Server or (Client and Client.GetIsControllingPlayer()) then

        local viewCoords = player:GetViewCoords()
        local eyePos = player:GetEyePos()

        local startPointTrace = Shared.TraceCapsule(eyePos, eyePos + viewCoords.zAxis, 0.2, 0, CollisionRep.Move, PhysicsMask.PredictedProjectileGroup, EntityFilterTwo(self, player))
        local startPoint = startPointTrace.endPoint

        local direction = viewCoords.zAxis

        if startPointTrace.fraction ~= 1 then
            direction = GetNormalizedVector(direction:GetProjection(startPointTrace.normal))
        end

        local grenade = player:CreatePredictedProjectile("Grenade", startPoint, direction * kGrenadeSpeed, 0, 0, 0) --0.7 bounce 0.45 friction

    end

end

function GrenadeLauncher:FirePrimary(player)
    ShootGrenade(self, player)
end

--TODO Fix the long dreaded reload
local function LoadBullet(self)

    if self.ammo > 0 and self.clip < self:GetClipSize() then

        self.clip = self.clip + 1
        self.ammo = self.ammo - 1

    end

end

function GrenadeLauncher:OnTag(tagName)

    PROFILE("GrenadeLauncher:OnTag")

    local continueReloading = false
    if self:GetIsReloading() and tagName == "reload_end" then

        continueReloading = true
        self.reloading = false

    end
--
    if tagName == "end" then
        self.primaryAttacking = false
    end

    ClipWeapon.OnTag(self, tagName)

    if tagName == "load_shell" then
        LoadBullet(self)
    -- We have a special case when loading the last shell in the clip.
    elseif tagName == "load_shell_sound" and self.clip < (self:GetClipSize() - 1) then
        self:TriggerEffects("grenadelauncher_reload_shell")
    elseif tagName == "load_shell_sound" then
        self:TriggerEffects("grenadelauncher_reload_shell_last")
    elseif tagName == "reload_start" then
        self:TriggerEffects("grenadelauncher_reload_start")
    elseif tagName == "shut_canister" then
        self:TriggerEffects("grenadelauncher_reload_end")
    end

    if continueReloading then

        local player = self:GetParent()
        if player then
            player:Reload()
        end

    end

end
