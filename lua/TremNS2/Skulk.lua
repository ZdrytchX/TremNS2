local kLeapVerticalForce = 10.8
local kLeapTime = 0.2
local kLeapForce = 14--7.6

-- How big the spheres are that are casted out to find walls, "feelers".
-- The size is calculated so the "balls" touch each other at the end of their range
--local kNormalWallWalkFeelerSize = 0.25
--local kNormalWallWalkRange = 0.3

-- jump is valid when you are close to a wall but not attached yet at this range
--local kJumpWallRange = 0.4
--local kJumpWallFeelerSize = 0.1

Skulk.kMaxSpeed = 13--7.25
Skulk.kSneakSpeedModifier = 0.66

local kMass = 45 -- ~100 pounds


Skulk.kXExtents = .45
Skulk.kYExtents = .45
Skulk.kZExtents = .45

Skulk.kMaxSneakOffset = 0 --0.55

Skulk.kWallJumpInterval = 0.4
Skulk.kWallJumpForce = 6.4 -- scales down the faster you are
Skulk.kMinWallJumpForce = 0.1
Skulk.kVerticalWallJumpForce = 4.3

Skulk.kWallJumpMaxSpeed = 26--11
Skulk.kWallJumpMaxSpeedCelerityBonus = 2--1.2

--[[
function Skulk:OnInitialized()

    Alien.OnInitialized(self)

    -- Note: This needs to be initialized BEFORE calling SetModel() below
    -- as SetModel() will call GetHeadAngles() through SetPlayerPoseParameters()
    -- which will cause a script error if the Skulk is wall walking BEFORE
    -- the Skulk is initialized on the client.
    self.currentWallWalkingAngles = Angles(0.0, 0.0, 0.0)

    self:SetModel(self:GetVariantModel(), kSkulkAnimationGraph)

--twiliteblue's wallwalk mod
    self.wallWalking = false
    self.wallWalkingNormalGoal = Vector.yAxis
    self.wallTooClose = false
	  self.wallStep = false
	  self.timeLastWallWalkCheck = 0
	  self.timeOfLastJumpLand = 0
	  self.wallWalkForce = 0

    if Client then

        self.currentCameraRoll = 0
        self.goalCameraRoll = 0

        self:AddHelpWidget("GUIEvolveHelp", 2)
        self:AddHelpWidget("GUISkulkParasiteHelp", 1)
        self:AddHelpWidget("GUISkulkLeapHelp", 2)
        self:AddHelpWidget("GUIMapHelp", 1)
        self:AddHelpWidget("GUITunnelEntranceHelp", 1)

    end

    InitMixin(self, IdleMixin)

end]]

function Skulk:GetPlayFootsteps()
    return self:GetVelocityLength() > .8 and self:GetIsOnGround() and self:GetIsAlive() and not self.movementModiferState
end--.75

function Skulk:GetTriggerLandEffect()
    local xzSpeed = self:GetVelocity():GetLengthXZ()
    return Alien.GetTriggerLandEffect(self) and (not self.movementModiferState or xzSpeed > 11) --7
end

function Skulk:GetCollisionSlowdownFraction()
    return 1--0.15
end

-- The Skulk movement should factor in the vertical velocity
-- only when wall walking.
function Skulk:GetMoveSpeedIs2D()
    return not self:GetIsWallWalking()
end

function Skulk:GetAcceleration()
    return 13
end

function Skulk:GetAirControl()
    return 165 * self:GetMaxSpeed() / 10--14--27
end

function Skulk:ModifyVelocity(input, velocity, deltaTime)
    --Air Strafe testing...
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

function Skulk:OnLeap()

    local velocity = self:GetVelocity() * 0.5 --0.5 = 1.5x limit
    local forwardVec = self:GetViewAngles():GetCoords().zAxis
    local newVelocity = velocity + GetNormalizedVectorXZ(forwardVec) * kLeapForce

    -- Add in vertical component.
    newVelocity.y = kLeapVerticalForce * forwardVec.y + kLeapVerticalForce * 0.5 + ConditionalValue(velocity.y < 0, velocity.y, 0)

    self:SetVelocity(newVelocity)

    self.leaping = true
    self.wallWalking = false
    self:DisableGroundMove(0.2)

    self.timeOfLeap = Shared.GetTime()

end

function Skulk:GetGroundTransistionTime()
    return 0.1
end

function Skulk:GetAirAcceleration()
    return 13--9
end

function Skulk:GetAirFriction()
    return 0--0.055 - (GetHasCelerityUpgrade(self) and GetSpurLevel(self:GetTeamNumber()) or 0) * 0.009
