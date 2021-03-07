CHARACTER.Reference = "thug kid"

CHARACTER.Name = "Thug Kid"
CHARACTER.Description = "Look at me, mom!"

CHARACTER.Health = 400
CHARACTER.Speed = 320

CHARACTER.StartingWeapon = "sogm_fists_thug"

CHARACTER.Model = Model( "models/player/kleiner.mdl" )

CHARACTER.CantExecute = true
CHARACTER.KnockdownImmunity = true
CHARACTER.NoPickups = true

CHARACTER.NoMenu = true

function CHARACTER:OnSpawn( pl )
	//if not DARKRP_TAG then
		//DARKRP_TAG = true
	//end
	
	if BIG_SERVER_MEN_TIME then
		if pl:IsNextBot() then
			pl:SetModel( "models/player/breen.mdl" )
			//pl:SetModelScale( 2.1, 0 )
			pl:SetNextBotColor( Color( 20, 20, 20 ) )
			pl:SetThug()
		end
		//local armor = pl:SpawnBodywear( "models/player/breen.mdl" )
		//armor:SetDTVector( 0, Vector(20/255, 20/255, 20/255))
	else
		if pl:IsNextBot() then
			//pl:SetModelScale( 2.1, 0 )
			pl:SetNextBotColor( color_white )
			pl:SetThug()
		end
		//local armor = pl:SpawnBodywear( "models/player/kleiner.mdl" )
	end
	//armor:SetDTVector( 0, Vector(215/255, 77/255, 64/255))
end

function CHARACTER:OnMeleeHit( pl, hitpos, hitnormal, dir, attacker ) 
	
	if SERVER then
		//local wep = attacker and attacker.GetActiveWeapon and attacker:GetActiveWeapon()
		if attacker and attacker.GetCharTable and attacker:GetCharTable() and attacker:GetCharTable().CanKnockThugs then
		
		//if wep and wep:IsValid() and ( wep:GetClass() == "sogm_fists_kill" or wep:GetClass() == "sogm_fists_concrete" or wep:GetClass() == "sogm_fists_henry" or wep:GetClass() == "sogm_axe" ) then
			pl:DoKnockdown( 2.3, true, attacker )
		end
	end

	return false
end

//new fancy bleeding status
function CHARACTER:OnBulletHit( pl, hitpos, hitnormal, dir, dmginfo ) 
	
	if not pl.Bleeding then
		pl.Bleeding = dmginfo:GetAttacker()
		pl:SetBleeding( true )
		pl.BleedingDmgInfo = dmginfo
		
		pl:Fire( "bleedout", "", BLEEDOUT_TIME )	
	end

	return true
end