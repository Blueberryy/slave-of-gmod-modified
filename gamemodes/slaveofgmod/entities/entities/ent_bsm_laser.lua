AddCSLuaFile()

ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_BOTH

util.PrecacheModel( "models/props_lab/teleportbulkeli.mdl" )

ENT.Patterns = {}

ENT.Patterns[1] = { 
	duration = 0.5,
	data = {
		[1] = {
				length = 1250, 
				start_ang = 5, 
				goal_ang = 5 
			},
		[2] = {
				length = 1250, 
				start_ang = 5, 
				goal_ang = 5 
			},
		[3] = {
				length = 1250, 
				start_ang = 5, 
				goal_ang = 5 
			},
		[4] = {
				length = 1250, 
				start_ang = 5, 
				goal_ang = 5 
			},
			
		}
}


ENT.Patterns[2] = { 
	duration = 2,
	data = {
		[1] = {
				length = 1000, 
				start_ang = -35, 
				goal_ang = 35 
			},
		}
}

ENT.Patterns[3] = { 
	duration = 2,
	data = {
		[3] = {
				length = 1000, 
				start_ang = 35, 
				goal_ang = -35 
			},
		}
}

ENT.Patterns[4] = { 
	duration = 2,
	data = {
		[2] = {
				length = 1200, 
				start_ang = 40, 
				goal_ang = -25 
			},
		[3] = {
				length = 1200, 
				start_ang = -40, 
				goal_ang = 25 
			},
		}
}

ENT.Patterns[5] = { 
	duration = 2,
	data = {
		
		[1] = {
				length = 1200, 
				start_ang = -55, 
				goal_ang = -5 
			},
		[2] = {
				length = 1200, 
				start_ang = -25, 
				goal_ang = 5 
			},
		[3] = {
				length = 1200, 
				start_ang = 25, 
				goal_ang = -5 
			},
		[4] = {
			length = 1200, 
			start_ang = 55, 
			goal_ang = 5 
		},
	}
}

ENT.Patterns[6] = { 
	duration = 2,
	data = {
		
		[1] = {
				length = 1200, 
				start_ang = -5, 
				goal_ang = 22 
			},
		[2] = {
				length = 1200, 
				start_ang = 5, 
				goal_ang = 22 
			},
		[3] = {
				length = 1200, 
				start_ang = -5, 
				goal_ang = -22 
			},
		[4] = {
			length = 1200, 
			start_ang = 5, 
			goal_ang = -22 
		},
	}
}

ENT.Patterns[7] = { 
	duration = 2.1,
	data = {
		[2] = {
				length = 1100, 
				start_ang = 45, 
				goal_ang = -22 
			},
		[4] = {
				length = 1100, 
				start_ang = -45, 
				goal_ang = 22 
			},
		}
}

ENT.Patterns[8] = { 
	duration = 2.7,
	data = {
		[1] = {
				length = 1400, 
				start_ang = -42, 
				goal_ang = -4 
			},
		[2] = {
				length = 1400, 
				start_ang = -42, 
				goal_ang = -4 
			},
		[3] = {
				length = 1400, 
				start_ang = -42, 
				goal_ang = -4 
			},
		[4] = {
				length = 1400, 
				start_ang = 22, 
				goal_ang = -4 
			},
		}
}

ENT.Patterns[9] = { 
	duration = 2,
	data = {
		[1] = {
				length = 1250, 
				start_ang = 4, 
				goal_ang = 4 
			},
		[2] = {
				length = 1250, 
				start_ang = 4, 
				goal_ang = 4 
			},
		[3] = {
				length = 1250, 
				start_ang = 4, 
				goal_ang = 4 
			},
		[4] = {
				length = 1250, 
				start_ang = 4, 
				goal_ang = 4 
			},
			
		}
}
		


