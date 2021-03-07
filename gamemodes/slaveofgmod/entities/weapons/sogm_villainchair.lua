AddCSLuaFile()

include("sck.lua")

SWEP.Base 				= "sogm_hl2smg" 

SWEP.HoldType				= "duel"

SWEP.Primary.ClipSize		= 60
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize
SWEP.Primary.Damage			= 100

SWEP.Secondary.Sound 		= Sound("PropAPC.FireRocket")
SWEP.Secondary.ClipSize		= 5
SWEP.Secondary.DefaultClip	= SWEP.Secondary.ClipSize
SWEP.Secondary.Delay		= 0.8
SWEP.MaxReloads 			= 4

SWEP.SingleClass = "sogm_hl2smg"
SWEP.Akimbo = true
SWEP.Hidden					= true

SWEP.WElements = {
	//["1"] = { type = "Model", model = "models/weapons/w_smg_mp5.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(6.962, 1.049, -4.22), angle = Angle(4.1, -2.511, 1.639), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["1"] = { type = "Model", model = "models/weapons/w_smg1.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(10.927, 3.482, 4.177), angle = Angle(7.951, -10.216, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["chair"] = { type = "Model", model = "models/props_combine/breenchair.mdl", bone = "ValveBiped.Bip01_Pelvis", rel = "", pos = Vector(-3.201, 19.604, -14.254), angle = Angle(63.994, -50.783, -42.074), size = Vector(0.972, 0.972, 0.972), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["launcher_left"] = { type = "Model", model = "models/weapons/w_rocket_launcher.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "chair", pos = Vector(16.024, -15.325, 28.839), angle = Angle(0, -180, 180), size = Vector(1.103, 1.103, 1.103), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["launcher_right"] = { type = "Model", model = "models/weapons/w_rocket_launcher.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "chair", pos = Vector(16.024, 12.574, 28.839), angle = Angle(0, -180, 180), size = Vector(1.103, 1.103, 1.103), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
}

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
	self:SetHoldType(self.HoldType)		
	if CLIENT then
		self:CreateModels(self.WElements)
	end
	self:DrawShadow(false)
end

function SWEP:CalcMainActivity( vel )
	local iSeq, iIdeal = self.Owner:LookupSequence ( "cidle_dual" )
	return iIdeal, iSeq
end

function SWEP:CanPrimaryAttack()

	if self:Clip1() <= 0 then
		self:EmitSound("Weapon_Pistol.Empty")
		self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		
		self:Reload()

		return false
	end

	return true
end

/*function SWEP:CanPrimaryAttack()

	if self:Clip1() <= 0 then
		self:EmitSound("Weapon_Pistol.Empty")
		self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		
		if self:Clip2() <= 0 then
			if SERVER then
				self.Owner:SelectWeapon( "sogm_fists" )
				self:Remove()
			end
		end
		
		return false
	end

	return true
end*/

function SWEP:CanSecondaryAttack()

	if self:Clip2() <= 0 then
		self:EmitSound("Weapon_Pistol.Empty")
		self.Weapon:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
		
		if self:Clip1() <= 0 then
			if SERVER then
				self.Owner:SelectWeapon( "sogm_fists" )
				self:Remove()
			end
		end
		
		return false
	end

	return true
end

local gtrace = { mask = MASK_SOLID }
function SWEP:FastReload( time )
	
	time = time or 2
		
	//if self.Owner and self.Owner:GetCharTable().AllowReload and self.Akimbo then
	
		if self:Clip1() > 0 then return end
		
		if self.Akimbo then
			self:ReverseMove( false )
			self:ResetAkimboMove()
		end
		
		if self:GetReloads() > ( self.MaxReloads - 1 ) then 
			self:EmitSound("Weapon_Pistol.Empty")
			self.Weapon:SetNextPrimaryFire(CurTime() + 2)
				
			if self:Clip2() <= 0 then
				if SERVER then
					self.Owner:SelectWeapon( "sogm_fists" )
					self:Remove()
				end
			end
			return
		end
		
		self:SetReloads( self:GetReloads() + 1 )
		
		if SERVER then
			self.Owner:GiveAmmo( self.Primary.ClipSize, self.Primary.Ammo, false )
		end
		
		self.Weapon:SetNextPrimaryFire( CurTime() + time + 0.2 )
		self.Owner:DoCustomAnimEvent( PLAYERANIMEVENT_RELOAD, 111 )
		
		if SERVER then
			self:Fire( "reload", "", time )
			
			for i=1, 2 do
			
				local att = i == 1 and "anim_attachment_RH" or "anim_attachment_LH"
			
				gtrace.start = self.Owner:GetAttachment(self.Owner:LookupAttachment(att)) and self.Owner:GetAttachment(self.Owner:LookupAttachment(att)).Pos or self.Owner:GetShootPos()
				local aim = self.Owner:GetAimVector():Angle()
				aim:RotateAroundAxis( vector_up, i == 1 and -math.random(25,35) or math.random(25,35) )
				aim = aim:Forward()
				
				gtrace.endpos = gtrace.start + aim * math.min( 0, 20 - self:OBBMaxs():Distance(self:OBBMins())/1.8 ) 
				gtrace.filter = self.Owner
				
				local tr = util.TraceLine(gtrace)
						
				local pr = ents.Create( "dropped_weapon" )
				
				pr:SetPos( tr.HitPos )
								
				pr:SetAngles( aim:Angle() )
				pr:DropAsWeapon( self, true )
				pr.StoredClip = 0 //because it's empty, duh
				pr:SetAttacker( self.Owner )
				pr.NoKnockback = noknockback or false
				pr:Spawn()
				
				local phys = pr:GetPhysicsObject()
				if IsValid(phys) then
					phys:SetVelocityInstantaneous( aim * ( 270 * (self:GetCharTable().ThrowMultiplier or 1) ) ) 
					phys:Wake()
				end
						
			end

			self.Owner:EmitSound( "weapons/slam/throw.wav" )
			
		end

	//end

