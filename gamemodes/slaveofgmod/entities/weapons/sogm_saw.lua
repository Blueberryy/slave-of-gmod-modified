AddCSLuaFile()

SWEP.Base 				= "sogm_melee_base" 

SWEP.WorldModel			= Model ( "models/props/cs_militia/circularsaw01.mdl"  ) 
SWEP.HoldType			= "melee2"
SWEP.DamageType 		= DMG_SLASH
SWEP.BloodMultiplier 	= 2
SWEP.HitsToExecute 		= 10
SWEP.ExecutionSequence 	= "cidle_fist"
SWEP.ExecutionGesture 	= ACT_HL2MP_GESTURE_RANGE_ATTACK_PISTOL
//SWEP.NoExecutionGesture = true
//SWEP.ExecutionPlaybackRate = 4
SWEP.Primary.Delay		= 0.6
SWEP.ExecutionDelay	 	= 0.005
SWEP.NoDamage 			= true
SWEP.ExecutionPoints	= 2500


SWEP.WElements = {
	["saw"] = { type = "Model", model = "models/props/cs_militia/circularsaw01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(13.14, 1.851, -0.749), angle = Angle(165.091, -117.3, 61.03), size = Vector(0.85, 0.85, 0.85), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}


function SWEP:PlayHitFleshSound()
	self:EmitSound("npc/manhack/grind_flesh"..math.random(3)..".wav",75,120)
end

function SWEP:OnExecutionHit( attacker, victim, headpos )
	
	local vec = VectorRand() * math.random(-1, 1)
	vec.z = 0

	GAMEMODE:DoBloodSpray( headpos + vector_up * 6, attacker:GetAimVector():Angle():Right(), VectorRand() * 5 , math.random(2,6), math.random( 500, 600 ) + 80 * (self.BloodMultiplier or 0) )
	GAMEMODE:DoBloodSpray( headpos + vector_up * 6, attacker:GetAimVector():Angle():Right(), VectorRand() * 5 , math.random(2,6), math.random( 50, 400 ) + 80 * (self.BloodMultiplier or 0) )

end

function SWEP:OnExecution( vic, attacker )
	
	local eyes = vic:LookupBone("ValveBiped.Bip01_Head1")
	if eyes then
		local eyesPos, eyesAng = vic:GetBonePosition( eyes )
		GAMEMODE:CreateGib( eyesPos, attacker:GetAimVector():Angle():Right(), math.random(110,200), 1 )
	end
		
end




