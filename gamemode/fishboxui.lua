
-- Menu for fishing pots.
function fishboxinfo(box)
	local w = 400
	local h = 300
	local Frame = vgui.Create( "DFrame" )
	Frame:SetPos( ScrW() / 2 - w / 2, ScrH() / 2 - h / 2 )
	Frame:SetSize( w, h )
	Frame:SetTitle( "Fishing Pot" )
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
		net.Start("trashfishbox")
			net.WriteEntity(box)
		net.SendToServer()
	end

	net.Start("PTRequestFishTable")
		net.WriteEntity(box)
	net.SendToServer()

	net.Receive("PTSendFishTable", function(len, ply)
		local fishtabledata = net.ReadTable()
		local potcontents = net.ReadTable()


		potfishtable(fishtabledata, potcontents)
	end)

	local f2panel = vgui.Create("DPanel", Frame)
	f2panel:SetPos( 0, 60)
	f2panel:SetSize( w, h - 60)

	local fishpotinfopanel = vgui.Create("DScrollPanel", f2panel)
	fishpotinfopanel:Dock( FILL )

	function potfishtable(fishtabledata, potcontents)
		for i=1, table.Count(fishtabledata) do
			
			local fishtypepanel = fishpotinfopanel:Add( "DPanel" )
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
			fishname:SetSize(w / 2, 40)
			fishname:SetColor(Color(100,100,100,255))
			fishname:SetFont("fishnamebig")

			local fishbaseprice = vgui.Create( "DLabel", fishtypepanel)
			fishbaseprice:SetText("Quantity: " .. potcontents[i][2])
			fishbaseprice:SetPos(82, 35)
			fishbaseprice:SetSize(w / 2, 15)
			fishbaseprice:SetColor(Color(100,100,100,255))
			fishbaseprice:SetFont("fishnamesmall")
			
			local dumpfish = vgui.Create("DButton", fishtypepanel)
			dumpfish:SetText("Dump Fish")
			dumpfish:SetPos(w - 120,20)
			dumpfish:SetSize(80,40)
			dumpfish.DoClick = function()
				net.Start("PTDumpFish")
					net.WriteEntity(box)
					net.WriteInt(i, 32)
				net.SendToServer()
			end
			
			
		end
	end
end

-- "open me!"
net.Receive("BXOpenGUI", function(len, ply)
	local newbox = net.ReadEntity()

	fishboxinfo(newbox)
end)


