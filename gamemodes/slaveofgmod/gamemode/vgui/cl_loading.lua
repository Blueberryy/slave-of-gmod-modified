local mat = Material( "sog/bg_gradient3.png" )
local mat_moon = Material( "sog/moon1.png" )

local mat_heks = Material( "sog/heks.png", "smooth" )

local palm1 = Material( "sog/palmtree1.png" )
local palm2 = Material( "sog/palmtree2.png" )
local palm3 = Material( "sog/palmtree3.png" )
local palm4 = Material( "sog/palmtree4.png" )

local blood_mat = Material( "effects/slime1.vtf" )

local col_house = Color( 30, 30, 30, 255)
local col_house_back = Color( 20, 20, 20, 255)
local col_window = Color( 109, 182, 255, 255 )
local col_window_back = Color( 163, 219, 255, 245 )
local col_window_back_refl = Color( 193, 249, 255, 105 )//Color( 163, 219, 255, 205 )

local col_evil = Color( 250, 30, 0, 255 )
local col_evil_back = Color( 202, 140, 1, 255)

local palm_width

local dead = SCENE and SCENE.Spooky

local water = {}

local function DrawWindowGrid( in_x, in_y, rows, collumns, sizeW, sizeH, spacing, col_wind, lines )
	
	if lines then
		sizeH = 3
	end
	
	surface.SetDrawColor( col_wind or col_window )
	
	local x, y = in_x - (sizeW*collumns+spacing*(collumns-1))/2, in_y - (sizeH*rows+spacing*(rows-1))/2
	
	if lines then
		x, y = in_x - (sizeW*collumns+spacing*(collumns-1))/2, in_y
	end
	
	local off_x, off_y = 0, 0

	if lines then
		for i=1, rows do
		
			surface.DrawLine( x, y+off_y,x+(sizeW*collumns+spacing*(collumns-1)), y+off_y ) 
			surface.DrawLine( x, y+off_y+1,x+(sizeW*collumns+spacing*(collumns-1)), y+off_y+1 )
			surface.DrawLine( x, y+off_y+2,x+(sizeW*collumns+spacing*(collumns-1)), y+off_y+2 ) 
			
			off_x = 0
			off_y = off_y + sizeH + spacing/3

		end
	else
		for i=1, rows do
		
			for j=1, collumns do			
				surface.DrawRect( x + off_x, y + off_y, sizeW, sizeH )
				off_x = off_x + sizeW + spacing
			end
			
			off_x = 0
			off_y = off_y + sizeH + spacing

		end
	end

end

