//a combination of napalm projectile and a puke from old zs

AddCSLuaFile()

ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_BOTH 

util.PrecacheModel("models/items/combine_rifle_ammo01.mdl")

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
	
end

if SERVER then

function ENT:Think()
	if self.DoRemove then
		self:Remove()
		return
	end

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
				dmginfo:SetDamageType( DMG_ACID )
				dmginfo:SetDamageForce( self:GetVelocity() * 55 )
				
				if takedamage then
					ent:TakeDamageInfo( dmginfo )
				end
			
		end
		
	end
end

function ENT:PhysicsCollide( data, phys )
	
	if self.DoRemove then return end
	
	if data.HitEntity:IsWorld() or not ( data.HitEntity:IsPlayer() or data.HitEntity:IsNextBot() ) then
		
		util.Decal( "YellowBlood", data.HitPos + data.HitNormal, data.HitPos - data.HitNormal)
		
		self:EmitSound( "physics/flesh/flesh_bloody_impact_hard1.wav", 50, math.random( 95, 105 )) 
		
		self.DoRemove = true	
	end

	
end

end

if CLIENT then

local function CollideCallback(particle, hitpos, hitnormal)
	particle:SetDieTime(0)
	util.Decal("YellowBlood", hitpos + hitnormal, hitpos - hitnormal)
end

local mat = Material( "decals/Yblood1" )

function ENT:Draw()
	
	local pos = self:GetPos()
	
	render.SetMaterial( mat )
	render.DrawSprite( pos, 32, 32, color_white )
	
	self.NextPuke = self.NextPuke or 0
	
	if self.NextPuke < CurTime() then
	
		local emitter = ParticleEmitter( self:GetPos() )
		
		local particle = emitter:Add( "decals/Yblood"..math.random( 6 ), pos + VectorRand():GetNormal() * math.Rand( 1, 4 ) )
		particle:SetVelocity( VectorRand():GetNormal() * math.Rand( 1, 4 ) )
		particle:SetDieTime( math.Rand( 0.6, 0.9 ) )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 255 )
		particle:SetStartSize( math.Rand( 12, 20 ) )
		particle:SetColor( 155, 10, 10 )
		particle:SetEndSize( 0 )
		particle:SetRoll( math.Rand( 0, 360 ) )
		particle:SetRollDelta( math.Rand( -1, 1 ) )
		particle:SetCollide(true)
		particle:SetCollideCallback(CollideCallback)
		particle:SetGravity( Vector( 0, 0, -500 ) )
		
		emitter:Finish()
		
		self.NextPuke = CurTime() + 0.01
		
	end
	
end

end


