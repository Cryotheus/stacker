SetGlobalBool("GMTimerActive", false)
SetGlobalFloat("GMTimer", 0)

--locals
local timer_active = false
local timer_target = 0

--gamemode functions
function GM:StackerTimerDeduct(time, minimum)
	if not timer_active then return end
	
	if minimum then if timer_target > minimum then hook.Call("StackerTimerSet", self, math.max(time - timer_target, minimum)) end
	else hook.Call("StackerTimerSet", self, timer_target - time) end
end

function GM:StackerTimerFinished(call_back)
	timer_active = false
	
	if isfunction(call_back) then call_back()
	elseif isstring(call_back) then hook.Call(call_back, self) end
	if timer_active then return end
	
	timer_target = 0
	
	SetGlobalBool("GMTimerActive", timer_active)
	SetGlobalFloat("GMTimer", timer_target)
end

function GM:StackerTimerReduce(time, allow_start)
	if timer_active then if time < timer_target then hook.Call("StackerTimerSet", self, time) end
	elseif allow_start then hook.Call("StackerTimerStart", self, time) end
end

function GM:StackerTimerSet(time)
	timer_target = time
	
	SetGlobalFloat("GMTimer", timer_target)
end

function GM:StackerTimerSetCallback(call_back) self.StackerTimerCallback = (isstring(call_back) or isfunction(call_back)) and call_back or nil end

function GM:StackerTimerStart(time, restart)
	timer_active = true
	
	hook.Call("StackerTimerSet", self, time)
	SetGlobalBool("GMTimerActive", timer_active)
end

function GM:StackerTimerStop()
	timer_active = false
	
	SetGlobalBool("GMTimerActive", timer_active)
end

function GM:StackerTimerThink() if CurTime() > timer_target then hook.Call("StackerTimerFinished", self, self.StackerTimerCallback) end end

--hooks
hook.Add("Think", "stacker_timer", function() if timer_active then hook.Run("StackerTimerThink") end end)