local Dialogues = {}
local Actions = {}

local DialogueKeywords = {
	["!g"] = function() GAMEMODE.GlitchTime = CurTime() + 2 end,
	["!i"] = function()  end,
}

function AddDialogueLine( person, ... )
	
	local line = {}
	
	line.person = person
	line.text = {...} or {}

	table.insert( Dialogues, line )
		
end

function AddDialogueAction( person, action )
	
	local act = {}
	
	act.person = person
	act.action = action or nil
	
	//basically it goes after the line, yet it gets called when the line above activates. If anything that I just said makes any sense.
	Actions[ #Dialogues ] = act
	
	//table.insert( Actions, act )
		
end

local mat = Material( "sog/bg_gradient3.png" )
local blank = Material( "sog/default.png", "smooth" )

//todo: finish in-game dialogue support

DialogueFont = "PixelCutsceneScaled"

local function CheckFontSize()
	
	if DialogueFont ~= "PixelCutsceneScaled" then return end
	
	local t = "WWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW"
	local w = ScrW()
	
	surface.SetFont( "PixelCutsceneScaled" )

	local tw, th = surface.GetTextSize( t )
	
	if w < tw + 130 then
		DialogueFont = 	"PixelCutsceneScaledSmall"
	else
		DialogueFont = 	"PixelCutsceneScaled"
	end
	
	
end

//just to avoid creating new table each frame
local poly = { {}, {}, {}, {} }
function DrawDialogue( req_finish )

	local w,h = ScrW(), ScrH()
	local MySelf = LocalPlayer()
	local drawtime = 0.4
	
	RunConsoleCommand( "-attack", "" )

	CheckFontSize()
	
	if Dialogue then
		Dialogue:Remove()
		Dialogue = nil
	end
	
	Dialogue = vgui.Create( "DFrame" )
	Dialogue:SetSize( w, h )
	Dialogue:SetPos(0,0)
	Dialogue:SetDraggable ( false )
	Dialogue:SetTitle("")
	Dialogue:ShowCloseButton( false )
	
	Dialogue.CurrentLine = 1
	Dialogue.CurrentSubLine = 1
	
	//Dialogue.MouseCloseTimer = 0
	
	Dialogue.DrawTime = CurTime() + drawtime
	
	Dialogue.Icon = nil
	
	Dialogue.TextTime = CurTime() + 0.45
	
	if Dialogues and Dialogues[ Dialogue.CurrentLine ] and Dialogues[ Dialogue.CurrentLine ].person and IsValid( Dialogues[ Dialogue.CurrentLine ].person ) then
		dialoguepos = Dialogues[ Dialogue.CurrentLine ].person:GetPos()
		if Dialogues[ Dialogue.CurrentLine ].person:IsNextBot() and Dialogues[ Dialogue.CurrentLine ].person:GetDTString( 1 ) ~= "" then
			Dialogues[ Dialogue.CurrentLine ].person.Icon = Material( Dialogues[ Dialogue.CurrentLine ].person:GetDTString( 1 ), "smooth" )
		end
		if Dialogues[ Dialogue.CurrentLine ].person and Dialogues[ Dialogue.CurrentLine ].person == Entity(1) and SCENE and SCENE.FlipPlayerIcon then
			Dialogue.FlipIcon = true
		end
		Dialogue.Icon = Dialogues[ Dialogue.CurrentLine ].person.Icon or ( Dialogues[ Dialogue.CurrentLine ].person:IsPlayer() or Dialogues[ Dialogue.CurrentLine ].person:IsNextBot() ) and Dialogues[ Dialogue.CurrentLine ].person:GetCharIcon()
		
		local text = Dialogues[ Dialogue.CurrentLine ].text and Dialogues[ Dialogue.CurrentLine ].text[ Dialogue.CurrentSubLine ]
		
		if text then
			for k, v in pairs( DialogueKeywords ) do
				if string.find( translate.Get(text), k, 1, true ) then
					v()
				end
			end
		end

	end
	
	if Actions and Actions[ Dialogue.CurrentLine ] and Actions[ Dialogue.CurrentLine ].action and Actions[ Dialogue.CurrentLine ].person and IsValid( Actions[ Dialogue.CurrentLine ].person ) then
		Actions[ Dialogue.CurrentLine ].action( Actions[ Dialogue.CurrentLine ].person )
	end
	
	Dialogue.OnMousePressed = function ( self, mouse )
		
			if self.IsClosing then return end
			if not self.IsClosing and ( self.DrawTime + 0.2 ) > CurTime() then return end
			
			if mouse == MOUSE_RIGHT then
				self.MouseCloseTimer = CurTime() + 1
				return
			end
			
			if mouse ~= MOUSE_LEFT then return end
			
			local lines = Dialogues and #Dialogues or 1
			local sublines = Dialogues and Dialogues[ self.CurrentLine ] and Dialogues[ self.CurrentLine ].text and #Dialogues[ self.CurrentLine ].text or 1
			
			self.CurrentSubLine = self.CurrentSubLine + 1
			
			local text = Dialogues and Dialogues[ Dialogue.CurrentLine ] and Dialogues[ self.CurrentLine ].text and Dialogues[ self.CurrentLine ].text[ self.CurrentSubLine ]
		
			if text then
				for k, v in pairs( DialogueKeywords ) do
					if string.find( translate.Get(text), k, 1, true ) then
						v()
					end
				end
			end
			
			//self.TextTime = 0
			self.TextTime = CurTime() + 0.45
			
			if self.CurrentSubLine > sublines then
				
				self.CurrentLine = self.CurrentLine + 1
				self.CurrentSubLine = 1
								
				if Dialogues and Dialogues[ Dialogue.CurrentLine ] and Dialogues[ Dialogue.CurrentLine ].person and IsValid( Dialogues[ Dialogue.CurrentLine ].person ) then
					dialoguepos = Dialogues[ Dialogue.CurrentLine ].person:GetPos()
					Dialogue.Icon = nil
					Dialogue.FlipIcon = nil
					if Dialogues[ Dialogue.CurrentLine ].person:IsNextBot() and Dialogues[ Dialogue.CurrentLine ].person:GetDTString( 1 ) ~= "" then
						Dialogues[ Dialogue.CurrentLine ].person.Icon = Material( Dialogues[ Dialogue.CurrentLine ].person:GetDTString( 1 ), "smooth" )
					end
					if Dialogues[ Dialogue.CurrentLine ].person and Dialogues[ Dialogue.CurrentLine ].person == Entity(1) and SCENE and SCENE.FlipPlayerIcon then
						Dialogue.FlipIcon = true
					end
					Dialogue.Icon = Dialogues[ Dialogue.CurrentLine ].person.Icon or ( Dialogues[ Dialogue.CurrentLine ].person:IsPlayer() or Dialogues[ Dialogue.CurrentLine ].person:IsNextBot() ) and Dialogues[ Dialogue.CurrentLine ].person:GetCharIcon()
					
					local text = Dialogues and Dialogues[ Dialogue.CurrentLine ] and Dialogues[ self.CurrentLine ].text and Dialogues[ self.CurrentLine ].text[ self.CurrentSubLine ]
		
					if text then
						for k, v in pairs( DialogueKeywords ) do
							if string.find( translate.Get(text), k, 1, true ) then
								v()
							end
						end
					end
					
				end
				
				if Actions and Actions[ Dialogue.CurrentLine ] and Actions[ Dialogue.CurrentLine ].action and Actions[ Dialogue.CurrentLine ].person and IsValid( Actions[ Dialogue.CurrentLine ].person ) then
					Actions[ Dialogue.CurrentLine ].action( Actions[ Dialogue.CurrentLine ].person )
				end
				
				if self.CurrentLine > lines then
														
					self.DrawTime = CurTime() + drawtime
					self.IsClosing = true
				
					dialoguepos = nil
					
				end				
				
			end
	
	end
	
	Dialogue.OnMouseReleased = function ( self, mouse )
		
		if mouse == MOUSE_RIGHT then
			self.MouseCloseTimer = nil
			return
		end
		
	end
	
	Dialogue.Think = function( self ) 

		if not self.Closing then
			
			//self.NextMouseTimer = self.NextMouseTimer or 0
			if self.MouseCloseTimer and self.MouseCloseTimer < CurTime() then
			
				self:OnMouseReleased( MOUSE_RIGHT )
			
				self.DrawTime = CurTime() + drawtime
				self.IsClosing = true
				
				dialoguepos = nil
			end
			
			
		end
	
	
		if Dialogues and Dialogues[ Dialogue.CurrentLine ] and Dialogues[ Dialogue.CurrentLine ].person and IsValid( Dialogues[ Dialogue.CurrentLine ].person ) then
			dialoguepos = Dialogues[ Dialogue.CurrentLine ].person:GetPos()
		end
	
		if self.IsClosing and self.DrawTime <= CurTime() then
			
			if game.SinglePlayer() and req_finish then
				net.Start( "FinishDialogue" )
				net.SendToServer()
			end
			
			table.Empty( Dialogues )
			table.Empty( Actions )
			
			dialoguepos = nil
			
			//hide cutscene as well
			if Cut and Cut:IsValid() and Cut.sc and Cut.sc:IsValid() then
				Cut.sc:OnMousePressed()
			end
			
			self:Remove()
			self = nil
		end
	end
	
	Dialogue.Paint = function( self, sw, sh )
		
		local delta = math.Clamp(  1 - ( self.DrawTime - CurTime() ) / drawtime , 0, 1)
		
		local textdelta = math.Clamp(  1 - ( self.TextTime - CurTime() ) / 0.45 , 0, 1)
		
		if self.IsClosing then
			delta = math.Clamp(  ( self.DrawTime - CurTime() ) / drawtime , 0, 1)
		end
		
		local r = 0.5*math.sin(RealTime()*1.5)*255 + 255/2
		local g = -0.5*math.sin(RealTime()*1.5)*255 + 255/2
		local b = 215
		
		//the character screenie
				
		poly[1].x, poly[1].y = sw-sw/2.5*delta + 40, 0
		poly[2].x, poly[2].y = sw+sw/2.5-sw/2.5*delta + 40, 0
		poly[3].x, poly[3].y = sw+sw/4-sw/4*delta + 40, sh
		poly[4].x, poly[4].y = sw-sw/4*delta + 40, sh
		
		surface.SetDrawColor( color_black )
		draw.NoTexture()
		surface.DrawPoly( poly )
		
		poly[1].x, poly[1].y = sw-sw/2.5*delta + 1 + 40, 0
		poly[2].x, poly[2].y = sw+sw/2.5-sw/2.5*delta + 1 + 40, 0
		poly[3].x, poly[3].y = sw+sw/4-sw/4*delta + 1 + 40, sh
		poly[4].x, poly[4].y = sw-sw/4*delta + 1 + 40, sh
		
		surface.SetDrawColor( Color( 200, 200, 200, 185 ) )
		draw.NoTexture()
		surface.DrawPoly( poly )
		
		poly[1].x, poly[1].y = sw-sw/2.5*delta + 4 + 40, 0
		poly[2].x, poly[2].y = sw+sw/2.5-sw/2.5*delta + 4 + 40, 0
		poly[3].x, poly[3].y = sw+sw/4-sw/4*delta + 4 + 40, sh
		poly[4].x, poly[4].y = sw-sw/4*delta + 4 + 40, sh
		
		surface.SetDrawColor( color_black )
		draw.NoTexture()
		surface.DrawPoly( poly )
		
		//colorful one
		poly[1].x, poly[1].y, poly[1].u, poly[1].v = sw-sw/2.5*delta + 5 + 40, 0, 0, 0
		poly[2].x, poly[2].y, poly[2].u, poly[2].v = sw+sw/2.5-sw/2.5*delta + 5 + sh/2 + 40, -sh/2, 0, 1
		poly[3].x, poly[3].y, poly[3].u, poly[3].v = sw+sw/4-sw/4*delta + 5 +sh/2 + 40, sh, 1, 1
		poly[4].x, poly[4].y, poly[4].u, poly[4].v = sw-sw/4*delta + 5 + 40, sh, 1, 0
		
		draw.NoTexture()
		surface.SetMaterial( mat )
		surface.SetDrawColor( Color(r, g, b, 180) )
		surface.DrawPoly( poly )
		
		//upper black bar
		surface.SetDrawColor( color_black )
		surface.DrawRect( 0, 0, sw, sh/5 * delta )
		
		surface.SetDrawColor( Color( 200, 200, 200, 185 ) )
		surface.DrawRect( 0, ( sh/5 * delta )-4, sw, 3 )
		
		draw.DrawText( translate.Get("sog_dialogue_menu_skip"), "PixelSmaller", 130 , ( sh/5 - 40 ) * delta, Color( 110, 110, 110, 255), TEXT_ALIGN_LEFT )
		
		surface.SetFont( "PixelSmaller" )
		local barw, barh = surface.GetTextSize( translate.Get("sog_dialogue_menu_skip") ) 
		
		local bar_delta = 1
		
		if self.MouseCloseTimer and self.MouseCloseTimer >= CurTime() then
		
			bar_delta = math.Clamp( 1 - ( self.MouseCloseTimer - CurTime() ), 0, 1 )
		
			surface.SetDrawColor( Color( 20 + 90 * bar_delta, 20 + 90 * bar_delta, 20 + 90 * bar_delta, 255) )
			surface.DrawRect( 130, ( sh/5 - 40 ) * delta - 3, barw * bar_delta, 2 )
		end
		
		
		//bottom black bar
		surface.SetDrawColor( color_black )
		surface.DrawRect( 0, sh-(sh/4 * delta), sw, sh/4 )
		
		surface.SetDrawColor( Color( 200, 200, 200, 185 ) )
		surface.DrawRect( 0, sh-(sh/4 * delta)+1, sw, 3 )
		
		//face
		surface.SetMaterial( Dialogue.Icon or blank )
		local rotation = math.sin( RealTime() * ( 0.8 ) ) * 7

		if Dialogue.FlipIcon then
			rotation = rotation + 180
		end
		
		if Dialogue.SpinPortrait then
			rotation = RealTime() * -700
		end		
		
		surface.SetDrawColor( 10,10,10,185 )
		surface.DrawTexturedRectRotated( sw - sw/6*delta + (1-delta)*sw/6  + 5 + 40, sh/2 + 5 - 15, sh/1.9, sh/1.9, rotation)
			
		surface.SetDrawColor( Dialogue.Icon and color_white or Color(10,10,10,255) )//color_white
		surface.DrawTexturedRectRotated( sw - sw/6*delta + (1-delta)*sw/6 + 40, sh/2 - 15, sh/1.9, sh/1.9, rotation)
		
		if Dialogues[ self.CurrentLine ] then
		
			local text = Dialogues[ self.CurrentLine ].text and Dialogues[ self.CurrentLine ].text[ self.CurrentSubLine ] or translate.Get("sog_menu_error")
			
			//fix some stuff
			text = string.gsub( text, "\\n", "\n" )
			text = string.gsub( translate.Get(text), "!g", "" )
			text = string.gsub( text, "!i", "" )
			text = string.gsub( translate.Get(text), "!PLAYERNAME", LocalPlayer():Name() or "" )
			text = string.upper( translate.Get(text) )
		
			local tx, ty = 130, sh-(sh/4 * delta)+40
			
			local shift = math.sin(RealTime()*3)*1.5 + 3
			
			draw.DrawText(text, DialogueFont, tx , ty, Color(r, g, b, 55 * textdelta),TEXT_ALIGN_LEFT)
			draw.DrawText(text, DialogueFont, tx - shift, ty - shift, Color(210, 210, 210, 255*textdelta),TEXT_ALIGN_LEFT)
		
		end
	
	
	end
	
end