--instead of some lame credits window or something, when you see someone who deserves credits in game they will have a special indicator
--orignally I thought I'd never put credits into addons, because it just feels out of place to me
--but after stencil core, gfl button restrictor, and a few other scripts, I want to start including credits
--unlike optimod that has a credation footer, I'm going to make a special glint and role text for each developer
--of course, I won't make them invasive
GM.StackerDeveloperCredation = {
	["NULL"] = { --for development only, don't actually use bots!
		Ready = Color(0, 160, 255),
		Role = "Bot"
	}, 
	
	["STEAM_0:1:72956761"] = {
		Color = Color(255, 190, 0), --name color
		Glint = Color(255, 224, 96), --glint color
		Ready = Color(255, 190, 0), --ready border color
		Role = "Gamemode Developer" --contributor's role in this gamemode's development
	}
}

--gamemode functions
function GM:StackerUICredationGetGlint(ply)
	local steam_id = ply:SteamID()
	local thanks = self.StackerDeveloperCredation[steam_id]
	
	if thanks then return thanks.Glint, thanks.Ready end
	
	return false
end

function GM:StackerUICredationGetNameColor(ply)
	local steam_id = ply:SteamID()
	local thanks = self.StackerDeveloperCredation[steam_id]
	
	if thanks then return thanks.Color end
	
	return false
end

function GM:StackerUICredationGetNameExtension(ply, concatenate)
	local steam_id = ply:SteamID()
	local thanks = self.StackerDeveloperCredation[steam_id]
	
	print(ply, steam_id, thanks)
	
	if thanks then
		if concatenate then
			if isstring(concatenate) then return ply:Nick() .. concatenate .. thanks.Role
			else return ply:Nick() .. "\n" .. thanks.Role end
		end
		
		return thanks.Role
	end
	
	return concatenate and ply:Nick() or false
end