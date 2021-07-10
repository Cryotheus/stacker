local PANEL = {}

--colors
local associated_colors = GM.UIColors.WaitList
local color_background = associated_colors.Background
local color_button = associated_colors.Button
local color_button_active = associated_colors.ButtonActive
local color_button_highlight = associated_colors.ButtonHighlight
local color_text_dark = associated_colors.TextDark
local color_text_light = associated_colors.TextLight

--panel functions
function PANEL:AddPlayer(ply, index)
	local player_entry = vgui.Create("StackerWaitListEntry", self)
	
	player_entry:Dock(TOP)
	player_entry:DockMargin(4, 0, 4, 4)
	player_entry:SetHeight(64)
	player_entry:SetPlayer(ply)
	player_entry:SetReady(ply:GetNWBool("GMReady"))
	player_entry:SetZPos(index or 1)
	
	self.Players[ply] = player_entry
end

function PANEL:Init()
	self.Players = {}
	
	do --banner panel
		local banner_panel = vgui.Create("DPanel", self)
		
		banner_panel:Dock(TOP)
		banner_panel:DockMargin(4, 4, 4, 4)
		banner_panel:SetHeight(64)
		
		do --waiting for players label
			local label = vgui.Create("DLabel", banner_panel)
			
			label:Dock(FILL)
			label:SetContentAlignment(5)
			label:SetFont("DermaLarge")
			label:SetText("WAITING FOR PLAYERS")
			label:SetTextColor(color_text_light)
			
			function label:Think()
				if GetGlobalBool("GMTimerActive") then self:SetText("STARTING IN " .. math.max(math.ceil(GetGlobalFloat("GMTimer") - CurTime()), 0))
				else self:SetText("WAITING FOR PLAYERS") end
			end
		end
		
		function banner_panel:Paint(width, height)
			surface.SetDrawColor(color_background)
			surface.DrawRect(0, 0, width, height)
		end
		
		self.BannerPanel = banner_panel
	end
	
	--player entries
	for index, ply in ipairs(player.GetAll()) do self:AddPlayer(ply, index) end
	
	do --ready button
		surface.SetFont("DermaLarge")
		
		local button = vgui.Create("DButton", self)
		local text_width, text_height = surface.GetTextSize("READY UP NOT READY")
		
		function button:DoClick() hook.Run("StackerPlayerReady", not self.Ready) end
		
		function button:Paint(width, height)
			if self.Hovered then
				self:SetTextColor(self.Ready and color_button_active or color_button)
				surface.SetDrawColor(color_button_highlight)
			else
				self:SetTextColor(color_button_highlight)
				surface.SetDrawColor(self.Ready and color_button_active or color_button)
			end
			
			surface.DrawRect(0, 0, width, height)
		end
		
		function button:SetReady(ready)
			self.Ready = ready
			
			if self.Ready then button:SetText("NOT READY")
			else button:SetText("READY UP") end
		end
		
		button:Dock(TOP)
		button:DockMargin(4, 0, 4, 4)
		button:SetFont("DermaLarge")
		button:SetHeight(text_height + 8)
		button:SetReady(LocalPlayer():GetNWBool("GMReady"))
		button:SetZPos(256)
		
		self.ReadyButton = button
	end
end

function PANEL:PerformLayout(width, height)
	self:Center()
	self:SizeToChildren(false, true)
end

function PANEL:Think()
	local local_player = LocalPlayer()
	
	--clean up old players
	for ply, player_entry in pairs(self.Players) do
		if IsValid(ply) then
			local ready = ply:GetNWBool("GMReady")
			
			if player_entry.Ready ~= ready then player_entry:SetReady(ply:GetNWBool("GMReady")) end
			if ply == local_player then self.ReadyButton:SetReady(ready) end
		else
			player_entry:Remove()
			
			self.Players[ply] = nil
		end
	end
	
	--add missing players
	for index, ply in ipairs(player.GetAll()) do
		if self.Players[ply] then continue end
		
		self:AddPlayer(ply, index)
	end
end

--post
derma.DefineControl("StackerWaitList", "List of all players for when a game has yet to start.", PANEL, "DSizeToContents")