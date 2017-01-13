Onos.kJumpForce = 20
Onos.kJumpVerticalVelocity = 8

Onos.kJumpRepeatTime = .25
Onos.kViewOffsetHeight = 2.5
Onos.XExtents = .7
Onos.YExtents = 1.2
Onos.ZExtents = .4
Onos.kMass = 453 -- Half a ton
Onos.kJumpHeight = 1.15

-- triggered when the momentum value has changed by this amount (negative because we trigger the effect when the onos stops, not accelerates)
Onos.kMomentumEffectTriggerDiff = 3

Onos.kGroundFrictionForce = 3

-- used for animations and sound effects
Onos.kMaxSpeed = 12--7.5
Onos.kChargeSpeed = 24--11.5

Onos.kHealth = kOnosHealth
Onos.kArmor = kOnosArmor
Onos.kChargeEnergyCost = kChargeEnergyCost

Onos.kChargeUpDuration = 2--0.5
Onos.kChargeDelay = 1.0

-- mouse sensitivity scalar during charging
Onos.kChargingSensScalar = 1--0

Onos.kStoopingCheckInterval = 0.3
Onos.kStoopingAnimationSpeed = 2
Onos.kYHeadExtents = 0.7
Onos.kYHeadExtentsLowered = 0.0

function Onos:GetAcceleration()
    return 12--6.5
end

function Onos:GetAirControl()
    return 0--12--4
end

function Onos:GetGroundFriction()
    return 6
end

function Onos:GetCrouchShrinkAmount()
    return 0.1--0.4
end

function Onos:GetExtentsCrouchShrinkAmount()
    return 0.1--0.4
end

function Onos:GetAirFriction()
    return 0--0.28
end

function Onos:GetMaxViewOffsetHeight()
    return Onos.kViewOffsetHeight
end

function Onos:GetMaxBackwardSpeedScalar()
    return 0.8
end

function Onos:ModifyAttackSpeed(attackSpeedTable)

    local activeWeapon = self:GetActiveWeapon()
    if activeWeapon and activeWeapon:isa("Gore") and activeWeapon:GetAttackType() == Gore.kAttackType.Smash then
        attackSpeedTable.attackSpeed = attackSpeedTable.attackSpeed * 1.375
    else
        attackSpeedTable.attackSpeed = attackSpeedTable.attackSpeed * 0.75
    end

end

function Fade:ModifyVelocity(input, velocity, deltaTime)
if not self.onGround then

  --initialising
  local lAirAcceleration = self:GetMaxSpeed()--maxSpeedTable.maxSpeed --accelerate to maximum speed in one second
  local wishDir = self:GetViewCoords():TransformVector(input.move) --this is a unit vector

  local wishDircurrentspeed = velocity:DotProduct(wishDir) --current velocity along wishdir axis

  local addspeedlimit = lAirAcceleration - wishDircurrentspeed
  if addspeedlimit <= 0 then return end

  accelerationIncrement = deltaTime * lAirAcceleration
  if accelerationIncrement > addspeedlimit then accelerationIncrement = addspeedlimit end

  --remove vertical speed
  wishDir.y = 0
  wishDir:Normalize()

  velocity:Add(wishDir * accelerationIncrement)

end
end
