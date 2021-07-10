function GM:StackerGameCreateOrder(sync)
	--for now its just randomized
	--in the future we might want to prioritize certain players and then randomize those with the same priority
	local all_players = player.GetAll()
	local order = {}
	local player_count = #all_players
	
	for remaining = player_count, 1, -1 do
		local ply = table.remove(all_players, math.random(remaining))
		
		ply:SetNWBool("GMPlaying", true)
		table.insert(order, ply)
	end
	
	if sync then hook.Call("StackerGameSyncOrder", self, order) end
	
	return order
end

function GM:StackerGameStart(...)
	local order = hook.Call("StackerGameCreateOrder", self, true)
	
	print("StackerGameStart")
	PrintTable(order, 1)
	
	self.StackerGameActive = true
	self.StackerGameOrder = order
end

function GM:StackerGameSyncOrder(order, target)
	order = order or self.StackerGameOrder
	
	if order then
		net.Start("stacker_ready")
		
		for index, ply in ipairs(order) do
			if index > 1 then net.WriteBool(true) end
			
			net.WriteUInt(ply:EntIndex(), 8)
		end
		
		net.WriteBool(false)
		
		if target then net.Send(target)
		else net.Broadcast() end
	end
end