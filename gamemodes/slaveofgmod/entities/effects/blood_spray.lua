local math = math
local util = util
local VectorRand = VectorRand

local function CollideCallback(particle, hitpos, hitnormal)
	//if not particle.HitAlready then
		//particle.HitAlready = true

		if BLACK_BLOOD then
			util.Decal("BloodHugeBlack"..math.random(3,4), hitpos + hitnormal, hitpos - hitnormal)	
			particle:SetDieTime(0)
			return
		end
		
		if particle.HorseBlood then
			util.Decal("BloodHugePurple"..math.random(3,4), hitpos + hitnormal, hitpos - hitnormal)	
			particle:SetDieTime(0)
			return
		end
		
		if particle.Yellow then
			util.Decal(math.random(5) == 5 and "Impact.Antlion" or "YellowBlood", hitpos + hitnormal, hitpos - hitnormal)
		else
			util.Decal(math.random(20) == 11 and "Blood" or "Impact.Flesh", hitpos + hitnormal, hitpos - hitnormal)
		end
		
		particle:SetBounce( math.Rand(0.01, 0.02) )
		local vel = particle.StartVelocity
		particle:SetVelocity( vel * math.Rand(4,9) + VectorRand() * 200 )
		if particle.Hits < particle.MaxHits then
			particle.Hits = particle.Hits + 1
		else
			particle:SetDieTime(0)
		end	
		
		//particle:SetDieTime(0)
	//end	
end

local mins = Vector( - 360, - 360, - 360)
local maxs = Vector( 360, 360, 360)
function EFFECT:Init(data)
	
	self.Pos = data:GetOrigin()
	self.Dir = data:GetNormal() or VectorRand()
	self.Scatter = data:GetStart() or VectorRand() * 3
	self.Amount = math.Round(data:GetMagnitude()) or math.random(2,3)
	self.Force = data:GetScale() or math.random(100,200)
	self.Yellow = math.Round(data:GetRadius()) == 1 or false
	
	self.HorseBlood = math.Round(data:GetRadius()) == 2 or false
	
	if DRUG_EFFECT then
		self.Yellow = true
	end
		
	//self.Emitter = ParticleEmitter(self.Entity:GetPos())
	
	local emitter = ParticleEmitter( self.Entity:GetPos() )
	
	self:SetRenderBounds( mins, maxs )

	local e = EffectData()
		e:SetOrigin( self.Pos )
		e:SetNormal( self.Dir )
		e:SetStart( self.Pos )
		e:SetScale( 1 )
	util.Effect( "BloodImpact", e, true, true )

	if emitter then
	
		for i = 1, self.Amount do
			local pos = self.Pos + self.Scatter
			local mat
			if DRUG_EFFECT then
				mat = math.random(2) == 2 and "Decals/alienflesh/shot"..math.random(5) or "Decals/yblood"..math.random(6)
			else
				mat = math.random(2) == 2 and "Decals/flesh/Blood"..math.random(5) or "Decals/Blood"..math.random(7)
			end
			
			if self.HorseBlood then
				mat = "decals/purple_blood"..math.random(4)
			end
			
			if BLACK_BLOOD then
				mat = "decals/black_blood"..math.random(4)
			end
			
			local particle = emitter:Add(mat, pos)
			particle:SetVelocity( self.Dir * self.Force + VectorRand() * self.Force * math.Rand(0,0.3) )
			particle.Huge = math.random(5) == 5
			particle:SetDieTime(0.8)
			particle:SetStartAlpha(250)
			particle:SetStartSize(3)
			particle:SetEndSize(math.random(3,5))
			particle:SetRoll(math.random(-180, 180))
			if DRUG_EFFECT then
				particle:SetColor(255, 255, 255)
			else
				particle:SetColor(255, 0, 0)
			end
			if BLACK_BLOOD then
				particle:SetColor(0, 0, 0)
			end
			particle:SetLighting(true)
			particle:SetCollide(true)
			particle:SetAirResistance(16)
			particle:SetGravity( vector_up * -1900 )
			particle:SetCollideCallback(CollideCallback)
			particle.Yellow = self.Yellow
			particle.HorseBlood = self.HorseBlood
			particle.StartVelocity = particle:GetVelocity()
			particle.Hits = 0
			particle.MaxHits = math.random(0,math.random(0, particle.Huge and 40 or 2))
		end
		
		emitter:Finish() emitter = nil collectgarbage("step", 64)
	end
	
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
