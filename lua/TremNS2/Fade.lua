local kMaxSpeed = 11--6.2
local kBlinkSpeed = 22--14
local kBlinkAcceleration = 40--40 --before reaching blinkspeed
local kBlinkAddAcceleration = 0.1 --1 after reaching blinkspeed
--local kMetabolizeAnimationDelay = 0.65

Fade.kShadowStepDuration = 0.4--0.25

-- Delay before you can blink again after a blink.
local kMinEnterEtherealTime = 0.75--0.4

--local kFadeGravityMod = 1.0

function Fade:GetPerformsVerticalMove()
    return self:GetIsBlinking()
end

function Fade:GetAcceleration()
    return 11
end

function Fade:GetGroundFriction()
    return self:GetIsShadowStepping() and 0 or 11
end

function Fade:GetAirControl()
    return 165 * self:GetMaxSpeed() / 10--40
end

function Fade:GetAirFriction()
    return 0 --(self:GetIsBlinking() or self:GetRecentlyShadowStepped()) and 0 or (0.17  - (GetHasCelerityUpgrade(self) and GetSpurLevel(self:GetTeamNumber()) or 0) * 0.01)
end

function Fade:GetGroundFriction()
    return 6
end
function Fade:GetCollisionSlowdownFraction()
    return 0.05
end

function Fade:GetMaxSpeed(possible)

    if possible then
        return kMaxSpeed
    end

    if self:GetIsBlinking() then
        return kBlinkSpeed
    end

    -- Take into account crouching.
    return kMaxSpeed

end

function Fade:GetRecentlyBlinked(player)
    return Shared.GetTime() - self.etherealEndTime < kMinEnterEtherealTime
end

function Fade:ModifyVelocity(input, velocity, deltaTime)

    if self:GetIsBlinking() then

        local wishDir = self:GetViewCoords().zAxis
        local maxSpeedTable = { maxSpeed = kBlinkSpeed }
        self:ModifyMaxSpeed(maxSpeedTable, input)
        local prevSpeed = velocity:GetLength()
        local maxSpeed = math.max(prevSpeed, maxSpeedTable.maxSpeed)
        local maxSpeed = math.min(25, maxSpeed)

        velocity:Add(wishDir * kBlinkAcceleration * deltaTime)

        if velocity:GetLength() > maxSpeed then

            velocity:Normalize()
            velocity:Scale(maxSpeed)

        end

        -- additional acceleration when holding down blink to exceed max speed
        velocity:Add(wishDir * kBlinkAddAcceleration * deltaTime)

    end

    if not self.onGround then

      --initialisin
      local laccelmod = 1--acceleration value
      local lAirAcceleration = self:GetMaxSpeed()--maxSpeedTable.maxSpeed --accelerate to maximum speed in one second
      local wishDir = self:GetViewCoords():TransformVector(input.move) --this is a unit vector

      local wishDircurrentspeed = velocity:DotProduct(wishDir) --current velocity along wishdir axis
      --Q1 strafe check
      if (input.move.x == 1 or input.move.x == -1) and (input.move.z == 0) then
        laccelmod = 70
        lAirAcceleration = lAirAcceleration * 0.1 --accel limit FIXME some weird shit goes on when forward/rear speed is below maxspeed and acts as if this doesnt exist
      end

      local addspeedlimit = lAirAcceleration - wishDircurrentspeed
      if addspeedlimit <= 0 then return end

      accelerationIncrement = laccelmod * deltaTime * lAirAcceleration
      if accelerationIncrement > addspeedlimit then accelerationIncrement = addspeedlimit end

      --remove vertical speed
      wishDir.y = 0
      wishDir:Normalize()

      velocity:Add(wishDir * accelerationIncrement)

    end

end

function Fade:GetHasShadowStepCooldown()
    return self.timeShadowStep + kShadowStepCooldown > Shared.GetTime()
end

function Fade:GetRecentlyShadowStepped()
    return self.timeShadowStep + kShadowStepCooldown * 2 > Shared.GetTime()
end


--Readded shadowstep stuff
function Fade:GetHasShadowStepAbility()
    return true--self:GetHasTwoHives()
end

function Fade:GetHasMovementSpecial()
    return self:GetHasOneHive()
end

function Fade:GetMovementSpecialTechId()
  --[[
    if self:GetCanMetabolizeHealth() then
        return kTechId.MetabolizeHealth
    else
        return kTechId.MetabolizeEnergy
    end]]
    return kTechId.ShadowStep
