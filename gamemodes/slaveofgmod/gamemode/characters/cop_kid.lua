CHARACTER.Reference = "cop kid"

CHARACTER.Name = "DarkRP Cop Kid"
CHARACTER.Description = "Power tripping toddler.  Weak to knockdowns"

CHARACTER.Health = 150
CHARACTER.Speed = 350

CHARACTER.StartingWeapon = "sogm_usp"
CHARACTER.KnockdownTimePenalty = 2.5
CHARACTER.GametypeSpecific = "drama"

CHARACTER.Icon = Material( "sog/police.png", "smooth" )

CHARACTER.Model = Model( "models/player/police.mdl" )

function CHARACTER:OnSpawn( pl )
	if pl:IsNextBot() and DARKRP_TAG then
		pl:SetNextBotColor( color_white )
	end
end