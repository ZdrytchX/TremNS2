-- sourced from https://github.com/Wooza42/Wooza-s-Potpourri/blob/master/output/lua/shine/extensions/thegorgesofapherioxia.lua#L215
--made by Las apparently. He realised he made a few mistakes later but aided me in fixing the function so i can use it.
--[[
local function push(client, amount)
	local player = client:GetControllingPlayer()

    local startPoint = player:GetEyePos()
    local endPoint = startPoint + player:GetViewCoords().zAxis * 100
    local trace = Shared.TraceRay(startPoint, endPoint,  CollisionRep.Default, PhysicsMask.Bullets, EntityFilterTwo(player, player:GetActiveWeapon()));
	local ent = trace.entity;
	if not ent then return end

	endPoint = trace.endPoint;

	local origin = ent:GetOrigin();
	local offset = origin - endPoint;
	local new = endPoint - startPoint;
	new = new * amount;
	ent:SetOrigin(new + startPoint + offset);
end
--]]

function AddKnockback(client, amount)
  local hitEntities = GetEntitiesWithMixinWithinRange("Live", self:GetOrigin(), kGrenadeLauncherGrenadeDamageRadius); -- this should be inside the class for the rocket itself
  for i = 1, #hitEntities do
    local ent = hitEntities[i];
    local origin = ent:GetOrigin();
    local offset = origin - endPoint;
    local len = offset:GetLength();
    local newlen = kGrenadeLauncherGrenadeDamage / len;
    offset.x = offset.x / len * newlen;
    offset.y = offset.y / len * newlen;
    offset.z = offset.z / len * newlen;
    local velocity = ent:GetVelocity() + offset;
    ent:SetVelocity(offset);
  end
end
