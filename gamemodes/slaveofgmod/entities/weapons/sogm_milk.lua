AddCSLuaFile()

SWEP.Base 				= "sogm_melee_base" 

SWEP.WorldModel			= Model ( "models/props_junk/garbage_milkcarton002a.mdl"  ) 
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
	["milk"] = { type = "Model", model = "models/props_junk/garbage_milkcarton002a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.184, 2.532, -1.341), angle = Angle(0.395, 22.927, -166.243), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/body/body_medium_impact_hard"..math.random(6)..".wav")
end