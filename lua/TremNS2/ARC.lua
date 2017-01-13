ARC.kMoveSpeed              = 3.5--2.0
ARC.kCombatMoveSpeed        = 1.5--0.8

--defaults:
--ARC.kSplashRadius           = 7
--ARC.kUpgradedSplashRadius   = 13

--
-- Do a complete check if the target can be fired on.
--
function ARC:GetCanFireAtTarget(target, targetPoint)

    if target == nil then
        return false
    end

    if not HasMixin(target, "Live") or not target:GetIsAlive() then
        return false
    end

    if not GetAreEnemies(self, target) then
        return false
    end
--target:GetReceivesBiologicalDamage()
    if (not target.GetReceivesStructuralDamage or not target:GetReceivesStructuralDamage()) and not target:isa("Player") then
        return false
    end

    -- don't target eggs (they take only splash damage)
    if --[[target:isa("Egg") or]] target:isa("Cyst") then
        return false
    end

    return self:GetCanFireAtTargetActual(target, targetPoint)

end

function ARC:GetCanFireAtTargetActual(target, targetPoint)

    if (not target.GetReceivesStructuralDamage or not target:GetReceivesStructuralDamage()) and not target:isa("Player") then
        return false
    end

    -- don't target eggs (they take only splash damage)
    if --[[target:isa("Egg") or]] target:isa("Cyst") then
        return false
    end

    if not target:GetIsSighted() and not GetIsTargetDetected(target) then
        return false
    end

    local distToTarget = (target:GetOrigin() - self:GetOrigin()):GetLengthXZ()
    if (distToTarget > ARC.kFireRange) or (distToTarget < ARC.kMinFireRange) then
        return false
    end

    return true

end
