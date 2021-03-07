CHARACTER.Reference = "matthias"

CHARACTER.Name = "Matthias"
CHARACTER.Description = "Bigger evil."

if BADASS_MODE then
	CHARACTER.Health = 200
	CHARACTER.StartingWeapon = "sogm_m249"
	CHARACTER.Speed = 330
	//CHARACTER.NormalHoldType = true
else
	CHARACTER.Health = 100
	CHARACTER.Speed = 380
end



CHARACTER.OverrideColor = Color( 40, 40, 40 )

CHARACTER.GametypeSpecific = "singleplayer"

CHARACTER.Icon = Material( "sog/evil.png", "smooth" )

if BADASS_MODE then
	CHARACTER.Model = Model( "models/player/combine_soldier_prisonguard.mdl" )
else
	CHARACTER.Model = Model( "models/player/eli.mdl" )
end

if BADASS_MODE then
/*CHARACTER.Styles = {
	{ 
		Name = "Elite", 
		Description = "",
		//Icon = Material( "sog/style_shotgun.png", "smooth" ),		
		func = function( pl ) 
			pl:Give("sogm_m249") 
			pl:SelectWeapon("sogm_m249") 
			pl.BodyguardWeapon = "sogm_m249" 
		end 
	},	
}*/

else
CHARACTER.Styles = {
	{ 	
		Name = "sog_character_classic", 
		Description = "sog_character_classic_desc",//Spawn with Uzi's. 
		Icon = Material( "sog/style_uzi.png", "smooth" ),
		func = function( pl ) 
			pl:Give("sogm_uzi") 
			pl:SelectWeapon("sogm_uzi") 
			pl.BodyguardWeapon = "sogm_uzi" 
		end },
	{ 
		Name = "sog_character_no_russian", 
		Description = "sog_character_no_russian_desc", //Spawn with AK-47's.
		Icon = Material( "sog/style_ak.png", "smooth" ),
		func = function( pl ) 
			pl:Give("sogm_ak47") 
			pl:SelectWeapon("sogm_ak47") 
			pl.BodyguardWeapon = "sogm_ak47" 
		end },
	{ 
		Name = "sog_character_raw_power", 
		Description = "sog_character_raw_power_desc",//Spawn with shotguns.
		Icon = Material( "sog/style_shotgun.png", "smooth" ),		
		func = function( pl ) 
			pl:Give("sogm_shotgun") 
			pl:SelectWeapon("sogm_shotgun") 
			pl.BodyguardWeapon = "sogm_shotgun" 
		end },
		
	//stylish test
	/*{ 
		Name = "Revengeance", 
		Description = "",
		//Icon = Material( "sog/style_shotgun.png", "smooth" ),		
		func = function( pl ) 
			pl:Give("sogm_katana") 
			pl:SelectWeapon("sogm_katana") 
			pl.BodyguardWeapon = "sogm_katana" 
			GAMEMODE:SetPlayerSpeed( pl, 430, 430 )
			pl.BodyguardSpeed = 430
		end },*/
	
	/*{ 
		Name = "Piece of the Elite", 
		Description = "",
		//Icon = Material( "sog/style_shotgun.png", "smooth" ),		
		func = function( pl ) 
			pl:Give("sogm_m249") 
			pl:SelectWeapon("sogm_m249") 
			pl.BodyguardWeapon = "sogm_m249" 
		end },*/
		
	/*{ 
		Name = "Negotiator", 
		Description = "",
		//Icon = Material( "sog/style_shotgun.png", "smooth" ),		
		func = function( pl ) 
			pl:Give("sogm_rpg") 
			pl:SelectWeapon("sogm_rpg") 
			pl.BodyguardWeapon = "sogm_rpg" 
		end },*/
}
end

if BADASS_MODE then
function CHARACTER:OnSpawn( pl )
	local armor = pl:SpawnBodywear( "models/combine_soldier.mdl" )
	armor:SetSkin( 1 )
	pl:SetMaterial("models/combine_soldier/combinesoldiersheet_shotgun")
end

function CHARACTER:OnBulletHit( pl, hitpos, hitnormal, dir, dmginfo ) 
		
	local e = EffectData()
		e:SetOrigin( hitpos )
		e:SetNormal( hitnormal )
		e:SetScale( 1 )
	util.Effect( "StunstickImpact", e, nil, true )
	
	pl:EmitSound( "player/bhit_helmet-1.wav", math.random( 80,110 ), 100 )
	
	local damage = dmginfo:GetDamage()
	
	if damage >= pl:Health() then
		return true
	else
		dmginfo:SetDamageForce( vector_origin )
		dmginfo:SetDamage( 1 )
		pl:SetHealth( pl:Health() - damage + 1 )
		pl:TakeDamageInfo( dmginfo )
		
		return false
	end
end
end

local offsets = { Vector( -1, -1, 0 ), Vector( 1, 1, 0 ), Vector( -1, 1, 0 ), Vector( 1, -1, 0 ) }

function CHARACTER:PostSpawn( pl )
	
	pl.Bodyguards = pl.Bodyguards or {}
	
	for k, v in pairs( pl.Bodyguards ) do
		if v and v:IsValid() then
			v:Remove()
		end
	end
	
	table.Empty( pl.Bodyguards )
	
	local myteam = pl:Team()
	local enemyteam = myteam == TEAM_PLAYER and TEAM_MOB or TEAM_PLAYER
	
	local am = 2
	
	if BADASS_MODE then pl.BodyguardWeapon = "sogm_m249" end
	
	for i=1, am do
		local rand = VectorRand() * 30
		rand.z = 0
		local b = GAMEMODE:SpawnBot( pl.BodyguardWeapon or "sogm_ak47", "default", pl:GetPos() + rand, myteam, enemyteam, enemyteam )
		b:SetAngles( pl:GetAngles() )
		b.IgnoreTeamDamage = myteam
		b.AllowRespawn = false
		b.IgnoreDeaths = true
		b.DOTCheck = 1
		if offsets[ i ] then
			b.FollowOffset = offsets[ i ]
		end
		b:SetOwner( pl )
		b:SetNextBotColor( Color( 40, 40, 40 ) )
		b.Bodyguard = true
		b.ReduceSpotDelay = 0.1 //be a little more effective
		b:SetBehaviour( BEHAVIOUR_FOLLOWER )//
		if pl.BodyguardSpeed then
			b.WalkSpeed = pl.BodyguardSpeed
		end
		b.IdleSpeed = b.WalkSpeed
		b:SetModel( "models/player/group03/male_04.mdl" )
		if BADASS_MODE then
			b:SetHealth( 200 )
			local armor = b:SpawnBodywear( "models/combine_soldier.mdl" )
			armor:SetSkin( 1 )
		end
		table.insert( pl.Bodyguards, b )
	end
	
	if pl.BodyguardSpeed then
		pl.BodyguardSpeed = nil
	end
	
end

function CHARACTER:OnDeath( pl, attacker, dmginfo )
	
	if !SINGLEPLAYER then
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
	end
	
end

