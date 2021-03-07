AddCSLuaFile()

SWEP.Base 				= "sogm_melee_base" 

SWEP.WorldModel			= Model ( "models/gibs/antlion_gib_medium_3.mdl"  ) 
SWEP.HoldType			= "knife"
SWEP.DamageType 		= DMG_SLASH
SWEP.ExecutionSequence 	= "cidle_knife"
SWEP.ExecutionGesture 	= ACT_HL2MP_GESTURE_RANGE_ATTACK_KNIFE
SWEP.Primary.Delay		= 0.45
SWEP.ExecutionDelay	 	= 0.4
SWEP.BloodMultiplier 	= 2
SWEP.HitsToExecute 		= 1
SWEP.ShowWorldModel 	= false

SWEP.MeleeRange			= 40

SWEP.WElements = {
	["gib"] = { type = "Model", model = "models/gibs/antlion_gib_medium_3.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0.347, 1.008, -1.448), angle = Angle(-15.44, -3.758, -87.151), size = Vector(0.74, 0.74, 0.74), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/zombie_fast_players/fast_zombie_sheet", skin = 0, bodygroup = {} }
}

function SWEP:PlayHitFleshSound()
	self:EmitSound("weapons/knife/knife_hit"..math.random(3)..".wav", 130, math.random(94,98))
end 
