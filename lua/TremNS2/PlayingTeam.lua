local relevantResearchIds = nil
local function GetIsResearchRelevant(techId)

    if not relevantResearchIds then

        relevantResearchIds = {}
        relevantResearchIds[kTechId.GrenadeLauncherTech] = 2
        relevantResearchIds[kTechId.AdvancedWeaponry] = 2
        relevantResearchIds[kTechId.FlamethrowerTech] = 2
        relevantResearchIds[kTechId.WelderTech] = 2
        relevantResearchIds[kTechId.GrenadeTech] = 2
        relevantResearchIds[kTechId.MinesTech] = 2
        relevantResearchIds[kTechId.ShotgunTech] = 2
        relevantResearchIds[kTechId.HeavyMachineGunTech] = 2
        relevantResearchIds[kTechId.ExosuitTech] = 3
        relevantResearchIds[kTechId.JetpackTech] = 3
        relevantResearchIds[kTechId.DualMinigunTech] = 3
        relevantResearchIds[kTechId.ClawRailgunTech] = 3
        relevantResearchIds[kTechId.DualRailgunTech] = 3

        relevantResearchIds[kTechId.DetonationTimeTech] = 2
        relevantResearchIds[kTechId.FlamethrowerRangeTech] = 2

        relevantResearchIds[kTechId.Armor1] = 1
        relevantResearchIds[kTechId.Armor2] = 1
        relevantResearchIds[kTechId.Armor3] = 1

        relevantResearchIds[kTechId.Weapons1] = 1
        relevantResearchIds[kTechId.Weapons2] = 1
        relevantResearchIds[kTechId.Weapons3] = 1

        relevantResearchIds[kTechId.UpgradeSkulk] = 1
        relevantResearchIds[kTechId.UpgradeGorge] = 1
        relevantResearchIds[kTechId.UpgradeLerk] = 1
        relevantResearchIds[kTechId.UpgradeFade] = 1
        relevantResearchIds[kTechId.UpgradeOnos] = 1

        relevantResearchIds[kTechId.GorgeTunnelTech] = 1

        relevantResearchIds[kTechId.Leap] = 1
        relevantResearchIds[kTechId.BileBomb] = 1
        relevantResearchIds[kTechId.Spores] = 1
        relevantResearchIds[kTechId.Stab] = 1
        relevantResearchIds[kTechId.Stomp] = 1

        relevantResearchIds[kTechId.Xenocide] = 1
        relevantResearchIds[kTechId.Umbra] = 1
        relevantResearchIds[kTechId.Vortex] = 1
        relevantResearchIds[kTechId.BoneShield] = 1
        relevantResearchIds[kTechId.WebTech] = 1
        relevantResearchIds[kTechId.ShadowStep] = 1

    end

    return relevantResearchIds[techId]

end

--victory/win conditions
function PlayingTeam:GetHasTeamLost()

    PROFILE("PlayingTeam:GetHasTeamLost")

    if GetGamerules():GetGameStarted() and not Shared.GetCheatsEnabled() then

        -- Team can't respawn or last Command Station or Hive destroyed
        local activePlayers = self:GetHasActivePlayers()
        local abilityToRespawn = self:GetHasAbilityToRespawn()
        local numAliveCommandStructures = self:GetNumAliveCommandStructures()

        if numAliveCommandStructures == 0 then
        --Bots don't log out at final destruction BUG
            local teamInfo = GetTeamInfoEntity(self:GetTeamNumber())

            if teamInfo:GetLastCommIsBot() then
                for i = 1,2 do
                    local bot = gServerBots[i]
                    if bot and bot:GetPlayer():GetTeamNumber() == self:GetTeamNumber() then
                        bot:Disconnect()
                    end
                end
            end
        end

        --local numAliveCommandStructures = self:GetNumAliveCommandStructures()
        --if (numAliveCommandStructures == 0) then
      --    GetGamerules():LogoutCommanders()
        --end
--        -- logout commanders in Concede Sequence
--        GetGamerules():LogoutCommanders()

        --test for Have We Lost?
        if  (not activePlayers and not abilityToRespawn) or
            --(numAliveCommandStructures == 0) or --Allow the game to continue without a hive/CC
            (self:GetNumPlayers() == 0) or
            self:GetHasConceded() then

            return true

        end

    end

    return false

end
