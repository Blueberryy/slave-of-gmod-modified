AddCSLuaFile()

SWEP.Base 					= "sogm_shotgun" 

SWEP.PrintName				= "M1014"

SWEP.WorldModel				= Model ( "models/weapons/w_shot_xm1014.mdl" )

SWEP.HoldType				= "shotgun"

SWEP.Primary.Sound			= Sound("Weapon_XM1014.Single")

SWEP.Primary.ClipSize		= 8
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize

SWEP.Primary.Numshots		= 5

SWEP.Primary.Delay			= 0.3
SWEP.Primary.Spread 		= 0.16
SWEP.Primary.Automatic		= true

SWEP.AkimboClass 			= "sogm_m1014_akimbo"

sound.Add( {
	name = "Weapon_XM1014.SingleHeavy",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 100,
	pitch = 115,
	sound = ")weapons/xm1014/xm1014-1.wav"
} )
