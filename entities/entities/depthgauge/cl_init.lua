include('shared.lua')

function ENT:Draw()
	self:DrawModel()
	
	
	local nametagpos = self:LocalToWorld(Vector(6.5,-1,5))
	local nametagang = self:LocalToWorldAngles(Angle(0,90,90)) 
	
	
	

	
	local ourdepth = self:GetNWFloat("curdepth", 7)
	ourdepth = math.Round(ourdepth)
	
	cam.Start3D2D(nametagpos, nametagang, 0.15)
		draw.DrawText( "DEPTH", "Trebuchet24", 0, 0, Color(255,0,0,255), TEXT_ALIGN_CENTER)
		draw.DrawText( ourdepth, "Trebuchet24", 0, 30, Color(255,0,0,255), TEXT_ALIGN_CENTER)
	cam.End3D2D()

	
	
	
end