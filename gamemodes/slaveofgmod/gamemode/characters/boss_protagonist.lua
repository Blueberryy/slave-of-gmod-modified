CHARACTER.Reference = "boss protagonist"

CHARACTER.Name = "Puppet"
CHARACTER.Description = ""

CHARACTER.Health = 100
CHARACTER.Speed = 300

CHARACTER.StartingWeapon = nil
CHARACTER.GametypeSpecific = "singleplayer"
CHARACTER.OverrideColor = Color( 62, 88, 106 )
CHARACTER.NormalHoldType = true
CHARACTER.NoMenu = true
CHARACTER.KnockdownImmunity = true

CHARACTER.InfiniteAmmo = true
//CHARACTER.RemoveWeaponOnDeath = true
CHARACTER.HideOriginalModel = true

CHARACTER.StartingWeapon = "sogm_fists_thug"

CHARACTER.Icon = Material( "sog/default.png", "smooth" )

CHARACTER.Model = Model( "models/player/group01/male_02.mdl")

local fingerbones = {
	"ValveBiped.Bip01_L_Finger2",
	"ValveBiped.Bip01_L_Finger21",
	"ValveBiped.Bip01_L_Finger22",
	"ValveBiped.Bip01_L_Finger3",
	"ValveBiped.Bip01_L_Finger31",
	"ValveBiped.Bip01_L_Finger32",
	"ValveBiped.Bip01_L_Finger4",
	"ValveBiped.Bip01_L_Finger41",
	"ValveBiped.Bip01_L_Finger42",
}

local flailing_bones = {
	["ValveBiped.Bip01_Spine2"] = true,
	["ValveBiped.Bip01_Spine4"] = true,
	["ValveBiped.Bip01_Spine"] = true,
	["ValveBiped.Bip01_Head1"] = true,
	//["ValveBiped.Bip01_R_UpperArm"] = true,
	["ValveBiped.Bip01_L_UpperArm"] = true,
	["ValveBiped.Bip01_L_Forearm"] = true,
	["ValveBiped.Bip01_L_Hand"] = true,
	["ValveBiped.Bip01_L_Clavicle"] = true,
	["ValveBiped.Bip01_R_Clavicle"] = true,
	["ValveBiped.Bip01_R_Forearm"] = true,
	["ValveBiped.Bip01_R_Hand"] = true,
}

local flailing_bones2 = {

	["ValveBiped.Bip01_Head1"] = true,
	//["ValveBiped.Bip01_Spine2"] = false,
	//["ValveBiped.Bip01_R_UpperArm"] = true,
	//["ValveBiped.Bip01_L_UpperArm"] = true,
	//["ValveBiped.Bip01_L_Forearm"] = false,
	//["ValveBiped.Bip01_L_Hand"] = false,
	//["ValveBiped.Bip01_L_Clavicle"] = true,
	//["ValveBiped.Bip01_R_Clavicle"] = true,
	//["ValveBiped.Bip01_R_Forearm"] = true,
	//["ValveBiped.Bip01_R_Hand"] = false,
}

/*
Reference

0	       	ValveBiped.Bip01_Pelvis
1	       	ValveBiped.Bip01_Spine2
2	       	ValveBiped.Bip01_R_UpperArm
3	       	ValveBiped.Bip01_L_UpperArm
4	       	ValveBiped.Bip01_L_Forearm
5	       	ValveBiped.Bip01_L_Hand
6	       	ValveBiped.Bip01_R_Forearm
7	       	ValveBiped.Bip01_R_Hand
8	       	ValveBiped.Bip01_R_Thigh
9	       	ValveBiped.Bip01_R_Calf
10	       	ValveBiped.Bip01_Head1
11	       	ValveBiped.Bip01_L_Thigh
12	       	ValveBiped.Bip01_L_Calf
13	       	ValveBiped.Bip01_L_Foot
14	       	ValveBiped.Bip01_R_Foot
*/

