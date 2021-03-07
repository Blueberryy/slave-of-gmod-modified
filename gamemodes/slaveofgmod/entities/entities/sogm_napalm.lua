AddCSLuaFile()

ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_BOTH 

util.PrecacheModel("models/items/combine_rifle_ammo01.mdl")

game.AddParticles("particles/fire_01.pcf" )
game.AddParticles("particles/fire_medium_01.pcf" )

local fire_particle = "fire_medium_01"

PrecacheParticleSystem( fire_particle )
PrecacheParticleSystem( "env_fire_tiny" )
PrecacheParticleSystem( "env_fire_medium" )


local mins = Vector(-318, -318, -318)
local maxs = Vector(318, 318, 318)

function ENT:Initialize()

	self:SetModel("models/items/combine_rifle_ammo01.mdl")
	self:DrawShadow(false)
	
	if SERVER then
		local size = 15
				
		self:PhysicsInitSphere( size, "slime")
		self:SetCollisionBounds( Vector( -size, -size, -size ), Vector( size, size, size ) )
		
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_PUSHAWAY)
		
		self.Touched = {}
		
		local phys = self.Entity:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:Wake()
		end	
		
		self:Fire("Kill","",5)
	end
	
	if CLIENT then
		self:SetRenderBounds( mins, maxs )
	end
	
	//self.DieTime = CurTime() + 5
	
end

if SERVER then

function ENT:Think()
	if self.DoRemove then
		self:Remove()
		return
	end
	
	//if self.DieTime and self.DieTime < CurTime() then
	//	self.DoRemove = true
	//end
	
	self:NextThink(CurTime())
	return true
end


function ENT:StartTouch( ent )
		
	if IsValid(ent) then
	
		if ent and ent:IsValid() and ent.IsBuddy then return end
		if ent and ent:IsValid() and ent:GetClass() == "dropped_weapon" then return end
		if ent and IsValid(ent.Knockdown) then return end
		if ent and IsValid( ent.Roll ) then return end
		if self:GetOwner() and self:GetOwner().Bodyguard and ent.Bodyguard then return end
		if self:GetOwner() and ent.Bodyguard and ent:GetOwner() == self:GetOwner() then return end
		if self:GetOwner() and self:GetOwner().Team and ent and ent.Team and self:GetOwner():Team() == ent:Team() and ent:Team() ~= TEAM_DM then return end
	
		if ent == game.GetWorld() then return end
		if self.Touched[ tostring(ent) ] then return end
		
		self.Touched[ tostring(ent) ] = true
			
		if ent:IsPlayer() or ent:IsNextBot() then
			
			local takedamage = true
			
			local dmginfo = DamageInfo()
				dmginfo:SetDamagePosition( self:GetPos() )
				dmginfo:SetDamage( 100 )
				
				local attacker = self.Entity
				
				if self:GetOwner() and self:GetOwner():IsValid() then
					if self:GetOwner().IsNextBot and self:GetOwner():IsNextBot() and IsValid(self:GetOwner():GetOwner()) then
						attacker = self:GetOwner():GetOwner()
					else
						attacker = self:GetOwner()
					end
				end
				
				dmginfo:SetAttacker( attacker or self.Entity )
				if self.Inflictor and IsValid(self.Inflictor) then
					dmginfo:SetInflictor(self.Inflictor)
				end
				dmginfo:SetDamageType( DMG_BURN )
				dmginfo:SetDamageForce( self:GetVelocity() * 15 )
				
				if ent:GetCharTable().OnFireHit then
					takedamage = ent:GetCharTable():OnFireHit( ent, dmginfo )
				end
				
				if takedamage then
					ent:TakeDamageInfo( dmginfo )
				end
			
		end
		
	end
end


function ENT:DelayedPhysicsCollide( data, phys )
	
	
	
end

