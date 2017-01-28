local kRange = 40--1.9

local kAttackDuration = Shared.GetAnimationLength("models/alien/fade/fade_view.model", "stab")
StabBlink.cooldownInfluence = 0.5 -- 0 = no focus cooldown, 1 = same as kAttackDuration

function StabBlink:GetMeleeBase()
    -- Width of box, height of box
    return 1, 1--0.2, 0.2--.7, 1.2
end

function StabBlink:DoAttack()
    self:TriggerEffects("stab_hit")
    self.stabbing = false

    local player = self:GetParent()
    if player then

        AttackMeleeCapsule(self, player, kStabDamage, kRange, nil, false, EntityFilterOneAndIsa(player, "Babbler"))

        self:DoAbilityFocusCooldown(player, kAttackDuration * StabBlink.cooldownInfluence)
    end
end
