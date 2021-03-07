AddCSLuaFile()

SWEP.Base 					= "sogm_m4" 

SWEP.ViewModel 				= Model( "models/weapons/cstrike/c_mach_m249para.mdl" )
SWEP.WorldModel 			= Model( "models/weapons/w_mach_m249para.mdl" )

SWEP.PrintName				= "M249"

SWEP.HoldType				= "ar2"

SWEP.Primary.Sound 			= Sound("Weapon_M249.Single")

SWEP.Primary.ClipSize		= 100
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize
SWEP.Primary.Damage			= 100
SWEP.Primary.Delay			= 0.061
SWEP.Primary.Spread 		= 0.09
SWEP.BulletSpeed			= 2000

SWEP.AkimboClass 			= nil
SWEP.Gametype 				= "singleplayer"
SWEP.IsLoud 				= true //yeah, its loud
//SWEP.Hidden					= true

function SWEP:OnKill( ply, attacker )
	ply.ToDismember = true
	if math.random(4) == 4 then
		ply.DeathSequence = { Anim = "death_0"..math.random(4), Speed = math.Rand(1.1, 2) }
	end
end