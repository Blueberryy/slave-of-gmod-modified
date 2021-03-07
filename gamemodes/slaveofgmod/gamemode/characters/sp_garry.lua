CHARACTER.Reference = "garry"

CHARACTER.Name = "garry"
CHARACTER.Description = ""

CHARACTER.Health = 100
CHARACTER.Speed = 380

CHARACTER.StartingWeapon = "sogm_fists_kill"
CHARACTER.RemoveDefaultFists = true

CHARACTER.ExecutionHitOverride = 1
CHARACTER.KnockdownImmunity = true

CHARACTER.SpotDelay = 0.8

CHARACTER.GametypeSpecific = "singleplayer"

CHARACTER.Icon = Material( "sog/him.png", "smooth" )

CHARACTER.Model = Model( "models/player/soldier_stripped.mdl")

function CHARACTER:OnBulletHit( pl, hitpos, hitnormal, dir, dmginfo ) 
		
	//local e = EffectData()
	//	e:SetOrigin( hitpos )
	//	e:SetNormal( hitnormal )
	//	e:SetScale( 1 )
	//util.Effect( "StunstickImpact", e, nil, true )
	
	pl:EmitSound( "weapons/fx/rics/ric"..math.random(5)..".wav", math.random( 80,110 ), 100 )
				
	return false
end

for i = 1, 5 do
	util.PrecacheSound( "weapons/fx/rics/ric"..i..".wav" )
end