AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')



function ENT:Initialize()

	-- Setup this particular box's settings.
	self.movetime = 0
	self.movedelay = 0
	self.moveit = 0
	self.moverange = 100
	self.moverangeup = 50
	self.moving = true
	self.started = false
	self.startvec = Vector(0,0,0)
	self.endvec = Vector(0,0,0)


	-- Regular old entity setup.
	self:SetModel( "models/tsbb/fishes/betta.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      
	self:SetMoveType( MOVETYPE_VPHYSICS )   
	self:SetSolid( SOLID_VPHYSICS )         
	self:SetUseType(SIMPLE_USE)
	--self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	self:SetGravity(1)

	-- Make sure it floats.
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		
		phys:SetMaterial("flesh")
		phys:Wake()
		
	end
end
 

function ENT:Use( activator, caller )
	self.endvec = self:GetPos() + Vector(math.Rand(-self.moverange, self.moverange), math.Rand(-self.moverange, self.moverange), math.Rand(-self.moverangeup, self.moverangeup))
	self.startvec = self:GetPos()
	return
end
 
function ENT:Think()

end

