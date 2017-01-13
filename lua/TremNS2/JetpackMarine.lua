function JetpackMarine:GetAirControl()
    return 0
end

function JetpackMarine:ModifyVelocity(input, velocity, deltaTime)

    if self:GetIsJetpacking() then

        local verticalAccel = 22

        if self:GetIsWebbed() then
            verticalAccel = 5
        elseif input.move:GetLength() == 0 then
            verticalAccel = 26
        end

        self.onGround = false
        local thrust = math.max(0, -velocity.y) / 6
        velocity.y = math.min(5, velocity.y + verticalAccel * deltaTime * (1 + thrust * 2.5))

    end

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
