-- ======= Copyright (c) 2003-2011, Unknown Worlds Entertainment, Inc. All rights reserved. =======
--
-- lua\TargetCache.lua
--
--    Created by:   Mats Olsson (mats.olsson@matsotech.se)
--
-- Allows for fast target selection for AI units such as hydras and sentries.
--
-- Gains most of its speed by using the fact that the majority of potential targets don't move
-- (static) while a minority is mobile.
--
-- Possible targets must implement one of the StaticTargetMixin and MobileTargetMixin. Mobile targets
-- can move freely, but StaticTargetMixins must call self:StaticTargetMoved() whenever they change
-- their location. As its fairly expensive to deal with a static target (all AI shooters in range will
-- trace to its location), it should not be done often (its intended to allow teleportation of
-- structures).
--
-- To speed things up even further, the concept of TargetType is used. Each TargetType maintains a
-- dictionary of created entities that match its own type. This allows for a quick filtering away of
-- uninterresting targets, without having to check their type or team.
--
-- The static targets are kept in a per-attacker cache. Usually, this table is empty, meaning that
-- 90% of all potential targets are ignored at zero cpu cost. The remaining targets are found by
-- using the fast ranged lookup (Shared.GetEntitiesWithinRadius()) and then using the per type list
-- to quickly ignore any non-valid targets, only then checking validity, range and visibility.
--
-- The TargetSelector is the main interface. It is configured, one per attacker, with the targeting
-- requriements (max range, if targets must be visible, what targetTypes, filters and prioritizers).
--
-- The TargetSelector is assumed NOT to move. If it starts moving, it must call selector:AttackerMoved()
-- before its next acquire target, in order to invalidate all cached targeting information.
--
-- Once configured, new targets may be acquired using AcquireTarget or AcquireTargets, and the validity
-- of a current target can be check by ValidateTarget().
--
-- Filters are used to reject targets that are not to valid.
--
-- Prioritizers are used to prioritize among targets. The default prioritizer chooses targets that
-- can damage the attacker before other targets.
--
--
-- TargetFilters are used to remove targets before presenting them to the prioritizers
--

--
-- Removes targets that are not inside the maxPitch
--FIXME
function PitchTargetFilter(attacker, minPitchDegree, maxPitchDegree)

    return function(target, targetPoint)
        local origin = GetEntityEyePos(attacker)
        local viewCoords = GetEntityViewAngles(attacker):GetCoords()
        local v = targetPoint - origin
        --local distY = Math.DotProduct(viewCoords.yAxis, v) --Horizontal?
        local distZ = Math.DotProduct(viewCoords.zAxis, v) --z axis: pitch?
        local pitch = 180 * --[[math.atan2(distY,distZ)]]distZ / math.pi
        result = pitch >= minPitchDegree and pitch <= maxPitchDegree
        -- Log("filter %s for %s, v %s, pitch %s, result %s (%s,%s)", target, attacker, v, pitch, result, minPitchDegree, maxPitchDegree)
        return result
    end

end
