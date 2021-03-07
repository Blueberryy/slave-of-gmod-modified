AddCSLuaFile()

SWEP.Base 					= "sogm_m4" 

SWEP.ViewModel 				= Model( "models/weapons/v_pist_usp.mdl" )
SWEP.WorldModel 			= Model( "models/weapons/w_pist_usp.mdl" )

SWEP.PrintName				= "USP"

SWEP.Primary.Sound 			= Sound( "Weapon_USP.SingleHeavy" )

SWEP.HoldType				= "pistol"

SWEP.Primary.ClipSize		= 12
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize
SWEP.Primary.Damage			= 100
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "pistol"
SWEP.Primary.Delay			= 0.2
SWEP.Primary.Spread 		= 0.05
SWEP.BulletSpeed			= 2700

SWEP.IsPistol = true

SWEP.ShellEffect			= "ef_shelleject" 

SWEP.AkimboClass = "sogm_usp_akimbo"

sound.Add( {
	name = "Weapon_USP.SingleHeavy",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 100,
	pitch = 127,
	sound = ")weapons/usp/usp_unsil-1.wav"
} )

function SWEP:GetBulletOffset( aim )
	return vector_origin
end

function SWEP:OnKill( ply, attacker )
	ply.ToDismember = HITGROUP_HEAD
	if math.random(3) == 3 then
		ply.DeathSequence = { Anim = "death_04", Speed = math.Rand(0.7, 2) }//"death_04"
	end
end


if CLIENT then
local ang_flip = Angle(0,0,-90)
local vec_up = vector_up
function SWEP:DrawWorldModel()
	
	local owner = self:GetOwner()
	if IsValid(owner) and owner.HideWeapon then return end
	
	owner:DrawShadow( false )
	
	if IsValid(self.Owner) then
		local bone = self.Owner:LookupBone("ValveBiped.Bip01_R_Hand")
		if bone then 
			self.Owner:ManipulateBoneAngles( bone, ang_flip )
		end
	end
	
	self:DrawModel()
	
end
end