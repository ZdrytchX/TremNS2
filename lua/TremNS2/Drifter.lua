--BuildUtility_SetDebug("all")

Drifter.kEnzymeRange = 30--22

local kDrifterSelfOrderRange = 30--12

local kDrifterConstructSound = PrecacheAsset("sound/NS2.fev/alien/drifter/drift")
local kDrifterMorphing = PrecacheAsset("sound/NS2.fev/alien/commander/drop_structure")

local kDetectInterval = 0.5
local kDetectRange = 1.5
---copy paste from originals onwards

local function IsBeingGrown(self, target)

    if target.hasDrifterEnzyme then
        return true
    end

    for _, drifter in ipairs(GetEntitiesForTeam("Drifter", target:GetTeamNumber())) do

        if self ~= drifter then

            local order = drifter:GetCurrentOrder()
            if order and order:GetType() == kTechId.Grow then

                local growTarget = Shared.GetEntity(order:GetParam())
                if growTarget == target then
                    return true
                end

            end

        end

    end

    return false

end

local function FindTask(self)

    -- find ungrown structures
    for _, structure in ipairs(GetEntitiesWithMixinForTeamWithinRange("Construct", self:GetTeamNumber(), self:GetOrigin(), kDrifterSelfOrderRange)) do

        if not structure:GetIsBuilt() and not IsBeingGrown(self, structure) and (not structure.GetCanAutoBuild or structure:GetCanAutoBuild()) then

            self:GiveOrder(kTechId.Grow, structure:GetId(), structure:GetOrigin(), nil, false, false)
            return

        end

    end

end

local function UpdateTasks(self, deltaTime)

    if not self:GetIsAlive() then
        return
    end

    local currentOrder = self:GetCurrentOrder()
    if currentOrder ~= nil then

        local maxSpeedTable = { maxSpeed = Drifter.kMoveSpeed }
        self:ModifyMaxSpeed(maxSpeedTable)
        local drifterMoveSpeed = maxSpeedTable.maxSpeed

        local currentOrigin = Vector(self:GetOrigin())

        if currentOrder:GetType() == kTechId.Move or currentOrder:GetType() == kTechId.Patrol then
            self:ProcessMoveOrder(drifterMoveSpeed, deltaTime)
        elseif currentOrder:GetType() == kTechId.Follow then
            self:ProcessFollowOrder(drifterMoveSpeed, deltaTime)
        elseif currentOrder:GetType() == kTechId.EnzymeCloud or currentOrder:GetType() == kTechId.Hallucinate or currentOrder:GetType() == kTechId.MucousMembrane or currentOrder:GetType() == kTechId.Storm then
            self:ProcessEnzymeOrder(drifterMoveSpeed, deltaTime)
        elseif currentOrder:GetType() == kTechId.Grow then
            self:ProcessGrowOrder(drifterMoveSpeed, deltaTime)
        end

        -- Check difference in location to set moveSpeed
        local distanceMoved = (self:GetOrigin() - currentOrigin):GetLength()

        self.moveSpeed = (distanceMoved / drifterMoveSpeed) / deltaTime

    else

        if not self.timeLastTaskCheck or self.timeLastTaskCheck + 2 < Shared.GetTime() then

            FindTask(self)
            self.timeLastTaskCheck = Shared.GetTime()

        end

    end

end

local function ScanForNearbyEnemy(self)

    -- Check for nearby enemy units. Uncloak if we find any.
    self.lastDetectedTime = self.lastDetectedTime or 0
    if self.lastDetectedTime + kDetectInterval < Shared.GetTime() then

        if #GetEntitiesForTeamWithinRange("Player", GetEnemyTeamNumber(self:GetTeamNumber()), self:GetOrigin(), kDetectRange) > 0 then

            self:TriggerUncloak()

        end
        self.lastDetectedTime = Shared.GetTime()

    end

end

function Drifter:OnUpdate(deltaTime)

    ScriptActor.OnUpdate(self, deltaTime)

    -- Blend smoothly towards target value
    self.moveSpeedParam = Clamp(Slerp(self.moveSpeedParam, self.moveSpeed, deltaTime), 0, 1)
    --UpdateMoveYaw(self, deltaTime)

    if Server then

        self.constructing = false
        UpdateTasks(self, deltaTime)

        ScanForNearbyEnemy(self)

        self.camouflaged = (not self:GetHasOrder() or self:GetCurrentOrder():GetType() == kTechId.HoldPosition ) and not self:GetIsInCombat()

        self.hasCamouflage = GetHasTech(self, kTechId.ShadeHive) == true
--[[
        self.hasCelerity = GetHasTech(self, kTechId.ShiftHive) == true
--]]
        self.hasRegeneration = GetHasTech(self, kTechId.CragHive) == true

        if self.hasRegeneration then

            if self:GetIsHealable() and ( not self.timeLastAlienAutoHeal or self.timeLastAlienAutoHeal + kAlienRegenerationTime <= Shared.GetTime() ) then

                self:AddHealth(0.06 * self:GetMaxHealth())
                self.timeLastAlienAutoHeal = Shared.GetTime()

            end

        end

        self.canUseAbilities = self.timeAbilityUsed + kDrifterAbilityCooldown < Shared.GetTime()

    elseif Client then

        self.trailCinematic:SetIsVisible(self:GetIsMoving() and self:GetIsVisible())

        if self.constructing and not self.playingConstructSound then

            Shared.PlaySound(self, kDrifterConstructSound)
            self.playingConstructSound = true

        elseif not self.constructing and self.playingConstructSound then

            Shared.StopSound(self, kDrifterConstructSound)
            self.playingConstructSound = false

        end

    end

end
