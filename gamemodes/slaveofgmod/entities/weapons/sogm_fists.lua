AddCSLuaFile()

SWEP.Base 				= "sogm_melee_base" 

SWEP.WorldModel			= Model ( "models/props_junk/Shoe001a.mdl"  ) 
SWEP.HoldType			= "normal"
SWEP.DamageType 		= DMG_CLUB
SWEP.BloodMultiplier 	= 1
SWEP.HitsToExecute 		= 3

SWEP.AutoSwitchTo		= true

SWEP.Primary.Delay		= 0.4
SWEP.ExecutionDelay	 	= 0.33
SWEP.NoDamage 			= true
SWEP.ExecutionPoints	= PTS_EXECUTION_BARE
SWEP.ExecutionSequence 	= "cidle_melee"
SWEP.ExecutionGesture 	= ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
SWEP.Hidden				= true
SWEP.Fists 				= true
SWEP.KillPoints 		= PTS_BARE_KILL

function SWEP:PlayHitFleshSound()
	self:EmitSound( "npc/vort/foot_hit.wav", 130, 95 )	
	self:EmitSound( "physics/body/body_medium_break"..math.random(2, 3)..".wav", 55, 100 )
end 

function SWEP:SecondaryAttack()
	if CLIENT then return end
	if self.Owner:GetCharTable().OverrideSecondaryAttack then
		return self.Owner:GetCharTable():OverrideSecondaryAttack( self.Owner, self )
	end
end

function SWEP:PlaySwingSound()
	self.Owner:EmitSound("npc/zombie/claw_miss1.wav", 45, math.Rand(75, 80))
end 

function SWEP:OverrideAttackAnimation()
	self.Owner:SetLuaAnimation(self:GetDTBool( 0 ) and "fist_right" or "fist_left")
	self:SetDTBool( 0 , !self:GetDTBool( 0 ) )
end
