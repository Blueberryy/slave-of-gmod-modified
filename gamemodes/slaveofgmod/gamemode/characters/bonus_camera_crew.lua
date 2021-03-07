CHARACTER.Reference = "camera crew"

CHARACTER.Name = "Camera Crew"
CHARACTER.Description = ""

CHARACTER.Health = 100
CHARACTER.Speed = 380

CHARACTER.Model = Model( "models/player/group02/male_04.mdl" )
CHARACTER.StartingRandomWeapon = { "sogm_pipe" }

CHARACTER.GametypeSpecific = "singleplayer"
CHARACTER.NoMenu = true

function CHARACTER:OnSpawn( pl )
	if pl:IsNextBot() then
		pl:SetNextBotColor( Color( 208, 43, 46 ) )
	end
end