AddCSLuaFile()

SWEP.Base 				= "sogm_melee_base" 

SWEP.WorldModel			= Model ( "models/props_trainstation/payphone_reciever001a.mdl"  ) 
SWEP.HoldType			= "melee"
SWEP.DamageType 		= DMG_CLUB
SWEP.BloodMultiplier 	= 1
SWEP.HitsToExecute 		= 10
SWEP.ExecutionSequence 	= "cidle_melee"
SWEP.ExecutionDelay	 	= 0.15
SWEP.ExecutionGesture 	= ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
SWEP.Primary.Delay		= 0.6
SWEP.Throwable 			= 430
SWEP.MapOnly 			= true


SWEP.WElements = {
	["phone"] = { type = "Model", model = "models/props_trainstation/payphone_reciever001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(-0.297, 9.6, 18.281), angle = Angle(0, 64.526, -180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/body/body_medium_impact_hard"..math.random(6)..".wav")
end
