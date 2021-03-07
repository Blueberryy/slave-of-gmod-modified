CHARACTER.Reference = "mutilated kid"

CHARACTER.Name = "Mutilated Kid"
CHARACTER.Description = ""

CHARACTER.Health = 100
CHARACTER.Speed = 420

CHARACTER.BonusBulletDamage = -60

CHARACTER.NoMenu = true

CHARACTER.Icon = Material( "sog/victim2.png" )

CHARACTER.Model = Model( "models/player/kleiner.mdl" )

function CHARACTER:OnSpawn( pl )
	pl:SetMaterial( "models/zombie_poison/poisonzombie_sheet" )
	pl:SetSubMaterial( 3, "models/zombie_fast_players/fast_zombie_sheet" )
	//local armor = pl:SpawnBodywear( "models/player/zombie_fast.mdl" )
end