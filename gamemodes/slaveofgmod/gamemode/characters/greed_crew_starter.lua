CHARACTER.Reference = "greed crew starter"

CHARACTER.Name = "New Coder"
CHARACTER.Description = "Where do I sign?"

CHARACTER.Health = 100
CHARACTER.Speed = 380

CHARACTER.StartingWeapon = nil

CHARACTER.Model = Model( "models/player/group01/female_04.mdl" )

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
