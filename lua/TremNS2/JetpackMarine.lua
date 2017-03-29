local kFlyFriction = 2--0.0

JetpackMarine.kJetpackFuelReplenishDelay = 2-- .4
JetpackMarine.kJetpackGravity = -25-- -16
JetpackMarine.kJetpackTakeOffTime = 1 -- .39

local kFlySpeed = 5
local kFlyAccelerationMod = 2--28

function JetpackMarine:GetAirFriction()
    return kFlyFriction
end

function JetpackMarine:GetAirControl()
    return 0
end

---------------------

function JetpackMarine:ModifyVelocity(input, velocity, deltaTime)

    if self:GetIsJetpacking() then

        local verticalAccel = 25--22

        if self:GetIsWebbed() then
            verticalAccel = 0--5
        elseif input.move:GetLength() == 0 then
            verticalAccel = 30--26
        end

        self.onGround = false
        local thrust = math.max(0, -velocity.y) / 6
        velocity.y = math.min(5, velocity.y + verticalAccel * deltaTime * (1 + thrust * 2.5))

    end

    if not self.onGround then

local lAirAcceleration = self:GetMaxSpeed() * kFlyAccelerationMod--maxSpeedTable.maxSpeed --accelerate to maximum speed in one second
local wishDir = self:GetViewCoords():TransformVector(input.move) --this is a unit vector

local wishDircurrentspeed = velocity:DotProduct(wishDir) --current velocity along wishdir axis

local addspeedlimit = kFlySpeed - wishDircurrentspeed
if addspeedlimit <= 0 then return end

accelerationIncrement = deltaTime * lAirAcceleration
if accelerationIncrement > addspeedlimit then accelerationIncrement = addspeedlimit end

--remove vertical speed
wishDir.y = 0
wishDir:Normalize()

velocity:Add(wishDir * accelerationIncrement)

    end

end
