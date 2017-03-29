--mod panel information
if AddModPanel then
  local tremns2_info = PrecacheAsset("materials/TremNS2/tremns2_info.material", "http://steamcommunity.com/sharedfiles/filedetails/?id=808128703")
  local tremns2_fade = PrecacheAsset("materials/TremNS2/tremns2_fade.material", "https://sites.google.com/site/zdrytchx/home/ns2-motd")
  local tremns2_speedo = PrecacheAsset("materials/TremNS2/tremns2_speedo.material")
  local tremns2_strafe = PrecacheAsset("materials/TremNS2/tremns2_strafe.material", "https://www.youtube.com/watch?v=htQdjjfps8I")
  local tremns2_ARC = PrecacheAsset("materials/TremNS2/tremns2_ARC.material")
  local tremns2_gl = PrecacheAsset("materials/TremNS2/tremns2_gl.material")
  local tremns2_victoryconditions = PrecacheAsset("materials/TremNS2/tremns2_victoryconditions.material")
  local tremns2_shittybase = PrecacheAsset("materials/TremNS2/tremns2_shittybase.material", "https://www.youtube.com/watch?v=osxt9t0nTq4")
  local tremns2_downloadtremulous = PrecacheAsset("materials/TremNS2/tremns2_downloadtremulous.material", "https://sites.google.com/site/zdrytchx/how-to/tremulous-install-for-newbies")
  local tremns2_crosshairs = PrecacheAsset("materials/TremNS2/tremns2_crosshairs.material")
  local tremns2_skulk = PrecacheAsset("materials/TremNS2/tremns2_skulk.material")
  --local tremns2_gl = PrecacheAsset("materials/TremNS2/tremns2_gl.material")
  --local tremns2_gl = PrecacheAsset("materials/TremNS2/tremns2_gl.material")

  AddModPanel(tremns2_info, "http://steamcommunity.com/sharedfiles/filedetails/?id=808128703")
  AddModPanel(tremns2_fade, "https://sites.google.com/site/zdrytchx/home/ns2-motd")
  AddModPanel(tremns2_speedo)
  AddModPanel(tremns2_strafe, "https://www.youtube.com/watch?v=htQdjjfps8I") --TODO: NEED A BETTER TUTORIAL
  AddModPanel(tremns2_ARC)
  AddModPanel(tremns2_gl)
  AddModPanel(tremns2_victoryconditions)
  AddModPanel(tremns2_shittybase, "https://www.youtube.com/watch?v=osxt9t0nTq4") --propaganda
  AddModPanel(tremns2_downloadtremulous, "https://sites.google.com/site/zdrytchx/how-to/tremulous-install-for-newbies")
  AddModPanel(tremns2_crosshairs)
  AddModPanel(tremns2_skulk)
  --AddModPanel(tremns2_gl)
  --AddModPanel(tremns2_gl)
end

--core mixins
ModLoader.SetupFileHook( "lua/Mixins/GroundMoveMixin.lua", "lua/TremNS2/core/GroundMoveMixin.lua", "post" )


--Balance
ModLoader.SetupFileHook( "lua/Balance.lua", "lua/TremNS2/Balance.lua", "post" )
ModLoader.SetupFileHook( "lua/BalanceHealth.lua", "lua/TremNS2/BalanceHealth.lua", "post" )
ModLoader.SetupFileHook( "lua/BalanceMisc.lua", "lua/TremNS2/BalanceMisc.lua", "post" )
ModLoader.SetupFileHook( "lua/ResourceTower_Server.lua", "lua/TremNS2/ResourceTower_Server.lua", "post" )
--Speed Modifications
ModLoader.SetupFileHook( "lua/Exo.lua", "lua/TremNS2/Exo.lua", "post" )
ModLoader.SetupFileHook( "lua/Gorge.lua", "lua/TremNS2/Gorge.lua", "post" )
ModLoader.SetupFileHook( "lua/Onos.lua", "lua/TremNS2/Onos.lua", "post" )
ModLoader.SetupFileHook( "lua/Lerk.lua", "lua/TremNS2/Lerk.lua", "post" )
ModLoader.SetupFileHook( "lua/Skulk.lua", "lua/TremNS2/Skulk.lua", "post" )
ModLoader.SetupFileHook( "lua/Fade.lua", "lua/TremNS2/Fade.lua", "post" )
ModLoader.SetupFileHook( "lua/Marine.lua", "lua/TremNS2/Marine.lua", "post" )
ModLoader.SetupFileHook( "lua/SprintMixin.lua", "lua/TremNS2/SprintMixin.lua", "post" )
ModLoader.SetupFileHook( "lua/JetpackMarine.lua", "lua/TremNS2/JetpackMarine.lua", "post" )

