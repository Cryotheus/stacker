DEFINE_BASECLASS("player_sandbox")

--locals
local PLAYER = {
	AvoidPlayers = false,
	CanUseFlashlight = false, --do we need it?
	DisplayName = "Parkourist",
	TeammateNoCollide = false,
	RunSpeed = 400,
	WalkSpeed = 200
}

--player functions
function PLAYER:Loadout()
	local ply = self.Player
	
	ply:RemoveAllItems()
	
	if GetGlobalBool("GMBuilding") then
		local weapon_physgun = ply:Give("weapon_physgun")
		
		ply:SetActiveWeapon(weapon_physgun)
	else end --give a parkour swep here? not one that changes movement capabilities
end

function PLAYER:SetupDataTables() BaseClass.SetupDataTables(self) end

--post
player_manager.RegisterClass("player_stacker", PLAYER, "player_sandbox")