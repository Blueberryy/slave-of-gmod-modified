CHARACTER.Reference = "security guard"

CHARACTER.Name = "Security"
CHARACTER.Description = ""

CHARACTER.Health = 400
CHARACTER.Speed = 320

CHARACTER.StartingWeapon = "sogm_deagle"

CHARACTER.Model = Model( "models/player/group01/male_01.mdl" )

CHARACTER.CantExecute = true
CHARACTER.KnockdownImmunity = true
//CHARACTER.NoPickups = true

CHARACTER.NoMenu = true

function CHARACTER:OnSpawn( pl )
	if pl:IsNextBot() then
		//pl:SetModelScale( 1.3, 0 )
		pl:SetNextBotColor( Color( 208, 43, 46 ) )
		pl:SetThug()
	end
	//local armor = pl:SpawnBodywear( "models/player/group01/male_01.mdl" )
	//armor:SetDTVector( 0, Vector(208/255, 43/255, 46/255))
	
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

function CHARACTER:OnFireHit( pl, dmginfo ) 
	
	if not pl.Bleeding then
		pl.Bleeding = dmginfo:GetAttacker()
		pl:SetBleeding( true )
		pl.BleedingDmgInfo = dmginfo
		
		pl:Fire( "bleedout", "", BLEEDOUT_TIME )	
		
		pl:SetMaterial( "models/charple/charple1_sheet" )
		local armor = pl.ent_bodywear
		
		if armor and armor:IsValid() then
			armor:SetMaterial( "models/charple/charple1_sheet" )
		end	
		
	end

	return true
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