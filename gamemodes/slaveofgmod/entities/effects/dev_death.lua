local maxbound = Vector( 5, 5, 5 )
local minbound = maxbound * -1

EFFECT.RockBones = {
	0, 1, 3, 4, 9, 10, 14, 15, 18, 19, 22, 23
}

local gib_render = function( self ) 
	if self.RenderTime then
		
		local delta = math.Clamp( self.RenderTime - CurTime(), 0, 1 )
		
		render.SetBlend( delta )
		render.SetColorModulation( 0.7, 0.7, 0.7 )
			self:DrawModel()
		render.SetColorModulation( 1, 1, 1 )
		render.SetBlend( 1 )
		
	end
end

function EFFECT:Init(data)

	self.Pos = data:GetOrigin()
	self.Ent = data:GetEntity()
	
	if !IsValid( self.Ent ) then return end
	
	local emitter = ParticleEmitter( self.Pos, true )
	local emitter2 = ParticleEmitter( self.Pos )
	
	for i=1, 23 do //#self.RockBones do
		
		local boneid = i//self.RockBones[ i ]
		local pos, ang = self.Ent:GetBonePosition( boneid )
		
		if pos and ang then
			
			local ent = ClientsideModel("models/props_debris/concrete_chunk04a.mdl", RENDERGROUP_OPAQUE)
			
			local big = i < 4 and math.Rand( 1.3, 1.6 ) or 1
			
			if ent:IsValid() then
				ent:SetModelScale( math.Rand(0.8, 6.3) * big, 0 )
				ent:SetPos( pos )
				ent:SetAngles( ang + VectorRand():Angle() )
				ent:PhysicsInitBox( minbound * big, maxbound * big )
				ent:SetCollisionBounds( minbound * big, maxbound * big )
				
				ent:SetMaterial( "!devwall_model" )
				
				//ent:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
				
				local phys = ent:GetPhysicsObject()
				if phys:IsValid() then
					phys:Wake()
					phys:SetMaterial("pottery")
					phys:SetMass( 15 )
					phys:ApplyForceCenter( ( ( pos - self:GetPos() ):GetNormal() + VectorRand() * 0.1 ) * math.random( 3000, 5000 ) )
					phys:AddAngleVelocity( VectorRand() * 3 ) 
				end

				local time = math.random( 6, 10 )
				ent.RenderTime = CurTime() + time
				ent.RenderOverride = gib_render
				
				SafeRemoveEntityDelayed( ent, time )
			end
			
			if emitter and emitter2 then
				
				for i=1, math.random( 3, 5 ) do
					
					local particle = emitter:Add( "!heks_energy_bit"..math.random( 3 ), pos + VectorRand( -2, 2 ) )
					particle:SetVelocity( VectorRand( -34, 34 ) + vector_up * 50 )
					particle:SetAngles( VectorRand():Angle() )
					particle:SetDieTime( math.Rand( 6, 12 ) )
					particle:SetStartAlpha( 255 )
					particle:SetEndAlpha( 0 )
					particle:SetStartSize( math.random( 4, 6 ) )
					particle:SetEndSize( 0 )
					particle:SetRollDelta( math.Rand(-0.5, 0.5) )
					particle:SetRoll( math.Rand(0, 360) )
					particle:SetColor( 10, 10, 10 )	
					particle:SetGravity( vector_up * -50 )
					particle:SetAirResistance( 3 )
					particle:SetCollide( true )
					
					local particle = emitter2:Add( "particle/particle_smokegrenade1", pos + VectorRand( -2, 2 ) )
					particle:SetVelocity( VectorRand( -14, 14 ) + vector_up * 4 )
					particle:SetDieTime( math.Rand( 8, 12 ) )
					particle:SetStartAlpha( 255 )
					particle:SetEndAlpha( 0 )
					particle:SetStartSize( math.random( 23, 25 ) )
					particle:SetEndSize( math.random( 33, 36 ) )
					particle:SetRollDelta( math.Rand(-0.5, 0.5) )
					particle:SetRoll( math.Rand(0, 360) )
					particle:SetColor( 30, 30, 30 )	
					//particle:SetGravity( vector_up * -50 )
					particle:SetAirResistance( 3 )
					//particle:SetCollide( true )
					
				end
				
				local particle = emitter2:Add( "particle/warp2_warp", pos + VectorRand( -15, 15 ) )
					particle:SetDieTime( math.Rand( 0.2, 0.3 ) )
					particle:SetStartAlpha( 255 )
					particle:SetEndAlpha( 255 )
					particle:SetStartSize( math.random( 13, 14 ) )
					particle:SetEndSize( math.random( 95, 110 ) )
					particle:SetRollDelta( math.Rand(-0.5, 0.5) )
					particle:SetRoll( math.Rand(0, 360) )
					particle:SetColor( 255, 255, 255 )	
					particle:SetAirResistance( 3 )
				
			end
			
		end
		
	end
	
	if emitter then
		emitter:Finish() emitter = nil collectgarbage("step", 64)
	end
	
	if emitter2 then
		emitter2:Finish() emitter2 = nil collectgarbage("step", 64)
	end

	
	self:EmitSound("physics/wood/wood_crate_break4.wav", 100, math.Rand(35, 45), nil, CHAN_AUTO)
	self:EmitSound("physics/wood/wood_crate_break4.wav", 100, math.Rand(25, 35), nil, CHAN_AUTO)
	self:EmitSound("physics/glass/glass_largesheet_break1.wav", 100, math.Rand(45, 55), nil, CHAN_AUTO)
	
	local dlight = DynamicLight( 900 )
	if ( dlight ) then
		local size = 500
		dlight.Pos = self.Ent:GetPos() + vector_up * 100
		dlight.r = 255
		dlight.g = 255
		dlight.b = 255
		dlight.Brightness = 12
		dlight.Size = size
		dlight.Decay = size * 1
		dlight.DieTime = CurTime() + 1
		dlight.Style = 0
		dlight.nomodel = true
	end
	
	self.Ent:SetRenderMode( RENDERMODE_NONE )
	self.Ent.HideModel = true
	
	util.ScreenShake( LocalPlayer():GetPos(), math.random( 10, 14 ), 0.5, 2, 1000 )

end

function EFFECT:Think()
	return false
end

function EFFECT:Render()

end