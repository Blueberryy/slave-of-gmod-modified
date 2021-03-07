AddCSLuaFile()

SWEP.Base 				= "sogm_melee_base" 

SWEP.WorldModel			= Model ( "models/props_junk/Shoe001a.mdl" ) 
SWEP.DroppedModel		= Model ( "models/props_lab/cleaver.mdl"  ) 
SWEP.HoldType			= "melee"
SWEP.DamageType 		= DMG_SLASH
SWEP.ExecutionSequence 	= "cidle_melee"
SWEP.ExecutionGesture 	= ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
SWEP.Primary.Delay		= 0.53
SWEP.ExecutionDelay	 	= 0.43
SWEP.BloodMultiplier 	= 2
SWEP.HitsToExecute 		= 1
SWEP.KillOnThrow 		= true
//SWEP.NoRotation 		= true

local RandomDism = {
	HITGROUP_HEAD,
	HITGROUP_LEFTARM,
	HITGROUP_RIGHTARM,
	HITGROUP_RIGHTLEG,
	HITGROUP_LEFTLEG,
}

function SWEP:OnKill( ply, attacker )
	
	if !IsValid( ply.Knockdown ) then
		ply.ToDismember = RandomDism[math.random(#RandomDism)]
	end
	if math.random(3) == 3 and !IsValid( ply.Knockdown ) then
		ply.DeathSequence = { Anim = "death_0"..math.random(4), Speed = math.Rand(1, 2) }
	end
	
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("weapons/knife/knife_hit"..math.random(3)..".wav", 130, math.random(74,98))
end 

SWEP.WElements = {
	["cleaver"] = { type = "Model", model = "models/props_lab/cleaver.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.219, 0.832, 0), angle = Angle(96.746, 4.223, -26.458), size = Vector(0.787, 0.787, 0.787), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}


if CLIENT then
local ang_flip = Angle(10,-30,-40)
function SWEP:OnDrawWorldModel()
	
	if IsValid(self.Owner) then
		local bone = self.Owner:LookupBone("ValveBiped.Bip01_R_UpperArm")
		if bone then 
			self.Owner:ManipulateBoneAngles( bone, ang_flip  )
		end
	end
		
end
end