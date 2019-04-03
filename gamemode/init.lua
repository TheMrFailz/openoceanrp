hook.Run("DarkRPStartedLoading")

GM.Version = "1.0.0"
GM.Name = "OpenOceanRP"
GM.Author = ""

DeriveGamemode("darkrp")
DEFINE_BASECLASS("gamemode_darkrp")

GM.DarkRP = BaseClass

-- Include files --
include("fishfile.lua")
include("npcspawn.lua")
include("smuggling.lua")
include("boatsales.lua")
include("daycycle.lua")

AddCSLuaFile("fishmarketui.lua")
AddCSLuaFile("fishpotui.lua")
AddCSLuaFile("fishboxui.lua")
AddCSLuaFile("crabpotui.lua")
AddCSLuaFile("smugglinggui.lua")
AddCSLuaFile("boatgui.lua")

-- Variables.
local enablemaptele = false
local sunthing = false
local testvar = 0
local raisedelay = 120
local raisedelaytime = 0
local raisemount = 0.5




-- Net library caching
util.AddNetworkString("openfishpot")
util.AddNetworkString("openfishbox")
util.AddNetworkString("transfishpot")
util.AddNetworkString("trashfishbox")
util.AddNetworkString("sellfishbox")
util.AddNetworkString("marketopen") -- remove

-- Fish market stuff
util.AddNetworkString("FMRequestFishTable")
util.AddNetworkString("FMSendFishTable")
util.AddNetworkString("FMPurchaseRequest")
util.AddNetworkString("FMPurchaseSpawn")
util.AddNetworkString("FMOpenGUI")
util.AddNetworkString("FMSellRequest")

-- Similar, Fish Pot UI
util.AddNetworkString("PTRequestFishTable")
util.AddNetworkString("PTSendFishTable")
util.AddNetworkString("PTDumpFish")
util.AddNetworkString("PTOpenGUI")
util.AddNetworkString("PTDeploy")

-- Fish box UI, basically copy paste of above but reusing a few funcs.
util.AddNetworkString("BXOpenGUI")

-- Crab pot
util.AddNetworkString("CPOpenGUI")
util.AddNetworkString("CPDumpCrab")
util.AddNetworkString("CPRequestCrabTable")
util.AddNetworkString("CPDeploy")
util.AddNetworkString("CPSendCrabTable")

-- Smuggling UI info
util.AddNetworkString("RequestSmuggleTable")
util.AddNetworkString("SendSmuggleTable")
util.AddNetworkString("SMOpenGUI")
util.AddNetworkString("SMOpenGUI2")
util.AddNetworkString("SMSellRequest")
util.AddNetworkString("SMBuyRequest")

-- Vehicle Sales UI
util.AddNetworkString("RequestVehicleTable")
util.AddNetworkString("SendVehicleTable")
util.AddNetworkString("VSOpenGUI")
util.AddNetworkString("VSBuyRequest")
util.AddNetworkString("VSPurchaseRequest")


util.AddNetworkString("skyboxupdatething")

-- Natural raise of market value.
function raisemarketval()

	if raisedelaytime < CurTime() then
		raisedelaytime = CurTime() + raisedelay
		for i = 1, table.Count(fishtable) do
			
			if fishtable[i][6] < fishtable[i][5] * 1.25 && fishtable[i][6] + raisemount < fishtable[i][5] * 1.35 then
				fishtable[i][6] = math.Round(fishtable[i][6] + raisemount)
				
			end
		end 
		
	end
end

hook.Add("Think", "marketvalueraiser", raisemarketval)

-- Lower the market value of a fish.
function lowermarketval(fishint, quantity)
	-- Change this value to a decimal of your choice to lower fish value. 0.1 is $1 every ten fish.
	-- 0.5 is $1 every 2 fish. Keep this low or grinders will slaughter fish prices. 
	-- Cannot go below 25% of the original value.
	local devaluemult = 0.1

	if fishtable[fishint][6] > fishtable[fishint][5] * 0.25 && fishtable[fishint][6] - (quantity * devaluemult) > fishtable[fishint][5] * 0.25 then
		fishtable[fishint][6] = math.Round(fishtable[fishint][6] - (quantity * devaluemult))
	end
	
