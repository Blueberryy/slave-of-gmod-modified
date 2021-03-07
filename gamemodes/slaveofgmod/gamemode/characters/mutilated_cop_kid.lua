CHARACTER.Reference = "mutilated cop kid"

CHARACTER.Name = "Mutilated Cop Kid"
CHARACTER.Description = ""

CHARACTER.Health = 150
CHARACTER.Speed = 350

CHARACTER.StartingWeapon = "sogm_glock"
CHARACTER.KnockdownTimePenalty = 2.5
CHARACTER.GametypeSpecific = "singleplayer"

CHARACTER.Model = Model( "models/player/police.mdl" )

CHARACTER.Icon = Material( "sog/police.png", "smooth" )

function CHARACTER:OnSpawn( pl )
	pl:SetMaterial( "models/zombie_poison/poisonzombie_sheet" )
end