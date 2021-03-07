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
SWEP.ExecutionPoints	= PTS_EXECUTION_BARE
SWEP.ExecutionSequence 	= "cidle_melee"
SWEP.ExecutionGesture 	= ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
SWEP.Hidden				= true
SWEP.NoDamage 			= true
SWEP.KnockoutDuration	= 0.2

function SWEP:SecondaryAttack()
	if CLIENT then return end
	if self.Owner:GetCharTable().OverrideSecondaryAttack then
		return self.Owner:GetCharTable():OverrideSecondaryAttack( self.Owner, self )
	end
end

function SWEP:PlayHitFleshSound()
	self:EmitSound( "npc/vort/foot_hit.wav", 130, 95 )
	sound.Play( "physics/body/body_medium_break"..math.random(2, 3)..".wav", self:GetPos(), 85, 100, 1 )	
end 

function SWEP:PlaySwingSound()
	self.Owner:EmitSound("npc/zombie/claw_miss1.wav", 45, math.Rand(75, 80))
end 

function SWEP:OverrideAttackAnimation()
	self.Owner:SetLuaAnimation(self:GetDTBool( 0 ) and "fist_right" or "fist_left")
	self:SetDTBool( 0 , !self:GetDTBool( 0 ) )
end

local NewActivityTranslate = {}
NewActivityTranslate[ACT_MP_STAND_IDLE] = ACT_HL2MP_IDLE_CROUCH
NewActivityTranslate[ACT_MP_WALK] = ACT_HL2MP_WALK_CROUCH
NewActivityTranslate[ACT_MP_RUN] = ACT_HL2MP_RUN_PANICKED
NewActivityTranslate[ACT_MP_CROUCH_IDLE] = ACT_HL2MP_IDLE_CROUCH
NewActivityTranslate[ACT_MP_CROUCHWALK] = ACT_HL2MP_RUN_PANICKED
NewActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE] = ACT_HL2MP_IDLE_SCARED
NewActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] = ACT_HL2MP_IDLE_SCARED
NewActivityTranslate[ACT_MP_RELOAD_STAND] = ACT_HL2MP_IDLE_SCARED
NewActivityTranslate[ACT_MP_RELOAD_CROUCH] = ACT_HL2MP_IDLE_SCARED
NewActivityTranslate[ACT_MP_JUMP] = ACT_HL2MP_IDLE_SCARED
NewActivityTranslate[ACT_RANGE_ATTACK1] = ACT_HL2MP_IDLE_SCARED


function SWEP:TranslateActivity(act)
	if NewActivityTranslate[act] ~= nil then
		return NewActivityTranslate[act]
	end

	return -1
end