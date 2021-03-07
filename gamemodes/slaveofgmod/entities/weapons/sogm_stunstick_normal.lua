AddCSLuaFile()

SWEP.Base 				= "sogm_melee_base" 

SWEP.PrintName			= "Stunstick"

SWEP.WorldModel			= Model ( "models/weapons/w_stunbaton.mdl"  ) 
SWEP.HoldType			= "knife"
SWEP.DamageType 		= DMG_CLUB
SWEP.BloodMultiplier 	= 1.3
SWEP.HitsToExecute 		= 3
SWEP.ExecutionSequence 	= "cidle_melee"
SWEP.ExecutionGesture 	= ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
SWEP.Primary.Delay		= 0.6
SWEP.ExecutionDelay	 	= 0.22
SWEP.ShowWorldModel 	= true

SWEP.OverrideAttackGesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/body/body_medium_impact_hard"..math.random(6)..".wav")
	self:EmitSound("physics/body/body_medium_break"..math.random(2, 3)..".wav",75,115)
end