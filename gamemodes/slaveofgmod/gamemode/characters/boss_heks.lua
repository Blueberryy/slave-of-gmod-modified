CHARACTER.Reference = "boss heks"

CHARACTER.Name = "Heks"
CHARACTER.Description = ""

CHARACTER.Health = 1000
CHARACTER.Speed = 300

CHARACTER.GametypeSpecific = "singleplayer"
CHARACTER.NoMenu = true
CHARACTER.KnockdownImmunity = true

CHARACTER.InfiniteAmmo = true
CHARACTER.BulletScale = 2
CHARACTER.SpreadMultiplier = 1.2

CHARACTER.StartingWeapon = "sogm_m4"
CHARACTER.TransmitState = TRANSMIT_ALWAYS
CHARACTER.NoLights = true

CHARACTER.Icon = Material( "sog/heks.png", "smooth" )

CHARACTER.Model = Model( "models/player/zombie_fast.mdl")

CHARACTER.WElements = {
	["m4"] = { type = "Model", model = "models/weapons/w_rif_m4a1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(12.737000465393, 1.125, 3.3759999275208), angle = Angle(0, 0, -180), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true },
	//["body"] = { type = "Model", model = "models/player/breen.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(-52.268001556396, -19.410999298096, -21.981000900269), angle = Angle(0, 77.186996459961, 66.044998168945), size = Vector(1, 1, 1), color = Color(15, 15, 15, 1), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bonemerge = true }
}

util.PrecacheModel( "models/props_debris/concrete_chunk04a.mdl" )

local NewActivityTranslate = {}
NewActivityTranslate[ACT_MP_STAND_IDLE] = ACT_HL2MP_IDLE_CROUCH_AR2 
NewActivityTranslate[ACT_MP_WALK] = ACT_HL2MP_WALK_CROUCH_SHOTGUN//ZOMBIE
NewActivityTranslate[ACT_MP_RUN] = ACT_HL2MP_WALK_CROUCH_SHOTGUN
NewActivityTranslate[ACT_MP_CROUCH_IDLE] = ACT_HL2MP_RUN_KNIFE
NewActivityTranslate[ACT_MP_CROUCHWALK] = ACT_HL2MP_RUN_KNIFE
NewActivityTranslate[ACT_MP_JUMP] = ACT_HL2MP_SWIM_PISTOL //ACT_HL2MP_SWIM_AR2 

local creep_distance = 300

local pillar_tops = {
	Vector( -837.56, 197.29, 340.36 ),
	Vector( -975.43, -720.27, 306.11 ),
	Vector( -1630.81, 70.14, 307.44 ),
	Vector( -2120.57, -698.35, 336.25 ),
	Vector( -2462.69, -65.32, 353.04 ),
}

local function EmitDSPSound( pl, soundname, duration, pitch )
	
	pl.Sounds = pl.Sounds or {}
	
	if not pl.Sounds[ soundname ] then
		pl.Sounds[ soundname ] = { snd = CreateSound( pl, soundname ), dur = duration }
		pl.Sounds[ soundname ].snd:SetDSP( 38 )
	end
	
	// stop current sound just in case
	if pl.CurPlaySound and pl.Sounds[ pl.CurPlaySound ] and pl.Sounds[ pl.CurPlaySound ].snd then
		pl.Sounds[ pl.CurPlaySound ].snd:Stop()
	end
	
	pl.CurPlayPitch = pitch or 100
	pl.CurPlaySound = soundname
	pl.PlaySoundTime = CurTime() + duration
	
end

// basically take current nav area and pick random spot on it to the left or to the right
local function CheckDodging( pl )
	
	pl.NextFlicker = pl.NextFlicker or 0
	
	if pl.NextFlicker >= CurTime() then return end
	
	if pl.PathObject then
		local cur_segment = pl.PathObject:FirstSegment()
		
		if cur_segment and cur_segment.area then
			
			local dir = math.random( 2 ) == 2 and 1 or -1
			
			local check_pos = pl:GetPos() + pl:GetRight() * dir * math.random( 120, 160 )
			
			local new_pos = cur_segment.area:GetClosestPointOnArea( check_pos )
			if new_pos then
				pl:SetPos( new_pos )
				//cur_segment.area:Draw()
				pl.NextFlicker = CurTime() + 0.1
				
				if math.random( 10 ) == 10 then
					EmitDSPSound( pl, "vo/citadel/br_youfool.wav", 4, math.random( 50, 65 ) )
				else
					EmitDSPSound( pl, "npc/headcrab_poison/ph_hiss1.wav", 2, math.random( 85, 115 ) )
				end

				pl:SetDTFloat( 2, CurTime() + 0.4 )
				
			end
		end
		
	end
end

local vis_mins = Vector( -3, -3, 0 )
local vis_maxs = Vector( 3, 3, 3 )
local visible_trace = { mask = MASK_SOLID_BRUSHONLY, mins = vis_mins, maxs = vis_maxs }
local function CheckVisibility( pl, ent )
	
	if pl and ent then
		
		visible_trace.start = pl:GetShootPos()
		visible_trace.endpos = ent:GetShootPos()
		
		local tr = util.TraceLine( visible_trace )
		
		return not tr.Hit
	
	end
	return false
end

local spike_trace_main = { mask = MASK_SOLID_BRUSHONLY }
local function DevSpikes( pl, norm, override_pos )
	
	local dist = 1000
	local hits = 20
	
	local delay = 0.1
	
	local spacing = dist / hits
	
	spike_trace_main.start = ( override_pos or pl:GetPos() ) + vector_up * 10
	spike_trace_main.endpos = spike_trace_main.start + norm * dist
	
	local tr_main = util.TraceLine( spike_trace_main )
	
	if tr_main then
		
		local real_dist = dist * tr_main.Fraction
		local valid_hits = math.max( math.ceil( hits * tr_main.Fraction ), 1 ) // division by zero prevention :O
		
		spacing = real_dist / valid_hits
				
		for i=1, valid_hits do
			
			local pos = spike_trace_main.start + tr_main.Normal * spacing * i - tr_main.Normal * spacing / 2
			
			timer.Simple( delay * i, function()
				
				if !IsValid( pl ) then return end
				
				if pos and pl:GetBehaviour() ~= BEHAVIOUR_DUMB then
					local e = EffectData()
						e:SetOrigin( pos )
					util.Effect( "dev_spike", e )
					
					util.BlastDamage( pl, pl, pos + vector_up*40, 40, 330 )
					
				end
				
				// finish attack when last dev spike emerges
				if i and valid_hits and i == valid_hits then
					pl.SpecialAttack = nil
				end

			end )
			
			
			
		end
				
	end
	
end

local wall_trace = { mask = MASK_SOLID_BRUSHONLY }
local function WallPunch( pl, ent, norm )
	
	local pos_hit_pl
	local pos_hitnormal_pl
	local pos_hit_ent
	local pos_hitnormal_ent
	
	wall_trace.start = pl:GetPos() + vector_up * 64
	wall_trace.endpos = wall_trace.start + norm * 130
	

	local tr = util.TraceLine( wall_trace )
	
	if tr.Hit and tr.HitNormal then
		pos_hit_pl = tr.HitPos * 1
		pos_hitnormal_pl = tr.HitNormal * 1
	end
	
	wall_trace.start = ent:GetPos() + vector_up * 64
	wall_trace.endpos = wall_trace.start - norm * 130
	
	local tr = util.TraceLine( wall_trace )
	
	if tr.Hit and tr.HitNormal then
		pos_hit_ent = tr.HitPos * 1
		pos_hitnormal_ent = tr.HitNormal * 1
	end
	
	// split it into 2 just in case
	if pos_hit_pl and pos_hitnormal_pl then
		/*local e = EffectData()
			e:SetOrigin( pos_hit_pl )
			e:SetNormal( pos_hitnormal_pl )
			e:SetMagnitude( 10 )
		util.Effect( "Explosion", e, nil, nil )*/
		
		pl:PlayGesture( "range_melee_shove_2hand" )
		
		pl:EmitSound( "npc/antlion_guard/shove1.wav", 100, math.random( 70, 80 ) )
		
	end
	
	if pos_hit_ent and pos_hitnormal_ent then
		local e = EffectData()
			e:SetOrigin( pos_hit_ent )
			e:SetNormal( norm )
		util.Effect( "dev_wall_impact", e, nil, nil )
		
		local k = ent:DoKnockdown( 3, true, pl )
		k:SetRecoveryTime( 1 )
		
		ent:SetGroundEntity( NULL )
		ent:SetLocalVelocity( norm * 2100 )
		
		local rand = math.random( 3 )
		
		// throwback to 2006 coding
		local pitch = math.random( 50, 65 )
		if rand == 1 then
			EmitDSPSound( pl, "vo/citadel/br_mock04.wav", 2 / ( pitch * 0.01 ), pitch )
		elseif rand == 2 then
			EmitDSPSound( pl, "vo/citadel/br_mock06.wav", 3 / ( pitch * 0.01 ), pitch )
		elseif rand == 3 then
			EmitDSPSound( pl, "vo/citadel/br_mock07.wav", 2.5 / ( pitch * 0.01 ), pitch )
		end
		
		pl.NextSpecialAttack = CurTime() + 3.3
		
	end

end

local function SpawnPlayers( pl )
	if not pl.HeksSpawns then
		pl.HeksSpawns = {}
		
		local ent = Entity(1)
		
		
		for k, v in pairs( pillar_tops ) do
			
			local sin = math.sin( RealTime() * 0.4 ) * math.random( 200, 210 )
			local cos = math.cos( RealTime() * 0.4 ) * math.random( 200, 210 )
			
			local rand = Vector( sin, cos, 0 )
			
			local pos = v + rand
			pos.z = ent:GetPos().z + 4
			
			local b = GAMEMODE:SpawnBot( nil, "heks aid", pos, TEAM_MOB, TEAM_PLAYER, TEAM_PLAYER )
			//b:SetAngles( tbl.ang )
			b.IgnoreTeamDamage = TEAM_MOB
			b.AllowRespawn = false
			
			b:SetBehaviour( BEHAVIOUR_DEFAULT )
			
			b.NoSpawnProtection = true
			
			pl.HeksSpawns[ k ] = b
			
			//local norm = b:GetForward()//( b:GetPos() - pl:GetPos() ):GetNormal()
	
			//b.loco:JumpAcrossGap( pl:GetPos() + norm * 600, norm )
			
			//pl.HeksSpawns[ tostring( b ) ] = b
			
		end
	
	end
end

local function SetHeksReference( ent )
	game.GetWorld():SetDTEntity( 2, ent )
end

local function GetHeksReference()
	return game.GetWorld():GetDTEntity( 2 )
end

local function SetHeksHealth( am )
	game.GetWorld():SetDTInt( 2, am )
end

local function GetHeksHealth()
	return game.GetWorld():GetDTInt( 2 )
end

local function SetHeksMaxHealth( am )
	game.GetWorld():SetDTInt( 3, am )
end

local function GetHeksMaxHealth()
	return math.max( game.GetWorld():GetDTInt( 3 ), 1 ) //division by zero preventiooooon
end

local function SetHexVulnerable( bl )
	game.GetWorld():SetDTBool( 2, bl )
end

local function IsHexVulnerable()
	return game.GetWorld():GetDTBool( 2 )
end

if SERVER then
	util.AddNetworkString( "HeksSecondStage" )
else
	net.Receive( "HeksSecondStage", function(len)

		if SOG_AUTOPLAY_MUSIC then
			PLAYBACK_APPROACH = nil
			if SCENE then
				SCENE.MusicPlayback = 1
			end
			UPDATE_PLAYBACK = true
			GAMEMODE:CreateMusic( MUSIC_TYPE_NORMAL, 182642904, 50, false, 28000, 214000 )
		end
		
	end )
end

if SERVER then
	util.AddNetworkString( "HeksSay" )
else

	local names = {
		"H̸e̵k̵s̴",
		"H̶e̴k̶s̸",
		"H̵͙͠e̶̙̕k̴̙̾ṣ̶͊",
		"H̸e̸k̶s̷",
		"H̵e̶k̴s̵"
	}

	net.Receive( "HeksSay", function(len)

		local text = net.ReadString()
		
		if text then
			chat.AddText( names[ math.random( #names ) ], Color( 255, 255, 255 ), ": ", text )
		end
		
	end )
end

local function SayText( text )
	
	if text then
		net.Start( "HeksSay" )
			net.WriteString( text )
		net.Broadcast()
	end
	
end


local function StartDeathSequence( pl )
	
	local ent = Entity(1)
	
	pl.IsDying = CurTime() + 15
	
	pl.DeathSequenceDuration = 5//2
	pl.DeathSequenceTime = CurTime() + pl.DeathSequenceDuration
	pl.OverrideSpeed = 1

	pl:SetBehaviour( BEHAVIOUR_DUMB )
	
	ent:SendLua( "PLAYBACK_APPROACH = 0.1" )
	ent:SendLua( "SCENE.MusicPlayback = 0.01" )
	ent:SendLua( "UPDATE_PLAYBACK = true" )
	ent:SendLua( "GAMEMODE.HeksHUD:Remove()" )
	
	ent:SetDSP( 0 )
	
	local goal_pos = Vector( -1445.605103, -374.472443, 68.031250 )

	local norm = ( goal_pos - pl:GetPos() ):GetNormal()
	
	if pl:IsOnGround() then
		timer.Simple( 0.2, function()
			pl.loco:JumpAcrossGap( goal_pos, norm )
		end )
	else
		pl.DoFinalJump = true
	end
	
	
	SetHexVulnerable( false )
	
	GAMEMODE:UnlockAchievement( "remnant" )
	
	timer.Simple( 1, function()  SayText( "You are a fool" ) end )
	timer.Simple( 4, function()  SayText( "It is not supposed to end like this!" ) end )
	timer.Simple( 7, function()  SayText( "*cough*" ) end )
	timer.Simple( 10, function()  SayText( "Do you realise what will be left of gmod now?" ) end )
	timer.Simple( 15, function()  SayText( "NOT A GODDAMN THING!!!" ) end )
	
end


local attachments = { 3, 7, 8, 10 }

local heks_max_health = 900
local heks_max_health_stage_2 = 1200

function CHARACTER:OnSpawn( pl )
	
	//SetHeksReference( pl )
	
	if pl:IsNextBot() then
		pl:SetModelScale( 3, 0 )
		
		pl.GetAimVector = function( self )
			
			if self.Target and self.Target:IsValid() then
				local norm = ( self.Target:GetPos() - self:GetShootPos() ):GetNormal()
				
				local norm_ang = norm:Angle()
				
				local forw_ang = self:GetForward():Angle()
				
				forw_ang.p = norm_ang.p * 1
				
				local new_aim = forw_ang:Forward()
				
				return new_aim
			end
			
			return self:GetForward()
		end
		
	end
	
	if not HEKS_SET_HEALTH then
		SetHeksHealth( heks_max_health )
		SetHeksMaxHealth( heks_max_health )
		
		HEKS_SET_HEALTH = true
	else
		if CUR_STAGE == 4 then
			SetHeksHealth( GetHeksMaxHealth() )
		else
			SetHeksHealth( math.Clamp( GetHeksHealth() + GetHeksMaxHealth() / 3, 0, GetHeksMaxHealth() ) )
			if not HESK_SAY_FIRSTDEATH then
				timer.Simple( 1.4, function()  SayText( "Huh" ) end )
				timer.Simple( 2.5, function()  SayText( "Still respawning?" ) end )
				timer.Simple( 4, function()  SayText( "Then I'll kill you as many times as it takes" ) end )
				HESK_SAY_FIRSTDEATH = true
			end
		end
	end
	
	pl.DOTCheck = 1
	
	pl.Pursuit = Entity(1)	
	
	pl.SpotDistance = 3000
	pl.AttackDistance = 3000
	pl.ChaseDistance = 3000
	pl.OverrideRepath = 0.5
	
	pl.loco:SetJumpHeight( 250 )

	pl.IgnoreDmgType = DMG_BLAST
	
	pl.MaxSpeed = 300
	
	pl.SpawnPos = pl:GetPos()
	pl.SpawnAng = pl:GetAngles()
	
	local start_length = 18
	local end_length = 1
	
	for k, v in pairs( attachments ) do
		util.SpriteTrail( pl, v, Color( 20, 20, 20, math.random( 190, 200 ) ), true, start_length, end_length, math.Rand( 0.7, 0.9 ), 1 / ( start_length + end_length ) * 0.5, "Effects/bloodstream.vmt")
		util.SpriteTrail( pl, v, Color( 0, 0, 0, 255 ), true, start_length, end_length, math.Rand( 0.7, 0.9 ), 1 / ( start_length + end_length ) * 0.5, "Effects/fleck_cement1.vmt")
		//util.SpriteTrail( pl, v, Color( 0, 0, 0, 255 ), true, start_length, end_length, math.Rand( 0.5, 0.7 ), 1 / ( start_length + end_length ) * 0.5, "Effects/fleck_cement2.vmt")
	end
	
	//override this a bit
	if CUR_STAGE == 4 then
		pl.SpecialAttack = "awaiting"
		pl.BeginSecondStage = true
		local pillar = math.random( #pillar_tops )
		pl:SetPos( pillar_tops[ pillar ] )
		pl.LastPillar = pillar
		pl.CanFireMidAir = true
		SpawnPlayers( pl )
	end
	
end

function CHARACTER:OnClientSpawn( pl )
		
end

function CHARACTER:OnThink( pl )
	
	local ent = Entity(1)
	local norm = ( ent:GetPos() - pl:GetPos() ):GetNormal()
	
	//if pl.PathObject then
		//pl.PathObject:Draw()
	//end	
	
	pl.DontAttack = true
	
	// handle sounds
	if pl.Sounds then
		if pl.CurPlaySound then
			if pl.Sounds[ pl.CurPlaySound ] and pl.Sounds[ pl.CurPlaySound ].snd then
				
				if pl.PlaySoundTime and pl.PlaySoundTime >= CurTime() then
					pl.Sounds[ pl.CurPlaySound ].snd:PlayEx( 1, pl.CurPlayPitch or 100 )
				else
					pl.Sounds[ pl.CurPlaySound ].snd:Stop()
				end
			
			end
		end
	end
	if pl:GetBehaviour() == BEHAVIOUR_DUMB then return end
	
	if CUR_STAGE == 4 and not HEKS_NEW_MODE and ent and ent:IsValid() then
		
		SetHeksHealth( heks_max_health_stage_2 )
		SetHeksMaxHealth( heks_max_health_stage_2 )
		
		if DEATH_TOKEN and DEATH_TOKEN:IsValid() then
			DEATH_TOKEN:Remove()
		end
		
		for k,v in pairs( GAMEMODE.Characters ) do
			if v and v.Reference and v.Reference == "james" then
				GAMEMODE.Characters[ k ].OverrideDeathEffects = nil
			end
		end
		
		net.Start( "HeksSecondStage" )
		net.Broadcast()
		
		ent:ScreenFade( SCREENFADE.IN, Color( 0, 0, 0, 255 ), 0.5, 1 )
		
		GAMEMODE:SetFirstPerson( true )
		
		local k = ent:DoKnockdown( 6, true, pl )
		k:SetRecoveryTime( 4.2 )
		
		timer.Simple( 0.1, function()
			
			if ent and ent:IsValid() and ent:Alive() then
				ent:SetPos( Vector( -1841.41, -383.88, 68.03 ) )
			end

		end )
		
		
		SetHexVulnerable( false )
		
		pl.SpecialAttack = "awaiting"
		
		if pl.SpawnPos then pl:SetPos( pl.SpawnPos ) end
		if pl.SpawnAng then pl:SetAngles( pl.SpawnAng ) end
		
		pl.LastPillar = 2//#pillar_tops - 1
		
		timer.Simple( 6, function()  SayText( "What's the matter?" ) end )
		timer.Simple( 8.5, function()  SayText( "This perspective is not what you have signed up for?" ) end )
		
		HEKS_NEW_MODE = true
	end
	
	//technically this is when first dialogue ends
	if CUR_STAGE == 2 and not HEKS_HEALTHBAR and ent and ent:IsValid() then
		ent:SendLua( "CreateAlternateHUD()" )
		HEKS_HEALTHBAR = true
		
		pl:PlayGesture( "range_melee_shove_2hand" )
		pl:EmitSound( "npc/antlion_guard/shove1.wav", 100, math.random( 70, 80 ) )
		
		ent:SetGroundEntity( NULL )
		ent:SetLocalVelocity( norm * 2100 )

		util.BlastDamage( pl, pl, ent:GetPos() + vector_up*40, 40, 330 )
	end
	
	pl.SpecialAttack = pl.SpecialAttack or nil
	
	if CUR_STAGE == 2 then
		if pl.SpecialAttack and pl.SpecialAttack == "angrybullets" then
			if IsHexVulnerable() then
				SetHexVulnerable( false )
			end
		else
			if not IsHexVulnerable() then
				SetHexVulnerable( true )
			end
		end
		
		if pl.JumpKnockdown and not pl:IsOnGround() and ent:Alive() and pl:GetPos():DistToSqr( ent:GetPos() ) < 120 * 120 then
			pl.JumpKnockdown = false
			local k = ent:DoKnockdown( 2, true, pl )
			k:SetRecoveryTime( 1 )
			
			pl:PlayGesture( "range_melee_shove_2hand" )
			pl:EmitSound( "npc/antlion_guard/shove1.wav", 100, math.random( 70, 80 ) )
		
			ent:SetGroundEntity( NULL )
			ent:SetLocalVelocity( pl:GetForward() * 2100 )
		end
		
		if pl.CanDoKnockdown and pl:IsOnGround() and ent:Alive() and pl:GetPos():DistToSqr( ent:GetPos() ) < 120 * 120 and pl.SpecialAttack == "angrybullets" then
			pl.CanDoKnockdown = false
			
			local k = ent:DoKnockdown( 1, true, pl )
			k:SetRecoveryTime( 1 )
			
			pl:PlayGesture( "range_melee_shove_2hand" )
			pl:EmitSound( "npc/antlion_guard/shove1.wav", 100, math.random( 70, 80 ) )
		
			ent:SetGroundEntity( NULL )
			ent:SetLocalVelocity( pl:GetForward() * 2100 )
		end
		
	else
		if pl.HeksSpawns then
			
			local all_dead = true
			
			for k, v in pairs( pl.HeksSpawns ) do
				if v and v:IsValid() and not v.Dead then
					all_dead = false
					break
				end
			end
			
			if pl.IsDying or pl.Dead then
				SetHexVulnerable( false )
			else
				if IsHexVulnerable() then
					if not all_dead then
						SetHexVulnerable( false )
					end
				else
					if all_dead then
						pl.NextJump = CurTime() + 1.1 //1.3
						if not pl.SetDSPOnPlayer then
							ent:SetDSP( 4 )
							pl.SetDSPOnPlayer = true
						end
						SetHexVulnerable( true )
					end
				end
			end
			
		end
		
		//if IsHexVulnerable() then
			//SetHexVulnerable( false )
		//end
	end
	
	
	
	// handle getting stuck is some (tm) geometry
	pl.StuckTimer = pl.StuckTimer or 0
	
	if pl.OverrideSpeed ~= 1 and not pl:IsOnGround() then
		if pl.StuckTimer == 0 then
			pl.StuckTimer = CurTime()
		end
		if ( pl.StuckTimer + 5 ) < CurTime() and pl.StuckTimer ~= 0 then
			CheckDodging( pl )
			pl.StuckTimer = 0
		end
	else
		pl.StuckTimer = 0
	end
	
	if pl.IsDying or pl.Dead then return end
	
	if ent and ent:IsValid() then
	
		pl.loco:FaceTowards( ent:GetShootPos() )
		pl.loco:FaceTowards( ent:GetShootPos() )
		pl.loco:FaceTowards( ent:GetShootPos() )
	
		local dist = pl:GetPos():DistToSqr( ent:GetPos() )
		
		pl.NextSpecialAttack = pl.NextSpecialAttack or CurTime() + 3
		pl.NextSpecialAttackAction = pl.NextSpecialAttackAction or 0 // this one is for coldowns inside attacks
		
		
		// handle kiting behind pillars + this sort of counts as another attack type?
		pl.KiteTimer = pl.KiteTimer or 0
		if not pl.SpecialAttack and ent:Alive() and !CheckVisibility( pl, ent ) and dist < 500 * 500 then
			if pl.KiteTimer == 0 then
				pl.KiteTimer = CurTime()
			end
			if ( pl.KiteTimer + 1 ) < CurTime() and pl.KiteTimer ~= 0 then
				WallPunch( pl, ent, norm )
				pl.KiteTimer = 0
			end
		else
			pl.KiteTimer = 0
		end
		
		//stage 2 waiting on the same spot
		if pl.SpecialAttack == "awaiting" then
			pl.OverrideSpeed = 1
			if not pl.BeginSecondStage then
				
				if dist < 150 * 150 and CheckVisibility( pl, ent ) and ent:Alive() and !IsValid( ent.Knockdown ) then
					EmitDSPSound( pl, "npc/stalker/go_alert2a.wav", 7, math.random( 60, 75 ) )
					
					local e = EffectData()
						e:SetOrigin( pl:GetPos() )
						e:SetNormal( vector_up + norm )
					util.Effect( "dev_wall_impact", e, nil, nil )
					
					pl:PlayGesture( "range_melee_shove_2hand" )
					pl:EmitSound( "npc/antlion_guard/shove1.wav", 100, math.random( 70, 80 ) )
					
					local k = ent:DoKnockdown( 3, true, pl )
					k:SetRecoveryTime( 1 )
					
					ent:SetGroundEntity( NULL )
					ent:SetLocalVelocity( pl:GetForward() * 2100 )
					
					pl:SetPos( pillar_tops[ 1 ] )
					pl.LastPillar = 1
					
					pl.BeginSecondStage = true
				end
				
			else
				pl.NextJump = pl.NextJump or CurTime() + 3
				
				if pl.NextJump < CurTime() and ent:Alive() then
					local new_pillar = math.random( #pillar_tops )
					if pl.LastPillar and pl.LastPillar == new_pillar then
						new_pillar = new_pillar + 1
						if new_pillar > #pillar_tops then
							new_pillar = 1
						end
					end
					//hacky workaround as he will not be able to jump at closest pillar reliably from the ground
					if not pl.LastPillar then
						pl.LastPillar = 2//#pillar_tops - 2
					else
						pl.LastPillar = new_pillar * 1
					end

					local goal_pos = pillar_tops[ new_pillar ]
					local norm2 = ( goal_pos - pl:GetPos() ):GetNormal()
					pl.loco:JumpAcrossGap( goal_pos, norm2 )
					EmitDSPSound( pl, "npc/antlion_guard/angry"..math.random( 3 )..".wav", 6, math.random( 85, 90 ) )
					pl:EmitSound( "npc/metropolice/gear"..math.random( 2 )..".wav", 100, math.random( 80, 90 ) )
					pl.NextJump = CurTime() + 9999///( IsHexVulnerable() and 2 or 10 )
				end
				
				if pl.CanFireMidAir and not pl:OnGround() then
					pl.DontAttack = false
					pl:PrimaryAttack( true )
				//else
					//pl.DontAttack = true
				end
				
			end
		end
		
		// roar, boolet barrage
		if pl.SpecialAttack == "angrybullets" then
			
			pl.BulletBarrage = pl.BulletBarrage or 0
			
			if pl.PrepareBarrage then
				
				if pl.BulletBarrage < CurTime() then
					pl.PrepareBarrage = false
					pl.FireBarrage = true
					// fire barrage
					pl.BulletBarrage = CurTime() + math.random( 3, 4 )
				end
				
			else
				
				if pl.FireBarrage then
					
					if pl.BulletBarrage > CurTime() and ent:Alive() then
						pl.DontAttack = false
						pl:PrimaryAttack( true )
						pl.OverrideSpeed = 1
					else	
						//pl.DontAttack = true
						pl.CanDoKnockdown = false
						pl.FireBarrage = nil
						pl.SpecialAttack = nil
						pl.NextSpecialAttack = CurTime() + 3
					end		
				
				end				
			end		
			
		end
		
		if not pl.SpecialAttack  then
			
			if dist < creep_distance * creep_distance and CheckVisibility( pl, ent ) and ent:Alive() and CUR_STAGE ~= 4 then
				
				local sin = math.sin( RealTime() * 0.4 ) * ( creep_distance - 50 )
				local cos = math.cos( RealTime() * 0.4 ) * ( creep_distance - 50 )
			
				// creep around
				pl.OverrideSpeed = 100
				pl.KeepDistanceVectorOffset = Vector( sin, cos, 0 )
				
				if not pl.CreepingAround then
					pl.CreepingAround = true
				end
				
			else		
			
				if pl.CreepingAround then
					if ent:Alive() and pl.NextSpecialAttack < CurTime() and CheckVisibility( pl, ent ) and !IsValid( ent.Knockdown ) then
						pl.SpecialAttack = "angrybullets"
						
						pl:EmitSound( "npc/metropolice/gear"..math.random( 2 )..".wav", 100, math.random( 80, 90 ) )
			
						pl.OverrideSpeed = 1
						pl.loco:JumpAcrossGap( ent:GetPos() + norm * 350, norm )

						local rand = math.random( 4 )
						
						if rand ~= 1 then
							//if math.random( 2 ) == 2 then
								EmitDSPSound( pl, "vo/citadel/br_laugh01.wav", 8, math.random( 60, 75 ) )
							//else
								//EmitDSPSound( pl, "vo/npc/barney/ba_laugh02.wav", 8, math.random( 40, 50 ) )
							//end
						else
							if math.random( 2 ) == 2 then
								EmitDSPSound( pl, "vo/npc/barney/ba_bringiton.wav", 8, math.random( 40, 50 ) )
							else
								EmitDSPSound( pl, "vo/citadel/br_mock09.wav", 8, math.random( 60, 75 ) )
							end
						end
						
						pl.NextSpecialAttack = CurTime() + 3
					end
					pl.CreepingAround = false
				end
				if pl.OverrideSpeed ~= pl.MaxSpeed then
					pl.OverrideSpeed = pl.MaxSpeed * 1
				end
				if pl.KeepDistanceVectorOffset then
					pl.KeepDistanceVectorOffset = nil
				end
			end
			
		end
	
	end
	
end

function CHARACTER:OnMeleeHit( pl, hitpos, hitnormal, dir, attacker )

	// nothing here
 
	return false
end

function CHARACTER:OnBulletHit( pl, hitpos, hitnormal, dir, dmginfo, bullet ) 
	
	// jump away and throw line of dev spikes behind when shot upclose
	// flicker when shot far away, also when you are supposed to do damage
	
	if SERVER then
		if pl:GetBehaviour() == BEHAVIOUR_DUMB then return false end
		if pl.IsDying or pl.Dead then return false end
		
		local ent = Entity(1)
		
		local take_damage = bullet and bullet.Cursed and IsHexVulnerable() 
		
		if CUR_STAGE == 4 then
			take_damage = IsHexVulnerable() 
		end
		
		local norm = ( ent:GetPos() - pl:GetPos() ):GetNormal()
		
		if not pl.SpecialAttack and IsValid( ent ) and ent:Alive() then
			
			if pl.CreepingAround then// pl:GetPos():DistToSqr( ent:GetPos() ) < 600 * 600 then
			
				local norm_ang = norm:Angle()
				
				local norm_left = norm_ang * 1
				local norm_right = norm_ang * 1
				
				local rand = math.random( 2 ) == 2
				
				norm_left:RotateAroundAxis( vector_up, rand and -30 or -15 )
				norm_right:RotateAroundAxis( vector_up, rand and 30 or 15 )
				
				norm_left = norm_left:Forward()
				norm_right = norm_right:Forward()
				
				pl.SpecialAttack = "devspikes"
				
				pl.OverrideSpeed = 1
				
				if rand then
					DevSpikes( pl, norm_left )
					DevSpikes( pl, norm_right )
					DevSpikes( pl, norm )
				else
					DevSpikes( pl, norm_left, pl:GetPos() - pl:GetRight() * 90 )
					DevSpikes( pl, norm_right, pl:GetPos() + pl:GetRight() * 90 )
				
					//DevSpikes( pl, norm )
				end
				
				pl:EmitSound( "npc/metropolice/gear"..math.random( 2 )..".wav", 100, math.random( 80, 90 ) )
				
				
				EmitDSPSound( pl, "npc/antlion_guard/angry2.wav", 4, math.random( 65, 90 ) )
				
				pl.loco:JumpAcrossGap( pl:GetPos() - norm * 350 * ( take_damage and -2 or 1 ), norm )
				pl:SetDTFloat( 3, CurTime() + 2 )
				
				pl:AddGesture( ACT_GMOD_GESTURE_ITEM_THROW )
				
				pl.NextSpecialAttack = CurTime() + 3
			
			else
			
				CheckDodging( pl )
				
				//SetHeksHealth( math.Clamp( GetHeksHealth() - dmginfo:GetDamage(), 0, GetHeksMaxHealth() ) )
			
			end
			
		end
		
		if take_damage then
			SetHeksHealth( math.Clamp( GetHeksHealth() - dmginfo:GetDamage(), 0, GetHeksMaxHealth() ) )
			pl:EmitSound( "npc/metropolice/pain"..math.random( 4 )..".wav", 100, math.random( 80, 90 ) )
			
			if CUR_STAGE == 2 and GetHeksHealth() <= 0 and ent:Alive() then
				timer.Simple( 0, function()	
					if ent:Alive() then
						// just in case
						for k, v in pairs( ents.FindByClass( "sogm_bullet" ) ) do
							if v and v:IsValid() then v:Remove() end
						end
						GAMEMODE:ActivateStage( 3 ) 
						Entity(1):SendLua( "PLAYBACK_APPROACH = 0.2" )
						Entity(1):SendLua( "SCENE.MusicPlayback = 0.01" )
						Entity(1):SendLua( "UPDATE_PLAYBACK = true" )
					end
				end )
			else
				if CUR_STAGE == 2 and not pl.SpecialAttack then
					if math.random( 3 ) == 3 or GetHeksHealth() <= GetHeksMaxHealth() / 2 then
						pl.loco:JumpAcrossGap( ent:GetPos() + norm * 50, norm )
						pl:EmitSound( "npc/metropolice/gear"..math.random( 2 )..".wav", 100, math.random( 80, 90 ) )
						pl.JumpKnockdown = true
					end
				end
				
				if CUR_STAGE == 4 and ent:Alive() and not pl.IsDying and GetHeksHealth() <= 0 then
					StartDeathSequence( pl )
				end
				
			end
			
			
		end
		

	end
	
	return false
end

function CHARACTER:OnLandOnGround( pl, ground_ent )
	
	if pl.JumpKnockdown then
		pl.JumpKnockdown = false
	end
	
	if pl.IsDying or pl.Dead then
		
		if pl.DoFinalJump then
			local goal_pos = Vector( -1445.605103, -374.472443, 68.031250 )
			local norm = ( goal_pos - pl:GetPos() ):GetNormal()
			
			pl.loco:JumpAcrossGap( goal_pos, norm )
			pl.DoFinalJump = false
		else
			Entity(1):EmitSound( "npc/dog/car_impact2.wav", 100, math.random( 80, 90 ), 1, CHAN_AUTO )
		end
		return 
	end
	
	pl:EmitSound( "npc/metropolice/gear"..math.random( 3, 6 )..".wav", 100, math.random( 80, 90 ) )
	
	if pl.SpecialAttack == "angrybullets" then
		
		pl.PrepareBarrage = true
		pl.BulletBarrage = CurTime() + 1 //1.1
		pl.OverrideSpeed = 1
		
		pl.CanDoKnockdown = true
	
		//EmitDSPSound( pl, "vo/ravenholm/madlaugh0"..math.random( 2 )..".wav", 4, 50 )

	end
	
	if pl.SpecialAttack == "awaiting" then
		if pl.LastPillar then
			if not pl.CanFireMidAir then
				SpawnPlayers( pl )
				pl.CanFireMidAir = true 
				timer.Simple( 2, function()  SayText( "How nice" ) end )
				timer.Simple( 4.5, function()  SayText( "Some of these players, that you have killed..." ) end )
				timer.Simple( 6.5, function()  SayText( "They still remember what you did to them" ) end )
			end
		end
		pl.NextJump = CurTime() + ( IsHexVulnerable() and 0.15 or 4 )
	end
	
end	

function CHARACTER:OnBodyUpdate( pl )
	
	if pl:GetBehaviour() == BEHAVIOUR_DUMB and CUR_STAGE == 1 then
		pl:SetSequence("sit_zen")
	end
	
	if pl.IsDying or pl.Dead then 
		
		if pl.DeathSequenceDuration and pl.DeathSequenceTime then
			
			if pl.IsDying <= CurTime() then
				if not pl.SecondDeathPart then
					pl.DeathSequenceDuration = 1.5
					pl.DeathSequenceTime = CurTime() + pl.DeathSequenceDuration
					pl.SecondDeathPart = true
					EmitDSPSound( pl, "npc/fast_zombie/fz_scream1.wav", 6, math.random( 75, 85 ) )
				end
				
				local delta = math.Clamp( 1 - ( pl.DeathSequenceTime - CurTime() ) / pl.DeathSequenceDuration, 0, 1 )// * 0.37
				pl:SetCycle( delta + math.Rand( -0.04, 0.04 ) )
				pl:SetSequence( "seq_preskewer" )
			else
				local delta = math.Clamp( 1 - ( pl.IsDying - CurTime() ) / pl.DeathSequenceDuration, 0, 1 ) * 0.42// * 0.63
				pl:SetCycle( 0.44 + delta + math.sin( RealTime() * 0.2 ) * 0.01 )
				pl:SetSequence( "zombie_slump_rise_01" )
			end
			
			if pl.SecondDeathPart and pl.DeathSequenceTime <= CurTime() and not pl.Dead then
				pl.Dead = true
				local e = EffectData()
					e:SetOrigin( pl:GetPos() )
					e:SetEntity( pl )
				util.Effect( "dev_death", e )
				EmitDSPSound( pl, "npc/stalker/go_alert2a.wav", 7, math.random( 85, 90 ) )
				timer.Simple( 4, function()
					
					local ent = Entity(1)
					
					if ent and ent:IsValid() and ent:Alive() then
						ent:Freeze( true )
						ent:SendLua( "DrawEnding()" )
					end

				end )
			end
			
		end
		
	end

end


function CHARACTER:TranslateActivity( pl, act )
	
	if not pl.CrouchAnim then
		pl.CrouchAnim = pl:GetSequenceActivity( pl:LookupSequence( "pose_ducking_01" ) ) 
	end
	
	if pl.SpecialAttack and ( pl.SpecialAttack == "devspikes" or pl.SpecialAttack == "awaiting" ) and pl:OnGround() and pl.CrouchAnim then
		return pl.CrouchAnim
	end
	
	local tbl = NewActivityTranslate
	
	if tbl[ act ] ~= nil then
		return tbl[ act ]
	end

	return -1
end

function CHARACTER:OnRemove( pl )
	if CLIENT and pl.Emitter then
		pl.Emitter:Finish()
	end
	if SERVER then
		if pl.Sounds then
			for k, v in pairs( pl.Sounds ) do
				if v and v.snd then
					v.snd:Stop()
				end
			end
		end
	end
end

if CLIENT then
local texturizer_mat = Material( "pp/texturize/obra.png" )
local mat_beam = Material( "Effects/bloodstream" )
local mat_beam_alpha = CreateMaterial( 
	"heks_energy", 
	"UnlitGeneric", 
	{
		["$basetexture"] = "effects/bloodstream", 
		["$vertexcolor"] = 1,
		["$alphatest"] = 1,
	}
)

local mat_glass1 = CreateMaterial( 
	"heks_energy_bit1", 
	"UnlitGeneric", 
	{
		["$basetexture"] = "effects/fleck_glass1", 
		["$translucent"] = 1,
		["$vertexcolor"] = 1,
		["$alphatest"] = 1,
		["$nocull"] = 1,
	}
)

local mat_glass2 = CreateMaterial( 
	"heks_energy_bit2", 
	"UnlitGeneric", 
	{
		["$basetexture"] = "effects/fleck_glass2", 
		["$translucent"] = 1,
		["$vertexcolor"] = 1,
		["$alphatest"] = 1,
		["$nocull"] = 1,
	}
)

local mat_glass3 = CreateMaterial( 
	"heks_energy_bit3", 
	"UnlitGeneric", 
	{
		["$basetexture"] = "effects/fleck_glass3", 
		["$translucent"] = 1,
		["$vertexcolor"] = 1,
		["$alphatest"] = 1,
		["$nocull"] = 1,
	}
)

local beam_table = {
	//spine4 - right hand
	[1] = { 4, 8, 9, 10, 11 },
	
	//spine4 - left hand
	[2] = { 4, 13, 14, 15, 16 },
	
	//spine4 - pelvis
	[3] = { 5, 4, 3, 2, 1, 0 },
	
	//spine4 - pelvis, second pass
	[4] = { 5, 4, 3, 2, 1, 0 },
	
	//spine2 - right leg
	[5] = { 3, 2, 1, 0, 18, 19, 20 },
	
	//spine2 - left leg
	[6] = { 3, 2, 1, 0, 22, 23, 24 },
	
	//spine4 - right hand
	[7] = { 4, 8, 9, 10, 11 },
	
	//spine4 - left hand
	[8] = { 4, 13, 14, 15, 16 },

}

local vec_rand = VectorRand
local math_random = math.random
local col_glow = Color( 50, 50, 50, 255 )
local col_glow_red = Color( 130, 10, 10, 255 )

local goop_mat = CreateMaterial( "coffin3",
    "VertexLitGeneric",
    {
        ["$basetexture"] = "Models/flesh",
        ["$bumpmap"] = "models/flesh_nrm",
        ["$nodecal"] = "0",
        ["$halflambert"] = 1,
        ["$translucent"] = 1,
        ["$model"] = 1,

        ["$detail"] = "Models/flesh",
        ["$detailscale"] = 1.2,
        ["$detailblendfactor"] = 7,
        ["$detailblendmode"] = 3,

        ["$phong"] = "1",
        ["$phongboost"] = "5",
        ["$phongfresnelranges"] = "[10 3 10]",
        ["$phongexponent"] = "500"
    }
)

local mat_flesh = Material( "models/shiny" )

local backflip_ang = 0
local bounds_mins = Vector( -2000, -2000, -200 )
local bounds_maxs = Vector( 2000, 2000, 500 )

local render_SetStencilReferenceValue = render.SetStencilReferenceValue
local render_SetStencilCompareFunction = render.SetStencilCompareFunction
local render_SetStencilPassOperation = render.SetStencilPassOperation
local render_SetStencilZFailOperation = render.SetStencilZFailOperation
local render_SetStencilFailOperation = render.SetStencilFailOperation
local render_SetStencilWriteMask = render.SetStencilWriteMask
local render_SetStencilTestMask = render.SetStencilTestMask
local render_ClearStencil = render.ClearStencil
local render_SetStencilEnable = render.SetStencilEnable

local math_Rand = math.Rand
local math_random = math.random
local math_Clamp = math.Clamp

local render_SetMaterial = render.SetMaterial
local render_DrawBeam = render.DrawBeam

function CHARACTER:OnDraw( pl )
	
	if pl:GetRenderMode() == RENDERMODE_NONE then 
		if pl.WElements and pl.WElements["m4"] then
			pl.WElements["m4"].color.a = 0
		end
		return 
	end
	
	if not pl.SetBounds then
		pl:SetRenderBounds( bounds_mins, bounds_maxs )
		pl:SetLOD( 0 )
		pl.SetBounds = true
	end
	
	pl.HideWeapon = true
	
	if not pl.Emitter then 
		pl.Emitter = ParticleEmitter( pl:GetPos(), true ) 
		pl.Emitter:SetNoDraw( true ) 
	end
	
	local emitter = pl.Emitter
	
	pl.NextEmit = pl.NextEmit or 0
	
	local dodge = pl:GetDTFloat( 2 ) >= CurTime()
	local dodge_blend = math_Clamp( ( pl:GetDTFloat( 2 ) - CurTime() ) / 0.4, 0, 1 )
	
	
	//local am = pl:GetDTFloat( 2 ) >= CurTime() and math.random( 10, 26 ) or 1
	
	if emitter and pl.NextEmit < CurTime() then
		local pos = pl:GetShootPos()
		
		
			local particle = emitter:Add( "!heks_energy_bit"..math_random( 3 ), pos + vec_rand() * 12 )//
			particle:SetVelocity( vec_rand() * math_random( 20, 30 ) )
			particle:SetAngles( vec_rand():Angle() )
			particle:SetDieTime( math_random( 2, 5 ) )
			particle:SetStartAlpha( 255 )
			particle:SetEndAlpha(0)
			particle:SetStartSize( math_random( 4, 8 ) )
			particle:SetEndSize( 0 )
			if GAMEMODE:GetFirstPerson() and IsHexVulnerable() then
				particle:SetColor( 229, 25, 25 )
			else
				particle:SetColor( 150, 150, 150 )
			end
			particle:SetRoll( math_random( -180, 180 ) )
			particle:SetRollDelta( math_random( -90, 90 ) )
			particle:SetCollide( true )
			particle:SetAirResistance( 50 )
			particle:SetGravity( vector_up * -20 )
		pl.NextEmit = CurTime() + 0.2//math_Rand( 0.1, 0.4 )
	end	
				
	render_SetStencilReferenceValue( 0 )
	render_SetStencilCompareFunction( STENCIL_ALWAYS )
	render_SetStencilPassOperation( STENCIL_KEEP )
	render_SetStencilZFailOperation( STENCIL_KEEP )
	render_SetStencilFailOperation( STENCIL_KEEP )
	
	render_SetStencilWriteMask( 0xFF )
	render_SetStencilTestMask( 0xFF )
	
	render_ClearStencil()
	render_SetStencilEnable(true)
	
	render_SetStencilCompareFunction( STENCIL_ALWAYS )
	render_SetStencilPassOperation( STENCIL_REPLACE )
	render_SetStencilFailOperation( STENCIL_KEEP )
	render_SetStencilZFailOperation( STENCIL_KEEP )
	
	render_SetStencilReferenceValue( 1 )
	
	emitter:Draw()
	
	render_SetMaterial( mat_beam_alpha )
	
	local rand = vec_rand()
	
	for k=1, #beam_table do
		if beam_table[k] then
			
			local tex_offset
		
			for i=2, #beam_table[k] do
				if beam_table[k][i] then
					local start_pos, start_ang = pl:GetBonePosition( beam_table[k][i-1] )
					local pos, ang = pl:GetBonePosition( beam_table[k][i] )
					
					if start_pos and start_ang and pos and ang then
						tex_offset = tex_offset or RealTime()*0.6
						
						render_DrawBeam( pos + rand * i * 0.3, start_pos + rand * i * 0.2, 22, tex_offset, tex_offset + 0.7, GAMEMODE:GetFirstPerson() and IsHexVulnerable() and col_glow_red or col_glow )
							
						tex_offset = tex_offset + 0.3					
					end
				end
			end
		end
	end
	
	render.SetColorModulation( 0.2, 0.2, 0.2 )
	render.SetBlend( 1 )
	
	if pl.WElements and pl.WElements["m4"] then
		if GAMEMODE:GetFirstPerson() and IsHexVulnerable() then
			pl.WElements["m4"].color.r = 229
			pl.WElements["m4"].color.g = 25
			pl.WElements["m4"].color.b = 25
		else
			pl.WElements["m4"].color.r = 255
			pl.WElements["m4"].color.g = 255
			pl.WElements["m4"].color.b = 255
		end
	end
	
	if dodge then 
		goop_mat:SetFloat( "$detailscale", 0.4 + 4 * dodge_blend )
		render.MaterialOverride( goop_mat )
	else
		if GAMEMODE:GetFirstPerson() and IsHexVulnerable() then
			render.MaterialOverride( mat_flesh )
			render.SetColorModulation( 0.9, 0.1, 0.1 )
			render.SuppressEngineLighting( true )
		else
			render.MaterialOverride()
		end
	end
	
end

local drawTexturize = DrawTexturize
function CHARACTER:PostDraw( pl )

	if pl:GetRenderMode() == RENDERMODE_NONE then return end

	if GAMEMODE:GetFirstPerson() and IsHexVulnerable() then
		render.SuppressEngineLighting( false )
	end

	render.MaterialOverride()
	render.SetBlend( 1 )
	render.SetColorModulation( 1, 1, 1 )

	render_SetStencilCompareFunction( GAMEMODE:GetFirstPerson() and IsHexVulnerable() and STENCIL_NOTEQUAL or STENCIL_EQUAL )
	render_SetStencilPassOperation( STENCIL_REPLACE )

	drawTexturize( 32, texturizer_mat )
	
	render_SetStencilEnable( false )
end

local draw_SimpleText = draw.SimpleText

local col_shadow = Color( 10, 10, 10, 185 )
local col_shadow_dark = Color( 10, 10, 10, 255 )
local col_text = Color( 220, 220, 220, 255 )

local name_glitch = 0
local cached_health_delta = 0
function CreateAlternateHUD()
		
	if GAMEMODE.HeksHUD then
		GAMEMODE.HeksHUD:Remove()
		GAMEMODE.HeksHUD = nil
	end
	
	GAMEMODE.HeksHUD =  vgui.Create( "DPanel" )
	GAMEMODE.HeksHUD:SetPos( 0, 0 )
	GAMEMODE.HeksHUD:SetSize( ScrW(), ScrH() )
	GAMEMODE.HeksHUD:SetKeyboardInputEnabled( false )
	GAMEMODE.HeksHUD:SetMouseInputEnabled( false ) 
	
	GAMEMODE.HeksHUD.Paint = function( self, w, h )
		
		// ammo
		
		local MySelf = LocalPlayer()
		
		local x, y = 60 , h - 70
		
		local wep = IsValid(MySelf:GetActiveWeapon()) and MySelf:GetActiveWeapon()
		
		if wep then
			
			local text = wep:Clip1().." rnds"
			local ammo_delta = math_Clamp( 1 - wep:Clip1() / wep.Primary.ClipSize, 0, 1 )
			
			local shake_x = math_Rand( -3 * ammo_delta - 0.1, 3 * ammo_delta + 0.1 )
			local shake_y = math_Rand( -3 * ammo_delta - 0.1, 3 * ammo_delta + 0.1 )
			
			local shadow_text = string.char( math_random( 30, 80 ), math_random( 30, 80 ), math_random( 30, 80 ), math_random( 30, 80 ), math_random( 30, 80 ) )
		
			draw_SimpleText( shadow_text, "Scene", x - 3 + shake_x * 14, y + 3 + shake_y * 14, col_shadow, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw_SimpleText( text, "PixelCutsceneScaled", x + 3, y + 3, col_shadow_dark, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw_SimpleText( text, "PixelCutsceneScaled", x + shake_x, y + shake_y, col_text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			
		end
		
		
		// boss healthbar
		
		local boss_header = "H̴e̸k̵s̶,̴ ̵T̴h̴e̴ ̸S̶a̵v̵i̴o̵r̶ ̷o̶f̶ ̵G̷M̴o̸d̷"
		
		if math_random( 300 ) == 300 and name_glitch < CurTime() then
			name_glitch = CurTime() + 0.4
		end
		
		if name_glitch >= CurTime() then
			boss_header = "H̴e̸k̵s̶,̴ ̵T̴h̴e̴ ̵D̴e̴a̶t̴h̷ ̷o̶f̶ ̵G̷M̴o̸d̷"
		end
		local boss_health_text = "|"
		local boss_health_lock_text = ""
		
		local max_health = GetHeksMaxHealth() or 100
		local cur_health = GetHeksHealth() or 100
		
		local health_delta = math_Clamp( cur_health / max_health, 0, 1 )
		
		cached_health_delta = Lerp( 0.05, cached_health_delta, health_delta )
		
		local chars = 40
		local req_chars = math.Round( cached_health_delta * chars, 1 )
		
		//print( "delta "..cached_health_delta )
		//print(req_chars)
		
		for i=1, chars do
			if i <= req_chars then
				boss_health_text = boss_health_text.."/"
				boss_health_lock_text = boss_health_lock_text.."\\"
			else
				boss_health_text = boss_health_text.."_"
				boss_health_lock_text = boss_health_lock_text.."_"
			end
			
		end
		
		boss_health_text = boss_health_text.."|"
		
		x, y = w/2, h - 70
		
		local shake_x = math_Rand( -1, 1 )
		local shake_y = math_Rand( -1, 1 )
		
		if not IsHexVulnerable() then
			shake_x = shake_x * 3
			shake_y = shake_y * 3
		end
		
		
		local shadow_text = ""
		
		//for i=1, chars * 0.4 do
		//	shadow_text = shadow_text..string.char( math.random( 30, 80 ) )
		//end

		//draw_SimpleText( shadow_text, "Scene", x + shake_x, y + shake_y * 20, col_shadow, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
		//draw_SimpleText( boss_health_text, "PixelSmall", x + 2 + shake_x, y - 2 + shake_y, col_shadow, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw_SimpleText( boss_health_text, "PixelSmall", x + 2 + shake_x, y + 2 + shake_y, col_shadow, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw_SimpleText( boss_health_text, "PixelSmall", x + shake_x, y + shake_y, IsHexVulnerable() and col_text or col_shadow, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
		if not IsHexVulnerable() then
			draw_SimpleText( boss_health_lock_text, "PixelSmall", x + 2 + shake_x, y + 2 + shake_y, col_shadow, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw_SimpleText( boss_health_lock_text, "PixelSmall", x + shake_x, y + shake_y, col_shadow, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		
		local tw, th = surface.GetTextSize( boss_health_text )
		
		x = x - tw/2
		y = y - th
		
		//draw_SimpleText( boss_header, "PixelSmall", x + 2 + shake_y, y - 2 + shake_x, col_shadow, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw_SimpleText( boss_header, "PixelSmall", x + 2 + shake_y, y + 2 + shake_x, col_shadow, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw_SimpleText( boss_header, "PixelSmall", x + shake_y, y + shake_x, col_text, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		
		
	end
	
	
end

end
