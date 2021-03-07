AddCSLuaFile()

SWEP.Base 				= "sogm_melee_base" 

SWEP.PrintName			= "GunBlade"

SWEP.WorldModel			= Model ( "models/weapons/w_shotgun.mdl"  ) 
SWEP.Secondary.Sound 	= Sound("Weapon_Shotgun.Single")
SWEP.HoldType			= "smg"
SWEP.DamageType 		= DMG_SLASH
SWEP.OverrideAttackGesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2
SWEP.BloodMultiplier 	= 5
SWEP.HitsToExecute 		= 1
SWEP.Primary.Delay		= 0.6
SWEP.AllowDismembement 	= true

SWEP.Primary.ClipSize		= 6
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize
SWEP.Secondary.Damage		= 50
SWEP.Secondary.Numshots		= 7
SWEP.Secondary.Automatic	= false
SWEP.Primary.Ammo			= "buckshot"
SWEP.Secondary.Delay		= 0.6
SWEP.Secondary.Spread 		= 0.22
SWEP.Hidden = true


SWEP.WElements = {
	//["melee2"] = { type = "Model", model = "models/props_c17/trappropeller_blade.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "melee1", pos = Vector(0.423, -1.043, -6.441), angle = Angle(-17.338, 0, 90), size = Vector(0.284, 0.284, 0.284), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	//["melee1"] = { type = "Model", model = "models/props_wasteland/tram_lever01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.814, 1.511, -6.317), angle = Angle(9.267, -4.773, -3.779), size = Vector(0.629, 0.629, 0.629), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["shotgun"] = { type = "Model", model = "models/weapons/w_shotgun.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "shotgun_base", pos = Vector(11.581, 1.758, 0), angle = Angle(-9.009, 175.222, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["shotgun_base"] = { type = "Model", model = "models/props_junk/PopCan01a.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(4.639, 1.187, 1.807), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 1), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	//["shotgun_back"] = { type = "Model", model = "models/weapons/w_shotgun.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(-4.758, 2.141, -0.913), angle = Angle(27.732, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
	["shotgun_left"] = { type = "Model", model = "models/weapons/w_shotgun.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(3.23, 2.138, 7.089), angle = Angle(100.503, -91.193, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["shotgun_right"] = { type = "Model", model = "models/weapons/w_shotgun.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.23, 0.856, -4.571), angle = Angle(-78.652, 26.37, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

function SWEP:OnKill( ply, attacker, dmginfo )
	if dmginfo and dmginfo:GetDamageType() == DMG_BULLET then
		ply.ToDismember = true
		if math.random(6) == 6 then
			ply.DeathSequence = { Anim = "death_04", Speed = math.Rand(1, 1.5) }
		end
	end
end

function SWEP:PlayHitFleshSound()
	//self:EmitSound("weapons/knife/knife_hit"..math.random(3)..".wav", 130, math.random(94,98) )
	self:EmitSound("physics/body/body_medium_impact_hard"..math.random(6)..".wav")
	sound.Play( "physics/body/body_medium_break"..math.random(2, 3)..".wav", self:GetPos(), 85, 100, 1 )
end 

//primary is secondary and vica versa. yeah this is confusing...

function SWEP:PrimaryAttack()
	if IsValid(self.Owner.Execution) then return false end
	if not self:CanPrimaryAttack() then return end	
	
	local owner = self.Owner
	
	if self:IsMeleeMode() then
	
		self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay + 0.2)
	
		if owner:GetCharTable() and owner:GetCharTable().MeleeGesture then
			owner:PlayGesture( owner:GetCharTable().MeleeGesture )
		else
			if self.OverrideAttackGesture then
				if SERVER then
					owner:PlayGesture( self.OverrideAttackGesture )
				end
			elseif self.OverrideAttackAnimation then
				self:OverrideAttackAnimation()
			else
				if owner:IsPlayer() then
					owner:SetAnimation(PLAYER_ATTACK1)
				else
					owner:RestartGesture( owner:GetCharTable() and owner:GetCharTable().MeleeGesture or self.ExecutionGesture  )//ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2
				end
			end
		end
		
		self.FirstHit = true
		

		self:SetFirstHitSound( true )
		self:SetFirstSwingSound( true )
		
		if self.Owner:IsNextBot() then
			table.Empty( self.FilterTable )
		end
		
		if self.NoDamage then
			self:Knockout( self.KnockdownDamage )
		else
			self:Slash()
		end
		
		if self:IsNextBot() then
		
		else
			self:StartSwinging()
		end

	else
		
		self.Weapon:SetNextPrimaryFire(CurTime() + self.Secondary.Delay)
		
		self.Owner:DoCustomAnimEvent( PLAYERANIMEVENT_ATTACK_SECONDARY, 111 )
		
		self:EmitFireSound()
		self:TakeAmmo()
		
		if self.Owner:IsPlayer() then
			//self.Owner:SetAnimation(PLAYER_ATTACK1)
		else
			if self.ActivityTranslate and self.ActivityTranslate[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ] then
				self.Owner:AddGesture( self.ActivityTranslate[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ] )
			end
		end
		
		self:FireBullet()
	
	end

end

function SWEP:SecondaryAttack()
	if CLIENT then return end
	
	//if !self:IsMeleeMode() then
		self:SetMeleeMode( true )
	//end
	
end

function SWEP:OnThink()
	
	
	
	if SERVER then
	
		if self:IsMeleeMode() and not self.Owner:KeyDown( IN_ATTACK2 ) then
			self:SetMeleeMode( false )
		end
	
		if self.Pump and self.Pump < CurTime() then
			self:SetPumpTime( CurTime() + self.Secondary.Delay/2 )
			self.PlayCockSound = true //insert bad joke here
			self.Pump = nil
		end
		
		if ( self:GetPumpTime() - self.Secondary.Delay/4 ) < CurTime() and self.PlayCockSound then
			self:EmitSound( "weapons/shotgun/shotgun_cock.wav", 45, 140 )
			self.PlayCockSound = nil
		end
		
	end
	
end

local trace = {mask = MASK_SHOT}
local Rand = math.Rand
function SWEP:FireBullet()

	local owner = self.Owner
	local aim = owner:GetAimVector()
	
	//self:ShootCustomEffects()
	
	if game.SinglePlayer() then
		owner:ShakeView( math.random(2,4) ) 
	else
		if CLIENT then
			GAMEMODE:ShakeView( math.random(2,4) )
		end
	end
	
	if SERVER then
	
		self.Pump = CurTime() + 0.2
	
		//self:SetPumpTime( CurTime() + self.Secondary.Delay )
	
		local penetrate = self.PenetratingBullets
		
		if owner:GetCharTable().PenetratingBullets then
			penetrate = true
		end
		
		local add = 0
	
		for i=1, self.Secondary.Numshots do
			local pr = ents.Create("sogm_bullet")
			if IsValid(pr) then
				local angle = self.Secondary.Spread / 2// * (owner:GetCharTable().SpreadMultiplier or 1)
				local rand = -angle/2 + (angle/self.Secondary.Numshots * (i-1)) //math.Rand(-0.15, 0.15)
							
				local spread = aim:Angle():Right() * rand
				
				//local predict = math.min(owner:Ping(), 250) / 1500 * ( (aim + spread) * 300 )
				local ping = math.min(owner:Ping(), 250) / 1100
				local predict = math.max(0.04, ping) * owner:GetVelocity():GetNormal() * owner:GetVelocityLength()*1.5
				if game.SinglePlayer() then
					predict = vector_origin
				end
				
				if i <= math.Round(self.Secondary.Numshots/2) then
					add = add + 3
				end
				
				if i > math.Round(self.Secondary.Numshots/2) then
					add = add - 3
				end
				
				local att = "anim_attachment_LH"
		
				trace.start = owner:GetShootPos() + predict
				trace.endpos = (owner:GetAttachment(owner:LookupAttachment(att)) and owner:GetAttachment(owner:LookupAttachment(att)).Pos or owner:GetShootPos()) + aim:Angle():Right() * -3 + aim * (add) + predict
				trace.filter = owner
				
				local tr = util.TraceLine(trace)
				
				local prehit
				
				if tr.Hit then
					prehit = tr
				end
				
				local pos = tr.HitPos
				
				pr:SetPos(pos or owner:GetShootPos())
				pr:SetOwner(owner)
				pr.Inflictor = self
				pr.Damage = self.Secondary.Damage + (owner:GetCharTable().BonusBulletDamage or 0)
				if penetrate then
					pr:Penetrating( true )
				end
				pr:SetAngles(aim:Angle())
					
				local force = 2700
					
				if owner:GetCharTable().BonusBulletSpeed then
					force = force + owner:GetCharTable().BonusBulletSpeed
				end
				pr:SetVelocity((aim + spread) * force)
				pr.Force = force
				pr:Spawn()

				local phys = pr:GetPhysicsObject()
				if phys:IsValid() then
					phys:SetVelocityInstantaneous((aim + spread) * force)
				end
				
				if prehit and !penetrate then
					pr:CheckTrace(prehit)
					pr:NextThink(CurTime())
				end
				
			end
		end
	
	end
	
end

function SWEP:TakeAmmo()
	if SERVER then
		if !self.Owner:GetCharTable().InfiniteAmmo then
			self:TakePrimaryAmmo(1)
		end
	end
end

function SWEP:SetMeleeMode( bl )
	self:SetDTBool( 6, bl )
end

function SWEP:IsMeleeMode()
	return self:GetDTBool( 6 )
end

function SWEP:SetPumpTime( tm )
	self:SetDTFloat( 1, tm )
end

function SWEP:GetPumpTime()
	return self:GetDTFloat( 1 )
end

function SWEP:CanPrimaryAttack()

	if !self:IsMeleeMode() and self:Clip1() <= 0 then
		self:EmitSound("Weapon_Pistol.Empty")
		self.Weapon:SetNextPrimaryFire(CurTime() + self.Secondary.Delay)

		return false
	end

	if self.Owner:IsNextBot() then
		return true
	end
	return not self:IsSwinging()
end

function SWEP:EmitFireSound()
	self:EmitSound(self.Secondary.Sound)
end

function SWEP:ShootCustomEffects()

	local PlayerPos = self.Owner:GetShootPos()
	local PlayerAim = self.Owner:GetAimVector()
	
	if not IsFirstTimePredicted() then return end
	
	if self.ShellEffect ~= "none" then
		if self.ShellEffect then
			local fx = EffectData()
			fx:SetEntity(self.Weapon)
			fx:SetNormal(PlayerAim)
			util.Effect(self.ShellEffect,fx)
		end
	end
	
end

local MeleeActivityTranslate = {}
MeleeActivityTranslate[ACT_MP_STAND_IDLE] = ACT_HL2MP_IDLE_MELEE2
MeleeActivityTranslate[ACT_MP_WALK] = ACT_HL2MP_WALK_MELEE2
MeleeActivityTranslate[ACT_MP_RUN] = ACT_HL2MP_RUN_MELEE2

local GunActivityTranslate = {}
GunActivityTranslate[ACT_MP_STAND_IDLE] = ACT_HL2MP_IDLE_SMG1
GunActivityTranslate[ACT_MP_WALK] = ACT_HL2MP_WALK_SMG1
GunActivityTranslate[ACT_MP_RUN] = ACT_HL2MP_RUN_SMG1

function SWEP:TranslateActivity(act)
	
	if self:IsMeleeMode() then
		if MeleeActivityTranslate[act] ~= nil then
			return MeleeActivityTranslate[act]
		end
	else
		if GunActivityTranslate[act] ~= nil then
			return GunActivityTranslate[act]
		end
	end


	return -1
end
/*
function SWEP:OnMeleeHit( pl, hitpos, hitnormal, dir, attacker ) 
		
	if !self:IsMeleeMode() then
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
	end

	return false
end*/

if CLIENT then

SWEP.HoldTypeDelta = 1

local pump_norm_off = Vector(4.639, 1.187, 1.807)
local pump_norm_ang = Angle(0, 0, 0)

local pump_middle_off = Vector(4.639, 1.187, -3.807)
local pump_middle_ang = Angle( 85, 9, -13 )

local pump_off = Vector( 4.639, 0.29, -12.565 )
local pump_ang = Angle( 85, 9, -13 )

SWEP.PumpDelta = 0

function SWEP:OnDrawWorldModel()
	
	if IsValid(self.Owner) then
	
		
	
		local melee = self:IsMeleeMode()
		
		for i=1,3 do
			self.Owner:SetIK( false )
		end
		
		if self.WElements and self.WElements["shotgun"] and self.WElements["shotgun"].color then
			self.WElements["shotgun"].color.a = melee and 0 or 255
		end
		
		/*if self.WElements and self.WElements["shotgun_back"] and self.WElements["shotgun_back"].color then
			self.WElements["shotgun_back"].color.a = melee and 255 or 0
		end*/
		
		
		
		if self.WElements and self.WElements["shotgun_base"] and self.WElements["shotgun_base"].modelEnt then
		
			//self.PumpDelta = math.Clamp( 1 - ( self:GetPumpTime() - CurTime() )/( self.Secondary.Delay ), 0, 1 )
			self.PumpDelta = math.Approach( self.PumpDelta, self:GetPumpTime() > CurTime() and 1 or 0, FrameTime() * 4 )
		
			local pos = LerpVector( self.PumpDelta, pump_norm_off, pump_middle_off ) 
			local ang = LerpAngle( self.PumpDelta, pump_norm_ang, pump_middle_ang ) 
			
			if self.PumpDelta == 0 then
				self.PumpEffect = false
			end
			
			if self.PumpDelta >= 0.5 then
				pos = LerpVector( ( self.PumpDelta - 0.5 ) * 2 , pump_middle_off, pump_off )
				ang = LerpAngle( ( self.PumpDelta - 0.5 ) * 2, pump_middle_ang, pump_ang ) 
				
				if not self.PumpEffect then
					local att = self.WElements["shotgun"].modelEnt:GetAttachment( self.WElements["shotgun"].modelEnt:LookupAttachment( "1" ) )
					if att then
						local e = EffectData()
							e:SetOrigin( att.Pos )
							e:SetAngles( self.WElements["shotgun"].modelEnt:GetRight():Angle() )
							e:SetEntity( self )
						util.Effect( "ShotgunShellEject", e )
					end
					self.PumpEffect = true
				end
				
			end	
			
			self.WElements["shotgun_base"].pos = pos
			self.WElements["shotgun_base"].angle = ang
		end
		
		
		if self.HoldTypeDelta ~= 0 or self.HoldTypeDelta ~= 1 then
			self.HoldTypeDelta = math.Approach( self.HoldTypeDelta, melee and 0 or 1, FrameTime() * 5 * ((self.HoldTypeDelta + 1) ^ 1.5))
		end
		
		if self.WElements and self.WElements["shotgun_left"] and self.WElements["shotgun_left"].color then
			self.WElements["shotgun_left"].color.a = melee and self.HoldTypeDelta > 0.1 and 255 or 0
		end
		
		if self.WElements and self.WElements["shotgun_right"] and self.WElements["shotgun_right"].color then
			self.WElements["shotgun_right"].color.a = melee and self.HoldTypeDelta < 0.1 and 255 or 0
		end
		
		local bone = self.Owner:LookupBone("ValveBiped.Bip01_R_UpperArm")
		if bone then 
			self.Owner:ManipulateBoneAngles( bone, Angle( 0, 80, 30 ) * self.HoldTypeDelta  )
			//self.Owner:ManipulateBoneScale( bone, Vector( 0.001, 0.001, 0.001 ) )
		end
		
		bone = self.Owner:LookupBone("ValveBiped.Bip01_R_Forearm")
		if bone then 
			self.Owner:ManipulateBoneAngles( bone, Angle( -20, 0, -30 ) * self.HoldTypeDelta  )
			//self.Owner:ManipulateBoneScale( bone, Vector( 0.001, 0.001, 0.001 ) )
		end
		
		bone = self.Owner:LookupBone("ValveBiped.Bip01_R_Hand")
		if bone then 
			self.Owner:ManipulateBoneAngles( bone, Angle( 10, -0, 0 ) * self.HoldTypeDelta  )
			//self.Owner:ManipulateBoneScale( bone, Vector( 0.1, 0.1, 0.1 ) )
		end
		
		/*
		local bone = self.Owner:LookupBone("ValveBiped.Bip01_R_UpperArm")
		if bone then 
			self.Owner:ManipulateBoneAngles( bone, Angle( -20, 80, 0 ) * self.HoldTypeDelta  )
			//self.Owner:ManipulateBoneScale( bone, Vector( 0.001, 0.001, 0.001 ) )
		end
		
		bone = self.Owner:LookupBone("ValveBiped.Bip01_R_Forearm")
		if bone then 
			self.Owner:ManipulateBoneAngles( bone, Angle( -20, 50, -30 ) * self.HoldTypeDelta  )
			//self.Owner:ManipulateBoneScale( bone, Vector( 0.001, 0.001, 0.001 ) )
		end
		
		bone = self.Owner:LookupBone("ValveBiped.Bip01_R_Hand")
		if bone then 
			self.Owner:ManipulateBoneAngles( bone, Angle( 10, -20, 0 ) * self.HoldTypeDelta  )
			//self.Owner:ManipulateBoneScale( bone, Vector( 0.1, 0.1, 0.1 ) )
		end*/
		
		//-------------------------
		
		bone = self.Owner:LookupBone("ValveBiped.Bip01_L_Clavicle")
		if bone then 
			self.Owner:ManipulateBoneAngles( bone, Angle( 20, 20, 0 ) * self.PumpDelta  )
		end
		
		bone = self.Owner:LookupBone("ValveBiped.Bip01_L_UpperArm")
		if bone then 
			self.Owner:ManipulateBoneAngles( bone, Angle( 0, 10, -10 ) * self.HoldTypeDelta + Angle( 0, 50, 0 ) * self.PumpDelta  )
		end
		
		bone = self.Owner:LookupBone("ValveBiped.Bip01_L_Forearm")
		if bone then 
			self.Owner:ManipulateBoneAngles( bone, Angle( -20, 10, 0 ) * self.HoldTypeDelta + Angle( 0, -70, -20 ) * self.PumpDelta  )
		end
		
		bone = self.Owner:LookupBone("ValveBiped.Bip01_L_Hand")
		if bone then 
			self.Owner:ManipulateBoneAngles( bone, Angle( 0, 20, 60 ) * self.HoldTypeDelta  )
		end
		
		
	end
		
end
end


