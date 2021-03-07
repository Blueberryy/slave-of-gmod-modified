local math = math

local sh_switch = false

function EFFECT:Init(data)
	
	self.WeaponEnt = data:GetEntity()
	if not (IsValid(self.WeaponEnt) and self.WeaponEnt:IsWeapon()) then return end
	
	self.Normal = data:GetNormal()

	
	if self.WeaponEnt.Akimbo and sh_switch then
		
		local owner = self.WeaponEnt:GetOwner()
		
		if !IsValid(owner) then return end
		
		self.EjectionPort = owner:GetAttachment(owner:LookupAttachment("anim_attachment_LH"))
		if not self.EjectionPort then return end
					
		self.Forward = self.Normal:Angle():Right()*-1
		self.Angle = self.Forward:Angle()
		self.Position = self.EjectionPort.Pos + (0.5*self.WeaponEnt:BoundingRadius())*self.EjectionPort.Ang:Forward()	
		
		//if self.Position:Distance(EyePos()) > 700 then return end

		local AddVel = self.WeaponEnt:GetOwner():GetVelocity()

		local effectdata = EffectData()
		effectdata:SetOrigin(self.Position)
		effectdata:SetAngles(self.Angle)
		effectdata:SetEntity(self.WeaponEnt)
		util.Effect("ShotgunShellEject", effectdata)
	
	else
	
		self.EjectionPort = self.WeaponEnt:GetAttachment(1)
		if not self.EjectionPort then return end
		
		
			
		self.Forward = self.Normal:Angle():Right()
		self.Angle = self.Forward:Angle()
		self.Position = self.EjectionPort.Pos - (0.5*self.WeaponEnt:BoundingRadius())*self.EjectionPort.Ang:Forward()	
		
		//if self.Position:Distance(EyePos()) > 700 then return end

		local AddVel = self.WeaponEnt:GetOwner():GetVelocity()

		local effectdata = EffectData()
		effectdata:SetOrigin(self.Position)
		effectdata:SetAngles(self.Angle)
		effectdata:SetEntity(self.WeaponEnt)
		util.Effect("ShotgunShellEject", effectdata)
		
	end
		

	sh_switch = !sh_switch

end


function EFFECT:Think()

	return false
	
end


function EFFECT:Render()


end



