--locals
local start_prop_position = Vector(0, 0, -9100)

--gamemode functions
function GM:StackerPropSpawn(ply, position, angles)
	local model = "models/props_c17/oildrum001.mdl"
	local prop = ents.Create("prop_physics")
	
	prop:SetAngles(angles or angle_zero)
	prop:SetPos(position)
	
	prop:SetModel(model)
	prop:SetSkin(prop:SkinCount() - 1)
	
	if ply then
		prop:SetNWEntity("StackerOwner", ply)
		prop:SetNWString("StackerSteamID", ply:SteamID())
	else
		prop:SetNWEntity("StackerOwner", game.GetWorld())
		prop:SetNWString("StackerSteamID", "WORLD")
	end
end

function GM:StackerPropSpawnStart()
	--more?
	hook.Call("StackerPropSpawn", self, nil, self.PropSpawnStartPoint or start_prop_position)
end
