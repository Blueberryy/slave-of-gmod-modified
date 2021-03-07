AddCSLuaFile()

SWEP.Base 				= "sogm_melee_base" 

SWEP.WorldModel			= Model ( "models/props_junk/metalgascan.mdl"  ) 
SWEP.HoldType			= "melee2"
SWEP.DamageType 		= DMG_CLUB
SWEP.BloodMultiplier 	= 2
SWEP.HitsToExecute 		= 1
SWEP.Primary.Delay		= 1.3
SWEP.ExecutionDelay	 	= 0.45

SWEP.NoDamage 			= true
SWEP.Hidden				= true

SWEP.KnockoutPower 		= 4
SWEP.KnockoutDuration	= GAMEMODE:GetGametype() == "nemesis" and 4 or 2

SWEP.KnockdownDamage 	= 90

SWEP.WElements = {
	["shield2"] = { type = "Model", model = "models/props_combine/combine_bunker01.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(-15.365, -23.185, -0.166), angle = Angle(64.625, -135.65, 2.515), size = Vector(0.143, 0.143, 0.143), color = ( GAMEMODE:GetGametype() == "nemesis" and Color(215, 77, 64, 255) or color_white ), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["handle"] = { type = "Model", model = "models/props_combine/combine_binocular01.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "shield2", pos = Vector(-7.605, -17.66, 10.498), angle = Angle(90, 90, 12.35), size = Vector(0.449, 0.449, 0.449), color = Color(215, 77, 64, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

function SWEP:OnBulletHit( pl, hitpos, hitnormal, dir ) 
	
	if dir:Dot(pl:GetAimVector()) > -0.5 then return true end
	
	local e = EffectData()
		e:SetOrigin( hitpos )
		e:SetNormal( hitnormal )
		e:SetScale( 2 )
	util.Effect( "StunstickImpact", e, nil, true )
	
	pl:EmitSound( "physics/metal/metal_box_impact_bullet"..math.random(3)..".wav" )

	return false
end