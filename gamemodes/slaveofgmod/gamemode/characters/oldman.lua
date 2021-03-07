//CHARACTER.id = 1
CHARACTER.Reference = "old man"

CHARACTER.Name = "Old Man"
CHARACTER.Description = "Killing punches.  No weapons."

CHARACTER.Health = 100

CHARACTER.Speed = 380//360

CHARACTER.StartingWeapon = "sogm_fists_kill"
CHARACTER.RemoveDefaultFists = true
CHARACTER.CanKnockThugs = true

CHARACTER.Model = Model( "models/player/hostage/hostage_04.mdl" )

CHARACTER.Icon = Material( "sog/oldman.png", "smooth" )

CHARACTER.NoPickups = true

function CHARACTER:OnSpawn( pl )
	if GAMEMODE:GetGametype() == "none" then
		pl:SetGoal( translate.Get(GAMEMODE:GetRandomHint()), 10 )
	end
end