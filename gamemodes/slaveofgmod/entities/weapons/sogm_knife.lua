AddCSLuaFile()

SWEP.Base 				= "sogm_melee_base" 

SWEP.WorldModel			= Model ( "models/weapons/w_knife_t.mdl"  ) 
SWEP.HoldType			= "knife"
SWEP.DamageType 		= DMG_SLASH
SWEP.ExecutionSequence 	= "cidle_knife"
SWEP.ExecutionGesture 	= ACT_HL2MP_GESTURE_RANGE_ATTACK_KNIFE
SWEP.Primary.Delay		= 0.33
SWEP.ExecutionDelay	 	= 0.23
SWEP.BloodMultiplier 	= 2
SWEP.HitsToExecute 		= 3
SWEP.KillOnThrow 		= true
SWEP.RemoveOnHit 		= true
SWEP.ShowWorldModel 	= true
SWEP.NoRotation 		= true

SWEP.MeleeRange			= 38

function SWEP:OnKill( ply, attacker )
	if math.random(3) == 3 then
		ply.DeathSequence = { Anim = "death_04", Speed = math.Rand(1, 2) }
	end
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("weapons/knife/knife_hit"..math.random(3)..".wav", 130, math.random(94,98))
end 

