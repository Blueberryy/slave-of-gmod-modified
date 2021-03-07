AddCSLuaFile()

ENT.Type = "anim"

ENT.Hits = 3
ENT.NextHit = 0
function ENT:Initialize()

	self.Entity:GetOwner().Execution = self
	self.Entity.Owner = self.Entity:GetOwner()
	self.Entity:DrawShadow( false )	

	if SERVER then
		local wep = self.Entity:GetOwner():GetActiveWeapon()
		/*if IsValid( wep ) and not wep.IsMelee then
			self.Entity:GetOwner():ThrowCurrentWeapon( 20, true, true )
		end*/
		self.Entity:GetOwner():SetLocalVelocity( vector_origin )
		self.Entity:GetOwner():SetMoveType( MOVETYPE_NONE )
		self.NextHit = CurTime() + 0.1//0.45
	end
	
end

if SERVER then

local trace = { mask = MASK_PLAYERSOLID }
function ENT:Think()
	if IsValid(self.Entity:GetOwner()) then
		if IsValid(self.Victim) and IsValid(self.Child) and !self.Entity:GetOwner():Alive() then
			self.Child:Remove()
			return
		end

	
		if IsValid(self.Victim) and IsValid(self.Child) then
			self.Entity.Owner:SetEyeAngles( (self.Victim:GetAimVector():GetNormal() * (self.Child:GetSkin() == 1 and -1 or 1)):Angle() )
			
			local wep = self.Entity:GetOwner():GetActiveWeapon()
			
			
			if self.Entity:GetOwner():KeyDown( IN_ATTACK ) then
				if self.NextHit <= CurTime() then
					
					local delay = 0.33
					if IsValid(wep) and wep.ExecutionDelay then
						wep:SetNextPrimaryFire(CurTime() + 1)
						delay = wep.ExecutionDelay
					end
				
					self.NextHit = CurTime() + delay
					
					local wep = self.Entity:GetOwner():GetActiveWeapon()
					
					if IsValid(wep) then
						if wep.ExecutionGesture and not wep.NoExecutionGesture then
							self.Entity:GetOwner():PlayGesture( wep.ExecutionGesture )
						else
							self.Entity:GetOwner():SetAnimation(PLAYER_ATTACK1)
						end
						if self.Hits < 6 then
							self.Entity:GetOwner():ShakeView( math.random(7,9) )
							self.Victim:ShakeView( math.random(7,9) )
						else
							self.Entity:GetOwner():ShakeView( math.random(0,1) )
							self.Victim:ShakeView( math.random(0,1) )
						end
					else
						self.Entity:GetOwner():PlayGesture( ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE )
						self.Entity:GetOwner():ShakeView( math.random(2,3) )
						self.Victim:ShakeView( math.random(2,3) )
					end
					
					if IsValid(wep) and wep.PlayHitFleshSound then
						wep:PlayHitFleshSound()
					elseif IsValid(wep) and wep.EmitFireSound then
						wep:EmitFireSound()
						if wep.ShootCustomEffects then
							wep:ShootCustomEffects()
						end
					else
						//self.Victim:EmitSound("physics/body/body_medium_impact_hard"..math.random(6)..".wav")
						self.Victim:EmitSound( "npc/vort/foot_hit.wav", 130, 95 )	
						self.Victim:EmitSound("physics/body/body_medium_break"..math.random(2, 3)..".wav",55,100)
					end
					
					local eyes = self.Victim:LookupBone("ValveBiped.Bip01_Head1")
					//self.Victim:GetAttachment( self.Victim:LookupAttachment( "eyes" ) )
					
					if eyes then
						local vec = VectorRand() * math.random(-(self.BloodMultiplier or 1), (self.BloodMultiplier or 1))
						vec.z = 0
					
						local eyesPos, eyesAng = self.Victim:GetBonePosition( eyes )
						
						local aim = self:GetOwner():GetAimVector():GetNormal()
						aim.z = 0
					
						for i=1, 20 do
							trace.start = self.Victim:GetPos() + vector_up*18 + aim*(i) + VectorRand() * 2 //eyesPos + vector_up * 18
							trace.endpos = trace.start - vector_up * 66
							trace.filter = self.Entity:GetOwner()
							
							local tr = util.TraceLine( trace )
							
							//PrintTable(tr)
							
							if tr.Hit and !tr.HitWorld then
								//for i=1, (self.BloodMultiplier or 1) do
									//local vec2 = VectorRand() * math.random(-(self.BloodMultiplier or 1) * math.random(12,26), (self.BloodMultiplier or 1) * math.random(12,26))
									//vec2.z = 0
									util.Decal("Blood", tr.HitPos + tr.HitNormal * 10, tr.HitPos - tr.HitNormal * 10)
								//end
							end
						
						end
						
						if IsValid(wep) and wep.OnExecutionHit then
							wep:OnExecutionHit( self.Entity:GetOwner(), self.Victim, eyesPos )
						else
							GAMEMODE:DoBloodSpray( eyesPos + vector_up * 6, self.Entity:GetOwner():GetAimVector():GetNormal() + vec , VectorRand() * 5 , math.random(13,17) * (self.BloodMultiplier or 1), math.random( 100, 400 ) + 30 * (self.BloodMultiplier or 0) )
							//GAMEMODE:DoBloodSpray( eyesPos + vector_up * 6, vector_up, VectorRand() * 5 , math.random(13,17) * (self.BloodMultiplier or 1), math.random( 600, 800 ) + 30 * (self.BloodMultiplier or 0) )
						end
						
				end
					
					local dmginfo = DamageInfo()
						dmginfo:SetDamagePosition( self:GetPos() )
						dmginfo:SetDamage( self.DamageToKill )
						dmginfo:SetAttacker( self:GetOwner() )
						dmginfo:SetInflictor( IsValid(self:GetOwner():GetActiveWeapon()) and self:GetOwner():GetActiveWeapon() or self:GetOwner() )
						dmginfo:SetDamageType( DMG_CLUB )
						dmginfo:SetDamageForce( vector_origin )
						
					self.Victim.GenericDeath = false
						self.Victim.ToDismember = HITGROUP_HEAD
							self.Victim:TakeDamageInfo( dmginfo )
							if !self.Victim:Alive() then
								//self:GetOwner().LastExecution = CurTime()
								if IsValid(wep) then
									if wep.OnExecutionFinish then
										wep:OnExecutionFinish( self.Entity:GetOwner(), self.Victim )
									end
								end
								if self.Entity:GetOwner():GetCharTable().OnExecutionFinish then
									self.Entity:GetOwner():GetCharTable():OnExecutionFinish( self.Entity:GetOwner(), self.Victim )
								end
								//self.Victim.ToDismember = HITGROUP_HEAD
							end
						self.Victim.ToDismember = nil
					self.Victim.GenericDeath = true
					
					//self.Victim:TakeDamage( self.DamageToKill, self:GetOwner(), self:GetOwner():GetActiveWeapon() or self:GetOwner()  )
					
				end
			end
		else
			self:Remove()
		end
	else
		self:Remove()
	end
	self:NextThink( CurTime() )
