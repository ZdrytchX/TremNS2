local function OnDeploy(self)

    self.deployed = true
    return false

end

local kDeployTime = 3

function Armory:ResupplyPlayer(player)

    local resuppliedPlayer = false

    -- Heal player first
    if (player:GetHealth() < player:GetMaxHealth()) then

        -- third param true = ignore armor but doesn't work
        player:AddHealth(Armory.kHealAmount, false, true)
        player:SetArmor(player:GetArmor() + Armory.kHealArmour)

        self:TriggerEffects("armory_health", {effecthostcoords = Coords.GetTranslation(player:GetOrigin())})

        resuppliedPlayer = true
        --[[
        if HasMixin(player, "ParasiteAble") and player:GetIsParasited() then

            player:RemoveParasite()

        end
        --]]

        if player:isa("Marine") and player.poisoned then

            player.poisoned = false

        end

    end

    -- Give ammo to all their weapons, one clip at a time, starting from primary
    local weapons = player:GetHUDOrderedWeaponList()

    for index, weapon in ipairs(weapons) do

        if weapon:isa("ClipWeapon") then

            if weapon:GiveAmmo(1, false) then

                self:TriggerEffects("armory_ammo", {effecthostcoords = Coords.GetTranslation(player:GetOrigin())})

                resuppliedPlayer = true

                break

            end

        end

    end

    if resuppliedPlayer then

        -- Insert/update entry in table
        self.resuppliedPlayers[player:GetId()] = Shared.GetTime()

        -- Play effect
        --self:PlayArmoryScan(player:GetId())

    end

end
