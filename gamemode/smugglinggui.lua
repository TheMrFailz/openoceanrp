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



function smuggleGUI(contrabandname, buyer)
	local w = 500
	local h = 400

	local Frame = vgui.Create( "DFrame" )
	Frame:SetPos( ScrW() / 2 - w / 2, ScrH() / 2 - h / 2 )
	Frame:SetSize( w, h )
	Frame:SetTitle( "Contraband Buyer" )
	Frame:SetVisible( true )
	Frame:SetDraggable( true )
	Frame:ShowCloseButton( true )
	Frame:MakePopup()
	
	local smugglegoodstable = {}
	local smugglertable = {}
	
	net.Start("RequestSmuggleTable")
	net.SendToServer()

	local buyermodel = vgui.Create( "DModelPanel", Frame)
	buyermodel:SetPos(10,20)
	buyermodel:SetSize(120, 120)
	buyermodel:SetModel("models/player/group03/male_08.mdl")
	local campos2 = Vector(0,0,64)
	buyermodel:SetLookAt(campos2)
	buyermodel:SetCamPos(campos2 + Vector(20,0,0))
	function buyermodel:LayoutEntity( ent )

	end
	
	local textblurb = vgui.Create("DLabel", Frame)
	textblurb:SetPos(140, 30)
	textblurb:SetSize(w - 140 - 10, 30)
	textblurb:SetText("Hey you got the goods?")
	textblurb:SetFont("fishnamebig")

	local spanel = vgui.Create("DPanel", Frame)
	spanel:SetPos( 10,150)
	spanel:SetSize( w - 20, 250 - 10)
	
	local smugglepanel = vgui.Create("DScrollPanel", spanel)
	smugglepanel:Dock( FILL )

	net.Receive("SendSmuggleTable", function(len, ply)
		smugglegoodstable = net.ReadTable()
		
		smuggleboxes(contrabandname, smugglegoodstable)
	end)

	-- Display fish market pricing:

	function smuggleboxes(contrabandname, smugglegoodstable)
	
		for i=1, table.Count(smugglegoodstable) do
			
			local smuggletypepanel = smugglepanel:Add( "DPanel" )
			smuggletypepanel:Dock(TOP)
			smuggletypepanel:SetPos(0,0)
			smuggletypepanel:SetSize(w - 20, 80)

			local smugglemodel = vgui.Create( "DModelPanel", smuggletypepanel)
			smugglemodel:SetPos(0,10)
			smugglemodel:SetSize(70, 70)
			smugglemodel:SetModel(smugglegoodstable[i][2])
			local campos = Vector(0,0,2)
			smugglemodel:SetLookAt(campos)
			smugglemodel:SetCamPos(campos - Vector(-smugglegoodstable[i][3],0,-30))

			local contraname = vgui.Create("DLabel", smuggletypepanel)
			contraname:SetPos(80, 10)
			contraname:SetSize(w - 70 - 20, 20)
			contraname:SetText("Sell " .. smugglegoodstable[i][1])
			contraname:SetColor(Color(100,100,100,255))
			contraname:SetFont("fishnamebig")

			local priceinfo = vgui.Create("DLabel", smuggletypepanel)
			priceinfo:SetPos(80, 50)
			priceinfo:SetSize(w - 70 - 20, 20)
			priceinfo:SetText("Sell For: " .. smugglegoodstable[i][5])
			priceinfo:SetColor(Color(100,100,100,255))
			priceinfo:SetFont("fishnamesmall")

			local sellbutton = vgui.Create("DButton", smuggletypepanel)
			sellbutton:SetPos(w - 20 - 100, 20)
			sellbutton:SetSize(80, 40)
			sellbutton:SetText("Sell")

			if contrabandname == "" || contrabandname != smugglegoodstable[i][1] then
				sellbutton:SetEnabled(false)
				print("Contra name: " .. contrabandname)
			else
				
				sellbutton.DoClick = function()
					net.Start("SMSellRequest")
						net.WriteString(contrabandname)
						net.WriteEntity(buyer)
					net.SendToServer()
					
				end

			end
			
		end
	end


end 

-- Open me (again!)