local bone_reference = {
	[0] = "ValveBiped.Bip01_Pelvis",
	[1] = "ValveBiped.Bip01_Spine2",
	[2] = "ValveBiped.Bip01_R_UpperArm",
	[3] = "ValveBiped.Bip01_L_UpperArm",
	[4] = "ValveBiped.Bip01_L_Forearm",
	[5] = "ValveBiped.Bip01_L_Hand",
	[6] = "ValveBiped.Bip01_R_Forearm",
	[7] = "ValveBiped.Bip01_R_Hand",
	[8] = "ValveBiped.Bip01_R_Thigh",
	[9] = "ValveBiped.Bip01_R_Calf",
	[10] = "ValveBiped.Bip01_Head1",
	[11] = "ValveBiped.Bip01_L_Thigh",
	[12] = "ValveBiped.Bip01_L_Calf",
	[13] = "ValveBiped.Bip01_L_Foot",
	[14] = "ValveBiped.Bip01_R_Foot",

}

local recovery_table = {
	13, 14, 12, 9, 8, 11, 0, 2
}

local recovery_table2 = {
	1, 10, 2, 6, 7
}

local recovery_bones = {}

local function DoRagdollRecovery( ent, duration )
	
	//if ent.BodyStage == 2 then return end
	
	ent.RecoveryDuration = duration
	ent.RecoveryTime = CurTime() + duration
	
	for k, v in pairs( recovery_bones ) do
		recovery_bones[ k ] = nil
	end
	
end

local function DoSecondStage( ent )
	
	ent.BodyStage = 2
	ent:SetModel( "models/Zombie/Classic_torso.mdl" )
	ent:DrawShadow( false )
	
	ent.OverrideSpeed = 150
	ent.MaxSpeed = 150
	
	ent.OverrideAttackDistance = 36
		
end

local function MakeTrails( ent )
	ent.Trails = ent.Trails or {}
	
	local start_length = 16
	local end_length = 6
	
	for k, v in pairs( ent:GetAttachments() ) do
		util.SpriteTrail( ent, v.id, Color( 20, 20, 20, math.random( 190, 200 ) ), true, start_length, end_length, math.Rand( 0.3, 0.7 ), 1 / ( start_length + end_length ) * 0.5, "Effects/bloodstream.vmt")
	end
	
end

local function RemoveTrails( ent )
	for k, v in pairs( ent.Trails or {} ) do
		SafeRemoveEntity( v )
	end
end

local function CheckUnstuck( pl )
	
	pl.NextUnstuck = pl.NextUnstuck or 0
	
	if pl.NextUnstuck >= CurTime() then return end
	
	if pl.PathObject then
		local cur_segment = pl.PathObject:FirstSegment()
		
		if cur_segment and cur_segment.area then
			
			local dir = math.random( 2 ) == 2 and 1 or -1
			
			local check_pos = pl:GetPos() + pl:GetRight() * dir * math.random( 50, 80 )
			
			local new_pos = cur_segment.area:GetClosestPointOnArea( check_pos )
			if new_pos then
				pl:SetPos( new_pos )
				pl.NextUnstuck = CurTime() + 0.5			
			end
		end
		
	end
end

