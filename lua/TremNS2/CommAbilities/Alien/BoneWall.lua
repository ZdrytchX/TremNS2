local kLifeSpan = 60-- --6

local kMoveOffset = 4
local kMoveDuration = 10--0.4

function BoneWall:GetLifeSpan()
    return kLifeSpan
end

function BoneWall:OnUpdate(deltaTime)

    CommanderAbility.OnUpdate(self, deltaTime)

    local lifeTime = math.max(0, Shared.GetTime() - self:GetTimeCreated())
    local remainingTime = self:GetLifeSpan() - lifeTime

    if remainingTime < self:GetLifeSpan() then

        local moveFraction = 0

        if remainingTime <= 1 then
            moveFraction = 1 - Clamp(remainingTime / kMoveDuration, 0, 1)
        end

        local piFraction = moveFraction * (math.pi / 2)

        self:SetOrigin(self.spawnPoint - Vector(0, math.sin(piFraction) * kMoveOffset, 0))

    end

end
