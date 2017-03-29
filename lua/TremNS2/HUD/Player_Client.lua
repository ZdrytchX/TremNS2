--CROSSHAIRS - Edited Duplicate of Player_Client.lua

--[[
 * Get the Y position of the crosshair image in the atlas.
 * Listed in this order:
 *   Rifle, Pistol, Axe, Shotgun, Minigun, Rifle with GL, Flamethrower
]]
function PlayerUI_GetCrosshairY()

    local player = Client.GetLocalPlayer()

    if(player and not player:GetIsThirdPerson()) then

        local weapon = player:GetActiveWeapon()
        if(weapon ~= nil) then

            -- Get class name and use to return index
            local index
            local mapname = weapon:GetMapName()

            if mapname == Rifle.kMapName or mapname == HeavyRifle.kMapName then
                index = 0
            elseif mapname == Pistol.kMapName or mapname == HeavyMachineGun.kMapName then
                index = 1
                --2 is blank by default, used for welder "painsaw"
            elseif mapname == Welder.kMapName then
                index = 2
            elseif mapname == Shotgun.kMapName or mapname == GrenadeLauncher.kMapName then
                index = 3
                --4 is bugged out by ns2 default
            elseif mapname == Minigun.kMapName then
                index = 4
            elseif mapname == Flamethrower.kMapName then
                index = 5
            -- All alien crosshairs are the same for now
            elseif mapname == LerkBite.kMapName or mapname == Spores.kMapName or mapname == LerkUmbra.kMapName or mapname == Parasite.kMapName or mapname == BileBomb.kMapName or mapname == StabBlink.kMapName then
                index = 6
            elseif mapname == SpitSpray.kMapName or mapname == BabblerAbility.kMapName or mapname == BiteLeap.kMapName or mapname == SwipeBlink.kMapName or mapname == Gore.kMapName then
                index = 7
            -- Blanks (with default damage indicator)
            else
                index = 8--circle thingy
            end

            return index * 64

        end

    end

end

function PlayerUI_GetCrosshairDamageIndicatorY()

    return 8 * 64

end

--[[
 * Returns the player name under the crosshair for display (return "" to not display anything).
]]
function PlayerUI_GetCrosshairText()

    local player = Client.GetLocalPlayer()
    if player then
        if player.GetCrossHairText then
            return player:GetCrossHairText()
        else
            return player.crossHairText
        end
    end
    return nil

end

function Player:GetDisplayUnitStates()
    return self:GetIsAlive()
end

function PlayerUI_GetProgressText()

    local player = Client.GetLocalPlayer()
    if player then
        return player.progressText
    end
    return nil

end

function PlayerUI_GetProgressFraction()

    local player = Client.GetLocalPlayer()
    if player then
        return player.progressFraction
    end
    return nil

end

local kEnemyObjectiveRange = 30
function PlayerUI_GetObjectiveInfo()

    local player = Client.GetLocalPlayer()

    if player then

        if player.crossHairHealth and player.crossHairText then

            player.showingObjective = true
            return player.crossHairHealth / 100, player.crossHairText .. " " .. ToString(player.crossHairHealth) .. "%", player.crossHairTeamType

        end

        -- check command structures in range (enemy or friend) and return health % and name
        local objectiveInfoEnts = EntityListToTable( Shared.GetEntitiesWithClassname("ObjectiveInfo") )
        local playersTeam = player:GetTeamNumber()

        local function SortByHealthAndTeam(ent1, ent2)
            return ent1:GetHealthScalar() < ent2:GetHealthScalar() and ent1.teamNumber == playersTeam
        end

        table.sort(objectiveInfoEnts, SortByHealthAndTeam)

        for _, objectiveInfoEnt in ipairs(objectiveInfoEnts) do

            if objectiveInfoEnt:GetIsInCombat() and ( playersTeam == objectiveInfoEnt:GetTeamNumber() or (player:GetOrigin() - objectiveInfoEnt:GetOrigin()):GetLength() < kEnemyObjectiveRange ) then

                local healthFraction = math.max(0.01, objectiveInfoEnt:GetHealthScalar())

                player.showingObjective = true

                local text = StringReformat(Locale.ResolveString("OBJECTIVE_PROGRESS"),
                                            { location = objectiveInfoEnt:GetLocationName(),
                                              name = GetDisplayNameForTechId(objectiveInfoEnt:GetTechId()),
                                              health = math.ceil(healthFraction * 100) })

                return healthFraction, text, objectiveInfoEnt:GetTeamType()

            end

        end

        player.showingObjective = false

    end

end

function PlayerUI_GetShowsObjective()

    local player = Client.GetLocalPlayer()
    if player then
        return player.showingObjective == true
    end

    return false

end

function PlayerUI_GetCrosshairHealth()

    local player = Client.GetLocalPlayer()
    if player then
        if player.GetCrossHairHealth then
            return player:GetCrossHairHealth()
        else
            return player.crossHairHealth
        end
    end
    return nil

end

function PlayerUI_GetCrosshairMaturity()

    local player = Client.GetLocalPlayer()
    if player then
        if player.GetCrossHairMaturity then
            return player:GetCrossHairMaturity()
        else
            return player.crossHairMaturity
        end
    end
    return nil

end

function PlayerUI_GetCrosshairBuildStatus()

    local player = Client.GetLocalPlayer()
    if player then
        if player.GetCrossHairBuildStatus then
            return player:GetCrossHairBuildStatus()
        else
            return player.crossHairBuildStatus
        end
    end
    return nil

end

-- Returns the int color to draw the results of PlayerUI_GetCrosshairText() in.
function PlayerUI_GetCrosshairTextColor()
    local player = Client.GetLocalPlayer()
    if player then
        return player.crossHairTextColor
    end
    return kFriendlyColor
end

--[[
 * Get the width of the crosshair image in the atlas, return 0 to hide
]]
function PlayerUI_GetCrosshairWidth()

    local player = Client.GetLocalPlayer()
    if player and player:GetActiveWeapon() and not player:GetIsThirdPerson() then
        return 64
    end

    return 0

end

--[[
 * Get the height of the crosshair image in the atlas, return 0 to hide
]]
function PlayerUI_GetCrosshairHeight()

    local player = Client.GetLocalPlayer()
    if player and player:GetActiveWeapon() and not player:GetIsThirdPerson() then
        return 64
    end

    return 0

end
