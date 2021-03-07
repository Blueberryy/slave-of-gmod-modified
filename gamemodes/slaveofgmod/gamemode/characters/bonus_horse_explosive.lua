CHARACTER.Reference = "horse explosive"

CHARACTER.Name = "Explosive Horse"
CHARACTER.Description = ""

CHARACTER.Health = 900
CHARACTER.Speed = 600
CHARACTER.KnockdownImmunity = true
CHARACTER.NoPickups = true
CHARACTER.YellowBlood = true

CHARACTER.NoMenu = true
CHARACTER.DontAttack = true

CHARACTER.Horse = true

CHARACTER.StartingWeapon = "sogm_fists_thug"

CHARACTER.Model = Model( "models/zombie/poison.mdl" )

CHARACTER.WElements = {
	["horse"] = { type = "Model", model = "models/props_c17/statue_horse.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(-135.441, -111.942, -4.805), angle = Angle(-77.937, 8.88, 49.861), size = Vector(1.064, 1.064, 1.064), color = Color(228, 31, 229, 255), surpresslightning = true, material = "models/flesh", skin = 0, bodygroup = {} },
	["clip"] = { type = "ClipPlane", bone = "ValveBiped.Bip01", rel = "horse", pos = Vector(0.873, -21.108, 174.457), angle = Angle(-27.091, 0, 0)},
	["hook"] = { type = "Model", model = "models/props_junk/meathook001a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(-13.226, 11.166, -17.296), angle = Angle(-180, -60.693, 45.904), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["spear++"] = { type = "Model", model = "models/props_junk/harpoon002a.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(-2.386, 0.379, 9.241), angle = Angle(72.815, -46.548, -35.424), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["spear"] = { type = "Model", model = "models/props_junk/harpoon002a.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(0, -5.891, 0), angle = Angle(68.959, -0.436, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["spear+"] = { type = "Model", model = "models/props_junk/harpoon002a.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(7.98, 3.213, 10.572), angle = Angle(44.876, 25.295, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
}

util.PrecacheModel( "models/props_junk/meathook001a.mdl" )
util.PrecacheModel( "models/props_junk/harpoon002a.mdl" )

function CHARACTER:OnSpawn( pl )
	
	pl.ChaseDistance = 3000
	pl.DOTCheck = 1
	
	local bone = pl:LookupBone( "ValveBiped.Bip01_R_UpperArm" )
	
	if bone then
		pl:ManipulateBoneAngles( bone, Angle( 30, -30, 0 ) )
		pl:ManipulateBoneScale( bone, Vector( 1.5, 1.5, 1.5 ) )
		for _, ch in pairs( pl:GetChildBones( bone )  ) do
			if ch then
				pl:ManipulateBoneScale( ch, Vector( 1.5, 1.5, 1.5 ) )
			end
		end
	end
	
	bone = pl:LookupBone( "ValveBiped.Bip01_L_UpperArm" )
	
	if bone then
		pl:ManipulateBoneAngles( bone, Angle( 30, -30, 0 ) )
		pl:ManipulateBoneScale( bone, Vector( 1.5, 1.5, 1.5 ))
		for _, ch in pairs( pl:GetChildBones( bone )  ) do
			if ch then
				pl:ManipulateBoneScale( ch, Vector( 1.5, 1.5, 1.5 ) )
			end
		end
	end
	
	bone = pl:LookupBone( "ValveBiped.Bip01_Spine3" )
	
	if bone then
		pl:ManipulateBoneScale( bone, Vector( 1.2, 1.2, 1.2 ) )
	end
	
	bone = pl:LookupBone( "ValveBiped.Bip01_Spine" )
	
	if bone then
		pl:ManipulateBoneAngles( bone, Angle( 60, 0, 0 ) )
		pl:ManipulateBoneScale( bone, Vector( 1.2, 1.2, 1.2 ) )
	end
	
	pl:SetModelScale( 2, 0 )
	
	pl:SetMaterial( "models/flesh" )
	pl:SetColor( Color(228, 31, 229, 255) )
	
	
	
end

function CHARACTER:OverrideBodyUpdate( pl )
	
	pl.NextSequence = pl.NextSequence or 0
	local next_seq = 0
	
	local velocity = pl.loco:GetVelocity()
	
	local eye_ang = pl:EyeAngles()
	
	pl:SetPlaybackRate( 1 )
	
	local len2d = velocity:Length2D()
	
	local seq = "Idle01"
	
	if len2d > 0.5 then
		seq = "Run"
	end
		
	local seq_id, seq_dur = pl:LookupSequence( seq )
		
	if pl.NextSequence < CurTime() then
		pl:ResetSequence( seq )
	end
		
end

function CHARACTER:OnThink( pl )
	
	if pl:GetBehaviour() == BEHAVIOUR_DUMB then return end
	
	if pl.DoomTime then 
		
		if pl.DoomTime < CurTime() then
			
			if not pl.Doomed then
				pl:EmitSound( "weapons/explode"..math.random(3,5)..".wav" )
				util.BlastDamage( Entity(1), Entity(1), pl:GetPos() + vector_up * 5, 200, 9999 )
				pl.Doomed = true
			end
			
		end
		
		return
	end
		
	if Entity(1):IsValid() and Entity(1):Alive() then//and pl.Spotted and pl.Spotted < CurTime() 
					
		if Entity(1):GetPos():DistToSqr( pl:GetPos() ) < 10000 and pl:IsInView( Entity(1), 1 ) then

			pl:ResetSequenceInfo()
			pl:ResetSequence( "releasecrab" )
			pl:SetCycle( 0 )
			pl.NextSequence = CurTime() + 0.8
			
			pl.DoomTime = CurTime() + 0.8
		
			pl.loco:SetAcceleration( 0 ) 
			pl.loco:SetDeceleration( 0 )
			
			pl.WalkSpeed = 0
			pl.IdleSpeed = 0
			
			pl:EmitSound( "npc/headcrab_poison/ph_scream"..math.random(3)..".wav", 75, math.random( 60, 70 ) )
		
		end
		
	end
	
end

function CHARACTER:OnTargetSpotted( pl, target )
	
	pl.Spotted = CurTime() + 1
	
end

function CHARACTER:OverrideDeathEffects( pl, attacker, dmginfo )
	
	local e = EffectData()
		e:SetOrigin( pl:LocalToWorld( pl:OBBCenter() ) )
		e:SetScale( 7 )
		e:SetNormal( vector_up )
	util.Effect( "Explosion", e, nil, true )
	local e = EffectData()
		e:SetEntity( pl )
		e:SetOrigin( pl:GetPos() )
		e:SetNormal( dmginfo and dmginfo:GetDamageForce():GetNormal() or VectorRand() )
	util.Effect("player_gib", e, nil, true)
end