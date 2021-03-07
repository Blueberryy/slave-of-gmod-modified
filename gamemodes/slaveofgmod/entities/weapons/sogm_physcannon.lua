AddCSLuaFile()

SWEP.Base 				= "sogm_melee_base"

SWEP.PrintName			= "Physcannon" 

SWEP.WorldModel			= Model ( "models/weapons/w_physics.mdl"  ) 
SWEP.HoldType			= "melee2"
SWEP.DamageType 		= DMG_CLUB
SWEP.BloodMultiplier 	= 1
SWEP.HitsToExecute 		= 2
SWEP.Primary.Delay		= 0.55
SWEP.ExecutionDelay	 	= 0.34


function SWEP:PlayHitFleshSound()
	self:EmitSound("doors/vent_open1.wav", 100, math.random(135,145),1, CHAN_WEAPON)
	sound.Play( "physics/body/body_medium_break"..math.random(2, 3)..".wav", self:GetPos(), 85, 100, 1 )
	//self:EmitSound("physics/body/body_medium_break"..math.random(2, 3)..".wav")
end


SWEP.WElements = {
	["physcannon"] = { type = "Model", model = "models/weapons/w_physics.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(1.514, 1.425, 0), angle = Angle(-76.96, 0, 180), size = Vector(0.915, 0.915, 0.915), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}