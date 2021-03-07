CHARACTER.Reference = "mutilated banned"

CHARACTER.Name = "Mutilated Banned"
CHARACTER.Description = ""

CHARACTER.Health = 1

CHARACTER.Speed = 440

CHARACTER.StartingWeapon = "sogm_dog"
CHARACTER.RemoveDefaultFists = true
CHARACTER.KnockdownImmunity = true
CHARACTER.NoMenu = true

CHARACTER.Icon = Material( "sog/victim2.png" )

CHARACTER.Model = Model( "models/player/kleiner.mdl" )

CHARACTER.Icon = nil

CHARACTER.NoPickups = true

function CHARACTER:OnSpawn( pl )
	pl:SetMaterial( "models/zombie_fast_players/fast_zombie_sheet" )
	//local armor = pl:SpawnBodywear( "models/player/zombie_fast.mdl" )
end