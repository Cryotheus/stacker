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
	local entry_container = vgui.Create("DPanel", self)
	
	entry_container:Dock(TOP)
	entry_container:DockMargin(4, 0, 4, 4)
	entry_container:SetHeight(64)
	entry_container:SetZPos(index or 1)
	
	function entry_container:Paint() end
	
	--index label
	do
		local label = vgui.Create("DLabel", entry_container)
		
		label:Dock(LEFT)
		label:SetContentAlignment(5)
		label:SetFont("DermaLarge")
		label:SetText("##" .. (index or 1))
		label:SetTextColor(index == 1 and color_white or color_text_light)
		label:SetWidth(64)
		
		function label:Paint(width, height)
			surface.SetDrawColor(color_background)
			surface.DrawRect(0, 0, width, height)
		end
		
		entry_container.IndexLabel = label
	end
	
	--player entry
	do
		local player_entry = vgui.Create("StackerWaitListEntry", entry_container)
		
		player_entry:Dock(FILL)
		player_entry:DockMargin(4, 0, 0, 0)
		player_entry:SetPlayer(ply)
		player_entry:SetReady(true)
		
		entry_container.PlayerEntryPanel = player_entry
	end
	
	self.Players[ply] = entry_container
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
			label:SetText("DRUM ROLL PLEASE")
			label:SetTextColor(color_text_light)
		end
		
		function banner_panel:Paint(width, height)
			surface.SetDrawColor(color_background)
			surface.DrawRect(0, 0, width, height)
		end
		
		self.BannerPanel = banner_panel
	end
	
	--player entries
	for index, ply in ipairs(GAMEMODE.StackerGameOrder) do self:AddPlayer(ply, index) end
end

function PANEL:PerformLayout(width, height)
	self:Center()
	self:SizeToChildren(false, true)
end

--post
derma.DefineControl("StackerPlayerOrder", "List of players in the order they take turns.", PANEL, "DSizeToContents")