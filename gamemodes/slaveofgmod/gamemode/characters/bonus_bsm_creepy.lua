CHARACTER.Reference = "bonus bsm creepy"

CHARACTER.Name = "True Big Server Men"
CHARACTER.Description = ""

CHARACTER.Health = 100
CHARACTER.Speed = 70
CHARACTER.KnockdownImmunity = true
CHARACTER.NoPickups = true
CHARACTER.YellowBlood = true

//CHARACTER.MeleeGesture = ACT_MELEE_ATTACK1

CHARACTER.DeathModel = Model( "models/player/breen.mdl" )
CHARACTER.HideOriginalModel = true

CHARACTER.NoMenu = true

CHARACTER.StartingWeapon = "sogm_fists_thug"

CHARACTER.Model = Model( "models/stalker.mdl" )
//CHARACTER.Model = Model( "models/antlion.mdl" ) //bullshit! for some reason this model will cause level to crash if too many nextbots collide with each otehr or something

CHARACTER.WElements = {
	//["head"] = { type = "Model", model = "models/player/breen.mdl", bone = "Antlion.Head_Bone", rel = "", pos = Vector(96.021, 122.93, 0), angle = Angle(0, -142.183, 90), size = Vector(2.446, 2.446, 2.446), color = Color(255, 255, 255, 255), surpresslightning = true, material = "", skin = 0, bodygroup = {} },
	//["clip"] = { type = "ClipPlane", bone = "ValveBiped.Bip01", rel = "head", pos = Vector(0, -0.371, 150.809), angle = Angle(-24.084, -0.889, 0)}
	["body"] = { type = "Model", model = "models/player/breen.mdl", bone = "ValveBiped.Bip01_Pelvis", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, sub_mat = { [4] = "models/zombie_fast_players/fast_zombie_sheet" }, bonemerge = false,
	bbp = function( ent, bc )
		
		local parent = ent:GetParent()
		local owner = parent.GetRagdollEntity and parent:GetRagdollEntity() or parent//:GetOwner()
		local pl = owner
		
		if owner and owner:IsValid() then
		
			local pelvis = pl:LookupBone( "ValveBiped.Bip01_Pelvis" )
			local m_pelv = pl:GetBoneMatrix( pelvis )
		
			for i=0, ent:GetBoneCount() - 1 do
			
				local bone_name = ent:GetBoneName( i )
				if bone_name then
					local bone = pl:LookupBone( bone_name )
					if bone then
						local m = ent:GetBoneMatrix( i )
						local m1 = pl:GetBoneMatrix( bone )
						if m and m1 then
							m:SetTranslation( m1:GetTranslation() )
							m:SetAngles( m1:GetAngles() )
							m:SetScale( m1:GetScale() )
							ent:SetBoneMatrix( i, m )
						end
					else
						local m = ent:GetBoneMatrix( i )
						local m_p = ent:GetBoneMatrix( ent:GetBoneParent( i ) )
						if m and m_p then
							m:SetScale( vector_origin )
							//m:SetScale( m_p:GetScale() )
							//m:SetTranslation( m_p:GetTranslation() )
							//m:Translate( m_p:GetUp() * ent:BoneLength( ent:GetBoneParent( i ) ) )
							m:SetAngles( m_p:GetAngles() )
							ent:SetBoneMatrix( i, m )
						end
					end
				else
					local m = ent:GetBoneMatrix( i )
					local m_p = ent:GetBoneMatrix( ent:GetBoneParent( i ) )
					if m and m_p then
						m:SetScale( vector_origin )
						//m:SetScale( m_p:GetScale() )
						//m:SetTranslation( m_p:GetTranslation() )
						//m:Translate( m_p:GetUp() * ent:BoneLength( ent:GetBoneParent( i ) ) )
						m:SetAngles( m_p:GetAngles() )
						ent:SetBoneMatrix( i, m )
					end
				end
			end
		end

	end	},

}
//2.446, 2.446, 2.446

