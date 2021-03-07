AddCSLuaFile()

SWEP.Base 				= "sogm_melee_base" 

SWEP.PrintName			= "Shovel"

SWEP.WorldModel			= Model ( "models/props_junk/shovel01a.mdl"  ) 
SWEP.HoldType			= "melee2"
SWEP.DamageType 		= DMG_CLUB
SWEP.BloodMultiplier 	= 2
SWEP.HitsToExecute 		= 1


SWEP.WElements = {
	["shovel"] = { type = "Model", model = "models/props_junk/shovel01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.104, -0.025, 0), angle = Angle(0, -113.011, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}


function SWEP:OnExecutionHit( attacker, victim, headpos )
	
	//local vec = VectorRand() * math.random(-1, 1)
	//vec.z = -0.5

	GAMEMODE:DoBloodSpray( headpos + vector_up * 3, attacker:GetAimVector():Angle():Right() * -1 + vector_up * -1, VectorRand() * 3 , math.random(29,32), math.random( 400, 700 ) + 60 * (self.BloodMultiplier or 0) )
	GAMEMODE:DoBloodSpray( headpos + vector_up * 3, attacker:GetAimVector():Angle():Right() * -1 + vector_up * -1, VectorRand() * 3 , math.random(10,15), math.random( 400, 700 ) + 160 * (self.BloodMultiplier or 0) )
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("doors/vent_open1.wav", 100, math.random(95,115))
	sound.Play( "physics/body/body_medium_break"..math.random(2, 3)..".wav", self:GetPos(), 85, 100, 1 )
	//self:EmitSound("physics/body/body_medium_break"..math.random(2, 3)..".wav")
end

if CLIENT then
local ang_flip = Angle(-50,-20,10)
function SWEP:OnDrawWorldModel()
	
	if IsValid(self.Owner) then
		local bone = self.Owner:LookupBone("ValveBiped.Bip01_R_UpperArm")
		if bone then 
			self.Owner:ManipulateBoneAngles( bone, ang_flip )
		end
	end
		
end
end