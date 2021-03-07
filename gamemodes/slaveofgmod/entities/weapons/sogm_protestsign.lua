AddCSLuaFile()

SWEP.Base 				= "sogm_melee_base" 

SWEP.PrintName			= "Protest Sign"

SWEP.WorldModel			= Model ( "models/props_lab/bewaredog.mdl" ) 
SWEP.HoldType			= "melee2"
SWEP.DamageType 		= DMG_CLUB
SWEP.BloodMultiplier 	= 1
SWEP.HitsToExecute 		= 3
SWEP.Primary.Delay		= 0.57
SWEP.ExecutionDelay	 	= 0.43

SWEP.WElements = {
	["sign"] = { type = "Model", model = "models/props_lab/bewaredog.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.122, 2.183, 4.171), angle = Angle(-180, 113.472, 0), size = Vector(0.605, 0.605, 0.605), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/wood/wood_plank_break"..math.random(4)..".wav", 75, math.Rand(95, 105))
	sound.Play( "physics/body/body_medium_break"..math.random(2, 3)..".wav", self:GetPos(), 85, 100, 1 )
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