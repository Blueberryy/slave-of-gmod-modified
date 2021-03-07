local mat_overlay = Material( "models/spawn_effect2" )

function EFFECT:Init( data )
	
	self.ent = data:GetEntity()
	self.time = data:GetRadius() or 1
	
	if !IsValid(self.ent) then return end
	
	
	self:SetModel( self.ent:GetModel() )
	self:SetParent( self.ent )
	self:AddEffects(EF_BONEMERGE)
	
	self.DieTime = CurTime() + self.time
	
	
end

function EFFECT:Think()
	
	return self.ent and self.ent:IsValid() and self.ent.Alive and self.ent:Alive() and self.DieTime and ( self.DieTime > CurTime() )
	
end

function EFFECT:Render()
	
	if self.ent and self.ent:IsValid() and self.ent.Alive and self.ent:Alive() then
	
		render.SuppressEngineLighting( true )
		render.MaterialOverride( mat_overlay )
		render.SetColorModulation( 0.9, 0, 0 )
			
		
		self:SetupBones()
		self:DrawModel()
								
		render.SetColorModulation( 1, 1, 1 )
		render.MaterialOverride( nil )
		render.SuppressEngineLighting( false )
	
	end
	
end



