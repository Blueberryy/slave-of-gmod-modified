AddCSLuaFile()

SWEP.Base 				= "sogm_melee_base" 

SWEP.PrintName			= "Lead Pipe"

SWEP.WorldModel			= Model ( "models/props_canal/mattpipe.mdl"  ) 
SWEP.HoldType			= "melee2"
SWEP.DamageType 		= DMG_CLUB
SWEP.BloodMultiplier 	= 1.5
SWEP.HitsToExecute 		= 1
SWEP.Primary.Delay		= 0.6
SWEP.ExecutionDelay	 	= 0.3
SWEP.ShowWorldModel 	= true


function SWEP:PlayHitFleshSound()
	self:EmitSound("doors/vent_open1.wav", 100, math.random(135,155))
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