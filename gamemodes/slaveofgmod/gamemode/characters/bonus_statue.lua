CHARACTER.Reference = "bonus statue"

CHARACTER.Name = "Statue"
CHARACTER.Description = ""

CHARACTER.Health = 100
CHARACTER.Speed = 380

CHARACTER.NoMenu = true

CHARACTER.Model = Model( "models/player/gman_high.mdl" )

CHARACTER.KnockdownImmunity = true

CHARACTER.NoLights = true

CHARACTER.OverrideMaterial = Material( "models/props_debris/concretedebris_chunk01" )

CHARACTER.StartingWeapon = "sogm_fists_thug"

local anims = {}
anims[1] = { seq = "seq_baton_swing", cycle = 0 }
anims[2] = { seq = "seq_preskewer", cycle = 1 }
anims[3] = { seq = "seq_throw", cycle = 0.15 }

function CHARACTER:OnSpawn( pl )
	
	pl.SpotDistance = 200
	pl.ChaseDistance = 350
	pl.Seq = anims[ math.random( 1, #anims) ]
	pl.AltBehaviour = -1
	
	if pl:IsNextBot() then
		pl:SetModelScale( 2.1, 0 )
		pl:SetMaterial( "models/props_debris/concretedebris_chunk01" )
		//pl:SetMaterial( "nature/gravelfloor005a.vtf" )
	end
	
end

function CHARACTER:OnBodyUpdate( pl ) 
	if pl.loco:GetVelocity():Length2D() < 1 then
		if pl.Seq then
		//pl:ResetSequenceInfo()
			pl:SetSequence( pl.Seq.seq )
			pl:SetCycle( pl.Seq.cycle )
		//pl:SetPlaybackRate(0)
		end
	end
end

function CHARACTER:OnMeleeHit( pl, hitpos, hitnormal, dir, attacker ) 
	
	if IsValid( pl.Target ) then return true end
	
	local e = EffectData()
		e:SetOrigin( hitpos )
		e:SetNormal( hitnormal )
		e:SetScale( 2 )
	util.Effect( "StunstickImpact", e, nil, true )
	
	pl:EmitSound( "physics/metal/metal_box_impact_bullet"..math.random(3)..".wav" )

	return false
end

function CHARACTER:OnBulletHit( pl, hitpos, hitnormal, dir, dmginfo ) 

	if IsValid( pl.Target ) then return true end
	
	local e = EffectData()
		e:SetOrigin( hitpos )
		e:SetNormal( hitnormal )
		e:SetScale( 2 )
	util.Effect( "StunstickImpact", e, nil, true )
	
	pl:EmitSound( "physics/metal/metal_box_impact_bullet"..math.random(3)..".wav" )

	return false
end