end

function transfercontents(pot)
	
	local possibleboxes = ents.FindInSphere(pot:GetPos(), 130)
	local possibleboxesclean = {}
	for i = 1, table.Count(possibleboxes) do
		if possibleboxes[i]:GetClass() == "fishbox" then
			table.insert(possibleboxesclean, possibleboxes[i])
		end
	end

	
	if possibleboxesclean[1] != nil then
		local box = possibleboxesclean[1]

		PrintTable(pot.contents)

		local overflow = box:FillStuff(pot.contents)
		table.Empty(pot.contents)
		pot.contents = table.Copy(overflow)
		pot:EmptyBoxContents()
	else
		--print("no boxes near!")
		
	end
end

function trashfishbox(box)
	-- This should work fine with either pots or boxes.
	print("emptying box/pot")
	
	box:EmptyBoxContents()

end



function sellfish(box, ply)
	local boxprice = 0

	for i = 1, table.Count(box.contents) do
		boxprice = boxprice + fishtable[i][6] * box.contents[i][2]
		lowermarketval(i, box.contents[i][2])
		
	end

	box:EmptyBoxContents()
	ply:addMoney(boxprice)
	DarkRP.notify(ply, 0, 3, "You made $" .. boxprice)
end


-- GUI related



net.Receive("FMSellRequest", function(len, ply)
	local seller = net.ReadEntity()
	sellfish(seller:FindNearestBox(ply), ply)
	
end)

net.Receive("transfishpot", function(len, ply)
	local pottotrans = net.ReadEntity()
	transfercontents(pottotrans)
end)

net.Receive("trashfishbox", function(len, ply)
	local pottotrash = net.ReadEntity()
	trashfishbox(pottotrash)
end)

concommand.Add("skyboxtest", function(ply, cmd, args)
	--[[
	for i = 97, 121 do
		print("The number " .. i .. " is the letter " .. string.char(i))
		
	end
	]]

	if sunthing == false then
		sunthing = true
		engine.LightStyle(0, "a")
		net.Start("skyboxupdatething")
		net.Broadcast()
		
	else
		sunthing = false
		engine.LightStyle(0, "m")
		net.Start("skyboxupdatething")
		net.Broadcast()
	end

	
	
end)

net.Receive("FMPurchaseRequest", function(len, ply)
	local seller = net.ReadEntity()
	local entitynum = net.ReadInt(32)

	local moneyhad = ply:getDarkRPVar("money")
	local moneycost = fishingequipmenttable[entitynum][4]
	
	if moneyhad - moneycost >= 0 then
		seller:SpawnPurchase(ply, fishingequipmenttable[entitynum][3])
		ply:addMoney(-moneycost)
		DarkRP.notify(ply, 0, 3, "You paid $" .. moneycost)
	end
	
end)

net.Receive("PTDumpFish", function(len, ply)
	local box = net.ReadEntity()
	local fishint = net.ReadInt(32)
	
	if box:CPPIGetOwner() == ply then
		box.contents[fishint][2] = 0

		if box.fishents != nil then
			local contentcount = table.Count(box.fishents)
		
			local fishtablecount = table.Count(fishtable)

			for i = 1, contentcount do
				local invertedi = contentcount - (i - 1)
				--PrintTable(box.fishents)
				--print("i'm at " .. i .. " and inverted " .. invertedi)
				
				
				if box.fishents[invertedi]:IsValid() then
					if box.fishents[invertedi]:GetModel() == fishtable[fishint][2] then
						box.fishents[invertedi]:Remove()
						table.RemoveByValue(box.fishents, invertedi)
					end
				end
				
				
			end
		end
	end
	
	
end)

net.Receive("PTDeploy", function(len, ply)
	local pottodeploy = net.ReadEntity()
	
	if pottodeploy:CPPIGetOwner() == ply then
		if pottodeploy.deployed != true then 
			pottodeploy.deployed = true
			pottodeploy:makefloater(Color(255,0,0,255))
		end
	end
	
end)

--hrp_harbor2ocean_v1