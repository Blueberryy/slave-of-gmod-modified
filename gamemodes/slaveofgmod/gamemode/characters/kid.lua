//CHARACTER.id = 4
CHARACTER.Reference = "kid"

CHARACTER.Name = "DarkRP Kid"
CHARACTER.Description = "Agile little shit.  Muted.  Bad at shooting."

CHARACTER.Health = 100
CHARACTER.Speed = 420//400

CHARACTER.NoMicrophone = GM:GetGametype() ~= "axecution"// small exception
CHARACTER.BonusBulletDamage = -60
//CHARACTER.SpreadMultiplier = 6

CHARACTER.Icon = Material( "sog/kleiner.png" )

CHARACTER.Model = Model( "models/player/kleiner.mdl" )

function CHARACTER:OnSpawn( pl )
	if GAMEMODE:GetGametype() == "none" then
		pl:SetGoal( translate.Get(GAMEMODE:GetRandomHint()), 10 )
	end
	
	if pl:IsNextBot() and DARKRP_TAG then
		pl:SetNextBotColor( color_white )
	end
end