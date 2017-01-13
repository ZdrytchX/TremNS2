MedPack.kPickupDelay = kMedpackPickupDelay

function MedPack:OnTouch(recipient)
    if not recipient.timeLastMedpack or recipient.timeLastMedpack + self.kPickupDelay <= Shared.GetTime() then
        recipient:AddHealth(MedPack.kHealth, false, false) --Heal Armour as well.. or not? Doesn't work
      if recipient:isa("Marine") then
        recipient:SetArmor(recipient:GetArmor() + kMedpackArmour)--Heal Armour fixed
        recipient:AddRegeneration()
      elseif recipient:isa("Exo") then--so exosuit doesn't gain super little
        recipient:SetArmor(recipient:GetArmor() + kMedpackExo)
      end
        recipient.timeLastMedpack = Shared.GetTime()
        StartSoundEffectAtOrigin(MedPack.kHealthSound, self:GetOrigin())
    end
end

function MedPack:GetIsValidRecipient(recipient)
	if not (recipient:isa("Marine") or recipient:isa("Exo")) then
    return false
  end
    return recipient:GetIsAlive() and not GetIsVortexed(recipient) and (recipient:GetHealth() < recipient:GetMaxHealth() or recipient:isa("Exo")) and (not recipient.timeLastMedpack or recipient.timeLastMedpack + self.kPickupDelay <= Shared.GetTime())
end
