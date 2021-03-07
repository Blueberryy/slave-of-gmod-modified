CHARACTER.Reference = "pufulet"

CHARACTER.Name = "Pufulet"
CHARACTER.Description = "Hey, you are not supposed to see this description!"

CHARACTER.Health = 100
CHARACTER.Speed = 300

CHARACTER.GametypeSpecific = "singleplayer"

CHARACTER.Icon = Material( "sog/pufulet.png", "smooth" )

CHARACTER.Model = Model( "models/player/monk.mdl" )

CHARACTER.WElements = {
	["glasses"] = { type = "Model", model = "models/player/items/heavy/cop_glasses.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-1.724, 0.032, 0.01), angle = Angle(0, -69.825, -90), size = Vector(0.949, 0.949, 0.949), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["hat"] = { type = "Model", model = "models/player/items/demo/hallmark.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(1.355, -0.916, 0), angle = Angle(0, -81.394, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 1, bodygroup = {} }
}