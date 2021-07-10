local current_screen

--gamemode functions
function GM:StackerUIScreenClose()
	current_screen:Remove()
	
	current_screen = nil
end

function GM:StackerUIScreenGet() return current_screen end

function GM:StackerUIScreenOpenOrder()
	if current_screen then current_screen:Remove() end
	
	current_screen = vgui.Create("StackerScreen", GetHUDPanel(), "StackerWaitScreen")
	local game_order = vgui.Create("StackerPlayerOrder", current_screen)
	
	game_order:SetWide(512)
end

function GM:StackerUIScreenOpenWait()
	if current_screen then current_screen:Remove() end
	
	current_screen = vgui.Create("StackerScreen", GetHUDPanel(), "StackerWaitScreen")
	local wait_list = vgui.Create("StackerWaitList", current_screen)
	
	wait_list:SetWide(512)
end