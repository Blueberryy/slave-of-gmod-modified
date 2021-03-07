AddCSLuaFile()

SWEP.Base 				= "sogm_melee_base" 

SWEP.WorldModel			= Model ( "models/props_junk/Shoe001a.mdl"  ) 
SWEP.HoldType			= "normal"
SWEP.DamageType 		= DMG_SLASH
SWEP.BloodMultiplier 	= 6
SWEP.HitsToExecute 		= 3

SWEP.AutoSwitchTo		= true

SWEP.Primary.Delay		= 0.4
SWEP.ExecutionDelay	 	= 0.33
SWEP.ExecutionPoints	= PTS_EXECUTION_BARE
SWEP.ExecutionSequence 	= "cidle_melee"
SWEP.ExecutionGesture 	= ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
SWEP.Hidden				= true
SWEP.KillPoints 		= PTS_BARE_KILL
SWEP.MeleeRange			= 35
//SWEP.OverrideForce 		= 1800

function SWEP:SecondaryAttack()
	if CLIENT then return end
	if self.Owner:GetCharTable().OverrideSecondaryAttack then
		return self.Owner:GetCharTable():OverrideSecondaryAttack( self.Owner, self )
	end
end

for i=1, 3 do
	util.PrecacheSound("player/damage"..i..".wav")
end

function SWEP:PlayHitFleshSound()
	self:EmitSound( "player/damage"..math.random(3)..".wav", 130, 95 )	
	//self:EmitSound( "physics/body/body_medium_break"..math.random(2, 3)..".wav", 45, 100 )
end 

function SWEP:PlaySwingSound()
	self.Owner:EmitSound("npc/zombie/claw_miss1.wav", 45, math.Rand(75, 80))
end

function SWEP:OnKill( ply, attacker )
	ply.ToDismember = true
end

//a bit hacky way of forcing animations
local NewActivityTranslate = {}
NewActivityTranslate[ACT_MP_STAND_IDLE] = ACT_HL2MP_WALK_ZOMBIE_06
NewActivityTranslate[ACT_MP_WALK] = ACT_HL2MP_WALK_ZOMBIE_06
NewActivityTranslate[ACT_MP_RUN] = ACT_HL2MP_RUN_ZOMBIE_FAST
NewActivityTranslate[ACT_MP_CROUCH_IDLE] = ACT_HL2MP_WALK_ZOMBIE_06
NewActivityTranslate[ACT_MP_CROUCHWALK] = ACT_HL2MP_WALK_ZOMBIE_06
NewActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE] = ACT_GMOD_GESTURE_RANGE_ZOMBIE_SPECIAL
NewActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] = ACT_GMOD_GESTURE_RANGE_ZOMBIE_SPECIAL
NewActivityTranslate[ACT_MP_RELOAD_STAND] = ACT_HL2MP_WALK_ZOMBIE_06
NewActivityTranslate[ACT_MP_RELOAD_CROUCH] = ACT_HL2MP_WALK_ZOMBIE_06
NewActivityTranslate[ACT_MP_JUMP] = ACT_ZOMBIE_LEAPING
NewActivityTranslate[ACT_RANGE_ATTACK1] = ACT_ZOMBIE_LEAPING


function SWEP:TranslateActivity(act)
	if NewActivityTranslate[act] ~= nil then
		return NewActivityTranslate[act]
	end

	return -1
end