CHARACTER.Name = "Big SWAT Guy"
CHARACTER.Description = ""
CHARACTER.Reference = "swat heavy"

CHARACTER.Health = 1000
CHARACTER.Speed = 230//210

CHARACTER.StartingWeapon = "sogm_m249"

CHARACTER.NoPickups = true
CHARACTER.CantExecute = true
CHARACTER.KnockdownImmunity = true
CHARACTER.NoBulletHits = true

CHARACTER.GametypeSpecific = "singleplayer"
CHARACTER.NoMenu = true

//CHARACTER.BulletForceMultiplier = 0.1


CHARACTER.Model = Model( "models/player/swat.mdl" )

function CHARACTER:OnSpawn( pl )
	local armor = pl:SpawnBodywear( "models/combine_soldier.mdl" )
	armor:SetSkin( 1 )
end

function CHARACTER:OnBulletHit( pl, hitpos, hitnormal, dir, dmginfo ) 
		
	local e = EffectData()
		e:SetOrigin( hitpos )
		e:SetNormal( hitnormal )
		e:SetScale( 1 )
	util.Effect( "StunstickImpact", e, nil, true )
	
	pl:EmitSound( "player/bhit_helmet-1.wav", math.random( 80,110 ), 100 )
	
	local damage = dmginfo:GetDamage()
	
	if damage >= pl:Health() then
		return true
	else
		//just so he doesnt fly away like a ball
		dmginfo:SetDamageForce( vector_origin )
		dmginfo:SetDamage( 1 )
		pl:SetHealth( pl:Health() - damage + 1 )
		pl:TakeDamageInfo( dmginfo )
		
		return false
	end
end

util.PrecacheSound( "player/bhit_helmet-1.wav" )