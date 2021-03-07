function EFFECT:Init( data )
	
	self.ent = data:GetEntity()
	self.seq = math.Round( data:GetMagnitude() or 1 )
	self.speed = data:GetScale() or 1
	self.RagdollSpeed = math.Rand( 0.05, 0.15 )
	self.ang = data:GetAngles()
	
	//if not seq[ self.seq ] then return end
	if !IsValid(self.ent) then return end
	
	local rag = self.ent.GetRagdollEntity and self.ent:GetRagdollEntity()
	
	if !IsValid(rag) then return end
	
	for i = 0, self.ent:GetBoneCount() - 1 do
		local scale = self.ent:GetManipulateBoneScale( i )
			
		if scale ~= Vector( 1, 1, 1 ) then
			rag:ManipulateBoneScale( i, scale )
			rag:ManipulateBoneScale( i, scale )
			rag:ManipulateBoneScale( i, scale )
		end
			
	end

	self:SetModel( self.ent:GetModel() )
	self:SetAngles( self.ang )
	--self:SetAngles( self.ent:GetAngles() )
	//self:SetParent( self.ent )

	self:SetSequence( self.seq )
	//self:SetSequence(self:LookupSequence( seq[ self.seq ] ))
	self:SetPlaybackRate( self.speed )
	
	self.DieTime = (self:SequenceDuration()*0.95)/self.speed + CurTime()
	
	self.LastRender = 0
	
end


function EFFECT:Think()

	local rag = IsValid(self.ent) and self.ent.GetRagdollEntity and self.ent:GetRagdollEntity()

	if IsValid(rag) then
		if rag.Rag then
			self.Rag = rag.Rag
		end
	end
	
	if IsValid(self.Rag) then
		rag = self.Rag
	end
		
	if rag and IsValid(rag) then
		
		for i = 0, rag:GetPhysicsObjectCount() do
			local translate = self:TranslatePhysBoneToBone(i)
			if translate and 0 < translate then
			local pos, ang = self:GetBonePosition(translate)
			if pos and ang then
				local phys = rag:GetPhysicsObjectNum(i)
				if phys and phys:IsValid() then
					phys:Wake()
					if math.random(3) == 3 then
						phys:ComputeShadowControl({secondstoarrive = self.RagdollSpeed or 0.05, pos = pos, angle = ang, maxangular = 2000, maxangulardamp = 10000, maxspeed = 5000, maxspeeddamp = 1000, dampfactor = 0.85, teleportdistance = 100, deltatime = RealFrameTime()})
					end
					end
				end
			end
		end
		
		self:NextThink( CurTime() )
		
	end
	
	

	return self.DieTime and self.DieTime > CurTime()
end

function EFFECT:Render()
	
	self:FrameAdvance( ( RealTime() - ( self.LastRender or 0 ) ) * 1 )
	
	self.LastRender = RealTime()
	
end