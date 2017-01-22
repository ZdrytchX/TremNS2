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