function ENT:Initialize()
		
	if SERVER then
		
		self:SetModel("models/props_lab/teleportbulkeli.mdl")
				
		self:SetMoveType( MOVETYPE_NONE )
		self:SetSolid( SOLID_NONE )
		
		//self:SetEndPos( self:GetStartPos() - self:GetForward() * 200 )
		
		self:SetCurLength( 200 )
		self:SetCurDuration( 0 )
		self:SetCurPattern( 0 )
		//self.CurLength = 200
		//self.CurDuration = 0
		//self.CurPattern = 0
		
		//self.LaserSound = CreateSound( self, "ambient/machines/electric_machine.wav" )
		
		self:SetLaserActive( false )
		//self.Active = false
		
		//timer.Simple( 15, function() self:StartLaser() end )
		
		//self:SetMaterial( "models/barnacle/barnacle_sheet" )
						
	end
	
	if CLIENT then
		
		self:DrawShadow( false )
		self:SetRenderBounds( Vector(-1518, -1518, -318), Vector(1518, 1518, 318) )
		
		self.SoundFix = ClientsideModel( "models/props_junk/PopCan01a.mdl", RENDERGROUP_BOTH )
		if self.SoundFix then
			self.SoundFix:SetPos( self:GetPos() )
			self.SoundFix:SetAngles( self:GetAngles() )
			self.SoundFix:SetNoDraw( true )				
		end
		
		self.SavePos = self:GetPos()
	
	end


end

function ENT:StartLaser()
	
	if self.Disabled then return end
	
	self:SetLaserActive( true )
	self:SetCurPattern( 1 )
	
	self:SetCurDuration( CurTime() + self.Patterns[ 1 ].duration or 0 )
	
	if self.Patterns[ self:GetCurPattern() ] and self.Patterns[ self:GetCurPattern() ].data[ self:GetLaserID() ] then	
		self:SetCurLength( self.Patterns[ self:GetCurPattern() ].data[ self:GetLaserID() ].length or 200 )
	end
	
	
	/*self.Active = true
	self.CurPattern = 1
	
	self.CurDuration = CurTime() + self.Patterns[ 1 ].duration or 0
	
	if self.Patterns[ self.CurPattern ] and self.Patterns[ self.CurPattern ].id and self.Patterns[ self.CurPattern ].id[ self.ID ] then	
		self.CurLength = self.Patterns[ 1 ].length or 200
	end*/
	
end

function ENT:UpdatePattern( p )
	
	self:SetCurPattern( p )
	
	self:SetCurDuration( CurTime() + self.Patterns[ p ].duration or 0 )
	
	if self.Patterns[ self:GetCurPattern() ] and self.Patterns[ self:GetCurPattern() ].data[ self:GetLaserID() ] then	
		self:SetCurLength( self.Patterns[ self:GetCurPattern() ].data[ self:GetLaserID() ].length or 200 )
	end
	
	/*self.CurPattern = p
	
	self.CurDuration = CurTime() + self.Patterns[ p ].duration or 0
	
	if self.Patterns[ self.CurPattern ] and self.Patterns[ self.CurPattern ].id and self.Patterns[ self.CurPattern ].id[ self.ID ] then	
		self.CurLength = self.Patterns[ p ].length or 200
	end*/
	
end



function ENT:StopLaser( destroy )
	
	self:SetLaserActive( false )
	self:SetCurPattern( 0 )
	self:SetCurDuration( 0 )
	self:SetCurLength( 200 )
	
	if destroy then
		
		self:SetCurPattern( 10 )
	
		self.Disabled = true
		
		local e = EffectData()
			e:SetOrigin( self:LocalToWorld( self:OBBCenter() ) )
			e:SetNormal( vector_up )
			e:SetMagnitude( 10 )
			e:SetScale( 10 )
		util.Effect( "Explosion", e, true, true )
		
		if CUR_STAGE == 2 and self:GetLaserID() == 1 then
			timer.Simple( 0, function()	GAMEMODE:ActivateStage( 3 ) end )
		end
		
	end
	
	/*self.Active = false
	self.CurPattern = 0
	self.CurDuration = 0
	self.CurLength = 200*/
	
