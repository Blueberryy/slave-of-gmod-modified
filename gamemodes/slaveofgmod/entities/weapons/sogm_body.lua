AddCSLuaFile()

SWEP.Base 				= "sogm_melee_base" 

SWEP.PrintName			= "Body"

SWEP.WorldModel			= Model ( "models/player/kleiner.mdl"  ) 
SWEP.HoldType			= "melee2"
SWEP.DamageType 		= DMG_SLASH
SWEP.BloodMultiplier 	= 5
SWEP.HitsToExecute 		= 1
SWEP.Primary.Delay		= 0.6
SWEP.ShowWorldModel		= false
SWEP.MapOnly			= true

SWEP.WElements = {
	["body"] = { type = "Model", model = "models/player/kleiner.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", seq = "pose_standing_01", pos = Vector(5.942, -0.751, 12.18), angle = Angle(-0.802, -96.821, -180), size = Vector(0.681, 0.681, 0.681), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

function SWEP:PlayHitFleshSound()
	self:EmitSound( "npc/vort/foot_hit.wav", 130, 95 )
	sound.Play( "physics/body/body_medium_break"..math.random(2, 3)..".wav", self:GetPos(), 85, 100, 1 )	
end 

function SWEP:PlaySwingSound()
	self.Owner:EmitSound("npc/zombie/claw_miss1.wav", 45, math.Rand(75, 80))
end 
