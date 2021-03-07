CHARACTER.Reference = "greed crew moderator"

CHARACTER.Name = "Coderfired Moderator"
CHARACTER.Description = "Stop banning yourself."

CHARACTER.Health = 100
CHARACTER.Speed = 380

CHARACTER.StartingRandomWeapon = { "sogm_magnum_akimbo" }

CHARACTER.Model = Model( "models/player/alyx.mdl" )

CHARACTER.CantExecute = true
//CHARACTER.UseAkimboGuns = true
CHARACTER.DontLoseWeapon = true

CHARACTER.GametypeSpecific = "nemesis"
CHARACTER.NoMenu = true

function CHARACTER:OnSpawn( pl )
	if not CODERFIRED_TAG then
		CODERFIRED_TAG = true
	end
	if pl:IsNextBot() then
		pl:SetNextBotColor( Color( 215, 77, 64 ) )
		pl:SetModelScale( 1.1, 0 )
	end
	//local armor = pl:SpawnBodywear( "models/player/alyx.mdl" )
	//armor:SetDTVector( 0, Vector(215/255, 77/255, 64/255))
end

function CHARACTER:OnMeleeHit( pl, hitpos, hitnormal, dir, attacker ) 
	
	if SERVER then
	
		pl.AbsorbedDamage = pl.AbsorbedDamage or 0
		
		pl.AbsorbedDamage = pl.AbsorbedDamage + 200
		
		//pl:EmitSound( "player/headshot"..math.random(2)..".wav" )
		pl:EmitSound( "player/kevlar"..math.random(5)..".wav" )		
		
		if pl.AbsorbedDamage >= 100 then
			pl:DoKnockdown( 2.3, true, attacker )
			pl.AbsorbedDamage = 0
		end
	end

	return false
end

function CHARACTER:OnBulletHit( pl, hitpos, hitnormal, dir, dmginfo ) 
	
	pl.AbsorbedDamage = pl.AbsorbedDamage or 0
	
	local damage = dmginfo:GetDamage()
	local attacker = dmginfo:GetAttacker()
	
	pl.AbsorbedDamage = pl.AbsorbedDamage + damage
	
	//pl:EmitSound( "player/headshot"..math.random(2)..".wav" )
	pl:EmitSound( "player/kevlar"..math.random(5)..".wav" )		
		
	if pl.AbsorbedDamage >= 100 then
		pl:DoKnockdown( 2.3, true, attacker )
		pl.AbsorbedDamage = 0
	end

		
	return false
end