function CHARACTER:OnSpawn( pl )
	
	if BOSS_RAGDOLL then SafeRemoveEntity( BOSS_RAGDOLL ) end
	if BOSS_RAGDOLL_WEAPON then SafeRemoveEntity( BOSS_RAGDOLL_WEAPON ) end
	
	pl.DOTCheck = 1
	
	pl.Pursuit = Entity(1)	
	pl.ChaseDistance = 3000
	pl.OverrideRepath = 0.1
	
	local ent = ents.Create( "prop_ragdoll" )
	if ( !IsValid( ent ) ) then return end

	ent:SetModel( pl:GetModel() )
	ent:SetAngles( pl:GetAngles() )
	ent:SetPos( pl:GetPos() )
	ent:Spawn()
	ent:Activate()
	ent:SetOwner( pl )
	ent:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	ent:AddEffects( EF_NOSHADOW )
	
	MakeTrails( ent )
	
	ent.OverrideRagdollOwner = true
	
	pl.RagdollPuppet = ent
	
	local pipe = ents.Create( "prop_dynamic" )
	pipe:SetModel( "models/props_canal/mattpipe.mdl" )
	pipe:SetPos( pl:GetPos() )
	pipe:SetAngles( pl:GetAngles() )
	pipe:Spawn()
	
	pipe:SetParent( ent )
	pipe:SetMoveType( MOVETYPE_NONE )
	pipe:AddEffects( EF_BONEMERGE )
	pipe:AddEffects( EF_NOSHADOW )
	
	//pl:SetNoDraw( true )
	
	//pl.loco:SetJumpHeight( 850 ) 
	
	pl.MaxSpeed = 300
	pl.OverrideSpeed = 300
	
	for k, v in pairs( fingerbones ) do
		local bone = ent:LookupBone( v )
		if bone then
			ent:ManipulateBoneAngles( bone, Angle( 0, -60, 0 ) )
		end
	end
	
	pl:SetDTEntity( 20, ent )
	
	BOSS_RAGDOLL = ent
	BOSS_RAGDOLL_WEAPON = pipe
	
	pl.ScreamSound = CreateSound( pl, "vo/npc/male01/no02.wav" )
	pl.ScreamSound:SetDSP(38) //57 echo, 38 spooky
	
	pl.StartleSound = CreateSound( pl, "vo/citadel/br_youfool.wav" )
	pl.StartleSound:SetDSP(38)
	
	pl.BodyStage = 1
	
	pl.CantBeExecuted = true
	pl.IgnoreDmgType = DMG_BLAST
	
	//DoSecondStage( pl )
		
end

local duration = 0.5
function CHARACTER:OnBodyUpdate( pl )
	
	if pl:GetBehaviour() == BEHAVIOUR_DUMB then
		pl:SetSequence("zombie_slump_idle_02")
	end
	
	if pl.BodyStage == 2 then
	
		pl.NextSeq = pl.NextSeq or CurTime() + duration
	
		if pl.NextSeq <= CurTime() then
			pl.NextSeq = CurTime() + duration
		end
		
		local cycle = math.Clamp( 1 - ( pl.NextSeq - CurTime() ) / duration, 0, 1 )
	
		pl:SetSequence("crawl")
		pl:SetCycle( cycle )
	end
	
end

