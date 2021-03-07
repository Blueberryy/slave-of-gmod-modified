AddCSLuaFile()

SWEP.Base 				= "sogm_uzi" 

SWEP.ViewModel = Model( "models/weapons/v_smg_tmp.mdl" )
SWEP.WorldModel = Model( "models/weapons/w_smg_tmp.mdl" )

SWEP.PrintName			= "TMP"

SWEP.Primary.Sound = Sound( "Weapon_TMP.SingleHeavy" )

SWEP.Primary.ClipSize		= 25
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize
SWEP.Primary.Damage			= 90
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "smg1"
SWEP.Primary.Delay			= 0.027
SWEP.Primary.Spread 		= 0.07

SWEP.AkimboClass 			= "sogm_tmp_akimbo"

SWEP.Silenced 				= true

sound.Add( {
	name = "Weapon_TMP.SingleHeavy",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 100,
	pitch = 110,
	sound = ")weapons/tmp/tmp-1.wav"
} )