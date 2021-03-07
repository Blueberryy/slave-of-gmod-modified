GM.Gametypes = GM.Gametypes or {}

if SERVER then
	//bot multiplier per additional player
	NEMESIS_BOT_MULTIPLIER = CreateConVar("sog_nemesis_bot_multiplier", 0.2, FCVAR_ARCHIVE + FCVAR_NOTIFY, "Amount of bots = original amount + (original amount) * this_convar per additional player.."):GetFloat()
	cvars.AddChangeCallback("sog_nemesis_bot_multiplier", function(cvar, oldvalue, newvalue)
		NEMESIS_BOT_MULTIPLIER = newvalue
	end)
end

function GM:CoOpInitialize()

	
	GAMEMODE.UseCharacters = { "pr1", "pr2", "pr3", "pr4" }
	
	GAMEMODE.GametypeName = translate.Get("sog_gametype_name_nemesis")

	print"Gametype Initialized"
	
	TEAM_EVIL = 6
	TEAM_MAIN = 7

	team.SetUp(TEAM_EVIL, "The Evil", Color(0,164,233,255))
	team.SetUp(TEAM_MAIN, "Protagonists", color_white)
	
	function self:PlayerShouldTakeDamage(pl, attacker)
		if attacker.Team then
			if pl:Team() == attacker:Team() then
				return false
			end 
		end
		return true
	end
	
	if SERVER then
	
		team.SetSpawnPoint( TEAM_EVIL, "info_player_main" )
		team.SetSpawnPoint( TEAM_MAIN, "info_player_mob" )
	
		BOT_CLASS = "pr1"
		DEFAULT_CHARACTER = "pr1"
		
		WAVES = {}
		
		local function AddWave( num, tab )
			WAVES[ num or #WAVES+1 ] = tab
		end
		
		//test wave
		/*AddWave( nil, { 
						{ char = "banned", am = function() return math.random(3,4) end },
					})*/
		
		//wave1
		AddWave( nil, { 
						{ char = "greed crew default", am = function() return math.random(3, 4) end },
						{ char = "greed crew starter", am = function() return math.random(1, 2) end },
						{ char = "greed crew trusted", am = function() return math.random(3, 4) end , cap = 10 },
						{ char = "banned", am = function() return math.random(1, 2) end },
					})
		//wave 2
		AddWave( nil, { 
						{ char = "greed crew default", am = function() return math.random(3, 4) end },
						{ char = "greed crew starter", am = function() return math.random(1, 2) end },
						{ char = "greed crew trusted", am = function() return math.random(3, 4) end, cap = 10 },
						{ char = "greed crew shield", am = function() return 2 end, cap = 4 },
						{ char = "banned", am = function() return math.random(2, 3) end },
					})
		//wave 3
		AddWave( nil, { 
						{ char = "greed crew default", am = function() return math.random(2, 3) end },
						{ char = "greed crew starter", am = function() return math.random(1, 2) end },
						{ char = "greed crew trusted", am = function() return math.random(2, 3) end, cap = 10 },
						{ char = "greed crew shield", am = function() return 2 end, cap = 3 },
						{ char = "greed crew featured", am = function() return math.random(1, 2) end, cap = 3 },
						{ char = "banned", am = function() return math.random(3, 4) end },
					})
		//wave 4
		AddWave( nil, { 
						{ char = "banned", am = function() return math.random(3, 4) end },
						{ char = "greed crew starter", am = function() return math.random(2, 3) end },
						{ char = "greed crew trusted", am = function() return math.random(1, 2) end, cap = 5 },
						{ char = "greed crew premium", am = function() return math.random(1, 2) end, cap = 8 },
						{ char = "greed crew shield", am = function() return 2 end, cap = 3 },
						{ char = "greed crew featured", am = function() return math.random(1, 2) end, cap = 3 },
						{ char = "greed crew thug", am = function() return math.random(1,2) end },
					})
					
		//wave 5
		AddWave( nil, { 
						{ char = "banned", am = function() return math.random(3, 5) end },
						{ char = "greed crew starter", am = function() return math.random(1, 2) end },
						{ char = "greed crew premium", am = function() return math.random(3, 4) end, cap = 8 },
						{ char = "greed crew shield", am = function() return math.random(2, 3) end, cap = 3 },
						{ char = "greed crew featured", am = function() return math.random(1, 2) end, cap = 3 },
						{ char = "greed crew thug", am = function() return 2 end },
						{ char = "greed crew bitch", am = function() return math.random(1, 2) end, cap = 4 },
					})
		//wave 6			
		AddWave( nil, { 
						{ char = "banned", am = function() return math.random(2, 3) end },
						{ char = "greed crew starter", am = function() return math.random(2, 3) end },
						{ char = "greed crew premium", am = function() return math.random(2, 3) end, cap = 8 },
						{ char = "greed crew shield", am = function() return 3 end, cap = 3 },
						{ char = "greed crew featured", am = function() return math.random(1, 2) end, cap = 5 },
						{ char = "greed crew thug", am = function() return 3 end, cap = 6 },
						{ char = "greed crew bitch", am = function() return 1 end, cap = 4 },
						{ char = "greed crew leaker", am = function() return math.random(2, 3) end },
						{ char = "greed crew moderator", am = function() return 1 end, cap = 1 },
					})
		
		//progress will save AFTER these wave
		CHECKPOINTS = { 1, 2, 3, 4, 5, 6 }
		CHECKPOINT_WAVE = 1
		
		WAVE_INTERMISSION = 5
		
		CUR_WAVE_PLAYERS = 0
		
		//experimental
		USE_LIVES = false
		
		GENERATED_WAVES = {}
		GENERATED_BOTS_TOTAL_COUNT = {}
		ACTIVE_BOTS = {}
		ACTIVE_BOTS_TOTAL = 0
		BOTS_TOTAL = 0
		
		PICKUP_REMOVE_TIME = 7
		
		//distance between spawns that is used as template (sog_greed_v2)
		MAP_DISTANCE_DEFAULT = 2251
		
		MAP_MUL_MIN = 0.8
		MAP_MUL_MAX = 1.7
		
		EVIL_SPAWNPOINTS = {}
		//EVIL_SPAWNPOINTS_VECTORS = {}
		
		DISABLE_TEAM_PUNCHING = true
		
		//BOT_IGNORE_CLASS = true
		
		JOIN_TIME = 30
		
		CUR_WAVE = 1
				
		function self:SetWave( num )
			game.GetWorld():SetDTInt( 0, num )
		end
		
		function self:GetBotMultiplier( amount )
			
			local newam = amount
			
			for i=1, math.max( team.NumPlayers( TEAM_MAIN ) - 1, 0 ) do
				newam = newam + newam * NEMESIS_BOT_MULTIPLIER
			end
			return math.ceil( newam * (MAP_MULTIPLIER or 1) )
			//return math.max( team.NumPlayers( TEAM_MAIN ) - 1, 0 ) * NEMESIS_BOT_MULTIPLIER
		end
		
		function self:GenerateWaves()
			
			if not WAVES or not GENERATED_WAVES then return end
			
			for num, wavetab in ipairs( WAVES ) do
				GENERATED_WAVES[ num ] = {}
				GENERATED_BOTS_TOTAL_COUNT[ num ] = 0
				for i, enemytab in ipairs( wavetab ) do
					local amount = enemytab.am()
					GENERATED_WAVES[ num ][i] = { char = enemytab.char, am = amount, cap = enemytab.cap or 999 }
					GENERATED_BOTS_TOTAL_COUNT[ num ] = GENERATED_BOTS_TOTAL_COUNT[ num ] + amount
				end
			end
			
		end
		
		function self:GetDesiredBotAmount( wave )
			
			local count = 0
			
			if not GENERATED_WAVES[ wave ] then return 0 end
			
			for i, enemy in ipairs( GENERATED_WAVES[ wave ] ) do
				count = count + math.min( self:GetBotMultiplier( enemy.am ), enemy.cap or 999 )
			end
			
			return count
			
		end
		
		function self:GametypeOnChangeChar( pl, char, oldchar )
		
			//pl.CheckCharacter = true
			
		end
		
		function self:SelectMainCharacter( pl )
		
			
			//if !pl.CheckCharacter then return end
			
			
			local protagonists = team.GetPlayers( TEAM_MAIN )
			local random = false
			
			
			for k, v in ipairs( protagonists ) do
				if v and v:IsValid() and v ~= pl and self:GetCharacterReferenceById( v:GetCharacter() ) == pl.StoreCharacterPref then
					//so we can switch when both players are dead
					//both players are dead or one is dead and other one wants another character anyway
					if !pl:Alive() and !v:Alive() or !pl:Alive() and pl.StoreCharacterPref ~= v.StoreCharacterPref then continue end
					random = true
					break
				end
			end
			
			if random then
				for k, v in ipairs ( self.UseCharacters ) do
					local free = true
					
					for _, j in ipairs( protagonists ) do
						if j and j:IsValid() and j ~= pl and self:GetCharacterReferenceById( j:GetCharacter() ) == v then
							free = false
						end
					end	
					
					if free then
						pl.CharacterPref = v
						//not sure why this was enabled in a first place
						//pl.StoreCharacterPref = v
						break
					end
				end
			else
				pl.CharacterPref = pl.StoreCharacterPref
			end
				
			//pl.CheckCharacter = false
					
		end
		
		function team.GetJoinableTeam()
			
			local t1 = team.GetPlayers( TEAM_MAIN )
			
			local result = TEAM_SPECTATOR
			
			if #t1 < 4 then
				result = TEAM_MAIN
			end
			
			return result
			
		end
		
		function team.GetAlivePlayers( team_id )
			
			local alive = {}
			
			local players = team.GetPlayers( team_id )
			
			for k,v in ipairs( players ) do
				if v and v:IsValid() and v:Alive() then
					table.insert( alive, v )
				end
			end
			
			return alive
			
		end
		
		function self:OnPlayerAuthed(pl)
			pl:SendLua("GAMEMODE:CoOpInitialize()")
		end
		
		
		function self:RoundStart()
			
			//ROUNDTIME = CurTime()
			self:SetRoundTime( CurTime() )
			
			self:SetRoundState( ROUNDSTATE_IDLE )
			
			//self:SpawnBots()
			//self:WaveStart()
			
			//CUR_WAVE = CUR_WAVE + 1
			
		end
		
		function self:RoundEnd()
			
			if self:GetRoundState() == ROUNDSTATE_RESTARTING then return end
					
			self:SetRoundState( ROUNDSTATE_RESTARTING )
			
			self:RestartRoundIn( 5 )

		end
		
		function self:RestartRound( args )
			
			self:ResetWaves( args )
			self:RoundStart()
			self:ResetMap()
			
			self:RemoveRDMBots()
			
			for k, v in pairs(player.GetAll()) do
				if v:Team() == TEAM_SPECTATOR or v:Team() == TEAM_CONNECTING then continue end
				v.CheckCharacter = true
				self:PlayerInitialSpawn(v)
				v:Spawn()
			end
			
		end
		
		function self:ResetWaves( fullreset )
			
			if fullreset then
				CUR_WAVE = 1
				CHECKPOINT_WAVE = 1
				self:SetWave( CUR_WAVE )
				return
			end
			
			CUR_WAVE = CHECKPOINT_WAVE
			self:SetWave( CUR_WAVE )
		end
		
		function self:WaveStart()
			
			if self:GetRoundState() == ROUNDSTATE_RESTARTING or self:GetRoundState() == ROUNDSTATE_END then return end
			
			self:SetWave( CUR_WAVE )
			
			for k, v in ipairs(player.GetAll()) do
				v:ChatPrint( "-- Wave "..CUR_WAVE.." has begun!" )
				v.BotsKilled = 0
			end
			
			//if at least one stays alive and finishes the wave - respawn the protagonists
			if CUR_WAVE > 1 then
				//if #team.GetAlivePlayers( TEAM_MAIN ) > 0 then
					local alive = false
			
					for _, p in ipairs( team.GetPlayers( TEAM_MAIN ) ) do
						if p and p:IsValid() and p:Alive() then
							alive = true
							break
						end
					end
					
					if alive then
						for k, v in ipairs( team.GetPlayers( TEAM_MAIN ) ) do
							if v and v:IsValid()then
								if !v:Alive() then
									v:UnSpectate()
									v:Spawn()
								else
									v:ConCommand( "r_cleardecals" )
									v:CleanBodies()
								end
								v.Lives = 3
							end
						end
					end
				//end
			end
			
			//timer.Simple(1, function()
				self:SpawnBots()
			//end)
			
		end
		
		function self:WaveComplete()
			
			local checkpoint = false
			
			if table.HasValue( CHECKPOINTS, CUR_WAVE ) then
				CHECKPOINT_WAVE = CUR_WAVE + 1
				checkpoint = true
			end
			
			local final = CUR_WAVE == #WAVES
			
			for k, v in ipairs(player.GetAll()) do
				if final then
					v:ChatPrint( "-- Final wave completed. But was it truly a final one?" )
				else
					v:ChatPrint( "-- Wave "..CUR_WAVE.." completed." )
					if checkpoint then
						v:ChatPrint( "-- You have reached a checkpoint!" )
					end
					if v:Team() == TEAM_MAIN then
						v:ShowHugeMessage( "Wave Clear" )
					end
				end
			end
			
			if final then
				self:SetRoundState( ROUNDSTATE_RESTARTING )		
				self:ShowLevelClear()

				timer.Simple( 5, function()
					self:StartVoting( VOTING_TIME )
				end)
			else
				CUR_WAVE = CUR_WAVE + 1
				
				timer.Simple( WAVE_INTERMISSION, function()
					self:WaveStart()
				end)
			end
			
			
			
		end
		local math = math
		
		function self:SpawnBots( torespawn, recalculate )
			
			if not GENERATED_WAVES then return end
								
			if #player.GetAll() <= 0 then return end
			
			if not GENERATED_WAVES[ CUR_WAVE ] then return end
			
			if not EVIL_SPAWNPOINTS_VECTORS then
			
				EVIL_SPAWNPOINTS_VECTORS = {}
				
				for k,v in ipairs(INFO_PLAYER_MAIN) do
					table.Add( EVIL_SPAWNPOINTS_VECTORS, self:GetSpotsAroundPos( v:GetPos(), 400, false ) )
				end
				
				//if #EVIL_SPAWNPOINTS_VECTORS < 1 then
					for k,v in ipairs( INFO_PLAYER_MAIN ) do
						table.insert( EVIL_SPAWNPOINTS_VECTORS, v:GetPos() )
					end
				//end
				
				if not MAP_MULTIPLIER then
					local dist = self:DistanceBetweenAverageVectors( INFO_PLAYER_MOB, EVIL_SPAWNPOINTS_VECTORS, true, false )
					MAP_MULTIPLIER = math.Round( math.Clamp( math.Round(dist)/MAP_DISTANCE_DEFAULT, MAP_MUL_MIN, MAP_MUL_MAX), 1 )
					
					//print("dist: "..dist)
					//print("default: "..MAP_DISTANCE_DEFAULT)
					print("Current map multiplier: "..MAP_MULTIPLIER)
					
				end
				
			end
			
			local spawns = EVIL_SPAWNPOINTS_VECTORS//EVIL_SPAWNPOINTS
			local ct = CurTime()
			
			local respawned = 0
			local spawnpoint = 1
			
			if torespawn then

				for i, enemy in ipairs( GENERATED_WAVES[ CUR_WAVE ] ) do
					
					local char = enemy.char
					//local am = enemy.am + math.Round( enemy.am * self:GetBotMultiplier() )
					local am = math.min( self:GetBotMultiplier( enemy.am ), enemy.cap or 999 )
					
					if respawned >= torespawn then break end
					
					
					if ACTIVE_BOTS[ char ] and ACTIVE_BOTS[ char ] < am and respawned < torespawn then
						
						for _ = 1, math.min( am - ACTIVE_BOTS[ char ], torespawn ) do

							local pos 
							local spawn = spawns[ spawnpoint ]
							
							pos = spawn
						
							spawnpoint = spawnpoint + 1
														
							if spawnpoint > #spawns then
								spawnpoint = 1
							end
																									
							local b = self:SpawnBot( nil, char, pos, TEAM_EVIL, TEAM_MAIN, nil )
							b.CharacterReference = char
							b.IgnoreTeamDamage = TEAM_EVIL
							b.AllowRespawn = false
							b.IdleSpeed = b.WalkSpeed / 2
							b.SpawnProtection = ct + 5
							
							b:ShowSpawnProtectionEffect( 5 )
							
							b.StuckPositions = EVIL_SPAWNPOINTS_VECTORS
							
							if team.NumPlayers( TEAM_MAIN ) > 0 then
								b.GoalTable = team.GetPlayers( TEAM_MAIN )
							end
							
							//record him
							ACTIVE_BOTS[ char ] = ACTIVE_BOTS[ char ] + 1
							
							ACTIVE_BOTS_TOTAL = ACTIVE_BOTS_TOTAL + 1
							
							//increase max amount, because other player joined
							if recalculate then
								BOTS_TOTAL = BOTS_TOTAL + 1
							end
							
							respawned = respawned + 1
							
							if respawned >= torespawn then break end
							
						end
					
					end
				end
			
			else
	
				self:RemoveRDMBots()
	
				table.Empty( ACTIVE_BOTS )
				
				ACTIVE_BOTS_TOTAL = 0
				BOTS_TOTAL = 0
				
				for i, enemy in ipairs( GENERATED_WAVES[ CUR_WAVE ] ) do
					
					local char = enemy.char
					//local am = enemy.am + math.Round( enemy.am * self:GetBotMultiplier() )
					local am = math.min( self:GetBotMultiplier( enemy.am ), enemy.cap or 999 )
					
					if not ACTIVE_BOTS[ char ] then ACTIVE_BOTS[ char ] = 0 end
					
					for _ = 1, am do
						
						//spawn bot
						local pos 
						local spawn = spawns[ spawnpoint ]
						
						pos = spawn
						
						spawnpoint = spawnpoint + 1
						
						if spawnpoint > #spawns then
							spawnpoint = 1
						end
										
						local b = self:SpawnBot( nil, char, pos, TEAM_EVIL, TEAM_MAIN, nil )
						b.CharacterReference = char
						b.IgnoreTeamDamage = TEAM_EVIL
						b.AllowRespawn = false
						b.IdleSpeed = b.WalkSpeed / 2
						b.SpawnProtection = ct + 5
						
						b.StuckPositions = EVIL_SPAWNPOINTS_VECTORS
						
						if team.NumPlayers( TEAM_MAIN ) > 0 then
							b.GoalTable = team.GetPlayers( TEAM_MAIN )
						end
						
						//record him
						ACTIVE_BOTS[ char ] = ACTIVE_BOTS[ char ] + 1
						
						ACTIVE_BOTS_TOTAL = ACTIVE_BOTS_TOTAL + 1
						BOTS_TOTAL = BOTS_TOTAL + 1
						
					end
					
				end
			end
			
			//PrintTable( ACTIVE_BOTS )
			
		end
		
		function self:OnInitPostEntity()	
			self:GenerateWaves()			
		end
		
		
		function self:GametypePlayerInitialSpawn( pl )
			
			pl:DrawShadow( false )
			
			if not pl.FirstSpawn and not pl:IsBot() then
				pl:SetTeam( TEAM_SPECTATOR )
				pl:SendLua( "ManageFirstSpawn(\""..self:GetGametype().."\")" )
				pl.FirstSpawn = true
				return
			end
			
			if not pl.FirstSpawn and pl:IsBot() then
				pl:SetTeam( TEAM_SPECTATOR )
				pl.CheckCharacter = true
				pl.CharacterPref = "pr1"
				pl.StoreCharacterPref = "pr1"
				pl.FirstSpawn = true
			end
			
			pl.Active = true
			
			pl:SendLua("GAMEMODE:PlayMusic()")
			
			pl:UnSpectate()
			
			if pl:Team() == TEAM_SPECTATOR or pl:Team() == TEAM_CONNECTING then
				pl:SetTeam( team.GetJoinableTeam() )
			end
			
			pl:SetFlipView( pl:Team() == TEAM_EVIL )
			
			
			if pl:Team() == TEAM_MAIN then
				pl.Lives = 3
							
				if self:GetRoundState() ~= ROUNDSTATE_RESTARTING then
					if self:GetRoundState() == ROUNDSTATE_IDLE then
						self:WaveStart()
						CUR_WAVE_PLAYERS = team.NumPlayers( TEAM_MAIN )
					end
					self:SetRoundState( ROUNDSTATE_ACTIVE )
					
					//try to spawn missing bots
					if CUR_WAVE_PLAYERS ~= team.NumPlayers( TEAM_MAIN ) then
						local true_bot_amount = self:GetDesiredBotAmount( CUR_WAVE )
						
						//print"Adding more bots for another player"
						//print("Desired total amount: "..true_bot_amount)
						//print("Current total amount: "..BOTS_TOTAL)
						
						if true_bot_amount > BOTS_TOTAL then
							self:SpawnBots( true_bot_amount - BOTS_TOTAL, true )
						end
						CUR_WAVE_PLAYERS = team.NumPlayers( TEAM_MAIN )
					end
				end				
			else
				pl.Lives = 0
			end
								
		end
				
		
		function self:GametypePrePlayerSpawn( pl ) 
			
			self:SelectMainCharacter( pl )
			
			if pl:Team() == TEAM_MAIN then
										
			else
					
				pl.CharacterPref = "greed crew default"
					
			end
			
			
		end
		
		
		function self:GametypePlayerSpawn( pl )
						
			if pl:Team() == TEAM_SPECTATOR and pl.Active then
				pl:Freeze( false )
				pl:Spectate(OBS_MODE_CHASE)
				for _, p in pairs( team.GetPlayers( TEAM_MAIN )) do
					if p and p:IsValid() and p:Alive() then
						pl:SpectateEntity( p )
						pl:SetPos( p:GetPos() )
						break
					end
				end
			else
				pl.BotsKilled = 0
				pl.SpawnProtection = CurTime() + 3
							
				local col = team.GetColor( pl:Team() )
				pl:SetPlayerColor( Vector( col.r/255, col.g/255, col.b/255) )
			end
						
		end
		
		
		function self:PlayerDisconnected( pl )
			
			if pl:Team() == TEAM_MAIN then
				
				local restart = true
				
				for k, v in ipairs( team.GetPlayers( TEAM_MAIN ) ) do
					if USE_LIVES then
						if v and v:IsValid() and v.Lives and v.Lives > 0 and v ~= pl then
							restart = false
							break
						end
					else
						if v and v:IsValid() and v ~= pl then
							restart = false
							break
						end
					end
				end
				
				if restart then
					
					if self:GetRoundState() == ROUNDSTATE_RESTARTING or self:GetRoundState() == ROUNDSTATE_END then return end
						
					self:SetRoundState( ROUNDSTATE_RESTARTING )
						
					for k,v in ipairs(player.GetAll()) do
						v:ChatPrint("All protagonists are dead!")
						v:ChatPrint("Starting new round in 3 seconds...")
					end
					
					//reset all checkpoints
					self:RestartRoundIn( 3, true )
						
				end
				
				for k,v in pairs( team.GetPlayers( TEAM_SPECTATOR ) ) do
					if v and v:IsValid() and v.Active then
						v:SetTeam( TEAM_MAIN )
						v:ChatPrint( "You have been moved from spectators, because there is a free slot!" )
						break
					end
				end
				
				CUR_WAVE_PLAYERS = team.NumPlayers( TEAM_MAIN )
				
			end
			
			if #player.GetAll() <= 1 then
				self:RoundEnd()
			end
			
		end
		
		function self:GametypeDoNextBotDeath( pl, attacker, dmginfo )
			
			if pl.IsBuddy then return end
			
			if attacker and attacker:IsPlayer() then
				attacker.BotsKilled = attacker.BotsKilled + 1
			end
			
			if pl.CharacterReference and ACTIVE_BOTS[ pl.CharacterReference ] then
				ACTIVE_BOTS[ pl.CharacterReference ] = ACTIVE_BOTS[ pl.CharacterReference ] - 1
				ACTIVE_BOTS_TOTAL = ACTIVE_BOTS_TOTAL - 1
			end
			
			local alive = false
			
			for _, p in pairs( NEXTBOTS ) do
				if p and p:IsValid() and p:Alive() then
					alive = true
					break
				end
			end
								
			if self:GetNextBotCount() < math.Round( BOTS_TOTAL / 2 ) then
				for k, v in ipairs( team.GetPlayers( TEAM_MAIN ) ) do
					if v and v:IsValid() and v:Alive() then
						for _, p in pairs( NEXTBOTS ) do
							if p and p:IsValid() and p:Alive() then
								v:AddArrow( p, nil, true )
							end
						end
					end
				end
			end
			
			if not alive then
				self:WaveComplete()
			end
			
		end
		
		function self:GametypeDoPlayerDeath( pl, attacker, dmginfo )
			
			if pl:Team() == TEAM_MAIN then
				
				pl.NextSpawnTime = CurTime() + 1
				
				//just so afk players wont delay the progress
				pl.AFKRespawn = CurTime() + math.random(10,15)
				
				if USE_LIVES then
				
					pl.Lives = pl.Lives - 1
					
					pl:ChatPrint("You have "..pl.Lives.." more lives.")
					
					
					local restart = true
					
					for k, v in pairs( team.GetPlayers( TEAM_MAIN ) ) do
						if v and v:IsValid() and v.Lives and v.Lives > 0 then
							restart = false
							break
						end
					end
					
					if restart then
						
						if self:GetRoundState() == ROUNDSTATE_RESTARTING or self:GetRoundState() == ROUNDSTATE_END then return end
							
							self:SetRoundState( ROUNDSTATE_RESTARTING )
							
							for k,v in ipairs(player.GetAll()) do
								v:ChatPrint("All protagonists are dead!")
								v:ChatPrint("Starting new round in 3 seconds...")
							end

							self:RestartRoundIn( 3 )
							
						end
					end
					
				end
				
				if self:GetRoundState() == ROUNDSTATE_RESTARTING or self:GetRoundState() == ROUNDSTATE_END then return end
				//respawn some of dead bots ( killed by this player)  upon player's death
				
				if pl.BotsKilled and pl.BotsKilled > 0 then
					
					self:SpawnBots( pl.BotsKilled )
									
					if self:GetNextBotCount() < math.Round( BOTS_TOTAL / 2 ) then
						for k, v in ipairs( team.GetPlayers( TEAM_MAIN ) ) do
							if v and v:IsValid() and v:Alive() then
								for _, p in pairs( NEXTBOTS ) do
									if p and p:IsValid() and p:Alive() then
										v:AddArrow( p, nil, true )
									end
								end
							end
						end
					else
						for k, v in ipairs( team.GetPlayers( TEAM_MAIN ) ) do
							if v and v:IsValid() then
								v:CleanArrows()
							end
						end
					end
				
				end			
		end
		
		function self:OnPlayerDeathThink( pl )
			
			if pl:KeyPressed( IN_JUMP ) and pl.NextSpawnTime and pl.NextSpawnTime < CurTime() then
				pl:SendLua( "DrawCharacterMenu()" )
				return
			end
			
			if self:GetRoundState() == ROUNDSTATE_END and pl.NextSpawnTime and pl.NextSpawnTime < CurTime() and (( pl:KeyPressed( IN_ATTACK ) || pl:KeyPressed( IN_ATTACK2 ) || pl:KeyPressed( IN_JUMP ) ) or pl:IsBot()) then
				
				if self:GetRoundState() == ROUNDSTATE_RESTARTING then return end
				
				self:SetRoundState( ROUNDSTATE_RESTARTING )
				
				for k,v in ipairs(player.GetAll()) do
					v:ChatPrint("Starting a new round...")
				end
				self:RestartRound()
				
			else
				if pl:Team() == TEAM_MAIN then
					
					if USE_LIVES and (pl.Lives or 0 ) <= 0 then
						pl.Spectated = pl.Spectated or 0
						
						if pl:KeyPressed( IN_ATTACK ) then
							pl.Spectated = pl.Spectated + 1
							
							local tospec = {}
							
							for k, v in ipairs(team.GetPlayers(TEAM_MAIN)) do
								if v:Alive() then 
									table.insert(tospec, v) 
								end
							end
							
							if pl.Spectated > #tospec then
								pl.Spectated = 1
							end
							
							local spec = tospec[pl.Spectated]
													
							if spec then
								pl:Spectate(OBS_MODE_CHASE)
								pl:SpectateEntity(spec)
							else
								pl.Spectated = 0
							end
						
						end
					else	
						//print(tostring(pl.AFKRespawn < CurTime()))
						if pl.AFKRespawn and pl.AFKRespawn < CurTime() or pl.NextSpawnTime and pl.NextSpawnTime < CurTime() and pl:KeyPressed( IN_ATTACK ) or pl:IsBot() then
							pl:Spawn()
						end
					end
			
				end
				if pl:Team() == TEAM_SPECTATOR and pl.Active then
					
					pl.Spectated = pl.Spectated or 0
						
					if pl:KeyPressed( IN_ATTACK ) then
						pl.Spectated = pl.Spectated + 1
							
						local tospec = {}
							
						for k, v in ipairs(team.GetPlayers(TEAM_MAIN)) do
							if v:Alive() then 
								table.insert(tospec, v) 
							end
						end
							/*for k, v in pairs(NEXTBOTS) do
								if v:Alive() then 
									table.insert(tospec, v) 
								end
							end*/
							
						if pl.Spectated > #tospec then
							pl.Spectated = 1
						end
							
						local spec = tospec[pl.Spectated]
													
						if spec then
							pl:Spectate(OBS_MODE_CHASE)
							pl:SpectateEntity(spec)
						else
							pl.Spectated = 0
						end
						
					end			
				end
				if pl:Team() == TEAM_EVIL then
					if pl.NextSpawnTime and pl.NextSpawnTime < CurTime() and pl:KeyPressed( IN_ATTACK ) or pl:IsBot() then
						pl:Spawn()
					end
				end
			end
			
			
		end
		
		function self:PlayerSelectSpawn( pl )
			local ent = self:PlayerSelectTeamSpawn( pl:Team(), pl )
			if ( IsValid(ent) ) then return ent end			
		end
		
	end
	
	function self:GetWave()
		return game.GetWorld():GetDTInt( 0 ) or 1
	end

	if CLIENT then
		local radius = 450
		local blend = false
		//local player_trace = { mask = MASK_SOLID_BRUSHONLY }
		local mat = Material( "Debug/hsv" )
			
		GAMEMODE.Gametype = "nemesis"
		
		BLOODY_SCREEN = true //so real!
		
		SHOW_TAKEN_CHARACTERS = true
		DRAW_NAMES = true
		GAMETYPE_PLAYLIST = 60128471
		GAMETYPE_PLAYLIST_VOLUME = 30
		
		/*function self:OnThink()
			
			local MySelf = LocalPlayer()
			
			if IsValid( MySelf ) and ( MySelf:Team() ~= TEAM_SPECTATOR or MySelf:Team() ~= TEAM_CONNECTING ) then
				self:CheckThunder()
			end
		end*/
		
		function self:DrawAdditionalInfo()
			local info = translate.Format("sog_hud_wave_x", (self:GetWave()) or 1 )
			if self:GetWave() == 6 then
				info = translate.Get("sog_hud_final_wave")
			end
			return info
		end
			
		function self:OnDrawDeathHUD()
		
			local w,h = ScrW(), ScrH()
			local MySelf = LocalPlayer()
				
					
			local shift = math.cos(RealTime()*3)*2 + 5
				
			local x, y = 60, h*0.85
						
			local text = IsValid( MySelf:GetObserverTarget() ) and translate.Format("sog_hud_spectating_x", MySelf:GetObserverTarget():Name()) or translate.Get("sog_hud_you_are_dead")
							
			draw.SimpleText( text, "NumbersSmall", x + 3, y + 3, Color( 10, 10, 10, 185), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText( text, "NumbersSmall", x, y, Color( 97, 0, 27, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText( text, "NumbersSmall", x - shift, y - shift, Color( 220, 220, 220, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				
			shift = math.sin(RealTime()*3)*2 + 5
	
			x, y = 60, h*0.85 + 38	
						
			text = translate.Get("sog_hud_change_character")
						
			draw.SimpleText( text, "NumbersSmall", x + 3, y + 3, Color( 10, 10, 10, 185), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText( text, "NumbersSmall", x, y, Color( 97, 0, 27, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText( text, "NumbersSmall", x - shift, y - shift, Color( 220, 220, 220, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
					
		
		end

		end


end

GM:AddAvalaibleGametype( "nemesis", translate.Get("sog_gametype_name_nemesis_help") )
GM.Gametypes["nemesis"] = GM.CoOpInitialize