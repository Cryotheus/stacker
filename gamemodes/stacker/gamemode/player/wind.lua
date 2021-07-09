--locals
local local_player = IsValid(LocalPlayer()) and LocalPlayer() or nil
local wind_active = false
local wind_max_speed = 2400
local wind_min_speed = 600
local wind_path = "vehicles/fast_windloop1.wav"
local wind_pitch_divisor = (wind_max_speed - wind_min_speed)
local wind_sound = IsValid(LocalPlayer()) and CreateSound(local_player, wind_path) or nil

--gamemode functions
function GM:StackerPlayerWindThink(ply)
	local speed = math.Clamp(ply:GetVelocity():Length() - wind_min_speed, 0, wind_max_speed)
	
	if speed > 0 then
		local pitch = speed / wind_pitch_divisor * 100 + 60
		local volume = math.min((speed / wind_pitch_divisor) ^ 1.2 * 2, 1)
		
		if wind_active then
			wind_sound:ChangePitch(pitch)
			wind_sound:ChangeVolume(volume)
		else
			wind_active = true
			
			wind_sound:PlayEx(volume, pitch)
		end
	elseif wind_active then
		wind_active = false
		
		wind_sound:Stop()
	end
end

--hooks
hook.Add("LocalPlayerInitialized", "stacker_player_wind", function(ply)
	local_player = ply
	wind_sound = CreateSound(ply, wind_path)
end)