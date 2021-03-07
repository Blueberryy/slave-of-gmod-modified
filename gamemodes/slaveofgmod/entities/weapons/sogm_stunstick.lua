AddCSLuaFile()

SWEP.Base 				= "sogm_melee_base" 

SWEP.WorldModel			= Model ( "models/weapons/w_stunbaton.mdl"  ) 
SWEP.HoldType			= "melee"
SWEP.DamageType 		= DMG_CLUB
SWEP.BloodMultiplier 	= 1.3
SWEP.HitsToExecute 		= 15
SWEP.ExecutionSequence 	= "cidle_melee"
SWEP.ExecutionGesture 	= ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
SWEP.Primary.Delay		= 0.6
SWEP.ExecutionDelay	 	= 0.22

SWEP.Hidden				= true
//SWEP.NoDamage 			= true


SWEP.WElements = {
	["stick1"] = { type = "Model", model = "models/weapons/w_stunbaton.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.769, 1.838, 2.174), angle = Angle(5.826, 166.992, -8.08), size = Vector(1.144, 1.144, 1.144), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["stick1_handle"] = { type = "Model", model = "models/props_c17/pillarcluster_001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "stick1", pos = Vector(1.906, -0.598, -3.014), angle = Angle(-0.775, -6.623, 180), size = Vector(0.03, 0.03, 0.03), color = Color(40, 40, 40, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/body/body_medium_impact_hard"..math.random(6)..".wav")
	sound.Play( "physics/body/body_medium_break"..math.random(2, 3)..".wav", self:GetPos(), 85, 100, 1 )
	//self:EmitSound("physics/body/body_medium_break"..math.random(2, 3)..".wav",75,115)
end

if CLIENT then
local ang_flip = Angle(35,-25,-90) 
function SWEP:OnDrawWorldModel()
	
	if IsValid(self.Owner) then
		local bone = self.Owner:LookupBone("ValveBiped.Bip01_R_UpperArm")
		if bone then 
			self.Owner:ManipulateBoneAngles( bone, ang_flip )
		end
	end
		
end
end