AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')



function ENT:Initialize()

	-- Setup this particular box's settings.
	self.maxobjects = 20
	self.contents = {}

	-- Setup the internal fish counters.
	for i = 1, table.Count(fishtable) do
		self.contents[i] = {}
		self.contents[i][1] = fishtable[i][1]
		self.contents[i][2] = 0
	end

	-- Regular old entity setup.
	self:SetModel( "models/player/group01/male_05.mdl" )
	self:SetAnimation( PLAYER_IDLE )
	self:PhysicsInit( SOLID_OBB )     
	self:SetSolid( SOLID_OBB )         
	self:SetUseType(SIMPLE_USE)
	self:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)

	-- Make Setup Fysixs
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableMotion(false)

		
	end
	-- Set animation.

	self:SetSequence(2)
end


-- Note to self: Delete following func

function ENT:SpawnPurchase(ply, vehicleint)

	local spotvector = Vector(0,0,0)
	local spotang = Angle(0,90,0)
	local xyzsize = 20
	
	for i = 1, table.Count(vehiclespawnlocationsoorp) do
		if vehiclespawnlocationsoorp[i][4] == vehiclesaleslist[vehicleint][5] then
			local checkin = ents.FindInBox(vehiclespawnlocationsoorp[i][2] + Vector(-xyzsize, -xyzsize, -100), vehiclespawnlocationsoorp[i][2] + Vector(xyzsize, xyzsize, 100))
			
			
			local taken = false

			for d = 1, table.Count(checkin) do
				if checkin[d]:IsVehicle() || string.StartWith(checkin[d]:GetClass(), "wac_") then
					taken = true
				end
			end
			
			if taken != true then
				spotvector = vehiclespawnlocationsoorp[i][2]
				spotang = vehiclespawnlocationsoorp[i][3]
				break
			end
			
		end
	end

	if spotvector == Vector(0,0,0) then
		--spotvector = Vector(-13786.957031, 11354.899414, 72.774536)
		DarkRP.notify(ply, 0, 3, "No available spots!")
	else
	

		local newpurchase = ents.Create(vehiclesaleslist[vehicleint][2])
		if string.StartWith(vehiclesaleslist[vehicleint][2], "prop_vehicle") then
			

			newpurchase:SetModel(vehiclesaleslist[vehicleint][3])
			newpurchase:SetKeyValue("vehiclescript","scripts/vehicles/airboat.txt")
		end
		
		newpurchase:SetPos(spotvector)
		newpurchase:SetAngles(spotang)
		newpurchase:DropToFloor()
		newpurchase:Spawn()
		
		newpurchase:Activate()
		newpurchase:CPPISetOwner(ply)
		DarkRP.notify(ply, 0, 3, "Vehicle spawned.")
	end
	--newpurchase:CPPISetOwner(ply)
end



function ENT:Use( activator, caller )


	net.Start("VSOpenGUI")
		net.WriteEntity(self)
	net.Send(activator)
	
	
	return
end
 
function ENT:Think()

end