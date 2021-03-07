AddCSLuaFile()

SWEP.Base 				= "sogm_melee_base" 

SWEP.WorldModel			= Model ( "models/props_c17/chair_stool01a.mdl"  ) 
SWEP.HoldType			= "melee2"
SWEP.DamageType 		= DMG_CLUB
SWEP.BloodMultiplier 	= 1.8
SWEP.HitsToExecute 		= 2
SWEP.Primary.Delay		= 0.7
SWEP.ExecutionDelay	 	= 0.45

function SWEP:PlayHitFleshSound()
	sound.Play( "physics/body/body_medium_break"..math.random(2, 3)..".wav", self:GetPos(), 85, 100, 1 )
	self:EmitSound("physics/metal/metal_sheet_impact_hard6.wav", 100, 145)
	//self:EmitSound("physics/body/body_medium_break"..math.random(2, 3)..".wav")
end

SWEP.WElements = {
	["chair"] = { type = "Model", model = "models/props_c17/chair_stool01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.157, 1.389, 11.633), angle = Angle(4.921, 0, 176.832), size = Vector(0.794, 0.794, 0.794), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

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