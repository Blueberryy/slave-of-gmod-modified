AddCSLuaFile()

SWEP.Base 				= "sogm_melee_base" 

SWEP.WorldModel			= Model ( "models/props_junk/propane_tank001a.mdl"  ) 
SWEP.HoldType			= "melee2"
SWEP.DamageType 		= DMG_CLUB
SWEP.BloodMultiplier 	= 3
SWEP.HitsToExecute 		= 1
SWEP.Primary.Delay		= 0.7
SWEP.ExecutionDelay	 	= 0.45


SWEP.WElements = {
	["tank"] = { type = "Model", model = "models/props_junk/propane_tank001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.941, 3.325, -6.021), angle = Angle(0.112, 2.69, -13.377), size = Vector(0.485, 0.485, 0.485), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}


function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/metal/metal_canister_impact_hard"..math.random(3)..".wav", 75, math.Rand(86, 90))
	sound.Play( "physics/body/body_medium_break"..math.random(2, 3)..".wav", self:GetPos(), 85, 100, 1 )
	//self:EmitSound("physics/body/body_medium_break"..math.random(2, 3)..".wav")
end

function SWEP:OnExecutionFinish( attacker, victim )
	
	local eyes = victim:LookupBone("ValveBiped.Bip01_Head1")
	
	if eyes then
		local eyesPos, eyesAng = victim:GetBonePosition( eyes )
		
		local e = EffectData()
			e:SetOrigin( eyesPos + vector_up * 3 )
			e:SetScale( 1 )
		util.Effect( "Explosion", e, nil, true )
		
		local e = EffectData()
			e:SetOrigin( eyesPos + vector_up * 3 )
			e:SetScale( 1 )
		util.Effect( "HelicopterMegaBomb", e, nil, true )
		
		self:Remove()
		
		util.BlastDamage( self or attacker, attacker or self, eyesPos + vector_up * 3, 250, 330 )
	
	end
	
	
	
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