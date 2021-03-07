CHARACTER.Reference = "server owner"

CHARACTER.Name = "Retarded server owner"
CHARACTER.Description = "Greedy.  Decreased combo window."

CHARACTER.Health = 100
CHARACTER.Speed = 380

CHARACTER.AddComboWindow = -1.5
CHARACTER.GametypeSpecific = "drama"
CHARACTER.BonusPtsOnKill = 150
//CHARACTER.AlwaysDismemberment = true

CHARACTER.Icon = Material( "sog/breen.png", "smooth" )

CHARACTER.Model = Model( "models/player/breen.mdl" )

function CHARACTER:OnSpawn( pl )
	if pl:IsNextBot() and DARKRP_TAG then
		pl:SetNextBotColor( color_white )
	end
	if BIG_SERVER_MEN_TIME then
		if pl:IsNextBot() then
			pl:SetNextBotColor( Color( 20, 20, 20 ) )
		end
	end
end