function ENT:PhysicsCollide( data, phys )
	
	if self.DoRemove then return end
	
	if data.HitEntity:IsWorld() or not ( data.HitEntity:IsPlayer() or data.HitEntity:IsNextBot() ) then
		//local rand = math.random( 3 )
		//util.Decal( rand == 3 and "Scorch" or "FadingScorch", data.HitPos + data.HitNormal, data.HitPos - data.HitNormal)

		if data.HitEntity:IsWorld() and rand == 3 then
			local f = ents.Create("env_fire")
				f:SetPos( self:GetPos() )
				f:SetAngles( Angle( 0, 0, math.random( -360, 360 ) ) )
				f:SetKeyValue( "firesize", math.Rand( 2, 25 ) )
				f:SetKeyValue( "fireattack", math.Rand( 0, 1 ) )
				f:SetKeyValue( "damagescale", 0 )
				//f:SetKeyValue( "duration", math.random( 1, 2 ) ) 
				f:SetKeyValue( "spawnflags", "256" )
				f:Spawn()
				f:Activate()
			f:Fire("StartFire","", 0)
			f:Fire( "Kill", "", math.random( 1, 3 ) )
		end
		
		self.DoRemove = true	
	end
	
	
	/*timer.Simple( 0, function()
		if self and data and phys then
			self:DelayedPhysicsCollide( data, phys )
		end
	end)*/
	
end

end

if CLIENT then

function ENT:Draw()
	

	//self:DrawModel()

	if not self.Particle2 then
		//self.Particle = CreateParticleSystem( self, fire_particle, PATTACH_ABSORIGIN_FOLLOW, 0, Vector( 0, 0, 0 ) ) 
		self.Particle2 = CreateParticleSystem( self, "env_fire_small", PATTACH_ABSORIGIN_FOLLOW, 0, Vector( 0, 0, 0 ) )
		self.Particle3 = CreateParticleSystem( self, "env_fire_medium", PATTACH_ABSORIGIN_FOLLOW, 0, Vector( 0, 0, 0 ) )
	end
	
	/*if self.Particle then
		
		self.Particle:SetShouldDraw( false ) 
		render.SetColorModulation( 0, 0, 1 )
		self.Particle:Render()
		render.SetColorModulation( 1, 1, 1 )
		self.Particle:SetShouldDraw( true ) 
		
	end*/
	
	self.LifeTime = self.LifeTime or CurTime()
	
	self.NextFire = self.NextFire or CurTime() + 0.01
	
	local life = CurTime() - self.LifeTime
	
	if self.NextFire > CurTime() then return end
	
	self.NextFire = CurTime() + 0.1
	
	self.LifeTime2 = self.LifeTime2 or 0
	
	self.LifeTime2 = self.LifeTime2 + 1
	
	local dlight = DynamicLight( self:EntIndex() )
	if dlight then
		dlight.pos = self:GetPos()
		dlight.r = 255
		dlight.g = 155
		dlight.b = 55
		dlight.brightness = 4
		dlight.Decay = 1000
		dlight.Size = 186
		dlight.DieTime = CurTime() + 1
	end
	/*
	local emitter = ParticleEmitter( self:GetPos() )
	
	if emitter then
		local p = emitter:Add( "sprites/heatwave", self:GetPos() + VectorRand() * 2 )
		if p then
			local rand = math.random( 55, 100 )
			p:SetAngles( VectorRand():Angle() )
			p:SetColor(155 + rand,135 + rand,55 + rand,255)
			p:SetVelocity( VectorRand() * 38 + self:GetVelocity()/2)
			p:SetDieTime( 0.3 )
			p:SetLifeTime(0)
			p:SetStartSize( self.LifeTime2 / 20 )		
			p:SetEndSize( ( 8 + self.LifeTime2 / 20 ) ^ 2 )
			p:SetCollide(true)
			p:SetBounce(0)
			p:SetStartAlpha(150)
			p:SetEndAlpha(10)
			p:SetLighting( math.random( 2 ) == 2 and true or false )
			p:SetAirResistance(0)
			
			p:SetRollDelta( math.random(-.5,.5) )
			p:SetGravity( Vector( 0, 0, -500 ) ); 

			//p:SetNextThink(CurTime() + 5)
			//part:SetThinkFunction(FuelThink)

			//part:SetCollideCallback(FuelCallback)
		end
		emitter:Finish()
	end*/
	
end

end