function CHARACTER:OnThink( pl )
	
	local norm = ( Entity(1):GetPos() - pl:GetPos() ):GetNormal()
	
	local wep = pl:GetActiveWeapon()
	
	if wep and wep:IsValid() and wep.OnKill then
		wep.OnKill = nil
	end
	
	if CUR_STAGE and CUR_STAGE == 2 and not BOSS_RECOVERY then
		DoRagdollRecovery( pl, 5 )
		
		if Entity(1) and IsValid( Entity(1).AnimationOverride ) then
			Entity(1).AnimationOverride:Remove()
		end
		
		BOSS_RECOVERY = true
		
		pl.StartleDuration = CurTime() + 5
	end
	
	pl.DontAttack = pl.FrenzyState and pl.FrenzyState == 0 or false
	
	if pl.RecoveryTime then pl.DontAttack = true end
	
	if pl.ScreamSound then
		if pl.SpecialAttack and pl.SpecialAttack == "frenzy" then
			pl.ScreamSound:PlayEx( 0.4, pl.FrenzyPitch or 70 )
		else
			pl.ScreamSound:Stop()
		end
	end
	
	if pl.StartleSound then
		//if pl.StartleDuration and pl.StartleDuration > CurTime() then
			//pl.StartleSound:PlayEx( 0.9, 70 )
		//else
		//	pl.StartleSound:Stop()
		//end
	end
	
	pl.StuckTimer = pl.StuckTimer or 0
	
	if not pl:IsOnGround() then
		if pl.StuckTimer == 0 then
			pl.StuckTimer = CurTime()
		end
		if ( pl.StuckTimer + 3 ) < CurTime() and pl.StuckTimer ~= 0 then
			CheckUnstuck( pl )
			pl.StuckTimer = 0
		end
	else
		pl.StuckTimer = 0
	end
	
	if IsValid( pl.RagdollPuppet) then

		local v = pl.RagdollPuppet
		
		if pl.RecoveryTime and pl.RecoveryTime > CurTime() and pl.RecoveryDuration then
		
			pl.OverrideSpeed = 1
			
			local total = pl.BodyStage == 2 and #recovery_table2 or #recovery_table
			local delta = math.Clamp( 1 - ( pl.RecoveryTime - CurTime() ) / pl.RecoveryDuration, 0, 1 )
			
			local id = math.ceil( delta * total )

			if pl.BodyStage == 1 then
				if recovery_table[ id ] and not recovery_bones[ recovery_table[ id ] ] then
					recovery_bones[ recovery_table[ id ] ] = true
					if recovery_table[ id ] % 2 == 0 then
						pl:EmitSound("physics/wood/wood_strain"..math.random( 1, 3 )..".wav", 65, math.random( 45, 60 ), 1, CHAN_AUTO)
						pl:EmitSound("physics/body/body_medium_break"..math.random( 2, 4 )..".wav", 75, math.random( 105, 115 ))
					end
				end
			else
				if recovery_table2[ id ] and not recovery_bones[ recovery_table2[ id ] ] then
					recovery_bones[ recovery_table2[ id ] ] = true
					//if recovery_table2[ id ] % 2 == 0 then
						pl:EmitSound("physics/wood/wood_strain"..math.random( 1, 3 )..".wav", 65, math.random( 45, 60 ), 1, CHAN_AUTO)
						pl:EmitSound("physics/body/body_medium_break"..math.random( 2, 4 )..".wav", 75, math.random( 105, 115 ))
					//end
				end
			end
			
		else
			if pl.RecoveryTime then
				pl.RecoveryTime = nil
				
				for k, v in pairs( recovery_bones ) do
					recovery_bones[ k ] = nil
				end
			end
		end
		
		
		if pl.PullAttack then // and not pl.BodyStage == 2 
			
			//leaping forward
			
			pl.loco:FaceTowards( Entity(1):GetPos() )
			
			local bone = pl:LookupBone( "ValveBiped.Bip01_Spine2" )
			//local rag_bone = v:LookupBone( "ValveBiped.Bip01_Pelvis" )
			local phys_bone_id = 1 //v:TranslatePhysBoneToBone( rag_bone )
			local phys_bone = v:GetPhysicsObjectNum( phys_bone_id )
			
			if bone and phys_bone and phys_bone:IsValid() then
				
				local m = pl:GetBoneMatrix( bone )
				if m then
										
					local pos, ang = m:GetTranslation(), m:GetAngles()
					if pos and ang then
											
						phys_bone:Wake()
						phys_bone:SetDragCoefficient( 10 ) 
						phys_bone:SetAngleDragCoefficient( 20 )
						phys_bone:SetPos( pos )
											
						phys_bone:AddAngleVelocity( norm * 4000 )// ang:Forward()
						
						//ang:RotateAroundAxis( ang:Right(), math.NormalizeAngle( RealTime() * 500 )  )
						//phys_bone:SetAngles( ang )
												
					end
				end
			
			end
			
		else
		
			//print"-------------------------------"
		
			//for i=0, v:GetPhysicsObjectCount() - 1 do
			for i, b in pairs( bone_reference ) do
				
				if IsValid( pl.Knockdown ) and i > 0 then continue end
				
				local phys_bone = v:GetPhysicsObjectNum( i )
				//local rag_bone = pl:TranslatePhysBoneToBone( i )
				local bone_name = b //v:GetBoneName( rag_bone )
				local bone = pl:LookupBone( bone_name )
				
				if bone and phys_bone and phys_bone:IsValid() then
					
					phys_bone:Wake()
					phys_bone:SetDragCoefficient( 10 ) 
					phys_bone:SetAngleDragCoefficient( 20 )
					
					phys_bone:SetMaterial( "gmod_silent" )
					
					//print( i, "       ", tostring( bone_name ) )
					
					if pl.SpecialAttack and pl.SpecialAttack == "frenzy" and pl.FrenzyState > 0 and ( pl.BodyStage == 1 and i == 0 or pl.BodyStage == 2 ) then
						phys_bone:AddAngleVelocity( pl:GetForward() * ( 1000 + pl.FrenzyState * 500 ) ) //forward
					end
					
					if pl.BodyStage == 1 then
						if flailing_bones[ bone_name ] then 
							if pl.SpecialAttack and pl.SpecialAttack == "frenzy" and pl.FrenzyState == 0 then
								phys_bone:AddVelocity( VectorRand() * 400 + vector_up * 200 )
							end
							continue 
						end
					end
					
					if pl.BodyStage == 2 then
						if flailing_bones2[ bone_name ] then 
							if pl.SpecialAttack and pl.SpecialAttack == "frenzy" and pl.FrenzyState == 0 then
								phys_bone:AddVelocity( VectorRand() * 400 + vector_up * 200 )
							end
							continue 
						end
					end
					
					local m = pl:GetBoneMatrix( bone )
					if m then
										
						local pos, ang = m:GetTranslation(), m:GetAngles()
						if pos and ang then
								
							if pl.RecoveryTime then
								if recovery_bones[ i ] then
									phys_bone:SetPos( pos )
									phys_bone:SetAngles( ang )
								end
							else
								if pl:GetBehaviour() ~= BEHAVIOUR_DUMB then
									phys_bone:SetPos( pos )
									if pl.BodyStage == 2 then
										phys_bone:SetAngles( ang )
									end
								end
							end

						end
					end
				end
				
			end
		
		end
		
	end
	
	if pl:GetBehaviour() == BEHAVIOUR_DUMB then return end
	
	// 1 - frenzy
	// 2 - jump back and forth
	
	if Entity(1) then

		pl.NextForwardJump = pl.NextForwardJump or CurTime() + 5
		pl.NextSpecialAttack = pl.NextSpecialAttack or CurTime() + 8
		
		pl.SpecialAttack = pl.SpecialAttack or nil
		
		//if pl.BodyStage == 2 then return end
		
		if IsValid( pl.Knockdown ) then 
			pl.SpecialAttack = nil
			return
		end
			
		
		local dist = pl:GetPos():DistToSqr( Entity(1):GetPos() )
		
		if pl.NextForwardJump < CurTime() and dist > 90000 and not pl.SpecialAttack and Entity(1):Alive() and not pl.RecoveryTime and not pl.PullAttack then
			
			pl.loco:JumpAcrossGap( Entity(1):GetPos() + norm * ( Entity(1):GetVelocity():Length2D() / 4 ), norm ) // + norm * ( Entity(1):GetVelocity():Length2D() / 4 )
			pl.NextForwardJump = CurTime() + 5
			pl.NextSpecialAttack = CurTime() + 8
			pl.PullAttack = true
			
			pl:EmitSound( "npc/combine_soldier/gear"..math.random( 6 )..".wav", 75, math.Rand(125, 135), 1 )

		end
		
		if pl.NextSpecialAttack < CurTime() and not pl.PullAttack and not pl.SpecialAttack and Entity(1):Alive() and not pl.RecoveryTime then
			
			
			// double jump
			if dist > 150 * 150 and dist < 300 * 300 then
				pl.SpecialAttack = "double jump"
				pl.loco:JumpAcrossGap( pl:GetPos() - norm * 150, norm )
				pl.NextSpecialAttack = CurTime() + 10
			end
			
			/*pl.SpecialAttack = "frenzy"
			
			pl.FrenzyState = 0
			pl.NextFrenzy = CurTime() + 1.5
			
			pl:EmitSound( "ambient/creatures/town_child_scream1.wav", 70, 90 )
			Entity(1):ShakeView( math.random(15,20), 0.8 )
			
			pl.OverrideSpeed = 1
			
			pl.NextSpecialAttack = CurTime() + 8*/
			
		end
		
		if pl.SpecialAttack and pl.SpecialAttack == "frenzy" and pl.FrenzyState and pl.NextFrenzy and pl.NextFrenzy < CurTime() then
			
			
			pl.FrenzyState = pl.FrenzyState + 1
			
			pl.OverrideSpeed = 20 * pl.FrenzyState
			pl.NextFrenzy = CurTime() + 0.7 - 0.06 * pl.FrenzyState
			
			local wep = pl:GetActiveWeapon()
			
			if wep and wep:IsValid() then
				wep:SetNextPrimaryFire( CurTime() )
			end
			
			pl.loco:FaceTowards( Entity(1):GetPos() )
			pl.loco:FaceTowards( Entity(1):GetPos() )
			pl.loco:FaceTowards( Entity(1):GetPos() )
			
			pl.NextMeleeAttack = 0
			pl:PrimaryAttack( true )
			pl:EmitSound( "npc/zombie/claw_miss1.wav", 75, math.Rand(75, 90), 1 )
			
			//pl.loco:FaceTowards( pl:GetPos() + VectorRand() * 50 )
			
			if pl.FrenzyState == 9 then
				pl.loco:JumpAcrossGap( Entity(1):GetPos(), norm )
			end
			
			if pl.FrenzyState >= 10 then
				pl.SpecialAttack = nil
				pl.OverrideSpeed = pl.MaxSpeed
			end
			
			pl.NextSpecialAttack = CurTime() + 8
			
		end
		
		
		if not pl.SpecialAttack and pl.OverrideSpeed ~= pl.MaxSpeed then
			if not pl.RecoveryTime then
				pl.OverrideSpeed = pl.MaxSpeed
			end
		end
		
	end
	
	
	
