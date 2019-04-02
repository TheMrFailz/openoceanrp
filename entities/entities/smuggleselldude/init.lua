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
	self:SetModel( "models/player/group03/male_09.mdl" )
	self:SetAnimation( PLAYER_IDLE )
	self:PhysicsInit( SOLID_OBB )     
	self:SetSolid( SOLID_OBB )         
	self:SetUseType(SIMPLE_USE)
	

	-- Make Setup Fysixs
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableMotion(false)

		
	end
	-- Set animation.

	self:SetSequence(2)
end
 

function ENT:SpawnPurchase(contradata)
	local posrange = 100

	local spotvector = Vector(0,0,50)
	
	if math.Round(math.Rand(0,1)) == 0 then
		spotvector = Vector(0,posrange,50)
	else
		spotvector = Vector(0,-posrange,50)
	end

	local newpurchase = ents.Create("smuggleentity")
	
	
	newpurchase:SetPos(self:GetPos() + spotvector)
	newpurchase:SetModel(contradata[2])
	newpurchase:Spawn()
	newpurchase.ContraType = contradata[1]
	--newpurchase:Activate()
end



function ENT:Use( activator, caller )


	net.Start("SMOpenGUI2")
		net.WriteEntity(self)
	net.Send(activator)
	
	
	return
end
 
function ENT:Think()

end