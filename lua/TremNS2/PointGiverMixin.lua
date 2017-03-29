if Server then

    function PointGiverMixin:PreOnKill(attacker, doer, point, direction)

        if self.isHallucination then
            return
        end

        local totalDamageDone = self:GetMaxHealth() + self:GetMaxArmor() * 2
        local resReward = self:isa("Player") and kPersonalResPerKill or 0
        --Limit reward to 4 frags equivalent:  if points are larger than 4 frags then only give 4 frags worth
        local points = math.min(self:GetPointValue(), kmaxfragValue)

        for attackerId, damageDone in pairs(self.damagePoints) do

            local currentAttacker = Shared.GetEntity(attackerId)
            if currentAttacker and HasMixin(currentAttacker, "Scoring") then

                local damageFraction = Clamp(damageDone / totalDamageDone, 0, 1)
                local scoreReward = points >= 1 and math.max(1, points * damageFraction) or 0

                currentAttacker:AddScore(math.round(scoreReward), resReward * damageFraction, attacker == currentAttacker)

--Conversion rate
                local fragValue = resReward * points / k1fragValue-- <= 4 or (kmaxfragValue / k1fragValue)
--give frag credits to the killer

                if currentAttacker:isa("Commander") then
                    fragValue = fragValue * 0.5
                end

                currentAttacker:AddResources(math.round(fragValue))

                if self:isa("Player") and currentAttacker ~= attacker then
                    currentAttacker:AddAssistKill()
                end

            end

        end
        --Don't forget to add kills to the scoreboard
        if self:isa("Player") and attacker and GetAreEnemies(self, attacker) then

            if attacker:isa("Player") or attacker:isa("Commander") then
                attacker:AddKill()
                attacker:GetTeam():AddTeamResources(kKillTeamReward)
            end

            --self:GetTeam():AddTeamResources(kKillTeamReward) --LOL UWEY did it backwards? Give resouces to the enemy!

        end

    end

end

--TODO: The distribution needs fixing


function PointGiverMixin:GetPointValue()

    if self.isHallucination then
        return 0
    end
    local lupgradediv = kPersonalResPerKill
    local numUpgrades = HasMixin(self, "Upgradable") and #self:GetUpgrades() or 0
    local techId = self:GetTechId()
    local points = LookupTechData(techId, kTechDataPointValue, 0) +
            math.floor(numUpgrades * LookupTechData(techId, kTechDataUpgradeCost, 0) / lupgradediv)

    for i = 0, self:GetNumChildren() - 1 do

        local child = self:GetChildAtIndex(i)
        if HasMixin(child, "PointGiver") then
            points = points + child:GetPointValue()
        end

    end

    -- give additional points for enemies which got alot of score in their current life
    -- but don't give more than twice the default point value
    --*cough cough* UWE means that has earnt a lot of score i.e. valuable killer bonus?
    if HasMixin(self, "Scoring") then

        local scoreGained = self:GetScoreGainedCurrentLife() or 0
        points = points + math.min(math.max(scoreGained * 0.001 - 5, 0), points)--math.min(points, scoreGained * 0.01--[[0.1]])

    end

    if self:isa("Hive") then
        points = points + math.min((self:GetBioMassLevel() - 1) * kBioMassUpgradePointValue, 0)
        if self:isa("ShiftHive") or self:isa("CragHive") or self:isa(" ShadeHive") then
            points = points + kUgradedHivePointValue
        end
    end

    return points

end
