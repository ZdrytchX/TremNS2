Grenade.kMinLifeTime = 0.00--0.15

local kGrenadeCameraShakeDistance = 10--15
local kGrenadeMinShakeIntensity = 0.02
local kGrenadeMaxShakeIntensity = 0.25--0.13

if Server then
    --[[function Grenade:ProcessHit(targetHit, surface, normal, endPoint )

        if targetHit and GetAreEnemies(self, targetHit) then

            self:Detonate(targetHit, hitPoint )

        else--if self:GetVelocity():GetLength() > 2 then

            --self:TriggerEffects("grenade_bounce")
            self:Detonate()
        end

    end]]
    function Grenade:ProcessHit(targetHit, surface, normal, endPoint )
            self:Detonate()
    end
--q3 knockback equation:
--knockback = damage * g_knockback.value / 200
--luci ~= 1275 ups, or 39.84375 m/s knockback
    function Grenade:Detonate(targetHit)

      -- Do damage to nearby targets.
      local hitEntities = GetEntitiesWithMixinWithinRange("Live", self:GetOrigin(), kGrenadeLauncherGrenadeDamageRadius)
      local ldamage = kGrenadeLauncherGrenadeDamage

      -- Remove grenade and add firing player.
      table.removevalue(hitEntities, self)


--FIXME: Does not apply to targets (Low Priority)
--TODO: Let the client predict the explosions
    -- Knockback because UWE didn't have anything as simple as this fucker
      for i = 1, #hitEntities do
          local ltarget = hitEntities[i]
          if ltarget:isa("Player") and ltarget:GetMass() then--Must ensure it is a player else getorigin() will fail... which for some reason, drifters and hive bypass check... #Wtf_UWEEY
            local origin = ltarget:GetOrigin()
            local originpush = Vector(origin) --speed up calcs a bit
            local selforigin =  self:GetOrigin() --speed up calcs a bit

            --XXX Replacement function, can cause players to get stuck in vents but at least hives don't spam errors
            --origin.y = origin.y + 0.001
            --ltarget:SetOrigin(origin)
            --XXX

            --increase upward mpush without increasing
            origin.y = origin.y +1.75--ltarget:GetEyePos()--TODO: normalise the vector and stuff so the actual radius for knockback doesn't change
            originpush.y = originpush.y + 0.75 --ensure it isn't below the ground

            local offset = origin - selforigin
            local push = originpush - selforigin

            local llength = Clamp(push:GetLength(), 0, kGrenadeLauncherGrenadeDamageRadius) --limits at 6, wtf am i doing here with 25.5?
            --local lmodifier = math.max(kGrenadeLauncherGrenadeDamage * 8 / ltarget:GetMass(), 25.5)--3.5 for including jump
            local lmodifier =  11.75 * kGrenadeLauncherGrenadeDamage * (kGrenadeLauncherGrenadeDamageRadius - llength) / (ltarget:GetMass() * kGrenadeLauncherGrenadeDamageRadius)--*8
--sort of to emulate the hitbox distance that quake has and ns2 doesnt--8
            offset:Normalize()
            --offset is now a direction, does not need modifying

            --push = push * lmodifier / llength / llength --actual push
            --push is the magnitude
            pushscale = push:GetLength()* lmodifier


            local velocity = ltarget:GetVelocity() + offset * pushscale
                ltarget:SetVelocity(velocity)
------------------------------------------------
                --FIXME: GetIsOnGround searches through hives somehow
                --[[
            if ltarget:GetIsOnGround() then
              ltarget.onGround = false
            end]]
            -------- Replacement
            if ltarget.DisableGroundMove then ltarget:DisableGroundMove(0.1) end
---------------------------------------

            --FIXME doesn't work
            local lshooter = self:GetParentId()
            --local ltargetname

            if lshooter and ltarget:GetId() == lshooter then
              ldamage = ldamage * 0.05
            end

          end
      end

      -- full damage on direct impact
      if targetHit then
          table.removevalue(hitEntities, targetHit)
          self:DoDamage(ldamage, targetHit, targetHit:GetOrigin(), GetNormalizedVector(targetHit:GetOrigin() - self:GetOrigin()), "none")
      end

      RadiusDamage(hitEntities, self:GetOrigin(), kGrenadeLauncherGrenadeDamageRadius, kGrenadeLauncherGrenadeDamage, self)

      -- TODO: use what is defined in the material file
      local surface = GetSurfaceFromEntity(targetHit)

      if GetIsVortexed(self) then
          surface = "ethereal"
      end

      local params = { surface = surface }
      params[kEffectHostCoords] = Coords.GetLookIn( self:GetOrigin(), self:GetCoords().zAxis)

      self:TriggerEffects("grenade_explode", params)

      CreateExplosionDecals(self)
      TriggerCameraShake(self, kGrenadeMinShakeIntensity, kGrenadeMaxShakeIntensity, kGrenadeCameraShakeDistance)

      DestroyEntity(self)

    end

end
