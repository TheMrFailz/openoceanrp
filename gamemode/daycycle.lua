---=== Day Night Cycle Code ===---

-- SET TO "false" TO DISABLE GAMEMODE DAY NIGHT IF YOU HAVE YOUR OWN MEME.
local customdaynight = true

-- Time variables. 1 Second irl = 1 Minute in game.
-- 1440 min irl for 1 ingame day cycle, (14 min)
local timeofday = 0
local daystart = 0

-- These variables control the "sunrise" periods start and end.
local morningstart = 360 -- Roughly 6 am
local morningend = 420 -- Roughly 7 am

--[[
local morningstart = 360 -- Roughly 6 am
local morningend = 420 -- Roughly 7 am



]]

local sunsetstart = 1080 -- roughly 6pm
local sunsetend = 1140 -- roughly 7pm

--[[
local sunsetstart = 1080 -- roughly 6pm
local sunsetend = 1140 -- roughly 7pm



]]

-- Sun Editor Ent because lolhackyshit
local sunpointer
local skysetter

-- default sky settings
--[[
	topcolor .2 .5 1
	botcolor .8 1 1
	fadebias 1
	hdrscale .66
	
	duskcolor 1 .2 0
	
	
]]


function initdaycycle()
	if customdaynight == true then
		daystart = CurTime()

		sunpointer = ents.Create("edit_sun")
		sunpointer:SetPos(Vector(4192.000000, 11184.000000, 14924.000000))
		sunpointer:SetAngles(Angle(0,0,0))
		sunpointer:Spawn()

		skysetter = ents.Create("edit_sky")
		skysetter:SetPos(Vector(4192.000000, 11184.000000, 15624.000000))
		skysetter:Spawn()
		

	end

end

hook.Add("InitPostEntity", "initoorpdaycycle", initdaycycle)



local lightletter = "a"

local function customlerpskymorn(startval, endval)
	local lerpiter = ((timeofday - (morningend - morningstart)) / (morningend - morningstart)) % 1

	local currentval = Lerp(lerpiter, startval, endval)
	
	if math.Round(lerpiter, 1) == 0.3 && lightletter == "a" then
		lightletter = "d"
		engine.LightStyle(0, lightletter)
		net.Start("skyboxupdatething")
		net.Broadcast()

		print("I AM STARTING TO LIGHT")

	end

	if math.Round(lerpiter, 1) == 0.6 && lightletter == "d" then
		lightletter = "h"
		engine.LightStyle(0, lightletter)
		net.Start("skyboxupdatething")
		net.Broadcast()

		print("I AM STARTING TO LIGHT2")

	end



	if math.Round(lerpiter, 1) == 0.9 && lightletter == "h" then
		lightletter = "m"
		engine.LightStyle(0, lightletter)
		net.Start("skyboxupdatething")
		net.Broadcast()
	
		print("I AM STARTING TO LIGHT3")


	end


	return currentval
end

local function customlerpskyeve(endval, startval)
	local lerpiter = ((timeofday - (sunsetend - sunsetstart)) / (sunsetend - sunsetstart)) % 1

	local currentval = Lerp(lerpiter, startval, endval)
	
	if math.Round(lerpiter, 1) == 0.3 && lightletter == "m" then
		lightletter = "h"
		engine.LightStyle(0, lightletter)
		net.Start("skyboxupdatething")
		net.Broadcast()
		
		
	
		
	end

	if math.Round(lerpiter, 1) == 0.6 && lightletter == "h" then
		lightletter = "d"
		engine.LightStyle(0, lightletter)
		net.Start("skyboxupdatething")
		net.Broadcast()
		
		
	
		
	end

	if math.Round(lerpiter, 1) == 0.8 && lightletter == "d" then
		lightletter = "a"
		engine.LightStyle(0, lightletter)
		net.Start("skyboxupdatething")
		net.Broadcast()

		

	end
	return currentval
end

function sunsequencer()
	if customdaynight == true && sunpointer != nil then
		if sunpointer:IsValid() then
		local time2ang = (CurTime() - daystart) / 4
		timeofday = (CurTime() - daystart)
		sunpointer:SetAngles(Angle(time2ang + 90,90,0))
		
		if timeofday > morningstart && timeofday < morningend then
			-- Lerp(1 + ((timeofday - morningend) / morningend), 0, 0.2)


			skysetter:SetTopColor(Vector(customlerpskymorn(0,0.2), customlerpskymorn(0,0.5), customlerpskymorn(0,1)))
			skysetter:SetBottomColor(Vector(customlerpskymorn(0,0.8), customlerpskymorn(0,1), customlerpskymorn(0,1)))
			skysetter:SetDuskColor(Vector(customlerpskymorn(0,1), customlerpskymorn(0,0.2), 0))
			
		end

		if timeofday > sunsetstart && timeofday < sunsetend then
			-- Lerp(1 + ((timeofday - morningend) / morningend), 0, 0.2)


			skysetter:SetTopColor(Vector(customlerpskyeve(0,0.2), customlerpskyeve(0,0.5), customlerpskyeve(0,1)))
			skysetter:SetBottomColor(Vector(customlerpskyeve(0,0.8), customlerpskyeve(0,1), customlerpskyeve(0,1)))
			skysetter:SetDuskColor(Vector(customlerpskyeve(0,1), customlerpskyeve(0,0.2), 0))
			
		end

		if timeofday > morningend && timeofday < sunsetstart then
			skysetter:SetTopColor(Vector(0.2, 0.5, 1))
			skysetter:SetBottomColor(Vector(0.8, 1, 1))
			skysetter:SetDuskColor(Vector(1, 0.2, 0))
			
		end
		
		if timeofday > sunsetend || timeofday < morningstart then
			--skysetter:SetTopColor(0.02, 0.02, 0.02)
			skysetter:SetTopColor(Vector(0,0,0))
			skysetter:SetBottomColor(Vector(0, 0, 0))
			skysetter:SetDuskColor(Vector(0.02, 0.02, 0.02))


		end

		--print("Curtime is " .. timeofday)
		
		if timeofday >= 1440 then
			daystart = CurTime()
			print("New day!")
		end
		end
	end
end
hook.Add("Think", "initoorpdaycycle", sunsequencer)


