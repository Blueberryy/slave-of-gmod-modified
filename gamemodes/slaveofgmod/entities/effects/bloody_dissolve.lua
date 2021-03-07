
local function CollideCallback(particle, hitpos, hitnormal)

	local id = 1 
	
	if particle.id then
		id = particle.id
	end

	//util.Decal( "BloodHuge"..id, hitpos + hitnormal, hitpos - hitnormal)
	util.Decal( "BloodHugePurple"..id, hitpos + hitnormal, hitpos - hitnormal)
	
	particle:SetDieTime(0)
	
end

function EFFECT:Init( data )
	
	self.Entity:SetRenderBounds( Vector( -300, -300, -300 ), Vector( 300, 300, 300 ) )
	
	self.ent = data:GetEntity()
	self.normal = data:GetNormal()
	
	self.force = math.random( 200, 300 )
	self.angforce = VectorRand()
	
	if !IsValid( self.ent ) then return end
		
	self.rag = self.ent.GetRagdollEntity and self.ent:GetRagdollEntity()
	
	self.LifeTime = 1.2
	self.DieTime = CurTime() + self.LifeTime
		
	self.rag:AddEffects( EF_NODRAW )
	self.rag:SetMaterial( "models/shiny" )
	self.rag:SetColor( Color(228, 31, math.random( 89, 220 ), 255) )
	
	self.Entity:EmitSound( "physics/flesh/flesh_bloody_break.wav", 35, 100 )
	
	self.delta = 0
	
	local emitter = ParticleEmitter( self:GetPos() )
	
	if emitter then
	
		for i = 0, self.rag:GetPhysicsObjectCount(), 2 do
			local translate = self.rag:TranslatePhysBoneToBone(i)
			if translate and 0 < translate then
				local pos, ang = self.rag:GetBonePosition(translate)
				if pos and ang then
				
					//for j=1, math.random( 2, 4 ) do
					
						local id = math.random(1,4)
						
						local particle = emitter:Add("decals/purple_blood"..id, pos + VectorRand() * 2)
						particle.id = id					
						particle:SetVelocity( VectorRand()*100 + vector_up * 30 + self.normal * 600 )
						particle:SetDieTime( self.LifeTime * ( 1 - self.delta ) )
						particle:SetStartAlpha(231)
						particle:SetEndAlpha(0)
						particle:SetStartSize( 10 )
						particle:SetEndSize( 10 )
						particle:SetRoll(math.Rand(0, 10))
						particle:SetRollDelta(math.Rand(-1, 1))
						particle:SetColor( 145, 20, 20 )
						particle:SetAirResistance( 45 )
						particle:SetBounce(0)
						particle:SetGravity( vector_up * -1600 )//-1500 )
						particle:SetCollide( true )
						particle:SetCollideCallback(CollideCallback)
						
					//end
				end
			end
		end
	
		emitter:Finish() emitter = nil collectgarbage("step", 64)
	
	end
	
	
end

function EFFECT:Think()
	
	self.delta = math.Clamp( 1 - ( self.DieTime - CurTime() ) / self.LifeTime, 0, 1 )
	
	if !IsValid( self.rag ) then
		return false
	end
	
	if self.DieTime < CurTime() then
		//self.rag:AddEffects( EF_NODRAW )
		//return false
	end
	
	for i = 0, self.rag:GetPhysicsObjectCount() do
		local phys = self.rag:GetPhysicsObjectNum(i)
		if phys and phys:IsValid() then
			phys:Wake()
			//phys:SetMaterial( "gmod_silent" )
			//phys:EnableGravity( false )
			//phys:SetVelocityInstantaneous( (self.normal + vector_up * 0.2) * self.force * (1 - self.delta) )
			//phys:AddAngleVelocity( self.angforce * self.force * (1 - self.delta) )
			//phys:SetDamping( 10 * self.delta, 10 * self.delta )
		end
	end
	
	return true
end

local mat = Material( "models/shiny" )
function EFFECT:Render()

	if IsValid( self.rag ) then
		
		local col = self.rag:GetColor()

		render.SetColorModulation( col.r / 255, col.g / 255, col.b / 255 )
		//render.SetColorModulation( 0.89, 0.13, 0.86 )
		//render.ModelMaterialOverride( mat )
		render.SuppressEngineLighting( true )
		self.rag:DrawModel()
		render.SuppressEngineLighting( false )
		//render.ModelMaterialOverride()
		render.SetColorModulation( 1, 1, 1 )
	
	end
	
end