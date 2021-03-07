AddCSLuaFile()

SWEP.Base 					= "sogm_uzi" 

SWEP.ViewModel 				= Model( "models/weapons/v_smg_ump45.mdl" )
SWEP.WorldModel				= Model( "models/weapons/w_smg_ump45.mdl" )

SWEP.PrintName				= "UMP"

SWEP.Primary.Sound 			= Sound("Weapon_UMP45.SingleHeavy")

SWEP.NormalHoldType 		= "smg"

SWEP.Primary.ClipSize		= 25
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize
SWEP.Primary.Damage			= 95
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"
SWEP.Primary.Delay			= 0.065
SWEP.Primary.Spread 		= 0.06

SWEP.AkimboClass 			= "sogm_ump_akimbo"

sound.Add( {
	name = "Weapon_UMP45.SingleHeavy",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 100,
	pitch = 200,//{80,85},
	sound = ")weapons/ump45/ump45-1.wav"
} )