CHARACTER.Reference = "greed crew bitch"

CHARACTER.Name = "Greedy Bitch"
CHARACTER.Description = "I'm back!"

CHARACTER.Health = 100
CHARACTER.Speed = 700

CHARACTER.StartingWeapon = "sogm_katana"//"sogm_stunstick"

if !SINGLEPLAYER then
	CHARACTER.RemoveWeaponOnDeath = true
end
CHARACTER.DontLoseWeapon = true

CHARACTER.NoPickups = true

//CHARACTER.Hidden = true
CHARACTER.GametypeSpecific = "nemesis"
CHARACTER.NoMenu = true

CHARACTER.Model = Model( "models/player/group01/female_04.mdl" )//"models/player/police_fem.mdl"

function CHARACTER:OnSpawn(pl) 
	
	local spawns = POINT_PICKUPS
	
	local spawn = spawns[math.random(#spawns)]
	
	if spawn then
		if not SINGLEPLAYER and not EDITOR_MODE then
			pl:SetPos( spawn:GetPos() )
		end
		if not SINGLEPLAYER and not EDITOR_MODE then
			local e = EffectData()
				e:SetOrigin( pl:GetShootPos() + vector_up * 50 )
				e:SetMagnitude( math.random(200,300) )
				e:SetScale( 16 )
			util.Effect( "smoke_explosion", e, nil, true )
		end
	end
	
	if pl:IsNextBot() then
		pl:SetNextBotColor( Color( 215, 77, 64 ) )
		pl.NoSpawnProtection = true
		pl:SetMaterial("models/zombie_fast/fast_zombie_sheet")
	end
	
end

function CHARACTER:OverrideSecondaryAttack( pl, weapon ) 	
	return false
end