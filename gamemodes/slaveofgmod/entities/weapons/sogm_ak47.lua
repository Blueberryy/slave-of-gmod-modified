AddCSLuaFile()

SWEP.Base 					= "sogm_m4" 

SWEP.ViewModel 				= Model( "models/weapons/cstrike/c_rif_ak47.mdl" )
SWEP.WorldModel 			= Model( "models/weapons/w_rif_ak47.mdl" )

SWEP.PrintName				= "AK-47"

SWEP.Primary.Sound 			= Sound("Weapon_AK47.SingleHeavy")

SWEP.Primary.ClipSize		= 25
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize
SWEP.Primary.Damage			= 100
SWEP.Primary.Delay			= 0.1
SWEP.Primary.Spread 		= 0.06
SWEP.BulletSpeed			= 2000

SWEP.AkimboClass 			= "sogm_ak47_akimbo"

sound.Add( {
	name = "Weapon_AK47.SingleHeavy",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 100,
	pitch = 120,
	sound = ")weapons/ak47/ak47-1.wav"
} )