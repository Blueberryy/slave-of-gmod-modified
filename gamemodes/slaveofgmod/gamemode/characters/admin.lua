//CHARACTER.id = 5
CHARACTER.Reference = "admin"

CHARACTER.Name = "Paid Admin"
CHARACTER.Description = "Increased combo window.  Corrupt and weak."

CHARACTER.Health = 1
CHARACTER.Speed = 380//360

CHARACTER.AddComboWindow = 2
CHARACTER.ThrowMultiplier = 0.6

CHARACTER.Icon = Material( "sog/elite.png", "smooth" )

CHARACTER.Model = Model( "models/player/combine_super_soldier.mdl" )

function CHARACTER:OnSpawn( pl )
	if GAMEMODE:GetGametype() == "none" then
		if math.random(2) == 2 then
			pl:SetGoal( translate.Get("sog_play_tip_admin"), 10 )
		else
			pl:SetGoal( translate.Get("sog_play_tip_music"), 10 )
		end
	end
	if pl:IsNextBot() and DARKRP_TAG then
		pl:SetNextBotColor( color_white )
	end
end