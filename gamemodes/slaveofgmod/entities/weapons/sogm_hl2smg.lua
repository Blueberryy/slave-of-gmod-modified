AddCSLuaFile()

SWEP.Base 					= "sogm_mp5" 

SWEP.ViewModel 				= Model( "models/weapons/c_smg1.mdl" )
SWEP.WorldModel				= Model( "models/weapons/w_smg1.mdl" )

SWEP.PrintName				= "HL2 SMG"

SWEP.Primary.Sound 			= Sound("Weapon_HL2SMG.SingleHeavy")

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize
SWEP.Primary.Damage			= 70
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"
SWEP.Primary.Delay			= 0.055
SWEP.Primary.Spread 		= 0.06

SWEP.AkimboClass 			= "sogm_hl2dm_akimbo"

sound.Add( {
	name = "Weapon_HL2SMG.SingleHeavy",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 100,
	pitch = 200,
	sound = ")weapons/smg1/smg1_fire1.wav"
} )