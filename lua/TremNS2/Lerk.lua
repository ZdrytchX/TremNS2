-- if the user hits a wall and holds the use key and the resulting speed is < this, grip starts
Lerk.kWallGripMaxSpeed = 8--4
-- once you press grip, you will slide for this long a time and then stop. This is also the time you
-- have to release your movement keys, after this window of time, pressing movement keys will release the grip.
Lerk.kWallGripSlideTime = 0.7
-- after landing, the y-axis of the model will be adjusted to the wallGripNormal after this time.
Lerk.kWallGripSmoothTime = 0.6

-- how to grab for stuff ... same as the skulk tight-in code
Lerk.kWallGripRange = 0.2
Lerk.kWallGripFeelerSize = 0.25

Lerk.kIdleSoundMinSpeed = 12.5--11.5 -- also is max speed that can be temporarily reached by flapping while holding on the brakes
Lerk.kIdleSoundMinPlayLength = 3 -- also is max speed that can be temporarily reached by flapping while holding on the brakes
Lerk.kIdleSoundMinSilenceLength = 5 -- also is max speed that can be temporarily reached by flapping while holding on the brakes


local kViewOffsetHeight = 0.5
Lerk.XZExtents = 0.4
Lerk.YExtents = 0.4
-- ~120 pounds
local kMass = 54
local kJumpHeight = 1.5

-- Lerks walk slowly to encourage flight
local kMaxWalkSpeed = 6.25--2.8
local kMaxSpeed = 25--12.5
kAirStrafeMaxSpeed = 6.25--5.5

local flying2DSound = PrecacheAsset("sound/NS2.fev/alien/lerk/flying")
local flying3DSound = PrecacheAsset("sound/NS2.fev/alien/lerk/flying")

local kGlideAccel = 7--6 you can set tihs negative to achieve thrust --0.25
Lerk.kFlapForce = 6--5
Lerk.kFlapForceForward = 12.5--8.3
Lerk.kFlapForceStrafe = 8--7

Lerk.kGravity = -9.8 -- -7
Lerk.kSwoopGravity = Lerk.kGravity * 3--6
--12.5
function Lerk:GetAirAcceleration()
    return 12.5 + (GetHasCelerityUpgrade(self) and GetSpurLevel(self:GetTeamNumber()) or 0) * 1--0
end
--0.717 0.027
function Lerk:GetAirFriction()
    return 0.22 - (GetHasCelerityUpgrade(self) and GetSpurLevel(self:GetTeamNumber()) or 0) * 0.035--0.08 0.055 - (GetHasCelerityUpgrade(self) and GetSpurLevel(self:GetTeamNumber()) or 0) * 0.009
end

local function UpdateGlide(self, input, velocity, deltaTime)

    -- more control when moving forward
    local holdingGlide = bit.band(input.commands, Move.Jump) ~= 0 and self.glideAllowed
    if input.move.z == 1 and holdingGlide then

        local useMove = Vector(input.move)
        useMove.x = useMove.x * 0.5

        local wishDir = GetNormalizedVector(self:GetViewCoords():TransformVector(useMove))
        -- slow down when moving in another XZ direction, accelerate when falling down
        local currentDir = GetNormalizedVector(velocity)
        local glideAccel = -currentDir.y * deltaTime * kGlideAccel

        local maxSpeedTable = { maxSpeed = kMaxSpeed }
        self:ModifyMaxSpeed(maxSpeedTable, input)

        local speed = velocity:GetLength() -- velocity:DotProduct(wishDir) * 0.1 + velocity:GetLength() * 0.9
        local useSpeed = math.min(maxSpeedTable.maxSpeed, speed + glideAccel)

        -- when speed falls below 1, set horizontal speed to 1, and vertical speed to zero, but allow dive to regain speed
        --
        if useSpeed < 6.25 then
          self.gliding = false
          self.glideAllowed = false
          if useSpeed < 3 then
            useSpeed = 3
            local newY = math.min(wishDir.y, -1)
            wishDir.y = newY
            wishDir = GetNormalizedVector(wishDir)
          end

        end

        -- when gliding we always have 100% control
        local redirectVelocity = wishDir * useSpeed
        VectorCopy(redirectVelocity, velocity)
        --velocity:Add(redirectVelocity * deltaTime)

        self.gliding = not self:GetIsOnGround()

    else
        self.gliding = false
    end

end

-- jetpack and exo do the same, move to utility function
local function UpdateAirStrafe(self, input, velocity, deltaTime)

    if not self:GetIsOnGround() and not self.gliding then

        -- do XZ acceleration
        local wishDir = self:GetViewCoords():TransformVector(input.move)
        wishDir.y = 0
        wishDir:Normalize()

        local maxSpeed = math.max(kAirStrafeMaxSpeed, velocity:GetLengthXZ())
        velocity:Add(wishDir * 18 * deltaTime)

        if velocity:GetLengthXZ() > maxSpeed then

            local yVel = velocity.y
            velocity.y = 0
            velocity:Normalize()
            velocity:Scale(maxSpeed)
            velocity.y = yVel

        end

    end

