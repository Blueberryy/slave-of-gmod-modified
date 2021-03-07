AddCSLuaFile()

SWEP.Base 				= "sogm_melee_base" 

SWEP.WorldModel			= Model ( "models/props_c17/grinderclamp01a.mdl"  ) 
SWEP.HoldType			= "melee"
SWEP.DamageType 		= DMG_CLUB
SWEP.BloodMultiplier 	= 1.8
SWEP.HitsToExecute 		= 9//3
SWEP.ExecutionSequence 	= "cidle_revolver"//"cidle_melee"
//SWEP.NoExecutionGesture = true
SWEP.ExecutionGesture 	= ACT_HL2MP_GESTURE_RANGE_ATTACK_REVOLVER
SWEP.Primary.Delay		= 0.6
SWEP.ExecutionDelay	 	= 0.01//0.4
SWEP.ExecutionPoints	= 2500
SWEP.NoDamage 			= true

SWEP.WElements = {
	["meatgrinder"] = { type = "Model", model = "models/props_c17/grinderclamp01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.101, -0.491, -5.307), angle = Angle(0, -180, -180), size = Vector(0.954, 0.954, 0.954), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

function SWEP:PlayHitFleshSound()

	if IsValid(self.Owner.Execution) then
		self:EmitSound("npc/manhack/grind_flesh"..math.random(3)..".wav",75,110)
	else
		self:EmitSound("physics/metal/metal_sheet_impact_hard6.wav", 100, 115)
		self:EmitSound("physics/body/body_medium_break"..math.random(2, 3)..".wav")
	end
end

function SWEP:OnExecutionHit( attacker, victim, headpos )
	local att = attacker:GetAttachment(attacker:LookupAttachment( "anim_attachment_RH" ))
	if att then
		GAMEMODE:DoBloodSpray( att.Pos + att.Ang:Up() * 7 + att.Ang:Right() * 3, att.Ang:Up() , VectorRand() * 2 , math.random(9,12), math.random( 200, 800 ) + 80 * (self.BloodMultiplier or 0), false )
		GAMEMODE:DoBloodSpray( att.Pos + att.Ang:Up() * 7 + att.Ang:Right() * 3, att.Ang:Up() , VectorRand() * 2 , math.random(6,12), math.random( 100, 600 ) + 50 * (self.BloodMultiplier or 0), true )
	end
end

