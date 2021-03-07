AddCSLuaFile()

SWEP.Base 				= "sogm_melee_base" 

SWEP.WorldModel			= Model ( "models/props_junk/cinderblock01a.mdl"  ) 
SWEP.HoldType			= "melee"
SWEP.DamageType 		= DMG_CLUB
SWEP.BloodMultiplier 	= 3
SWEP.HitsToExecute 		= 2
SWEP.ExecutionSequence 	= "cidle_melee"
SWEP.ExecutionGesture 	= ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
SWEP.Primary.Delay		= 0.6
SWEP.ExecutionDelay	 	= 0.4
SWEP.Throwable 			= 730
SWEP.KillOnThrow 		= true

SWEP.WElements = {
	["cinderblock"] = { type = "Model", model = "models/props_junk/cinderblock01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.265, 4.474, -3.3), angle = Angle(0, -124.635, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

function SWEP:OnKill( ply, attacker )
	ply.ToDismember = HITGROUP_HEAD
	if math.random(3) == 3 then
		ply.DeathSequence = { Anim = "death_04", Speed = math.Rand(1, 2) }
	end
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/concrete/rock_impact_hard"..math.random(6)..".wav", 100, 95)
	sound.Play( "physics/body/body_medium_break"..math.random(2, 3)..".wav", self:GetPos(), 85, 100, 1 )
	//self:EmitSound("physics/body/body_medium_break"..math.random(2, 3)..".wav")
end