end

function CHARACTER:OnLandOnGround( pl, ground_ent )
	
	local pl2 = Entity(1)
	
	local norm = ( pl2:GetPos() - pl:GetPos() ):GetNormal()
	
	if pl2 then
	
		local dist = pl:GetPos():DistToSqr( pl2:GetPos() )
		local pull_range = 300 * 300
		
		local norm = ( pl2:GetPos() - pl:GetPos() ):GetNormal()
		
		if pl.PullAttack then
			
			if dist < pull_range then
				pl2:SetGroundEntity( NULL )
				pl2:SetVelocity( norm * -600 )
			end
			
			pl.PullAttack = false
			
			/*local e = EffectData()
				e:SetOrigin( pl:GetShootPos() )
				e:SetNormal( vector_up )
				e:SetMagnitude( 200 )
			util.Effect( "VortDispel", e, true, true )*/
		
		end
		
		if pl.SpecialAttack and pl.SpecialAttack == "double jump" then
			
			pl.PullAttack = false
			
			if pl.DidDoubleJump then
				pl.NextSpecialAttack = CurTime() + 8
				pl.SpecialAttack = nil
				pl.DidDoubleJump = false
			else
				pl.loco:JumpAcrossGap( Entity(1):GetPos(), norm * 200 )
				pl.DidDoubleJump = true
			end

		end
		
		
	
	end
	
