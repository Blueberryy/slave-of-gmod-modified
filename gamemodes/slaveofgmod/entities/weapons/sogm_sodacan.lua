AddCSLuaFile()

SWEP.Base 				= "sogm_melee_base" 

SWEP.WorldModel			= Model ( "models/props_junk/PopCan01a.mdl"  ) 
SWEP.HoldType			= "grenade"
SWEP.DamageType 		= DMG_CLUB
SWEP.BloodMultiplier 	= 0.5
SWEP.HitsToExecute 		= 10
SWEP.ExecutionSequence 	= "cidle_grenade"
SWEP.ExecutionGesture 	= ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
SWEP.Primary.Delay		= 0.6
SWEP.ExecutionDelay	 	= 0.21
SWEP.Throwable 			= 330
SWEP.MapOnly 			= true

SWEP.WElements = {
	["can"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.157, 2.13, -0.304), angle = Angle(10.802, 0, 180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = math.random(3), bodygroup = {} }
}


function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/body/body_medium_impact_hard"..math.random(6)..".wav")
end



