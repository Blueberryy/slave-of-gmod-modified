AddCSLuaFile()

SWEP.Base 				= "sogm_melee_base" 

SWEP.WorldModel			= Model ( "models/props/cs_office/tv_plasma.mdl"  ) 
SWEP.HoldType			= "melee2"
SWEP.DamageType 		= DMG_CLUB
SWEP.BloodMultiplier 	= 3
SWEP.HitsToExecute 		= 3
SWEP.Primary.Delay		= 0.6
SWEP.ExecutionDelay	 	= 0.45
SWEP.MapOnly 			= true
SWEP.Durability = 2

function SWEP:OnKill( ply, attacker )
	if self.Durability then
		
		self.Durability = self.Durability - 1
		
		if self.Durability == 0 then
			
			local gibs = ents.Create("prop_physics")
			if IsValid( gibs ) then
				gibs:SetModel( "models/props/cs_office/tv_plasma.mdl" )
				gibs:SetPos(self:GetPos()+attacker:GetForward() * 20)
				gibs:SetAngles( VectorRand():Angle() )
				gibs:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
				gibs:Spawn()
				gibs:SetModelScale( 0.4 , 0 )
				local phys = gibs:GetPhysicsObject()
				if IsValid(phys) then
					phys:SetVelocityInstantaneous( attacker:GetForward() * 300 )
				end
				gibs:Fire("break","",0.1) 
			end
			
			self:Remove()
			
		end
		
	end
end

SWEP.WElements = {
	["tv_plasma"] = { type = "Model", model = "models/props/cs_office/tv_plasma.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(0.409, -0.978, -11.289), angle = Angle(2.532, -83.916, -98.899), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}


function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/metal/metal_box_break"..math.random(2)..".wav", 75, math.Rand(95, 105))
	sound.Play( "physics/body/body_medium_break"..math.random(2, 3)..".wav", self:GetPos(), 85, 100, 1 )
	//self:EmitSound("physics/body/body_medium_break"..math.random(2, 3)..".wav")
end


if CLIENT then
local ang_flip = Angle(10,-20,30)
function SWEP:OnDrawWorldModel()
	
	if IsValid(self.Owner) then
		local bone = self.Owner:LookupBone("ValveBiped.Bip01_R_UpperArm")
		if bone then 
			self.Owner:ManipulateBoneAngles( bone, ang_flip  )
		end
	end
		
end
end