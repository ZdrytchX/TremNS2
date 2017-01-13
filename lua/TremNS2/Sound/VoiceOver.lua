LEFT_MENU = 1
RIGHT_MENU = 2
kMaxRequestsPerSide = 6

--buy medpack stuff, Nin's patch for SiegeSimple
local healthCost = 50
local medpackHealthSound = PrecacheAsset("sound/NS2.fev/marine/common/health")
local medpackHealthRequest = PrecacheAsset("sound/NS2.fev/marine/voiceovers/medpack")

local function BuyMedpack(player)
    if player then   --duplicated the 'if' for the fuckery spark engine error check
      if kTechId.MedPack and player:GetIsAlive() and not player.timeLastMedpack or player.timeLastMedpack + kMedpackPickupDelay <= Shared.GetTime() then

      --Marine
          if  player:isa("Marine") and player:GetHealth() < player:GetMaxHealth() or player:GetArmor() < player:GetMaxArmor() then
              if player.resources > healthCost then

                player.resources = player.resources - healthCost
                player:AddHealth(kMedpackHeal, false, true)
                player:SetArmor(player:GetMaxArmor()) --kMedpackArmour is used for commander stuff
                player:AddRegeneration()
                player.timeLastMedpack = Shared.GetTime()
                StartSoundEffectAtOrigin(medpackHealthSound, player:GetOrigin())
              else
                StartSoundEffectOnEntity(medpackHealthRequest, player)
              end

        --Exosuits
      elseif player:isa("Exo") and player:GetArmor() < player:GetMaxArmor() then
              if player.resources > healthCost then
                player:SetArmor(player:GetArmor() + kMedpackExo)
                player.timeLastMedpack = Shared.GetTime() - (kMedpackPickupDelay / 2) --Shroten their regeneration limit because exos heal slowly
                StartSoundEffectAtOrigin(medpackHealthSound, player:GetOrigin())
              else
                StartSoundEffectOnEntity(medpackHealthRequest, player)
              end
          end
      end --medpack/alive check
    end

end

local function VoteEjectCommander(player)

    if player then
        GetGamerules():CastVoteByPlayer(kTechId.VoteDownCommander1, player)
    end

end

local function VoteConcedeRound(player)

    if player then
        GetGamerules():CastVoteByPlayer(kTechId.VoteConcedeRound, player)
    end

end

local function GetLifeFormSound(player)

    if player and (player:isa("Alien") or player:isa("ReadyRoomEmbryo")) then
        return kAlienTauntSounds[player:GetTechId()] or ""
    end

    return ""

end

local function PingInViewDirection(player)

    if player and (not player.lastTimePinged or player.lastTimePinged + 60 < Shared.GetTime()) then

        local startPoint = player:GetEyePos()
        local endPoint = startPoint + player:GetViewCoords().zAxis * 40
        local trace = Shared.TraceRay(startPoint, endPoint,  CollisionRep.Default, PhysicsMask.Bullets, EntityFilterOne(player))

        -- seems due to changes to team mixin you can be assigned to a team which does not implement SetCommanderPing
        local team = player:GetTeam()
        if team and team.SetCommanderPing then
            player:GetTeam():SetCommanderPing(trace.endPoint)
        end

        player.lastTimePinged = Shared.GetTime()

    end

end

local function GiveWeldOrder(player)

    if ( player:isa("Marine") or player:isa("Exo") ) and player:GetArmor() < player:GetMaxArmor() then

        for _, marine in ipairs(GetEntitiesForTeamWithinRange("Marine", player:GetTeamNumber(), player:GetOrigin(), 8)) do

            if player ~= marine and marine:GetWeapon(Welder.kMapName) then
                marine:GiveOrder(kTechId.AutoWeld, player:GetId(), player:GetOrigin(), nil, true, false)
            end

        end

    end

end

