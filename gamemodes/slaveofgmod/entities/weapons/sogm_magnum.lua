AddCSLuaFile()

SWEP.Base 				= "sogm_usp" 

SWEP.WorldModel			= Model( "models/weapons/w_357.mdl" )

SWEP.PrintName			= "Motherfucking Magnum"

SWEP.Primary.Sound		= Sound("Weapon_357.SingleHeavy")
SWEP.Primary.ClipSize	= 6
SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize
SWEP.Primary.Damage		= 300
SWEP.Primary.Delay		= 0.2
SWEP.Primary.Spread 	= 0.03
SWEP.PenetratingBullets = true

SWEP.MinShake 			= 5
SWEP.MaxShake 			= 8

SWEP.ShellEffect		= "none" 

SWEP.AkimboClass 		= "sogm_magnum_akimbo"

sound.Add( {
	name = "Weapon_357.SingleHeavy",
	channel = CHAN_WEAPON,
	volume = 0.93,
	level = 100,
	pitch = {80,85},
	sound = "weapons/357/357_fire2.wav"
} )

function SWEP:OnKill( ply, attacker )
	ply.ToDismember = HITGROUP_HEAD
	if math.random(3) ~= 3 then
		ply.DeathSequence = { Anim = "death_04", Speed = math.Rand(1, 1.8) }
	end
end

if CLIENT then
local vec_up = vector_up
function SWEP:DrawWorldModel()
	
	local owner = self:GetOwner()
	if IsValid(owner) and owner.HideWeapon then return end
	
	owner:DrawShadow( false )
	
	self:DrawModel()
	
end
end