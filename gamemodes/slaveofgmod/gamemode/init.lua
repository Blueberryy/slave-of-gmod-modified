AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

AddCSLuaFile("vgui/cl_charactermenu.lua")
AddCSLuaFile("vgui/cl_menubackground.lua")
AddCSLuaFile("vgui/cl_menu.lua")
AddCSLuaFile("vgui/cl_dialogue.lua")
AddCSLuaFile("vgui/cl_dream.lua")
AddCSLuaFile("vgui/cl_loading.lua")
AddCSLuaFile("vgui/cl_miscmenus.lua")

include( "shared.lua" )
include("sv_obj_player_extend.lua")

include("boneanimlib_v2/sh_boneanimlib.lua")
include("boneanimlib_v2/boneanimlib.lua")

hook.Remove("PlayerTick", "TickWidgets")
hook.Remove("PostDrawEffects", "RenderWidgets")

//current votes
RTV_NUM = 0

GM.RTV_Players = {}
GM.MapVoted_Players = {}
GM.GtVoted_Players = {}

VOTING_TIME = 30

NEXT_MAP = nil
NEXT_GAMETYPE = nil

//for easier changing
BOT_CLASS = "default"
DEFAULT_CHARACTER = "default"

ROUNDSTATE_IDLE = 0
ROUNDSTATE_ACTIVE = 1
ROUNDSTATE_END = 2
ROUNDSTATE_RESTARTING = 3

ROUND_STATE = ROUND_STATE or ROUNDSTATE_IDLE

GM.Gametype = CreateConVar("sog_gametype", "none", FCVAR_ARCHIVE + FCVAR_NOTIFY, ""):GetString()
cvars.AddChangeCallback("sog_gametype", function(cvar, oldvalue, newvalue)
	GAMEMODE.Gametype = newvalue
end)

GM.RDMBots = util.tobool(CreateConVar("sog_rdm_bots_enable", 1, FCVAR_ARCHIVE + FCVAR_NOTIFY, "Enable or disable bots for Random Deathmatch."):GetInt())
GM.RDMBotsAmount = CreateConVar("sog_rdm_bots_amount", 8, FCVAR_ARCHIVE + FCVAR_NOTIFY, "This amount of bots will spawn in Random Deathmatch."):GetInt()
GM.RDMBotsFFA = util.tobool(CreateConVar("sog_rdm_bots_ffa", 1, FCVAR_ARCHIVE + FCVAR_NOTIFY, "Bots will attack each other in Random deathmatch."):GetInt())
cvars.AddChangeCallback("sog_rdm_bots_enable", function(cvar, oldvalue, newvalue)
	GAMEMODE.RDMBots = util.tobool( newvalue )
	
	if GAMEMODE:GetGametype() ~= "none" then return end
	
	local am = GetConVarNumber( "sog_rdm_bots_amount" ) or 7
	
	if GAMEMODE.RDMBots then
		GAMEMODE:RemoveRDMBots()
		GAMEMODE:SpawnRDMBots( am )
	else
		GAMEMODE:RemoveRDMBots()
	end
	
end)

cvars.AddChangeCallback("sog_rdm_bots_ffa", function(cvar, oldvalue, newvalue)
	GAMEMODE.RDMBotsFFA = util.tobool( newvalue )

	if GAMEMODE:GetGametype() ~= "none" then return end
	
	if not NEXTBOTS then return end
	
	if GAMEMODE.RDMBotsFFA then
		for k, v in pairs( NEXTBOTS ) do
			if v and v:IsValid() then
				v.EnemyTeam = TEAM_DM
				v.KillNextBots = true
			end
		end
	else
		for k, v in pairs( NEXTBOTS ) do
			if v and v:IsValid() then
				v.EnemyTeam = nil
				v.KillNextBots = false
			end
		end
	end
	
end)



function GM:AddResources()
	

	resource.AddSingleFile("resource/fonts/minecraftia.ttf")
	resource.AddSingleFile("resource/fonts/shogunsclan.ttf")
	resource.AddSingleFile("resource/fonts/super_retro_italic.ttf")
	resource.AddSingleFile("resource/fonts/wnd.ttf")
	
	//additional check for dedicated serevrs
	resource.AddSingleFile("cache/workshop/resource/fonts/minecraftia.ttf")
	resource.AddSingleFile("cache/workshop/resource/fonts/shogunsclan.ttf")
	resource.AddSingleFile("cache/workshop/resource/fonts/super_retro_italic.ttf")
	resource.AddSingleFile("cache/workshop/resource/fonts/wnd.ttf")

	resource.AddSingleFile("sound/ambient/thunder/hm2_lightning1.wav")
	resource.AddSingleFile("sound/ambient/thunder/hm2_lightning2.wav")
	resource.AddSingleFile("sound/ambient/thunder/hm2_lightning3.wav")
	
	local a,b = file.Find("materials/sog/*.*" , "GAME") 
	for _, filename in pairs(a) do
		resource.AddSingleFile("materials/sog/"..string.lower(filename))
	end
	
	resource.AddSingleFile("materials/decals/purple_blood1.vmt")
	resource.AddSingleFile("materials/decals/purple_blood2.vmt")
	resource.AddSingleFile("materials/decals/purple_blood3.vmt")
	resource.AddSingleFile("materials/decals/purple_blood4.vmt")
	
	resource.AddSingleFile("materials/pp/texturize/obra.png")
		
end

GM.AvalaibleWeapons = GM.AvalaibleWeapons or {}
GM.PickupWeapons = GM.PickupWeapons or {}
GM.RangedWeapons = GM.RangedWeapons or {}
GM.MeleeWeapons = GM.MeleeWeapons or {}
GM.ThrowableWeapons = GM.ThrowableWeapons or {}

GM.GlobalHints = {
	"[RMB] to pick up/throw. [SPACEBAR] to execute.",
	"Use [MOUSE WHEEL] to adjust volume. [F2] to enable/disable music.",
	"Press [F3] to vote for a new map/gametype.",
	"Press [F1] to open options.",
	"Press [F4] to open a mute menu.",
	"Small reminder: [F1] - Menu; [F2] - Toggle music; [F3] - RTV; [F4] - Player list",
}

