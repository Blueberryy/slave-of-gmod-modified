CHARACTER.Reference = "bonus bsm cool leader"

CHARACTER.Name = "Cool Big Server Men Leader"
CHARACTER.Description = ""

CHARACTER.Health = 100
CHARACTER.Speed = 380

CHARACTER.GametypeSpecific = "singleplayer"

CHARACTER.Icon = Material( "sog/bigservermen.png", "smooth" )

CHARACTER.Model = Model( "models/player/breen.mdl" )

CHARACTER.WElements = {
	["glasses"] = { type = "Model", model = "models/player/items/scout/summer_shades.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-0.005, 0.61, 0.122), angle = Angle(0, -72.376, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["hat"] = { type = "Model", model = "models/player/items/scout/fwk_scout_cap.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-0.615, -0.309, 0), angle = Angle(0, -90, -90), size = Vector(1.136, 1.136, 1.136), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

function CHARACTER:OnSpawn( pl )
	if pl:IsNextBot() then
	
		BIG_SERVER_MEN_TIME = true //just a small workaround for few other characters on same level
	
		pl:SetNextBotColor( Color( 20, 20, 20 ) )
	end
end

function CHARACTER:OnThink( pl )
	if pl:IsNextBot() and SERVER then
		if CUR_STAGE == 2 or CUR_STAGE == 3 and not CUR_DIALOGUE and game.GetMap() == "sog_shady_v1" then
			if Entity(1):IsValid() and Entity(1):Alive() then
				pl.NextTaunt = pl.NextTaunt or 0
				if pl.NextTaunt < CurTime() then
					Entity(1):AddScoreMessage( "sog_hud_bsm_haha", pl:GetPos() + VectorRand() * 30, math.Rand( 0.5, 0.8 ) )
					pl.NextTaunt = CurTime() + 0.8
				end
			end
		end
	end
end

function CHARACTER:OnDraw( pl )
	
	if not pl.CoolStance then
		pl.CoolStance = 1
		pl.CheckCoolSequence = pl:LookupSequence( "pose_standing_01" )
	end

	if pl.CoolStance == 1 and pl.CheckCoolSequence and pl:GetSequence() == pl.CheckCoolSequence then
	
		local sin = math.sin( RealTime() * 6 ) * 20
		
		local bone = pl:LookupBone( "ValveBiped.Bip01_Spine1" )
		if bone then
			pl:ManipulateBoneAngles( bone, Angle( 0, sin, 0 ) )
		end
		bone = pl:LookupBone( "ValveBiped.Bip01_Spine2" )
		if bone then
			pl:ManipulateBoneAngles( bone, Angle( 0, sin, 0 ) )
		end
		bone = pl:LookupBone( "ValveBiped.Bip01_Spine4" )
		if bone then
			pl:ManipulateBoneAngles( bone, Angle( 0, sin, 0 ) )
		end
		bone = pl:LookupBone( "ValveBiped.Bip01_Head1" )
		if bone then
			pl:ManipulateBoneAngles( bone, Angle( 0, sin * -1, 0 ) )
		end
	end	
	
end
