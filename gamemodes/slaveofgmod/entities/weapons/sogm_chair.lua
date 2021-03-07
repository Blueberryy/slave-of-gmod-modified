AddCSLuaFile()

SWEP.Base 				= "sogm_melee_base" 

SWEP.WorldModel			= Model ( "models/props_interiors/furniture_chair03a.mdl"  ) 
SWEP.HoldType			= "melee2"
SWEP.DamageType 		= DMG_CLUB
SWEP.BloodMultiplier 	= 1.8
SWEP.HitsToExecute 		= 1
SWEP.Primary.Delay		= 0.7
SWEP.ExecutionDelay	 	= 0.45

SWEP.WElements = {
	["chair"] = { type = "Model", model = "models/props_interiors/furniture_chair03a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(10.263, -4.395, -4.205), angle = Angle(0, 0, 0), size = Vector(0.882, 0.882, 0.882), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/metal/metal_sheet_impact_hard6.wav", 100, 145)
	sound.Play( "physics/body/body_medium_break"..math.random(2, 3)..".wav", self:GetPos(), 85, 100, 1 )
	//self:EmitSound("physics/body/body_medium_break"..math.random(2, 3)..".wav")
end

if CLIENT then
local ang_flip = Angle(10,-20,30) 
function SWEP:OnDrawWorldModel()
	
	if IsValid(self.Owner) then
		local bone = self.Owner:LookupBone("ValveBiped.Bip01_R_UpperArm")
		if bone then 
			self.Owner:ManipulateBoneAngles( bone, ang_flip  )
		end
	end
		
end
end