end

if SERVER then
	function ENT:UpdateTransmitState()
		return TRANSMIT_ALWAYS
	end
end

function ENT:SetStartAngle( ang )
	self:SetDTAngle( 0, ang )
end

function ENT:SetGoalAngle( ang )
	self:SetDTAngle( 1, ang )
end

function ENT:GetStartAngle()
	return self:GetDTAngle( 0 )
end

function ENT:GetGoalAngle()
	return self:GetDTAngle( 1 )
end

local off_pos = Vector( 0.75, -9.57, 64.78 )

function ENT:GetStartPos()
	return self:LocalToWorld( off_pos )
end

function ENT:SetEndPos( vec )
	self:SetDTVector( 0, vec )
end

function ENT:GetEndPos()
	return self:GetDTVector( 0 )
end

function ENT:SetLaserID( id )
	self:SetDTInt( 0, id )
	//self.ID = id
end

function ENT:GetLaserID()
	return self:GetDTInt( 0 )
	//return self.ID
end

function ENT:SetCurPattern( p )
	self:SetDTInt( 1, p )
end

function ENT:GetCurPattern()
	return self:GetDTInt( 1 )
end

function ENT:SetCurLength( len )
	self:SetDTInt( 2, len )
end

function ENT:GetCurLength()
	return self:GetDTInt( 2 )
end

function ENT:SetCurDuration( dur )
	self:SetDTFloat( 0, dur )
end

function ENT:GetCurDuration()
	return self:GetDTFloat( 0 )
end

function ENT:SetLaserActive( bl )
	self:SetDTBool( 0, bl )
end

function ENT:IsLaserActive()
	return self:GetDTBool( 0 )
end

function ENT:OverridePatterns( bl )
	self:SetDTBool( 1, bl )
end

function ENT:GetOverridePatterns()
	return self:GetDTBool( 1 )
end

ENT.TraceOutput = {}
ENT.TraceData = { ignoreworld = true, collisiongroup = COLLISION_GROUP_PLAYER }

ENT.TraceDataNextbot = { ignoreworld = true, mask = MASK_SHOT }