end

local function UpdateCrouchDive(self, input, velocity, deltaTime)
    if self:GetCrouching() and not self:GetIsOnGround() then

        local vy = velocity.y
        if velocity.y > 0 then
            -- cut upwards momentum quick
            velocity.y = velocity.y - velocity.y * 5 * deltaTime
        else

            ---- add some air friction at high speeds
            local maxSpeedTable = { maxSpeed = kMaxSpeed }
            self:ModifyMaxSpeed(maxSpeedTable, input)

            local maxSpeed = maxSpeedTable.maxSpeed * 1.5
            if velocity.y * velocity.y > maxSpeed * maxSpeed then
                -- add some high speedair friction
                velocity.y = velocity.y - velocity.y * 1.5 * deltaTime
            end

        end

    end
end

local function UpdateFlap(self, input, velocity)

    local flapPressed = bit.band(input.commands, Move.Jump) ~= 0

    if flapPressed ~= self.flapPressed then

        self.flapPressed = flapPressed
        self.glideAllowed = not self:GetIsOnGround()

        if flapPressed and self:GetEnergy() > kLerkFlapEnergyCost and not self.gliding then

            -- take off
            if self:GetIsOnGround() or input.move:GetLength() == 0 then
                velocity.y = velocity.y * 0.5 + 5

            else

                local flapForce = Lerk.kFlapForce
                local move = Vector(input.move)
                move.x = move.x * 0.75
                -- flap only at 50% speed side wards

                local wishDir = self:GetViewCoords():TransformVector(move)
                wishDir:Normalize()

                -- the speed we already have in the new direction
                local currentSpeed = move:DotProduct(velocity)
                -- prevent exceeding max speed of kMaxSpeed by flapping
                local maxSpeedTable = { maxSpeed = kMaxSpeed }
                self:ModifyMaxSpeed(maxSpeedTable, input)

                local maxSpeed = math.max(currentSpeed, maxSpeedTable.maxSpeed)

                if input.move.z ~= 1 and velocity.y < 0 then
                    -- apply vertical flap
                    velocity.y = velocity.y * 0.5 + 3.8
                elseif input.move.z == 1 and input.move.x == 0 then
                    -- flapping forward
                    flapForce = Lerk.kFlapForceForward
                elseif input.move.z == 0 and input.move.x ~= 0 then
                    -- strafe flapping
                    flapForce = Lerk.kFlapForceStrafe
                    velocity.y = velocity.y + 3.5
                end

                -- directional flap
                velocity:Scale(0.65)
                velocity:Add(wishDir * flapForce)

                if velocity:GetLengthSquared() > maxSpeed * maxSpeed then
                    velocity:Normalize()
                    velocity:Scale(maxSpeed)
                end

            end

            self:DeductAbilityEnergy(kLerkFlapEnergyCost)
            self.lastTimeFlapped = Shared.GetTime()
            self.onGround = false
            self:TriggerEffects("flap")

        end

    end

end

--Maximum Walk Speed

function Lerk:OverrideGetMoveSpeed(speed)

    if self:GetIsOnGround() then
        return kMaxWalkSpeed
    end
    -- move_speed determines how often we flap. We fiddle some to
    -- flap more at minimum flying speed
    return Clamp((speed - kMaxWalkSpeed) / kMaxSpeed, 0, 1)

end

-- but always use walk speed fucks up the move_speed variable; it is set with possible=true.
-- gliding animation goes up to max at 2.8m/s rather than 13m/s...
-- always use walk speed. flying is handled in modify velocity
function Lerk:GetMaxSpeed(possible)

    if possible then
        return kMaxWalkSpeed
    end

    if self:GetIsOnGround() then
        return kMaxWalkSpeed
    else
        return kMaxSpeed
    end

end

function Lerk:ModifyVelocity(input, velocity, deltaTime)

    UpdateFlap(self, input, velocity)
    UpdateAirStrafe(self, input, velocity, deltaTime)
    UpdateGlide(self, input, velocity, deltaTime)
    UpdateCrouchDive(self, input, velocity, deltaTime)

end

function Lerk:ModifyAttackSpeed(attackSpeedTable)

    local activeWeapon = self:GetActiveWeapon()
    if activeWeapon then
        attackSpeedTable.attackSpeed = attackSpeedTable.attackSpeed * 1.25 --1.25 = ~400msec, 1.5 ~= 333msec
    end

end