//i should've just used a table instead of this bullshit
function CHARACTER:OnSpawn( pl )
	pl:SetMaterial("models/zombie_fast_players/fast_zombie_sheet" )
	
	pl.OverrideRepath = math.random( 1, 3 )
	
	pl:SetModelScale( 1.5, 0 )
	
	pl.OverrideAttackDistance = 55
	
	//pl.loco:SetJumpHeight( 60 ) 
	
	local bone = pl:LookupBone( "ValveBiped.Bip01_L_Clavicle" )
	
	if bone then
		pl:ManipulateBoneAngles( bone, Angle( -60, 30, -40 ) )
	end
	
	local bone = pl:LookupBone( "ValveBiped.Bip01_R_Clavicle" )
	
	if bone then
		pl:ManipulateBoneAngles( bone, Angle( 60, 30, 40 ) )
	end
	
	local bone = pl:LookupBone( "ValveBiped.Bip01_L_Forearm" )
	
	if bone then
		pl:ManipulateBoneAngles( bone, Angle( 0, 10, 0 ) )
	end
	
	local bone = pl:LookupBone( "ValveBiped.Bip01_R_Forearm" )
	
	if bone then
		pl:ManipulateBoneAngles( bone, Angle( 0, 10, 0 ) )
	end
		
end

function CHARACTER:OnTargetSpotted( pl, target )
	
	if pl:GetBehaviour() == BEHAVIOUR_IDLE then
	
		/*local normal = ( target:GetPos() - pl:GetPos() ):GetNormal()
		local dist = pl:GetPos():Distance( target:GetPos() )
		
		pl.loco:JumpAcrossGap( pl:GetPos() + normal * math.min( dist, 150 ), normal )*/
		
	
	
	end
	
end

function CHARACTER:OnThink( pl )
	if pl:GetBehaviour() == BEHAVIOUR_IDLE then
		pl.ReduceSpotDelay = 0.1
		pl.WalkSpeed = 350//500
		pl.IdleSpeed = 350//500
		pl.SpotDistance = 200
		pl.ChaseDistance = 600
		//pl.loco:SetAcceleration( pl.WalkSpeed ) 
		//pl.loco:SetDeceleration( pl.WalkSpeed ) 
	else
		pl.Pursuit = Entity(1)
		pl.SpotDistance = 3000
		pl.ChaseDistance = 3000
		
	end
end

function CHARACTER:OnAttack( pl )
	
	local bone = pl:LookupBone( "ValveBiped.Bip01_Spine2" )
	
	if bone then
		pl:ManipulateBoneAngles( bone, Angle( 0, 50, 0 ) )
	end
	
	local bone = pl:LookupBone( "ValveBiped.Bip01_Spine4" )
	
	if bone then
		pl:ManipulateBoneAngles( bone, Angle( 0, 20, 0 ) )
	end
	
	local bone = pl:LookupBone( "ValveBiped.Bip01_Head1" )
	
	if bone then
		pl:ManipulateBoneAngles( bone, Angle( 0, 20, 0 ) )
	end
	
end

/*function CHARACTER:OverrideBodyUpdate( pl )
	
	pl.NextSequence = pl.NextSequence or 0
	local next_seq = 0
	
	local velocity = pl.loco:GetVelocity()
	
	local eye_ang = pl:EyeAngles()
	
	pl:SetPlaybackRate( 1 )
	
	local len2d = velocity:Length2D()
	
	pl.IdleSeq = pl.IdleSeq or "DistractIdle"..math.random( 2, 4 )
	
	local seq = pl.IdleSeq
	
	if len2d > 0.5 then
		seq = "walk_all"
		pl:SetPlaybackRate( len2d/70 * 0.6 )
	end
		
	local seq_id, seq_dur = pl:LookupSequence( seq )
		
	if pl.NextSequence < CurTime() then
		pl:ResetSequence( seq )
	end
		
end*/

local NewActivityTranslate = {}
NewActivityTranslate[ACT_MP_STAND_IDLE] = ACT_IDLE
NewActivityTranslate[ACT_MP_WALK] = ACT_WALK
NewActivityTranslate[ACT_MP_RUN] = ACT_WALK
NewActivityTranslate[ACT_MP_CROUCH_IDLE] = ACT_IDLE
NewActivityTranslate[ACT_MP_CROUCHWALK] = ACT_WALK
NewActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE] = ACT_MELEE_ATTACK1
NewActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] = ACT_MELEE_ATTACK1
NewActivityTranslate[ACT_MP_RELOAD_STAND] = ACT_IDLE
NewActivityTranslate[ACT_MP_RELOAD_CROUCH] = ACT_IDLE
NewActivityTranslate[ACT_MP_JUMP] = ACT_JUMP
NewActivityTranslate[ACT_RANGE_ATTACK1] = ACT_MELEE_ATTACK1

function CHARACTER:TranslateActivity( pl, act )
	if NewActivityTranslate[act] ~= nil then
		return NewActivityTranslate[act]
	end

	return -1
end
