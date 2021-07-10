util.AddNetworkString("stacker_ready")

--locals
local ready_delays = {}

--gamemode functions
function GM:StackerPlayerReady(ply, ready)
	local ready_count = 0
	local ready_percent = 0.5
	local ready_threshold_weight = 0
	
	ply:SetNWBool("GMReady", ready)
	
	for index, ply in ipairs(player.GetAll()) do
		if ply:GetNWBool("GMReady") then ready_count = ready_count + 1 end
		
		ready_threshold_weight = ready_threshold_weight + ready_percent
	end
	
	if ready_count >= ready_threshold_weight then hook.Call("StackerTimerReduce", self, CurTime() + 5, true)
	elseif ready_count == 0 then hook.Call("StackerTimerStop", self)
	else hook.Call("StackerTimerStart", self, CurTime() + 70) end
	
	--[[
	net.Start("stacker_ready")
	net.WriteBool(false)
	net.Broadcast() --]]
end

--concommand
concommand.Add("stacker_ready_bots", function(ply, command, arguments, arguments_string)
	local bots = player.GetBots()
	local quantity = tonumber(arguments[1]) or #bots
	
	for index, bot in ipairs(bots) do
		local ready = index <= quantity
		
		if ready ~= bot:GetNWBool("GMReady") then hook.Run("StackerPlayerReady", bot, ready) end
	end
end, nil, "Ready X amount of bots.")

--hook
hook.Add("PlayerDisconnected", "stacker_player_ready", function(ply) ready_delays[ply] = nil end)

--net
net.Receive("stacker_ready", function(length, ply)
	if GAMEMODE.StackerGameActive then return end
	
	local cur_time = CurTime()
	
	if ready_delays[ply] then
		if cur_time > ready_delays[ply] then ready_delays[ply] = nil
		else return print(ply, "is on cool down") end
	end
	
	local ready = net.ReadBool()
	
	if ply:GetNWBool("GMReady") ~= ready then
		ready_delays[ply] = cur_time + 0.25
		
		hook.Run("StackerPlayerReady", ply, ready)
	end
end)

--post
hook.Call("StackerTimerSetCallback", GM, "StackerGameStart")