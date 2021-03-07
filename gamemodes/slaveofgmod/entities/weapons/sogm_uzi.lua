AddCSLuaFile()

SWEP.Author			= "NECROSSIN"
SWEP.Purpose		= ""

SWEP.AdminSpawnable		= true
SWEP.Spawnable			= true
SWEP.UseHands			= true

SWEP.ViewModel = Model( "models/weapons/v_smg_mac10.mdl" )
SWEP.WorldModel = Model( "models/weapons/w_smg_mac10.mdl" )

SWEP.ViewModelFOV		= 50

SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.HoldType			= "pistol"
SWEP.NormalHoldType 	= "revolver"

SWEP.PrintName			= "Micro UZI"
SWEP.Slot				= 1
SWEP.SlotPos			= 1
SWEP.DrawAmmo			= true
SWEP.DrawCrosshair		= false

SWEP.Primary.Sound			= Sound("Weapon_MAC10.SingleHeavy")
SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize
SWEP.Primary.Damage			= 90
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"
SWEP.Primary.Delay			= 0.07
SWEP.Primary.Spread 		= 0.09

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.HitsToExecute 			= 2
SWEP.ExecutionDelay	 		= SWEP.Primary.Delay

SWEP.ShellEffect			= "ef_shelleject" 

SWEP.AkimboClass 			= "sogm_uzi_akimbo"

sound.Add( {
	name = "Weapon_MAC10.SingleHeavy",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 80,
	pitch = 250,
	sound = ")weapons/mac10/mac10-1.wav"
} )

function SWEP:OnKill( ply, attacker )
	ply.ToDismember = math.random(5) == 5 and true or HITGROUP_HEAD
	if math.random(4) == 4 then
		ply.DeathSequence = { Anim = "death_0"..math.random(4), Speed = math.Rand(1.1, 1.5) }
	end
end

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)	
	self:SetHoldType(self.HoldType)	
	self:DrawShadow( false )
end

function SWEP:Deploy()
	if self.Owner and self.Owner:IsValid() and self.Owner:GetCharTable().NormalHoldType then
		if self.NormalHoldType and not self.Akimbo then
			self:SetWeaponHoldType(self.NormalHoldType)	
			self:SetHoldType(self.NormalHoldType)
			self.Owner:ResetBoneMatrix()
		end
	end
	return true
end

function SWEP:PrimaryAttack()
	if IsValid(self.Owner.Execution) then return false end
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	if not self:CanPrimaryAttack() then return end	
	
	self:EmitFireSound()
	self:TakeAmmo()
	if self.Akimbo then
		self:TakeAmmo()
	end
	
	//self.Owner:LagCompensation(true) 
	if self.Owner:IsPlayer() then
		self.Owner:SetAnimation(PLAYER_ATTACK1)
	else
		if self.ActivityTranslate and self.ActivityTranslate[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ] then
			self.Owner:AddGesture( self.ActivityTranslate[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ] )
		end
	end
	self:FireBullet()
	if self.Akimbo then
		self:FireBullet()
	end
	//self.Owner:LagCompensation(false) 
	
end

function SWEP:SecondaryAttack()
	if self.Owner:GetCharTable().OverrideSecondaryAttack then
		return self.Owner:GetCharTable():OverrideSecondaryAttack( self.Owner, self )
	end
	if CLIENT then return end
	if self.Akimbo then
		if !self:IsDoingAkimboMove() or self:IsReversedMove() then
			self:ReverseMove( false )
			self:SetAkimboMove( CurTime() + AKIMBO_MOVE*(self:GetFirstMove() and self:GetAkimboMoveMul() or 1))
			self:SetFirstMove( true )
			//self.FirstMove = true
		end
	end
	if IsValid(self.Owner.CanSwitch) then return end
	if !self.Akimbo then
		self.Owner:ThrowCurrentWeapon()
	end
end

function SWEP:ReverseMove( bl )
	self:SetDTBool( 0, bl )
end

function SWEP:IsReversedMove()
	return self:GetDTBool( 0 )
end

function SWEP:SetFirstMove( bl )
	self:SetDTBool( 1, bl )
end

function SWEP:GetFirstMove( bl )
	return self:GetDTBool( 1 )
end

function SWEP:Think()

	if self:IsDoingAkimboMove() then
		if !self:IsReversedMove() and not self.Owner:KeyDown(IN_ATTACK2) then
			self:SetAkimboMove( CurTime() + AKIMBO_MOVE*self:GetAkimboMoveMul() )
			self:ReverseMove( true )
		end
		if self:Clip1() < 1 then
			self:ReverseMove( false )
			self:ResetAkimboMove()
		end
	end
	
