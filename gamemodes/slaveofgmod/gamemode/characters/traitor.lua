//CHARACTER.id = 3
CHARACTER.Reference = "traitor"

CHARACTER.Name = "TTT Traitor"
CHARACTER.Description = "Start with a knife.  Longer executions."

CHARACTER.Health = 100
CHARACTER.Speed = 380//360

//CHARACTER.CantExecute = true
CHARACTER.ExecutionHitMultiplier = 2

CHARACTER.StartingWeapon = "sogm_knife"

CHARACTER.Icon = Material( "sog/traitor.png", "smooth" )

CHARACTER.Model = Model( "models/player/leet.mdl" )

function CHARACTER:OnSpawn( pl )
	if GAMEMODE:GetGametype() == "none" then
		pl:SetGoal( GAMEMODE:GetRandomHint(), 10 )
	end
end