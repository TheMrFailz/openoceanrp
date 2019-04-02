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
	self:SetModel( "models/player/odessa.mdl" )
	self:SetAnimation( PLAYER_IDLE )
	self:PhysicsInit( SOLID_OBB )     
	self:SetSolid( SOLID_OBB )         
	self:SetUseType(SIMPLE_USE)
	

	-- Make sure it floats.
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableMotion(false)
		--phys:Wake()
		
	end
	self:SetSequence(2)
end
 
function ENT:FindNearestBox(ply)
	local possibleboxes = ents.FindInSphere(self:GetPos(), 100)
	local possibleboxesclean = {}
	for i = 1, table.Count(possibleboxes) do
		if possibleboxes[i]:GetClass() == "fishbox" && possibleboxes[i]:CPPIGetOwner() == ply then
			table.insert(possibleboxesclean, possibleboxes[i])
		end
	end
	local boxint = 1

	if possibleboxesclean[1] != nil then
		
		
		while possibleboxesclean[boxint]:TotalContents() == 0 && possibleboxesclean[boxint+1] != nil do
			boxint = boxint + 1
		end

		if possibleboxesclean[boxint]:TotalContents() == 0 then
			
			return nil
		else
			return possibleboxesclean[boxint]
		end
		
	else
		
		return nil
	end
	
	
	
end

function ENT:SpawnPurchase(ply, entclass)
	local posrange = 100

	local spotvector = Vector(0,0,50)
	
	if math.Round(math.Rand(0,1)) == 0 then
		spotvector = Vector(0,posrange,50)
	else
		spotvector = Vector(0,-posrange,50)
	end

	local newpurchase = ents.Create(entclass)
	newpurchase:CPPISetOwner(ply)
	newpurchase:SetPos(self:GetPos() + spotvector)
	newpurchase:Spawn()
end



function ENT:Use( activator, caller )
	local boxtosell = self:FindNearestBox(activator)

	net.Start("FMOpenGUI")
		net.WriteEntity(self)
	net.Send(activator)
	
	
	return
end
 
function ENT:Think()

end