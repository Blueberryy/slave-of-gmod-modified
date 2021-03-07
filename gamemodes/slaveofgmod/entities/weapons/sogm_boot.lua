AddCSLuaFile()

SWEP.Base 				= "sogm_melee_base" 

SWEP.WorldModel			= Model ( "models/props_junk/Shoe001a.mdl"  ) 
SWEP.HoldType			= "grenade"
SWEP.DamageType 		= DMG_CLUB
SWEP.BloodMultiplier 	= 1
SWEP.HitsToExecute 		= 10
SWEP.ExecutionSequence 	= "cidle_grenade"
SWEP.ExecutionGesture 	= ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
SWEP.Primary.Delay		= 0.6
SWEP.ExecutionDelay	 	= 0.2
SWEP.Throwable 			= 430
SWEP.MapOnly 			= true
SWEP.KillOnThrow 		= math.random(10) == 10



SWEP.WElements = {
	["shoe"] = { type = "Model", model = "models/props_junk/Shoe001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.415, 0.368, -0.062), angle = Angle(97.258, 80.075, -180), size = Vector(0.906, 0.906, 0.906), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}


function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/body/body_medium_impact_hard"..math.random(6)..".wav")
end
