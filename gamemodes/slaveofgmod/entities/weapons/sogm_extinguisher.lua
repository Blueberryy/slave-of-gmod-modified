AddCSLuaFile()

SWEP.Base 				= "sogm_melee_base" 

SWEP.WorldModel			= Model ( "models/props/cs_office/fire_extinguisher.mdl"  ) 
SWEP.HoldType			= "melee2"
SWEP.DamageType 		= DMG_CLUB
SWEP.BloodMultiplier 	= 3
SWEP.HitsToExecute 		= 1
SWEP.Primary.Delay		= 0.7
SWEP.ExecutionDelay	 	= 0.45
SWEP.ExecutionPoints	= 1700


SWEP.WElements = {
	["extinguisher"] = { type = "Model", model = "models/props/cs_office/fire_extinguisher.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.33, 4.105, 16.26), angle = Angle(-3.04, 63.916, 172.384), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}


function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/metal/metal_canister_impact_hard"..math.random(3)..".wav", 75, math.Rand(86, 90))
	sound.Play( "physics/body/body_medium_break"..math.random(2, 3)..".wav", self:GetPos(), 85, 100, 1 )
	//self:EmitSound("physics/body/body_medium_break"..math.random(2, 3)..".wav")
end

local trace = { mask = MASK_SOLID_BRUSHONLY }
function SWEP:OnExecutionFinish( attacker, victim )
	
	local eyes = victim:LookupBone("ValveBiped.Bip01_Head1")
	
	if eyes then
		local eyesPos, eyesAng = victim:GetBonePosition( eyes )
		
		local e = EffectData()
			e:SetOrigin( eyesPos + vector_up * 3 )
			e:SetScale( 1 )
		util.Effect( "Explosion", e )
		
		for i=1, math.random(3,5) do
			local vec = VectorRand()
			vec.z = 0
			
			trace.start = eyesPos + vector_up * 20 + vec * math.random(2,65)
			trace.endpos = trace.start - vector_up* 40
			
			local tr = util.TraceLine( trace )
			
			if tr.Hit then
				util.Decal("PaintSplatBlue", tr.HitPos + tr.HitNormal * 10, tr.HitPos - tr.HitNormal * 10)
			end
		
		end
	
	end
	
	self:Remove()
	
end


if CLIENT then
local ang_flip = Angle(10,-20,30)  
function SWEP:OnDrawWorldModel()
	
	if IsValid(self.Owner) then
		local bone = self.Owner:LookupBone("ValveBiped.Bip01_R_UpperArm")
		if bone then 
			self.Owner:ManipulateBoneAngles( bone, ang_flip )
		end
	end
		
end
end