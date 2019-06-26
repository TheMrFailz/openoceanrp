--[[ NOTE:
	If you've been snooping around in other files, you've probably noticed by now that there's
	an awful lot of copy pasting going on between market types (smuggling, plants, etc. are all derived
	from fishing as their base). As such assume any references to other market types in the wrong file
	are unintentional.

	

]]

-- format: Crop name, model, base price, current price, model zoom out

-- Set current price when making a new fish to the same as base price. Will adjust based on sales.
-- Programmers note: Please keep crabs at the end of the fisht able. Also, you'll need to modify 
-- fish nets if you add more crabs.

 
planttable = {
	{"Bananas", "models/props/cs_italy/bananna_bunch.mdl", 30, 30, 8},
}


-- format: Equipment name, model, entity class, price, model material (defaults to model texture)
plantequipmenttable = {
	{"Water Bottle", "models/props/cs_office/water_bottle.mdl", "", 1, ""},


}

net.Receive("PMRequestPlantTable", function(len, ply)
	local seller = net.ReadEntity()
	

	
	net.Start("PMSendPlantTable")
		net.WriteTable(planttable)
		net.WriteTable(plantequipmenttable)

		if seller:FindNearestBox(ply) != nil then
			net.WriteTable(seller:FindNearestBox(ply).contents)
		else
			local niltable = {}
			net.WriteTable(niltable)
		end

	net.Send(ply)
end)
 
net.Receive("BXRequestPlantTable", function(len, ply)
	local box = net.ReadEntity()
	net.Start("BXSendPlantTable")
		net.WriteTable(planttable)
		net.WriteTable(box.contents)
	net.Send(ply)
end)