//ENT.TraceData.output = ENT.TraceOutput
function ENT:Think()
	
	if SERVER then
		
		if CUR_STAGE == 2 then
			
			if not CUR_DIALOGUE and IsValid( Entity(1) ) and Entity(1):Alive() and not self:IsLaserActive() then
				self:StartLaser()
			end
			
			if self:IsLaserActive() and !Entity(1):Alive() then
				self:StopLaser()
			end
			
			
		end
		
		if self:IsLaserActive() then
		
			/*if self.LaserSound then
				self.LaserSound:PlayEx( 1, 100 )
			end*/
			
			local forward = self:GetForward() * -1
			local ang = forward:Angle()

			if self:GetCurDuration() and self:GetCurDuration() <= CurTime() then
				
				if self.Patterns[ self:GetCurPattern() + 1 ] then
					self:UpdatePattern( self:GetCurPattern() + 1 )
					
					if self:GetCurPattern() == 9 then
						self:EmitSound( "npc/scanner/cbot_energyexplosion1.wav" )
					end
					
				else
					//self:StartLaser()
					self:StopLaser( true )
				end
				
			end
			
			if self.Patterns[ self:GetCurPattern() ] and self.Patterns[ self:GetCurPattern() ].data[ self:GetLaserID() ] and self:GetCurDuration() and self:GetCurDuration() > CurTime() then
				
				local delta =  math.Clamp( 1 - ( self:GetCurDuration() - CurTime() )/self.Patterns[ self:GetCurPattern() ].duration, 0, 1 )
				
				local ang1 = forward:Angle()
				local ang2 = forward:Angle()
				
				ang1:RotateAroundAxis( vector_up, self.Patterns[ self:GetCurPattern() ].data[ self:GetLaserID() ].start_ang )
				ang2:RotateAroundAxis( vector_up, self.Patterns[ self:GetCurPattern() ].data[ self:GetLaserID() ].goal_ang )
				
				
				local desired_ang = LerpAngle( delta, ang1, ang2 )
				
				forward = desired_ang:Forward()
				
				if not self.SetPropFilter then
					self.TraceData.filter = table.Copy( self.PropFilter )
					self.TraceDataNextbot.filter = table.Copy( self.PropFilter )
					table.insert( self.TraceDataNextbot.filter, Entity(1) )
					self.SetPropFilter = true
				end
				
				self.TraceData.start = self:GetStartPos()
				self.TraceData.start.z = self.TraceData.start.z - 40
				
				self.TraceData.endpos = self:GetStartPos() + forward * self:GetCurLength()
				self.TraceData.endpos.z = self.TraceData.endpos.z - 40
				
				local tr = util.TraceLine( self.TraceData )
				
				self.NextDamage = self.NextDamage or 0
				
				if tr.Hit and tr.Entity and tr.Entity:IsPlayer() then
					
					if self.NextDamage < CurTime() then
						
						local dmginfo = DamageInfo() 
						dmginfo:SetDamage( 9999 )
						dmginfo:SetAttacker( self )
						dmginfo:SetInflictor( self )
						dmginfo:SetDamagePosition( tr.HitPos )
						dmginfo:SetDamageForce( tr.Entity:GetVelocity() * 1.2 )
						dmginfo:SetDamageType( DMG_DISSOLVE )
						
						tr.Entity:EmitSound( "ambient/levels/citadel/weapon_disintegrate"..math.random(4)..".wav" )
						
						tr.Entity:TakeDamageInfo( dmginfo )
						
						self.NextDamage = CurTime() + 0.8
						//print(tr.Entity)
					end
				
					
				end
			
			else				
				self:SetCurLength( 200 )
				//self:StartLaser()
			end
			
			//self:SetEndPos( self:GetStartPos() + forward * self.CurLength )
		
		else
		
			if LASER_ATTACK_TARGET and LASER_ATTACK_TARGET:IsValid() and not self:GetOverridePatterns() then
				self:OverridePatterns( true )
				self.NextDamage = CurTime() + 1.5
				self:EmitSound( "ambient/levels/citadel/zapper_warmup1.wav" )
			end
				
			if !IsValid( LASER_ATTACK_TARGET ) and self:GetOverridePatterns() then
				self:OverridePatterns( false )
			end
			
			if self:GetOverridePatterns() then
					
				if LASER_ATTACK_TARGET and LASER_ATTACK_TARGET:IsValid() then
						
					local pos = LASER_ATTACK_TARGET:GetShootPos()
					pos.z = self:GetStartPos().z - 40
						
					self:SetEndPos( pos )
						
					/*self.TraceDataNextbot.start = self:GetStartPos()
					self.TraceDataNextbot.start.z = self.TraceData.start.z - 40
				
					self.TraceDataNextbot.endpos = pos
						
					local tr = util.TraceLine( self.TraceData )*/
				
					self.NextDamage = self.NextDamage or 0
					
						
					//if tr.Hit and tr.Entity and tr.Entity:IsNextBot() then
						
						if self.NextDamage < CurTime() then
								
							local dmginfo = DamageInfo() 
							dmginfo:SetDamage( 9999 )
							dmginfo:SetAttacker( self )
							dmginfo:SetInflictor( self )
							dmginfo:SetDamagePosition( pos )
							dmginfo:SetDamageForce( vector_origin )
							dmginfo:SetDamageType( DMG_DISSOLVE )
								
							LASER_ATTACK_TARGET:EmitSound( "ambient/levels/citadel/weapon_disintegrate"..math.random(4)..".wav" )
							LASER_ATTACK_TARGET:EmitSound( "npc/antlion_guard/antlion_guard_die2.wav" )
							LASER_ATTACK_TARGET:TakeDamageInfo( dmginfo )
							
							local dissolve = ents.Create( "env_entity_dissolver" )
							dissolve:SetPos( LASER_ATTACK_TARGET:GetPos() )

							local targname = "dis"..LASER_ATTACK_TARGET:EntIndex()
							LASER_ATTACK_TARGET:SetName(targname)
							dissolve:SetKeyValue( "target", targname )
							dissolve:SetKeyValue( "dissolvetype", 1 )
							dissolve:SetKeyValue( "magnitude", 0 )
							dissolve:Spawn()
							dissolve:Fire( "Dissolve", targname, 0 )
							dissolve:Fire( "kill", "", 1 )
								
							self.NextDamage = CurTime() + 1
								//print(tr.Entity)
						end
						
							
					//end
						
				end
					
			end
		
			//self:SetEndPos( self:GetStartPos() - self:GetForward() * 200 )
			/*if self.LaserSound then
				self.LaserSound:Stop()
			end*/
		end
		
	end
	
	if CLIENT then
			
		if self:IsLaserActive() then
		
			if not self.LaserSound and self.SoundFix and self.SoundFix:IsValid() then
				self.LaserSound = CreateSound( self, "ambient/machines/electric_machine.wav" )
			end
		
			if self.LaserSound then
				self.LaserSound:PlayEx( 0.85, 105 + math.sin( RealTime() * 1 ) + 10 ) 
			end
		else
			if self.LaserSound then

				//print(self.LaserSound:IsPlaying())
			
				self.LaserSound:Stop() 
				
			end
		end
	end
	
	
	self:NextThink( CurTime() )
	return true
	
