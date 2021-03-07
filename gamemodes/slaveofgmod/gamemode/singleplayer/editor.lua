if SERVER then

concommand.Add( "editor_open", function( pl, cmd, args )
	
	if !game.SinglePlayer() then return end
	if !pl:Alive() then return end
	
	if GAMEMODE.RDMBots then
		game.ConsoleCommand( "sog_rdm_bots_enable 0\n" )
	end
	
	pl:StripWeapons()
	pl:GodEnable()
	
	pl:SendLua("LoadEditor()")
	
	//to prevent some things
	EDITOR_MODE = true
	
end)



concommand.Add( "editor_addspawnpoint", function( pl, cmd, args )
	
	if !game.SinglePlayer() then return end
	if !pl:Alive() then return end
	
	PLAYER_SPAWNPOINT = pl:GetPos()
	
end)

concommand.Add( "editor_return", function( pl, cmd, args )
	
	if !game.SinglePlayer() then return end
	//if !pl:Alive() then return end
	
	if GAMEMODE.ReturnToEditor then
		GAMEMODE:ReturnToEditor()
	end
	
end)

//concommands are not enough
util.AddNetworkString( "AddEnemy" )

net.Receive( "AddEnemy", function( len )
	
	if !game.SinglePlayer() then return end
	
	local key = net.ReadString()
	local tbl = net.ReadTable()
		
	local b = GAMEMODE:SpawnBot( tbl.wep or nil, tbl.char or "default", tbl.pos or nil, tbl.ally and TEAM_PLAYER or TEAM_MOB, tbl.ally and TEAM_MOB or TEAM_PLAYER, nil )
	if tbl.ang then
		b:SetAngles( tbl.ang )
	end
	b.IgnoreTeamDamage = TEAM_MOB
	b.AllowRespawn = false
	b:SetBehaviour( BEHAVIOUR_DUMB ) //always use dumb for editor
	b.EditorTag = key
	b:SetImmune( true ) //just in case
	if tbl.anim then
		b.IdleAnim = tbl.anim
	end
	
end)

util.AddNetworkString( "RemoveNearbyEnemy" )
util.AddNetworkString( "RemoveAllEnemies" )
util.AddNetworkString( "RemoveNearbyEnemyClient" )

net.Receive( "RemoveAllEnemies", function( len )
	
	if !game.SinglePlayer() then return end
	
	for k, v in pairs( NEXTBOTS ) do
		if v and v:IsValid() then
			//if v.IgnoreDeaths then continue end
			for _, b in pairs( v.Bodyguards or {} ) do
				if b and b:IsValid() then
					b:Remove()
				end
			end
			v:Remove()
		end
	end	
	
end)

net.Receive( "RemoveNearbyEnemy", function( len )
	
	if !game.SinglePlayer() then return end
	
	local pos = net.ReadVector()
	local key
	
	local max = 99999
	local cur_closest
	
	for k, v in pairs( NEXTBOTS ) do
		if v and v:IsValid() and v:GetPos():Distance(pos) <= max then
			max = v:GetPos():Distance(pos)
			cur_closest = v
		end
	end
	
	if cur_closest and cur_closest:IsValid() and cur_closest.EditorTag and cur_closest:GetPos():Distance(pos) < 60 then
		key = cur_closest.EditorTag
		for _, b in pairs( cur_closest.Bodyguards or {} ) do
			if b and b:IsValid() then
				b:Remove()
			end
		end
		cur_closest:Remove()
	end
	
	if key then
		net.Start( "RemoveNearbyEnemyClient" )
			net.WriteString( key )
		net.Broadcast()
	end
	
	
end)

util.AddNetworkString( "RetreiveWeaponTables" )
util.AddNetworkString( "SendWeaponTables" )


net.Receive( "RetreiveWeaponTables", function( len )
	
	if !game.SinglePlayer() then return end
	
	net.Start("SendWeaponTables")
		net.WriteTable( GAMEMODE.AvalaibleWeapons )
		net.WriteTable( GAMEMODE.ThrowableWeapons )
		net.WriteTable( GAMEMODE.MeleeWeapons )
		net.WriteTable( GAMEMODE.RangedWeapons )
	net.Broadcast()	
	
end)

util.AddNetworkString( "AddWeapon" )

net.Receive( "AddWeapon", function( len )
	
	if !game.SinglePlayer() then return end
	
	local key = net.ReadString()
	local tbl = net.ReadTable()
		
	local pr = ents.Create( "dropped_weapon" )
		pr:SetPos( tbl.pos + vector_up * 15 )
		pr:SpawnAsWeapon( tbl.wep )
		pr.NoKnockback = false
		pr.MapBased = true
	pr:Spawn()
	pr:SetCollisionGroup( COLLISION_GROUP_DEBRIS ) // to prevent from picking up in editor
	local phys = pr:GetPhysicsObject()
	if IsValid(phys) then
		phys:SetVelocityInstantaneous( vector_up * 130 )
		//phys:Sleep()
	end
	pr.EditorTag = key
	
end)

util.AddNetworkString( "RemoveNearbyWeapon" )
util.AddNetworkString( "RemoveAllWeapons" )
util.AddNetworkString( "RemoveNearbyWeaponClient" )

net.Receive( "RemoveAllWeapons", function( len )
	
	if !game.SinglePlayer() then return end
	
	for _, wep in pairs( DROPPED_WEAPONS ) do
		if wep and wep:IsValid() and wep.EditorTag then
			wep:Remove()
		end
	end
	
end)

net.Receive( "RemoveNearbyWeapon", function( len )
	
	if !game.SinglePlayer() then return end
	
	local pos = net.ReadVector()
	local key
	
	local max = 99999
	local cur_closest
	
	for k, v in pairs( DROPPED_WEAPONS ) do
		if v and v:IsValid() and v:GetPos():Distance(pos) <= max then
			max = v:GetPos():Distance(pos)
			cur_closest = v
		end
	end
	
	if cur_closest and cur_closest:IsValid() and cur_closest.EditorTag and cur_closest:GetPos():Distance(pos) < 60 then
		key = cur_closest.EditorTag
		cur_closest:Remove()
	end
	
	if key then
		net.Start( "RemoveNearbyWeaponClient" )
			net.WriteString( key )
		net.Broadcast()
	end
	
	
end)

end


if CLIENT then
//nice job, finding this one
SOG_EDITOR_TEST = util.tobool( CreateClientConVar("sog_editor_test", 0, true, false):GetInt() )
cvars.AddChangeCallback("sog_editor_test", function(cvar, oldvalue, newvalue)
	SOG_EDITOR_TEST = util.tobool( newvalue )
end)

EDITOR = {}

local EditorCharacters = { "protagonist", "moderator", "mark", "matthias", "server owner", "steve", "axe guy", "carl", "thomas", "garry", "watch", "james" }

local Enemies = {
	["darkrp/ttt"] = { "admin", "banned", "kid", "cop kid", "server owner", "thug kid", "detective", "traitor" },
	["gmpower"] = { "gmpower random", "gmpower mod", "gmpower admin", "infected" },
	["coderfired"] = { "greed crew default", "greed crew trusted", "greed crew featured", "greed crew premium", "greed crew shield", "greed crew thug", "banned", "greed crew starter", "greed crew leaker", "greed crew bitch" },
	["lowlife"] = { "zombie normal", "zombie fast", "hobo" },
	["swat"] = { "swat default", "swat tactical", "swat heavy", "swat sniper" },
	["shitgamers"] = { "mutilated cop kid", "mutilated admin", "mutilated kid", "mutilated banned" },
	["singleplayer"] = { "axe guy", "carl", "steve", "matthias", "mark", "mercenary", "victim", 
				"thomas", "bystander weird", "bystander", "boss ase", "boss lick", "boss stan", 
				"boss sellout", "boss donator", "boss master", "protagonist victim" 
				},
	["bonus"] = { "bonus statue", "bonus slave1", "bonus slave2", "bonus slave3", "saw hero", 
				"security guard", "camera crew", "horse default", "horse dancer", "horse security", "horse explosive", "horse abomination",
				"shady car", "bonus bsm cool", "bonus bsm cool leader", "bonus bsm creepy", "boss marishka", "pufulet", "swat edge", "swat weird", "boss protagonist", "boss heks", "heks aid"
				},
}


BEHAVIOUR_DUMB = -1
BEHAVIOUR_DEFAULT = 0
BEHAVIOUR_IDLE = 1
BEHAVIOUR_CCW = 2
BEHAVIOUR_RANDOM = 3
BEHAVIOUR_FOLLOWER = 4

SHOW_ENEMY_INFO = true
SHOW_WEAPON_INFO = true
SHOW_TRIGGERS = true

ADD_OBJECT_TO_STAGE = {}

//need this to update trigger tabs with content
CONTENTS_CHANGED = true

local BehaviourToText = {
	[BEHAVIOUR_DUMB] = "Do nothing at all",
	[BEHAVIOUR_DEFAULT] = "Default( walks randomly )",
	[BEHAVIOUR_IDLE] = "Idle( attacks on sight )",
	[BEHAVIOUR_CCW] = "Patrolling",
	[BEHAVIOUR_FOLLOWER] = "Follower",
}

local VehicleToModel = {
	[1] = { mdl = "models/props/de_nuke/car_nuke_black.mdl", glass_mdl = "models/props/de_nuke/car_nuke_glass.mdl" },
	[2] = { mdl = "models/props/cs_militia/van.mdl", glass_mdl = "models/props/cs_militia/van_glass.mdl"},
	[3] = { mdl = "models/props/de_nuke/car_nuke.mdl", glass_mdl = "models/props/de_nuke/car_nuke_glass.mdl" },
	[4] = { mdl = "models/props/de_nuke/car_nuke_red.mdl", glass_mdl = "models/props/de_nuke/car_nuke_glass.mdl" },
	[5] = { mdl = "models/props/de_nuke/truck_nuke.mdl", glass_mdl = "models/props/de_nuke/truck_nuke_glass.mdl", ang_off = Angle( 0, -180, 0)},
	[6] = { mdl = "models/props/de_train/utility_truck.mdl", glass_mdl = "models/props/de_train/utility_truck_windows.mdl", ang_off = Angle( 0, -90, 0)},
	[7] = { mdl = "models/props_vehicles/car002a.mdl", pos_off = Vector( 0, 0, 35 ), ang_off = Angle( 0, 90, 0 )},
	[8] = { mdl = "models/props_vehicles/car003a.mdl", pos_off = Vector( 0, 0, 35 ), ang_off = Angle( 0, 90, 0 )},
	[9] = { mdl = "models/props_vehicles/car004a.mdl", pos_off = Vector( 0, 0, 35 ), ang_off = Angle( 0, 90, 0 )},
	[10] = { mdl = "models/props_vehicles/car005a.mdl", pos_off = Vector( 0, 0, 35 ), ang_off = Angle( 0, 90, 0 )},
	[11] = { mdl = "models/props_vehicles/van001a.mdl", pos_off = Vector( 0, 0, 35 ), ang_off = Angle( 0, 90, 0 )},
}

local Weapons = {
	"sogm_usp", "sogm_usp_silenced", "sogm_ak47", "sogm_shotgun", "sogm_m4", "sogm_uzi", "sogm_mp5", "sogm_katana", "sogm_m3", "sogm_famas",
	"sogm_tmp", "sogm_magnum", "sogm_ump", "sogm_pipe", "sogm_axe", "sogm_physcannon", "sogm_glock", "sogm_stunstick_normal", "sogm_usp_akimbo",
	"sogm_m1014", "sogm_beretta_single", "sogm_boomstick", "sogm_sawblade", "sogm_deagle", "sogm_m249", "sogm_protestsign", "sogm_hook", "sogm_riotshield"
}

local IdleAnims = { "taunt_dance_base", "taunt_muscle_base", "pose_standing_01", 
	"pose_standing_02", "pose_standing_03", "pose_standing_04", "idle_all_cower", "zombie_slump_idle_01", "zombie_slump_idle_02",
	"pose_ducking_01", "pose_ducking_02", "sit_zen", "idle_passive", "seq_preskewer"
}

local EditorWeapons = {
	["all"] = {},
	["melee"] = {},
	["guns"] = {},
	["throwable"] = {},
}

local received_weps = false

local blank = Material( "sog/default.png", "smooth" )
local matHover = Material( "vgui/spawnmenu/hover" )
local arrow = Material( "sog/arrow1.png" )

function LoadEditor()
	
	table.Empty( EDITOR )
	PLAYER_SPAWNPOINT = nil
	EDITOR_VEHICLE = nil
	
	if not received_weps then
		net.Start( "RetreiveWeaponTables" )
		net.SendToServer()
		received_weps = true
	end
	
	//create editor panel
	if EditorPanel then
		EditorPanel:Remove()
		EditorPanel = nil
	end
	
	if FilePanel then
		FilePanel:Remove()
		FilePanel = nil
	end
	
	if HelpPanel then
		HelpPanel:Remove()
		HelpPanel = nil
	end
	
	//if we have pending scene - load it instead
	LoadTestScene()

	EditorPanel = GAMEMODE.CursorFix:Add( "DPropertySheet" )
	EditorPanel:SetSize( GAMEMODE.CursorFix:GetWide()/3.8, GAMEMODE.CursorFix:GetTall() )
	EditorPanel:SetPos( GAMEMODE.CursorFix:GetWide() - EditorPanel:GetWide(), 0 )
		
	FilePanel = GAMEMODE.CursorFix:Add( "DPanel" )
	FilePanel:SetSize( 550, 22 )
		
	local new_b = FilePanel:Add( "DButton" )
	new_b:SetText( "New Scene" )
	new_b:SetSize( FilePanel:GetWide()/4, 22 )
	new_b:Dock( LEFT )
	new_b.DoClick = function( self )
		NewSceneMenu( EditorPanel )
	end
	
	local save_b = FilePanel:Add( "DButton" )
	save_b:SetText( "Save Scene" )
	save_b:SetSize( FilePanel:GetWide()/4, 22 )
	save_b:Dock( LEFT )
	save_b.DoClick = function( self )
		SaveScene()
	end
	save_b.Think = function( self )
		if not PLAYER_SPAWNPOINT then
			self:SetEnabled( false )
		else
			self:SetEnabled( true )
		end
	end
	
	local load_b = FilePanel:Add( "DButton" )
	load_b:SetText( "Load Scene" )
	load_b:SetSize( FilePanel:GetWide()/4, 22 )
	load_b:Dock( LEFT )
	load_b.DoClick = function( self )
		LoadSceneMenu( EditorPanel )
	end
	
	local test_b = FilePanel:Add( "DButton" )
	test_b:SetText( "Test Scene" )
	test_b:SetSize( FilePanel:GetWide()/4, 22 )
	test_b:Dock( LEFT )
	test_b.DoClick = function( self )
		PlayTestScene()
	end
	test_b.Think = function( self )
		if not PLAYER_SPAWNPOINT then
			self:SetEnabled( false )
		else
			self:SetEnabled( true )
		end
	end
	
	AddTabs( EditorPanel )
	
	EditorPanel:SetVisible( false )
	
	HelpPanel = GAMEMODE.CursorFix:Add( "DPanel" )
	HelpPanel:SetPos( 0, 34 )
	HelpPanel:SetSize( 155, 160 )
	HelpPanel.Paint = function( self, sw, sh )
		draw.RoundedBox( 4, 0, 0, 125, 60, Color( 0, 0, 0, 60 ) ) 
	end
	
	local enemy_info = HelpPanel:Add( "DCheckBoxLabel" )
	enemy_info:SetText( "Show enemy info" )
	enemy_info:SetTall( 20 )
	enemy_info:SetValue( SHOW_ENEMY_INFO )
	enemy_info:DockMargin( 2, 1, 2, 0 )
	enemy_info:Dock( TOP )
	enemy_info.OnChange = function( self, bVal )
		SHOW_ENEMY_INFO = bVal
	end
	
	local trigger_info = HelpPanel:Add( "DCheckBoxLabel" )
	trigger_info:SetText( "Show triggers" )
	trigger_info:SetTall( 20 )
	trigger_info:SetValue( SHOW_TRIGGERS )
	trigger_info:DockMargin( 2, 1, 2, 0 )
	trigger_info:Dock( TOP )
	trigger_info.OnChange = function( self, bVal )
		SHOW_TRIGGERS = bVal
	end
	
	local wep_info = HelpPanel:Add( "DCheckBoxLabel" )
	wep_info:SetText( "Show pickup info" )
	wep_info:SetTall( 20 )
	wep_info:SetValue( SHOW_WEAPON_INFO )
	wep_info:DockMargin( 2, 1, 2, 0 )
	wep_info:Dock( TOP )
	wep_info.OnChange = function( self, bVal )
		SHOW_WEAPON_INFO = bVal
	end
	
	
	for i=1, 4 do
		
		local stage = HelpPanel:Add( "DCheckBoxLabel" )
		stage:SetText( "Add object to stage #"..i )
		stage:SetTall( 20 )
		stage:SetValue( ADD_OBJECT_TO_STAGE[ i ] or false )
		stage:DockMargin( 2, i==1 and 20 or 1, 2, 0 )
		stage:Dock( TOP )
		stage.OnChange = function( self, bVal )
			ADD_OBJECT_TO_STAGE[ i ] = bVal
		end
		
	end
	
		
