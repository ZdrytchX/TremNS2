function ClipWeapon:GetMaxClips()
    return 1--4 --For flamer and blaster
end

function ClipWeapon:GetSprintAllowed()
    return true--not self.reloading and (Shared.GetTime() > (self.timeAttackEnded + kMaxTimeToSprintAfterAttack))
end
