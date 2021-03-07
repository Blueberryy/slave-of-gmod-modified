AddCSLuaFile()

SWEP.Author			= "NECROSSIN"
SWEP.Purpose		= ""

SWEP.AdminSpawnable		= true
SWEP.Spawnable			= true
SWEP.UseHands			= true

SWEP.ViewModel			= Model( "models/weapons/v_shot_xm1014.mdl" )
SWEP.WorldModel			= Model( "models/weapons/w_annabelle.mdl" )//models/weapons/w_shot_xm1014.mdl


SWEP.ViewModelFOV		= 50

SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType			= "ar2"

SWEP.PrintName			= "Boomstick"
SWEP.Slot				= 1
SWEP.SlotPos			= 1
SWEP.DrawAmmo			= true
SWEP.DrawCrosshair		= false

SWEP.Primary.Sound			= Sound("weapons/shotgun/shotgun_dbl_fire.wav")//Sound("Weapon_XM1014.Single")
SWEP.Primary.ClipSize		= 2
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize
SWEP.Primary.Damage			= 100
SWEP.Primary.Numshots		= 14
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "buckshot"
SWEP.Primary.Delay			= 0.2
SWEP.Primary.Spread 		= 0.4

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.HitsToExecute 			= 1
SWEP.ExecutionDelay	 		= SWEP.Primary.Delay

function SWEP:OnKill( ply, attacker )
	ply.ToDismember = true
end

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)	
	self:SetHoldType(self.HoldType)
end

function SWEP:PrimaryAttack()
	if IsValid(self.Owner.Execution) then return false end
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	if not self:CanPrimaryAttack() then return end	
	
	self:EmitFireSound()
	self:TakeAmmo()
	
	//self.Owner:LagCompensation(true) 
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

local trace = { mask = MASK_SHOT}
local Rand = math.Rand
function SWEP:FireBullet()

	local owner = self.Owner
	local aim = owner:GetAimVector()
	owner:SetAnimation(PLAYER_ATTACK1)
	
	if game.SinglePlayer() then
		owner:ShakeView( math.random(13,20) ) 
	else
		if CLIENT then
			GAMEMODE:ShakeView( math.random(13,20) )
		end
	end
	
	if SERVER then
	
		local penetrate = self.PenetratingBullets
		
		if owner:GetCharTable().PenetratingBullets then
			penetrate = true
		end
	
		local add = 0
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
				if game.SinglePlayer() then
					predict = vector_origin
				end
				
				if i <= math.Round(self.Primary.Numshots/2) then
					add = add + 1
				end
				
				if i > math.Round(self.Primary.Numshots/2) then
					add = add - 1
				end
				
				trace.start = owner:GetShootPos() + predict
				trace.endpos = (owner:GetAttachment(owner:LookupAttachment("anim_attachment_RH")) and owner:GetAttachment(owner:LookupAttachment("anim_attachment_RH")).Pos or owner:GetShootPos()) + aim:Angle():Right() * -3 + aim * (add) + predict
				trace.filter = owner
				
				
				local tr = util.TraceLine(trace)
				
				
				local prehit
			
				if tr.Hit then
					prehit = tr
				end
				
				pr:SetPos(tr.HitPos)
				pr:SetOwner(owner)
				pr.Inflictor = self
				pr.Damage = self.Primary.Damage + (owner:GetCharTable().BonusBulletDamage or 0)
				if penetrate then
					pr:Penetrating( true )
				end
				pr:SetAngles(aim:Angle())
				
				local force = 2600
				
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

function SWEP:TakeAmmo()
	if SERVER then
		self:TakePrimaryAmmo(1)
	end
end

function SWEP:Reload()
end

function SWEP:CanPrimaryAttack()


	if self:Clip1() <= 0 then
		self:EmitSound("Weapon_Pistol.Empty")
		self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

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
	
	if IsValid(self.Owner) then
		local bone = self.Owner:LookupBone("ValveBiped.Bip01_R_Hand")
		if bone then 
			if self.Owner:GetManipulateBoneAngles( bone ) ~= Angle(0,0,0) then
				self.Owner:ManipulateBoneAngles( bone, Angle(0,0,0)  )
			end
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