end

function SWEP:GetAkimboMoveMul()
	return self:GetAkimboMove() == 0 and 0 or ( self:IsReversedMove() and math.Clamp( (self:GetAkimboMove() - CurTime())/AKIMBO_MOVE, 0, 1 ) or math.Clamp( 1 - (self:GetAkimboMove() - CurTime())/AKIMBO_MOVE, 0, 1 ) )
end

function SWEP:ResetAkimboMove()
	self:SetDTFloat( 0, 0 )
	self:SetFirstMove( false )
	//self.FirstMove = false
end

function SWEP:SetAkimboMove( time )
	self:SetDTFloat( 0, time )
end

function SWEP:GetAkimboMove()
	return self:GetDTFloat( 0 ) or 0
end

function SWEP:IsDoingAkimboMove()
	return self:GetAkimboMove() > 0
end

local trace = {mask = MASK_SHOT}
local Rand = math.Rand
function SWEP:FireBullet()

	local owner = self.Owner
	local aim = owner:GetAimVector()
	
	self:ShootCustomEffects()
	
	if game.SinglePlayer() then
		owner:ShakeView( math.random(2,4) ) 
	else
		if CLIENT then
			GAMEMODE:ShakeView( math.random(2,4) )
		end
	end
	
	if SERVER then
	
		local penetrate = self.PenetratingBullets
		
		if owner:GetCharTable().PenetratingBullets then
			penetrate = true
		end
	
		local pr = ents.Create("sogm_bullet")
		if IsValid(pr) then
			local rand = Rand(-self.Primary.Spread, self.Primary.Spread) * (owner:GetCharTable().SpreadMultiplier or 1)
			
			if self.Akimbo then
				local ang = aim:Angle()
				ang:RotateAroundAxis( vector_up, 90 * self:GetAkimboMoveMul() * (self.Switch and 1 or -1) )
				aim = ang:Forward()
			end
			
			local spread = aim:Angle():Right() * rand
			
			//local predict = math.min(owner:Ping(), 250) / 1500 * ( (aim + spread) * 300 )
			local ping = math.min(owner:Ping(), 250) / 1100
			local predict = math.max(0.04, ping) * owner:GetVelocity():GetNormal() * owner:GetVelocityLength()*1.5
			if game.SinglePlayer() then
				predict = vector_origin
			end
			
			local att = "anim_attachment_RH"
			
			if self.Akimbo then
				self.Switch = self.Switch or false
				att = self.Switch and "anim_attachment_LH" or "anim_attachment_RH"
				self.Switch = !self.Switch
			end
			
			trace.start = owner:GetShootPos() + predict
			trace.endpos = (owner:GetAttachment(owner:LookupAttachment(att)) and owner:GetAttachment(owner:LookupAttachment(att)).Pos or owner:GetShootPos()) + aim:Angle():Right() * (self.Akimbo and 0 or -5) + predict
			trace.filter = owner
			
			//owner:LagCompensation(true) 
			local tr = util.TraceLine(trace)
			//owner:LagCompensation(false) 
			
			local prehit
			
			if tr.Hit then
				prehit = tr
			end
			
			local pos = tr.HitPos
			
			//okay, so this part might cause all these crashes, so I don't recommend using akimbo weapons yet
			if self.Akimbo then
				local dist = owner:GetShootPos():Distance(tr.HitPos)
				local dist2 = math.sqrt( math.abs(dist^2 - 256*(1- self:GetAkimboMoveMul())) )
				pos = pos-owner:GetAimVector()*dist2 + aim*dist2
			end
			
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
	
end

function SWEP:TakeAmmo()
	if SERVER then
		if !self.Owner:GetCharTable().InfiniteAmmo then
			self:TakePrimaryAmmo(1)
		end
	end
end

function SWEP:SetReloads( am )
	self:SetDTInt( 0, am )
end

function SWEP:GetReloads()
	return self:GetDTInt( 0 )
end

function SWEP:Reload()
	
	if self.Owner and self.Owner:GetCharTable().FastReload then
		self:FastReload( self.Owner:GetCharTable().FastReload or 1 )
	else
		if self.Owner and self.Owner:GetCharTable().AllowReload and self.Akimbo then
		
			if self:Clip1() > 0 then return end
			
			if self.Akimbo then
				self:ReverseMove( false )
				self:ResetAkimboMove()
			end
			
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