local kSoundData =
{

    -- always part of the menu
    [kVoiceId.VoteEject] = { Function = VoteEjectCommander },
    [kVoiceId.VoteConcede] = { Function = VoteConcedeRound },

    [kVoiceId.Ping] = { Function = PingInViewDirection, Description = "REQUEST_PING", KeyBind = "PingLocation" },

    -- marine vote menu
    [kVoiceId.RequestWeld] = { Sound = "sound/NS2.fev/marine/voiceovers/weld", Function = GiveWeldOrder, Description = "REQUEST_MARINE_WELD", KeyBind = "RequestWeld", AlertTechId = kTechId.None },
    [kVoiceId.MarineRequestMedpack] = {Function = BuyMedpack, Description = "Buy Medpack", KeyBind = "RequestHealth", AlertTechId = kTechId.MarineAlertNeedMedpack },
    --[kVoiceId.MarineRequestMedpack] = { Sound = "sound/NS2.fev/marine/voiceovers/medpack", Description = "REQUEST_MARINE_MEDPACK", KeyBind = "RequestHealth", AlertTechId = kTechId.MarineAlertNeedMedpack },
    [kVoiceId.MarineRequestAmmo] = { Sound = "sound/NS2.fev/marine/voiceovers/ammo", Description = "REQUEST_MARINE_AMMO", KeyBind = "RequestAmmo", AlertTechId = kTechId.MarineAlertNeedAmmo },
    [kVoiceId.MarineRequestOrder] = { Sound = "sound/NS2.fev/marine/voiceovers/need_orders", Description = "REQUEST_MARINE_ORDER",  KeyBind = "RequestOrder", AlertTechId = kTechId.MarineAlertNeedOrder },

--Apparently ns2 doesn't like raw files, they need to be packed properly to fade out with distance
    [kVoiceId.MarineTaunt] = { Sound = --[["sound/human/taunt.wav"]]"sound/NS2.fev/marine/voiceovers/taunt", Description = "REQUEST_MARINE_TAUNT", KeyBind = "Taunt", AlertTechId = kTechId.None },
    [kVoiceId.MarineTauntExclusive] = { Sound = "sound/NS2.fev/marine/voiceovers/taunt_exclusive", Description = "REQUEST_MARINE_TAUNT", KeyBind = "Taunt", AlertTechId = kTechId.None },
    [kVoiceId.MarineCovering] = { Sound = "sound/NS2.fev/marine/voiceovers/covering", Description = "REQUEST_MARINE_COVERING", KeyBind = "VoiceOverCovering", AlertTechId = kTechId.None },
    [kVoiceId.MarineFollowMe] = { Sound = "sound/NS2.fev/marine/voiceovers/follow_me", Description = "REQUEST_MARINE_FOLLOWME", KeyBind = "VoiceOverFollowMe", AlertTechId = kTechId.None },
    [kVoiceId.MarineHostiles] = { Sound = "sound/NS2.fev/marine/voiceovers/hostiles", Description = "REQUEST_MARINE_HOSTILES", KeyBind = "VoiceOverHostiles", AlertTechId = kTechId.None },
    [kVoiceId.MarineLetsMove] = { Sound = "sound/NS2.fev/marine/voiceovers/lets_move", Description = "REQUEST_MARINE_LETSMOVE", KeyBind = "VoiceOverFollowMe", AlertTechId = kTechId.None },
    [kVoiceId.MarineAcknowledged] = { Sound = "sound/NS2.fev/marine/voiceovers/ack", Description = "REQUEST_MARINE_ACKNOWLEDGED", KeyBind = "VoiceOverAcknowledged", AlertTechId = kTechId.None },

    -- alien vote menu
    [kVoiceId.AlienRequestHarvester] = { Sound = "sound/NS2.fev/alien/voiceovers/follow_me", Description = "REQUEST_ALIEN_HARVESTER", KeyBind = "RequestOrder", AlertTechId = kTechId.AlienAlertNeedHarvester },
    [kVoiceId.AlienRequestMist] = { Sound = "sound/NS2.fev/alien/common/hatch", Description = "REQUEST_ALIEN_MIST", KeyBind = "RequestHealth", AlertTechId = kTechId.AlienAlertNeedMist },
    [kVoiceId.AlienRequestDrifter] = { Sound = "sound/NS2.fev/alien/voiceovers/follow_me", Description = "REQUEST_ALIEN_DRIFTER", KeyBind = "RequestAmmo", AlertTechId = kTechId.AlienAlertNeedDrifter },
    [kVoiceId.AlienRequestHealing] = { Sound = "sound/NS2.fev/alien/voiceovers/need_healing", Description = "REQUEST_ALIEN_HEAL", KeyBind = "RequestHealth", AlertTechId = kTechId.None },
    [kVoiceId.AlienTaunt] = { Sound = "", Function = GetLifeFormSound, Description = "REQUEST_ALIEN_TAUNT", KeyBind = "Taunt", AlertTechId = kTechId.None },
    [kVoiceId.AlienFollowMe] = { Sound = "sound/NS2.fev/alien/voiceovers/follow_me", Description = "REQUEST_ALIEN_FOLLOWME", AlertTechId = kTechId.None },
    [kVoiceId.AlienChuckle] = { Sound = "sound/NS2.fev/alien/voiceovers/chuckle", Description = "REQUEST_ALIEN_CHUCKLE", KeyBind = "VoiceOverAcknowledged", AlertTechId = kTechId.None },
    [kVoiceId.EmbryoChuckle] = { Sound = "sound/NS2.fev/alien/structures/death_large", Description = "REQUEST_ALIEN_CHUCKLE", KeyBind = "VoiceOverAcknowledged", AlertTechId = kTechId.None },

}

