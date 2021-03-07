CHARACTER.Reference = "boss donator"

CHARACTER.Name = "The Donator"
CHARACTER.Description = "Blood and Flesh"

CHARACTER.Health = 100
CHARACTER.Speed = 430

CHARACTER.StartingWeapon = "sogm_dog"
CHARACTER.RemoveDefaultFists = true
CHARACTER.KnockdownImmunity = true
CHARACTER.NoPickups = true

CHARACTER.NoMenu = true

CHARACTER.Model = Model( "models/player/zombie_fast.mdl" )

CHARACTER.Icon = Material( "sog/kleiner.png" )

function CHARACTER:OnSpawn( pl )
	
	pl.DOTCheck = 1
	
	pl.Pursuit = Entity(1)
	
	pl:SetModelScale( 1.4, 0 )
	
	pl:SetMaterial( "models/zombie_poison/poisonzombie_sheet" )
	
	--pl.Immune = true
	
	
	local token = ents.Create( "ent_donator_token" )
		token:SetPos( pl:GetPos() )
		token:SetParent( pl )
		token:SetOwner( pl )
	token:Spawn()
	
	pl.WalkSpeed = 420 - ( token:GetID() - 1 ) * 5
	
	
end

function CHARACTER:OnMeleeHit( pl, hitpos, hitnormal, dir, attacker ) 
	
	if IsValid( pl.ent_token ) and !pl.ent_token:IsActive() then
		local e = EffectData()
			e:SetOrigin( hitpos )
			e:SetNormal( hitnormal )
			e:SetScale( 2 )
		util.Effect( "StunstickImpact", e, nil, true )
		
		pl:EmitSound( "physics/metal/metal_box_impact_bullet"..math.random(3)..".wav" )
		pl:EmitSound( "weapons/stunstick/stunstick_impact"..math.random(2)..".wav" )
		return false
	end

	return true
end

function CHARACTER:OnBulletHit( pl, hitpos, hitnormal, dir ) 
	
	if IsValid( pl.ent_token ) and !pl.ent_token:IsActive() then
		local e = EffectData()
			e:SetOrigin( hitpos )
			e:SetNormal( hitnormal )
			e:SetScale( 2 )
		util.Effect( "StunstickImpact", e, nil, true )
		
		pl:EmitSound( "physics/metal/metal_box_impact_bullet"..math.random(3)..".wav" )
		return false
	end

	return true
end

function CHARACTER:OnDeath( pl, attacker, dmginfo )
	pl:EmitSound( "npc/stalker/go_alert2.wav", 75, math.random( 100, 110 ), 0.7 )
end
