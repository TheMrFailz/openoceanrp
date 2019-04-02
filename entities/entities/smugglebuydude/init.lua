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
	self:SetModel( "models/player/group03/male_08.mdl" )
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
 
function ENT:FindNearestContra()
	-- Magic function that lets you find nearby contraband

	local possibleboxes = ents.FindInSphere(self:GetPos(), 100)
	local possibleboxesclean = {}
	for i = 1, table.Count(possibleboxes) do
		if possibleboxes[i]:GetClass() == "smuggleentity" then
			table.insert(possibleboxesclean, possibleboxes[i])
		end
	end
	if possibleboxesclean[1] != nil then
		print(possibleboxesclean.ContraType)
		return possibleboxesclean[1].ContraType
		
	else
		
		return ""
	end
	
	
	
end

function ENT:SellNearestContra(name)
	local possibleboxes = ents.FindInSphere(self:GetPos(), 100)
	local possibleboxesclean = {}
	for i = 1, table.Count(possibleboxes) do
		if possibleboxes[i]:GetClass() == "smuggleentity" then
			if possibleboxes[i].ContraType == name then
				table.insert(possibleboxesclean, possibleboxes[i])
			end
		end
	end
	local boxint = 1

	if possibleboxesclean[1] != nil then
		local narctype = possibleboxesclean[1].ContraType
		possibleboxesclean[1]:Remove()
		
		return narctype
		
	else
		
		
		return ""
	end
	
end

-- Note to self: Delete following func

function ENT:SpawnPurchase(ply, entclass)
	local posrange = 100

	local spotvector = Vector(0,0,50)
	
	if math.Round(math.Rand(0,1)) == 0 then
		spotvector = self:LocalToWorld(0, posrange, 50)
	else
		spotvector = self:LocalToWorld(0, -posrange, 50)
	end

	local newpurchase = ents.Create(entclass)
	newpurchase:CPPISetOwner(ply)
	newpurchase:SetPos(self:GetPos() + spotvector)
	newpurchase:Spawn()
end



function ENT:Use( activator, caller )


	net.Start("SMOpenGUI")
		net.WriteEntity(self)
		net.WriteString(self:FindNearestContra())
	net.Send(activator)
	
	
	return
end
 
function ENT:Think()

end