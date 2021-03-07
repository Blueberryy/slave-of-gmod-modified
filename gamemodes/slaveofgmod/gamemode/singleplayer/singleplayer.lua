ACTS = ACTS or {}
SCENES = SCENES or {}

local ActNames = {
	"DMCA",
	"DDOS",
	"Pride",
	"Greed",
	"Terror",
	"Dead End",
	"Development Hell"
}

local ActCovers = {
	Material( "sog/covers/act_cover_1.png" ),
	Material( "sog/covers/act_cover_2.png" ),
	Material( "sog/covers/act_cover_3.png" ),
	Material( "sog/covers/act_cover_4.png" ),
	Material( "sog/covers/act_cover_5.png" ),
	Material( "sog/covers/act_cover_6.png" ),
	Material( "sog/covers/act_cover_bonus.png" ),
}

local act_def_cover = Material( "sog/covers/act_cover_default.png" )
local scene_def_cover = Material( "sog/covers/dvd_disk_default.png", "alphatest" )

//to sort out later
local bonus_scenes = {}

if not CHECKED_LUA_SCENES then

	local a, b = file.Find(GM.FolderName.."/gamemode/singleplayer/scenes/*.lua", "LUA")
	for _, scene in ipairs( a ) do
			
		AddCSLuaFile("scenes/"..scene)
			
		SCENE = {}
			
		include("scenes/"..scene)
		
		if not SCENE.Cover then
			SCENE.Cover = scene_def_cover
		end
		
		if SCENE.Order then
			local num = SCENE.Order
			if not SCENES[num] then
				SCENES[num] = SCENE
			end
		else
			table.insert( bonus_scenes, SCENE )
		end
		
		SCENE = nil
			
	end
	CHECKED_LUA_SCENES = true
end

//check txt files
if not CHECKED_TXT_SCENES then
	local a, b = file.Find("slaveofgmod/savedscenes/*.txt", "DATA")
	for _, scene in ipairs( a ) do
		
		local content = file.Read( "slaveofgmod/savedscenes/"..scene )
		
		if content then
		
			SCENE = {}
			
			RunString( content )
			
			if not SCENE.Cover then
				SCENE.Cover = scene_def_cover
			end
					
			if SCENE.Order then
				local num = SCENE.Order
				if not SCENES[num] then
					SCENES[num] = SCENE
				end
			else
				table.insert( bonus_scenes, SCENE )
			end
			
			SCENE = nil
		
		end
			
	end
	CHECKED_TXT_SCENES = true
end

//add bonus scenes to the end, might add sub-sorting for these as well
for _, scene in ipairs( bonus_scenes ) do
	//SCENES[ #SCENES + 1 ] = scene
end

for k, v in pairs( SCENES ) do
	if SCENES[ k ] and SCENES[ k ].Order and SCENES[ k ].Act then
		//make act, add name
		if not ACTS[ SCENES[ k ].Act ] then
			ACTS[ SCENES[ k ].Act ] = {}
			if ActNames[ SCENES[ k ].Act ] then
				ACTS[ SCENES[ k ].Act ].Name = ActNames[ SCENES[ k ].Act ]
			else
				ACTS[ SCENES[ k ].Act ].Name = "Untitled"
			end
			if ActCovers[ SCENES[ k ].Act ] then
				ACTS[ SCENES[ k ].Act ].Cover = ActCovers[ SCENES[ k ].Act ]
			else
				ACTS[ SCENES[ k ].Act ].Cover = act_def_cover
			end
		end
		//manage scenes
		ACTS[ SCENES[ k ].Act ].Scenes = ACTS[ SCENES[ k ].Act ].Scenes or {}
		//important not to fuck up this one
		local act_order = SCENES[ k ].Order - 4 * ( SCENES[ k ].Act - 1 )
		
		ACTS[ SCENES[ k ].Act ].Scenes[ act_order ] = table.Copy( SCENES[ k ] )
	end
end

//if we have a file from editor, this means we want to test it, so always load it instead
EDITOR_TEST = file.Exists( "slaveofgmod/editortest.txt", "DATA" )
if not CHECKED_EDITOR_SCENES then
	if EDITOR_TEST then

		local content = file.Read( "slaveofgmod/editortest.txt" )
		
		if content then
			
			SCENE = {}
			
			RunString( content )
			
			EDITOR_SCENE = table.Copy( SCENE )
			
			SCENE = nil
				
		end
		
	end
	CHECKED_EDITOR_SCENES = true
end

TEAM_PLAYER = 6
TEAM_MOB = 7

team.SetUp(TEAM_PLAYER, "Player", Color(255,255,255,255))
team.SetUp(TEAM_MOB, "Enemies", Color(255,255,255,255))

//used for some hardcode triggering
CUR_STAGE = CUR_STAGE or 1

CUR_SCENE = CUR_SCENE or CreateConVar("sog_cur_scene", 1, FCVAR_ARCHIVE, ""):GetInt()
cvars.AddChangeCallback("sog_cur_scene", function(cvar, oldvalue, newvalue)
	CUR_SCENE = util.tobool( newvalue )
end)

SINGLEPLAYER = SINGLEPLAYER or util.tobool(CreateConVar("sog_singleplayer", 0, FCVAR_ARCHIVE, ""):GetInt())
PLAY_CUTSCENE = PLAY_CUTSCENE or GetConVar( "sog_singleplayer" ):GetInt() ~= 2
/*cvars.AddChangeCallback("sog_singleplayer", function(cvar, oldvalue, newvalue)
	if newvalue == 2 then
		PLAY_CUTSCENE = false
	end
end)*/

//print("Singleplayer: "..tostring(SINGLEPLAYER))

//Serverside part
if SERVER then

local function singleplayer_change_map(pl,cmd,args)
	
	if !game.SinglePlayer() then return end
	
	local scene = args[1]
	local overridemap = args[2]
	local nointro = args[3]
	if not scene then return end
	if not SCENES[tonumber(scene)] then return end
	
	local tbl = SCENES[tonumber(scene)]
	
	if not tbl.Map then return end
	
	if CUR_SCENE and CUR_SCENE ~= tonumber(scene) then
		game.ConsoleCommand( "sog_cur_scene "..scene.."\n" )
	end
	
	//if not SINGLEPLAYER then
	if nointro and tonumber( nointro ) == 1 then
		game.ConsoleCommand( "sog_singleplayer 2\n" )
	else
		game.ConsoleCommand( "sog_singleplayer 1\n" )
	end
	//end
		
	if GAMEMODE:GetGametype() ~= "none" then
		game.ConsoleCommand( "sog_gametype none\n" )
	end
	
	game.ConsoleCommand("changelevel "..( overridemap or tbl.Map ).."\n");
	
end
concommand.Add("sog_singleplayer_changelevel",singleplayer_change_map)

