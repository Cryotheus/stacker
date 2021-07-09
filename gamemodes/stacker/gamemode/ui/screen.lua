function GM:StackerUIScreenOpenWait()
	local screen_panel = vgui.Create("StackerScreen", GetHUDPanel(), "StackerWaitScreen")
	local wait_list = vgui.Create("StackerWaitList", screen_panel)
	
	wait_list:SetWide(512)
end