end

function CHARACTER:OnMeleeHit( pl, hitpos, hitnormal, dir, attacker ) 
	
	if SERVER then
		
		if pl:GetBehaviour() == BEHAVIOUR_DUMB then return false end
		
		if not pl.SpecialAttack and not pl.PullAttack and not pl.RecoveryTime then
			
			if attacker and attacker:IsPlayer() then
				attacker:EmitSound("physics/body/body_medium_break"..math.random(2, 3)..".wav")
			end
			
			//DoRagdollRecovery( pl, 5 )
			
			pl.FrenzyPitch = math.random( 60, 75 )
			
			pl.SpecialAttack = "frenzy"
				
			pl.FrenzyState = 0
			pl.NextFrenzy = CurTime() + 1.5
				
			//pl:EmitSound( "npc/stalker/go_alert2.wav", 70, 90 )
			Entity(1):ShakeView( math.random(10,15), 0.8 )
				
			pl.OverrideSpeed = 1
				
			pl.NextSpecialAttack = CurTime() + 8
		end
	end

	return false
end

function CHARACTER:OnRemoveKnockdown( pl )
	
	if pl.BodyStage == 1 then
		DoSecondStage( pl )
		DoRagdollRecovery( pl, 3 )
	else
		pl.Vulnerable = true
		DoRagdollRecovery( pl, 6 )
	end
	
	
	pl.NextForwardJump = CurTime() + 8
	pl.NextSpecialAttack = CurTime() + 8
	