end

function NewSceneMenu( p )

	RemoveAllEnemies()
	RemoveAllWeapons()
	RemoveAllTriggers()
	
	table.Empty( EDITOR )
	PLAYER_SPAWNPOINT = nil
	EDITOR_VEHICLE = nil

	p:SetVisible( false )

	//name and etc
	local Intro = vgui.Create( "DFrame", GAMEMODE.CursorFix:GetWide() )
	Intro:SetSize( GAMEMODE.CursorFix:GetWide()/2.6, GAMEMODE.CursorFix:GetTall()/2.3 )
	Intro:Center()
	Intro:SetDraggable( false )
	Intro:SetTitle( "New Scene" )
	Intro:MakePopup()
	
	local Intro_p = Intro:Add( "DPanel" )
	Intro_p:Dock( FILL )
	
	local name = Intro_p:Add( "DTextEntry" )
	name:SetText( "untitled" )
	name:SetEditable( true )
	name:SetTall( 22 )
	name:Dock( TOP )
	
	local song = Intro_p:Add( "DPanel" )
	song:SetTall( 22 )
	song:Dock( TOP )
	
		local song_url = song:Add( "DTextEntry" )
		song_url:SetText( "full url to soundcloud track" )
		song_url:SetEditable( true )
		song_url:SetSize( Intro:GetWide()/2, 22 )
		song_url:Dock( LEFT )
		
		local song_vol = song:Add( "DNumSlider" )
		song_vol:SetText( "Volume" )
		song_vol:SetSize( Intro:GetWide()/2.5, 22 )
		song_vol:SetDecimals( 0 )
		song_vol:SetMin( 0 )	
		song_vol:SetMax( 100 )
		song_vol:SetValue( 30 )
		song_vol:SetDark( true )
		song_vol:Dock( RIGHT )
		
	local song_tr = Intro_p:Add( "DPanel" )
	song_tr:SetTall( 22 )
	song_tr:Dock( TOP )
	
		local tr_start = song_tr:Add( "DNumSlider" )
		tr_start:SetText( "Start from:" )
		tr_start:SetSize( Intro:GetWide()/2, 22 )
		tr_start:SetDecimals( 0 )
		tr_start:SetMin( 0 )	
		tr_start:SetMax( 0 )
		tr_start:Dock( LEFT )
		tr_start:SetDark( true )
		tr_start.OnValueChanged = function( self, val )
			self.TextArea:SetNumeric( false )
			self.TextArea:SetValue( string.ToMinutesSecondsMilliseconds( val )  ) 
		end
		tr_start:SetValue( 0 )
		
		local tr_end = song_tr:Add( "DNumSlider" )
		tr_end:SetText( "End at:" )
		tr_end:SetSize( Intro:GetWide()/2, 22 )
		tr_end:SetDecimals( 0 )
		tr_end:SetMin( 0 )	
		tr_end:SetMax( 0 )
		tr_end:Dock( LEFT )
		tr_end:SetDark( true )
		tr_end.OnValueChanged = function( self, val )
			self.TextArea:SetNumeric( false )
			self.TextArea:SetValue( string.ToMinutesSecondsMilliseconds( val )  ) 
		end
		tr_end:SetValue( 0 )		
			
	local sname = Intro_p:Add( "DTextEntry" )
	sname:SetText( "Musician - Song Name" )
	sname:SetEditable( true )
	sname:SetTall( 22 )
	sname:Dock( TOP )
	
	song_url.OnLoseFocus = function( self )
		
		local key = "e4b98888683c9b1633202415df2b273d"
		
		http.Fetch( "http://api.soundcloud.com/resolve.json?url="..self:GetValue().."&client_id="..key, function ( body )
			if body then
				
				if not ( song_url and song_url:IsValid() ) then return end
				
				local tbl = util.JSONToTable( body )
				
				if tbl then
					song_url.ID = tonumber( tbl.id )
					
					local musician = tbl.user.username
					
					local song_duration = tonumber( tbl.duration )
					local song_duration_norm = math.floor( song_duration / 1000 )
					
					tr_start:SetMax( song_duration_norm )
					tr_end:SetMax( song_duration_norm )
					tr_end:SetValue( song_duration_norm )
					
					local songname = tbl.title
					
					sname:SetText( musician.." - "..songname )
					
					
				end
			
			end
		end )
		
		/*local bd = ""
		
		http.Fetch( self:GetValue(),
			function( body, len, headers, code )
			
				//timer.Simple( 1, function()
			
					if not ( song_url and song_url:IsValid() ) then return end
				
					bd = body
					
					//super shitty method, but it works
					
					//get song id
					local start_text = [["uri":"https://api.soundcloud.com/tracks/]]
										
					local start_ = string.find( bd, start_text ) + #start_text
					
					local end_text = [[","urn":]]		
					local end_ = string.find( bd, end_text) - 1
				
					local text = string.sub( bd, start_, end_)
					song_url.ID = tonumber( text )
										
					//get song musician
					start_text = [["username":"]]
					start_ = string.find( bd, start_text) + #start_text
					end_text = [[","last_modified"]]
					end_ = string.find( bd, end_text) - 1
					
					text = string.sub( bd, start_, end_)
					
					local musician = text
										
					//get song duration
					start_text = [["duration":]]
					start_ = string.find( bd, start_text) + #start_text
					end_text = [[,"full_duration"]]
					end_ = string.find( bd, end_text) - 1
					
					text = string.sub( bd, start_, end_)
					
					local song_duration = tonumber(text)
					local song_duration_norm = math.floor( song_duration / 1000 )
					
					tr_start:SetMax( song_duration_norm )
					tr_end:SetMax( song_duration_norm )
					tr_end:SetValue( song_duration_norm )
					
					//get song name
					start_text = [["title":"]]
					start_ = string.find( bd, start_text) + #start_text
					text = string.sub( bd, start_, -1)
					end_text = [[","uri"]]
					end_ = string.find( text, end_text) - 1
					
					text = string.sub( text, 1, end_)
					
					local songname = text
					
					sname:SetText( musician.." - "..songname )
				
				//end)
				
			end,
			function( error )
			end
		 )*/
		 
	end
	
	//ambient music
	local amb = Intro_p:Add( "DPanel" )
	amb:SetTall( 22 )
	amb:Dock( TOP )
	
		local amb_url = amb:Add( "DTextEntry" )
		amb_url:SetText( "(Optional Ambient) full url to soundcloud track" )
		amb_url:SetEditable( true )
		amb_url:SetSize( Intro:GetWide()/2, 22 )
		amb_url:Dock( LEFT )
		
		local amb_vol = amb:Add( "DNumSlider" )
		amb_vol:SetText( "Volume" )
		amb_vol:SetSize( Intro:GetWide()/2.5, 22 )
		amb_vol:SetDecimals( 0 )
		amb_vol:SetMin( 0 )	
		amb_vol:SetMax( 100 )
		amb_vol:SetValue( 30 )
		amb_vol:SetDark( true )
		amb_vol:Dock( RIGHT )
		
	local amb_tr = Intro_p:Add( "DPanel" )
	amb_tr:SetTall( 22 )
	amb_tr:Dock( TOP )
	
		local amb_tr_start = amb_tr:Add( "DNumSlider" )
		amb_tr_start:SetText( "Start from:" )
		amb_tr_start:SetSize( Intro:GetWide()/2, 22 )
		amb_tr_start:SetDecimals( 0 )
		amb_tr_start:SetMin( 0 )	
		amb_tr_start:SetMax( 0 )
		amb_tr_start:Dock( LEFT )
		amb_tr_start:SetDark( true )
		amb_tr_start.OnValueChanged = function( self, val )
			self.TextArea:SetNumeric( false )
			self.TextArea:SetValue( string.ToMinutesSecondsMilliseconds( val )  ) 
		end
		amb_tr_start:SetValue( 0 )
		
		local amb_tr_end = amb_tr:Add( "DNumSlider" )
		amb_tr_end:SetText( "End at:" )
		amb_tr_end:SetSize( Intro:GetWide()/2, 22 )
		amb_tr_end:SetDecimals( 0 )
		amb_tr_end:SetMin( 0 )	
		amb_tr_end:SetMax( 0 )
		amb_tr_end:Dock( LEFT )
		amb_tr_end:SetDark( true )
		amb_tr_end.OnValueChanged = function( self, val )
			self.TextArea:SetNumeric( false )
			self.TextArea:SetValue( string.ToMinutesSecondsMilliseconds( val )  ) 
		end
		amb_tr_end:SetValue( 0 )
		
	amb_url.OnLoseFocus = function( self )
		
		local key = "e4b98888683c9b1633202415df2b273d"
		
		http.Fetch( "http://api.soundcloud.com/resolve.json?url="..self:GetValue().."&client_id="..key, function ( body )
			if body then
				
				if not ( amb_url and amb_url:IsValid() ) then return end
				
				local tbl = util.JSONToTable( body )
				
				if tbl then
					amb_url.ID = tonumber( tbl.id )
					
					local song_duration = tonumber( tbl.duration )
					local song_duration_norm = math.floor( song_duration / 1000 )
					
					amb_tr_start:SetMax( song_duration_norm )
					amb_tr_end:SetMax( song_duration_norm )
					amb_tr_end:SetValue( song_duration_norm )					
					
				end
			
			end
		end )
		
		/*local bd = ""
		
		http.Fetch( self:GetValue(),
			function( body, len, headers, code )
			
				if not ( amb_url and amb_url:IsValid() ) then return end
			
				bd = body
								
				//get song id
				local start_text = [["uri":"https://api.soundcloud.com/tracks/]]
				local start_ = string.find( bd, start_text) + #start_text
				
				local end_text = [[","urn":]]			
				local end_ = string.find( bd, end_text) - 1
			
				local text = string.sub( bd, start_, end_)
				
				local text = string.sub( bd, start_, end_)
				amb_url.ID = tonumber( text )
								
				//get song duration
				start_text = [["duration":]]
				start_ = string.find( bd, start_text) + #start_text
				end_text = [[,"full_duration"]]
				end_ = string.find( bd, end_text) - 1
				
				text = string.sub( bd, start_, end_)
				
				local song_duration = tonumber(text)
				local song_duration_norm = math.floor( song_duration / 1000 )
				
				amb_tr_start:SetMax( song_duration_norm )
				amb_tr_end:SetMax( song_duration_norm )
				amb_tr_end:SetValue( song_duration_norm )			
				
			end,
			function( error )
			end
		 )*/
		 
	end
	
	local done = Intro_p:Add( "DButton" )
	done:SetTall( 22 )
	done:SetText( "Begin!" )
	done:Dock( BOTTOM )
	
	local char_preview = Intro_p:Add( "DPanel" )
	char_preview:SetWide(Intro:GetWide()/2)
	char_preview:Dock( RIGHT )
	char_preview.PaintOver = function( self, sw, sh )
		surface.SetMaterial( char_preview.Mat or blank )
		local rotation = math.sin( RealTime() * ( 0.8 ) ) * 7 
		
		surface.SetDrawColor( 10,10,10,185 )
		surface.DrawTexturedRectRotated( sw/2, sh/2, sh*0.9, sh*0.9, rotation)
			
		surface.SetDrawColor( char_preview.Mat and color_white or Color(10,10,10,255) )
		surface.DrawTexturedRectRotated( sw/2, sh/2, sh*0.9, sh*0.9, rotation)
	end
	
	local char_list = Intro_p:Add( "DListView" )
	char_list:SetMultiSelect( true )
	char_list:AddColumn( "Select character" )
	char_list:Dock( FILL )	
	
	char_list.tbl = {}
	
	for k, char in pairs( EditorCharacters ) do
		
		local id = GAMEMODE:GetCharacterIdByReference( char )
		
		if id and GAMEMODE.Characters[ id ] then
			
			char_list.tbl[ char ] = table.Copy( GAMEMODE.Characters[ id ] )
			char_list:AddLine( char )
		
		end
		
	end
	
	char_list.OnClickLine = function( self, line, isSelected )	
		local val = line:GetValue( 1 )
		line.Sel = line.Sel or false
		line.Sel = !line.Sel
		line:SetSelected( line.Sel )
		if val and self.tbl[ val ] then
			char_preview.Mat = self.tbl[ val ].Icon
			self.cur_char = val
		end
	end
	
	char_list:OnClickLine( char_list:GetLine( 1 ) )
		
	done.DoClick = function( self )
				
		EDITOR.Name = name:GetValue()
		EDITOR.Map = game.GetMap()
				
		local tbl = { }
		if #char_list:GetSelected() > 1 then
			for k, line in pairs( char_list:GetSelected() ) do
				local val = line:GetValue( 1 )
				if val and char_list.tbl[ val ]then
					table.insert( tbl, val )
				end
			end
		else
			 table.insert( tbl, char_list.cur_char )
		end
		
		EDITOR.Characters = tbl
				
		if song_url.ID then
			EDITOR.SoundTrack = song_url.ID
			EDITOR.Volume = math.ceil(song_vol:GetValue())
			
			if tr_start:GetValue() ~= tr_start:GetMin() then
				EDITOR.StartFrom = math.floor( tr_start:GetValue()) * 1000
			end
			
			if tr_end:GetValue() ~= tr_end:GetMax() then
				EDITOR.EndAt = math.floor( tr_end:GetValue() ) * 1000
			end
			
			if sname:GetValue() ~= "" then
				EDITOR.MusicText = sname:GetValue()
			end
		end
		
		if amb_url.ID then
			EDITOR.Ambient = amb_url.ID
			EDITOR.AmbientVolume = math.ceil(amb_vol:GetValue())
			
			if amb_tr_start:GetValue() ~= amb_tr_start:GetMin() then
				EDITOR.AmbientStartFrom = math.floor( amb_tr_start:GetValue()) * 1000
			end
			
			if amb_tr_end:GetValue() ~= amb_tr_end:GetMax() then
				EDITOR.AmbientEndAt = math.floor( amb_tr_end:GetValue() ) * 1000
			end
		end
		
		//PrintTable(EDITOR)
		
		Intro:Remove()
		Intro = nil
		
		p:SetVisible( true )
		
	end
end

function LoadSceneMenu( p )

	//p:SetVisible( false )

	local Load = vgui.Create( "DFrame", GAMEMODE.CursorFix:GetWide() )
	Load:SetSize( GAMEMODE.CursorFix:GetWide()/3, GAMEMODE.CursorFix:GetTall()/2.5 )
	Load:Center()
	Load:SetDraggable( false )
	Load:SetTitle( "Load Scene" )
	Load:SetSizable( true )
	Load:MakePopup()
	
	local browser = vgui.Create( "DFileBrowser", Load )
	browser:Dock( FILL )
	browser:SetName( "Saved Scenes" )
	browser:SetPath( "GAME" )
	browser:SetBaseFolder( "data/slaveofgmod/savedscenes" )
	browser:SetOpen( true )
	//browser:SetFileTypes( "*.txt" )
	
	function browser:OnSelect( path, icon )
		LoadScene( string.gsub( path, "data/", "" ) )
		Load:Remove()
	end
	
	/*local browser = vgui.Create( "DFileBrowser", Load )
	browser:Dock( FILL )
	browser:SetName( "Saved Scenes" )
	browser:SetPath( "data/slaveofgmod/savedscenes" )
	//browser.Tree.RootNode:AddFolder( "scenes2", "data/slaveofgmod/savedscenes", false )
	browser:SetFileTypes( "*.txt" )
	
	function browser:OnSelect( path, icon )
		LoadScene( string.gsub( path, "data/", "" ) )
		Load:Remove()
	end*/

end

function AddTabs( p )
	
	EDITOR.Enemies = EDITOR.Enemies or {}
	EDITOR.Pickups = EDITOR.Pickups or {}
	EDITOR.Triggers = EDITOR.Triggers or {}
	EDITOR.Dialogues = EDITOR.Dialogues or {}
	
	//level tab
	AddLevelTab( p )	
	//enemies
	AddEnemiesTab( p )	
	//weapons
	AddWeaponsTab( p )
	//triggers
	AddTriggerTab( p )
	//dialogues
	AddDialogueTab( p )
	//stages
	AddStagesTab( p )