end

function SWEP:AcceptInput( name, activator, caller, args ) 
	
	name = string.lower(name)
	if name == "reload" then
		self:ActualReload()
	end
	
end

function SWEP:ActualReload()
	
	local owner = self.Owner
	
	if owner and owner:IsValid() then
		
		local am = math.min( self.Primary.ClipSize - self:Clip1(), owner:GetAmmoCount( self:GetPrimaryAmmoType() )  )
		self:SetClip1( self:Clip1() + am )
		owner:RemoveAmmo( am, self:GetPrimaryAmmoType() )
	
	end
	
end

local gtrace = { mask = MASK_SOLID }
function SWEP:FastReload( time )
	
	time = time or 2
		
	if self.Owner and self.Owner:GetCharTable().AllowReload and self.Akimbo then
	
		if self:Clip1() > 0 then return end
		
		if self.Akimbo then
			self:ReverseMove( false )
			self:ResetAkimboMove()
		end
		
		if self:GetReloads() > 0 then 
			self.Weapon:SetNextPrimaryFire( CurTime() + 2 )
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
		
		self.Weapon:SetNextPrimaryFire( CurTime() + time )
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

	end

end

function SWEP:CanPrimaryAttack()

	if self:Clip1() <= 0 then
		self:EmitSound("Weapon_Pistol.Empty")
		self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		
		self:Reload()
		
		if self.Owner and self.Owner:GetCharTable().AllowReload then
			//self.Weapon:SetNextPrimaryFire(CurTime() + 3)
		end

		return false
	end

	return true
end

util.PrecacheSound( "weapons/pistol/pistol_empty.wav" )

function SWEP:EmitFireSound()
	self:EmitSound(self.Primary.Sound, 100, 100, 1, CHAN_WEAPON)
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


if CLIENT then
local zero_ang = Angle( 0, 0, 0 )
function SWEP:AkimboDraw()
	
	if IsValid(self.Owner) then
		
		if self:IsDoingAkimboMove() and self:Clip1() > 0 then
			
			local bone = self.Owner:LookupBone("ValveBiped.Bip01_R_Clavicle")
			if bone then 
				self.Owner:ManipulateBoneAngles( bone, Angle(-50 * self:GetAkimboMoveMul(),0,0)  )
			end
			
			bone = self.Owner:LookupBone("ValveBiped.Bip01_R_Forearm")
			if bone then 
				self.Owner:ManipulateBoneAngles( bone, Angle(30 * self:GetAkimboMoveMul(),30 * self:GetAkimboMoveMul(),0)  )
			end
			
			bone = self.Owner:LookupBone("ValveBiped.Bip01_L_Clavicle")
			if bone then 
				self.Owner:ManipulateBoneAngles( bone, Angle(50 * self:GetAkimboMoveMul(),0,0)  )
			end
			
			bone = self.Owner:LookupBone("ValveBiped.Bip01_L_Forearm")
			if bone then 
				self.Owner:ManipulateBoneAngles( bone, Angle(-30 * self:GetAkimboMoveMul(),30 * self:GetAkimboMoveMul(),0)  )
			end
			
		else
			local bone = self.Owner:LookupBone("ValveBiped.Bip01_R_Clavicle")
			if bone then 
				self.Owner:ManipulateBoneAngles( bone, zero_ang  )
			end
			
			bone = self.Owner:LookupBone("ValveBiped.Bip01_R_Forearm")
			if bone then 
				self.Owner:ManipulateBoneAngles( bone, zero_ang  )
			end
			
			bone = self.Owner:LookupBone("ValveBiped.Bip01_L_Clavicle")
			if bone then 
				self.Owner:ManipulateBoneAngles( bone, zero_ang  )
			end
			
			local bone = self.Owner:LookupBone("ValveBiped.Bip01_L_Forearm")
			if bone then 
				self.Owner:ManipulateBoneAngles( bone, zero_ang  )
			end
			
		end
		
	end

end

local ang_flip = Angle(0,0,-90)
local vec_up = vector_up
function SWEP:DrawWorldModel()
	
	local owner = self:GetOwner()
	if IsValid(owner) and owner.HideWeapon then return end
	
	owner:DrawShadow( false )
	
	if not owner:GetCharTable().NormalHoldType then
		if IsValid(self.Owner) then
			local bone = self.Owner:LookupBone("ValveBiped.Bip01_R_Hand")
			if bone then 
				self.Owner:ManipulateBoneAngles( bone, ang_flip  )
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

