local Gibs = {
	Model( "models/Gibs/HGIBS.mdl" ),
	Model( "models/props_junk/watermelon01_chunk02a.mdl" ),
	Model( "models/props_junk/watermelon01_chunk02b.mdl" ),
	Model( "models/props_junk/watermelon01_chunk02c.mdl" ),
	Model( "models/Gibs/HGIBS_rib.mdl" ),
	Model( "models/Gibs/HGIBS_scapula.mdl" ),
	Model( "models/Gibs/HGIBS_spine.mdl" ),
	Model( "models/Gibs/Antlion_gib_medium_1.mdl" ),	
	Model( "models/Gibs/Shield_Scanner_Gib6.mdl" ),
}

local mat = Material( "effects/strider_pinch_dudv" )

function EFFECT:Init(data)

	self.ent = data:GetEntity()

	local modelid = data:GetScale() or math.random( #Gibs )
	self.Entity:SetModel(Gibs[ modelid ])

	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	self.Entity:SetCollisionBounds( Vector( -128 -128, -128 ), Vector( 128, 128, 128 ) )

	if modelid > 1 then
		self.Entity:SetMaterial("models/flesh")
		self.Entity:SetModelScale( math.Rand(1,3), 0 )
	end
	
	self.horseblood = IsValid( self.ent ) and self.ent:GetCharTable().Horse
	
	local dir = data:GetNormal() or VectorRand()
	local power = data:GetMagnitude() or 500
	
	if self.horseblood then
		power = power * math.random(2,3)
	end
	
	local override_time = math.Round( data:GetRadius() ) == -1 and true or false
		
	local phys = self.Entity:GetPhysicsObject()
	if ( phys && phys:IsValid() ) then
		phys:Wake()
		phys:SetMaterial("zombieflesh")
		phys:SetAngles( Angle( math.random(0,359), math.random(0,359), math.random(0,359) ) )
		phys:SetVelocityInstantaneous( dir * power + VectorRand() * 30 + vector_up*20 )		
	end
	
	//if override_time and IsValid( LocalPlayer() ) and LocalPlayer().fake_bodies then
	//	self.Time = -1
	//	table.insert( LocalPlayer().gibs, self.Entity )
	//else
		self.Time = CurTime() + math.random(8, 10)
	//end
	
	//local tbl = LocalPlayer().gibs
	//tbl[ #tbl + 1 ] = self.Entity
	
	//if self.horseblood then
	//	self.Time = CurTime() + math.random(8, 10)
	//end
	

	//self.Emitter = ParticleEmitter(self.Entity:GetPos())	
end

function EFFECT:Think()
	if CurTime() > self.Time and self.Time ~= -1 then
		//self.Emitter:Finish()
		return false
	end
	return true
end

local function CollideCallbackSmall(particle, hitpos, hitnormal)
	if not particle.HitAlready then
		particle.HitAlready = true
		
		if BLACK_BLOOD then
			util.Decal("BloodHugeBlack"..math.random(4), hitpos + hitnormal, hitpos - hitnormal)	
			particle:SetDieTime(0)
			return
		end
		
		if particle.HorseBlood then
			util.Decal("BloodHugePurple"..math.random(2,4), hitpos + hitnormal, hitpos - hitnormal)	
			//util.Decal(math.random(15) == 15 and "BloodHuge"..math.random(3,6) or "BloodHuge"..math.random(2), hitpos + hitnormal, hitpos - hitnormal)
			particle:SetDieTime(0)
			return
		end
		
		if DRUG_EFFECT then
			if TERROR then
				util.Decal(math.random(15) == 15 and "BloodHuge"..math.random(6).."" or "YellowBlood", hitpos + hitnormal, hitpos - hitnormal)
			else
				//util.Decal(math.random(15) == 15 and "StainHuge"..math.random(7).."" or "YellowBlood", hitpos + hitnormal, hitpos - hitnormal)
				util.Decal("StainHuge"..math.random(7).."", hitpos + hitnormal, hitpos - hitnormal)	
				util.Decal("YellowBlood", hitpos + hitnormal, hitpos - hitnormal)	
			end
			//util.Decal(math.random(15) == 15 and "YellowBlood" or "Impact.Antlion", hitpos + hitnormal, hitpos - hitnormal)
		else
			util.Decal(math.random(15) == 15 and "Blood" or "Impact.Flesh", hitpos + hitnormal, hitpos - hitnormal)
		end
		particle:SetDieTime(0)
	end	
end


function EFFECT:Render()
	if IsValid(self.Entity) then
		self.Entity:DrawModel()
		if self.Entity:GetVelocity():LengthSqr() > 100 then

			self.NextEmit = self.NextEmit or 0
			
			if self.NextEmit < CurTime() then
			
				local emitter = ParticleEmitter( self:GetPos() )
			
				local horse = self.horseblood
				local creepy_blood = horse or DRUG_EFFECT
			
				local mat = DRUG_EFFECT and "Decals/alienflesh/shot"..math.random(5) or "Decals/flesh/Blood"..math.random(5)
				
				if horse then
					mat = "decals/purple_blood"..math.random(4)
				end
				
				if emitter then
				
					local particle = emitter:Add( mat, self.Entity:GetPos() )
					particle:SetVelocity(VectorRand() * 16)
					particle:SetDieTime(0.8)
					particle:SetStartAlpha(255)
					if DRUG_EFFECT then
						particle:SetStartSize( 20 * self.Entity:GetModelScale() )
						particle:SetEndSize(10 * self.Entity:GetModelScale())
					else
						particle:SetStartSize( 6 * self.Entity:GetModelScale() )
						particle:SetEndSize(2 * self.Entity:GetModelScale())
					end
					particle:SetRoll(180)
					if creepy_blood then
						particle:SetColor(255, 255, 255)
					else
						particle:SetColor(255, 0, 0)
					end
					particle:SetLighting( horse and false or true )
					particle:SetCollide(true)
					particle:SetGravity( vector_up * -300 )
					particle:SetAirResistance(12)
					particle.ent = self.Entity
					particle:SetCollideCallback(CollideCallbackSmall)
					
					if horse then
						particle.HorseBlood = true
					end
					
					emitter:Finish() emitter = nil collectgarbage("step", 64)
					
				end
				
				self.NextEmit = CurTime() + 0.06
			end
		end
	end
end

local gib_render = function( self )
	
	self:DrawModel()
	
	if self:GetVelocity():LengthSqr() > 100 then

			self.NextEmit = self.NextEmit or 0
			
			if self.NextEmit < CurTime() then
				
				local horse = self.horseblood
				local creepy_blood = horse or DRUG_EFFECT
			
				local mat = DRUG_EFFECT and "Decals/alienflesh/shot"..math.random(5) or "Decals/flesh/Blood"..math.random(5)
				
				if horse then
					mat = "decals/purple_blood"..math.random(4)
				end
				
				local emitter = ParticleEmitter( self:GetPos() )
				
				local scale = self and self.GetModelScale and self:GetModelScale() or 1
				
				if emitter then
				
					local particle = emitter:Add( mat, self:GetPos() )
					particle:SetVelocity(VectorRand() * 16)
					particle:SetDieTime(0.8)
					particle:SetStartAlpha(255)
					if DRUG_EFFECT then
						particle:SetStartSize( 20 * scale )
						particle:SetEndSize( 10 * scale )
					else
						particle:SetStartSize( 6 * scale )
						particle:SetEndSize(2 * scale )
					end
					particle:SetRoll(180)
					if creepy_blood then
						particle:SetColor(255, 255, 255)
					else
						particle:SetColor(255, 0, 0)
					end
					particle:SetLighting( horse and false or true )
					particle:SetCollide(true)
					particle:SetGravity( vector_up * -300 )
					particle:SetAirResistance(12)
					particle.ent = self
					particle:SetCollideCallback(CollideCallbackSmall)
					
					if horse then
						particle.HorseBlood = true
					end
					
					emitter:Finish() emitter = nil collectgarbage("step", 64)
					
				end
				self.NextEmit = CurTime() + 0.06
			end
		
	end

end

local NextEffect = 0
local collision_bounds = Vector( 5, 5, 5 )

for i=1, 4 do
	util.PrecacheSound( "ambient/explosions/exp"..i..".wav" )
end
	
effects.Register(
            {
                Init = function(self, data)
				
					self.ent = data:GetEntity()
                    local pos = data:GetOrigin()
					local norm = data:GetNormal()
					
					//if CurTime() < NextEffect then return end
					//NextEffect = CurTime() + 0.01
					
					local rag = IsValid(self.ent) and self.ent.GetRagdollEntity and self.ent:GetRagdollEntity()
					
					if rag and rag:IsValid() then
						rag.Hide = true
					end
					
					local horse = IsValid( self.ent ) and self.ent:GetCharTable().Horse
										
					self.Entity:EmitSound( "physics/flesh/flesh_bloody_break.wav" )
					
					for i = 1, math.random(3,9) do
						
						local gib = ClientsideModel(Gibs[ math.random( 2, #Gibs )], RENDERGROUP_OPAQUE)
						local gib_normal = norm + VectorRand() * 0.8
						
						local power = math.random( 150, 300 )
	
						if horse then
							power = power * math.random(2,3)
						end
							
						if gib:IsValid() then
								
							gib:SetMaterial( "models/flesh" )
							gib:SetModelScale( math.Rand( 1, 3 ),0 )
							gib:SetPos( pos + vector_up * 30 + VectorRand() * 15 )
							gib:SetAngles( VectorRand():Angle() )
							
							gib:PhysicsInitBox( collision_bounds * -1, collision_bounds )
							gib:SetCollisionBounds( collision_bounds * -1, collision_bounds )
									
							//gib:AddCallback( "PhysicsCollide", gib_callback )

							gib:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
							gib:SetMoveType(MOVETYPE_VPHYSICS)
							
							gib.horseblood = horse
							
							gib.RenderOverride = gib_render
							
							local phys = gib:GetPhysicsObject()
							if phys:IsValid() then
								phys:SetMaterial("bloodyflesh")
								phys:SetVelocityInstantaneous( gib_normal * power + VectorRand() * 30 + vector_up*20 )	
							end
							
							//local tbl = LocalPlayer().gibs
							//tbl[ #tbl + 1 ] = gib
							table.insert( LocalPlayer().gibs, gib )

							SafeRemoveEntityDelayed(gib, math.Rand(6, 10))
						end
						
					end					
					
					if horse and rag and rag:IsValid() then
						rag:AddEffects( EF_NODRAW )
					end
					
					if horse or DRUG_EFFECT then
						local e = EffectData()
							e:SetOrigin( pos + vector_up * 30 )
						util.Effect( "refract_effect", e )
						sound.Play( "ambient/explosions/exp"..math.random(4)..".wav", pos )
					end
					
					
                end,
 
                Think = function() end,
 
                Render = function(self) end
            },
 
            "player_gib"
		)
		
effects.Register(
            {
                Init = function(self, data)
				
					self.ent = data:GetEntity()
                    local pos = data:GetOrigin()
					local norm = data:GetNormal()
					
					--if CurTime() < NextEffect then return end
					--NextEffect = CurTime() + 0.01
					
					local rag = IsValid(self.ent) and self.ent.GetRagdollEntity and self.ent:GetRagdollEntity()
					
					if rag and rag:IsValid() then
						rag.Hide = true
					end
										
					self.Entity:EmitSound( "physics/flesh/flesh_bloody_break.wav" )
					
					local emitter = ParticleEmitter(pos + vector_up * 30)
					
					for i = 1, math.random(10,14) do
						
						local particle = emitter:Add("decals/black_blood"..math.random(4), pos + vector_up * 30 + VectorRand() * 15)
						if i < 5 then
							particle:SetVelocity( math.random(100,200) * norm + vector_up * 300 + VectorRand() * 205 )
						else
							particle:SetVelocity( math.random(300,900) * norm + VectorRand() * 205 )
						end
						particle:SetDieTime(1)
						particle:SetStartAlpha(255)
						particle:SetStartSize(15)
						particle:SetEndSize(math.random(17,23))
						particle:SetRoll(math.random(-180, 180))
						particle:SetColor(255, 255, 255)
						particle:SetLighting(true)
						particle:SetCollide(true)
						particle:SetAirResistance(16)
						particle:SetGravity( vector_up * -1900 )
						particle.Black = true
						particle:SetCollideCallback(CollideCallbackSmall)
						
					end
					
					emitter:Finish() emitter = nil collectgarbage("step", 64)
					
					if rag and rag:IsValid() then
						rag:AddEffects( EF_NODRAW )
					end
					
                end,
 
                Think = function() end,
 
                Render = function(self) end
            },
 
            "player_gib_black"
		)



//just reusing some code from one of the old refraction ring effects	
effects.Register(
            {
                Init = function( self, data )
				
                    self.pos = data:GetOrigin()
					self.goal = math.Rand( 0.01, 0.11 )
					self.refr = 0
					self.max = data:GetMagnitude() or math.random( 1100, 1500 )
					self.cur = 16 + math.random(-5,5)
					
					self.Entity:SetRenderBounds(Vector(-self.max, -self.max, -self.max), Vector(self.max, self.max, self.max))
					
                end,
 
                Think = function( self )
				
					self.refr = self.refr + FrameTime() * 0.5
					self.cur = self.max * self.refr ^ 0.3

					return self.refr < 1
				
				end,
 
                Render = function( self ) 
					
					local pos = self.Entity:GetPos()

					//mat:SetFloat("$refractamount", math.sin( (self.refr) * math.pi) * -0.07)
					//mat:SetFloat("$refractamount", -1)
					mat:SetFloat("$refractamount", 0.07 * ( 1 - self.refr ) * (LocalPlayer():FlipView() and -1 or 1 ))
					render.SetMaterial(mat)
					render.SetBlend( 0.2 )
					render.UpdateRefractTexture()
					render.DrawQuadEasy(pos, Vector(0, 0, 1), self.cur, self.cur)
					render.SetBlend( 1 )
				
				end
            },
 
            "refract_effect"
		)
		
local mat_refract = Material( "effects/strider_pinch_dudv" )		
effects.Register(
            {
                Init = function( self, data )
				
                    self.pos = data:GetOrigin()
					self.ent = data:GetEntity()
					
					self.Entity:SetRenderBounds(Vector(-300, -300, -300), Vector(300, 300, 300))
					
					
					
                end,
 
                Think = function( self )
				
					if self.ent and self.ent:IsValid() and self.ent:Alive() then
						self:SetPos( self.ent:GetPos() )
						return true
					end
					
					return false
				
				end,
 
                Render = function( self ) 

					if self.ent and self.ent:IsValid() and self.ent:Alive() then
						local pl = self.ent
						
						local add = ( pl:GetVelocity():Length()/pl:GetMaxSpeed() ) * 0.01
						mat_refract:SetFloat("$refractamount", ( 0.001 + add  ) * (LocalPlayer():FlipView() and -1 or 1 ))
						mat_refract:SetInt("$ignorez", 0 )
						render.SetMaterial( mat_refract )
						render.UpdateRefractTexture()
						render.DrawQuadEasy( pl:GetPos() - vector_up * 10, vector_up, ScrW()/2, ScrW()/2, color_white, 0 )
					
					end
				end
            },
 
            "drug_effect"
		)

