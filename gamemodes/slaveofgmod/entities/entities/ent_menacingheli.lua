AddCSLuaFile()

ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_BOTH 
ENT.AutomaticFrameAdvance = true

ENT.StartPos = Vector( -848, 239, 121 ) //111
ENT.EndPos = Vector( -848, -7852, 121 )
ENT.DefaultAngles = Angle( 0, 0, 0 )

ENT.RamPos = Vector( -561, -7157, 145 )
ENT.RamAng = Angle( 44, 3, -0 )

ENT.Model = Model( "models/combine_helicopter.mdl" )

ENT.DeathSound = Sound( "ambient/explosions/explode_3.wav" )

local mins = Vector(-318, -318, -318)
local maxs = Vector(318, 318, 318)

local engine_sound = Sound( "npc/combine_gunship/engine_whine_loop1.wav" )

local shoot_sound = Sound( "npc/combine_gunship/gunship_fire_loop1.wav" )

local light_pos = Vector( 159.12, 0, -50.69 )
local light_pos2 = Vector( 159.12, 0, -50.69 )

local color_on = Color( 235, 5, 5, 255 )
local color_off = Color( 255, 255, 255, 255 )

util.PrecacheSound( "npc/manhack/grind_flesh1.wav" )
util.PrecacheSound( "npc/manhack/grind_flesh2.wav" )
util.PrecacheSound( "npc/manhack/grind_flesh3.wav" )

local blood_pos = Vector( -489.497009, -7152.705078, 0.031250 )

function ENT:Initialize()

	self:SetModel( self.Model )
	
	if SERVER then
		
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetCollisionGroup( COLLISION_GROUP_IN_VEHICLE  )
		self:SetSolid( SOLID_VPHYSICS )
		self:PhysicsInit( SOLID_VPHYSICS )
				
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
			phys:SetMaterial( "metalvehicle" )
			phys:EnableGravity(false)
			//phys:SetMass( 1 )
		end

		//self.EngineSound = CreateSound( self, "npc/combine_gunship/engine_whine_loop1.wav" )

		self:CreateLight()

	end
	
	local seq = self:LookupSequence( "idle" )
	self:ResetSequence( seq )
	
	if CLIENT then
		self:CreateClientsideLight()
		self:SetRenderBounds( mins, maxs )	
	end
	
end

function ENT:CreateLight()
	
	local ang = self:GetAngles()
	ang:RotateAroundAxis( self:GetRight(), 90 )
	
	self.LightActive = true
	
	self.LightModel = ents.Create("prop_dynamic")
	self.LightModel:SetModel( "models/effects/vol_light64x128.mdl" )
	self.LightModel:SetPos( self:LocalToWorld( light_pos ) )
	self.LightModel:SetAngles( ang )
	self.LightModel:SetSolid( SOLID_NONE )
	self.LightModel:SetParent( self )
	self.LightModel:Spawn()
		
	self.LightModel:SetModelScale( 0.5, 0 )
		
	self.LightModel:SetColor( color_on )
		
	self:DeleteOnRemove( self.LightModel )
	
end

function ENT:CreateClientsideLight()
	
	self.Light = ProjectedTexture()
	
	self.Light:SetTexture( "effects/flashlight/hard" )
	self.Light:SetNearZ( 20 )
	self.Light:SetFarZ( 440 )
	//self.Light:SetHorizontalFOV( 60 ) 
	//self.Light:SetVerticalFOV( 55 ) //95
	self.Light:SetColor( color_on )
	
	self.Light:SetBrightness( 10 ) 
	

end

function ENT:UpdateClientsideLight()
	
	if self.Light then
	
		self.Light:SetPos( self:LocalToWorld( light_pos2 ) )	
		
		local ang = self:GetAngles()
		ang:RotateAroundAxis( self:GetRight(), 0 )
		
		self.Light:SetAngles( ang ) 
		
		self.Light:SetNearZ( 50 )
		self.Light:SetFarZ( 460 )
		
		self.Light:SetHorizontalFOV( 45 ) 
		self.Light:SetVerticalFOV( 90 ) //95
		
		self.Light:SetBrightness( 35 ) 
		
		self.Light:Update()
		
	end
	
end	

local ShadowParams = {secondstoarrive = 0.35, maxangular = 1000, maxangulardamp = 10000, maxspeed = 800, maxspeeddamp = 1000, dampfactor = 0.65, teleportdistance = 300}

