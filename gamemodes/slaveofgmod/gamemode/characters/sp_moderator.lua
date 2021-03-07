CHARACTER.Reference = "moderator"

CHARACTER.Name = "sog_character_moderator_name"
CHARACTER.Description = "sog_character_moderator_desc"

CHARACTER.Health = 100
CHARACTER.Speed = 380

CHARACTER.StartingWeapon = "sogm_magnum_akimbo"
CHARACTER.DontLoseWeapon = true
CHARACTER.AllowReload = true
CHARACTER.Stylish = true 
CHARACTER.BonusBulletDamage = 10
CHARACTER.BonusBulletSpeed = 300
CHARACTER.SpreadMultiplier = 0.8
CHARACTER.CantExecute = true

CHARACTER.AkimboSingleMode = true
CHARACTER.FastReload = 0.6

CHARACTER.OverrideColor = Color( 215, 77, 64 )
CHARACTER.GametypeSpecific = "singleplayer"

CHARACTER.Icon = Material( "sog/alyx.png", "smooth" )

CHARACTER.Model = Model( "models/player/alyx.mdl" )

/*function CHARACTER:OverrideSecondaryAttack( pl, weapon )
	
	if weapon and weapon:IsValid() and weapon.Akimbo and weapon.IsPistol then
		weapon:SetNextPrimaryFire(0)
		weapon:PrimaryAttack()
	end
	
end*/