end

function ENT:OnRemove()
	
	if IsValid(self.Entity.Owner) then
		self.Entity.Owner:SetMoveType(MOVETYPE_WALK)
		self.Entity.Owner.Execution = nil
	end
	
end

local stuck_trace = { mask = MASK_SOLID_BRUSHONLY, mins = Vector( - 20, - 20, 20 ), maxs = Vector( 20, 20, 30 ) }
function ENT:SetVictim( pl )
	
	self.Victim = pl
	if IsValid( pl.Knockdown ) then
		local wep = self:GetOwner():GetActiveWeapon()
		self.Child = pl.Knockdown
		//pl.Knockdown.DieTime = CurTime() + 9999
		pl.Knockdown:SetDieTime( CurTime() + 9999 )
		pl.Knockdown:SetDuration( 9999 )

		//hopefully this will fix players getting stuck after executions
				
		stuck_trace.start = pl:GetPos() + vector_up * 30
		stuck_trace.endpos = pl:GetPos() + vector_up * 30
		
		local tr = util.TraceHull( stuck_trace )
		local stuck = false
				
			
		if tr.HitWorld then
			stuck = true
		end
		
		if stuck then		
			pl:SetPos( self:GetOwner():GetPos() )
		end
		self:GetOwner():SetPos( pl:GetPos() + (self.Child:GetSkin() == 1 and self.Victim:GetAimVector():GetNormal() * 10 or vector_origin) + vector_up*10) 
		if IsValid( wep ) then
			if wep.HitsToExecute then
				self.Hits = wep.HitsToExecute
			end
			if wep.BloodMultiplier then
				self.BloodMultiplier = wep.BloodMultiplier
			end
		end
		
		if self:GetOwner():GetCharTable().ExecutionHitMultiplier then
			self.Hits = self.Hits * self:GetOwner():GetCharTable().ExecutionHitMultiplier
		end
		
		if self:GetOwner():GetCharTable().ExecutionHitOverride then
			self.Hits = self:GetOwner():GetCharTable().ExecutionHitOverride
		end
		
		if self.Victim:GetCharTable().RequiredExecutionHitOverride then
			self.Hits = self.Victim:GetCharTable().RequiredExecutionHitOverride
		end
		
		self.DamageToKill = math.Round((pl:Health() + 5 ) / self.Hits)
		
		
	end
	
end

end

if CLIENT then

function ENT:Draw()
	//self:DrawModel()
end	
	
end

hook.Add("CalcMainActivity","ExecutionAnims",function(pl,vel)
	if pl.Execution and IsValid(pl.Execution) and IsValid(pl:GetActiveWeapon()) and pl:GetActiveWeapon().IsMelee then
		if IsValid(pl:GetActiveWeapon()) then
			if pl:GetActiveWeapon().ExecutionSequence then
				local iSeq, iIdeal = pl:LookupSequence(pl:GetActiveWeapon().ExecutionSequence)
				return iIdeal, iSeq 
			end
		else
			local iSeq, iIdeal = pl:LookupSequence("cidle_melee")
			return iIdeal, iSeq 
		end
		
		
	end	
end)

hook.Add("UpdateAnimation","ExecutionAnims",function(pl, velocity, maxseqgroundspeed)
	if pl.Execution and IsValid(pl.Execution) then
		local wep = pl:GetActiveWeapon()
		if IsValid(wep) and wep.ExecutionPlaybackRate and pl:KeyDown( IN_ATTACK ) then
			pl:SetPlaybackRate( wep.ExecutionPlaybackRate )
		end
		pl:SetPoseParameter( "aim_pitch", 81.5 ) 
		return true
	end
end)