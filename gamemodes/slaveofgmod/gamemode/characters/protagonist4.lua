CHARACTER.Reference = "pr4"

CHARACTER.Name = "Henry"
CHARACTER.Description = "Thug.  No weapons."

CHARACTER.Health = 300
CHARACTER.Speed = 380

CHARACTER.ExecutionHitOverride = 1 //1hk executions
CHARACTER.KnockdownImmunity = true

//CHARACTER.Hidden = true
CHARACTER.GametypeSpecific = "nemesis"

CHARACTER.Icon = Material( "sog/male_08m.png", "smooth" )

CHARACTER.Model = Model( "models/player/group03m/male_08.mdl" )
CHARACTER.ModelScale = 1.8//1.3
CHARACTER.CanKnockThugs = true
//CHARACTER.StepSize = 35

CHARACTER.NoPickups = true
//CHARACTER.SpotDelay = 0.3//1.2

CHARACTER.StartingWeapon = "sogm_fists_henry"
CHARACTER.RemoveDefaultFists = true

function CHARACTER:OnSpawn( pl )
	
	pl:SetGoal( translate.Get("sog_play_tip_protagonist4"), 25 )
	//local armor = pl:SpawnBodywear( "models/player/group03m/male_08.mdl" )
	//pl:SetModelScale( 1.2, 0 )
end

//prevent him flying from bullet damage
function CHARACTER:OnBulletHit( pl, hitpos, hitnormal, dir, dmginfo ) 
			
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

function CHARACTER:OnMeleeHit( pl, hitpos, hitnormal, dir, attacker ) 
	
	if SERVER then
		local wep = attacker and attacker.GetActiveWeapon and attacker:GetActiveWeapon()
		if wep and wep:IsValid() and ( wep:GetClass() == "sogm_fists_kill" or wep:GetClass() == "sogm_stunstick" or wep:GetClass() == "sogm_fists_thug" or (wep:GetClass() == "sogm_katana" and attacker.Team and attacker:Team() ~= pl:Team()) ) then
			pl:DoKnockdown( 2.3, true, attacker )
		end
	end

	return false
end