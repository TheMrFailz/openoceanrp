AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.
 
include('shared.lua')



function ENT:Initialize()
	self.maxfish = 30
	self.ropelength = 1400
	self.deployed = false 
	self.delay = 15
	self.baited = true
	self.bait_amount = 0
	self.fishtime = 60
	self.baitent = nil
	self.fishents = {}
	self.bobber = nil

	-- copy fish table to ourself
	self.contents = {}

	for i = 1, table.Count(fishtable) do
		self.contents[i] = {}
		self.contents[i][1] = fishtable[i][1]
		self.contents[i][2] = 0
	end
	
	
	
	self:SetModel( "models/lostcoast/props_wasteland/crabpot.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )      
	self:SetMoveType( MOVETYPE_VPHYSICS )   
	self:SetSolid( SOLID_VPHYSICS )         
	self:SetUseType(SIMPLE_USE)
	
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMaterial("metal")
		phys:SetBuoyancyRatio(0)
	end
end
 
function ENT:makefloater(bobbercolor)
	-- Gutted because it literally doesn't need to exist.
end

function ENT:GenerateFish(model, isbait)
	local fishobject = ents.Create("prop_dynamic")
	fishobject:SetModel(model)
	if isbait == true then 
		self.baitent = fishobject
		fishobject:SetModelScale(0.25)
		fishobject:SetMaterial("models/flesh")
	else
		table.insert(self.fishents, fishobject) 
	end
	
	
	fishobject:SetPos(self:LocalToWorld(Vector(math.Rand(-6,6),math.Rand(-6,6),3)))
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


function ENT:Use( activator, caller )
	net.Start("PTOpenGUI")
		net.WriteEntity(self)

	net.Send(activator)
	
	return
end
 
function ENT:StartTouch(ent)

	if ent:GetClass() == "fishbait" && self.bait_amount == 0 then
		ent:Remove()
		self.bait_amount = 30
		self:GenerateFish( "models/gibs/antlion_gib_large_3.mdl",true)
	end
	
	
	
end

function ENT:CountFish()
	local fishtot = 0
	for i = 1, table.Count(self.contents) do
		fishtot = fishtot + self.contents[i][2]
		
	end
		
	return fishtot
end


function ENT:Think()
	if self.deployed == true then
		if self.baited == true && self:WaterLevel() >= 1 then
			if self.delay <= CurTime() then
				self.delay = CurTime() + self.fishtime
				if self.bait_amount > 0 && self:CountFish() < self.maxfish then


					if math.Rand(0,1) >= 0.25 then
						local checkingdepth = self:CheckWaterDepth()
						local potentialfish = {}
						
						-- Go through the table and try to find a fish that fits in this zone. Will happen multiple times obv.
						for i = 1, table.Count(fishtable) do
							if checkingdepth <= fishtable[i][4] && checkingdepth >= fishtable[i][3] then
								-- Insert it's name into the potential fish list.
								if (fishtable[i][1] == "Ghost Crab") || ((fishtable[i][1] == "Ghost Crab")||(fishtable[i][1] == "HS Crab")) then
									table.insert(potentialfish, fishtable[i])
								end
							end
							
						end
						
						

						-- Pick a random fish from the list of potential fish.
						local fishtopick = math.Round(math.Rand(1, table.Count(potentialfish)))
						
						-- Assuming nothing dumb happened,
						if potentialfish[fishtopick] != nil then

							
							
							-- Find our corresponding internal fish counter.
							local keyforfish = table.KeyFromValue(fishtable, potentialfish[fishtopick])
							
							-- Add a cute fish model.

							self:GenerateFish( fishtable[keyforfish][2],false)
							
							-- Raise it's count.
							self.contents[keyforfish][2] = self.contents[keyforfish][2] + 1 
							
							if self.bait_amount - 1 == 0 then
								self.baitent:Remove()
							end
							
							self.bait_amount = self.bait_amount - 1
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


