local function OnCommandDebugSpeed()

    if gSpeedDebug then --reversed 'not' so it is on by default
        gSpeedDebug = GetGUIManager():CreateGUIScriptSingle("GUISpeedDebug")
    else

        GetGUIManager():DestroyGUIScriptSingle("GUISpeedDebug")
        gSpeedDebug = nil

    end

end

kSayTeamDelay = 1--3
function OnCommandSayTeam(...)

    if not timeLastSayTeam or timeLastSayTeam + kSayTeamDelay < Shared.GetTime() then

        local chatMessage = StringConcatArgs(...)
        chatMessage = string.UTF8Sub(chatMessage, 1, kMaxChatLength)

        if string.len(chatMessage) > 0 then

            local player = Client.GetLocalPlayer()
            local playerName = player:GetName()
            local playerLocationId = player.locationId
            local playerTeamNumber = player:GetTeamNumber()
            local playerTeamType = player:GetTeamType()

            Client.SendNetworkMessage("ChatClient", BuildChatMessage(true, playerName, playerLocationId, playerTeamNumber, playerTeamType, chatMessage), true)
        end

        timeLastSayTeam = Shared.GetTime()
    else
        Print("Please don't spam the team chat! Your message has been filtered out. Please wait 5 seconds before trying again.")
        timeLastSayTeam = Shared.GetTime() + 3
    end
end

Event.Hook("Console_tsay", OnCommandSayTeam)
Event.Hook("Console_debugspeed", OnCommandDebugSpeed)
