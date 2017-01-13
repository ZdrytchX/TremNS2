--TODO: Deduct sprint energy when jumping by 5 point

SprintMixin.kMaxSprintTime = 12--6 --maxes out at 12

-- Rate at which max sprint time comes back when not sprinting (multiplier x time)
SprintMixin.kSprintRecoveryRate = 0.75 -- 1 --0.5

-- Must have this much energy to start sprint
SprintMixin.kMinSprintTime = 6 -- 1

-- After this time, play extra sounds to indicate player is getting tired
SprintMixin.kSprintTiredTime = SprintMixin.kMaxSprintTime * 2--0.4

-- Time it takes to get to top speed
SprintMixin.kSprintTime = 0.1--1.5 -- 0.1

-- Releasing the sprint key within this time after pressing it puts you in sprint mode
SprintMixin.kSprintLockTime = 0.5--.2

-- Time it takes to come to rest
SprintMixin.kUnsprintTime = kMaxTimeToSprintAfterAttack

SprintMixin.kTiredSoundName = PrecacheAsset("sound/NS2.fev/marine/common/sprint_tired")

function SprintMixin:__initmixin()

    if Server then
        self.sprinting = false
        self.timeSprintChange = Shared.GetTime()
        self.sprintTimeOnChange = SprintMixin.kMaxSprintTime

        self.desiredSprinting = false
        self.sprintingScalar = 0

        self.sprintButtonDownTime = 0
        self.sprintButtonUpTime = 0
        self.sprintDownLastFrame = false
        self.sprintMode = false
        self.requireNewSprintPress = false
    end

end

function SprintMixin:GetIsSprinting()
    return self.sprinting
end

function SprintMixin:GetSprintingScalar()
    return self.sprintingScalar
end
--
function SprintMixin:GetSufficientStamina()
    return Clamp(self:GetSprintTime() / SprintMixin.kMinSprintTime, 0.125, 1) --lower limit must be above 0.1
end
--
function SprintMixin:UpdateSprintingState(input)

    PROFILE("SprintMixin:UpdateSprintingState")

    local velocity = self:GetVelocity()
    local speed = velocity:GetLength()

    local weapon = self:GetActiveWeapon()
    local deployed = not weapon or not weapon.GetIsDeployed or weapon:GetIsDeployed()
    local sprintingAllowedByWeapon = not deployed or not weapon or (weapon.GetSprintAllowed and weapon:GetSprintAllowed())

    local attacking = false
    if weapon and weapon.GetTryingToFire then
        attacking = weapon:GetTryingToFire(input)
    end

    local buttonDown = (bit.band(input.commands, Move.MovementModifier) ~= 0)
    if not weapon or (not weapon.GetIsReloading or not weapon:GetIsReloading()) then
        self:UpdateSprintMode(buttonDown)
    end

    -- Allow small little falls to not break our sprint (stairs)
    self.desiredSprinting = (buttonDown or self.sprintMode) and sprintingAllowedByWeapon and speed > 1 and not self.crouching and not self.requireNewSprintPress and not attacking-- and self:GetIsOnGround()

    if input.move.z < kEpsilon then
        self.desiredSprinting = false
    else

        -- Only allow sprinting if we're pressing forward and moving in that direction
        local normMoveDirection = GetNormalizedVectorXZ(self:GetViewCoords():TransformVector(input.move))
        local normVelocity = GetNormalizedVectorXZ(velocity)
        local viewFacing = GetNormalizedVectorXZ(self:GetViewCoords().zAxis)

        if normVelocity:DotProduct(normMoveDirection) < 0.3 or normMoveDirection:DotProduct(viewFacing) < 0.2 then
            self.desiredSprinting = false
        end

    end

    if self.desiredSprinting ~= self.sprinting then

      -- Only allow sprinting to start if we have some minimum energy (so we don't start and stop constantly)
      if not self.desiredSprinting or (self:GetSprintTime() >= SprintMixin.kMinSprintTime) then

          self.sprintTimeOnChange = self:GetSprintTime()
          local sprintDuration = math.max(0, Shared.GetTime() - self.timeSprintChange)
          self.timeSprintChange = Shared.GetTime()
          self.sprinting = self.desiredSprinting

          if self.sprinting then

              if self.OnSprintStart then
                  self:OnSprintStart()
              end

          else

              if self.OnSprintEnd then
                  self:OnSprintEnd(sprintDuration)
              end

          end

      end

    end

    -- Some things break us out of sprint mode
    if self.sprintMode and (--[[attacking or not self:GetIsOnGround() or ]]speed <= 1 or self.crouching) then
        self.sprintMode = false
        self.requireNewSprintPress = true--attacking
    end
--
    self.sprintingScalar = self:GetSufficientStamina()
    --[[
    if self.desiredSprinting then
        self.sprintingScalar =   Clamp((Shared.GetTime() - self.timeSprintChange) / SprintMixin.kSprintTime, 0, 1) * self:GetSprintTime() / SprintMixin.kMaxSprintTime
    else
        self.sprintingScalar =  1 - Clamp((Shared.GetTime() - self.timeSprintChange) / SprintMixin.kUnsprintTime, 0, 1)
    end]]

end

function SprintMixin:OnUpdate(deltaTime)
    PROFILE("SprintMixin:OnUpdate")
    if self.OnUpdateSprint then
        self:OnUpdateSprint(self.sprinting)
    end

end

function SprintMixin:OnProcessMove(input)

    local deltaTime = input.time

    if self.OnUpdateSprint then
        self:OnUpdateSprint(self.sprinting)
    end

--here
    if self.sprinting then

        if self:GetSprintTime() == 0 then

            self.sprintTimeOnChange = 0
            self.timeSprintChange = Shared.GetTime()
            self.sprinting = false

            ---if self.OnSprintEnd then
            ---    self:OnSprintEnd()
            ---end

            -- Play local sound when we're tired (max 1 playback)
            if Client and (Client.GetLocalPlayer() == self) then
                Shared.PlaySound(self, SprintMixin.kTiredSoundName)
            end

            self.sprintMode = false

            if self.sprintDownLastFrame then
                self.requireNewSprintPress = true
            end

        end

    end--to here

end

function SprintMixin:GetSprintTime()
    local dt = Shared.GetTime() - self.timeSprintChange
    local rate = self.sprinting and -1 or SprintMixin.kSprintRecoveryRate
    return Clamp(self.sprintTimeOnChange + dt * rate , 0, SprintMixin.kMaxSprintTime)
end

function SprintMixin:GetTiredScalar()
    return Clamp( (1 - (self:GetSprintTime() / SprintMixin.kMaxSprintTime) ) * 2, 0, 1)
end
