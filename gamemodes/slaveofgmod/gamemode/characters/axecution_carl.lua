CHARACTER.Reference = "carl"

CHARACTER.Name = "Carl"
CHARACTER.Description = "Nothing to lose.  Starts with a shogtun."

CHARACTER.Health = 100
CHARACTER.Speed = 380

CHARACTER.StartingWeapon = "sogm_shotgun"
CHARACTER.Stylish = true

CHARACTER.GametypeSpecific = "axecution"

CHARACTER.Icon = Material( "sog/oldman.png", "smooth" )

CHARACTER.Model = Model( "models/player/hostage/hostage_04.mdl" )

function CHARACTER:OnSpawn( pl )
	if SINGLEPLAYER then return end
	if game.SinglePlayer() then
		timer.Simple( 0.2, function() 
			pl:PlayGesture( ACT_HL2MP_GESTURE_RELOAD_SHOTGUN )
		end)
	else
		pl:PlayGesture( ACT_HL2MP_GESTURE_RELOAD_SHOTGUN )
	end
end