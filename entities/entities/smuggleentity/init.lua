AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')



function ENT:Initialize()

	-- Setup settings.
	self.ContraType = ""
	self.WaterDamage = 0
	self.WaterDelay = 3
	self.WaterDelayTime = 0

	-- Regular old entity setup.
	--self:SetModel( "models/props/cs_assault/dryer_box2.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      
	self:SetMoveType( MOVETYPE_VPHYSICS )   
	self:SetSolid( SOLID_VPHYSICS )         
	self:SetUseType(SIMPLE_USE)
	
	
	-- Make sure it floats.
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		
		phys:SetMaterial("wood")
		phys:Wake()
		
	end
end
 

function ENT:Use( activator, caller )

	return
end


function ENT:Think()
	if self:WaterLevel() > 1 && CurTime() > self.WaterDelayTime then
		self.WaterDelayTime = CurTime() + self.WaterDelay
		
		if self.WaterDamage < 100 && self.WaterDamage + 20 < 100 then
			self:EmitSound("physics/wood/wood_crate_impact_hard1.wav")
			self.WaterDamage = self.WaterDamage + 20
			self:SetColor(Color(255 - self.WaterDamage * 2.5,255 - self.WaterDamage * 2.5,255 - self.WaterDamage * 2.5,255))

		elseif self.WaterDamage + 20 >= 100 then
			self:EmitSound("physics/wood/wood_crate_break2.wav")
			self:Remove()
		end
	end
end

