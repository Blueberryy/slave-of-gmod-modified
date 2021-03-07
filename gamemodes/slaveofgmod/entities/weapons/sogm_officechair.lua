AddCSLuaFile()

SWEP.Base 				= "sogm_melee_base" 

SWEP.WorldModel			= Model ( "models/props/cs_office/chair_office.mdl"  ) 
SWEP.HoldType			= "melee2"
SWEP.DamageType 		= DMG_CLUB
SWEP.BloodMultiplier 	= 1.8
SWEP.HitsToExecute 		= 1
SWEP.Primary.Delay		= 0.7
SWEP.ExecutionDelay	 	= 0.45

SWEP.WElements = {
	["chair"] = { type = "Model", model = "models/props/cs_office/chair_office.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.555, -0.555, 7.763), angle = Angle(7.487, -123.989, -172.249), size = Vector(0.755, 0.755, 0.755), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}


function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/metal/metal_sheet_impact_hard6.wav", 100, 145)
	sound.Play( "physics/body/body_medium_break"..math.random(2, 3)..".wav", self:GetPos(), 85, 100, 1 )
	//self:EmitSound("physics/body/body_medium_break"..math.random(2, 3)..".wav")
end

if CLIENT then
function SWEP:OnDrawWorldModel()
	
	if IsValid(self.Owner) then
		local bone = self.Owner:LookupBone("ValveBiped.Bip01_R_UpperArm")
		if bone then 
			self.Owner:ManipulateBoneAngles( bone, Angle(10,-20,30)  )
		end
	end
		
end
end