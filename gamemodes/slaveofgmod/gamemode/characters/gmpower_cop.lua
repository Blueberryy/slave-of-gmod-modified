CHARACTER.Reference = "gmpower mod"

CHARACTER.Name = "GMod Power Moderator"
CHARACTER.Description = ""

CHARACTER.Health = 100
CHARACTER.Speed = 350

CHARACTER.StartingWeapon = "sogm_usp"
CHARACTER.KnockdownTimePenalty = 2.5
CHARACTER.GametypeSpecific = "singleplayer"

CHARACTER.NormalHoldType = true

CHARACTER.Icon = Material( "sog/police.png", "smooth" )

CHARACTER.Model = Model( "models/player/police.mdl" )

CHARACTER.OverrideColor = Color( 47, 89, 185 )

local alt = Model( "models/player/police_fem.mdl" )

function CHARACTER:OnSpawn( pl )
	
	if pl:IsNextBot() then
		if math.random(3) == 3 then
			pl:SetModel( alt )
		end
		pl:SetNextBotColor( Color( 47, 89, 185 ) )
	end
	
end