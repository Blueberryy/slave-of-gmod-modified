AddCSLuaFile()

SWEP.Base 				= "sogm_melee_base" 

SWEP.WorldModel			= Model ( "models/props_junk/metalgascan.mdl"  ) 
SWEP.HoldType			= "melee2"
SWEP.DamageType 		= DMG_CLUB
SWEP.BloodMultiplier 	= 2
SWEP.HitsToExecute 		= 1
SWEP.Primary.Delay		= 0.7
SWEP.ExecutionDelay	 	= 0.45


SWEP.WElements = {
	["gascan"] = { type = "Model", model = "models/props_junk/metalgascan.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(10.079, -2.796, -1.504), angle = Angle(20.6, -55.688, 82.377), size = Vector(0.634, 0.634, 0.634), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}


function SWEP:PlayHitFleshSound()
	self:EmitSound("ambient/materials/door_hit1.wav", 95, math.Rand(95, 105))
	sound.Play( "physics/body/body_medium_break"..math.random(2, 3)..".wav", self:GetPos(), 85, 100, 1 )
	//self:EmitSound("physics/body/body_medium_break"..math.random(2, 3)..".wav")
end


if CLIENT then
local ang_flip = Angle(10,-20,30)
function SWEP:OnDrawWorldModel()
	
	if IsValid(self.Owner) then
		local bone = self.Owner:LookupBone("ValveBiped.Bip01_R_UpperArm")
		if bone then 
			self.Owner:ManipulateBoneAngles( bone, ang_flip )
		end
	end
		
end
end