CHARACTER.Reference = "mercenary"

CHARACTER.Name = "Merc"
CHARACTER.Description = ""

CHARACTER.Health = 100
CHARACTER.Speed = 380

CHARACTER.StartingRandomWeapon = { "sogm_ak47", "sogm_shotgun", "sogm_ump", "sogm_katana", "sogm_m3" }

CHARACTER.Model = Model( "models/player/group03/male_06.mdl" )

CHARACTER.Icon = Material( "sog/merc.png", "smooth" )

CHARACTER.GametypeSpecific = "singleplayer"
CHARACTER.NoMenu = true

function CHARACTER:OnSpawn( pl )
	if pl:IsNextBot() then
		pl:SetNextBotColor( Color( 40, 40, 40 ) )
		pl.ReduceSpotDelay = 0.1
	end
end