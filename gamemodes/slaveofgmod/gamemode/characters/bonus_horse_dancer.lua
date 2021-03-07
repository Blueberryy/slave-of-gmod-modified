CHARACTER.Reference = "horse dancer"

CHARACTER.Name = "Horse Dancer"
CHARACTER.Description = ""

CHARACTER.Health = 100
CHARACTER.Speed = 380

CHARACTER.Model = Model( "models/player/p2_chell.mdl" )

CHARACTER.Horse = true
//CHARACTER.YellowBlood = true

CHARACTER.KnockdownImmunity = true

CHARACTER.GametypeSpecific = "singleplayer"
CHARACTER.NoMenu = true

CHARACTER.WElements = {
	["dummy"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["horse"] = { type = "Model", model = "models/props_c17/statue_horse.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "dummy", pos = Vector(-43.93, 1.888, 33.617), angle = Angle(20.305, 60.858, 140.772), size = Vector(0.289, 0.289, 0.289), color = Color(228, 31, 89, 255), surpresslightning = true, material = "models/shiny", skin = 0, bodygroup = {} },
	["clip"] = { type = "ClipPlane", bone = "ValveBiped.Bip01", rel = "horse", pos = Vector(7.216, -3.245, 53.555), angle = Angle(-43.729, 42.563, 4.359)},
}

function CHARACTER:OnSpawn( pl )
	if pl:IsNextBot() then
		pl:SetMaterial("models/zombie_fast_players/fast_zombie_sheet" )
		//pl:SetNextBotColor( Color( 208, 43, 46 ) )
		local bone = pl:LookupBone( "ValveBiped.Bip01_Head1" )
		if bone then
			pl:ManipulateBoneScale( bone, Vector( 0.1, 0.1, 0.1 ) )
		end
	end
end