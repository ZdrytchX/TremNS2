function Rifle:GetMaxClips()
    return 6
end

function Rifle:GetSpread()
    return kRifleSpread
end

--FIXME
--[[
function Rifle:ModifyAttackSpeed(attackSpeedTable)

    local activeWeapon = self:GetActiveWeapon()
    if activeWeapon then
        attackSpeedTable.attackSpeed = attackSpeedTable.attackSpeed * 0.7
    end

end
--]]
