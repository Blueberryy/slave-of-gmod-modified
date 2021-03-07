CHARACTER.Reference = "gmpower admin"

CHARACTER.Name = "GMod Power Admin"
CHARACTER.Description = ""

CHARACTER.Health = 600
CHARACTER.Speed = 280

CHARACTER.StartingWeapon = "sogm_m249"

CHARACTER.CantExecute = true
CHARACTER.KnockdownImmunity = true
CHARACTER.NoBulletHits = true

CHARACTER.GametypeSpecific = "singleplayer"
CHARACTER.NoMenu = true

CHARACTER.Icon = Material( "sog/elite.png", "smooth" )

CHARACTER.Model = Model( "models/player/combine_super_soldier.mdl" )

function CHARACTER:OnSpawn( pl )
	if pl:IsNextBot() then
		pl:SetNextBotColor( Color( 47, 89, 185 ) )
	end
	local armor = pl:SpawnBodywear( "models/player/combine_super_soldier.mdl" )
	armor:SetDTVector( 0, Vector(47/255, 89/255, 185/255) )

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