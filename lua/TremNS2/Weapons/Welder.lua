local kWeldRange = 1.25--1.875--2.4

function Welder:GetRange()
    return kWeldRange
end

function Welder:GetMeleeBase()
    return 0.1, 0.5
end

function Welder:GetHUDSlot()
    return kWelderHUDSlot--kPrimaryWeaponSlot--
end

function Welder:GetReplacementWeaponMapName()
    return Axe.kMapName
end

function Welder:PerformWeld(player)

    local attackDirection = player:GetViewCoords().zAxis
    local success = false
    -- prioritize friendlies
    local didHit, target, endPoint, direction, surface = CheckMeleeCapsule(self, player, 0, self:GetRange(), nil, true, 1, PrioritizeDamagedFriends, nil, PhysicsMask.Flame)

    if didHit and target and HasMixin(target, "Live") then

        if GetAreEnemies(player, target) then
            self:DoDamage(kWelderDamagePerSecond * kWelderFireDelay, target, endPoint, attackDirection)
            success = true
        elseif player:GetTeamNumber() == target:GetTeamNumber() and HasMixin(target, "Weldable") then

            if target:GetHealthScalar() < 1 then

                local prevHealthScalar = target:GetHealthScalar()
                local prevHealth = target:GetHealth()
                local prevArmor = target:GetArmor()
                target:OnWeld(self, kWelderFireDelay, player)
                success = prevHealthScalar ~= target:GetHealthScalar()

                if success then

                    local addAmount = (target:GetHealth() - prevHealth) + (target:GetArmor() - prevArmor)
                    player:AddContinuousScore("WeldHealth", addAmount, Welder.kAmountHealedForPoints, Welder.kHealScoreAdded)

                    -- weld owner as well
                    player:AddHealth(kWelderFireDelay * kSelfHealWeldAmount, false, false)
                    player:SetArmor(player:GetArmor() + kWelderFireDelay * kSelfWeldAmount)

                end

            end

            if HasMixin(target, "Construct") and target:GetCanConstruct(player) then
                target:Construct(kWelderFireDelay, player)
            end

        end

    end

    if success then
        return endPoint
    end

end
