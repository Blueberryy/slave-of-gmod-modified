AddCSLuaFile()

SWEP.Base 				= "sogm_melee_base" 

SWEP.WorldModel			= Model ( "models/props_junk/Shoe001a.mdl"  ) 
SWEP.HoldType			= "fist"
SWEP.DamageType 		= DMG_CLUB
SWEP.BloodMultiplier 	= 1
SWEP.HitsToExecute 		= 3

SWEP.AutoSwitchTo		= true

SWEP.Primary.Delay		= 0.33
SWEP.ExecutionDelay	 	= 0.33
SWEP.ExecutionPoints	= PTS_EXECUTION_BARE
SWEP.ExecutionSequence 	= "cidle_fist"
SWEP.ExecutionGesture 	= ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
SWEP.Hidden				= true
SWEP.KillPoints 		= PTS_BARE_KILL
SWEP.OverrideForce 		= 1900

function SWEP:OverrideAttackAnimation()
	local owner = self.Owner
	if !self:IsChargeAttacking() then
		if owner:IsPlayer() then
			owner:SetAnimation(PLAYER_ATTACK1)
		else
			owner:RestartGesture( self.ExecutionGesture  )//ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2
		end
	end
end

function SWEP:PlayHitFleshSound()
	self:EmitSound( "physics/body/body_medium_break"..math.random(2, 3)..".wav", 85, 90 )
end 

function SWEP:PlaySwingSound()
	if !self:IsChargeAttacking() then
		self.Owner:EmitSound("npc/zombie/claw_miss1.wav", 45, math.Rand(75, 80))
	end
end 

function SWEP:OnKill( ply, attacker )
	ply.ToDismember = true
end

function SWEP:OnDeploy()
	if SERVER then
		self.Ram = CreateSound(self.Owner, "npc/antlion/rumble1.wav")
	end
end

function SWEP:CanPrimaryAttack()
	if self:IsCharging() then return false end
	if self:IsChargeAttacking() then return false end

	return true
end

function SWEP:SecondaryAttack()
	if self:IsChargeAttacking() then return end
	//if self.NextCharge >= CurTime() then return end
	
	self.Owner:SetCycle( 0 )
	self:SetChargeEnd( CurTime() + 1.3)
end

local charge_trace = { mask = MASK_PLAYERSOLID + CONTENTS_DEBRIS, mins = Vector(-14,-14,-48), maxs = Vector(14,14,9) }
SWEP.NextChargeHit = 0
function SWEP:OnThink()

	//start charging at stuff
	if self:IsCharging() and self:GetChargeEnd() <= CurTime() then
		self:StopCharging()
		/*local vel = self.Owner:GetAngles():Forward() * 650 //600
					
		//vel.z = 5
		if not self.Owner:OnGround() then
			vel.z = -250
		end
		self.Owner:SetLocalVelocity( vel )*/
					
		self:SetChargeAttack(true)
		self.SkipCheck = true
	end
	
	//if we hit anyone
	if self:IsChargeAttacking() then
		
		charge_trace.start = self.Owner:GetShootPos()
		charge_trace.endpos = self.Owner:GetShootPos() + self.Owner:GetAngles():Forward() * 20
		charge_trace.filter = self.Owner
		
		local tr = util.TraceHull( charge_trace )
		
		if tr.Hit and ( tr.HitWorld or tr.Entity and ( tr.Entity:IsPlayer() and tr.Entity:Team() ~= self.Owner:Team() or tr.Entity:IsNextBot() ) and !( tr.Entity.SpawnProtection and tr.Entity.SpawnProtection > CurTime() and !tr.Entity.NoSpawnProtection ) ) then
						
			if tr.HitWorld then
				if SERVER then
				
					if self.Ram then
						self.Ram:Stop()
					end
				
					self.Owner:EmitSound("NPC_AntlionGuard.HitHard")
					self.Owner:ShakeView( math.random(12,27) ) 
					self:SetChargeAttack(false)
					local k = self.Owner:DoKnockdown( 2, true, self.Owner, false )
					k:SetSkin( 1 )
				
				end
			else
				if !(tr.Entity and tr.Entity:GetClass() == "dropped_weapon") then 
					if self.NextChargeHit < CurTime() then
						self.OverrideForce = 2300
							self:Slash()
						self.OverrideForce = 1900
						self.NextChargeHit = CurTime() + 0.05
					end
				end
			end
			
		else
			
			if SERVER then
			
				self.LastPos = self.LastPos or self.Owner:GetPos() + vector_up * 10
						
				if self.LastPos == self.Owner:GetPos() or !self.SkipCheck and self.Owner:GetVelocity():Length() < 100 then				
					self.Owner:EmitSound("NPC_AntlionGuard.HitHard")
					self.Owner:ShakeView( math.random(12,27) ) 
					self:SetChargeAttack(false)
					self.Owner:DoKnockdown( 2, true, self.Owner, false )
				else
					local vel = self.Owner:GetAngles():Forward() * 650 //600
					
					//vel.z = 5
					if not self.Owner:OnGround() then
						vel.z = -250
					end
					//self.Owner:SetGroundEntity(NULL)
					self.Owner:SetLocalVelocity( vel )
					
					self.LastPos = self:GetPos()
				end
			end
			
		end
		if self.SkipCheck then
			self.SkipCheck = false
		end
	end
	
	if self:IsCharging() and not self.Owner:KeyDown( IN_ATTACK2 ) then
		self:StopCharging()
	end
	
	self:NextThink( CurTime() )

