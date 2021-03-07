//CHARACTER.id = 2
CHARACTER.Reference = "detective"

CHARACTER.Name = "TTT Detective"
CHARACTER.Description = "Survive two bullets.  Slow."

CHARACTER.Health = 210
CHARACTER.Speed = 340//320

CHARACTER.Icon = Material( "sog/detective.png", "smooth" )

CHARACTER.Model = Model( "models/player/phoenix.mdl" )

function CHARACTER:OnSpawn( pl )
	if GAMEMODE:GetGametype() == "none" then
		pl:SetGoal( translate.Get(GAMEMODE:GetRandomHint()), 10 )
	end
end