local kRange = 1.9--1.42
--local kEnzymedRange = 2.1 --1.55

function BiteLeap:GetMeleeBase()
    -- Width of box, height of box
    return 1.5,0.375--1.2, 1.2
end

function BiteLeap:GetRange()
    return kRange
end

--TraceMeleeCapsule()
--[[
function BiteLeap:OnTag(tagName)

    PROFILE("BiteLeap:OnTag")

    if tagName == "hit" then

        local player = self:GetParent()

        if player then

            local range = (player.GetIsEnzymed and player:GetIsEnzymed()) and kEnzymedRange or kRange

            local didHit, target, endPoint = AttackMeleeCapsule(self, player, kBiteDamage, range, nil, false, EntityFilterOneAndIsa(player, "Babbler"))

            if Client and didHit then
                self:TriggerFirstPersonHitEffects(player, target)
            end

            if target and HasMixin(target, "Live") and not target:GetIsAlive() then
                self:TriggerEffects("bite_kill")
            elseif Server and target and target.TriggerEffects and GetReceivesStructuralDamage(target) and (not HasMixin(target, "Live") or target:GetCanTakeDamage()) then
                target:TriggerEffects("bite_structure", {effecthostcoords = Coords.GetTranslation(endPoint), isalien = GetIsAlienUnit(target)})
            end

            player:DeductAbilityEnergy(self:GetEnergyCost())
            self:TriggerEffects("bite_attack")

            self:DoAbilityFocusCooldown(player, kAttackDuration)

        end

    end

end
]]