//small function have have a few nice looking houses
local function DrawHouses( x, y, col, col_wind )
	
	local spacing = 30
	local total_w = 0
	
	if EVIL_SCREEN then
		col_wind = col_evil
	end
	
	if dead then
		col_wind = color_black
	end
	
	//house 1
	local hw, hh = 100, 180
	local hx, hy = x-hw/2, y - hh
	
	surface.SetDrawColor( col or col_house )
	surface.DrawRect( hx, hy, hw, hh )
	
	DrawWindowGrid( hx+hw/2, hy+hh/2, 9, 5, 8, 8, 9, col_wind )
	
	total_w = hw/2 + spacing
	
	//house 2
	hw, hh = 50, 220
	hx, hy = x + total_w, y - hh
	
	surface.SetDrawColor( col or col_house )
	surface.DrawRect( hx, hy, hw, hh )
	
	DrawWindowGrid( hx+hw/2, hy+hh/2, 12, 3, 6, 8, 9, col_wind )
	
	total_w = total_w + hw + spacing
	
	//house 3
	hw, hh = 40, 160
	hx, hy = x + total_w, y - hh
	
	surface.SetDrawColor( col or col_house )
	surface.DrawRect( hx, hy, hw, hh )
	
	DrawWindowGrid( hx+hw/2, hy+hh/2, 11, 3, 4, 6, 7, col_wind )
	
	total_w = total_w + hw + spacing
	
	//house 4
	hw, hh = 70, 260
	hx, hy = x + total_w, y - hh
	
	surface.SetDrawColor( col or col_house )
	surface.DrawRect( hx, hy, hw, hh )
	surface.DrawRect( hx+hw/2-(hw*0.7)/2, hy-10, hw*0.7, 10 )
	
	DrawWindowGrid( hx+hw/2, hy-5, 1, 3, 3, 4, 10, col_wind )
	
	DrawWindowGrid( hx+hw/2, hy+25, 2, 4, 4, 4, 10, col_wind )
	
	DrawWindowGrid( hx+hw/2, hy+hh/1.7, 14, 4, 4, 4, 10, col_wind )
	
	total_w = total_w + hw + spacing
	
	//house 5
	hw, hh = 70, 230
	hx, hy = x + total_w, y - hh
	
	surface.SetDrawColor( col or col_house )
	surface.DrawRect( hx, hy, hw, hh )
	surface.DrawRect( hx+hw/2-(hw*0.8)/2, hy-40, hw*0.8, 40 )
	surface.DrawRect( hx+hw/2-(hw*0.7)/2, hy-50, hw*0.7, 10 )
				
	DrawWindowGrid( hx+hw/2, hy-20, 2, 3, 4, 6, 10, col_wind )
	
	DrawWindowGrid( hx+hw/2, hy+hh/2, 12, 4, 4, 8, 10, col_wind )
	
	total_w = total_w + hw + spacing
	
	//house 6
	hw, hh = 50, 200
	hx, hy = x + total_w, y - hh
	
	surface.SetDrawColor( col or col_house )
	surface.DrawRect( hx, hy, hw, hh )
	
	DrawWindowGrid( hx+hw/2, hy+hh/2, 16, 3, 8, 4, 7, col_wind )
	
	total_w = total_w + hw + spacing
	
	//house 7
	hw, hh = 120, 80
	hx, hy = x + total_w, y - hh
	
	surface.SetDrawColor( col or col_house )
	surface.DrawRect( hx, hy, hw, hh )
	surface.DrawRect( hx+hw/2-(hw*0.9)/2, hy-5, hw*0.9, 5 )
	surface.DrawRect( hx+hw/2-(hw*0.8)/2, hy-10, hw*0.8, 5 )
	
	DrawWindowGrid( hx+hw/2, hy+hh/2, 5, 8, 6, 6, 7, col_wind )
	
	total_w = total_w + hw + spacing
	
	//house 8
	hw, hh = 70, 190
	hx, hy = x + total_w, y - hh
	
	surface.SetDrawColor( col or col_house )
	surface.DrawRect( hx, hy, hw, hh )
	surface.DrawRect( hx+hw/2-(hw*0.8)/2, hy-10, hw*0.8, 10 )
	surface.DrawRect( hx+hw/2-(hw*0.25)/2, hy-40, hw*0.25, 30 )
				
	DrawWindowGrid( hx+hw/2, hy-30, 1, 1, 6, 6, 0, col_wind )
	
	DrawWindowGrid( hx+hw/2, hy+hh/2-40, 6, 4, 4, 6, 10, col_wind )
	
	DrawWindowGrid( hx+hw/2, hy+hh/2+50, 3, 4, 4, 6, 10, col_wind )
	
	total_w = total_w + hw + spacing
	
	//print(total_w)
	//810
	
end

