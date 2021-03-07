AddCSLuaFile()

SWEP.Base 				= "sogm_melee_base" 

SWEP.WorldModel			= Model ( "models/props_c17/BriefCase001a.mdl"  ) 
SWEP.HoldType			= "melee"
SWEP.DamageType 		= DMG_CLUB
SWEP.BloodMultiplier 	= 1
SWEP.HitsToExecute 		= 3
SWEP.ExecutionSequence 	= "cidle_melee"
SWEP.ExecutionGesture 	= ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
SWEP.Primary.Delay		= 0.6
SWEP.ExecutionDelay	 	= 0.4


SWEP.WElements = {
	["briefcase"] = { type = "Model", model = "models/props_c17/BriefCase001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(9.612, 2.573, -1.512), angle = Angle(82.402, -5.888, -0.38), size = Vector(0.768, 0.768, 0.768), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}


function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/body/body_medium_impact_hard"..math.random(6)..".wav")
	//self:EmitSound("physics/body/body_medium_break"..math.random(2, 3)..".wav",75,115)
	sound.Play( "physics/body/body_medium_break"..math.random(2, 3)..".wav", self:GetPos(), 85, 100, 1 )
end