//only load when we are in singleplayer and stuff
if game.SinglePlayer() and SINGLEPLAYER then

	NO_LEVEL_CLEAR = false
	
	SCENE = SCENE or SCENES[ CUR_SCENE ] or SCENES[ 1 ]
	
	SCENE.Events = SCENE.Events or {}
	
	if EDITOR_SCENE then
		SCENE = EDITOR_SCENE
	end
	
	if SCENE.Initialize then
		SCENE.Initialize()
	end
	
	if SCENE.Nightmare then
		NIGHTMARE = true
	end
	
	if SCENE.DrugEffect then
		DRUG_EFFECT = true
	end
	
	if SCENE.NoPickups then
		NO_PICKUPS = true
	end
	
	if SCENE.DisableNextbotLights then
		DISABLE_NEXTBOTLIGHT = true
	end
	
	if SCENE.PickupsPersistance then
		PICKUP_PERSISTANCE = true
	end
	
	if SCENE.NoPickupsRespawn then
		PICKUP_RESPAWN_TIME = 9999999
	end
	
	if SCENE.NoMapProps then
		NO_MAP_PROPS = true
	end
	
	if SCENE.BadassMode then
		BADASS_MODE = true
	end
	
	if SCENE.Characters then
		GM.UseCharacters = SCENE.Characters
	end
	
	//maybe make a faction selection option?
	if SCENE.Enemies then
		for k, v in pairs( SCENE.Enemies ) do
			if v then
				if v.char == "thug kid" then
					DARKRP_TAG = true
					break
				end
				if v.char == "greed crew thug" then
					CODERFIRED_TAG = true
					break
				end
			end
		end
	end
	
	function GM:RoundStart()	
		self:SetRoundTime( CurTime() )
		self:SetRoundState( ROUNDSTATE_IDLE )
	end
	
	function GM:RestartRound()
				
		self:RoundStart()
		self:ResetMap()
		
		if SCENE.Restart then
			SCENE.Restart()
		end
		
		if SCENE.Triggers then
			self:SpawnTriggers( SCENE.Triggers, true )
		end
		
		if SCENE.Enemies then
			self:SpawnEnemies( SCENE.Enemies )
		end
		
		if SCENE.Pickups then
			self:SpawnWeapons( SCENE.Pickups )
		end
		
		if SCENE.SpawnMobs then
			self:RemoveNextbots()
			SCENE.SpawnMobs()
		end

		for k, v in pairs(player.GetAll()) do
			v:Spawn()
		end
			
	end
	
	util.AddNetworkString( "CheckStoryProgress" )
	
	//goal is completed
	function GM:FinishRound()
		
		//in case if you manage to die
		timer.Simple( 0.5, function()
			if Entity(1) and !Entity(1):Alive() then return end
			if self:GetRoundState() == ROUNDSTATE_RESTARTING or self:GetRoundState() == ROUNDSTATE_END then return end
							
			self:SetRoundState( ROUNDSTATE_RESTARTING )

			self:ShowLevelClear()
			
			LEVEL_CLEAR = true

			if SCENE.LevelClear	then
				SCENE.LevelClear()
			else
				
			end
			
			//update the progress if it's an official level
			if SCENE and SCENE.Order and not SCENE.OverrideStoryProgress then
				net.Start( "CheckStoryProgress" )
					net.WriteInt( SCENE.Order, 32 )
				net.Broadcast()
			end
			
			self:DoEvents( "OnLevelClear" )
			
			if SCENE and SCENE.Achievement then
				self:UnlockAchievement( SCENE.Achievement )
			end
			
			if SCENE and SCENE.Name == "legacy" then
				local wep = Entity(1):GetActiveWeapon()
				if IsValid( wep ) and wep:GetClass() == "sogm_villainchair" then
					self:UnlockAchievement( "comfy" )
				end
			end
			
			
			
		end)
		
		//Entity(1):PopHUDMessage( "Leave Area" )
		
	end
	
	function GM:DoEvents( event_name )
		if SCENE.Events and SCENE.Events[ event_name ] then
			for k, v in pairs( TRIGGERS ) do
				if v and v:IsValid() and v.Tag and table.HasValue( SCENE.Events[ event_name ], v.Tag )then
					v.Active = true
					v:StartTouch( Entity(1) )
				end
			end
		end
	end
	
	util.AddNetworkString( "PlayFinalCutscene" )
	
	function GM:LoadNextLevel()
		
		if EDITOR_TEST then
			self:ReturnToEditor()
		else
			self:PauseEnemies( true )
			
			local reset = false
			
			local am = #SCENES
			local toload = CUR_SCENE + 1
			
			if toload > am then
				reset = true
				//toload = 1
			end
			
			Entity(1):SetLocalVelocity( vector_origin )
			Entity(1):SetMoveType( MOVETYPE_NONE )
			//Entity(1):ChatPrint( "Next Level will load in 3 seconds" )
			
			Entity(1):ScreenFade( SCREENFADE.OUT, Color( 5, 5, 5, 255 ), 2, SCENE.OutroCutscene and 9999999 or 10 )
			
			//check it once again, if we have skipped Level Clear check
			if SCENE and SCENE.Order then
				net.Start( "CheckStoryProgress" )
					net.WriteInt( SCENE.Order, 32 )
				net.Broadcast()
			end
			
			if SCENE.OutroCutscene then
				timer.Simple(3, function()
					net.Start( "PlayFinalCutscene" )
					net.WriteString( SCENE.OutroCutscene )
					net.WriteInt( toload, 32 )
					net.Broadcast()
				end)
			else
				timer.Simple(3, function()
					if reset then
						game.ConsoleCommand("changelevel "..tostring( game.GetMap() ).."\n")
					else
						game.ConsoleCommand("sog_singleplayer_changelevel "..tostring( toload ).."\n")
					end
				end)
			end
		end
		
	end
	
	function GM:ReturnToEditor()
		
		if not EDITOR_TEST then return end
	
		game.ConsoleCommand("changelevel "..game.GetMap().."\n")
		
	end
	
	//pause and unpause bots
	function GM:PauseEnemies( pause )
		
		for k, v in pairs( NEXTBOTS ) do
			if v and v:IsValid() then
				if v.IgnoreDeaths or ( v.Ally and ( v.StoreBehaviour == BEHAVIOUR_FOLLOWER or v:GetBehaviour() == BEHAVIOUR_FOLLOWER ) ) then 
				//if v.Ally and ( v.StoreBehaviour == BEHAVIOUR_FOLLOWER or v:GetBehaviour() == BEHAVIOUR_FOLLOWER ) then
					v.NoTargets = pause
					continue 
				end
				v.StoreBehaviour = v.StoreBehaviour or v:GetBehaviour()
				v:SetBehaviour( pause and BEHAVIOUR_DUMB or v.StoreBehaviour )
			end
		end
		
	end
	
	function GM:OnInitPostEntity()
	
		PLAYER_SPAWNPOINT = INFO_PLAYER_MAIN[1]:GetPos()
		
		/*if SCENE.NextLevelTrigger then
			local e = ents.Create( "trigger_nextlevel" )
			e:SetPos( SCENE.NextLevelTrigger.pos )
			e:SetSize( SCENE.NextLevelTrigger.size or 100 )
			e:Spawn()
		end*/
		
		if SCENE.Map and SCENE.Map ~= game.GetMap() then
			game.ConsoleCommand( "sog_singleplayer 0\n" )
			game.ConsoleCommand( "changelevel "..game.GetMap().."\n" )
		end
		
		if SCENE.Loaded then
			SCENE.Loaded()
		end	
		
		if self.LoadSceneAssets then
			self:LoadSceneAssets( SCENE )
		end

		//spawn optional vehicle
		if SCENE.Vehicle then
			if SCENE.Vehicle.mdl then
				local car = ents.Create( "prop_physics" )
				car:SetModel( SCENE.Vehicle.mdl )
				car:SetPos( SCENE.Vehicle.pos )
				car:SetAngles( SCENE.Vehicle.ang )
				car:SetMoveType( MOVETYPE_NONE )
				car:Spawn()
				local phys = car:GetPhysicsObject()
				if phys and phys:IsValid() then
					phys:EnableMotion( false )
				end
			end
			if SCENE.Vehicle.glass_mdl then
				local glass = ents.Create( "prop_physics" )
				glass:SetModel( SCENE.Vehicle.glass_mdl  )
				glass:SetPos( SCENE.Vehicle.pos )
				glass:SetAngles( SCENE.Vehicle.ang )
				glass:SetMoveType( MOVETYPE_NONE )
				glass:SetSolid( SOLID_NONE )
				glass:Spawn()
				local phys = glass:GetPhysicsObject()
				if phys and phys:IsValid() then
					phys:EnableMotion( false )
				end
			end
		end
		
		ENEMY_MAX_ID = 1
		
		if SCENE.Enemies then
			for k,v in pairs( SCENE.Enemies ) do
				local normal_ind = tonumber(string.Replace( k, "e", "" ))
				if normal_ind > ENEMY_MAX_ID then
					ENEMY_MAX_ID = normal_ind
				end
			end
		end
		
		self:HandleTriggerObjects()
		
		if not PLAYER_SPAWNPOINT then
			PLAYER_SPAWNPOINT = INFO_PLAYER_MAIN[1]:GetPos()
		end
	end
	
	//a bit different
	function GM:RemoveNextbots( all )
	
		if not NEXTBOTS then return end
		
		for k, v in pairs( NEXTBOTS ) do
			if v and v:IsValid() then
				//if v.IgnoreDeaths and !all then continue end
				v.RemovedByGame = true
				v:Remove()
			end
		end
		
	end
	
	//sort out normal stuff and spawwn that will be affected by triggers
	function GM:HandleTriggerObjects()
		if SCENE.Triggers then
			for tr_key, tbl in pairs( SCENE.Triggers ) do
				//spawning
				if tbl.action == "spawn" then
					if tbl.objects then
						SCENE.Triggers[ tr_key ].OnTrigger = function()
							if SCENE.Triggers[ tr_key ].trigger_once then
								SCENE.Triggers[ tr_key ].discard = true
							end
							for _, key in pairs( tbl.objects ) do
								//spawn mobs
								if SCENE.Enemies and SCENE.Enemies[ key ] and SCENE.Enemies[ key ].CheckTriggers then
									local sub_tbl = SCENE.Enemies[ key ]
									local b = GAMEMODE:SpawnBot( sub_tbl.wep or nil, sub_tbl.char or "default", sub_tbl.pos or nil, sub_tbl.ally and TEAM_PLAYER or TEAM_MOB, sub_tbl.ally and TEAM_MOB or TEAM_PLAYER, sub_tbl.ally and TEAM_MOB or TEAM_PLAYER )
									b:SetAngles( sub_tbl.ang )
									b.IgnoreTeamDamage = sub_tbl.ally and TEAM_PLAYER or TEAM_MOB
									b.AllowRespawn = false
									if sub_tbl.ally then
										b.Ally = true
									end
									if sub_tbl.opt then
										b.Optional = true
									end
									if tbl.stages then
										b.Stages = tbl.stages
									end
									if sub_tbl.beh then
										if sub_tbl.beh == BEHAVIOUR_FOLLOWER then
											if sub_tbl.ally then
												b:SetOwner( Entity( 1 ) )
												b.IdleSpeed = b.WalkSpeed
											end
											local off = VectorRand()
											off.z = 0
											b.FollowOffset = off
										end
										b:SetBehaviour( sub_tbl.beh )
									end
									if sub_tbl.anim then
										b.IdleAnim = sub_tbl.anim
									end
									
									if sub_tbl.icon then
										b:SetDTString( 1, sub_tbl.icon )
									end
									
									if sub_tbl.immune then
										b:SetImmune( true )
									end
									
									b.Tag = key
									b.NoSpawnProtection = true
									
									if CUR_DIALOGUE then
										self:PauseEnemies( true )
									end
									
								end
								//spawn pickups
								if SCENE.Pickups and SCENE.Pickups[ key ] and SCENE.Pickups[ key ].CheckTriggers then
									local sub_tbl = SCENE.Pickups[ key ]
									local pr = ents.Create( "dropped_weapon" )
										pr:SetPos( sub_tbl.pos + vector_up * 15 )
										pr:SpawnAsWeapon( sub_tbl.wep )
										pr.NoKnockback = false
										pr.MapBased = true
									pr:Spawn()
									local phys = pr:GetPhysicsObject()
									if IsValid(phys) then
										phys:SetVelocityInstantaneous( vector_up * 130 )
									end
									pr.Tag = key
								end
								//spawn triggers
								if SCENE.Triggers and SCENE.Triggers[ key ] and SCENE.Triggers[ key ].CheckTriggers then
									local sub_tbl = SCENE.Triggers[ key ]
									if sub_tbl.action == "nextlevel" then
										local e = ents.Create( "trigger_nextlevel" )
											e:SetPos( sub_tbl.pos )
										e:Spawn()
										e.Tag = key
										e:SetSize( sub_tbl.size or 100 )
									else
										local e = ents.Create( "trigger_default" )
											e:SetPos( sub_tbl.pos )
											if sub_tbl.OnTrigger then
												e.Trigger = sub_tbl.OnTrigger
											end
											if sub_tbl.data then
												e.Data = sub_tbl.data
											end
										e:Spawn()
										e.Tag = key
										e:SetSize( sub_tbl.size or 100 )
										
										if sub_tbl.trigger_once or sub_tbl.action == "dialogue" then
											e.DontRemove = true
										end
										if sub_tbl.action == "dialogue" then
											e.Dialogue = true
										end

									end
								end
							end
						end
					end
				//music time stuff
				elseif tbl.action == "music_time" then
					SCENE.Triggers[ tr_key ].OnTrigger = function()
						if tbl.data then
							//PrintTable( tbl.data )
							if tbl.data.start then
								Entity( 1 ):SendLua( "GAMEMODE.MusicStartFrom = "..tonumber( tbl.data.start / 1000 ) )
							end
							if tbl.data.endpos then
								Entity( 1 ):SendLua( "GAMEMODE.MusicEndAt = "..tonumber( tbl.data.endpos / 1000 ) )
							end
						end
					end
				//ent input stuff
				elseif tbl.action == "ent_input" then
					SCENE.Triggers[ tr_key ].OnTrigger = function()
						if tbl.data then
							if tbl.data.index and tbl.data.input_name then
								local ent = ents.GetMapCreatedEntity( tonumber( tbl.data.index ) )
								if ent then
									ent:Fire( tostring( tbl.data.input_name ), "", 0 )
								end
							end
						end
					end
				//hud messages
				elseif tbl.action == "hudmessage" then
					SCENE.Triggers[ tr_key ].OnTrigger = function()
						if tbl.data then
							Entity(1):PopHUDMessage( tbl.data )
						end
					end
				//light style
				elseif tbl.action == "engine_lighting" then
					SCENE.Triggers[ tr_key ].OnTrigger = function()
						if tbl.data then
							engine.LightStyle( 0, tbl.data )
							Entity( 1 ):SendLua( "render.RedownloadAllLightmaps( true )" )
						end
					end
				//level clear
				elseif tbl.action == "levelclear" then
					//override default one
					NO_LEVEL_CLEAR = true
					SCENE.Triggers[ tr_key ].OnTrigger = function()
						GAMEMODE:FinishRound()
					end
				//various events
				elseif tbl.action == "event" then
					if tbl.event then
						SCENE.Events = SCENE.Events or {}
						SCENE.Events[ tbl.event ] = SCENE.Events[ tbl.event ] or {}
						table.insert( SCENE.Events[ tbl.event ], tr_key )
						SCENE.Triggers[ tr_key ].OnTrigger = function()
							//activate all child triggers
							if tbl.objects then
								//print( "Event "..tr_key.." - activating" )
								for k, v in pairs( TRIGGERS ) do
									
									if v and v:IsValid() and v.Tag and table.HasValue( tbl.objects, v.Tag )then
										//print( "Event "..tr_key.." - found "..v.Tag )
										//print(v.Active)
										v.Active = true
										v:StartTouch( Entity(1) )
									end
								end
							end
						end
					end
				//arrows
				elseif tbl.action == "arrow" then
					SCENE.Triggers[ tr_key ].OnTrigger = function()
						timer.Simple( 0.1, function()
							if tbl.objects then
								for k, v in pairs( NEXTBOTS ) do
									if v and v:IsValid() and v.Tag and table.HasValue( tbl.objects, v.Tag )then
										Entity(1):AddArrow( v, nil, true, true )
									end
								end
								for k, v in pairs( DROPPED_WEAPONS ) do
									if v and v:IsValid() and v.Tag and table.HasValue( tbl.objects, v.Tag )then
										Entity(1):AddArrow( v, nil, true, true )
									end
								end
							end
						end)
					end
				//enemy ai stuff
				elseif tbl.action == "pauseenemies" then
					SCENE.Triggers[ tr_key ].OnTrigger = function()
						if tbl.data then
							GAMEMODE:PauseEnemies( util.tobool( tbl.data ) )
						end
					end
				//dialogues
				elseif tbl.action == "dialogue" then
					SCENE.Triggers[ tr_key ].OnTrigger = function()
						if tbl.objects then
							//lets assume that nothing is broken
							GAMEMODE:StartDialogue( tbl.objects[ 1 ] )
						end
					end
				//activate stage
				elseif tbl.action == "activate_stage" then
					SCENE.Triggers[ tr_key ].OnTrigger = function()
						//if tbl.objects then
						if tbl.data then
							//just so we wont end our level earlier
							NO_LEVEL_CLEAR = true
							timer.Simple( 0, function()
								GAMEMODE:ActivateStage( tonumber( tbl.data ) ) 
							end )
						end
					end
				//update spawnpoint
				elseif tbl.action == "newspawnpoint" then
					SCENE.Triggers[ tr_key ].OnTrigger = function()
						PLAYER_SPAWNPOINT = tbl.pos//Entity(1):GetPos()
					end
				//linker
				elseif tbl.action == "linker" then
					SCENE.Triggers[ tr_key ].OnTrigger = function()
						//activate all child triggers
						if tbl.objects then
							for k, v in pairs( TRIGGERS ) do
								if v and v:IsValid() and v.Tag and table.HasValue( tbl.objects, v.Tag )then
									v.Active = true
									v:StartTouch( Entity(1) )
								end
							end
						end
					end
				//stop ambient and play music
				elseif tbl.action == "playmusic" then
					SCENE.Triggers[ tr_key ].OnTrigger = function()
						Entity(1):SendLua("GAMEMODE:SwitchAmbientToMusic()")
					end	
				//remove immune status
				elseif tbl.action == "remove_immune" then
					SCENE.Triggers[ tr_key ].OnTrigger = function()
						if tbl.objects then
							for k, v in pairs( NEXTBOTS ) do
								if v and v:IsValid() and v.Tag and table.HasValue( tbl.objects, v.Tag )then
									v:SetImmune( false )
									if SCENE and SCENE.Enemies and SCENE.Enemies[ v.Tag ] and SCENE.Enemies[ v.Tag ].immune then
										SCENE.Enemies[ v.Tag ].immune = nil
									end
								end
							end
						end
					end
				//remove optional status
				elseif tbl.action == "remove_optional" then
					SCENE.Triggers[ tr_key ].OnTrigger = function()
						if tbl.objects then
							for k, v in pairs( NEXTBOTS ) do
								if v and v:IsValid() and v.Tag and table.HasValue( tbl.objects, v.Tag )then
									v.Optional = nil
									if SCENE and SCENE.Enemies and SCENE.Enemies[ v.Tag ] and SCENE.Enemies[ v.Tag ].opt then
										SCENE.Enemies[ v.Tag ].opt = nil
									end
								end
							end
						end
					end
				//change behaviour
				elseif tbl.action == "set_behaviour" then
					SCENE.Triggers[ tr_key ].OnTrigger = function()
						if tbl.objects and tbl.data then
							for k, v in pairs( NEXTBOTS ) do
								if v and v:IsValid() and v.Tag and table.HasValue( tbl.objects, v.Tag )then
									local paused = v.StoreBehaviour and v.StoreBehaviour ~= v:GetBehaviour() and v:GetBehaviour() == BEHAVIOUR_DUMB
									
									if paused then
										v.StoreBehaviour = tonumber( tbl.data )
									else
										v:SetBehaviour( tonumber( tbl.data ) )
									end
									if SCENE and SCENE.Enemies and SCENE.Enemies[ v.Tag ] and SCENE.Enemies[ v.Tag ].beh then
										SCENE.Enemies[ v.Tag ].beh = tonumber( tbl.data )
									end
									
									//reset idle animation just in case, might make it as a separate trigger later
									v.IdleAnim = nil
									if SCENE and SCENE.Enemies and SCENE.Enemies[ v.Tag ] and SCENE.Enemies[ v.Tag ].anim then
										SCENE.Enemies[ v.Tag ].anim = nil
									end
								end
							end
						end
					end
				//linker
				elseif tbl.action == "disarm" then
					SCENE.Triggers[ tr_key ].OnTrigger = function()
						//prevent all child triggers from being activated
						if tbl.objects then
							for k, v in pairs( TRIGGERS ) do
								if v and v:IsValid() and v.Tag and table.HasValue( tbl.objects, v.Tag )then
									v.Active = true
									v.Activated = true
									//this stuff is for optionl triggers, so make sure that you wont make yourself a dead end
								end
							end
						end
					end
				//remove arrows
				elseif tbl.action == "removearrows" then
					SCENE.Triggers[ tr_key ].OnTrigger = function()
						Entity(1):CleanArrows()
					end	
				//
				end
			end
		end
		
	end
	
	util.AddNetworkString( "StartDialogue" )
	util.AddNetworkString( "FinishDialogue" )
	
	function GM:StartDialogue( key )
		
		if !game.SinglePlayer() then return end
		
		if not ( SCENE.Dialogues and SCENE.Dialogues[ key ] ) then return end
		
		Entity(1):SetLocalVelocity( vector_origin )
		Entity(1):SetMoveType( MOVETYPE_NONE )
		
		timer.Simple( 0, function()
		
			CUR_DIALOGUE = key
			
			Entity(1):SetLocalVelocity( vector_origin )
			Entity(1):SetMoveType( MOVETYPE_NONE )
			
			//basically, instead of sending entire table for no reason, we will just send reference to entities and load the table on client
			local KeyToEnt = {}
			KeyToEnt[ "player" ] = Entity( 1 )
			
			local tbl = SCENE.Dialogues[ key ]
			
			for _, stuff in pairs( tbl ) do
				if KeyToEnt[ stuff.person ] then continue end
				for k, v in pairs( NEXTBOTS ) do
					if v and v:IsValid() and v.Tag and v.Tag == stuff.person then
						KeyToEnt[ stuff.person ] = v
						break
					end
				end
				
			end
			
			net.Start( "StartDialogue" )
				net.WriteString( key )
				net.WriteTable( KeyToEnt )
			net.Broadcast()
			
			if SCENE.Events and SCENE.Events[ "OnDialogueStarted" ] then
				for k, v in pairs( TRIGGERS ) do
					if v and v:IsValid() and v.Tag and v.Data and table.HasValue( SCENE.Events[ "OnDialogueStarted" ], v.Tag ) and table.HasValue( v.Data, key ) then
						v.Active = true
						v:StartTouch( Entity(1) )
					end
				end
			end
			
		end)
		
		timer.Simple( 0.1, function() 
			Entity(1):SetLocalVelocity( vector_origin )
			Entity(1):SetMoveType( MOVETYPE_NONE )
		end )
		timer.Simple( 1, function() 
			Entity(1):SetLocalVelocity( vector_origin )
			Entity(1):SetMoveType( MOVETYPE_NONE )
		end )
		
		self:PauseEnemies( true )
		
		//self:DoEvents( "OnDialogueStarted" )
		
	end
	
	net.Receive( "FinishDialogue", function( len )
		
		if !game.SinglePlayer() then return end
		
		GAMEMODE:FinishDialogue()
		
	end)
	
	function GM:FinishDialogue()
	
		Entity(1):SetMoveType( MOVETYPE_WALK )
		
		if CUR_DIALOGUE then
			self:PauseEnemies( false )
		end
		
		if SCENE.Events and SCENE.Events[ "OnDialogueFinished" ] and CUR_DIALOGUE then
			for k, v in pairs( TRIGGERS ) do
				if v and v:IsValid() and v.Tag and v.Data and table.HasValue( SCENE.Events[ "OnDialogueFinished" ], v.Tag ) and table.HasValue( v.Data, CUR_DIALOGUE ) then
					v.Active = true
					v:StartTouch( Entity(1) )
				end
			end
		end
		
		if SCENE then
			if SCENE.Name == "mutilation" and CUR_DIALOGUE == "d5" then
				self:UnlockAchievement( "safety" )
			end
			
			if SCENE.Name == "bad idea" and CUR_DIALOGUE == "d2" then
				self:UnlockAchievement( "sog" )
			end
			
			if SCENE.Name == "the bottom" and CUR_DIALOGUE == "d3" then
				for _, p in pairs( NEXTBOTS ) do
					if IsValid( p ) and p:Alive() and p.Tag == "e19" then
						self:UnlockAchievement( "sorry" )
						break
					end
				end
			end
			
		end
		

		//self:DoEvents( "OnDialogueFinished" )
		
		CUR_DIALOGUE = nil
	
	end
	
	function GM:ActivateStage( num )
		
		CUR_STAGE = num
		
		self:SpawnEnemies( SCENE.Enemies, num )
		self:SpawnTriggers( SCENE.Triggers, false, num )
		
		if SCENE.Events and SCENE.Events[ "OnStageStart" ] then
			//print"checking for stage start events"
			for k, v in pairs( TRIGGERS ) do
				if v and v:IsValid() and v.Tag and v.Data and table.HasValue( SCENE.Events[ "OnStageStart" ], v.Tag ) and tonumber( v.Data ) == num then
					//print("activating "..v.Tag)
					v.Active = true
					v:StartTouch( Entity(1) )
				end
			end
		end
				
	end
	
	function GM:SpawnEnemies( scene_tbl, stage_override )
		
		if not scene_tbl then return end
		
		if stage_override then
			
		else
			self:RemoveNextbots()
		end
		
		local stage_skip
		
		//dont respawn existing nextbots when new stage kicks in
		if stage_override and NEXTBOTS then
			stage_skip = {}
			
			for k, v in pairs( NEXTBOTS ) do
				if v and v:IsValid() and v.Tag then
					if v.Stages then
						for _, stage_num in pairs( v.Stages ) do
							if stage_num and stage_num == stage_override then
								stage_skip[ v.Tag ] = true
								break
							end
						end
					else	
						stage_skip[ v.Tag ] = true
					end
				end
			end
			
		end
		
		//for bot_key, tbl in pairs( scene_tbl ) do
		for i=1, ENEMY_MAX_ID do
			//make sure that they spawn in proper order
			local bot_key = "e"..i
			local tbl = scene_tbl[bot_key]
			if not tbl then continue end
			
			//skip spawning if we have it in triggers
			local skip = false
			if tbl.CheckTriggers then 
				for k, v in pairs( tbl.CheckTriggers ) do
					if SCENE.Triggers and SCENE.Triggers[v] and SCENE.Triggers[v].action == "spawn" and not SCENE.Triggers[v].discard then
						skip = true
						break
					end
				end
			end
			//skip if that bot doesnt belongs to a current stage
			if tbl.stages and #tbl.stages > 0 then
				for k, v in pairs( tbl.stages ) do
					if CUR_STAGE and !table.HasValue( tbl.stages, CUR_STAGE ) then
						skip = true
						break
					end
				end
			else
				//scene_tbl[bot_key].stages = { 1 }
				//PrintTable( scene_tbl[bot_key] )
			end
			
			if stage_skip and stage_skip[ bot_key ] then 
				skip = true
			end
			
			if skip then continue end
			local b = GAMEMODE:SpawnBot( tbl.wep or nil, tbl.char or "default", tbl.pos or nil, tbl.ally and TEAM_PLAYER or TEAM_MOB, tbl.ally and TEAM_MOB or TEAM_PLAYER, tbl.ally and TEAM_MOB or TEAM_PLAYER )
			b:SetAngles( tbl.ang )
			b.IgnoreTeamDamage = tbl.ally and TEAM_PLAYER or TEAM_MOB
			b.AllowRespawn = false
			if tbl.ally then
				b.Ally = true
			end
			if tbl.opt then
				b.Optional = true
			end
			if tbl.stages then
				b.Stages = tbl.stages
			end
			if tbl.beh then
				if tbl.beh == BEHAVIOUR_FOLLOWER then
					if tbl.ally then
						b:SetOwner( Entity( 1 ) )
						b.IdleSpeed = b.WalkSpeed
					end
					local off = VectorRand()
					off.z = 0
					b.FollowOffset = off
				end
				
				local beh = tbl.beh
				
				//66 % to give this behaviour instead of default one
				if b.AltBehaviour then
					if math.random( 3 ) ~= 1 then
						beh = b.AltBehaviour
						b.Optional = true
					end
				end
				
				b:SetBehaviour( beh )
			end
			if tbl.anim then
				b.IdleAnim = tbl.anim
			end
			if tbl.immune then
				b:SetImmune( true )
			end
			if tbl.icon then
				b:SetDTString( 1, tbl.icon )
			end
			
			b.Tag = bot_key
			b.NoSpawnProtection = true
			
			//just in case
			if CUR_DIALOGUE then
				self:PauseEnemies( true )
			end
			
		end
		
	end
	
	function GM:SpawnWeapons( scene_tbl )
		
		if not scene_tbl then return end
				
		for wep_key, tbl in pairs( scene_tbl ) do
			local skip = false
			if tbl.CheckTriggers then 
				for k, v in pairs( tbl.CheckTriggers ) do
					if SCENE.Triggers and SCENE.Triggers[v] and SCENE.Triggers[v].action == "spawn" and not SCENE.Triggers[v].discard then
						skip = true
						break
					end
				end
			end
			
			if tbl.stages and #tbl.stages > 0 then
				for k, v in pairs( tbl.stages ) do
					if CUR_STAGE and !table.HasValue( tbl.stages, CUR_STAGE ) then
						//skip = true
						break
					end
				end
			else
				//scene_tbl[wep_key].stages = { 1 }
				//PrintTable( scene_tbl[bot_key] )
			end
			
			if skip then continue end
			local pr = ents.Create( "dropped_weapon" )
				pr:SetPos( tbl.pos + vector_up * 15 )
				pr:SpawnAsWeapon( tbl.wep )
				pr.NoKnockback = false
				pr.MapBased = true
			pr:Spawn()
			local phys = pr:GetPhysicsObject()
			if IsValid(phys) then
				phys:SetVelocityInstantaneous( vector_up * 130 )
			end
			pr.Tag = wep_key
		end
		
	end
	
	function GM:SpawnTriggers( scene_tbl, restart, stage_override )
		
		if not scene_tbl then return end
		
		if stage_override then
			
		else
			for k, v in pairs( TRIGGERS ) do
				if v and v:IsValid() and ( v.Dialogue and not v.Activated or !v.DontRemove ) then
					if v.Dialogue and not v.Activated then
						if SCENE.Triggers[ v.Tag ] then
							SCENE.Triggers[ v.Tag ].bypass_skip = true
						end
					end
					v:Remove()
				end
			end
		end
		
		local stage_skip
		
		if stage_override and TRIGGERS then
			stage_skip = {}
			
			for k, v in pairs( TRIGGERS ) do
				if v and v:IsValid() and v.Tag then
					if v.Stages then
						for _, stage_num in pairs( v.Stages ) do
							if stage_num and stage_num == stage_override then
								stage_skip[ v.Tag ] = true
								break
							end
						end
					else
						stage_skip[ v.Tag ] = true
					end
				end
			end
			
		end
	
		for tr_key, tbl in pairs( scene_tbl ) do
			local skip = false
			local disable = false
			if tbl.CheckTriggers then 
				for k, v in pairs( tbl.CheckTriggers ) do
					if SCENE.Triggers and SCENE.Triggers[v] and SCENE.Triggers[v].action == "spawn" and not SCENE.Triggers[v].discard then
						skip = true
						break
					end
				end
			end
			
			if restart and tbl.action == "dialogue" and !tbl.bypass_skip then continue end
			if restart and tbl.trigger_once then continue end
			
			if tbl.stages and #tbl.stages > 0 then
				for k, v in pairs( tbl.stages ) do
					if CUR_STAGE and !table.HasValue( tbl.stages, CUR_STAGE ) then
						skip = true
						break
					end
				end
			else
				//scene_tbl[tr_key].stages = { 1 }
				//PrintTable( scene_tbl[bot_key] )
			end
			
			if stage_skip and stage_skip[ tr_key ] then 
				skip = true
			end

			if skip then continue end
			
			//print( "Spawning "..tr_key )
			
			if SCENE.Triggers[ tr_key ].bypass_skip then
				SCENE.Triggers[ tr_key ].bypass_skip = false
			end
			
			//and check if we want to disable the trigger, in case if it will be activated by event
			if tbl.CheckTriggers then 
				for k, v in pairs( tbl.CheckTriggers ) do
					if SCENE.Triggers and SCENE.Triggers[v] and SCENE.Triggers[v].action == "event" then
						disable = true
						break
					end
				end
			end
			//disable actual events as well
			if tbl.action == "event" then
				disable = true
			end
			if tbl.action == "nextlevel" then
				local e = ents.Create( "trigger_nextlevel" )
					e:SetPos( tbl.pos )
					if tbl.data then
						e.Data = tbl.data
					end
				e:Spawn()
				if disable then
					e.Active = false
				end
				e.Tag = tr_key
				e:SetSize( tbl.size or 100 )
			else
				local e = ents.Create( "trigger_default" )
					e:SetPos( tbl.pos )
					if tbl.OnTrigger then
						e.Trigger = tbl.OnTrigger
					end
					if tbl.data then
						e.Data = tbl.data
					end
				e:Spawn()
				e.Tag = tr_key
				if disable then
					e.Active = false
				end
				e:SetSize( tbl.size or 100 )
				if tbl.trigger_once or tbl.action == "dialogue" then
					e.DontRemove = true
				end
				if tbl.action == "dialogue" then
					e.Dialogue = true
				end
			end
		end
		
	end
	
	function GM:GametypePlayerInitialSpawn( pl )
		pl:DrawShadow( false )
			
		if not pl.FirstSpawn and not pl:IsBot() then
			pl:SetTeam( TEAM_SPECTATOR )
			pl:SendLua( "ManageFirstSpawn(\""..self:GetGametype().."\", true)" )
			pl.FirstSpawn = true
			return
		end
			
		pl:UnSpectate()
		pl:SetTeam( TEAM_PLAYER )
		
		pl:SetFlipView( SCENE.FlipView or false )		
		
	end
	
	function GM:GametypePlayerSpawn( pl )
		local col = pl:GetCharTable().OverrideColor or team.GetColor( pl:Team() )	
		pl:SetPlayerColor( Vector( col.r/255, col.g/255, col.b/255) )
		
		pl:SetPos( PLAYER_SPAWNPOINT )
		
		self:SetRoundState( ROUNDSTATE_ACTIVE )
		
		if SCENE.PlayerSpawn then
			SCENE.PlayerSpawn()
		end
		
		if NIGHTMARE and DRUG_EFFECT then
			pl:SetDSP( 29, false )
		end
		
		//if self:GetRoundState() ~= ROUNDSTATE_RESTARTING then
			//if self:GetRoundState() == ROUNDSTATE_IDLE then
				if not self.OnLevelLoaded then
					if SCENE.Triggers then
						self:SpawnTriggers( SCENE.Triggers )
					end
					if SCENE.Enemies then
						self:SpawnEnemies( SCENE.Enemies )
					end
					if SCENE.SpawnMobs then
						self:RemoveNextbots()
						SCENE.SpawnMobs()
					end
					if SCENE.Pickups then
						self:SpawnWeapons( SCENE.Pickups )
					end
					
					//timer.Simple( 0.5, function()
						//if self then
							self:DoEvents( "OnLevelLoaded" )
						//end
					//end)
					
					if SCENE.LightStyle then
						engine.LightStyle( 0, SCENE.LightStyle )
						pl:SendLua( "render.RedownloadAllLightmaps( true )" )
					end
				
				self.OnLevelLoaded = true
				end
			//end
		//end
		
		/*if not self.OnLevelLoaded then
			timer.Simple( 0.5, function()
				if self then
					self:DoEvents( "OnLevelLoaded" )
				end
				end)
			self.OnLevelLoaded = true
		end*/
		
	end	
	
	function GM:GametypeDoPlayerDeath( pl, attacker, dmginfo )
	
		self:DoEvents( "OnPlayerDeath" )
		
		if self:GetRoundState() == ROUNDSTATE_RESTARTING then return end
		
		pl.NextSpawnTime = CurTime() + 1
		
		self:SetRoundState( ROUNDSTATE_END )
		
	end
	
	function GM:GetNextBotCountSingleplayer()
	
		local count = 0

		if not NEXTBOTS then return 0 end
		
		for k, v in pairs( NEXTBOTS ) do
			if v and v:IsValid() and v:Alive() then
				if v.IgnoreDeaths then continue end
				if v.Ally then continue end
				if v.Optional then continue end
				count = count + 1
			end
		end
		
		return count

	end
	
	function GM:GametypeDoNextBotDeath( pl, attacker, dmginfo )
				
		if pl.IgnoreDeaths then return end
		if pl.Ally then return end
		if pl.Optional then return end
				
		local alive = false
		
		
		for _, p in pairs( NEXTBOTS ) do
			if IsValid( p ) and p:Alive() and p ~= pl then
				if p.IgnoreDeaths then continue end
				if p.Ally then continue end
				if p.Optional then continue end
				alive = true
				break
			end
		end
		
		if SCENE and SCENE.Name == "big server men" and pl.Tag and pl.Tag == "e5" then
			self:UnlockAchievement( "shadycar" )
		end
		
		if SCENE and SCENE.Name == "served cold" and pl.Tag and pl.Tag == "e17" then
			self:UnlockAchievement( "bsm" )
		end
		
		if SCENE and SCENE.Name == "wild ride" and pl.Tag and pl.Tag == "e35" then
			self:UnlockAchievement( "cptedge" )
		end
				
		if not alive then
			self:DoEvents( "OnAllEnemiesKilled" )
			
			if SCENE then
				if SCENE.Name == "mutilation" then
					self:UnlockAchievement( "lust" )
				end
			end
		else
			if SCENE and SCENE.ShowLastEnemies and Entity(1):Alive() then
				if self:GetNextBotCountSingleplayer() <= 5 then
					for _, p in pairs( NEXTBOTS ) do
						if p and p:IsValid() and p:Alive() then
							if p.IgnoreDeaths then continue end
							if p.Ally then continue end
							if p.Optional then continue end
							Entity(1):AddArrow( p, nil, true )
						end
					end
				end
			end
			
		end
		
		if !NO_LEVEL_CLEAR then
			if not alive then			
				self:FinishRound()
			end
		end
	end
	
	function GM:OnPlayerDeathThink( pl )
		
		if self:GetRoundState() == ROUNDSTATE_END and pl.NextSpawnTime and pl.NextSpawnTime < CurTime() and (( pl:KeyPressed( IN_ATTACK ) || pl:KeyPressed( IN_ATTACK2 ) ) or pl:IsBot()) then
			self:RestartRound()
		end
		
		if pl:KeyPressed( IN_JUMP ) then
			if pl:GetCharTable().Styles then
				pl:SendLua( "DrawCharacterMenu( nil, \""..tostring(self:GetCharacterReferenceById( pl:GetCharacter() )).."\" )" )
				return
			end
			if #self.UseCharacters > 1 then
				pl:SendLua( "DrawCharacterMenu()" )
				return
			end
			
		end
		
	end
	
	function GM:OnNextBotKnockdown( ply, attacker )
		if SCENE.Events and SCENE.Events[ "OnNextBotKnockdown" ] and ply.Tag then
			for k, v in pairs( TRIGGERS ) do
				if v and v:IsValid() and v.Tag and v.Data and table.HasValue( SCENE.Events[ "OnNextBotKnockdown" ], v.Tag ) and table.HasValue( v.Data, ply.Tag ) then
					v.Active = true
					v:StartTouch( Entity(1) )
				end
			end
		end
	end
	
	function GM:OnEntityRemoved( ent )
		
		if SCENE and SCENE.Events and SCENE.Events[ "OnWeaponRemoved" ] and ent.Tag and !ent.RemovedByGame then
			for k, v in pairs( TRIGGERS ) do
				if v and v:IsValid() and v.Tag and v.Data and table.HasValue( SCENE.Events[ "OnWeaponRemoved" ], v.Tag ) and table.HasValue( v.Data, ent.Tag ) then
					v.Active = true
					v:StartTouch( Entity(1) )
				end
			end
		end
		
	end

