AddCSLuaFile()

SWEP.Author			= "NECROSSIN"
SWEP.Purpose		= ""

SWEP.AdminSpawnable		= true
SWEP.Spawnable			= true
SWEP.UseHands			= true

SWEP.ViewModel			= Model ( "models/weapons/c_shotgun.mdl" )
SWEP.WorldModel			= Model ( "models/Weapons/w_shotgun.mdl" )

SWEP.ViewModelFOV		= 50

SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType			= "shotgun"

SWEP.PrintName			= "Shotgun"
SWEP.Slot				= 1
SWEP.SlotPos			= 1
SWEP.DrawAmmo			= true
SWEP.DrawCrosshair		= false

SWEP.Primary.Sound			= Sound("Weapon_Shotgun.Single")
SWEP.Primary.ClipSize		= 6
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize
SWEP.Primary.Damage			= 50
SWEP.Primary.Numshots		= 5
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "buckshot"
SWEP.Primary.Delay			= 0.4
SWEP.Primary.Spread 		= 0.12

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.ShellEffect			= "ef_shelleject_shotgun" 

SWEP.HitsToExecute 			= 1
SWEP.ExecutionDelay	 		= SWEP.Primary.Delay

SWEP.Hidden					= true

function SWEP:OnKill( ply, attacker )
	ply.ToDismember = true
end

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)	
end

function SWEP:Deploy()
	if self.Owner and self.Owner:IsValid() and SERVER then
		self.Owner:PlayGesture( ACT_HL2MP_GESTURE_RELOAD_SHOTGUN  )
	end
end

function SWEP:PrimaryAttack()
	if IsValid(self.Owner.Execution) then return false end
	if not self:CanPrimaryAttack() then return end	
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	
	self:EmitFireSound()
	self:TakeAmmo()	
	
	//self.Owner:LagCompensation(true) 
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:FireBullet()
	//self.Owner:LagCompensation(false) 
	
end

function SWEP:SecondaryAttack()
	if CLIENT then return end
	if self.Owner:GetCharTable().OverrideSecondaryAttack then
		return self.Owner:GetCharTable():OverrideSecondaryAttack( self.Owner, self )
	end
	if IsValid(self.Owner.CanSwitch) then return end
	self.Owner:ThrowCurrentWeapon()
end



function SWEP:SetPistolHoldType( time )
	self:SetDTFloat( 0 , time )
	self:SetHoldType( "pistol" )
end

function SWEP:GetPistolHoldType()
	return self:GetDTFloat( 0 )
end

function SWEP:IsPistolHoldType()
	return self:GetDTFloat( 0 ) > 0
end

function SWEP:ResetHoldType()
	self:SetDTFloat( 0, 0 )
	self:SetHoldType( self.HoldType )
end


SWEP.LastYaw = 0
function SWEP:Think()

	if SERVER then
		
		self.CurYaw = self.Owner:GetAngles().y 
		
		if math.NormalizeAngle( math.abs( self.CurYaw - self.LastYaw) ) > 60 then // !self:IsPistolHoldType() and 
			self:SetPistolHoldType( CurTime() + 1.5 )
		end
		
		if self:IsPistolHoldType() and self:GetPistolHoldType() <= CurTime() then
			self:ResetHoldType()
		end
		
		self.LastYaw = self.CurYaw
	
	end
	
	
	self:NextThink(CurTime())
	return true
	
end

