local kAttackDurationGore = Shared.GetAnimationLength("models/alien/onos/onos_view.model", "gore_attack")--"gore_attack")
local kAttackDurationSmash = Shared.GetAnimationLength("models/alien/onos/onos_view.model", "smash")

local kAttackRange = 3--1.7
local kFloorAttackRage = 0.9--0.9

local function PrioritizeEnemyPlayers(weapon, player, newTarget, oldTarget)
    return not oldTarget or (GetAreEnemies(player, newTarget) and newTarget:isa("Player") and not oldTarget:isa("Player") )
end

local function GetGoreAttackRange(viewCoords)
    return kAttackRange + math.max(0, -viewCoords.zAxis.y) * kFloorAttackRage
end

function Gore:GetMeleeBase()
    -- Width of box, height of box
    return 1, 1.4
end

-- checks in front of the onos in a radius for potential targets and returns the attack mode (randomized if no targets found)
local function GetAttackType(self, player)
    PROFILE("GetAttackType")

    local attackType = Gore.kAttackType.Gore
    local range = GetGoreAttackRange(player:GetViewCoords())
    local didHit, target, direction = CheckMeleeCapsule(self, player, 0, range, nil, nil, nil, PrioritizeEnemyPlayers)

    if didHit then

        if target and HasMixin(target, "Live") then

            if (target.GetReceivesStructuralDamage and target:GetReceivesStructuralDamage() ) and GetAreEnemies(player, target) then
                attackType = Gore.kAttackType.Smash
            end

        end

    end

    if Server then
        self.lastAttackType = attackType
    end

    return attackType

end

function Gore:GetAttackType()
    return self.attackType
end

function Gore:GetAttackAnimationDuration(attackType)
    if attackType == Gore.kAttackType.Smash then
        return kAttackDurationSmash
    else
        return kAttackDurationGore
    end
end

function Gore:Attack(player)

    local now = Shared.GetTime()
    local didHit = false
    local impactPoint = nil
    local target = nil
    local attackType = self.attackType

    if Server then
        attackType = self.lastAttackType
    end

    local range = GetGoreAttackRange(player:GetViewCoords())
    didHit, target, impactPoint = AttackMeleeCapsule(self, player, kGoreDamage, range)

    player:DeductAbilityEnergy(self:GetEnergyCost(player))

    self:DoAbilityFocusCooldown(player, self:GetAttackAnimationDuration(attackType))

    return didHit, impactPoint, target

end

function Gore:OnUpdateAnimationInput(modelMixin)
    local now = Shared.GetTime()
    local cooledDown = (not self.nextAttackTime) or (now >= self.nextAttackTime)
    if not self.nextAttackUpdate or now > self.nextAttackUpdate then
        if self.attackButtonPressed and cooledDown then
            if self.attackType == Gore.kAttackType.Gore then
                self.activityString = "primary"
                self.nextAttackUpdate = now + 0.1--doesn't do anything?
            elseif self.attackType == Gore.kAttackType.Smash then
                self.activityString = "smash"
                self.nextAttackUpdate = now + 0.1
            end
        else
            self.activityString = "none"
        end
    end

    modelMixin:SetAnimationInput("ability", "gore")
    modelMixin:SetAnimationInput("activity", self.activityString)

end


--[[
function Gore:OnUpdateAnimationInput(modelMixin)

    Player.OnUpdateAnimationInput(self, modelMixin)

    local attackSpeed = self:GetIsEnzymed() and kEnzymeAttackSpeed or kDefaultAttackSpeed * 0.7
    attackSpeed = attackSpeed * ( self.electrified and kElectrifiedAttackSpeed or 1 )
    if self.ModifyAttackSpeed then

        local attackSpeedTable = { attackSpeed = attackSpeed }
        self:ModifyAttackSpeed(attackSpeedTable)
        attackSpeed = self:ModifyAttackSpeed(attackSpeed)--attackSpeedTable.attackSpeed

    end

    modelMixin:SetAnimationInput("attack_speed", attackSpeed)

end]]