end

function SWEP:Reload()
	
	self:FastReload( 0.5 )
	
	/*if self:Clip1() > 0 then return end
			
	if self.Akimbo then
		self:ReverseMove( false )
		self:ResetAkimboMove()
	end
			
	if self:GetReloads() > ( self.MaxReloads - 1 ) then 
		self:EmitSound("Weapon_Pistol.Empty")
		self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
			
		if self:Clip2() <= 0 then
			if SERVER then
				self.Owner:SelectWeapon( "sogm_fists" )
				self:Remove()
			end
		end
		return
	end
			
	self:SetReloads( self:GetReloads() + 1 )
			
	if SERVER then
		self.Owner:GiveAmmo( self.Primary.ClipSize, self.Primary.Ammo, false )
	end
	self:DefaultReload( ACT_VM_RELOAD )
	self.Owner:DoReloadEvent()*/

end

function SWEP:SecondaryAttack()
	if self.Owner:GetCharTable().OverrideSecondaryAttack then
		return self.Owner:GetCharTable():OverrideSecondaryAttack( self.Owner, self )
	end
	
	if not self:CanSecondaryAttack() then return end	
	
	local owner = self:GetOwner()
	local aim = owner:GetAimVector()	
	
	if game.SinglePlayer() then
		owner:ShakeView( math.random(1,4) ) 
	else
		if CLIENT then
			GAMEMODE:ShakeView( math.random(1,4) )
		end
	end
	
	self:EmitSound(self.Secondary.Sound)
	
	/*if CLIENT then
		self.Switch = self.Switch or false
		
		if self.WElements then
		
			local rpg = self.Switch and "launcher_left" or "launcher_right"
		
			if self.WElements[rpg] then
				local effectdata = EffectData() 
				effectdata:SetOrigin( self.WElements[rpg].modelEnt:GetPos() )// +self.WElements["rotate_main"].modelEnt:GetAngles():Up()*25
				//effectdata:SetAttachment( self.WElements[rpg].modelEnt:LookupAttachment( "muzzle" ) ) 
				effectdata:SetAngles( self.Owner:GetAimVector():Angle() ) 
				effectdata:SetScale( 1.5 )
				util.Effect( "MuzzleEffect", effectdata ) 
			end
		end
		self.Switch = !self.Switch
	end*/
	
	if SERVER then
			
		if GAMEMODE:GetRoundState() == ROUNDSTATE_RESTARTING then return end	
			
		local pr = ents.Create("rpg_missile")
		
		if IsValid(pr) then
			
			local att = "anim_attachment_RH"
			
			self.Switch = self.Switch or false
			att = self.Switch and "anim_attachment_LH" or "anim_attachment_RH"
			self.Switch = !self.Switch
									
			pr:SetPos((owner:GetAttachment(owner:LookupAttachment(att)) and ( owner:GetAttachment(owner:LookupAttachment(att)).Pos ) or owner:GetShootPos()) + aim * 35 + vector_up * 5)
			pr.Inflictor = self
			local ang = aim:Angle()
			ang.p = 0
			pr:SetAngles(ang)
			pr:SetSaveValue( "m_flDamage", 0 ) 
			pr:SetOwner(owner)
			pr:Spawn()
			pr:Activate()
			pr:SetModelScale( 1.2, 0 )
			pr:SetSolid( SOLID_BBOX )
			//print( pr:OBBMins() )
			//print( pr:OBBMaxs() )
			pr:SetCollisionBounds( Vector( -4.8, -12.8, -4.8 ), Vector( 4.8, 12.8, 50.8 ) )  
			//pr:SetCollisionBounds( pr:OBBMins() * 1 , pr:OBBMaxs() * 3  )
			
			pr:SetVelocity( aim:Angle():Forward() * 300 )
			
			pr.Owner = owner
			//PrintTable(pr:GetSaveTable())
			pr.Team = function() return owner:Team() end
			
			self:TakeSecondaryAmmo(1)
						
		end
	
	end
	
	//if IsValid(self.Owner.CanSwitch) then return end
	//if !self.Akimbo then
	//	self.Owner:ThrowCurrentWeapon()
	//end
