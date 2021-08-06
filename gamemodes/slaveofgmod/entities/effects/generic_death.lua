function EFFECT:Init(data)
	self.Ent = data:GetEntity()
	self.Pos = data:GetOrigin()
	
	if!IsValid(self.Ent) then return end
	
	
	
	self.Rag = self.Ent.GetRagdollEntity and self.Ent:GetRagdollEntity()
	self.Dir = data:GetNormal()
	self.Force = data:GetMagnitude()
	
	self.Vel = self.Dir * self.Force//vector_origin//self.Ent:GetVelocity()
	
	if self.Ent:GetCharTable().HideRagdollEntity then
		if IsValid( self.Rag ) then
			self.Rag:AddEffects( EF_NODRAW )
		end
	end
	
	if self.Rag and self.Rag:IsValid() and self.Rag.SnatchModelInstance then
		self.Rag:SnatchModelInstance( self.Ent ) 
	end
	
	//print(self.Vel)
	
	//self.Emitter = ParticleEmitter(self.Entity:GetPos())
	
	self.DieTime = CurTime() + math.Rand(0.05,0.2)
	
end

function EFFECT:Think()
	if !IsValid(self.Rag) or self.DieTime and self.DieTime <= CurTime() then
		//if self.Emitter then
			//self.Emitter:Finish()
		//end
		return false
	end
	return true
end

local function CollideCallback(particle, hitpos, hitnormal)
	
	if DRUG_EFFECT then
		util.Decal(math.random(20) == 15 and "YellowBlood" or "Impact.Antlion", hitpos + hitnormal, hitpos - hitnormal)
	else
		util.Decal(math.random(20) == 15 and "Blood" or "Impact.Flesh", hitpos + hitnormal, hitpos - hitnormal)
	end
	
	particle:SetBounce( math.Rand(0.01, 0.015) )
	local vel = particle.StartVelocity
	particle:SetVelocity( vel * math.Rand(4,12) + VectorRand() * 800 )
	if particle.Hits <= particle.MaxHits then
		particle.Hits = particle.Hits + 1
	else
		particle:SetDieTime(0)
	end	
end

function EFFECT:Render()

	local MySelf = IsValid( LocalPlayer():GetObserverTarget() ) and LocalPlayer():GetObserverTarget() or LocalPlayer()
	
	local visible = MySelf:GetPos():DistToSqr(self:GetPos()) < DRAW_DISTANCE * DRAW_DISTANCE
	
	if not visible then return end

	if IsValid(self.Rag) then
		//if self.Rag:GetPhysicsObjectNum(1) and self.Rag:GetPhysicsObjectNum(1):GetVelocity():Length() > 0 then
			self.Delay = self.Delay or 0
			if self.Delay < CurTime() then
				self.Delay = CurTime() + 0.065
				
				local emitter = ParticleEmitter(self.Entity:GetPos())
				
				if emitter then
				
					for i=0, 15, 4 do
						local bone = self.Rag:GetBoneMatrix(i)
						if bone then
							local pos = bone:GetTranslation()
							local mat
							if DRUG_EFFECT then
								mat = math.random(2) == 2 and "Decals/alienflesh/shot"..math.random(5) or "Decals/yblood"..math.random(6)
							else
								mat = math.random(2) == 2 and "Decals/flesh/Blood"..math.random(5) or "Decals/Blood"..math.random(7)
							end
							
							
							local particle = emitter:Add(mat, pos + vector_up * i)
							particle:SetVelocity(VectorRand() * 366 + self.Vel * math.Rand(1,1.5) + vector_up * - 450 )
							particle.Huge = math.random(5) == 5
							particle:SetDieTime(particle.Huge and 1 or 1)
							particle:SetStartAlpha(235)
							particle:SetEndAlpha( 255 )
							particle:SetStartSize(2)
							particle:SetEndSize(math.random(2,6))
							particle:SetRoll(math.random(-180,180))
							particle:SetColor(255, 0, 0)
							particle:SetLighting(true)
							particle:SetCollide(true)
							particle:SetAirResistance(particle.Huge and 2 or 70)
							particle:SetGravity( vector_up * -3500 )
							particle:SetCollideCallback(CollideCallback)
							particle.Hits = 0
							
							particle.StartVelocity = particle:GetVelocity()
							particle.MaxHits = math.random(0,math.random(0, particle.Huge and 45 or 2))
						end	
					end
					
					emitter:Finish() emitter = nil collectgarbage("step", 64)
				end
			end
		//end
	end

end
