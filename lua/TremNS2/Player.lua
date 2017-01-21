-- This is how far the player can turn with their feet standing on the same ground before
-- they start to rotate in the direction they are looking.

-- Spectator Player speeds
Player.kWalkMaxSpeed = 10  -- 5 Four miles an hour = 6,437 meters/hour = 1.8 meters/second (increase for FPS tastes)
-- Slow down players when crouching
Player.kCrouchSpeedScalar = 0.25 --duckscale = 0.25, swimscale = 0.5

Player.kAcceleration = 100--40
Player.kRunAcceleration = 120--100

Player.kGravity = -25-- -21.5 --800/32 = 25
--Player.kMass = 90.7 -- ~200 pounds (incl. armor, weapons)
Player.kWalkBackwardSpeedScalar = 0.8--0.4
Player.kJumpHeight =  0.9375 --1.25 // V^2 = u^2 + 2as; player jumps at 220 ups which results in 30.25 units high ~=0.945
--Player.kOnGroundDistance = 0.1 --used for 'step down'

Player.kDamageIndicatorDrawTime = 0.25--1 cannot be 0

-- The slowest scalar of our max speed we can go to because of jumping
--Player.kMinSlowSpeedScalar = .3

local kBodyYawTurnThreshold = Math.Radians(50) --85deg

function Player:GetAirControl()
    return 0
end

function Player:GetBodyYawTurnThreshold()
    return -kBodyYawTurnThreshold, kBodyYawTurnThreshold
end

function Player:OnWeldOverride(doer, elapsedTime)

    -- macs weld marines by only 50% of the rate
    local macMod = (HasMixin(self, "Combat") and self:GetIsInCombat()) and 0.1 or 0.5
    local weldMod = ( doer ~= nil and doer:isa("MAC") ) and macMod or 1

    if self:GetArmor() < self:GetMaxArmor() then

        local addArmor = kPlayerArmorWeldRate * elapsedTime * weldMod
        local addHealth = kPlayerHealWeldRate * elapsedTime * weldMod
        self:SetArmor(self:GetArmor() + addArmor)
        self:AddHealth(addHealth, false, false)

    end

end

function Player:ModifyVelocity(input, velocity, deltaTime)
    --Air Strafe testing...
    if not self.onGround then

        local lAirAcceleration = self:GetMaxSpeed()--maxSpeedTable.maxSpeed --accelerate to maximum speed in one second
        local wishDir = self:GetViewCoords():TransformVector(input.move) --this is a unit vector
        local wishDirvelocity = velocity:DotProduct(wishDir) --current velocity along wishdir axis
        local acceleration = Clamp(lAirAcceleration - wishDirvelocity, 0, lAirAcceleration)
        --remove vertical speed
        wishDir.y = 0
        wishDir:Normalize()

        velocity:Add(wishDir * acceleration * deltaTime)

    end

end

function Player:GetGroundFriction()
    return 6
end
