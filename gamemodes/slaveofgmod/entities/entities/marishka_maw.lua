AddCSLuaFile()

ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.AutomaticFrameAdvance = false

local points = { Vector( -11, -11, 0 ), Vector( 11, 11, 80 ) }

util.PrecacheModel( "models/barnacle.mdl" )

ENT.ModelScale = 2

function ENT:Initialize()

	if SERVER then	
		self:SetModel( "models/barnacle.mdl" )
		
		self:SetModelScale( self.ModelScale, 0 )
	
		self:PhysicsInitBox( points[1], points[2] ) 
		self:SetSolid( SOLID_OBB )
		self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
		self:SetMoveType( MOVETYPE_NONE )
		

		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			//phys:SetMaterial("material")
			phys:Wake()
		end
		
		self:SetTrigger( true )
		
		self.DamageTime = CurTime() + 0.2
		
	end
	
	self:DrawShadow( false )
	
	local seq = self:LookupSequence( "attack_smallthings" )
	self:ResetSequence( seq )
	self:SetPlaybackRate( 2 )
	
	if CLIENT then
		//self:SetRenderBounds(Vector(-318, -318, -318), Vector(318, 318, 318))
		self.SavePos = self:GetPos()
		self.Offset = 90
		
		sound.Play( "physics/concrete/boulder_impact_hard"..math.random(4)..".wav", self:GetPos() )
		sound.Play( "physics/body/body_medium_break"..math.random( 2, 4 )..".wav", self:GetPos() )
		
		if LocalPlayer():GetPos():Distance( self:GetPos() ) < 400 then
			GAMEMODE:ShakeView( math.random(11,16), math.Rand(0.1, 0.3) )
		end
		
	end

	
end

if SERVER then
	
	function ENT:StartTouch( ent )
				
		if ent and ent:IsPlayer() then
		
			
			if self.DamageTime > CurTime() then
				
				local dmginfo = DamageInfo() 
					dmginfo:SetDamage( 9999 )
					dmginfo:SetAttacker( self )
					dmginfo:SetInflictor( self )
					dmginfo:SetDamagePosition( ent:GetPos() )
					dmginfo:SetDamageForce( ent:GetVelocity() * 1.2 )
					dmginfo:SetDamageType( DMG_BLAST )
						
					//tr.Entity:EmitSound( "ambient/levels/citadel/weapon_disintegrate"..math.random(4)..".wav" )
						
				ent:TakeDamageInfo( dmginfo )
				
			else
				//ent:SetLocalVelocity( vector_origin )
				//ent:SetVelocity( (ent:GetPos()-ent:GetPos()):GetNormal() * ( ent:GetVelocity():Length() + 200 ) )
			end
			
		end
		
	end
	
	function ENT:Touch( ent )
				
		if ent and ent:IsPlayer() then

			if self.DamageTime < CurTime() then
				ent:SetLocalVelocity( vector_origin )
				ent:SetVelocity( (ent:GetPos()-ent:GetPos()):GetNormal() * ( ent:GetVelocity():Length() + 300 ) )
			end
			
		end
		
	end
	
	function ENT:OnTakeDamage( dmginfo )
		
		local attacker = dmginfo:GetAttacker()
		local inflictor = dmginfo:GetInflictor()
		
		if IsValid( attacker ) and attacker:IsPlayer() and attacker:Team() == TEAM_PLAYER and inflictor and not inflictor:IsPlayer() then

			self:EmitSound("physics/flesh/flesh_squishy_impact_hard"..math.random(4)..".wav",100, math.Rand(95, 130)) 
			
			//GAMEMODE:DoBloodSpray( dmginfo:GetDamagePosition(), dmginfo:GetDamageForce() * -1, VectorRand() * 4 , math.random(3,5) * ( dmginfo:GetDamage() / 50 ), math.random( 100, 400 ) + 60 * ( dmginfo:GetDamage() / 50 ) )
			//GAMEMODE:DoBloodSpray( dmginfo:GetDamagePosition(), VectorRand(), VectorRand() * 4 , math.random(3,5) * ( dmginfo:GetDamage() / 50 ), math.random( 100, 400 ) + 60 * ( dmginfo:GetDamage() / 50 ) )
			local e = EffectData()
				e:SetEntity( self )
				e:SetOrigin( self:LocalToWorld( self:OBBCenter() ) )
				e:SetNormal( vector_up )
			util.Effect("player_gib", e, nil, true)
			
			
			self:Remove()
			
		end
		
	end
	
	function ENT:OnRemove()
		
		if self.RemoveByGame then
			local e = EffectData()
				e:SetEntity( self )
				e:SetOrigin( self:LocalToWorld( self:OBBCenter() ) )
				e:SetNormal( vector_up )
			util.Effect("player_gib", e, nil, true)
		end
	
	end
	
end

if CLIENT then
	
	function ENT:Draw()
		
		self.PopTime = self.PopTime or ( CurTime() + 0.15 )
		
		local delta = math.Clamp( ( self.PopTime - CurTime() ) / 0.15, 0, 1)
		
		self.Offset = self.Offset or 90
		self.SavePos = self.SavePos or self:GetPos()
		
		self.Offset = 90*delta//math.Approach( self.Offset, 0, FrameTime() * 55 )
		
		self:SetAngles( Angle( 180, 0, 0 ) )
		self:SetPos( self.SavePos - vector_up * self.Offset )
		
		self:FrameAdvance( ( RealTime() - ( self.LastRender or 0 ) ) * 2 )
		render.SetColorModulation( 0.8, 0.1, 0.1 )
		//render.SuppressEngineLighting( true )
		//cam.IgnoreZ( true )
		self:DrawModel()
		//cam.IgnoreZ( false )
		//render.SuppressEngineLighting( false )
		render.SetColorModulation( 1, 1, 1 )
		self.LastRender = RealTime()
		
	end
	
end



