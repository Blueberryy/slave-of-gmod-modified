AddCSLuaFile()

ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_BOTH

local model = Model( "models/humans/charple04.mdl" )

function ENT:SetDistorted( bl )
	self:SetDTBool( 0, bl )
end

function ENT:IsDistorted()
	return self:GetDTBool( 0 )
end

function ENT:SetNormal( bl )
	self:SetDTBool( 1, bl )
end

function ENT:IsNormal()
	return self:GetDTBool( 1 )
end

function ENT:ApplyDistortion()
	local owner = self:GetOwner()
	if owner and owner:IsValid() then
		if not self.Applied then
			for i=1, owner:GetBoneCount() - 1 do
				if math.random(2) == 2 then
					owner:ManipulateBoneAngles( i, AngleRand() * math.random( 360 ) )
				end
				//if math.random(2) == 2 then
					//owner:ManipulateBoneScale( i,Vector( 1, 1, 1 ) * math.Rand(0.2, 3) )
				//end
			end
			self.Applied = true
		end
	end
end

function ENT:Initialize()

	self.EntOwner = self.Entity:GetOwner()
	
	if IsValid(self.EntOwner.ent_doppler) then
		if SERVER then
			self.EntOwner.ent_doppler:Remove()
		end
		self.EntOwner.ent_doppler = nil
	end
	
	self.EntOwner.ent_doppler = self.Entity
	self:SetSolid(SOLID_NONE)
	self:SetMoveType(MOVETYPE_NONE)
	self:AddEffects(EF_BONEMERGE)
		
	if SERVER then
		self.Entity:DrawShadow(false)
		self:SetModel( self.EntOwner:GetModel() )		
	end
	if CLIENT then
		self:SetRenderBounds(Vector(-360,-360,0),Vector(360,360,360))
		self:SetLOD( 0 )
	end
end

function ENT:OnRemove()
	if IsValid(self.EntOwner) then
		self:GetOwner().ent_doppler = nil
	end
end

function ENT:Think()
	if SERVER then
		if !IsValid(self.EntOwner) or not self.EntOwner:Alive() then
			self:Remove()
			return
		end
	end	
end

if SERVER then
	function ENT:UpdateTransmitState()
		return TRANSMIT_ALWAYS
	end
end

if CLIENT then

local vec = Vector(-43.091, -32.389, -3.018)
local angle = Angle(-8.952, -131.243, -87.985)
local size = 1.11
local bone = "ValveBiped.Bip01_Spine2"

function ENT:GetPlayerColor()
	return self:GetOwner() and self:GetOwner().GetPlayerColor and self:GetOwner():GetPlayerColor() or vector_origin
end

function ENT:Draw()

	if !IsValid( self:GetOwner() ) then return end

	if not self:GetOwner()._changedLOD then
		self:GetOwner():SetLOD( 0 )
		self:GetOwner()._changedLOD = true
	end
	
	if self:IsNormal() then
		self:DrawModel()
	else
		if self:IsDistorted() then
			self:ApplyDistortion()
		else
			if not self.ang then self.ang = Angle( 0, 0, 0 ) end
			
			local bone = self:GetOwner():LookupBone("ValveBiped.Bip01_Head1")
			if bone then
				self.ang.r = math.NormalizeAngle( RealTime() * 163 )
				self:GetOwner():ManipulateBoneAngles( bone, self.ang  )
			end
		end
	end
			
end

end