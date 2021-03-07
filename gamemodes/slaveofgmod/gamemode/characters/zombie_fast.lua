//pretty much a reskin of banned character
CHARACTER.Reference = "zombie fast"

CHARACTER.Name = "Fast Zombie"
CHARACTER.Description = ""

CHARACTER.Health = 100

CHARACTER.Speed = 440//360

CHARACTER.StartingWeapon = "sogm_dog"
CHARACTER.RemoveDefaultFists = true
CHARACTER.KnockdownImmunity = true
CHARACTER.NoMenu = true

CHARACTER.Model = Model( "models/player/zombie_fast.mdl" )

CHARACTER.Icon = nil

CHARACTER.NoPickups = true

function CHARACTER:OnSpawn( pl )
	if pl:IsNextBot() and GAMEMODE:GetGametype() == "nemesis" then
		pl:SetNextBotColor( Color( 215, 77, 64 ) )
	end
end