local function DrawReflections( x, y, col, col_wind )
	
	if dead then return end
	
	local spacing = 30
	local total_w = 0
	
	if EVIL_SCREEN then
		col_wind = col_evil
	end
	
	//house 1

	local hw, hh = 100, 180
	local hx, hy = x-hw/2, y// + hh
	
	DrawWindowGrid( hx+hw/2, hy, 9, 5, 8, 8, 9, col_wind, true )
	
	total_w = hw/2 + spacing
	
	//house 2
	hw, hh = 50, 220
	hx, hy = x + total_w, y// + hh
	
	DrawWindowGrid( hx+hw/2, hy, 12, 3, 6, 8, 9, col_wind, true )
	
	total_w = total_w + hw + spacing
	
	//house 3
	hw, hh = 40, 160
	hx, hy = x + total_w, y// + hh
	
	DrawWindowGrid( hx+hw/2, hy, 11, 3, 4, 6, 7, col_wind, true )
	
	total_w = total_w + hw + spacing
	
	//house 4
	hw, hh = 70, 260
	hx, hy = x + total_w, y// + hh
		
	DrawWindowGrid( hx+hw/2, hy, 14, 4, 4, 4, 10, col_wind, true )
	
	DrawWindowGrid( hx+hw/2, hy+90, 2, 4, 4, 4, 10, col_wind, true )
	
	DrawWindowGrid( hx+hw/2, hy+102, 1, 3, 3, 4, 10, col_wind, true )
	
	total_w = total_w + hw + spacing
	
	//house 5
	hw, hh = 70, 230
	hx, hy = x + total_w, y// + hh
				
	
	DrawWindowGrid( hx+hw/2, hy, 12, 4, 4, 8, 10, col_wind, true )
	
	DrawWindowGrid( hx+hw/2, hy+75, 2, 3, 4, 6, 10, col_wind, true )
	
	total_w = total_w + hw + spacing
	
	//house 6
	hw, hh = 50, 200
	hx, hy = x + total_w, y// + hh
		
	DrawWindowGrid( hx+hw/2, hy, 16, 3, 8, 4, 7, col_wind, true )
	
	total_w = total_w + hw + spacing
	
	//house 7
	hw, hh = 120, 80
	hx, hy = x + total_w, y// + hh
		
	DrawWindowGrid( hx+hw/2, hy, 5, 8, 6, 6, 7, col_wind, true )
	
	total_w = total_w + hw + spacing
	
	//house 8
	hw, hh = 70, 190
	hx, hy = x + total_w, y// + hh
	
	DrawWindowGrid( hx+hw/2, hy, 3, 4, 4, 6, 10, col_wind, true )
	
	DrawWindowGrid( hx+hw/2, hy+20, 6, 4, 4, 6, 10, col_wind, true )
	
	DrawWindowGrid( hx+hw/2, hy+56, 1, 2, 6, 6, 0, col_wind, true )
	
	total_w = total_w + hw + spacing
	
	//print(total_w)
	//810
	
end

