CHARACTER.Reference = "mark"

CHARACTER.Name = "sog_character_mark_name"
CHARACTER.Description = "sog_character_mark_desc"

CHARACTER.Health = 100
CHARACTER.Speed = 380

CHARACTER.StartingWeapon = "sogm_glock_axe"
CHARACTER.OverrideColor = Color( 215, 77, 64 )
CHARACTER.GametypeSpecific = "singleplayer"

CHARACTER.Icon = Material( "sog/mark.png", "smooth" )

CHARACTER.Model = Model( "models/player/group01/male_09.mdl" )

function CHARACTER:OnSpawn( pl )
	if pl:IsNextBot() then
		pl:SetNextBotColor( Color( 215, 77, 64 ) )
		if NIGHTMARE then
			local armor = pl:SpawnBodywear( "models/gibs/fast_zombie_torso.mdl" )
			
		end
	end
end