----------------------------------
--Weapons
-------------
--Aliens
--Extend Melee Ranges
ModLoader.SetupFileHook( "lua/Weapons/Alien/BiteLeap.lua", "lua/TremNS2/Weapons/SkulkBite.lua", "post" )
ModLoader.SetupFileHook( "lua/Weapons/Alien/SwipeBlink.lua", "lua/TremNS2/Weapons/SwipeBlink.lua", "post" )
ModLoader.SetupFileHook( "lua/Weapons/Alien/StabBlink.lua", "lua/TremNS2/Weapons/StabBlink.lua", "post" )
ModLoader.SetupFileHook( "lua/Weapons/Alien/Gore.lua", "lua/TremNS2/Weapons/Gore.lua", "post" )

ModLoader.SetupFileHook( "lua/Weapons/Alien/HealSprayMixin.lua", "lua/TremNS2/Weapons/HealSprayMixin.lua", "post" )
ModLoader.SetupFileHook( "lua/Weapons/Babbler.lua", "lua/TremNS2/Babbler.lua", "post" )
ModLoader.SetupFileHook( "lua/Whip_Server.lua", "lua/TremNS2/Whip_Server.lua", "post" )

--Give lerk spores poison effect
ModLoader.SetupFileHook( "lua/Weapons/SporeCloud.lua", "lua/TremNS2/Weapons/SporeCloud.lua", "post" )

--Fade Shadowstep Fixup
ModLoader.SetupFileHook( "lua/TechData.lua", "lua/TremNS2/TechData.lua", "post" )
ModLoader.SetupFileHook( "lua/EvolutionChamber.lua", "lua/TremNS2/EvolutionChamber.lua", "post" )
ModLoader.SetupFileHook( "lua/AlienTechMap.lua", "lua/TremNS2/AlienTechMap.lua", "post" )
ModLoader.SetupFileHook( "lua/AlienTeam.lua", "lua/TremNS2/AlienTeam.lua", "post" )
ModLoader.SetupFileHook( "lua/TeamInfo.lua", "lua/TremNS2/TeamInfo.lua", "post" )
ModLoader.SetupFileHook( "lua/PlayingTeam.lua", "lua/TremNS2/PlayingTeam.lua", "post" )

--------------
--Marines
ModLoader.SetupFileHook( "lua/Weapons/Marine/Minigun.lua", "lua/TremNS2/Weapons/Minigun.lua", "post" )
ModLoader.SetupFileHook( "lua/Weapons/Marine/Railgun.lua", "lua/TremNS2/Weapons/Railgun.lua", "post" )
ModLoader.SetupFileHook( "lua/Weapons/Marine/ClusterGrenade.lua", "lua/TremNS2/Weapons/ClusterGrenade.lua", "post" )
--Grenade Launcher shall fire at just above running pace
ModLoader.SetupFileHook( "lua/Weapons/Marine/GrenadeLauncher.lua", "lua/TremNS2/Weapons/GrenadeLauncher.lua", "post" )
ModLoader.SetupFileHook( "lua/Weapons/Marine/Grenade.lua", "lua/TremNS2/Weapons/Grenade.lua", "post" )
ModLoader.SetupFileHook( "lua/Weapons/Marine/Pistol.lua", "lua/TremNS2/Weapons/Pistol.lua", "post" )
--Clip count modifications
ModLoader.SetupFileHook( "lua/Weapons/Marine/ClipWeapon.lua", "lua/TremNS2/Weapons/ClipWeapon.lua", "post" )
ModLoader.SetupFileHook( "lua/Weapons/Marine/Rifle.lua", "lua/TremNS2/Weapons/Rifle.lua", "post" )
ModLoader.SetupFileHook( "lua/Weapons/Marine/Shotgun.lua", "lua/TremNS2/Weapons/Shotgun.lua", "post" )

--Welder
ModLoader.SetupFileHook( "lua/Weapons/Marine/Welder.lua", "lua/TremNS2/Weapons/Welder.lua", "post" )
--FIXME: remove the welder's ability to remove axes and buying new weapnos should allow the user to buy the welder again
--TODO: Remove costs if a user buys sometihng cheaper
--ModLoader.SetupFileHook( "lua/Weapons/MarineBuy_Client.lua", "lua/TremNS2/MarineBuy_Client.lua", "post" )
--ModLoader.SetupFileHook( "lua/Weapons/Marine_Server.lua", "lua/TremNS2/Marine_Server.lua", "post" )
--Heal with Welder
ModLoader.SetupFileHook( "lua/Player.lua", "lua/TremNS2/Player.lua", "post" )
---------------------------------
--Misc