end


util.AddNetworkString( "SOG_UnlockAchievement" )

function GM:UnlockAchievement( id )
	
	if not CHECKED_ACHIEVEMENTS then
		self:ReloadAchievements()
		CHECKED_ACHIEVEMENTS = true
	end
	
	if not self.Achievements[ id ] then return end
	if self.PlayerAchievements[ id ] then return end
	
	self.PlayerAchievements[ id ] = true
	
	local tbl = {}
	
	local path = "slaveofgmod/achievements.txt"
	
	for ach, _ in pairs( self.Achievements ) do
		if self.PlayerAchievements[ ach ] then
			table.insert( tbl, ach )
		end
	end
	
	file.Write( path, util.TableToJSON( tbl ) )
	
	net.Start( "SOG_UnlockAchievement" )
		net.WriteString( tostring( id ) )
	net.Broadcast( )
	
end

//not putting it in shared so I can only have serverside part in singleplayer, because we still want client to be able to view achievements outside of singleplayer
function GM:ReloadAchievements()
	
	if !file.Exists( "slaveofgmod", "DATA" ) then
		file.CreateDir("slaveofgmod")
	end
	
	self.PlayerAchievements = self.PlayerAchievements or {}
	
	local path = "slaveofgmod/achievements.txt"
	
	if not file.Exists( path, "DATA" ) then
		file.Write( path, util.TableToJSON( { } ) )
	end
	
	local read = util.JSONToTable( file.Read( path ) )
	
	for _, ach in pairs( read ) do
		if self.Achievements[ ach ] then
			self.PlayerAchievements[ ach ] = true
		end
	end
	
