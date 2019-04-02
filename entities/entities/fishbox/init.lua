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
	self:SetModel( "models/hunter/blocks/cube075x075x075.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      
	self:SetMoveType( MOVETYPE_VPHYSICS )   
	self:SetSolid( SOLID_VPHYSICS )         
	self:SetUseType(SIMPLE_USE)
	self:SetMaterial("phoenix_storms/bluemetal")
	self:SetUseType(SIMPLE_USE)
	
	-- Make sure it floats.
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		
		phys:SetMaterial("Wood_Solid")
		phys:Wake()
		
	end
end
 
function ENT:TotalContents()
	local totalfish = 0

	for i = 1, table.Count(self.contents) do
		totalfish = totalfish + self.contents[i][2]
		
	end
	
	return totalfish
end

function ENT:FillStuff(content2add)
	
	-- Attempt to fill this container with the desired amounts. Returns a table of everything that wouldn't fit.

	local leftover = table.Copy(content2add)

	for i = 1, table.Count(self.contents) do
		
		-- attempt to fill.
		self.contents[i][2] = content2add[i][2] + self.contents[i][2]

		-- If we filled and spilled,
		if self:TotalContents() > 20 then

			-- How big is our over fill?
			local overload = self:TotalContents()

			-- Take all the fish out.
			self.contents[i][2] = self.contents[i][2] - content2add[i][2]
			
			-- Calculate how much over we are.
			local overfill = overload - self:TotalContents()

			-- fill, but without the overfill.
			self.contents[i][2] = self.contents[i][2] + (content2add[i][2] - overfill)
			
			-- Remove the fish we took out.
			leftover[i][2] = leftover[i][2] - (content2add[i][2] - overfill)

		else
			-- Remove the fish we took out.
			leftover[i][2] = leftover[i][2] - content2add[i][2]
			
		end
		
	end
	
	
	return leftover
	
end

function ENT:EmptyBoxContents()
	table.Empty(self.contents)
	for i = 1, table.Count(fishtable) do
		self.contents[i] = {}
		self.contents[i][1] = fishtable[i][1]
		self.contents[i][2] = 0
	end
end

function ENT:Use( activator, caller )
	net.Start("BXOpenGUI")
		net.WriteEntity(self)

	net.Send(activator)
	
	return
end
 
function ENT:Think()

end