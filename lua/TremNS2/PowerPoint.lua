local kDestructionBuildDelay = 3--15

function GetPowerPointRecentlyDestroyed(self)
    return (self.timeOfDestruction + kDestructionBuildDelay) > Shared.GetTime()
end

--TODO: KABOOM!
--function PowerPoint:OnKill()

--end