function ENT:CalculateMovement()
	
	local ct = CurTime()
	
	local frametime = ct - (self.LastThink or ct)
	self.LastThink = ct
					
	local phys = self:GetPhysicsObject()		
	phys:Wake()
	
	local goal_pos = self.StartPos
	
	if Entity( 1 ) and Entity( 1 ):IsValid() then
		goal_pos = Vector( self.StartPos.x, math.Clamp( Entity(1):GetPos().y, self.EndPos.y, self.StartPos.y ), self.StartPos.z )
	end
	
	//lets make this easier
	if CUR_STAGE == 4 and CAPTAIN_EDGE and IsValid( CAPTAIN_EDGE ) then
		goal_pos = Vector( self.StartPos.x, math.Clamp( CAPTAIN_EDGE:GetPos().y, self.EndPos.y, self.StartPos.y ), self.StartPos.z )
	end

	local tilt = Angle( 0, 0, 15 ) * math.Clamp( self:GetVelocity():Length() / 315, 0, 1 )
	
	if self:GetVelocity().y > 0 then
		tilt = tilt * -1
	end
	
	local goal_ang = self.DefaultAngles + tilt
	
	if self.StartRam then
		goal_pos = self.RamPos + VectorRand() * 30
		goal_ang = self.RamAng
		
		if self:GetPos():Distance( goal_pos ) < 20 then
			if not self:ShowBlood() then
				self:StartBlood()
				if CAPTAIN_EDGE and CAPTAIN_EDGE:IsValid() then
					CAPTAIN_EDGE:AddEffects( EF_NODRAW )
					CAPTAIN_EDGE:EmitSound( "vehicles/v8/vehicle_impact_heavy3.wav", 130, 100 )
				end
			end
		end
		
	end
	
	ShadowParams.pos = goal_pos
	ShadowParams.angle = goal_ang
	ShadowParams.deltatime = frametime
	phys:ComputeShadowControl( ShadowParams )
	
end

function ENT:ShootStuff()
	
	if self:IsFiring() then
		self:ShootBullets()
	else
		self:StopFiring()
	end
	
end

function ENT:StartFiring( time )
	
	if !self:CanFire() then return end
	if self:IsFiring() then return end
	if CUR_DIALOGUE then return end
	if CUR_STAGE > 2 then return end
	if GAMEMODE:GetRoundState() == ROUNDSTATE_RESTARTING then return end
	
	self:SetFireTime( time )
	self:SetNextFireTime( 0 )
	
	self:EmitSound( "npc/combine_gunship/attack_start2.wav", 130 )
	
end

function ENT:StopFiring()
	
	if self:GetFireTime() == 0 then return end
	
	self:SetFireTime( 0 )
	self:SetNextFireTime( CurTime() + 1.5 )
	
	self:EmitSound( "npc/combine_gunship/attack_stop2.wav", 130 )
	
end

function ENT:ShootBullets()
	
	if GAMEMODE:GetRoundState() == ROUNDSTATE_RESTARTING then return end
	
	if Entity( 1 ) and Entity( 1 ):IsValid() and Entity( 1 ):Alive() then
		
		self.NextShot = self.NextShot or 0
		
		if self.NextShot < CurTime() then
			
			local pr = ents.Create( "sogm_bullet" )
			local attachment = self:LookupAttachment( "Muzzle" )
			local att = self:GetAttachment( attachment )
			local aim = att.Ang:Forward()
			
			if IsValid(pr) then

				local rand = math.Rand(-0.15, 0.15)
							
				local spread = aim:Angle():Right() * rand
								
				local pos = att.Pos
				
				pr:SetPos(pos or self:GetPos())
				pr:SetOwner( self )
				pr.Inflictor = self
				pr.Damage = 100
				//if penetrate then
					//pr:Penetrating( true )
				//end
				pr:SetAngles( aim:Angle() )
					
				local force = 3700

				pr:SetVelocity((aim + spread) * force)
				pr.Force = force
				pr.DamageType = DMG_BLAST
				pr:Spawn()

				local phys = pr:GetPhysicsObject()
				if phys:IsValid() then
					phys:SetVelocityInstantaneous((aim + spread) * force)
				end
				
			end
			
			self.NextShot = CurTime() + 0.04
		end
		
	else
		self:StopFiring()
	end
	
end

//few things so its compaticle with b00lets
function ENT:Team()
	return TEAM_DM//MOB
end

//small hack to override bullet options
ENT.dummy_table = { BulletScale = 3 }

function ENT:GetActiveWeapon()
	return self
end

function ENT:SetFireTime( tm )
	self:SetDTFloat( 0, tm )
end

function ENT:GetFireTime()
	return self:GetDTFloat( 0 )
end

function ENT:SetNextFireTime( tm )
	self:SetDTFloat( 1, tm )
end