end

function Fade:GetMovementSpecialEnergyCost()
    --return kMetabolizeEnergyCost
    return kFadeShadowStepCost
end

function Fade:MovementModifierChanged(newMovementModifierState, input)
--[[
    if newMovementModifierState and self:GetActiveWeapon() ~= nil then
        local weaponMapName = self:GetActiveWeapon():GetMapName()
        local metabweapon = self:GetWeapon(Metabolize.kMapName)
        if metabweapon and not metabweapon:GetHasAttackDelay() and self:GetEnergy() >= metabweapon:GetEnergyCost() then
            self:SetActiveWeapon(Metabolize.kMapName)
            self:PrimaryAttack()
            if weaponMapName ~= Metabolize.kMapName then
                self.previousweapon = weaponMapName
            end
        end
    end]]
    if newMovementModifierState then
        self:TriggerShadowStep(input.move)
            end

end
--[[
function Fade:GetMovementSpecialCooldown()
    local cooldown = 0
    local timeLeft = (Shared.GetTime() - self.timeMetabolize)

    local metabolizeWeapon = self:GetWeapon(Metabolize.kMapName)
    local metaDelay = metabolizeWeapon and metabolizeWeapon:GetAttackDelay() or 0
    if timeLeft < metaDelay then
        return Clamp(timeLeft / metaDelay, 0, 1)
    end

    return cooldown
end]]

function Fade:TriggerShadowStep(direction)

    --if not self:GetHasMovementSpecial() then
        --return
    --end

    if not GetIsTechResearched(self:GetTeamNumber(), kTechId.ShadowStep) then
        return
    end

    if direction:GetLength() == 0 then
        direction.z = 1
    end
    --[[
    if direction.z == 1 then
        direction.x = 0
    end
    --]]
    local movementDirection = self:GetViewCoords():TransformVector(direction)

--Ensure we are not stuck to the ground
    if self:GetIsOnSurface() then

        movementDirection.y = 0.25
        movementDirection:Normalize()
        self.onGround = false

    else
        movementDirection.y = math.min(0.25, movementDirection.y)
        movementDirection:Normalize()
    end

    if not self:GetIsBlinking() and not self:GetHasShadowStepCooldown() and self:GetEnergy() > kFadeShadowStepCost then

        local celerityAddSpeed = (GetHasCelerityUpgrade(self) and GetSpurLevel(self:GetTeamNumber()) or 0) * 0.7

        -- add small force in the direction we are stepping
        local currentSpeed = movementDirection:DotProduct(self:GetVelocity())
        local shadowStepStrength = math.max(currentSpeed + kShadowStepLimitForce, kMaxSpeed + kShadowStepForce)  + celerityAddSpeed
        self:SetVelocity(movementDirection * shadowStepStrength * self:GetSlowSpeedModifier())

        self.timeShadowStep = Shared.GetTime()
        self.shadowStepSpeed = kShadowStepSpeed
        self.shadowStepping = true
        self.shadowStepDirection = Vector(movementDirection)

        self:TriggerEffects("shadow_step", { effecthostcoords = Coords.GetLookIn(self:GetOrigin(), movementDirection) })
        self:DeductAbilityEnergy(kFadeShadowStepCost)
        --self:TriggerUncloak()

    end

end

function Fade:OverrideInput(input)

    Alien.OverrideInput(self, input)

    if self:GetIsShadowStepping() then
        input.move = self.shadowStepDirection
    elseif self:GetIsBlinking() then
        input.move.z = 1
        input.move.x = 0
    end

    return input

end

function Fade:GetIsShadowStepping()
    return self.shadowStepping
end

function Fade:PreUpdateMove(input, runningPrediction)
    self.shadowStepping = self.timeShadowStep + Fade.kShadowStepDuration > Shared.GetTime()
end
--[[ unused
function Fade:OnGroundChanged(onGround, impactForce, normal, velocity)

    Alien.OnGroundChanged(self, onGround, impactForce, normal, velocity)

    if onGround then
        self.landedAfterBlink = true
        self.hasDoubleJumped = false
    end

end]]

function Fade:ModifyAttackSpeed(attackSpeedTable)

    local activeWeapon = self:GetWeapon(StabBlink.kMapName)--self:GetActiveWeapon()
    if activeWeapon then
        attackSpeedTable.attackSpeed = attackSpeedTable.attackSpeed * 0.8
    end

end
