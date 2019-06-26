surface.CreateFont("plantnamebig", {
	font = "Trebuchet24",
	size = 20,
	weight = 2500,
	antialias = true,
	shadow = false
} )
surface.CreateFont("plantnamesmall", {
	font = "Trebuchet24",
	size = 15,
	weight = 500,
	antialias = true,
	shadow = false
} )



function plantmarketv2(planter)
	local w = 800
	local h = 300
	
	-- debug please remove



	local Frame = vgui.Create( "DFrame" )
	Frame:SetPos( ScrW() / 2 - w / 2, ScrH() / 2 - h / 2 )
	Frame:SetSize( w, h )
	Frame:SetTitle( "Plant Market" )
	Frame:SetVisible( true )
	Frame:SetDraggable( true )
	Frame:ShowCloseButton( true )
	Frame:MakePopup()
	
	local planttabledata = {}
	local playerplantstuff = {}
	local equipmenttable = {}
	
	net.Start("PMRequestPlantTable")
		net.WriteEntity(planter)
	net.SendToServer()

	
	

	local fpanel = vgui.Create("DPanel", Frame)
	fpanel:SetPos(10,50)
	fpanel:SetSize( w / 4, h - 60)

	local ppanelname = vgui.Create( "DLabel", Frame)
	ppanelname:SetText("Plant Prices:")
	ppanelname:SetPos(60, 25)
	ppanelname:SetSize(100,25)
	ppanelname:SetColor(Color(200,200,200,255))
	ppanelname:SetFont("plantnamebig")

	local spanel = vgui.Create("DPanel", Frame)
	spanel:SetPos( w / 4 + 20,50)
	spanel:SetSize( w / 2 - 40, h - 60)

	local spanelname = vgui.Create( "DLabel", Frame)
	spanelname:SetText("Planting Supplies:")
	spanelname:SetPos( w / 2 - 75, 25)
	spanelname:SetSize(150,25)
	spanelname:SetColor(Color(200,200,200,255))
	spanelname:SetFont("plantnamebig")

	local p2panelname = vgui.Create( "DLabel", Frame)
	p2panelname:SetText("Your Plants:")
	p2panelname:SetPos( w - (w / 4) + 50, 25)
	p2panelname:SetSize(100,25)
	p2panelname:SetColor(Color(200,200,200,255))
	p2panelname:SetFont("plantnamebig")

	local p2panel = vgui.Create("DPanel", Frame)
	p2panel:SetPos( w - (w / 4) - 10,50)
	p2panel:SetSize( w / 4, h - 120)

	local plantpricepanel = vgui.Create("DScrollPanel", fpanel)
	plantpricepanel:Dock( FILL )

	local plantpricepanel2 = vgui.Create("DScrollPanel", p2panel)
	plantpricepanel2:Dock( FILL )
	
	local equipmentpanel = vgui.Create("DScrollPanel", spanel)
	equipmentpanel:Dock( FILL )

	net.Receive("PMSendPlantTable", function(len, ply)
		planttabledata = net.ReadTable()
		equipmenttable = net.ReadTable()
		playerplantstuff = net.ReadTable()
	
		setupplantpriceinfo(planttabledata)
		setupplayerplantinfo(playerplantstuff)
		setupequipmentinfo(equipmenttable)
	end)

	-- Display plant market pricing:

	function setupplantpriceinfo(planttabledata)
	
		for i=1, table.Count(planttabledata) do
			
			local planttypepanel = plantpricepanel:Add( "DPanel" )
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
			plantname:SetSize(w / 4 - 85, 40)
			plantname:SetColor(Color(100,100,100,255))
			plantname:SetFont("plantnamebig")

			local plantbaseprice = vgui.Create( "DLabel", planttypepanel)
			plantbaseprice:SetText("Base price: $" .. planttabledata[i][5])
			plantbaseprice:SetPos(82, 35)
			plantbaseprice:SetSize(w / 4 - 85, 15)
			plantbaseprice:SetColor(Color(100,100,100,255))
			plantbaseprice:SetFont("plantnamesmall")
			
			local plantmarketprice = vgui.Create( "DLabel", planttypepanel)
			plantmarketprice:SetText("Curr. price: $" .. planttabledata[i][6])
			plantmarketprice:SetPos(82, 50)
			plantmarketprice:SetSize(w / 4 - 85, 15)
			plantmarketprice:SetColor(Color(100,100,100,255))
			plantmarketprice:SetFont("plantnamesmall")
			
		end
	end

	-- Display player's plants:
	function setupplayerplantinfo(playerplant)
		

		local plantprice = 0

		local sellbuttonyes = vgui.Create( "DButton", Frame) 
		sellbuttonyes:SetPos( w - (w / 4) - 10, 50 + h - 110)
		sellbuttonyes:SetSize(w / 4, 50)

		if playerplant[1] == nil then
			local noplantmess = vgui.Create( "DLabel", Frame)
			noplantmess:SetText("You have no plants!")
			noplantmess:SetPos( w - (w / 4) + 15, 75)
			noplantmess:SetSize((w / 4) - 0,25)
			noplantmess:SetColor(Color(100,100,100,255))
			noplantmess:SetFont("plantnamebig")
			
			
			sellbuttonyes:SetText("You have no plants!")
			

		return end
		
		for i=1, table.Count(playerplant) do
			
			local planttypepanel = plantpricepanel2:Add( "DPanel" )
			planttypepanel:Dock(TOP)
			planttypepanel:SetPos(0,0)
			planttypepanel:SetSize(w/4, 80)

			local plantmodel = vgui.Create( "DModelPanel", planttypepanel)
			plantmodel:SetPos(0,0)
			plantmodel:SetSize(80, 80)
			plantmodel:SetModel(planttabledata[i][2])
			local campos = Vector(0,0,0)
			plantmodel:SetLookAt(campos)
			plantmodel:SetCamPos(campos - Vector(-planttabledata[i][7],0,0))

			local plantname = vgui.Create( "DLabel", planttypepanel)
			plantname:SetText(planttabledata[i][1])
			plantname:SetPos(82, 0)
			plantname:SetSize(w / 4 - 85, 40)
			plantname:SetColor(Color(100,100,100,255))
			plantname:SetFont("plantnamebig")

			local plantbaseprice = vgui.Create( "DLabel", planttypepanel)
			plantbaseprice:SetText("Quantity: " .. playerplant[i][2])
			plantbaseprice:SetPos(82, 35)
			plantbaseprice:SetSize(w / 4 - 85, 15)
			plantbaseprice:SetColor(Color(100,100,100,255))
			plantbaseprice:SetFont("plantnamesmall")
			
			local plantmarketprice = vgui.Create( "DLabel", planttypepanel)
			plantmarketprice:SetText("Value: $" .. playerplant[i][2] * planttabledata[i][6])
			plantmarketprice:SetPos(82, 50)
			plantmarketprice:SetSize(w / 4 - 85, 15)
			plantmarketprice:SetColor(Color(100,100,100,255))
			plantmarketprice:SetFont("plantnamesmall")
			
			plantprice = plantprice + playerplant[i][2] * planttabledata[i][6]
			
		end

		sellbuttonyes:SetText("Sell Fish ($" .. plantprice .. ")")
		sellbuttonyes.DoClick = function()
			net.Start("FMSellRequest")
				net.WriteEntity(planter)
			net.SendToServer()
			Frame:Remove()
		end

	end

	

	-- Setup equipment slider thing
	function setupequipmentinfo(planttabledata)
	
		for i=1, table.Count(planttabledata) do
			
			local planttypepanel = equipmentpanel:Add( "DPanel" )
			planttypepanel:Dock(TOP)
			planttypepanel:SetPos(0,0)
			planttypepanel:SetSize(w/4, 80)

			local plantmodel = vgui.Create( "DModelPanel", planttypepanel)
			plantmodel:SetPos(0,0)
			plantmodel:SetSize(80, 80)
			plantmodel:SetModel(planttabledata[i][2])
			plantmodel.Entity:SetMaterial(planttabledata[i][5])
			local campos = Vector(0,0,0)
			plantmodel:SetLookAt(campos)
			plantmodel:SetCamPos(campos - Vector(-100,0,0))

			local plantname = vgui.Create( "DLabel", planttypepanel)
			plantname:SetText(planttabledata[i][1])
			plantname:SetPos(82, 0)
			plantname:SetSize(w / 4 - 35, 40)
			plantname:SetColor(Color(100,100,100,255))
			plantname:SetFont("plantnamebig")

			local plantbaseprice = vgui.Create( "DLabel", planttypepanel)
			plantbaseprice:SetText("$" .. planttabledata[i][4] .. " each")
			plantbaseprice:SetPos(82, 35)
			plantbaseprice:SetSize(w / 4 - 85, 15)
			plantbaseprice:SetColor(Color(100,100,100,255))
			plantbaseprice:SetFont("plantnamesmall")
			
			local buybutton = vgui.Create( "DButton", planttypepanel)
			buybutton:SetText("Purchase")
			buybutton:SetPos( w / 2 - 130, 25)
			buybutton:SetSize(70, 25)
			buybutton.DoClick = function()
				net.Start("FMPurchaseRequest")
					net.WriteEntity(planter)
					net.WriteInt(i, 32)
				net.SendToServer()
				
			end
			

		end
	end
end 

-- Open me (again!)

net.Receive("FMOpenGUI", function(len, ply)
	local seller = net.ReadEntity()
	plantmarketv2(seller)
	
end)


concommand.Add("plantmarketv2test", function(ply, cmd, args)
	plantmarketv2()


end)

