SwipeBlink.kRange = 2.5--1.6 80 units long

local kAttackDuration = 1.7 * Shared.GetAnimationLength("models/alien/fade/fade_view.model", "swipe_attack") --1.1 0.7 gpp 0.9, fade animation is 0.5s
function SwipeBlink:GetMeleeBase()
    -- Width of box, height of box
    return 0.35, 0.85 --.7, 1.1-gpp 27 units wide gpp value 12 units wide

end

function SwipeBlink:OnTag(tagName)

    PROFILE("SwipeBlink:OnTag")

    if tagName == "hit" then

        local stabWep = self:GetParent():GetWeapon(StabBlink.kMapName)
        if stabWep and stabWep.stabbing then
            -- player is using stab and has switched to swipe really fast, but the attack the "hit"
            -- tag is from is still a stab, and thus should do stab damage.
            stabWep:DoAttack()
        else
            self:TriggerEffects("swipe_attack")
            self:PerformMeleeAttack()

            local player = self:GetParent()
            if player then

                player:DeductAbilityEnergy(self:GetEnergyCost())
                self:DoAbilityFocusCooldown(player, kAttackDuration)

            end
        end

    end

end