end

function CHARACTER:OnDraw( pl )
	local rag = pl:GetDTEntity( 20 )
	if IsValid( rag ) and not rag.GetPlayerColor then
		rag.GetPlayerColor = function() return Vector( 62 / 255, 88 / 255, 106 / 255 ) end
	end
end

local NewActivityTranslate = {}
NewActivityTranslate[ACT_MP_STAND_IDLE] = ACT_HL2MP_WALK_ZOMBIE_06 
NewActivityTranslate[ACT_MP_WALK] = ACT_HL2MP_WALK_KNIFE//ZOMBIE
NewActivityTranslate[ACT_MP_RUN] = ACT_HL2MP_RUN_KNIFE
NewActivityTranslate[ACT_MP_CROUCH_IDLE] = ACT_HL2MP_RUN_KNIFE
NewActivityTranslate[ACT_MP_CROUCHWALK] = ACT_HL2MP_RUN_KNIFE
NewActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE] = ACT_GMOD_GESTURE_RANGE_ZOMBIE_SPECIAL
NewActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] = ACT_GMOD_GESTURE_RANGE_ZOMBIE_SPECIAL
NewActivityTranslate[ACT_MP_RELOAD_STAND] = ACT_HL2MP_RUN_KNIFE
NewActivityTranslate[ACT_MP_RELOAD_CROUCH] = ACT_HL2MP_RUN_KNIFE
NewActivityTranslate[ACT_MP_JUMP] = ACT_HL2MP_IDLE_CROUCH_KNIFE
NewActivityTranslate[ACT_RANGE_ATTACK1] = ACT_HL2MP_IDLE_CROUCH_KNIFE

local NewActivityTranslate2 = {}
NewActivityTranslate2[ACT_MP_STAND_IDLE] = ACT_IDLE
NewActivityTranslate2[ACT_MP_WALK] = ACT_WALK
NewActivityTranslate2[ACT_MP_RUN] = ACT_WALK
NewActivityTranslate2[ACT_MP_CROUCH_IDLE] = ACT_IDLE
NewActivityTranslate2[ACT_MP_CROUCHWALK] = ACT_WALK
NewActivityTranslate2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] = ACT_MELEE_ATTACK1
NewActivityTranslate2[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] = ACT_MELEE_ATTACK1
NewActivityTranslate2[ACT_MP_JUMP] = ACT_WALK
NewActivityTranslate2[ACT_RANGE_ATTACK1] = ACT_MELEE_ATTACK1


function CHARACTER:TranslateActivity( pl, act )
	
	local tbl = NewActivityTranslate//pl.BodyStage == 2 and NewActivityTranslate2 or NewActivityTranslate
	
	if tbl[ act ] ~= nil then
		return tbl[ act ]
	end

	return -1
end