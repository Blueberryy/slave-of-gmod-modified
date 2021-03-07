AddCSLuaFile()

SWEP.Base 					= "sogm_m4" 

SWEP.ViewModel 				= Model( "models/weapons/cstrike/c_pist_glock18.mdl" )
SWEP.WorldModel 			= Model( "models/weapons/w_pist_glock18.mdl" )

SWEP.PrintName				= "Glock"

SWEP.Primary.Sound 			= Sound( "weapons/glock/glock18-1.wav" )

SWEP.HoldType				= "pistol"

SWEP.Primary.ClipSize		= 7
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize
SWEP.Primary.Damage			= 100
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"
SWEP.Primary.Delay			= 0.2
SWEP.Primary.Spread 		= 0.05
SWEP.BulletSpeed			= 2700

SWEP.ShellEffect			= "ef_shelleject" 

SWEP.AkimboClass 			= "sogm_glock_akimbo"	

function SWEP:GetBulletOffset( aim )
	return vector_origin
end

/*function SWEP:PrimaryAttack()
	if IsValid(self.Owner.Execution) then return false end
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	if not self:CanPrimaryAttack() then return end	
	
	self:EmitFireSound()
	self:TakeAmmo()

	self.Owner:SetAnimation(PLAYER_ATTACK1)
	
	self:FireBullet()
	self:FireBullet()
	
end*/

function SWEP:OverrideFireBullet()
	self:FireBullet()
	self:FireBullet()
end

if CLIENT then
local ang_flip = Angle(0,0,-90)
local vec_up = vector_up
function SWEP:DrawWorldModel()
	
	local owner = self:GetOwner()
	if IsValid(owner) and owner.HideWeapon then return end
	
	owner:DrawShadow( false )
	
		if owner:IsNextBot() then
			local dlight = DynamicLight( owner:EntIndex() )
			if ( dlight ) then
				local size = 50
				dlight.Pos = owner:GetPos()+vec_up*2
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
	
	if IsValid(self.Owner) then
		local bone = self.Owner:LookupBone("ValveBiped.Bip01_R_Hand")
		if bone and self.Owner:GetManipulateBoneAngles(bone) ~= ang_flip then 
			self.Owner:ManipulateBoneAngles( bone, ang_flip  )
		end
	end
	
	self:DrawModel()
	
end
end