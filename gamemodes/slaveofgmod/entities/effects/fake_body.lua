function EFFECT:Init( data )
	
	self.Entity:SetRenderBounds( Vector( -300, -300, -300 ), Vector( 300, 300, 300 ) )
	
	if SINGLEPLAYER then 
		local ent = data:GetEntity()
		
		if !IsValid(ent) then return end
		
		local rag = ent.GetRagdollEntity and ent:GetRagdollEntity()
	
		if !IsValid(rag) then return end
		
		self.ent = ent
		self.rag = rag
		
		if NIGHTMARE and ent:IsNextBot() and rag.Hide then
			rag:AddEffects( EF_NODRAW )
		end
		
		if ent:GetMaterial() ~= "" then
			rag:SetMaterial(ent:GetMaterial())
		end
		
		if ent:GetMaterial() == "models/charple/charple1_sheet" then
			ParticleEffectAttach( "env_fire_tiny", PATTACH_ABSORIGIN_FOLLOW, rag, 0 )
			//CreateParticleSystem( rag, "burning_character", PATTACH_ABSORIGIN_FOLLOW, 0, Vector( 0, 0, 0 ) )
		end
		
		
		for i = 0, ent:GetBoneCount() - 1 do
			local scale = ent:GetManipulateBoneScale( i )
			
			//if scale ~= Vector( 1, 1, 1 ) then
				rag:ManipulateBoneScale( i, scale )
				rag:ManipulateBoneScale( i, scale )
				rag:ManipulateBoneScale( i, scale )
			//end
			
		end
		
		
		return 
	end
	
	if not LocalPlayer().fake_bodies then return end
	
	if #LocalPlayer().fake_bodies >= math.min(40, SOG_MAX_CORPSES) then return end
	
	local ent = data:GetEntity()
	local bodywear_ind = math.Round( data:GetScale() )
	
	if !IsValid(ent) then return end
	
	local bodywear = bodywear_ind ~= 0 and Entity( bodywear_ind ) or nil
			
	local rag = ent.GetRagdollEntity and ent:GetRagdollEntity()
	
	if !IsValid(rag) then return end
			
	local test = rag:BecomeRagdollOnClient()
	//test:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	rag.Rag = test
	test.Parent = rag
	test:SetOwner( ent )
	
	//wow, what a safe measure
	if rag.Rag.SnatchModelInstance then
		rag.Rag:SnatchModelInstance( ent ) 
	end
	
	if ent:GetMaterial() ~= "" then
		test:SetMaterial(ent:GetMaterial())
	end
	
	test.NewRagdollOwner = ent
	
	self.Parent = test
	
	if ent.GetPlayerColor then
		test.StoredColor = ent:GetPlayerColor()
	end
	
	if ent:IsNextBot() then
		test.StoredColor = ent:GetDTVector( 0 )
	end
	
	if NIGHTMARE and ent:IsNextBot() and rag.Hide then
		self.Parent:AddEffects( EF_NODRAW )
	end

	if IsValid(self.Parent) then
		for i = 0, self.Parent:GetPhysicsObjectCount() do
			local phys = self.Parent:GetPhysicsObjectNum(i)
			if phys and phys:IsValid() then
				phys:SetDamping( 1, 1 )
				//phys:SetVelocityInstantaneous( (phys:GetVelocity():GetNormal() - vector_up * 1.5):GetNormal() * 600 )
				phys:SetMass( 33643000 )
				phys:EnableDrag( true )
				//phys:SetMaterial( "zombieflesh" )
				phys:Wake()
			end
		end		
		if IsValid( bodywear ) then			
			self.DrawBodywear = true
			local b = bodywear
			self.Entity:SetModel( b:GetModel() )
			self.Entity:SetSkin( b:GetSkin() )
			self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
			self.Entity:SetParent( self.Parent )
			self.Entity:AddEffects( EF_BONEMERGE )
			if test.StoredColor then
				self.Entity.StoredColor = test.StoredColor
			end
			if b.DoBoneScaling then
				b:DoBoneScaling( self.Entity )
				b:DoBoneScaling( self.Entity )
			end
			self.Parent:AddEffects( EF_NODRAW )
		end
		
	end
	
	table.insert( LocalPlayer().fake_bodies, test )
	

end

function EFFECT:Think()
	
	if IsValid(self.rag) and game.GetMap() == "sog_chase_v2"  and self.rag:GetPos().z < 0 then
		if not self.AppliedForce then
			self.AppliedForce = true
			self.ForceTime = CurTime() + 4
		end
		
		if self.ForceTime and self.ForceTime > CurTime() then
			for i = 0, self.rag:GetPhysicsObjectCount() do
				local phys = self.rag:GetPhysicsObjectNum(i)
				if phys and phys:IsValid() then
					phys:Wake()
					phys:SetMaterial( "bloodyflesh" )
					phys:SetVelocityInstantaneous( Vector( 0, 1, 0 ) * 300 + Vector( 1, 0, 0 ) * 100 * ( self.rag:GetPos().x > -385 and 1 or -1 ) )
				end
			end
		end
	end
	
	if SINGLEPLAYER then
		return IsValid(self.rag)
	end

	return IsValid(self.Parent)
end

local vector_up = vector_up
local render = render

function EFFECT:Render()
	//stupid crutch so we can render character's sck shit on death (players only)
	if SINGLEPLAYER then
		
		if IsValid( self.ent ) and IsValid( self.rag ) then
			
			if self.ent.WElements then
				
				GAMEMODE:DrawSCKModels( self.ent )
				
			end
			
		end
		
	end

end