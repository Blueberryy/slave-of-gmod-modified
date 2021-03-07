CHARACTER.Reference = "thomas"

CHARACTER.Name = "Thomas"
CHARACTER.Description = ""

CHARACTER.Health = 100
CHARACTER.Speed = 420

CHARACTER.OverrideColor = Color( 250, 0, 250 )

CHARACTER.NoPickups = true
CHARACTER.StartingWeapon = "sogm_fists_scared"
CHARACTER.RemoveDefaultFists = true
CHARACTER.CantExecute = true

CHARACTER.BonusBulletDamage = -60

CHARACTER.SpotDelay = 0.1

CHARACTER.NoMenu = true

CHARACTER.Icon = Material( "sog/thomas.png" )

CHARACTER.Model = Model( "models/player/kleiner.mdl" )

function CHARACTER:OnSpawn( pl )
	if pl:IsNextBot() then
		pl:SetNextBotColor( Color( 250, 0, 250 ) )
	end
end