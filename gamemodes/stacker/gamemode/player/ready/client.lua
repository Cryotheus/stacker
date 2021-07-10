--gamemode functions
function GM:StackerPlayerReady(ready)
	net.Start("stacker_ready")
	net.WriteBool(ready)
	net.SendToServer()
end

--net
net.Receive("stacker_ready", function()
	local order = {}
	local player_indices = {}
	
	repeat
		local player_index = net.ReadUInt(8)
		
		table.insert(order, Entity(player_index))
		table.insert(player_indices, player_index)
	until not net.ReadBool()
	
	GAMEMODE.StackerGameOrder = order
	GAMEMODE.StackerPlayerIndices = player_indices
	
	hook.Run("StackerGameStart", player_indices)
end)