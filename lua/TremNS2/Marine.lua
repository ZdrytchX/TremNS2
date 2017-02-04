--[[Marine.kFlashlightSoundName = PrecacheAsset("sound/NS2.fev/common/light")
Marine.kGunPickupSound = PrecacheAsset("sound/NS2.fev/marine/common/pickup_gun")
Marine.kSpendResourcesSoundName = PrecacheAsset("sound/NS2.fev/marine/common/player_spend_nanites")
Marine.kChatSound = PrecacheAsset("sound/NS2.fev/marine/common/chat")
Marine.kSoldierLostAlertSound = PrecacheAsset("sound/NS2.fev/marine/voiceovers/soldier_lost")

Marine.kFlinchEffect = PrecacheAsset("cinematics/marine/hit.cinematic")
Marine.kFlinchBigEffect = PrecacheAsset("cinematics/marine/hit_big.cinematic")

Marine.kHitGroundStunnedSound = PrecacheAsset("sound/NS2.fev/marine/common/jump")
Marine.kSprintStart = PrecacheAsset("sound/NS2.fev/marine/common/sprint_start")
Marine.kSprintTiredEnd = PrecacheAsset("sound/NS2.fev/marine/common/sprint_tired")
--The longer running sound, sprint_start, would be ideally the sprint_end soudn instead. That is what is done here
Marine.kSprintStartFemale = PrecacheAsset("sound/NS2.fev/marine/common/sprint_tired_female")
Marine.kSprintTiredEndFemale = PrecacheAsset("sound/NS2.fev/marine/common/sprint_start_female")]]

Marine.kEffectNode = "fxnode_playereffect"
Marine.kHealth = kMarineHealth
Marine.kBaseArmor = kMarineArmor
Marine.kArmorPerUpgradeLevel = kArmorPerUpgradeLevel
Marine.kMaxSprintFov = 95
-- Player phase delay - players can only teleport this often
Marine.kPlayerPhaseDelay = 2

Marine.kWalkMaxSpeed = 10                -- Four miles an hour = 6,437 meters/hour = 1.8 meters/second (increase for FPS tastes)
Marine.kRunMaxSpeed = 12--5.75
Marine.kRunInfestationMaxSpeed = 5

-- How fast does our armor get repaired by welders
Marine.kArmorWeldRate = kMarineArmorWeldRate
Marine.kWeldedEffectsInterval = 0.25--.5

Marine.kSpitSlowDuration = 5--3

Marine.kWalkBackwardSpeedScalar = 0.8--0.4

-- start the get up animation after stun before giving back control
Marine.kGetUpAnimationLength = 0

-- tracked per techId
Marine.kMarineAlertTimeout = 4

Marine.kDropWeaponTimeLimit = 1
Marine.kFindWeaponRange = 2
Marine.kPickupWeaponTimeLimit = 1
Marine.kPickupPriority = { [kTechId.Flamethrower] = 1, [kTechId.GrenadeLauncher] = 2, [kTechId.Shotgun] = 3 }

Marine.kAcceleration = 10
Marine.kSprintAcceleration = 12 -- 70
Marine.kSprintInfestationAcceleration = 60

Marine.kGroundFrictionForce = 10--16

Marine.kAirStrafeWeight = 2
--local   lJumpStaminaReduction = 4
local   lJumpStaminaRequirement = 0.25

--give self.medpackused
function Marine:OnCreate()

    InitMixin(self, BaseMoveMixin, { kGravity = Player.kGravity })
    InitMixin(self, GroundMoveMixin)
    InitMixin(self, JumpMoveMixin)
    InitMixin(self, CrouchMoveMixin)
    InitMixin(self, LadderMoveMixin)
    InitMixin(self, CameraHolderMixin, { kFov = kDefaultFov })
    InitMixin(self, MarineActionFinderMixin)
    InitMixin(self, ScoringMixin, { kMaxScore = kMaxScore })
    InitMixin(self, VortexAbleMixin)
    InitMixin(self, CombatMixin)
    InitMixin(self, SelectableMixin)

    Player.OnCreate(self)

    InitMixin(self, DissolveMixin)
    InitMixin(self, LOSMixin)
    InitMixin(self, ParasiteMixin)
    InitMixin(self, RagdollMixin)
    InitMixin(self, WebableMixin)
    InitMixin(self, CorrodeMixin)
    InitMixin(self, TunnelUserMixin)
    InitMixin(self, PhaseGateUserMixin)
    InitMixin(self, PredictedProjectileShooterMixin)
    InitMixin(self, MarineVariantMixin)

    InitMixin(self, RegenerationMixin)

    if Server then

        self.timePoisoned = 0
        self.poisoned = false

        -- stores welder / builder progress
        self.unitStatusPercentage = 0
        self.timeLastUnitPercentageUpdate = 0

		    self.grenadesLeft = 0
		    self.grenadeType = nil

    elseif Client then

        self.flashlight = Client.CreateRenderLight()

        self.flashlight:SetType( RenderLight.Type_Spot )
        self.flashlight:SetColor( Color(1, .05, 0) ) --0.8 0.8 1 // before 1 .7 .6
        self.flashlight:SetInnerCone( math.rad(35) ) --30
        self.flashlight:SetOuterCone( math.rad(40) ) --35
        self.flashlight:SetIntensity( 16 ) --10
        self.flashlight:SetRadius( 32 ) --distance 15
        self.flashlight:SetGoboTexture("models/marine/male/flashlight.dds")

        self.flashlight:SetIsVisible(false)

        InitMixin(self, TeamMessageMixin, { kGUIScriptName = "GUIMarineTeamMessage" })

        InitMixin(self, DisorientableMixin)

    end

    self.weaponDropTime = 0
    self.timeLastSpitHit = 0
    self.lastSpitDirection = Vector(0, 0, 0)
    self.timeOfLastDrop = 0
    self.timeOfLastPickUpWeapon = 0
    self.ruptured = false
    self.interruptAim = false
    self.catpackboost = false
    self.timeCatpackboost = 0
    self.flashlightLastFrame = false
    self.weaponBeforeUseId = Entity.invalidId
    --self.medpackused = 0