end

if CLIENT then

local mat_beam = Material( "effects/bloodstream" )
local mat_beam2 = Material( "effects/tool_tracer" )
local mat_beam3 = Material( "effects/laser1" )

local mat_glow = Material( "effects/redflare" )
local mat_glow2 = Material( "effects/yellowflare" )


//second trace to make lasers look prettier
ENT.TraceData2 = { mask = MASK_NPCWORLDSTATIC }

function ENT:DrawLaser()
	
	
	local start = self:GetStartPos()
	local endpos = start - self:GetForward() * 200
	
	if self:IsLaserActive() then
			
		local forward = self:GetForward() * -1
		local ang = forward:Angle()
		
		if self.Patterns[ self:GetCurPattern() ] and self.Patterns[ self:GetCurPattern() ].data[ self:GetLaserID() ] and self:GetCurDuration() and self:GetCurDuration() > CurTime() then
				
				local delta =  math.Clamp( 1 - ( self:GetCurDuration() - CurTime() )/self.Patterns[ self:GetCurPattern() ].duration, 0, 1 )
				//local desired_ang = self.Patterns[ self.CurPattern ].start_ang + ( self.Patterns[ self.CurPattern ].goal_ang - self.Patterns[ self.CurPattern ].start_ang ) * delta
				
				local ang1 = forward:Angle()
				local ang2 = forward:Angle()
				
				ang1:RotateAroundAxis( vector_up, self.Patterns[ self:GetCurPattern() ].data[ self:GetLaserID() ].start_ang )
				ang2:RotateAroundAxis( vector_up, self.Patterns[ self:GetCurPattern() ].data[ self:GetLaserID() ].goal_ang )
				
				//ang:RotateAroundAxis( vector_up, desired_ang )
				
				local desired_ang = LerpAngle( delta, ang1, ang2 )
				
				forward = desired_ang:Forward()
				
				endpos = start + forward * self:GetCurLength()
				
				if self.SoundFix and self.SoundFix:IsValid() then
					self.SoundFix:SetPos( start + forward * self:GetCurLength() / 2 )
					
					//if self.LaserSound then
					//	self.LaserSound:PlayEx( 0.4, 110 + math.sin( RealTime() * 1 ) + 5 ) 
					//end
					
				end
				
				self.TraceData2.start = start + forward * self:GetCurLength() / 2
				self.TraceData2.endpos = self.TraceData2.start + forward * self:GetCurLength() / 2
				
				local tr = util.TraceLine( self.TraceData2 )
				
				if tr.Hit and tr.HitWorld then
					endpos = tr.HitPos	

					self.NextSparks = self.NextSparks or 0
					
					if self.NextSparks < CurTime() then
						
						local e = EffectData()
							e:SetOrigin( tr.HitPos )
							e:SetNormal( tr.HitNormal )
							e:SetMagnitude( 1 )
							e:SetScale( 1 )
							e:SetRadius( 1 )
						util.Effect( "Sparks", e )
					
						self.NextSparks = CurTime() + 0.03
					end
				else
				
					self.TraceData2.start = start + forward * self:GetCurLength()
					self.TraceData2.endpos = self.TraceData2.start - vector_up * 90
					
					local tr = util.TraceLine( self.TraceData2 )
					
					if tr.Hit and tr.HitWorld then
						
						self.NextSparks = self.NextSparks or 0
					
						if self.NextSparks < CurTime() then
							
							local e = EffectData()
								e:SetOrigin( tr.HitPos )
								e:SetNormal( tr.HitNormal )
								e:SetMagnitude( 0.5 )
								e:SetScale( 0.5 )
								e:SetRadius( 0.5 )
							util.Effect( "Sparks", e )
						
							self.NextSparks = CurTime() + 0.03
							
							util.Decal( "Scorch", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
							
						end
						
					end
					
				end
			
			self:SetupBones()
			self:SetPos( start + forward * self:GetCurLength() / 2 )
			
		else
		
			if self.SoundFix and self.SoundFix:IsValid() then
				//self.SoundFix:SetPos( self:GetPos() )
			end
			
			if self.LaserSound then
				//self.LaserSound:Stop()
			end
		end	
	else
	
		
		if self:GetOverridePatterns() then
			
			local forward = self:GetForward() * -1
			local ang = forward:Angle()
		
			endpos = self:GetEndPos()			
			
			self:SetupBones()
			self:SetPos( endpos )
			
		end
			
	end
	
	
	
	render.SetMaterial( mat_beam )
	render.DrawBeam( endpos, start, 20 + math.sin( RealTime() * 1 ) * 5, RealTime()*1.2, RealTime()*1.2 + 1.8 + math.cos( RealTime() * 1 )*0.2, Color( 245, 10, 10, 255 ) )

	render.SetMaterial( mat_beam2 )
	render.DrawBeam( endpos, start, 30 + math.sin( RealTime() * 1 ) * 15, RealTime()*1.7, RealTime()*1.7 + 1.8 + math.cos( RealTime() * 1 )*0.2, Color( 235, 0, 0, 255 ) )
	
	render.SetMaterial( mat_beam3 )
	render.DrawBeam( endpos, start, 75 + math.sin( RealTime() * 1 ) * 5, RealTime()*1.7, RealTime()*1.7 + 1.8 + math.cos( RealTime() * 1 )*0.2, Color( 235, 0, 0, 255 ) )

	local sz1 = 170 + math.sin( RealTime() * 1 ) * 35
	render.SetMaterial( mat_glow )
	render.DrawSprite( start, sz1, sz1,Color( 235, 0, 0, 255 )  ) 
	
	local sz2 = 70 + math.sin( RealTime() * 60 ) * 10
	render.SetMaterial( mat_glow )
	render.DrawSprite( endpos, sz2, sz2,Color( 235, 0, 0, 255 )  )
	
	render.SetMaterial( mat_glow2 )
	render.DrawSprite( endpos, sz2, sz2,Color( 235, 0, 0, 255 )  ) 
	
end

function ENT:Draw()
	
	self:SetPos( self.SavePos )
	self:DrawModel()
	
	self:DrawLaser()

end

end

