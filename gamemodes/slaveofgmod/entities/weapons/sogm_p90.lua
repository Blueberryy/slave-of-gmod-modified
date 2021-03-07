AddCSLuaFile()

SWEP.Base 					= "sogm_uzi" 

SWEP.ViewModel 				= Model( "models/weapons/v_smg_p90.mdl" )
SWEP.WorldModel				= Model( "models/weapons/w_smg_p90.mdl" )

SWEP.PrintName				= "P90"

SWEP.Primary.Sound 			= Sound("Weapon_p90.SingleHeavy")

SWEP.Primary.ClipSize		= 50
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize
SWEP.Primary.Damage			= 70
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"
SWEP.Primary.Delay			= 0.035
SWEP.Primary.Spread 		= 0.06

SWEP.AkimboClass 			= "sogm_p90_akimbo"

sound.Add( {
	name = "Weapon_p90.SingleHeavy",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 100,
	pitch = 250,//{80,85},
	sound = ")weapons/ump45/ump45-1.wav"
} )