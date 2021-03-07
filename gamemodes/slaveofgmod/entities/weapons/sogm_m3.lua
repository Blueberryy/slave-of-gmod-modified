AddCSLuaFile()

SWEP.Base 					= "sogm_shotgun" 

SWEP.PrintName				= "M3"

SWEP.WorldModel				= Model ( "models/weapons/w_shot_m3super90.mdl" )

SWEP.Primary.Sound			= Sound("Weapon_M3.Single")

SWEP.Primary.ClipSize		= 4
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize

SWEP.Primary.Numshots		= 6

SWEP.Primary.Delay			= 0.9
SWEP.Primary.Spread 		= 0.16

SWEP.AkimboClass 			= "sogm_m3_akimbo"

sound.Add( {
	name = "Weapon_M3.SingleHeavy",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 100,
	pitch = 95,
	sound = ")weapons/m3/m3-1.wav"
} )
