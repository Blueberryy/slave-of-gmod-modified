AddCSLuaFile()

ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

DONATOR_TOKENS = DONATOR_TOKENS or {}

function ENT:Initialize()
	self.EntOwner = self.Entity:GetOwner()
	
	if IsValid(self.EntOwner.ent_token) then
		if SERVER then
			self.EntOwner.ent_token:Remove()
		end
		self.EntOwner.ent_token = nil
	end
	
	local count = 0
	
	for k, v in pairs( DONATOR_TOKENS ) do
		count = count + 1
	end
	
	local id = count + 1 
	
	for i=1, count do
		if not DONATOR_TOKENS[i] then
			id = i
			break
		end
	end
	
	self:SetID( id )
	
	self.EntOwner.ent_token = self.Entity
	self:SetSolid(SOLID_NONE)
	self:SetMoveType(MOVETYPE_NONE)
	self:AddEffects(EF_BONEMERGE)
	self:SetModel( "models/player/kleiner.mdl" )
	
	//self:SetMaterial( "models/zombie_fast_players/fast_zombie_sheet" )
	self:SetSubMaterial( 3, "models/kleiner/walter_face" )
	
	DONATOR_TOKENS[self:GetID()] = self.Entity
	
	if SERVER then
		if self:GetID() == 1 then
			self:ActivateToken()
		end
		self:CheckLineChilds()
		self.Entity:DrawShadow(false)
	end
	if CLIENT then
		self:SetRenderBounds(Vector(-360,-360,0),Vector(360,360,360))
	end
end

function ENT:CheckLineChilds()
	/*if self:GetID() > 1 then
		local check = self:GetID() - 1
		if DONATOR_TOKENS[check] and DONATOR_TOKENS[check]:IsValid() then
			self:SetLineChild( DONATOR_TOKENS[check] )
		end
		if self:GetID() == 5 then
			timer.Simple( 1, function()
				if self then
					for k, v in pairs( DONATOR_TOKENS ) do
						if v and v:IsValid() and v:GetID() == 1 then
							v:SetLineChild( self )
						end
					end
				end
			end)
		end
	end*/
	
	timer.Simple( 0.1, function()
				if self then
					if self:GetID() > 1 then
						local check = self:GetID() - 1
				
						for k, v in pairs( DONATOR_TOKENS ) do
							if v and v:IsValid() and v:GetID() == check then
								self:SetLineChild( v )
							end
						end
						
						if self:GetID() == 5 then
							for k, v in pairs( DONATOR_TOKENS ) do
								if v and v:IsValid() and v:GetID() == 1 then
									v:SetLineChild( self )
								end
							end
						end
					end
				end
			end)
	
end

function ENT:SetLineChild( ent )
	self:SetDTEntity( 0, ent )
end

function ENT:GetLineChild()
	return self:GetDTEntity( 0 )
end

function ENT:ActivateToken()
	self:SetActive( true )
	self.Time = CurTime() + 5
	if SERVER then
		//self:GetOwner().Immune = false
	end
end

function ENT:SwitchTokens()
	
	local found_token = false
	
	self:SetActive( false )
	if self:GetOwner() and self:GetOwner():IsValid() then
		//self:GetOwner().Immune = true
	end
	
	local count = 0
	
	for k, v in pairs( DONATOR_TOKENS ) do
		count = count + 1
	end
	
	local cur = self:GetID()
	
	cur = cur + 1
	
	if cur > count then
		cur = 1
	end
	
	for i=1, 5 do 
		if i < cur then continue end
		if DONATOR_TOKENS[i] and DONATOR_TOKENS[i]:IsValid() then
			found_token = true
			DONATOR_TOKENS[i]:ActivateToken()
			break
		end
	end
	
	if not found_token then
		for i=1, 5 do 
			if DONATOR_TOKENS[i] and DONATOR_TOKENS[i]:IsValid() then
				found_token = true
				DONATOR_TOKENS[i]:ActivateToken()
				break
			end
		end
	end
	
	if not found_token then
		self:ActivateToken()
	end
	
end

function ENT:Think()
	if SERVER then
		if self:IsActive() and self.Time and self.Time <= CurTime() then
			self:SwitchTokens()
		end
		if !IsValid(self.EntOwner) or not self.EntOwner:Alive() then
			self:Remove()
			return
		end	
	end	
end

function ENT:OnRemove()
	if not self.ForceRemove then
		if DONATOR_TOKENS[self:GetID()] and DONATOR_TOKENS[self:GetID()] == self.Entity then
			DONATOR_TOKENS[self:GetID()] = nil
			self:SwitchTokens()
		end
	end
end

if SERVER then
	function ENT:UpdateTransmitState()
		return TRANSMIT_ALWAYS
	end
end

function ENT:SetActive( bl )
	self:SetDTBool( 0, bl )
end

function ENT:IsActive()
	return self:GetDTBool( 0 )
end

function ENT:SetID( num )
	self:SetDTInt( 0, num )
end

function ENT:GetID()
	return self:GetDTInt( 0 )
end