end

function SWEP:Move( cmd )
	
	
	local keys_down = ( self.Owner:KeyDown( IN_FORWARD ) or self.Owner:KeyDown( IN_BACK ) or self.Owner:KeyDown( IN_MOVELEFT ) or self.Owner:KeyDown( IN_MOVERIGHT ) )
	
	if not self.Acceleration and self.Owner:GetVelocityLength() >= self.Owner:GetMaxSpeed() then
		self.Acceleration = true
		cmd:SetVelocity(cmd:GetVelocity() * 1.4 )//1.4
	end
	
	if self.Acceleration and self.Owner:GetVelocityLength() < self.Owner:GetMaxSpeed()/2 then
		self.Acceleration = false
	end
	
	if self.Acceleration and !keys_down then
		self.Owner:SetGroundEntity(NULL)
		cmd:SetForwardSpeed(0)
		cmd:SetVelocity(cmd:GetVelocity() * (1 - FrameTime() * 0.4))
	end
	
end

if CLIENT then
local ang_flip = Angle(0,0,-40)
local vec_up = vector_up

function SWEP:DrawHUD()

	if not self.OverrideAmmoText then
		self.OverrideAmmoText = ""
	end
	
	local clip = self:Clip1()
	local clip2 = self:Clip2()
	
	local clips = self.MaxReloads - self:GetReloads()
	
	self.OverrideAmmoText = clip > 0 and translate.Format("sog_hud_x_rnd", clip)..(clip == 1 and "" or translate.Get("sog_hud_x_rnds")) or translate.Get("sog_hud_empty")
	self.OverrideAmmoText = self.OverrideAmmoText.."    "..( clips > 0 and ( translate.Format("sog_hud_x_clips", clips) ) or "" )
	self.OverrideAmmoText = self.OverrideAmmoText.."    "..( clip2 > 0 and ( translate.Format("sog_hud_x_rockets", clip2) ) or "" )
	
end

function SWEP:DrawWorldModel()
	
	local owner = self:GetOwner()
	if IsValid(owner) and owner.HideWeapon then return end
	
	owner:DrawShadow( false )
		
	self:DrawModel()
	
	if IsValid(self.Owner) then
		local bone = self.Owner:LookupBone("ValveBiped.Bip01_R_Hand")
		if bone then 
			self.Owner:ManipulateBoneAngles( bone, ang_flip )
		end
		local bone = self.Owner:LookupBone("ValveBiped.Bip01_L_Hand")
		if bone then 
			self.Owner:ManipulateBoneAngles( bone, ang_flip * -1 )
		end
		
		self:AkimboDraw()
				
	end
	
	self:SCK_DrawWorldModel()
	
	if !IsValid(self.Owner) then return end
	if self.Owner:GetVelocityLength() < 100 then return end
	
	self.NextEffect = self.NextEffect or 0
	
	if self.NextEffect > CurTime() then return end
	
	self.NextEffect = CurTime() + 0.023
			
	local emitter = ParticleEmitter(self.Owner:GetPos())
	emitter:SetPos(self.Owner:GetShootPos())

		
	local rand = VectorRand()
	rand.z = 0
	local pos = self.Owner:GetPos() + vector_up*math.Rand(2,4) + rand*math.Rand(-15,15)
		
	for i=1, 2 do
		local particle = emitter:Add("particles/smokey", pos)
		particle:SetVelocity(math.Rand(0.1, 0.5)*self.Owner:GetVelocity()+VectorRand()*2+vector_up*math.random(30))
		particle:SetDieTime(math.Rand(0.5, 1))
		particle:SetStartAlpha(100)
		particle:SetEndAlpha(0)
		particle:SetStartSize(math.random(3,5))
		particle:SetEndSize(math.random(6,10))
		particle:SetRoll(math.Rand(-180, 180))
		particle:SetColor(100, 100, 100)
		particle:SetCollide(true)
		particle:SetBounce(0.1)
		particle:SetAirResistance(15)
		particle:SetGravity(vector_up*-25)
	end
		
	emitter:Finish()
		
end
end