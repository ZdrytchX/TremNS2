local kBombVelocity = 11

local kBbombViewEffect = PrecacheAsset("cinematics/alien/gorge/bbomb_1p.cinematic")

local networkVars =
{
    firingPrimary = "boolean"
}

AddMixinNetworkVars(HealSprayMixin, networkVars)

local function CreateBombProjectile( self, player )

    if not Predict then


        local viewAngles = player:GetViewAngles()
        local viewCoords = viewAngles:GetCoords()
        local startPoint = player:GetEyePos() + viewCoords.zAxis * 1.5

        local startPointTrace = Shared.TraceRay(player:GetEyePos(), startPoint, CollisionRep.Damage, PhysicsMask.Bullets, EntityFilterOneAndIsa(player, "Babbler"))
        startPoint = startPointTrace.endPoint

        local startVelocity = viewCoords.zAxis * kBombVelocity

        local bomb = player:CreatePredictedProjectile( "Bomb", startPoint, startVelocity, 0, 0, nil )

    end

end

function BileBomb:OnTag(tagName)

    PROFILE("BileBomb:OnTag")

    if self.firingPrimary and tagName == "shoot" then

        local player = self:GetParent()
        local lBilePResRequired = 50

        if player and player.resources > lBilePResRequired then

            if Server or (Client and Client.GetIsControllingPlayer()) then
                CreateBombProjectile(self, player)
            end

            player.resources = player.resources - lBilePResRequired

            player:DeductAbilityEnergy(self:GetEnergyCost())
            self.timeLastBileBomb = Shared.GetTime()

            self:TriggerEffects("bilebomb_attack")

            if Client then

                local cinematic = Client.CreateCinematic(RenderScene.Zone_ViewModel)
                cinematic:SetCinematic(kBbombViewEffect)

            end

        end

    end

end

function BileBomb:OnPrimaryAttack(player)

    if player:GetEnergy() >= self:GetEnergyCost() then

        self.firingPrimary = true

    else
        self.firingPrimary = false
    end

end

function BileBomb:OnPrimaryAttackEnd(player)

    Ability.OnPrimaryAttackEnd(self, player)

    self.firingPrimary = false

end

function BileBomb:GetTimeLastBomb()
    return self.timeLastBileBomb
end

function BileBomb:OnUpdateAnimationInput(modelMixin)

    PROFILE("BileBomb:OnUpdateAnimationInput")

    modelMixin:SetAnimationInput("ability", "bomb")

    local activityString = "none"
    if self.firingPrimary then
        activityString = "primary"
    end
    modelMixin:SetAnimationInput("activity", activityString)

end
