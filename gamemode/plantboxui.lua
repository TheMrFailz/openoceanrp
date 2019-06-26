
-- Menu for planting pots.
function plantboxinfo(box)
	local w = 400
	local h = 300
	local Frame = vgui.Create( "DFrame" )
	Frame:SetPos( ScrW() / 2 - w / 2, ScrH() / 2 - h / 2 )
	Frame:SetSize( w, h )
	Frame:SetTitle( "Plant Box" )
	Frame:SetVisible( true )
	Frame:SetDraggable( true )
	Frame:ShowCloseButton( true )
	Frame:MakePopup()

	local emptboxb = vgui.Create("DButton", Frame)
	emptboxb:SetText("Trash Contents")
	emptboxb:SetPos(0,20)
	emptboxb:SetSize(w,40)
	emptboxb.DoClick = function()
		Frame:Remove()
		net.Start("trashplantbox")
			net.WriteEntity(box)
		net.SendToServer()
	end

	net.Start("PTRequestplantTable")
		net.WriteEntity(box)
	net.SendToServer()

	net.Receive("PTSendplantTable", function(len, ply)
		local planttabledata = net.ReadTable()
		local potcontents = net.ReadTable()


		potplanttable(planttabledata, potcontents)
	end)

	local f2panel = vgui.Create("DPanel", Frame)
	f2panel:SetPos( 0, 60)
	f2panel:SetSize( w, h - 60)

	local plantpotinfopanel = vgui.Create("DScrollPanel", f2panel)
	plantpotinfopanel:Dock( FILL )

	function potplanttable(planttabledata, potcontents)
		for i=1, table.Count(planttabledata) do
			
			local planttypepanel = plantpotinfopanel:Add( "DPanel" )
			planttypepanel:Dock(TOP)
			planttypepanel:SetPos(0,0)
			planttypepanel:SetSize(w/4, 80)

			local plantmodel = vgui.Create( "DModelPanel", planttypepanel)
			plantmodel:SetPos(0,0)
			plantmodel:SetSize(80, 80)
			plantmodel:SetModel(planttabledata[i][2])
			local campos = Vector(0,0,2)
			plantmodel:SetLookAt(campos)
			plantmodel:SetCamPos(campos - Vector(-planttabledata[i][7],0,0))

			local plantname = vgui.Create( "DLabel", planttypepanel)
			plantname:SetText(planttabledata[i][1])
			plantname:SetPos(82, 0)
			plantname:SetSize(w / 2, 40)
			plantname:SetColor(Color(100,100,100,255))
			plantname:SetFont("plantnamebig")

			local plantbaseprice = vgui.Create( "DLabel", planttypepanel)
			plantbaseprice:SetText("Quantity: " .. potcontents[i][2])
			plantbaseprice:SetPos(82, 35)
			plantbaseprice:SetSize(w / 2, 15)
			plantbaseprice:SetColor(Color(100,100,100,255))
			plantbaseprice:SetFont("plantnamesmall")
			
			local dumpplant = vgui.Create("DButton", planttypepanel)
			dumpplant:SetText("Dump plant")
			dumpplant:SetPos(w - 120,20)
			dumpplant:SetSize(80,40)
			dumpplant.DoClick = function()
				net.Start("PTDumpplant")
					net.WriteEntity(box)
					net.WriteInt(i, 32)
				net.SendToServer()
			end
			
			
		end
	end
end

-- "open me!"
net.Receive("PLBXOpenGUI", function(len, ply)
	local newbox = net.ReadEntity()

	plantboxinfo(newbox)
end)