local function DrawHousesBack( x, y, col, col_wind )
	
	local spacing = 30
	local total_w = 0
	
	if EVIL_SCREEN then
		col_wind = col_evil_back
	end
	
	if dead then
		col_wind = color_black
	end
	
	//house 1
	local hw, hh = 100, 180
	local hx, hy = x-hw/2, y - hh
	
	surface.SetDrawColor( col or col_house )
	surface.DrawRect( hx, hy, hw, hh )
	
	DrawWindowGrid( hx+hw/2, hy+hh/2, 9, 5, 8, 8, 9, col_wind )
	
	total_w = hw/2 + spacing
	
	//house 2
	hw, hh = 70, 190
	hx, hy = x + total_w, y - hh
	
	surface.SetDrawColor( col or col_house )
	surface.DrawRect( hx, hy, hw, hh )
	surface.DrawRect( hx+hw/2-(hw*0.8)/2, hy-10, hw*0.8, 10 )
	surface.DrawRect( hx+hw/2-(hw*0.25)/2, hy-40, hw*0.25, 30 )
				
	DrawWindowGrid( hx+hw/2, hy-30, 1, 1, 6, 6, 0, col_wind )
	
	DrawWindowGrid( hx+hw/2, hy+hh/2-40, 6, 4, 4, 6, 10, col_wind )
	
	DrawWindowGrid( hx+hw/2, hy+hh/2+50, 3, 4, 4, 6, 10, col_wind )
	
	total_w = total_w + hw + spacing
	
	//house 3
	hw, hh = 120, 80
	hx, hy = x + total_w, y - hh
	
	surface.SetDrawColor( col or col_house )
	surface.DrawRect( hx, hy, hw, hh )
	surface.DrawRect( hx+hw/2-(hw*0.9)/2, hy-5, hw*0.9, 5 )
	surface.DrawRect( hx+hw/2-(hw*0.8)/2, hy-10, hw*0.8, 5 )
	
	DrawWindowGrid( hx+hw/2, hy+hh/2, 5, 8, 6, 6, 7, col_wind )
	
	total_w = total_w + hw + spacing
	
	
	//house 4
	hw, hh = 50, 200
	hx, hy = x + total_w, y - hh
	
	surface.SetDrawColor( col or col_house )
	surface.DrawRect( hx, hy, hw, hh )
	
	DrawWindowGrid( hx+hw/2, hy+hh/2, 16, 3, 8, 4, 7, col_wind )
	
	total_w = total_w + hw + spacing
	
	//house 5
	hw, hh = 70, 230
	hx, hy = x + total_w, y - hh
	
	surface.SetDrawColor( col or col_house )
	surface.DrawRect( hx, hy, hw, hh )
	surface.DrawRect( hx+hw/2-(hw*0.8)/2, hy-40, hw*0.8, 40 )
	surface.DrawRect( hx+hw/2-(hw*0.7)/2, hy-50, hw*0.7, 10 )
				
	DrawWindowGrid( hx+hw/2, hy-20, 2, 3, 4, 6, 10, col_wind )
	
	DrawWindowGrid( hx+hw/2, hy+hh/2, 12, 4, 4, 8, 10, col_wind )
	
	total_w = total_w + hw + spacing
	
	//house 6
	hw, hh = 70, 260
	hx, hy = x + total_w, y - hh
	
	surface.SetDrawColor( col or col_house )
	surface.DrawRect( hx, hy, hw, hh )
	surface.DrawRect( hx+hw/2-(hw*0.7)/2, hy-10, hw*0.7, 10 )
	
	DrawWindowGrid( hx+hw/2, hy-5, 1, 3, 3, 4, 10, col_wind )
	
	DrawWindowGrid( hx+hw/2, hy+25, 2, 4, 4, 4, 10, col_wind )
	
	DrawWindowGrid( hx+hw/2, hy+hh/1.7, 14, 4, 4, 4, 10, col_wind )
	
	total_w = total_w + hw + spacing
	
	//house 7
	hw, hh = 40, 160
	hx, hy = x + total_w, y - hh
	
	surface.SetDrawColor( col or col_house )
	surface.DrawRect( hx, hy, hw, hh )
	
	DrawWindowGrid( hx+hw/2, hy+hh/2, 11, 3, 4, 6, 7, col_wind )
	
	total_w = total_w + hw + spacing
	
	//house 8
	hw, hh = 50, 220
	hx, hy = x + total_w, y - hh
	
	surface.SetDrawColor( col or col_house )
	surface.DrawRect( hx, hy, hw, hh )
	
	DrawWindowGrid( hx+hw/2, hy+hh/2, 12, 3, 6, 8, 9, col_wind )
	
	total_w = total_w + hw + spacing
	
	//print(total_w)
	//810
	
end

function DrawScrollingHouses( y, wide, speed, col, col_wind, func )

		local w = 810 //todo: change when nessesary
		//w = w + 40
		
		local left = speed < 0
			
		local x = math.fmod( RealTime() * math.abs(speed), math.min(wide,w) ) * ( left and -1 or 1);
				
		if left then
			
			while ( x < wide) do
				
				if func then
					func( x, y, col, col_wind )
				else
					DrawHouses( x, y, col, col_wind )
				end

				x = x + w

			end
		else
						
			while ( x + math.min(w,wide) > 0 ) do
			
				if func then
					func( x, y, col, col_wind )
				else
					DrawHouses( x, y, col, col_wind )
				end
				
				x = x - w
			
			end
		end

end

local function DrawPalmTrees( x, y, col, spacing, w, h )
		
	//spacing = spacing or 100
	local total_w = 0
	
	surface.SetDrawColor( col )
	
	local hw, hh = h/2.2, h/1.6
	
	//1
	local hx, hy = x, y - hh
	
	surface.SetMaterial( palm1 )
	surface.DrawTexturedRect( hx, hy, hw, hh )
		
	total_w = hw + spacing
	
	//2
	hx, hy = x + total_w, y - hh
	
	surface.SetMaterial( palm2 )
	surface.DrawTexturedRect( hx, hy, hw, hh )
		
	total_w = total_w + hw + spacing
	
	//3
	hx, hy = x + total_w, y - hh
	
	surface.SetMaterial( palm3 )
	surface.DrawTexturedRect( hx, hy, hw, hh )
		
	total_w = total_w + hw + spacing
	
	//4
	hx, hy = x + total_w, y - hh
	
	surface.SetMaterial( palm4 )
	surface.DrawTexturedRect( hx, hy, hw, hh )
		
	total_w = total_w + hw + spacing

	if not palm_width then
		palm_width = total_w
	end
	
