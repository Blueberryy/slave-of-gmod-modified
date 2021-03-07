CHARACTER.Reference = "swat weird"

CHARACTER.Name = "Weird SWAT Unit"
CHARACTER.Description = ""

CHARACTER.Health = 100
CHARACTER.Speed = 400

CHARACTER.StartingRandomWeapon = { "sogm_m4", "sogm_shotgun", "sogm_stunstick_normal", "sogm_usp" }
CHARACTER.NormalHoldType = true

CHARACTER.Model = Model( "models/player/riot.mdl" )
CHARACTER.OverrideMaterial = Material( "models/wireframe" )
CHARACTER.OverrideColor = Color( 0, 0, 0 )

CHARACTER.CantExecute = true

CHARACTER.GametypeSpecific = "singleplayer"
CHARACTER.NoMenu = true


local mat = Material( "models/wireframe" )
function CHARACTER:OnDraw( pl )

	
	--pl:SetRenderOrigin( pl:GetPos() )
	
	--pl:SetupBones()

end

function CHARACTER:OnThink( pl )
	pl.Pursuit = Entity(1)
	pl.SpotDistance = 3000
	pl.ChaseDistance = 3000
end

function CHARACTER:PostDraw( pl )

	local def_pos = pl:GetPos()
	
	local vel = pl:GetVelocity()
	local mul = vel:LengthSqr() / 160000

	for i = 1, 3 do
		pl:SetupBones()
		pl:SetPos( def_pos +VectorRand() * 0.5 - vel:GetNormal() * ( i * 15 * mul ) )
		--pl:SetRenderOrigin( def_pos + VectorRand() * 2 - vel:GetNormal() * ( i * 2 * mul ) )
		
		render.SetColorModulation( 0,0,0 )
		render.SetBlend( 0.4 - i * 0.1 )
		render.MaterialOverride( mat )
		pl:DrawModel()
		render.MaterialOverride()
		render.SetBlend(1)
		render.SetColorModulation( 1,1,1 )
		
		
	end

end

function CHARACTER:OverrideDeathEffects( pl, attacker, dmginfo )
	local e = EffectData()
		e:SetEntity( pl )
		e:SetOrigin( pl:GetPos() )
		e:SetNormal( dmginfo and dmginfo:GetDamageForce():GetNormal() or VectorRand() )
	util.Effect("player_gib_black", e, nil, true)
end