end

hook.Add( "PlayerSay", "Sog_SingleplayerGoodies", function( pl, text, team_only )
	
	if string.lower( string.sub( text, 1, 9  ) ) == "!superhot" and game.SinglePlayer() then
		if not SUPERHOT then
			SUPERHOT = true
		else
			SUPERHOT = false
		end
		return ""
	end
	
	if string.lower( string.sub( text, 1, 12  ) ) == "!firstperson" and game.SinglePlayer() then
		if GAMEMODE:GetFirstPerson() then
			GAMEMODE:SetFirstPerson( false )
		else
			GAMEMODE:SetFirstPerson( true )
		end
		return ""
	end

end)

end




//Clientside part
if CLIENT then

SOG_CAMPAIGN_TEST = util.tobool( CreateClientConVar("sog_campaign_test", 0, true, false):GetInt() )
cvars.AddChangeCallback("sog_campaign_test", function(cvar, oldvalue, newvalue)
	SOG_CAMPAIGN_TEST = util.tobool( newvalue )
end)


SOG_PROGRESS = CreateClientConVar("sog_progress", 1, true, false):GetInt()
cvars.AddChangeCallback("sog_progress", function(cvar, oldvalue, newvalue)
	SOG_PROGRESS = math.max( tonumber( newvalue ), 1 )
end)

