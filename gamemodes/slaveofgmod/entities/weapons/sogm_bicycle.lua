AddCSLuaFile()

SWEP.Base 				= "sogm_melee_base" 

SWEP.WorldModel			= Model ( "models/props_junk/bicycle01a.mdl"  ) 
SWEP.HoldType			= "melee2"
SWEP.DamageType 		= DMG_CLUB
SWEP.BloodMultiplier 	= 3
SWEP.HitsToExecute 		= 1
SWEP.Primary.Delay		= 0.6
SWEP.ExecutionDelay	 	= 0.4
SWEP.MapOnly			= true

SWEP.WElements = {
	["bicycle"] = { type = "Model", model = "models/props_junk/bicycle01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(14.965, 1.281, 0), angle = Angle(-84.374, 0, -180), size = Vector(0.773, 0.773, 0.773), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

function SWEP:PlayHitFleshSound()
	self:EmitSound("doors/vent_open1.wav", 100, math.random(115,135))
	sound.Play( "physics/body/body_medium_break"..math.random(2, 3)..".wav", self:GetPos(), 85, 100, 1 )
	//self:EmitSound("physics/body/body_medium_break"..math.random(2, 3)..".wav")
end