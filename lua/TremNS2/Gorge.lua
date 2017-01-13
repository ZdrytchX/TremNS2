Gorge.kXZExtents = 0.5
Gorge.kYExtents = 0.475

--local kMass = 80
--local kJumpHeight = 1.2
local kStartSlideSpeed = 10
--local kViewOffsetHeight = 0.6
local kMaxGroundSpeed = 8--6
local kMaxSlidingSpeed = 20--13
--local kSlidingMoveInputScalar = 0.1
--local kBuildingModeMovementScalar = 0.001
--local kSlideCoolDown = 1.5

Gorge.kAirZMoveWeight = 2.5
Gorge.kAirStrafeWeight = 2.5
Gorge.kAirBrakeWeight = 0.1 --0.1

--local kGorgeLeanSpeed = 3

Gorge.kBellyFriction = 0.1
Gorge.kBellyFrictionOnInfestation = 0.02--0.068

function Gorge:GetMaxSpeed(possible)
    return kMaxGroundSpeed
end

function Gorge:GetAcceleration()
    return self:GetIsBellySliding() and 0 or 8
end

function Gorge:GetGroundFriction()

    if self:GetIsBellySliding() then
        return self:GetGameEffectMask(kGameEffect.OnInfestation) and Gorge.kBellyFrictionOnInfestation or Gorge.kBellyFriction
    end

    return 6--7

end

function Gorge:GetAirControl()
    return 0--8--4 XXX TESTING strafe below XXX
end

function Gorge:GetAirFriction()
    return 0--0.8
end

function Gorge:ModifyAttackSpeed(attackSpeedTable)

    local activeWeapon = self:GetActiveWeapon()
    if activeWeapon then
        attackSpeedTable.attackSpeed = attackSpeedTable.attackSpeed * 0.8
    end

end

function Gorge:PostUpdateMove(input, runningPrediction)

    if self:GetIsBellySliding() and self:GetIsOnGround() then

        local velocity = self:GetVelocity()

        local yTravel = self:GetOrigin().y - self.prevY
        local xzSpeed = velocity:GetLengthXZ()

        xzSpeed = xzSpeed + yTravel * -4

        if xzSpeed < kMaxSlidingSpeed or yTravel > 0 then

            local directionXZ = GetNormalizedVectorXZ(velocity)
            directionXZ:Scale(xzSpeed)

            velocity.x = directionXZ.x
            velocity.z = directionXZ.z

            self:SetVelocity(velocity)

        end

        self.verticalVelocity = yTravel / input.time

    end

end

function Gorge:ModifyVelocity(input, velocity, deltaTime)

    -- Give a little push forward to make sliding useful
    if self.startedSliding then

        if self:GetIsOnGround() then

            local pushDirection = GetNormalizedVectorXZ(self:GetViewCoords().zAxis)

            local currentSpeed = math.max(0, pushDirection:DotProduct(velocity))

            local maxSpeedTable = { maxSpeed = kStartSlideSpeed }
            self:ModifyMaxSpeed(maxSpeedTable, input)

            local addSpeed = math.max(0, maxSpeedTable.maxSpeed - currentSpeed)
            local impulse = pushDirection * addSpeed

            velocity:Add(impulse)

        end

        self.startedSliding = false

    end

    if self:GetIsBellySliding() then

        local currentSpeed = velocity:GetLengthXZ()
        local prevY = velocity.y
        velocity.y = 0

        local addVelocity = self:GetViewCoords():TransformVector(input.move)
        addVelocity.y = 0
        addVelocity:Normalize()
        addVelocity:Scale(deltaTime * 10)

        velocity:Add(addVelocity)
        velocity:Normalize()
        velocity:Scale(currentSpeed)
        velocity.y = prevY

    end
--XXX
    --Air Strafe testing...
    --forward z = +1 || left x = +1
--XXX
    if not self.onGround then

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
--[[
        if velocity:GetLengthXZ() > maxSpeed then

            local yVel = velocity.y
            velocity.y = 0
            velocity:Normalize()
            velocity:Scale(maxSpeed)
            velocity.y = yVel

        end]]

        --if self:GetIsJetpacking() then
        --    velocity:Add(wishDir * kJetpackingAccel * deltaTime)
        --end

--This is what q3 has:
--[[
        int     i;
float   addspeed, accelspeed, currentspeed;

currentspeed = DotProduct( pm->ps->velocity, wishdir );
addspeed = wishspeed - currentspeed;
if( addspeed <= 0 )
  return;

accelspeed = accel * pml.frametime * wishspeed;
if( accelspeed > addspeed )
  accelspeed = addspeed;

for( i = 0; i < 3; i++ )
  pm->ps->velocity[ i ] += accelspeed * wishdir[ i ];


  more garbage
        int     i;
  float   addspeed, accelspeed, currentspeed;

  currentspeed = DotProduct( pm->ps->velocity, wishdir );
  addspeed = wishspeed - currentspeed;
  if( addspeed <= 0 )
    return;

  accelspeed = accel * pml.frametime * wishspeed;
  if( accelspeed > addspeed )
    accelspeed = addspeed;

  for( i = 0; i < 3; i++ )
    pm->ps->velocity[ i ] += accelspeed * wishdir[ i ];
  ]]

  ----------------------


--[[local prevXZSpeed = velocity:GetLengthXZ()
local maxSpeedTable = { maxSpeed = math.max(kFlySpeed, prevXZSpeed) }
self:ModifyMaxSpeed(maxSpeedTable)
local maxSpeed = maxSpeedTable.maxSpeed

if not self.onGround then

    -- do XZ acceleration
    local prevXZSpeed = velocity:GetLengthXZ()
    local maxSpeedTable = { maxSpeed = math.max(kFlySpeed, prevXZSpeed) }
    self:ModifyMaxSpeed(maxSpeedTable)
    local maxSpeed = maxSpeedTable.maxSpeed

    if not self:GetIsJetpacking() then
        maxSpeed = prevXZSpeed
    end

    local wishDir = self:GetViewCoords():TransformVector(input.move)
    local acceleration = 0
    wishDir.y = 0
    wishDir:Normalize()

    acceleration = kFlyAcceleration

    velocity:Add(wishDir * acceleration * self:GetInventorySpeedScalar() * deltaTime)

    if velocity:GetLengthXZ() > maxSpeed then

        local yVel = velocity.y
        velocity.y = 0
        velocity:Normalize()
        velocity:Scale(maxSpeed)
        velocity.y = yVel

    end

    if self:GetIsJetpacking() then
        velocity:Add(wishDir * kJetpackingAccel * deltaTime)
    end

end
]]
