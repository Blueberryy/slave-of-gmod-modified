AddCSLuaFile()

SWEP.Base 				= "sogm_melee_base" 

SWEP.PrintName			= "Katana"

SWEP.WorldModel			= Model ( "models/weapons/w_crowbar.mdl"  ) 
//SWEP.DroppedModel		= Model ( "models/weapons/c_models/c_shogun_katana/c_shogun_katana.mdl"  ) 
SWEP.HoldType			= "knife"
SWEP.DamageType 		= DMG_SLASH
SWEP.ExecutionGesture 	= ACT_HL2MP_GESTURE_RANGE_ATTACK_KNIFE
SWEP.BloodMultiplier 	= 2
SWEP.HitsToExecute 		= 1
SWEP.AllowDismembement 	= true
SWEP.AllowSlicing 		= true
SWEP.ShowWorldModel 	= false
SWEP.Hidden 			= false
SWEP.OverrideForce 		= 100
SWEP.Primary.SwingDelay = 0.1
SWEP.Primary.Delay		= 0.5
//SWEP.OverrideAttackGesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_SLAM
SWEP.SlidingGesture 	= "swimming_melee2"
SWEP.KillPoints 		= 900
SWEP.Gametype 			= "nemesis"

SWEP.WElements = {
	//["katana"] = { type = "Model", model = "models/weapons/c_models/c_shogun_katana/c_shogun_katana.mdl", bone = "ValveBiped.Anim_Attachment_RH", rel = "", pos = Vector(-0.306, -1.069, -0.033), angle = Angle(0, 180, -100.74), size = Vector(0.827, 0.827, 0.827), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	["blade"] = { type = "Model", model = "models/props_canal/boat002b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(16.850999832153, -0.24600000679493, 0.78299999237061), angle = Angle(0, 0, -90), size = Vector(0.32100000977516, 0.003000000026077, 0.05799999833107), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_wasteland/prison_objects005", skin = 0, bodygroup = {}, fix_scale = true },
	["1"] = { type = "Model", model = "models/props_foliage/driftwood_01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.4519999027252, 1.87600004673, 1.652999997139), angle = Angle(-90, 90, 0), def_pos = Vector(3.4519999027252, 1.87600004673, 1.652999997139), def_angle = Angle(-90, 90, 0), slice_pos = Vector(3.3139998912811, 0.25, -1.4620000123978), slice_angle = Angle(90, 90, 0), size = Vector(0.019999999552965, 0.054999999701977, 0.043999999761581), color = Color(200, 200, 200, 255), surpresslightning = false, material = "models/gibs/metalgibs/metal_gibs", skin = 0, bodygroup = {}, fix_scale = true },
	["2"] = { type = "Model", model = "models/XQM/cylinderx1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(4.0089998245239, 0, 0.76399999856949), angle = Angle(0, 0, 0), size = Vector(0.045000001788139, 0.40000000596046, 0.30000001192093), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_wasteland/prison_objects005", skin = 0, bodygroup = {}, fix_scale = true },
	//["2+++"] = { type = "Model", model = "models/hunter/plates/plate05x1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(4.6100001335144, 0, 0.76399999856949), angle = Angle(90, -90, 0.5), size = Vector(0.026000000536442, 0.025000000372529, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/player/shared/gold_player", skin = 0, bodygroup = {}, fix_scale = true },
	//["2++++"] = { type = "Model", model = "models/hunter/misc/sphere1x1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "1", pos = Vector(-3.6579999923706, 0, 0.77999997138977), angle = Angle(90, -90, 90), size = Vector(0.045000001788139, 0.054999999701977, 0.019999999552965), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/player/shared/gold_player", skin = 0, bodygroup = {} }
}

function SWEP:OverrideAttackAnimation()
	if SERVER then
		if self.Owner:IsRolling() then
			self.Owner:PlayGesture( ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2 )
		else
			self.Owner:PlayGesture( ACT_HL2MP_GESTURE_RANGE_ATTACK_SLAM )
		end
	end
end

function SWEP:OnPrimaryAttack()
	self:SetNextSwing( CurTime() + self.Primary.SwingDelay )
end

function SWEP:SetNextSwing( time )
	self:SetDTFloat( 10, time )
end

function SWEP:GetNextSwing()
	return self:GetDTFloat( 10 ) or 0
end

function SWEP:MakeBloody()
	self:SetDTBool(10, true)
end

function SWEP:IsBloody()
	return self:GetDTBool(10)
end

local swing = Sound("npc/zombie/claw_miss1.wav")
function SWEP:PlaySwingSound()
	self.Owner:EmitSound(swing, 75, math.Rand(115, 125))
end 

for i=1,3 do
	util.PrecacheSound("weapons/knife/knife_hit"..i..".wav")
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("weapons/knife/knife_hit"..math.random(3)..".wav", 120, math.random(110,115))
end 

function SWEP:OnKill( ply, attacker )
	
	if !self:IsBloody() then
		self:MakeBloody()
	end
	

	if math.random(4) == 4 then
		ply.DeathSequence = { Anim = "death_04", Speed = math.Rand(1, 1.5) }
	end
end

if CLIENT then
function SWEP:OnDrawWorldModel()
	
	local owner = self.Owner
	
	if IsValid(owner) then
	
		local delta = math.Clamp( 1 - (self:GetNextSwing() - CurTime())/(self.Primary.SwingDelay),0,1 )
			
		if delta == 1 then
			delta = math.Clamp( (self:GetNextSwing() + 0.6 - CurTime())/(0.2),0,1 )
		end
		
		delta = delta ^ 2
		
		local mul = owner.IsRolling and owner:IsRolling() and 0 or 1
		
		local bone = owner:LookupBone("ValveBiped.Bip01_R_UpperArm")
		if bone then 
			owner:ManipulateBoneAngles( bone, Angle(40 * delta * mul,(40-40*delta) * mul, 0)  )
		end
		bone = owner:LookupBone("ValveBiped.Bip01_R_Clavicle")
		if bone then 
			owner:ManipulateBoneAngles( bone, Angle( ((70+10)*delta-10) * mul,40*delta * mul,-20*delta * mul)  )
		end
		bone = owner:LookupBone("ValveBiped.Bip01_R_ForeArm")
		if bone then 
			owner:ManipulateBoneAngles( bone, Angle(0,(-10 * delta+30) * mul,-20*delta * mul)  )
		end
		bone = owner:LookupBone("ValveBiped.Bip01_R_Hand")
		if bone then 
			owner:ManipulateBoneAngles( bone, Angle(((30+50)*delta-50) * mul,0,-20*delta * mul)  )
		end
		
		//stabby
		//angle = Angle(0, 180, -100.74)
		
		//normal
		//angle = Angle(0, 0, -90)
		
		if self.WElements then
			if self.WElements["1"] and self.WElements["1"].def_pos and self.WElements["1"].def_angle and self.WElements["1"].slice_pos and self.WElements["1"].slice_angle then
				
				self.WElements["1"].pos = LerpVector( delta * mul, self.WElements["1"].def_pos, self.WElements["1"].slice_pos )
				self.WElements["1"].angle = LerpAngle( delta * mul, self.WElements["1"].def_angle, self.WElements["1"].slice_angle )
				
				//self.WElements["1"].angle.p = 90 //-90 + 180*delta*mul
				//self.WElements["1"].angle.y = 180*delta*mul
				//self.WElements["1"].angle.r = -90 - 10 * delta * mul
								
				//if self:IsBloody() and self.WElements["katana"].modelEnt:GetSkin() ~= 2 then
				//	self.WElements["katana"].skin = 2
				//end
				
			end
		end
		
	end
		
end
end