AddCSLuaFile()

SWEP.Base 				= "sogm_melee_base" 

SWEP.PrintName			= "Axe"

SWEP.WorldModel			= Model ( "models/props/CS_militia/axe.mdl"  ) 
SWEP.HoldType			= "melee2"
SWEP.DamageType 		= DMG_SLASH
SWEP.BloodMultiplier 	= 5
SWEP.HitsToExecute 		= 1
SWEP.Primary.Delay		= 0.6
SWEP.AllowDismembement 	= true
//SWEP.Team				= GAMEMODE:GetGametype() == "axecution" and 6 or nil

SWEP.WElements = {
	["axe"] = { type = "Model", model = "models/props/CS_militia/axe.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.272, 1.741, -6.066), angle = Angle(0, 0, 83.808), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }, 
}

function SWEP:PlayHitFleshSound()
	//self:EmitSound("weapons/knife/knife_hit"..math.random(3)..".wav", 130, math.random(94,98), 1, CHAN_WEAPON )
	self:EmitSound("weapons/knife/knife_hit"..math.random(3)..".wav", 130, math.random(94,98) )
end 

function SWEP:OnExecution( vic, attacker )
	
	local eyes = vic:LookupBone("ValveBiped.Bip01_Head1")
	if eyes then
		local eyesPos, eyesAng = vic:GetBonePosition( eyes )
		GAMEMODE:CreateGib( eyesPos, attacker:GetAimVector(), math.random(140,250), 1 )
	end
		
end

function SWEP:OnKill( ply, attacker )
	if math.random(4) == 4 then
		ply.DeathSequence = { Anim = "death_04", Speed = math.Rand(1, 1.5) }
	end
end

if CLIENT then
local ang_flip = Angle(-50,-20,10)
function SWEP:OnDrawWorldModel()
	
	if IsValid(self.Owner) then
		local bone = self.Owner:LookupBone("ValveBiped.Bip01_R_UpperArm")
		if bone then 
			self.Owner:ManipulateBoneAngles( bone, ang_flip  )
		end
	end
		
end
end