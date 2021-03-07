
local blank = Material( "sog/default.png" )
local gradient = surface.GetTextureID("VGUI/gradient_down")
local gradient2 = surface.GetTextureID("VGUI/gradient_up")

local function fixvolume( s, delta ) 
	if delta > 0 then
		if GAMEMODE.Radio and GAMEMODE.Radio:IsValid() and !( GAMEMODE.SceneAmbient and GAMEMODE.SceneAmbient:IsValid() ) then
			GAMEMODE.Radio:RunJavascript( "IncreaseVolume();" )
		end
	end
		
	if delta < 0 then		
		if GAMEMODE.Radio and GAMEMODE.Radio:IsValid() and !( GAMEMODE.SceneAmbient and GAMEMODE.SceneAmbient:IsValid() ) then
			GAMEMODE.Radio:RunJavascript( "DecreaseVolume();" )
		end
	end
end

function DrawCharacterMenu( func, char )
	
	local w,h = ScrW(), ScrH()
	local MySelf = LocalPlayer()
	
	local styles
	local char_id
	
	if char then
		local id = GAMEMODE:GetCharacterIdByReference( char )
		if id and GAMEMODE.Characters[ id ] and GAMEMODE.Characters[ id ].Styles then
			styles = GAMEMODE.Characters[ id ].Styles
			char_id = id
		end
	end

	if CharMenu then
		CharMenu:Remove()
		CharMenu = nil
	end

	CharMenu = vgui.Create( "DFrame" )
	CharMenu:SetSize( w, h )///1.5
	CharMenu:SetPos( 0,0)// h-CharMenu:GetTall() )
	CharMenu:SetDraggable ( false )
	CharMenu:SetTitle("")
	CharMenu:ShowCloseButton (false)
	CharMenu.Paint = function( self ) 
		Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
	end 
	CharMenu.OnMouseWheeled = fixvolume
	
	local parent = CharMenu:Add( "DPanel" )
	parent:SetSize( w, h/1.5 )
	parent:SetPos( 0, h-parent:GetTall() )
	parent.Paint = function() end

	local Row = parent:Add( "DPanel" )
	Row:SetSize( parent:GetWide(), parent:GetTall()/2.3 )
	Row:SetPos( 0, parent:GetTall()/12)
	
	Row.Btn = {}
	
	local Desc = parent:Add( "DPanel" )
	Desc:SetSize( parent:GetWide(), parent:GetTall()/3.3 )
	Desc:SetPos( 0, parent:GetTall()/12 + Row:GetTall())
	Desc.OnMouseWheeled = fixvolume
	Desc.Paint = function( self, sw, sh )
		if self.Selected and self.SelectedID and not CharMenu.IsClosing then
		
			local owner = Row.Btn[ self.SelectedID ] and Row.Btn[ self.SelectedID ].Owner
		
			local shift = math.sin(RealTime()*3.2)*9 + 11
			local text = translate.Get(self.Selected.Name) or translate.Get("sog_menu_error2")
			
			text = string.upper( text )
			
			local x,y = sw/2, sh/5
					
			draw.SimpleText( text, "Scene", x + 3, y + 3, Color( 10, 10, 10, 185), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					
			for i=0,10 do
				if i == 0 then
					draw.SimpleTextOutlined( text, "Scene", x - shift/2 * (i/12), y - shift/2 * (i/12), Color( 253, 0, 251, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
				else
					draw.SimpleText( text, "Scene", x - shift/2 * (i/12), y - shift/2 * (i/12), Color( 253, 0, 251, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				end
			end	

					

			draw.SimpleTextOutlined( text, "Scene", x - shift/2, y - shift/2, Color( 253, 0, 251, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color_black)
			draw.SimpleText( text, "Scene", x - shift/2, y - shift/2, Color( 0, 255, 248, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			
			//desc
			shift = shift*3
			text = translate.Get(self.Selected.Description) or translate.Get("sog_menu_error2")
			
			y = sh/2.1
			
			draw.SimpleTextOutlined( text, "PixelCutsceneScaled", x, y, Color( 186, 13, 190, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
			draw.SimpleTextOutlined( text, "PixelCutsceneScaled", x - 3, y - 3, Color( 255 - shift, 136 - shift, 255 - shift, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
			
			//taken by someone (coop only)
			if owner and owner:IsValid() and owner:IsPlayer() then
				text = "Taken by "..owner:Name()

				local tw, th = surface.GetTextSize( text )

				y = sh-th
				
				draw.SimpleTextOutlined( text, "PixelCutsceneScaled", x, y, Color( 186, 13, 190, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
				draw.SimpleTextOutlined( text, "PixelCutsceneScaled", x - 3, y - 3, Color( 255 - shift, 136 - shift, 255 - shift, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
			end
			
			/*local shift = math.cos(RealTime()*3)*2 + 5
			
			local text = translate.Get(self.Selected.Name) or translate.Get("sog_menu_error2")
			
			draw.SimpleText( text, "Numbers", x + 3, y + 3, Color( 10, 10, 10, 185), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText( text, "Numbers", x, y, Color( 97, 0, 27, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText( text, "Numbers", x - shift, y - shift, Color( 220, 220, 220, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			
			
			shift = math.sin(RealTime()*3)*2 + 5
			
			text = translate.Get(self.Selected.Description) or translate.Get("sog_menu_error2")
			y = 3*sh/4
			
			draw.SimpleText( text, "NumbersSmall", x + 3, y + 3, Color( 10, 10, 10, 185), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText( text, "NumbersSmall", x, y, Color( 97, 0, 27, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText( text, "NumbersSmall", x - shift, y - shift, Color( 210, 210, 210, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)*/
			
		end
	end
	
	Row.Bars = {}
	for i=1,8 do
		Row.Bars[ i ] = { goal = 0, current = 2 * Row:GetWide() }// + (i-1)*Row:GetWide()/8  }
	end
	Row.ButtonOffset = Row.Bars[ 1 ].current
	Row.Paint = function( self, sw, sh )
		
		local bw, bh = sw, sh/13
		local spacing = 0
		local num = 8
		
		local wholeh = bh * num + spacing * ( num - 1 )

		local step = 0
		
		local r = 0.5*math.sin(RealTime()*1)*255 + 255/2
		local g = -0.5*math.sin(RealTime()*1)*255 + 255/2
		local b = 215
		
		self.ButtonOffset = self.Bars[ 1 ].current
		
		for i=1, num do
		
			local x,y = 0, sh/2-wholeh/2
			
			if self.Bars[ i ] and self.Bars[ i ].current ~= self.Bars[ i ].goal then
				self.Bars[ i ].current = math.Approach( self.Bars[ i ].current, self.Bars[ i ].goal, FrameTime() * (6000 - i*350) )
			end
			
			x = self.Bars[ i ].current
		
			surface.SetTexture( gradient )
			
			surface.SetDrawColor(0, 0, 0, 255)
			surface.DrawTexturedRect( x, y + step, bw, bh)
			
			surface.SetDrawColor(0, 0, 0, 255)
			surface.DrawTexturedRect( x, y + step, bw, bh)
			
			surface.SetDrawColor(0, 0, 0, 255)
			surface.DrawTexturedRect( x, y + step, bw, bh)
			
			surface.SetTexture( gradient2 )
						
			surface.SetDrawColor(r-num*2, g-num*2, b-num*2, 255)
			surface.DrawTexturedRect( x+1, y+1 + step, bw-2, bh-2)
			
			surface.SetDrawColor(0, 0, 0, 205)
			surface.DrawTexturedRect( x, y + step, bw, bh)
					
			step = step + bh + spacing
			
		end
				
	end

	local chars = styles or GAMEMODE.Characters
	local num = 0
	
	for ind, tbl in pairs( chars ) do
		if !styles and GAMEMODE.UseCharacters and ( tbl.Reference and !table.HasValue( GAMEMODE.UseCharacters, tbl.Reference ) or !tbl.Reference) then continue end
		if tbl.GametypeSpecific and tbl.GametypeSpecific ~= GAMEMODE:GetGametype() and !SINGLEPLAYER then continue end
		if tbl.NoMenu then continue end
		num = num + 1
	end
	
	local tall = math.min(Row:GetTall(),Row:GetWide()/(num))
	
	local bw, bh = tall, tall
	local spacing = 0
	
	local wholew = bw * num + spacing * ( num - 1 )
	
	local ind_to_ref = {}
	
	local step = 0
	
	for ind, tbl in pairs( chars ) do
	
		if !styles and GAMEMODE.UseCharacters and ( tbl.Reference and !table.HasValue( GAMEMODE.UseCharacters, tbl.Reference ) or !tbl.Reference) then continue end
		if tbl.GametypeSpecific and tbl.GametypeSpecific ~= GAMEMODE:GetGametype() and !SINGLEPLAYER then continue end
		if tbl.NoMenu then continue end
		
		//local btn = Row.Btn[ ind ]
		
		local btn = Row:Add( "DButton" )
		btn:SetSize( bw, bh )
		btn:SetText( "" )
		btn:SetPos( Row:GetWide()/2 - wholew/2 + step , Row:GetTall()/2 - bh/2 )
		btn.SaveX, btn.SaveY = btn:GetPos() //welp, that was weird before
		btn.OnMouseWheeled = fixvolume
		if tbl.Reference then
			btn.Reference = tbl.Reference
			ind_to_ref[ btn.Reference ] = ind
		end
		btn.Think = function( self )
			local x, y = self.SaveX, self.SaveY
			self:SetPos( x + Row.ButtonOffset, y )
		end
		btn.OnCursorEntered = function( self )
			self.Overed = true
			Desc.Selected = tbl
			Desc.SelectedID = ind
		end
		btn.OnCursorExited = function( self )
			self.Overed = false
			Desc.Selected = nil
			Desc.SelectedID = nil
		end
		btn.Paint = function( self, sw, sh )
			
			local scale = self.Overed and 0.96 or 0.78
			
			surface.SetMaterial( tbl.Icon or blank )
			
			local rotation = math.sin( RealTime() * ( 1 + 0.2 ^ ind ) ) * 7 
			
			surface.SetDrawColor( 10,10,10,185 )
			surface.DrawTexturedRectRotated( sw/2 + 5, sh/2 + 5, sw*scale, sh*scale, rotation)
			
			if self.Taken and self.Taken > CurTime() then
				surface.SetDrawColor( tbl.Icon and Color(95,95,95,255) or Color(10,10,10,255) )
			else
				surface.SetDrawColor( tbl.Icon and Color(255,255,255,255) or Color(10,10,10,255) )
			end
			surface.DrawTexturedRectRotated( sw/2, sh/2, sw*scale, sh*scale, rotation)
		end
		btn.DoClick = function( self )
			
			if CharMenu.IsClosing then return end
			
			for i=1,8 do
				Row.Bars[ i ].goal = -1 * Row:GetWide()// - (i-1)*Row:GetWide()/8
			end
			
			CharMenu.IsClosing = true
			
			if styles and char_id then
				RunConsoleCommand( "select_style", tostring( ind ) )
				RunConsoleCommand( "select_character", tostring( char_id ) )
			else
				RunConsoleCommand( "select_character", tostring( ind ) )
			end
			//CharMenu:Remove()
			//CharMenu = nil
		end
		
		Row.Btn[ ind ] = btn
		
		step = step + bw + spacing
		
	end
		
	CharMenu.Think = function( self ) 
		
		if SHOW_TAKEN_CHARACTERS then
	
			self.NextRefresh = self.NextRefresh or 0
			
			if self.NextRefresh < CurTime() then
						
				for k, v in pairs( player.GetAll() ) do
					
					if v and v:IsValid() and v:Team() ~= TEAM_SPECTATOR and v ~= LocalPlayer() then
					
						local char = ind_to_ref[ GAMEMODE:GetCharacterReferenceById( v:GetCharacter() ) ]
											
						if char and Row.Btn[ char ] then
							if !Row.Btn[ char ].Taken or Row.Btn[ char ].Taken and Row.Btn[ char ].Taken < CurTime() then
								Row.Btn[ char ].Owner = v
							end
							Row.Btn[ char ].Taken = CurTime() + 0.11
						end
					end
				end
				
				self.NextRefresh = CurTime() + 0.1
			end
			
		end
	
		if self.IsClosing and Row.Bars[ 8 ].current == Row.Bars[ 8 ].goal and Row.Bars[ 8 ].goal ~= 0 then
			self:Remove()
			self = nil
			
			if func then
				func()
			end
		
		end
	end

end