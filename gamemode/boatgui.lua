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



function vehiclesalesGUI(seller)
	local w = 500
	local h = 400

	local Frame = vgui.Create( "DFrame" )
	Frame:SetPos( ScrW() / 2 - w / 2, ScrH() / 2 - h / 2 )
	Frame:SetSize( w, h )
	Frame:SetTitle( "Vehicle Salesman" )
	Frame:SetVisible( true )
	Frame:SetDraggable( true )
	Frame:ShowCloseButton( true )
	Frame:MakePopup()
	
	local vehicletable = {}
	
	net.Start("RequestVehicleTable")

	net.SendToServer()

	local buyermodel = vgui.Create( "DModelPanel", Frame)
	buyermodel:SetPos(10,20)
	buyermodel:SetSize(120, 120)
	buyermodel:SetModel("models/player/group01/male_05.mdl")
	local campos2 = Vector(0,0,64)
	buyermodel:SetLookAt(campos2)
	buyermodel:SetCamPos(campos2 + Vector(20,0,0))
	function buyermodel:LayoutEntity( ent )

	end
	
	local textblurb = vgui.Create("DLabel", Frame)
	textblurb:SetPos(140, 30)
	textblurb:SetSize(w - 140 - 10, 30)
	textblurb:SetText("Welcome to Jin's Vehicle Emporium.")
	textblurb:SetFont("fishnamebig")

	local spanel = vgui.Create("DPanel", Frame)
	spanel:SetPos( 10,150)
	spanel:SetSize( w - 20, 250 - 10)
	
	local vehiclepanel = vgui.Create("DScrollPanel", spanel)
	vehiclepanel:Dock( FILL )

	net.Receive("SendVehicleTable", function(len, ply)
		vehicletable = net.ReadTable()

		vehiclelisting(vehicletable)
	end)

	-- Display fish market pricing:

	function vehiclelisting(vehicletable)

		for i=1, table.Count(vehicletable) do
			
			local vehicletypepanel = vehiclepanel:Add( "DPanel" )
			vehicletypepanel:Dock(TOP)
			vehicletypepanel:SetPos(0,0)
			vehicletypepanel:SetSize(w - 20, 80)

			local vehiclemodel = vgui.Create( "DModelPanel", vehicletypepanel)
			vehiclemodel:SetPos(10,10)
			vehiclemodel:SetSize(60, 60)
			vehiclemodel:SetModel(vehicletable[i][3])
			local campos = Vector(0,0,2)
			vehiclemodel:SetLookAt(campos)
			vehiclemodel:SetCamPos(campos - Vector(-vehicletable[i][7],0,-30))

			local vehiclename = vgui.Create("DLabel", vehicletypepanel)
			vehiclename:SetPos(80, 10)
			vehiclename:SetSize(w - 70 - 20, 20)
			vehiclename:SetText(vehicletable[i][1])
			vehiclename:SetColor(Color(100,100,100,255))
			vehiclename:SetFont("fishnamebig")

			local priceinfo = vgui.Create("DLabel", vehicletypepanel)
			priceinfo:SetPos(80, 50)
			priceinfo:SetSize(w - 70 - 20, 20)
			priceinfo:SetText("Purchase For: " .. vehicletable[i][4])
			priceinfo:SetColor(Color(100,100,100,255))
			priceinfo:SetFont("fishnamesmall")

			local spawnbutton = vgui.Create("DButton", vehicletypepanel)
			spawnbutton:SetPos(w - 20 - 190, 20)
			spawnbutton:SetSize(80, 40)
			spawnbutton:SetText("Spawn")

			spawnbutton.DoClick = function()
				net.Start("VSBuyRequest")
					net.WriteInt(i, 32)
					net.WriteEntity(seller)
				net.SendToServer()
			end

			local buybutton = vgui.Create("DButton", vehicletypepanel)
			buybutton:SetPos(w - 20 - 100, 20)
			buybutton:SetSize(80, 40)
			buybutton:SetText("Purchase")

			buybutton.DoClick = function()
				net.Start("VSPurchaseRequest")
					net.WriteInt(i, 32)
				net.SendToServer()
				
			end

			
		end
	end


end 

-- Open me (again!)

net.Receive("VSOpenGUI", function(len, ply)
	local seller = net.ReadEntity()
	vehiclesalesGUI(seller)
	
end)


