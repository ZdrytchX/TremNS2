--target:SetPoisoned(player)

-- Damage per think interval (from NS1)
-- 0.5 in NS1, reducing to make sure sprinting machines take damage
local kDamageInterval = 0.25

-- Keep table of entities that have been hurt by spores to make
-- spores non-stackable. List of {entityId, time} pairs.

local gHurtBySpores = { }

-- how fast we drop
SporeCloud.kDropSpeed = 0.6
-- how far away from our drop-target before we slow down the speed
SporeCloud.kDropSlowDistance = 0.4
-- minimum distance above floor we drop to
SporeCloud.kDropMinDistance = 1.1

SporeCloud.kMaxRange = 3--17
SporeCloud.kTravelSpeed = 60 --m/s

local function GetEntityRecentlyHurt(entityId, time)

    for index, pair in ipairs(gHurtBySpores) do
        if pair[1] == entityId and pair[2] > time then
            return true
        end
    end

    return false

end

local function SetEntityRecentlyHurt(entityId)

    for index, pair in ipairs(gHurtBySpores) do
        if pair[1] == entityId then
            table.remove(gHurtBySpores, index)
        end
    end

    table.insert(gHurtBySpores, {entityId, Shared.GetTime()})

end

function SporeCloud:GetDamageType()
    return kDamageType.Normal--kDamageType.Gas
end

-- They stick around for a while - don't show the numbers. Too much.
function SporeCloud:GetShowHitIndicator()
    return true--false
end

function SporeCloud:SporeDamage(time)

    local enemies = GetEntitiesForTeam("Player", GetEnemyTeamNumber(self:GetTeamNumber()))
    local damageRadius = self:GetDamageRadius()

    -- When checking if spore cloud can reach something, only walls and door entities will block the damage.
    local filterNonDoors = EntityFilterAllButIsa("Door")
    for index, entity in ipairs(enemies) do

        local attackPoint = entity:GetEyePos()
        if (attackPoint - self:GetOrigin()):GetLength() < damageRadius then

            if not entity:isa("Commander") and not GetEntityRecentlyHurt(entity:GetId(), (time - kDamageInterval)) then

                -- Make sure spores can "see" target
                local trace = Shared.TraceRay(self:GetOrigin(), attackPoint, CollisionRep.Damage, PhysicsMask.Bullets, filterNonDoors)
                if trace.fraction == 1.0 or trace.entity == entity then

                   entity:SetPoisoned(self:GetParent())

                    self:DoDamage(kSporesDustDamagePerSecond * kDamageInterval, entity, trace.endPoint, (attackPoint - trace.endPoint):GetUnit(), "organic" )

                    -- Spores can't hurt this entity for kDamageInterval
                    SetEntityRecentlyHurt(entity:GetId())

                end

            end

        end

    end
end
