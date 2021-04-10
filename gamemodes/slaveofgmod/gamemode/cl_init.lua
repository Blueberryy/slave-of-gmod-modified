include( 'shared.lua' )
include("sh_translate.lua")
include( "boneanimlib_v2/cl_boneanimlib.lua" )

include( "vgui/cl_charactermenu.lua" )
include( "vgui/cl_menubackground.lua" )
include( "vgui/cl_menu.lua" )
include( "vgui/cl_dialogue.lua" )
include( "vgui/cl_dream.lua" )
include( "vgui/cl_loading.lua" )
include( "vgui/cl_miscmenus.lua" )

//convars!
SOG_VIEW_TILT = util.tobool( CreateClientConVar("sog_viewtilt", 1, true, false):GetInt() )
cvars.AddChangeCallback("sog_viewtilt", function(cvar, oldvalue, newvalue)
	SOG_VIEW_TILT = util.tobool( newvalue )
end)

SOG_MAX_CORPSES = CreateClientConVar("sog_maxcorpses", 20, true, false):GetInt()
cvars.AddChangeCallback("sog_maxcorpses", function(cvar, oldvalue, newvalue)
	SOG_MAX_CORPSES = tonumber( newvalue )
end)

SOG_RADIO = util.tobool( CreateClientConVar("sog_radio", 1, true, false):GetInt() )
cvars.AddChangeCallback("sog_radio", function(cvar, oldvalue, newvalue)
	SOG_RADIO = util.tobool( newvalue )
end)

SOG_AUTOPLAY_MUSIC = util.tobool( CreateClientConVar("sog_autoplaymusic", 1, true, false):GetInt() )
cvars.AddChangeCallback("sog_autoplaymusic", function(cvar, oldvalue, newvalue)
	SOG_AUTOPLAY_MUSIC = util.tobool( newvalue )
end)

SOG_MENU_MUSIC = util.tobool( CreateClientConVar("sog_menumusic", 1, true, false):GetInt() )
cvars.AddChangeCallback("sog_menumusic", function(cvar, oldvalue, newvalue)
	SOG_MENU_MUSIC = util.tobool( newvalue )
end)

SOG_CUTSCENE_MUSIC = util.tobool( CreateClientConVar("sog_cutscenemusic", 1, true, false):GetInt() )
cvars.AddChangeCallback("sog_cutscenemusic", function(cvar, oldvalue, newvalue)
	SOG_CUTSCENE_MUSIC = util.tobool( newvalue )
end)

SOG_HUD = util.tobool( CreateClientConVar("sog_hud", 1, true, false):GetInt() )
cvars.AddChangeCallback("sog_hud", function(cvar, oldvalue, newvalue)
	SOG_HUD = util.tobool( newvalue )
end)

SOG_CROSSHAIR_COLOR = CreateClientConVar("sog_crosshair_color", 1, true, false):GetInt()
cvars.AddChangeCallback("sog_crosshair_color", function(cvar, oldvalue, newvalue)
	SOG_CROSSHAIR_COLOR = tonumber( newvalue )
end)

SOG_BEAT_STORY = util.tobool( CreateClientConVar("sog_beatstory", 0, true, false):GetInt() )
cvars.AddChangeCallback("sog_beatstory", function(cvar, oldvalue, newvalue)
	SOG_BEAT_STORY = util.tobool( newvalue )
end)


GM.Gametype = GetConVarString( "sog_gametype" ) or "none"

GM.MapCenter = {}
GM.MapCenter[ "sog_office_v6" ] = Vector(256, 576, 0)
GM.MapCenter[ "sog_garage_v1" ] = Vector(1301, -694, 0)

GM.CrosshairColors = {
	[1] = { name = "sog_crosshair_color_white", col = Color( 255, 255, 255, 250 ) },
	[2] = { name = "sog_crosshair_color_green", col = Color( 0, 255, 0, 250 ) },
	[3] = { name = "sog_crosshair_color_red", col = Color( 255, 0, 0, 250 ) },
	[4] = { name = "sog_crosshair_color_blue", col = Color( 0, 60, 255, 250 ) },
	[5] = { name = "sog_crosshair_color_yellow", col = Color( 255, 255, 0, 250 ) },
	[6] = { name = "sog_crosshair_color_orange", col = Color( 255, 127, 0, 250 ) },
	[7] = { name = "sog_crosshair_color_cyan", col = Color( 0, 255, 255, 250 ) },
}


GM.AvalaibleMaps = {}

local taking_screenshot

local curmap

local LAST_SONG = 38 //amount of tracks in playlist - 1

DRAW_NAMES = false

//for some things
DRAW_DISTANCE = 470

GM.GametypeName = "sog_gametype_name_rdm"

function GM:DrawGametypeName()
	self:AddHugeMessage( translate.Get(self.GametypeName), 6 )
end

local render = render
local surface = surface
local draw = draw
local cam = cam
local player = player
local ents = ents
local hook = hook
local util = util
local math = math
local string = string
local gui = gui

local Vector = Vector
local VectorRand = VectorRand
local Angle = Angle
local Entity = Entity
local Color = Color
local FrameTime = FrameTime
local RealTime = RealTime
local CurTime = CurTime
local EyePos = EyePos
local EyeAngles = EyeAngles
local pairs = pairs
local ipairs = ipairs
local IsValid = IsValid
local tostring = tostring
local tonumber = tonumber
local ScrW = ScrW
local ScrH = ScrH

local math_min = math.min
local math_max = math.max
local math_Clamp = math.Clamp
local math_Approach = math.Approach
local math_random = math.random
local math_Rand = math.Rand
local math_sin = math.sin
local math_cos = math.cos
local math_fmod = math.fmod
local math_abs = math.abs
local math_pi = math.pi
local math_rad = math.rad 
local math_Round = math.Round
local math_floor = math.floor
local gui_MouseX = gui.MouseX
local gui_MouseY = gui.MouseY
local gui_MousePos = gui.MousePos
local LerpVector = LerpVector

local translate = translate

local render_SetMaterial = render.SetMaterial
local render_RenderView = render.RenderView
local render_DrawQuadEasy = render.DrawQuadEasy

local surface_SetFont = surface.SetFont
local surface_DrawRect = surface.DrawRect
local surface_DrawOutlinedRect = surface.DrawOutlinedRect
local surface_GetTextSize = surface.GetTextSize
local surface_SetTextPos = surface.SetTextPos
local surface_SetTextColor = surface.SetTextColor
local surface_DrawText = surface.DrawText
local surface_DrawTexturedRectRotated = surface.DrawTexturedRectRotated
local surface_SetDrawColor = surface.SetDrawColor
local surface_SetMaterial = surface.SetMaterial
local surface_SetTexture = surface.SetTexture
local surface_CreateFont = surface.CreateFont
local surface_DrawLine = surface.DrawLine

local draw_SimpleText = draw.SimpleText
local draw_SimpleTextOutlined = draw.SimpleTextOutlined


local TEXT_ALIGN_CENTER = TEXT_ALIGN_CENTER
local TEXT_ALIGN_LEFT = TEXT_ALIGN_LEFT
local TEXT_ALIGN_RIGHT = TEXT_ALIGN_RIGHT
local TEXT_ALIGN_TOP = TEXT_ALIGN_TOP
local TEXT_ALIGN_BOTTOM = TEXT_ALIGN_BOTTOM

local vec_up = vector_up

local function NewScreenScale( size )
	return math_Clamp(ScrH() / 1080, 0.6, 1) * size
end

//some stuff from toolgun and wiki
function DrawScrollingText( text,texwide, speed, font, color, y )

		surface_SetFont( font )
		local w, h = surface_GetTextSize( text )
		
		local left = speed < 0
			
		local x = math_fmod( RealTime() * math_abs(speed), math_max(texwide,w) ) * ( left and -1 or 1);
				
		if left then
			
			while ( x < texwide) do

				surface_SetTextPos( x, y or 0 )
				surface_DrawText( text )

				x = x + w

			end
		else
						
			while ( x + math_max(w,texwide) > 0 ) do//
			
				surface_SetTextPos( x , y or 0 )
				surface_DrawText( text )
				
				x = x - w
			
			end
		end

end

function draw.ScrollingTextRotated( text, x, y, texwide, speed, color, font, ang, scale, nocenter )
	render.PushFilterMag( TEXFILTER.ANISOTROPIC )
	render.PushFilterMin( TEXFILTER.ANISOTROPIC )
	surface_SetFont( font )
	surface_SetTextColor( color )
	surface_SetTextPos( 0, 0 )
	local textWidth, textHeight = surface_GetTextSize( text )
	if scale then
		textWidth = textWidth * scale
		textHeight = textHeight * scale
	end
	local rad = -math_rad( ang )
	local halvedPi = math_pi / 2
	if not nocenter then
		x = x - ( math_sin( rad + halvedPi ) * math_min(textWidth,texwide) / 2 + math_sin( rad ) * textHeight / 2 )
		y = y - ( math_cos( rad + halvedPi ) * math_min(textWidth,texwide) / 2 + math_cos( rad ) * textHeight / 2 )
	end
	local m = Matrix()
	m:SetAngles( Angle( 0, ang, 0 ) )
	m:SetTranslation( Vector( x, y, 0 ) )
	if scale then
		m:Scale( Vector( scale, scale, 1 ) )
	end
	cam.PushModelMatrix( m )
		DrawScrollingText( text, texwide, speed, font, color )
	cam.PopModelMatrix()
	render.PopFilterMag()
	render.PopFilterMin()
end

function draw.TextRotated( text, x, y, color, font, ang, scale, outline )
	render.PushFilterMag( TEXFILTER.ANISOTROPIC )
	render.PushFilterMin( TEXFILTER.ANISOTROPIC )
	surface_SetFont( font )
	//surface_SetTextColor( color )
	//surface_SetTextPos( 0, 0 )
	local textWidth, textHeight = surface_GetTextSize( text )
	
	if scale then
		textWidth = textWidth * scale
		textHeight = textHeight * scale
	end
	local rad = -math_rad( ang )
	local halvedPi = math_pi / 2
	x = x - ( math_sin( rad + halvedPi ) * textWidth / 2 + math_sin( rad ) * textHeight / 2 ) - 20 * (scale or 1)
	y = y - ( math_cos( rad + halvedPi ) * textWidth / 2 + math_cos( rad ) * textHeight / 2 )
	local m = Matrix()
	m:SetAngles( Angle( 0, ang, 0 ) )
	m:SetTranslation( Vector( x, y, 0 ) )
	if scale then
		m:Scale( Vector( scale, scale, 1 ) )
	end
	cam.PushModelMatrix( m )
		//surface_DrawText( text )
		if outline then
			draw_SimpleTextOutlined( text, font, 20, 0, color, nil, nil, outline, color_black)
		else
			draw_SimpleText( text, font, 20, 0, color, nil, nil)
		end
	cam.PopModelMatrix()
	render.PopFilterMag()
	render.PopFilterMin()
end

function draw.ScaledText( text, x, y, color, font, scale, outline )
	render.PushFilterMag( TEXFILTER.ANISOTROPIC )
	render.PushFilterMin( TEXFILTER.ANISOTROPIC )
	surface_SetFont( font )
	local textWidth, textHeight = surface_GetTextSize( text )
	if scale then
		textWidth = textWidth * scale
		textHeight = textHeight * scale
	end
	x = x - textWidth/2 - 25*scale
	y = y - textHeight/2
	local m = Matrix()
	m:SetAngles( Angle( 0, 0, 0 ) )
	m:SetTranslation( Vector( x, y, 0 ) )
	if scale then
		m:Scale( Vector( scale, scale, 1 ) )
	end
	cam.PushModelMatrix( m )
		if outline then
			draw_SimpleTextOutlined( text, font, 25, 0, color, TEXT_ALIGN_LEFT, nil, 1, color_black)
		else
			draw_SimpleText( text, font, 25, 0, color, TEXT_ALIGN_LEFT, nil)
		end
	cam.PopModelMatrix()
	render.PopFilterMag()
	render.PopFilterMin()
end

function GM:Initialize( )

	//removing some unnessesary shit
	hook.Remove("RenderScreenspaceEffects", "RenderColorModify")
	hook.Remove("RenderScreenspaceEffects", "RenderBloom")
	hook.Remove("RenderScreenspaceEffects", "RenderToyTown")
	hook.Remove("RenderScreenspaceEffects", "RenderTexturize")
	hook.Remove("RenderScreenspaceEffects", "RenderSunbeams")
	hook.Remove("RenderScreenspaceEffects", "RenderSobel")
	hook.Remove("RenderScreenspaceEffects", "RenderSharpen")
	hook.Remove("RenderScreenspaceEffects", "RenderMaterialOverlay")
	hook.Remove("RenderScreenspaceEffects", "RenderMotionBlur")
	hook.Remove("RenderScene", "RenderStereoscopy")
	hook.Remove("RenderScene", "RenderSuperDoF")
	hook.Remove("GUIMousePressed", "SuperDOFMouseDown")
	hook.Remove("GUIMouseReleased", "SuperDOFMouseUp")
	hook.Remove("PreventScreenClicks", "SuperDOFPreventClicks")
	hook.Remove("PostRender", "RenderFrameBlend")
	hook.Remove("PreRender", "PreRenderFrameBlend")
	hook.Remove("Think", "DOFThink")
	hook.Remove("RenderScreenspaceEffects", "RenderBokeh")
	hook.Remove("NeedsDepthPass", "NeedsDepthPass_Bokeh")
	hook.Remove("PostDrawEffects", "RenderWidgets")
	hook.Remove("PostDrawEffects", "RenderHalos")
	hook.Remove("PlayerTick", "TickWidgets")
	hook.Remove("PostReloadToolsMenu", "BuildCleanupUI")
	hook.Remove("PostReloadToolsMenu", "BuildUndoUI")
	hook.Remove("PreDrawHalos", "PropertiesHover")
	
	



	surface_CreateFont( "NumbersBig",{font = "Super Retro M54", size = 63,weight = 500,antialias = true,extended = true})
	surface_CreateFont( "NumbersBigger",{font = "Super Retro M54", size = 53,weight = 500,antialias = true,extended = true})
	surface_CreateFont( "Numbers",{font = "Super Retro M54", size = 43,weight = 500,antialias = true,extended = true})
	surface_CreateFont( "NumbersSmaller",{font = "Super Retro M54", size = 38,weight = 500,antialias = true,extended = true})
	surface_CreateFont( "NumbersTimer",{font = "Super Retro M54", size = 33,weight = 500,antialias = true,extended = true})
	surface_CreateFont( "NumbersSmallerBold",{font = "Super Retro M54", size = 38,weight = 1000,antialias = true,extended = true})
	surface_CreateFont( "ScoreboardHeader",{font = "Super Retro M54", size = 28,weight = 500,antialias = true,extended = true})
	surface_CreateFont( "NumbersSmall",{font = "Super Retro M54", size = 30,weight = 500,antialias = true,extended = true})
	surface_CreateFont( "NumbersSmallest",{font = "Super Retro M54", size = 23,weight = 500,antialias = true,extended = true})
	surface_CreateFont( "NumbersTiny",{font = "Super Retro M54", size = 18,weight = 500,antialias = true,extended = true})
	//surface_CreateFont( "ComboMeter",{font = "WindCTT", size = 170, weight = 500,extended = true})
	surface_CreateFont( "ComboMeter",{font = "Bullet In Your Head", size = 170, weight = 500,extended = true})
	surface_CreateFont( "MenuHeaderOld",{font = "WindCTT", size = 220, weight = 500,extended = true})
	
	surface_CreateFont( "MenuHeader",{font = "Shoguns Clan_chr", size = 120, weight = 500,extended = true})
	surface_CreateFont( "HugeMessage",{font = "Shoguns Clan_chr", size = 190, weight = 500,extended = true})
	surface_CreateFont( "HugeMessageOutlined",{font = "Shoguns Clan_chr", size = 290, weight = 500, outline = true,antialias = true,extended = true})
	
	surface_CreateFont( "Scene",{font = "D3 Digitalism_chr", size = 50,weight = 500,antialias = true,extended = true})
	
	surface_CreateFont( "PixelObj",{font = "Minecraftia_fix", size = NewScreenScale( 35 ),weight = 1000,antialias = true,extended = true})
	surface_CreateFont( "PixelCutscene",{font = "Minecraftia_fix", size = 60,weight = 1000,antialias = true,extended = true})
	surface_CreateFont( "PixelCutsceneScaled",{font = "Minecraftia_fix", size = NewScreenScale( 60 ),weight = 1000,antialias = true,extended = true})
	surface_CreateFont( "PixelCutsceneBiggerScaled",{font = "Minecraftia_fix", size = NewScreenScale( 80 ),weight = 1000,antialias = true,extended = true})
	surface_CreateFont( "PixelCutsceneScaledSmall",{font = "Minecraftia_fix", size = NewScreenScale( 40 ),weight = 1000,antialias = true,extended = true})
	surface_CreateFont( "PixelSmall",{font = "Minecraftia_fix", size = 35,weight = 500,antialias = false,extended = true})
	surface_CreateFont( "PixelSmaller",{font = "Minecraftia_fix", size = 25,weight = 500,antialias = false,extended = true})

	GAMEMODE.ShowScoreboard = false
	
	curmap = game.GetMap()
	
	//since we dont have nice ways to change cursors
	self.CursorFix = vgui.Create( "EditablePanel" )//"DPanel"
	self.CursorFix:SetPos( 0, 0 )
	self.CursorFix:SetSize( ScrW(), ScrH() )
	if system.IsWindows() then
		self.CursorFix:SetCursor( "blank" )//"crosshair"
		self.CursorFix.Paint = function(s, tw, th) 
		
			if taking_screenshot then return end
			if self:GetFirstPerson() then return end
		
			local x, y = gui_MousePos()
			
			local gap = math_sin(RealTime()*3)*3 + 6
			local l = 8
			
			local col = GAMEMODE.CrosshairColors[ SOG_CROSSHAIR_COLOR ] and GAMEMODE.CrosshairColors[ SOG_CROSSHAIR_COLOR ].col or GAMEMODE.CrosshairColors[ 1 ].col
					
			surface_SetDrawColor( col.r, col.g, col.b, col.a )
			
			surface_DrawRect( x - gap - l, y - 1, l, 2 )
			surface_DrawRect( x + gap, y - 1, l, 2 )
			surface_DrawRect( x - 1, y - gap - l, 2, l )
			surface_DrawRect( x - 1, y + gap, 2, l )

			
			//return true 
		end
	else
		self.CursorFix:SetCursor( "crosshair" )
	end
	self.CursorFix.OnMousePressed = function( s, mc )
		if ( mc == MOUSE_LEFT ) then
			RunConsoleCommand( "+attack", "" )
			s.Pressed1 = true
		end
		
		if ( mc == MOUSE_RIGHT ) then
			RunConsoleCommand( "+attack2", "" )
			s.Pressed2 = true
		end
	end
	self.CursorFix.OnMouseReleased = function( s, mc )
		if ( mc == MOUSE_LEFT ) then
			RunConsoleCommand( "-attack", "" )
			s.Pressed1 = false
		end
		
		if ( mc == MOUSE_RIGHT ) then
			RunConsoleCommand( "-attack2", "" )
			s.Pressed2 = false
		end
	end
	self.CursorFix.OnMouseWheeled = function( s, delta )
		if delta > 0 then
			if IsValid( self.Music ) and !IsValid( self.SceneAmbient ) then
				self.Music:SetVolume( self.Music:GetVolume() + 0.03 )
			end
			/*if self.Radio and self.Radio:IsValid() and !( self.SceneAmbient and self.SceneAmbient:IsValid() ) then
				self.Radio:RunJavascript( "IncreaseVolume();" )
			end*/
		end
		
		if delta < 0 then		
			if IsValid( self.Music ) and !IsValid( self.SceneAmbient ) then
				self.Music:SetVolume( self.Music:GetVolume() - 0.03 )
			end
			/*if self.Radio and self.Radio:IsValid() and !( self.SceneAmbient and self.SceneAmbient:IsValid() ) then
				self.Radio:RunJavascript( "DecreaseVolume();" )
			end*/
		end
	end
	//lets hope it wont hurt too bad
	self.CursorFix.Think = function( s )
	
		if self:GetFirstPerson() then 
			gui.EnableScreenClicker( false )
			s:SetMouseInputEnabled( false ) 
		else
			gui.EnableScreenClicker( true )
		end
		
		if Dialogue and Dialogue:IsValid() then
			gui.EnableScreenClicker( true )
		end
		
		local me = LocalPlayer()
		
		s.NextClick = s.NextClick or 0
		
		if not me then return end
		if s.NextClick > CurTime() then return end
		
		if GAMEMODE.RadioEnabled then
			
			if IsValid( GAMEMODE.Music ) then
				if input.IsKeyDown( KEY_PAD_4  ) then
					GAMEMODE:SwitchTrack( -1 )
					s.NextClick = CurTime() + 0.3
				end
				
				if input.IsKeyDown( KEY_PAD_6  ) then
					GAMEMODE:SwitchTrack( 1 )
					s.NextClick = CurTime() + 0.3
				end
			end
			
		end
		/*if self.Radio and self.Radio:IsValid() then
		
			if input.IsKeyDown( KEY_PAD_4  ) then
				self.Radio:RunJavascript( "PrevTrack();" )
				s.NextClick = CurTime() + 0.3
			end
			
			if input.IsKeyDown( KEY_PAD_6  ) then
				self.Radio:RunJavascript( "NextTrack();" )
				s.NextClick = CurTime() + 0.3
			end
		
		end*/
		
	end
	
	if SOG_AUTOPLAY_MUSIC then
		self:MakeAmbient(82571975 , 90 )//126074994//137468020//89336670
	end
			
