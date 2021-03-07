AddCSLuaFile()

SWEP.Base 				= "sogm_usp" 

SWEP.WorldModel 		= Model( "models/weapons/w_pist_usp_silencer.mdl" )

SWEP.PrintName			= "Silenced USP"

SWEP.Primary.Sound 		= Sound( "Weapon_USP.SilencedHEavy" )

SWEP.AkimboClass 		= "sogm_usp_silenced_akimbo"

SWEP.Silenced 			= true

sound.Add( {
	name = "Weapon_USP.SilencedHeavy",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 100,
	pitch = 125,
	sound = ")weapons/usp/usp1.wav"
} )