local trace = { mask = MASK_SHOT}
local Rand = math.Rand
function SWEP:FireBullet()

	local owner = self.Owner
	local aim = owner:GetAimVector()
	//owner:SetAnimation(PLAYER_ATTACK1)
	
	self:ShootCustomEffects()
	
	if CLIENT then
		GAMEMODE:ShakeView( math.random(5,8) )
	end
	
	
	if SERVER then
	
		local penetrate = self.PenetratingBullets
		
		if owner:GetCharTable().PenetratingBullets then
			penetrate = true
		end
	
		local add = 0
		
		local att = "anim_attachment_RH"
					
		//owner:LagCompensation(true) 
		
		for i=1, self.Primary.Numshots do
			local pr = ents.Create("sogm_bullet")
			if IsValid(pr) then
				local angle = self.Primary.Spread / 2// * (owner:GetCharTable().SpreadMultiplier or 1)
				local rand = -angle/2 + (angle/self.Primary.Numshots * (i-1)) //math.Rand(-0.15, 0.15)
				
				local spread = aim:Angle():Right() * rand
				
				//local predict = math.min(owner:Ping(), 250) / 1500 * ( (aim + spread) * 300 )
				local ping = math.min(owner:Ping(), 250) / 1100
				local predict = math.max(0.04, ping) * owner:GetVelocity():GetNormal() * owner:GetVelocityLength()*1.5
							
				if i <= math.Round(self.Primary.Numshots/2) then
					add = add + 3
				end
				
				if i > math.Round(self.Primary.Numshots/2) then
					add = add - 3
				end
				
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
				pr.Damage = self.Primary.Damage + (owner:GetCharTable().BonusBulletDamage or 0)
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
		//owner:LagCompensation(false) 
	
	end
	
end

function SWEP:ShootCustomEffects()

	local PlayerPos = self.Owner:GetShootPos()
	local PlayerAim = self.Owner:GetAimVector()
	
	if not IsFirstTimePredicted() then return end
	
	/*if self.MuzzleEffect ~= "none" then
		local fx = EffectData()
		fx:SetEntity(self.Weapon)
		fx:SetOrigin(PlayerPos)
		fx:SetNormal(PlayerAim)
		fx:SetAttachment(self.MuzzleAttachment)
		util.Effect(self.MuzzleEffect,fx)
	end*/
	
	if self.ShellEffect ~= "none" then
		if self.ShellEffect then
			local fx = EffectData()
			fx:SetEntity(self.Weapon)
			fx:SetNormal(PlayerAim)
			util.Effect(self.ShellEffect,fx)
		end
	end
	
end


function SWEP:TakeAmmo()
	if SERVER then
		self:TakePrimaryAmmo(1)
	end
end

function SWEP:SetReloads( am )
	self:SetDTInt( 0, am )
end

function SWEP:GetReloads()
	return self:GetDTInt( 0 )
end

function SWEP:Reload()
	
	if self.Owner and self.Owner:GetCharTable().AllowReload then
	
		if self:Clip1() > 0 then return end
		
		if self:GetReloads() > 0 then 
			self.Weapon:SetNextPrimaryFire(CurTime() + 2)
			if SERVER then
				self.Owner:SelectWeapon( "sogm_fists" )
				self:Remove()
			end
			return 
		end
		
		self:SetReloads( self:GetReloads() + 1 )
		
		if SERVER then
			self.Owner:GiveAmmo( self.Primary.ClipSize, self.Primary.Ammo, false )
		end
		self:DefaultReload( ACT_VM_RELOAD )
		self.Owner:DoReloadEvent()

	end

end

function SWEP:CanPrimaryAttack()

	if self:Clip1() <= 0 then
		self:EmitSound("Weapon_Pistol.Empty")
		self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		
		self:Reload()
		
		if self.Owner and self.Owner:GetCharTable().AllowReload then
			self.Weapon:SetNextPrimaryFire(CurTime() + 3)
		end

		return false
	end

	return true
end

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound)
end

if CLIENT then
function SWEP:DrawWorldModel()
	
	local owner = self:GetOwner()
	if IsValid(owner) and owner.HideWeapon then return end
	
	owner:DrawShadow( false )
	
		if owner:IsNextBot() then
			local dlight = DynamicLight( owner:EntIndex() )
			if ( dlight ) then
				local size = 50
				dlight.Pos = owner:GetPos()+vector_up*2
				dlight.r = 255
				dlight.g = 255
				dlight.b = 255
				dlight.Brightness = 3.5
				dlight.Size = size
				dlight.Decay = size * 1
				dlight.DieTime = CurTime() + 1
				dlight.Style = 0
				dlight.NoModel = true
			end
		end
	
	self:DrawModel()
	
end
	function SWEP:OnRemove()
		if IsValid(self.Owner) then
			self.Owner:ResetBoneMatrix()
		end
	end
end