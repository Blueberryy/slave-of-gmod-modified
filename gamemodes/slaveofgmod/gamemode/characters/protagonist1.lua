CHARACTER.Reference = "pr1"

CHARACTER.Name = "Dean"
CHARACTER.Description = "Akimbo guns.  Loud and slow."

CHARACTER.Health = 100
CHARACTER.Speed = 310//335

CHARACTER.UseAkimboGuns = true
CHARACTER.StartingWeapon = "sogm_ump_akimbo"
CHARACTER.AllowReload = true
//CHARACTER.NoMelee = true

//CHARACTER.Hidden = true
CHARACTER.GametypeSpecific = "nemesis"

CHARACTER.Icon = Material( "sog/barney.png", "smooth" )

CHARACTER.Model = Model( "models/player/barney.mdl" )

function CHARACTER:OnSpawn( pl )
	
	pl:SetGoal( translate.Get("sog_play_tip_protagonist1"), 25 )

	local armor = pl:SpawnBodywear( "models/player/barney.mdl" )
end