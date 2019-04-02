AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')



function ENT:Initialize()
	self.maxfish = 60
	self.deployed = false 
	self.delay = 15
	self.fishtime = 15
	self.fishents = {}

	-- copy fish table to ourself
	self.contents = {}

	for i = 1, table.Count(fishtable) do
		self.contents[i] = {}
		self.contents[i][1] = fishtable[i][1]
		self.contents[i][2] = 0
	end
	
	
	
	self:SetModel( "models/hunter/blocks/cube6x6x025.mdl" )
	self:SetMaterial("models/props_interiors/metalfence007a")
	self:PhysicsInit( SOLID_VPHYSICS )      
	self:SetMoveType( MOVETYPE_VPHYSICS )   
	self:SetSolid( SOLID_VPHYSICS )         
	self:SetUseType(SIMPLE_USE)
	
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMaterial("metal")
		phys:SetBuoyancyRatio(0)
		phys:SetMass(300)
	end
end
 
function ENT:GenerateFish(model, isbait)
	local fishobject = ents.Create("prop_physics")
	fishobject:SetModel(model)
	if isbait == true then 
		self.baitent = fishobject
		fishobject:SetModelScale(0.25)
		fishobject:SetMaterial("models/flesh")
	else
		table.insert(self.fishents, fishobject) 
	end
	
	local distfish = 200
	
	fishobject:SetPos(self:LocalToWorld(Vector(math.Rand(-distfish,distfish),math.Rand(-distfish,distfish),0)))
	fishobject:SetAngles(self:GetAngles() + Angle(0,math.Rand(0,360),0))
	fishobject:SetParent(self)
	fishobject:Spawn()
	
	
end

function ENT:CheckWaterDepth()
	local depth = 0
	
	local tracesetting = {
		endpos = self:GetPos(),
		start = self:GetPos() + Vector(0,0,4500),
		filter = function(ent) if (ent != nil) then return false end end,
		mask = MASK_WATER

	}

	local depthtrace = util.TraceLine(tracesetting)

	local finaldepth = depthtrace.HitPos:Distance(self:GetPos())

	return finaldepth 
	
end

function ENT:GetContents()
	return self.contents
end

function ENT:EmptyBoxContents()
	local contentcount = table.Count(self.fishents)
	local fishtablecount = table.Count(fishtable)

	for i = 1, contentcount do
		local invertedi = contentcount - (i - 1)
		PrintTable(self.fishents)
		
			
			
		if self.fishents[invertedi]:IsValid() then
			
			self.fishents[invertedi]:Remove()
			table.RemoveByValue(self.fishents, invertedi)
			
		end
		
			
	end

	

	table.Empty(self.contents)
	
	for i = 1, table.Count(fishtable) do

		
		
		self.contents[i] = {}
		self.contents[i][1] = fishtable[i][1]
		self.contents[i][2] = 0
	end
	
end

function ENT:makefloater(bobbercolor)
	-- gutted because nets dont have floats.
end


function ENT:Use( activator, caller )
	net.Start("PTOpenGUI")
		net.WriteEntity(self)

	net.Send(activator)
	
	return
end
 
function ENT:StartTouch(ent)
	
end

function ENT:CountFish()
	local fishtot = 0
	for i = 1, table.Count(self.contents) do
		fishtot = fishtot + self.contents[i][2]
		
	end
		
	return fishtot
end


function ENT:Think()
	-- Doing velocity memes
	
	local linespeed = self:GetVelocity():Length()
	--print(linespeed)
	if linespeed > 30 then
		if linespeed <= 600 then
			self.fishtime = 160 / ((linespeed / 100) + 1)
		else
			self.fishtime = 160 / ((600 / 100) + 1)
		end
		
	else
		self.fishtime = 160
	end

	if self.deployed == true && linespeed > 30 then
		
		if self:WaterLevel() >= 1 then
			if self.delay <= CurTime() then
				self.delay = CurTime() + self.fishtime

				if self:CountFish() < self.maxfish then


					if math.Rand(0,1) >= 0.25 then
						local checkingdepth = self:CheckWaterDepth() + 1400
						local potentialfish = {}
						
						
						-- Go through the table and try to find a fish that fits in this zone. Will happen multiple times obv.
						for i = 1, table.Count(fishtablesearch - 3) do
							if checkingdepth <= fishtable[i][4] && checkingdepth >= fishtable[i][3] then
								-- Insert it's name into the potential fish list.
								table.insert(potentialfish, fishtablesearch[i])
								print(checkingdepth)
							end
							
						end
						
						

						-- Pick a random fish from the list of potential fish.
						local fishtopick = math.Round(math.Rand(1, table.Count(potentialfish)))
						
						-- Assuming nothing dumb happened,
						if potentialfish[fishtopick] != nil then

							
							
							-- Find our corresponding internal fish counter.
							local keyforfish = table.KeyFromValue(fishtablesearch, potentialfish[fishtopick])
							
							-- Add a cute fish model.

							self:GenerateFish( fishtable[keyforfish][2],false)
							
							-- Raise it's count.
							self.contents[keyforfish][2] = self.contents[keyforfish][2] + 1 
							
							
							
							
							--print("snagged one! Fishtopick: " .. fishtopick)
						else
							-- No fish available. May occur if the main init.file is edited during runtime.
							print("Either there's no fish at this depth or something stupid happened.")
						end
						
					else
						-- failure to get fish state
					end
				end
			end
		end
	end
	
	
end


