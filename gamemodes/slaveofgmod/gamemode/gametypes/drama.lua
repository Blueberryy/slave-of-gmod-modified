GM.Gametypes = GM.Gametypes or {}


//some convars
if SERVER then
	//how much people required to spawn a server owner
	DRAMA_ROUNDS = CreateConVar("sog_drama_maxrounds", 20, FCVAR_ARCHIVE + FCVAR_NOTIFY, "Total amount of rounds in Serious Drama. Keep it even."):GetInt()
	cvars.AddChangeCallback("sog_drama_maxrounds", function(cvar, oldvalue, newvalue)
		DRAMA_ROUNDS = newvalue
	end)
end

function GM:SDInitialize()
	
	GAMEMODE.UseCharacters = { "server owner", "cop kid", "kid", "admin" } //which classes we should use
	
	GAMEMODE.GametypeName = "Serious Drama"

	print"Gametype Initialized"
	TEAM_EVIL = 6 //they want to ddos
	TEAM_STUPID = 7 //they are retarded
	
	PICKUP_RESPAWN_TIME = 99999 //basically no pickup respawning
	PICKUP_PERSISTANCE = true
	
	USE_TIME_LIMIT = true //enables the round timer
	
	OBJECTIVE_CLASS = "ent_server"
	
	team.SetUp(TEAM_EVIL, "DDOS-Gamers.tk", Color(205,16,16,255))//"Generic Community 1"
	team.SetUp(TEAM_STUPID, "3-Year-Old-Gaming.mom", Color(180,180,180,255))//"Generic Community 2"
	
	self.Goals = {}
	self.Goals[TEAM_EVIL] = "Use the package [hold USE KEY] to overload the server"
	self.Goals[TEAM_STUPID] = "Protect the server!"
	
	function self:PlayerShouldTakeDamage(pl, attacker)
		if attacker.Team then
			if pl:Team() == attacker:Team() then
				return false
			end 
		end
		return true
	end
	
	ROUND_PLAY_TIME = 1*60
	
	if SERVER then
	
		team.SetSpawnPoint( TEAM_EVIL, "info_player_main" )
		team.SetSpawnPoint( TEAM_STUPID, "info_player_mob" )
		
		JOIN_TIME = 30
		
		CUR_ROUND = 1
		
		DEFAULT_CHARACTER = "kid"
		
		DISABLE_TEAM_PUNCHING = true
		
		SERVER_ENTITY = {}
		
		function team.GetJoinableTeam()
			
			local t1 = team.GetPlayers( TEAM_EVIL )
			local t2 = team.GetPlayers( TEAM_STUPID )
			
			local result = math.random( TEAM_EVIL, TEAM_STUPID )
			
			if #t1 > #t2 then
				result = TEAM_STUPID
			end
			
			if #t2 > #t1 then
				result = TEAM_EVIL
			end
			
			return result
			
		end
		
		function team.GetAlivePlayers( team_id )
			
			local alive = {}
			
			local players = team.GetPlayers( team_id )
			
			for k,v in ipairs( players ) do
				if v and v:Alive() then
					table.insert( alive, v )
				end
			end
			
			return alive
			
		end
		
		function self:ShouldSwitchTeams()
			return CUR_ROUND == (math.Round( DRAMA_ROUNDS/2 ) + 1) 
		end
		
		function self:ScrambleTeams( team1, team2 )
			
			local all_players = {}
			
			for k, v in pairs( team.GetPlayers( team1 ) ) do
				if v and v:IsValid() then
					table.insert( all_players, v )
					v:SetTeam( TEAM_SPECTATOR )
				end
			end
			
			for k, v in pairs( team.GetPlayers( team2 ) ) do
				if v and v:IsValid() then
					table.insert( all_players, v )
					v:SetTeam( TEAM_SPECTATOR )
				end
			end
			
			table.Shuffle( all_players )
			
			for k, v in pairs( all_players ) do
				if v and v:IsValid() then
					v:SetTeam( team.GetJoinableTeam() )
					v:ChatPrint("Teams have been scrambled!")
				end
			end
			
		end
		
		function self:SwitchTeams( team1, team2 )
						
			local team1score = team.GetScore( team2 )
			local team2score = team.GetScore( team1 )
			
			team.SetScore( team1, team1score )
			team.SetScore( team2, team2score )
			
			local team1players = table.Copy( team.GetPlayers( team2 )  )			
			local team2players = table.Copy( team.GetPlayers( team1 )  )
			
			
			for k,v in pairs( team1players ) do
				if v and v:IsValid() then
					v:SetTeam( team1 )
				end
			end
			
			for k,v in pairs( team2players ) do
				if v and v:IsValid() then
					v:SetTeam( team2 )
				end
			end
			
		end
		
		function self:ResetRounds( team1, team2 )
		
			team.SetScore( team1, 0 )
			team.SetScore( team2, 0 )
			
			CUR_ROUND = 1
						
		end
		
		local ents = ents
		
		function self:SpawnPackage()
		
			local spawns = ents.FindByClass("info_player_main")
			//PrintTable(spawns)
			
			local pos = spawns[1]:GetPos() + vector_up * 50 + VectorRand() * 50
			
			local pr = ents.Create( "dropped_weapon" )
				pr:SetPos( pos )
				pr:SpawnAsWeapon( "obj_package" )
				pr.NoKnockback = false
				pr.Exception = true
			pr:Spawn()

			local phys = pr:GetPhysicsObject()
			if IsValid(phys) then
				phys:SetVelocityInstantaneous( vector_up * 130 + VectorRand() * 50 )
			end
			
		end
		
		function self:SpawnRandomWeapons()
		
			local spawns1 = ents.FindByClass("info_player_main")
			local spawns2 = ents.FindByClass("info_player_mob")
			
			local spawn1 = spawns1[1]
			local spawn2 = spawns2[math.random(#spawns2)]
			
			local am1 = math.ceil(team.NumPlayers( TEAM_EVIL )*0.6)
			local am2 = math.ceil(team.NumPlayers( TEAM_STUPID )*0.6)
			
			if am1 > 0 then
				local carpos = IsValid(self.Car) and (self.Car:GetPos() - self.Car:GetAngles():Forward() * 170) or nil
				for i=1,am1 do
					local pr = ents.Create( "dropped_weapon" )
						pr:SetPos( (carpos or spawn1:GetPos()) + vector_up*20 + VectorRand() * 10 )
						pr:SpawnAsWeapon( math.random(2) == 2 and self.RangedWeapons[math.random(#self.RangedWeapons)] or self.MeleeWeapons[math.random(#self.MeleeWeapons)] )
						pr.NoKnockback = false
						pr.Exception = true
					pr:Spawn()

					local phys = pr:GetPhysicsObject()
					if IsValid(phys) then
						phys:SetVelocityInstantaneous( vector_up * 130 + VectorRand() * 50 )
					end
				end
			end
			
			if am2 > 0 then
				for i=1,am2 do
					local pr = ents.Create( "dropped_weapon" )
						pr:SetPos( spawns2[math.random(#spawns2)]:GetPos() + vector_up*50 + VectorRand() * 50 )
						pr:SpawnAsWeapon( math.random(2) == 2 and self.RangedWeapons[math.random(#self.RangedWeapons)] or self.MeleeWeapons[math.random(#self.MeleeWeapons)] )
						pr.NoKnockback = false
						pr.Exception = true
					pr:Spawn()

					local phys = pr:GetPhysicsObject()
					if IsValid(phys) then
						phys:SetVelocityInstantaneous( vector_up * 130 + VectorRand() * 50 )
					end
				end
			end
			
		end
		
		function self:SpawnRandomServer()
			
			table.Empty( SERVER_ENTITY )
			
			for k,v in pairs( ents.FindByClass( OBJECTIVE_CLASS or "ent_secure" ) ) do
				if v and v:IsValid() then
					v:Remove()
				end
			end
			
			local dontcheckspawns = false
			local rotate = false
			
			local sorted = {}
			
			local points = ents.FindByClass( "point_server" )
			
			if #points > 0 then
				dontcheckspawns = true
				rotate = true
				sorted = points
			end
			
			if !dontcheckspawns then
				local spawns1 = INFO_PLAYER_MAIN
				local spawns2 = INFO_PLAYER_MOB
				
				local spawn1 = spawns1[math.random(#spawns1)]
				local spawn2 = spawns2[math.random(#spawns2)]
				
				local distance = spawn1:GetPos():Distance( spawn2:GetPos() )/1.5				
				local pickups = ents.FindByClass("point_pickup")
				
				for k,v in pairs( pickups ) do
					if v and v:IsValid() and v:GetPos():Distance( spawn2:GetPos() ) <= distance and v:GetPos():Distance( spawn2:GetPos() ) > 400 then
						table.insert( sorted, v )
					end
				end
			end
			
			local am = math.min( #sorted, 2 )
			
			local curspawn = math.random(#sorted)
			
			for i=1, am do
				
				local tospawn = sorted[curspawn]
				
				local oldspawn = curspawn
				
				curspawn = curspawn + math.random(math.Round(#sorted/2))
				
				if curspawn > #sorted then
					if oldspawn == 1 then
						curspawn = 2
					else
						curspawn = 1
					end
				end
			
				if tospawn then
					local pr = ents.Create( OBJECTIVE_CLASS or "ent_secure" )
					pr:SetPos( tospawn:GetPos() )
					pr.DontRotate = true
					if rotate then
						pr:SetAngles( tospawn:GetAngles() )
					end
					pr:Spawn()
					
					table.insert( SERVER_ENTITY, pr )
										
				end
				
			end
			
			/*local tospawn = sorted[math.random(#sorted)]
			
			if tospawn then
				local pr = ents.Create( OBJECTIVE_CLASS or "ent_secure" )
				pr:SetPos( tospawn:GetPos() )
				pr.DontRotate = true
				if rotate then
					pr:SetAngles( tospawn:GetAngles() )
				end
				pr:Spawn()
				
				SERVER_ENTITY = pr
				
			end*/
		
		end
		
		function self:OnMapReset()

			self:SpawnRandomServer()
			self:SpawnRandomWeapons()
			self:SpawnPackage()
			
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
			self:SpawnRandomServer()
			self:SpawnRandomWeapons()
			self:SpawnPackage()
			
			local car_spawns = ents.FindByClass("point_van")
			local normal_pos
			local normal_ang
				
			if #car_spawns > 0 then
				if car_spawns[1] then
					normal_pos = car_spawns[1]:GetPos()
					normal_ang = car_spawns[1]:GetAngles()
				end
			end
			
			::spawncar::
			
			//while !IsValid(self.Car) do
				table.Shuffle( vectors )
				
				local spawns1 = ents.FindByClass("info_player_main")
				
				local spawn1 = spawns1[math.random(#spawns1)]//spawns1[1]
				
				local pos = spawn1:GetPos()
				local ang = Angle(0,math.random(-180,180),0)
				local min, max = Vector( -100, -100, 0 ), Vector( 100, 100, 50 )
				
				local clear = false
				local stop = false
				
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
								ang = (newpos-pos):GetNormal():Angle()
								ang.r = 0
								ang.p = 0
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
					car:SetModel("models/props_vehicles/van001a_physics.mdl")
					car:SetPos( normal_pos or pos+vector_up*35 )
					car:SetAngles( normal_ang or ang+Angle(0,math.random(-15,15),0) )
					car:SetMoveType( MOVETYPE_NONE )
					car:Spawn()
					local phys = car:GetPhysicsObject()
					if phys and phys:IsValid() then
						phys:EnableMotion( false )
					end
					
					self.Car = car
				end
				
				if !IsValid(self.Car) then goto spawncar end
				
			//end
		end
		
		function self:OnPlayerAuthed(pl)
			pl:SendLua("GAMEMODE:SDInitialize()")
		end
		
		function self:RoundStart()
			
			//ROUNDTIME = CurTime()
			self:SetRoundTime( CurTime() )
			
			self:SetRoundState( ROUNDSTATE_IDLE )
			
			CUR_ROUND = CUR_ROUND + 1
			
			if CUR_ROUND > DRAMA_ROUNDS then
				self:ResetRounds( TEAM_EVIL, TEAM_STUPID )
				//if math.Round(2) == 2 then
					//self:SwitchTeams( TEAM_EVIL, TEAM_STUPID )
				//end
				self:ScrambleTeams( TEAM_EVIL, TEAM_STUPID )
			end
			
			if self:ShouldSwitchTeams() then
				self:SwitchTeams( TEAM_EVIL, TEAM_STUPID )
			end
		
		end
		
		function self:RoundEnd()
			
			if SERVER_ARMED then return end
			if self:GetRoundState() == ROUNDSTATE_RESTARTING then return end
					
			self:SetRoundState( ROUNDSTATE_RESTARTING )
			
			team.AddScore( TEAM_STUPID, 1 )
			
			for k,v in ipairs(player.GetAll()) do
				
				if v:Team() == TEAM_EVIL and v:Alive() then
					v:StripWeapons()
					GAMEMODE:SetPlayerSpeed( v, 90, 90 )
				end
				
				v:ChatPrint(team.GetName(TEAM_EVIL).." has failed their evil plan.")
				v:ChatPrint("Starting new round in 5 seconds...")
			end
			
			self:RestartRoundIn( 5 )
			
			
		end
		
		function self:RestartRound()
									
			self:RoundStart()
			self:ResetMap()

			for k, v in pairs(player.GetAll()) do
				if v:Team() == TEAM_SPECTATOR or v:Team() == TEAM_CONNECTING then continue end
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
				return
			end
			
			pl:SendLua("GAMEMODE:PlayMusic()")
			
			pl:UnSpectate()
			if pl:Team() == TEAM_SPECTATOR or pl:Team() == TEAM_CONNECTING then
				pl:SetTeam( team.GetJoinableTeam() )
			end
			
			pl:SetFlipView( pl:Team() == TEAM_STUPID )
			
			if self:GetRoundState() ~= ROUNDSTATE_RESTARTING then
				if self:GetRoundState() == ROUNDSTATE_IDLE then
					self:SetRoundTime( CurTime() )
				end
				self:SetRoundState( ROUNDSTATE_ACTIVE )
				
			end
			
			pl:ChatPrint("Round "..CUR_ROUND.." out of "..DRAMA_ROUNDS)
			if self:ShouldSwitchTeams() then
				pl:ChatPrint("Teams have been switched!")
			end
						
		end
		
		function self:OnPlayerSetModel( pl )
			
		end
		
		
		function self:GametypePlayerSpawn( pl )
			
			if CurTime() - self:GetRoundTime() > JOIN_TIME and team.NumPlayers( pl:Team() ) > 1 then
				pl:KillSilent()
			end
			
			if self.Goals[pl:Team()] then
				pl:SetGoal( self.Goals[pl:Team()], 20 )
			end
			
			for k, v in ipairs( SERVER_ENTITY ) do
				if IsValid(v) and pl:Team() == TEAM_EVIL then
					local vec = VectorRand() * 40 * k
					vec.z = 0
					pl:AddObjectiveArrow( nil, v:GetPos() + vec, math.random(8,12) )
				end
			end
			
			local col = team.GetColor( pl:Team() )
			pl:SetPlayerColor( Vector( col.r/255, col.g/255, col.b/255) )
			
			
			
			
		end
		
		function self:PlayerDisconnected(pl)
			
			if (pl:Team() == TEAM_EVIL or pl:Team() == TEAM_STUPID) and (team.NumPlayers( pl:Team() ) > 1 and #team.GetAlivePlayers( pl:Team() ) < 2 or team.NumPlayers( pl:Team() ) < 2) then
				
				if self:GetRoundState() == ROUNDSTATE_RESTARTING then return end
				
				self:SetRoundState( ROUNDSTATE_RESTARTING )
				
				//BALANCING_TEAMS = true
				
				for k,v in ipairs(player.GetAll()) do				
					v:ChatPrint(team.GetName( pl:Team() ).." has no alive players!")
					v:ChatPrint("Starting a new round in 5 seconds...")
				end
				
				self:RestartRoundIn( 5 )
			end
			
		end
		
		function self:GametypeDoPlayerDeath( pl, attacker, dmginfo )
		
			pl:BalanceTeams( TEAM_EVIL, TEAM_STUPID )
		
			local alive = false
			local tospectate
			for _, p in ipairs( team.GetPlayers( pl:Team() ) ) do
				if IsValid( p ) and p:Alive() and p ~= pl then
					alive = true
					tospectate = p
					break
				end
			end
				
			if not alive then
				
				if pl:Team() == TEAM_EVIL and SERVER_ARMED then
					
				else
				
					if self:GetRoundState() == ROUNDSTATE_RESTARTING then return end
						
					self:SetRoundState( ROUNDSTATE_END )
					
					local winner = pl:Team() == TEAM_EVIL and TEAM_STUPID or TEAM_EVIL
					
					team.AddScore( winner, 1 )
					
					for k,v in ipairs(player.GetAll()) do
						v:ChatPrint(team.GetName(pl:Team()).." was slain!")
					end

				end

			end
		
		end
		
		function self:OnPlayerDeathThink( pl )
			
			if pl:KeyPressed( IN_JUMP ) then
				pl:SendLua( "DrawCharacterMenu()" )
				return
			end
			
			if self:GetRoundState() == ROUNDSTATE_END and (( pl:KeyPressed( IN_ATTACK ) ) or pl:IsBot()) then
				
				if self:GetRoundState() == ROUNDSTATE_RESTARTING then return end
				
				self:SetRoundState( ROUNDSTATE_RESTARTING )
				
				for k,v in ipairs(player.GetAll()) do
					v:ChatPrint("Starting new round in 5 seconds...")
				end
				self:RestartRoundIn( 5 )
								
			else
								
				pl.Spectated = pl.Spectated or 0
					
				if pl:KeyPressed( IN_ATTACK ) then
					pl.Spectated = pl.Spectated + 1
						
					local tospec = {}
						
					for k, v in pairs(team.GetPlayers(pl:Team())) do
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
		
		function self:PlayerSelectSpawn( pl )
			local ent = self:PlayerSelectTeamSpawn( pl:Team(), pl )
			if ( IsValid(ent) ) then return ent end			
		end
	
	end
		if CLIENT then
			local radius = 450
			local blend = false
			local player_trace = { mask = MASK_SOLID_BRUSHONLY }
			local mat = Material( "Debug/hsv" )
			
			GAMEMODE.Gametype = "drama"
			
			DRAW_NAMES = true

			
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

				local todraw = (dist < radius and tr and !tr.HitWorld or pl:Team() == MySelf:Team() )//MySelf:Team() == pl:Team() and 
				
				if todraw then
			
					pl:SetRenderBounds(Vector(-360,-360,0),Vector(360,360,360))

					//local col = team.GetColor( pl:Team() )
					
					local dlight = DynamicLight( pl:EntIndex() )
					if ( dlight ) then
						local size = pl:KeyDown( IN_ATTACK ) and 60 or 50
						dlight.Pos = pl:GetPos()+vector_up*2
						dlight.r = 255//col.r
						dlight.g = 255//col.g
						dlight.b = 255//col.b
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
				
					
				local shift = math.cos(RealTime()*3)*2 + 5
				
				local x, y = 60, h*0.85
						
				local text = IsValid( MySelf:GetObserverTarget() ) and "Spectating "..MySelf:GetObserverTarget():Name() or "You are dead!"
							
				draw.SimpleText( text, "NumbersSmall", x + 3, y + 3, Color( 10, 10, 10, 185), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				draw.SimpleText( text, "NumbersSmall", x, y, Color( 97, 0, 27, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				draw.SimpleText( text, "NumbersSmall", x - shift, y - shift, Color( 220, 220, 220, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				
				shift = math.sin(RealTime()*3)*2 + 5
	
				x, y = 60, h*0.85 + 38	
						
				text = "Press SPACEBAR to change character"
						
				draw.SimpleText( text, "NumbersSmall", x + 3, y + 3, Color( 10, 10, 10, 185), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				draw.SimpleText( text, "NumbersSmall", x, y, Color( 97, 0, 27, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				draw.SimpleText( text, "NumbersSmall", x - shift, y - shift, Color( 220, 220, 220, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
					
		
			end

		end
		
	
end

GM:AddAvalaibleGametype( "drama", "Serious Drama (PvP)" )
GM.Gametypes["drama"] = GM.SDInitialize