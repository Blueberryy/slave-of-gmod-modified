CHARACTER.Reference = "boss lick"

CHARACTER.Name = "Lick"
CHARACTER.Description = ""

CHARACTER.Health = 100
CHARACTER.Speed = 380

CHARACTER.OverrideColor = Color( 0, 0, 0 )

CHARACTER.GametypeSpecific = "singleplayer"

CHARACTER.StartingWeapon = "sogm_m1014"
CHARACTER.KnockdownImmunity = true

CHARACTER.InfiniteAmmo = true

CHARACTER.Boss = true

CHARACTER.Icon = Material( "sog/envy2.png", "smooth" )

CHARACTER.Model = Model( "models/player/group02/male_04.mdl" )

function CHARACTER:OnSpawn( pl )
		
	pl.OverrideAttackDistance = 220
	pl.SpotDistance = 220
	
end