util.AddNetworkString("stacker_init")

--locals
local loading_players = {}

--gamemode functions
function GM:CanPlayerSuicide(ply)
	if ply:Team() == TEAM_SPECTATOR then return false
	else ply:PrintMessage(HUD_PRINTTALK, "Suicide would be consider as the player finishing their turn.") end
	
	return true
end

function GM:PlayerDeath(ply, inflictor, attacker) end
function GM:PlayerDeathSound(ply) return true end
function GM:PlayerDeathThink(ply) ply:Spawn() end
function GM:PlayerDisconnected(ply) loading_players[ply] = nil end

function GM:PlayerInitialSpawn(ply, ...)
	player_manager.SetPlayerClass(ply, "player_stacker")
	
	loading_players[ply] = ply:TimeConnected()
end

function GM:PlayerLoad(ply, forced)
	net.Start("stacker_init")
	net.WriteUInt(ply:EntIndex(), 8)
	net.Broadcast()
end

function GM:PlayerSpawn(ply, transition, ...)
	ply:SetHealth(99)
	
	if GetGlobalEntity("GMPlayer") == ply or self.StackerDebugSpawn then
		ply:UnSpectate()
		
		ply:SetTeam(TEAM_UNASSIGNED)
		ply:SetupHands()
		
		player_manager.OnPlayerSpawn(ply, transiton)
		player_manager.RunClass(ply, "Spawn")
		
		hook.Call("PlayerLoadout", self, ply) --do loadout even if transition, there won't be transitions with these maps
		hook.Call("PlayerSetModel", self, ply)
		
		if GetGlobalBool("GMBuilding") then ply:CrosshairEnable()
		else ply:CrosshairDisable() end
	else hook.Call("PlayerSpawnAsSpectator", self, ply) end
end

function GM:PlayerSpawnAsSpectator(ply)
	ply:RemoveAllItems()
	ply:SetTeam(TEAM_SPECTATOR)
	ply:Spectate(OBS_MODE_ROAMING)
	
	ply:CrosshairDisable()
end

--concommands
concommand.Add("stacker_focus", function(ply, command, arguments, arguments_string)
	local last_player = GetGlobalEntity("GMPlayer")
	
	if IsValid(ply) and ply ~= last_player then
		SetGlobalEntity("GMPlayer", ply)
		
		ply:Spawn()
	else SetGlobalEntity("GMPlayer") end
	
	if IsValid(last_player) then last_player:Spawn() end
end, nil, "Force yourself as the focus player.")

concommand.Add("stacker_spawn", function(ply, command, arguments, arguments_string)
	GAMEMODE.StackerDebugSpawn = true
	
	if IsValid(ply) then ply:Spawn() end
	
	GAMEMODE.StackerDebugSpawn = false
end, nil, "Force yourself as the focus player.")

--net
net.Receive("minge_defense_player_init", function(length, ply)
	if loading_players[ply] == nil then ErrorNoHaltWithStack("A player (", ply, ") tried to send a load net message but has yet to be spawned! It is possible that they are cheating.")
	else
		if loading_players[ply] == false then MsgC(color_red, "A player (" .. tostring(ply) .. ") had a belated load net message, an emulated one has been made.\n", color_white, "The above message is not an error, but a sign that clients are taking too long to load your server's content.\n") end
		
		loading_players[ply] = nil
		
		hook.Call("PlayerLoad", GAMEMODE, ply)
	end
end)