end

function GM:GetMotionBlurValues( horizontal, vertical, forward, rotational ) 
	if game.GetTimeScale() < 1 then
		local fwd = ( 1 - ( game.GetTimeScale() + 0.05 ) ) * 0.011
		return 0, 0, fwd, rotational
	end
	return 0, 0, 0, 0
end

//this is just to make sure that music wont break when game is paused in singleplayer
local real_music_playback = SCENE and SCENE.MusicPlayback or 1
local real_ambient_playback = SCENE and SCENE.AmbientPlayback or 1


local music_playback = SCENE and SCENE.MusicPlayback or 1
local ambient_playback = SCENE and SCENE.AmbientPlayback or 1
local level_clear_playback = 1
function GM:PreDrawHUD()
		
	//is escape menu open
	local paused = gui.IsGameUIVisible() or FrameTime() == 0
	
	if UPDATE_PLAYBACK then
		UPDATE_PLAYBACK = nil
		real_music_playback = SCENE and SCENE.MusicPlayback or 1
		real_ambient_playback = SCENE and SCENE.AmbientPlayback or 1
	end
	
	//new music shit
	if self.RadioEnabled then
		self:RadioThink()
	else
		if IsValid( self.Music ) then
			if self.MusicStartFrom and self.Music:GetTime() < self.MusicStartFrom then
				self.Music:SetTime( self.MusicStartFrom )
			end
			if self.MusicEndAt and self.Music:GetTime() >= self.MusicEndAt then
				self.Music:SetTime( self.MusicStartFrom or 0 )
			end
			
			--if game.GetTimeScale() ~= 1 then
				--music_playback = math.Approach( music_playback, paused and 0.01 or real_music_playback * math.max( 0.9, game.GetTimeScale() ), RealFrameTime() * 0.8 )
			--else
				music_playback = math_Approach( music_playback, paused and 0.01 or real_music_playback, RealFrameTime() * ( PLAYBACK_APPROACH or 2 ) )
			--end
			
			
			if self.Music:GetPlaybackRate() ~= music_playback then
				self.Music:SetPlaybackRate( music_playback )
			end
			
			if MUSIC_SYNC then
				self:GetFFT( self.Music )
			end
			
		end
		if IsValid( self.SceneAmbient ) then
			if self.SceneAmbientStartFrom and self.SceneAmbient:GetTime() < self.SceneAmbientStartFrom then
				self.SceneAmbient:SetTime( self.SceneAmbientStartFrom )
			end
			if self.SceneAmbientEndAt and self.SceneAmbient:GetTime() >= self.SceneAmbientEndAt then
				self.SceneAmbient:SetTime( self.SceneAmbientStartFrom or 0 )
			end
			
			ambient_playback = math_Approach( ambient_playback, paused and 0.01 or real_ambient_playback, RealFrameTime() * 2 )
			
			if self.SceneAmbient:GetPlaybackRate() ~= ambient_playback then
				self.SceneAmbient:SetPlaybackRate( ambient_playback )
			end
			
		end
		if IsValid( self.Ambient ) then			
			level_clear_playback = math_Approach( level_clear_playback, paused and 0.01 or 1, RealFrameTime() * 2 )
			
			if self.Ambient:GetPlaybackRate() ~= level_clear_playback then
				self.Ambient:SetPlaybackRate( level_clear_playback )
			end
			
		end
	end
	
end

function GM:Think()
	
	if IsValid( LocalPlayer() ) and not LocalPlayer().fake_bodies then
		LocalPlayer().fake_bodies = {}
		LocalPlayer().fake_bodies_sliced = {}
		LocalPlayer().gibs = {}
		//LocalPlayer():SetLOD( 0 )
	end
		
	if self.OnThink then
		self:OnThink()
	end
	
end



local ignorez = false
function GM:PreDrawEffects( ) 

end

function GM:PostDrawEffects( ) 

end

local mat_refract = Material( "effects/strider_pinch_dudv" )

function GM:DrawPlayerName( pl )
	
	if !DRAW_NAMES then return end
	
	local MySelf = LocalPlayer()
	
	if pl and pl:Alive() and MySelf and pl ~= MySelf and pl:Team() == MySelf:Team() and !pl.HideWeapon then
	
		local pos = pl:GetPos() + vec_up * 10
		local angle = Angle(0,90 * (MySelf:FlipView() and -1 or 1),0)
		
		surface_SetFont( "PixelSmall" )
		
		local text = pl.Name and pl:Name() or "ERROR!"
		local tw, th = surface_GetTextSize( text )
		
		cam.Start3D2D(pos,angle,0.37)
			surface_SetDrawColor( 10, 10, 10, 55 )
			surface_DrawRect( -(tw+16)/2, 55, tw+16, th+3 )
			draw.DrawText(text, "PixelSmall", 0, 55, Color(210, 210, 210, 205),TEXT_ALIGN_CENTER)
		cam.End3D2D()

	end
	
end


local slice = false
local blend = false
local bounds_min = Vector(-360,-360,0)
local bounds_max = Vector(360,360,360)
local mat_test = Material( "sprites/sent_ball" )
function GM:PrePlayerDraw( pl )

	
	if pl.ClientsideScale and pl.ClientsideScale ~= 1 then
		if pl:GetModelScale() ~= pl.ClientsideScale then
			pl:SetModelScale( pl.ClientsideScale, 0 )
		end
	end
	
	if not pl._changedLOD then
		pl:SetLOD( 0 )
		pl._changedLOD = true
	end
	
	if pl.ent_bodywear and IsValid( pl.ent_bodywear ) then
		local bone = pl:LookupBone( "ValveBiped.Bip01_Head1" )
		if bone then
			local pos, ang = pl:GetBonePosition( bone )
			if pos and ang then
				slice = true
				render.EnableClipping( true )
				render.PushCustomClipPlane( vec_up, vec_up:Dot( pos + vec_up*1.5 ) )
			end
		end
	end
	
	if self.OnPrePlayerDraw then
		self:OnPrePlayerDraw( pl )
		return
	end
		
	pl:SetRenderBounds(bounds_min,bounds_max)

	if not self:GetFirstPerson() then
	
		local dlight = DynamicLight( pl:EntIndex() )
		if ( dlight ) then
			local size = pl:KeyDown( IN_ATTACK ) and 60 or 50
			dlight.Pos = pl:GetPos()+vec_up*2
			dlight.r = 255
			dlight.g = 255
			dlight.b = 255
			dlight.Brightness = 3.5
			dlight.Size = size
			dlight.Decay = size * 1
			dlight.DieTime = CurTime() + 1
			dlight.Style = 0
			dlight.NoModel = true
		end
	end
	
	if pl:GetCharTable().HideOriginalModel then
		render.SetBlend(0)
		blend = true
	end

end

function GM:PostPlayerDraw( pl )
	
	if slice then
		render.PopCustomClipPlane()
		render.EnableClipping( false )
		
		slice = false
	end
	
	if blend then
		render.SetBlend( 1 )
		//pl:SetRenderMode( RENDERMODE_NORMAL  ) 
		blend = false
	end
	
	self:DrawPlayerName( pl )
	
	self:HandleSCKModels( pl )
	
	if pl:GetCharTable().PostPlayerDraw then
		pl:GetCharTable():PostPlayerDraw( pl )
	end
	

	if self.OnPostPlayerDraw then
		self:OnPostPlayerDraw( pl )
		return 
	end

end

local zero_vec = Vector( 0, 0, 0 )
local zero_ang = Angle( 0, 0, 0 )

