surface.CreateFont("fishnamebig", {
	font = "Trebuchet24",
	size = 20,
	weight = 2500,
	antialias = true,
	shadow = false
} )
surface.CreateFont("fishnamesmall", {
	font = "Trebuchet24",
	size = 15,
	weight = 500,
	antialias = true,
	shadow = false
} )



function fishmarketv2(fisher)
	local w = 800
	local h = 300
	
	-- debug please remove



	local Frame = vgui.Create( "DFrame" )
	Frame:SetPos( ScrW() / 2 - w / 2, ScrH() / 2 - h / 2 )
	Frame:SetSize( w, h )
	Frame:SetTitle( "Fish Market" )
	Frame:SetVisible( true )
	Frame:SetDraggable( true )
	Frame:ShowCloseButton( true )
	Frame:MakePopup()
	
	local fishtabledata = {}
	local playerfishstuff = {}
	local equipmenttable = {}
	
	net.Start("FMRequestFishTable")
		net.WriteEntity(fisher)
	net.SendToServer()

	
	

	local fpanel = vgui.Create("DPanel", Frame)
	fpanel:SetPos(10,50)
	fpanel:SetSize( w / 4, h - 60)

	local fpanelname = vgui.Create( "DLabel", Frame)
	fpanelname:SetText("Fish Prices:")
	fpanelname:SetPos(60, 25)
	fpanelname:SetSize(100,25)
	fpanelname:SetColor(Color(200,200,200,255))
	fpanelname:SetFont("fishnamebig")

	local spanel = vgui.Create("DPanel", Frame)
	spanel:SetPos( w / 4 + 20,50)
	spanel:SetSize( w / 2 - 40, h - 60)

	local spanelname = vgui.Create( "DLabel", Frame)
	spanelname:SetText("Fishing Supplies:")
	spanelname:SetPos( w / 2 - 75, 25)
	spanelname:SetSize(150,25)
	spanelname:SetColor(Color(200,200,200,255))
	spanelname:SetFont("fishnamebig")

	local f2panelname = vgui.Create( "DLabel", Frame)
	f2panelname:SetText("Your Fish:")
	f2panelname:SetPos( w - (w / 4) + 50, 25)
	f2panelname:SetSize(100,25)
	f2panelname:SetColor(Color(200,200,200,255))
	f2panelname:SetFont("fishnamebig")

	local f2panel = vgui.Create("DPanel", Frame)
	f2panel:SetPos( w - (w / 4) - 10,50)
	f2panel:SetSize( w / 4, h - 120)

	local fishpricepanel = vgui.Create("DScrollPanel", fpanel)
	fishpricepanel:Dock( FILL )

	local fishpricepanel2 = vgui.Create("DScrollPanel", f2panel)
	fishpricepanel2:Dock( FILL )
	
	local equipmentpanel = vgui.Create("DScrollPanel", spanel)
	equipmentpanel:Dock( FILL )

	net.Receive("FMSendFishTable", function(len, ply)
		fishtabledata = net.ReadTable()
		equipmenttable = net.ReadTable()
		playerfishstuff = net.ReadTable()
	
		setupfishpriceinfo(fishtabledata)
		setupplayerfishinfo(playerfishstuff)
		setupequipmentinfo(equipmenttable)
	end)

	-- Display fish market pricing:

	function setupfishpriceinfo(fishtabledata)
	
		for i=1, table.Count(fishtabledata) do
			
			local fishtypepanel = fishpricepanel:Add( "DPanel" )
			fishtypepanel:Dock(TOP)
			fishtypepanel:SetPos(0,0)
			fishtypepanel:SetSize(w/4, 80)

			local fishmodel = vgui.Create( "DModelPanel", fishtypepanel)
			fishmodel:SetPos(0,0)
			fishmodel:SetSize(80, 80)
			fishmodel:SetModel(fishtabledata[i][2])
			local campos = Vector(0,0,2)
			fishmodel:SetLookAt(campos)
			fishmodel:SetCamPos(campos - Vector(-fishtabledata[i][7],0,0))

			local fishname = vgui.Create( "DLabel", fishtypepanel)
			fishname:SetText(fishtabledata[i][1])
			fishname:SetPos(82, 0)
			fishname:SetSize(w / 4 - 85, 40)
			fishname:SetColor(Color(100,100,100,255))
			fishname:SetFont("fishnamebig")

			local fishbaseprice = vgui.Create( "DLabel", fishtypepanel)
			fishbaseprice:SetText("Base price: $" .. fishtabledata[i][5])
			fishbaseprice:SetPos(82, 35)
			fishbaseprice:SetSize(w / 4 - 85, 15)
			fishbaseprice:SetColor(Color(100,100,100,255))
			fishbaseprice:SetFont("fishnamesmall")
			
			local fishmarketprice = vgui.Create( "DLabel", fishtypepanel)
			fishmarketprice:SetText("Curr. price: $" .. fishtabledata[i][6])
			fishmarketprice:SetPos(82, 50)
			fishmarketprice:SetSize(w / 4 - 85, 15)
			fishmarketprice:SetColor(Color(100,100,100,255))
			fishmarketprice:SetFont("fishnamesmall")
			
		end
	end

	-- Display player's fish:
	function setupplayerfishinfo(playerfish)
		

		local fishprice = 0

		local sellbuttonyes = vgui.Create( "DButton", Frame) 
		sellbuttonyes:SetPos( w - (w / 4) - 10, 50 + h - 110)
		sellbuttonyes:SetSize(w / 4, 50)

		if playerfish[1] == nil then
			local nofishmess = vgui.Create( "DLabel", Frame)
			nofishmess:SetText("You have no fish!")
			nofishmess:SetPos( w - (w / 4) + 15, 75)
			nofishmess:SetSize((w / 4) - 0,25)
			nofishmess:SetColor(Color(100,100,100,255))
			nofishmess:SetFont("fishnamebig")
			
			
			sellbuttonyes:SetText("You have no fish!")
			

		return end
		
		for i=1, table.Count(playerfish) do
			
			local fishtypepanel = fishpricepanel2:Add( "DPanel" )
			fishtypepanel:Dock(TOP)
			fishtypepanel:SetPos(0,0)
			fishtypepanel:SetSize(w/4, 80)

			local fishmodel = vgui.Create( "DModelPanel", fishtypepanel)
			fishmodel:SetPos(0,0)
			fishmodel:SetSize(80, 80)
			fishmodel:SetModel(fishtabledata[i][2])
			local campos = Vector(0,0,0)
			fishmodel:SetLookAt(campos)
			fishmodel:SetCamPos(campos - Vector(-fishtabledata[i][7],0,0))

			local fishname = vgui.Create( "DLabel", fishtypepanel)
			fishname:SetText(fishtabledata[i][1])
			fishname:SetPos(82, 0)
			fishname:SetSize(w / 4 - 85, 40)
			fishname:SetColor(Color(100,100,100,255))
			fishname:SetFont("fishnamebig")

			local fishbaseprice = vgui.Create( "DLabel", fishtypepanel)
			fishbaseprice:SetText("Quantity: " .. playerfish[i][2])
			fishbaseprice:SetPos(82, 35)
			fishbaseprice:SetSize(w / 4 - 85, 15)
			fishbaseprice:SetColor(Color(100,100,100,255))
			fishbaseprice:SetFont("fishnamesmall")
			
			local fishmarketprice = vgui.Create( "DLabel", fishtypepanel)
			fishmarketprice:SetText("Value: $" .. playerfish[i][2] * fishtabledata[i][6])
			fishmarketprice:SetPos(82, 50)
			fishmarketprice:SetSize(w / 4 - 85, 15)
			fishmarketprice:SetColor(Color(100,100,100,255))
			fishmarketprice:SetFont("fishnamesmall")
			
			fishprice = fishprice + playerfish[i][2] * fishtabledata[i][6]
			
		end

		sellbuttonyes:SetText("Sell Fish ($" .. fishprice .. ")")
		sellbuttonyes.DoClick = function()
			net.Start("FMSellRequest")
				net.WriteEntity(fisher)
			net.SendToServer()
			Frame:Remove()
		end

	end

	

	-- Setup equipment slider thing
	function setupequipmentinfo(fishtabledata)
	
		for i=1, table.Count(fishtabledata) do
			
			local fishtypepanel = equipmentpanel:Add( "DPanel" )
			fishtypepanel:Dock(TOP)
			fishtypepanel:SetPos(0,0)
			fishtypepanel:SetSize(w/4, 80)

			local fishmodel = vgui.Create( "DModelPanel", fishtypepanel)
			fishmodel:SetPos(0,0)
			fishmodel:SetSize(80, 80)
			fishmodel:SetModel(fishtabledata[i][2])
			fishmodel.Entity:SetMaterial(fishtabledata[i][5])
			local campos = Vector(0,0,0)
			fishmodel:SetLookAt(campos)
			fishmodel:SetCamPos(campos - Vector(-100,0,0))

			local fishname = vgui.Create( "DLabel", fishtypepanel)
			fishname:SetText(fishtabledata[i][1])
			fishname:SetPos(82, 0)
			fishname:SetSize(w / 4 - 35, 40)
			fishname:SetColor(Color(100,100,100,255))
			fishname:SetFont("fishnamebig")

			local fishbaseprice = vgui.Create( "DLabel", fishtypepanel)
			fishbaseprice:SetText("$" .. fishtabledata[i][4] .. " each")
			fishbaseprice:SetPos(82, 35)
			fishbaseprice:SetSize(w / 4 - 85, 15)
			fishbaseprice:SetColor(Color(100,100,100,255))
			fishbaseprice:SetFont("fishnamesmall")
			
			local buybutton = vgui.Create( "DButton", fishtypepanel)
			buybutton:SetText("Purchase")
			buybutton:SetPos( w / 2 - 130, 25)
			buybutton:SetSize(70, 25)
			buybutton.DoClick = function()
				net.Start("FMPurchaseRequest")
					net.WriteEntity(fisher)
					net.WriteInt(i, 32)
				net.SendToServer()
				
			end
			

		end
	end
end 

-- Open me (again!)

net.Receive("FMOpenGUI", function(len, ply)
	local seller = net.ReadEntity()
	fishmarketv2(seller)
	
end)


concommand.Add("fishmarketv2test", function(ply, cmd, args)
	fishmarketv2()


end)