end

local function QuickLabel( p, text )
	local l = p:Add( "DLabel" )
	l:SetDark( true )
	l:SetText( text or "" )
	l:SetTall( 22 )
	l:Dock( TOP )
	
	return l
end

local function TextEditForm( title, def_text, apply_func )
	
	local form = vgui.Create("DFrame")
	form:SetSize(300,80)
	form:Center()
	form:SetTitle( title or "No Title" )
	form:ShowCloseButton(false)
	form:MakePopup()
	
	local entry = form:Add("DTextEntry")
	entry:SetPos(2,24)
	entry:SetSize(form:GetWide()-4, 23)
	entry:SetText( def_text or "No text" )
	
	local conf = form:Add("DButton")
	conf:SetText("Confirm")
	conf:SetSize( form:GetWide()/2-4, 30 )
	conf:SetPos( 2, form:GetTall() - 32)
	conf.DoClick = function(self)
		if entry:GetValue() ~= "" then
			apply_func( entry:GetValue() )
			form:Remove()
		end
	end
	
	local cancel = form:Add("DButton")
	cancel:SetText("Cancel")
	cancel:SetSize( form:GetWide()/2-4, 30 )
	cancel:SetPos( form:GetWide()/2+2, form:GetTall() - 32)
	cancel.DoClick = function(self)
		form:Remove()
	end
	

end

function SpawnVehicleFromEditor()
	if EDITOR.Vehicle then
		EDITOR_VEHICLE = true

		local e = EffectData()
			e:SetOrigin( EDITOR.Vehicle.pos )
			e:SetRadius( EDITOR.Vehicle.type or 1 )
		util.Effect( "editor_vehicle", e )
	end
end

function AddLevelTab( p )
	
	local tab = p:Add( "EditablePanel" )
	
	//create spawnpoint
	
	local spawn_b = tab:Add( "DButton" )
	spawn_b:SetTall( 42 )
	spawn_b:SetText( "Set Player's Spawnpoint" )
	spawn_b:Dock( TOP )
	spawn_b.DoClick = function( self )
		PLAYER_SPAWNPOINT = LocalPlayer():GetPos()
		RunConsoleCommand( "editor_addspawnpoint" )
	end	
	
	local angle_p = tab:Add( "DPanel" )
	angle_p:SetTall( 100 )
	angle_p:Dock( TOP )
	
	local img = angle_p:Add( "DPanel" )
	img:SetWide( 100 )
	img:Dock( LEFT )
	
	local veh_settings = angle_p:Add( "DPanel" )
	veh_settings:Dock( FILL )
	
	local veh_type = veh_settings:Add( "DComboBox" )
	veh_type:SetWide( 100 )
	veh_type:Dock( TOP )
	veh_type:AddChoice( "Axe Guy's car", 1, true )
	veh_type:AddChoice( "CoderFired van", 2, false )
	veh_type:AddChoice( "White car", 3, false )
	veh_type:AddChoice( "Red car", 4, false )
	veh_type:AddChoice( "Truck", 5, false )
	veh_type:AddChoice( "Small truck", 6, false )
	veh_type:AddChoice( "HL2 Car #1", 7, false )
	veh_type:AddChoice( "HL2 Car #2", 8, false )
	veh_type:AddChoice( "HL2 Car #3", 9, false )
	veh_type:AddChoice( "HL2 Car #4", 10, false )
	veh_type:AddChoice( "HL2 Broken van", 11, false )
	
	local spawn_veh = veh_settings:Add( "DButton" )
	spawn_veh:SetTall( 42 )
	spawn_veh:SetText( "Spawn/Remove Vehicle" )
	spawn_veh:Dock( BOTTOM )
	
	local img_rot = veh_settings:Add( "DNumSlider" )
	img_rot:SetText( "Vehicle Direction" )
	img_rot:SetWide( tab:GetWide()/2 )
	//img_rot:SetTall( 42 )
	img_rot:SetDecimals( 0 )
	img_rot:SetMin( -180 )	
	img_rot:SetMax( 180 )
	img_rot:SetValue( 0 )
	img_rot:SetDark( true )
	img_rot:Dock( BOTTOM )
	
	img.PaintOver = function( self, sw, sh )
		surface.SetDrawColor( 50, 50, 50, 255 )
		surface.SetMaterial( arrow )
		surface.DrawTexturedRectRotated( sw/2, sh/2, sw*0.9, sh*0.9, ( img_rot:GetValue() or 0 ) - 90 + ( LocalPlayer():FlipView() and 180 or 0 ) ) 
	end
	
	spawn_veh.DoClick = function( self )
		
		if EDITOR_VEHICLE then
			EDITOR_VEHICLE = nil
			EDITOR.Vehicle = nil
		else
			local desc, veh_ind = veh_type:GetSelected()
			
			EDITOR_VEHICLE = true
			EDITOR.Vehicle = { type = veh_ind, pos = ( LocalPlayer():GetPos() +  ( VehicleToModel[veh_ind] and VehicleToModel[veh_ind].pos_off or Vector( 0, 0, 0 ) )), ang = ( Angle( 0, math.ceil( img_rot:GetValue() - 90 ), 0 ) + ( VehicleToModel[veh_ind] and VehicleToModel[veh_ind].ang_off or Angle( 0, 0, 0 ) ) ) }
			
			if VehicleToModel[veh_ind] and VehicleToModel[veh_ind].mdl then
				EDITOR.Vehicle.mdl = VehicleToModel[veh_ind].mdl
			end
			
			if VehicleToModel[veh_ind] and VehicleToModel[veh_ind].glass_mdl then
				EDITOR.Vehicle.glass_mdl = VehicleToModel[veh_ind].glass_mdl
			end
			
			local e = EffectData()
				e:SetOrigin( LocalPlayer():GetPos() )
				e:SetRadius( veh_ind or 1 )
			util.Effect( "editor_vehicle", e )			
		end
	
	
		//AddEnemy( LocalPlayer():GetPos(), Angle( 0 ,math.ceil( img_rot:GetValue() ) ,0 ), tab.SelectedChar, nil, tab.Behaviour, tab.IdleAnim or nil, tab.Immune, tab.Ally )
	end	
	
	local options = tab:Add( "DProperties" )
	options:SetTall( p:GetTall()/1.5 )
	options:Dock( TOP )
	
	local pk = options:CreateRow( "Weapon Pickups", "Remove weapons from map" )
	pk:Setup( "Boolean" )
	pk:SetValue( util.tobool( EDITOR.NoPickups ) )
	pk.DataChanged = function( self, val )
		EDITOR.NoPickups = util.tobool( val )
	end
	
	local pk = options:CreateRow( "Weapon Pickups", "Thrown weapons won't dissapear" )
	pk:Setup( "Boolean" )
	pk:SetValue( util.tobool( EDITOR.PickupsPersistance ) )
	pk.DataChanged = function( self, val )
		EDITOR.PickupsPersistance = util.tobool( val )
	end
	
	local pk = options:CreateRow( "Weapon Pickups", "Weapons don't respawn" )
	pk:Setup( "Boolean" )
	pk:SetValue( util.tobool( EDITOR.NoPickupsRespawn ) )
	pk.DataChanged = function( self, val )
		EDITOR.NoPickupsRespawn = util.tobool( val )
	end
	
	local pk = options:CreateRow( "Weapon Pickups", "Dont turn map props into weapons" )
	pk:Setup( "Boolean" )
	pk:SetValue( util.tobool( EDITOR.NoMapProps ) )
	pk.DataChanged = function( self, val )
		EDITOR.NoMapProps = util.tobool( val )
	end
	
	local pk = options:CreateRow( "Loading Screen", "Blood on loading screen" )
	pk:Setup( "Boolean" )
	pk:SetValue( util.tobool( EDITOR.BloodyScreen ) )
	pk.DataChanged = function( self, val )
		EDITOR.BloodyScreen = util.tobool( val )
	end
	
	local pk = options:CreateRow( "Loading Screen", "Blood Moon version" )
	pk:Setup( "Boolean" )
	pk:SetValue( util.tobool( EDITOR.BloodMoonScreen ) )
	pk.DataChanged = function( self, val )
		EDITOR.BloodMoonScreen = util.tobool( val )
	end
	
	local pk = options:CreateRow( "Background", "Add thunder effects" )
	pk:Setup( "Boolean" )
	pk:SetValue( util.tobool( EDITOR.AddThunder ) )
	pk.DataChanged = function( self, val )
		EDITOR.AddThunder = util.tobool( val )
	end	
	
	local pk = options:CreateRow( "Background", "Upside down view" )
	pk:Setup( "Boolean" )
	pk:SetValue( util.tobool( EDITOR.FlipView ) )
	pk.DataChanged = function( self, val )
		EDITOR.FlipView = util.tobool( val )
	end	
	
	local pk = options:CreateRow( "Background", "Music syncronization" )
	pk:Setup( "Boolean" )
	pk:SetValue( util.tobool( EDITOR.MusicSync ) )
	pk.DataChanged = function( self, val )
		EDITOR.MusicSync = util.tobool( val )
	end	
	
	local pk = options:CreateRow( "Music", "Enable ambient at the beginning" )
	pk:Setup( "Boolean" )
	pk:SetValue( util.tobool( EDITOR.StartFromAmbient ) )
	pk.DataChanged = function( self, val )
		EDITOR.StartFromAmbient = util.tobool( val )
	end	
	
	local pk = options:CreateRow( "Misc", "Nightmare" )
	pk:Setup( "Boolean" )
	pk:SetValue( util.tobool( EDITOR.Nightmare ) )
	pk.DataChanged = function( self, val )
		EDITOR.Nightmare = util.tobool( val )
	end	
	local pk = options:CreateRow( "Misc", "Drug Effect (Overrides visuals from nightmare)" )
	pk:Setup( "Boolean" )
	pk:SetValue( util.tobool( EDITOR.DrugEffect ) )
	pk.DataChanged = function( self, val )
		EDITOR.DrugEffect = util.tobool( val )
	end	
	local pk = options:CreateRow( "Misc", "ShitGamers Ambient (Overrides all above)" )
	pk:Setup( "Boolean" )
	pk:SetValue( util.tobool( EDITOR.Terror ) )
	pk.DataChanged = function( self, val )
		EDITOR.Terror = util.tobool( val )
	end	
	local pk = options:CreateRow( "Misc", "Badass Mode (Only works with specific characters)" )
	pk:Setup( "Boolean" )
	pk:SetValue( util.tobool( EDITOR.BadassMode ) )
	pk.DataChanged = function( self, val )
		EDITOR.BadassMode = util.tobool( val )
	end	
	
	local pk = options:CreateRow( "Misc", "Show remaining enemies" )
	pk:Setup( "Boolean" )
	pk:SetValue( util.tobool( EDITOR.ShowLastEnemies ) )
	pk.DataChanged = function( self, val )
		EDITOR.ShowLastEnemies = util.tobool( val )
	end	
	
	local pk = options:CreateRow( "Performance (aka try these if level is laggy)", "Disable nextbot lights" )
	pk:Setup( "Boolean" )
	pk:SetToolTip( "If you have a lot of nextbots on the bright level - it's advised to disable these lights" )
	pk:SetValue( util.tobool( EDITOR.DisableNextbotLights ) )
	pk.DataChanged = function( self, val )
		EDITOR.DisableNextbotLights = util.tobool( val )
	end	
	
	/*local pk = options:CreateRow( "Advanced", "Multiple stages" )
	pk:Setup( "Boolean" )
	pk:SetToolTip( "Only enable this if you know what you are doing" )
	pk:SetValue( util.tobool( EDITOR.MultipleStages ) )
	pk.DataChanged = function( self, val )
		EDITOR.MultipleStages = util.tobool( val )
	end	*/

	p:AddSheet( "Level", tab, "icon16/cd_edit.png" )

end

