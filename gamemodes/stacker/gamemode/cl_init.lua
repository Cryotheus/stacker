DEFINE_BASECLASS("gamemode_sandbox")
include("shared.lua")

--locals
local local_player = IsValid(LocalPlayer()) and LocalPlayer() or nil

--gamemode functions
function GM:InitPostEntity()
	BaseClass.InitPostEntity(self)
	
	net.Start("stacker_init")
	net.SendToServer()
	
	hook.Call("LocalPlayerInitialized", self, LocalPlayer())
	
	if self.StackerGameActive then --stuffs
	else hook.Call("StackerUIScreenOpenWait", self) end
end

function GM:LocalPlayerInitialized(ply) local_player = ply end
function GM:Think() if local_player then hook.Call("StackerPlayerWindThink", self, local_player) end end

--net
net.Receive("stacker_init", function()
	local ply_ent_index = net.ReadUInt(8)
	
	print("Player loaded in with ent index " .. ply_ent_index)
end)

--finish off with the rest of the scripts
include("loader.lua")