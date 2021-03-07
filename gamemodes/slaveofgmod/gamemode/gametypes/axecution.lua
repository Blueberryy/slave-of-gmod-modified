//Before you say "that is a lot of duplicate code". yes it is.

GM.Gametypes = GM.Gametypes or {}

//some convars
if SERVER then
	//how much people rquired to spawn a server owner
	AXECUTION_SERVER_OWNER_PLAYERS = CreateConVar("sog_axecution_so_players", 10, FCVAR_ARCHIVE + FCVAR_NOTIFY, "Amount of players required for a server owner to spawn in Axecution."):GetInt()
	cvars.AddChangeCallback("sog_axecution_so_players", function(cvar, oldvalue, newvalue)
		AXECUTION_SERVER_OWNER_PLAYERS = newvalue
	end)
	AXECUTION_BOTS = util.tobool(CreateConVar("sog_axecution_bots_enable", 1, FCVAR_ARCHIVE + FCVAR_NOTIFY, "Enable or disable bots for Axecution."):GetInt())
	cvars.AddChangeCallback("sog_axecution_bots_enable", function(cvar, oldvalue, newvalue)
		
		AXECUTION_BOTS = util.tobool( newvalue )
		
		if GAMEMODE:GetGametype() ~= "axecution" then return end
		
		if AXECUTION_BOTS then
			GAMEMODE:SpawnAxecutionBots()
		else
			GAMEMODE:RemoveRDMBots()
		end
		
	end)
	AXECUTION_BOTS_AMOUNT = CreateConVar("sog_axecution_bots_imitate_amount", 12, FCVAR_ARCHIVE + FCVAR_NOTIFY, "Bots will imitate this amount of players. Also its a damn long convar name."):GetInt()
	cvars.AddChangeCallback("sog_axecution_bots_imitate_amount", function(cvar, oldvalue, newvalue)
		AXECUTION_BOTS_AMOUNT = newvalue
	end)
end

