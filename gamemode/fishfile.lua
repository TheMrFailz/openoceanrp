--[[ NOTE:
	Half way through writing this I decided to do different tables for different pot types
	"sorta". Normal fish pots and micro pots will have the same table (fishtable), but
	megapots, nets, and meganets will have unique tables (again, sort of). Megapots will
	combine normal pots tables and net tables, and nets will use their own unique table.

	Why? Simple:
	Big pots can catch big fish, small pots cannot. I don't want someone catching halibut
	in their glorified hairnet and I don't want someone catching sardines in their shipping
	container sized pot. Also, for price / fish intake balancing. I plan on doing multipliers
	for bigger pots and nets to balance their buy in cost but if single fish prices apply there 
	then they're gonna get really op really quick. I figure if I do something like 2x fish but
	0.75x fish price then whatever. Also, I don't want certain fish coming up in pots period,
	namely sardines and other high volume fish.

]]

-- format: fish name, model, min depth, max depth,  base price, current price, model zoom out

-- Set current price when making a new fish to the same as base price. Will adjust based on sales.
-- Programmers note: Please keep crabs at the end of the fisht able. Also, you'll need to modify 
-- fish nets if you add more crabs.


fishtable = {

	{"Bitterling", "models/tsbb/fishes/bitterling.mdl", 0, 100, 30, 30, 8},
	{"Gold Fish", "models/props/de_inferno/goldfish.mdl", 50, 220, 34, 34, 11},
	{"Snapper", "models/props/cs_militia/fishriver01.mdl", 220, 400, 50, 50, 10},
	{"Loach", "models/tsbb/fishes/loach.mdl", 400, 600, 60, 60, 14},
	{"Goby", "models/tsbb/fishes/goby.mdl", 600, 800, 68, 68, 15},
	{"Catfish", "models/tsbb/fishes/catfish.mdl", 2500, 2700, 120, 120, 38},
	{"Euro Carp", "models/tsbb/fishes/carp.mdl", 1300, 1800, 80, 80, 30},
	{"", "model", 4300, 4300, 10, 10, 15},
	{"Ghost Crab", "models/crab.mdl", 500, 1800, 25, 25, 8},
	{"Tasmanian Crab", "models/tsbb/animals/tasmanian_crab.mdl", 1900, 2100, 25, 25, 20},
	{"HS Crab", "models/tsbb/animals/horseshoe_crab2.mdl", 3000, 3300, 25, 25, 20}
}

fishtablesearch = {}


-- format: Equipment name, model, entity class, price, model material (defaults to model texture)
fishingequipmenttable = {
	{"Fishnet (Large)", "models/hunter/blocks/cube075x075x075.mdl", "fishnetbig", 5000, "models/props_interiors/metalfence007a"},
	{"Fishnet (Small)", "models/hunter/blocks/cube075x075x075.mdl", "fishnetsmall", 1000, "models/props_interiors/metalfence007a"},
	{"Crab Pot", "models/lostcoast/props_wasteland/crabpot.mdl", "crabpot", 500, ""},
	{"Fishing Pot", "models/props/gg_vietnam/foul_cage_round.mdl", "fishpot", 300, ""},
	{"Fish Trap", "models/props/gg_vietnam/fishtrap.mdl", "fishtrap", 50, ""},
	{"Fishing Box", "models/hunter/blocks/cube075x075x075.mdl", "fishbox", 100, "phoenix_storms/bluemetal"},
	{"Fish bait", "models/gibs/antlion_gib_large_3.mdl", "fishbait", 25, "models/flesh"}

}


-- format: crab name, model, min depth, max depth,  base price, current price, model zoom out
crabtable = {
	{"Ghost Crab", "models/crab.mdl", 500, 1800, 25, 25, 8},
	{"Tasmanian Crab", "models/tsbb/animals/tasmanian_crab.mdl", 1900, 2100, 25, 25, 20},
	{"HS Crab", "models/tsbb/animals/horseshoe_crab2.mdl", 3000, 3300, 25, 25, 20}

}

function initFishTable()
	for i = 1, table.Count(fishtable) do
		fishtablesearch[i] = fishtable[i][1]
	end
	
end
hook.Add("Initialize", "setupfishsearch", initFishTable)

function getFishTable()
	
	return fishtable 
	
end

net.Receive("FMRequestFishTable", function(len, ply)
	local seller = net.ReadEntity()
	

	
	net.Start("FMSendFishTable")
		net.WriteTable(fishtable)
		net.WriteTable(fishingequipmenttable)

		if seller:FindNearestBox(ply) != nil then
			net.WriteTable(seller:FindNearestBox(ply).contents)
		else
			local niltable = {}
			net.WriteTable(niltable)
		end

	net.Send(ply)
end)
 
net.Receive("PTRequestFishTable", function(len, ply)
	local pot = net.ReadEntity()
	net.Start("PTSendFishTable")
		net.WriteTable(fishtable)
		net.WriteTable(pot.contents)
	net.Send(ply)
end)

net.Receive("CPRequestCrabTable", function(len, ply)
	local pot = net.ReadEntity()
	net.Start("CPSendCrabTable")
		net.WriteTable(crabtable)
		net.WriteTable(pot.contents)
	net.Send(ply)
end)



