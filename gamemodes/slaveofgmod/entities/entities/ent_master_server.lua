AddCSLuaFile()

ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_BOTH

MASTER_SERVERS = MASTER_SERVERS or {}
MASTER_SERVERS_COUNT = MASTER_SERVERS_COUNT or 0

function ENT:Initialize()
	
	self.FleshMaterial = true
	
	if SERVER then
		
		NO_LEVEL_CLEAR = true //wow, i should've put this in the first place
		
		MASTER_SERVERS_COUNT = MASTER_SERVERS_COUNT + 1
		
		self:SetModel("models/props_lab/workspace004.mdl")
		//models/props_lab/servers.mdl
		//models/props_lab/securitybank.mdl
		//models/props_lab/workspace004.mdl
		
		self:SetMoveType( MOVETYPE_NONE )
		self:SetSolid( SOLID_VPHYSICS )
		self:PhysicsInit( SOLID_VPHYSICS )
		
		self:SetBloodColor( BLOOD_COLOR_RED or 0 )
		
		self:SetMaterial( "models/barnacle/barnacle_sheet" )
		
		self.health = 900
				
		local phys = self:GetPhysicsObject()
		
		if IsValid(phys) then
			phys:EnableMotion( false )
		end
						
	end
	
	if CLIENT then
		
		self:DrawShadow( false )
		self:SetRenderBounds( Vector(-318, -318, -318), Vector(318, 318, 318) )
		
	end
	
	MASTER_SERVERS[tostring(self)] = self.Entity

end

if SERVER then

function ENT:OnRemove()
	MASTER_SERVERS_COUNT = MASTER_SERVERS_COUNT - 1
	if not self.ForceRemove then
		if MASTER_SERVERS[tostring(self)] then
			MASTER_SERVERS[tostring(self)] = nil
		end
		if MASTER_SERVERS_COUNT <= 0 and self.RemoveByDamage then
			GAMEMODE:FinishRound()			
		end

	end
end


function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end
	
function ENT:OnTakeDamage( dmginfo )
	
	local attacker = dmginfo:GetAttacker()
	local inflictor = dmginfo:GetInflictor()
	
	if IsValid( attacker ) and attacker:IsPlayer() and attacker:Team() == TEAM_PLAYER and inflictor and not inflictor:IsPlayer() then
					
		self.health = self.health - dmginfo:GetDamage()
		
		
		self:EmitSound("physics/flesh/flesh_squishy_impact_hard"..math.random(4)..".wav",100, math.Rand(95, 130)) 
		
		GAMEMODE:DoBloodSpray( dmginfo:GetDamagePosition(), dmginfo:GetDamageForce() * -1, VectorRand() * 4 , math.random(3,5) * ( dmginfo:GetDamage() / 50 ), math.random( 100, 400 ) + 60 * ( dmginfo:GetDamage() / 50 ) )
		
		if self.health <= 0 then
			local e = EffectData()
				e:SetOrigin( self:GetPos() )
				e:SetScale( 2 )
			util.Effect( "Explosion", e, nil, true )
			
			local e = EffectData()
				e:SetEntity( self )
				e:SetOrigin( self:LocalToWorld( self:OBBCenter() ) )
				e:SetNormal( vector_up )
			util.Effect("player_gib", e, nil, true)
			
			
			self.RemoveByDamage = true
			
			Entity(1):ShakeView( math.random(15,20), 0.4)
			
			self:Remove()
		end
		
	end

end
end

if CLIENT then
local mat_whole = Material( "models/flesh" )
local mat_glow = Material( "models/spawn_effect2" )
local mat_beam = Material( "effects/bloodstream" )
local trace = { mask = MASK_SOLID_BRUSHONLY }
function ENT:Draw()

	self:DrawModel()
	
	render.SuppressEngineLighting( true )
		render.MaterialOverride( mat_glow )
		render.SetBlend( math.sin( RealTime() ) * 0.2 + 0.8 )
		render.SetColorModulation( 1, 0.1, 0.1 )
		
		self:SetupBones()
		self:DrawModel()
		
		render.SetColorModulation( 1, 1, 1 )
		render.SetBlend( 1 )	
		render.MaterialOverride( nil )
	render.SuppressEngineLighting( false )
	
	if not self.Beams then
		self.Beams = {}
		
		for i=1, math.random(5,6) do
		
			local reach = VectorRand() * 999
		
			trace.start = self:LocalToWorld(self:OBBCenter())
			trace.endpos = trace.start + reach
			trace.filter = self
			
			local tr = util.TraceLine( trace )
			
			if tr.Hit then
				self.Beams[i] = tr.HitPos
			end
	
		end
	end
	
	if self.Beams then
		for i=1, #self.Beams do
			if self.Beams[i] then
				render.SetMaterial( mat_beam )
				//self:LocalToWorld(self:OBBCenter())
				render.DrawBeam( self:LocalToWorld(self:OBBCenter()), self.Beams[i], 25 + math.sin( RealTime() * 1 ) * 10, RealTime()*0.8, RealTime()*0.8 + 1.8 + math.cos( RealTime() * 1 )*0.2, Color( 135, 20, 20, 255 ) ) 
			end
		end
	end
			
end

end