end

function Marine:GetCrouchSpeedScalar()
    return 0.75 --duckscale = 0.25, swimscale = 0.5
end

function Marine:GetGroundFriction()
    return 6
end

function Marine:GetSlowOnLand()
    return false
end

function Marine:GetCanJump()
    return not self:GetIsWebbed() and ( self:GetIsOnGround() or self:GetIsOnLadder() ) and self:GetSprintingScalar() >= lJumpStaminaRequirement
end

function Marine:GetJumpHeight()
    return Player.kJumpHeight - Player.kJumpHeight * self.slowAmount * self:GetSprintingScalar()--*0.8
end

function Marine:OnJump()

    if self.strafeJumped then
        self:TriggerEffects("strafe_jump", {surface = self:GetMaterialBelowPlayer()})
    end

    self:TriggerEffects("jump", {surface = self:GetMaterialBelowPlayer()})
    --take out some stamina FIXME
    --self.timeSprintChange = self.timeSprintChange - lJumpStaminaReduction
end

function Marine:GetMaxSpeed(possible)

    if possible then
        return Marine.kRunMaxSpeed
    end

    local sprintingScalar = self:GetSprintingScalar()--Change speed on sprint scalar

    --maxSprintSpeed
    local maxSpeed = Marine.kWalkMaxSpeed * sprintingScalar --+ ( Marine.kRunMaxSpeed - Marine.kWalkMaxSpeed ) * sprintingScalar
    --local maxSpeed = ConditionalValue( self:GetIsSprinting(), maxSprintSpeed, Marine.kWalkMaxSpeed )

    if self:GetIsSprinting() then maxSpeed = maxSpeed * ( Marine.kRunMaxSpeed / Marine.kWalkMaxSpeed ) end

    -- Take into account our weapon inventory and current weapon. Assumes a vanilla marine has a scalar of around .8.
    local inventorySpeedScalar = self:GetInventorySpeedScalar()-- + .17
    local useModifier = 1

    local activeWeapon = self:GetActiveWeapon()
    if self.isUsing and activeWeapon:GetMapName() == Builder.kMapName then
        useModifier = 0.5
    end

    if self.catpackboost then
        maxSpeed = maxSpeed + kCatPackMoveAddSpeed
    end

    return maxSpeed * self:GetSlowSpeedModifier() * inventorySpeedScalar  * useModifier

end

function Marine:ModifyJumpLandSlowDown(slowdownScalar)

    if self.strafeJumped then
        slowdownScalar = 0.0 + slowdownScalar --0.2
    end

    return slowdownScalar

end

function Marine:GetAirControl()
    return 0
end

--Strafe jumps

function Marine:ModifyVelocity(input, velocity, deltaTime)
    --Air Strafe testing...
    if not self.onGround then

        --initialising
        local lAirAcceleration = self:GetMaxSpeed()--maxSpeedTable.maxSpeed --accelerate to maximum speed in one second
        local wishDir = self:GetViewCoords():TransformVector(input.move) --this is a unit vector
        wishDir.y = 0
        wishDir:Normalize()

        local wishDircurrentspeed = velocity:DotProduct(wishDir) --current velocity along wishdir axis

        local addspeedlimit = lAirAcceleration - wishDircurrentspeed
        if addspeedlimit <= 0 then return end

        accelerationIncrement = deltaTime * lAirAcceleration
        if accelerationIncrement > addspeedlimit then accelerationIncrement = addspeedlimit end

        velocity:Add(wishDir * accelerationIncrement)
        --Because fuck ns2 physics

    end

end


--FIXME
--[[
function Marine:ModifyAttackSpeed(attackSpeedTable)

    local activeWeapon = self:GetActiveWeapon()
    if activeWeapon and activeWeapon:isa("GrenadeLauncher") then
        attackSpeedTable.attackSpeed = attackSpeedTable.attackSpeed * 2
    end

end
]]
--------------------------------------
--Get Armour Levels to find out weapon costs somehow
--for now i'll just copy paste the function here

--[[
function Marine:GetArmorLevel()

    local armorLevel = 0
    local techTree = self:GetTechTree()

    if techTree then

        local armor3Node = techTree:GetTechNode(kTechId.Armor3)
        local armor2Node = techTree:GetTechNode(kTechId.Armor2)
        local armor1Node = techTree:GetTechNode(kTechId.Armor1)

        if armor3Node and armor3Node:GetResearched() then
            armorLevel = 3
        elseif armor2Node and armor2Node:GetResearched()  then
            armorLevel = 2
        elseif armor1Node and armor1Node:GetResearched()  then
            armorLevel = 1
        end

    end

    return armorLevel

end

function Marine:GetArmorAmount(armorLevels)

    if not armorLevels then

        armorLevels = 0

        if GetHasTech(self, kTechId.Armor3, true) then
            armorLevels = 3
        elseif GetHasTech(self, kTechId.Armor2, true) then
            armorLevels = 2
        elseif GetHasTech(self, kTechId.Armor1, true) then
            armorLevels = 1
        end

    end

    return Marine.kBaseArmor + armorLevels * Marine.kArmorPerUpgradeLevel

end
]]-- end of copied function