end

function DrawScrollingPalmTrees( y, wide, speed, col, spacing, ww, hh )

		local w = palm_width or hh*4
		
		local left = speed < 0
			
		local x = math.fmod( RealTime() * math.abs(speed), math.min(wide,w) ) * ( left and -1 or 1);
				
		if left then
			
			while ( x < wide) do
				
				DrawPalmTrees( x, y, col, spacing, ww, hh )

				x = x + w

			end
		else
						
			while ( x + math.min(w,wide) > 0 ) do
			
				DrawPalmTrees( x, y, col, spacing, ww, hh )
				
				x = x - w
			
			end
		end

end

local function AddWaterLine( x, y, w, h )
	
	if #water > 55 then return end
	
	local line = {}
	line.x = math.random( x + 25, w - 25 )
	line.y = math.random( y + 25, h - 25 )
	line.size = math.random(34,80)
	line.starttime = CurTime()
	line.lifetime = math.Rand( 0.11, 0.35 )
	
	table.insert( water, line )

end

local function DrawWaterLines()
	
	surface.SetDrawColor( Color( 250, 250, 250, 255) )
	
	for k, line in pairs( water ) do
		
		if line.starttime + line.lifetime*2 > CurTime() then
		
			local delta = math.Clamp( 1 - (((line.starttime + line.lifetime) - CurTime())/line.lifetime), 0, 1 )

			if delta == 1 then 
				delta = math.Clamp( (((line.starttime + line.lifetime*2) - CurTime())/line.lifetime), 0, 1 )
			end
			
			surface.DrawLine( line.x-( line.size * delta )/2, line.y, line.x+( line.size * delta )/2, line.y ) 
			surface.DrawLine( line.x-( line.size * delta )/2, line.y+1, line.x+( line.size * delta )/2, line.y+1 ) 
			surface.DrawLine( line.x-( line.size * delta )/2, line.y+2, line.x+( line.size * delta )/2, line.y+2 ) 
			
		else
			water[k] = nil
		end

	end

end

local function AddBlood( blood )
	
	if not blood then return end
	if not BLOODY_SCREEN then return end
	if #blood > 500 then return end
	
	local drip = {}
	drip.x = math.random( -25, ScrW() )
	drip.y = math.random( -25, ScrH() )
	drip.size = math.random(15,70)
	drip.flow = math.Rand( 0.2, 4.5 )
	drip.splats = math.random(2,3)
	drip.flowtime = math.Rand( 1, 4 )
	drip.starttime = CurTime()
	
	table.insert( blood, drip )

end

local function DrawBlood( blood )
		
	if not blood then return end

	surface.SetDrawColor( dead and Color( 25, 25, 25, 250 ) or Color( 245, 15, 15, 250 ) )
	surface.SetMaterial( blood_mat )
	
	for _, drip in pairs( blood ) do
		local scale = 1 + math.Clamp( drip.flow * ( 1 - ( ( drip.starttime + drip.flowtime - CurTime())/drip.flowtime ) ), 0, drip.flow*2 )
		for i=1, drip.splats do
			if not drip["offset"..i] then
				drip["offset"..i] = math.Rand( -5, 5 )
			end
			
			surface.DrawTexturedRect( drip.x + drip["offset"..i], drip.y + drip["offset"..i] - ( dead and drip.size * math.max( 1, scale/2 ) or 0 ), drip.size, drip.size * math.max( 1, scale/2) )
		end
		if dead then
			surface.DrawTexturedRect( drip.x, drip.y - ( drip.size * scale + drip.size/3 ), drip.size, drip.size * scale )
		else
			surface.DrawTexturedRect( drip.x, drip.y + ( drip.size/3 * scale - drip.size/3 ), drip.size, drip.size * scale )
		end
	end
	
end