--Give Credits For Frags
ModLoader.SetupFileHook( "lua/PointGiverMixin.lua", "lua/TremNS2/PointGiverMixin.lua", "post" )
ModLoader.SetupFileHook( "lua/ScoringMixin.lua", "lua/TremNS2/ScoringMixin.lua", "post" )
ModLoader.SetupFileHook( "lua/NS2Utility.lua", "lua/TremNS2/NS2Utility.lua", "post" )
--heal armour as well
ModLoader.SetupFileHook( "lua/MedPack.lua", "lua/TremNS2/MedPack.lua", "post" )
ModLoader.SetupFileHook( "lua/RegenerationMixin.lua", "lua/TremNS2/RegenerationMixin.lua", "post" )
--Adjusted Vampire upgrades
ModLoader.SetupFileHook( "lua/Damagetypes.lua", "lua/TremNS2/Damagetypes.lua", "post" )

--Bots that build stuff for the commander
ModLoader.SetupFileHook( "lua/Drifter.lua", "lua/TremNS2/Drifter.lua", "post" )
ModLoader.SetupFileHook( "lua/MAC.lua", "lua/TremNS2/MAC.lua", "post" )

--Structures
--Allow Multiple Turrets per Battery
ModLoader.SetupFileHook( "lua/SentryBattery.lua", "lua/TremNS2/SentryBattery.lua", "post" )
ModLoader.SetupFileHook( "lua/PowerPoint.lua", "lua/TremNS2/PowerPoint.lua", "post")
ModLoader.SetupFileHook( "lua/Armory.lua", "lua/TremNS2/Armory.lua", "post" )
ModLoader.SetupFileHook( "lua/Armory_Server.lua", "lua/TremNS2/Armory_Server.lua", "post" )
ModLoader.SetupFileHook( "lua/Sentry.lua", "lua/TremNS2/Sentry.lua", "post" ) --FIXME
--ModLoader.SetupFileHook( "lua/TargetCache.lua", "lua/TremNS2/TargetCache.lua", "post" ) --FIXME
--for some fucking reason sentries don't have any physics whatsoever so i can't fix its angle problem yet
ModLoader.SetupFileHook( "lua/ARC.lua", "lua/TremNS2/ARC.lua", "post" )
ModLoader.SetupFileHook( "lua/CommAbilities/Alien/BoneWall.lua", "lua/TremNS2/CommAbilities/Alien/BoneWall.lua", "post" )

--Autobuild for Marines FIXME
--ModLoader.SetupFileHook( "lua/ConstructMixin.lua", "lua/TremNS2/ConstructMixin.lua", "post" )

----------------------------------
--Research Tech Modifications
ModLoader.SetupFileHook( "lua/MarineTeam.lua", "lua/TremNS2/MarineTeam.lua", "post" )
ModLoader.SetupFileHook( "lua/MarineTechMap.lua", "lua/TremNS2/MarineTechMap.lua", "post" )

------------------------------
--HUD
--FIXME Doesn't work?
ModLoader.SetupFileHook( "lua/GUIBulletDisplay.lua", "lua/TremNS2/HUD/GUIBulletDisplay.lua", "post" )
ModLoader.SetupFileHook( "lua/GUIFlamethrowerDisplay.lua", "lua/TremNS2/HUD/GUIFlamethrowerDisplay.lua", "post" )
ModLoader.SetupFileHook( "lua/GUIEvemt.lua", "lua/TremNS2/HUD/GUIEvemt.lua", "post" )
ModLoader.SetupFileHook( "lua/ConsoleCommands_Client.lua", "lua/TremNS2/HUD/ConsoleCommands_Client.lua", "post" )
ModLoader.SetupFileHook( "lua/GUISpeedDebug.lua", "lua/TremNS2/HUD/GUISpeedDebug.lua", "post" )
ModLoader.SetupFileHook( "lua/Player_Client.lua", "lua/TremNS2/HUD/Player_Client.lua", "post" ) --HUD
ModLoader.SetupFileHook( "lua/GUIDamageIndicators.lua", "lua/TremNS2/HUD/GUIDamageIndicators.lua", "post" )

--Sounds
--ModLoader.SetupFileHook( "lua/DamageEffects.lua", "lua/TremNS2/Sound/DamageEffects.lua", "post" ) XXX
--ModLoader.SetupFileHook( "lua/PlayerEffects.lua", "lua/TremNS2/Sound/PlayerEffects.lua", "post" ) XXX

--Come'on! replacement taunt + give medpack ability
ModLoader.SetupFileHook( "lua/VoiceOver.lua", "lua/TremNS2/Sound/VoiceOver.lua", "post" )

----------------
--Bots

ModLoader.SetupFileHook( "lua/bots/AlienCommanderBrain_Data.lua", "lua/TremNS2/bots/AlienCommanderBrain_Data.lua", "post" )
--ModLoader.SetupFileHook( "lua/bots/MarineBrain_Data.lua", "lua/TremNS2/bots/MarineBrain_Data.lua", "post" )
ModLoader.SetupFileHook( "lua/bots/MarineCommanderBrain_Data.lua", "lua/TremNS2/bots/MarineCommanderBrain_Data.lua", "post" )