function GM:AxecutionInitialize()
	
	GAMEMODE.UseCharacters = { "axe guy", "carl", "steve" }
	
	GAMEMODE.GametypeName = translate.Get("sog_gametype_name_axecution")

	print"Gametype Initialized"
	TEAM_AXE = 6 //Clavus and his ideas about "Axe guy"
	TEAM_MOB = 7
	
	OBJECTIVE_CLASS = "ent_secure"
	
	NO_PICKUPS = true //disables the weapon pickups
	PICKUP_PERSISTANCE = true //pickups dont dissapear
	BOT_IGNORE_CLASS = true //bots will obey the player character selection, only useful in this gametype
	
	team.SetUp(TEAM_AXE, "PROTAGONIST", Color(155,16,16,255))//Color(255,66,0,255)
	team.SetUp(TEAM_MOB, "DEAD MEAT", Color(255,255,255,255))
	
	function self:PlayerShouldTakeDamage(pl, attacker)
		if attacker.Team then
			if pl:Team() == attacker:Team() then
				return false
			end 
		end
		return true
	end
	
	if SERVER then
	
		team.SetSpawnPoint( TEAM_AXE, "info_player_main" )
		team.SetSpawnPoint( TEAM_MOB, "info_player_mob" )
	
		CURRENT_AXE = 1
		TRIES_PER_AXE = 2
		
		SERVER_OWNER = nil
		
		JOIN_TIME = 30
		
		DISABLE_TEAM_PUNCHING = true
		
		function player.GetActive()
			
			local tbl = team.GetPlayers( TEAM_MOB )
			tbl = table.Add( team.GetPlayers( TEAM_AXE ) )
			
			return tbl
			
		end
		
		function self:OnMapReset()
			
			self:SpawnRandomPrinters()
			
		end
		
		function self:OnPlayerAuthed(pl)
			pl:SendLua("GAMEMODE:AxecutionInitialize()")
		end
		
		function self:SpawnAxecutionBots()
			
			self:RemoveRDMBots()
			
			if !AXECUTION_BOTS then return end
			
			local am = math.max( AXECUTION_BOTS_AMOUNT - #player.GetAll() + 1 , 0 ) //+ 1 is because we exclude axe guy
			
			if am == 0 then return end
			
			if not AXECUTION_BOT_SPAWNS then
				AXECUTION_BOT_SPAWNS = {}
				
				for k,v in ipairs( INFO_PLAYER_MOB ) do
					table.Add( AXECUTION_BOT_SPAWNS, self:GetSpotsAroundPos( v:GetPos(), 400, true ) )
				end
				
				//no nav mesh or something, fall back to plan B
				//if #AXECUTION_BOT_SPAWNS < 1 then
					for k,v in ipairs( INFO_PLAYER_MOB ) do
						table.insert( AXECUTION_BOT_SPAWNS, v:GetPos() )
					end
				//end
			
				//print"-----------"
				//PrintTable(AXECUTION_BOT_SPAWNS)
				
			end
			
			local spawns = AXECUTION_BOT_SPAWNS//ents.FindByClass("info_player_mob")
			
			local admins = 0
			local banned = 0
			local cops = 0
	
			local spawnpoint = 1
	
			for i=1, am do
				local pos 
				local spawn = spawns[ spawnpoint ]//spawns[ math.random( #spawns ) ]
				
				pos = spawn
				
				spawnpoint = spawnpoint + 1
							
				if spawnpoint > #spawns then
					spawnpoint = 1
				end
				
				/*if spawn then
					local vec = VectorRand()*math.random(20,40)
					vec.z = 0
					pos = spawn:GetPos()// + vec
				end*/
				
				local char = "kid"
				local weapon = char == "kid" and "sogm_physcannon" or nil
				
				if math.random(6) == 6 and admins < 1 then
					char = "admin"
					weapon = math.random(3) == 3 and "sogm_uzi" or "sogm_shotgun"
					admins = admins + 1
				end
				
				if math.random(3) == 3 and char == "kid" and banned < 2 then
					char = "banned"
					weapon = nil
					banned = banned + 1
				end
				
				if math.random(3) == 3 and char == "kid" and cops < 5 then
					char = "cop kid"
					weapon = nil
					cops = cops + 1
				end
				
				
				local b = self:SpawnBot( weapon, char, pos, TEAM_MOB, TEAM_AXE, nil )
				b.IgnoreTeamDamage = TEAM_MOB
				b.AllowRespawn = false
				b:SetNextBotColor( color_white )
				b.StuckPositions = AXECUTION_BOT_SPAWNS
				
			end
			
		end
		
		function self:SpawnRandomPrinters()
			
			for k,v in pairs( ents.FindByClass( OBJECTIVE_CLASS or "ent_secure" ) ) do
				if v and v:IsValid() then
					v:Remove()
				end
			end
			
			if #player.GetAll() < 3 then return end
			
			local spawns = table.Copy( ents.FindByClass( "point_secure" ) )
			
			local max = math.min( 2, #spawns )
			
			for i=1, max do
				
				local r = math.random(#spawns)
				local s = spawns[ r ]
				
				if s then
					local pr = ents.Create( OBJECTIVE_CLASS or "ent_secure" )
					pr:SetPos( s:GetPos() + vector_up * 50 )
					pr:Spawn()
					spawns[ r ] = nil
					table.Resequence( spawns )
				end
				
			end
		
		end
		
		local vectors = {
				Vector(1,0,0),
				Vector(-1,0,0),
				Vector(0,1,0),
				Vector(0,-1,0),
				Vector(1,1,0),
				Vector(1,-1,0),
				Vector(-1,1,0),
				Vector(-1,-1,0),
			}
		local trace = {mask = MASK_SOLID}
		function self:OnInitPostEntity()
			
			self:SpawnRandomPrinters()
			
		
				local clear = false
				local stop = false
				
				
				local car_spawns = ents.FindByClass("point_car")
				local normal_pos
				local normal_ang
				
				if #car_spawns > 0 then
					if car_spawns[1] then
						normal_pos = car_spawns[1]:GetPos()
						normal_ang = car_spawns[1]:GetAngles()
					end
				end
				
				::spawncar::
			
				table.Shuffle( vectors )
				
				local spawns1 = ents.FindByClass("info_player_main")
				
				local spawn1 = spawns1[math.random(#spawns1)]
				
				local pos = spawn1:GetPos()
				local ang = Angle(0,math.random(-180,180),0)//spawn1:GetAngles()
				local min, max = Vector( -90, -90, 0 ), Vector( 90, 90, 50 )
				
				
				
				for i=1, 15 do
					for k,v in pairs(vectors) do
						
						local newpos = pos + v * 30 * i
						
						trace.start = newpos + vector_up*10
						trace.endpos = newpos + vector_up*10
						trace.mins = min
						trace.maxs = max
						
						local tr = util.TraceHull( trace )
						
						trace.start = newpos + vector_up*10
						trace.endpos = newpos - vector_up*40
						
						local tr2 = util.TraceLine( trace )
											
						if !tr.Hit and tr2.Hit and tr2.HitWorld then
							local blocking = false
							
							for _, sp in pairs(spawns1) do
								if newpos:Distance(sp:GetPos()) <= 150 then
									blocking = true
								end
							end
							
							if !blocking and newpos:Distance(pos) <= 400 then
								clear = true
								ang = (pos-newpos):GetNormal():Angle()
								pos = newpos
								stop = true
							end
						end
						if stop then break end
					end
					if stop then break end
				end
				
				if clear or normal_pos and normal_ang then
									
					local car = ents.Create("prop_physics")
					car:SetModel("models/props/de_nuke/car_nuke_black.mdl")
					car:SetPos( normal_pos or pos )
					car:SetAngles( normal_ang or ang+Angle(0,math.random(80,100),0) )
					car:SetMoveType( MOVETYPE_NONE )
					car:Spawn()
					local phys = car:GetPhysicsObject()
					if phys and phys:IsValid() then
						phys:EnableMotion( false )
					end
					
					local glass = ents.Create("prop_physics")
					glass:SetModel("models/props/de_nuke/car_nuke_glass.mdl")
					glass:SetPos( car:GetPos() )
					glass:SetAngles( car:GetAngles() )
					glass:SetMoveType( MOVETYPE_NONE )
					glass:SetSolid( SOLID_NONE )

					glass:Spawn()
					local phys = glass:GetPhysicsObject()
					if phys and phys:IsValid() then
						phys:EnableMotion( false )
					end
					
					self.Car = car
				end
			
			
			if !IsValid(self.Car) then goto spawncar end
			
		end
		
		function self:RoundStart()
			
			self:SetRoundTime( CurTime() )
			
			self:SetRoundState( ROUNDSTATE_IDLE )
		
		end
		
		function self:RestartRound()
			
			print"Restarting Round"
			
			if team.NumPlayers(TEAM_MOB) < 1 or #player.GetAll() < 1 then
				CURRENT_AXE = 1
			end
			
			if CHANGE_AXE then
			
			
				CURRENT_AXE = CURRENT_AXE + 1
				
				local max = game.MaxPlayers()
				
				for i=1, max do
					
					local pl = Entity( CURRENT_AXE )
					
					if IsValid( pl ) and pl:IsPlayer() and pl:Team() ~= TEAM_CONNECTING and pl:Team() ~= TEAM_SPECTATOR then break end
					if #player.GetAll() < 1 then 
						CURRENT_AXE = 1
						break 
					end
					
					CURRENT_AXE = CURRENT_AXE + 1
					
					if CURRENT_AXE > max then
						CURRENT_AXE = 1
						
						for j=1, max do
							
							local pl = Entity( CURRENT_AXE )
					
							if IsValid( pl ) and pl:IsPlayer() and pl:Team() ~= TEAM_CONNECTING and pl:Team() ~= TEAM_SPECTATOR then break end
							if #player.GetAll() < 1 then 
								CURRENT_AXE = 1
								break 
							end
							
							CURRENT_AXE = CURRENT_AXE + 1
							
						end
					end
				
				end
				
				
				if IsValid( Entity( CURRENT_AXE ) ) and Entity( CURRENT_AXE ):IsPlayer() then
					for k,v in pairs( player.GetAll() ) do
						v:ChatPrint( Entity( CURRENT_AXE ):Name().." has become the protagonist!" )
					end
				end
								
				CHANGE_AXE = false
			end
			
			SERVER_OWNER = nil			
			
			if #team.GetPlayers(TEAM_MOB) >= AXECUTION_SERVER_OWNER_PLAYERS then
				local kids = team.GetPlayers(TEAM_MOB)
				SERVER_OWNER = kids[math.random(#kids)]
				if SERVER_OWNER == Entity( CURRENT_AXE ) then
					SERVER_OWNER = kids[math.random(#kids)]
				end
			else
				SERVER_OWNER = nil
			end
			
			self:RoundStart()
			
			self:ResetMap()

			if #player.GetAll() > 0 then
				self:SpawnAxecutionBots()
			end
			
			for k, v in pairs(player.GetAll()) do
				if v:Team() == TEAM_SPECTATOR or v:Team() == TEAM_CONNECTING then continue end
				v:SetTeam(TEAM_MOB)
				self:PlayerInitialSpawn(v)
				v:Spawn()
			end
			
		end
		
		function self:GametypePlayerInitialSpawn( pl )
			
			pl:DrawShadow( false )
			
			if not pl.FirstSpawn and not pl:IsBot() then
				pl:SetTeam( TEAM_SPECTATOR )
				pl:SendLua( "ManageFirstSpawn(\""..self:GetGametype().."\")" )
				pl.FirstSpawn = true
				
				if self:GetNextBotCount() < 1 then
					self:SpawnAxecutionBots()
				end
				
				return
			end
			
			pl:SendLua("GAMEMODE:PlayMusic()")
			
			//pl.Cop = false
			
			pl:UnSpectate()
			pl:SetTeam( TEAM_MOB )
			
			
			local axe = team.GetPlayers( TEAM_AXE )
			local mob = team.GetPlayers( TEAM_MOB )
			
			local players = player.GetAll()
			
			
			//just in case if axe guy is still in menu or something
			local forceaxe = IsValid( Entity( CURRENT_AXE ) ) and Entity( CURRENT_AXE ):IsPlayer() and ( Entity( CURRENT_AXE ):Team() == TEAM_SPECTATOR or Entity( CURRENT_AXE ):Team() == TEAM_CONNECTING ) or #players == 1 or !IsValid( Entity( CURRENT_AXE ) ) 
			
			if pl == Entity( CURRENT_AXE ) or forceaxe then
				
				if forceaxe then
					CURRENT_AXE = pl:EntIndex()
				end
			
				pl:SetTeam( TEAM_AXE )
				pl.NoScore = false
				pl.NoKnockdown = true
				pl:SetFlipView( false )
				self:SetRoundState( ROUNDSTATE_ACTIVE )
				
				if math.random(2) == 2 then
					pl:SetGoal( "Kill DarkRP kids or (and) break their shitty printers", 20 )
				else
					pl:SetGoal( self:GetRandomHint(), 10 )
				end
				
				
				pl.CharacterPref = pl.StoreCharacterPref //always use our choice
				
				local col = pl:GetCharTable().OverrideColor or team.GetColor( pl:Team() )
			
				pl:SetPlayerColor( Vector( col.r/255, col.g/255, col.b/255) )
				
			else
				pl.CharacterPref = "kid"
				if math.random(4) == 4 then
					//pl.Cop = true
					pl.CharacterPref = "cop kid"
				end
			
				pl:SetTeam( TEAM_MOB )
				pl.NoScore = true
				pl.NoKnockdown = false
				pl:SetFlipView( true )
				
				if SERVER_OWNER and SERVER_OWNER ~= Entity( CURRENT_AXE ) then
					pl:SetGoal( "Protect your printers and server owner!", 20 )
				else
					if math.random(2) == 2 then
						pl:SetGoal( "Protect your worthless money printers!", 20 )
					else
						pl:SetGoal( self:GetRandomHint(), 10 )
					end
				end
				
				if SERVER_OWNER and SERVER_OWNER == pl then
					pl.CharacterPref = "server owner"
					pl:SetGoal( "Protect your greedy ass!", 20 )
				end
				
				if pl.CharacterPref == "kid" then
					pl:SpawnNearbyWeapon( "sogm_physcannon" )
				end
				
				local col = team.GetColor( TEAM_MOB )
			
				pl:SetPlayerColor( Vector( col.r/255, col.g/255, col.b/255) )
				
				/*if team.NumPlayers( TEAM_AXE ) < 1 then
					if self:GetRoundState() ~= ROUNDSTATE_RESTARTING then
						self:SetRoundState( ROUNDSTATE_RESTARTING )
						
						CHANGE_AXE = true
						
						for k,v in ipairs(player.GetAll()) do
							v:ChatPrint("Starting a new round in 5 seconds...")
						end
						
						self:RestartRoundIn( 5 )
					end
				end*/
				
			end
			
			pl.Tries = pl.Tries or 0
			
			
			
		end			
		
		function self:GametypePlayerSpawn( pl )
			
			if pl:Team() == TEAM_MOB and CurTime() - self:GetRoundTime() > JOIN_TIME and team.NumPlayers( TEAM_MOB ) > 1 or (self:GetRoundState() == ROUNDSTATE_END or self:GetRoundState() == ROUNDSTATE_RESTARTING) then
				pl:KillSilent()
			end
			
			if pl:Team() == TEAM_AXE then
				timer.Simple( 0, function()
					for k,v in pairs( ents.FindByClass("ent_secure") ) do
						local r = VectorRand()*15
						r.z = 0
						local norm = (v:GetPos()-pl:GetPos()):GetNormal() * math.random(75,90)
						norm.z = 0
						pl:AddObjectiveArrow( pl:GetPos()+norm+r, v:GetPos(), math.random(10,15) )
					end
				end)
			end
			
			timer.Simple(2, function()
				for _, ent in ipairs( ents.FindByClass( "ent_secure" ) ) do
					if IsValid( ent ) then
						pl:AddArrow( ent, ent:GetPos() )
					end
				end
			end)
		
		end
		
		function self:OnPlayerLoadout( pl )
		
			if pl:Team() == TEAM_AXE and pl:GetCharacter() == self:GetCharacterIdByReference( "axe guy" ) then
				local axe = pl:SpawnNearbyWeapon( "sogm_axe" )
				local gun
				
				//no need for now
				/*if ( #team.GetPlayers(TEAM_MOB) + self:GetNextBotCount()/3 ) >= AXECUTION_SERVER_OWNER_PLAYERS then
					gun = pl:SpawnNearbyWeapon( "sogm_m1014" )
				end*/
				
				if IsValid(self.Car) then
					axe:SetPos(self.Car:GetPos() + self.Car:GetAngles():Right() * 110 + vector_up * 30)
					axe:SetAngles( self.Car:GetAngles() + Angle(0,90,0) )
					//hacky override, so other team can pick up axes
					axe.Team = TEAM_AXE
					axe:SetImportant( TEAM_AXE )
					
					if gun then
						gun:SetPos(self.Car:GetPos() + self.Car:GetAngles():Right() * 130)
						gun:SetAngles( self.Car:GetAngles() + Angle(0,10,0) )
						gun.Team = TEAM_AXE
						gun:SetImportant( TEAM_AXE )					
					end
					
				end
				
				
				
			end
		end
		
		//handle all bot deaths here
		function self:GametypeDoNextBotDeath( pl, attacker, dmginfo )
			
				local alive = false
				for _, p in ipairs( team.GetPlayers( TEAM_MOB ) ) do
					if IsValid( p ) and p:Alive() then
						alive = true
						break
					end
				end
				
				for _, p in pairs( NEXTBOTS ) do
					if IsValid( p ) and p:Alive() and p ~= pl then
						alive = true
						break
					end
				end
			
				if pl:GetCharacter() == self:GetCharacterIdByReference( "server owner" ) and pl ~= attacker then
					
					if self:GetRoundState() == ROUNDSTATE_RESTARTING or self:GetRoundState() == ROUNDSTATE_END then return end
						
						self:SetRoundState( ROUNDSTATE_RESTARTING )
						
						if self:GetRoundState() ~= ROUNDSTATE_END then
							self:ShowLevelClear()
						end		
						
						for k,v in ipairs(player.GetAll()) do
							v:ChatPrint("The DarkRP server owner was slain. What a terrifying day for a shitty community!")
							v:ChatPrint("Starting new round in 15 seconds...")
							
							if v:Team() == TEAM_AXE and v:Alive() then
								v:AddFrags( 1 )
							end
							
						end
						
						self:RestartRoundIn( 15 )
						
						if #team.GetPlayers( TEAM_MOB ) > 0 then
							CHANGE_AXE = true
						end
					
				else
				
					if not alive then
						
						if self:GetRoundState() == ROUNDSTATE_RESTARTING or self:GetRoundState() == ROUNDSTATE_END then return end
						
						self:SetRoundState( ROUNDSTATE_RESTARTING )
						
						if self:GetRoundState() ~= ROUNDSTATE_END then
							self:ShowLevelClear()
						end		
						
						for k,v in ipairs(player.GetAll()) do
							v:ChatPrint("The DarkRP kids were slain.")
							v:ChatPrint("Starting new round in 15 seconds...")
							
							if v:Team() == TEAM_AXE and v:Alive() then
								v:AddFrags( 1 )
							end
							
						end
						
						self:RestartRoundIn( 15 )
						
						if #team.GetPlayers( TEAM_MOB ) > 0 then
							CHANGE_AXE = true
						end
						
					end
				end
			
		end
		
		function self:GametypeDoPlayerDeath( pl, attacker, dmginfo )
			
			if pl:Team() == TEAM_AXE then
				if self:GetRoundState() == ROUNDSTATE_RESTARTING or self:GetRoundState() == ROUNDSTATE_END then return end
				for k,v in ipairs(player.GetAll()) do
					v:ChatPrint(pl:GetCharTable().Name.." was slain.")
				end
				
				//dont show this stuff when there are only bots
				if #team.GetPlayers( TEAM_MOB ) > 0 then
					pl:ChatPrint("You have "..(TRIES_PER_AXE - pl.Tries).." remaining attempts.")
									
					if pl.Tries >= TRIES_PER_AXE then
						CHANGE_AXE = true
						pl.Tries = 0
					else
						pl.Tries = pl.Tries + 1
					end
				end
				pl.NextSpawnTime = CurTime() + 1
				self:SetRoundState( ROUNDSTATE_END )
			
			end
			
			if pl:Team() == TEAM_MOB then
			
				local alive = false
				local tospectate
				for _, p in ipairs( team.GetPlayers( TEAM_MOB ) ) do
					if IsValid( p ) and p:Alive() and p ~= pl then
						alive = true
						tospectate = p
						break
					end
				end
				
				for _, p in pairs( NEXTBOTS ) do
					if IsValid( p ) and p:Alive() then
						alive = true
						break
					end
				end
			
				if pl:GetCharacter() == self:GetCharacterIdByReference( "server owner" ) and pl ~= attacker then
					
					if self:GetRoundState() == ROUNDSTATE_RESTARTING or self:GetRoundState() == ROUNDSTATE_END then return end
						
						self:SetRoundState( ROUNDSTATE_RESTARTING )
						
						if self:GetRoundState() ~= ROUNDSTATE_END then
							self:ShowLevelClear()
						end		
						
						for k,v in ipairs(player.GetAll()) do
							v:ChatPrint("The DarkRP server owner was slain. What a terrifying day for a shitty community!")
							v:ChatPrint("Starting new round in 15 seconds...")
							
							if v:Team() == TEAM_AXE and v:Alive() then
								v:AddFrags( 1 )
							end
							
						end
						
						self:RestartRoundIn( 15 )
						
						CHANGE_AXE = true
						
						pl.Tries = 0
					
				else
				
					if not alive then
						
						if self:GetRoundState() == ROUNDSTATE_RESTARTING or self:GetRoundState() == ROUNDSTATE_END then return end
						
						self:SetRoundState( ROUNDSTATE_RESTARTING )
						
						if self:GetRoundState() ~= ROUNDSTATE_END then
							self:ShowLevelClear()
						end		
						
						for k,v in ipairs(player.GetAll()) do
							v:ChatPrint("The DarkRP kids were slain.")
							v:ChatPrint("Starting new round in 15 seconds...")
							
							if v:Team() == TEAM_AXE and v:Alive() then
								v:AddFrags( 1 )
							end
							
						end
						
						self:RestartRoundIn( 15 )
						
						CHANGE_AXE = true
						
						pl.Tries = 0
						
					end
				end

			end
		
		end
		
		function self:PlayerDisconnected(pl)
			
			timer.Simple(1, function()
				if #player.GetAll() < 1 and self:GetNextBotCount() > 1 then
					self:RemoveRDMBots()
				end
			end)
			
			if pl:Team() == TEAM_AXE then
				
				if self:GetRoundState() == ROUNDSTATE_RESTARTING then return end
				
				self:SetRoundState( ROUNDSTATE_RESTARTING )
				
				CHANGE_AXE = true
				
				for k,v in ipairs(player.GetAll()) do
					v:ChatPrint("Starting a new round in 5 seconds...")
				end
				
				self:RestartRoundIn( 5 )
				
			end
			
		end
		
		function self:OnPlayerDeathThink( pl )
			
			if pl:KeyPressed( IN_JUMP ) and pl:Team() == TEAM_AXE then //probably should remove team restriction
				pl:SendLua( "DrawCharacterMenu()" )
				return
			end
			
			if self:GetRoundState() == ROUNDSTATE_END and pl.NextSpawnTime and pl.NextSpawnTime < CurTime() and (( pl:KeyPressed( IN_ATTACK ) || pl:KeyPressed( IN_ATTACK2 ) ) or pl:IsBot()) then
				
				if self:GetRoundState() == ROUNDSTATE_RESTARTING then return end
				
				self:SetRoundState( ROUNDSTATE_RESTARTING )
				
				
				local axe = team.GetPlayers( TEAM_AXE )[1]
				
				if IsValid( axe ) and axe:Alive() then
					for k,v in ipairs(player.GetAll()) do
						v:ChatPrint("Starting new round in 15 seconds...")
					end
					self:RestartRoundIn( 15 )
				else
				
					for k,v in ipairs(player.GetAll()) do
						v:ChatPrint("Starting a new round...")
					end
					self:RestartRound()
				end
				
			else
				if pl:Team() == TEAM_MOB then
					
					pl.Spectated = pl.Spectated or 0
					
					if pl:KeyPressed( IN_ATTACK ) then
						pl.Spectated = pl.Spectated + 1
						
						local tospec = {}
						
						for k, v in pairs(team.GetPlayers(TEAM_MOB)) do
							if v:Alive() then 
								table.insert(tospec, v) 
							end
						end
						for k, v in pairs(NEXTBOTS) do
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
			
				end
			end
			
			
		end
		
		function self:PlayerSelectSpawn( pl )
			local ent = self:PlayerSelectTeamSpawn( pl:Team(), pl )
			if ( IsValid(ent) ) then return ent end			
		end
		
	end

	//CLIENT part
	
	if CLIENT then
	
		local radius = 450
		local blend = false
		local player_trace = { mask = MASK_SOLID_BRUSHONLY }
		local mat = Material( "Debug/hsv" )
		
		GAMEMODE.Gametype = "axecution"
		
		//draw tplayer names
		DRAW_NAMES = true
		GAMETYPE_PLAYLIST = 48060077 //todo: add an option to toggle this
		GAMETYPE_PLAYLIST_VOLUME = 30
		
		THUNDER_BACKGROUND = true

		function self:OnThink()
			
			local MySelf = LocalPlayer()
			
			if IsValid( MySelf ) and ( MySelf:Team() ~= TEAM_SPECTATOR or MySelf:Team() ~= TEAM_CONNECTING ) then
				self:CheckThunder()
			end
		end
		
		function self:OnPrePlayerDraw( pl )

			local hide_weapon = false
		
			local MySelf = LocalPlayer()
			local mypos = IsValid(MySelf:GetObserverTarget()) and MySelf:GetObserverTarget():GetShootPos() or MySelf:GetShootPos()
			local dist = pl:NearestPoint(mypos):Distance(mypos)
			local tr
			
			if pl ~= MySelf then
				player_trace.start = mypos
				player_trace.endpos = pl:NearestPoint(mypos)
				
				tr = util.TraceLine( player_trace )
			end	

			local todraw = MySelf:Team() == TEAM_MOB and (dist < radius and tr and !tr.HitWorld or pl == MySelf ) or MySelf:Team() == TEAM_AXE

			if todraw then
		
				pl:SetRenderBounds(Vector(-360,-360,0),Vector(360,360,360))

				local dlight = DynamicLight( pl:EntIndex() )
				if ( dlight ) then
					local size = pl:KeyDown( IN_ATTACK ) and 60 or 50
					dlight.Pos = pl:GetPos()+vector_up*2
					dlight.r = 255
					dlight.g = 255
					dlight.b = 255
					dlight.Brightness = 5
					dlight.Size = size
					dlight.Decay = size * 1
					dlight.DieTime = CurTime() + 1
					dlight.Style = 0
					dlight.NoModel = true
				end
				//if not pl.m_DrawShadow then
					pl:DrawShadow( true )
					//pl.m_DrawShadow = true
				//end
			else
				render.SetBlend(0)
				render.ModelMaterialOverride( mat )
				blend = true
				hide_weapon = true
				//if pl.m_DrawShadow then
					pl:DrawShadow( false )
					pl:RemoveAllDecals()
					//pl.m_DrawShadow = false
				//end
			end
			
			pl.HideWeapon = hide_weapon
			
		end
		
		function self:OnPostPlayerDraw( pl )
		
			if blend then
				render.ModelMaterialOverride()
				render.SetBlend(1)
				blend = false
			end
		
		end
		
		function self:OnDrawDeathHUD()
	
			local w,h = ScrW(), ScrH()
			local MySelf = LocalPlayer()
			
			//if MySelf:Team() == TEAM_MOB then
				
				local shift = math.cos(RealTime()*3)*2 + 5
			
				local x, y = 60, h*0.85
					
				local text = IsValid( MySelf:GetObserverTarget() ) and MySelf:GetObserverTarget().Name and translate.Format("sog_hud_spectating_x", MySelf:GetObserverTarget():Name()) or translate.Get("sog_hud_you_are_dead")
						
				draw.SimpleText( text, "NumbersSmall", x + 3, y + 3, Color( 10, 10, 10, 185), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				draw.SimpleText( text, "NumbersSmall", x, y, Color( 97, 0, 27, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				draw.SimpleText( text, "NumbersSmall", x - shift, y - shift, Color( 220, 220, 220, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				
				if MySelf:Team() ~= TEAM_AXE then return end
				
				shift = math.sin(RealTime()*3)*2 + 5
	
				x, y = 60, h*0.85 + 38	
							
				text = translate.Get("sog_hud_change_character")
							
				draw.SimpleText( text, "NumbersSmall", x + 3, y + 3, Color( 10, 10, 10, 185), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				draw.SimpleText( text, "NumbersSmall", x, y, Color( 97, 0, 27, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				draw.SimpleText( text, "NumbersSmall", x - shift, y - shift, Color( 220, 220, 220, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			//end
	
		end

	end

end

GM:AddAvalaibleGametype( "axecution", translate.Get("sog_gametype_name_axecution") )
GM.Gametypes["axecution"] = GM.AxecutionInitialize