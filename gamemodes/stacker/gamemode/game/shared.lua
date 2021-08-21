local team_no_clip_checks = {
	[TEAM_PARKOURIST] = function(ply, desire) return not desire end, --let them exit
	[TEAM_BUILDER] = function(ply, desire) return true end, --let them do whatever
	[TEAM_SPECTATOR] = function(ply, desire) return desire end --let them enter
}

--globals
TEAM_PARKOURIST = 1
TEAM_BUILDER = 2

--gamemode functions
function GM:CreateTeams()
	team.SetUp(TEAM_PARKOURIST, "Parkourist", Color(255, 255, 255), false)
	team.SetUp(TEAM_BUILDER, "Builder", Color(192, 224, 255), false)
end

function GM:PlayerNoClip(ply, desire)
	local check_function = team_no_clip_checks[ply:Team()]
	
	if check_function then check_function(ply, desire)
	else return false end
end