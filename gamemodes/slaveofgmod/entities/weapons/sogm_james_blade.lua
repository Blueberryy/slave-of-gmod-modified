AddCSLuaFile()

SWEP.Base 				= "sogm_melee_base" 

SWEP.PrintName			= "James Blade"

SWEP.WorldModel			= Model ( "models/props_wasteland/tram_lever01.mdl"  ) 
SWEP.HoldType			= "melee2"
SWEP.DamageType 		= DMG_SLASH
//SWEP.OverrideAttackGesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2
SWEP.BloodMultiplier 	= 5
SWEP.HitsToExecute 		= 1
SWEP.Primary.Delay		= 0.6
SWEP.AllowDismembement 	= true

SWEP.Hidden = true

SWEP.WElements = {
	["melee2"] = { type = "Model", model = "models/props_c17/trappropeller_blade.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "melee1", pos = Vector(0.423, -1.043, -6.441), angle = Angle(-17.338, 0, 90), size = Vector(0.284, 0.284, 0.284), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["melee1"] = { type = "Model", model = "models/props_wasteland/tram_lever01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.814, 1.511, -6.317), angle = Angle(9.267, -4.773, -3.779), size = Vector(0.629, 0.629, 0.629), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
}

function SWEP:PlayHitFleshSound()
	self:EmitSound("weapons/knife/knife_hit"..math.random(3)..".wav", 130, math.random(94,98) )
end 

function SWEP:SecondaryAttack()
	if IsValid(self.Owner.Execution) then return end
	if CLIENT then return end
	
	if !self:IsBlockMode() then
		self:SetBlockMode( true )
	end
	
end

function SWEP:CanPrimaryAttack()
	if self.Owner:IsNextBot() then
		return true
	end
	if self:IsBlockMode() then 
		return false
	end
	
	return not self:IsSwinging()
end

function SWEP:OnThink()
	
	if self:IsBlockMode() and not self.Owner:KeyDown( IN_ATTACK2 ) then
		self:SetBlockMode( false )
	end
	
end

function SWEP:SetBlockMode( bl )
	self:SetDTBool( 0, bl )
end

function SWEP:IsBlockMode()
	return self:GetDTBool( 0 )
end

function SWEP:OnMeleeHit( pl, hitpos, hitnormal, dir, attacker ) 
		
	if !self:IsBlockMode() then
		return true
	else
		if dir:Dot(pl:GetAimVector()) > -0.5 then return true end
	end
	
	if SERVER then
		local e = EffectData()
			e:SetOrigin( hitpos )
			e:SetNormal( hitnormal )
			e:SetScale( 2 )
		util.Effect( "StunstickImpact", e, nil, true )
		
		pl:EmitSound( "physics/metal/metal_box_impact_bullet"..math.random(3)..".wav" )
		
		pl:SetGroundEntity( NULL )
		pl:SetVelocity( dir * 900 )
		
	end

	return false
end

if CLIENT then

SWEP.HoldTypeDelta = 1
local ang_flip = Angle(-10,-20,10)
function SWEP:OnDrawWorldModel()
	
	if IsValid(self.Owner) then
	
		for i=1,3 do
			self.Owner:SetIK( true )
		end
	
		local block = self:IsBlockMode()
		
		
		if self.HoldTypeDelta ~= 0 or self.HoldTypeDelta ~= 1 then
			self.HoldTypeDelta = math.Approach( self.HoldTypeDelta, block and 1 or 0, FrameTime() * ( 3 + ( 4 * (self.HoldTypeDelta ) ) ^ 2 ))
		end
		
		local bone = self.Owner:LookupBone("ValveBiped.Bip01_R_UpperArm")
		if bone then 
			self.Owner:ManipulateBoneAngles( bone, Angle(-10,0,0) + Angle(40,-50,-10) * self.HoldTypeDelta )
			//self.Owner:ManipulateBoneScale( bone, Vector( 0.001, 0.001, 0.001 ) )
		end
		
		bone = self.Owner:LookupBone("ValveBiped.Bip01_R_Forearm")
		if bone then 
			self.Owner:ManipulateBoneAngles( bone, Angle( -30, 40, -10 ) * self.HoldTypeDelta  )
		end
		
		bone = self.Owner:LookupBone("ValveBiped.Bip01_R_Hand")
		if bone then 
			self.Owner:ManipulateBoneAngles( bone, Angle( 0, 10, -20 ) * self.HoldTypeDelta  )
		end	
		
		
	end
		
end
end