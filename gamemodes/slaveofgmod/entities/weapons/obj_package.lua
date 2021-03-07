AddCSLuaFile()

SWEP.Base 				= "sogm_melee_base" 

SWEP.WorldModel			= Model ( "models/props_junk/cardboard_box003a.mdl"  ) 
SWEP.HoldType			= "slam"
SWEP.DamageType 		= DMG_CLUB
SWEP.BloodMultiplier 	= 1
SWEP.HitsToExecute 		= 3
//SWEP.ExecutionSequence 	= "cidle_fist"
//SWEP.ExecutionGesture 	= ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL

SWEP.Primary.Delay		= 0.6
SWEP.ExecutionDelay	 	= 0.35
SWEP.NoDamage 			= true

SWEP.DontRemove 		= true //this will prevent dropped weapon from despawning

SWEP.OverrideAttackGesture = ACT_GMOD_GESTURE_MELEE_SHOVE_1HAND
SWEP.Team				= 6

SWEP.WElements = {
	["box"] = { type = "Model", model = "models/props_junk/cardboard_box003a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.825, 7.222, -4.733), angle = Angle(9.52, -19.494, -155.849), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}