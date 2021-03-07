AddCSLuaFile()

SWEP.Base 				= "sogm_melee_base" 

SWEP.WorldModel			= Model ( "models/props_junk/Shoe001a.mdl"  ) 
SWEP.HoldType			= "normal"//"fist"
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
SWEP.KillPoints 		= PTS_BARE_KILL
SWEP.OverrideForce 		= 2900

function SWEP:SecondaryAttack()
	if CLIENT then return end
	if self.Owner:GetCharTable().OverrideSecondaryAttack then
		return self.Owner:GetCharTable():OverrideSecondaryAttack( self.Owner, self )
	end
end

for i=1,4 do 
	util.PrecacheSound("physics/concrete/boulder_impact_hard"..i..".wav")
end

function SWEP:PlayHitFleshSound()
	//self:EmitSound( "physics/concrete/boulder_impact_hard"..math.random(4)..".wav", 70, math.random(85,110) )	
	self:EmitSound( "physics/body/body_medium_break"..math.random(2, 3)..".wav", 85, 100 )
end 

function SWEP:PlaySwingSound()
	self.Owner:EmitSound("npc/zombie/claw_miss1.wav", 45, math.Rand(75, 80))
end 

function SWEP:OnKill( ply, attacker )
	ply.ToDismember = true
end

local NewActivityTranslate = {}
NewActivityTranslate[ACT_MP_STAND_IDLE] = ACT_HL2MP_IDLE_ANGRY
NewActivityTranslate[ACT_MP_WALK] = ACT_HL2MP_WALK
NewActivityTranslate[ACT_MP_RUN] = ACT_HL2MP_WALK

function SWEP:TranslateActivity(act)
	
	if not self.CheckActivity then
		if self.Owner then
			NewActivityTranslate[ACT_MP_STAND_IDLE] = self.Owner:GetSequenceActivity( self.Owner:LookupSequence( "pose_standing_02" ) ) 
		end
		self.CheckActivity = true
	end
	
	if NewActivityTranslate[act] ~= nil then
		return NewActivityTranslate[act]
	end

	return -1
end