-- Initialize the female variants of the voice overs and precache.
for _, soundData in pairs(kSoundData) do

    if soundData.Sound ~= nil and string.len(soundData.Sound) > 0 then

        PrecacheAsset(soundData.Sound)

        -- Do not look for female versions of alien sounds.
        if string.find(soundData.Sound, "sound/NS2.fev/alien/", 1) == nil then

            soundData.SoundFemale = soundData.Sound .. "_female"
            PrecacheAsset(soundData.SoundFemale)

        end

    end

end

function GetVoiceSoundData(voiceId)
    return kSoundData[voiceId]
end

local kMarineMenu =
{
    [LEFT_MENU] = { kVoiceId.RequestWeld, kVoiceId.MarineRequestMedpack, kVoiceId.MarineRequestAmmo, kVoiceId.MarineRequestOrder, kVoiceId.Ping },
    [RIGHT_MENU] = { kVoiceId.MarineTaunt, kVoiceId.MarineCovering, kVoiceId.MarineFollowMe, kVoiceId.MarineHostiles, kVoiceId.MarineAcknowledged}
}

local kExoMenu =
 {
    [LEFT_MENU] = { kVoiceId.RequestWeld, kVoiceId.MarineRequestOrder, kVoiceId.Ping },
    [RIGHT_MENU] = { kVoiceId.MarineTaunt, kVoiceId.MarineCovering, kVoiceId.MarineFollowMe, kVoiceId.MarineHostiles, kVoiceId.MarineAcknowledged }
}

local kAlienMenu =
{
    [LEFT_MENU] = { kVoiceId.AlienRequestHealing, kVoiceId.AlienRequestDrifter, kVoiceId.Ping },
    [RIGHT_MENU] = { kVoiceId.AlienTaunt, kVoiceId.AlienChuckle }
}

local kEmbryoMenu =
{
    [LEFT_MENU] = { kVoiceId.AlienRequestMist },
    [RIGHT_MENU] = { kVoiceId.AlienTaunt, kVoiceId.EmbryoChuckle }
}

local kRequestMenus =
{
    ["Spectator"] = { },
    ["AlienSpectator"] = { },
    ["MarineSpectator"] = { },

    ["Marine"] = kMarineMenu,
    ["JetpackMarine"] = kMarineMenu,
    ["Exo"] = kExoMenu,

    ["Skulk"] = kAlienMenu,
    ["Gorge"] =
    {
        [LEFT_MENU] = { kVoiceId.AlienRequestHealing, kVoiceId.AlienRequestDrifter, kVoiceId.AlienRequestHarvester, kVoiceId.Ping },
        [RIGHT_MENU] = { kVoiceId.AlienTaunt, kVoiceId.AlienChuckle }
    },

    ["Lerk"] = kAlienMenu,
    ["Fade"] = kAlienMenu,
    ["Onos"] = kAlienMenu,
    ["Embryo"] = kEmbryoMenu,
    ["ReadyRoomPlayer"] = kMarineMenu,
    ["ReadyRoomExo"] = kExoMenu,
    ["ReadyRoomEmbryo"] = kEmbryoMenu,
}

function GetRequestMenu(side, className)

    local menu = kRequestMenus[className]
    if menu and menu[side] then
        return menu[side]
    end

    return { }

end

if Client then

    function GetVoiceDescriptionText(voiceId)

        local descriptionText = ""

        local soundData = kSoundData[voiceId]
        if soundData then
            descriptionText = Locale.ResolveString(soundData.Description)
        end

        return descriptionText

    end

    function GetVoiceKeyBind(voiceId)

        local soundData = kSoundData[voiceId]
        if soundData then
            return soundData.KeyBind
        end

    end

end
