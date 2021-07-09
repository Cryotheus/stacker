util.AddNetworkString("stacker_ready")

--locals
local ready_delays = {}

--gamemode functions
function GM:StackerPlayerReady(ply, ready)
	
	ply:SetNWBool("GMReady", ready)
	
	--[[
	net.Start("stacker_ready")
	net.WriteBool(false)
	net.Broadcast() --]]
end

--hook
hook.Add("PlayerDisconnected", "stacker_player_ready", function(ply) ready_delays[ply] = nil end)

--net
net.Receive("stacker_ready", function(length, ply)
	if GetGlobalBool("GMActive") then return end
	
	local cur_time = CurTime()
	
	if ready_delays[ply] then
		if cur_time > ready_delays[ply] then ready_delays[ply] = nil
		else return print(ply, "is on cool down") end
	end
	
	local ready = net.ReadBool()
	
	if ply:GetNWBool("GMReady") ~= ready then
		ready_delays[ply] = cur_time + 0.25
		
		hook.Run("StackerPlayerReady", ply, ready)
	else print(ply, "updated to the state they already were in") end
end)