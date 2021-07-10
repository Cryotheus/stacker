local PANEL = {}

--colors
local associated_colors = GM.UIColors.WaitList
local color_background = associated_colors.Background
local color_text_light = associated_colors.TextLight

--local functions
local function name_refresh_think(self)

end

--panel functions
function PANEL:Init()
	self:DockPadding(4, 4, 4, 4)
	
	do --avatar panel
		local avatar_panel = vgui.Create("StackerWaitListAvatar", self)
		
		avatar_panel:Dock(LEFT)
		
		self.AvatarPanel = avatar_panel
	end
	
	do --name label
		local label = vgui.Create("DLabel", self)
		
		label:Dock(FILL)
		label:DockMargin(4, 0, 0, 0)
		label:SetFont("Trebuchet24")
		label:SetText("unknown")
		
		self.Label = label
	end
end

function PANEL:Paint(width, height)
	surface.SetDrawColor(color_background)
	surface.DrawRect(0, 0, width, height)
end

function PANEL:PerformLayout(width, height)
	local avatar_panel = self.AvatarPanel
	
	avatar_panel:SetWide(avatar_panel:GetTall())
end

function PANEL:SetPlayer(ply)
	if IsValid(ply) then --update name here too
		self.Player = ply
		
		if ply:GetName() == "unconnected" then self.Think = self.NameRefreshThink end
		
		self.AvatarPanel:SetPlayer(ply)
		self.Label:SetText(hook.Run("StackerUICredationGetNameExtension", ply, true))
		self.Label:SetTextColor(hook.Run("StackerUICredationGetNameColor", ply) or color_text_light)
	else
		self.NeedsNameRefresh = false
		self.Player = nil
		self.Think = nil
		
		self.Label:SetText("invalid")
	end
end

function PANEL:SetReady(ready)
	self.Ready = ready
	self.AvatarPanel.Ready = ready
end

function PANEL:NameRefreshThink()
	local ply = self.Player
	
	if IsValid(ply) then
		if ply:Nick() == "unconnected" then return end
		
		self:SetPlayer(ply)
	else self:SetPlayer() end
end

--post
derma.DefineControl("StackerWaitListEntry", "A player's entry for the StackerWaitList panel.", PANEL, "DPanel")