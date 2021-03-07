AddCSLuaFile()

SWEP.Base 					= "sogm_m4" 
SWEP.PrintName				= "Cursed M4"
SWEP.Hidden = true

function SWEP:Think()
	if SERVER then
		
		self.NextRegen = self.NextRegen or 0
		
		if CUR_STAGE == 1 then
			self:SetClip1( 0 )
			return
		end
		
		if self:Clip1() < self.Primary.ClipSize and self:GetNextPrimaryFire() < CurTime() and self.NextRegen < CurTime() then
			self:SetClip1( math.Clamp( self:Clip1() + 1, 0, self.Primary.ClipSize ) )
			self.NextRegen = CurTime() + ( CUR_STAGE == 4 and 0.15 or 0.3 )
		end
		
	end
end