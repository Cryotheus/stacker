local material_blur = Material("pp/blurscreen")
local PANEL = {}

--panel functions
function PANEL:Init()
	self.Blur = true
	self.BlurColor = Color(10, 10, 10, 200)
	self.BlurDividend = 5
	self.BlurPasses = 3
	
	self:Dock(FILL)
	self:MakePopup(true)
	self:SetKeyBoardInputEnabled(false)
	
	do --close button
		surface.SetFont("DermaDefault")
		
		local close_button = vgui.Create("DButton", self)
		local text_width, text_height = surface.GetTextSize("CLOSE")
		
		close_button:SetSize(text_width + 16, text_height + 8)
		close_button:SetText("CLOSE")
		
		function close_button:DoClick() self:GetParent():Remove() end
		
		self.CloseButton = close_button
	end
end

function PANEL:Paint(width, height)
	if self.Blur then
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(material_blur)
		
		for blur_divisor = 1, self.BlurPasses do
			material_blur:SetFloat("$blur", self.BlurDividend / blur_divisor)
			material_blur:Recompute()
			
			render.UpdateScreenEffectTexture()
			surface.DrawTexturedRect(0, 0, width, height)
		end
		
		surface.SetDrawColor(self.BlurColor)
		surface.DrawRect(0, 0, width, height)
	end
end

function PANEL:PerformLayout(width, height)
	local close_button = self.CloseButton
	
	close_button:SetPos(width - close_button:GetWide(), 0)
end

--post
derma.DefineControl("StackerScreen", "For important Stacker panels, has a convenient blur feature.", PANEL, "DPanel")