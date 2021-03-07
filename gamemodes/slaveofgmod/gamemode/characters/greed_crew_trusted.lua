CHARACTER.Reference = "greed crew trusted"

CHARACTER.Name = "Trusted Coder"
CHARACTER.Description = "30 bucks minimum.  Money first - result later."

CHARACTER.Health = 100
CHARACTER.Speed = 380

//CHARACTER.StartingWeapon = "sogm_uzi"
CHARACTER.StartingRandomWeapon = { "sogm_uzi", "sogm_mp5", "sogm_glock", "sogm_magnum", "sogm_shotgun" }

CHARACTER.Model = Model( "models/player/group01/male_05.mdl" )

CHARACTER.CantExecute = true
//CHARACTER.DontLoseWeapon = true

CHARACTER.GametypeSpecific = "nemesis"
CHARACTER.NoMenu = true

function CHARACTER:OnSpawn( pl )
	if not CODERFIRED_TAG then
		CODERFIRED_TAG = true
	end
	if pl:IsNextBot() then
		pl:SetNextBotColor( Color( 215, 77, 64 ) )
	end
end