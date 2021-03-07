CHARACTER.Reference = "bonus slave3"

CHARACTER.Name = "Slave 3 (BobbleHead)"
CHARACTER.Description = ""

//CHARACTER.OverrideColor = Color( 255, 255, 210 )

CHARACTER.Health = 100
CHARACTER.Speed = 380

CHARACTER.NoMenu = true

CHARACTER.Model = Model( "models/player/gman_high.mdl" )

function CHARACTER:OnSpawn( pl )
	//pl:SetMaterial( "models/zombie_poison/poisonzombie_sheet" )
	//pl:SetSubMaterial( 3, "models/gman/plyr_sheet" )
	
	//pl:SetSubMaterial( 2, "models/gman/gman_facehirez" )
	
	local bone = pl:LookupBone( "ValveBiped.Bip01_Head1" )
	if bone then
		pl:ManipulateBoneScale( bone, Vector( 2, 2, 2 ) )
		pl:ManipulateBoneScale( bone, Vector( 2, 2, 2 )  )
	end
	
	if pl:IsNextBot() then
		pl:SetNextBotColor( Color( 255, 0, 210 ) )
	end
	
end