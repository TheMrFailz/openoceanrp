AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')



function ENT:Initialize()



	-- Regular old entity setup.
	self:SetModel( "models/gibs/antlion_gib_large_3.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      
	self:SetMoveType( MOVETYPE_VPHYSICS )   
	self:SetSolid( SOLID_VPHYSICS )         
	self:SetUseType(SIMPLE_USE)
	self:SetMaterial("models/flesh")
	
	-- Make sure it floats.
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:SetBuoyancyRatio(1)
		phys:SetMaterial("armorflesh")
		phys:Wake()
		
	end
end
 
