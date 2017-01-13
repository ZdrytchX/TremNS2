local kAnimationGraph = PrecacheAsset("models/marine/armory/armory.animation_graph")

-- Looping sound while using the armory
Armory.kResupplySound = PrecacheAsset("sound/NS2.fev/marine/structures/armory_resupply")
local kLoginAndResupplyTime = 0.3--0.3
Armory.kHealAmount = 6--25
Armory.kHealArmour = 7
Armory.kResupplyInterval = 0.3--.8
gArmoryHealthHeight = 1.4
-- Players can use menu and be supplied by armor inside this range
Armory.kResupplyUseRange = 2.5
-- Check if friendly players are nearby and facing armory and heal/resupply them
local function LoginAndResupply(self)

    self:UpdateLoggedIn()

    -- Make sure players are still close enough, alive, marines, etc.
    -- Give health and ammo to nearby players.
    if GetIsUnitActive(self) then
        self:ResupplyPlayers()
    end

    return true

end

function Armory:OnInitialized()

    ScriptActor.OnInitialized(self)

    self:SetModel(Armory.kModelName, kAnimationGraph)

    InitMixin(self, WeldableMixin)
    InitMixin(self, NanoShieldMixin)

    if Server then

        self.loggedInArray = { false, false, false, false }

        -- Use entityId as index, store time last resupplied
        self.resuppliedPlayers = { }

        self:AddTimedCallback(LoginAndResupply, kLoginAndResupplyTime)

        -- This Mixin must be inited inside this OnInitialized() function.
        if not HasMixin(self, "MapBlip") then
            InitMixin(self, MapBlipMixin)
        end

        InitMixin(self, StaticTargetMixin)
        InitMixin(self, InfestationTrackerMixin)
        InitMixin(self, SupplyUserMixin)

    elseif Client then

        self:OnInitClient()
        InitMixin(self, UnitStatusMixin)
        InitMixin(self, HiveVisionMixin)

    end

    InitMixin(self, IdleMixin)

end

function Armory:GetRequiresPower()
    return true
end

--[[
function Armory:GetCanBeUsed(player, useSuccessTable)

    if player:isa("Exo") then
        useSuccessTable.useSuccess = true--false
    end

end
function Armory:GetCanBeUsedConstructed(byPlayer)
    return true--not byPlayer:isa("Exo")
end
]]
