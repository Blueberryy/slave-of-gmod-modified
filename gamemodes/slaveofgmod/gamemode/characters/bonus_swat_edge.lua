CHARACTER.Reference = "swat edge"

CHARACTER.Name = "Captain Edge"
CHARACTER.Description = "Har har"

CHARACTER.Health = 900
CHARACTER.Speed = 100
//CHARACTER.KnockdownImmunity = true
CHARACTER.NoPickups = true

CHARACTER.NoMenu = true

CHARACTER.StartingWeapon = "sogm_fists_thug"

CHARACTER.Icon = Material( "sog/cpt_edgy.png", "smooth" )

CHARACTER.HideRagdollEntity = true

CHARACTER.Model = Model( "models/player/barney.mdl" )

CHARACTER.WElements = {
	["knife"] = { type = "Model", model = "models/weapons/w_knife_t.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.231, 1.532, -8.37), angle = Angle(-3.625, -180, -1.856), size = Vector(2.167, 2.167, 2.167), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["knife+"] = { type = "Model", model = "models/weapons/w_knife_t.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(6.55, 2.127, 8.69), angle = Angle(171.817, -3.372, -0.542), size = Vector(2.167, 2.167, 2.167), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

function CHARACTER:OnSpawn( pl )
	if pl:IsNextBot() then
		pl:SetModelScale( 1.3, 0 )
	end	
	pl:SetSubMaterial( 2, "models/monk/grigori_head" )
	
	pl.SpotDistance = 3000
	pl.ChaseDistance = 3000
	
	pl.DOTCheck = 1
	
	pl.Pursuit = Entity(1)

	pl:SetDTFloat( 0, 0 )
	
	pl.TookHits = 0
	
	CAPTAIN_EDGE = pl
	
end

local max_hits = 3

function CHARACTER:OnMeleeHit( pl, hitpos, hitnormal, dir, attacker )

	if pl.TookHits and pl.TookHits < max_hits then
		if SERVER and attacker and !IsValid( pl.Knockdown ) then
			
			pl.NextHit = pl.NextHit or 0
		
			if pl.NextHit < CurTime() then
		
				pl.TookHits = pl.TookHits + 1
				pl:DoKnockdown( pl.TookHits == max_hits and 0.1 or 2, true, attacker )
				
				pl:EmitSound( "vo/npc/barney/ba_pain0"..math.random( 8, 9 )..".wav", 100, math.random( 50, 60 ) )
				
			end

		end
	end
 
	return false
end

function CHARACTER:OnBulletHit( pl, hitpos, hitnormal, dir ) 
	
	local e = EffectData()
		e:SetOrigin( hitpos )
		e:SetNormal( hitnormal )
		e:SetScale( 1 )
	util.Effect( "StunstickImpact", e, nil, true )
	
	pl:EmitSound( "player/bhit_helmet-1.wav", 100, math.random( 80,110 ) )

	
	return false
end


local stay_pos = Vector( -489.497009, -7152.705078, 0.031250 )
local look_at = Vector( -467.559875, -7152.705078, 0.031250 )
function CHARACTER:OnThink( pl )
	
	if pl.TookHits == max_hits then
		
		if SERVER then
			pl:SetBehaviour( BEHAVIOUR_DUMB )
			
			if CUR_STAGE == 3 and !pl.ChangeStage then
				pl.ChangeStage = true
				timer.Simple( 0, function()	GAMEMODE:ActivateStage( 4 ) end )
			end
			
		end
		
		pl:SetDTFloat( 0, 0 )
		
		pl.OverrideMovePos = stay_pos
		
		if pl:GetPos():Distance( stay_pos ) < 20 then
			pl:SetDTBool( 0, true )
			pl.OverrideSpeed = 0
			pl.loco:SetAcceleration( 0 ) 
			pl.loco:SetDeceleration( 0 ) 
			pl:SetDTFloat( 0, 0 )
			
			if IsValid( Entity(1) ) then
				pl.OverrideLookAt = Entity(1):GetPos()
				pl.LookAt = Entity(1):GetPos()
			end
		else
			pl.OverrideSpeed = 168
			pl.loco:SetAcceleration( 168 ) 
			pl.loco:SetDeceleration( 168 )
		end
		
	end
	
	if pl:GetBehaviour() == BEHAVIOUR_DUMB then return end
	
	if IsValid( Entity(1) ) and !Entity(1):Alive() then
		pl:SetDTBool( 0, true )
		pl.OverrideSpeed = 0
		pl.loco:SetAcceleration( 0 ) 
		pl.loco:SetDeceleration( 0 ) 
		pl:SetDTFloat( 0, 0 )
		return
	end
	
	local charge_speed = 400
	
	pl.NextCharge = pl.NextCharge or 0
		
	if pl.NextCharge < CurTime() and IsValid( Entity(1) ) and Entity(1):Alive() then
		
		pl:SetDTFloat( 0, CurTime() + 3 )
		
		pl.NextCharge = CurTime() + 4
		
		if IsValid( Entity(1) ) and Entity(1):Alive() then
			pl.OverrideSpeed = charge_speed
			pl.loco:SetAcceleration( charge_speed ) 
			pl.loco:SetDeceleration( charge_speed ) 
			//pl.OverrideMovePos = Entity(1):GetPos()
		end
	else
		//if IsValid( Entity(1) ) and ( !Entity(1):Alive() or ( Entity(1):Alive() and pl:GetPos():Distance( Entity(1):GetPos() ) < 30 ) ) then
			
		//end
	end
		
	if pl:GetDTFloat( 0 ) < CurTime() or IsValid( pl.Knockdown ) then
		
		pl:SetDTFloat( 0, 0 )
		
		if pl.OverrideSpeed == charge_speed then
			pl.OverrideSpeed = 0
			pl.loco:SetAcceleration( 0 ) 
			pl.loco:SetDeceleration( 0 ) 
		end
	
	//	print"charge"
	end
	
end

function CHARACTER:OnRemoveKnockdown( pl )
	
	pl.NextHit = CurTime() + 1
	
end

//this character kills a player, not vica versa
function CHARACTER:OnPlayerKilled( pl, attacker, dmginfo ) 
	
	//SUPER_EDGY_DEATH_COUNT = SUPER_EDGY_DEATH_COUNT or 0
	//SUPER_EDGY_DEATH_COUNT = SUPER_EDGY_DEATH_COUNT + 1
	
end

function CHARACTER:OnDraw( pl )
	
	if pl:GetDTBool( 0 ) then
	
		local bone = pl:LookupBone( "ValveBiped.Bip01_Head1" )
	
		if bone then
			pl:ManipulateBoneAngles( bone, Angle( -30, -30 , -10 ) )
		end
		
		local bone = pl:LookupBone( "ValveBiped.Bip01_Spine1" )
	
		if bone then
			pl:ManipulateBoneAngles( bone, Angle( 0, -60 , 0 ) )
		end
	
		local bone = pl:LookupBone( "ValveBiped.Bip01_L_Clavicle" )
	
		if bone then
			pl:ManipulateBoneAngles( bone, Angle( 50, 30 , -20 ) )
		end
		
		local bone = pl:LookupBone( "ValveBiped.Bip01_R_Clavicle" )
	
		if bone then
			pl:ManipulateBoneAngles( bone, Angle( -50, 30 , 20 ) )
		end
		
		local bone = pl:LookupBone( "ValveBiped.Bip01_L_Forearm" )
	
		if bone then
			pl:ManipulateBoneAngles( bone, Angle( 0, 0 , -20 ) )
		end
		
		local bone = pl:LookupBone( "ValveBiped.Bip01_L_Hand" )
	
		if bone then
			pl:ManipulateBoneAngles( bone, Angle( 0, 0 , -20 ) )
		end
		
		local bone = pl:LookupBone( "ValveBiped.Bip01_R_Forearm" )
	
		if bone then
			pl:ManipulateBoneAngles( bone, Angle( 0, 0 , 20 ) )
		end
		
		local bone = pl:LookupBone( "ValveBiped.Bip01_R_Hand" )
	
		if bone then
			pl:ManipulateBoneAngles( bone, Angle( 0, 0 , 20 ) )
		end
		
		local bone = pl:LookupBone( "ValveBiped.Bip01_L_UpperArm" )
	
		if bone then
			pl:ManipulateBoneAngles( bone, Angle( 0, 0, 0 ) )
		end
		
		local bone = pl:LookupBone( "ValveBiped.Bip01_R_UpperArm" )
	
		if bone then
			pl:ManipulateBoneAngles( bone, Angle( 0, 0, 0 ) )
		end
	
		return
	end
	
	local swing_speed = 1300
	local attack = pl:GetDTFloat( 0 ) > CurTime()
	
	pl.AttackSpeed = pl.AttackSpeed or 0
	
	pl.AttackSpeed = math.Approach( pl.AttackSpeed, attack and swing_speed or 0, 50 )
	
	local speed = pl.AttackSpeed
	local delta = math.Clamp( pl.AttackSpeed / swing_speed, 0, 1 )
	
	local bone = pl:LookupBone( "ValveBiped.Bip01_L_UpperArm" )
	
	if bone then
		pl:ManipulateBoneAngles( bone, Angle( 0, math.NormalizeAngle( RealTime() * speed ) , 0 ) )
	end
	
	local bone = pl:LookupBone( "ValveBiped.Bip01_R_UpperArm" )
	
	if bone then
		pl:ManipulateBoneAngles( bone, Angle( 0, math.NormalizeAngle( RealTime() * speed ) + 180 * delta, 0 ) )
	end
	
end

function CHARACTER:OverrideDeathEffects( pl, attacker, dmginfo )

	local e = EffectData()
		e:SetOrigin( pl:GetPos() )
		e:SetEntity( pl )
		e:SetNormal( dmginfo:GetDamageForce():GetNormal() )
		e:SetMagnitude( dmginfo:GetDamageForce():Length() )
	util.Effect( "generic_death", e, nil, true )

	local e = EffectData()
		e:SetEntity( pl )
		e:SetOrigin( pl:GetPos() )
		e:SetNormal( dmginfo and dmginfo:GetDamageForce():GetNormal() or VectorRand() )
	util.Effect("player_gib", e, nil, true)
end

local NewActivityTranslate = {}
NewActivityTranslate[ACT_MP_STAND_IDLE] = ACT_HL2MP_IDLE_ANGRY
NewActivityTranslate[ACT_MP_WALK] = ACT_HL2MP_WALK_FIST
NewActivityTranslate[ACT_MP_RUN] = ACT_HL2MP_WALK_DUEL

function CHARACTER:TranslateActivity( pl, act )
	if NewActivityTranslate[act] ~= nil then
		return NewActivityTranslate[act]
	end

	return -1
end