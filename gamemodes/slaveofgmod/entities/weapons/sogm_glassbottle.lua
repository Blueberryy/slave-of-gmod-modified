AddCSLuaFile()

SWEP.Base 				= "sogm_melee_base" 

SWEP.WorldModel			= Model ( "models/props_junk/garbage_glassbottle003a.mdl"  ) 
SWEP.HoldType			= "melee"
SWEP.DamageType 		= DMG_CLUB
SWEP.BloodMultiplier 	= 1
SWEP.HitsToExecute 		= 1
SWEP.ExecutionSequence 	= "cidle_melee"
SWEP.ExecutionGesture 	= ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
SWEP.Primary.Delay		= 0.6
SWEP.ExecutionDelay	 	= 0.22

SWEP.NoDamage 			= true

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/body/body_medium_impact_hard"..math.random(6)..".wav")
	sound.Play( "physics/body/body_medium_break"..math.random(2, 3)..".wav", self:GetPos(), 85, 100, 1 )
	//self:EmitSound("physics/body/body_medium_break"..math.random(2, 3)..".wav",75,115)
end

SWEP.WElements = {
	["1"] = { type = "Model", model = "models/props_junk/garbage_glassbottle003a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.611, 1.054, -4.46), angle = Angle(8.76, 2.733, 4.517), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

for i=1, 4 do
	util.PrecacheSound( "physics/glass/glass_impact_bullet"..i..".wav" )
end

function SWEP:OnExecutionFinish( attacker, victim )
	attacker:EmitSound( "physics/glass/glass_impact_bullet"..math.random(4)..".wav", 45, math.random(100,115) )
	
	self:Remove()
	
	if attacker and attacker:Alive() then
		attacker:Give( "sogm_glassbottle_broken" )
		attacker:SelectWeapon( "sogm_glassbottle_broken" )
	end
end

function SWEP:OnKnockoutHit( attacker, victim )
	attacker:EmitSound( "physics/glass/glass_impact_bullet"..math.random(4)..".wav", 45, math.random(100,115) )
	
	self:Remove()
	
	if attacker and attacker:Alive() then
		attacker:Give( "sogm_glassbottle_broken" )
		attacker:SelectWeapon( "sogm_glassbottle_broken" )
	end
	
	
end

local NEW = {}

NEW.Base 				= "sogm_melee_base" 
NEW.WorldModel			= Model ( "models/props_junk/garbage_glassbottle003a_chunk01.mdl"  ) 
NEW.HoldType			= "melee"
NEW.DamageType 			= DMG_CLUB
NEW.BloodMultiplier 	= 1.8
NEW.HitsToExecute 		= 1
NEW.ExecutionSequence 	= "cidle_melee"
NEW.ExecutionGesture 	= ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
NEW.Primary 			= {}
NEW.Primary.Delay		= 0.6
NEW.ExecutionDelay	 	= 0.22

NEW.WElements = {
	["1"] = { type = "Model", model = "models/props_junk/garbage_glassbottle003a_chunk01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.75, 1.68, -5.057), angle = Angle(8.704, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

function NEW:PlayHitFleshSound()
	self:EmitSound("weapons/knife/knife_hit"..math.random(3)..".wav", 130, math.random(94,98))
	self:EmitSound("physics/body/body_medium_break"..math.random(2, 3)..".wav",75,115)
end

function NEW:OnKill( ply, attacker )
	ply:EmitSound( "physics/glass/glass_impact_bullet"..math.random(4)..".wav", 75, math.random(100,115) )
	self:Remove()
end





weapons.Register( NEW, "sogm_glassbottle_broken", false )

NEW = nil

