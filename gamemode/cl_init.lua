hook.Run("DarkRPStartedLoading")

GM.Version = "1.0.0"
GM.Name = "DarkRP"
GM.Author = "By Harry, FPtje Falco et al."

DeriveGamemode("darkrp")
DEFINE_BASECLASS("gamemode_darkrp")
GM.DarkRP = BaseClass

include("fishmarketui.lua")
include("fishpotui.lua")
include("fishboxui.lua")
include("crabpotui.lua")
include("smugglinggui.lua")
include("boatgui.lua")


net.Receive("skyboxupdatething", function(len, ply)
	render.RedownloadAllLightmaps(true)
end)