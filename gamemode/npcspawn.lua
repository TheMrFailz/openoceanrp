-- This is where you set where you want your NPCs to spawn.

-- Fish dealer
local fishpos = Vector(-9944.103516, 13818.609375, 0.320469)
local fishang = Angle(4.290401, -43.788239, 0.000000)
local fishname = "Fish Market"

--[[
	Format: class, name, position, angle
	Protip: Subtract 64 units from the Z of a getpos return (command) to get their feet on the ground.
]]

local npcoorptable = {
	{"fishdude", "Fish Market (RH)", Vector(-9944.103516, 13818.609375, 0.320469), Angle(4.290401, -43.788239, 0.000000)},
	{"fishdude", "Fish Market (OH)", Vector(-13074.303711, 13043.426758, 8720.031250), Angle(4.702499, 129.772552, 0.000000)},
	{"fishdude", "Fish Market (GH)", Vector(-9517.682617, 7624.578613, 14720.031250), Angle(-1.072490, -146.459854, 0.000000)},
	{"fishdude", "Fish Market (BH)", Vector(15304.745117, -12272.047852, -2.183811), Angle(-2.392523, 127.709854, 0.000000)},
	{"smugglebuydude", "Contraband Buyer", Vector(-11082.199219, 15152.566406, 10.031250), Angle(0, 27.862444, 0.000000)},
	{"smuggleselldude", "Contraband Seller", Vector(13471.594727, -15284.463867, 0), Angle(0, 149.602249, 0.000000)},
	{"barreldropoffdude", "Barrel giver", Vector(15855.968750, -15407.968750, 0.031250), Angle(1.650027, 122.407402, 0.000000)},
	{"vehicleshopoorp", "Vehicle Salesman", Vector(-14444.905273, 11591.235352, 400.031250), Angle(-3.052531, 1.267553, 0.000000)},
	
	
	
}

function spawnoorpnpcs()
	
	for i = 1, table.Count(npcoorptable) do
		local newnpc = ents.Create(npcoorptable[i][1])
		newnpc.viewname = npcoorptable[i][2]
		newnpc:SetPos(npcoorptable[i][3])
		newnpc:SetAngles(npcoorptable[i][4])
		newnpc:Spawn()
	
	
	end
end



hook.Add("InitPostEntity", "spawnoorpnpcs", spawnoorpnpcs)
