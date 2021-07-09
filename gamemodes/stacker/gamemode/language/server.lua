util.AddNetworkString("stacker_message")

--gamemode functions
function GM:StackerLanguageAttemptFormat(key, text, phrases)
	if phrases then return string.gsub(text, "%[%:(.-)%]", phrases)
	else return text end
end

function GM:StackerLanguageSend(target, enumeration, key)
	net.Start("stacker_message")
	net.WriteUInt(enumeration - 1, 2)
	net.WriteString(key)
	
	if target then net.Send(target)
	else net.Broadcast() end
end

function GM:StackerLanguageSendFormat(target, enumeration, key, phrases)
	if istable(key) then
		phrases = key
		key = key.key
	end
	
	net.Start("stacker_message")
	net.WriteUInt(enumeration - 1, 2)
	net.WriteString(key)
	
	for tag, phrase in pairs(phrases) do
		net.WriteBool(true)
		net.WriteString(tag)
		net.WriteString(phrase)
	end
	
	if target then net.Send(target)
	else net.Broadcast() end
end

PYRITION.StackerLanguageMessage = PYRITION.StackerLanguageSendFormat