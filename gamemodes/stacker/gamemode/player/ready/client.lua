--gamemode functions
function GM:StackerPlayerReady(ready)
	net.Start("stacker_ready")
	net.WriteBool(ready)
	net.SendToServer()
end

function GM:StackerPlayerReadyUpdate(game_ready) end

--net
--[[
net.Receive("stacker_ready", function()
	local game_ready = net.ReadBool()
	
	hook.Run("StackerPlayerReadyUpdate", game_ready)
end) --]]