CHARACTER.Reference = "greed crew featured"

CHARACTER.Name = "Featured Coder"
CHARACTER.Description = "Put on sale.  50 percent off.  Still over 25 bucks."

CHARACTER.Health = 100
CHARACTER.Speed = 420

//CHARACTER.StartingWeapon = "sogm_cinderblock"
CHARACTER.StartingRandomWeapon = { "sogm_cinderblock", "sogm_sawblade" }

CHARACTER.Model = Model( "models/player/corpse1.mdl" )

CHARACTER.CantExecute = true

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