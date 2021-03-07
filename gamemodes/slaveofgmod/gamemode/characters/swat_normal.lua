CHARACTER.Reference = "swat default"

CHARACTER.Name = "Normal SWAT"
CHARACTER.Description = ""

CHARACTER.Health = 100
CHARACTER.Speed = 380

CHARACTER.StartingWeapon = "sogm_stunstick_normal"

CHARACTER.Model = Model( "models/player/gasmask.mdl" )

CHARACTER.DontLoseWeapon = true

CHARACTER.GametypeSpecific = "singleplayer"
CHARACTER.NoMenu = true

CHARACTER.Icon = Material( "sog/gasmask.png", "smooth" )

function CHARACTER:OnThink( pl )
	
	if SCENE and SCENE and SCENE.Name == "scene_name_wild_ride" and pl.Tag and pl.Tag == "e1" and pl:GetBehaviour() == BEHAVIOUR_DUMB and CUR_DIALOGUE then
		
		if not pl.SpitCoffee then
			pl.SpitCoffee = CurTime() + 3
		end
		
		if pl.SpitCoffee > CurTime() then
			local head = pl:LookupBone("ValveBiped.Bip01_Head1")
			if head then
				
				pl:ManipulateBoneAngles( head, Angle( math.random( -30, 30 ), math.random( -30, 30 ), math.random( -30, 30 ) ) )
			
				local pos, ang = pl:GetBonePosition( head )
				if pos and ang then
					local e = EffectData()
						e:SetOrigin( pos + ang:Right() * 5 )
						e:SetAngles( ang )
						e:SetNormal( ang:Right() )
						e:SetScale( 1.2 )
						e:SetMagnitude( 0 )
					util.Effect( "StriderBlood", e, nil, true )
				end
			end
		end
		
	end

end

