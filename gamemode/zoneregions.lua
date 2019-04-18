-- zone file. This is all the map zones.


--[[ Zone table
	Format: Name of zone (Printed), Priority val, min boundries, max boundries,
	unique zone, layer zone, noclip allowed, drowning allowed.
	
	Priority val:
	Priority value is a value used to determine how important the properties of a zone are and
	how they should override the zone they are inside. The closer to 0 the more important you are (scale only goes 1-3 though).
	3: Global regions. Basically the default fallback thing and mainly should be used for the boundries of an entire playable area.
	2: Local regions. Towns and other large areas like oil rigs.
	1: Room and buildings. Basically if you need a build zone this is the value to use.

	Zone flags:
	unique zone - Boolean, Should this zone be announced on enter? (No for things like buildzones).
	noclip allowed - Boolean, Should you be able to noclip inside this zone?
	drowning allowed - Boolean, Should you be able to drown here? (No for most unique zones).

]]

-- {"printname", Vector(0,0,0), Vector(1,1,1), false, false, false, false},

zonestable = {
	{"Sea", 3, Vector(-15855.991211, 15855.968750, 2897.694580), Vector(15870.576172, -15849.153320, -3680.276123), true, false, true},
	{"Red Harbor", 2, Vector(-15855.991211, 15855.968750, 2897.694580), Vector(-9080.812500, 9819.488281, -299.944122), true, false, false},


}


function zonecheckin()



end