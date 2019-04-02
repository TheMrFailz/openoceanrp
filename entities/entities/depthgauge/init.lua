AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')



function ENT:Initialize()

	-- Setup settings.
	self.depthdelay = 1
	self.delaytime = 0
	self.curdepth = 0
	self.enabled = false


	-- Regular old entity setup.
	self:SetModel( "models/props_lab/monitor01b.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      
	self:SetMoveType( MOVETYPE_VPHYSICS )   
	self:SetSolid( SOLID_VPHYSICS )         
	self:SetUseType(SIMPLE_USE)
	
	
	-- Make sure it floats.
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		
		phys:SetMaterial("metal")
		phys:Wake()
		
	end
end
 

function ENT:Use( activator, caller )
	if self.enabled == false then
		self.enabled = true
	elseif self.enabled == true then
		self.enabled = false
	end
	
	return
end
 
function ENT:DepthFinder()

	local unit2water = {
		start = self:GetPos(),
		endpos = self:GetPos() - Vector(0,0,4500),
		filter = function(ent) return false end

	}

	local unit2water2 = {
		start = self:GetPos(),
		endpos = self:GetPos() - Vector(0,0,4100),
		filter = function(ent) return false end,
		mask = MASK_WATER

	}
	
	local surfacetrace = util.TraceLine(unit2water)
	local surfacetrace2 = util.TraceLine(unit2water2)

	local waterpos = surfacetrace.HitPos
	local waterpos2 = surfacetrace2.HitPos

	local finaldepth = waterpos:Distance(self:GetPos())
	local height = waterpos2:Distance(self:GetPos())

	
	local newdepth = (finaldepth - height)

	
	if height > 0 && (height < 2000) then
		
		return newdepth
	else
		return finaldepth
	end

end

function ENT:Think()
	if self.enabled == true && self.delaytime < CurTime() then
		self.delaytime = CurTime() + self.depthdelay
		self:SetNWFloat("curdepth", self:DepthFinder())
			
	end
	

end

