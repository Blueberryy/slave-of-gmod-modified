CHARACTER.Reference = "greed crew default"

CHARACTER.Name = "Greedy Coder"
CHARACTER.Description = "Script goes in - cash comes out."

CHARACTER.Health = 100
CHARACTER.Speed = 380

CHARACTER.StartingRandomWeapon = { "sogm_pipe", "sogm_axe", "sogm_hook", "sogm_cleaver", "sogm_knife", "sogm_stunstick_normal" }

CHARACTER.Model = Model( "models/player/group02/male_06.mdl" )
//CHARACTER.NoPickups = true
CHARACTER.DontLoseWeapon = true

//CHARACTER.Hidden = true
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

