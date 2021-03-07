CHARACTER.Reference = "bystander"

CHARACTER.Name = "Bystander Guy"
CHARACTER.Description = ""

CHARACTER.Health = 100
CHARACTER.Speed = 380

CHARACTER.Model = Model( "models/player/group01/male_05.mdl" )

CHARACTER.GametypeSpecific = "singleplayer"
CHARACTER.NoMenu = true

function CHARACTER:OnSpawn( pl )
	if pl:IsNextBot() then
		pl:SetNextBotColor( Color( 155, 215, 64 ) )
	end
end