end

function Skulk:GetGroundFriction()
    return 6--11
end

function Skulk:GetCanStep()
    return not self:GetIsWallWalking()
end

--triliteblue's skulk wallwalk mod
--[[
// Update wall-walking from current origin
function Skulk:PreUpdateMove(input, runningPrediction)

    PROFILE("Skulk:PreUpdateMove")
    /*
    local dashDesired = bit.band(input.commands, Move.MovementModifier) ~= 0 and self:GetVelocity():GetLength() > 4
    if not self.dashing and dashDesired and self:GetEnergy() > 15 then
        self.dashing = true
    elseif self.dashing and not dashDesired then
        self.dashing = false
    end

    if self.dashing then
        self:DeductAbilityEnergy(input.time * 30)
    end

    if self:GetEnergy() == 0 then
        self.dashing = false
    end
    */

	local wallWalkedLastFrame = self.wallWalking
	if self:GetIsWallWalkingPossible() then
		if self:GetCrouching() then
			self.wallWalking = true
		end
	else
		self.wallWalking = false
    end

    if self.wallWalking then

        -- Most of the time, it returns a fraction of 0, which means
        -- trace started outside the world (and no normal is returned)
        local goal = self:GetAverageWallWalkingNormal(kNormalWallWalkRange, kNormalWallWalkFeelerSize)
        if goal ~= nil then

            self.wallWalkingNormalGoal = goal
            self.wallWalking = true

        else

            self.wallWalking = false
        end

    end

	if self.wallWalking and not wallWalkedLastFrame then
		self.timeOfLastJumpLand = Shared.GetTime()
	end

    if not self:GetIsWallWalking() then
        // When not wall walking, the goal is always directly up (running on ground).
        --self.wallWalkingNormalGoal = Vector.yAxis
		self.wallTooClose = false
		self.wallStep = false
    end

    if self.leaping and Shared.GetTime() > self.timeOfLeap + kLeapTime then
        self.leaping = false
    end
    self.currentWallWalkingAngles = self:GetAnglesFromWallNormal(self.wallWalkingNormalGoal or Vector.yAxis) or self.currentWallWalkingAngles

    // adjust the sneakOffset so sneaking skulks can look around corners without having to expose themselves too much
    local delta = input.time * math.min(1, self:GetVelocityLength())
    if self.movementModiferState then
        if self.sneakOffset < Skulk.kMaxSneakOffset then
            self.sneakOffset = math.min(Skulk.kMaxSneakOffset, self.sneakOffset + delta)
        end
    else
        if self.sneakOffset > 0 then
            self.sneakOffset = math.max(0, self.sneakOffset - delta)
        end
    end
end

function Skulk:PostUpdateMove(input, runningPrediction)

    if self:GetIsWallWalking() then
        --pull skulk toward the wall
		local velocity = self:GetVelocity()
		local prevSpeed = math.max(self:GetMaxSpeed(), self:GetVelocityLength()) --self:GetVelocityLength()
		local pullStrength = 1

		if not self.wallTooClose then
			local pullVelocity = Vector()
			local dotSpeed = velocity:DotProduct(self.wallWalkingNormalGoal)

			-- VERY strong pull towards wall when movement modifier or crouch key is not held down
			if not self:GetCrouching() then
				local kGripMultiplier = 12
				pullStrength = pullStrength * kGripMultiplier
			elseif self.movementModiferState then
				local kGripMultiplier = 8
				pullStrength = pullStrength * kGripMultiplier
			elseif input.move:GetLength() > 0 and (self.timeOfLastJumpLand + 0.8 < Shared.GetTime()) then
				pullStrength = math.max(0, pullStrength - math.abs(dotSpeed))
			end

			pullVelocity = -self.wallWalkingNormalGoal * pullStrength
			self.wallWalkForce = pullStrength
			local completedMove, hitEntities, averageSurfaceNormal = self:PerformMovement(pullVelocity * input.time, 3, nil, true)

		else
]]
			--[[ try to push away from the wall we are clinging to, to walk over obstacles
			otherwise, we are bumping into the wall we are sticking to, take a break from pulling towards the wall]]
--[[
			self.wallWalkForce = 0

			if input.move:GetLength() > 0 then

				/*if Client then
					DebugLine(self:GetOrigin(), self:GetOrigin() + forwardDir, 5, 0,1,0,1)
				end*/

				if Shared.GetTime() > self.timeLastWallWalkCheck then
					self.wallTooClose = false
					self.wallStep = false
				end

			end

		end
	end
end
]]
