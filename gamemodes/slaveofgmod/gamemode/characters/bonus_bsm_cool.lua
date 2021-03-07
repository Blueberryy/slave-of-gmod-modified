CHARACTER.Reference = "bonus bsm cool"

CHARACTER.Name = "Cool Big Server Men"
CHARACTER.Description = ""

CHARACTER.Health = 100
CHARACTER.Speed = 380

CHARACTER.GametypeSpecific = "singleplayer"

//CHARACTER.Icon = Material( "sog/breen.png", "smooth" )

CHARACTER.Model = Model( "models/player/breen.mdl" )

function CHARACTER:OnSpawn( pl )
	if pl:IsNextBot() then
		pl:SetNextBotColor( Color( 20, 20, 20 ) )
	end
end

function CHARACTER:OnThink( pl )
	if pl:IsNextBot() and SERVER then
		if CUR_STAGE == 2 or CUR_STAGE == 3 and not CUR_DIALOGUE then
			if Entity(1):IsValid() and Entity(1):Alive() then
				pl.NextTaunt = pl.NextTaunt or 0
				if pl.NextTaunt < CurTime() then
					Entity(1):AddScoreMessage( "sog_hud_bsm_haha", pl:GetPos() + VectorRand() * 30, math.Rand( 0.3, 0.5 ) )
					pl.NextTaunt = CurTime() + math.Rand( 0.3, 0.8 )
				end
			end
		end
	end
end

function CHARACTER:OnDraw( pl )
	
	if not pl.CoolStance then
		pl.CoolStance = 2
		pl.CheckCoolSequence = pl:LookupSequence( "pose_standing_04" )
	end
	
	if pl.CoolStance == 2 and pl.CheckCoolSequence and pl:GetSequence() == pl.CheckCoolSequence then
			
		if not pl.MirrorCoolAnims then
		
			if MIRROR_COOL_ANIMS then
				MIRROR_COOL_ANIMS = false
			else
				MIRROR_COOL_ANIMS = true
			end
		
			pl.MirrorCoolAnims = MIRROR_COOL_ANIMS and 1 or -1
		end

		
		//print(pl.MirrorCoolAnims)
	
		local sin = math.sin( RealTime() * 6 ) * 25 * pl.MirrorCoolAnims
		
		
		local bone = pl:LookupBone( "ValveBiped.Bip01_Spine1" )
		if bone then
			pl:ManipulateBoneAngles( bone, Angle( 0, -80, sin ) )
		end
		bone = pl:LookupBone( "ValveBiped.Bip01_Spine2" )
		if bone then
			pl:ManipulateBoneAngles( bone, Angle( 0, -20, sin ) )
		end
		bone = pl:LookupBone( "ValveBiped.Bip01_Spine4" )
		if bone then
			pl:ManipulateBoneAngles( bone, Angle( 0, 40, sin ) )
		end
		bone = pl:LookupBone( "ValveBiped.Bip01_Head1" )
		if bone then
			pl:ManipulateBoneAngles( bone, Angle( 0, -30, sin * -1.5 ) )
		end
		
		bone = pl:LookupBone( "ValveBiped.Bip01_L_Clavicle" )
		if bone then
			pl:ManipulateBoneAngles( bone, Angle( -sin, sin, -10) )
		end
		bone = pl:LookupBone( "ValveBiped.Bip01_R_Clavicle" )
		if bone then
			pl:ManipulateBoneAngles( bone, Angle( -sin, -sin, 10) )
		end
		
		
		bone = pl:LookupBone( "ValveBiped.Bip01_L_UpperArm" )
		if bone then
			pl:ManipulateBoneAngles( bone, Angle( 0, sin, sin ) )
		end
		bone = pl:LookupBone( "ValveBiped.Bip01_R_UpperArm" )
		if bone then
			pl:ManipulateBoneAngles( bone, Angle( 0, -sin, sin ) )
		end
		
		bone = pl:LookupBone( "ValveBiped.Bip01_L_Forearm" )
		if bone then
			pl:ManipulateBoneAngles( bone, Angle( 10, -sin * 2 + 20, -50 ) )
		end
		bone = pl:LookupBone( "ValveBiped.Bip01_R_Forearm" )
		if bone then
			pl:ManipulateBoneAngles( bone, Angle( -10, sin * 2 + 20, 50 ) )
		end

	end
	
end

