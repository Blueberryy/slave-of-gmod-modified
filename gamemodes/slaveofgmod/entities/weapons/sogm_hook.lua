AddCSLuaFile()

SWEP.Base 				= "sogm_melee_base" 

SWEP.WorldModel			= Model ( "models/props_junk/meathook001a.mdl"  ) 
SWEP.HoldType			= "melee2"
SWEP.DamageType 		= DMG_CLUB
SWEP.BloodMultiplier 	= 2.5
SWEP.HitsToExecute 		= 1

SWEP.WElements = {
	["hook"] = { type = "Model", model = "models/props_junk/meathook001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(6.117, 2.483, -4.049), angle = Angle(-5.705, 77.845, -2.904), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

function SWEP:OnKill( ply, attacker )
	ply.ToDismember = HITGROUP_HEAD
	local eyes = ply:LookupBone("ValveBiped.Bip01_Head1")
	if eyes then
		local eyesPos, eyesAng = ply:GetBonePosition( eyes )
		GAMEMODE:CreateGib( eyesPos, attacker:GetAimVector(), math.random(110,150), 1 )
	end
	if math.random(3) == 3 then
		ply.DeathSequence = { Anim = "death_04", Speed = math.Rand(1, 2) }//death_04
	end
end

function SWEP:OnExecutionHit( attacker, victim, headpos )
	GAMEMODE:DoBloodSpray( headpos + vector_up * 3, attacker:GetAimVector():Angle():Right() * -1 + vector_up * -1, VectorRand() * 3 , math.random(29,32), math.random( 400, 700 ) + 60 * (self.BloodMultiplier or 0) )
	GAMEMODE:DoBloodSpray( headpos + vector_up * 3, attacker:GetAimVector():Angle():Right() * -1 + vector_up * -1, VectorRand() * 3 , math.random(10,15), math.random( 400, 700 ) + 160 * (self.BloodMultiplier or 0) )
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("weapons/knife/knife_hit"..math.random(3)..".wav", 130, math.random(94,98))
	sound.Play( "physics/body/body_medium_break"..math.random(2, 3)..".wav", self:GetPos(), 85, 115, 1 )
	//self:EmitSound("physics/body/body_medium_break"..math.random(2, 3)..".wav",75,115)
end

if CLIENT then
local ang_flip = Angle(-35,-20,10) 
function SWEP:OnDrawWorldModel()
	
	if IsValid(self.Owner) then
		local bone = self.Owner:LookupBone("ValveBiped.Bip01_R_UpperArm")
		if bone then 
			self.Owner:ManipulateBoneAngles( bone, ang_flip )
		end
	end
		
end
end