end

function SWEP:Move(mv)
	if self:IsCharging() then
		mv:SetMaxSpeed( 0 )
	end
	if self:IsChargeAttacking() then
		self.Owner:SetGroundEntity(NULL)
		//mv:SetSideSpeed(0)
		mv:SetForwardSpeed(0)
		mv:SetVelocity(mv:GetVelocity())
	end
end

function SWEP:CalcMainActivity( vel )
	if self:IsCharging() then
		local iSeq, iIdeal = self.Owner:LookupSequence ( "seq_throw" )
		return iIdeal, iSeq
	end
	if self:IsChargeAttacking() then
		local iSeq, iIdeal = self.Owner:LookupSequence ( "run_all_charging" )
		return iIdeal, iSeq
	end
end

function SWEP:UpdateAnimation( velocity, maxseqgroundspeed )
	if self:IsCharging() then
		self.Owner:SetPlaybackRate( 0.55 )
		return true
	end
end

function SWEP:SetChargeAttack( b )
	self:SetDTBool( 10, b )
end

function SWEP:IsChargeAttacking()
	return self:GetDTBool( 10 )
end

function SWEP:StopCharging()
	self:SetChargeEnd( 0 )
end

function SWEP:IsCharging()
	return self:GetChargeEnd() > 0
end

function SWEP:SetChargeEnd( endtime )
	self:SetDTFloat( 10, endtime )
end

function SWEP:GetChargeEnd()
	return self:GetDTFloat( 10 )
end

if SERVER then
function SWEP:OnRemove()
	if self.Ram then
		self.Ram:Stop()
	end
end
end

if CLIENT then
function SWEP:OnDrawWorldModel()
	
	if IsValid(self.Owner) then
		local ent = self.Owner
		local bone = ent:LookupBone( "ValveBiped.Bip01_Spine2" )
		if bone and ent:GetManipulateBoneScale(bone) ~= Vector( 1.35, 1.35, 1.35 ) then
			ent:ManipulateBoneScale( bone, Vector( 1.35, 1.35, 1.35 )  )
		end
		
		bone = ent:LookupBone( "ValveBiped.Bip01_Spine4" )
		if bone and ent:GetManipulateBoneScale(bone) ~= Vector( 1.45, 1.45, 1.45 ) then
			ent:ManipulateBoneScale( bone, Vector( 1.45, 1.45, 1.45 )  )
		end
		
		bone = ent:LookupBone( "ValveBiped.Bip01_L_Forearm" )
		if bone and ent:GetManipulateBoneScale(bone) ~= Vector( 1.65, 1.65, 1.65 ) then
			ent:ManipulateBoneScale( bone, Vector( 1.65, 1.65, 1.65 )  )
		end
		
		bone = ent:LookupBone( "ValveBiped.Bip01_R_Forearm" )
		if bone and ent:GetManipulateBoneScale(bone) ~= Vector( 1.65, 1.65, 1.65 ) then
			ent:ManipulateBoneScale( bone, Vector( 1.65, 1.65, 1.65 )  )
		end
		
		bone = ent:LookupBone( "ValveBiped.Bip01_L_UpperArm" )
		if bone and ent:GetManipulateBoneScale(bone) ~= Vector( 1.65, 1.65, 1.65 ) then
			ent:ManipulateBoneScale( bone, Vector( 1.65, 1.65, 1.65 )  )
		end
		
		bone = ent:LookupBone( "ValveBiped.Bip01_R_UpperArm" )
		if bone and ent:GetManipulateBoneScale(bone) ~= Vector( 1.65, 1.65, 1.65 ) then
			ent:ManipulateBoneScale( bone, Vector( 1.65, 1.65, 1.65 )  )
		end
		
		bone = ent:LookupBone( "ValveBiped.Bip01_L_Hand" )
		if bone and ent:GetManipulateBoneScale(bone) ~= Vector( 2, 2, 2 ) then
			ent:ManipulateBoneScale( bone, Vector( 2, 2, 2 )  )
		end
		
		bone = ent:LookupBone( "ValveBiped.Bip01_R_Hand" )
		if bone and ent:GetManipulateBoneScale(bone) ~= Vector( 1.65, 1.65, 1.65 ) then
			ent:ManipulateBoneScale( bone, Vector( 1.65, 1.65, 1.65 )  )
		end
		
	end
		
end

function SWEP:OnRemove()
	if IsValid(self.Owner) then
		self.Owner:ResetBoneMatrix()
		self.Owner:ResetBoneScale()
	end
end

end