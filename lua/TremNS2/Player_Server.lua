--[[
 * Called when the player is killed. Point and direction specify the world
 * space location and direction of the damage that killed the player. These
 * may be nil if the damage wasn't directional.
]]
function Player:OnKill(killer, doer, point, direction)

    local isSuicide = not doer and not killer -- xenocide is not a suicide
    local killedByDeathTrigger = doer and doer:isa("DeathTrigger") or killer and killer:isa("DeathTrigger")

    if not Shared.GetCheatsEnabled() and ( isSuicide or killedByDeathTrigger ) then
        self.spawnBlockTime = Shared.GetTime() + kSuicideDelay + kFadeToBlackTime
    end

    -- Determine the killer's player name.
    local killerName
    if killer then
        -- search for a player being/owning the killer
        local realKiller = killer
        while realKiller and not realKiller:isa("Player") and realKiller.GetOwner do
            realKiller = realKiller:GetOwner()
        end
        if realKiller and realKiller:isa("Player") then
            self.killedBy = killer:GetId()
            killerName = realKiller:GetName()
            Log("%s was killed by %s", self, self.killedBy)
        end
    end

    -- Save death to server log unless it's part of the concede sequence
    if not self.concedeSequenceActive then
        if isSuicide or killedByDeathTrigger then
            PrintToLog("%s committed suicide", self:GetName())
        elseif killerName ~= nil then
            PrintToLog("%s was killed by %s", self:GetName(), killerName)
        else
            PrintToLog("%s died", self:GetName())
        end
    end

    -- Go to third person so we can see ragdoll and avoid HUD effects (but keep short so it's personal)
    if not self:GetAnimateDeathCamera() then
        self:SetIsThirdPerson(4)
    end

    local angles = self:GetAngles()
    angles.roll = 0
    self:SetAngles(angles)

    -- This is a hack, CameraHolderMixin should be doing this.
    self.baseYaw = 0

    self:AddDeaths()

    -- Fade out screen.
    self.timeOfDeath = Shared.GetTime()

    DestroyViewModel(self)

    -- Save position of last death only if we didn't die to a DeathTrigger
    if not killedByDeathTrigger then
        self.lastDeathPos = self:GetOrigin()
    end

    self.lastClass = self:GetMapName()

end


--[[
 * Replaces the existing player with a new player of the specified map name.
 * Removes old player off its team and adds new player to newTeamNumber parameter
 * if specified. Note this destroys self, so it should be called carefully. Returns
 * the new player. If preserveWeapons is true, then InitWeapons() isn't called
 * and old ones are kept (including view model).
]]
function Player:Replace(mapName, newTeamNumber, preserveWeapons, atOrigin, extraValues)

    local team = self:GetTeam()
    if team == nil then
        return self
    end

    local teamNumber = team:GetTeamNumber()
    local client = Server.GetOwner(self)
    local teamChanged = newTeamNumber ~= nil and newTeamNumber ~= self:GetTeamNumber()

    -- Add new player to new team if specified
    -- Both nil and -1 are possible invalid team numbers.
    if newTeamNumber ~= nil and newTeamNumber ~= -1 then
        teamNumber = newTeamNumber
    end

    local player = CreateEntity(mapName, atOrigin or Vector(self:GetOrigin()), teamNumber, extraValues)

    -- Save last player map name so we can show player of appropriate form in the ready room if the game ends while spectating
    player.previousMapName = self:GetMapName()

    -- The class may need to adjust values before copying to the new player (such as gravity).
    self:PreCopyPlayerData()

    -- If the atOrigin is specified, set self to that origin before
    -- the copy happens or else it will be overridden inside player.
    if atOrigin then
        self:SetOrigin(atOrigin)
    end
    -- Copy over the relevant fields to the new player, before we delete it
    player:CopyPlayerDataFrom(self)

    -- Make model look where the player is looking
    player.standingBodyYaw = Math.Wrap( self:GetAngles().yaw, 0, 2*math.pi )

    if not player:GetTeam():GetSupportsOrders() and HasMixin(player, "Orders") then
        player:ClearOrders()
    end


	-- Grant some free grenades, if you died before using them
	--if player:isa("Marine") and not self:GetIsAlive() then
		--if player.grenadeType and player.grenadesLeft > 0 then
			--local nadeThrower = player:GiveItem(self.grenadeType, false)
			--nadeThrower.grenadesLeft = player.grenadesLeft
		--end
		--player.grenadesLeft = 0
		--player.grenadeType = nil
	--end

    -- Remove newly spawned weapons and reparent originals
    if preserveWeapons then

        player:DestroyWeapons()

        local allWeapons = { }
        local function AllWeapons(weapon) table.insert(allWeapons, weapon) end
        ForEachChildOfType(self, "Weapon", AllWeapons)

        for i, weapon in ipairs(allWeapons) do
            player:AddWeapon(weapon)
        end

    end

    -- Notify others of the change
    self:SendEntityChanged(player:GetId())

    -- This player is no longer controlled by a client.
    self.client = nil

    -- Remove any spectators currently spectating this player.
    self:RemoveSpectators(player)

    player:SetPlayerInfo(self.playerInfo)
    self.playerInfo = nil

    -- Only destroy the old player if it is not a ragdoll.
    -- Ragdolls will eventually destroy themselve.
    if not HasMixin(self, "Ragdoll") or not self:GetIsRagdoll() then
        DestroyEntity(self)
    end

    player:SetControllerClient(client)

    -- There are some cases where the spectating player isn't set to nil.
    -- Handle any edge cases here (like being dead when the game is reset).
    -- In some cases, client will be nil (when the map is changing for example).
    if client and not player:isa("Spectator") then
        client:SetSpectatingPlayer(nil)
    end

    -- Log player spawning
    if teamNumber ~= 0 then
        PostGameViz(string.format("%s spawned", SafeClassName(self)), self)
    end

    return player

end
