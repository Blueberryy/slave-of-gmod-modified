EFFECT.LifeTime = 0.8

local function CollideCallback(particle, hitpos, hitnormal)	
	util.Decal("BloodHugeBlack"..math.random(1,3), hitpos + hitnormal, hitpos - hitnormal)	
	particle:SetDieTime(0)	
end

function EFFECT:Init(data)

	self.Pos = data:GetOrigin()
	
	self.DieTime = CurTime() + self.LifeTime
	self.EjectTime = CurTime() + self.LifeTime / 3
	
	self:SetModel( "models/props_wasteland/rockcliff01k.mdl" )
	self:SetModelScale( math.Rand( 0.4, 1 ), 0 )
	
	local ang_r = VectorRand():Angle()
	ang_r.p = math.random( -25, 25 )
	ang_r.y = math.random( -35, 35 )
	ang_r.y = math.random( -90, 90 )
	
	self:SetAngles( ang_r )
	
	self:SetRenderBounds( Vector( -50, -50, -50 ), Vector( 60, 60, 60 ) )
	
	local emitter = ParticleEmitter( self.Pos )
	
	self:EmitSound( "physics/concrete/boulder_impact_hard"..math.random( 4 )..".wav", 35, math.random( 180, 205 ), 0.5 )
	
	if emitter then
				
		for i=1, 2 do
					
			local rand = VectorRand( -1, 1 )
			rand.z = 0
			
			local particle = emitter:Add( "decals/black_blood"..math.random(4), self.Pos + vector_up * 120 + VectorRand( -10, 10 ) )
			particle:SetVelocity( rand * math.random( 50, 100 ) + vector_up * -200 )
			particle:SetDieTime(5)
			particle:SetStartAlpha(0)
			particle:SetStartSize(0)
			particle:SetEndSize(26)
			particle:SetColor(0, 0, 0)
			particle:SetLighting(true)
			//particle:SetCollide(true)
			particle:SetAirResistance(16)
			particle:SetGravity( vector_up * -1500 )
			//particle:SetCollideCallback( CollideCallback )
					
		end
				
			
		emitter:Finish() emitter = nil collectgarbage("step", 64)
			
	end

end

function EFFECT:Think()
	return CurTime() < self.DieTime
end

local dev_mat = CreateMaterial( 
	"devwall_model", 
	"VertexLitGeneric", 
	{
		["$basetexture"] = "dev/dev_measurewall01d", 
		["$model"] = 1,
	}
)

local goop_mat = CreateMaterial( "coffin2",
    "VertexLitGeneric",
    {
        ["$basetexture"] = "Models/flesh",
        ["$bumpmap"] = "models/flesh_nrm",
        ["$nodecal"] = "0",
        ["$halflambert"] = 1,
        ["$translucent"] = 1,
        ["$model"] = 1,

        ["$detail"] = "Models/flesh",
        ["$detailscale"] = 1.2,
        ["$detailblendfactor"] = 7,
        ["$detailblendmode"] = 3,

        ["$phong"] = "1",
        ["$phongboost"] = "5",
        ["$phongfresnelranges"] = "[10 3 10]",
        ["$phongexponent"] = "500"
    }
)

function EFFECT:Render()
	
	if self.Pos and self.LifeTime then
		
		local origin = self.Pos
		local life_delta = math.Clamp( ( self.DieTime - CurTime() ) / self.LifeTime, 0, 1 )
		local delta = math.Clamp( ( self.EjectTime - CurTime() ) / ( self.LifeTime / 3 ), 0, 1 )
		local reverse_delta = 1 - delta
		
		
		goop_mat:SetFloat( "$detailscale", 0.4 + math.sin(RealTime() * 0.2) * 0.2 )
		
		self:SetPos( origin + vector_up * ( 30 * ( reverse_delta ) ) )
		//self:SetAngles( tbl.ang )
		//self:SetModelScale( tbl.scale * ( 1 - delta ^ 50 )  )
								
		render.SetBlend( life_delta <= 0.1 and ( life_delta / 0.1 ) or 1 )
		
		render.MaterialOverride( dev_mat )
		self:DrawModel()
		render.MaterialOverride( )
		
		render.MaterialOverride( goop_mat )
		render.SetColorModulation( 0, 0, 0 )
		self:SetupBones()
		self:DrawModel()
		render.SetColorModulation( 1, 1, 1 )
		render.MaterialOverride( )
		render.SetBlend(1)
		
	
	end
	
end