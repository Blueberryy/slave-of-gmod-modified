AddCSLuaFile()

SWEP.Base 					= "sogm_m4" 

SWEP.ViewModel 				= Model( "models/weapons/cstrike/c_rif_famas.mdl" )
SWEP.WorldModel 			= Model( "models/weapons/w_rif_famas.mdl" )

SWEP.PrintName				= "FAMAS"

SWEP.Primary.Sound 			= Sound("Weapon_FAMAS.Single")

SWEP.Primary.ClipSize		= 20
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize
SWEP.Primary.Damage			= 100
SWEP.Primary.Delay			= 0.055
SWEP.Primary.Spread 		= 0.055
SWEP.BulletSpeed			= 2900

SWEP.AkimboClass 			= "sogm_famas_akimbo"