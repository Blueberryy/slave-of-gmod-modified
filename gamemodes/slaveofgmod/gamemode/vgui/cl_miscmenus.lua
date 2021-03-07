local mapVoted = false
local gametypeVoted = false

local function gettextcolor( a )
	
	local r = 0.5*math.sin(RealTime()*1.5)*255 + 255/2
	local g = -0.5*math.sin(RealTime()*1.5)*255 + 255/2
	local b = 215
	
	return Color( r, g, b, a or 255 )
	
end

function DrawVoteMenu( time )

	local w,h = ScrW(), ScrH()
	local MySelf = LocalPlayer()
	
	local TimeToClose = CurTime() + time or 20

	if VoteMenu then
		VoteMenu:Remove()
		VoteMenu = nil
	end
	
	VoteMenu = vgui.Create( "DFrame" )
	VoteMenu:SetSize( w, h )
	VoteMenu:SetPos(0,0)
	VoteMenu:SetDraggable ( false )
	VoteMenu:SetTitle("")
	VoteMenu:ShowCloseButton(false)

	VoteMenu.Paint = function( self ) 
		Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
		Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
	end

	local spacing = 25
	
	local mw, mh = w/3.5, h*0.4
	local mx, my = w/2-mw-spacing, h/2-mh/2
	
	
	//map list
	local MapList = vgui.Create( "DScrollPanel", VoteMenu )
	MapList:SetPos( mx, my )
	MapList:SetSize( mw, mh )
	MapList.Paint = function( self, tw, th )
		//surface.SetDrawColor( color_white )
		//surface.DrawOutlinedRect( 0,0,tw,th)
	end
	
	local gw, gh = mw, mh
	local gx, gy = w/2+spacing, my
	
	//gametype list
	local GtList = vgui.Create( "DScrollPanel", VoteMenu )
	GtList:SetPos( gx, gy )
	GtList:SetSize( gw, gh )
	GtList.Paint = function( self, tw, th )
		//surface.SetDrawColor( color_white )
		//surface.DrawOutlinedRect( 0,0,tw,th)
	end
	
	local Close = vgui.Create( "DButton", VoteMenu )
	Close:SetPos( mx, my + mh + spacing/2 )
	Close:SetText( "" )
	Close:SetSize( mw+gw+spacing*2, 70)	
	Close.Paint = function( self, tw, th )
			
		local shift = math.sin(RealTime()*3)*1.5 + 3
			
		local text = "CLOSE (Voting ends in "..math.Clamp(math.ceil(TimeToClose-CurTime()),0,999)..")"
			
		if self.Overed then
			draw.SimpleText( text, "PixelCutsceneScaled", tw/2 , th/2, gettextcolor( 55 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText( text, "PixelCutsceneScaled", tw/2 - shift , th/2 - shift, Color(250, 250, 250, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			draw.SimpleText( text, "PixelCutsceneScaled", tw/2, th/2, Color(250, 250, 250, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end
		
	Close.OnCursorEntered = function( self )
		self.Overed = true
	end
	Close.OnCursorExited = function( self )
		self.Overed = false
	end
	
	Close.Think = function( self )
		if TimeToClose and TimeToClose <= CurTime() then
			VoteMenu:Remove()
			VoteMenu = nil
		end
	end
	
	Close.DoClick = function( self )
		VoteMenu:Remove()
		VoteMenu = nil
	end
	
	//map list filler
	
	local MapHeader = MapList:Add( "DLabel" )
	MapHeader:SetTall( 70 )
	MapHeader:SetText("")
	MapHeader:Dock( TOP )
	MapHeader:DockMargin( 0,0,0,8 )
	
	MapHeader.Paint = function( self, tw, th )
		draw.SimpleText( "MAPS", "PixelCutsceneScaled", tw, th/2, Color(250, 250, 250, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
	end
	
	
	
	
	for k, v in pairs(GAMEMODE.AvalaibleMaps) do
		
		local map = MapList:Add( "DButton" )
		map:SetTall( 35 )
		map:SetText("")
		map:Dock( TOP )
		map:DockMargin( 0,0,0,3 )
		
		map.Paint = function( self, tw, th )
			local shift = math.sin(RealTime()*3)*1.5 + 3
			local vote = v.votes
			local text = vote == 0 and k or "("..vote..") "..k  //"("..math.random(1000,20000)..") sog_map_v"..i
			
			if self.Overed and !mapVoted then
				draw.SimpleText( text, "PixelSmall", tw - 7 , th/2, gettextcolor( 55 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
				draw.SimpleText( text, "PixelSmall", tw - shift - 7, th/2 - shift, Color(250, 250, 250, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
			else
				draw.SimpleText( text, "PixelSmall", tw, th/2, Color(250, 250, 250, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
			end
		end
		map.OnCursorEntered = function( self )
			self.Overed = true
		end
		map.OnCursorExited = function( self )
			self.Overed = false
		end
		
		map.DoClick = function( self )
		
			if mapVoted then return end
			mapVoted = true
			
			self:SetEnabled( false )
			self:SetDisabled( true )
			
			surface.PlaySound("UI/hint.wav")
			
			RunConsoleCommand("vote_map",tostring(k))
			
		end
		
	end
	
	//map list filler
	
	local GtHeader = GtList:Add( "DLabel" )
	GtHeader:SetTall( 70 )
	GtHeader:SetText("")
	GtHeader:Dock( TOP )
	GtHeader:DockMargin( 0,0,0,8 )
	
	GtHeader.Paint = function( self, tw, th )
		draw.SimpleText( "GAMETYPES", "PixelCutsceneScaled", 0, th/2, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
	end
	
	for k, v in pairs(GAMEMODE.AvalaibleGametypes) do
		
		local gt = GtList:Add( "DButton" )
		gt:SetTall( 35 )
		gt:SetText("")
		gt:Dock( TOP )
		gt:DockMargin( 0,0,0,3 )
		
		gt.Paint = function( self, tw, th )
			
			local shift = math.sin(RealTime()*3)*1.5 + 3
			
			local vote = v.votes
			local text = vote == 0 and v.name or v.name.." ("..vote..")"
			
			if self.Overed and !gametypeVoted then
				draw.SimpleText( text, "PixelSmall", 7 , th/2, gettextcolor( 55 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
				draw.SimpleText( text, "PixelSmall", 7 - shift , th/2 - shift, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			else
				draw.SimpleText( text, "PixelSmall", 0, th/2, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
			end
		end
		
		gt.OnCursorEntered = function( self )
			self.Overed = true
		end
		gt.OnCursorExited = function( self )
			self.Overed = false
		end
		
		gt.DoClick = function( self )
		
			if gametypeVoted then return end
			gametypeVoted = true
			
			self:SetEnabled( false )
			self:SetDisabled( true )
			
			surface.PlaySound("UI/hint.wav")
			
			RunConsoleCommand("vote_gametype",tostring(k))
			
		end
		
	end

end

//todo add some more shit
function DrawPlayerMenu()
	
	local w,h = ScrW(), ScrH()
	local MySelf = LocalPlayer()
	
	if PlayerMenu then
		PlayerMenu:Remove()
		PlayerMenu = nil
	end
	
	PlayerMenu = vgui.Create( "DFrame" )
	PlayerMenu:SetSize( w, h )
	PlayerMenu:SetPos(0,0)
	PlayerMenu:SetDraggable ( false )
	PlayerMenu:SetTitle("")
	PlayerMenu:ShowCloseButton(false)

	PlayerMenu.Paint = function( self ) 
		Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
		Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
	end
	
	local pw, ph = w, h*0.6
	local px, py = w/2-pw/2, h/2-ph/2
	
	local PlayerList = vgui.Create( "DScrollPanel", PlayerMenu )
	PlayerList:SetPos( px, py )
	PlayerList:SetSize( pw, ph )
	PlayerList.Paint = function( self, tw, th )
		//surface.SetDrawColor( color_white )
		//surface.DrawOutlinedRect( 0,0,tw,th)
	end
	
	//close btn
	local Close = vgui.Create( "DButton", PlayerMenu )
	Close:SetPos( px, py + ph + 12 )
	Close:SetText( "" )
	Close:SetSize( pw, 70 )	
	Close.Paint = function( self, tw, th )
			
		local shift = math.sin(RealTime()*3)*1.5 + 3
			
		local text = "CLOSE"
			
		if self.Overed then
			draw.SimpleText( text, "PixelCutsceneScaled", tw/2 , th/2, gettextcolor( 55 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText( text, "PixelCutsceneScaled", tw/2 - shift , th/2 - shift, Color(250, 250, 250, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			draw.SimpleText( text, "PixelCutsceneScaled", tw/2, th/2, Color(250, 250, 250, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end
	Close.OnCursorEntered = function( self )
		self.Overed = true
	end
	Close.OnCursorExited = function( self )
		self.Overed = false
	end	
	Close.DoClick = function( self )
		PlayerMenu:Remove()
		PlayerMenu = nil
	end
	
	//header
	local ListHeader = PlayerList:Add( "DLabel" )
	ListHeader:SetTall( 60 )
	ListHeader:SetText("")
	ListHeader:Dock( TOP )
	ListHeader:DockMargin( 0,0,0,0 )
	
	ListHeader.Paint = function( self, tw, th )
		draw.SimpleText( "PLAYERS AND SCREAMING KIDS", "PixelCutsceneScaled", tw/2, th/2, Color(250, 250, 250, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	
	//second header
	local ListHeader = PlayerList:Add( "DLabel" )
	ListHeader:SetTall( 30 )
	ListHeader:SetText("")
	ListHeader:Dock( TOP )
	ListHeader:DockMargin( 0,0,0,50 )
	
	ListHeader.Paint = function( self, tw, th )
		draw.SimpleText( "click on any to mute/unmute", "PixelSmall", tw/2, th/2, Color(210, 210, 210, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	
	for k,v in ipairs( player.GetAll() ) do
		
		local p = PlayerList:Add( "DButton" )
		p:SetTall( 35 )
		p:SetText("")
		p:Dock( TOP )
		p:DockMargin( 0,0,0,3 )
		p.Player = v
		
		p.Paint = function( self, tw, th )
			
			if !IsValid(self.Player) then return end
			
			local shift = math.sin(RealTime()*3)*1.5 + 3

			local muted = self.Player:IsMuted() and "  [MUTED]" or ""
			local text = self.Player:Name()..""..muted
			
			if self.Overed then
				draw.SimpleText( text, "PixelSmall", tw/2 , th/2, gettextcolor( 55 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText( text, "PixelSmall", tw/2 - shift, th/2 - shift, Color(250, 250, 250, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			else
				draw.SimpleText( text, "PixelSmall", tw/2, th/2, Color(250, 250, 250, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
		end
		p.OnCursorEntered = function( self )
			self.Overed = true
		end
		p.OnCursorExited = function( self )
			self.Overed = false
		end
		
		p.Think = function( self )
			if !IsValid( self.Player ) then
				self:Remove()
				self = nil
			end
		end
		
		p.DoClick = function( self )
			
			if !IsValid(self.Player) then return end
			surface.PlaySound("UI/hint.wav")
			self.Player:SetMuted( !self.Player:IsMuted() )
					
		end
	
	end
	

end

local maps = { 
	["251669441"] = "Full Frontal",
	["252102889"] = "Construction",
	["345251117"] = "Siege",
	["405905515"] = "Oxy",
	["407397840"] = "Coastal",
	["422345705"] = "The Bottom",
	["462738528"] = "Storm",
	["516489025"] = "Stakes",
}

function CheckMapsMenu()

	local ok = true

	for id, name in pairs( maps ) do
		if !steamworks.IsSubscribed( id ) then
			ok = false
			break
		end
	end
	
	for id, name in pairs( maps ) do
		if !steamworks.ShouldMountAddon( id ) then
			ok = false
			break
		end
	end
	
	if ok then return true end
	
	
	local w,h = ScrW(), ScrH()
	local MySelf = LocalPlayer()
	
	if MapsMenu then
		MapsMenu:Remove()
		MapsMenu = nil
	end
	
	MapsMenu = vgui.Create( "DFrame" )
	MapsMenu:SetSize( w, h )
	MapsMenu:SetPos(0,0)
	MapsMenu:SetDraggable ( false )
	MapsMenu:SetTitle("")
	MapsMenu:ShowCloseButton(false)

	MapsMenu.Paint = function( self )
		surface.SetDrawColor( Color( 0, 0, 0, 230 ) )
		surface.DrawRect( 0, 0, w, h )
		Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
		//Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
	end
	
	local pw, ph = w, h*0.6
	local px, py = w/2-pw/2, h/2-ph/2
	
	local MapsList = vgui.Create( "DScrollPanel", MapsMenu )
	MapsList:SetPos( px, py )
	MapsList:SetSize( pw, ph )
	MapsList.Paint = function( self, tw, th )
		
	end
	
	//close btn
	local Close = vgui.Create( "DButton", MapsMenu )
	Close:SetPos( px, py + ph + 12 )
	Close:SetText( "" )
	Close:SetSize( pw, 70 )	
	Close.Paint = function( self, tw, th )
			
		local shift = math.sin(RealTime()*3)*1.5 + 3
			
		local text = "CLOSE"
			
		if self.Overed then
			draw.SimpleText( text, "PixelCutsceneScaled", tw/2 , th/2, gettextcolor( 55 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText( text, "PixelCutsceneScaled", tw/2 - shift , th/2 - shift, Color(250, 250, 250, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			draw.SimpleText( text, "PixelCutsceneScaled", tw/2, th/2, Color(250, 250, 250, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end
	Close.OnCursorEntered = function( self )
		self.Overed = true
	end
	Close.OnCursorExited = function( self )
		self.Overed = false
	end	
	Close.DoClick = function( self )
		MapsMenu:Remove()
		MapsMenu = nil
	end
	
	//header
	local ListHeader = MapsList:Add( "DLabel" )
	ListHeader:SetTall( 60 )
	ListHeader:SetText("")
	ListHeader:Dock( TOP )
	ListHeader:DockMargin( 0,0,0,0 )
	
	ListHeader.Paint = function( self, tw, th )
		draw.SimpleText( "YOU NEED THESE MAPS IN ORDER TO PLAY STORY MODE", "PixelCutsceneScaled", tw/2, th/2, Color(250, 250, 250, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	
	//second header
	local ListHeader = MapsList:Add( "DLabel" )
	ListHeader:SetTall( 30 )
	ListHeader:SetText("")
	ListHeader:Dock( TOP )
	ListHeader:DockMargin( 0,0,0,50 )
	
	ListHeader.Paint = function( self, tw, th )
		draw.SimpleText( "click on missing maps, so you can download them", "PixelSmall", tw/2, th/2, Color(210, 210, 210, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	
	for id,name in pairs( maps ) do
		
		if steamworks.IsSubscribed( id ) and steamworks.ShouldMountAddon( id ) then continue end
		
		local p = MapsList:Add( "DButton" )
		p:SetTall( 35 )
		p:SetText("")
		p:Dock( TOP )
		p:DockMargin( 0,0,0,3 )
		p.id = id
		
		p.Paint = function( self, tw, th )
				
			local installed = steamworks.IsSubscribed( self.id )
			local enabled = steamworks.ShouldMountAddon( self.id )
				
			local shift = math.sin(RealTime()*3)*1.5 + 3

			local inst = installed and "  [INSTALLED, "..(enabled and "ENABLED" or "DISABLED").."]" or " [MISSING] <-- click here to download it"
			local enb = enabled and "" or " <-- enable it in 'Addons' menu"
			local text = name..""..inst..""..enb
			
			if self.Overed then
				draw.SimpleText( text, "PixelSmall", tw/2 , th/2, gettextcolor( 55 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				draw.SimpleText( text, "PixelSmall", tw/2 - shift, th/2 - shift, Color(250, 250, 250, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			else
				draw.SimpleText( text, "PixelSmall", tw/2, th/2, Color(250, 250, 250, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
		end
		p.OnCursorEntered = function( self )
			self.Overed = true
		end
		p.OnCursorExited = function( self )
			self.Overed = false
		end
		
		p.Think = function( self )
			local installed = steamworks.IsSubscribed( self.id )
			local enabled = steamworks.ShouldMountAddon( self.id )
			if installed then
				p:SetDisabled( true )
				p:SetEnabled( false )
			else
				p:SetDisabled( false )
				p:SetEnabled( true )
			end
		end
		
		p.DoClick = function( self )
			
			surface.PlaySound("UI/hint.wav")
			steamworks.ViewFile( self.id ) 
					
		end
	
	end
	
	return false

end

function CheckMulticore()
	
	local convar1 = GetConVarNumber( "gmod_mcore_test" )
	local convar2 = GetConVarNumber( "cl_threaded_bone_setup" )
	
	if convar1 == 1 and convar2 == 1 then return end
	
	local w,h = ScrW(), ScrH()
	local MySelf = LocalPlayer()
	
	if MCore then
		MCore:Remove()
		MCore = nil
	end
	
	MCore = vgui.Create( "DFrame" )
	MCore:SetSize( w, h )
	MCore:SetPos(0,0)
	MCore:SetDraggable ( false )
	MCore:SetTitle("")
	MCore:ShowCloseButton(false)

	MCore.Paint = function( self )
		surface.SetDrawColor( Color( 0, 0, 0, 230 ) )
		surface.DrawRect( 0, 0, w, h )
		Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
	end
	
	local pw, ph = w/2, h*0.6
	local px, py = w/2-pw/2, h/2-ph/2
		
	//agree btn
	local Yes = vgui.Create( "DButton", MCore )
	Yes:SetPos( w/2 - pw, h/2+70/2 )
	Yes:SetText( "" )
	Yes:SetSize( pw, 70 )	
	Yes.Paint = function( self, tw, th )
			
		local shift = math.sin(RealTime()*3)*1.5 + 3
			
		local text = "YES"
			
		if self.Overed then
			draw.SimpleText( text..", I want good FPS", "PixelCutsceneScaled", tw - 60 , th/2, gettextcolor( 55 ), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
			draw.SimpleText( text..", I want good FPS", "PixelCutsceneScaled", tw - 60 - shift , th/2 - shift, Color(250, 250, 250, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		else
			draw.SimpleText( text, "PixelCutsceneScaled", tw - 60, th/2, Color(250, 250, 250, 255), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
		end
	end
	Yes.OnCursorEntered = function( self )
		self.Overed = true
	end
	Yes.OnCursorExited = function( self )
		self.Overed = false
	end	
	Yes.DoClick = function( self )
		
		RunConsoleCommand("gmod_mcore_test", "1")
		RunConsoleCommand("cl_threaded_bone_setup", "1")
	
		surface.PlaySound("UI/hint.wav")
	
		MCore:Remove()
		MCore = nil
	end
	
	//disagree btn
	local No = vgui.Create( "DButton", MCore )
	No:SetPos( w/2, h/2+70/2 )
	No:SetText( "" )
	No:SetSize( pw, 70 )	
	No.Paint = function( self, tw, th )
			
		local shift = math.sin(RealTime()*3)*1.5 + 3
			
		local text = "NO"
			
		if self.Overed then
			draw.SimpleText( text..", I want shitty FPS", "PixelCutsceneScaled", 60 , th/2, gettextcolor( 55 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			draw.SimpleText( text..", I want shitty FPS", "PixelCutsceneScaled", 60 - shift , th/2 - shift, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		else
			draw.SimpleText( text, "PixelCutsceneScaled", 60, th/2, Color(250, 250, 250, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		end
	end
	No.OnCursorEntered = function( self )
		self.Overed = true
	end
	No.OnCursorExited = function( self )
		self.Overed = false
	end	
	No.DoClick = function( self )
	
		surface.PlaySound("UI/hint.wav")
	
		MCore:Remove()
		MCore = nil
	end
	
	//header
	local ListHeader = MCore:Add( "DLabel" )
	ListHeader:SetTall( 60 )
	ListHeader:SetText("")
	ListHeader:Dock( TOP )
	ListHeader:DockMargin( 0,100,0,0 )
	
	ListHeader.Paint = function( self, tw, th )
		draw.SimpleText( "ENABLE MULTICORE RENDERING?", "PixelCutsceneScaled", tw/2, th/2, Color(250, 250, 250, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	
	//second header
	local ListHeader = MCore:Add( "DLabel" )
	ListHeader:SetTall( 30 )
	ListHeader:SetText("")
	ListHeader:Dock( TOP )
	ListHeader:DockMargin( 0,0,0,50 )
	
	ListHeader.Paint = function( self, tw, th )
		draw.SimpleText( "you will get more FPS, obviously", "PixelSmall", tw/2, th/2, Color(210, 210, 210, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	end
	
end

local credits_font = "PixelCutsceneScaled"

local function CheckFontSize()
	
	if credits_font ~= "PixelCutsceneScaled" then return end
	
	local t = "WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW"
	local w = ScrW()
	
	surface.SetFont( "PixelCutsceneScaled" )

	local tw, th = surface.GetTextSize( t )
	
	if w < tw + 130 then
		credits_font = 	"PixelCutsceneScaledSmall"
	else
		credits_font = 	"PixelCutsceneScaled"
	end
	
	
end

local CreditsText = [[
SLAVE OF GMOD
by Necrossin











Inspired by Hotline Miami
and based on all the horrors/drama in this game










Maps by

Pufulet
Danny Judas
Stelk
RzDat (their map was unused, but still)



Music by

Various music artists, that are shown in menu
Current one is: "It's Raining Knives" by Espectrostatic



Special thanks to
(playtesters, ideas, feedback, etc...)

_Kilburn
Clavus
Pufulet
Danny Judas
-Milbor-
Chubakus
Gorma
Ben
Braindawg
MarshmallowTophat
The Darker One
Revenge
Triviality
B1LP0
DN-Reznov
All other people I've forgot to add here

Mr. Green community (for hosting it back then)
Knockout community (former Facepunch community)



And you, for still playing











The End
]]

local SuperhotText = [[
SUPERHOT MODE
unlocked


"Time moves when you move"

Type !superhot in chat to toggle




(Story Mode only)
]]

local FirstpersonText = [[
FIRSTPERSON MODE
unlocked


"You were given a revelation"

Type !firstperson in chat to toggle

NOTE: this might look weird on certain maps/levels,
so use it at your own risk


(Story Mode only)
]]

local col_in_game = Color( 115, 190, 62 )
local undo_shrink = false

local goal_pos = Vector( -3760.9, 1052.9, 971.17 )
local goal_ang = Angle( 20.9, -40.43, 0 )

local start_pos
local start_ang

local function EndingCalcView( pl, origin, angles, fov, znear, zfar )
	
	if GAMEMODE:GetFirstPerson() and Credits and Credits.StartDuration and Credits.StartTime then
		
		if not undo_shrink then
			local bone = pl:LookupBone("ValveBiped.Bip01_Head1")
			if bone then
				pl:ManipulateBoneScale( bone, Vector(1,1,1)  )
				pl:ManipulateBoneScale( bone, Vector(1,1,1)  )
				pl:ManipulateBoneScale( bone, Vector(1,1,1)  )
			end
			undo_shrink = true
		end
		
		if not start_ang then
			start_ang = Angle( 0, 0, 0 ) //LocalPlayer():EyeAngles()
			start_ang.p = 0
		end
		if not start_pos then
			start_pos = LocalPlayer():GetPos() + vector_up * 54 - start_ang:Forward() * 40
		end
		
		local delta = math.Clamp( 1 - ( Credits.StartTime - CurTime() ) / Credits.StartDuration, 0, 1 )
		delta = delta ^ 2

		local new_pos = LerpVector( delta, start_pos, goal_pos )
		local new_ang = LerpAngle( delta, start_ang, goal_ang )
		
		return { origin = new_pos, angles = new_ang, drawviewer = true, fov = fov, znear = 1, zfar = zfar }
		
	end
	
	
end

local function EndingCalcMainActivity( pl, vel )
	
	if GAMEMODE:GetFirstPerson() and Credits and Credits.AnimDuration and Credits.AnimTime then
		local iSeq, iIdeal = pl:LookupSequence("death_04")
		return iIdeal, iSeq 
	end
	
end

local function EndingUpdateAnimation( pl, velocity, maxseqgroundspeed )
	
	if GAMEMODE:GetFirstPerson() and Credits and Credits.AnimDuration and Credits.AnimTime then
		local delta = math.Clamp( 1 - ( Credits.AnimTime - CurTime() ) / Credits.AnimDuration, 0, 1 )
		//delta = delta ^ 2
		pl:SetCycle( 0.63 * delta )
		
		local bone = pl:LookupBone("ValveBiped.Bip01_Spine2")
		if bone then
			pl:ManipulateBoneAngles( bone, Angle( 0, 25 * delta, 0 ) )
		end
		
		bone = pl:LookupBone("ValveBiped.Bip01_L_UpperArm")
		if bone then
			pl:ManipulateBoneAngles( bone, Angle( -40 * delta, -40 * delta, -21 * delta ) )
		end
		
		bone = pl:LookupBone("ValveBiped.Bip01_R_UpperArm")
		if bone then
			pl:ManipulateBoneAngles( bone, Angle( 25 * delta, -15 * delta, 12 * delta ) )
		end
		
		return true
	end
	
end

local function EndingSetupWorldFog()
	
	if GAMEMODE:GetFirstPerson() and Credits and Credits.StartDuration and Credits.StartTime then

		local delta = math.Clamp( ( Credits.StartTime - CurTime() ) / Credits.StartDuration, 0, 1 )
		delta = delta ^ 2
	
		render.FogMode( 1 ) 
		render.FogStart( 0 )
		render.FogEnd( 65000 * delta + 400 )
		render.FogMaxDensity( 0.999 )
		
		render.FogColor( 10, 10, 10 )

		return true
	
	end

end

local function EndingSetupSkyboxFog( skyboxscale )
	
	if GAMEMODE:GetFirstPerson() and Credits and Credits.StartDuration and Credits.StartTime then

		local delta = math.Clamp( ( Credits.StartTime - CurTime() ) / Credits.StartDuration, 0, 1 )
		delta = delta ^ 2
	
		render.FogMode( 1 ) 
		render.FogStart( 0 * skyboxscale )
		render.FogEnd( 65000 * delta * skyboxscale + 400 * skyboxscale )
		render.FogMaxDensity( 0.999 )
		
		render.FogColor( 10, 10, 10 )

		return true
	
	end

end

	

function DrawEnding()
	
	hook.Remove( "CalcView", "EndingCalcView" )
	hook.Remove( "CalcMainActivity", "EndingCalcMainActivity" )
	hook.Remove( "UpdateAnimation", "EndingUpdateAnimation" )
	hook.Remove( "SetupWorldFog","EndingSetupWorldFog" )
	hook.Remove( "SetupSkyboxFog","EndingSetupSkyboxFog" )
	
	start_pos = nil
	start_ang = nil
	
	if GAMEMODE.Music then
		GAMEMODE.Music:Stop()
	end
	
	CheckFontSize()
	
	PLAYBACK_APPROACH = nil
	if SCENE then
		SCENE.MusicPlayback = 1
	end
	UPDATE_PLAYBACK = true
	
	local start_dur = 80.4 // start is 80.4

	if Credits then
		Credits:Remove()
		Credits = nil
	end
	
	if SOG_AUTOPLAY_MUSIC then
		GAMEMODE:CreateMusic( MUSIC_TYPE_NORMAL, 114279811, 60, false, nil, nil, true )
	end
	
	hook.Add( "CalcView", "EndingCalcView", EndingCalcView )
	hook.Add( "CalcMainActivity", "EndingCalcMainActivity", EndingCalcMainActivity )
	hook.Add( "UpdateAnimation", "EndingUpdateAnimation", EndingUpdateAnimation )
	hook.Add( "SetupWorldFog","EndingSetupWorldFog", EndingSetupWorldFog )
	hook.Add( "SetupSkyboxFog","EndingSetupSkyboxFog", EndingSetupSkyboxFog )
	
	local w,h = ScrW(), ScrH()
	
	Credits = vgui.Create( "DFrame" )
	Credits:SetSize( w, h )
	Credits:SetPos(0,0)
	Credits:SetDraggable ( false )
	Credits:SetTitle("")
	Credits:ShowCloseButton(false)
	
	Credits.StartDuration = start_dur
	Credits.StartTime = CurTime() + start_dur
	
	Credits.AnimDuration = 3
	//Credits.AnimTime = CurTime() + Credits.AnimDuration
	
	Credits.WindupDuration = 5
	
	Credits.TextDuration = 87 - Credits.WindupDuration // start is 87 - windup
	
	Credits.Players = math.random( 45000, 64000 )
	
	Credits.Think = function( self )
		if self.EnableClicker then
			gui.EnableScreenClicker( true )
		end
	end
	
	Credits.Paint = function( self, tw, th )
	
		local delta = math.Clamp( 1 - ( Credits.StartTime - CurTime() ) / Credits.StartDuration, 0, 1 )
		
		if delta > 0.65 and not self.AnimTime then
			self.AnimTime = CurTime() + self.AnimDuration
		end

		if self.StartTime and self.StartTime < CurTime() and not self.DrawStuff then
			self.WindupTime = CurTime() + self.WindupDuration
			self.DrawStuff = true
		end
	
		if not self.DrawStuff then return end
	
		surface.SetDrawColor( Color( 20, 20, 20, 255 ) )
		surface.DrawRect( 0, 0, w, h )
	
		surface.SetFont( credits_font )
		local spacing_w, spacing_h = surface.GetTextSize( "WWWWWWWW" ) 
		local textw, texth = surface.GetTextSize( CreditsText )
		
		local scroll = 0
		
		if self.WindupTime and self.WindupTime < CurTime() and not self.DoText then
			self.TextTime = CurTime() + self.TextDuration
			self.DoText = true
		end
		
		if self.TextTime and self.TextDuration then
			scroll = math.Clamp( 1 - ( self.TextTime - CurTime() ) / self.TextDuration, 0, 1 )
		end
		
		if scroll == 1 then
			self.EnableClicker = true
		end
			
		local col_delta = math.Clamp( 1 - ( self.WindupTime - CurTime() ) / self.WindupDuration, 0, 1 )
		col_delta = col_delta ^ 0.5
			
		draw.DrawText( CreditsText, credits_font, tw/2, th/2 - texth * scroll - ( spacing_h - spacing_h * scroll * 2  ), Color(210, 210, 210, 255 * col_delta ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	
		if self.DoText and self.Players then
			draw.DrawText( math.floor( self.Players * ( 1 - scroll ) ).." In-Game", "TargetID", tw - 30, th - 30, col_in_game, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM )
		end
		
		if self.ShowCheats then
			
			surface.SetDrawColor( Color( 20, 20, 20, 255 ) )
			surface.DrawRect( 0, 0, w, h )
			
			surface.SetFont( credits_font )
			
			local text = self.ShowCheats == 1 and SuperhotText or FirstpersonText
			local textw, texth = surface.GetTextSize( text )
			
			
			draw.DrawText( text, credits_font, tw/2, th/2 - texth/2, Color( 210, 210, 210, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
		
	end
	
	Credits.OnMousePressed = function( self )
	
		self.NextClick = self.NextClick or 0
		
		if self.NextClick > CurTime() then return end
		if not self.TextTime then return end
		
		if self.TextTime and self.TextTime > CurTime() then return end
		
		local snd = false
		
		if self.ShowCheats and self.ShowCheats == 2 then
			RunConsoleCommand( "sog_beatstory", "1" )
			RunConsoleCommand( "changelevel", game.GetMap() )
			return
		end
		
		if self.ShowCheats and self.ShowCheats == 1 then
			self.ShowCheats = 2
			snd = true
		end
		
		
		if not self.ShowCheats then 
			self.ShowCheats = 1
			snd = true
		end
		
		if snd then
			surface.PlaySound( "weapons/physcannon/energy_disintegrate"..math.random( 4, 5 )..".wav" )
		end
		
		self.NextClick = CurTime() + 1.3
	end

end
