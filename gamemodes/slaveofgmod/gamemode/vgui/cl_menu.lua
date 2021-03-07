local MenuElements = {}

local function AddToMainMenu( name, element, backname )
	table.insert( MenuElements, { name, element, backname } )
end

local function TextPaint( panel, sw, sh, text, font, overridecol )
	
	local shift = 2
			
	if panel.Overed then
		shift = math.sin(RealTime()*3.2)*9 + 11
	end
			
	local x,y = sw/2, sh/2 
			
	draw.SimpleText( text, font or "NumbersBig", x + 3, y + 3, Color( 10, 10, 10, 185), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			
	for i=0,10 do
		draw.SimpleText( text, font or "NumbersBig", x - shift * (i/12), y - shift/3 * (i/12), BLACK_AND_WHITE and Color( 20, 20, 20, 255) or Color( 97, 0, 27, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end			

	draw.SimpleText( text, font or "NumbersBig", x - shift, y - shift/3, overridecol or Color( 220, 220, 220, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			
end

function CheckStory( gametype, f )
	
	if STORY then
		local cv = GAMEMODE.TranslateCutscenes[gametype]
		if cv then
			local actual_cv = GetConVar( cv ) and GetConVar( cv ):GetInt() or 0
			
			if GAMEMODE.Cutscenes[ cv ] and GAMEMODE.Cutscenes[ cv ][ actual_cv ] then
				DrawCutscene( GAMEMODE.Cutscenes[ cv ][ actual_cv ], f, cv)
				//timer.Simple( 6, function() DrawCutscene( GAMEMODE.Cutscenes[ cv ][ actual_cv ], f, cv) end)
			else
				if GAMEMODE.Cutscenes[ cv ] and actual_cv < table.maxn(GAMEMODE.Cutscenes[ cv ]) + 1 then
					RunConsoleCommand( cv, tostring( actual_cv + 1 ) )
				end
				f()
			end
		else
			f()
		end
	else
		f()
	end

end

function ManageFirstSpawn( gametype, singleplayer )
	
	if EDITOR_TEST and !singleplayer then
		RunConsoleCommand( "select_character", "0")
		RunConsoleCommand( "editor_open" )
	else
		if singleplayer then
			//show menu function
			local char_menu = function()
				if GAMEMODE.UseCharacters and #GAMEMODE.UseCharacters > 1 then
					DrawCharacterMenu()
				else
					local num = OVERRIDE_CHARACTER and tostring(GAMEMODE:GetCharacterIdByReference( OVERRIDE_CHARACTER )) or "0"
					
					local checkstyles = GAMEMODE.Characters[GAMEMODE:GetCharacterIdByReference( OVERRIDE_CHARACTER ) or "default"]
					if checkstyles and checkstyles.Styles then
						DrawCharacterMenu( nil, OVERRIDE_CHARACTER or "default" )
					else
						RunConsoleCommand( "select_character", num )
					end
				end
			end
			
			//loading screen function that calls char menu
			local loading_screen = function()
			
				if SCENE.OnLoadingScreen then
					SCENE.OnLoadingScreen()
				end
			
				local scene = CUR_SCENE or -1
				if not SCENE.Order then
					scene = -1
				end
				
				if EDITOR_TEST and singleplayer then
					scene = 0
				end
			
				CreateLoadingScreen( SCENE.Name or "UNTITLED", scene, SCENE.Final and 10 or 6, true, char_menu )
				
				if SOG_AUTOPLAY_MUSIC then
					if SCENE.Ambient and SCENE.StartFromAmbient then
						GAMEMODE:CreateMusic( MUSIC_TYPE_AMBIENT, SCENE.Ambient, SCENE.AmbientVolume or 20, false, SCENE.AmbientStartFrom or nil, SCENE.AmbientEndAt or nil )
						if SCENE.SoundTrack then
							GAMEMODE:CreateMusic( MUSIC_TYPE_NORMAL, SCENE.SoundTrack, SCENE.Volume or 20, true, SCENE.StartFrom or nil, SCENE.EndAt or nil )
						end
					else
						if SCENE.SoundTrack then
							GAMEMODE:CreateMusic( MUSIC_TYPE_NORMAL, SCENE.SoundTrack, SCENE.Volume or 20, false, SCENE.StartFrom or nil, SCENE.EndAt or nil )
						end
					end
				end
			end
			
			//if we have a cutscene then play it, otherwise load the level
			if not EDITOR_TEST and SCENE.Name and GAMEMODE.SingleplayerCutscenes[ SCENE.Name ] and PLAY_CUTSCENE then
				DrawCutscene( GAMEMODE.SingleplayerCutscenes[ SCENE.Name ], loading_screen )
			else
				loading_screen()
			end
			
		else
			DrawMenu( true, gametype ) 
		end
	end
			
end

function DrawMenu( background, gametype )

	local w,h = ScrW(), ScrH()
	local MySelf = LocalPlayer()

	if MainMenu then
		MainMenu:Remove()
		MainMenu = nil
	end
	
	MainMenu = vgui.Create( "DFrame" )
	MainMenu:SetSize( w, h )
	MainMenu:SetPos(0,0)
	MainMenu:SetDraggable ( false )
	MainMenu:SetTitle("")
	MainMenu:ShowCloseButton(false)
	MainMenu.HasBackground = background
	MainMenu.Think = function( self )
		gui.EnableScreenClicker( true )
	end
	
	if gametype then
		MainMenu.Gametype = gametype
	end
	
	if background then
		MainMenu.Paint = function() end
		MainMenu.Background = CreateMenuBackground( MainMenu )
	else
		MainMenu.Paint = function( self, tw, th ) 
			local gametype = GAMEMODE:GetGametype() and GAMEMODE.AvalaibleGametypes[GAMEMODE:GetGametype()] and GAMEMODE.AvalaibleGametypes[GAMEMODE:GetGametype()].name
			if SINGLEPLAYER then
				gametype = "Story Mode"
			end
			Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
			draw.SimpleText( GAMEMODE.Version or "error", "PixelSmaller", tw-10, 25, Color(250, 250, 250, 205), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
			draw.SimpleText( gametype or "error", "PixelSmaller", tw-10, 50, Color(250, 250, 250, 205), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
		end 
	end
	
	local Collumn = MainMenu:Add( "DPanel" )
	Collumn:SetSize( MainMenu:GetWide(), MainMenu:GetTall()/1.5 )
	local div = game.SinglePlayer() and 2.75 or 2.4
	Collumn:SetPos( MainMenu:GetWide()/2 - Collumn:GetWide()/2, MainMenu:GetTall()/div)
	Collumn.Paint = function() end
	
	MainMenu.BuildMenu = function( s )
		
		for k, v in pairs( Collumn:GetChildren() ) do
			if v then v:Remove() end
		end
		
		local num = 0
	
		for ind, tbl in pairs( MenuElements ) do
			num = num + 1
		end

		local bw, bh = Collumn:GetWide(), 70
		local spacing = 13
		
		local wholeh = bh * num + spacing * ( num - 1 )

		local Btn = {}
		
		local step = 0
		
		for ind, tbl in pairs( MenuElements ) do
			
			local name = background and tbl[3] or tbl[1]
			local el = tbl[2]
			
			local btn = Btn[ ind ]
			
			btn = Collumn:Add( "DButton" )
			btn:SetSize( bw, bh )
			btn:SetText( "" )
			btn:SetPos( Collumn:GetWide()/2 - bw/2 , step )//Collumn:GetTall()/2  + - wholeh/2
			//btn:SetCursor( "crosshair" )
			btn.OnCursorEntered = function( self )
				self.Overed = true
			end
			btn.OnCursorExited = function( self )
				self.Overed = false
			end
			btn.DoClick = function( self )
				if name == "" then return end
				local element = el( MainMenu, Collumn )
			end
			btn.Paint = function( self, sw, sh )
			
				TextPaint( self, sw, sh, name or "Error" )
				
			end
			
			step = step + bh + spacing
		end
		
	end
	
	MainMenu:BuildMenu()
	
	/*local num = 0
	
	for ind, tbl in pairs( MenuElements ) do
		num = num + 1
	end

	local bw, bh = Collumn:GetWide(), 70
	local spacing = 13
	
	local wholeh = bh * num + spacing * ( num - 1 )

	local Btn = {}
	
	local step = 0
	
	for ind, tbl in pairs( MenuElements ) do
		
		local name = background and tbl[3] or tbl[1]
		local el = tbl[2]
		
		local btn = Btn[ ind ]
		
		btn = Collumn:Add( "DButton" )
		btn:SetSize( bw, bh )
		btn:SetText( "" )
		btn:SetPos( Collumn:GetWide()/2 - bw/2 , step )//Collumn:GetTall()/2  + - wholeh/2
		//btn:SetCursor( "crosshair" )
		btn.OnCursorEntered = function( self )
			self.Overed = true
		end
		btn.OnCursorExited = function( self )
			self.Overed = false
		end
		btn.DoClick = function( self )
			if name == "" then return end
			local element = el( MainMenu, Collumn )
		end
		btn.Paint = function( self, sw, sh )
		
			TextPaint( self, sw, sh, name or "Error" )
			
		end
		
		step = step + bh + spacing
	end	*/
	
	if background then
		CheckMulticore()
	end
	
end	

//start/resume
local function Resume( parent, list )
	
	local menu = false
	local gametype
	
	if parent.Gametype then
		gametype = parent.Gametype
	end
	
	if parent.HasBackground then
		menu = true
	end
	
	parent:Remove()
	parent = nil
	
	if menu then
	
		local f = function()
			
			local c = function()
				if not NOCHARMENU then
					DrawCharacterMenu( )
				else
					RunConsoleCommand( "select_character", "0")
					//GAMEMODE:DrawGametypeName()
				end
			end
			
			local number = 0
			
			local cv = GAMEMODE.TranslateCutscenes[gametype]
			if cv then
				local actual_cv = GetConVar( cv ) and GetConVar( cv ):GetInt() or 0
				number = actual_cv
			end
			
			CreateLoadingScreen( GAMEMODE.GametypeName, number + 1, 5.5, true, c )
			
			if IsValid( GAMEMODE.Music ) then
				GAMEMODE.Music:Stop()
			end
			
			if SOG_AUTOPLAY_MUSIC then
				GAMEMODE:ToggleRadio()
			end
		end
	
		if gametype then
			CheckStory( gametype, f )
		else
			f()
		end
	
	end
	
	return
end

AddToMainMenu( "Resume", Resume, "Start game" )

local function Campaign( parent, list )
	
	if not CheckMapsMenu() then return end
	
	list:SetVisible( false )
	
	local Collumn = parent:Add( "DPanel" )
	Collumn:SetSize( parent:GetWide(), parent:GetTall()/1.5 )
	Collumn:SetPos( parent:GetWide()/2 - Collumn:GetWide()/2, parent:GetTall()/2.5)
	Collumn.Paint = function() end
	
	local TopName = Collumn:Add( "DPanel" )
	TopName:SetSize( parent:GetWide(), 50 )
	TopName.Text = "Act Selection"
	TopName.Paint = function( self, pw, ph ) 
		
		local shift = math.sin(RealTime()*3.2)*9 + 11
		
		shift = shift*3

		drawstripes( 3*pw/4, ph/2, pw/2, 4, 6, 4, true )
		drawstripes( pw/4, ph/2,  pw/2, 4, 6, 4, false )
		
		local x, y = pw/2, ph/2
		local text = self.Text or "error"
		
		local col_back_text = BLACK_AND_WHITE and Color( 23, 23, 23, 255 ) or Color( 186, 13, 190, 255 )
		local col_text = BLACK_AND_WHITE and Color( 255 - shift, 255 - shift, 255 - shift, 255 ) or Color( 255 - shift, 136 - shift, 255 - shift, 255 )
		
		draw.SimpleTextOutlined( text, "PixelCutsceneScaled", x, y, col_back_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
		draw.SimpleTextOutlined( text, "PixelCutsceneScaled", x - 3, y - 3, col_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
	
	
	end
	TopName:Dock( TOP )
	
	local Manager = Collumn:Add( "DPanel" )
	Manager:SetSize( Collumn:GetWide(), Collumn:GetTall()/2.5 )
	Manager:Dock( TOP )
	Manager.Mode = "acts"
	Manager.Paint = function() end
	
	local TrackName = Collumn:Add( "DPanel" )
	TrackName:SetSize( parent:GetWide(), 40 )
	TrackName.Text = ""
	TrackName.Overed = true
	TrackName.Paint = function( self, pw, ph ) 

		local shift = math.sin(RealTime()*3.2)*9 + 11
		
		shift = shift*3
		
		local x, y = pw/2, ph/2
		local text = self.Text or "error"
		
		local col_back_text = BLACK_AND_WHITE and Color( 23, 23, 23, 255 ) or Color( 186, 13, 190, 255 )
		local col_text = BLACK_AND_WHITE and Color( 255 - shift, 255 - shift, 255 - shift, 255 ) or Color( 255 - shift, 136 - shift, 255 - shift, 255 )
		
		draw.SimpleTextOutlined( text, "PixelCutsceneScaledSmall", x, y, col_back_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
		draw.SimpleTextOutlined( text, "PixelCutsceneScaledSmall", x - 3, y - 3, col_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
	
	end
	TrackName:Dock( TOP )
	
	local LowerName = Collumn:Add( "DPanel" )
	LowerName:SetSize( parent:GetWide(), 80 )
	LowerName.Text = ""
	LowerName.Overed = true
	LowerName.Paint = function( self, pw, ph ) 

		drawstripes( 3*pw/4, ph/2, pw/2, 4, 10, 4, true )
		drawstripes( pw/4, ph/2,  pw/2, 4, 10, 4, false )
		
		local text = self.Text or "error"
		
		TextPaint( self, pw, ph, text )
	
	end
	LowerName:Dock( TOP )
	
	local back = Collumn:Add( "DButton" )
	back:SetSize( Collumn:GetWide(), 70)
	back:DockMargin( 0, 0, 0, 13)
	back:SetText( "" )
	back:Dock( TOP )
	back.OnCursorEntered = function( self )
		self.Overed = true
	end
	back.OnCursorExited = function( self )
		self.Overed = false
	end
	back.Paint = function( self, sw, sh )
		TextPaint( self, sw, sh, "Back" )
	end
	back.DoClick = function( self )
		if Manager.Mode == "scenes" then
			Manager:MakeActs()
		elseif Manager.Mode == "intro" and Manager.TempAct then
			Manager:MakeScenes( Manager.TempAct )	
			Manager.TempAct = nil
		else
			Collumn:Remove()
			list:SetVisible( true )
		end
	end
	
	//make acts menu
	function Manager:MakeActs()
		
		for k, v in pairs( self:GetChildren() ) do
			if v and v:IsValid() then
				v:Remove()
			end
		end
		
		TrackName:SetSize( parent:GetWide(), 0 )
		
		self.Mode = "acts"
		
		local num_actual_acts = 0
		
		for ind, act_tbl in pairs( ACTS ) do
			if math.ceil( SOG_PROGRESS / 4 ) < ind then continue end
			num_actual_acts = num_actual_acts + 1
		end
		
		local num = num_actual_acts//math.max( #ACTS, 1 )

		local tall = math.min(self:GetTall(),self:GetWide()/(num))
		
		local bw, bh = tall, tall
		local spacing = 4
		local step = 0
		
		local wholew = bw * num + spacing * ( num - 1 )
		
		TopName.Text = "Act Selection"
		LowerName.Text = ""
		
		for ind, act_tbl in pairs( ACTS ) do
			
			if math.ceil( SOG_PROGRESS / 4 ) < ind then continue end
			
			local btn = self:Add( "DButton" )
			btn:SetSize( bw, bh )
			btn:SetText( "" )//act_tbl.Name
			btn:SetPos( self:GetWide()/2 - wholew/2 + step , self:GetTall()/2 - bh/2 )
			btn.OnCursorEntered = function( self )
				self.Overed = true
				TopName.Text = "Act #"..ind
				if ind > 6 then
					TopName.Text = "Bonus Act"
				end
				TrackName.Text = ""
				LowerName.Text = act_tbl.Name
			end
			btn.OnCursorExited = function( self )
				self.Overed = false
				TopName.Text = "Act Selection"
				TrackName.Text = ""
				LowerName.Text = ""
			end
			btn.Paint = function( self, sw, sh )
			
				local scale = self.Overed and 0.9 or 0.7
				
				local width, height = 150, 251//34, 57
				
				local mul =	sh * scale / height
				
				surface.SetMaterial( act_tbl.Cover )
				
				local rotation = math.sin( RealTime() * ( 1 + 0.2 ^ ind ) ) * 7 
				
				surface.SetDrawColor( 10,10,10,185 )
				surface.DrawTexturedRectRotated( sw/2 + 5, sh/2 + 5, width * mul, height * mul, rotation)
				
				surface.SetDrawColor( Color(255,255,255,255) )
				
				surface.DrawTexturedRectRotated( sw/2, sh/2, width * mul, height * mul, rotation)
			end
			btn.DoClick = function( s )
				self:MakeScenes( act_tbl.Scenes )
			end
			
			step = step + bw + spacing
			
		end
		
	end
	
	function Manager:MakeScenes( act_tbl )
		
		for k, v in pairs( self:GetChildren() ) do
			if v and v:IsValid() then
				v:Remove()
			end
		end
		
		self.Mode = "scenes"
		
		TrackName:SetSize( parent:GetWide(), 40 )
		
		local num_actual_scenes = 0
		
		for ind, scene_tbl in pairs( act_tbl ) do
			if SOG_PROGRESS < ( scene_tbl.Order or 2 ) then continue end
			num_actual_scenes = num_actual_scenes + 1
		end
		
		local num = num_actual_scenes//math.max( #act_tbl, 1 )

		local tall = math.min(self:GetTall(),self:GetWide()/(num))
		
		local bw, bh = tall, tall
		local spacing = 4
		local step = 0
		
		local wholew = bw * num + spacing * ( num - 1 )
		
		TopName.Text = "Scene Selection"
		LowerName.Text = ""
		
		for ind, scene_tbl in pairs( act_tbl ) do
			
			if SOG_PROGRESS < ( scene_tbl.Order or 2 ) then continue end
			
			local btn = self:Add( "DButton" )
			btn:SetSize( bw, bh )
			btn:SetText( "" )//scene_tbl.Name
			btn:SetPos( self:GetWide()/2 - wholew/2 + step , self:GetTall()/2 - bh/2 )
			btn.OnCursorEntered = function( self )
				self.Overed = true
				TopName.Text = "Scene #"..scene_tbl.Order
				if scene_tbl.MusicText then
					TrackName.Text = "♫ "..scene_tbl.MusicText.." ♫"//"Song: "..scene_tbl.MusicText
				else
					TrackName.Text = ""
				end
				LowerName.Text = scene_tbl.Name
			end
			btn.OnCursorExited = function( self )
				self.Overed = false
				TopName.Text = "Scene Selection"
				TrackName.Text = ""
				LowerName.Text = ""
			end
			btn.Paint = function( self, sw, sh )
			
				local scale = self.Overed and 1.2 or 0.7
				
				local width, height = 150, 251
				
				local mul =	sh * scale / height
				
				surface.SetMaterial( scene_tbl.Cover )
				
				local rotation = math.sin( RealTime() * ( 1 + 0.2 ^ ind ) ) * 7 
				
				surface.SetDrawColor( 10,10,10,185 )
				surface.DrawTexturedRectRotated( sw/2 + 5, sh/2 + 5, width * mul, width * mul, rotation)
				
				surface.SetDrawColor( Color(255,255,255,255) )
				
				surface.DrawTexturedRectRotated( sw/2, sh/2, width * mul, width * mul, rotation)
			end
			btn.DoClick = function( s )
				if GAMEMODE.SingleplayerCutscenes[scene_tbl.Name] then
					self.TempAct = act_tbl
					self:MakeIntroMenu( scene_tbl )
				else
					RunConsoleCommand( "sog_singleplayer_changelevel", tostring( scene_tbl.Order ) )
				end
			end
			
			step = step + bw + spacing
			
		end
		
	end
	
	function Manager:MakeIntroMenu( scene_tbl )
		
		for k, v in pairs( self:GetChildren() ) do
			if v and v:IsValid() then
				v:Remove()
			end
		end
		
		self.Mode = "intro"
		
		TrackName:SetSize( parent:GetWide(), 0 )
		
		local num = 2

		local tall = math.min(self:GetTall(),self:GetWide()/(num))
		
		local bw, bh = tall, tall
		local spacing = 4
		local step = 0
		
		local wholew = bw * num + spacing * ( num - 1 )
		
		TopName.Text = "Play intro?"
		LowerName.Text = ""
		
		for i = 1, 2 do
		
			local play = i == 1 or false
		
			local btn = self:Add( "DButton" )
			btn:SetSize( bw, bh )
			btn:SetText( "" )
			btn:SetPos( self:GetWide()/2 - wholew/2 + step , self:GetTall()/2 - bh/2 )
			btn.OnCursorEntered = function( self )
				self.Overed = true
				LowerName.Text = play and "YES" or "NO"
			end
			btn.OnCursorExited = function( self )
				self.Overed = false
				LowerName.Text = ""
			end
			btn.Paint = function( self, sw, sh )
			
				local scale = self.Overed and 1.2 or 1
				
				local width, height = 150, 251
				
				local mul =	sh * scale / height
				
				surface.SetMaterial( scene_tbl.Cover )
				
				local rotation = math.sin( RealTime() * ( 1 + 0.2 ^ i ) ) * 7 
				
				surface.SetDrawColor( 10,10,10,185 )
				surface.DrawTexturedRectRotated( sw/2 + 5, sh/2 + 5, width * mul, width * mul, rotation)
				
				surface.SetDrawColor( play and Color( 255, 255, 255, 255 ) or Color( 20, 20, 20, 255 ) )
				
				surface.DrawTexturedRectRotated( sw/2, sh/2, width * mul, width * mul, rotation)
			end
			btn.DoClick = function( s )
				if play then
					RunConsoleCommand( "sog_singleplayer_changelevel", tostring( scene_tbl.Order ) )
				else
					RunConsoleCommand( "sog_singleplayer_changelevel", tostring( scene_tbl.Order ), tostring( scene_tbl.Map ), "1" )
				end
			end
			
			step = step + bw + spacing
			
		end
		
	end
	
	Manager:MakeActs()

	return Collumn
end

//temp
if game.SinglePlayer() then
	AddToMainMenu( "Story Mode", Campaign )
end

//basically a mini copy of normal options
local function MusicOptions( parent, list )
	
	list:SetVisible( false )
	
	local Collumn = parent:Add( "DPanel" )
	Collumn:SetSize( parent:GetWide(), parent:GetTall()/1.5 )
	Collumn:SetPos( parent:GetWide()/2 - Collumn:GetWide()/2, parent:GetTall()/2.5)
	Collumn.Paint = function() end
	
	local desc = parent:Add( "DPanel" )
	desc:SetSize( parent:GetWide(), 90 )
	desc.Text = ""
	desc:SetPos( 0, parent:GetTall()-90)
	desc.Paint = function( self, sw, sh) 
		TextPaint( self, sw, sh, self.Text or "", "NumbersSmall" ) 
	end
	
	//actual music
	local b = Collumn:Add( "DButton" )
	b:SetSize( Collumn:GetWide(), 70)
	b:DockMargin( 0, 0, 0, 13)
	b:SetText( "" )
	b:Dock( TOP )
	b.OnCursorEntered = function( self )
		self.Overed = true
		desc.Text = "Enable or disable level music."
	end
	b.OnCursorExited = function( self )
		self.Overed = false
		desc.Text = ""
	end
	b.Paint = function( self, sw, sh )
		TextPaint( self, sw, sh, "autoplay level music   -   "..(SOG_AUTOPLAY_MUSIC and "on" or "off"), "Numbers" ) 
	end
	b.DoClick = function( self )
		RunConsoleCommand("sog_autoplaymusic", SOG_AUTOPLAY_MUSIC and "0" or "1")
	end
	
	//menu music
	local b = Collumn:Add( "DButton" )
	b:SetSize( Collumn:GetWide(), 70)
	b:DockMargin( 0, 0, 0, 13)
	b:SetText( "" )
	b:Dock( TOP )
	b.OnCursorEntered = function( self )
		self.Overed = true
		desc.Text = "Enable or disable music in menu."
	end
	b.OnCursorExited = function( self )
		self.Overed = false
		desc.Text = ""
	end
	b.Paint = function( self, sw, sh )
		TextPaint( self, sw, sh, "menu music   -   "..(SOG_MENU_MUSIC and "on" or "off"), "Numbers" ) 
	end
	b.DoClick = function( self )
		RunConsoleCommand("sog_menumusic", SOG_MENU_MUSIC and "0" or "1")
	end
	
	//cutscene music
	local b = Collumn:Add( "DButton" )
	b:SetSize( Collumn:GetWide(), 70)
	b:DockMargin( 0, 0, 0, 13)
	b:SetText( "" )
	b:Dock( TOP )
	b.OnCursorEntered = function( self )
		self.Overed = true
		desc.Text = "Enable or disable music in cutscenes."
	end
	b.OnCursorExited = function( self )
		self.Overed = false
		desc.Text = ""
	end
	b.Paint = function( self, sw, sh )
		TextPaint( self, sw, sh, "cutscene music   -   "..(SOG_CUTSCENE_MUSIC and "on" or "off"), "Numbers" ) 
	end
	b.DoClick = function( self )
		RunConsoleCommand("sog_cutscenemusic", SOG_CUTSCENE_MUSIC and "0" or "1")
	end
	
	local back = Collumn:Add( "DButton" )
	back:SetSize( Collumn:GetWide(), 70)
	back:DockMargin( 0, 0, 0, 13)
	back:SetText( "" )
	back:Dock( TOP )
	back.OnCursorEntered = function( self )
		self.Overed = true
	end
	back.OnCursorExited = function( self )
		self.Overed = false
	end
	back.Paint = function( self, sw, sh )
		TextPaint( self, sw, sh, "Back" )
	end
	back.DoClick = function( self )
		Collumn:Remove()
		desc:Remove()
		list:SetVisible( true )
	end
	
end

//cutscenes

local function Cutscenes( parent, list )
	
	list:SetVisible( false )
	
	local Collumn = parent:Add( "DPanel" )
	Collumn:SetSize( parent:GetWide(), parent:GetTall()/1.5 )
	Collumn:SetPos( parent:GetWide()/2 - Collumn:GetWide()/2, parent:GetTall()/2.5)
	Collumn.Paint = function() end
	
	local desc = parent:Add( "DPanel" )
	desc:SetSize( parent:GetWide(), 90 )
	desc.Text = ""
	desc:SetPos( 0, parent:GetTall()-90)
	desc.Paint = function( self, sw, sh) 
		TextPaint( self, sw, sh, self.Text or "", "NumbersSmall" ) 
	end
	
	//list
	local l = Collumn:Add( "DScrollPanel" )
	l:SetSize( Collumn:GetWide(), Collumn:GetTall()*0.6)
	l:DockMargin( 0, 0, 0, 13)
	l:Dock( TOP )
	
	for cv, cutscenes in pairs( GAMEMODE.Cutscenes ) do
		local cnt = 0
		local actual_cv = GetConVar( cv ):GetInt()
		for k=0, table.maxn( cutscenes ) do//for k, v in pairs( cutscenes ) do
			if !cutscenes[ k ] then continue end
			if actual_cv <= k then continue end
			
			cnt = cnt + 1
			
			local b = l:Add( "DButton" )
			b:SetSize( l:GetWide(), 50)
			b:DockMargin( 0, 0, 0, 5)
			b:SetText("")
			b:Dock( TOP )
			b.cnt = cnt
			
			b.OnCursorEntered = function( self )
				self.Overed = true
				desc.Text = ""
			end
			b.OnCursorExited = function( self )
				self.Overed = false
				desc.Text = ""
			end
			b.Paint = function( self, sw, sh )
				TextPaint( self, sw, sh, ( GAMEMODE.TranslateCutscenesReverse[cv] == "none" and "rdm" or GAMEMODE.TranslateCutscenesReverse[cv] ).."  "..self.cnt , "Numbers" ) 
			end
			b.DoClick = function( self )
				DrawCutscene( GAMEMODE.Cutscenes[ cv ][ k ])
			end
			
		end
	end
	
	
	local back = Collumn:Add( "DButton" )
	back:SetSize( Collumn:GetWide(), 70)
	back:DockMargin( 0, 0, 0, 13)
	back:SetText( "" )
	back:Dock( TOP )
	back.OnCursorEntered = function( self )
		self.Overed = true
	end
	back.OnCursorExited = function( self )
		self.Overed = false
	end
	back.Paint = function( self, sw, sh )
		TextPaint( self, sw, sh, "Back" )
	end
	back.DoClick = function( self )
		Collumn:Remove()
		desc:Remove()
		list:SetVisible( true )
	end
	
end


//actual options
local function Options( parent, list )
	
	list:SetVisible( false )
	
	local Collumn = parent:Add( "DPanel" )
	Collumn:SetSize( parent:GetWide(), parent:GetTall()/1.5 )
	Collumn:SetPos( parent:GetWide()/2 - Collumn:GetWide()/2, parent:GetTall()/2.5)
	Collumn.Paint = function() end
	
	local desc = parent:Add( "DPanel" )
	desc:SetSize( parent:GetWide(), 90 )
	desc.Text = ""
	desc:SetPos( 0, parent:GetTall()-90)
	desc.Paint = function( self, sw, sh) 
		TextPaint( self, sw, sh, self.Text or "", "NumbersSmall" ) 
	end
	
	local b = Collumn:Add( "DButton" )
	b:SetSize( Collumn:GetWide(), 60)
	b:DockMargin( 0, 0, 0, 10)
	b:SetText( "" )
	b:Dock( TOP )
	b.OnCursorEntered = function( self )
		self.Overed = true
		desc.Text = "Enable or disable view tilt."
	end
	b.OnCursorExited = function( self )
		self.Overed = false
		desc.Text = ""
	end
	b.Paint = function( self, sw, sh )
		TextPaint( self, sw, sh, "view tilt   -   "..(SOG_VIEW_TILT and "on" or "off"), "Numbers" ) 
	end
	b.DoClick = function( self )
		RunConsoleCommand("sog_viewtilt", SOG_VIEW_TILT and "0" or "1")
	end
	
	local b = Collumn:Add( "DButton" )
	b:SetSize( Collumn:GetWide(), 60)
	b:DockMargin( 0, 0, 0, 10)
	b:SetText( "" )
	b:Dock( TOP )
	b.OnCursorEntered = function( self )
		self.Overed = true
		desc.Text = "Increase via left click. Decrease via right click."
	end
	b.OnCursorExited = function( self )
		self.Overed = false
		desc.Text = ""
	end
	b.Paint = function( self, sw, sh )
		TextPaint( self, sw, sh, "corpse limit   -   "..tostring(SOG_MAX_CORPSES).."", "Numbers" ) 
	end
	b.DoClick = function( self )
		RunConsoleCommand("sog_maxcorpses", tostring( math.Clamp( SOG_MAX_CORPSES + 1, 0, 40) ))
	end
	b.DoRightClick = function( self )
		RunConsoleCommand("sog_maxcorpses", tostring( math.Clamp( SOG_MAX_CORPSES - 1, 0, 40) ))
	end	
	
	local b = Collumn:Add( "DButton" )
	b:SetSize( Collumn:GetWide(), 60)
	b:DockMargin( 0, 0, 0, 10)
	b:SetText( "" )
	b:Dock( TOP )
	b.OnCursorEntered = function( self )
		self.Overed = true
		desc.Text = "Enable or disable hud."
	end
	b.OnCursorExited = function( self )
		self.Overed = false
		desc.Text = ""
	end
	b.Paint = function( self, sw, sh )
		TextPaint( self, sw, sh, "ingame hud   -   "..(SOG_HUD and "on" or "off"), "Numbers" ) 
	end
	b.DoClick = function( self )
		RunConsoleCommand("sog_hud", SOG_HUD and "0" or "1")
	end
	
	local b = Collumn:Add( "DButton" )
	b:SetSize( Collumn:GetWide(), 60)
	b:DockMargin( 0, 0, 0, 10)
	b:SetText( "" )
	b:Dock( TOP )
	b.OnCursorEntered = function( self )
		self.Overed = true
		desc.Text = ""
	end
	b.OnCursorExited = function( self )
		self.Overed = false
		desc.Text = ""
	end
	b.Paint = function( self, sw, sh )
		TextPaint( self, sw, sh, "crosshair color   -   "..tostring(GAMEMODE.CrosshairColors[SOG_CROSSHAIR_COLOR] and GAMEMODE.CrosshairColors[SOG_CROSSHAIR_COLOR].name or "white").."", "Numbers" ) 
	end
	b.DoClick = function( self )
		local new = SOG_CROSSHAIR_COLOR + 1
		if new > #GAMEMODE.CrosshairColors then
			new = 1
		end
		RunConsoleCommand("sog_crosshair_color", tostring( math.Clamp( new, 1, #GAMEMODE.CrosshairColors) ))
	end
	b.DoRightClick = function( self )
		local new = SOG_CROSSHAIR_COLOR - 1
		if new < 1 then
			new = #GAMEMODE.CrosshairColors
		end
		RunConsoleCommand("sog_crosshair_color", tostring( math.Clamp( new, 1, #GAMEMODE.CrosshairColors) ))
	end	
	
	local b = Collumn:Add( "DButton" )
	b:SetSize( Collumn:GetWide(), 60)
	b:DockMargin( 0, 0, 0, 10)
	b:SetText( "" )
	b:Dock( TOP )
	b.OnCursorEntered = function( self )
		self.Overed = true
		desc.Text = ""
	end
	b.OnCursorExited = function( self )
		self.Overed = false
		desc.Text = ""
	end
	b.Paint = function( self, sw, sh )
		TextPaint( self, sw, sh, "music options", "Numbers" ) 
	end
	b.DoClick = function( self )
		//RunConsoleCommand("sog_viewtilt", util.tobool(GetConVarNumber("sog_viewtilt")) and "0" or "1")
		MusicOptions( parent, Collumn )
	end
	
	local back = Collumn:Add( "DButton" )
	back:SetSize( Collumn:GetWide(), 70)
	back:DockMargin( 0, 0, 0, 13)
	back:SetText( "" )
	back:Dock( TOP )
	back.OnCursorEntered = function( self )
		self.Overed = true
	end
	back.OnCursorExited = function( self )
		self.Overed = false
	end
	back.Paint = function( self, sw, sh )
		TextPaint( self, sw, sh, "Back" )
	end
	back.DoClick = function( self )
		Collumn:Remove()
		desc:Remove()
		list:SetVisible( true )
	end

	return Collumn
end

AddToMainMenu( "Options", Options )

local function Editor( parent, list )

	if GAMEMODE:GetGametype() ~= "none" then
		//we assume that it IS a singleplayer and a player IS an admin
		//so we change gametype to none, because this is how it works
		RunConsoleCommand( "admin_changelevel", tostring(game.GetMap()), "none")
		return
	end

	if game.SinglePlayer() and !EDITOR_TEST then
		parent:Remove()
		parent = nil
		RunConsoleCommand( "select_character", "0")
		RunConsoleCommand( "editor_open" )
		if IsValid( GAMEMODE.Music ) then
			GAMEMODE.Music:Stop()
		end
	end
	return
end

//hm
if game.SinglePlayer() and !EDITOR_TEST and !SINGLEPLAYER and !(EditorPanel and EditorPanel:IsValid()) and SOG_EDITOR_TEST then
	AddToMainMenu( "Editor", Editor )
end

local function AchievementList( parent, list )

	GAMEMODE:ReloadAchievements()
	
	list:SetVisible( false )
	
	local Collumn = parent:Add( "DPanel" )
	Collumn:SetSize( parent:GetWide(), parent:GetTall()/1.5 )
	Collumn:SetPos( parent:GetWide()/2 - Collumn:GetWide()/2, parent:GetTall()/2.5)
	Collumn.Paint = function() end
	
	local desc = parent:Add( "DPanel" )
	desc:SetSize( parent:GetWide(), 90 )
	desc.Text = ""
	desc:SetPos( 0, parent:GetTall()-90)
	desc.Paint = function( self, sw, sh) 
		TextPaint( self, sw, sh, self.Text or "", "NumbersSmall" ) 
	end
	
	local l = Collumn:Add( "DScrollPanel" )
	l:SetSize( Collumn:GetWide(), Collumn:GetTall()*0.6)
	l:DockMargin( 0, 0, 0, 13)
	l:Dock( TOP )
	
	for key, tbl in pairs( GAMEMODE.Achievements ) do
		local b = l:Add( "DButton" )
		b:SetSize( l:GetWide(), 50)
		b:DockMargin( 0, 0, 0, 5)
		b:SetText("")
		b:Dock( TOP )
			
		b.OnCursorEntered = function( self )
			self.Overed = true//GAMEMODE.PlayerAchievements[key] and true or false
			desc.Text = GAMEMODE.PlayerAchievements[key] and tbl.Desc or tbl.DescClosed
		end
		b.OnCursorExited = function( self )
			self.Overed = false
			desc.Text = ""
		end
		b.Paint = function( self, sw, sh )
			local status = GAMEMODE.PlayerAchievements[key] and "unlocked" or "locked"
			local text = tbl.Name.." - "..status
			TextPaint( self, sw, sh, text, "Numbers", GAMEMODE.PlayerAchievements[key] and Color( 220, 220, 220, 255) or Color( 80, 80, 80, 255) ) 
		end
		b.DoClick = function( self )
			
		end
	
	end	
	
	local back = Collumn:Add( "DButton" )
	back:SetSize( Collumn:GetWide(), 70)
	back:DockMargin( 0, 0, 0, 13)
	back:SetText( "" )
	back:Dock( TOP )
	back.OnCursorEntered = function( self )
		self.Overed = true
	end
	back.OnCursorExited = function( self )
		self.Overed = false
	end
	back.Paint = function( self, sw, sh )
		TextPaint( self, sw, sh, "Back" )
	end
	back.DoClick = function( self )
		Collumn:Remove()
		desc:Remove()
		list:SetVisible( true )
	end
	
end

local function Achievements( parent, list )
	
	//surface.PlaySound( "vo/engineer_no01.wav" )
	
	list:SetVisible( false )
	
	local Collumn = parent:Add( "DPanel" )
	Collumn:SetSize( parent:GetWide(), parent:GetTall()/1.5 )
	Collumn:SetPos( parent:GetWide()/2 - Collumn:GetWide()/2, parent:GetTall()/2.5)
	Collumn.Paint = function() end
	
	local desc = parent:Add( "DPanel" )
	desc:SetSize( parent:GetWide(), 90 )
	desc.Text = ""
	desc:SetPos( 0, parent:GetTall()-90)
	desc.Paint = function( self, sw, sh) 
		TextPaint( self, sw, sh, self.Text or "", "NumbersSmall" ) 
	end
		
	local b = Collumn:Add( "DButton" )
	b:SetSize( Collumn:GetWide(), 70)
	b:DockMargin( 0, 0, 0, 13)
	b:SetText( "" )
	b:Dock( TOP )
	b.OnCursorEntered = function( self )
		self.Overed = true
		desc.Text = ""
	end
	b.OnCursorExited = function( self )
		self.Overed = false
		desc.Text = ""
	end
	b.Paint = function( self, sw, sh )
		TextPaint( self, sw, sh, "cutscenes", "Numbers" ) 
	end
	b.DoClick = function( self )
		Cutscenes( parent, Collumn )
	end
	
	local b = Collumn:Add( "DButton" )
	b:SetSize( Collumn:GetWide(), 70)
	b:DockMargin( 0, 0, 0, 13)
	b:SetText( "" )
	b:Dock( TOP )
	b.OnCursorEntered = function( self )
		self.Overed = true
		desc.Text = ""
	end
	b.OnCursorExited = function( self )
		self.Overed = false
		desc.Text = ""
	end
	b.Paint = function( self, sw, sh )
		TextPaint( self, sw, sh, "achievements", "Numbers" ) 
	end
	b.DoClick = function( self )
		//Cutscenes( parent, Collumn )
		AchievementList( parent, Collumn )
	end
	
	local back = Collumn:Add( "DButton" )
	back:SetSize( Collumn:GetWide(), 70)
	back:DockMargin( 0, 0, 0, 13)
	back:SetText( "" )
	back:Dock( TOP )
	back.OnCursorEntered = function( self )
		self.Overed = true
	end
	back.OnCursorExited = function( self )
		self.Overed = false
	end
	back.Paint = function( self, sw, sh )
		TextPaint( self, sw, sh, "Back" )
	end
	back.DoClick = function( self )
		Collumn:Remove()
		desc:Remove()
		list:SetVisible( true )
	end

	return Collumn
	
end

AddToMainMenu( "Progress", Achievements )

local function Quit( parent, list )
	
	parent:Remove()
	parent = nil
	
	if EDITOR_TEST and SINGLEPLAYER then
		RunConsoleCommand( "editor_return" )
	else
		RunConsoleCommand( "disconnect" )
	end
	
	return 
end

AddToMainMenu( EDITOR_TEST and SINGLEPLAYER and "Back to Editor" or "Quit game", Quit )

-------------------------------------------------------------

local fake_click = 0

local replies = {
	
	[8] = { "James     ", "", "James", "", "         James. . ." },
	[9] = { "You     ", "        should", "have        ", "     stayed", "at home     ", "     today" },
	[10] = { "Now look   ", "        at", "what         ", "       you", "have     ", "          done. . ." },
	[11] = { "What    ", "         did you", "even expect       ", "      at the end", "of all this. . .    " },
	[12] = { "       a", "happy     ", "      end. . ." },
	[13] = { "or      ", "       another", "     boss fight", "with garry. . .      " },
	[14] = { "     there", "is nothing       ", "       left", "of gmod       ", "        now. . ." },
	[15] = { "", "", "nothing. . .", },
	[16] = { "", "", "but me. . .", },
}

local function fake_element( parent, list )

	if fake_click <= 4 then
		LocalPlayer():SetDSP( 0 )
		
		if GAMEMODE.Music then
			GAMEMODE.Music:SetTime( 0 )
		end
	end
	
	if fake_click == 5 then
		if GAMEMODE.Music then
			GAMEMODE.Music:Stop()
		end
		
		if SOG_MENU_MUSIC then
			GAMEMODE:CreateMusic( MUSIC_TYPE_NORMAL, 539756040, 60, true, 45000, nil, true )
		end
		
		GAMEMODE.GlitchTime = CurTime() + 2
		
		MenuElements[ 1 ][ 1 ] = "Stop game"
		MenuElements[ 2 ][ 1 ] = "Multiplayer mode"
		MenuElements[ 3 ][ 1 ] = "Shop"
		MenuElements[ 4 ][ 1 ] = "Browse dlcs"
		MenuElements[ 5 ][ 1 ] = "My account"
		MenuElements[ 6 ][ 1 ] = "Locked"
		
		parent:BuildMenu()
		
	end
	
	if fake_click == 6 then

		GAMEMODE.GlitchTime = CurTime() + 2
		
		MenuElements[ 1 ][ 1 ] = "quit game"
		MenuElements[ 2 ][ 1 ] = "quit game"
		MenuElements[ 3 ][ 1 ] = "quit game"
		MenuElements[ 4 ][ 1 ] = "quit game"
		MenuElements[ 5 ][ 1 ] = "quit game"
		MenuElements[ 6 ][ 1 ] = "quit game"
		
		parent:BuildMenu()
		
	end
	
	if fake_click == 7 then
		
		BLACK_AND_WHITE = true
	
		LocalPlayer():SetDSP( 38 ) 
		GAMEMODE.GlitchTime = CurTime() + 2
		LocalPlayer():EmitSound( "vo/citadel/br_laugh01.wav", 100, 60, 1 )

		if SOG_MENU_MUSIC then
			if GAMEMODE.Music then
				GAMEMODE.Music:Play()
			end
			//GAMEMODE:CreateMusic( MUSIC_TYPE_NORMAL, 539756040, 60, false, 45000, nil, true )
		end
		
		if parent.Background then
			parent.Background.TitleText = "Death of Gmod"
			parent.Background.OverrideCurWord = "your last"
			
			parent.Background.BW = true
			
			for i = 0, parent.Background.lines do
			
				//parent.Background.shittags[i] = " -------- | --------- | --------- | --------- | --------- | --------- | --------- | --------- | --------- | --------- | --------- | --------- | --------- |"
				parent.Background.shittags[i] = " Server is not responding | Server is not responding | Server is not responding | Server is not responding | Server is not responding | Server is not responding | Server is not responding | Server is not responding |"
			
			end
			
		end
		
		for k, v in pairs( MenuElements ) do
			MenuElements[ k ][ 1 ] = "-----------"
		end
		
		parent:BuildMenu()
		
	end
	
	if replies[ fake_click ] then
		for k, v in pairs( MenuElements ) do
			MenuElements[ k ][ 1 ] = replies[ fake_click ][ k ] or ""
		end
		parent:BuildMenu()
	end
	
	if fake_click == ( table.maxn( replies ) + 1 ) then
		
		//parent:Remove()
		//parent = nil
		if SCENE and SCENE.Order then
			RunConsoleCommand("sog_singleplayer_changelevel", tostring( SCENE.Order + 1 ) )
		end
		return
	end
	
	fake_click = fake_click + 1

end


function CallFakeMenu()
	
	if GAMEMODE.Ambient then
		GAMEMODE.Ambient:Stop()
	end
	
	if SCENE and SCENE.Name == "flashbacks" and SCENE.Order then
		if SOG_PROGRESS < ( SCENE.Order + 1 ) then
			RunConsoleCommand( "sog_progress", tostring( SCENE.Order + 1 ) )
		end
	end
	
	fake_click = 0
	
	for k, v in pairs( MenuElements ) do
		MenuElements[ k ] = nil
	end
	
	AddToMainMenu( "Start game", fake_element )
	AddToMainMenu( "Story Mode", fake_element )
	AddToMainMenu( "Options", fake_element )
	AddToMainMenu( "Editor", fake_element )
	AddToMainMenu( "Progress", fake_element )
	AddToMainMenu( "Quit game", fake_element )
	
	BLACK_AND_WHITE = false
	NORMAL_BACKGROUND = true
	
	DrawMenu( true, true )
	
	if MainMenu and MainMenu.Background then
		MainMenu.Background.ForceNormal = true
	end

end