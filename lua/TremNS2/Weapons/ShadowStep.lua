-- TODO
-- based off lua\Weapons\Alien\Metabolize.lua

Script.Load("lua/Weapons/Alien/Ability.lua")
Script.Load("lua/Weapons/Alien/Blink.lua")

class 'ShadowStep' (Blink)

ShadowStep.kMapName = "ShadowStep"

local networkVars =
{
    lastPrimaryAttackTime = "time"
}

kMetabolizeDelay = 2.0
local kMetabolizeEnergyRegain = 35
local kMetabolizeHealthRegain = 15

local kAnimationGraph = PrecacheAsset("models/alien/fade/fade_view.animation_graph")

function ShadowStep:OnCreate()

    Blink.OnCreate(self)

    self.primaryAttacking = false
    self.lastPrimaryAttackTime = 0
end

function ShadowStep:GetAnimationGraphName()
    return kAnimationGraph
end

function ShadowStep:GetEnergyCost(player)
    return kMetabolizeEnergyCost
end

function ShadowStep:GetHUDSlot()
    return 2
end

function ShadowStep:GetDeathIconIndex()
    return kDeathMessageIcon.Metabolize
end

function ShadowStep:GetBlinkAllowed()
    return true
end

function ShadowStep:GetAttackDelay()
    return kMetabolizeDelay
end

function ShadowStep:GetLastAttackTime()
    return self.lastPrimaryAttackTime
end

function ShadowStep:GetSecondaryTechId()
    return kTechId.Blink
end

function ShadowStep:GetHasAttackDelay()
	local parent = self:GetParent()
    return self.lastPrimaryAttackTime + kMetabolizeDelay > Shared.GetTime() or parent and parent:GetIsStabbing()
end

function ShadowStep:OnPrimaryAttack(player)

    if player:GetEnergy() >= self:GetEnergyCost() and not self:GetHasAttackDelay() then
        self.primaryAttacking = true
        player.timeMetabolize = Shared.GetTime()
    else
        self:OnPrimaryAttackEnd()
    end

end

function ShadowStep:OnPrimaryAttackEnd()

    Blink.OnPrimaryAttackEnd(self)
    self.primaryAttacking = false

end

function ShadowStep:OnHolster(player)

    Blink.OnHolster(self, player)
    self.primaryAttacking = false

end

function ShadowStep:OnTag(tagName)

    PROFILE("ShadowStep:OnTag")

    if tagName == "metabolize" and not self:GetHasAttackDelay() then
        local player = self:GetParent()
        if player then
            player:DeductAbilityEnergy(kMetabolizeEnergyCost)
            player:TriggerEffects("metabolize")
            if player:GetCanMetabolizeHealth() then
                local totalHealed = player:AddHealth(kMetabolizeHealthRegain, false, false)
				if Client and totalHealed > 0 then
					local GUIRegenerationFeedback = ClientUI.GetScript("GUIRegenerationFeedback")
					GUIRegenerationFeedback:TriggerRegenEffect()
					local cinematic = Client.CreateCinematic(RenderScene.Zone_ViewModel)
					cinematic:SetCinematic(kRegenerationViewCinematic)
				end
            end
            player:AddEnergy(kMetabolizeEnergyRegain)
            self.lastPrimaryAttackTime = Shared.GetTime()
            self.primaryAttacking = false
        end
    elseif tagName == "metabolize_end" then
        local player = self:GetParent()
        if player then
            self.primaryAttacking = false
        end
    end

    if tagName == "hit" then

        local stabWep = self:GetParent():GetWeapon(StabBlink.kMapName)
        if stabWep and stabWep.stabbing then
            stabWep:DoAttack()
        end
    end

end

function ShadowStep:OnUpdateAnimationInput(modelMixin)

    PROFILE("ShadowStep:OnUpdateAnimationInput")

    Blink.OnUpdateAnimationInput(self, modelMixin)

    modelMixin:SetAnimationInput("ability", "vortex")

    local player = self:GetParent()
    local activityString = (self.primaryAttacking and "primary") or "none"
    if player and player:GetHasMetabolizeAnimationDelay() then
        activityString = "primary"
    end

    modelMixin:SetAnimationInput("activity", activityString)

end

Shared.LinkClassToMap("Metabolize", Metabolize.kMapName, networkVars)
