
---------here new function
function Team:EjectAliveBotCommanders()
    local commandStructures = GetEntitiesForTeam("CommandStructure", self:GetTeamNumber())
    local numAlive = 0
    for c = 1, #commandStructures do
        numAlive = commandStructures[c]:GetIsAlive() and (numAlive + 1) or numAlive
    end
    if numAlive == 0 then
      GetGamerules():LogoutCommanders()
    end
    --player:GetIsAlive()
end
