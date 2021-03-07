CHARACTER.Name = "Shielded coder" //yeah, how original
CHARACTER.Description = ""
CHARACTER.Reference = "greed crew shield"

CHARACTER.Health = 100
CHARACTER.Speed = 280

CHARACTER.StartingWeapon = "sogm_riotshield"

CHARACTER.NoPickups = true
CHARACTER.ImmuneToThrowables = true

//CHARACTER.Hidden = true
CHARACTER.GametypeSpecific = "nemesis"
CHARACTER.NoMenu = true


CHARACTER.Model = Model( "models/player/zombie_classic.mdl" )


for i=1,3 do
	util.PrecacheSound( "physics/metal/metal_box_impact_bullet"..i..".wav" )
end

function CHARACTER:OnSpawn( pl )
	if not CODERFIRED_TAG then
		CODERFIRED_TAG = true
	end
	if pl:IsNextBot() then
		pl:SetNextBotColor( Color( 215, 77, 64 ) )
	end
end

//return true to allow damage, false to not
function CHARACTER:OnBulletHit( pl, hitpos, hitnormal, dir ) 
	
	if dir:Dot(pl:GetAimVector()) > -0.5 then return true end
	
	local e = EffectData()
		e:SetOrigin( hitpos )
		e:SetNormal( hitnormal )
		e:SetScale( 2 )
	util.Effect( "StunstickImpact", e, nil, true )
	
	pl:EmitSound( "physics/metal/metal_box_impact_bullet"..math.random(3)..".wav" )

	return false
end

function CHARACTER:OnMeleeHit( pl, hitpos, hitnormal, dir, attacker ) 
	
	if SERVER then
		local wep = attacker and attacker.GetActiveWeapon and attacker:GetActiveWeapon()
		if wep and wep:IsValid() and ( wep:GetClass() == "sogm_fists_kill" or wep:GetClass() == "sogm_fists_henry" ) and dir:Dot(pl:GetAimVector()) < -0.5 then
			pl:DoKnockdown( 2.3, true, attacker )
			return false
		end
	end
	
	if pl:IsPlayer() then
		if dir:Dot(pl:GetAimVector()) > -0.5 then return true end
	else
		if SERVER and dir:Dot(pl:GetAimVector()) > -0.5 then return true end
	end
	
	if SERVER then
		local e = EffectData()
			e:SetOrigin( hitpos )
			e:SetNormal( hitnormal )
			e:SetScale( 2 )
		util.Effect( "StunstickImpact", e, nil, true )
		
		pl:EmitSound( "physics/metal/metal_box_impact_bullet"..math.random(3)..".wav" )
	end

	return false
end