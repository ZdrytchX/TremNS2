local kChargeTime = 5--2
-- The Railgun will automatically shoot if it is charged for too long.
local kChargeForceShootTime = 8--2.2
local kRailgunRange = 400
local kRailgunSpread = Math.Radians(0)
local kBulletSize = 0.3

local kRailgunChargeTime = 1.8--1.4

local kChargeSound = PrecacheAsset("sound/NS2.fev/marine/heavy/railgun_charge")

function Railgun:OnPrimaryAttack(player)

    if not self.lockCharging and self.timeOfLastShot + kRailgunChargeTime <= Shared.GetTime() then

        if not self.railgunAttacking then

            self.timeChargeStarted = Shared.GetTime()

            -- lock the second gun
            --[[
            local exoWeaponHolder = player:GetActiveWeapon()
            if exoWeaponHolder then

                local otherSlotWeapon = self:GetExoWeaponSlot() == ExoWeaponHolder.kSlotNames.Left and exoWeaponHolder:GetRightSlotWeapon() or exoWeaponHolder:GetLeftSlotWeapon()
                if otherSlotWeapon and otherSlotWeapon:isa("Railgun") and not otherSlotWeapon.railgunAttacking then
                    otherSlotWeapon:LockGun()
                end

            end
              ]]

        end
        self.railgunAttacking = true

    end

end


function Railgun:LockGun()
    self.timeOfLastShot = Shared.GetTime()
end

local function ExecuteShot(self, startPoint, endPoint, player)

    -- Filter ourself out of the trace so that we don't hit ourselves.
    local filter = EntityFilterTwo(player, self)
    local trace = Shared.TraceRay(startPoint, endPoint, CollisionRep.Damage, PhysicsMask.Bullets, EntityFilterAllButIsa("Tunnel"))
    local hitPointOffset = trace.normal * 0.3
    local direction = (endPoint - startPoint):GetUnit()
    local damage = kRailgunDamage + math.min(1, (Shared.GetTime() - self.timeChargeStarted) / kChargeTime) * kRailgunChargeDamage

    local extents = GetDirectedExtentsForDiameter(direction, kBulletSize)

    if trace.fraction < 1 then

        -- do a max of 10 capsule traces, should be sufficient
        local hitEntities = {}
        for i = 1, 20 do

            local capsuleTrace = Shared.TraceBox(extents, startPoint, trace.endPoint, CollisionRep.Damage, PhysicsMask.Bullets, filter)
            if capsuleTrace.entity then

                if not table.find(hitEntities, capsuleTrace.entity) then

                    table.insert(hitEntities, capsuleTrace.entity)
                    self:DoDamage(damage, capsuleTrace.entity, capsuleTrace.endPoint + hitPointOffset, direction, capsuleTrace.surface, false, false)

                end

            end

            if (capsuleTrace.endPoint - trace.endPoint):GetLength() <= extents.x then
                break
            end

            -- use new start point
            startPoint = Vector(capsuleTrace.endPoint) + direction * extents.x * 3

        end

        -- for tracer
        local effectFrequency = self:GetTracerEffectFrequency()
        local showTracer = ConditionalValue(GetIsVortexed(player), false, math.random() < effectFrequency)
        self:DoDamage(0, nil, trace.endPoint + hitPointOffset, direction, trace.surface, false, showTracer)

        if Client and showTracer then
            TriggerFirstPersonTracer(self, trace.endPoint)
        end

    end

end

function Railgun:GetChargeAmount()
    return self.railgunAttacking and math.min(1, (Shared.GetTime() - self.timeChargeStarted) / kChargeTime) or 0
end

local function TriggerSteamEffect(self, player)

    if self:GetIsLeftSlot() then
        player:TriggerEffects("railgun_steam_left")
    elseif self:GetIsRightSlot() then
        player:TriggerEffects("railgun_steam_right")
    end

end

local function Shoot(self, leftSide)

    local player = self:GetParent()

    -- We can get a shoot tag even when the clip is empty if the frame rate is low
    -- and the animation loops before we have time to change the state.
    if player then

        player:TriggerEffects("railgun_attack")

        local viewAngles = player:GetViewAngles()
        local shootCoords = viewAngles:GetCoords()

        local startPoint = player:GetEyePos()

        local spreadDirection = CalculateSpread(shootCoords, kRailgunSpread, NetworkRandom)

        local endPoint = startPoint + spreadDirection * kRailgunRange
        ExecuteShot(self, startPoint, endPoint, player)

        if Client then
            TriggerSteamEffect(self, player)
        end

        self:LockGun()
        self.lockCharging = false --true

    end

end

function Railgun:OnTag(tagName)

    PROFILE("Railgun:OnTag")

    if self:GetIsLeftSlot() then

        if tagName == "l_shoot" then
            Shoot(self, true)
        elseif tagName == "l_shoot_end" then
            self.lockCharging = false
        end

    elseif not self:GetIsLeftSlot() then

        if tagName == "r_shoot" then
            Shoot(self, false)
        elseif tagName == "r_shoot_end" then
            self.lockCharging = false
        end

    end

end

function Railgun:ProcessMoveOnWeapon(player, input)

    if self.railgunAttacking then

        if (Shared.GetTime() - self.timeChargeStarted) >= kChargeForceShootTime then
            self.railgunAttacking = false
        end

    end

end