function GM:GetRandomHint()
	return self.GlobalHints[math.random(#self.GlobalHints)]
end

function GM:RestartRoundIn( time, args )
	timer.Simple(time, function() 
		if self then
			self:RestartRound( args )
			end
		end)
end

function GM:SetRoundTime( time )
	ROUNDTIME = time or CurTime()
	game.GetWorld():SetDTFloat( 0, time )
	/*for k,v in pairs( player.GetAll() ) do
		v:ChatPrint( "Round time: "..string.FormattedTime( time, "%02i:%02i") )
	end*/
end

function GM:GetRoundTime()
	return game.GetWorld():GetDTFloat( 0 ) or ROUNDTIME
end

function GM:GetRoundState()
	return ROUND_STATE
end

function GM:SetRoundState( state )
	if ROUND_STATE == ROUNDSTATE_IDLE and state == ROUNDSTATE_END then return end
	ROUND_STATE = state
end

function GM:ShowLevelClear()
	net.Start( "LevelClear" )
	net.Broadcast()
end

function change_map(pl,cmd,args)
	
	if !pl:IsAdmin() then return end
	
	local map = args[1]
	if not map then return end
	
	local gametype = args[2]
	
	if gametype and (GAMEMODE.Gametypes[gametype] or gametype == "none" and gametype ~= GAMEMODE:GetGametype()) then
		game.ConsoleCommand( "sog_gametype "..gametype.."\n" )
	end
	
	game.ConsoleCommand("changelevel "..map.."\n");
	
end

concommand.Add("admin_changelevel",change_map,
	//jamming some code from the wiki, because I got tired of typing all this shit over and over again
	function( cmd, stringargs )
		
		stringargs = string.Trim(stringargs)
		stringargs = string.lower(stringargs)
		
		local res = {}
		local gametypes = {}
		local toshow = {}
		local mapFiles = file.Find( "maps/*.bsp", "GAME" )
		local clean
		
		for _,mapname in pairs( mapFiles ) do
			if string.sub( mapname, 1,4 ) == "sog_" then
				clean = string.StripExtension( mapname )
				table.insert( res, clean )
			end
		end
		
		table.insert( gametypes, "none" )
		
		for k, v in pairs( GAMEMODE.Gametypes ) do
			table.insert( gametypes, k )
		end
		
		for _,mapname in pairs( res ) do
			if string.find( string.lower( mapname ), stringargs ) then
				if #stringargs >= #mapname then
					for k, v in pairs( gametypes ) do
						table.insert( toshow, cmd.." "..mapname.." "..v )
					end
				else
					table.insert( toshow, cmd.." "..mapname)
				end
				
			end
		end
		
		return toshow
		
	end
)

util.AddNetworkString( "UpdateMapVotes" )

concommand.Add("vote_map",function(pl,cmg,args)
	
	if GAMEMODE.MapVoted_Players[pl:SteamID()] then return end
	local vote = tostring(args[1])
	
	if not vote then return end
	if not VOTING then return end
	
	if GAMEMODE.AvalaibleMaps[vote] then
		GAMEMODE.AvalaibleMaps[vote].votes = GAMEMODE.AvalaibleMaps[vote].votes + math.max( pl:GetMaxScore(), 100 )

		net.Start( "UpdateMapVotes" )
			net.WriteString( vote )
			net.WriteInt( math.max( pl:GetMaxScore(), 100 ), 32 )
		net.Broadcast()
		
		GAMEMODE.MapVoted_Players[pl:SteamID()] = true
		
		//pl:ChatPrint("You have placed "..pl:GetMaxScore().." on "..vote)
	end
	
end)

util.AddNetworkString( "UpdateGtVotes" )

concommand.Add("vote_gametype",function(pl,cmg,args)
	
	if GAMEMODE.GtVoted_Players[pl:SteamID()] then return end
	local vote = tostring(args[1])
	
	if not vote then return end
	if not VOTING then return end
	
	if GAMEMODE.AvalaibleGametypes[vote] then
		GAMEMODE.AvalaibleGametypes[vote].votes = GAMEMODE.AvalaibleGametypes[vote].votes + math.max( pl:GetMaxScore(), 100 )

		net.Start( "UpdateGtVotes" )
			net.WriteString( vote )
			net.WriteInt( math.max( pl:GetMaxScore(), 100 ), 32 )
		net.Broadcast()
		
		GAMEMODE.GtVoted_Players[pl:SteamID()] = true
		
		//pl:ChatPrint("You have placed "..pl:GetMaxScore().." on "..vote)
	end
	
end)

concommand.Add( "select_character", function( pl, cmd, args )
	
	if !IsValid(pl) then return end
	if not args or not args[1] then return end
	
	local char = tonumber( args[1] or DEFAULT_CHARACTER )
	
	if not GAMEMODE.Characters[ char ] then return end
	if GAMEMODE.UseCharacters and !table.HasValue( GAMEMODE.UseCharacters, GAMEMODE:GetCharacterReferenceById( char ) ) then return end
	if GAMEMODE.Characters[ char ].GametypeSpecific and GAMEMODE.Characters[ char ].GametypeSpecific ~= GAMEMODE:GetGametype() and !SINGLEPLAYER then return end
	
	local oldchar = pl:GetCharacter()
	pl.OldCharacter = oldchar
	pl.CharacterPref = char
	pl.StoreCharacterPref = GAMEMODE:GetCharacterReferenceById( char )
	
	if GAMEMODE.GametypeOnChangeChar then
		GAMEMODE:GametypeOnChangeChar( pl, char, oldchar )
	end
	
	
	if pl:Team() == TEAM_SPECTATOR then
		pl:Freeze( false )
		if GAMEMODE:GetGametype() == "none" and !SINGLEPLAYER then
			pl:SetTeam( TEAM_DM )
			pl:Spawn()
		else
			GAMEMODE:PlayerInitialSpawn( pl )
			pl:Spawn()
		end

	end
	
end)

concommand.Add( "select_style", function( pl, cmd, args )
	
	if !IsValid(pl) then return end
	if not args or not args[1] then return end
	
	pl.SelectedStyle = tonumber( args[1] )
	
end)

function GM:Initialize()

	self:GetAllMaps()
	
	if self.Gametypes[self.Gametype] then
		self.Gametypes[self.Gametype](self)
	end

	self:AddResources()
	
	for ind, swep in pairs(weapons.GetList()) do
		if swep and swep.ClassName and string.find( swep.ClassName, "sogm_") and swep.ClassName ~= "sogm_melee_base" then
			self.AvalaibleWeapons[#self.AvalaibleWeapons + 1] = swep.ClassName
			if swep.MapOnly then continue end
			if swep.Hidden then continue end
			if swep.Akimbo then continue end
			if swep.Gametype and swep.Gametype ~= self.Gametype then continue end
			self.PickupWeapons[#self.PickupWeapons + 1] = swep.ClassName
			if swep.Base == "sogm_melee_base"  then
				if swep.Throwable then
					self.ThrowableWeapons[#self.ThrowableWeapons + 1] = swep.ClassName
				else
					self.MeleeWeapons[#self.MeleeWeapons + 1] = swep.ClassName
				end
			else
				self.RangedWeapons[#self.RangedWeapons + 1] = swep.ClassName
			end
		end
	end
end

function GM:ShowHelp( pl )
	if pl:Team() == TEAM_SPECTATOR then return end
	
	pl:SendLua( "DrawMenu()" )
end

function GM:ShowTeam(pl)
	if SINGLEPLAYER then
	

	else
		pl:SendLua("GAMEMODE:ToggleRadio()")
		pl:SetGoal( "Use [MOUSE WHEEL] to adjust volume. Use [NUM4] and [NUM6] to change track.", 10 )
	end
	
end

function GM:ShowSpare1(pl)
	if SINGLEPLAYER then return end
	pl:RTV()
end

function GM:ShowSpare2(pl)
	if SINGLEPLAYER then return end
	pl:SendLua("DrawPlayerMenu()")
end

function GM:OnDamagedByExplosion(pl)
	//if pl and pl:Alive() then
		//pl:ShakeView( math.random(14,28))
	//end
end

function GM:StartVoting( time )
	
	if VOTING then return end
	
	VOTING = true
	
	for k,v in ipairs(player.GetAll()) do
		if v:Team() ~= TEAM_SPECTATOR and v:Team() ~= TEAM_CONNECTING then
			v:SendLua("DrawVoteMenu( "..time.." )")
		end
	end
	
	timer.Simple(time,function() if self then self:EndVoting() end end)
	

end

function GM:EndVoting()
	
	VOTING = false
	
	local m_max = 0
	local m_winner = game.GetMap()
	
	for map,tbl in pairs(self.AvalaibleMaps) do
		local current = tbl.votes
		if current > m_max then
			m_max = current
			m_winner = map
		end
	end
	
	NEXT_MAP = m_winner
	
	local gt_max = 0
	local gt_winner = self:GetGametype() or "none"
	
	for gt,tbl in pairs(self.AvalaibleGametypes) do
		local current = tbl.votes
		if current > gt_max then
			gt_max = current
			gt_winner = gt
		end
	end
	
	NEXT_GAMETYPE = gt_winner

	local t = 5
	
	for k,v in pairs(player.GetAll()) do
		v:SendLua("surface.PlaySound(\"buttons/button14.wav\")")
		v:ChatPrint("Voting has ended! Next gametype will be "..self.AvalaibleGametypes[NEXT_GAMETYPE].name..".")
		v:ChatPrint("Changing map to "..NEXT_MAP.." in "..t.." seconds!")
	end
	
	timer.Simple(t,function()
		if NEXT_GAMETYPE then
			game.ConsoleCommand( "sog_gametype "..NEXT_GAMETYPE.."\n" )
		end
		game.ConsoleCommand("changelevel "..NEXT_MAP.."\n");
	end)
	
end

function GM:PlayerInitialSpawn( pl )

	if GetConVarNumber("sog_singleplayer") ~= 0 then
		game.ConsoleCommand( "sog_singleplayer 0\n" )
	end

	pl.CharacterPref = pl.CharacterPref or 0
	
	pl:SetCustomCollisionCheck( true )
	
	//pl:SetLOD( 0 )
	
	pl:SendMapList()
			
	if self.GametypePlayerInitialSpawn then
		self:GametypePlayerInitialSpawn( pl )
	else
		if pl:IsBot() then
			pl:SetTeam( TEAM_DM )
		else
			pl:SetTeam( TEAM_SPECTATOR )
			pl:SendLua( "ManageFirstSpawn(\""..self:GetGametype().."\")" )
		end
		if self.RDMBots and self:GetNextBotCount() < 1 then
			//GAMEMODE:RemoveRDMBots()
			local am = GetConVarNumber( "sog_rdm_bots_amount" ) or 6
			self:SpawnRDMBots( am )
		end
		
	end
	
end

function GM:PlayerSpawn( pl )
	
	if pl:Team() == TEAM_SPECTATOR then
		pl:KillSilent()
		pl:Freeze( true )
		
		pl:SetPos( Vector( 16000, 16000, 16000) )
		return
	end
	
	if IsValid(pl.Knockdown) then 
		pl.Knockdown:Remove()
		pl.Knockdown = nil
	end
	if IsValid(pl.Execution) then
		pl.Execution:Remove()
		pl.Execution = nil
	end
	
	if self.GametypePrePlayerSpawn then
		self:GametypePrePlayerSpawn( pl )
	end
	
	
	//if self:GetGametype() == "none" then
		pl:SetCharacter( pl.CharacterPref or DEFAULT_CHARACTER )
	//else
	//	pl:SetCharacter( 0 )
	//end
	
	if pl:IsBot() and !BOT_IGNORE_CLASS then
		pl:SetCharacter( self:GetGametype() == "none" and BOT_CLASS or DEFAULT_CHARACTER )
	end

	if pl:GetCharTable().Speed then
		self:SetPlayerSpeed( pl, pl:GetCharTable().Speed, pl:GetCharTable().Speed )
	else
		self:SetPlayerSpeed( pl, 360, 360 )
	end
	
	if pl:GetCharTable().StepSize then
		pl:SetStepSize( pl:GetCharTable().StepSize )
	else
		pl:SetStepSize( 20 )
	end
	
	
	pl:SetMoveType( MOVETYPE_WALK )
	
	pl:ConCommand( "r_cleardecals" )
	
	pl:ResetScore()
	pl:CleanAllCombo()
	
	pl:CleanBodies()
	
	if pl:GetMaterial() == "models/charple/charple1_sheet" then
		pl:SetMaterial( "" )
	end
	
	pl.GenericDeath = true
	pl.ToDismember = nil
	pl.DeathSequence = nil
	
	if pl:GetCharTable().Health then
		pl:SetHealth( pl:GetCharTable().Health )
		pl:SetMaxHealth( pl:GetCharTable().Health )
	end
		
	pl.CanInteract = function( ent ) return true end
	
	pl.SpawnProtection = CurTime() + 1
	
	if pl:GetCharTable().OnSpawn then
		pl:GetCharTable():OnSpawn( pl )
	end
	
	if self.GametypePlayerSpawn then
		self:GametypePlayerSpawn( pl )
	else
		local col = pl:GetCharTable().OverrideColor or color_white //team.GetColor( pl:Team() )	
		pl:SetPlayerColor( Vector( col.r/255, col.g/255, col.b/255) )
		if not pl.ShowHelp and pl:Team() ~= TEAM_SPECTATOR and pl:Team() ~= TEAM_CONNECTING then
			pl:SetGoal( "Small reminder: [F1] - Menu; [F2] - Toggle music; [F3] - RTV; [F4] - Player list", 35 )
			pl.ShowHelp = true
		end
	end
	
	-- Call item loadout function
	hook.Call( "PlayerLoadout", GAMEMODE, pl )
	
	-- Set player model
	hook.Call( "PlayerSetModel", GAMEMODE, pl )
	
	if pl:GetCharTable().PostSpawn then
		pl:GetCharTable():PostSpawn( pl )
	end
	
end

function GM:PlayerAuthed( pl )
	if self.OnPlayerAuthed then
		self:OnPlayerAuthed( pl )
	else
		pl:SendLua("GAMEMODE:InitializeGametype()")
	end
	//pl:SendLua("GAMEMODE.Gametype = "..tostring(self:GetGametype()))
end

function GM:SpawnBot( weapon, character, pos, myteam, enemyteam, attack_nextbots )

	if not WANDER_POINTS then
		
		WANDER_POINTS = {}
	
		for k,v in pairs(POINT_PICKUPS) do
			table.insert( WANDER_POINTS, v:GetPos() )
			table.Add( WANDER_POINTS, self:GetSpotsAroundPos( v:GetPos(), 150, true, true ) )
		end
		
	end

	local spawns = INFO_PLAYER_MOB//ents.FindByClass("info_player_mob")
	
	pos = pos or spawns[math.random(#spawns)]:GetPos()
	
	local b = ents.Create( "sogm_mob" )
	b:SetPos( pos )
	b.SpawnPos = pos
	if character then
		b:SetCharacter( character )
	end
	b:Spawn()
	
	local wep
	
	if weapon then
		if weapon ~= "none" then
			wep = weapon
		end
	else
		wep = b:GetCharTable().StartingWeapon
		
		if b:GetCharTable().StartingRandomWeapon then
			wep = b:GetCharTable().StartingRandomWeapon[ math.random( #b:GetCharTable().StartingRandomWeapon ) ]
		end
	end
	
	if wep then
		b:Give( wep )
	end
	
	if myteam then
		b:SetTeam( myteam )
	end
	
	if enemyteam then
		b.EnemyTeam = enemyteam
	end
	
	if attack_nextbots then
		b.KillNextBots = attack_nextbots
	end
	
	b.Spawned = true
	
	return b
	//NEXTBOTS[tostring(b)] = b
		
end

function GM:SpawnRDMBots( am )
	
	am = am or 6
	
	if not RDM_SPAWNS then
		RDM_SPAWNS = {}
		
		for k,v in ipairs( INFO_PLAYER_MOB ) do
			table.Add( RDM_SPAWNS, self:GetSpotsAroundPos( v:GetPos(), 400, true ) )
		end
		for k,v in ipairs( INFO_PLAYER_MAIN ) do
			table.Add( RDM_SPAWNS, self:GetSpotsAroundPos( v:GetPos(), 400, true ) )
		end
		
		//if #RDM_SPAWNS < 1 then
			for k,v in ipairs( ents.FindByClass("info_player_*") ) do
				table.insert( RDM_SPAWNS, v:GetPos() )
			end
		//end
		
		for k,v in ipairs( POINT_PICKUPS ) do
			table.insert( RDM_SPAWNS, v:GetPos() )
		end
		
	end
	
	local spawns = RDM_SPAWNS//ents.FindByClass("info_player_*")//team.GetSpawnPoint( TEAM_DM )	
	
	local det = 0
	local traitor = 0
	
	for i=1, am do
		local pos 
		local spawn = spawns[ math.random( #spawns ) ]
		if spawn then
			pos = spawn//:GetPos()
		end
		
		local char = 0
		
		if math.random(4) == 4 and det < math.Round(am/7) then
			char = "detective"
			det = det + 1
		end
		
		if math.random(5) == 5 and traitor < math.Round(am/7) and char ~= "detective" then
			char = "traitor"
			traitor = traitor + 1
		end
		
		local enemyteam = nil
		local hostile = false
		
		if self.RDMBotsFFA then
			enemyteam, hostile = TEAM_DM, true
		end
		
		local b = self:SpawnBot( nil, char, pos, TEAM_DM, enemyteam, hostile)
		b.StuckPositions = RDM_SPAWNS
		b.SpawnProtection = CurTime() + math.random(1,2)
		
	end
	
end

function GM:RemoveRDMBots()
	
	if not NEXTBOTS then return end
	
	for k, v in pairs( NEXTBOTS ) do
		if v and v:IsValid() then
			v:Remove()
		end
	end
	
end

function GM:GetNextBotCount()
	
	local count = 0

	if not NEXTBOTS then return 0 end
	
	for k, v in pairs( NEXTBOTS ) do
		if v and v:IsValid() and v:Alive() then
			count = count + 1
		end
	end
	
	return count

end

function GM:GetFallDamage( ply, flFallSpeed )
	return ply:Health() * 2
end

function GM:IsSpawnpointSuitable( pl, spawnpointent, bMakeSuitable )
	return true
end


function GM:PlayerSetModel( pl )

	local cl_playermodel = pl:GetInfo( "cl_playermodel" )
	local modelname = player_manager.TranslatePlayerModel( cl_playermodel )
	
	
	if pl:GetCharTable().Model then
		modelname = pl:GetCharTable().Model
	end
		
	pl:SetModel( modelname )
	
	if pl:GetCharTable().ModelScale then
		if pl:IsBot() then
			pl:SetModelScale( pl:GetCharTable().ModelScale, 0 )
		else
			pl:SetClientsideModelScale( pl:GetCharTable().ModelScale )
		end
	else
		if pl:GetModelScale() ~= 1 then
			pl:SetModelScale( 1, 0 )
		end
		if pl.ClientSideScale and pl.ClientSideScale ~= 1 then
			pl:SetClientsideModelScale( 1 )
		end
	end
	
	
	if self.OnPlayerSetModel then
		self:OnPlayerSetModel( pl )
	end
	
end


function GM:PlayerLoadout( pl )

	pl:StripWeapons()
	pl:RemoveAllAmmo()
	//if pl:IsBot() then
	//	pl:Give(self.AvalaibleWeapons[math.random(#self.AvalaibleWeapons)])
	//end
	
	pl.CanSwitch = false
	
	if !pl:GetCharTable().RemoveDefaultFists then
		pl:Give( "sogm_fists" )
	end
	
	if pl:GetCharTable().StartingWeapon then
		pl:Give( pl:GetCharTable().StartingWeapon )
		pl:SelectWeapon( pl:GetCharTable().StartingWeapon )
	end
	
	if pl:GetCharTable().Styles and pl.SelectedStyle and pl:GetCharTable().Styles[pl.SelectedStyle] then
		if pl:GetCharTable().Styles[pl.SelectedStyle].func then
			pl:GetCharTable().Styles[pl.SelectedStyle].func( pl )
		end
	end
	
	if self.OnPlayerLoadout then
		self:OnPlayerLoadout( pl )
	end
	
end

function GM:GetMaxPickupAmount()
	local players = math.Round(#player.GetAll() * 1.2)
	local points = #ents.FindByClass( "point_pickup" )
	return players + points
end

function GM:SetPlayerSpeed( ply, walk, run )

	ply:SetWalkSpeed( walk )
	ply:SetRunSpeed( run )
	
	ply:SetJumpPower( 0 )
	
end


function GM:PlayerDeath( Victim, Inflictor, Attacker )

	Victim.NextSpawnTime = CurTime() + (Victim:IsBot() and 4 or 0.5)
	Victim.DeathTime = CurTime()
	
	if ( !IsValid( Inflictor ) && IsValid( Attacker ) ) then
		Inflictor = Attacker
	end

	if ( Inflictor && Inflictor == Attacker && (Inflictor:IsPlayer() || Inflictor:IsNPC()) ) then
	
		Inflictor = Inflictor:GetActiveWeapon()
		if ( !IsValid( Inflictor ) ) then Inflictor = Attacker end
	
	end
	
	if (Attacker == Victim) then
		
		MsgAll( Attacker:Nick() .. " suicided!\n" )
		
	return end

	if ( Attacker:IsPlayer() ) then
		
		MsgAll( Attacker:Nick() .. " killed " .. Victim:Nick() .. " using " .. Inflictor:GetClass() .. "\n" )
		
	return end

	MsgAll( Victim:Nick() .. " was killed by " .. Attacker:GetClass() .. "\n" )
	
end

function GM:PlayerSwitchFlashlight( ply, SwitchOn )
	return true
end

hook.Add( "PlayerShouldTaunt", "Disable Acts", function( ply )
    return false
end ) 

function GM:ScalePlayerDamage( ply, hitgroup, dmginfo )
	//no
end

function GM:PlayerDisconnected(pl)
	
	if self.RDMBots then
		timer.Simple(1, function()
			if #player.GetAll() < 1 and self:GetNextBotCount() > 1 then
				self:RemoveRDMBots()
			end
		end)
	end
			
end

local math = math
function GM:Think()
	local ct = CurTime()

	for _, pl in ipairs(player.GetAll()) do
		pl:Think()
	end
	
	if not USE_TIME_LIMIT then return end
	
	local timeleft = ROUNDTIME + ROUND_PLAY_TIME
	
	if self:GetRoundState() == ROUNDSTATE_ACTIVE and timeleft <= ct then
		self:RoundEnd()
	end

end

function GM:KeyPress( pl, key )
		
	if key == IN_ATTACK2 then 
		if pl:GetCharTable().OverridePickup then
			pl:GetCharTable():OverridePickup( pl )
		end
	end
	
	if key == IN_JUMP then
		if pl:GetCharTable().OverrideExecution then
			pl:GetCharTable():OverrideExecution( pl )
		end
	end
	
end

function GM:EntityTakeDamage( ent, dmginfo )

	local attacker = dmginfo:GetAttacker()
	local inflictor = dmginfo:GetInflictor()
	local amount = dmginfo:GetDamage() 
	
	//Player gets damaged
	if ent and ent:IsPlayer() then
		
		local allow_crush = attacker.AllowCrushDamage
		
		if allow_crush then 
			
			//remove nonlethal damage (aka no stupid red flashing effect when we get hit just a little)
			if dmginfo:GetDamageType() == DMG_CRUSH and dmginfo:GetDamage() < ent:Health() then 
				dmginfo:SetDamage(0) 
				return true 
			end
			
		else
			if dmginfo:GetDamageType() == DMG_CRUSH then dmginfo:SetDamage(0) return true end
		end
		
		if ent.SpawnProtection and ent.SpawnProtection > CurTime() then
			dmginfo:SetDamage( 0 )
			return true
		end
		
		local wep = IsValid(ent:GetActiveWeapon()) and ent:GetActiveWeapon()
		
		if wep and wep.ProceedDamage then
			return wep:ProceedDamage( ent, attacker, inflictor, amount )
		end
		
	end
	
end

function GM:DoNextBotDeath( bot, attacker, dmginfo )
	if self.GametypeDoNextBotDeath then
		self:GametypeDoNextBotDeath( bot, attacker, dmginfo )
	end
end

function GM:NextBotKnockdown( ply, attacker )
	if self.OnNextBotKnockdown then
		self:OnNextBotKnockdown( ply, attacker )
	end
end

function GM:DoPlayerDeath( ply, attacker, dmginfo )

	if SINGLEPLAYER then
		ply:SetLocalVelocity( vector_origin )
	end

	local death_effect_override = false
	
	local inflictor = dmginfo:GetInflictor()

	ply:ThrowCurrentWeapon( 16, true )
	
	if ply:GetCharTable().OverrideDeathEffects then
		ply:GetCharTable():OverrideDeathEffects( ply, attacker, dmginfo )
		death_effect_override = true
	end

	if not death_effect_override then
		ply:CreateRagdoll()
	end


	local slice = false
						
	if attacker and ( attacker:IsPlayer() or attacker.NextBot ) and inflictor and inflictor.AllowSlicing then
			
		local ang = (attacker:GetAttachment(attacker:LookupAttachment("eyes")).Ang+(VectorRand()*math.random(-35,35)):Angle()):Up()
		local check_trace = attacker:GetEyeTrace()
		local pos = ply:GetShootPos() + VectorRand()*math.Rand(-3,3) + vector_up * math.Rand(-10,3)//ply:NearestPoint(dmginfo:GetDamagePosition())
		local zpos = pos.z
					
		local slice_rotation = math.random( 30,130 )//math.random( -95,95 )
		local change_rotation = false
		
		if math.abs( pos.x - ply:GetPos().x ) > 6 then
			pos.x = ply:GetPos().x + math.random( -3, 3 )
			change_rotation = true
		end
			
		if math.abs( pos.y - ply:GetPos().y ) > 6 then
			pos.y = ply:GetPos().y + math.random( -3, 3 )
			change_rotation = true
		end
			
		if change_rotation then
			slice_rotation = math.random( 40,120 )
		end
		
		if zpos < ply:GetPos().z then
			zpos = ply:GetPos().z + math.random( 10, 20 )
		end
			
		if zpos > ply:GetPos().z + 60 then
			zpos = ply:GetPos().z + 60 - math.random( 15, 30 )
		end
			
		if check_trace.Entity and check_trace.Entity:IsValid() and check_trace.Entity == ply then
			pos = check_trace.HitPos
			zpos = pos.z
			slice_rotation = math.random( 30,130 )
		end
			
		if attacker:GetGroundEntity() ~= game.GetWorld() or ply:GetGroundEntity() ~= game.GetWorld() or IsValid(ply.Knockdown) or attacker:IsRolling() then
			ang = attacker:GetAimVector():Angle():Right():Angle()
			ang:RotateAroundAxis( attacker:GetAimVector(), math.random( -4,4 ) )
			ang = ang:Forward()
			zpos = zpos - math.random( 10 )
		else
			ang = attacker:GetAimVector():Angle():Right():Angle()
			ang:RotateAroundAxis( attacker:GetAimVector(), slice_rotation )
			ang = ang:Forward()
		end
			
		local e = EffectData()
		e:SetEntity( ply )
		e:SetOrigin( ply:GetPos() )
		e:SetStart( pos )
		e:SetScale( zpos )
		e:SetNormal( ang )
		e:SetRadius( 1 )
			
		util.Effect("slice",e,nil,true)
			
		slice = true
			
	end
	
	if ply:GetComboCounter() > 1 then
		ply:FinishCombo()
	end
	
	ply:SetMoveType( MOVETYPE_NONE )
	
	local force_dism = false
	
	if dmginfo:GetDamageType() == DMG_BLAST then
		force_dism = true
	end
	
	if dmginfo:GetDamageType() == DMG_BURN then
		ply:SetMaterial( "models/charple/charple1_sheet" )
	end
	
	if attacker and ( attacker:IsPlayer() or attacker.NextBot ) and attacker.GetCharTable and attacker:GetCharTable().OnPlayerKilled then
		attacker:GetCharTable().OnPlayerKilled( ply, attacker, dmginfo ) 
	end
	
	if ply:GetCharTable().OnDeath then
		ply:GetCharTable():OnDeath( ply, attacker, dmginfo )
	end
	
	if ( attacker:IsValid() and ( attacker:IsPlayer() or attacker.NextBot ) ) then
	
		if attacker:IsNextBot() then
			attacker.Target = nil
			attacker.CurSpeed = attacker.IdleSpeed
			attacker.NextIdle = 0
		end
	
		if ( attacker == ply ) then
			ply.GenericDeath = false
		else

		end
		
		if inflictor and inflictor.OnKill then
			inflictor:OnKill( ply, attacker, dmginfo )
		end
		
		if inflictor and inflictor.OnExecution and IsValid( ply.Knockdown ) then
			inflictor:OnExecution( ply, attacker, dmginfo )
		end
		
		if attacker ~= ply then
			
			if attacker:GetCharTable().AlwaysDismemberment then
				force_dism = true
			end
			
			if !attacker:IsNextBot() then
				if IsValid( ply.Knockdown ) then
					if inflictor == attacker then
						//melee execution
						attacker:AddScore( PTS_EXECUTION_BARE + ( attacker:GetCharTable().BonusPtsOnKill or 0 ), ply )
					else
						attacker:AddScore( ( inflictor.ExecutionPoints or PTS_EXECUTION ) + ( attacker:GetCharTable().BonusPtsOnKill or 0 ), ply )
					end
				else
					if inflictor then
						if inflictor.IsMelee then
							attacker:AddScore( ( inflictor.KillPoints or PTS_MELEE_KILL ) + ( attacker:GetCharTable().BonusPtsOnKill or 0 ) , ply )
						else
							if inflictor == attacker then
								attacker:AddScore( PTS_BARE_KILL + ( attacker:GetCharTable().BonusPtsOnKill or 0 ), ply )
							else
								attacker:AddScore( PTS_RANGED_KILL + ( attacker:GetCharTable().BonusPtsOnKill or 0 ), ply )
							end
						end
					end
				end
				
				attacker:CheckCombo( inflictor.IsMelee or inflictor == attacker )
			end
		end
		
	end
	
	if not death_effect_override then
		if (force_dism or ply.ToDismember) and !slice then
			ply:Dismember( force_dism or ply.ToDismember, dmginfo )
		end
		
		if ply.GenericDeath then
			local e = EffectData()
				e:SetOrigin( ply:GetPos() )
				e:SetEntity( ply )
				e:SetNormal( dmginfo:GetDamageForce():GetNormal() )
				e:SetMagnitude( dmginfo:GetDamageForce():Length() )
			util.Effect( "generic_death", e, nil, true )
		end
		
		if ply.DeathSequence and !slice then
			local id, duration = ply:LookupSequence( NIGHTMARE and "taunt_dance_base" or ply.DeathSequence.Anim )
			local e = EffectData()
				e:SetEntity(ply)
				e:SetOrigin(ply:GetPos())
				e:SetAngles(ply:GetAngles())
				e:SetMagnitude( id )
				e:SetScale( ply.DeathSequence.Speed or 1 )
			util.Effect( "death_sequence", e, nil, true )
		end
		
		if !slice then
			local e = EffectData()
				e:SetOrigin(ply:GetPos())
				e:SetEntity(ply)
				e:SetScale( IsValid( ply.ent_bodywear ) and ply.ent_bodywear:EntIndex() or 0 )
			util.Effect( "fake_body", e, nil, true )
		end
	end
	

	if self.GametypeDoPlayerDeath then
		self:GametypeDoPlayerDeath( ply, attacker, dmginfo )
	end
	
end

function GM:CanPlayerSuicide( pl )
	
	//dont die during dialogues
	if CUR_DIALOGUE then
		return false
	end
	
	//not the best idea, but better safe than sorry
	if SINGLEPLAYER then
		return false
	end
	
	return !IsValid(pl.Knockdown)
end

function GM:PlayerDeathThink( pl )

	if self.OnPlayerDeathThink then
		self:OnPlayerDeathThink( pl )
		return
	end

	if pl:KeyPressed( IN_JUMP ) then
		pl:SendLua( "DrawCharacterMenu()" )
		return
	end
	
	if (  pl.NextSpawnTime && pl.NextSpawnTime > CurTime() ) then return end
	
	if ( pl:KeyPressed( IN_ATTACK ) ) or pl:IsBot() then
	
		pl:Spawn()
		
	end
	
end

function GM:PlayerDeathSound()
	return true
end

function GM:AllowPlayerPickup( ply, object )
	return false	
end

function GM:PlayerSwitchFlashlight( ply, SwitchOn )
	return false
end

function GM:PlayerCanHearPlayersVoice( pListener, pTalker )
	
	//local alltalk = sv_alltalk:GetInt()
	//if ( alltalk >= 1 ) then return true, alltalk == 2 end
	
	if pListener:Team() == TEAM_SPECTATOR and !pListener.Active then return false, false end

	return not pTalker:GetCharTable().NoMicrophone, false
	
end

function GM:DoBloodSpray( pos, dir, scatter, amount, force, chunks )
	
	local horse_blood = chunks and chunks == 2
	
	local e = EffectData()
		e:SetOrigin( pos )
		e:SetNormal( dir )
		e:SetStart( scatter )
		e:SetMagnitude( amount )
		e:SetScale( force )
		if horse_blood then
			e:SetRadius( 2 )
		else
			e:SetRadius( chunks and 1 or 0 )
		end
	util.Effect( "blood_spray", e, nil, true )
	
end

function GM:CreateGib( pos, dir, power, modelid )
	
	local e = EffectData()
		e:SetOrigin( pos )
		e:SetNormal( dir )
		e:SetMagnitude( power )
		e:SetScale( modelid )
	util.Effect( "gib", e, nil, true )
	
end


local function SetupPlayerVisibility( pl )	
	AddOriginToPVS( pl:GetPos() + vector_up * 370 );
end
hook.Add( "SetupPlayerVisibility", "AddPlayerToPVS", SetupPlayerVisibility )

local MapProps = {}

//because game.CleanMap() is slow as balls
function GM:ResetMap()
	
	for _, wep in pairs( DROPPED_WEAPONS ) do
		if !IsValid( wep.SpawnEntity ) and IsValid(wep) then
			wep.RemovedByGame = true
			wep:Remove()
		end
	end
	
	if NO_MAP_PROPS then
	else
		for _, tbl in ipairs( MapProps ) do
			local pr = ents.Create( "dropped_weapon" )
				pr:SetPos( tbl.pos )
				pr:SetAngles( tbl.ang )
				pr:SpawnAsWeapon( tbl.class )
				pr.NoKnockback = false
				pr.Exception = true
				pr.MapBased = true
			pr:Spawn()
		end
	end
	
	if SINGLEPLAYER then
		for k,v in pairs( DONATOR_TOKENS ) do
			if v and v:IsValid() then
				v.ForceRemove = true
				v:Remove()
			end
		end
		table.Empty( DONATOR_TOKENS )
		
		for k,v in pairs( MASTER_SERVERS ) do
			if v and v:IsValid() then
				v.ForceRemove = true
				v:Remove()
			end
		end
		table.Empty( MASTER_SERVERS )
	end
	
	if self.OnMapReset then
		self:OnMapReset()
	end
	
	//print"Successfully reset all entities"
	
end

function GM:GetSpotsAroundPos( pos, distance, visible, nohidden )
	
	local areas = navmesh.Find( pos, distance, 10, 5 ) 
	
	local spots = {}
	
	local lastpos
	
	for _, area in pairs( areas ) do
		
		if !visible or visible and area:IsVisible( pos ) then
			local vec = area:GetClosestPointOnArea( pos )
			//make sure to have some damn spacing
			if not lastpos or lastpos and lastpos:Distance( vec ) > 50 then
				table.insert( spots, vec )	
				lastpos = vec
			end	
		end
		
	end
	
	return spots
	
end

function GM:GetAverageVector( vec_table, convert_to_vec )
	
	local sum
	local am = #vec_table
	
	if am > 0 then
		
		for i = 1, am do
			if not sum then
				if convert_to_vec then
					sum = vec_table[i]:GetPos()
				else
					sum = vec_table[i]
				end
			else
				if convert_to_vec then
					sum = sum + vec_table[i]:GetPos()
				else
					sum = sum + vec_table[i]
				end
			end
		end
		
		if sum then
			return sum / am
		end
	end
	
	return
end

function GM:DistanceBetweenAverageVectors( vec_table1, vec_table2, convert1, convert2 )
	
	local vec1 = self:GetAverageVector( vec_table1, convert1 )
	local vec2 = self:GetAverageVector( vec_table2, convert2 )
	
	if vec1 and vec2 then
		return vec1:Distance( vec2 )
	end
	
	return 0
end

function GM:InitPostEntity()

	//no need for ragdolls crap
	game.ConsoleCommand( "ai_serverragdolls 0\n" )
	
	self:SetRoundTime( CurTime() )
	
	
	if not NO_MAP_PROPS then
		for _, prop in ipairs( ents.FindByClass( "prop_physics*" ) ) do
			
			if IsValid( prop ) then
				for k, wepclass in ipairs( self.AvalaibleWeapons ) do
					local wep = weapons.Get( wepclass )
					if string.lower(prop:GetModel()) == string.lower(wep.WorldModel) and not wep.DroppedModel and not wep.Hidden then
						local pr = ents.Create( "dropped_weapon" )
							pr:SetPos( prop:GetPos() )
							pr:SetAngles( prop:GetAngles() )
							pr:SpawnAsWeapon( wepclass )
							pr.NoKnockback = false
							pr.Exception = true
							pr.MapBased = true
						pr:Spawn()
						table.insert( MapProps, { class = wepclass, pos = prop:GetPos(), ang = prop:GetAngles() } )
						SafeRemoveEntity( prop )
					end
				end
			end
		end
	end
	
	local function FixVisleafs( pl )	
		
		local max = 10
		local count = 0
		local min_dist = 0
		local cur_pos
		
				
		for k, v in pairs( POINT_PICKUPS ) do
			if v and v:IsValid() then				
				//apparently this causes engine error if we put too many, so lets fix that
				if string.find( game.GetMap(), "apartments" ) then
					continue
					//if k >= 8 then
						//break
					//end
				end
				
				AddOriginToPVS( v:GetPos() + vector_up * 30 )
				
			end
		end
	end
	if game.SinglePlayer() then
		hook.Add( "SetupPlayerVisibility", "FixVisleafs", FixVisleafs )
	end
	
	
	//some messy map editing
	if string.find( game.GetMap(), "sog_office" ) then
		
		for _, prop in ipairs( ents.FindByClass( "prop_physics*" ) ) do
			if prop and prop:IsValid() then
				SafeRemoveEntity( prop )
			end
		end
	
		/*for _, v in ipairs( ents.FindByClass( "prop_physics*" ) ) do
			if v and v:IsValid() and ( v:GetModel() == "models/props/cs_office/file_cabinet1.mdl" or v:GetModel() == "models/props/cs_office/file_cabinet3.mdl") then
				v:Remove()
			end
		end*/
	end
	
	//goddamnit, stelk!
	if game.GetMap() == "sog_disco" then
		local toremove = ents.FindByClass( "func_clip_vphysics" )
		for k, v in pairs( toremove ) do
			if v and v:IsValid() then
				v:Remove()
			end
		end
	end
	
	//uh
	if game.GetMap() == "sog_storm" then
		local block = ents.Create( "prop_dynamic_override" )
			block:SetModel( "models/props_c17/fence03a.mdl" )
			block:SetPos( Vector( -53.379124, 618.693359, 54.375587 ) )
			block:SetAngles( Angle( 0, -92, 0 ) )
			block:SetKeyValue("solid", "6")
		block:Spawn()
		local block = ents.Create( "prop_dynamic_override" )
			block:SetModel( "models/props_c17/fence02a.mdl" )
			block:SetPos( Vector( 114.010521, 607.606445, 56.326408 ) )
			block:SetAngles( Angle( 0, -91, 0 ) )
			block:SetKeyValue("solid", "6")
		block:Spawn()
	end
	
	if game.GetMap() == "sog_apartments" then
		
		local p = ents.Create( "prop_dynamic" )
		p:SetModel( "models/props_interiors/radiator01a.mdl" )
		p:SetPos( Vector( -39.810043334961, -989.83630371094, 18.623920440674 ) )
		p:SetAngles( Angle( 0.98460322618484, 2.6826329231262, 0.6657652258873 ) )
		p:SetKeyValue("solid", "6")
		p:Spawn()
		
		p:AddEffects( EF_NODRAW )
		
		local p = ents.Create( "prop_dynamic" )
		p:SetModel( "models/props_interiors/radiator01a.mdl" )
		p:SetPos( Vector( -26.538772583008, -1036.5109863281, 21.225894927979 ) )
		p:SetAngles( Angle( 0.035070687532425, 41.504077911377, -0.00604248046875 ) )
		p:SetKeyValue("solid", "6")
		p:Spawn()
		
		p:AddEffects( EF_NODRAW )

		local p = ents.Create( "prop_dynamic" )
		p:SetModel( "models/props_interiors/radiator01a.mdl" )
		p:SetPos( Vector( 16.407850265503, -1067.8933105469, 22.877395629883 ) )
		p:SetAngles( Angle( -2.1896761609241e-05, 63.559757232666, -2.8019714355469 ) )
		p:SetKeyValue("solid", "6")
		p:Spawn()
		
		p:AddEffects( EF_NODRAW )
		
		local p = ents.Create( "prop_dynamic" )
		p:SetModel( "models/props_interiors/radiator01a.mdl" )
		p:SetPos( Vector( 93.038269042969, -1062.9191894531, 18.669267654419 ) )
		p:SetAngles( Angle( -0.0035602322313935, 120.87338256836, 1.2343055009842 ) )
		p:SetKeyValue("solid", "6")
		p:Spawn()
		
		p:AddEffects( EF_NODRAW )
		
		local p = ents.Create( "prop_dynamic" )
		p:SetModel( "models/props_interiors/radiator01a.mdl" )
		p:SetPos( Vector( 124.73292541504, -1031.4246826172, 10.453615188599 ) )
		p:SetAngles( Angle( -0.66617089509964, 89.00178527832, 0.26494526863098 ) )
		p:SetKeyValue("solid", "6")
		p:Spawn()
		
		p:AddEffects( EF_NODRAW )
		
		local p = ents.Create( "prop_dynamic" )
		p:SetModel( "models/props_interiors/radiator01a.mdl" )
		p:SetPos( Vector( 185.87533569336, -980.08850097656, 17.411291122437 ) )
		p:SetAngles( Angle( -2.7475950717926, -107.85430908203, 2.0977649688721 ) )
		p:SetKeyValue("solid", "6")
		p:Spawn()
		
		p:AddEffects( EF_NODRAW )
		
		local p = ents.Create( "prop_dynamic" )
		p:SetModel( "models/props_interiors/radiator01a.mdl" )
		p:SetPos( Vector( 170.86367797852, -1040.3352050781, 12.748726844788 ) )
		p:SetAngles( Angle( -1.1284400224686, 68.804702758789, 0.31620615720749 ) )
		p:SetKeyValue("solid", "6")
		p:Spawn()
		
		p:AddEffects( EF_NODRAW )

		local p = ents.Create( "prop_dynamic" )
		p:SetModel( "models/props_interiors/radiator01a.mdl" )
		p:SetPos( Vector( 230.02783203125, -994.78656005859, 19.151563644409 ) )
		p:SetAngles( Angle( -1.2721765041351, -107.62287902832, 2.0848648548126 ) )
		p:SetKeyValue("solid", "6")
		p:Spawn()
		
		p:AddEffects( EF_NODRAW )
		
		local p = ents.Create( "prop_dynamic" )
		p:SetModel( "models/props_interiors/radiator01a.mdl" )
		p:SetPos( Vector( 215.37590026855, -1055.8696289063, 15.153722763062 ) )
		p:SetAngles( Angle( -0.017823249101639, 72.843200683594, 0.0010694090742618 ) )
		p:SetKeyValue("solid", "6")
		p:Spawn()
		
		p:AddEffects( EF_NODRAW )

		local p = ents.Create( "prop_dynamic" )
		p:SetModel( "models/props_interiors/radiator01a.mdl" )
		p:SetPos( Vector( 260.41528320313, -1072.3376464844, 16.384120941162 ) )
		p:SetAngles( Angle( 1.0983786582947, 63.489654541016, 0.23403878509998 ) )
		p:SetKeyValue("solid", "6")
		p:Spawn()
		
		p:AddEffects( EF_NODRAW )
		
		local p = ents.Create( "prop_dynamic" )
		p:SetModel( "models/props_interiors/radiator01a.mdl" )
		p:SetPos( Vector( 274.92846679688, -1008.5384521484, 19.717439651489 ) )
		p:SetAngles( Angle( -2.3474981784821, -107.51076507568, 3.4646244049072 ) )
		p:SetKeyValue("solid", "6")
		p:Spawn()
		
		p:AddEffects( EF_NODRAW )

		local p = ents.Create( "prop_dynamic" )
		p:SetModel( "models/props_interiors/radiator01a.mdl" )
		p:SetPos( Vector( 315.78890991211, -1091.4260253906, 18.621194839478 ) )
		p:SetAngles( Angle( 0.95086246728897, 82.077247619629, -0.017791748046875 ) )
		p:SetKeyValue("solid", "6")
		p:Spawn()
		
		p:AddEffects( EF_NODRAW )
		
		local p = ents.Create( "prop_dynamic" )
		p:SetModel( "models/props_interiors/radiator01a.mdl" )
		p:SetPos( Vector( 370.71054077148, -1083.4105224609, 19.926740646362 ) )
		p:SetAngles( Angle( -0.2300531566143, 122.10753631592, -2.9718627929688 ) )
		p:SetKeyValue("solid", "6")
		p:Spawn()
		
		p:AddEffects( EF_NODRAW )
		
		local p = ents.Create( "prop_dynamic" )
		p:SetModel( "models/props_interiors/radiator01a.mdl" )
		p:SetPos( Vector( 412.90612792969, -1051.0506591797, 12.073778152466 ) )
		p:SetAngles( Angle( -0.15106165409088, 110.34623718262, -1.5314025878906 ) )
		p:SetKeyValue("solid", "6")
		p:Spawn()
		
		p:AddEffects( EF_NODRAW )
	
		local p = ents.Create( "prop_dynamic" )
		p:SetModel( "models/props_junk/ravenholmsign.mdl" )
		p:SetPos( Vector( 429.80642700195, -990.21734619141, 33.699436187744 ) )
		p:SetAngles( Angle( -5.2273626327515, -68.935958862305, -0.30587768554688 ) )
		p:SetKeyValue("solid", "6")
		p:Spawn()
		
		p:AddEffects( EF_NODRAW )

		local p = ents.Create( "prop_dynamic" )
		p:SetModel( "models/props_interiors/radiator01a.mdl" )
		p:SetPos( Vector( 552.84606933594, -1040.7535400391, 15.432860374451 ) )
		p:SetAngles( Angle( 0.77526378631592, 66.80583190918, 6.5404124259949 ) )
		p:SetKeyValue("solid", "6")
		p:Spawn()
		
		p:AddEffects( EF_NODRAW )
		
		local p = ents.Create( "prop_dynamic" )
		p:SetModel( "models/props_junk/ravenholmsign.mdl" )
		p:SetPos( Vector( 654.77941894531, -1087.8361816406, 15.939329147339 ) )
		p:SetAngles( Angle( -3.5894749164581, -120.39681243896, 2.1187605857849 ) )
		p:SetKeyValue("solid", "6")
		p:Spawn()
		
		p:AddEffects( EF_NODRAW )
		
		local p = ents.Create( "prop_dynamic" )
		p:SetModel( "models/props_junk/ravenholmsign.mdl" )
		p:SetPos( Vector( 716.34173583984, -1064.1658935547, 14.022121429443 ) )
		p:SetAngles( Angle( 1.4023315906525, -116.86206817627, 2.2518148422241 ) )
		p:SetKeyValue("solid", "6")
		p:Spawn()
		
		p:AddEffects( EF_NODRAW )

		local p = ents.Create( "prop_dynamic" )
		p:SetModel( "models/props_junk/ravenholmsign.mdl" )
		p:SetPos( Vector( 710.53216552734, -997.62780761719, 10.465446472168 ) )
		p:SetAngles( Angle( -15.296123504639, -97.648155212402, -5.5928955078125 ) )
		p:SetKeyValue("solid", "6")
		p:Spawn()
		
		p:AddEffects( EF_NODRAW )
		
		local p = ents.Create( "prop_dynamic" )
		p:SetModel( "models/props_junk/ravenholmsign.mdl" )
		p:SetPos( Vector( 712.23809814453, -1046.7642822266, 13.533690452576 ) )
		p:SetAngles( Angle( -5.4908299446106, 74.908340454102, -2.5251159667969 ) )
		p:SetKeyValue("solid", "6")
		p:Spawn()
		
		p:AddEffects( EF_NODRAW )
		
		local p = ents.Create( "prop_dynamic" )
		p:SetModel( "models/props_junk/ravenholmsign.mdl" )
		p:SetPos( Vector( 753.92932128906, -1054.5352783203, 13.003923416138 ) )
		p:SetAngles( Angle( -3.681339263916, 76.727416992188, 1.7604312896729 ) )
		p:SetKeyValue("solid", "6")
		p:Spawn()
		
		p:AddEffects( EF_NODRAW )

		local p = ents.Create( "prop_dynamic" )
		p:SetModel( "models/props_junk/ravenholmsign.mdl" )
		p:SetPos( Vector( 783.75152587891, -1010.9642333984, 10.885940551758 ) )
		p:SetAngles( Angle( -7.9079217910767, -102.77665710449, 6.1396594047546 ) )
		p:SetKeyValue("solid", "6")
		p:Spawn()
		
		p:AddEffects( EF_NODRAW )

	end
	
	if string.find( game.GetMap(), "sog_horsebang" ) then
		local props = ents.FindByClass( "prop_physics*" )
		for k, v in pairs( props ) do
			if v and v:IsValid() and string.find( v:GetModel(), "barstool" ) then
				v:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
			end
			if v and v:IsValid() and string.find( v:GetModel(), "horse" ) then
				v:SetMaterial( "models/flesh" ) 
			end
			if v and v:IsValid() and string.find( v:GetModel(), "wood_crate001a" ) then
				v:SetHealth( 9999999 ) 
			end
		end
	end
	
	if string.find( game.GetMap(), "sog_deathloop" ) then
		local props = ents.FindByClass( "prop_physics*" )
		for k, v in pairs( props ) do
			if v and v:IsValid() then
				v:SetMaterial( "!dev30_model" ) 
			end
		end
		local props = ents.FindByClass( "prop_dynamic" )
		for k, v in pairs( props ) do
			if v and v:IsValid() then
				v:SetMaterial( "!dev30_model" ) 
			end
		end
	end
	
	if string.find( game.GetMap(), "sog_destruct" ) then
		local fire = ents.FindByClass( "env_fire" )
		for k, v in pairs( fire ) do
			if v and v:IsValid() then
				v:SetKeyValue( "damagescale", -1 )
			end
		end
	end
	
	if string.find( game.GetMap(), "sog_stakes" ) then
		local toremove = ents.FindByClass( "prop_physics*" )
		for k, v in pairs( toremove ) do
			if v and v:IsValid() and string.find( v:GetModel(), "chair" ) then
				v:Remove()
			end
		end
		for _, prop in ipairs( ents.FindByClass( "prop_physics*" ) ) do
			if prop and prop:IsValid() then
				prop:PhysicsDestroy() 
				//SafeRemoveEntity( prop )
			end
		end
		
	end
	
	//remove ragdolls
	local toremove = ents.FindByClass( "prop_ragdoll" )
	for k, v in pairs( toremove ) do
		if v and v:IsValid() then
			v:Remove()
		end
	end
	
	if self.OnInitPostEntity then
		self:OnInitPostEntity()
	end
	
	if self.SendToClient then
		self:SendToClient()
	end
	
	
	//PrintTable( MapProps )

end

function GM:EntityRemoved( ent ) 
	if self.OnEntityRemoved then
		self:OnEntityRemoved( ent )
	end
end

GM.BlockedAreas = {}

/*local nav_meta = FindMetaTable( "CNavArea" )
if nav_meta then 
	
	nav_meta.OldIsBlocked = nav_meta.IsBlocked
	
	function nav_meta:IsBlocked( ... )
		
		if GAMEMODE.BlockedAreas and GAMEMODE.BlockedAreas[ tostring( self ) ] then 
			return true 
		end
		
		return self:OldIsBlocked( ... )
		
	end
	
end */


function GM:BlockNavAreas( ent )
	
	timer.Simple( 1, function()
	
		local start = ent:GetPos()//ent:LocalToWorld( ent:OBBCenter() )
		local distance = ent:OBBMins():Distance( ent:OBBMaxs() )
		
		if start and distance then
			//print( start, "   ", distance )
			local area = navmesh.GetNearestNavArea( start, false, distance * 1.1, false, true, -2 )
			if area and area:IsValid() then
				//SetAttributes( NAV_MESH_INVALID ) 
				//area.ForceBlock = true
				self.BlockedAreas[ tostring( area ) ] = true
				//print( "BLOCKING AREA ", area, area:IsBlocked() )
				
				area:Remove()
				
				/*for k, v in pairs( area:GetAdjacentAreas() ) do
					if v and v:IsValid() then
						area:Disconnect( v )
					end
				end*/
				
				//area:SetAttributes( NAV_MESH_NO_MERGE  )
			end
		end
		
	end )
	
end

//basically if there are maps like: map1_v1, map1_v2, etc... - it will take the map with latest version. Type in 'false' if you do not want to do that.
SORT_OUT_OLDER_VERSIONS = true

local cleanname
GM.AvalaibleMaps = {}
function GM:GetAllMaps()
	
	local mapFiles = file.Find( "maps/*.bsp", "GAME" )
	
	table.Empty( self.AvalaibleMaps )
	
	for _,mapname in pairs(mapFiles) do
		if string.sub( mapname, 1,4 ) == "sog_" then
			cleanname = string.sub(mapname, 1, -5)
			self.AvalaibleMaps[cleanname] = { votes = 0 }
		end
	end
	
	if SORT_OUT_OLDER_VERSIONS then
		local version_maps = {}
		
		for k, v in pairs(self.AvalaibleMaps) do
			local version = string.find( k, "_v" )
			if version then 
				version_maps[k] = version
			end
		end
		
		local toclean = {}
		
		for k,v in pairs(version_maps) do
			local cur = tonumber(string.sub( k, 2 + v )) // '2+' because there is also '_v'
			local max = cur
			local match = k
			for k1, v1 in pairs(version_maps) do
				
				if k ~= k1 and string.find( k, string.sub( k1, 1, v - 1 ) ) then
					local cur1 = tonumber(string.sub( k1, 2 + v1 ))
					
					if cur1 > cur then
						max = cur1
						match = k1
					else
						if !table.HasValue( toclean, k1 ) then
							table.insert( toclean, k1 )
						end
					end
					
				end

			end
		end
			
		for k, v in pairs( toclean ) do
			if self.AvalaibleMaps[v] then
				self.AvalaibleMaps[v] = nil
			end
		end
	end

	
	//PrintTable(self.AvalaibleMaps)
	
end