function ENT:GetNextFireTime()
	return self:GetDTFloat( 1 )
end

function ENT:SetDeathTime( tm )
	self:SetDTFloat( 2, tm )
end

function ENT:GetDeathTime()
	return self:GetDTFloat( 2 )
end

function ENT:StartBlood()
	self:SetDTBool( 0, true )
	self:SetDeathTime( CurTime() + 4 )
end

function ENT:ShowBlood()
	return self:GetDTBool( 0 )
end

function ENT:IsFiring()
	return self:GetFireTime() > CurTime()
end

function ENT:CanFire()
	return self:GetNextFireTime() < CurTime()
end

function ENT:CheckRam()
	
	if CUR_STAGE == 4 and not CUR_DIALOGUE then
		
		if not self.StartRam then
			self.StartRam = true
		end
	end
	
	if self.StartRam and self:ShowBlood() and self:GetDeathTime() < CurTime() and not self.Exploded then
				
			if CAPTAIN_EDGE and CAPTAIN_EDGE:IsValid() then				
				
				local dmginfo = DamageInfo() 
					dmginfo:SetDamage( 9999 )
					dmginfo:SetAttacker( self )
					dmginfo:SetInflictor( self )
					dmginfo:SetDamagePosition( CAPTAIN_EDGE:GetPos() )
					dmginfo:SetDamageForce( vector_up * 300 )
					dmginfo:SetDamageType( DMG_ACID )
						
				CAPTAIN_EDGE:TakeDamageInfo( dmginfo )
			end
			
			self.Exploded = true
				
			self:DoDeath()
			
		end
	
end

local light_trace = { mask = MASK_SHOT, mins = Vector( -12, -12, 0 ), maxs = Vector( 12, 12, 30 ) }
function ENT:Think()

	if SERVER then
		self:HandleObstacles()
		self:CheckRam()
		self:CalculateMovement()
		self:ShootStuff()
	end
		
	local light = self:GetDTEntity( 0 )
		
	if Entity(1):IsValid() then//if light and light:IsValid() and Entity(1):IsValid() then
			
		light_trace.start = self:LocalToWorld( light_pos )
		light_trace.endpos = Entity(1):NearestPoint( Entity(1):GetShootPos() ) or ( light_trace.start + Vector( 150, 0, 0 ) )
			
			
		local tr = util.TraceLine( light_trace )
			
		if tr.Hit then
			
			if !tr.HitWorld then
				
				if SERVER then
					if not self.LightActive then
							//light:Fire( "TurnOn", "", 0 )
						self.LightActive = true
							
						//if self.LightModel and self.LightModel:IsValid() then
						//	self.LightModel:SetColor( color_on )
						//end

					end
					
					if self.LightModel and self.LightModel:IsValid() then
						self.LightModel:SetColor( color_on )
					end
					
					local sec = 1
					
					if CUR_STAGE and CUR_STAGE == 2 then
						sec = 6
					end
					
					self:StartFiring( CurTime() + sec )
				end
				
				if CLIENT then
					if self.Light then
						//self.Light:SetNearZ( 40 )
						self.Light:SetColor( color_on )
					end
				end
					
			else
				
				if SERVER then
					if self.LightActive then
						//light:Fire( "TurnOff", "", 0 )
						self.LightActive = false
						
						//if self.LightModel and self.LightModel:IsValid() then
						//	self.LightModel:SetColor( color_off )
						//end
					end
					
					if self.LightModel and self.LightModel:IsValid() then
						if self:IsFiring() then
							self.LightModel:SetColor( color_on )
						else
							self.LightModel:SetColor( color_off )
						end
					end
					
				end
				
				if CLIENT then
					if self.Light then
						if self:IsFiring() then
							self.Light:SetColor( color_on )
						else
							self.Light:SetColor( color_off )
						end
						//self.Light:SetNearZ( 0 )
					end
				end

				
			end
		else
			if SERVER then
				if self.LightModel and self.LightModel:IsValid() then
					if self:IsFiring() then
						self.LightModel:SetColor( color_on )
					else
						self.LightModel:SetColor( color_off )
					end
				end
			end
		
			if CLIENT then
				if self.Light then
					if self:IsFiring() then
						self.Light:SetColor( color_on )
					else
						self.Light:SetColor( color_off )
					end
					//self.Light:SetNearZ( 1 )
				end
			end
		end
		

	end
	
	if CLIENT then
		if not self.EngineSound then
			self.EngineSound = CreateSound( self, engine_sound )
		end
	
		if self.EngineSound then
			self.EngineSound:PlayEx( 0.6, 95 + math.sin( RealTime() * 1 ) * 5 ) 
		end
		
		if not self.ShootSound then
			self.ShootSound = CreateSound( self, shoot_sound )
			self.ShootSound:SetSoundLevel( 140  ) 
		end
		
		if self.ShootSound then
			if self:IsFiring() then
				self.ShootSound:PlayEx( 1, 95 + math.sin( RealTime() * 1 ) * 5 ) 
			else
				self.ShootSound:Stop()
			end
		end
		
		if self:ShowBlood() then
			
			self.NextBlade = self.NextBlade or 0
			
			if self.NextBlade < CurTime() then
				
				sound.Play( "npc/manhack/grind_flesh"..math.random(3)..".wav", blood_pos, 150, 100, 1 ) 
				--self:EmitSound( "npc/manhack/grind_flesh"..math.random(3)..".wav", 90, 130 )
				
				self.NextBlade = CurTime() + 0.1
			end
			
		end
		
		
		
	end
	
	self:NextThink( CurTime() )
	return true
	
