AddCSLuaFile()

SWEP.Base 				= "sogm_melee_base" 

SWEP.WorldModel			= Model ( "models/healthvial.mdl"  ) 
SWEP.HoldType			= "melee"

SWEP.ExecutionSequence 	= "cidle_melee"
SWEP.BloodMultiplier 	= 2
SWEP.HitsToExecute 		= 4
SWEP.NoDamage 			= true
SWEP.DamageType 		= DMG_CLUB
SWEP.ExecutionGesture 	= ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
SWEP.Primary.Delay		= 0.6
SWEP.ExecutionDelay	 	= 0.2
SWEP.Throwable 			= 430

SWEP.WElements = {
	["health"] = { type = "Model", model = "models/healthvial.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.733, 1.302, -5.889), angle = Angle(-7.941, -78.939, 8.138), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/body/body_medium_impact_hard"..math.random(6)..".wav")
end
