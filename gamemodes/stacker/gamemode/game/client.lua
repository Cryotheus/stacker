function GM:StackerGameStart(player_indices)
	hook.Call("StackerUIScreenOpenOrder", self)
	
	PrintTable(player_indices, 1)
end