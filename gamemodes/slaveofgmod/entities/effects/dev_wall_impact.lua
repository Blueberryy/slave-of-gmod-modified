local rubble_models = {
	Model( "models/props_debris/concrete_chunk01a.mdl" ),
	Model( "models/props_debris/concrete_chunk01b.mdl" ),
	Model( "models/props_debris/concrete_chunk01c.mdl" ),
	Model( "models/props_debris/concrete_chunk07a.mdl" ),
	Model( "models/props_debris/concrete_column001a_chunk01.mdl" ),
	Model( "models/props_debris/concrete_column001a_chunk02.mdl" ),
	Model( "models/props_debris/concrete_column001a_chunk03.mdl" ),
	Model( "models/props_debris/concrete_column001a_chunk05.mdl" ),
	Model( "models/props_debris/tile_wall001a_chunk07.mdl" ),
}

local maxbound = Vector( 9, 9, 9 )
local minbound = maxbound * -1

function EFFECT:Init(data)

	self.Pos = data:GetOrigin()
	self.Normal = data:GetNormal()
	
	self:SetRenderBounds( Vector( -50, -50, -50 ), Vector( 60, 60, 60 ) )
	
	for i=1, math.random( 5, 6 ) do
				
		local ent = ClientsideModel( rubble_models[ math.random( #rubble_models ) ], RENDERGROUP_OPAQUE )
		if ent:IsValid() then
			ent:SetModelScale( math.Rand( 0.3 , 0.9 ), 0 )
			ent:SetPos( self.Pos + self.Normal * 20 + VectorRand( -6, 6 ) )
			ent:PhysicsInitBox(minbound, maxbound)
			ent:SetCollisionBounds(minbound, maxbound)
			ent:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
			
			ent:SetMaterial( "!devwall_model" )

			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				phys:SetMaterial("concrete")
				phys:Wake()
				phys:SetVelocityInstantaneous( self.Normal * math.Rand( 250, 500 ) )
				phys:AddAngleVelocity( VectorRand() * 500 )
			end

			SafeRemoveEntityDelayed( ent, math.Rand( 8, 12 ) )
		end
	end
	
	local emitter = ParticleEmitter( self.Pos )
	
	//self:EmitSound( "physics/concrete/boulder_impact_hard"..math.random( 4 )..".wav", 35, math.random( 180, 205 ), 0.5 )
	
	sound.Play("physics/wood/wood_crate_break4.wav", self.Pos, 77, math.Rand(35, 45))
	sound.Play("physics/concrete/concrete_break2.wav", self.Pos, 77, math.Rand(130, 140))
	
	if emitter then
				
		for i=1, math.random( 8, 13 ) do
					
			local particle = emitter:Add( "particles/smokey", self.Pos + VectorRand( -2, 2 ) )
			particle:SetVelocity( self.Normal * math.random( 100, 400 ) + VectorRand( -44, 44 ) )
			particle:SetDieTime( math.Rand( 3, 4 ) )
			particle:SetStartAlpha( math.random( 220, 250 ) )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( math.random( 18, 23 ) )
			particle:SetEndSize( math.random( 66, 103 ) )
			particle:SetRollDelta(math.Rand(-0.5, 0.5))
			particle:SetRoll(math.Rand(0, 360))
			local rand_col = math.random( 30, 80 )
			particle:SetColor( rand_col, rand_col, rand_col )
			particle:SetAirResistance( 70 )					
		end
		
		emitter:Finish() emitter = nil collectgarbage("step", 64)
			
	end

end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end