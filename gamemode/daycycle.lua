---=== Day Night Cycle Code ===---

-- SET TO "false" TO DISABLE GAMEMODE DAY NIGHT IF YOU HAVE YOUR OWN MEME.
local customdaynight = true

-- Time variables. 1 Second irl = 1 Minute in game.
-- 1440 min irl for 1 ingame day cycle, (14 min)
local timeofday = 0
local daystart = 0

function initdaycycle()
	daystart = CurTime()
	
	
	
end

hook.Add("Initialize", "initoorpdaycycle", inidaycycle)



