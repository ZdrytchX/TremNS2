local kClipSize = kPistolClipSize
local kSpread = kPistolSpread
local kAltSpread = ClipWeapon.kCone0Degrees
local kPistolBullletSize = 0.5--vanilla = 0.018

function Pistol:GetClipSize()
    return kClipSize
end

function Pistol:GetMaxClips()
    return 30
end

function ClipWeapon:GetBulletSize()
    return kBulletSize
end

function Pistol:GetSpread()
    return ConditionalValue(self.altMode, kAltSpread, kSpread)
end

function Weapon:GetIsDroppable()
    return false
end
