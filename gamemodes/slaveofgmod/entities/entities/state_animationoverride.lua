AddCSLuaFile()

ENT.Type = "anim"

function ENT:Initialize()

	self.Entity:GetOwner().AnimationOverride = self
	self.Entity:DrawShadow( false )	
	
	self:SetParent( self.Entity:GetOwner() )

end

function ENT:SetOverrideSpeed( speed )
	self:SetDTInt( 1, speed )
end

function ENT:SetOverrideSequence( seq_id )
	self:SetDTInt( 0, seq_id )
end

function ENT:GetOverrideSequence()
	return self:GetDTInt( 0 )
end

function ENT:GetOverrideSpeed()
	return self:GetDTInt( 1 )
end

if SERVER then
	function ENT:Think()
	
		if self.RemoveOnStage then
			if IsValid( self.Entity:GetOwner() ) and CUR_STAGE == self.RemoveOnStage then
				self:Remove()
				return 
			end
		else
			if IsValid( self.Entity:GetOwner() ) and IsValid( self.Entity:GetOwner():GetActiveWeapon() ) and self.Entity:GetOwner():GetActiveWeapon():GetClass() ~= "sogm_fists" then 
				self:Remove()
				return 
			end
		end
		
		if !IsValid(self.Entity:GetOwner()) or IsValid(self.Entity:GetOwner()) and !self.Entity:GetOwner():Alive() then
			self:Remove()
			return
		end
	end
end

function ENT:OnRemove()
	
	if IsValid(self.Entity:GetOwner()) then
		self.Entity:GetOwner().AnimationOverride = nil
	end

end

function ENT:Draw()
end

hook.Add("CalcMainActivity","OverrideAnims",function(pl,vel)
	if pl.AnimationOverride and IsValid( pl.AnimationOverride ) and !IsValid( pl.Knockdown ) then
		return -1, pl.AnimationOverride:GetOverrideSequence()
	end	
end)
