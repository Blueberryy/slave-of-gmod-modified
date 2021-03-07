CHARACTER.Reference = "greed crew premium"

CHARACTER.Name = "Premium Coder"
CHARACTER.Description = "Fuck you.  Also I am rich."

CHARACTER.Health = 210
CHARACTER.Speed = 350

//CHARACTER.StartingWeapon = "sogm_mp5_akimbo"
CHARACTER.StartingRandomWeapon = { "sogm_mp5_akimbo", "sogm_shotgun_akimbo", "sogm_uzi_akimbo", "sogm_ump_akimbo", "sogm_p90_akimbo" }

CHARACTER.Model = Model( "models/player/guerilla.mdl" )

CHARACTER.CantExecute = true
CHARACTER.DontLoseWeapon = true
CHARACTER.UseAkimboGuns = true

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