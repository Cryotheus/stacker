--local variables
local enumerated_message_functions = {MsgC}

--setup
for hud_enum = 2, 4 do enumerated_message_functions[hud_enum] = function(text) LocalPlayer():PrintMessage(hud_enum, text) end end

--gamemode functions
function PYRITION:StackerLanguageAttemptFormat(key, fall_back, phrases)
	local text = language.GetPhrase(key)
	text = text == key and fall_back or text
	
	if phrases then return string.gsub(text, "%[%:(.-)%]", phrases)
	else return text end
end

function PYRITION:StackerLanguageFormat(key, phrases)
	if phrases then return string.gsub(language.GetPhrase(key), "%[%:(.-)%]", phrases)
	else return language.GetPhrase(key) end
end

function PYRITION:StackerLanguageMessage(ply, enumeration, key, phrases, ...)
	local text = phrases and hook.Call("StackerLanguageFormat", self, key, phrases) or language.GetPhrase(key)
	
	return enumerated_message_functions[enumeration](text, ...)
end

--net
net.Receive("stacker_message", function()
	local enumeration = net.ReadUInt(2) + 1
	local key = net.ReadString()
	
	print("got stacker_message with", enumeration, key)
	
	if net.ReadBool() then 
		local phrases = {}
		
		repeat phrases[net.ReadString()] = net.ReadString()
		until not net.ReadBool()
		
		hook.Call("StackerLanguageMessage", PYRITION, LocalPlayer(), enumeration, key, phrases)
	else hook.Call("StackerLanguageMessage", PYRITION, LocalPlayer(), enumeration, key) end
end)