AddCSLuaFile()

ENT.Type = "anim"

util.PrecacheModel("models/props_c17/tv_monitor01.mdl")

function ENT:Initialize()

	self.Entity:GetOwner().Roll = self
	self.Entity.Owner = self.Entity:GetOwner()
	self.Entity:DrawShadow( false )	

	if SERVER then
	
		self:SetModel("models/props_c17/tv_monitor01.mdl")
		
		self:SetSolid(SOLID_VPHYSICS)
		self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
		self:SetTrigger( true )
		
		self.Entity:DrawShadow(false)

		local bone = self.Entity.Owner:LookupBone("ValveBiped.Bip01_Pelvis")
		if bone then
			self.Entity.Owner:ManipulateBoneAngles( bone, Angle(0,0,-20)  )
			self.Entity.Owner:ManipulateBonePosition( bone, vector_up*-30  )
		end
		/*local bone = self.Entity.Owner:LookupBone("ValveBiped.Bip01_Spine4")
		if bone then
			self.Entity.Owner:ManipulateBoneAngles( bone, Angle(0,15,0)  )
		end
		local bone = self.Entity.Owner:LookupBone("ValveBiped.Bip01_Head1")
		if bone then
			self.Entity.Owner:ManipulateBoneAngles( bone, Angle(0,-15,0)  )
		end*/
		
		//self:Fire("Kill", "", 0.65)	
		
		//self.Entity.Owner:SetVelocity(self.Entity.Owner:GetVelocity() * 0.3)
		
	end
	if CLIENT then
		self.Entity.Owner:SetIK(true)
		//sound.Play( self.Sound, self:GetPos(), 100, 100, 1 )
		self.Sound = CreateSound(self.Entity, "physics/body/body_medium_scrape_smooth_loop1.wav")
		self.Entity:SetRenderBounds(Vector(-128, -128, -128), Vector(128, 128, 128))
	end
	
end



function ENT:OnRemove()
	
	if IsValid(self.Entity.Owner) then
		if SERVER then
			if !self.NoUnfreezing then
				self.Entity.Owner:Freeze( false )
			end
		end
		self.Entity.Owner:ResetBoneMatrix()
		self.Entity.Owner.Roll = nil
	end
	if CLIENT then
		if self.Sound then
			self.Sound:Stop()
		end
	end

end
if SERVER then

function ENT:Think()	
	if !IsValid(self.Entity.Owner) or IsValid(self.Entity.Owner) and !self.Entity.Owner:Alive() then
		self:Remove()
		return
	end
	if !self.Entity.Owner:KeyDown(IN_JUMP) or self.Entity.Owner:GetVelocityLength() < self.Entity.Owner:GetMaxSpeed()/2 then
		self:Remove()
		return
	end
end

function ENT:StartTouch( ent )
		
	//if !self.NoKnockdown and IsValid( ent ) and (ent:IsPlayer() or ent:IsNextBot()) then
		//if ent ~= self.Entity.Owner and !IsValid(ent.Knockdown) and !IsValid(ent.Execution) then
			//ent:DoKnockdown( 1.2, false, self.Entity.Owner )
		//end
	//end
	
end

end

if CLIENT then

function ENT:Think()
	if self.Sound and IsValid(self.Entity.Owner) and self.Entity.Owner:OnGround() then
		self.Sound:PlayEx(0.35,123)
	end
end

function ENT:Draw()
	self.NextEffect = self.NextEffect or 0
	
	if self.NextEffect > CurTime() then return end
	
	self.NextEffect = CurTime() + 0.013
		
	local emitter = ParticleEmitter(self:GetPos())
	emitter:SetPos(self.Entity.Owner:GetShootPos())

	
	local rand = VectorRand()
	rand.z = 0
	local pos = self.Entity.Owner:GetPos() + vector_up*math.Rand(2,4) + rand*math.Rand(-15,15)
	
	for i=1, 2 do
		local particle = emitter:Add("particles/smokey", pos)
		particle:SetVelocity(math.Rand(0.1, 0.7)*self.Entity.Owner:GetVelocity()+VectorRand()*2+vector_up*math.random(30))
		particle:SetDieTime(math.Rand(0.5, 1))
		particle:SetStartAlpha(100)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.random(3,5))
		particle:SetEndSize(math.random(6,10))
		particle:SetRoll(math.Rand(-180, 180))
		particle:SetColor(100, 100, 100)
		particle:SetCollide(true)
		particle:SetBounce(0.1)
		particle:SetAirResistance(15)
		particle:SetGravity(vector_up*-25)
	end
	
	emitter:Finish()
end	
end


hook.Add("CalcMainActivity","RollAnims",function(pl,vel)
	if pl.Roll and IsValid(pl.Roll) then
		//local iSeq, iIdeal = pl:LookupSequence("cidle_all")
		local wep = pl.GetActiveWeapon and pl:GetActiveWeapon():IsValid() and pl:GetActiveWeapon()
		//fix the horrifying anims
		if wep and wep:GetHoldType() == "pistol" then
			local iSeq, iIdeal = pl:LookupSequence("swimming_revolver")
			return iIdeal, iSeq 
		elseif wep and wep:GetHoldType() == "shotgun" then
			local iSeq, iIdeal = pl:LookupSequence("swimming_ar2")
			return iIdeal, iSeq 
		elseif wep and wep:GetHoldType() == "normal" then
			local iSeq, iIdeal = pl:LookupSequence("swimming_fist")
			return iIdeal, iSeq 
		elseif wep and wep.SlidingGesture then
			local iSeq, iIdeal = pl:LookupSequence(wep.SlidingGesture)
			return iIdeal, iSeq 
		else
			local iIdeal, iSeq = ACT_MP_SWIM, -1
			return iIdeal, iSeq 
		end
	end	
end)

hook.Add("UpdateAnimation","RollAnims",function(pl, velocity, maxseqgroundspeed)
	if pl.Roll and IsValid(pl.Roll) then
		pl:SetPlaybackRate(0)
		pl:SetCycle(0.2)
		pl:SetPoseParameter("move_x", -1 )
		pl:SetPoseParameter("move_y", 0 )
		pl:SetPoseParameter("aim_pitch", 14.0 ) 
		pl:SetPoseParameter("aim_yaw", 12.0 ) 
		pl:SetPoseParameter("head_pitch", 60.0 ) 
		//pl:SetPoseParameter( "aim_pitch", 81.5 ) 
		return true
	end
end)