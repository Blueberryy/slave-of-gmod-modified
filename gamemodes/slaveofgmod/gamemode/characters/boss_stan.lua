CHARACTER.Reference = "boss stan"

CHARACTER.Name = "Stan"
CHARACTER.Description = ""

CHARACTER.Health = 100
CHARACTER.Speed = 300

CHARACTER.OverrideColor = Color( 0, 0, 0 )

CHARACTER.GametypeSpecific = "singleplayer"

CHARACTER.StartingWeapon = "boss_cannon"
CHARACTER.KnockdownImmunity = true

CHARACTER.InfiniteAmmo = true

CHARACTER.Boss = true

CHARACTER.Icon = Material( "sog/grigori.png", "smooth" )

CHARACTER.Model = Model( "models/player/monk.mdl" )

function CHARACTER:OnSpawn( pl )
	
	//so he wont die from his own stuff
	pl.IgnoreDmgType = DMG_BLAST
	pl.SpotDistance = 3000
	pl.AttackDistance = 800
	pl.ChaseDistance = 3000
	pl.IdleSpeed = pl.WalkSpeed
	pl.DOTCheck = 1//0.5
	
	pl:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	
	pl.Pursuit = Entity(1)
	
	//pl.loco:SetMaxYawRate( 700 )
	
	local armor = pl:SpawnBodywear( "models/combine_soldier.mdl" )
	armor:SetSkin( 1 )
	
end