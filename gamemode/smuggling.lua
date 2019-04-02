--[[
	Smuggling code stuff.



]]

-- Goods name, model, zoom, buy price, sell price

smugglinggoods = {
	{"Narcotics", "models/props_c17/BriefCase001a.mdl", 20, 1000, 2000},
	{"Illegal Guns", "models/props_junk/wood_crate001a.mdl", 60, 4000, 6000},
	{"Printed Money", "models/props/cs_assault/MoneyPallet.mdl" , 110, 10000, 15000}
	
	
	
	
	
}

net.Receive("RequestSmuggleTable", function(len, ply)

	net.Start("SendSmuggleTable")
		net.WriteTable(smugglinggoods)
	net.Send(ply)
end)

function sellcontra(seller, ply, contraname)
	local boxprice = 0
	for i = 1, table.Count(smugglinggoods) do
		if smugglinggoods[i][1] == contraname then 
			boxprice = smugglinggoods[i][5]
		end
	end


	seller:SellNearestContra(contraname)
	
	ply:addMoney(boxprice)
	DarkRP.notify(ply, 0, 3, "You made $" .. boxprice)
end

function buycontra(seller, ply, contraint)
	if ply:getDarkRPVar("money") - smugglinggoods[contraint][4] >= 0 then
		
		ply:addMoney(-smugglinggoods[contraint][4])
		DarkRP.notify(ply, 0, 3, "You paid $" .. smugglinggoods[contraint][4])
		seller:SpawnPurchase(smugglinggoods[contraint])
		
	end
	
end

net.Receive("SMSellRequest", function(len, ply)


	local contranamer = net.ReadString()
	local seller = net.ReadEntity()
	sellcontra(seller, ply, contranamer)
	
end)

net.Receive("SMBuyRequest", function(len, ply)

	local contraint = net.ReadInt(32, 1)
	local seller = net.ReadEntity()


	buycontra(seller, ply, contraint)
	
end)



