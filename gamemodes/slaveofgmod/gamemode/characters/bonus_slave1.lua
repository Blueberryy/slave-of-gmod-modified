CHARACTER.Reference = "bonus slave1"

CHARACTER.Name = "Slave 1"
CHARACTER.Description = ""

//CHARACTER.OverrideColor = Color( 0, 0, 210 )
CHARACTER.Icon = Material( "sog/slave1.png", "smooth" )

CHARACTER.Health = 100
CHARACTER.Speed = 380

CHARACTER.NoMenu = true

CHARACTER.Model = Model( "models/player/group01/female_02.mdl" )

function CHARACTER:OnSpawn( pl )
	//pl:SetMaterial( "models/zombie_poison/poisonzombie_sheet" )
	//pl:SetSubMaterial( 3, "models/gman/plyr_sheet" )
	pl:SetSubMaterial( 2, "models/gman/gman_facehirez" )
	
	if pl:IsNextBot() then
		pl:SetNextBotColor( Color( 0, 255, 210 ) )
	end
end