function GM:DrawSCKModels( pl )
	
	local owner = pl
		if !IsValid(owner) then return end
		
		if (!pl.WElements) then return end
		
		if (!pl.wRenderOrder) then

			pl.wRenderOrder = {}

			for k, v in pairs( pl.WElements ) do
				if (v.type == "Model") then
					table.insert(pl.wRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(pl.wRenderOrder, k)
				end
			end
			
			for k, v in pairs( pl.WElements ) do
				if (v.type == "ClipPlane") then
					table.insert(pl.wRenderOrder, 1, k)
				end
			end

		end
		
		bone_ent = pl.GetRagdollEntity and IsValid( pl:GetRagdollEntity() ) and pl:GetRagdollEntity() or pl

		if !IsValid(bone_ent) then return end
		
		for i = 1, #pl.wRenderOrder do
			
			local name = pl.wRenderOrder[ i ]
			local v = pl.WElements[name]
			if (!v) then pl.wRenderOrder = nil break end
			
			local pos, ang
			
			if (v.bone) then
				pos, ang = self:GetBoneOrientation( pl.WElements, v, bone_ent )
			else
				pos, ang = self:GetBoneOrientation( pl.WElements, v, bone_ent, "ValveBiped.Bip01_R_Hand" )
			end
			
			if (!pos) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			
			if (v.type == "Model" and IsValid(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )

				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				

				local size = (v.size.x + v.size.y + v.size.z)/3
				model:SetAngles(ang)
				
				if v.fix_scale then
					local matrix = Matrix()
					matrix:Scale(v.size)
					model:EnableMatrix( "RenderMultiply", matrix )
				else
					if model:GetModelScale() ~= size then
						model:SetModelScale(size,0)
					end
				end
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				
				//model:SetupBones()
				
				if model.clipplane_pos and model.clipplane_ang then				
					local clip_pos, clip_ang = model.clipplane_pos, model.clipplane_ang
				
					render.EnableClipping( true )
					render.PushCustomClipPlane( clip_ang:Up(), clip_ang:Up():Dot( clip_pos ) )
				end
						
				
				model:DrawModel()
				
				if model.clipplane_pos and model.clipplane_ang then
					render.PopCustomClipPlane()
					render.EnableClipping( false )
				end
				
				
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render_SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( pl )
				cam.End3D2D()
				
			elseif (v.type == "ClipPlane" and v.rel) then
				
				local mdl = pl.WElements[ v.rel ] and IsValid( pl.WElements[ v.rel ].modelEnt ) and pl.WElements[ v.rel ].modelEnt
				
				if mdl then//and not mdl.clipplane then
					
					local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
					ang:RotateAroundAxis(ang:Up(), v.angle.y)
					ang:RotateAroundAxis(ang:Right(), v.angle.p)
					ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
					mdl.clipplane_pos = drawpos
					mdl.clipplane_ang = ang
				
				end

			end
			
		end
	
end

function GM:GetBoneOrientation( basetab, tab, ent, bone_override )
		
		local bone, pos, ang
		if (tab.rel and tab.rel != "") then
			
			local v = basetab[tab.rel]
			
			if (!v) then return end

			pos, ang = self:GetBoneOrientation( basetab, v, ent )
			
			if (!pos) then return end
			
			pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
		else
		
			if tab.cached_bone then
				bone = tab.cached_bone
			else
				bone = ent:LookupBone(bone_override or tab.bone)
				tab.cached_bone = bone
			end

			if (!bone) then return end
			
			pos, ang = zero_vec, zero_ang//Vector(0,0,0), Angle(0,0,0)
			local m = ent:GetBoneMatrix(bone)
			if (m) then
				pos, ang = m:GetTranslation(), m:GetAngles()
			end
		
		end
		
	return pos, ang
end

function GM:CreateSCKModels( pl, tab )

		if (!tab) then return end

		for k, v in pairs( tab ) do
			if (v.type == "Model" and v.model and v.model != "" and (!IsValid(v.modelEnt) or v.createdModel != v.model) and 
					string.find(v.model, ".mdl") and file.Exists (v.model,"GAME") ) then
				
				v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)
				if (IsValid(v.modelEnt)) then
					v.modelEnt:SetPos(pl:GetPos())
					v.modelEnt:SetAngles(pl:GetAngles())
					v.modelEnt:SetParent(pl)
					v.modelEnt:SetNoDraw(true)
					v.modelEnt:DrawShadow( false )
					v.createdModel = v.model
										
					if v.seq then
						v.modelEnt:SetSequence( v.modelEnt:LookupSequence( v.seq ) )
					end
					
					if v.bbp then
						v.modelEnt:AddCallback("BuildBonePositions", v.bbp )
					end
					
					if v.bonemerge then
						//v.modelEnt:AddEffects(EF_BONEMERGE)
					end
					
					if v.sub_mat then
						for ind, mat in pairs( v.sub_mat ) do
							v.modelEnt:SetSubMaterial( ind, mat )
						end
					end
					
				else
					v.modelEnt = nil
				end
				
			elseif (v.type == "Sprite" and v.sprite and v.sprite != "" and (!v.spriteMaterial or v.createdSprite != v.sprite) 
				and file.Exists ("materials/"..v.sprite..".vmt","GAME")) then
				
				local name = v.sprite.."-"
				local params = { ["$basetexture"] = v.sprite }
				// make sure we create a unique name based on the selected options
				local tocheck = { "nocull", "additive", "vertexalpha", "vertexcolor", "ignorez" }
				for i, j in pairs( tocheck ) do
					if (v[j]) then
						params["$"..j] = 1
						name = name.."1"
					else
						name = name.."0"
					end
				end

				v.createdSprite = v.sprite
				v.spriteMaterial = CreateMaterial(name,"UnlitGeneric",params)
				
			end
		end
		
	end


function GM:RemoveSCKModels( pl )
	if (pl.WElements) then
		for k, v in pairs( pl.WElements ) do
			if (IsValid( v.modelEnt )) then v.modelEnt:Remove() end
		end
	end
	pl.WElements = nil
end

function GM:HandleSCKModels( pl )
	
	if pl:GetCharTable().WElements and not pl.WElements then
		pl.WElements = table.Copy( pl:GetCharTable().WElements )
		self:CreateSCKModels( pl, pl.WElements )
		pl.AllowSCKRender = true
		return
	end
	
	if pl.WElements and pl.AllowSCKRender then
		self:DrawSCKModels( pl )
	end
	
	
end

function GM:CreateClientsideRagdoll( ent, rag )

	if !ent.GetRagdollEntity then
		ent.GetRagdollEntity = function() return rag end
	end

end

local vec_64 = Vector(0, 0, 64)
local rot_vec1 = Vector(0, 0, 1)
local rot_vec2 = Vector(1, 1, 0)
function GM:CreateMove( cmd )

	local MySelf = LocalPlayer()
	
	if ( not MySelf:Alive() ) then return end
	if self:GetFirstPerson() then return end

	local plyPos = ( MySelf:GetPos() + vec_64 ):ToScreen()
	local plyvec = Vector( ScrW()/2, ScrH()/2 )//Vector( plyPos.x, plyPos.y, 0 )
	
	local pos = Vector( gui.MouseX(), gui.MouseY(), 0 )
	local angle = ( pos-plyvec ):Angle()
	
	//print(plyPos.x, plyPos.y)
	
	if MySelf:FlipView() then
		angle:RotateAroundAxis( rot_vec1, 180 )
		angle:RotateAroundAxis( rot_vec2, 90 )
	else
		angle:RotateAroundAxis( rot_vec2, 90 )
	end
	
	local charge = IsValid( MySelf:GetActiveWeapon() ) and MySelf:GetActiveWeapon() and MySelf:GetActiveWeapon().IsChargeAttacking and MySelf:GetActiveWeapon():IsChargeAttacking()
	
	if !IsValid( MySelf.Execution ) and !IsValid( MySelf.HumanShield ) and !charge then
		cmd:SetViewAngles( Angle(0, angle.y, 0) )
	end
	
	
end


local grad = surface.GetTextureID( "gui/gradient" )

function drawstripes ( x, y , bw, bh, am, spacing, left )
	
	local w, h = ScrW(), ScrH()
	local wholeh = bh * am + spacing * ( am - 1 )
	
	surface_SetTexture(grad)
	surface_SetDrawColor(0, 0, 0, 135)
	
	local step = 0
	
	for i = 1, am do
		
		surface_DrawTexturedRectRotated( x, y - wholeh/2 + bh/2 + step, bw, bh, left and 0 or 180)
		
		step = step + bh + spacing
		
	end
	
end

function GM:GetRoundTime()
	return Entity( 0 ):GetDTFloat( 0 ) or 0
end

function GM:DrawGlitch()
	
	if self.CaptureTime and self.CaptureTime > CurTime() then
		render.CapturePixels() 
	end
	
	local a = 255
	
	if self.GlitchTime and self.GlitchTime > CurTime() then
		a = 255 * math_Clamp( self.GlitchTime - CurTime(), 0, 1 )
	end
		
	for i = 1, math_random( 10, 250 ) do
		
		local x = math_random( 0, ScrW() )
		local y = math_random( 0, ScrH() )
		
		local r,g,b = render.ReadPixel( x, y )
		
		surface_SetDrawColor( r, g, b, a )
		local sz_x, sz_y = math_random( 10, 130 ), math_random( 1, 12 )
		surface_DrawRect( x - sz_x / 2, y - sz_y / 2, sz_x, sz_y )
		
	end
	
end

function GM:DrawOverlay() 	
	if self.GlitchTime and self.GlitchTime > CurTime() then
		-- apparently if you take screenshot during render.CapturePixels - it will just crash your game
		-- we dont want that, right? so lets take first few frames so post process has time to kick in
		if not self.CaptureTime then
			self.CaptureTime = CurTime() + 0.05
		end
		
		self:DrawGlitch()
	else
		if self.CaptureTime then
			self.CaptureTime = nil
		end
	end
	
end

local currentpoints = 0

local curweppos = -400
local goalweppos = -400

local col_shadow = Color( 10, 10, 10, 185)
local col_darkred = Color( 220, 220, 220, 255)

function GM:HUDPaint()
	
	local w, h = ScrW(), ScrH()
	local MySelf = LocalPlayer()
	
	if MySelf:Team() == TEAM_SPECTATOR then return end
	if SCENE and SCENE.DisableDefaultHUD then 
		self:DrawArrows()
		return 
	end
	
	if taking_screenshot then return end
	
	self:DrawScoreMessages()
	self:DrawComboMeter()
	
	if !SOG_HUD then return end
	
	self:DrawArrows()
	self:DrawDeathHUD()
	self:DrawHugeMessage()
	

	
	local x, y = w - 60, 70
	local bw, bh = 400, 7
	local spacing = 3
	
	local am = 6
	
	drawstripes( w - bw/2, y , bw, bh, am, spacing, false )

	local points = MySelf:GetScore()
	
	currentpoints = points == 0 and 0 or math_Round(math_Approach( currentpoints, points, RealFrameTime() * 3500))

	local text = translate.Format("sog_hud_x_points", currentpoints)
	
	local shift = math_sin(RealTime()*3)*2 + 5
	local shift_reverse = math_cos(RealTime()*3)*2 + 5
	
	draw_SimpleText( text, "Numbers", x + 3, y + 3, col_shadow, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	draw_SimpleText( text, "Numbers", x, y, Color( 97 + shift_reverse*10, 0, 27, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER) //Color( 97, 0, 27, 255)
	draw_SimpleText( text, "Numbers", x - shift, y - shift, col_darkred , TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	
	//todo: merge it
	if USE_TIME_LIMIT then
		y = y + 60
		
		//small nice timer
		
		local actual_time = math_Round((self:GetRoundTime() or 0) + ROUND_PLAY_TIME - CurTime())
		
		local time = string.FormattedTime(actual_time)//, "%02i:%02i"
		
		time = actual_time >= 0 and (time.m..". "..(time.s < 10 and "0" or "")..time.s) or "overtime"
		
		local timew = 2*bw/3
		
		drawstripes( w - timew/2, y , timew, bh-2, 5, spacing, false )
		
		draw_SimpleText( time, "NumbersTimer", x + 3, y + 3, col_shadow, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		draw_SimpleText( time, "NumbersTimer", x, y, Color( 97 + shift_reverse*10, 0, 27, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		draw_SimpleText( time, "NumbersTimer", x - shift, y - shift, col_darkred, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	end
	
	if self.DrawAdditionalInfo and self:DrawAdditionalInfo() then
		y = y + 60
		
		local text = self:DrawAdditionalInfo() or ""
		
		local timew = 2*bw/3
		
		drawstripes( w - timew/2, y , timew, bh-2, 5, spacing, false )
		
		draw_SimpleText( text, "NumbersTimer", x + 3, y + 3, col_shadow, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		draw_SimpleText( text, "NumbersTimer", x, y, Color( 97 + shift_reverse*10, 0, 27, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		draw_SimpleText( text, "NumbersTimer", x - shift, y - shift, col_darkred, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
	end
	
	local buddy = MySelf:GetBuddy()
	local buddy_wep = IsValid(buddy) and IsValid(buddy:GetDTEntity( 0 )) and buddy:GetDTEntity( 0 )
	
	local wep = buddy_wep or IsValid(MySelf:GetActiveWeapon()) and MySelf:GetActiveWeapon()
	
	local text = translate.Get("sog_hud_no_gun")
	
	if not wep or wep and wep.Primary.ClipSize == -1 then 
		text = translate.Get("sog_hud_no_gun")
		goalweppos = -400
	else
		local clip = buddy_wep and buddy:GetDTInt( 2 ) or wep:Clip1()
		text = clip > 0 and translate.Format("sog_hud_x_rnd", clip)..(clip == 1 and "" or translate.Get("sog_hud_x_rnds")) or translate.Get("sog_hud_empty")
		/*if wep.MaxReloads and wep.Reloads and MySelf:GetCharTable().AllowReloads then
			local clips = wep.MaxReloads - wep.Reloads
			
			text = text.."  "..( clips > 0 and ( translate.Format("sog_hud_x_clips", clips) ) or "" )
		end*/
				
		if wep.GetReloads and MySelf:GetCharTable().AllowReload and wep.Akimbo then
			local clips = 1 - wep:GetReloads()
			
			if wep.Akimbo then
				clips = clips * 2
			end
			
			text = text.."    "..( clips > 0 and ( translate.Format("sog_hud_x_clips", clips) ) or "" )
		end
		
		if wep.OverrideAmmoText then
			text = wep.OverrideAmmoText
		end
		
		goalweppos = 0
	end 
	
	if HUD_MESSAGE and MySelf:Alive() then
		text = HUD_MESSAGE
		goalweppos = 0
	end
	
	if HUD_MESSAGE and !MySelf:Alive() then
		HUD_MESSAGE = nil
	end
	
	if curweppos ~= goalweppos then
		curweppos = math_Approach( curweppos, goalweppos, RealFrameTime() * 700 )
	end
	
	x, y = 60 + curweppos , h - 70
	
	drawstripes( bw/2 + curweppos, y , bw, bh, am, spacing, true )
	
	draw_SimpleText( text, "Numbers", x + 3, y + 3, col_shadow, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	draw_SimpleText( text, "Numbers", x, y, Color( 97 + shift*10, 0, 27, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	draw_SimpleText( text, "Numbers", x - shift, y - shift, col_darkred, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	
	//on top!
	self:DrawGoal()
	
	/*if self.Music and self.Music:IsValid() then
		local val, val_smooth, val_max = self:GetFFT( self.Music )
		
		if val_smooth then
			
			for i=1, 128 do
			
				local delta = math.Clamp( val_smooth[i] / math.max( 0.001, val_max[i] ), 0, 1 )
			
				draw.RoundedBox( 0, 30 + ( i * 10 ) + ( (i-1) * 4 ), 30, 10, 300, Color( i * 2, 100, 100, 55 ) ) 
				draw.RoundedBox( 0, 30 + ( i * 10 ) + ( (i-1) * 4 ), 30, 10, 300 * delta, Color( i * 2, 100, 100, 255 ) ) 
				
				draw_SimpleText( i, "Default", 30 + ( i * 10 ) + ( (i-1) * 4 ), 30, col_shadow, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end
		
		end
		
	end*/

end



//what a mess
local ren = {}
local override_ren = {}
local trace2 = {mask = MASK_SHOT,mins = Vector(-16,-16,0), maxs = Vector(16, 16, 50)}
local trace3 = {mask = MASK_SOLID_BRUSHONLY,mins = Vector(-6,-6,0), maxs = Vector(6, 6, 0)}
local zfar = 0
local renderpos = vector_origin
local look_dist = 0
local look_vec = vector_origin
local rot = 0

//for small view shake
local view_shake = 0
local view_shake_goal = 0
local view_shake_time = 0
local view_shake_duration = 1

local vector_origin = vector_origin

function GM:ShakeView( amount, duration )
	view_shake = amount
	view_shake_time = CurTime() + (duration or 0.1)
	view_shake_duration = duration or 0.1
end


local def_pos = Vector( 16000, 16000, 16000)
local flip_ang = Angle(90, 0, 0)
local norm_ang = Angle(90, 0, 180)
local dev_mat = Material( "dev/reflectivity_30" )

-- todo: add more of these
GM.WorldMaterials = {
	[1] = Material( "dev/reflectivity_30" ),
}




function GM:RenderScene(  )
		
		if self:GetFirstPerson() then return false end
		
		//local look = vector_origin
		local shake = vector_origin
		
		local look_goal = 0
		
		local w, h = ScrW(), ScrH()
		local MySelf = LocalPlayer():GetObserverTarget()
		if !IsValid( MySelf ) then MySelf = LocalPlayer() end

		local RealMySelf = LocalPlayer()
		
		if !IsValid(MySelf) then return true end
		
		if not curmap then
			curmap = game.GetMap()
		end
		
		if self.MapCenter[ curmap ] and SOG_VIEW_TILT then//curmap
		
			local mapX, mapY = self.MapCenter[ curmap ].x, self.MapCenter[ curmap ].y
			local mypos = MySelf:GetPos()
			local myX, myY = mypos.x, mypos.y
			
			local target = 0
			
			if myY < mapY and myX > mapX then
				target = -1.5
			end
			if myY > mapY and myX < mapX then
				target = -1.5
			end
			if myY > mapY and myX > mapX then
				target = 1.5
			end
			if myY < mapY and myX < mapX then
				target = 1.5
			end
			
			local dist1 = Vector(myX,0,0):Distance( Vector(mapX,0,0) )
			local dist2 = Vector(0,myY,0):Distance( Vector(0,mapY,0) )
			local dist = math_min(dist1,dist2)
			
			local mul = math_Clamp(dist/2100,0,1)
			
			local torotate = mul * (dist > 300 and target or 0)
			
			rot = math_Approach( rot, torotate, RealFrameTime() * ( 1.5 + mul ))
		else
			rot = 0
		end
		
		if view_shake ~= 0 and view_shake_time < CurTime() then
			view_shake = 0
		else
			local delta = math_Clamp( ( view_shake_time - CurTime() ) / view_shake_duration, 0, 1 )
			local r = VectorRand() * math_Rand( view_shake / 3 * delta, view_shake * delta )//math.Rand( -view_shake, view_shake )
			r.z = 0
			shake = r
		end
				
		if MySelf and MySelf.KeyDown and MySelf:IsPlayer() and MySelf:KeyDown( IN_SPEED ) and MySelf:Team() ~= TEAM_MOB and RealMySelf:Alive() then
			local tomiddle = Vector(gui_MouseX()-w/2,gui_MouseY()-h/2,0):LengthSqr()
			look_goal = math_Clamp(tomiddle, 0, 62500) //250 * 250
			look_goal = ( look_goal / 62500 ) * 250
		end
		
		look_dist = look_goal
		
		look_vec = LerpVector( 0.03, look_vec, MySelf:GetAimVector() * look_dist )

		local height = 240
		local size = 1210
				
		if not MySelf.origin then
			MySelf.origin = MySelf:GetPos()
		end
				
		if dialoguepos and MySelf.origin.x < 15900 then
			MySelf.origin = LerpVector( RealFrameTime()*5, MySelf.origin, dialoguepos )
		else
			//smooth this stuff when dialogue is closing
			if Dialogue and Dialogue:IsValid() and MySelf.origin.x < 15900 then
				MySelf.origin = LerpVector( RealFrameTime()*7, MySelf.origin, MySelf:GetPos() )
			else
				MySelf.origin = MySelf:GetPos()
			end
		end
		
		local scale = 3.9

		ren.x = 0
		ren.y = 0
		ren.w = w
		ren.h = h
		ren.ortho = true
		ren.ortholeft = override_ren.left or -w/scale
		ren.orthobottom = override_ren.bottom or h/scale
		ren.orthoright = override_ren.right or w/scale
		ren.orthotop = override_ren.top or -h/scale
		//ren.origin = (dialoguepos or MySelf:GetPos())+vec_up*size + look + shake
		ren.origin = MySelf.origin + vec_up * size + look_vec + shake
		renderpos = ren.origin
		
		ren.drawviewmodel = false
		
		//ren.angles = RealMySelf:FlipView() and Angle(90, 0, 0 + rot) or Angle(90, 0, 180 + rot)
		
		flip_ang.r = rot
		norm_ang.r = 180 + rot
		
		ren.angles = RealMySelf:FlipView() and flip_ang or norm_ang
		ren.drawhud = override_ren.drawhud or true
		ren.dopostprocess = true
		ren.drawmonitors = false
		ren.znear = 0//size - MySelf.RenderZ
		ren.zfar = size*1.4//size+(tr2.HitSky and size or 132)
		
		zfar = ren.zfar
		
		if DISABLE_RENDER then return true end
		
		if WORLD_OVERRIDE_MAT then render.WorldMaterialOverride( WORLD_OVERRIDE_MAT ) end
		//PrintTable(ren)
		render_RenderView( ren )
		if WORLD_OVERRIDE_MAT then render.WorldMaterialOverride() end
		
		return true

end

local shrink = false

local normal_ang = Angle(0,0,0)
local flip_ang = Angle(0,180,0)

local firstperson_z
local spine_z
function GM:CalcView( pl, origin, angles, fov, znear, zfar )

	if self:GetFirstPerson() then
	
		local bone = pl:LookupBone("ValveBiped.Bip01_Head1")
		if bone then
			if !shrink then
				pl:ManipulateBoneScale( bone, vector_origin  )
				pl:ManipulateBoneScale( bone, vector_origin  )
				pl:ManipulateBoneScale( bone, vector_origin  )
				shrink = true
			end
			if shrink and pl:GetManipulateBoneScale(bone) ~= vector_origin then
				pl:ManipulateBoneScale( bone, vector_origin  )
			end
		end
		
		local rag = pl:GetRagdollEntity()
		
		if !pl:Alive() and IsValid( rag ) then
			local att = rag:GetAttachment( rag:LookupAttachment("eyes") )
			if att then
				return { origin = att.Pos + att.Ang:Forward() * 1, angles = angles, znear = 1, zfar = zfar }
			end
		end
		
		local att = pl:GetAttachment( pl:LookupAttachment("eyes") )
		if att then
			local new_ang = angles
			local new_pos = att.Pos + att.Ang:Forward() * 0.1 - att.Ang:Up() * 1.7
			
			
			if IsValid( pl.Knockdown ) or IsValid( pl.Execution ) then
				new_ang = att.Ang
			else
				/*if not firstperson_z then
					firstperson_z = new_pos.z * 1
				end
				if math.abs( firstperson_z - new_pos.z ) > 3 then
					firstperson_z = new_pos.z * 1
				end
				new_pos.z = firstperson_z * 1
				
				local bone = pl:LookupBone("ValveBiped.Bip01_Spine4")
				if bone then
					local pos, ang = pl:GetBonePosition( bone )
					if pos and ang then
						
						if not spine_z then
							spine_z = pos.z
						end
						
						if math.abs( spine_z - pos.z ) > 5 then
							spine_z = pos.z
						end
						
						local override_spine_pos = pos * 1
						override_spine_pos.z = spine_z * 1

						//pl:SetBonePosition( bone, override_spine_pos, ang )
						
					end
				end*/
				
			end
			
			return { origin = new_pos, angles = new_ang, drawviewer = true, fov = fov + fov * 0.11, znear = 1, zfar = zfar }
		end
	
	else
		if shrink then
			local bone = pl:LookupBone("ValveBiped.Bip01_Head1")
			if bone then
				pl:ManipulateBoneScale( bone, Vector(1,1,1)  )
				pl:ManipulateBoneScale( bone, Vector(1,1,1)  )
				pl:ManipulateBoneScale( bone, Vector(1,1,1)  )
			end
			shrink = false
		end
	end
	
	if pl:FlipView() then
		angles = normal_ang * 1
	else
		angles = flip_ang * 1
	end

	return self.BaseClass.CalcView(self, pl, origin, angles, fov, znear, zfar)
end

local mat = Material( "sog/bg_gradient3.png", "smooth" )
local mat2 = Material( "vgui/gradient-d" )

local colormul = 1
local timemul = 1//1.1//0.48
local flashtime = 0

local next_thunder = 10
local next_riot = 0
local thunder_flash = 0
local thunder = {}

/*for i = 1, 4 do
	util.PrecacheSound( "ambient/atmosphere/thunder"..i..".wav" )
	thunder[i] = "ambient/atmosphere/thunder"..i..".wav"
end*/

for i = 1, 3 do
	util.PrecacheSound( "ambient/thunder/hm2_lightning"..i..".wav" )
	thunder[i] = "ambient/thunder/hm2_lightning"..i..".wav"
end

local terror_screams = {
	Sound( "ambient/creatures/town_child_scream1.wav" ),
	Sound( "ambient/creatures/town_muffled_cry1.wav" ),
	Sound( "ambient/creatures/town_scared_breathing1.wav" ),
	Sound( "ambient/creatures/town_scared_breathing2.wav" ),
	Sound( "ambient/creatures/town_scared_sob1.wav" ),
	Sound( "ambient/creatures/town_scared_sob2.wav" ),
	Sound( "npc/zombie_poison/pz_call1.wav" ),
}

local riot_sounds = {
	Sound( "ambient/levels/streetwar/city_riot1.wav" ),
	Sound( "ambient/levels/streetwar/city_riot2.wav" ),
}

local first_snd = true

function GM:CheckThunder()
	if Cut and Cut:IsValid() then return end
	
	/*if SCREAMS and next_riot <= CurTime() and not LEVELCLEAR then
		local r = first_snd and "ambient/levels/streetwar/city_riot1.wav" or riot_sounds[math.random(#riot_sounds)]
		surface.PlaySound( r )
		next_riot = CurTime() + SoundDuration( r ) * 0.8
		first_snd = false
	end*/
	
	if next_thunder <= CurTime() then
		local t = thunder[math_random(#thunder)]
		LocalPlayer():EmitSound( t, 150, math_random(85,105), 1, CHAN_STATIC )
		
		if TERROR and math_random(5) == 5 then
			LocalPlayer():EmitSound( terror_screams[ math_random( #terror_screams ) ], 75, math_random(80,105), 0.5, CHAN_STATIC )
		end
		
		flashtime = CurTime() + math_Rand(0.5,0.75)
		thunder_flash = flashtime
		GAMEMODE:ShakeView( math_random(4,5), SoundDuration( t )/math_Rand(3,4) )
		
		local override_next = math_random(10,25)
		
		if self:GetFirstPerson() then
			util.ScreenShake( LocalPlayer():GetPos(), math.random( 6, 9 ), 0.5, SoundDuration( t )/math_Rand(3,4), 1000 )
			 
			if SCENE and SCENE.Name == "scene_name_return_end" then
				local e = EffectData()
					e:SetOrigin( Vector( -911.946350, -57.817841, -7068.935059 ) )
				util.Effect( "dev_lightning", e )
				
				override_next = math_random( 5, 9 )
				
				if Credits then override_next = 99999 end
			end
			 
		end
		
		if math_random(7) == 7 then
			next_thunder = CurTime() + math_random(1,2)
		else
			next_thunder = CurTime() + override_next
		end
	end
end

 local tab = {}
	tab[ "$pp_colour_addr" ] = 0
	tab[ "$pp_colour_addg" ] = 0
	tab[ "$pp_colour_addb" ] = 0
	tab[ "$pp_colour_brightness" ] = 0
	tab[ "$pp_colour_contrast" ] = 1
	tab[ "$pp_colour_colour" ] = 1
	tab[ "$pp_colour_mulr" ] = 0
	tab[ "$pp_colour_mulg" ] = 0
    tab[ "$pp_colour_mulb" ] = 0
 

function GM:GetGametype()
	return self.Gametype or "none"
end

MUSIC_SYNC = SCENE and SCENE.MusicSync
local fake_realtime = 0
GM.MusicSyncCount = 0
local fake_realtime_tick = 0

GM.MusicRefract = {}//0
GM.MusicCurRefract = {}//16

local mat_wave = Material( "effects/splashwake4" )
local mat_music_line = Material( "effects/laser1" )

function GM:CreateVisualizer()
	
	if self.MusicVisualizer then return end

	local gw, gh = ScrW(), ScrH()
	
	self.MusicVisualizer = self.CursorFix:Add( "DPanel" )
	self.MusicVisualizer:SetKeyboardInputEnabled( false )
	self.MusicVisualizer:SetMouseInputEnabled( false ) 
	self.MusicVisualizer:SetSize( gw, gh )
	self.MusicVisualizer:SetPos( -gw/2, -gh/2 )
	
	self.MusicVisualizer:SetPaintedManually( true )
	self.MusicVisualizer.SendColor = function( panel, r, g, b )
		panel.col_r = r
		panel.col_g = g
		panel.col_b = b
	end
	
	
	self.MusicVisualizer.Paint = function( panel, pw, ph, extra )
		
		if self.Music and self.Music:IsValid() and !IsValid( Cut ) then //and self.MusicStarted 
		
			local r = panel.col_r or 255
			local g = panel.col_g or 255
			local b = panel.col_b or 255
		
			if self.MusicRefract then
			
				for k, v in pairs( self.MusicRefract ) do
					if v.delete then
						self.MusicRefract[k] = nil
						continue
					end
				end
				
				surface_SetMaterial( mat_wave )
				
				
				for k, v in pairs( self.MusicRefract ) do
					if v then
						if v.refr < 1 then
							v.refr = v.refr + FrameTime() * 1
							v.cur_refr = ph * 1.2 * v.refr ^ 0.7
							
							surface_SetDrawColor( Color( r + 70, g, b + 70, 45 * ( 1 - v.refr ) ) )
							surface_DrawTexturedRectRotated( pw/2, ph/2, v.cur_refr, pw, 90 ) 
						else
							self.MusicRefract[k].delete = true
						end
					end
				
				end
			end
			
			
			local val, val_smooth, val_max = self.MusicRawFFT, self.MusicFFTSmooth, self.MusicFFTMax
		
			if val and val_smooth and val_max then
			
				local bits = 84

				local beam_pos_x, beam_pos_y = 0, ph/2
				local last_delta = 0
				
				local pow = 0
				local split = pw / bits
				
				for i=1, bits do //128
				
					if i <= bits / 2 then
						pow = pow + 1.5
					else
						pow = pow - 1.5
					end
				
					local delta = math_Clamp( val_smooth[i] / math_max( 0.001, val_max[i] ), 0, 1 ) * ( 0.2 + pow/( bits/2 ) )
					
					surface_SetDrawColor( Color( r + 70, g+70, b + 70, 125 ) )
					
					local rand = math_random( -split * 0.1, split * 0.1 )
					
					//big one
					surface_DrawLine( beam_pos_x + split * ( i - 1 ) + rand, beam_pos_y - last_delta * 200, beam_pos_x + split * i + rand, beam_pos_y - delta * 200 )
					surface_DrawLine( beam_pos_x + split * ( i - 1 ) + rand, beam_pos_y + last_delta * 200, beam_pos_x + split * i + rand, beam_pos_y + delta * 200 )
					
					surface_SetDrawColor( Color( r + 50, g+50, b + 50, 115 ) )
					
					//small one
					surface_DrawLine( beam_pos_x + split * ( i - 1 ), beam_pos_y - last_delta * 100, beam_pos_x + split * i, beam_pos_y - delta * 100 )
					surface_DrawLine( beam_pos_x + split * ( i - 1 ), beam_pos_y + last_delta * 100, beam_pos_x + split * i, beam_pos_y + delta * 100 )
					
					surface_DrawLine( beam_pos_x + split * ( i - 1 ), beam_pos_y + last_delta * 100, beam_pos_x + split * i, beam_pos_y - delta * 100 )
					
					surface_SetDrawColor( Color( r + 40, g+40, b + 40, 75 ) )
					
					surface_DrawLine( beam_pos_x + split * ( i - 1 ) + rand, beam_pos_y - last_delta * 150, beam_pos_x + split * i + rand, beam_pos_y - delta * 150 )
					surface_DrawLine( beam_pos_x + split * ( i - 1 ) + rand, beam_pos_y + last_delta * 150, beam_pos_x + split * i + rand, beam_pos_y + delta * 150 )
					
					surface_DrawLine( beam_pos_x + split * ( i - 1 ) + rand, beam_pos_y - last_delta * 30, beam_pos_x + split * i + rand, beam_pos_y - delta * 30 )
					surface_DrawLine( beam_pos_x + split * ( i - 1 ) + rand, beam_pos_y + last_delta * 30, beam_pos_x + split * i + rand, beam_pos_y + delta * 30 )
					
					
					--surface_DrawLine( beam_pos_x + split * i, beam_pos_y, beam_pos_x + split * i, beam_pos_y + delta * 100 )
					
					last_delta = delta
				end
				
				--surface_SetDrawColor( Color( r + 70, g+70, b + 70, 115 ) )
				--surface_DrawLine( 0, ph/2, pw, ph/2 )

			
			end
			
		end

	end

end

local light_pos = Vector( -1012, -2428, 1 )

local spooky_mat = CreateMaterial( "spooky_background", "UnlitGeneric", {
	["$basetexture"] = "skybox/starfield", 
	["$vertexcolor"] = 1, 
	["$vertexalpha"] = 1, 
	["$nolod"] = 1,
} )
function GM:PreDrawTranslucentRenderables( depth, skybox )

	local w, h = ScrW(), ScrH()
	
	local realtime = RealTime()

	local flash = flashtime > CurTime()
	local beat = false
	
	if self.BeatTime and self.BeatTime >= CurTime() then
		beat = true
	end
	
	
	timemul = 1
	
	if beat then
		self.MusicSyncCount = self.MusicSyncCount + 0.07
	end
	
	if flash and not BLACK_BLOOD then
		timemul = 17
	end	
	
	if MUSIC_SYNC then	
		//timemul = beat and 4 or 0
		//realtime = realtime + self.MusicSyncCount * 0.1
		self:CreateVisualizer()
	end	
	
	if MUSIC_SYNC then
	
		if game.GetMap() == "sog_horsebang" and SCENE and SCENE.Name == "scene_name_this_is_fine" and self.MusicStarted then
			
			local glob_sin = math_sin( RealTime() * 0.7 )
			local radius = 250 + glob_sin * 50
			
			for i=0, 4 do
				
				local sin = math_sin( ( CurTime() * 0.4 + self.MusicSyncCount * 0.9 + math_rad( 72 * i ) ) * -1 )
				local cos = math_cos( ( CurTime() * 0.4 + self.MusicSyncCount * 0.9 + math_rad( 72 * i ) ) * -1 )
				
				local dlight = DynamicLight( 1000 * ( i + 1 )  )
				if ( dlight ) then
					local size = 260 + glob_sin * 35
					dlight.Pos = light_pos + Vector( 1, 0, 0 ) * sin * radius + Vector( 0, 1, 0 ) * cos * radius
					dlight.r = 218 - glob_sin * 15
					dlight.g = 0
					dlight.b = 218 - glob_sin * 15
					dlight.Brightness = 4.5
					dlight.Size = size
					dlight.Decay = size * 1
					dlight.DieTime = CurTime() + 0.1
					dlight.Style = 0
					dlight.nomodel = true
				end
				
				
			end
			
			
			

		end
	
	
		local r1 = 0.5 * math_sin(realtime*timemul)*60 + 60/2 + 10
		local g = 0
		local b1 = 0.5 * math_sin(realtime*timemul)*60 + 60/2 + 10
		
		local r2 = 0.5 * math_cos(realtime*timemul)*60 + 60/2 + 10
		local b2 = 0.5 * math_cos(realtime*timemul)*60 + 60/2 + 10
		
		local MySelf = LocalPlayer()
			
		//local mul = flash and 0.9 or 0.8
		local mul = flash and 2 or 1//0.8
		
		local add_width = math_sin(realtime*timemul)*5
		local add_a = 0
				
		if self.MusicStarted and ( self.MusicStarted + 2 ) > CurTime() then
			local delta = math_Clamp( ( self.MusicStarted + 2 - CurTime() )/ 2, 0, 1 )
			add_width = 90 * delta
			add_a = 130 * delta
			r1 = 300 * delta
			b1 = 300 * delta
			r2 = 300 * delta
			b2 = 300 * delta
		end
		
			
		tab[ "$pp_colour_mulr" ] = r1/60 * mul
		tab[ "$pp_colour_mulb" ] = b1/60 * mul
		
		tab[ "$pp_colour_colour" ] = 1.1
		tab[ "$pp_colour_brightness" ] = -0.01
			
		local pos = IsValid( MySelf:GetObserverTarget() ) and MySelf:GetObserverTarget():GetPos()
		if not pos then
			pos = MySelf:GetPos()
		end
			
		if renderpos then
			pos.x = renderpos.x
			pos.y = renderpos.y
		end
		
		

		render_SetMaterial( mat )
		render_DrawQuadEasy( pos - vec_up*131, vec_up, w*1.8, h, Color( r1+math_random(0,2), g+math_random(0,2), b1+math_random(0,2), 120 + add_a), MySelf:FlipView() and 0 or 180 )
		render_DrawQuadEasy( pos - vec_up*131, vec_up, w*1.8, h, Color( r2+math_random(0,2), g+math_random(0,2), b2+math_random(0,2), 120 + add_a), MySelf:FlipView() and 180 or 0 )
		
		
		if self.Music and self.Music:IsValid() then //and self.MusicStarted 
		
			if self.MusicVisualizer and self.MusicVisualizer:IsValid() then
				self.MusicVisualizer:SendColor( r1, g, b1 )
				cam.Start3D2D( pos - vec_up*131,  Angle( 0, 90, 0 ), NewScreenScale( 0.85 ) )//
					self.MusicVisualizer:PaintManual()
				cam.End3D2D()
				
				
			end
		
			/*local val, val_smooth, val_max = self.MusicRawFFT, self.MusicFFTSmooth, self.MusicFFTMax
		
			if val and val_smooth and val_max then
			
				local interval = 10//w / 228 //7
				
				
				
				render_SetMaterial( mat_music_line )
				
				render.StartBeam( 128 ) 
				
				local beam_pos = pos - vec_up*135

				local pow = 0
				
				for i=1, 128 do
				
					if i <= 42 then
						pow = pow + 1
					else
						pow = pow - 1
					end
				
					local delta = math.Clamp( val_smooth[i] / math.max( 0.001, val_max[i] ), 0, 1 ) * ( 0.2 + pow/42 )
					
					render.AddBeam( beam_pos + Vector( -200 * delta, i * interval - 42 * interval, 0 ), 15 + add_width, 1, Color( r1 + 30, g+30, b1 + 30, 65 ) ) 
				end
				
				render.EndBeam()
				
				render_SetMaterial( mat_music_line )
				
				render.StartBeam( 128 ) 
				
				
				//render_SetMaterial( mat_music_line )
				
				pow = 0
				
				for i=1, 128 do
				
					if i <= 42 then
						pow = pow + 1
					else
						pow = pow - 1
					end
				
					local delta = math.Clamp( val_smooth[i] / math.max( 0.001, val_max[i] ), 0, 1 ) * ( 0.2 + pow/42 )
					
					render.AddBeam( beam_pos + Vector( -100 * ( delta ^ 1.1 ), i * interval - 42 * interval, 0 ), 10 + add_width *-1, 1, Color( r1 + 20, g+20, b1 + 20, 25 ) ) 
				end
				
				render.EndBeam()
				
				
				///////////
				
				pow = 0
				
				render_SetMaterial( mat_music_line )
				
				render.StartBeam( 128 ) 
				
				local beam_pos = pos - vec_up*125
				
				render_SetMaterial( mat_music_line )
				
				for i=1, 128 do
				
					if i <= 42 then
						pow = pow + 1
					else
						pow = pow - 1
					end
				
					local delta = math.Clamp( val_smooth[i] / math.max( 0.001, val_max[i] ), 0, 1 ) * ( 0.2 + pow/42 )
					
					render.AddBeam( beam_pos + Vector( 200 * delta, i * interval - 42 * interval, 0 ), 15 + add_width, 1, Color( r1 + 30, g+30, b1 + 30, 65 ) ) 
				end
				
				render.EndBeam()
				
				pow = 0
				
				render_SetMaterial( mat_music_line )
				
				render.StartBeam( 128 ) 
				
				local beam_pos = pos - vec_up*125
				
				render_SetMaterial( mat_music_line )
				
				for i=1, 128 do
				
					if i <= 42 then
						pow = pow + 1
					else
						pow = pow - 1
					end
				
					local delta = math.Clamp( val_smooth[i] / math.max( 0.001, val_max[i] ), 0, 1 ) * ( 0.2 + pow/42 )
					
					render.AddBeam( beam_pos + Vector( 100 * ( delta ^ 1.1 ), i * interval - 42 * interval, 0 ), 10 + add_width*-1, 1, Color( r1 + 20, g+20, b1 + 20, 25 ) ) 
				end
				
				render.EndBeam()
			
			end
			
			if self.MusicRefract then
			
				for k, v in pairs( self.MusicRefract ) do
					if v.delete then
						self.MusicRefract[k] = nil
						continue
					end
				end
				
				for k, v in pairs( self.MusicRefract ) do
					if v then
						if v.refr < 1 then
							v.refr = v.refr + FrameTime() * 1
							v.cur_refr = h * 1.2 * v.refr ^ 0.7
								
							local MySelf = LocalPlayer()
							local pos = IsValid( MySelf:GetObserverTarget() ) and MySelf:GetObserverTarget():GetPos() or MySelf:GetPos()

							render_SetMaterial( mat_wave )
							render_DrawQuadEasy( pos - vec_up*125, Vector(0, 0, 1), v.cur_refr, h , Color( r1 + 70, g, b1 + 70, 25 * ( 1 - v.refr ) ), 90 )
						else
							self.MusicRefract[k].delete = true
						end
					end
				
				end
			

			end*/
			
		end
		
		
	else
	
		if !THUNDER_BACKGROUND then
		
			local r = 0.5 * math_sin(realtime*timemul)*255 + 255/2
			local g = -0.5 * math_sin(realtime*timemul)*255 + 255/2
			local b = 210

			if flash then
				g = g * math_Rand(0.5,1)
				b = b * math_Rand(0.5,1)
			end
			
			local MySelf = LocalPlayer()
			
			local mul = flash and 0.6 or 0.5
			
			tab[ "$pp_colour_mulr" ] = r/255 * ( mul + 0.3 )
			tab[ "$pp_colour_mulg" ] = g/255 * mul
			tab[ "$pp_colour_mulb" ] = b/255 * mul
			
			local pos = IsValid( MySelf:GetObserverTarget() ) and MySelf:GetObserverTarget():GetPos()
			if not pos then
				pos = MySelf:GetPos()
			end
			
			if renderpos then
				pos.x = renderpos.x
				pos.y = renderpos.y
			end
			
			if beat then
				//b = b * 1.3
			end
			
			if BLACK_BLOOD or SCENE and SCENE.SpookyBackground then
				render_SetMaterial( spooky_mat )
				render_DrawQuadEasy( pos - vec_up*131, vec_up, w*1.3, w*1.3, Color( 255, 255, 255, 250), RealTime() * 0.4 + 180 )
				render_DrawQuadEasy( pos - vec_up*132, vec_up, w*1.3, w*1.3, Color( 255, 255, 255, 150), -1 * RealTime() * 0.2 )
			else
				render_SetMaterial( mat )
				render_DrawQuadEasy( pos - vec_up*131, vec_up, w*1.3, h, Color( r+math_random(0,2), g+math_random(0,2), b+math_random(0,2), 70), MySelf:FlipView() and 0 or 180 )//70
			end

		else
			
			timemul = 1	
			
			if flash then
				if thunder_flash == flashtime then
					timemul = 70
				else
					timemul = 20
				end
			end
			
			if taking_screenshot then timemul = 0 end
		
			local mul = flash and thunder_flash ~= flashtime and 0.7 or 0//flash and 0.8 or 0
		
			local r = 0.5*math_sin(realtime*timemul)*205 + 205/2 + 30
			local g = 30
			local b = 30
			
			local a1 = 0.5*math_sin(realtime*timemul)*155 + 155/2 + 30
			local a2 = 0.5*math_cos(realtime*timemul)*155 + 155/2 + 30
					
			local MySelf = LocalPlayer()
			
			if flash and thunder_flash == flashtime then
				r = r * 1.5
				g = r/4//g * math_Rand(0.5,1)
				b = r/4//b * math_Rand(0.5,1)
			end
			
			tab[ "$pp_colour_mulr" ] = r/255 * mul
			
			//tab[ "$pp_colour_brightness" ] = -0.03
			
			if TERROR then
				r = r/( flash and thunder_flash == flashtime and 1.5 or 2.5 )
			end
			
			if TERROR then
				r = math_max( r, 50 )
				a1 = math_max( a1, 140 )
				a2 = math_max( a2, 190 )
			end
			
			local pos = IsValid( MySelf:GetObserverTarget() ) and MySelf:GetObserverTarget():GetPos()
			if not pos then
				pos = MySelf:GetPos()
			end
			
			if renderpos then
				pos.x = renderpos.x
				pos.y = renderpos.y
			end
			
			if BLACK_BLOOD or SCENE and SCENE.SpookyBackground then
				render_SetMaterial( spooky_mat )
				render_DrawQuadEasy( pos - vec_up*131, vec_up, w*1.3, w*1.3, Color( 255, 255, 255, 250), RealTime() * 0.4 + 180 )
				render_DrawQuadEasy( pos - vec_up*132, vec_up, w*1.3, w*1.3, Color( 255, 255, 255, 150), -1 * RealTime() * 0.2 )
			else
				render_SetMaterial( mat )
				render_DrawQuadEasy( pos - vec_up*331, vec_up, w*1.8, h, Color( r, g, b, a1), MySelf:FlipView() and 0 or 180 )//131
				render_DrawQuadEasy( pos - vec_up*331, vec_up, w*1.8, h, Color( r, g, b, a2), MySelf:FlipView() and 180 or 0 )
			end
			
		end
	end
		
	if NIGHTMARE then
		tab[ "$pp_colour_colour" ] = 0.05
	end
	
	//overrides nightmare
	if DRUG_EFFECT then
		tab[ "$pp_colour_colour" ] = -1.3
	end
	
	//overrides everything (kinda)
	if TERROR then
		tab[ "$pp_colour_brightness" ] = game.GetMap() == "sog_business_v1" and -0.05 or -0.1
		tab[ "$pp_colour_contrast" ] = game.GetMap() == "sog_business_v1" and 1.2 or 1.8
		tab[ "$pp_colour_colour" ] = 1
		tab[ "$pp_colour_mulg" ] = 0.06
		tab[ "$pp_colour_mulb" ] = 0.36
		tab[ "$pp_colour_mulr" ] = 0
		tab[ "$pp_colour_addb" ] = 0
		tab[ "$pp_colour_addg" ] = 0
	end
	
	//ultimate combo
	if NIGHTMARE and DRUG_EFFECT and TERROR then
		tab[ "$pp_colour_addr" ] = 0
		tab[ "$pp_colour_addg" ] = 0
		tab[ "$pp_colour_addb" ] = 0
		tab[ "$pp_colour_brightness" ] = -0.15
		tab[ "$pp_colour_contrast" ] = 1
		tab[ "$pp_colour_colour" ] = 0.7
		tab[ "$pp_colour_mulr" ] = 0.5
		tab[ "$pp_colour_mulg" ] = 0
		tab[ "$pp_colour_mulb" ] = 0
	end
	
	if self.GlitchTime and self.GlitchTime > CurTime() then
		tab[ "$pp_colour_colour" ] = 1 - math_Clamp( self.GlitchTime - CurTime(), 0, 1 )
		tab[ "$pp_colour_mulr" ] = 0
		tab[ "$pp_colour_mulg" ] = 0
		tab[ "$pp_colour_mulb" ] = 0
	end

	
end

function GM:PreDrawOpaqueRenderables()
	if DRUG_EFFECT then
		local pl = LocalPlayer()
		if not pl.drug_pos then pl.drug_pos = pl:GetPos() end
		
		if pl.drug_pos.x < 15900 and pl:Alive() then
			pl.drug_pos = LerpVector( FrameTime()*20, pl.drug_pos, pl:GetPos() )
		else
			pl.drug_pos = pl:GetPos()
		end
		
		local add = ( pl:GetVelocity():LengthSqr()/ ( pl:GetMaxSpeed() * pl:GetMaxSpeed() ) ) * 0.02
		mat_refract:SetFloat("$refractamount", ( 0.01 - math_sin( RealTime() * 0.6 ) * 0.02 + add  ) * (LocalPlayer():FlipView() and -1 or 1 ))
		render_SetMaterial( mat_refract )
		render.UpdateRefractTexture()
		render_DrawQuadEasy( pl.drug_pos - vec_up*131, vec_up, ScrW(), ScrW(), Color( 255, 255, 255, 10 ) )
	end
end

function GM:RenderScreenspaceEffects()

	if drawingplayer then
		tab[ "$pp_colour_colour" ] = 0
		tab[ "$pp_colour_mulr" ] = 0
		tab[ "$pp_colour_mulg" ] = 0
		tab[ "$pp_colour_mulb" ] = 0
		
		DrawColorModify( tab )
		
	else

		DrawColorModify( tab )
	end
	
	if TERROR and not DRUG_EFFECT and game.GetMap() ~= "sog_business_v1" then
		DrawBloom( 0.94, 2.85, 9.49, 12.73, 5, 1.7, 0.3, 0.1, 0 ) 
	end
	
	if render.SupportsPixelShaders_2_0() and game.GetMap() == "sog_horsebang" and SCENE and SCENE.Name == "scene_name_this_is_fine" and self.MusicStarted then
		local vec = Vector( -1019, -2434, 64 )
		//local power = math_Clamp( 1 - math_Clamp( vec:Distance( LocalPlayer():GetPos() ), 0, 300 ) / 300, 0, 1 ) * 0.2
		local power = math_Clamp( 1 - math_Clamp( vec:DistToSqr( LocalPlayer():GetPos() ), 0, 90000 ) / 90000, 0, 1 ) * 0.2
		
		if power > 0 then
			DrawSunbeams( 0.4, 0 + power, 10, 0.5, 0.5 )
		end
		
	end
	
end

function GM:ShouldDrawLocalPlayer( ply )
	return true
end

function GM:ScoreboardShow()

end

function GM:ScoreboardHide()

end

function GM:PlayerBindPress( pl, bind, down )

	if ( bind == "+duck" ) then
		return true
	end
	
	if ( bind == "+jump" ) then
	//	return true
	end
	
	if string.find(bind, "slot") then
		return true
	end
	
	if string.find(bind, "invnext") then
		if IsValid( self.Music ) and !IsValid( self.SceneAmbient ) then
			self.Music:SetVolume( self.Music:GetVolume() - 0.03 )
		end
		return true
	end
	
	if string.find(bind, "invprev") then
		if IsValid( self.Music ) and !IsValid( self.SceneAmbient ) then
			self.Music:SetVolume( self.Music:GetVolume() + 0.03 )
		end
		return true
	end
	
	
	if string.find(bind, "slot") then
		return true
	end
	
	if ( bind == "+speed" ) then
		//return true
	end
	
	
end

local NotToDraw = { "CHudHealth","CHudBattery", "CHudSecondaryAmmo","CHudAmmo","CHudDamageIndicator","CHudVoiceSelfStatus", "CHudCrosshair" }
//todo: change this stuff instead of using getconvarnumber etc
hook.Add("HUDShouldDraw", "HideStuff", function( name )

	for k,v in ipairs( NotToDraw ) do
		if v == name then 
			return false
		end
	end
	
	if name == "CHudChat" then
		return SOG_HUD
	end		
end)

hook.Add("GUIMousePressed", "TopDownMousePressed", function( mc )

	if ( mc == MOUSE_LEFT ) then
		RunConsoleCommand( "+attack", "" )
	end
	
	if ( mc == MOUSE_RIGHT ) then
		RunConsoleCommand( "+attack2", "" )
	end
	
end)


hook.Add("GUIMouseReleased", "TopDownMouseReleased", function( mc )

	if ( mc == MOUSE_LEFT ) then
		RunConsoleCommand( "-attack", "" )
	end
	if ( mc == MOUSE_RIGHT ) then
		RunConsoleCommand( "-attack2", "" )
	end

end)

function GM:ToggleRadio()
	
	if self.RadioEnabled then
		if self.RadioPaused then return end
		self:RemoveRadio()
		LocalPlayer():ChatPrintTranslated("sog_music_off")
	else
		self:MakeRadio()
		LocalPlayer():ChatPrintTranslated("sog_music_on")
		LocalPlayer():ChatPrintTranslated("sog_music_help")
		LocalPlayer():ChatPrintTranslated("sog_music_help2")
	end
	/*if self.Radio and self.Radio:Valid() then
		if self.Radio.Paused then return end //just to prevent some stuff
		self:RemoveRadio()
		LocalPlayer():ChatPrintTranslated("sog_music_off")
	else
		self:MakeRadio()
		LocalPlayer():ChatPrintTranslated("sog_music_on")
		LocalPlayer():ChatPrintTranslated("sog_music_help")
		LocalPlayer():ChatPrintTranslated("sog_music_help2")
	end*/
end

GM.MusicRawFFT = {}
GM.MusicFFTPrev = {}
GM.MusicFFT = {}
GM.MusicFFTMax = {}
GM.MusicFFTSmooth = {}

for i=1, 128 do	
	GM.MusicRawFFT[i] = 0
	GM.MusicFFTPrev[i] = 0
	GM.MusicFFT[i] = 0
	GM.MusicFFTMax[i] = 0
	GM.MusicFFTSmooth[i] = 0
end

GM.NextBeat = 0
GM.BeatTime = 0

/*function GM:GetFFT( music )
	
	if music and music:IsValid() then
		
		music:FFT( self.MusicRawFFT, FFT_512 )
		
		if #self.MusicRawFFT < 1 then return end
		
		local max_prev = 0
		local max_cur = 0

		for i = 1, 8 do
			if self.MusicFFT[ i ] then
				if not self.MusicFFTMax[ i ] then self.MusicFFTMax[ i ] = self.MusicFFT[ i ] end
				if not self.MusicFFTSmooth[ i ] then self.MusicFFTSmooth[ i ] = self.MusicFFT[ i ] end
				if self.MusicFFTMax[ i ] < self.MusicFFT[ i ] then
					self.MusicFFTMax[ i ] = self.MusicFFT[ i ]
				end
			end
		end
		
		local count = 1
		
		for i=1, 8 do
			
			local av = 0
			
			local smp_count = math_pow( 2, i )
			
			if i == 8 then
				smp_count = smp_count + 2
			end
			
			for j = 1, smp_count do
				av = av + self.MusicRawFFT[ count ] * ( count + 1 )
				count = count + 1
				if count == 256 then break end
			end
			
			av = av / count
			
			if self.MusicFFT[ i ] and self.MusicFFTMax[ i ] then
			
				if ( i == 1 ) then
					if av > self.MusicFFTMax[ i ] * 0.5 and self.NextBeat < CurTime() then
						self.BeatTime = CurTime() + 0.1
						self.NextBeat = CurTime() + 0.3
					end
				end
				
				
				if ( i == 7 ) then
					if av > self.MusicFFTMax[ i ] * 0.5 and self.NextBeat < CurTime() then
						self.BeatTime = CurTime() + 0.1
						self.NextBeat = CurTime() + 0.3
					end
				end
				
			end
			
			if max_cur < av then
				max_cur = av	
			end
			
			self.MusicFFT[ i ] = av
			
			if self.MusicFFTSmooth[ i ] then
				self.MusicFFTSmooth[ i ] = math_Approach( self.MusicFFTSmooth[ i ], self.MusicFFT[ i ], FrameTime() )
			end
			
		end
		
		return self.MusicFFT, self.MusicFFTSmooth, self.MusicFFTMax
		
	end
	
end*/
local beat_count = 0
function GM:GetFFT( music )
	
	if music and music:IsValid() and !IsValid( Cut ) then
		
		//if !self.MusicStarted then return end

		if self.MusicStarted and self.MusicStarted < CurTime() and not self.FixFFTStuff then
			for i=1, 128 do	
				self.MusicRawFFT[i] = 0
				self.MusicFFTPrev[i] = 0
				self.MusicFFT[i] = 0
				self.MusicFFTMax[i] = 0
				self.MusicFFTSmooth[i] = 0
			end
			self.FixFFTStuff = true
		end
		
		music:FFT( self.MusicRawFFT, FFT_256 )
		
		local ignore_max = false
		local booting = false
		
		local boot_time = 1.5
		
		if self.MusicStarted and ( self.MusicStarted + 2 ) > CurTime() then
			
			for i=1, 44 do
				local delta = math_Clamp( 1 - ( self.MusicStarted + boot_time - CurTime() )/ boot_time, 0, 1 ) * 44
				delta = math_floor( delta )
				self.MusicRawFFT[i] = delta == i and math_Rand( 0.5, 1 ) or 0
				self.MusicRawFFT[88 - i] = self.MusicRawFFT[i] * 1
				//self.MusicFFTSmooth[i] = delta == i and 1 or 0
			end
			
			/*for i=1, 42 do
				local j = 86 - i
				local delta = math_Clamp( 1 - ( self.MusicStarted + 2 - CurTime() )/ 2, 0, 1 ) * 64
				delta = math_floor( delta )
				self.MusicRawFFT[j] = delta == j and math_Rand( 0.8, 1 ) or 0
				//self.MusicFFTSmooth[j] = delta == j and 1 or 0
			end*/
			
			booting = true
			ignore_max = true
		end
	
		if #self.MusicRawFFT < 1 then return end
		
		local beat = false
		
		for i=1, 128 do	
			if self.MusicRawFFT[ i ] then
				if not self.MusicFFTMax[ i ] then self.MusicFFTMax[ i ] = 0 end
				if not self.MusicFFTSmooth[ i ] then self.MusicFFTSmooth[ i ] = 0 end
				if not self.MusicFFTPrev[ i ] then self.MusicFFTPrev[ i ] = 0 end
				if self.MusicFFTMax[ i ] < self.MusicRawFFT[ i ] and !ignore_max then
					self.MusicFFTMax[ i ] = self.MusicRawFFT[ i ] * 1
				end
			end
				
			if self.MusicRawFFT[ i ] and self.MusicFFTMax[ i ] then

					if ( i == 1 ) then
						
						if ( self.MusicRawFFT[ i ] - self.MusicFFTPrev[ i ] ) > self.MusicFFTMax[ i ] * 0.4 and self.NextBeat < CurTime() then
							beat_count = beat_count + 1
						end
						
						if self.MusicRawFFT[ i ] > self.MusicFFTMax[ i ] * 0.65 and beat_count > 5 and self.NextBeat < CurTime() then
							self.BeatTime = CurTime() + 0.1
							self.NextBeat = CurTime() + 0.3
							beat = true
							beat_count = 0
						end
					end
					
			end

			//self.MusicFFT[ i ] = av
				
			if self.MusicFFTSmooth[ i ] then
				if self.MusicFFTSmooth[ i ] < self.MusicRawFFT[ i ] then
					self.MusicFFTSmooth[ i ] = self.MusicRawFFT[ i ] * 1
				end
				//self.MusicFFTSmooth[ i ] = self.MusicFFTSmooth[ i ] * 0.99
				if booting then
					self.MusicFFTSmooth[ i ] = self.MusicFFTSmooth[ i ] * 0.92
				else
					self.MusicFFTSmooth[ i ] = math_Approach( self.MusicFFTSmooth[ i ], self.MusicRawFFT[ i ], FrameTime() * ( self.MusicFFTSmooth[ i ] ^ 0.55 ) )
				end
			end
			
			self.MusicFFTPrev[ i ] = self.MusicRawFFT[ i ] * 1
			
		end
		
		if beat then
			//table.insert( self.MusicRefract, { cur_refr = 16, refr = 0 } )	
			self.MusicRefract[ #self.MusicRefract + 1 ] = { cur_refr = 16, refr = 0 }
		end
			
		
		return self.MusicRawFFT, self.MusicFFTSmooth, self.MusicFFTMax
		
	end
	
end

function GM:RemoveRadio()
	
	self.RadioEnabled = false
	
	if IsValid( self.Music ) then
		self.Music:Stop()
	end

	/*if self.Radio and self.Radio:Valid() then
		self.Radio:Remove()
	end
	self.Radio = nil*/
end

function GM:MakeRadioTrack( num )
		
	if self.RadioPlaylist[ num ] then
		local tbl = self.RadioPlaylist[ num ]	
		self.RadioCurDuration = tbl.duration
		self:CreateMusic( MUSIC_TYPE_NORMAL, tbl.id, GAMETYPE_PLAYLIST_VOLUME or 30, false )
	end
	
	self.RadioCurTrack = num
	self.RadioCurDuration = self.RadioCurDuration or 0
	
end

function GM:SwitchTrack( add )
	
	self.RadioSwitching = true
	
	local am = self.RadioTracks or #self.RadioPlaylist
	local next_track = ( self.RadioCurTrack or 1 ) + add
						
	if next_track > am then next_track = 1 end
	if next_track < 1 then next_track = am end				
						
	if self.RadioPlaylist[ next_track ] then
		self:MakeRadioTrack( next_track )
	end
	
end

function GM:RadioThink()
	
	if self.RadioPlaylist then
		
		//create music, since we need an initial delay to let it the tracks info
		if self.RadioForceEnable then
			self:MakeRadioTrack( 1 )
			self.RadioForceEnable = nil
		end
		
		if IsValid( self.Music ) then
			local cur = self.RadioCurTrack
			
			if self.RadioPlaylist[ cur ] and self.RadioPlaylist[ cur ].duration then
				local dur = self.RadioPlaylist[ cur ].duration
				
				if self.Music:GetTime() >= dur then
					
					if not self.RadioSwitching then
						self.RadioSwitching = true
						self:SwitchTrack( 1 )
					end
				end
				
			end
		else
			if self.RadioSwitching then
				self.RadioSwitching = nil
			end
		end
		
		
	end
	
end

function GM:InitializeRadio()
	
	local playlist = GAMETYPE_PLAYLIST or 25165062
	
	if not self.RadioPlaylist then
		
		local key = "e4b98888683c9b1633202415df2b273d"
		
		http.Fetch( "http://api.soundcloud.com/resolve.json?url=http://api.soundcloud.com/playlists/"..playlist.."&client_id="..key, function ( body )
			if body then
				local tbl = util.JSONToTable( body )
				if tbl and tbl.tracks then
					
					self.RadioPlaylist = {}
					
					for i=1, #tbl.tracks do 
						local tr = tbl.tracks[ i ]
						self.RadioPlaylist[ i ] = { id = tr.id, duration = math_floor( tr.duration / 1000 ), name = tr.title }
					end
					
					self.RadioTracks = #tbl.tracks
					
					table.Shuffle( self.RadioPlaylist )
					
					//PrintTable( self.RadioPlaylist )
					
				end
				
			end
		end )
	
	end
	
end

function GM:MakeRadio()
	
	self.RadioEnabled = true
	
	self:InitializeRadio()
	
	self.RadioForceEnable = true
	
	/*local playlist = GAMETYPE_PLAYLIST or 25165062
	local volume = GAMETYPE_PLAYLIST_VOLUME or 15
			
	GAMEMODE:CreateSCPanel( nil, playlist, volume, true, nil ) //create a playlist with some nice tracks,38 volume, radio format
	*/	
end

function GM:MakeAmbient( id, volume )
	
	self:CreateMusic( MUSIC_TYPE_LEVEL_CLEAR, id, volume, true )
	
	/*local sc = vgui.Create("HTML")
	self.Ambient = sc
	sc:SetPos( 0, 0 )
	sc:SetSize(400, 165)
	sc:SetVisible(false)
	sc:SetMouseInputEnabled(false)
	sc:SetKeyboardInputEnabled(false)
	
	local html = self:GetPlayerHTMLCode( id, volume, true, true, 0 )//22*1000 + 500//1500
	
	sc:SetHTML( html )*/
	
end

util.PrecacheSound( "ambient/levels/citadel/portal_beam_shoot5.wav" )

function GM:PlayAmbient()
	if IsValid( self.Ambient ) then
		self.Ambient:Play()
	end
	/*if self.Ambient and self.Ambient:IsValid() then
		self.Ambient:RunJavascript( "Play();" )
	end*/
end

function GM:StopAmbient()
	if IsValid( self.Ambient ) then
		self.Ambient:Pause()
		self.Ambient:SetTime( 0 )
	end
	
	/*if self.Ambient and self.Ambient:IsValid() then
		self.Ambient:RunJavascript( "Pause(); ResetTime(0);" )//22*1000 + 500
	end*/
end

function GM:SetAmbientVolume( vol )
	if self.Ambient and self.Ambient:IsValid() then
		self.Ambient:RunJavascript( "volume = "..(vol/100)..";" )
	end
end

//old broken piece of trash
function GM:GetPlayerHTMLCode( track_id, volume, loop, paused, start_from, end_at )
	
	local player_id = "widget"..math_random(0,100)
	
	volume = volume/100 or 0.3
	loop = loop or false
	
	local t = loop and [[tracks]] or [[playlists]]
	
	//local disable_volumestuff = track_id == 25165062
	
	track_id = t..[[/]]..track_id

	local start = start_from and [[widget.seekTo(]]..start_from..[[);]] or [[]]
	
	local should_start = start_from and [[
										if ( position < ]]..start_from..[[ )
										{
											widget.seekTo(]]..start_from..[[);
										}
										]] or [[]]
										
	local check_end = end_at and [[
									if ( position >= ]]..end_at..[[ )
									{
										widget.seekTo(]]..( start_from or 0 )..[[);
									}
									]] or [[]]
	
	local loopcode = loop and [[
			widget.getDuration(function (duration) {
				widget.getPosition(function (position) {
						if ( (duration - position) < 1000 )
						{
							widget.seekTo(0);
						}
						]]..should_start..[[
						]]..check_end..[[
					});
				});
	
	]] or [[
			widget.getDuration(function (duration) {
				widget.getPosition(function (position) {
					widget.getCurrentSoundIndex(function (soundindex) {
						if (soundindex == GetLastTrack())
						{
							if ( (duration - position) < 3000 )
							//if (position > 5000)
							{
								widget.skip(0);
								widget.pause();
								setTimeout(Play, 2000);
							}
						}
						else
						{
							if ( (duration - position) < 1000 )
							//if (position > 5000)
							{
								widget.next();
							}
						}
					});
				});
			});
	]]
	
	local autoplay = [[&amp;auto_play=false]]//paused and [[&amp;auto_play=false]] or [[&amp;auto_play=true]]
	
	local play_and_pause = paused and [[Bufferize();]] or [[]]
			
	//local trackvolume = loop and [[	volume = defaultvolume; ]] or [[]]
	local trackvolume = [[]]
	
	//if disable_volumestuff then
		volumestuff = [[
						widget.getCurrentSoundIndex(function (soundindex) {
							volume = defaultvolume;
						});]]
	//end
								
	local shufflecode = loop and [[]] or [[PlayRandomTrack();]]
	
	local code = [[
		<!DOCTYPE html>
		<html>
		<head>
			<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
			<script src="https://w.soundcloud.com/player/api.js" type="text/javascript"></script>
		</head>
		<body>
			<iframe id="]]..player_id..[[" src="http://w.soundcloud.com/player/?url=https://api.soundcloud.com/]]..track_id..[[]]..autoplay..[[&show_artwork=false&liking=false&sharing=false" width="70%" height="165" scrolling="no" frameborder="no"></iframe>
			//<script src="https://w.soundcloud.com/player/api.js" type="text/javascript"></script>
			<script type="text/javascript">
			 
				var widgetIframe = document.getElementById(']]..player_id..[['),
				widget = SC.Widget(widgetIframe);
				
				defaultvolume = ]]..volume..[[;
				volume = ]]..volume..[[;
				user_volume = volume;
				user_changed_volume = false;
				bufferizing = false;
				var use_buff = ]]..(paused and [[true]] or [[false]])..[[;
								
				/*widget.bind(SC.Widget.Events.READY, function() {
					
					]]..play_and_pause..[[
					
					if ( user_changed_volume == true )
					{
						defaultvolume = user_volume;
						volume = user_volume;
					}
					
					widget.setVolume( volume );
					
					if ( bufferizing == true )
					{
						//widget.setVolume( 0 );
					}
					
					widget.getSounds(function(sounds) 
					{
						tracks_amount = sounds.length;
						]]..shufflecode..[[	
					});
	
					

				});
				widget.bind(SC.Widget.Events.PLAY, function() {
					//--]]..volumestuff..[[	

					if ( user_changed_volume == true )
					{
						defaultvolume = user_volume;
						volume = user_volume;
					}
					
					widget.setVolume( volume );
					
					if ( bufferizing == true )
					{
						//widget.setVolume( 0 );
					}									
				});
				widget.bind(SC.Widget.Events.PAUSE, function() {
					
				});
				widget.bind(SC.Widget.Events.PLAY_PROGRESS, function() {
					
					]]..loopcode..[[
					
					]]..trackvolume..[[
					
					if ( user_changed_volume == true )
					{
						defaultvolume = user_volume;
						volume = user_volume;
					}
					
					widget.setVolume( volume );
					
					if ( bufferizing == true )
					{
						//widget.setVolume( 0 );
					}

				});*/
					
				
				function IncreaseVolume()
				{
					ChangeVolume( volume + 0.03 );
					user_changed_volume = true;
					user_volume = volume;
				}
				function DecreaseVolume()
				{
					ChangeVolume( volume - 0.03 );
					user_changed_volume = true;
					user_volume = volume;
				}
				
				function Play()
				{
					widget.play();
				}
				
				function Bufferize()
				{
					if ( use_buff == true )
					{
						user_changed_volume = true;
						user_volume = 0;
						//Play();
						setTimeout(FinishBufferize, 300);
					}
				}
				
				function FinishBufferize()
				{
					if ( use_buff == true )
					{
						Pause();
						widget.seekTo(]]..(start_from or 0)..[[);
						user_changed_volume = true;
						user_volume = ]]..volume..[[;
					}
				}
				
				function Pause()
				{
					widget.pause();
				}
				
				function ResetTime( arg )
				{
					widget.seekTo( arg );
				}
				
				function ChangeVolume( arg )
				{
					volume = Math.max(0, Math.min(arg, 1));
				}
				
				function ChangeDefaultVolume( arg )
				{
					defaultvolume = Math.max(0, Math.min(arg, 1));
				}
				
				function GetLastTrack()
				{
					return (tracks_amount - 1);
				}
					
				function GetRandomTrack()
				{
					return Math.floor((Math.random() * GetLastTrack())); 
				}
				
				function PlayRandomTrack()
				{
					widget.skip(GetRandomTrack());
				}
				
				function NextTrack()
				{
					widget.getCurrentSoundIndex(function (current_track) {
						var next_track = current_track + 1;
						if ( next_track > GetLastTrack() )
						{
							next_track = 0;
						}
						widget.skip(next_track);
						widget.seekTo(0);
					});
				}
				
				function PrevTrack()
				{
					widget.getCurrentSoundIndex(function (current_track) {
						var next_track = current_track - 1;
						if ( next_track < 0 )
						{
							next_track = GetLastTrack();
						}
						widget.skip(next_track);
						widget.seekTo(0);
					});
				}
				
				
			  
			</script>
		</body>
		</html>
		]]
	
	
		
	//print(code)
	
	return code
	
end

function GM:PlayMusic()
	
	self:StopAmbient()
	
	if IsValid( self.Music ) then
		self.Music:Play()
		self.RadioPaused = false
	end
	
	/*self:StopAmbient()
	if self.Radio and self.Radio:IsValid() then
		if !self.Radio.Paused then return end
		self.Radio:RunJavascript( "Play();" )
		self.Radio.Paused = false
		//self:StopAmbient()
	end*/
end

function GM:PauseMusic()
	if IsValid( self.Music ) then
		self.Music:Pause()
		self.RadioPaused = true
	end
	/*if self.Radio and self.Radio:IsValid() then
		self.Radio:RunJavascript( "Pause();" )
		self.Radio.Paused = true
	end*/
end

function GM:CreateMusic( t, id, volume, paused, start_from, end_at, no_loop )
	
	local force_start_from
	
	if t == MUSIC_TYPE_NORMAL then
		if IsValid( self.Music ) then self.Music:Stop() end
		self.MusicStartFrom = nil
		self.MusicEndAt = nil
		
		if start_from then
			self.MusicStartFrom = start_from / 1000
			force_start_from = self.MusicStartFrom * 1
		end
		
		if end_at then
			self.MusicEndAt = end_at / 1000
		end
			
	end
	
	if t == MUSIC_TYPE_AMBIENT then
		if IsValid( self.SceneAmbient ) then self.SceneAmbient:Stop() end
		self.SceneAmbientStartFrom = nil
		self.SceneAmbientEndAt = nil
		
		if start_from then
			self.SceneAmbientStartFrom = start_from / 1000
			force_start_from = self.SceneAmbientStartFrom * 1
		end
		
		if end_at then
			self.SceneAmbientEndAt = end_at / 1000
		end
		
	end
	
	local tags = "noplay noblock"
	
	//if start_from or end_at then
		//tags = "noplay noblock"
	//end
	
	local key = "e4b98888683c9b1633202415df2b273d"
	
	sound.PlayURL( "http://api.soundcloud.com/tracks/"..id.."/stream?client_id="..key, tags, function ( song, id, str ) 
			
		if IsValid( song ) then
			
			local var = song
			
			var:Pause()
			
			var:SetVolume( volume and ( volume + 25 ) / 100 or 0.4 )	
			
			
			
			if force_start_from then
				//var:Pause()
				var:SetTime( force_start_from )
				//var:Play()
			end
			
			if paused then
			
			else
				if t == MUSIC_TYPE_AMBIENT then
					timer.Simple( 0.6, function() if var then var:Play() end end )
				else
					var:Play()
				end
			end
			
			/*if paused then
				var:Pause()
			else
				var:Play()
			end*/
			
			if no_loop then
				var:EnableLooping( false )
			else
				var:EnableLooping( true )
			end
			
			if t == MUSIC_TYPE_NORMAL then
				self.Music = var
			end
			
			if t == MUSIC_TYPE_AMBIENT then
				self.SceneAmbient = var
			end
			
			if t == MUSIC_TYPE_LEVEL_CLEAR then
				self.Ambient = var
			end
		else
			print( "Music error: "..str )	
		end
		
	end)
	
end

function GM:CreateSCPanel( panel, id, volume, radio, paused, startfrom, end_at, override )
		
	/*
	
	self:RemoveRadio()
		
	local sc
	
	if panel then
		sc = panel:Add("HTML")
	else
		sc = vgui.Create("HTML")
	end
	
	if radio then
		self.Radio = sc
	end
	
	sc:SetPos( 0, 0 )
	sc:SetSize(700, 365)
	sc:SetVisible(true)
	sc:SetMouseInputEnabled(true)
	sc:SetKeyboardInputEnabled(true)
	
	sc.volume = volume
	sc.startfrom = startfrom
	sc.end_at = end_at
	
	local html = self:GetPlayerHTMLCode( id, volume, not radio, paused, startfrom, end_at )
	
	sc:SetHTML( html )
	sc:UpdateHTMLTexture() 
	
	//sc:MakePopup()
	
	return sc*/

end

local combometer = 0
local curcombopos = -200
local goalcombopos = -200
local lastshake = 0

net.Receive( "IncreaseComboMeter", function( len )

	if !SOG_HUD then return end
	
	combometer = net.ReadInt( 32 )//combometer + 1
	goalcombopos = 0
	lastshake = CurTime() + COMBO_WINDOW + (LocalPlayer():GetCharTable().AddComboWindow or 0)
	
	if combometer > 1 or GAMEMODE:GetGametype() == "axecution" then
		flashtime = CurTime() + 0.5
	end
	
end)

net.Receive( "ResetComboMeter", function( len )

	//if !util.tobool(GetConVarNumber("sog_hud")) then return end
	
	goalcombopos = -200
	lastshake = 0
	if combometer > 1 then
		flashtime = CurTime() + 0.5
	end
	
end)


function GM:DrawComboMeter()
	
	if curcombopos == -200 and combometer ~= 0 and goalcombopos == -200 then
		combometer = 0
	end
	
	if combometer < 2 and curcombopos == - 200 then return end

	//goalcombopos = 0
	
	if curcombopos ~= goalcombopos then
		curcombopos = math_Approach( curcombopos, goalcombopos, RealFrameTime() * 700 )
	end
	
	local w, h = ScrW(), ScrH()
	local MySelf = LocalPlayer()
	
	local x, y = 60 + curcombopos ,70
	local bw, bh = 270, 7
	local spacing = 3
	
	local am = 7

	drawstripes( bw/2 + curcombopos, y , bw, bh, am, spacing, true )
	
	local text = combometer.."X"
	
	local shift = math_sin(RealTime()*(2+combometer*0.3))*42 + 42

	if lastshake and lastshake ~= 0 then
		local delta = math_Clamp(  ( lastshake - CurTime() ) / COMBO_WINDOW , 0, 1)
		
		local maxshake = math_min(2+combometer,10)
		
		x = x + math_Rand( -maxshake * delta, maxshake * delta )
		y = y + math_Rand( -maxshake * delta, maxshake * delta )
	end
	
	surface_SetFont( "ComboMeter" )
	
	local offset_x, offset_y = surface_GetTextSize( text )
	offset_x = offset_x/3
	offset_y = offset_y/3
	local scale = 1.65
	
	draw.ScaledText( text, x + 3 * scale + offset_x*scale, y + 3 * scale, col_shadow, "ComboMeter", scale, false )
	draw.ScaledText( text, x + offset_x*scale, y, Color( 157 + shift + combometer, 0, 57, 255), "ComboMeter", scale, false )
	//draw_SimpleText( text, "ComboMeter", x + 3, y + 3, Color( 10, 10, 10, 185), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	//draw_SimpleText( text, "ComboMeter", x, y, Color( 157 + shift + combometer, 0, 57, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	
end

local ScoreMessages = {}

net.Receive( "RecScoreMessage", function( len )
	
	local msg = {}
	
	msg.text = net.ReadString()
	msg.pos = net.ReadVector()
	msg.decay = net.ReadFloat()
	msg.time = CurTime()
	
	table.insert( ScoreMessages, msg )

end)

function GM:AddScoreMessage( text, pos, decay )
	
	local msg = {}
	
	msg.text = translate.Format(text) or ""
	msg.pos = pos or vector_origin
	msg.decay = decay or 1
	msg.time = CurTime()
	
	table.insert( ScoreMessages, msg )
	
end

local function DrawRawMessage( msg )
	
	local text = msg.text
	local pos = msg.pos:ToScreen()
	
	local x, y = pos.x, pos.y - 30
	
	local delta = math_Clamp( 1 - (((msg.time + msg.decay) - CurTime())/msg.decay), 0, 1 )
	
	local gap = 35
	
	local shift = (delta ^ 1.5) * gap
	local shift1 = (delta ^ 2) * gap
	local shift2 = (delta ^ 2.5) * gap
	local shift3 = delta * gap
		
	draw_SimpleText( text, "NumbersSmaller", x + 1, y + 1 - shift2, col_shadow, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	draw_SimpleText( text, "NumbersSmaller", x, y - shift, Color( 97, 0, 27, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) //Color( 97, 0, 27, 255)
	draw_SimpleText( text, "NumbersSmaller", x, y - shift1, Color( 97, 0, 27, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) //Color( 97, 0, 27, 255)
	draw_SimpleText( text, "NumbersSmaller", x, y - shift2, Color( 97, 0, 27, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER) //Color( 97, 0, 27, 255)
	draw_SimpleText( text, "NumbersSmaller", x, y - shift3, Color( 210, 210, 210, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	
end

function GM:DrawScoreMessages()

	for _, msg in ipairs( ScoreMessages ) do

		if msg.time + msg.decay > CurTime() then
			
			DrawRawMessage( msg )
		
		end
		
	end

	for _, msg in ipairs( ScoreMessages ) do
		if msg.time + msg.decay > CurTime() then
			return
		end
	end
	
	if #ScoreMessages > 0 then
		ScoreMessages = {}
	end


end

local message = nil
local message_whole = nil
local message_text_time = nil
local message_curtime = 0
local message_time = 0
local message_scale = nil

function GM:AddHugeMessage( text, time, scale )
	
	if text then
		message = string.ToTable(text)
		message_text_time = {}
		message_whole = text
		message_curtime = CurTime()
		message_time = time or 4
		message_scale = scale or 1.45
		
		local num = #message
		for k, v in pairs( message ) do
			local t = ""
			for i=1,num do
				if i == k then
					t = t..v
				else
					t = t.."  "//new plan - double space because fonts are fixe dnow, sort of
				end
			end
			message[k] = t
			if #message ~= 0 then
				message_text_time[k] = { appear = CurTime() + (k/#message) * 1.5, dissappear = CurTime() + message_time - ((#message-k)/#message) * 1.5 }
			end
		end
		
		//PrintTable(message)
		
	end
	
end

function GM:DrawHugeMessage()
	
	if not message then return end
	
	local w,h = ScrW(), ScrH()
	
	local scale = message_scale or 1.45
	
	if #message >= 17 then
		scale = 1.3
	end
	
	if #message <= 10 then
		scale = 1.55
	end
	
	for k, v in pairs( message ) do
	
		if message_text_time[k] and message_text_time[k].appear and message_text_time[k].appear > CurTime() then continue end
		if message_text_time[k] and message_text_time[k].dissappear and message_text_time[k].dissappear < CurTime() then continue end
		
		local flash = math_random(-20,30)
		
		draw.ScaledText( v, w/2, h/2, Color( 0, 204 + flash, 204 + flash, 250), "HugeMessage", scale, true )
		
		local am = 10
		local popup = #message ~= 0 and math_min(message_time/#message, 0.5) or 0.5//0.5
		
		for i=0,am do
			if message_text_time[k] and message_text_time[k].appear and message_text_time[k].appear + popup*2 + 0.01 < CurTime() then continue end
			local delta = math_Clamp( 1 - (((message_text_time[k].appear + popup) - CurTime())/popup), 0, 1 )

			if delta == 1 then 
				delta = math_Clamp( (((message_text_time[k].appear + popup*2) - CurTime())/(popup)), 0, 1 )
			end
			local gap = 35
			local shift = delta * ( i/am * gap )//(delta ^ 1.5) * gap
			
			local offset = 15
			local shift2 = delta*offset * (k/#message)
			
			draw.ScaledText( v, w/2 - delta*(offset/2)*(i/am) + shift2*(i/am), h/2 - shift, Color( 250 + flash, 220 * (i/am) + flash, 220 * (i/am) + flash, 250), "HugeMessage", scale, false )

		end
	end
	
	if message_curtime + message_time <= CurTime() then
		message = nil
		message_curtime = 0
		message_time = 0
		message_whole = nil
		message_text_time = nil
		message_scale = nil
	end
	
end

local cur_goal = nil
local goal_time = -1

net.Receive( "SetGoal", function( len )
	
	local goal = net.ReadString()
	local time = net.ReadInt( 32 )
	if goal then
		GAMEMODE:SetGoal( goal, time and (CurTime() + time) or -1 )
	end

end)

net.Receive( "ClearGoal", function( len )
	GAMEMODE:ClearGoal()
end)

function GM:SetGoal( goal, time )
	cur_goal = tostring(goal)
	goal_time = time or -1
end

function GM:ClearGoal()
	cur_goal = nil
	goal_time = -1
end

function GM:DrawGoal()
	
	local w, h = ScrW(), ScrH()
	local MySelf = LocalPlayer()
	
	if not cur_goal then return end
	if goal_time ~= -1 and goal_time < CurTime() then return end
	if !MySelf:Alive() then return end
	
	surface_SetFont("PixelObj")
	
	local tw, th = surface_GetTextSize(cur_goal)
	
	local border = 9
	
	local tx, ty = w/2, h - 10 - th//h-70-th/2
	
	surface_SetDrawColor( Color(10,10,10,175) )
	surface_DrawRect( tx-(tw+border)/2, ty-border/2, tw+border, th+border )
	
	draw.DrawText( translate.Get(cur_goal), "PixelObj", tx, ty, Color(210, 210, 210, 205 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	
	
end

local Arrows = {}

local arrow_mat = Material( "gui/html/forward" )

net.Receive( "AddArrow", function( len )
	
	local entity = net.ReadEntity()
	local epos = net.ReadVector()
	local follow = net.ReadBit()
	local screencheck = net.ReadBit()
		
	table.insert( Arrows, { ent = entity, pos = epos ~= vector_origin and epos or nil, follow = follow == 1 or nil, screencheck = screencheck == 1 or false } )

end)

net.Receive( "CleanArrows", function( len )
	GAMEMODE:CleanArrows()
end)

function GM:AddArrow( ent, pos, follow, screencheck )
	
	if self:ExistArrow( ent ) then return end
	
	table.insert( Arrows, { ent = ent, pos = pos or nil, follow = follow or nil, screencheck = screencheck or false } )
	
end

function GM:CleanArrows()
	table.Empty( Arrows )
end

function GM:ExistArrow( ent )
	local result = false
	for k, v in ipairs(Arrows) do
		if v.ent == ent then
			result = true
			break
		end
	end
	return result
end

function GM:DrawArrows()
	
	local r = 0.5*math_sin(RealTime()*timemul)*255 + 255/2
	local g = -0.5*math_sin(RealTime()*timemul)*255 + 255/2
	local b = 210
	
	if SCENE and SCENE.DarkArrows then
		r = math_sin( RealTime() * timemul ) * 25 + 235
		g = math_sin( RealTime() * timemul ) * 25 + 235
		b = math_sin( RealTime() * timemul ) * 25 + 235
	end
	
	local MySelf = LocalPlayer()

	if not ( Dialogue and Dialogue:IsValid() ) then
		for _, tbl in pairs( Arrows ) do
			if IsValid( tbl.ent ) then
				
				local me = MySelf:GetObserverTarget() 
				if not IsValid( me ) then
					me = MySelf
				end
				
				if tbl.follow and ( tbl.screencheck and me:GetPos():DistToSqr(tbl.ent:GetPos()) > 62500 or not tbl.screencheck ) then
					
					local pos = me:GetPos() + vec_up * 2
					local endpos = tbl.ent:GetPos() + vec_up * 2

					local shift = math_sin(RealTime()*4)*7 + 7
					
					/*local dir = ( pos - endpos ):GetNormal()
					local ang = dir:Angle()
					
					ang:RotateAroundAxis( vec_up, 45 )
					
					cam.Start3D( EyePos(), EyeAngles() )
						cam.Start3D2D(pos - me:GetAimVector() * look_dist * 2.2 - dir * ( 140 + shift*2 ), ang, 1.5)// 
							surface_SetMaterial( arrow_mat )
							surface_SetDrawColor( r, g, b, 110 )
							surface_DrawTexturedRectRotated( 16, 16, 32, 32, 180-45 )
						cam.End3D2D()
					cam.End3D()*/
					
					local ent_pos_screen = endpos:ToScreen()
					local my_pos_screen = pos:ToScreen()
					
					local screen_norm = ( Vector( ent_pos_screen.x, ent_pos_screen.y, 0 ) - Vector( my_pos_screen.x, my_pos_screen.y, 0 )  ):GetNormal()
					local ang = screen_norm:Angle()
					
					local aw, ah = 32, 32
					
					surface_SetMaterial( arrow_mat )
					surface_SetDrawColor( r, g, b, 255 )
					surface_DrawTexturedRectRotated( my_pos_screen.x + screen_norm.x * ( aw * 2.2 + shift ), my_pos_screen.y + screen_norm.y * ( aw * 2.2 + shift ), aw, ah, ang.y * - 1 )
					
					
				else
				
					local toworld = tbl.ent:LocalToWorld(tbl.ent:OBBCenter())
					toworld.z = 0
					local pos = tbl.pos and tbl.pos:ToScreen() or toworld:ToScreen()

					local aw, ah = 32, 32
					
					local shift = math_sin(RealTime()*4)*7 + 7
				
					surface_SetMaterial( arrow_mat )
					surface_SetDrawColor( r, g, b, 255 )
					surface_DrawTexturedRectRotated( pos.x - aw * 2.2 + shift, pos.y - 7, aw, ah, 0 )
				
				end
				
			end
		end
	end


	for _, tbl in pairs( Arrows ) do
		if IsValid( tbl.ent ) then
			return
		end
	end
	
	if #Arrows > 0 then
		table.Empty( Arrows )
		//Arrows = {}
	end

end

function GM:DrawDeathHUD()
	
	local w,h = ScrW(), ScrH()
	local MySelf = LocalPlayer()
	
	if MySelf:Alive() then return end
	if CharMenu and CharMenu:IsVisible() then return end

	if self.OnDrawDeathHUD then
		self:OnDrawDeathHUD()
		return
	end

	
	if self:GetGametype() ~= "none" then return end
	
	local shift = math_cos(RealTime()*3)*2 + 5
			
	local x, y = 60, h*0.85	
		
	local text = translate.Get("sog_hud_you_are_dead")
			
	draw_SimpleText( text, "NumbersSmall", x + 3, y + 3, col_shadow, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	draw_SimpleText( text, "NumbersSmall", x, y, Color( 97, 0, 27, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	draw_SimpleText( text, "NumbersSmall", x - shift, y - shift, col_darkred, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	
	
	if MySelf:GetCharTable().Styles then
		shift = math_sin(RealTime()*3)*2 + 5
		
		x, y = 60, h*0.85 + 38	
				
		text = translate.Get("sog_hud_change_style")
				
		draw_SimpleText( text, "NumbersSmall", x + 3, y + 3, col_shadow, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw_SimpleText( text, "NumbersSmall", x, y, Color( 97, 0, 27, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw_SimpleText( text, "NumbersSmall", x - shift, y - shift, col_darkred, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		return
	end
	
	if self.UseCharacters and #self.UseCharacters > 1 then
	
		shift = math_sin(RealTime()*3)*2 + 5
		
		x, y = 60, h*0.85 + 38	
				
		text = translate.Get("sog_hud_change_character")
				
		draw_SimpleText( text, "NumbersSmall", x + 3, y + 3, col_shadow, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw_SimpleText( text, "NumbersSmall", x, y, Color( 97, 0, 27, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw_SimpleText( text, "NumbersSmall", x - shift, y - shift, col_darkred, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		
	end
	
end


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

local active_achievements = 0
	
function GM:DrawAchievement( id )
		
	surface.PlaySound("UI/hint.wav")
		
	local w, h = ScrW(), ScrH()
	local sz_w, sz_h = 320, 120
	
	local fade_time = 1
		
	local ach = vgui.Create( "DPanel" )
	
	if id and self.Achievements[ id ] and self.Achievements[ id ].Name then
		ach.Text = translate.Get(self.Achievements[ id ].Name)
	end
	
	ach.DieTime = CurTime() + 8 - 1 * ( active_achievements )
	active_achievements = active_achievements + 1
	ach:SetSize( sz_w, sz_h )
	ach.offset = active_achievements
	ach.cur_y = h
	ach.FadeoutTime = ach.DieTime - fade_time
	ach:SetKeyboardInputEnabled( false )
	ach:SetMouseInputEnabled( false )
	ach.Paint = function( self, pw, ph )
		
		local r = 0.5*math_sin(RealTime()*1.5)*255 + 255/2
		local g = -0.5*math_sin(RealTime()*1.5)*255 + 255/2
		local b = 215
	
		local fade = math_Clamp( ( self.FadeoutTime - CurTime() / fade_time ), 0, 1 )
	
	
		surface_SetDrawColor( Color( r, g, b, 10 * fade ) )
		surface_DrawRect( 0, 0, pw, ph )
		surface_SetDrawColor( Color( 10, 10, 10, 90 * fade ) )
		surface_DrawRect( 0, 0, pw, ph )
		surface_SetDrawColor( r, g, b, 255 * fade )
		surface_DrawOutlinedRect( 0, 0, pw, ph )
		
		local shift = math_sin(RealTime()*3.2)*9 + 11
		
		shift = shift*3
		
		local x, y = pw/2, ph/3
		local text = string.upper( self.Text or "error" )
		
		draw_SimpleTextOutlined( translate.Get("sog_achievement_unlocked"), "PixelSmaller", x, y, Color( 186, 13, 190, 255 * fade), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, 255  * fade ) )
		draw_SimpleTextOutlined( translate.Get("sog_achievement_unlocked"), "PixelSmaller", x - 3, y - 3, Color( 235 - shift, 116 - shift, 235 - shift, 255 * fade), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, 255  * fade ) )
		
		x, y = pw/2, 2*ph/3
		
		draw_SimpleTextOutlined( text, "PixelCutsceneScaledSmall", x, y, Color( 186, 13, 190, 255 * fade), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, 255  * fade ) )
		draw_SimpleTextOutlined( text, "PixelCutsceneScaledSmall", x - 3, y - 3, Color( 235 - shift, 116 - shift, 235 - shift, 255 * fade), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Color( 0, 0, 0, 255  * fade ) )
		
		//draw_SimpleText( ach.offset, "PixelSmall", pw/2, ph/2, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	ach.Think = function( self )
		local goal = h - sz_h * self.offset
		self.cur_y = math_Approach( self.cur_y, goal, RealFrameTime() * ( 160 * self.offset ) )
		ach:SetPos( w - sz_w, self.cur_y  )
		if self.DieTime and self.DieTime < CurTime() then
			self:Remove()
			active_achievements = active_achievements - 1
		end
	end
		
		
end

local leftslide = -ScrW()
local goalleft = -ScrW()

local rightslide = ScrW()
local goalright = ScrW()

local sorting = function( pl1, pl2 ) return pl1:GetMaxScore() > pl2:GetMaxScore() end
local header_tbl = { GetMaxScore = function() return 999999999 end, Header = true }
 
function GM:HUDDrawScoreBoard()
	
	local w, h = ScrW(), ScrH()
	local MySelf = LocalPlayer()

	goalleft = MySelf:KeyDown( IN_SCORE ) and 0 or -w
	goalright = MySelf:KeyDown( IN_SCORE ) and 0 or w
	
	if leftslide ~= goalleft then
		leftslide = math_Approach( leftslide, goalleft, FrameTime() * 4500 )
	end
	
	if rightslide ~= goalright then
		rightslide = math_Approach( rightslide, goalright, FrameTime() * 4500 )
	end
	
	if leftslide == -w and rightslide == w then return end	
		
	local spacing = 5
	
	surface_SetFont( "NumbersSmallest" )
	local tw, th = surface_GetTextSize( "TEST" )
	
	local players = player.GetAll()
	table.insert( players, header_tbl)

	local wholeH = th * #players + spacing * math_Clamp( #players - 1, 0, 999)
	
	
	local step = 0
	local step2 = w/2-w/3
	local step3 = step2 * 2
	local step4 = step2 + step3
	
	local shift = math_sin(RealTime()*3)*1.5 + 3
	
	table.sort( players, sorting )
		
	for _, pl in ipairs( players ) do
			
		local text
		local maxscore
		local score
		local ping
		local font = "NumbersSmallest"
		local font2
		local col = Color( 210, 210, 210, 255)
		
		local add = 0
		
		if pl.Header then
			text = translate.Get("sog_scoreboard_name")
			maxscore = translate.Get("sog_scoreboard_max_score")
			score = self:GetGametype() == "axecution" and translate.Get("sog_scoreboard_axe_wins") or self:GetGametype() == "drama" and translate.Get("sog_scoreboard_team_score") or translate.Get("sog_scoreboard_score")
			font = "ScoreboardHeader"
			ping = translate.Get("sog_scoreboard_ping")
			add = 14
		else
			text = pl:Name()
			maxscore = pl:GetMaxScore()
			score = self:GetGametype() == "axecution" and pl:Frags() or self:GetGametype() == "drama" and team.GetScore(pl:Team()) or pl:GetScore()
			ping = pl:Ping()
			
			if self:GetGametype() == "axecution" and pl:Team() == 6 then
				col = Color( 240-shift*10, 20, 20, 255)
			end
			
			if self:GetGametype() == "drama" and pl:Team() ~= TEAM_SPECTATOR and pl:Team() ~= TEAM_CONNECTING then
				col = team.GetColor(pl:Team())
			end
			
			if string.len(text) >= 10 then
				font2 = "NumbersTiny"
			end
			
			if string.len(text) > 19 then
				text = string.sub( text, 1, 19).."..."
			end
			
		end
		
		local x, y = ( ( _ % 2 == 0) and (rightslide + rightslide/(_+1) * (goalright == 0 and 1 or -1)) or leftslide + leftslide/(_+1) * (goalleft == 0 and 1 or -1) ), h/2 - wholeH/2
		
		local bw, bh = pl.Header and w/1.5 or w/2.8, th/4
		
		drawstripes( x + w/3 + bw/2 + step2 - 1  , y + step , bw, bh, pl.Header and 5 or 4, 1, true )
		drawstripes( x + w/3 - bw/2 + step2 , y + step , bw, bh, pl.Header and 5 or 4, 1, false )
		
		x = x + w/4
		
		draw_SimpleText( text, font2 or font, x + 3, y + 3 + step, Color( 10, 10, 10, 185), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw_SimpleText( text, font2 or font, x, y + step, Color( 97, 0, 27, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw_SimpleText( text, font2 or font, x - shift, y - shift + step, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		
		draw_SimpleText( maxscore, font, x + 3 + step2, y + 3 + step, Color( 10, 10, 10, 185), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw_SimpleText( maxscore, font, x + step2, y + step, Color( 97, 0, 27, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw_SimpleText( maxscore, font, x - shift + step2, y - shift + step, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		
		draw_SimpleText( score, font, x + 3 + step3, y + 3 + step, Color( 10, 10, 10, 185), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw_SimpleText( score, font, x + step3, y + step, Color( 97, 0, 27, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw_SimpleText( score, font, x - shift + step3, y - shift + step, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		
		draw_SimpleText( ping, font, x + 3 + step4, y + 3 + step, Color( 10, 10, 10, 185), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw_SimpleText( ping, font, x + step4, y + step, Color( 97, 0, 27, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		draw_SimpleText( ping, font, x - shift + step4, y - shift + step, col, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		
		step = step + spacing + th + add
		
	end
	
end

//Because GMod is about shitty workarounds, not about creativity
matproxy.Add( 
{
	name	=	"PlayerColor", 

	init	=	function( self, mat, values )

		self.ResultTo = values.resultvar

	end,

	bind	=	function( self, mat, ent )

		if ( !IsValid( ent ) ) then return end

		if ent.StoredColor then
			mat:SetVector( self.ResultTo, ent.StoredColor )
			return
		end
		
		if ( ent:IsRagdoll() ) and !ent.BypassColorOwner then
			ent = ent.NewRagdollOwner or ent:GetRagdollOwner()
			if ( !IsValid( ent ) ) then return end
		end
		
		if ent:IsRagdoll() and ent.TeamColor then
			mat:SetVector( self.ResultTo, ent.TeamColor )
			return
		end

		if ( ent.GetPlayerColor ) or ent:IsNextBot() then
			if !ent:IsPlayer() then
				//print(ent)
			end
			if ent:IsNextBot() then
				if not ent.TeamColor or ent.TeamColor and ent.TeamColor ~= ent:GetDTVector( 0 ) then
					ent.TeamColor = ent:GetDTVector( 0 ) or Vector( 1, 1, 1 )
				end
				mat:SetVector( self.ResultTo, ent.TeamColor )//ent:GetDTVector( 0 ) or 
			else			
				local col = ent:GetPlayerColor()
				if ( isvector( col ) ) then
					mat:SetVector( self.ResultTo, col )
				end
			end
		else
			mat:SetVector( self.ResultTo, Vector( 62.0/255.0, 88.0/255.0, 106.0/255.0 ) )
		end

	end 
})

local reset_vec = Vector( 1, 1, 1 )
local function ResetBoneScale( ent )
	ent:SetNoDraw( true )
	for i = 0, ent:GetBoneCount() - 1 do
		ent:ManipulateBoneScale( i, reset_vec )
		ent:ManipulateBoneScale( i, reset_vec )
		ent:ManipulateBoneScale( i, reset_vec )
	end
end

net.Receive("CleanBodies", function(len)
	
	if !IsValid( LocalPlayer() ) then return end
	if not LocalPlayer().fake_bodies then return end

	for k, v in pairs( LocalPlayer().fake_bodies or {} ) do
		if IsValid( v ) then
				for k2, v2 in pairs( v:GetChildren() ) do
				if v2 and v2:GetClass() == "manipulate_bone" then
					SafeRemoveEntity(v2)
				end
			end
			SafeRemoveEntity( v )
		end
	end
	for k, v in pairs( LocalPlayer().fake_bodies_sliced or {} ) do
		if IsValid( v ) then
		   for k2, v2 in pairs( v:GetChildren() ) do
				if v2 and v2:GetClass() == "manipulate_bone" then
					SafeRemoveEntity(v2)
				end
			end
			SafeRemoveEntity( v )
		end
	end
	for k, v in pairs( LocalPlayer().gibs or {} ) do
		if IsValid( v ) then
			SafeRemoveEntity( v )
		end
	end
	
	for k,v in ipairs( ents.FindByClass( "class C_ClientRagdoll" ) ) do
		if v and v:IsValid() then
			//ResetBoneScale( v )
			SafeRemoveEntity( v )
		end
	end
		
	table.Empty( LocalPlayer().fake_bodies )
	table.Empty( LocalPlayer().fake_bodies_sliced )
	
end)

net.Receive( "ShakeView", function(len)
	
	local amount = net.ReadInt( 32 )
	local dur = net.ReadFloat()
	
	GAMEMODE:ShakeView( amount or 1, dur or 0.1 )
	
end)

net.Receive( "AddObjArrow", function(len)
	
	local start = net.ReadVector()
	local endpos = net.ReadVector()
	local time = net.ReadFloat()
	
	local e = EffectData()
		e:SetOrigin( start )
		e:SetStart( endpos )
		e:SetScale( time )
	util.Effect( "obj_arrow", e)
	
end)

net.Receive( "AddObjArrowFollow", function(len)
	
	local target = net.ReadEntity()

	if target._showArrow then return end
	
	target._showArrow = true
	local e = EffectData()
		e:SetOrigin(LocalPlayer():GetPos())
		e:SetEntity( target )
	util.Effect( "obj_arrow_follow", e)

	
end)

net.Receive("LevelClear", function(len)
	
	if !IsValid( LocalPlayer() ) then return end
	if LocalPlayer():Team() == TEAM_SPECTATOR or LocalPlayer():Team() == TEAM_CONNECTING then return end
	
	local t = LocalPlayer():Team()
	
	GAMEMODE:PauseMusic()
	GAMEMODE:PlayAmbient()
	GAMEMODE:AddHugeMessage( t == TEAM_MOB and "You lost" or t == TEAM_STUPID and "You lost" or "Level Clear" )
	
	surface.PlaySound( "music/stingers/hl1_stinger_song28.mp3" )
	
	if SINGLEPLAYER then
		LEVELCLEAR = true
	end

end)

net.Receive("ShowHugeMessage", function(len)
	
	local txt = net.ReadString()
	
	if txt then
		GAMEMODE:AddHugeMessage( txt )
	end

end)

net.Receive( "UpdateMapVotes", function( len )
	
	if !IsValid(LocalPlayer()) then return end
	
	local vote = net.ReadString()
	local score = net.ReadInt( 32 )
	
	if GAMEMODE.AvalaibleMaps[vote] then
		GAMEMODE.AvalaibleMaps[vote].votes = GAMEMODE.AvalaibleMaps[vote].votes + score
		//surface.PlaySound("UI/hint.wav")
	end
	
end)

net.Receive( "UpdateGtVotes", function( len )
	
	if !IsValid(LocalPlayer()) then return end
	
	local vote = net.ReadString()
	local score = net.ReadInt( 32 )
	
	if GAMEMODE.AvalaibleGametypes[vote] then
		GAMEMODE.AvalaibleGametypes[vote].votes = GAMEMODE.AvalaibleGametypes[vote].votes + score
	end
	
end)

net.Receive("SendMapList", function(len)
		
	local tbl = net.ReadTable()
	
	if tbl then
		GAMEMODE.AvalaibleMaps = table.Copy( tbl )
	end
	
end)

net.Receive("SetClientsideModelScale", function(len)
		
	local ent = net.ReadEntity()
	local scale = net.ReadFloat() or 1
	
	if ent and ent:IsValid() then
		ent:SetModelScale( scale, 0 )
		ent.ClientsideScale = scale
	end
	
end)

net.Receive("HUDMessage", function(len)
		
	local txt = net.ReadString()
	if txt == string.lower( "none" ) then
		HUD_MESSAGE = nil
	else
		HUD_MESSAGE = txt
	end
	
	
end)


function RegisterParticleEffect( name )
	 effects.Register(
            {
                Init = function(self, data)
                    local pos = data:GetOrigin()
					local norm = Angle(data:GetNormal().x,data:GetNormal().y,data:GetNormal().z)
					
					ParticleEffect(name,pos,norm,nil)
                end,
 
                Think = function() end,
 
                Render = function(self) end
            },
 
            name
        )
end

local fog_pos = Vector( -1529.65, -3325.22, 0.03 )

local function AddFog()

	local dist = LocalPlayer():GetPos():DistToSqr( fog_pos )
	
	local power = math_Clamp( dist/1000000, 0, 1 )
	//power = 1 - power

	render.FogMode( 1 ) 
	render.FogStart( 0 )
	render.FogEnd( 0 )
	render.FogMaxDensity( 0.6 * power )

	
	render.FogColor( 255, 255, 255 )

	return true

end
if SCENE and SCENE.Name == "scene_name_flashbacks" then
	hook.Add( "SetupWorldFog","AddFog", AddFog )
end