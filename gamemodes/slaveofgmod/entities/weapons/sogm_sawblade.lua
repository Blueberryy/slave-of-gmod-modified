AddCSLuaFile()

SWEP.Base 				= "sogm_melee_base" 

SWEP.PrintName			= "Sawblade"

SWEP.WorldModel			= Model ( "models/props_junk/sawblade001a.mdl"  ) 
SWEP.HoldType			= "melee"
SWEP.DamageType 		= DMG_SLASH
SWEP.BloodMultiplier 	= 6
SWEP.HitsToExecute 		= 2
SWEP.ExecutionSequence 	= "cidle_melee"
SWEP.ExecutionGesture 	= ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
SWEP.Primary.Delay		= 0.6
SWEP.ExecutionDelay	 	= 0.4
SWEP.Throwable 			= 630
SWEP.KillOnThrow 		= true
SWEP.NoRotation 		= true

function SWEP:OnKill( ply, attacker )
	ply.ToDismember = HITGROUP_HEAD
	local eyes = ply:LookupBone("ValveBiped.Bip01_Head1")
	if eyes then
		local eyesPos, eyesAng = ply:GetBonePosition( eyes )
		GAMEMODE:CreateGib( eyesPos, vector_up, math.random(110,150), 1 )
	end
	if math.random(3) == 3 then
		ply.DeathSequence = { Anim = "death_04", Speed = math.Rand(1, 2) }
	end
end

SWEP.WElements = {
	["sawblade"] = { type = "Model", model = "models/props_junk/sawblade001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.534, 6.697, -2.981), angle = Angle(-35.987, 0, 0), size = Vector(0.375, 0.375, 0.375), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

function SWEP:PlayHitFleshSound()
	self:EmitSound("ambient/machines/slicer"..math.random(4)..".wav", 100, 105)
	sound.Play( "physics/body/body_medium_break"..math.random(2, 3)..".wav", self:GetPos(), 85, 115, 1 )
	//self:EmitSound("physics/body/body_medium_break"..math.random(2, 3)..".wav",75,115)
end