if CLIENT then
local mat_overlay = Material( "models/spawn_effect2" )
local mat_ring = Material( "particle/warp1_warp" )

local mat_beam = Material( "effects/bloodstream" )
local mat_beam2 = Material( "effects/lamp_beam" )
function ENT:DrawTranslucent()	
	
	self:SetModel( "models/player/kleiner.mdl" )
	
	if not self.FixedBones then
		if self:GetOwner() and self:GetOwner():IsValid() then
			local head = self:LookupBone( "ValveBiped.Bip01_Head1" )
			for i=0, self:GetBoneCount() - 1 do
				if i == head then 
					self:ManipulateBoneScale( i, Vector( 1.1, 1.1, 1.1 ) )
					continue 
				end
				self:ManipulateBoneScale( i, vector_origin )
			end
			local bone = self:GetOwner():LookupBone( "ValveBiped.Bip01_Spine4" )
			if bone then
				self:GetOwner():ManipulateBoneAngles( bone, Angle( 0, -30, 0 ) )
				self:GetOwner():ManipulateBoneAngles( bone, Angle( 0, -30, 0 ) )
			end
			self.FixedBones = true
		end
	end
	
	local bone = self:LookupBone( "ValveBiped.Bip01_Head1" )
	if bone then
		local pos, ang = self:GetBonePosition( bone )
		if pos and ang then
			render.EnableClipping( true )
				render.PushCustomClipPlane( vector_up, vector_up:Dot( pos + vector_up*1.5 ) )
				self:SetupBones()
				self:DrawModel()
				render.PopCustomClipPlane()
			render.EnableClipping( false )
		end
	end
	
	
	
	if !self:IsActive() then
	
		self:SetModel( "models/player/zombie_fast.mdl" )
	
		render.SuppressEngineLighting( true )
		render.MaterialOverride( mat_overlay )
		render.SetColorModulation( 0.9, 0, 0 )
		
		if self:GetOwner() and self:GetOwner():IsValid() then
			local head = self:LookupBone( "ValveBiped.Bip01_Head1" )
			for i=0, self:GetBoneCount() - 1 do
				if i == head then 
					self:ManipulateBoneScale( i, Vector( 1.1, 1.1, 1.1 ) )
					continue 
				end
				self:ManipulateBoneScale( i, Vector(1, 1, 1) )
			end
			local bone = self:GetOwner():LookupBone( "ValveBiped.Bip01_Spine4" )
			if bone then
				self:GetOwner():ManipulateBoneAngles( bone, Angle( 0, -30, 0 ) )
				self:GetOwner():ManipulateBoneAngles( bone, Angle( 0, -30, 0 ) )
			end
			self.FixedBones = true
		end
		
		
		//self:SetupBones()
		self:DrawModel()
							
		render.SetColorModulation( 1, 1, 1 )
		render.MaterialOverride( nil )
		render.SuppressEngineLighting( false )
		
		if self:GetOwner() and self:GetOwner():IsValid() then
			render.SetMaterial( mat_ring )
			local sz = math.sin( RealTime() * 1 )*10 + 90
			render.DrawQuadEasy( self:GetOwner():GetPos() + vector_up * 1, vector_up, sz, sz, Color( 135, 20, 20, 245 + sz/2 ), math.NormalizeAngle(RealTime() * 30) ) //
		end
		
	end
				
	self.FixedBones = false
	
	if self:GetOwner() then
		self:GetOwner().RenderGroup = RENDERGROUP_OPAQUE
	end
	
	if self:GetLineChild() and self:GetLineChild():IsValid() then
		if self:GetOwner():IsValid() and self:GetLineChild():GetOwner():IsValid() then
			render.SetMaterial( mat_beam )
			render.DrawBeam( self:GetOwner():GetPos() + vector_up * 30, self:GetLineChild():GetOwner():GetPos() + vector_up * 30, 25 + math.sin( RealTime() * 1 ) * 10, RealTime()*0.8, RealTime()*0.8 + 1.8 + math.cos( RealTime() * 1 )*0.2, Color( 135, 20, 20, 255 ) ) 
			render.SetMaterial( mat_beam2 )
			render.DrawBeam( self:GetOwner():GetPos() + vector_up * 30, self:GetLineChild():GetOwner():GetPos() + vector_up * 30, 25 + math.cos( RealTime() * 1 ) * 10, RealTime()*0.8, RealTime()*0.8 + 1.8 + math.sin( RealTime() * 1 )*0.2, Color( 135, 20, 20, 255 ) ) 

		end
	end
	
	/*
	local pos = self:GetOwner():LocalToWorld(self:GetOwner():OBBCenter())
	local angle = Angle(0,90 * (LocalPlayer():FlipView() and -1 or 1),0)
	
	local text = "id "..self:GetID()
	
	cam.IgnoreZ( true )
		cam.Start3D2D(pos,angle,0.4)
			draw.DrawText(text, "PixelSmall", 0, 0, Color(210, 210, 210, 255),TEXT_ALIGN_CENTER)
		cam.End3D2D()
	cam.IgnoreZ( false )*/
	
end
end