local function textspin( freq, am, shift )
	return math.sin( ( RealTime() + (shift or 0) ) * ( freq ) ) * am
end

function CreateLoadingScreen( name, number, duration, fade, func )
	
	local w,h = ScrW(), ScrH()
	local MySelf = LocalPlayer()
	
	local text = name or "untitled"
	
	local desc = number.."th"
	
	if number == -1 then desc = "bonus" end
	if number == 0 then desc = "new" end
	if number == 1 then desc = "first" end
	if number == 2 then desc = "second" end
	if number == 3 then desc = "third" end
	if number == 4 then desc = "fourth" end
	if number == 5 then desc = "fifth" end
	if number == 6 then desc = "sixth" end
	if number == 7 then desc = "seventh" end
	if number == 8 then desc = "eighth" end
	
	if number > 20 then
		local last = tostring( number )
		if string.EndsWith( last, "2" ) then
			desc = number.."nd"
		end
		if string.EndsWith( last, "3" ) then
			desc = number.."rd"
		end
	end
	
	if SCENE and SCENE.Final then
		desc = "final"
	end
	
	desc = desc.." scene"
	desc = string.upper(desc)
	
	if dead then desc = "" end
	
	local Loading = vgui.Create( "DFrame" )
	Loading:SetSize( w, h )
	Loading:SetPos(0,0)
	Loading:SetDraggable ( false )
	Loading:SetTitle("")
	Loading:ShowCloseButton(false)
	Loading.StartTime = CurTime()
	Loading.ClosingTime = CurTime() + duration
	Loading.BloodTable = {}
	if fade then
		Loading.FadeInTime = Loading.StartTime + 1
		Loading.FadeOutTime = Loading.ClosingTime - 0.3
		Loading.Opening = true
		Loading.Closing = true
	end
	
	//just so we can change volume when loading
	Loading.OnMouseWheeled = function( s, delta )
		if delta > 0 then
			/*if GAMEMODE.Radio and GAMEMODE.Radio:IsValid() and !( GAMEMODE.SceneAmbient and GAMEMODE.SceneAmbient:IsValid() ) then
				GAMEMODE.Radio:RunJavascript( "IncreaseVolume();" )
			end*/
			if IsValid( GAMEMODE.Music ) and !IsValid( GAMEMODE.SceneAmbient ) then
				GAMEMODE.Music:SetVolume( GAMEMODE.Music:GetVolume() + 0.03 )
			end
		end
		
		if delta < 0 then		
			if IsValid( GAMEMODE.Music ) and !IsValid( GAMEMODE.SceneAmbient ) then
				GAMEMODE.Music:SetVolume( GAMEMODE.Music:GetVolume() - 0.03 )
			end
			/*if GAMEMODE.Radio and GAMEMODE.Radio:IsValid() and !( GAMEMODE.SceneAmbient and GAMEMODE.SceneAmbient:IsValid() ) then
				GAMEMODE.Radio:RunJavascript( "DecreaseVolume();" )
			end*/
		end
	end
	
	Loading.OnMousePressed = function( self )
		if EDITOR_TEST then
			self.ClosingTime = 0
		end
	end
	
	Loading.Think = function( self ) 
		if self.ClosingTime <= CurTime() then
			
			if self.BloodTable then
				table.Empty( self.BloodTable )
				self.BloodTable = nil
			end
			
			Loading:Remove()
			Loading = nil
			
			if func then
				timer.Simple(0.1,function()
					func()
				end)
			end
		end
		if not fade then return end
		
		if self.FadeInTime < CurTime() and self.Opening then
			self.Opening = false
		end
		
		if self.FadeOutTime > CurTime() and not self.Closing then
			self.Closing = true
		end
	end

	Loading.NewPaint = function( self, sw, sh )
	
		self.NextWater = self.NextWater or 0
		
		if self.NextWater < CurTime() then
			self.NextWater = CurTime() + math.Rand(0.1,0.4)
			
			for i=1, math.random(4,11) do
				AddWaterLine( 0, sh/2, sw, 3*sh/4 )
			end
			
			//AddBlood()
			
		end
		
		AddBlood( self.BloodTable )
		AddBlood( self.BloodTable )
	
		local r = 31
		local g = 170
		local b = 232
		
		if EVIL_SCREEN then
			r, g, b = 255, 31, 31
		end
		
		if dead then
			r = 235
			g = 235
			b = 235
		end
		
		local add_a = 0.5*math.sin(RealTime()*1)*40 + 40/2
		local add_a2 = 0.5*math.sin(RealTime()*1)*90 + 90/2
		
		surface.SetDrawColor( color_black )
		surface.DrawRect( 0, 0, sw, sh )
		
		surface.SetDrawColor( Color( r, g, b, 20+add_a2) )
		surface.SetMaterial( mat )
		
		surface.DrawTexturedRect( 0, 0, sw, sh*0.7 )
		surface.DrawTexturedRect( 0, 0, sw, sh*0.7 )
		
		if dead then
			surface.SetDrawColor( Color( 244+add_a/2, 244+add_a/2, 244+add_a/2, 215) )
			surface.SetMaterial( mat_heks )
			
			local shift = math.sin( RealTime() * ( 1.3 ) ) * 5
			
			surface.DrawTexturedRectRotated( sw/2 + shift, sh/3-shift, sh/1.1, sh/1.1, 0 )
		end
		
		surface.SetMaterial( mat )
		
		//water
		if EVIL_SCREEN then
			surface.SetDrawColor( Color( 151, 10, 13, 255) )
		else
			surface.SetDrawColor( Color( 231, 80, 233, 255) )
		end
		if dead then
			surface.SetDrawColor( Color( 201, 201, 201, 255) )
		end
		surface.DrawTexturedRectRotated( sw/2, 3*sh/4, sw*1.5, sh/2, 0 )
		DrawScrollingHouses( sh/2+8, sw*1.5, -50, col_house, col_window_back_refl, DrawReflections )
		DrawWaterLines()
		if EVIL_SCREEN then
			surface.SetDrawColor( Color( 235, 10, 10, 180+add_a) )
		else
			surface.SetDrawColor( Color( 109, 182, 255, 180+add_a) )
		end
		if dead then
			surface.SetDrawColor( Color( 231, 231, 231, 180+add_a) )
		end
		surface.DrawTexturedRectRotated( sw/2, 3*sh/4, sw*1.4, sh/2, 180 )

		if EVIL_SCREEN then
			surface.SetDrawColor( Color( 117, 21, 21, 70+add_a) )
		else
			surface.SetDrawColor( Color( 77, 21, 117, 70+add_a) )
		end
		if dead then
			surface.SetDrawColor( Color( 181, 181, 181, 70+add_a) )
		end
		surface.DrawRect( 0, sh/2-2, sw, 4 )
				
		//moon
		if !dead then
			surface.SetDrawColor( Color( 244+add_a/2, 181+add_a/2, 197+add_a/2, 215) )
			surface.SetMaterial( mat_moon )
		
			local shift = math.sin( RealTime() * ( 1.3 ) ) * 5

			surface.DrawTexturedRectRotated( sw/2 + shift, sh/4-shift, sh/2.4, sh/2.4, 0 )
		end
		
		//houses		
		DrawScrollingHouses( sh/2, sw*1.5, -30, col_house_back, col_window_back, DrawHousesBack )
		DrawScrollingHouses( sh/2, sw*1.5, -50, col_house, col_window )
		
		if dead then
			DrawScrollingPalmTrees( sh-50, sw*2, -1280, Color(131, 131, 131, 65), 0, w, h )
		else
			DrawScrollingPalmTrees( sh-50, sw*2, -1280, EVIL_SCREEN and Color(232, 170, 31, 65) or Color(31, 170, 232, 65), 0, w, h )
		end
		
		DrawBlood( self.BloodTable )
		
	end
	
	Loading.PaintText = function( self, sw, sh )
			
		draw.TextRotated( desc, sw/2+2*1.4, sh/3+2*1.4, EVIL_SCREEN and Color( 151, 10, 13, 255) or Color( 220, 206, 16, 255 ), "Scene", textspin(1.3,-1.1),  1.4, 1.5 )
		draw.TextRotated( desc, sw/2, sh/3, EVIL_SCREEN and Color(232, 170, 31, 255) or Color( 13, 213, 3, 255 ),"Scene", textspin(1.3,-1.1),  1.4, 1 )
		
		local am = 15 + math.Clamp( 13 - #text, 0, 13)
		
		local scale = 2.3
				
		surface.SetFont( "HugeMessage" )
		
		local tw, th = surface.GetTextSize( text )
		local side_offset, empty = surface.GetTextSize( "W" )
		
		if not tw or tw <= 0 then tw = 1 end
		tw = tw + side_offset * 1.5
		
		scale = math.Clamp( sw / tw ,0.9, 3 )//2.6
			
		for i=0,am do
		
			local r = 0.5*math.sin((RealTime()+0.8*i/am)*2)*180 + 180/2
			local g = -0.5*math.sin((RealTime()+0.8*i/am)*2)*180 + 180/2
			local b = 255
			
			if EVIL_SCREEN then
				r = 255
				g = 0.5*math.sin((RealTime()+0.8*i/am)*2)*180 + 180/2
				b = 31
			end
			
			if dead then
				r = math.sin( ( RealTime() + 0.8 * i/am ) * 2 ) * 55 + 220
				g = math.sin( ( RealTime() + 0.8 * i/am ) * 2 ) * 55 + 220
				b = math.sin( ( RealTime() + 0.8 * i/am ) * 2 ) * 55 + 220
			end
					
			
			local add = 0
			
			if NIGHTMARE then
				add = math.Clamp( 1 - (self.ClosingTime - CurTime())/duration, 0, 6 ) * i * scale * 6
			end
			
			if i == 0 or i == am then
				draw.TextRotated( text, sw/2, sh/2+add, Color(r,g,b,250), "HugeMessage",textspin(1,5,0.9*i/am) + 0.1 * add, scale + 0.01*i, 1 )
			else
				draw.TextRotated( text, sw/2, sh/2+add, Color(r,g,b,250), "HugeMessage",textspin(1,5,0.9*i/am) + 0.1 * add, scale + 0.01*i, false )
			end

			
		end
				
	end
	
	Loading.PaintFade = function( self, sw, sh )
		
		if not fade then return end
		
		if self.Opening then
			local delta = math.Clamp( ( self.FadeInTime - CurTime() ) / 1 , 0, 1)
			surface.SetDrawColor( Color(0,0,0,255*delta) )
			surface.DrawRect( 0, 0, sw, sh )
		end
		
		if self.Closing then
			local delta = math.Clamp( 1 - ( self.FadeOutTime - CurTime() ) / 1 , 0, 1)
			surface.SetDrawColor( Color(0,0,0,255*delta) )
			surface.DrawRect( 0, 0, sw, sh )
		end
		
	end
	
	Loading.Paint = function( self, sw, sh )
		
		//local ang = math.sin( RealTime() * ( 1.3 ) ) * 1.1//1
		local ang = math.sin( RealTime() * ( 1 ) ) * 1.4//1
		local scale = 1.05
		
		local sw1 = sw * scale
		local sh1 = sh * scale
		
		local x, y = sw/2, sh/2
	
		render.PushFilterMag( TEXFILTER.ANISOTROPIC )
		render.PushFilterMin( TEXFILTER.ANISOTROPIC )
				
		local rad = -math.rad( ang )
		local halvedPi = math.pi / 2
		x = x - ( math.sin( rad + halvedPi ) * sw1 / 2 + math.sin( rad ) * sh1 / 2 )
		y = y - ( math.cos( rad + halvedPi ) * sw1 / 2 + math.cos( rad ) * sh1 / 2 )
		local m = Matrix()
		m:SetAngles( Angle( 0, ang, 0 ) )
		m:SetTranslation( Vector( x, y, 0 ) )
		m:Scale( Vector( scale, scale, 1 ) )
		
		
		cam.PushModelMatrix( m )
			self:NewPaint( sw, sh )
		cam.PopModelMatrix()
		render.PopFilterMag()
		render.PopFilterMin()
		
		self:PaintText( sw, sh )
		
		self:PaintFade( sw, sh )
		
	end

end