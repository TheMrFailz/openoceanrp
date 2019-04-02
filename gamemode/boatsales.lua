--[[
	Boat sales file and code



]]

-- Format: Vehicle name, vehicle class, vehicle model, cost, Vehicle type: 1 = sea, 2 = sea (large), 3 = air (vtol/heli), 4 = seaplane
--  Quick description blurb, zoom.
vehiclesaleslist = {
	{"Airboat", "prop_vehicle_airboat", "models/airboat.mdl", 1, 1, "It floats.", 140},
	{"DemoCopter", "wac_hc_r22", "models/r22/r22bodi.mdl", 1, 3, "Zoomy", 140}
	
}

-- Format: Name (for human reference), Position Vector, Angle, Vehicle Type (see above).

vehiclespawnlocationsoorp = {
	{"spawnpos1", Vector(-13487.278320, 13298.740234, 94.009682), Angle(0,-90,0), 1},
	{"spawnpos2", Vector(-13496.604492, 13013.955078, 94.009682), Angle(0,-90,0), 1},
	{"spawnpos3", Vector(-13489.007813, 12705.968750, 67.320343), Angle(0,-90,0), 1},
	{"spawnpos4", Vector(-13483.983398, 12443.502930, 67.320343), Angle(0,-90,0), 1},
	{"spawnpos5", Vector(-13426.842773, 11998.658203, 93.481407), Angle(0,-90,0), 1},
	{"spawnpos6", Vector(-13422.105469, 11751.190430, 93.481407), Angle(0,-90,0), 1},
	{"spawnpos7", Vector(-14007.520508, 10499.400391, 106.724686), Angle(0,-90,0), 2},
	{"helispawn1", Vector(-14329.724609, 9741.215820, 325.639709), Angle(0,-180,0), 3},
	{"helispawn2", Vector(-13510.600586, 9756.084961, 264.693359), Angle(0,-180,0), 3},
	{"helispawn3", Vector(-12543.856445, 10005.884766, 319.166962), Angle(0,-135,0), 3},
	{"planespawn1", Vector(-13842.843750, 9125.477539, 91.802620), Angle(0,-180,0), 4},
}

net.Receive("RequestVehicleTable", function(len, ply)

	net.Start("SendVehicleTable")
		net.WriteTable(vehiclesaleslist)
	net.Send(ply)
end)


function buyvehicle(seller, ply, vehicleint)
	if not playervehicletable[ply:SteamID()] then
		print("Player not found!")

		return
	else
		if table.HasValue(playervehicletable[ply:SteamID()], vehiclesaleslist[vehicleint][1]) then 
			seller:SpawnPurchase(ply, vehicleint)
		else
			print("You don't own that!")
		end
		
	end
	
end



net.Receive("VSBuyRequest", function(len, ply)

	local contraint = net.ReadInt(32, 1)
	local seller = net.ReadEntity()


	buyvehicle(seller, ply, contraint)
	
end)

function purchasevehicle(ply, vehicleint)
	if not playervehicletable[ply:SteamID()] then
		DarkRP.notify(ply, 0, 3, "We don't have a file on you for some reason.")

		return
	else
		if ply:getDarkRPVar("money") - vehiclesaleslist[vehicleint][4] >= 0 then
			if table.HasValue(playervehicletable[ply:SteamID()], vehiclesaleslist[vehicleint][1]) then
				
				DarkRP.notify(ply, 0, 3, "You already own that!")
				
				
			else
				table.insert(playervehicletable[ply:SteamID()], vehiclesaleslist[vehicleint][1])
				ply:addMoney(-vehiclesaleslist[vehicleint][4])
				DarkRP.notify(ply, 0, 3, "You paid $" .. vehiclesaleslist[vehicleint][4])
				
				saveplayervehiclesdata()
			end
			
			
		
		end
	end
end

net.Receive("VSPurchaseRequest", function(len, ply)

	local vehint = net.ReadInt(32, 1)
	
	purchasevehicle(ply, vehint)
	
	
end)

------File storage

-- format (DONT TOUCH THE VAR BELOW): {[steamid] {vehiclename, vehiclename}
-- text: steamid;vehiclename;vehiclename;etc.
playervehicletable = {}

function readplayervehiclesdata()
	print("Starting to load player data...")
	local bigdata = file.Read("player_vh_data.txt", "DATA")
	if not bigdata then 
		print("Data file not found!")
		return
	else
		print("Found player data file!")
	end

	bigdata = string.Split( bigdata, "|" )
	

	for i = 1, table.Count( bigdata ) do
		local args = string.Split(bigdata[i], ";")
		
		local steamidkey = args[1]
		playervehicletable[steamidkey] = {}
		
		for d = 1, table.Count(args) do
			if d != 1 then
				
				playervehicletable[steamidkey][d-1] = args[d]
			end
			
		end
	end
	print("Finished loading player data.")
	

end
hook.Add("Initialize", "readplayerstuff", readplayervehiclesdata)

function saveplayervehiclesdata()
	local bigdata = file.Read("player_vh_data.txt", "DATA")
	local finalwritestring = ""
	if not bigdata then 
		print("Data file not found! Creating...")

		file.Write("player_vh_data.txt", "")

		local bigdata2 = file.Read("player_vh_data.txt", "DATA")

		if not bigdata2 then
			print("Couldn't make the file for some reason...")
		else
			print("Success!")
		end

	else
		print("Found the file!")
		
		for id, args in pairs(playervehicletable) do
			local playerstring = ""
			playerstring = playerstring .. id
			
			for _, arg in pairs( args ) do
				playerstring = playerstring .. ";" .. arg
				--playerstring = playerstring + playervehicletable[i][d] + ";"
				
			end	

			playerstring = playerstring .. "|"
			finalwritestring = finalwritestring .. playerstring
		end 
		
		
		file.Write("player_vh_data.txt", finalwritestring)
	end

	
	
end

function checkplayerveh(ply)
	PrintTable(playervehicletable)
	if not playervehicletable[ply:SteamID()] then
		print("Player data not found! Creating...")

		playervehicletable[ply:SteamID()] = {}
	else
		DarkRP.notify(ply, 0, 3, "Loaded purchased vehicles.")
	end
	
	
end
hook.Add("PlayerInitialSpawn", "checkplayervehi", checkplayerveh)




concommand.Add("checkplayerdata", function(ply, cmd, args)
	checkplayerveh(ply)
end)
concommand.Add("saveplayerdata", function(ply, cmd, args)
	saveplayervehiclesdata()
	
end)
concommand.Add("readplayerdata", function(ply, cmd, args)
	readplayervehiclesdata()
	
end)

