//nextbot only character
CHARACTER.Reference = "banned"

CHARACTER.Name = "Banned"
CHARACTER.Description = "Even after being banned they can be used as dogs."

CHARACTER.Health = 1

CHARACTER.Speed = 440//360

CHARACTER.StartingWeapon = "sogm_dog"
CHARACTER.RemoveDefaultFists = true
CHARACTER.KnockdownImmunity = true
CHARACTER.NoMenu = true

CHARACTER.Model = Model( "models/player/kleiner.mdl" )

CHARACTER.Icon = nil

CHARACTER.NoPickups = true

function CHARACTER:OnSpawn( pl )
	if pl:IsNextBot() and ( CODERFIRED_TAG or GAMEMODE:GetGametype() == "nemesis" ) then
		pl:SetNextBotColor( Color( 215, 77, 64 ) )
	end
	if pl:IsNextBot() and DARKRP_TAG then
		pl:SetNextBotColor( color_white )
	end
	if BIG_SERVER_MEN_TIME then
		pl:SetModel( "models/player/breen.mdl" )
		pl:SetNextBotColor( Color( 20, 20, 20 ) )
	end
end