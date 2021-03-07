AddCSLuaFile()

SWEP.Base 				= "sogm_melee_base" 

SWEP.WorldModel			= Model ( "models/props_c17/metalpot002a.mdl"  ) 
SWEP.HoldType			= "melee"
SWEP.DamageType 		= DMG_CLUB
SWEP.BloodMultiplier 	= 1.8
SWEP.HitsToExecute 		= 3
SWEP.ExecutionSequence 	= "cidle_melee"
SWEP.ExecutionGesture 	= ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
SWEP.Primary.Delay		= 0.6
SWEP.ExecutionDelay	 	= 0.4


function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/metal/metal_sheet_impact_hard6.wav", 100, 115)
	sound.Play( "physics/body/body_medium_break"..math.random(2, 3)..".wav", self:GetPos(), 85, 100, 1 )
	//self:EmitSound("physics/body/body_medium_break"..math.random(2, 3)..".wav")
end

if SWEP.Base == "sogm_melee_base"  then
	SWEP.WElements = {
		["metalpot"] = { type = "Model", model = "models/props_c17/metalpot002a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.546, 1.222, -9.66), angle = Angle(-81.766, -0.196, 169.231), size = Vector(1.059, 1.059, 1.059), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	}
end
