AddCSLuaFile()

SWEP.Base 				= "sogm_melee_base" 

SWEP.WorldModel			= Model ( "models/props_junk/wood_crate001a.mdl"  ) 
SWEP.HoldType 			= "physgun"
SWEP.DamageType 		= DMG_CLUB
SWEP.OverrideAttackGesture = ACT_GMOD_GESTURE_MELEE_SHOVE_1HAND
SWEP.BloodMultiplier 	= 1
SWEP.HitsToExecute 		= 1
SWEP.Primary.Delay		= 0.57
SWEP.ExecutionDelay	 	= 0.43
SWEP.ShowWorldModel		= false
SWEP.Gametype 			= "singleplayer"
SWEP.Durability 		= 6
SWEP.Hidden 			= true

function SWEP:CheckDurability()
	if self.Durability then
		
		self.Durability = self.Durability - 1
		
		if self.Durability == 0 then
			
			local gibs = ents.Create("prop_physics")
			if IsValid( gibs ) then
				gibs:SetModel( "models/props_junk/wood_crate001a.mdl" )
				gibs:SetPos(self:GetPos()+self.Owner:GetForward() * 20)
				gibs:SetAngles( VectorRand():Angle() )
				gibs:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
				gibs:Spawn()
				//gibs:SetModelScale( 0.4 , 0 )
				local phys = gibs:GetPhysicsObject()
				if IsValid(phys) then
					phys:SetVelocityInstantaneous( self.Owner:GetForward() * 300 )
				end
				gibs:Fire("break","",0.1) 
			end
			
			self:Remove()
			
		end
		
	end
end

//return true to allow damage, false to not
function SWEP:OnBulletHit( pl, hitpos, hitnormal, dir ) 
	
	if dir:Dot(pl:GetAimVector()) > -0.5 then return true end
	
	local e = EffectData()
		e:SetOrigin( hitpos )
		e:SetNormal( hitnormal )
		e:SetScale( 2 )
	util.Effect( "StunstickImpact", e, nil, true )
	
	pl:EmitSound( "physics/metal/metal_box_impact_bullet"..math.random(3)..".wav" )
	
	self:CheckDurability( )

	return false
end

function SWEP:OnKill( ply, attacker )
	self:CheckDurability( )
end

SWEP.WElements = {
	["box"] = { type = "Model", model = "models/props_junk/wood_crate001a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(11.449, -0.672, -7.086), angle = Angle(-28.043, -45.119, 11.888), size = Vector(0.423, 0.423, 0.423), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}


function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/wood/wood_plank_break"..math.random(4)..".wav", 75, math.Rand(95, 105))
	sound.Play( "physics/body/body_medium_break"..math.random(2, 3)..".wav", self:GetPos(), 85, 100, 1 )
end