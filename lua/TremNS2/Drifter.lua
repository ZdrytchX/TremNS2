Drifter.kEnzymeRange = 30--22

local kDrifterSelfOrderRange = 30--12

local function FindTask(self)

    -- find ungrown structures
    for _, structure in ipairs(GetEntitiesWithMixinForTeamWithinRange("Construct", self:GetTeamNumber(), self:GetOrigin(), kDrifterSelfOrderRange)) do

        if not structure:GetIsBuilt() and not IsBeingGrown(self, structure) and (not structure.GetCanAutoBuild or structure:GetCanAutoBuild()) then

            self:GiveOrder(kTechId.Grow, structure:GetId(), structure:GetOrigin(), nil, false, false)
            return

        end

    end

end