function AddEnemiesTab( p )
	
	EDITOR.Enemies = EDITOR.Enemies or {}
	
	local tab = p:Add( "EditablePanel" )
	
	tab.SelectedChar = "kid"
	tab.Behaviour = BEHAVIOUR_DEFAULT
	tab.UseDefaultWeapon = true
	tab.OverrideWeapon = nil
		
	local enemy_factions = tab:Add( "DPropertySheet" )
	enemy_factions:SetSize( p:GetWide(), p:GetTall()/3 )
	enemy_factions:Dock( TOP )
	
	for faction, tbl in pairs( Enemies ) do
		local scroll = enemy_factions:Add( "DScrollPanel" )
		scroll:Dock( FILL )
		local faction_panel = scroll:Add( "DIconLayout" )
		faction_panel:SetSpaceX( 3 )
		faction_panel:SetSpaceY( 3 )
		faction_panel:Dock( FILL )
		for _, char in pairs( tbl ) do
			local id = GAMEMODE:GetCharacterIdByReference( char )
			if id and GAMEMODE.Characters[ id ] then
				local ch = faction_panel:Add( "SpawnIcon" )
				ch:SetSize( p:GetWide()/4.5, p:GetWide()/4.5 )
				ch:InvalidateLayout( true )
				ch:SetModel( GAMEMODE.Characters[ id ].Model )
				ch:SetToolTip( GAMEMODE.Characters[ id ].Name or "untitled" )
				ch.PaintOver = function( self, sw, sh )
					self:DrawSelections()
					
					if GAMEMODE.Characters[ id ].Icon then
						surface.SetDrawColor( 154, 157, 161, 255 )
						surface.DrawRect( 0, 0, sw, sh )
						
						surface.SetDrawColor( 255, 255, 255, 255 )
						surface.SetMaterial( GAMEMODE.Characters[ id ].Icon )
						surface.DrawTexturedRectRotated( sw/2, sh/2, sw*0.9, sh*0.9, 0 )
						
					end
					
					if self.Hovered or tab.SelectedChar == char then

					else
						surface.SetDrawColor( 55, 55, 55, 175 )
						surface.DrawRect( 0, 0, sw, sh )
					end
					draw.SimpleTextOutlined( GAMEMODE.Characters[ id ].Name or "untitled", "Default", sw/2, sh*0.8, tab.SelectedChar == char and Color( 250, 250, 250, 255) or Color( 150, 150, 150, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
				end
				ch.DoClick = function( self )
					tab.SelectedChar = char
				end				
			end
		end
		enemy_factions:AddSheet( faction, scroll )
	end
	
	//behaviours
	local options = tab:Add( "DProperties" )
	options:SetTall( 220 )
	options:Dock( TOP )
	
	local pk = options:CreateRow( "Nextbot Behaviour", "Select behaviour" )
	pk:Setup( "Combo", {} )
	pk:AddChoice( "Default", function() tab.Behaviour = BEHAVIOUR_DEFAULT end, true )
	pk:AddChoice( "Idle", function() tab.Behaviour = BEHAVIOUR_IDLE end )
	pk:AddChoice( "Patrolling", function() tab.Behaviour = BEHAVIOUR_CCW end )
	pk:AddChoice( "Do nothing at all", function() tab.Behaviour = BEHAVIOUR_DUMB end )
	pk:AddChoice( "Follower", function() tab.Behaviour = BEHAVIOUR_FOLLOWER end )
	pk.DataChanged = function( self, data )
		data()
	end
	
	//weapons for enemies
	local wp = options:CreateRow( "Weapons", "Use default weapon" )
	wp:Setup( "Boolean" )
	wp:SetValue( true )

	local wp2 = options:CreateRow( "Weapons", "Override weapon" )
	wp2:Setup( "Combo", {} )
	wp2:AddChoice( "Remove weapon" , "none" )
	for k, v in pairs( Weapons ) do
		//wp2:AddChoice( weapons.Get( v ).PrintName , v )
		wp2:AddChoice( v , v )
	end

	wp2.DataChanged = function( self, data )
		if tab.UseDefaultWeapon then
			wp:SetValue( false )
		end
		tab.OverrideWeapon = data
	end
	
	wp.DataChanged = function( self, val )
		tab.UseDefaultWeapon = util.tobool( val )
		if tab.UseDefaultWeapon then
			tab.OverrideWeapon = nil
		end
	end
	
	local anim = options:CreateRow( "Misc", "Idle Animation" )
	anim:Setup( "Combo", {} )
	anim:AddChoice( "none" , "none" )
	for k, v in pairs( IdleAnims ) do
		anim:AddChoice( v , v ) //don't even ask what it looks like
	end
	
	anim.DataChanged = function( self, data )
		if data == "none" then
			tab.IdleAnim = nil
		else
			tab.IdleAnim = data
		end
	end
	
	local npc = options:CreateRow( "Misc", "Invincible (NPC-like)" )
	npc:Setup( "Boolean" )
	npc:SetValue( false )
	
	npc.DataChanged = function( self, val )
		tab.Immune = util.tobool( val )
	end
	
	local ally = options:CreateRow( "Misc", "Become an Ally (Join player's team)" )
	ally:Setup( "Boolean" )
	ally:SetValue( false )
	
	ally.DataChanged = function( self, val )
		tab.Ally = util.tobool( val )
	end
	
	local opt = options:CreateRow( "Misc", "Optional (doesn't have to be killed)" )
	opt:SetTooltip( "Useful if you want to have targets that you can kill, but you ddon't have to." )
	opt:Setup( "Boolean" )
	opt:SetValue( false )
	
	opt.DataChanged = function( self, val )
		tab.Optional = util.tobool( val )
	end
	
	local angle_p = tab:Add( "DPanel" )
	angle_p:SetTall( 100 )
	angle_p:Dock( TOP )
	
	local img = angle_p:Add( "DPanel" )
	img:SetWide( 100 )
	img:Dock( LEFT )
	
	local img_rot = angle_p:Add( "DNumSlider" )
	img_rot:SetText( "Nextbot Direction" )
	img_rot:SetWide( tab:GetWide()/2 )
	img_rot:SetDecimals( 0 )
	img_rot:SetMin( -180 )	
	img_rot:SetMax( 180 )
	img_rot:SetValue( 0 )
	img_rot:SetDark( true )
	img_rot:Dock( FILL )
	
	img.PaintOver = function( self, sw, sh )
		surface.SetDrawColor( 50, 50, 50, 255 )
		surface.SetMaterial( arrow )
		surface.DrawTexturedRectRotated( sw/2, sh/2, sw*0.9, sh*0.9, ( img_rot:GetValue() or 0 ) - 90 + ( LocalPlayer():FlipView() and 180 or 0 ) )
	end
	
	
	local spawn_b = tab:Add( "DButton" )
	spawn_b:SetTall( 42 )
	spawn_b:SetText( "Add Selected Nextbot" )
	spawn_b:Dock( TOP )
	spawn_b.DoClick = function( self )
		local id = GAMEMODE:GetCharacterIdByReference( tab.SelectedChar )
		if id and GAMEMODE.Characters[ id ] and GAMEMODE.Characters[ id ].NoPickups then
			AddEnemy( LocalPlayer():GetPos(), Angle( 0 ,math.ceil( img_rot:GetValue() ) ,0 ), tab.SelectedChar, nil, tab.Behaviour, tab.IdleAnim or nil, tab.Immune, tab.Ally, tab.Optional )
		else
			AddEnemy( LocalPlayer():GetPos(), Angle( 0 ,math.ceil( img_rot:GetValue() ) ,0 ), tab.SelectedChar, tab.OverrideWeapon, tab.Behaviour, tab.IdleAnim or nil, tab.Immune, tab.Ally, tab.Optional )
		end
	end	
	
	local rm_b = tab:Add( "DButton" )
	rm_b:SetTall( 42 )
	rm_b:SetText( "Remove Nearby Nextbot" )
	rm_b:Dock( TOP )
	rm_b.DoClick = function( self )
		RemoveNearbyEnemy()
	end	
	
	local rma_b = tab:Add( "DButton" )
	rma_b:SetTall( 42 )
	rma_b:SetText( "Remove ALL Nextbots" )
	rma_b:Dock( BOTTOM )
	rma_b.DoClick = function( self )
		RemoveAllEnemies()
	end	
	
	p:AddSheet( "Nextbots", tab, "icon16/bug.png" )

end

function AddWeaponsTab( p )
	
	EDITOR.Pickups = EDITOR.Pickups or {}
	
	local tab = p:Add( "EditablePanel" )
				
	local weapon_types = tab:Add( "DPropertySheet" )
	weapon_types:SetSize( p:GetWide(), 2*p:GetTall()/3 )
	weapon_types:Dock( TOP )
	
	timer.Simple( 1, function()
	for cat, tbl in pairs( EditorWeapons ) do
		local scroll = weapon_types:Add( "DScrollPanel" )
		scroll:Dock( FILL )
		local cat_panel = scroll:Add( "DIconLayout" )
		cat_panel:SetSpaceX( 3 )
		cat_panel:SetSpaceY( 3 )
		cat_panel:Dock( FILL )
		
		for _, wep_class in pairs( tbl ) do
			local swep = weapons.Get( wep_class ) 
			if swep then
				if swep.Akimbo then continue end
				if string.find( swep.ClassName, "fists" ) then continue end
				if string.find( swep.ClassName, "dog" ) then continue end
				
				if swep.PrintName == "Melee" then
					swep.PrintName = string.sub( swep.ClassName, 6 )
				end
				
				local wp = cat_panel:Add( "SpawnIcon" )
				wp:SetSize( p:GetWide()/4.5, p:GetWide()/4.5 )
				wp:InvalidateLayout( true )
				wp:SetModel( swep.DroppedModel or swep.WorldModel )
				wp.PaintOver = function( self, sw, sh )
					self:DrawSelections()
					if self.Hovered or tab.SelectedWep == wep_class then

					else
						surface.SetDrawColor( 55, 55, 55, 175 )
						surface.DrawRect( 0, 0, sw, sh )
					end
					draw.SimpleTextOutlined( swep.PrintName or "untitled", "Default", sw/2, sh*0.8, tab.SelectedWep == wep_class and Color( 250, 250, 250, 255) or Color( 150, 150, 150, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
				end
				wp.DoClick = function( self )
					tab.SelectedWep = wep_class
				end				
			end
		end
		weapon_types:AddSheet( cat, scroll )
	end
	
	//weapon_types:InvalidateLayout() 
	end)
	
	local spawn_b = tab:Add( "DButton" )
	spawn_b:SetTall( 42 )
	spawn_b:SetText( "Add Selected Weapon" )
	spawn_b:Dock( TOP )
	spawn_b.DoClick = function( self )
		if tab.SelectedWep then
			AddWeapon( LocalPlayer():GetPos(), tab.SelectedWep )
		end
	end	
	
	local rm_b = tab:Add( "DButton" )
	rm_b:SetTall( 42 )
	rm_b:SetText( "Remove Nearby Weapon" )
	rm_b:Dock( TOP )
	rm_b.DoClick = function( self )
		RemoveNearbyWeapon()
	end	
	
	local rma_b = tab:Add( "DButton" )
	rma_b:SetTall( 42 )
	rma_b:SetText( "Remove ALL Weapons" )
	rma_b:Dock( BOTTOM )
	rma_b.DoClick = function( self )
		RemoveAllWeapons()
	end	
	
	p:AddSheet( "Weapons", tab, "icon16/cut.png" )

end

local function BehaviourEditForm( apply_func )
	
	local form = vgui.Create("DFrame")
	form:SetSize(300,80)
	form:Center()
	form:SetTitle( "Select new behaviour" )
	form:ShowCloseButton(false)
	form:MakePopup()
	
	local entry = form:Add("DTextEntry")
	entry:SetPos(2,24)
	entry:SetSize(form:GetWide()-4, 23)
	entry:SetText( def_text or "No text" )
	
	local entry = form:Add( "DComboBox" )
	entry:SetPos(2,24)
	entry:SetSize( form:GetWide()-4, 23 )
	entry:AddChoice( "Do nothing at all", -1, true )
	entry:AddChoice( "Defaut ( walk around )", 0, false )
	entry:AddChoice( "Idle", 1, false )
	entry:AddChoice( "Patrolling", 2, false )
	entry:AddChoice( "Random", 3, false )
	entry:AddChoice( "Follow nearby nextbot", 4, false )
	
	local conf = form:Add("DButton")
	conf:SetText("Confirm")
	conf:SetSize( form:GetWide()/2-4, 30 )
	conf:SetPos( 2, form:GetTall() - 32)
	conf.DoClick = function(self)
		local desc, beh_ind = entry:GetSelected()
		if beh_ind then
			apply_func( beh_ind )
			form:Remove()
		end
	end
	
	local cancel = form:Add("DButton")
	cancel:SetText("Cancel")
	cancel:SetSize( form:GetWide()/2-4, 30 )
	cancel:SetPos( form:GetWide()/2+2, form:GetTall() - 32)
	cancel.DoClick = function(self)
		form:Remove()
	end
	

end

local function MusicTimeForm( apply_func )
	
	local form = vgui.Create("DFrame")
	form:SetSize( 300, 80 )
	form:Center()
	form:SetTitle( "Edit music boundaries" )
	form:ShowCloseButton(false)
	form:MakePopup()
	
	local entry1 = form:Add("DTextEntry")
	entry1:SetPos(2,24)
	entry1:SetSize(form:GetWide()/2-4, 23)
	entry1:SetText( "" )
	
	local entry2 = form:Add("DTextEntry")
	entry2:SetPos(form:GetWide()/2+2,24)
	entry2:SetSize(form:GetWide()/2-4, 23)
	entry2:SetText( "" )
	
	local conf = form:Add("DButton")
	conf:SetText("Confirm")
	conf:SetSize( form:GetWide()/2-4, 30 )
	conf:SetPos( 2, form:GetTall() - 32)
	conf.DoClick = function(self)
		local tbl = { start = nil, endpos = nil }
		local empty = true
		if entry1:GetValue() ~= "" then
			tbl.start = tonumber( entry1:GetValue() )
			empty = false
		end
		if entry2:GetValue() ~= "" then
			tbl.endpos = tonumber( entry2:GetValue() )
			empty = false
		end
		if not empty then
			apply_func( tbl )
			form:Remove()
		end
	end
	
	local cancel = form:Add("DButton")
	cancel:SetText("Cancel")
	cancel:SetSize( form:GetWide()/2-4, 30 )
	cancel:SetPos( form:GetWide()/2+2, form:GetTall() - 32)
	cancel.DoClick = function(self)
		form:Remove()
	end
	

end

local function EntInputForm( apply_func )
	
	local form = vgui.Create("DFrame")
	form:SetSize( 300, 80 )
	form:Center()
	form:SetTitle( "Enter entity map index and input name" )
	form:ShowCloseButton(false)
	form:MakePopup()
	
	local entry1 = form:Add("DTextEntry")
	entry1:SetPos(2,24)
	entry1:SetSize(form:GetWide()/2-4, 23)
	entry1:SetText( "" )
	
	local entry2 = form:Add("DTextEntry")
	entry2:SetPos(form:GetWide()/2+2,24)
	entry2:SetSize(form:GetWide()/2-4, 23)
	entry2:SetText( "" )
	
	local conf = form:Add("DButton")
	conf:SetText("Confirm")
	conf:SetSize( form:GetWide()/2-4, 30 )
	conf:SetPos( 2, form:GetTall() - 32)
	conf.DoClick = function(self)
		local tbl = { index = nil, input_name = nil }
		local empty = true
		if entry1:GetValue() ~= "" then
			tbl.index = tonumber( entry1:GetValue() )
			empty = false
		end
		if entry2:GetValue() ~= "" then
			tbl.input_name = tostring( entry2:GetValue() )
			empty = false
		end
		if not empty then
			apply_func( tbl )
			form:Remove()
		end
	end
	
	local cancel = form:Add("DButton")
	cancel:SetText("Cancel")
	cancel:SetSize( form:GetWide()/2-4, 30 )
	cancel:SetPos( form:GetWide()/2+2, form:GetTall() - 32)
	cancel.DoClick = function(self)
		form:Remove()
	end
	

end

function AddTriggerTab( p )
	
	EDITOR.Triggers = EDITOR.Triggers or {}
	
	//local scroll = p:Add( "DScrollPanel" )
	//scroll:Dock( FILL )
	
	local tab = p:Add( "EditablePanel" )
	
	tab.ActivateOnce = false
	
	local scroll = tab:Add( "DScrollPanel" )
	//scroll:Dock( FILL )
	scroll:SetSize( p:GetWide(), p:GetTall()*0.95 )
	
	//objects and stuff	
	local trigger_p = scroll:Add( "DPanel" )
	trigger_p:SetSize( p:GetWide(), p:GetTall()/2 )
	trigger_p:Dock( TOP )
	
	//trigger buttons
	local tr_p = trigger_p:Add( "DPanel" )
	tr_p:SetSize( p:GetWide()/2, p:GetTall()/2 )
	tr_p:Dock( LEFT )
	
	QuickLabel( tr_p, "-- Object Triggers" )
	
	local tr_create = tr_p:Add( "DButton" )
	tr_create:SetTall( 22 )
	tr_create:SetText( "Create object on trigger" )
	tr_create:SetToolTip( "Will create selected enemy/weapon/trigger, when triggered." )
	tr_create:Dock( TOP )
	
	local tr_arrow = tr_p:Add( "DButton" )
	tr_arrow:SetTall( 22 )
	tr_arrow:SetText( "Create arrow on trigger" )
	tr_arrow:Dock( TOP )
	
	local tr_dial = tr_p:Add( "DButton" )
	tr_dial:SetTall( 22 )
	tr_dial:SetText( "Activate dialogue on trigger" )
	tr_dial:SetToolTip( "Will activate selected dialogue on trigger. Always works once." )
	tr_dial:Dock( TOP )
	
	local tr_link = tr_p:Add( "DButton" )
	tr_link:SetTall( 22 )
	tr_link:SetText( "Activate trigger on trigger" )
	tr_link:SetToolTip( "Useful if you have 2 entrances and stuff, leading to a single trigger." )
	tr_link:Dock( TOP )
	
	local tr_shut = tr_p:Add( "DButton" )
	tr_shut:SetTall( 22 )
	tr_shut:SetText( "Turn off trigger on trigger" )
	tr_shut:SetToolTip( "Use this to prevent SELECTED triggers from being activated." )
	tr_shut:Dock( TOP )
	
	local tr_rmvimm = tr_p:Add( "DButton" )
	tr_rmvimm:SetTall( 22 )
	tr_rmvimm:SetText( "Remove invincibility from nextbot" )
	tr_rmvimm:SetToolTip( "Removes incvincibility from SELECTED NEXTBOTS when triggered." )
	tr_rmvimm:Dock( TOP )
	
	local tr_rmvopt = tr_p:Add( "DButton" )
	tr_rmvopt:SetTall( 22 )
	tr_rmvopt:SetText( "Remove optional tag from nextbot" )
	tr_rmvopt:SetToolTip( "Removes optional tag from SELECTED NEXTBOTS when triggered." )
	tr_rmvopt:Dock( TOP )
	
	local tr_setbeh = tr_p:Add( "DButton" )
	tr_setbeh:SetTall( 22 )
	tr_setbeh:SetText( "Permamently change nextbot's behaviour" )
	tr_setbeh:SetToolTip( "Set behaviour for SELECTED NEXTBOTS when triggered." )
	tr_setbeh:Dock( TOP )
	
	local tr_actstage = tr_p:Add( "DButton" )
	tr_actstage:SetTall( 22 )
	tr_actstage:SetText( "Activate stage" )
	tr_actstage:SetToolTip( "Activates SELECTED STAGE when triggered." )
	tr_actstage:Dock( TOP )
	
	local obj_types = trigger_p:Add( "DPropertySheet" )
	obj_types:SetSize( p:GetWide()/2, p:GetTall()/2 )
	obj_types:Dock( FILL )
	
	local types = { "Enemies", "Pickups", "Triggers", "Dialogues" }
	obj_types.Lists = {}
	
	local function FillLines( list_, tbl_ )
		
		if not tbl_ then return end
		
		for id, obj_tbl in pairs( tbl_ ) do
			
			local links
			
			if obj_tbl.CheckTriggers then
				links = ""
				for k, v in pairs( obj_tbl.CheckTriggers ) do
					links = links.." "..v
				end
			end
			
			local id_txt = id
			local event = false
			
			/*if obj_tbl.action and obj_tbl.action == "event" then
				id_txt = "event "..id
				event = true
			end*/
			
			if obj_tbl.action then
				//id_txt = "["..obj_tbl.action.."] "..id
				if obj_tbl.action == "event" then
					event = true
				end
			end
			
			local tp = ""
			
			if obj_tbl.action then
				tp = obj_tbl.action
			end
			
			if obj_tbl.wep then
				tp = obj_tbl.wep
			end
			
			if obj_tbl.char then
				tp = obj_tbl.char
			end
			
			local line = list_:AddLine( id_txt, tp, links )
			line.OnRightClick = function( self )
				self:SetSelected( false )
			end
			//we dont want to link to events
			if event then
				line.OnSelect = function( self )
					self:SetSelected( false )
				end
			end
								
		end
	end
		
	for i=1, #types do
		
		local tbl = EDITOR[ types[i] ]
		
		if tbl then
			local obj_list = obj_types:Add( "DListView" )
			obj_list:SetMultiSelect( i ~= 4 )
			obj_list:AddColumn( "Obj ID" )
			obj_list:AddColumn( "Type" )
			obj_list:AddColumn( "Links" )
			obj_list:Dock( FILL )
			obj_list.Editor_ID = types[i]
		
			FillLines( obj_list, EDITOR[ obj_list.Editor_ID ] )
					
			table.insert( obj_types.Lists, obj_list )
			obj_types:AddSheet( types[i], obj_list )
						
		end
	end
	
	//stages
	local stage_list = obj_types:Add( "DListView" )
	stage_list:SetMultiSelect( false )
	stage_list:AddColumn( "Stage number" )
	stage_list:Dock( FILL )
	
	for i = 1, 4 do
		local line = stage_list:AddLine( i )
		line.OnRightClick = function( self )
			self:SetSelected( false )
		end
	end
	
							
	table.insert( obj_types.Lists, stage_list )
	obj_types:AddSheet( "Stages", stage_list )
	
	
	//update all at once instead of active tabs
	obj_types.Think = function( self )
		if CONTENTS_CHANGED then
			for i=1, 4 do
				local v = self.Lists[ i ]
				if v and v:IsValid() then
					v:Clear()
					FillLines( v, EDITOR[ v.Editor_ID ] )
				end
			end
			/*for k, v in pairs( self.Lists ) do
				if v and v:IsValid() then
					v:Clear()
					FillLines( v, EDITOR[ v.Editor_ID ] )
				end
			end*/
		end
		CONTENTS_CHANGED = false
	end
	
	QuickLabel( tr_p, "-- Game Events" )
	
	local botskilled_b = tr_p:Add( "DButton" )
	botskilled_b:SetTall( 22 )
	botskilled_b:SetText( "<All enemies killed> (Triggers only)" )
	botskilled_b:SetToolTip( "Will activate SELECTED TRIGGERS, once all enemies are dead." )
	botskilled_b:Dock( TOP )
	
	local wepremoved_b = tr_p:Add( "DButton" )
	wepremoved_b:SetTall( 22 )
	wepremoved_b:SetText( "<Weapon was removed> (Pickups/Triggers)" )
	wepremoved_b:SetToolTip( "Will activate SELECTED TRIGGERS, once SELECTED WEAPON is picked up." )
	wepremoved_b:Dock( TOP )
	
	local onlvl_b = tr_p:Add( "DButton" )
	onlvl_b:SetTall( 22 )
	onlvl_b:SetText( "<On \"Level Clear\"> (Triggers only)" )
	onlvl_b:SetToolTip( "Will activate SELECTED TRIGGERS, once level is in 'Level Clear' state." )
	onlvl_b:Dock( TOP )
	
	local ondst_b = tr_p:Add( "DButton" )
	ondst_b:SetTall( 22 )
	ondst_b:SetText( "<On Dialogue Start> (Triggers only)" )
	ondst_b:SetToolTip( "Will activate SELECTED TRIGGERS, once SELECTED DIALOGUE is active." )
	ondst_b:Dock( TOP )
	
	local ondf_b = tr_p:Add( "DButton" )
	ondf_b:SetTall( 22 )
	ondf_b:SetText( "<On Dialogue Finish> (Triggers only)" )
	ondf_b:SetToolTip( "Will activate SELECTED TRIGGERS, once SELECTED DIALOGUE is finished." )
	ondf_b:Dock( TOP )
	
	local onspwn_b = tr_p:Add( "DButton" )
	onspwn_b:SetTall( 22 )
	onspwn_b:SetText( "<On Level Loaded> (Triggers only)" )
	onspwn_b:Dock( TOP )
	
	local ondth_b = tr_p:Add( "DButton" )
	ondth_b:SetTall( 22 )
	ondth_b:SetText( "<On Player Death> (Triggers only)" )
	ondth_b:Dock( TOP )

	local onknd_b = tr_p:Add( "DButton" )
	onknd_b:SetTall( 22 )
	onknd_b:SetText( "<On Nextbot Knocked> (Triggers only)" )
	onknd_b:SetToolTip( "Will activate SELECTED TRIGGERS, once SELECTED NEXTBOT is knocked down." )
	onknd_b:Dock( TOP )	
	
	local onstage_s = tr_p:Add( "DButton" )
	onstage_s:SetTall( 22 )
	onstage_s:SetText( "<On Stage Start> (Triggers only)" )
	onstage_s:SetToolTip( "Will activate SELECTED TRIGGERS, once SELECTED STAGE is started." )
	onstage_s:Dock( TOP )	
	
	QuickLabel( scroll, "-- Level Triggers" )
	
	local nxt_b = scroll:Add( "DButton" )
	nxt_b:SetTall( 22 )
	nxt_b:SetText( "Add nextlevel trigger" )
	nxt_b:Dock( TOP )
	
	local lvl_b = scroll:Add( "DButton" )
	lvl_b:SetTall( 22 )
	lvl_b:SetText( "Add \"Level Clear\" trigger" )
	lvl_b:Dock( TOP )
	
	local spwn_b = scroll:Add( "DButton" )
	spwn_b:SetTall( 22 )
	spwn_b:SetText( "Create new spawnpoint on trigger" )
	spwn_b:Dock( TOP )

	QuickLabel( scroll, "-- Miscellaneous Triggers" )
	
	local hd_b = scroll:Add( "DButton" )
	hd_b:SetTall( 22 )
	hd_b:SetText( "Add HUD Message" )
	hd_b:Dock( TOP )
	
	local amb_b = scroll:Add( "DButton" )
	amb_b:SetTall( 22 )
	amb_b:SetText( "Stop ambient and play level track" )
	amb_b:SetToolTip( "This trigger will be activated only ONCE" )
	amb_b:Dock( TOP )
	
	local time_b = scroll:Add( "DButton" )
	time_b:SetTall( 22 )
	time_b:SetText( "Change music start and end time" )
	time_b:Dock( TOP )
	
	local inp_b = scroll:Add( "DButton" )
	inp_b:SetTall( 22 )
	inp_b:SetText( "Activate entity input" )
	inp_b:Dock( TOP )
	
	local rmar_b = scroll:Add( "DButton" )
	rmar_b:SetTall( 22 )
	rmar_b:SetText( "Remove ALL arrows" )
	rmar_b:Dock( TOP )
	
	local light_b = scroll:Add( "DButton" )
	light_b:SetTall( 22 )
	light_b:SetText( "Change map lighting" )
	light_b:Dock( TOP )
	
	QuickLabel( scroll, "-- Enemy AI Triggers" )
	
	local dis_b = scroll:Add( "DButton" )
	dis_b:SetTall( 22 )
	dis_b:SetText( "\"Pause\" AI for all enemies" )
	dis_b:Dock( TOP )
	
	local en_b = scroll:Add( "DButton" )
	en_b:SetTall( 22 )
	en_b:SetText( "\"Unpause\" AI for all enemies" )
	en_b:Dock( TOP )
	
	local tr_sz = scroll:Add( "DNumSlider" )
	tr_sz:SetText( "Trigger Area Size" )
	tr_sz:SetTall( 22 )
	tr_sz:SetDecimals( 0 )
	tr_sz:SetMin( 10 )	
	tr_sz:SetMax( 700 )
	tr_sz:SetValue( 60 )
	tr_sz:SetDark( true )
	tr_sz:Dock( TOP )
	
	local once_c = scroll:Add( "DCheckBoxLabel" )
	once_c:SetText( "Trigger will only activate once" )
	once_c:SetTall( 20 )
	once_c:SetDark( true )
	once_c:SetValue( false )
	once_c:Dock( TOP )
	once_c.OnChange = function( self, bVal )
		tab.ActivateOnce = bVal
	end
	
	//DoClicks are here
	
	tr_create.DoClick = function( self )
		local obj_tbl = {}
		for k, v in pairs( obj_types.Lists ) do
			if v and v:IsValid() and k ~= 5 then
				for _, line in pairs( v:GetSelected() ) do
					if line then
						table.insert( obj_tbl, line:GetValue( 1 ) )
					end
				end
			end
		end
		if #obj_tbl > 0 then
			AddTrigger( LocalPlayer():GetPos(), math.ceil( tr_sz:GetValue() ), "spawn", obj_tbl, nil, nil, tab.ActivateOnce )
		end
	end
	
	tr_arrow.DoClick = function( self )
		local obj_tbl = {}
		if obj_types.Lists[1] then
			for _, line in pairs( obj_types.Lists[1]:GetSelected() ) do
				if line then
					table.insert( obj_tbl, line:GetValue( 1 ) )
				end
			end
		end
		if obj_types.Lists[2] then
			for _, line in pairs( obj_types.Lists[2]:GetSelected() ) do
				if line then
					table.insert( obj_tbl, line:GetValue( 1 ) )
				end
			end
		end
		if #obj_tbl > 0 then
			AddTrigger( LocalPlayer():GetPos(), math.ceil( tr_sz:GetValue() ), "arrow", obj_tbl, nil, nil, tab.ActivateOnce )
		end
	end
	
	tr_dial.DoClick = function( self )
		local obj_tbl = {}
		if obj_types.Lists[4] then
			for _, line in pairs( obj_types.Lists[4]:GetSelected() ) do
				if line then
					table.insert( obj_tbl, line:GetValue( 1 ) )
				end
			end
		end
		if #obj_tbl > 0 then
			AddTrigger( LocalPlayer():GetPos(), math.ceil( tr_sz:GetValue() ), "dialogue", obj_tbl )
		end
	end
	
	tr_link.DoClick = function( self )
		local obj_tbl = {}
		if obj_types.Lists[3] then
			for _, line in pairs( obj_types.Lists[3]:GetSelected() ) do
				if line then
					table.insert( obj_tbl, line:GetValue( 1 ) )
				end
			end
		end
		if #obj_tbl > 0 then
			AddTrigger( LocalPlayer():GetPos(), math.ceil( tr_sz:GetValue() ), "linker", obj_tbl )
		end
	end
	
	tr_shut.DoClick = function( self )
		local obj_tbl = {}
		if obj_types.Lists[3] then
			for _, line in pairs( obj_types.Lists[3]:GetSelected() ) do
				if line then
					table.insert( obj_tbl, line:GetValue( 1 ) )
				end
			end
		end
		if #obj_tbl > 0 then
			AddTrigger( LocalPlayer():GetPos(), math.ceil( tr_sz:GetValue() ), "disarm", obj_tbl )
		end
	end
	
	tr_rmvimm.DoClick = function( self )
		local obj_tbl = {}
		if obj_types.Lists[1] then
			for _, line in pairs( obj_types.Lists[1]:GetSelected() ) do
				if line then
					table.insert( obj_tbl, line:GetValue( 1 ) )
				end
			end
		end
		if #obj_tbl > 0 then
			AddTrigger( LocalPlayer():GetPos(), math.ceil( tr_sz:GetValue() ), "remove_immune", obj_tbl, nil, nil, tab.ActivateOnce )
		end
	end
	
	tr_rmvopt.DoClick = function( self )
		local obj_tbl = {}
		if obj_types.Lists[1] then
			for _, line in pairs( obj_types.Lists[1]:GetSelected() ) do
				if line then
					table.insert( obj_tbl, line:GetValue( 1 ) )
				end
			end
		end
		if #obj_tbl > 0 then
			AddTrigger( LocalPlayer():GetPos(), math.ceil( tr_sz:GetValue() ), "remove_optional", obj_tbl, nil, nil, tab.ActivateOnce )
		end
	end
	
	
	
	tr_setbeh.DoClick = function( self )
		local obj_tbl = {}
		if obj_types.Lists[1] then
			for _, line in pairs( obj_types.Lists[1]:GetSelected() ) do
				if line then
					table.insert( obj_tbl, line:GetValue( 1 ) )
				end
			end
		end
		
		local function beh_form( beh )
			AddTrigger( LocalPlayer():GetPos(), math.ceil( tr_sz:GetValue() ), "set_behaviour", obj_tbl, nil, beh, tab.ActivateOnce )
		end
		
		if #obj_tbl > 0 then
			BehaviourEditForm( beh_form )
		end
	end
	
	tr_actstage.DoClick = function( self )
		//local obj_tbl = {}
		local num 
		if obj_types.Lists[5] then
			for _, line in pairs( obj_types.Lists[5]:GetSelected() ) do
				if line then
					num = line:GetValue( 1 )
					break
					//table.insert( obj_tbl, line:GetValue( 1 ) )
				end
			end
		end
		if num > 0 then
			//AddTrigger( LocalPlayer():GetPos(), math.ceil( tr_sz:GetValue() ), "activate_stage", obj_tbl )
			AddTrigger( LocalPlayer():GetPos(), math.ceil( tr_sz:GetValue() ), "activate_stage", nil, nil, num, tab.ActivateOnce )
		end
	end
	
	botskilled_b.DoClick = function( self )
		local obj_tbl = {}
		if obj_types.Lists[3] then
			for _, line in pairs( obj_types.Lists[3]:GetSelected() ) do
				if line then
					table.insert( obj_tbl, line:GetValue( 1 ) )
				end
			end
		end
		if #obj_tbl > 0 then
			AddTrigger( LocalPlayer():GetPos(), math.ceil( tr_sz:GetValue() ), "event", obj_tbl, "OnAllEnemiesKilled")
		end
	end
	
	wepremoved_b.DoClick = function( self )
		local data = {}
		local obj_tbl = {}
		if obj_types.Lists[2] then
			for _, line in pairs( obj_types.Lists[2]:GetSelected() ) do
				if line then
					table.insert( data, line:GetValue( 1 ) )
				end
			end
		end
		if obj_types.Lists[3] then
			for _, line in pairs( obj_types.Lists[3]:GetSelected() ) do
				if line then
					table.insert( obj_tbl, line:GetValue( 1 ) )
				end
			end
		end
		if #obj_tbl > 0 then
			AddTrigger( LocalPlayer():GetPos(), math.ceil( tr_sz:GetValue() ), "event", obj_tbl, "OnWeaponRemoved", data )
		end
	end
	
	onknd_b.DoClick = function( self )
		local data = {}
		local obj_tbl = {}
		if obj_types.Lists[1] then
			for _, line in pairs( obj_types.Lists[1]:GetSelected() ) do
				if line then
					table.insert( data, line:GetValue( 1 ) )
				end
			end
		end
		if obj_types.Lists[3] then
			for _, line in pairs( obj_types.Lists[3]:GetSelected() ) do
				if line then
					table.insert( obj_tbl, line:GetValue( 1 ) )
				end
			end
		end
		if #obj_tbl > 0 then
			AddTrigger( LocalPlayer():GetPos(), math.ceil( tr_sz:GetValue() ), "event", obj_tbl, "OnNextBotKnockdown", data )
		end
	end
	
	onlvl_b.DoClick = function( self )
		local obj_tbl = {}
		if obj_types.Lists[3] then
			for _, line in pairs( obj_types.Lists[3]:GetSelected() ) do
				if line then
					table.insert( obj_tbl, line:GetValue( 1 ) )
				end
			end
		end
		if #obj_tbl > 0 then
			AddTrigger( LocalPlayer():GetPos(), math.ceil( tr_sz:GetValue() ), "event", obj_tbl, "OnLevelClear" )
		end
	end
	
	onspwn_b.DoClick = function( self )
		local obj_tbl = {}
		if obj_types.Lists[3] then
			for _, line in pairs( obj_types.Lists[3]:GetSelected() ) do
				if line then
					table.insert( obj_tbl, line:GetValue( 1 ) )
				end
			end
		end
		if #obj_tbl > 0 then
			AddTrigger( LocalPlayer():GetPos(), math.ceil( tr_sz:GetValue() ), "event", obj_tbl, "OnLevelLoaded" )
		end
	end
	
	ondth_b.DoClick = function( self )
		local obj_tbl = {}
		if obj_types.Lists[3] then
			for _, line in pairs( obj_types.Lists[3]:GetSelected() ) do
				if line then
					table.insert( obj_tbl, line:GetValue( 1 ) )
				end
			end
		end
		if #obj_tbl > 0 then
			AddTrigger( LocalPlayer():GetPos(), math.ceil( tr_sz:GetValue() ), "event", obj_tbl, "OnPlayerDeath" )
		end
	end
	
	ondst_b.DoClick = function( self )
		local data = {}
		local obj_tbl = {}
		if obj_types.Lists[4] then
			for _, line in pairs( obj_types.Lists[4]:GetSelected() ) do
				if line then
					table.insert( data, line:GetValue( 1 ) )
				end
			end
		end
		if obj_types.Lists[3] then
			for _, line in pairs( obj_types.Lists[3]:GetSelected() ) do
				if line then
					table.insert( obj_tbl, line:GetValue( 1 ) )
				end
			end
		end
		if #obj_tbl > 0 then
			AddTrigger( LocalPlayer():GetPos(), math.ceil( tr_sz:GetValue() ), "event", obj_tbl, "OnDialogueStarted", data )
		end
	end
	
	ondf_b.DoClick = function( self )
		local data = {}
		local obj_tbl = {}
		if obj_types.Lists[4] then
			for _, line in pairs( obj_types.Lists[4]:GetSelected() ) do
				if line then
					table.insert( data, line:GetValue( 1 ) )
				end
			end
		end
		if obj_types.Lists[3] then
			for _, line in pairs( obj_types.Lists[3]:GetSelected() ) do
				if line then
					table.insert( obj_tbl, line:GetValue( 1 ) )
				end
			end
		end
		if #obj_tbl > 0 then
			AddTrigger( LocalPlayer():GetPos(), math.ceil( tr_sz:GetValue() ), "event", obj_tbl, "OnDialogueFinished", data )
		end
	end
	
	onstage_s.DoClick = function( self )
		local data
		local obj_tbl = {}
		if obj_types.Lists[5] then
			for _, line in pairs( obj_types.Lists[5]:GetSelected() ) do
				if line then
					data = line:GetValue( 1 )
					break
				end
			end
		end
		if obj_types.Lists[3] then
			for _, line in pairs( obj_types.Lists[3]:GetSelected() ) do
				if line then
					table.insert( obj_tbl, line:GetValue( 1 ) )
				end
			end
		end
		if #obj_tbl > 0 then
			AddTrigger( LocalPlayer():GetPos(), math.ceil( tr_sz:GetValue() ), "event", obj_tbl, "OnStageStart", data )
		end
	end
	
	nxt_b.DoClick = function( self )
		AddTrigger( LocalPlayer():GetPos(), math.ceil( tr_sz:GetValue() ), "nextlevel", nil, nil, nil, tab.ActivateOnce )
	end	
	
	lvl_b.DoClick = function( self )
		AddTrigger( LocalPlayer():GetPos(), math.ceil( tr_sz:GetValue() ), "levelclear", nil, nil, nil, tab.ActivateOnce )
	end	
	
	spwn_b.DoClick = function( self )
		AddTrigger( LocalPlayer():GetPos(), math.ceil( tr_sz:GetValue() ), "newspawnpoint", nil, nil, nil, tab.ActivateOnce )
	end	
	
	local function hd_msg( txt )
		AddTrigger( LocalPlayer():GetPos(), math.ceil( tr_sz:GetValue() ), "hudmessage", nil, nil, txt, tab.ActivateOnce )
	end
	
	hd_b.DoClick = function( self )
		TextEditForm( "Add HUD Message", "Leave Area", hd_msg )
	end
	
	local function light_msg( txt )
		AddTrigger( LocalPlayer():GetPos(), math.ceil( tr_sz:GetValue() ), "engine_lighting", nil, nil, txt, tab.ActivateOnce )
	end
	
	light_b.DoClick = function( self )
		TextEditForm( "Change engine lighting style", "", light_msg )
	end
	
	local function time_form( time_data )
		AddTrigger( LocalPlayer():GetPos(), math.ceil( tr_sz:GetValue() ), "music_time", nil, nil, time_data, tab.ActivateOnce )
	end
	
	time_b.DoClick = function( self )
		MusicTimeForm( time_form )
	end
	
	local function inp_form( inp_data )
		AddTrigger( LocalPlayer():GetPos(), math.ceil( tr_sz:GetValue() ), "ent_input", nil, nil, inp_data, tab.ActivateOnce )
	end
	
	inp_b.DoClick = function( self )
		EntInputForm( inp_form )
	end
	
	amb_b.DoClick = function( self )
		AddTrigger( LocalPlayer():GetPos(), math.ceil( tr_sz:GetValue() ), "playmusic", nil, nil, nil, true ) //activate once all the time
	end	
	
	rmar_b.DoClick = function( self )
		AddTrigger( LocalPlayer():GetPos(), math.ceil( tr_sz:GetValue() ), "removearrows", nil, nil, nil, tab.ActivateOnce )
	end	
	
	dis_b.DoClick = function( self )
		AddTrigger( LocalPlayer():GetPos(), math.ceil( tr_sz:GetValue() ), "pauseenemies", nil, nil, "true", tab.ActivateOnce )
	end
	
	en_b.DoClick = function( self )
		AddTrigger( LocalPlayer():GetPos(), math.ceil( tr_sz:GetValue() ), "pauseenemies", nil, nil, "false", tab.ActivateOnce )
	end
	
	local rm_b = scroll:Add( "DButton" )
	rm_b:SetTall( 32 )
	rm_b:SetText( "Remove Nearby Trigger" )
	rm_b:Dock( TOP )
	rm_b.DoClick = function( self )
		RemoveNearbyTrigger()
	end	
	
	local rms_b = scroll:Add( "DButton" )
	rms_b:SetTall( 32 )
	rms_b:SetText( "Remove Selected Trigger(s)" )
	rms_b:Dock( TOP )
	rms_b.DoClick = function( self )
		for _, line in pairs( obj_types.Lists[3]:GetSelected() ) do
			if line then
				RemoveNearbyTrigger( line:GetValue( 1 ) )
			end
		end
	end
	
	local rma_b = scroll:Add( "DButton" )
	rma_b:SetTall( 42 )
	rma_b:SetText( "Remove ALL Triggers" )
	rma_b:Dock( TOP )
	rma_b.DoClick = function( self )
		RemoveAllTriggers()
	end
	
	local sheet = p:AddSheet( "Triggers", tab, "icon16/script_link.png" )
	if sheet.Tab then
		sheet.Tab.OldDoClick = sheet.Tab.DoClick
		function sheet.Tab:DoClick( ... )
			CONTENTS_CHANGED = true
			sheet.Tab:OldDoClick( ... )
		end
	end

end

function AddDialogueTab( p )
	
	EDITOR.Dialogues = EDITOR.Dialogues or {}
	
	local tab = p:Add( "EditablePanel" )
	
	local scroll = tab:Add( "DScrollPanel" )
	scroll:SetSize( p:GetWide(), p:GetTall()/3 )
	scroll:Dock( TOP )
	
	local d_parent = scroll:Add( "DPanel" )
	d_parent:SetSize( p:GetWide(), p:GetTall()/3 )
	d_parent:Dock( TOP )
	
	local function RefreshDialogues()
		if EDITOR.Dialogues then
			for key, tbl in pairs( EDITOR.Dialogues ) do
				
				local d_p = d_parent:Add( "DPanel" )
				d_p:SetTall( 22 )
				d_p:Dock( TOP )
				
				local del = d_p:Add( "DButton" )
				del:SetText( "X" )
				del:SetWide( 20 )
				del:Dock( RIGHT )
				del.DoClick = function( self )
					if EDITOR.Dialogues and EDITOR.Dialogues[ key ] then
						EDITOR.Dialogues[ key ] = nil
						CONTENTS_CHANGED = true
					end
				end
				
				local edit = d_p:Add( "DButton" )
				edit:SetText( "Edit dialogue "..key )
				edit:Dock( FILL )
				edit.DoClick = function( self )
					DialogueEditor( key )
				end	
				
			end
			d_parent:SizeToContents()
		end
	end
	
	d_parent.Think = function( self )
		if CONTENTS_CHANGED then
			for k, v in pairs( self:GetChildren() ) do
				if v and v:IsValid() then
					v:Remove()
				end
			end
			RefreshDialogues()
		end
		CONTENTS_CHANGED = false
	end
	
	local add_b = tab:Add( "DButton" )
	add_b:SetTall( 42 )
	add_b:SetText( "Add new dialogue" )
	add_b:Dock( TOP )
	add_b.DoClick = function( self )
		DialogueEditor()
	end	
				
	local sheet = p:AddSheet( "Dialogues", tab, "icon16/comments.png" )
	//hacky way to manually update contents as well
	if sheet.Tab then
		sheet.Tab.OldDoClick = sheet.Tab.DoClick
		function sheet.Tab:DoClick( ... )
			CONTENTS_CHANGED = true
			sheet.Tab:OldDoClick( ... )
		end
	end
	
end

function DialogueEditor( change )

	EDITOR.Dialogues = EDITOR.Dialogues or {}

	local cur_d = {}
	
	if change and EDITOR.Dialogues[ change ] then
		cur_d = table.Copy( EDITOR.Dialogues[ change ] )	
	end

	local Main = vgui.Create( "DFrame", GAMEMODE.CursorFix:GetWide() )
	Main:SetSize( GAMEMODE.CursorFix:GetWide()/2.5, GAMEMODE.CursorFix:GetTall()/1.9 )
	Main:Center()
	Main:SetDraggable( true )
	Main:SetTitle( change and "Editing dialogue: "..change or "New Dialogue" )
	Main:MakePopup()
	
	//enable scrolling
	local scroll = Main:Add( "DScrollPanel" )
	scroll:SetSize( Main:GetWide(), Main:GetTall() * 0.8 )
	scroll:Dock( TOP )
	
	local layout = scroll:Add( "DListLayout" )
	//layout:SetSize( Main:GetWide(), Main:GetTall() * 0.8 )
	layout:SetDrawBackground( false )
	layout:Dock( TOP )
	
	layout:MakeDroppable( "test" )
	
	local edit = Main:Add( "DPanel" )
	edit:SetTall( 30 )
	edit:Dock( BOTTOM )
	
	local function UpdateDialogue()
		
		for k, v in pairs(layout:GetChildren()) do
			if v and v:IsValid() then
				v:Remove()
			end
		end
		
		for _, line_tbl in pairs( cur_d ) do
			
			local line_p = layout:Add( "DPanel" )
			line_p:SetWide( layout:GetWide() )
			line_p.id = _
			line_p.savetable = line_tbl
			line_p:DockMargin( 1, 1, 1, 1 )
			
			local p_name = line_p:Add( "DLabel" )
			p_name:SetDark( true )
			p_name:SetText( line_tbl.person or "player" )
			p_name:SetWide( 100 )
			p_name:Dock( LEFT )
			
			local p_textlay = line_p:Add( "DListLayout" )
			p_textlay:MakeDroppable( "line".._ )
			p_textlay:Dock( FILL )
			
			local tall = 0
			
			for k, txt_line in pairs( line_tbl.text ) do
				
				local txt_p = p_textlay:Add( "DPanel" )
				txt_p:SetTall( 22 )
				txt_p.id = k
				txt_p.saveline = txt_line
				
				local del = txt_p:Add( "DButton" )
				del:SetText( "X" )
				del:SetWide( 20 )
				del:Dock( RIGHT )
				
				function del:DoClick()
					cur_d[_].text[k] = nil
					if #cur_d[_].text < 1 then
						cur_d[_] = nil
					end
					UpdateDialogue()
				end
				
				local drag = txt_p:Add( "DLabel" )
				//drag:SetDark( true )
				drag:SetText( "  Hold to drag" )
				drag:SetWide( 80 )
				drag:Dock( RIGHT )
				
				
				local txt_text = txt_p:Add( "DTextEntry" )
				txt_text:SetText( txt_line )
				txt_text:SetEditable( true )
				txt_text:SetWide( txt_p:GetWide() * 0.7 )
				txt_text:Dock( FILL )
				
				function txt_text:OnLoseFocus()
					cur_d[_].text[k] = self:GetValue()
					UpdateDialogue()
				end
				
				tall = tall + 22
				
			end
				
			line_p:SetTall( tall )
			
			function p_textlay:OnModified()
				for k, v in pairs(p_textlay:GetChildren()) do
					cur_d[_].text[k] = v.saveline
				end
				UpdateDialogue()
			end
			
		end
	end
	
	local function CheckChildren()
		print"--dialogue table"
		PrintTable(cur_d)	
	end
	
	local function SortDialogueLines()
		for k, v in pairs(layout:GetChildren()) do
			cur_d[ k ] = v.savetable
		end
		UpdateDialogue()
	end
	
	function layout:OnModified()
		SortDialogueLines()
		CheckChildren()
	end
	
	local pers = edit:Add( "DComboBox" )
	pers:SetWide( 100 )
	pers:Dock( LEFT )
	pers:AddChoice( "player", nil, true )
	
	if EDITOR.Enemies then
		for k, v in pairs( EDITOR.Enemies ) do
			pers:AddChoice( k )
		end
	end
	
	local add_line = edit:Add( "DButton" )
	add_line:SetText( "Add" )
	add_line:SetWide( 100 )
	add_line:Dock( RIGHT )
	
	
	local entry = edit:Add( "DTextEntry" )
	entry:SetEditable( true )
	entry:Dock( FILL )
	
	function add_line:DoClick()
		if entry:GetValue() ~= "" then
			
			local person, data = pers:GetSelected()
			
			local am = #cur_d
			
			//lselected guy is one who talked last, add a new line instead
			if cur_d[ am ] and cur_d[ am ].person == person then
				if cur_d[ am ].text then
					table.insert( cur_d[ am ].text, entry:GetValue() )
					entry:SetText( "" )
				end
			//no? then let the other guy speak
			else
				local fill = {}
				fill.person = person
				fill.text = {}
				
				table.insert( fill.text, entry:GetValue() )
				table.insert( cur_d, fill )
				entry:SetText( "" )
			end
			UpdateDialogue()
			entry:RequestFocus()
		end
	end
	
	entry.OnEnter = add_line.DoClick
	
	UpdateDialogue()
	CheckChildren()
	
	local save = Main:Add( "DButton" )
	save:SetPos( Main:GetWide() - 120, 0 )
	save:SetSize( 80, 22 )
	save:SetText( "Save Dialogue" )
	function save:DoClick()
		if #cur_d > 0 then
			if change then
				EDITOR.Dialogues[ change ] = table.Copy( cur_d )
			else
				local count = 0
	
				for k, v in pairs( EDITOR.Dialogues ) do
					count = count + 1
				end
				
				local key = "d"..(count + 1)
				
				for i=1, count do
					if not EDITOR.Dialogues["d"..i] then
						key = "d"..i
						break
					end
				end
				EDITOR.Dialogues[ key ] = table.Copy( cur_d )
			end
		end
		CONTENTS_CHANGED = true
		Main:Remove()
	end
	
end

function AddStagesTab( p )
		
	local tab = p:Add( "EditablePanel" )
	
	local stage_sheets = tab:Add( "DPropertySheet" )
	stage_sheets:SetSize( p:GetWide(), p:GetTall()/1.7 )
	stage_sheets:Dock( TOP )
	
	stage_sheets.Lists = {}
	stage_sheets.StageChecks = {}
	
	for i=1, 4 do
		local obj_list = stage_sheets:Add( "DListView" )
		obj_list:SetMultiSelect( false )
		obj_list:AddColumn( "Obj ID" )
		obj_list:AddColumn( "Type" )
		obj_list:AddColumn( "Category" )
		obj_list:Dock( FILL )
		
		stage_sheets:AddSheet( ""..i.."", obj_list )
		
		stage_sheets.Lists[ i ] = obj_list
	end
	
	local options = tab:Add( "DProperties" )
	options:SetTall( 220 )
	options:Dock( TOP )
	
	local pk1 = options:CreateRow( "Nextbots", "Add nextbot" )
	
	local pk2 = options:CreateRow( "Triggers and Events", "Add trigger/event" )
	
	for i = 1, 4 do
		stage_sheets.StageChecks[ i ] = options:CreateRow( "Stages", "Add to stage "..i )
		stage_sheets.StageChecks[ i ]:Setup( "Boolean" )
		stage_sheets.StageChecks[ i ]:SetValue( i == 1 )
		stage_sheets.StageChecks[ i ].Val = util.tobool( i == 1 )
		
		stage_sheets.StageChecks[ i ].DataChanged = function( self, val )
			self.Val = util.tobool( val )
		end
	end
	
	
	local function UpdateEnemies()
		
		pk1:Setup( "Combo", {} )
		
		if EDITOR.Enemies then
			for key, obj_tbl in pairs( EDITOR.Enemies ) do
				pk1:AddChoice( key, function()
					
					for i = 1, 4 do
						if stage_sheets.StageChecks[ i ] and stage_sheets.StageChecks[ i ].Val then
							EditObjectStage( key, "Enemies", i )
						end
					end
					
					CONTENTS_CHANGED = true
					
				end )
			end
		end
		
	end	
	
	local function UpdateTriggers()
		
		pk2:Setup( "Combo", {} )
		
		if EDITOR.Triggers then
			for key, obj_tbl in pairs( EDITOR.Triggers ) do
				pk2:AddChoice( key, function()
					
					for i = 1, 4 do
						if stage_sheets.StageChecks[ i ] and stage_sheets.StageChecks[ i ].Val then
							EditObjectStage( key, "Triggers", i )
						end
					end
					
					CONTENTS_CHANGED = true
					
				end )
			end
		end
		
	end	
	
	UpdateEnemies()
	UpdateTriggers()
	
	
	pk1.DataChanged = function( self, data )
		data()
	end	
	
	pk2.DataChanged = function( self, data )
		data()
	end	
	
	local categories = { "Enemies", "Triggers" }//, "Pickups", "Dialogues" }
	
	local function AddLine( num, object_id, category )
		
		if not EDITOR[ category ] then return end
		if not EDITOR[ category ][ object_id ] then return end
		
		local obj_tbl = EDITOR[ category ][ object_id ]
		
		local tp = ""
			
		if obj_tbl.action then
			tp = obj_tbl.action
		end
			
		if obj_tbl.wep then
			tp = obj_tbl.wep
		end
			
		if obj_tbl.char then
			tp = obj_tbl.char
		end
		
		
		local line = stage_sheets.Lists[ num ]:AddLine( object_id, tp, category )
		
		line.OnSelect = function( self )
			EditObjectStage( object_id, category, num, true )
			CONTENTS_CHANGED = true
		end
		
		line.OnRightClick = function( self )
			for i=1, 4 do
				EditObjectStage( object_id, category, i, true )
				CONTENTS_CHANGED = true
			end
		end
		
		
			//line.OnRightClick = function( self )
			//self:SetSelected( false )
		//end
		
	end
	
	local function UpdateStages()
		for i = 1, 4 do
			if stage_sheets.Lists[ i ] and stage_sheets.Lists[ i ]:IsValid() then
				
				local cur_list = stage_sheets.Lists[ i ]
				cur_list:Clear()
			
				for k, v in pairs( categories ) do
					if EDITOR[ v ] then
						for key, obj_tbl in pairs( EDITOR[ v ] ) do
							if obj_tbl.stages then
								if table.HasValue( obj_tbl.stages, i ) then
									AddLine( i, key, v )
								end
							end
						end
					end
				end
			end
		end	
	end
	
	UpdateStages()
	
	
	stage_sheets.Think = function( self )
		if CONTENTS_CHANGED then
			UpdateStages()
			UpdateEnemies()
			UpdateTriggers()
		end
		CONTENTS_CHANGED = false
	end
	
				
	local sheet = p:AddSheet( "Stages", tab, "icon16/sitemap_color.png" )
	//hacky way to manually update contents as well
	if sheet.Tab then
		sheet.Tab.OldDoClick = sheet.Tab.DoClick
		function sheet.Tab:DoClick( ... )
			CONTENTS_CHANGED = true
			sheet.Tab:OldDoClick( ... )
		end
	end
	
end
	

function RemoveObjectFromTrigger( key, tbl )

	if key and tbl and tbl.CheckTriggers then
		for k,v in pairs( tbl.CheckTriggers ) do
			if EDITOR.Triggers and EDITOR.Triggers[v] then
				local obj_tbl = EDITOR.Triggers[v].objects
				if obj_tbl then
					for _, obj_key in pairs( obj_tbl ) do
						if key == obj_key then
							EDITOR.Triggers[v].objects[ _ ] = nil
							break
						end
					end
					if #EDITOR.Triggers[v].objects < 1 then
						RemoveNearbyTrigger( v )
					end
				end
			end
		end
	end
	
end

function AddTrigger( pos_, size_, action_, obj_tbl, eventtype, data_, once_ )
	
	EDITOR.Triggers = EDITOR.Triggers or {}
	
	local count = 0
	
	for k, v in pairs( EDITOR.Triggers ) do
		count = count + 1
	end
	
	local key = "t"..(count + 1)
	
	for i=1, count do
		if not EDITOR.Triggers["t"..i] then
			key = "t"..i
			break
		end
	end
	
	EDITOR.Triggers[key] = { pos = pos_, size = size_, action = action_, objects = obj_tbl or nil, data = data_ or nil, event = eventtype or nil, trigger_once = once_ or nil }
	
	if obj_tbl then
		for k, v in pairs( obj_tbl ) do
			if EDITOR.Enemies and EDITOR.Enemies[ v ] then
				EDITOR.Enemies[ v ].CheckTriggers = EDITOR.Enemies[ v ].CheckTriggers or {}
				table.insert( EDITOR.Enemies[ v ].CheckTriggers, key )
			end
			if EDITOR.Pickups and EDITOR.Pickups[ v ] then
				EDITOR.Pickups[ v ].CheckTriggers = EDITOR.Pickups[ v ].CheckTriggers or {}
				table.insert( EDITOR.Pickups[ v ].CheckTriggers, key )
			end
			if EDITOR.Triggers and EDITOR.Triggers[ v ] then
				EDITOR.Triggers[ v ].CheckTriggers = EDITOR.Triggers[ v ].CheckTriggers or {}
				table.insert( EDITOR.Triggers[ v ].CheckTriggers, key )
			end
		end
	end
	
	for i=1, 4 do
		if ADD_OBJECT_TO_STAGE[ i ] then
			EditObjectStage( key, "Triggers", i )
		end
	end
	
	CONTENTS_CHANGED = true
end

function RemoveNearbyTrigger( override_key )

	EDITOR.Triggers = EDITOR.Triggers or {}
	
	local pos = LocalPlayer():GetPos()
	local key
	
	local max = 99999
	local cur_closest
	
	if override_key then
		key = override_key
	else
		for k, v in pairs( EDITOR.Triggers ) do
			if v.pos and v.pos:Distance(pos) <= max then
				max = v.pos:Distance(pos)
				cur_closest = k
			end
		end
		
		if cur_closest and EDITOR.Triggers[ cur_closest ] and EDITOR.Triggers[ cur_closest ].pos and EDITOR.Triggers[ cur_closest ].pos:Distance(pos) < 100 then
			key = cur_closest
		end
	end
	
	if key then
		local obj_tbl = EDITOR.Triggers[ key ].objects
		
		if obj_tbl then
			for k, v in pairs( obj_tbl ) do
				if EDITOR.Enemies and EDITOR.Enemies[ v ] then
					EDITOR.Enemies[ v ].CheckTriggers = EDITOR.Enemies[ v ].CheckTriggers or {}
					for _, tr in pairs( EDITOR.Enemies[ v ].CheckTriggers ) do
						if tr == key then
							EDITOR.Enemies[ v ].CheckTriggers[ _ ] = nil
							break
						end
					end
					if #EDITOR.Enemies[ v ].CheckTriggers < 1 then
						EDITOR.Enemies[ v ].CheckTriggers = nil
					end
				end
				if EDITOR.Pickups and EDITOR.Pickups[ v ] then
					EDITOR.Pickups[ v ].CheckTriggers = EDITOR.Pickups[ v ].CheckTriggers or {}
					for _, tr in pairs( EDITOR.Pickups[ v ].CheckTriggers ) do
						if tr == key then
							EDITOR.Pickups[ v ].CheckTriggers[ _ ] = nil
							break
						end
					end
					if #EDITOR.Pickups[ v ].CheckTriggers < 1 then
						EDITOR.Pickups[ v ].CheckTriggers = nil
					end
				end
				if EDITOR.Triggers and EDITOR.Triggers[ v ] then
					EDITOR.Triggers[ v ].CheckTriggers = EDITOR.Triggers[ v ].CheckTriggers or {}
					for _, tr in pairs( EDITOR.Triggers[ v ].CheckTriggers ) do
						if tr == key then
							EDITOR.Triggers[ v ].CheckTriggers[ _ ] = nil
							break
						end
					end
					if #EDITOR.Triggers[ v ].CheckTriggers < 1 then
						EDITOR.Triggers[ v ].CheckTriggers = nil
					end
				end
			end
		end
		
		if EDITOR.Triggers[key] then
			RemoveObjectFromTrigger( key, EDITOR.Triggers[key] )
			EDITOR.Triggers[key] = nil
		end
		
		CONTENTS_CHANGED = true
		
	end	
	
end

function RemoveAllTriggers()
	
	EDITOR.Triggers = EDITOR.Triggers or {}
	
	for k, v in pairs( EDITOR.Triggers ) do
		RemoveNearbyTrigger( k )
	end
	
end

function AddWeapon( pos_, swep_class )
	
	EDITOR.Pickups = EDITOR.Pickups or {}
	
	local count = 0
	
	for k, v in pairs( EDITOR.Pickups ) do
		count = count + 1
	end
	
	local key = "w"..(count + 1)
	
	for i=1, count do
		if not EDITOR.Pickups["w"..i] then
			key = "w"..i
			break
		end
	end
	
	EDITOR.Pickups[key] = { pos = pos_, wep = swep_class }
		
	net.Start( "AddWeapon" )
		net.WriteString( key )
		net.WriteTable( EDITOR.Pickups[key] )
	net.SendToServer()
	
	CONTENTS_CHANGED = true
end

function RemoveAllWeapons()
	
	EDITOR.Pickups = EDITOR.Pickups or {}
	
	for k, v in pairs( EDITOR.Pickups ) do
		RemoveObjectFromTrigger( k, EDITOR.Pickups[k] )
	end
	
	table.Empty( EDITOR.Pickups )
		
	net.Start("RemoveAllWeapons")
	net.SendToServer()
	
	CONTENTS_CHANGED = true
	
end

function RemoveNearbyWeapon()
	
	EDITOR.Pickups = EDITOR.Pickups or {}
		
	net.Start("RemoveNearbyWeapon")
		net.WriteVector( LocalPlayer():GetPos() )
	net.SendToServer()
		
end

net.Receive( "RemoveNearbyWeaponClient", function( len )
	
	local key = net.ReadString()
	
	if EDITOR.Pickups[key] then
		RemoveObjectFromTrigger( key, EDITOR.Pickups[key] )
		EDITOR.Pickups[key] = nil
	end
	
	CONTENTS_CHANGED = true
	
end)

function EditObjectStage( obj_key, category, stage_num, remove  )
		
	if EDITOR[ category ] and EDITOR[ category ][ obj_key ] then
	
		local obj_tbl = EDITOR[ category ][ obj_key ]
				
		if remove then
			
			if obj_tbl.stages then
				
				local count = 0
				
				for k, v in pairs( obj_tbl.stages ) do
					if v and v == stage_num then
						obj_tbl.stages[ k ] = nil
						break
					end
				end
				
				//remove table if its empty
				for k, v in pairs( obj_tbl.stages ) do
					if v then
						count = count + 1
					end
				end
				
				if count == 0 then
					obj_tbl.stages = nil
				end
				
			end
			
		else
			
			obj_tbl.stages = obj_tbl.stages or {}
			
			local exists = false
			
			for k, v in pairs( obj_tbl.stages ) do
				if v and v == stage_num then
					exists = true
					break
				end
			end
			
			if not exists then
				table.insert( obj_tbl.stages, stage_num )
			end
			
			PrintTable( EDITOR )
			
		end
	
	end
	
end

function AddEnemy( pos_, ang_, char_, wep_, behaviour_, anim_, immunity, ally_, optional_ )
	
	EDITOR.Enemies = EDITOR.Enemies or {}
	
	local count = 0
	
	for k, v in pairs( EDITOR.Enemies ) do
		count = count + 1
	end
	
	local key = "e"..(count + 1)
	
	for i=1, count do
		if not EDITOR.Enemies["e"..i] then
			key = "e"..i
			break
		end
	end
	
	EDITOR.Enemies[key] = { pos = pos_, ang = ang_, char = char_, wep = wep_ or nil, beh = behaviour_ or nil, anim = anim_ or nil, immune = immunity or nil, ally = ally_ or nil, opt = optional_ or nil }

	net.Start( "AddEnemy" )
		net.WriteString( key )
		net.WriteTable( EDITOR.Enemies[key] )
	net.SendToServer()
	
	for i=1, 4 do
		if ADD_OBJECT_TO_STAGE[ i ] then
			EditObjectStage( key, "Enemies", i )
		end
	end
	
	CONTENTS_CHANGED = true
	
end

function RemoveAllEnemies()
	
	EDITOR.Enemies = EDITOR.Enemies or {}
	
	for k, v in pairs( EDITOR.Enemies ) do
		RemoveObjectFromTrigger( k, EDITOR.Enemies[k] )
	end
	
	table.Empty( EDITOR.Enemies )
		
	net.Start("RemoveAllEnemies")
	net.SendToServer()
	
	CONTENTS_CHANGED = true
	
end

function RemoveNearbyEnemy()
	
	EDITOR.Enemies = EDITOR.Enemies or {}
		
	net.Start("RemoveNearbyEnemy")
		net.WriteVector( LocalPlayer():GetPos() )
	net.SendToServer()
		
end

net.Receive( "RemoveNearbyEnemyClient", function( len )
	
	local key = net.ReadString()
	
	if EDITOR.Enemies[key] then
		RemoveObjectFromTrigger( key, EDITOR.Enemies[key] )
		EDITOR.Enemies[key] = nil
	end
	
	CONTENTS_CHANGED = true
end)

net.Receive( "SendWeaponTables", function( len )
	
	local all_weps = net.ReadTable()
	local throwable_weps = net.ReadTable()
	local melee_weps = net.ReadTable()
	local ranged_weps = net.ReadTable()
	
	EditorWeapons["all"] = all_weps
	EditorWeapons["throwable"] = throwable_weps
	EditorWeapons["melee"] = melee_weps
	EditorWeapons["guns"] = ranged_weps
	
	//PrintTable( EditorWeapons )
	
end)

//because im lazy to make a new file
effects.Register(
            {
                Init = function( self, data )
                    					
					self.vehicle = math.Round( data:GetRadius() )

					if VehicleToModel[ self.vehicle ] and VehicleToModel[ self.vehicle ].mdl then
						self.body_mdl = VehicleToModel[ self.vehicle ].mdl
					end
					
					if VehicleToModel[ self.vehicle ] and VehicleToModel[ self.vehicle ].glass_mdl then
						self.glass_mdl = VehicleToModel[ self.vehicle ].glass_mdl
					end
					
                end,
 
                Think = function( self ) 
					
					if EDITOR and EDITOR.Vehicle then
						if EDITOR.Vehicle.pos then
							self:SetPos( EDITOR.Vehicle.pos )
						end
						if EDITOR.Vehicle.ang then
							self:SetAngles( EDITOR.Vehicle.ang )
						end
					end
					
					return EDITOR_VEHICLE ~= nil
				end,
 
                Render = function( self ) 
				
					if self.body_mdl then
						self:SetModel( self.body_mdl )
						self:SetupBones()
						self:DrawModel()
					end
					if self.glass_mdl then
						self:SetModel( self.glass_mdl )
						self:SetupBones()
						self:DrawModel()
					end
				end
            },
 
            "editor_vehicle"
        )

function ValueToString( val, add_depth )
	
	local depth = 0
	
	if add_depth then
		depth = add_depth + 1
	end
	
	local res = tostring(val)
	
	if type( val ) == "string" then
		res = string.format( "%q", val )//"\""..val.."\""
	end
	
	if type( val ) == "number" then
		res = tostring( val )
	end
	
	if type( val ) == "Vector" then
		res = "Vector( "..math.ceil( val.x, 2 )..", "..math.ceil( val.y, 2 )..", "..math.ceil( val.z, 2 ).." )"
	end
	
	if type( val ) == "Angle" then
		res = "Angle( "..math.ceil( val.p, 2 )..", "..math.ceil( val.y, 2 )..", "..math.ceil( val.r, 2 ).." )"
	end
	
	if type( val ) == "boolean" then
		res = tostring(val)
	end
	
	if type( val ) == "table" then
		res = "{\n"
		for i = 1, depth do
			res = res.."	"
		end
		for k, v in pairs( val ) do
			if type(k) == "number" then
				res = res.." "..ValueToString( v )..","
			else
				res = res.." ["..string.format( "%q", tostring( k ) ).."] = "..ValueToString( v, depth )..","
			end
		end
		if string.sub(res, -1) == "," then
			res = string.sub(res, 1, #res - 1)
		end
		res = res.." \n"
		for i = 1, depth do
			res = res.."	"
		end
		res = res.."}"
	end
	
	return res
end

function PlayTestScene()
	
	SaveScene( true )
	RunConsoleCommand( "sog_singleplayer_changelevel", "1", game.GetMap() )
	
end

function LoadTestScene()
	
	local test = file.Exists( "slaveofgmod/editortest.txt", "DATA" )
	
	if test then
		LoadScene( "slaveofgmod/editortest.txt" )
		//remove it, since its temporary
		file.Delete( "slaveofgmod/editortest.txt" )
	end
	
end

function SortTablePattern( tbl, pattern )
	
	for k, v in pairs( tbl ) do
		local normal_ind = tonumber(string.Replace( k, pattern, "" ))
		tbl[k]._pattern_sort = normal_ind
	end
	
	table.sort( tbl, function( a, b ) return a._pattern_sort > b._pattern_sort end )
	
	for k, v in pairs( tbl ) do
		tbl[k]._pattern_sort = nil
	end
	
end

function SaveScene( temp )
	
	local txt = ""
	
	for k, v in pairs( EDITOR ) do
		//ignore functions, since we do them manually
		if type( v ) == "function" then continue end
		txt = txt.."SCENE."..k.." = "..ValueToString( v ).."\n"
	end
	
	txt = txt.."\n"
	
	//do initialize stuff
	txt = txt.."SCENE.Initialize = function()\n"
	
	
	
	txt = txt.."end\n\n"
	
	//do Loaded stuff
	
		txt = txt.."SCENE.Loaded = function()\n"
	
			if PLAYER_SPAWNPOINT then
				txt = txt.."	PLAYER_SPAWNPOINT = "..ValueToString( PLAYER_SPAWNPOINT ).."\n"
			end
	
		txt = txt.."end\n\n"
	
	//print( txt )
	
	if !file.Exists( "slaveofgmod/savedscenes", "DATA" ) then
		file.CreateDir("slaveofgmod/savedscenes")
	end
	
	local name = EDITOR.Name ~= "" and EDITOR.Name or "untitled"
	name = string.lower( name )
	name = string.gsub( name, " ", "_" )
	
	if temp then
		file.Write("slaveofgmod/editortest.txt", txt)
	else
		file.Write("slaveofgmod/savedscenes/"..name..".txt", txt)
	end
	
	surface.PlaySound("buttons/button14.wav")
	
end

function LoadScene( path )
	
	local content = file.Read( path )
	
	//prevent loading stuff from other maps
	if content and not string.find( content, game.GetMap() ) then
		LocalPlayer():ChatPrint( "Current map and scene map are mismatching!" ) 
		surface.PlaySound( "buttons/button2.wav" )
		return
	end
	
	RemoveAllEnemies()
	RemoveAllWeapons()
	RemoveAllTriggers()
	
	table.Empty( EDITOR )
	PLAYER_SPAWNPOINT = nil
	EDITOR_VEHICLE = nil
	
	
	if content then
	
		SCENE = {}
		
		RunString( content )
		
		EDITOR = table.Copy( SCENE )
		
		SCENE = nil
		
		if EDITOR.Loaded then
			EDITOR.Loaded()
		end
		
		SpawnVehicleFromEditor()
		
		//add enemies
		if EDITOR.Enemies then
			
			local max_id = 1
		
			for k, v in pairs( EDITOR.Enemies ) do
				local normal_ind = tonumber(string.Replace( k, "e", "" ))
				if normal_ind > max_id then
					max_id = normal_ind
				end
			end
			
			//for key, tbl in pairs( EDITOR.Enemies ) do
			for i=1, max_id do
			
				local key = "e"..i
				local tbl = EDITOR.Enemies[key]
				if not tbl then continue end
				
				net.Start( "AddEnemy" )
					net.WriteString( key )
					net.WriteTable( tbl )
				net.SendToServer()
			end
		end
		
		//add pickups/weapons
		if EDITOR.Pickups then
			for key, tbl in pairs( EDITOR.Pickups ) do
				net.Start( "AddWeapon" )
					net.WriteString( key )
					net.WriteTable( tbl )
				net.SendToServer()
			end
		end
		
		PrintTable( EDITOR )
	
	end
	
	if EditorPanel then
		EditorPanel:Remove()
		EditorPanel = nil
	end
	
	if FilePanel then
		FilePanel:Remove()
		FilePanel = nil
	end

	EditorPanel = GAMEMODE.CursorFix:Add( "DPropertySheet" )
	EditorPanel:SetSize( GAMEMODE.CursorFix:GetWide()/3.8, GAMEMODE.CursorFix:GetTall() )
	EditorPanel:SetPos( GAMEMODE.CursorFix:GetWide() - EditorPanel:GetWide(), 0 )
	
	FilePanel = GAMEMODE.CursorFix:Add( "DPanel" )
	FilePanel:SetSize( 550, 22 )
		
	local new_b = FilePanel:Add( "DButton" )
	new_b:SetText( "New Scene" )
	new_b:SetSize( FilePanel:GetWide()/4, 22 )
	new_b:Dock( LEFT )
	new_b.DoClick = function( self )
		NewSceneMenu( EditorPanel )
	end
	
	local save_b = FilePanel:Add( "DButton" )
	save_b:SetText( "Save Scene" )
	save_b:SetSize( FilePanel:GetWide()/4, 22 )
	save_b:Dock( LEFT )
	save_b.DoClick = function( self )
		SaveScene()
	end
	save_b.Think = function( self )
		if not PLAYER_SPAWNPOINT then
			self:SetEnabled( false )
		else
			self:SetEnabled( true )
		end
	end
	
	local load_b = FilePanel:Add( "DButton" )
	load_b:SetText( "Load Scene" )
	load_b:SetSize( FilePanel:GetWide()/4, 22 )
	load_b:Dock( LEFT )
	load_b.DoClick = function( self )
		LoadSceneMenu( EditorPanel )
	end
	
	local test_b = FilePanel:Add( "DButton" )
	test_b:SetText( "Test Scene" )
	test_b:SetSize( FilePanel:GetWide()/4, 22 )
	test_b:Dock( LEFT )
	test_b.DoClick = function( self )
		PlayTestScene()
	end
	test_b.Think = function( self )
		if not PLAYER_SPAWNPOINT then
			self:SetEnabled( false )
		else
			self:SetEnabled( true )
		end
	end
	
	AddTabs( EditorPanel )

end

//hud and stuff

local function DrawCross( x, y )
	surface.SetDrawColor( color_white )
	surface.DrawLine( x - 3, y - 3, x + 3, y + 3 ) 
	surface.DrawLine( x - 3, y + 3, x + 3, y - 3 )
end

local function DrawSquare( x, y, size )
	surface.SetDrawColor( color_white )
	surface.DrawLine( x - size/2, y - size/2, x + size/2, y - size/2 ) 
	surface.DrawLine( x - size/2, y - size/2, x - size/2, y + size/2 ) 
	surface.DrawLine( x + size/2, y + size/2, x + size/2, y - size/2 ) 
	surface.DrawLine( x + size/2, y + size/2, x - size/2, y + size/2 ) 
end

local function DrawSquareToScreen( pos, size, col )
	
	local top_left = (pos + Vector( -size, -size, 0 )):ToScreen()
	local top_right = (pos + Vector( size, -size, 0 )):ToScreen()
	local bottom_left = (pos + Vector( -size, size, 0 )):ToScreen()
	local bottom_right = (pos + Vector( size, size, 0 )):ToScreen()

	surface.SetDrawColor( col or color_white )
	surface.DrawLine( top_left.x, top_left.y, top_right.x, top_right.y ) 
	surface.DrawLine( top_left.x, top_left.y, bottom_left.x, bottom_left.y ) 
	surface.DrawLine( bottom_right.x, bottom_right.y, bottom_left.x, bottom_left.y ) 
	surface.DrawLine( bottom_right.x, bottom_right.y, top_right.x, top_right.y ) 
end

local function DrawRhombusToScreen( pos, size, col )
	
	local top_left = (pos + Vector( -size, 0, 0 )):ToScreen()
	local top_right = (pos + Vector( 0, -size/2, 0 )):ToScreen()
	local bottom_left = (pos + Vector( 0, size/2, 0 )):ToScreen()
	local bottom_right = (pos + Vector( size, 0, 0 )):ToScreen()

	surface.SetDrawColor( col or color_white )
	surface.DrawLine( top_left.x, top_left.y, top_right.x, top_right.y ) 
	surface.DrawLine( top_left.x, top_left.y, bottom_left.x, bottom_left.y ) 
	surface.DrawLine( bottom_right.x, bottom_right.y, bottom_left.x, bottom_left.y ) 
	surface.DrawLine( bottom_right.x, bottom_right.y, top_right.x, top_right.y ) 
end

local function DrawArrowToScreen( pos1, pos2, col )
	
	local tpos1 = pos1:ToScreen()
	local tpos2 = pos2:ToScreen()
	
	surface.SetDrawColor( col or color_white )
	surface.DrawLine( tpos1.x, tpos1.y, tpos2.x, tpos2.y ) 
	
	local norm = (pos1 - pos2):GetNormal()
	
	local ang = norm:Angle()
	ang:RotateAroundAxis( vector_up, 20 )
	
	local arrow_norm1 = ang:Forward()
	local arrow_pos1 = (pos2 + arrow_norm1 * 5):ToScreen()
	
	surface.DrawLine( tpos2.x, tpos2.y, arrow_pos1.x, arrow_pos1.y ) 
	
	ang = norm:Angle()
	ang:RotateAroundAxis( vector_up, -20 )
	
	local arrow_norm2 = ang:Forward()
	local arrow_pos2 = (pos2 + arrow_norm2 * 5):ToScreen()
	
	surface.DrawLine( tpos2.x, tpos2.y, arrow_pos2.x, arrow_pos2.y ) 
	
	
end

hook.Add( "HUDPaint", "EditorStuff", function()
	
	if not EditorPanel then return end
		
	if PLAYER_SPAWNPOINT then
		local pos = PLAYER_SPAWNPOINT:ToScreen()
		
		draw.SimpleText( "player spawns here", "Default", pos.x, pos.y - 15, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		DrawCross( pos.x, pos.y )
		
	end
	
	//triggers
	if SHOW_TRIGGERS then		
		if EDITOR.Triggers then
			for key, tbl in pairs( EDITOR.Triggers ) do
				local pos = tbl.pos
				local size = tbl.size
				local action = tbl.action
				
				if pos and size then
					local tpos = pos:ToScreen()
					
					local stage = ""
				
					if tbl.stages then
						stage = "  ["
						for k, v in pairs( tbl.stages ) do
							stage = stage.." "..v
						end
						stage = stage.." ]"
					end
					
					if tbl.event then
						draw.SimpleTextOutlined( "Event: "..key..stage, "Default", tpos.x, tpos.y + 35, Color( 255, 50, 30 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
						draw.SimpleTextOutlined( "Action: Activate connected triggers", "Default", tpos.x, tpos.y + 45, Color( 255, 50, 30 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
						draw.SimpleTextOutlined( "Event Type: \""..tbl.event.."\"", "Default", tpos.x, tpos.y + 65, Color( 255, 50, 30 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
						
						local dt = ""
						local cnt = 0
						if tbl.data then
							if type(tbl.data) == "table" then
								for k, v in pairs( tbl.data ) do
									if v then
										dt = dt.."\""..tostring( v ).."\" "
										cnt = cnt + 1
										draw.SimpleTextOutlined( "Data: "..dt, "Default", tpos.x, tpos.y + 75 * ( cnt ), Color( 255, 50, 30 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
									end
								end
							else
								draw.SimpleTextOutlined( "Data: \""..tostring(tbl.data).."\"", "Default", tpos.x, tpos.y + 75, Color( 255, 50, 30 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
							end
						end
						DrawRhombusToScreen( pos, 10, Color( 255, 50, 30 ) )
					else
						draw.SimpleTextOutlined( "Trigger: "..key..stage, "Default", tpos.x, tpos.y + 35, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
						draw.SimpleTextOutlined( "Action: "..action, "Default", tpos.x, tpos.y + 45, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
						//if tbl.data and ( type(tbl.data) == "string" or type(tbl.data) == "boolean" or type(tbl.data) == "number" ) then
						//	draw.SimpleTextOutlined( "Data: \""..tostring(tbl.data).."\"", "Default", tpos.x, tpos.y + 65, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
						//end
						local dt = ""
						local cnt = 0
						if tbl.data then
							if type(tbl.data) == "table" then
								for k, v in pairs( tbl.data ) do
									if v then
										dt = dt.."\""..tostring( v ).."\" "
										cnt = cnt + 1
										draw.SimpleTextOutlined( "Data: "..dt, "Default", tpos.x, tpos.y + 65 * ( cnt ), color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
									end
								end
							else
								draw.SimpleTextOutlined( "Data: \""..tostring(tbl.data).."\"", "Default", tpos.x, tpos.y + 65, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
							end
						end
						DrawSquareToScreen( pos, size )
					end
					
					if tbl.action == "dialogue" then
						draw.SimpleTextOutlined( "Dialogue: \""..tostring(tbl.objects[1]).."\"", "Default", tpos.x, tpos.y + 65, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
					end
					
					if tbl.trigger_once then
						draw.SimpleTextOutlined( "Will be triggered once", "Default", tpos.x, tpos.y + 75, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
					end
					
					//outcoming arrows
					if tbl.objects then
						local obj_tbl = tbl.objects
						for k, v in pairs( obj_tbl ) do
							if EDITOR.Enemies and EDITOR.Enemies[ v ] and EDITOR.Enemies[ v ].pos then
								DrawArrowToScreen( pos, EDITOR.Enemies[ v ].pos )
							end
							if EDITOR.Pickups and EDITOR.Pickups[ v ] and EDITOR.Pickups[ v ].pos then
								DrawArrowToScreen( pos, EDITOR.Pickups[ v ].pos )
							end
							if EDITOR.Triggers and EDITOR.Triggers[ v ] and EDITOR.Triggers[ v ].pos then
								DrawArrowToScreen( pos, EDITOR.Triggers[ v ].pos )
							end
						end
					end
					//incoming arrows
					if tbl.data and type(tbl.data) == "table" then
						local obj_tbl = tbl.data
						for k, v in pairs( obj_tbl ) do
							if EDITOR.Enemies and EDITOR.Enemies[ v ] and EDITOR.Enemies[ v ].pos then
								DrawArrowToScreen( EDITOR.Enemies[ v ].pos, pos, Color( 255, 50, 30 ) )
							end
							if EDITOR.Pickups and EDITOR.Pickups[ v ] and EDITOR.Pickups[ v ].pos then
								DrawArrowToScreen( EDITOR.Pickups[ v ].pos, pos, Color( 255, 50, 30 ) )
							end
							if EDITOR.Triggers and EDITOR.Triggers[ v ] and EDITOR.Triggers[ v ].pos then
								DrawArrowToScreen( EDITOR.Triggers[ v ].pos, pos, Color( 255, 50, 30 ) )
							end
						end
					end
				end
			end
		end
	end
	
	//enemies
	if EDITOR.Enemies and SHOW_ENEMY_INFO then
		for key, tbl in pairs( EDITOR.Enemies ) do
			local pos = tbl.pos:ToScreen()
			local beh = BehaviourToText[tbl.beh or BEHAVIOUR_DEFAULT]
			
			if pos and beh then
				local stage = ""
				
				if tbl.stages then
					stage = "  ["
					for k, v in pairs( tbl.stages ) do
						stage = stage.." "..v
					end
					stage = stage.." ]"
				end
				
				draw.SimpleTextOutlined( "Enemy: "..key..stage, "Default", pos.x, pos.y + 35, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
				draw.SimpleTextOutlined( beh, "Default", pos.x, pos.y + 45, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
				if tbl.immune then
					draw.SimpleTextOutlined( "Invincible", "Default", pos.x, pos.y + 55, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
				end
				if tbl.ally then
					draw.SimpleTextOutlined( "Ally", "Default", pos.x, pos.y + 65, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
				end
				if tbl.opt then
					draw.SimpleTextOutlined( "Optional target", "Default", pos.x, pos.y + 75, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
				end
			end
		end
	end
	
	//pickups
	if EDITOR.Pickups and SHOW_WEAPON_INFO then
		for key, tbl in pairs( EDITOR.Pickups ) do
			local pos = tbl.pos:ToScreen()
			local name = tbl.wep
			
			if pos and name then
				draw.SimpleTextOutlined( "Weapon: "..key, "Default", pos.x, pos.y + 35, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
				draw.SimpleTextOutlined( name, "Default", pos.x, pos.y + 45, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
			end
		end
	end

end)


end