concommand.Add( "sog_takemetohell", function(pl,cmd,args)
	
	if not game.SinglePlayer() then return end
	
	RunConsoleCommand( "sog_progress", tostring( math.max( 25, SOG_PROGRESS ) ) )
	RunConsoleCommand( "changelevel", game.GetMap() )
	
end )

if game.SinglePlayer() and SINGLEPLAYER then
	
	SCENE = SCENES[ CUR_SCENE ] or SCENES[ 1 ]
	
	if EDITOR_SCENE then
		SCENE = EDITOR_SCENE
	end
		
	if SCENE.Initialize then
		SCENE.Initialize()
	end
	
	if SCENE.Nightmare then
		NIGHTMARE = true
	end
	
	if SCENE.DrugEffect then
		DRUG_EFFECT = true
	end
	
	if SCENE.Terror then
		TERROR = true
	end
	
	if SCENE.BadassMode then
		BADASS_MODE = true
	end
	
	if SCENE.BloodyScreen then
		BLOODY_SCREEN = true
	end
	
	if SCENE.Screams then
		SCREAMS = true
	end
	
	if SCENE.BloodMoonScreen then
		EVIL_SCREEN = true
	end
	
	if SCENE.AddThunder then
		THUNDER_BACKGROUND = true
		
		function GM:OnThink()
			
			local MySelf = LocalPlayer()
			
			if IsValid( MySelf ) and ( MySelf:Team() ~= TEAM_SPECTATOR or MySelf:Team() ~= TEAM_CONNECTING ) then
				self:CheckThunder()
			end
		end
	end
	
	if SCENE.Characters then
		GM.UseCharacters = SCENE.Characters
		if #GM.UseCharacters == 1 then
			OVERRIDE_CHARACTER = GM.UseCharacters[1]
		end
	end
	
	function GM:SwitchAmbientToMusic()
		if not SCENE then return end
		if !SOG_AUTOPLAY_MUSIC then return end
		
		if IsValid( self.SceneAmbient ) then
			self.SceneAmbient:Stop()
		end
		
		if SCENE.SoundTrack and IsValid( self.Music ) then
			self.Music:Play()
			self.MusicStarted = CurTime()
		end
		
		/*if self.SceneAmbient and self.SceneAmbient:IsValid() then
			self.SceneAmbient:Remove()
			self.SceneAmbient = nil
		end
		
		if SCENE.SoundTrack and self.Radio and self.Radio:IsValid() then
			self.Radio:RunJavascript( "Play();" )
		end*/
		
		//self:RemoveRadio()
		
		//if SCENE.SoundTrack then
		//	self.Radio = self:CreateSCPanel( nil, SCENE.SoundTrack, SCENE.Volume or 20, false, false, SCENE.StartFrom or 0, SCENE.EndAt or nil  )
		//end
		
	end
	


	
	net.Receive( "CheckStoryProgress", function( len )
		
		if !game.SinglePlayer() then return end
		
		local num = net.ReadInt( 32 )
		
		if num then
			if SOG_PROGRESS < ( num + 1 ) then
				RunConsoleCommand( "sog_progress", tostring( num + 1 ) )
			end
		end
	
	end)
	
	net.Receive( "PlayFinalCutscene", function( len )
		
		if !game.SinglePlayer() then return end
		
		if IsValid( GAMEMODE.Ambient ) then
			GAMEMODE.Ambient:Pause()
		end
		
		DISABLE_RENDER = true
		
		local cut_name = net.ReadString()
		local next_scene = net.ReadInt( 32 )
		
		local f = function()
			//RunConsoleCommand( "changelevel", tostring( game.GetMap() ) )
			RunConsoleCommand( "sog_singleplayer_changelevel", tostring( next_scene ) )
		end
		
		if GAMEMODE.SingleplayerCutscenes[ cut_name ] then
			DrawCutscene( GAMEMODE.SingleplayerCutscenes[ cut_name ], f )
		else
			f()
		end

	end)
	
	net.Receive( "StartDialogue", function( len )
		
		if !game.SinglePlayer() then return end
		
		local key = net.ReadString()
		local KeyToEnt = net.ReadTable()
		
		if SCENE.Dialogues and SCENE.Dialogues[ key ] then
			
			for i=1, #SCENE.Dialogues[ key ] do
				
				local p = SCENE.Dialogues[ key ][ i ].person
				local text = SCENE.Dialogues[ key ][ i ].text
				local person = KeyToEnt[ p ]

				if p and text and person then
					//hacky way to override icon
					if not person.Icon and person:IsNextBot() then
						if person:GetDTString( 1 ) ~= "" then
							person.Icon = Material( person:GetDTString( 1 ), "smooth" )
						end
					end

					AddDialogueLine( person, unpack( text ) )
				end
				
			end
			
			DrawDialogue( true )
			
		end
		
	end)
	
end

	net.Receive( "SOG_UnlockAchievement", function( len )
		
		local id = net.ReadString()
		
		if GAMEMODE.PlayerAchievements then
			GAMEMODE.PlayerAchievements[id] = true
			timer.Simple( 1, function() GAMEMODE:DrawAchievement( id )  end )
			
		end
		
	end)

end