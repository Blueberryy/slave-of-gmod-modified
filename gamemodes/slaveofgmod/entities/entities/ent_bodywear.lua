AddCSLuaFile()

ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Initialize()

	self.EntOwner = self.Entity:GetOwner()
	
	if IsValid(self.EntOwner.ent_bodywear) then
		if SERVER then
			self.EntOwner.ent_bodywear:Remove()
		end
		self.EntOwner.ent_bodywear = nil
	end
	
	self.EntOwner.ent_bodywear = self.Entity
	self:SetSolid(SOLID_NONE)
	self:SetMoveType(MOVETYPE_NONE)
	self:AddEffects(EF_BONEMERGE)
	
	self.Team = function() return self.EntOwner and self.EntOwner:Team() end
	
	if SERVER then
		self.Entity:DrawShadow(false)
		self:SetDTVector( 0, Vector(1, 1, 1))
	end
	if CLIENT then
		self:SetRenderBounds(Vector(-360,-360,0),Vector(360,360,360))
		self:SetLOD( 0 )
	end
	
	//self.EntOwner:SetRenderMode(RENDERMODE_NONE)
end

function ENT:OnRemove()
	if IsValid(self.EntOwner) then
		self:GetOwner().ent_bodywear = nil
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

function ENT:GetPlayerColor()
	if self:GetOwner() and self:GetOwner():IsPlayer() then
		return self:GetOwner().GetPlayerColor and self:GetOwner():GetPlayerColor() or Vector(1,1,1)
	end
	/*if self:GetOwner() and self:GetOwner().IsNextBot and self:GetOwner():IsNextBot() then
		return self:GetOwner():GetDTVector( 0 ) or Vector(1,1,1)
	end*/
	
	return self:GetDTVector(0) or Vector( 1, 1, 1 )
	
end 

if CLIENT then
local zero_vector = vector_origin

function ENT:DoBoneScaling( ent )
	
	//ent = ent or self
	
	local head = true
	
	local bone = ent:LookupBone( "ValveBiped.Bip01_Head1" )
	if bone and ent:GetManipulateBoneScale(bone) ~= zero_vector then
		ent:ManipulateBoneScale( bone, zero_vector  )
	else
		head = false
	end
	
	bone = ent:LookupBone( "ValveBiped.Bip01_Spine2" )
	if bone and ent:GetManipulateBoneScale(bone) ~= Vector( 1.45, 1.45, 1.45 ) then
		ent:ManipulateBoneScale( bone, Vector( 1.45, 1.45, 1.45 )  )
	end
	
	bone = ent:LookupBone( "ValveBiped.Bip01_Spine4" )
	if head then
		if bone and ent:GetManipulateBoneScale(bone) ~= Vector( 1.45, 1.45, 1.45 ) then
			ent:ManipulateBoneScale( bone, Vector( 1.45, 1.45, 1.45 )  )
		end
	else
		if bone and ent:GetManipulateBoneScale(bone) ~= zero_vector then
			ent:ManipulateBoneScale( bone, zero_vector  )
		end
	end
	
	bone = ent:LookupBone( "ValveBiped.Bip01_L_Forearm" )
	if bone and ent:GetManipulateBoneScale(bone) ~= Vector( 1.15, 1.15, 1.15 )  then
		ent:ManipulateBoneScale( bone, Vector( 1.15, 1.15, 1.15 )  )
	end
	
	bone = ent:LookupBone( "ValveBiped.Bip01_R_Forearm" )
	if bone and ent:GetManipulateBoneScale(bone) ~= Vector( 1.15, 1.15, 1.15 ) then
		ent:ManipulateBoneScale( bone, Vector( 1.15, 1.15, 1.15 )  )
	end
	
	bone = ent:LookupBone( "ValveBiped.Bip01_L_UpperArm" )
	if bone and ent:GetManipulateBoneScale(bone) ~= Vector( 1.25, 1.25, 1.25 ) then
		ent:ManipulateBoneScale( bone, Vector( 1.25, 1.25, 1.25 )  )
	end
	
	bone = ent:LookupBone( "ValveBiped.Bip01_R_UpperArm" )
	if bone and ent:GetManipulateBoneScale(bone) ~= Vector( 1.25, 1.25, 1.25 ) then
		ent:ManipulateBoneScale( bone, Vector( 1.25, 1.25, 1.25 )  )
	end
	
end

function ENT:Draw()
		
	if not self:GetOwner()._changedLOD then
		self:GetOwner():SetLOD( 0 )
		self:GetOwner()._changedLOD = true
	end
	
	self:SetPos( self:GetOwner():GetPos() )
	
	//render.SetColorModulation( 90/255, 90/255, 90/255 )
		//self:SetupBones()
		self:DrawModel()
	//render.SetColorModulation( 1, 1, 1 )
	
	if self:GetOwner() and self:GetOwner().GetCharTable and self:GetOwner():GetCharTable().ArmorBoneScaling then
		self:GetOwner():GetCharTable():ArmorBoneScaling( self )
	else
		if self:GetOwner() and self:GetOwner().GetCharTable and self:GetOwner():GetCharTable().NoArmorBoneScale then

		else
			self:DoBoneScaling( self )
		end
	end
	
	
	
end

end