end


//starting from 2, because they will start appearing on stage 2
util.PrecacheModel( "models/props_debris/plaster_floor001a.mdl" )
util.PrecacheModel( "models/props_debris/plaster_floorpile001a.mdl" )
util.PrecacheModel( "models/props_debris/plaster_ceilingpile001a.mdl" )
util.PrecacheModel( "models/props_debris/barricade_tall03a.mdl" )
util.PrecacheModel( "models/props_vehicles/apc001.mdl" )
local obstacles = {}
obstacles[2] = function( self )
	
	local p = ents.Create( "prop_dynamic" )
	p:SetModel( "models/props_debris/plaster_floor001a.mdl" )
	p:SetPos( Vector( -414.48132324219, -3577.2646484375, 64.473594665527 ) )
	p:SetAngles( Angle( 89.87321472168, -94.10082244873, -4.4205322265625 ) )
	p:SetKeyValue("solid", "6")
	p:Spawn()
	
	p:EmitSound( "npc/dog/car_impact1.wav" )
	
	local p = ents.Create( "prop_dynamic" )
	p:SetModel( "models/props_debris/plaster_floorpile001a.mdl" )
	p:SetPos( Vector( -380.61636352539, -3536.5600585938, 8.5040788650513 ) )
	p:SetAngles( Angle( 0.00020947102166247, 96.096435546875, 0.0002911961346399 ) )
	p:SetKeyValue("solid", "6")
	p:Spawn()
		
	local p = ents.Create( "prop_dynamic" )
	p:SetModel( "models/props_debris/plaster_ceilingpile001a.mdl" )
	p:SetPos( Vector( -438.47213745117, -3530.3696289063, 33.332626342773 ) )
	p:SetAngles( Angle( 10.155782699585, -174.94921875, 48.153259277344 ) )
	p:SetKeyValue("solid", "6")
	p:Spawn()
	
	local e = EffectData()
		e:SetOrigin( Vector( -414.48132324219, -3577.2646484375, 64.473594665527 ) )
		e:SetNormal( vector_origin )
	util.Effect("explosion_huge", e, nil, true)

end

obstacles[3] = function( self )
	
	local p = ents.Create( "prop_dynamic" )
	p:SetModel( "models/props_debris/barricade_tall03a.mdl" )
	p:SetPos( Vector( -443.26922607422, -6440.3725585938, 61.199451446533 ) )
	p:SetAngles( Angle( -0.070138186216354, 87.564804077148, -2.3572998046875 ) )
	p:SetKeyValue("solid", "6")
	p:Spawn()
	
	p:EmitSound( "npc/dog/car_impact1.wav" )
	
	local e = EffectData()
		e:SetOrigin( Vector( -443.26922607422, -6440.3725585938, 61.199451446533 ) )
		e:SetNormal( vector_origin )
	util.Effect("explosion_huge", e, nil, true)
	
	local p = ents.Create( "prop_dynamic" )
	p:SetModel( "models/props_vehicles/apc001.mdl" )
	p:SetPos( Vector( -357.27346801758, -7447.2661132813, 66.421974182129 ) )
	p:SetAngles( Angle( -89.39404296875, 0.57432407140732, 83.399971008301 ) )
	p:SetKeyValue("solid", "6")
	p:Spawn()
	
	self.DeleteThis = p //their dad is working for Steam

end

obstacles[9999] = function( self )
		
	if IsValid( self.DeleteThis ) then
	
		self.DeleteThis:EmitSound( "npc/dog/car_impact1.wav" )
	
		self.DeleteThis:Remove()
		
		local e = EffectData()
			e:SetOrigin( Vector( -357.27346801758, -7447.2661132813, 66.421974182129 ) )
			e:SetNormal( vector_origin )
		util.Effect("explosion_huge", e, nil, true)
	end
	
	