net.Receive("SMOpenGUI", function(len, ply)
	local buyer = net.ReadEntity()
	local contraband = net.ReadString()
	smuggleGUI(contraband, buyer)
	
end)

function smuggleGUI2(buyer)
	local w = 500
	local h = 400

	local Frame = vgui.Create( "DFrame" )
	Frame:SetPos( ScrW() / 2 - w / 2, ScrH() / 2 - h / 2 )
	Frame:SetSize( w, h )
	Frame:SetTitle( "Contraband Seller" )
	Frame:SetVisible( true )
	Frame:SetDraggable( true )
	Frame:ShowCloseButton( true )
	Frame:MakePopup()
	
	local smugglegoodstable = {}
	local smugglertable = {}
	
	net.Start("RequestSmuggleTable")
	net.SendToServer()

	local buyermodel = vgui.Create( "DModelPanel", Frame)
	buyermodel:SetPos(10,20)
	buyermodel:SetSize(120, 120)
	buyermodel:SetModel("models/player/group03/male_09.mdl")
	local campos2 = Vector(0,0,64)
	buyermodel:SetLookAt(campos2)
	buyermodel:SetCamPos(campos2 + Vector(20,0,0))
	function buyermodel:LayoutEntity( ent )

	end
	
	local textblurb = vgui.Create("DLabel", Frame)
	textblurb:SetPos(140, 30)
	textblurb:SetSize(w - 140 - 10, 30)
	textblurb:SetText("Buy something and get out of here.")
	textblurb:SetFont("fishnamebig")

	local spanel = vgui.Create("DPanel", Frame)
	spanel:SetPos( 10,150)
	spanel:SetSize( w - 20, 250 - 10)
	
	local smugglepanel = vgui.Create("DScrollPanel", spanel)
	smugglepanel:Dock( FILL )

	net.Receive("SendSmuggleTable", function(len, ply)
		smugglegoodstable = net.ReadTable()
		
		smuggleboxes(smugglegoodstable)
	end)

	-- Display fish market pricing:

	function smuggleboxes(smugglegoodstable)
	
		for i=1, table.Count(smugglegoodstable) do
			
			local smuggletypepanel = smugglepanel:Add( "DPanel" )
			smuggletypepanel:Dock(TOP)
			smuggletypepanel:SetPos(0,0)
			smuggletypepanel:SetSize(w - 20, 80)

			local smugglemodel = vgui.Create( "DModelPanel", smuggletypepanel)
			smugglemodel:SetPos(0,10)
			smugglemodel:SetSize(70, 70)
			smugglemodel:SetModel(smugglegoodstable[i][2])
			local campos = Vector(0,0,2)
			smugglemodel:SetLookAt(campos)
			smugglemodel:SetCamPos(campos - Vector(-smugglegoodstable[i][3],0,-30))

			local contraname = vgui.Create("DLabel", smuggletypepanel)
			contraname:SetPos(80, 10)
			contraname:SetSize(w - 70 - 20, 20)
			contraname:SetText("Buy " .. smugglegoodstable[i][1])
			contraname:SetColor(Color(100,100,100,255))
			contraname:SetFont("fishnamebig")

			local priceinfo = vgui.Create("DLabel", smuggletypepanel)
			priceinfo:SetPos(80, 30)
			priceinfo:SetSize(w - 70 - 20, 40)
			priceinfo:SetText("Buy For: " .. smugglegoodstable[i][4] .. "\nSell For: " .. smugglegoodstable[i][5])
			priceinfo:SetColor(Color(100,100,100,255))
			priceinfo:SetFont("fishnamesmall")

			local sellbutton = vgui.Create("DButton", smuggletypepanel)
			sellbutton:SetPos(w - 20 - 100, 20)
			sellbutton:SetSize(80, 40)
			sellbutton:SetText("Buy")

			sellbutton.DoClick = function()
				net.Start("SMBuyRequest")
					net.WriteInt(i, 32)
					net.WriteEntity(buyer)
				net.SendToServer()
					
			end
			
		end
	end


end 
net.Receive("SMOpenGUI2", function(len, ply)
	local buyer = net.ReadEntity()
	smuggleGUI2(buyer)
	
end)

concommand.Add("smuggleguitest", function(ply, cmd, args)
	smuggleGUI2(nil)


end)

