include('shared.lua')

-- DO NOT ATTEMPT TO SPAWN THIS USING CONSOLE COMMANDS (ie ent_create). IT WILL BREAK RENDERING.


function ENT:Draw()
	self:DrawModel()
	local name2use = ""

	if self:CPPIGetOwner() != nil then
		if self:CPPIGetOwner():Nick() == nil then
			name2use = ""
		else
			name2use = self:CPPIGetOwner():Nick()
		end 
	end
	
	local nametagpos = self:LocalToWorld(Vector(-2,0,13))
	local nametagang = self:LocalToWorldAngles(Angle(0,90,0)) 
	
	cam.Start3D2D(nametagpos, nametagang, 0.15)
		draw.DrawText( name2use .. "'s Plant Box", "Trebuchet24", 0, 0, Color(255,0,0,255), TEXT_ALIGN_CENTER)
	cam.End3D2D()

	
	
	
end