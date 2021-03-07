CHARACTER.Reference = "greed crew thug"

CHARACTER.Name = "Coderfired Thug"
CHARACTER.Description = "Takes care of leakers."

CHARACTER.Health = 700
CHARACTER.Speed = 320

CHARACTER.StartingWeapon = "sogm_fists_thug"

CHARACTER.Model = Model( "models/player/group01/male_03.mdl" )

CHARACTER.CantExecute = true
CHARACTER.KnockdownImmunity = true
CHARACTER.NoPickups = true

//CHARACTER.GametypeSpecific = "nemesis"
CHARACTER.NoMenu = true

function CHARACTER:OnSpawn( pl )
	//if not CODERFIRED_TAG then
	//	CODERFIRED_TAG = true
	//end
	if pl:IsNextBot() then
		pl:SetNextBotColor( Color( 215, 77, 64 ) )
		//pl:SetModelScale( 2.1, 0 )
		pl:SetThug()
	end
	//local armor = pl:SpawnBodywear( "models/player/group01/male_03.mdl" )
	//armor:SetDTVector( 0, Vector(215/255, 77/255, 64/255))
end

function CHARACTER:OnMeleeHit( pl, hitpos, hitnormal, dir, attacker ) 
	
	if SERVER then
		//local wep = attacker and attacker.GetActiveWeapon and attacker:GetActiveWeapon()
		//if wep and wep:IsValid() and ( wep:GetClass() == "sogm_fists_kill" or wep:GetClass() == "sogm_fists_concrete" or wep:GetClass() == "sogm_fists_henry" or wep:GetClass() == "sogm_axe" ) then
		if attacker and attacker.GetCharTable and attacker:GetCharTable() and attacker:GetCharTable().CanKnockThugs then
			pl:DoKnockdown( 2.3, true, attacker )
		end
	end

	return false
end

function CHARACTER:OnBulletHit( pl, hitpos, hitnormal, dir, dmginfo ) 
	
	if not pl.Bleeding then
		pl.Bleeding = dmginfo:GetAttacker()
		pl:SetBleeding( true )
		pl.BleedingDmgInfo = dmginfo
		
		pl:Fire( "bleedout", "", BLEEDOUT_TIME )	
	end

	return true
end