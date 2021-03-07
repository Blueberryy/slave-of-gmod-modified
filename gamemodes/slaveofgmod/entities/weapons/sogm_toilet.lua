AddCSLuaFile()

SWEP.Base 				= "sogm_melee_base" 

SWEP.WorldModel			= Model ( "models/props_wasteland/prison_toilet01.mdl"  ) 
SWEP.HoldType			= "melee2"
SWEP.DamageType 		= DMG_CLUB
SWEP.BloodMultiplier 	= 3
SWEP.HitsToExecute 		= 2
SWEP.Primary.Delay		= 0.67
SWEP.ExecutionDelay	 	= 0.45
SWEP.ExecutionPoints	= 1700
SWEP.Durability = 2

function SWEP:OnKill( ply, attacker )
	if self.Durability then
		
		self.Durability = self.Durability - 1
		
		if self.Durability == 0 then
			
			local gibs = ents.Create("prop_physics")
			if IsValid( gibs ) then
				gibs:SetModel( "models/props_wasteland/prison_toilet01.mdl" )
				gibs:SetPos(self:GetPos()+attacker:GetForward() * 20)
				gibs:SetAngles( VectorRand():Angle() )
				gibs:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
				gibs:Spawn()
				//gibs:SetModelScale( 0.4 , 0 )
				local phys = gibs:GetPhysicsObject()
				if IsValid(phys) then
					phys:SetVelocityInstantaneous( attacker:GetForward() * 180 )
				end
				gibs:Fire("break","",0.1) 
			end
			
			self:Remove()
			
		end
		
	end
end

SWEP.WElements = {
	["toilet"] = { type = "Model", model = "models/props_wasteland/prison_toilet01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(12.848, 1.133, -1.602), angle = Angle(0, -0.815, 0.987), size = Vector(0.908, 0.908, 0.908), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}


function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/body/body_medium_break"..math.random(2, 3)..".wav",70)
	self:EmitSound("physics/concrete/rock_impact_hard"..math.random(6)..".wav", 150, 100)
end


if CLIENT then
function SWEP:OnDrawWorldModel()
	
	if IsValid(self.Owner) then
		local bone = self.Owner:LookupBone("ValveBiped.Bip01_R_UpperArm")
		if bone then 
			self.Owner:ManipulateBoneAngles( bone, Angle(10,-20,30)  )
		end
	end
		
end
end