end

//this is messy, but its better to do these things in here
function ENT:HandleObstacles()
	
	self.CurStage = self.CurStage or 1
	
	if CUR_STAGE and self.CurStage < CUR_STAGE then
	
		self.CurStage = CUR_STAGE
		
		if obstacles and obstacles[ self.CurStage ] then
			obstacles[ self.CurStage ]( self )
		end
	
	end


end

ENT.Gibs = {
	Model( "models/gibs/helicopter_brokenpiece_04_cockpit.mdl" ),
	Model( "models/gibs/helicopter_brokenpiece_06_body.mdl" ),
	Model( "models/gibs/helicopter_brokenpiece_05_tailfan.mdl" )

}

function ENT:DoDeath()
	
	obstacles[ 9999 ]( self )
	
	self:AddEffects( EF_NODRAW )
	
	self:EmitSound( self.DeathSound )
	
	local e = EffectData()
		e:SetOrigin( self:GetPos() )
		e:SetNormal( vector_origin )
	util.Effect( "explosion_huge", e, true, true )
	
	for k, v in pairs( self.Gibs ) do
		local ent = ents.Create("prop_physics")
		ent:SetModel( v )
		ent:SetPos( self:GetPos() + self:GetForward() * 30 - self:GetForward() * 30 * k )
		ent:SetAngles( self:GetAngles() )
		ent:SetSolid( SOLID_VPHYSICS )
		ent:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
		ent:Spawn()
		
		local phys = ent:GetPhysicsObject()
		if phys and IsValid( phys ) then
			phys:Wake()
		end
		
		ent:Ignite( 999, 0 )
		
		ent:Fire( "kill", "", 10 )
		
	end
	
	GAMEMODE:FinishRound()
	
	self:Remove()
end

function ENT:OnRemove()
	if CLIENT then
		if self.EngineSound then
			self.EngineSound:Stop()
		end
		if self.ShootSound then
			self.ShootSound:Stop()
		end
		if self.Light then
			self.Light:Remove()
		end
	end
end

if CLIENT then
		
	local function CollideCallback(particle, hitpos, hitnormal)
		util.Decal( "Blood", hitpos + hitnormal, hitpos - hitnormal)
		particle:SetDieTime(0)
	end
	
	function ENT:Draw()
		
		self:UpdateClientsideLight()
			
		self:DrawModel()
			
		if self:IsFiring() then
			self.NextFlash = self.NextFlash or 0
				
			if self.NextFlash < CurTime() then
				
				local attachment = self:LookupAttachment( "Muzzle" )
				local att = self:GetAttachment( attachment )
				
				local effectdata = EffectData() 
					effectdata:SetOrigin( att.Pos ) 
					effectdata:SetAngles( att.Ang ) 
					effectdata:SetAttachment( attachment )
					effectdata:SetScale( 2 )
				util.Effect( "MuzzleEffect", effectdata ) 
				
				self.NextFlash = CurTime() + 0.02
			end
			
		end
		
		if self:ShowBlood() then
			
			self.NextEffect = self.NextEffect or 0
			
			if self.NextEffect < CurTime() then

				local emitter = ParticleEmitter( blood_pos )
				
				local particle = emitter:Add("Decals/flesh/Blood"..math.random(5), blood_pos + VectorRand() * 5 + vector_up * 60 )
					local rand = VectorRand()
					rand.z = 0
					particle:SetVelocity( rand * 706 )
					particle:SetDieTime( 2 )
					particle:SetStartAlpha(235)
					particle:SetEndAlpha( 255 )
					particle:SetStartSize(15)
					particle:SetEndSize(math.random(25,33))
					particle:SetRoll(math.random(-180,180))
					particle:SetColor(255, 255, 255)
					--particle:SetLighting(true)
					particle:SetCollide(true)
					particle:SetAirResistance( 1 )
					particle:SetGravity( vector_up * -1450 )
				particle:SetCollideCallback(CollideCallback)
				
				emitter:Finish()
				
				self.NextEffect = CurTime() + 0.01
				
			end
			
			self.NextExplosion = self.NextExplosion or 0
			
			if self.NextExplosion < CurTime() then
			
				self.NextExplosion = CurTime() + 0.3
				
				local e = EffectData()
					e:SetOrigin( self:LocalToWorld( self:OBBCenter() + VectorRand() * 45 ) )
					e:SetScale( math.Rand( 1, 1.5 ) )
				util.Effect( "Explosion", e, nil, true )
				
			end
		
		end
		
		
	end
	
end


