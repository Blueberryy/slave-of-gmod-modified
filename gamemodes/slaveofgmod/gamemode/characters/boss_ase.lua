CHARACTER.Reference = "boss ase"

CHARACTER.Name = "Ase"
CHARACTER.Description = ""

CHARACTER.Health = 600
CHARACTER.Speed = 380

CHARACTER.OverrideColor = Color( 0, 0, 0 )

CHARACTER.GametypeSpecific = "singleplayer"

CHARACTER.StartingWeapon = "sogm_dmca"
CHARACTER.KnockdownImmunity = true

CHARACTER.Boss = true

CHARACTER.Icon = Material( "sog/envy1.png", "smooth" )

CHARACTER.Model = Model( "models/player/group02/male_04.mdl" )

function CHARACTER:OnSpawn( pl )
		
	pl.DOTCheck = 1
	
	pl:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	
	pl.OverrideAttackDistance = 500
	pl.SpotDistance = 500
	
/*	pl.Bodyguards = pl.Bodyguards or {}
	
	for k, v in pairs( pl.Bodyguards ) do
		if v and v:IsValid() then
			v:Remove()
		end
	end
	
	table.Empty( pl.Bodyguards )
	
	local b = GAMEMODE:SpawnBot( nil, "boss lick", pl:GetPos(), TEAM_MOB, TEAM_PLAYER, TEAM_PLAYER )
	b:SetAngles( pl:GetAngles() )
	b.IgnoreTeamDamage = TEAM_MOB
	b.AllowRespawn = false
	//b.IgnoreDeaths = true
	b.DOTCheck = 1
	local off = VectorRand()
	off.z = 0
	b.FollowOffset = off
	b:SetOwner( pl )
	//b:SetNextBotColor( Color( 40, 40, 40 ) )
	b.Bodyguard = true
	b:SetBehaviour( BEHAVIOUR_FOLLOWER )
	b.IdleSpeed = b.WalkSpeed
	//b:SetModel( "models/player/group03/male_04.mdl" )
	table.insert( pl.Bodyguards, b )*/

end

function CHARACTER:OnDeath( pl, attacker, dmginfo )
	
	/*if !SINGLEPLAYER then
		if pl.Bodyguards then
			for k, v in pairs( pl.Bodyguards ) do
				if v and v:IsValid() then
					local dmginfo = DamageInfo()
						dmginfo:SetDamagePosition( v:GetPos() )
						dmginfo:SetDamage( v:Health() )
						dmginfo:SetAttacker( game.GetWorld() )
						dmginfo:SetInflictor( game.GetWorld() )
						dmginfo:SetDamageType( DMG_SLASH )
						dmginfo:SetDamageForce( VectorRand() * 200) 
					//v.DeathSequence = { Anim = "death_04", Speed = math.Rand(1, 1.2) }
					v:TakeDamageInfo( dmginfo )
				end
			end
		end
	end*/
	
end