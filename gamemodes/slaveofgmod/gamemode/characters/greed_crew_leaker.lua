CHARACTER.Reference = "greed crew leaker"

CHARACTER.Name = "Leaker/Coder"
CHARACTER.Description = "Multiple accounts."

CHARACTER.Health = 100
CHARACTER.Speed = 380

CHARACTER.StartingRandomWeapon = { "sogm_boomstick" }

CHARACTER.Model = Model( "models/player/group01/female_01.mdl" )
//CHARACTER.DontLoseWeapon = true

//CHARACTER.Hidden = true
CHARACTER.GametypeSpecific = "nemesis"
CHARACTER.NoMenu = true

function CHARACTER:OnSpawn( pl )
	if not CODERFIRED_TAG then
		CODERFIRED_TAG = true
	end
	if pl:IsNextBot() then
		pl:SetNextBotColor( Color( 215, 77, 64 ) )
		
		pl.DOTCheck = 1
		
		local b = ents.Create( "ent_doppler" )
		b:SetPos( pl:GetPos() )
		b:SetParent( pl )
		b:SetOwner( pl )
		b:Spawn()
				
	end
end