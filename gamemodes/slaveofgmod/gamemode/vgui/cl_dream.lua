local ModelToFace = {
	["models/player/group01/male_07.mdl"] = Material( "sog/male_07.png", "smooth" ),
	["models/player/barney.mdl"] = Material( "sog/barney.png", "smooth" ),
	["models/humans/group01/male_02.mdl"] = Material( "sog/default.png", "smooth" ),
	["models/player/group01/male_02.mdl"] = Material( "sog/default.png", "smooth" ),
	["models/player/group01/male_09.mdl"] = Material( "sog/mark.png", "smooth" ),
	["models/player/phoenix.mdl"] = Material( "sog/detective.png", "smooth" ),
	["models/player/kleiner.mdl"] = Material( "sog/kleiner.png", "smooth" ),
	["models/player/group03/female_02.mdl"] = Material( "sog/female_02.png", "smooth" ),
	["models/player/group01/male_03.mdl"] = Material( "sog/male_03.png", "smooth" ),
	["models/props_trainstation/payphone_reciever001a.mdl"] = Material( "sog/phone2.png", "smooth" ),
	["models/player/hostage/hostage_03.mdl"] = Material( "sog/weird1.png", "smooth" ),
	["models/player/breen.mdl"] = Material( "sog/breen.png", "smooth" ),
	["models/player/police.mdl"] = Material( "sog/police.png", "smooth" ),
	["models/player/eli.mdl"] = Material( "sog/evil.png", "smooth" ),
	["models/player/group03/male_06.mdl"] = Material( "sog/merc.png", "smooth" ),
	["models/props_c17/tv_monitor01.mdl"] = Material( "sog/tv.png", "smooth" ),
	["models/player/odessa.mdl"] = Material( "sog/odessa.png", "smooth" ),
	["models/player/group03/male_09.mdl"] = Material( "sog/male_09.png", "smooth" ),
	["models/props_lab/reciever01d.mdl"] = Material( "sog/carradio.png", "smooth alphatest" ),
	["models/props/cs_militia/axe.mdl"] = Material( "sog/axe.png", "smooth" ),
	["models/player/alyx.mdl"] = Material( "sog/alyx.png", "smooth" ),
	["models/kleiner.mdl"] = Material( "sog/kleiner.png", "smooth" ),
	["models/props/cs_office/phone.mdl"] = Material( "sog/phone.png", "smooth" ),
	["models/player/soldier_stripped.mdl"] = Material( "sog/him.png", "smooth" ),
}

local mark2 = Material( "sog/mark_weird.png", "smooth" )

local mat = Material( "sog/bg_gradient3.png" )
local mat_moon = Material( "sog/moon1.png" )

local palm1 = Material( "sog/palmtree1.png" )
local palm2 = Material( "sog/palmtree2.png" )
local palm3 = Material( "sog/palmtree3.png" )
local palm4 = Material( "sog/palmtree4.png" )

local spooky_mat = CreateMaterial( "spooky_background2", "UnlitGeneric", {
	["$basetexture"] = "skybox/starfield", 
	["$vertexcolor"] = 1, 
	["$vertexalpha"] = 1, 
	["$nolod"] = 1,
} )

local fancy_palms = {}
local alt_palm = false
local function AddPalm( life, alt )
	
	--if #fancy_palms > 20 then return end
	
	local palm = {}
	palm.starttime = CurTime()
	palm.lifetime = life * 6 or 1
	palm.alt = alt_palm
	
	table.insert( fancy_palms, palm )
	
	alt_palm = not alt_palm

end

local road_poly = { {}, {}, {}, {} }
local function SunsetBackground( self, sw, sh )
	if ( self.NextPalm or 0 ) < CurTime() then
		local lf = 0.7
		AddPalm( lf )
			
		self.NextPalm = CurTime() + lf
	end
	
	local timemul = 0.7
		
	local add_a = 0.5*math.sin(RealTime()*timemul)*40 + 40/2
	local add_a2 = 0.5*math.sin(RealTime()*timemul)*90 + 90/2
	
	local r = 250
	local g = 0.5*math.sin(RealTime()*timemul)*180 + 180/2
	local b = 51
		
	surface.SetDrawColor( color_black )
	surface.DrawRect( 0, 0, sw, sh )
		
	surface.SetDrawColor( Color( r, g, b, 20+add_a2) )
	surface.SetMaterial( mat )
		
	surface.DrawTexturedRect( 0, 0, sw, sh )
	surface.DrawTexturedRect( 0, 0, sw, sh )
		
	surface.SetDrawColor( Color( 244+add_a/2, 161+add_a/2, 177+add_a/2, 215) )
	surface.SetMaterial( mat_moon )
		
	local shift = math.sin( RealTime() * ( 1.3 ) ) * 5
		
	surface.DrawTexturedRectRotated( sw/2, sh/2.2-shift, sh/1.4, sh/1.4, 0 )
		
		
	surface.SetDrawColor( Color( r-add_a/2, g-add_a/2, b-add_a/2, 255 ) )
	surface.SetMaterial( mat )
		
	surface.DrawTexturedRect( 0, sh/1.8, sw, sh/2 )
		
	local w_spacing = sw/7
		
	road_poly[1].x, road_poly[1].y = sw/2-w_spacing/2, sh/1.8
	road_poly[2].x, road_poly[2].y = sw/2+w_spacing/2, sh/1.8
	road_poly[3].x, road_poly[3].y = sw/2 + ( w_spacing + sw/3.1 ), sh
	road_poly[4].x, road_poly[4].y = sw/2 - ( w_spacing + sw/3.1 ), sh
		
	surface.SetDrawColor( Color(7, 7, 7, 255) )
	draw.NoTexture()
	surface.DrawPoly( road_poly )
	
	for k, palm in pairs( fancy_palms ) do
			
		if palm.starttime + palm.lifetime > CurTime() then
			
			local delta = math.Clamp( 1 - (((palm.starttime + palm.lifetime) - CurTime())/palm.lifetime), 0, 1 )
				
			--surface.SetDrawColor( Color(232, 170, 31, 65) )
			surface.SetDrawColor( Color(5, 5, 5, 215) )
				
			delta = delta ^ 1.5
				
			local scale = delta * 15
				
				
			local hw, hh = sh*0.05, sh*0.05
				
			hw, hh = hw * scale, hh * scale
				
				
			local w_spacing = sw/7 + delta * ( 5 * sw/7 + hw / 2 ) 
			local hx, hy = sw/2, sh/1.8 - hh/2 + delta * ( hh/2 )
				
			surface.SetMaterial( palm.alt and palm1 or palm4 )
			surface.DrawTexturedRectRotated( hx - w_spacing/2, hy, hw, hh, 0 )
				
			surface.SetMaterial( palm.alt and palm2 or palm3 )
			surface.DrawTexturedRectRotated( hx + w_spacing/2, hy, hw, hh, 0 )
				

				
		else
			fancy_palms[k] = nil
		end

	end
end


//todo: support more than just 2 sequences
function ScenePlaySequence1and2( p, seq1, seq2, playback )
	
	p:ResetSequenceInfo()
	
	local len = p:SetSequence( p:LookupSequence( seq1 ) )
	
	p:SetPlaybackRate( playback or 1 )
	p:SetCycle( 0 )
	
	timer.Simple( ( len * 0.95 )/( playback or 1 ), function() 
		if IsValid( p ) then
			p:SetSequence( p:LookupSequence( seq2 ) )
		end
	end)
	
end

function CreateScenery( self )
	
	if not self.Scenery then return end
		
	if ( !ClientsideModel ) then return end
	
	local model = self.Scenery.Main.mdl
	if self.Scenery.Main.lp and IsValid(LocalPlayer()) then
		local cl_playermodel = LocalPlayer():GetInfo( "cl_playermodel" )
		model = player_manager.TranslatePlayerModel( cl_playermodel )
	end
	
	self.Main = ClientsideModel( model , RENDER_GROUP_OPAQUE_ENTITY )
	if ( !IsValid(self.Main) ) then return end
	
	//if IsValid(LocalPlayer()) then
		//self.Main:SetPos( LocalPlayer():GetPos() + vector_up * 500 )
	//end
	self.Main:SetNoDraw( true )
	self.Main:SetSequence( self.Main:LookupSequence( self.Scenery.Main.seq ) )	
	
	if self.Scenery.Main.mat and self.Scenery.Main.mat ~= "" then
		self.Main:SetMaterial( self.Scenery.Main.mat )
	end
	
	if self.Scenery.StaticCamera then
		self.StaticCamera = true
	end
	
	if self.Scenery.RedLighting then
		self.RedLighting = true
	end
	
	if self.Scenery.OverridePaint and self.CutScenePanel then
		self.CutScenePanel.OverridePaint = function( s, s_w, s_h )
			self.Scenery.OverridePaint( s, s_w, s_h )
		end
	end
	
	if self.Scenery.OverrideClose then
		self.OverrideClose = true
	end
	
	//small emitter for the cutscenes
	self.Emitter = ParticleEmitter(self.Main:GetPos())
	self.Emitter:SetNoDraw()

	self.Relative = {}
	
	for k, v in pairs( self.Scenery.Relative ) do
		local relpos, relang = LocalToWorld( v.offset , v.ang, self.Main:GetPos(), self.Main:GetAngles() )  
		
		local model = v.mdl
		if v.lp then
			local cl_playermodel = GetConVar( "cl_playermodel" ):GetString()
			model = player_manager.TranslatePlayerModel( cl_playermodel )
		end	
		
		if v.rag then
			self.Relative[k] = ClientsideRagdoll( model )
			//so it will be nocollided just in case
			self.Relative[k]:SetParent( self.Main )
		else
			self.Relative[k] = ClientsideModel( model, RENDER_GROUP_OPAQUE_ENTITY )
		end
		
		self.Relative[k]:SetPos( relpos )
		self.Relative[k]:SetAngles( relang )
		
		self.Relative[k].OriginalPos = self.Relative[k]:GetPos()
		
		local seq, dur = self.Relative[k]:LookupSequence( v.seq )
		
		self.Relative[k]:ResetSequence( seq )
		
		self.Relative[k].Duration = dur
		
		self.Relative[k].NextPlay = CurTime() + self.Relative[k].Duration
		
		if v.mat and v.mat ~= "" then
			self.Relative[k]:SetMaterial( v.mat )
		end
		
		self.Relative[k].LastRender = 0
		
		//so you can mark entities
		if v.tag then
			self[v.tag] = self.Relative[k]
		end
		
		if v.hide then
			self.Relative[k].Hide = true
		end
		
		if v.blendhide then
			self.Relative[k].BlendHide = true
		end
		
		if v.modelscale then
			self.Relative[k].ModelScale = v.modelscale
		end
		
		if v.noframeadv then
			self.Relative[k].NoFrameAdvance = true
		end
		
		if v.loopanim then
			self.Relative[k].LoopAnimation = true
		end
		
		if v.skin then
			self.Relative[k]:SetSkin( v.skin )
		end
		
		if v.scale then
			self.Relative[k]:SetModelScale( v.scale, 0 )
		end
		
		if v.rag then	
			for i=0, self.Relative[k]:GetPhysicsObjectCount()-1 do
			
				local translate = self.Relative[k]:TranslatePhysBoneToBone(i)
				local phys = self.Relative[k]:GetPhysicsObjectNum( i )
							
				if translate and translate > 0 and v.rag[ translate ] and phys and phys:IsValid() then
								
					local b = v.rag[ translate ]
								
					local b_relpos, b_relang = LocalToWorld( b.b_offset, b.b_ang, self.Main:GetPos(), self.Main:GetAngles() )
								
					phys:SetPos( b_relpos )
					phys:SetAngles( b_relang )
								
					phys:EnableMotion( false )
					phys:EnableGravity( false )
					phys:EnableCollisions( false )
								
				end
							
			end
			
		end
		self.Relative[k]:SetNoDraw( true )
		//lets assume its not gonna hit 15 people, unless it is a sitcom scene
		for i=1, 15 do
			if v["t"..i] then
				self.Relative[k]["t"..i] = true
				self["t"..i] = self.Relative[k]
			end
		end
		
		if v.mdl == "models/dav0r/camera.mdl" then
			self.Relative[k].Camera = true
			self:SetCamPos( self.Relative[k]:GetPos() )
			self:SetLookAt( self.Relative[k]:GetPos() )
			self:SetLookAng( self.Relative[k]:GetAngles() )
			
			self.HasCamera = true
		end
		
		if ModelToFace[self.Relative[k]:GetModel()] then
			self.Relative[k].Icon = ModelToFace[self.Relative[k]:GetModel()]
		end
		
		if v.icon then
			self.Relative[k].Icon = v.icon
		end
		
		if v.shake then
			self.Relative[k].Shake = true
		end
		
		if v.noanim then
			self.Relative[k].NoAnimation = true
		end
		
		if v.PlayerColor then
			//hacky fix, because matproxy usually refers to owner if you have to recolor a ragdoll
			if self.Relative[k]:IsRagdoll() then
				self.Relative[k].BypassColorOwner = true
			end
			self.Relative[k].GetPlayerColor = function( self )
				local r, g, b = v.PlayerColor.r/255, v.PlayerColor.g/255, v.PlayerColor.b/255
				return Vector(r, g, b) or Vector(1,1,1)
			end 
		end		
				
	end
	
	self.LastPaint = 0

end

function DrawScenery( self )
	
	if ( !IsValid( self.Main ) ) then return end
	
	
	local r = 0.5*math.sin(RealTime()*1)*250 + 250/2
	local g = -0.5*math.sin(RealTime()*1)*250 + 250/2
	local b = 210
	
	if self.RedLighting then
		r = 0.5*math.sin(RealTime()*1)*205 + 205/2 + 30
		g = 30
		b = 30
	end
	
	self:SetAmbientLight( Color( 14, 14, 14 ) )//Color( 14, 14, 14 )
	self:SetDirectionalLight( BOX_TOP, Color( 0, 0, 0 ) )
	self:SetDirectionalLight( BOX_FRONT, Color( 0, 0, 0 ) )
	self:SetDirectionalLight( BOX_RIGHT, Color( r, g, b ) )
	self:SetDirectionalLight( BOX_LEFT, Color( r, g, b ) )
	
	local x, y = self:LocalToScreen( 0, 0 )
	
	self.Main:FrameAdvance( ( RealTime() - ( self.LastPaint or 0 ) ) * 1 )
	
	local ang = self.aLookAngle
	if ( !ang ) then
		ang = (vector_up * -1):Angle()//(self.vLookatPos-self.vCamPos):Angle()
	end
	
	if !self.HasCamera then
		ang:RotateAroundAxis( vector_up, 5 )
	end
	
	//local pos = Vector(self.vCamPos.x, self.vCamPos.y, self.vCamPos.z)
	
	if not self.goalpos then
		self.goalpos = self.vCamPos
	end
	
	if self.StaticCamera then
	
	else
		if dialoguepos then
			self.goalpos = LerpVector( FrameTime()*5, self.goalpos, dialoguepos )
			self.goalpos.z = self.vCamPos.z
		else
			self.goalpos = LerpVector( FrameTime()*5, self.goalpos, self.vCamPos )
			self.goalpos.z = self.vCamPos.z
		end	
	end
	
	local w, h = self:GetSize()
	cam.Start3D( self.goalpos or self.vCamPos , ang, self.HasCamera and 80 or 45 , x, y, w, h, 5, 4096 )//self.fFOV

	//cam.IgnoreZ( true )
	
	render.SuppressEngineLighting( true )
	render.SetLightingOrigin( self.Main:GetPos() )
	render.ResetModelLighting( self.colAmbientLight.r/255, self.colAmbientLight.g/255, self.colAmbientLight.b/255 )
	
	for i=0, 6 do
		local col = self.DirectionalLight[ i ]
		if ( col ) then
			render.SetModelLighting( i, col.r/255, col.g/255, col.b/255 )
		end
	end
	
	self.Main:DrawModel()
	
	local shake = VectorRand() * math.Rand(-0.8,0.8)
	shake.z = 0
	
	for k, v in pairs( self.Relative ) do
		if self.Relative[k].Camera then continue end
		if self.Relative[k].Hide then continue end
		
		if self.Relative[k].NoAnimation then
			self.Relative[k]:SetCycle( 0 )
		end
		
		if !self.Relative[k].NoFrameAdvance then
			self.Relative[k]:FrameAdvance( ( RealTime() - ( self.Relative[k].LastRender or 0 ) ) * 1 )	
		end

		if self.Relative[k].LoopAnimation then
			if self.Relative[k].NextPlay < CurTime() then
				self.Relative[k].NextPlay = CurTime() + ( self.Relative[k].Duration or 0 )
				self.Relative[k]:SetCycle( 0 )
			end
		end
		
		if not self.Relative[k].OriginalPos then
			self.Relative[k].OriginalPos = self.Relative[k]:GetPos()
		end
		
		if self.Relative[k].Shake then
			self.Relative[k]:SetPos( self.Relative[k].OriginalPos + shake)
		end
		
		if self.Relative[k].ModelScale then
			self.Relative[k]:SetModelScale( self.Relative[k].ModelScale, 0 )
		end
		
		if self.Relative[k].BlendHide then
			render.SetBlend( 0 )
		end
		
		self.Relative[k]:DrawModel()
		
		if self.Relative[k].BlendHide then
			render.SetBlend( 1 )
		end
		
		
		if self.Relative[k].OnDraw then
			self.Relative[k].OnDraw()
		end
		
		self.Relative[k].LastRender = RealTime()
	end	
	
	if self.Emitter then
		self.Emitter:Draw()
	end
	
	render.SuppressEngineLighting( false )
	//cam.IgnoreZ( false )

	cam.End3D()
	
	self.LastPaint = RealTime()
	
	

end




function DrawCutscene( scene, func, cv )

	local w,h = ScrW(), ScrH()
	local MySelf = LocalPlayer()

	if Cut then
		Cut:Remove()
		Cut = nil
	end
	
	Cut = vgui.Create( "DFrame" )
	Cut:SetSize( w, h )
	Cut:SetPos(0,0)
	Cut:SetDraggable ( false )
	Cut:SetTitle("")
	Cut:ShowCloseButton( false )
	Cut.Paint = function( self, sw, sh )
	
		if self.OverridePaint then
			self:OverridePaint( sw, sh )
			return
		end
	
		local r = 0.5*math.sin(RealTime()*1)*250 + 250/2
		local g = -0.5*math.sin(RealTime()*1)*250 + 250/2
		local b = 210
		
		surface.SetDrawColor( color_black )
		surface.DrawRect( 0, 0, sw, sh )
		
		surface.SetDrawColor( Color( r, g, b, 110) )
		surface.SetMaterial( mat )
		
		surface.DrawTexturedRect( -sw/2, 0, sw, sh*1.4 )
		surface.DrawTexturedRect( sw/2, 0, sw, sh*1.4 )
	end
	
	local sc = Cut:Add( "DModelPanel" )
	sc:SetSize( w, h )
	sc:SetPos(0,0)
	sc:SetCamPos( Vector( 60, 0, 550 ) )
	sc:SetLookAt( sc.vCamPos )
	sc:SetFOV( 70 )
	Cut.sc = sc
	sc.CutScenePanel = Cut
	sc.Scenery = table.Copy( scene or Scene1 )
	sc.ClosingTime = 0
	sc.ClosingDuration = 3
	if sc.Scenery.SoundTrack and SOG_CUTSCENE_MUSIC then
		//sc.Music = GAMEMODE:CreateSCPanel( Cut, sc.Scenery.SoundTrack, sc.Scenery.Volume or 52, false, false, sc.Scenery.StartFrom or nil, sc.Scenery.EndAt or nil )
		GAMEMODE:CreateMusic( MUSIC_TYPE_NORMAL, sc.Scenery.SoundTrack, sc.Scenery.Volume or 52, false, sc.Scenery.StartFrom or nil, sc.Scenery.EndAt or nil )
		sc.Volume = sc.Scenery.Volume and sc.Scenery.Volume/100 or 0.25
		sc.CurVolume = sc.Volume
	end
	sc.SetModel = function( self )
	end
	CreateScenery( sc )
	
	sc.Paint = function( self, tw, th )
		DrawScenery( self )
		
		if self.IsClosing then
		
			local delta = math.Clamp(  1 - ( self.ClosingTime - 0.2 - CurTime() ) / self.ClosingDuration , 0, 1)
		
			surface.SetDrawColor( Color(0,0,0,255*delta) )
			surface.DrawRect( 0, 0, tw, th )
		
		end
		
	end
	
	local dialogue = false
	
	sc.OnMousePressed = function(self)
		if dialogue and !self.FirstClick and !sc.Scenery.Intro then
			DrawDialogue()
			self.FirstClick = true
		else
			if self.IsClosing then return end
			self.ClosingTime = CurTime() + self.ClosingDuration
			self.IsClosing = true
			//Cut:Remove()
			//Cut = nil
		end
	end
	
	sc.Think = function( self ) 
		if self.IsClosing then
			/*if self.Music then
				self.NextChange = self.NextChange or 0
				if self.NextChange < CurTime() then
					local delta = math.Clamp(  ( self.ClosingTime - CurTime() ) / self.ClosingDuration , 0, 1)
					self.CurVolume = self.Volume * delta
					self.Music:RunJavascript( "ChangeVolume( "..self.CurVolume.." );" )
					self.NextChange = CurTime() + 0.1 //hopefully this wont cause too much problems
				end
			end*/
			if IsValid( GAMEMODE.Music ) then
				self.NextChange = self.NextChange or 0
				if self.NextChange < CurTime() then
					local delta = math.Clamp(  ( self.ClosingTime - CurTime() ) / self.ClosingDuration , 0, 1)
					self.CurVolume = self.Volume * delta
					GAMEMODE.Music:SetVolume( self.CurVolume )
					self.NextChange = CurTime() + 0.1 //hopefully this wont cause too much problems
				end
			end			
		end
		if self.IsClosing and self.ClosingTime <= CurTime() then
			if self.Emitter then
				self.Emitter:Finish()
				self.Emitter = nil
			end
			
			for k,v in pairs (self.Relative) do
				if IsValid( self.Relative[k] ) then
					self.Relative[k]:Remove()
				end
				self.Relative[k] = nil
			end
			
			if IsValid( self.Main ) then
				self.Main:Remove()
				self.Main = nil
			end
			
			Cut:Remove()
			Cut = nil
			
			if func then
				func()
			end
			
			if cv then
				local actual_cv = GetConVar( cv ):GetInt()
				if GAMEMODE.Cutscenes[ cv ] and actual_cv < table.maxn(GAMEMODE.Cutscenes[ cv ]) + 1 then
					RunConsoleCommand( cv, tostring( actual_cv + 1 ) )
				end
			end
			
		end
	end
		
	if sc.Scenery.Dialogues then
		sc.Scenery.Dialogues( sc )
		dialogue = true
	end
		
	if sc.Scenery.Intro then
		local intro = sc:Add("DPanel")
		intro:SetPos(0,0)
		intro:SetSize(w,h)
		intro:SetText("")
		
		local extend = 0
		
		if sc.Scenery.Act then
			extend = 2
		end
		
		intro.TextFadeInTime = CurTime() + 0.5
		intro.TextDuration = 2 + extend
		intro.TextFadeOutTime = CurTime() + 3 + extend
		intro.FadeOutTime = 2 + extend
		intro.Duration = CurTime() + 6 + extend
		intro.Paint = function( self, tw, th )
			
			local delta = math.Clamp(  ( self.Duration + self.FadeOutTime - CurTime() ) / self.FadeOutTime , 0, 1)
			local delta1 = math.Clamp( 1 - ( self.TextFadeInTime - CurTime() ) / 0.5 , 0, 1)
			local delta2 = math.Clamp( ( self.TextDuration + self.TextFadeOutTime - CurTime() ) / 3 , 0, 1)
		
			surface.SetDrawColor( Color(0,0,0,255*delta) )
			surface.DrawRect( 0, 0, tw, th )
			
			surface.SetFont("PixelCutsceneScaled")
			local textw, texth = surface.GetTextSize(sc.Scenery.Intro)
			
			draw.DrawText( translate.Get(sc.Scenery.Intro), "PixelCutsceneScaled", tw/2, th/2-texth/2, Color(210, 210, 210, 255*(self.TextFadeInTime >= CurTime() and delta1 or delta2) ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )

			if sc.Scenery.Act then
				surface.SetFont("PixelCutsceneBiggerScaled")
				local textw, texth = surface.GetTextSize(sc.Scenery.Intro)
			
				draw.DrawText( sc.Scenery.Act, "PixelCutsceneBiggerScaled", tw/2, th/5-texth/2, Color(210, 210, 210, 255*(self.TextFadeInTime >= CurTime() and delta1 or delta2) ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
			end
			
		end
		intro.Think = function( self )
			if self.Duration + self.FadeOutTime <= CurTime() then
				self:Remove()
				DrawDialogue()
			end
		end
		intro.OnMousePressed = function(self)
			//self:Remove()
		end
	end	
	
end


//stuuuuufffff

GM.Cutscenes = {}
GM.SingleplayerCutscenes = {}

GM.TranslateCutscenes = {
	["none"] = "_sog_demo1",
	["axecution"] = "_sog_demo2",
	["drama"] = "_sog_demo3",
	["nemesis"] = "_sog_demo4",
}

GM.TranslateCutscenesReverse = {}

for k,v in pairs( GM.TranslateCutscenes ) do
	GM.TranslateCutscenesReverse[v] = k
end

/*GM.TranslateCutscenesReverse = {
	["_sog_demo1"] = "none",
	["_sog_demo2"] = "axecution",
	["_sog_demo3"] = "drama",
}*/

//CreateClientConVar("_sog_demo1", 0, true, false)
//CreateClientConVar("_sog_demo2", 0, true, false)
//CreateClientConVar("_sog_demo3", 0, true, false)

GM.Cutscenes["_sog_demo1"] = {}
GM.Cutscenes["_sog_demo2"] = {}
GM.Cutscenes["_sog_demo3"] = {}
GM.Cutscenes["_sog_demo4"] = {}

for k,v in pairs(GM.Cutscenes) do
	CreateClientConVar(k, 0, true, false)
end

GM.Cutscenes["_sog_demo1"][0] = {
	Intro = "sog_intro_the_bottom_2013",
	SoundTrack = 111429172,
	Volume = 25,
	Main = { mdl = Model( "models/hunter/plates/plate5x6.mdl" ), seq = "idle"},
	Relative = {
		{ mdl = Model( "models/hunter/blocks/cube025x05x025.mdl"), offset = Vector(102, -27, 5) , ang = Angle(-1, -101, -1) , seq = "idle" },
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(-30, 20, 265) , ang = Angle(89, -25, -2) , seq = "Idle" },
		{ mdl = Model( "models/player/group01/male_02.mdl"), offset = Vector(-16, -47, 4) , ang = Angle(0, 94, 0) , seq = "idle_all_01", lp = true },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-98, 22, 3) , ang = Angle(0, -180, -1) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-98, -27, 3) , ang = Angle(0, 2, -1) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-100, -78, 3) , ang = Angle(0, -175, 0) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-97, -128, 3) , ang = Angle(0, -89, 0) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-49, -123, 3) , ang = Angle(-1, -89, 0) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-51, -74, 3) , ang = Angle(-1, 92, -1) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-1, -121, 3) , ang = Angle(0, -89, 0) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-4, -72, 3) , ang = Angle(-1, 92, -1) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(47, -123, 3) , ang = Angle(-1, 1, 0) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(46, -75, 3) , ang = Angle(-1, 91, -1) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(94, -124, 3) , ang = Angle(0, 1, 0) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(95, -73, 4) , ang = Angle(-1, 91, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/metal_paintcan001b.mdl"), offset = Vector(108, -59, 11) , ang = Angle(89, 172, -65) , seq = "idle" },
		{ mdl = Model( "models/props_junk/metal_paintcan001a.mdl"), offset = Vector(98, -52, 13) , ang = Angle(-2, -116, 0) , seq = "idle" },
		{ mdl = Model( "models/weapons/w_physics.mdl"), offset = Vector(85, -64, 9) , ang = Angle(-12, 109, -3) , seq = "idle" },
		{ mdl = Model( "models/hunter/blocks/cube025x025x025.mdl"), offset = Vector(98, -39, 11) , ang = Angle(0, -103, -1) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(50, 72, 4) , ang = Angle(-2, 89, 0) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(94, 24, 3) , ang = Angle(-1, 90, 0) , seq = "idle" },
		{ mdl = Model( "models/weapons/w_crowbar.mdl"), offset = Vector(75, 78, 18) , ang = Angle(75, 178, -75) , seq = "idle" },
		{ mdl = Model( "models/maxofs2d/companion_doll.mdl"), offset = Vector(71, 89, 19) , ang = Angle(-80, 112, 0) , seq = "idle" },
		{ mdl = Model( "models/props_canal/mattpipe.mdl"), offset = Vector(-4, 88, 29) , ang = Angle(16, -151, 92) , seq = "idle" },
		{ mdl = Model( "models/humans/group01/male_02.mdl"), offset = Vector(-25, 85, 10) , ang = Angle(-1, -91, -1) , seq = "d1_t01_BreakRoom_Sit01_Idle", t1 = true, icon = Material( "sog/default.png", "smooth" ) },
		{ mdl = Model( "models/props_c17/gravestone_coffinpiece002a.mdl"), offset = Vector(-24, 98, 17) , ang = Angle(0, -180, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/gascan001a.mdl"), offset = Vector(37, 91, 21) , ang = Angle(-32, 0, 1) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-99, 118, 3) , ang = Angle(-1, 92, -1) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-51, 120, 3) , ang = Angle(0, 91, -1) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-95, 70, 3) , ang = Angle(-1, 92, -1) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(48, 120, 3) , ang = Angle(0, 88, 0) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(95, 120, 3) , ang = Angle(-1, 88, 0) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(98, 71, 4) , ang = Angle(-1, 90, -1) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-1, 120, 3) , ang = Angle(-1, 90, 0) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(46, 24, 3) , ang = Angle(0, 90, 0) , seq = "idle" },
		{ mdl = Model( "models/props_lab/harddrive01.mdl"), offset = Vector(58, 22, 8) , ang = Angle(0, 15, -91) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-2, 25, 3) , ang = Angle(-1, -180, 0) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(2, 73, 3) , ang = Angle(-1, 90, -1) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-47, 71, 3) , ang = Angle(0, 92, -1) , seq = "idle" },
		{ mdl = Model( "models/maxofs2d/camera.mdl"), offset = Vector(-64, 51, 5) , ang = Angle(3, -120, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/shoe001a.mdl"), offset = Vector(-94, 40, 8) , ang = Angle(-5, 52, -97) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-50, 23, 3) , ang = Angle(-1, -180, 0) , seq = "idle" },
		{ mdl = Model( "models/hunter/blocks/cube05x05x05.mdl"), offset = Vector(-92, -1, 17) , ang = Angle(-1, -126, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/dollar.mdl"), offset = Vector(-86, -1, 29) , ang = Angle(-7, -54, -4) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-50, -26, 3) , ang = Angle(-1, 2, 0) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-2, -24, 3) , ang = Angle(0, 2, -1) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(66, -25, 6) , ang = Angle(-7, -2, 0) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(97, -25, 3) , ang = Angle(0, 1, 0) , seq = "idle" },
		{ mdl = Model( "models/props_lab/clipboard.mdl"), offset = Vector(99, -19, 17) , ang = Angle(0, 176, 0) , seq = "idle" },
		{ mdl = Model( "models/props_lab/monitor01a.mdl"), offset = Vector(88, 24, 16) , ang = Angle(-6, -111, 89) , seq = "idle" },
	},
	Dialogues = function( sc )
		AddDialogueLine( sc.t1, ". . .", "Psst. . .", "Over here. . ." )
		AddDialogueLine( sc.t1, "Surprised to see you in the place like this one.", ". . .", "Don't mind the props and floor tho. . .", "They are pointless anyway." )
		AddDialogueLine( sc.t1, ". . .", "In fact, whole place is.", "What a mess." )
		AddDialogueLine( sc.t1, ". . .", "How did you end up in here?", "Normally people don't give a shit about good things. . ." )
		AddDialogueLine( sc.t1, "*sigh*", "Unless you misclicked and wanted to join your\nfavourite custom TTT or DarkRP server instead." )
		AddDialogueLine( sc.t1, ". . .", "Anyway. . .", "There is not much stuff to do anymore. . .")
		AddDialogueLine( sc.t1, "Unless you are looking for some cheap\nmoney grab, or something. . ." )
		AddDialogueLine( sc.t1, ". . .or to record some crappy video\nand make profit from it.", "They tend to do that. . .", "Don't they?" )
		AddDialogueLine( sc.t1, ". . .", "Damn place still creeps me out after shit went down. . ." )
		AddDialogueLine( sc.t1, "*sigh*", "So you are still there. . .", "I doubt you will like the things\nthat you will see. . ." )
		AddDialogueLine( sc.t1, "Some of them are just too painful to watch.", ". . .", "Well. . ."  )
		AddDialogueLine( sc.t1, "There is not much to say about. . .", "At least for now. . ." )
		
	end,
} 

GM.Cutscenes["_sog_demo1"][5] = {
	Intro = "2013\n| Happy Torturer | meat factory",
	SoundTrack = 56480920,
	Volume = 70,
	Main = { mdl = Model( "models/hunter/plates/plate5x5.mdl" ), seq = "idle"},
	Relative = {
		{ mdl = Model( "models/player/monk.mdl"), offset = Vector(62, 22, 4) , ang = Angle(1, 7, -1) , seq = "pose_standing_02", t1 = true, icon = Material( "sog/grigori.png", "smooth" ) },
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(0, 11, 237) , ang = Angle(89, 113, 0) , seq = "Idle" },
		{ mdl = Model( "models/props/cs_militia/circularsaw01.mdl"), offset = Vector(88, 43, 30) , ang = Angle(0, -152, -1) , seq = "idle" },
		{ mdl = Model( "models/props_lab/jar01b.mdl"), offset = Vector(88, 29, 35) , ang = Angle(-1, -59, -1) , seq = "idle" },
		{ mdl = Model( "models/props_lab/jar01a.mdl"), offset = Vector(92, 20, 37) , ang = Angle(0, 179, -1) , seq = "idle" },
		{ mdl = Model( "models/props_c17/furnituresink001a.mdl"), offset = Vector(88, -3, 28) , ang = Angle(0, -180, -1) , seq = "idle" },
		{ mdl = Model( "models/props_lab/cleaver.mdl"), offset = Vector(8, -46, 53) , ang = Angle(-46, -46, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/stove01.mdl"), offset = Vector(83, -38, 24) , ang = Angle(-1, 170, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/footlocker01_open.mdl"), offset = Vector(-84, 92, 18) , ang = Angle(-1, -24, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/footlocker01_closed.mdl"), offset = Vector(90, 29, 18) , ang = Angle(0, 177, 0) , seq = "idle" },
		{ mdl = Model( "models/props_c17/suitcase001a.mdl"), offset = Vector(86, 61, 15) , ang = Angle(0, 174, -1) , seq = "idle" },
		{ mdl = Model( "models/humans/charple02.mdl"), offset = Vector(-8, -25, 34) , ang = Angle(-73, -68, -30) , seq = "ragdoll" },
		{ mdl = Model( "models/props/cs_militia/table_shed.mdl"), offset = Vector(-6, 0, 6) , ang = Angle(0, -11, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-12, -62, 3) , ang = Angle(-1, -1, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(80, -61, 3) , ang = Angle(-1, -1, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage_plasticbottle002a.mdl"), offset = Vector(-66, 94, 15) , ang = Angle(-21, -23, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-12, 65, 3) , ang = Angle(0, 179, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-104, 63, 3) , ang = Angle(-1, 179, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(80, 62, 3) , ang = Angle(-1, -1, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/metalgascan.mdl"), offset = Vector(4, 64, 17) , ang = Angle(53, -100, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/cardboard_box03.mdl"), offset = Vector(5, 50, 6) , ang = Angle(0, 85, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/paintbucket01.mdl"), offset = Vector(-26, 59, 6) , ang = Angle(-1, 83, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage_carboard001a.mdl"), offset = Vector(28, 89, 6) , ang = Angle(-1, 70, -1) , seq = "idle" },
		{ mdl = Model( "models/player/group02/male_04.mdl"), offset = Vector(-90, 35, 21) , ang = Angle(0, -10, -1) , seq = "sit", t3 = true, icon = Material( "sog/envy2.png", "smooth" ) },
		{ mdl = Model( "models/player/group02/male_04.mdl"), offset = Vector(-93, 7, 22) , ang = Angle(0, -8, -1) , seq = "sit", t2 = true, icon = Material( "sog/envy1.png", "smooth" ) },
		{ mdl = Model( "models/weapons/w_pist_deagle.mdl"), offset = Vector(-88, 53, 24) , ang = Angle(1, 17, 84) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/wood_bench.mdl"), offset = Vector(-90, 22, 6) , ang = Angle(0, 82, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-103, -65, 3) , ang = Angle(-1, -1, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/sawhorse.mdl"), offset = Vector(-84, -57, 6) , ang = Angle(0, 69, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/axe.mdl"), offset = Vector(-89, -64, 52) , ang = Angle(58, -145, 63) , seq = "idle" },
		{ mdl = Model( "models/props_c17/briefcase001a.mdl"), offset = Vector(-87, -24, 14) , ang = Angle(0, 170, 0) , seq = "idle" },
		{ mdl = Model( "models/props_c17/furniturechair001a.mdl"), offset = Vector(-5, -80, 15) , ang = Angle(-90, 158, -45) , seq = "idle" },
		{ mdl = Model( "models/props_junk/sawblade001a.mdl"), offset = Vector(-8, -15, 37) , ang = Angle(89, -15, 175) , seq = "idle" },
		{ mdl = Model( "models/props_lab/clipboard.mdl"), offset = Vector(-29, -14, 41) , ang = Angle(0, 133, -1) , seq = "idle" },
		{ mdl = Model( "models/props_c17/tools_pliers01a.mdl"), offset = Vector(5, -26, 41) , ang = Angle(8, 14, 0) , seq = "idle" },
		{ mdl = Model( "models/props_c17/tools_wrench01a.mdl"), offset = Vector(0, -32, 41) , ang = Angle(-1, 32, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/dryer.mdl"), offset = Vector(76, -71, 27) , ang = Angle(0, 172, 0) , seq = "idle" },
		{ mdl = Model( "models/props_c17/paper01.mdl"), offset = Vector(70, -76, 45) , ang = Angle(0, 108, -1) , seq = "idle" },
	},
	Dialogues = function( sc )
		AddDialogueLine( sc.t1, "So. . .", "You came back?" )
		AddDialogueLine( sc.t3, "There are things, that has to be done.",". . .", "And people who have to be punished." )
		AddDialogueLine( sc.t2, "Yeah.", ". . .", "What the fuck!", "Is that. . .", ". . .", "Is that a corpse?!" )
		AddDialogueLine( sc.t1, "Just an unsatisfied customer. Nothing special." )
		AddDialogueLine( sc.t2, ". . ." )
		AddDialogueLine( sc.t1, "What do you want from me?" )
		AddDialogueLine( sc.t2, "A help." )
		AddDialogueLine( sc.t3, "A weapon." )
		AddDialogueLine( sc.t1, "And why would you two need it?" )
		AddDialogueLine( sc.t2, "'We' are the same person." )
		AddDialogueLine( sc.t3, "At least, I am." )
		AddDialogueLine( sc.t1, ". . ." )
		AddDialogueLine( sc.t2, "I need something to take care of all these haters." )
		AddDialogueLine( sc.t2, ". . .", "Something that hits hard and hurts badly." )
		AddDialogueLine( sc.t3, "And that's why I'm here." )
		AddDialogueLine( sc.t1, ". . .", "You need to become a server owner with such enormous ego." )
		AddDialogueLine( sc.t2, "I'm not." )
		AddDialogueLine( sc.t3, "I already am." )
		AddDialogueLine( sc.t1, "And since you are - you should know the ways to\ndeal with your 'opponents'.", ". . ." )
		AddDialogueLine( sc.t2, "DDOS?" )
		AddDialogueLine( sc.t3, "DMCA." )
		AddDialogueLine( sc.t1, "Yes.", ". . .", "Actually. . .", "These are the only ways of dealing with people." )
		AddDialogueLine( sc.t1, "And considering how. . .",". . .not fucked up you are. . .",". . .DMCA would be the best for you." )
		AddDialogueLine( sc.t2, "Niccceeeeee. . ." )
		AddDialogueLine( sc.t1, "However. . .","Do you really want to hurt all these\n'innocent' players so badly?." )
		AddDialogueLine( sc.t3, "It's like I give a shit about them." )
		AddDialogueLine( sc.t1, "How cute.", "At least we have something in common.", ". . ." )
		AddDialogueLine( sc.t1, "See that paper sheet on the table?", ". . .", "Take it." )
		AddDialogueLine( sc.t2, "And what would I do with it?" )
		AddDialogueLine( sc.t1, "You'd better ask yourself.", ". . .", "It's your ticket to the so called 'punishment',\nafter all." )
	end,
}

GM.Cutscenes["_sog_demo1"][10] = {
	Intro = "2013\nCurrent server",
	SoundTrack = 47472501,
	Volume = 25,
	Main = { mdl = Model( "models/hunter/plates/plate5x6.mdl" ), seq = "idle"},
	Relative = {
		{ mdl = Model( "models/hunter/blocks/cube025x05x025.mdl"), offset = Vector(102, -27, 5) , ang = Angle(-1, -101, -1) , seq = "idle" },
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(-30, 20, 265) , ang = Angle(89, -25, -2) , seq = "Idle" },
		{ mdl = Model( "models/player/group01/male_02.mdl"), offset = Vector(-16, -47, 4) , ang = Angle(0, 94, 0) , seq = "idle_all_01", lp = true },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-98, 22, 3) , ang = Angle(0, -180, -1) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-98, -27, 3) , ang = Angle(0, 2, -1) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-100, -78, 3) , ang = Angle(0, -175, 0) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-97, -128, 3) , ang = Angle(0, -89, 0) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-49, -123, 3) , ang = Angle(-1, -89, 0) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-51, -74, 3) , ang = Angle(-1, 92, -1) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-1, -121, 3) , ang = Angle(0, -89, 0) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-4, -72, 3) , ang = Angle(-1, 92, -1) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(47, -123, 3) , ang = Angle(-1, 1, 0) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(46, -75, 3) , ang = Angle(-1, 91, -1) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(94, -124, 3) , ang = Angle(0, 1, 0) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(95, -73, 4) , ang = Angle(-1, 91, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/metal_paintcan001b.mdl"), offset = Vector(108, -59, 11) , ang = Angle(89, 172, -65) , seq = "idle" },
		{ mdl = Model( "models/props_junk/metal_paintcan001a.mdl"), offset = Vector(98, -52, 13) , ang = Angle(-2, -116, 0) , seq = "idle" },
		{ mdl = Model( "models/weapons/w_physics.mdl"), offset = Vector(85, -64, 9) , ang = Angle(-12, 109, -3) , seq = "idle" },
		{ mdl = Model( "models/hunter/blocks/cube025x025x025.mdl"), offset = Vector(98, -39, 11) , ang = Angle(0, -103, -1) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(50, 72, 4) , ang = Angle(-2, 89, 0) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(94, 24, 3) , ang = Angle(-1, 90, 0) , seq = "idle" },
		{ mdl = Model( "models/weapons/w_crowbar.mdl"), offset = Vector(75, 78, 18) , ang = Angle(75, 178, -75) , seq = "idle" },
		{ mdl = Model( "models/maxofs2d/companion_doll.mdl"), offset = Vector(71, 89, 19) , ang = Angle(-80, 112, 0) , seq = "idle" },
		{ mdl = Model( "models/props_canal/mattpipe.mdl"), offset = Vector(-4, 88, 29) , ang = Angle(16, -151, 92) , seq = "idle" },
		{ mdl = Model( "models/humans/group01/male_02.mdl"), offset = Vector(-25, 85, 10) , ang = Angle(-1, -91, -1) , seq = "d1_t01_BreakRoom_Sit01_Idle", t1 = true, icon = Material( "sog/default.png", "smooth" ) },
		{ mdl = Model( "models/props_c17/gravestone_coffinpiece002a.mdl"), offset = Vector(-24, 98, 17) , ang = Angle(0, -180, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/gascan001a.mdl"), offset = Vector(37, 91, 21) , ang = Angle(-32, 0, 1) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-99, 118, 3) , ang = Angle(-1, 92, -1) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-51, 120, 3) , ang = Angle(0, 91, -1) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-95, 70, 3) , ang = Angle(-1, 92, -1) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(48, 120, 3) , ang = Angle(0, 88, 0) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(95, 120, 3) , ang = Angle(-1, 88, 0) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(98, 71, 4) , ang = Angle(-1, 90, -1) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-1, 120, 3) , ang = Angle(-1, 90, 0) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(46, 24, 3) , ang = Angle(0, 90, 0) , seq = "idle" },
		{ mdl = Model( "models/props_lab/harddrive01.mdl"), offset = Vector(58, 22, 8) , ang = Angle(0, 15, -91) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-2, 25, 3) , ang = Angle(-1, -180, 0) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(2, 73, 3) , ang = Angle(-1, 90, -1) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-47, 71, 3) , ang = Angle(0, 92, -1) , seq = "idle" },
		{ mdl = Model( "models/maxofs2d/camera.mdl"), offset = Vector(-64, 51, 5) , ang = Angle(3, -120, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/shoe001a.mdl"), offset = Vector(-94, 40, 8) , ang = Angle(-5, 52, -97) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-50, 23, 3) , ang = Angle(-1, -180, 0) , seq = "idle" },
		{ mdl = Model( "models/hunter/blocks/cube05x05x05.mdl"), offset = Vector(-92, -1, 17) , ang = Angle(-1, -126, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/dollar.mdl"), offset = Vector(-86, -1, 29) , ang = Angle(-7, -54, -4) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-50, -26, 3) , ang = Angle(-1, 2, 0) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-2, -24, 3) , ang = Angle(0, 2, -1) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(66, -25, 6) , ang = Angle(-7, -2, 0) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(97, -25, 3) , ang = Angle(0, 1, 0) , seq = "idle" },
		{ mdl = Model( "models/props_lab/clipboard.mdl"), offset = Vector(99, -19, 17) , ang = Angle(0, 176, 0) , seq = "idle" },
		{ mdl = Model( "models/props_lab/monitor01a.mdl"), offset = Vector(88, 24, 16) , ang = Angle(-6, -111, 89) , seq = "idle" },
	},
	Dialogues = function( sc )
		AddDialogueLine( sc.t1, "Oh. . .", "You are back. . ." )
		AddDialogueLine( sc.t1, "There haven't been any changes recently. . .", "Even the cutscene layout is same, as you can see. . ." )
		AddDialogueLine( sc.t1, "*sigh*" )
		AddDialogueLine( sc.t1, "So. . .", "Have you noticed anything strange since your last visit?" )
		AddDialogueLine( sc.t1, ". . .", "Me, neither. . ." )
		AddDialogueLine( sc.t1, "You still don't realise how terrible this place is,\ndo you?" )
		AddDialogueLine( sc.t1, "I think you will figure it out.", ". . .", "Eventually. . ." )
		AddDialogueLine( sc.t1, "But before you leave. . .", "Let me ask you few questions.", "They may be important for you. . ." )
		AddDialogueLine( sc.t1, "Or you might just ignore them.", "Or you may even hate me for them.", ". . ." )
		AddDialogueLine( sc.t1, "Question number one:\n. . .", "Does this place have any terrible addons\nthat try to make it 'custom', when it's not?" )
		AddDialogueLine( sc.t1, "Question number two:\n. . .", "Does this place have terrible tags separated by '|'\nthat try to make it 'truly unique', when it's not?" )
		AddDialogueLine( sc.t1, "Question number three:\n. . .", "Do you think it is run by retarded kids\nlike most of the servers, or not?" )
		AddDialogueLine( sc.t1, "And the last question:\n. . .", "Where are we, right now?" )
		AddDialogueLine( sc.t1, "Think about it. . ." )
	end,
}

GM.Cutscenes["_sog_demo1"][15] = {
	Intro = "2013\nDirty abandoned stage\n\"Shit that gets you mad in GMod\"",
	SoundTrack = 86282419, //goddamn, where did older track go
	Volume = 20,
	Main = { mdl = Model( "models/hunter/plates/plate6x7.mdl" ), seq = "idle"},
	Relative = {
		{ mdl = Model( "models/player/police.mdl"), offset = Vector(-3, 23, 4) , ang = Angle(-1, 89, -1) , seq = "pose_standing_04" },
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(-14, -3, 289) , ang = Angle(89, -86, 0) , seq = "Idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(133, -122, 3) , ang = Angle(0, 179, -1) , seq = "idle" },
		{ mdl = Model( "models/props_c17/doll01.mdl"), offset = Vector(99, -66, 33) , ang = Angle(-43, 107, 21) , seq = "idle", t3 = true, icon = Material( "sog/thing.png", "smooth" ) },
		{ mdl = Model( "models/props_trainstation/traincar_seats001.mdl"), offset = Vector(90, 109, 6) , ang = Angle(0, -91, 0) , seq = "idle" },
		{ mdl = Model( "models/props_trainstation/traincar_seats001.mdl"), offset = Vector(92, 57, 6) , ang = Angle(0, -91, -1) , seq = "idle" },
		{ mdl = Model( "models/player/kleiner.mdl"), offset = Vector(71, 56, 24) , ang = Angle(0, -91, 0) , seq = "sit", t7 = true, icon = Material( "sog/kleiner.png", "smooth" ) },
		{ mdl = Model( "models/player/kleiner.mdl"), offset = Vector(96, 59, 21) , ang = Angle(0, -96, -1) , seq = "sit" },
		{ mdl = Model( "models/player/kleiner.mdl"), offset = Vector(125, 57, 23) , ang = Angle(0, -91, 0) , seq = "sit", t5 = true, icon = Material( "sog/kleiner.png", "smooth" ) },
		{ mdl = Model( "models/player/kleiner.mdl"), offset = Vector(122, 108, 24) , ang = Angle(0, -91, 0) , seq = "sit" },
		{ mdl = Model( "models/player/kleiner.mdl"), offset = Vector(80, 108, 24) , ang = Angle(0, -95, -1) , seq = "sit" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(133, 119, 3) , ang = Angle(-1, -1, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(41, 118, 3) , ang = Angle(0, -1, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-50, 124, 3) , ang = Angle(0, -1, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage_carboard002a.mdl"), offset = Vector(4, 111, 5) , ang = Angle(-1, 110, -1) , seq = "idle" },
		{ mdl = Model( "models/maxofs2d/camera.mdl"), offset = Vector(1, -74, 30) , ang = Angle(3, 68, 1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-50, -118, 3) , ang = Angle(0, 179, -1) , seq = "idle" },
		{ mdl = Model( "models/props_lab/reciever_cart.mdl"), offset = Vector(-154, -92, 41) , ang = Angle(0, 122, -1) , seq = "idle" },
		{ mdl = Model( "models/props_c17/oildrum001.mdl"), offset = Vector(-108, -124, 20) , ang = Angle(41, 110, -91) , seq = "idle" },
		{ mdl = Model( "models/props_c17/oildrum001.mdl"), offset = Vector(-86, -148, 6) , ang = Angle(-1, 140, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/sofa_chair.mdl"), offset = Vector(-75, -82, 6) , ang = Angle(0, 46, -1) , seq = "idle" },
		{ mdl = Model( "models/props_c17/tv_monitor01.mdl"), offset = Vector(-72, -76, 38) , ang = Angle(0, 54, -1) , seq = "idle", t1 = true, icon = Material( "sog/tv.png", "smooth" ) },
		{ mdl = Model( "models/props/cs_office/water_bottle.mdl"), offset = Vector(-16, -74, 35) , ang = Angle(-2, 134, 1) , seq = "idle" },
		{ mdl = Model( "models/props_vehicles/generatortrailer01.mdl"), offset = Vector(135, -139, 6) , ang = Angle(-1, 28, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/sofa.mdl"), offset = Vector(78, -78, 6) , ang = Angle(0, 120, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(42, -124, 3) , ang = Angle(0, 179, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/table_coffee.mdl"), offset = Vector(-7, -93, 6) , ang = Angle(0, -2, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(-9, -97, 30) , ang = Angle(0, -131, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(-8, -103, 31) , ang = Angle(0, 27, -179) , seq = "idle" },
		{ mdl = Model( "models/player/gman_high.mdl"), offset = Vector(54, -78, 26) , ang = Angle(-4, 68, 2) , seq = "zombie_slump_idle_02", t2 = true, icon = Material( "sog/sellout.png", "smooth" ) },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-142, 0, 3) , ang = Angle(0, 179, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/metal_paintcan001a.mdl"), offset = Vector(-126, -2, 11) , ang = Angle(-31, 132, -91) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-51, 0, 3) , ang = Angle(0, -1, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(42, -1, 3) , ang = Angle(-1, 179, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/shoe001a.mdl"), offset = Vector(37, -9, 8) , ang = Angle(-6, -125, -98) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(133, -4, 3) , ang = Angle(-1, -1, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-141, 123, 3) , ang = Angle(0, 179, -1) , seq = "idle" },
		{ mdl = Model( "models/props_trainstation/traincar_seats001.mdl"), offset = Vector(-89, 110, 6) , ang = Angle(-1, -91, -1) , seq = "idle" },
		{ mdl = Model( "models/player/kleiner.mdl"), offset = Vector(-120, 112, 22) , ang = Angle(0, -91, 0) , seq = "sit", t4 = true, icon = Material( "sog/kleiner.png", "smooth" ) },
		{ mdl = Model( "models/player/kleiner.mdl"), offset = Vector(-96, 112, 20) , ang = Angle(0, -92, 0) , seq = "sit" },
		{ mdl = Model( "models/player/kleiner.mdl"), offset = Vector(-74, 112, 24) , ang = Angle(0, -91, 0) , seq = "sit", t6 = true, icon = Material( "sog/kleiner.png", "smooth" ) },
		{ mdl = Model( "models/player/kleiner.mdl"), offset = Vector(-55, 112, 20) , ang = Angle(0, -93, 0) , seq = "sit" },
		{ mdl = Model( "models/props_trainstation/traincar_seats001.mdl"), offset = Vector(-91, 56, 6) , ang = Angle(0, -91, 0) , seq = "idle" },
		{ mdl = Model( "models/player/kleiner.mdl"), offset = Vector(-118, 60, 23) , ang = Angle(0, -92, 0) , seq = "sit" },
		{ mdl = Model( "models/player/kleiner.mdl"), offset = Vector(-66, 56, 23) , ang = Angle(0, -91, 0) , seq = "sit" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-142, -123, 3) , ang = Angle(0, 179, -1) , seq = "idle" },
	},
	Dialogues = function( sc )
		AddDialogueLine( sc.t1, "And now I'd like to welcome our today's guests!", ". . .", "They are one of the most famous gmod youtubers!" )
		AddDialogueLine( sc.t1, "Here they are:", "\"LetsTortureGmod\", who is also called as\n\"Sellout\" by normal people. . ." )
		AddDialogueLine( sc.t1, ". . .and his younger brother!", ". . .", "Hello \"LetsTortureGmod\",\nhow can you describe yourself?" )
		AddDialogueLine( sc.t2, ". . .", "I am a god." )
		AddDialogueLine( sc.t1, ". . ." )
		AddDialogueLine( sc.t2, "I am a motherfucking god!", ". . .", "Isn't that right, my little slaves?" )
		AddDialogueLine( sc.t4, "Yay!" )
		AddDialogueLine( sc.t5, "We love you, \"LetsTortureGmod\"!" )
		AddDialogueLine( sc.t6, "You rule!" )
		AddDialogueLine( sc.t2, "Thaaatsss right!" )
		AddDialogueLine( sc.t1, ". . .", "Okay. . .", "And what about your brother?" )
		AddDialogueLine( sc.t3, "Shut up." )
		AddDialogueLine( sc.t1, ". . .", "Well.", "A lot of people were calling you a \"Sellout\", despite\nthe fact that you are really well-known." )
		AddDialogueLine( sc.t3, "They are just fucking jealous, okay?", ". . .", "Stupid peasants. . ." )
		AddDialogueLine( sc.t2, "Oh, please. . .", "We are the professionals at this." )
		AddDialogueLine( sc.t1, ". . .", "Any tips on how to succeed in this?" )
		AddDialogueLine( sc.t2, "Of course!", "The simpliest and most important rule:\nIt is all about quantity." )
		AddDialogueLine( sc.t2, ". . .", "The more you make - the better!" )
		AddDialogueLine( sc.t1, "Isn't quality should be used inste. . ." )
		AddDialogueLine( sc.t3, "Shut the fuck up." )
		AddDialogueLine( sc.t1, "O-o-okay." )
		AddDialogueLine( sc.t2, "Also don't forget about these dirty tricks\nup the sleeve. . ." )
		AddDialogueLine( sc.t2, ". . .like overusing caps lock in titles, loud intros,\nmisleading thumbnails, huge facecams. . ." )
		AddDialogueLine( sc.t1, ". . ." )
		AddDialogueLine( sc.t2, ". . .forcing suggestions to like and subscribe down\nthe people's throats, until they start choking on it." )
		AddDialogueLine( sc.t1, "Well. . ." )
		AddDialogueLine( sc.t2, "As I said, it's very simple!" )
		AddDialogueLine( sc.t1, "Well, looks like our time is almost out. . .", "Any last word of advice to our viewers?" )
		AddDialogueLine( sc.t2, "Yeah!", "Don't forget to hit the fucking subscribe button!" )
		AddDialogueLine( sc.t3, "Bitcheesssssss!" )
		
	end,
}

GM.Cutscenes["_sog_demo1"][17] = {
	SoundTrack = 102174869,
	Volume = 20,
	Intro = "Summer 2013\nSomewhere. . .",
	Main = { mdl = Model( "models/hunter/plates/plate5x5.mdl" ), seq = "idle"},
	Relative = {
		{ mdl = Model( "models/props_c17/furniturearmchair001a.mdl"), offset = Vector(59, -123, 6) , ang = Angle(0, 87, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(-28, -12, 38) , ang = Angle(9, 96, -4) , seq = "idle" },
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(-16, -18, 253) , ang = Angle(89, 143, -1) , seq = "Idle" },
		{ mdl = Model( "models/player/gman_high.mdl"), offset = Vector(29, -94, 31) , ang = Angle(-1, -1, -1) , seq = "idle",tag = "sellout", icon = Material( "sog/sellout.png", "smooth" ), rag = { [3] = { b_offset = Vector(31, -99, 42), b_ang = Angle(-51, 84, -79) }, [6] = { b_offset = Vector(32, -87, 52), b_ang = Angle(-63, 83, 93) }, [9] = { b_offset = Vector(39, -91, 47), b_ang = Angle(72, 14, 166) }, [10] = { b_offset = Vector(43, -91, 37), b_ang = Angle(0, 115, -110) }, [11] = { b_offset = Vector(37, -80, 35), b_ang = Angle(58, 121, 103) }, [14] = { b_offset = Vector(24, -92, 49), b_ang = Angle(49, -153, 40) }, [15] = { b_offset = Vector(17, -96, 40), b_ang = Angle(27, 85, -57) }, [16] = { b_offset = Vector(17, -84, 37), b_ang = Angle(-7, 96, 84) }, [18] = { b_offset = Vector(33, -95, 32), b_ang = Angle(-1, 82, -90) }, [19] = { b_offset = Vector(35, -77, 31), b_ang = Angle(85, -112, 76) }, [20] = { b_offset = Vector(35, -78, 14), b_ang = Angle(67, 80, -89) }, [22] = { b_offset = Vector(25, -94, 33), b_ang = Angle(3, 95, -79) }, [23] = { b_offset = Vector(24, -76, 31), b_ang = Angle(77, -155, 21) }, [24] = { b_offset = Vector(20, -78, 15), b_ang = Angle(66, 115, -67) }, } },
		{ mdl = Model( "models/player/group01/male_09.mdl"), offset = Vector(46, 89, 28) , ang = Angle(-1, -1, -1) , seq = "ragdoll",tag = "mark", icon = Material( "sog/mark.png", "smooth" ), PlayerColor = Color( 215, 77, 64 ), rag = { [3] = { b_offset = Vector(45, 95, 38), b_ang = Angle(-74, -157, -17) }, [6] = { b_offset = Vector(41, 91, 52), b_ang = Angle(-59, -143, 140) }, [9] = { b_offset = Vector(35, 92, 44), b_ang = Angle(75, 166, 148) }, [10] = { b_offset = Vector(32, 93, 33), b_ang = Angle(43, -83, -108) }, [11] = { b_offset = Vector(33, 84, 25), b_ang = Angle(-26, -95, 92) }, [14] = { b_offset = Vector(50, 94, 49), b_ang = Angle(1, 57, 4) }, [15] = { b_offset = Vector(56, 104, 49), b_ang = Angle(3, -39, -3) }, [16] = { b_offset = Vector(65, 97, 48), b_ang = Angle(52, -18, 112) }, [18] = { b_offset = Vector(42, 88, 28), b_ang = Angle(6, -97, -97) }, [19] = { b_offset = Vector(40, 71, 26), b_ang = Angle(79, -142, -138) }, [20] = { b_offset = Vector(37, 69, 10), b_ang = Angle(34, -98, -97) }, [22] = { b_offset = Vector(50, 90, 28), b_ang = Angle(5, -90, -85) }, [23] = { b_offset = Vector(50, 72, 26), b_ang = Angle(70, -75, -74) }, [24] = { b_offset = Vector(51, 67, 11), b_ang = Angle(32, -66, -80) }, } },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(70, 85, 24) , ang = Angle(0, -67, 0) , seq = "idle" },
		{ mdl = Model( "models/error.mdl"), offset = Vector(-87, 65, 8) , ang = Angle(-1, -45, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/couch.mdl"), offset = Vector(47, 90, 5) , ang = Angle(0, -175, -1) , seq = "idle" },
		{ mdl = Model( "models/player/soldier_stripped.mdl"), offset = Vector(-83, -24, 36) , ang = Angle(-1, -1, -1) , seq = "ragdoll", tag = "gary", icon = Material( "sog/him.png", "smooth" ), rag = { [3] = { b_offset = Vector(-91, -23, 43), b_ang = Angle(-57, -169, 94) }, [6] = { b_offset = Vector(-97, -24, 57), b_ang = Angle(-80, 159, -62) }, [9] = { b_offset = Vector(-93, -32, 52), b_ang = Angle(39, -77, -146) }, [10] = { b_offset = Vector(-91, -41, 45), b_ang = Angle(-50, 67, 171) }, [11] = { b_offset = Vector(-89, -34, 54), b_ang = Angle(-28, 160, -55) }, [14] = { b_offset = Vector(-98, -17, 52), b_ang = Angle(60, 72, -79) }, [15] = { b_offset = Vector(-96, -11, 41), b_ang = Angle(-66, 50, -77) }, [16] = { b_offset = Vector(-93, -7, 52), b_ang = Angle(-13, 107, -71) }, [18] = { b_offset = Vector(-82, -29, 36), b_ang = Angle(-7, 34, -54) }, [19] = { b_offset = Vector(-67, -19, 38), b_ang = Angle(-9, 33, -53) }, [20] = { b_offset = Vector(-54, -10, 40), b_ang = Angle(-39, -11, -28) }, [22] = { b_offset = Vector(-83, -20, 36), b_ang = Angle(-38, 11, -101) }, [23] = { b_offset = Vector(-68, -18, 48), b_ang = Angle(15, -3, -109) }, [24] = { b_offset = Vector(-52, -18, 43), b_ang = Angle(-16, 2, -104) }, } },
		{ mdl = Model( "models/props_combine/breenchair.mdl"), offset = Vector(-73, -24, 12) , ang = Angle(-28, 11, -6) , seq = "idle" },
		{ mdl = Model( "models/props_combine/breenclock.mdl"), offset = Vector(-24, -55, 41) , ang = Angle(-1, -7, -1) , seq = "idle" },
		{ mdl = Model( "models/props_combine/combinebutton.mdl"), offset = Vector(-46, -67, 27) , ang = Angle(-1, -94, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(-5, -98, 6) , ang = Angle(-1, -125, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/moneypallet_washerdryer.mdl"), offset = Vector(-112, -93, 6) , ang = Angle(-1, -59, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-90, -57, 3) , ang = Angle(-1, -179, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(-31, -36, 37) , ang = Angle(0, -98, 1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(-35, -33, 37) , ang = Angle(0, -107, 2) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(-29, -17, 37) , ang = Angle(0, 26, 1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(94, -62, 4) , ang = Angle(-1, 0, -1) , seq = "idle" },
		{ mdl = Model( "models/props_c17/furniturechair001a.mdl"), offset = Vector(67, -96, 26) , ang = Angle(0, 103, -1) , seq = "idle" },
		{ mdl = Model( "models/player/breen.mdl"), offset = Vector(43, -16, 6) , ang = Angle(0, 179, 0) , seq = "pose_standing_02",tag = "owner", icon = Material( "sog/breen.png", "smooth" ) },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(3, -64, 3) , ang = Angle(-1, 0, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(2, 60, 3) , ang = Angle(0, 0, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(94, 61, 4) , ang = Angle(-1, 0, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-90, 66, 3) , ang = Angle(0, -180, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(8, -50, 6) , ang = Angle(-1, -75, -1) , seq = "idle" },
		{ mdl = Model( "models/maxofs2d/gm_painting.mdl"), offset = Vector(-17, 33, 23) , ang = Angle(-20, 84, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(3, -10, 6) , ang = Angle(0, 20, -180) , seq = "idle" },
		{ mdl = Model( "models/props_combine/breendesk.mdl"), offset = Vector(-37, -19, 6) , ang = Angle(0, -4, 0) , seq = "idle" },
		{ mdl = Model( "models/props_combine/breenbust.mdl"), offset = Vector(-21, 14, 52) , ang = Angle(0, -2, -1) , seq = "idle" },
		{ mdl = Model( "models/props_c17/doll01.mdl"), offset = Vector(69, -99, 29) , ang = Angle(-29, 91, 10) , seq = "idle", tag = "jr", icon = Material( "sog/thing.png", "smooth" ) },
	},
	Dialogues = function( sc )
		AddDialogueLine( sc.owner, "Hello there,\nI heard rumours that. . .", ". . .", ". . .there is an error behind you. . ." )
		AddDialogueLine( sc.gary, "It's harmless." )
		AddDialogueLine( sc.owner, "So yeah,\nI heard these rumours about upcoming things. . .", ". . .", "Are you sure it is a good idea?" )
		AddDialogueLine( sc.gary, "What?" )
		AddDialogueLine( sc.owner, "Well,\nyou know. . .", "Some of these things are not even finished.", "There has to be at least a reason for that." )
		AddDialogueLine( sc.gary, "I don't see the problem." )
		AddDialogueLine( sc.owner, "What I'm trying to say is\nthat 98% of addons will be broken." )
		AddDialogueLine( sc.gary, "So?" )
		AddDialogueLine( sc.owner, ". . .", "Not to mention disabled multicore rendering." )
		AddDialogueLine( sc.gary, "If you need - you can always fix your shit." )
		AddDialogueLine( sc.owner, "Well, yeah.\nI'm not sure if it would be a good idea to. . ." )
		AddDialogueLine( sc.gary, "Thus, this nice guy volunteered to contribute numerous\nhigh quality addons, as he says." )
		AddDialogueLine( sc.gary, ". . .", "A marketplace. Or something like that." )
		AddDialogueLine( sc.mark, "Absolutely!", ". . .", "For a fair price even your 1-year old kid will be\nable to make a successful community in less than a day!" )
		AddDialogueLine( sc.mark, ". . .", "It is all about creativity and opportunity." )
		AddDialogueLine( sc.owner, "I see. . ." )
		AddDialogueLine( sc.gary, "Just shut up and enjoy the fucking update.", ". . .", "I'm 100% sure that whole playerbase\nwill be bigger and nicer than ever." )
		AddDialogueLine( sc.sellout, ". . ." )
		AddDialogueLine( sc.jr, ". . ." )
		AddDialogueLine( sc.sellout, "I can guarantee that." )
		AddDialogueLine( sc.owner, ". . ." )
		AddDialogueLine( sc.gary, "If you don't have anything more to say. . .", ". . .then you'd better leave.", "I have more important things to do,\nunlike you." )
		AddDialogueLine( sc.owner, "Wait, what about. . ." )
		AddDialogueLine( sc.gary, "Get out!" )
		AddDialogueLine( sc.mark, ". . ." )
	end
}

GM.Cutscenes["_sog_demo1"][20] = {
	Intro = "2013\nLair of \"CoderFired\" Corporation",
	SoundTrack = 50672559,
	Volume = 75,
	StartFrom = 1*60*1000+15*1000, //1:15, all in milliseconds
	Main = { mdl = Model( "models/hunter/plates/plate6x6.mdl" ), seq = "idle"},
	Relative = {
		{ mdl = Model( "models/props/cs_assault/moneypallet.mdl"), offset = Vector(-142, -29, 6) , ang = Angle(1, 178, -1) , seq = "idle" },
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(20, -7, 279) , ang = Angle(88, -131, 0) , seq = "Idle" },
		{ mdl = Model( "models/props_combine/combine_binocular01.mdl"), offset = Vector(-89, 9, 25) , ang = Angle(46, -46, 0) , seq = "idle" },
		{ mdl = Model( "models/props_combine/combine_binocular01.mdl"), offset = Vector(-79, -52, 26) , ang = Angle(45, 45, -1) , seq = "idle" },
		{ mdl = Model( "models/props_combine/combine_binocular01.mdl"), offset = Vector(-66, -20, 26) , ang = Angle(45, 178, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/plant01.mdl"), offset = Vector(-81, -99, 5) , ang = Angle(-1, -77, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-83, 28, 3) , ang = Angle(-1, 90, 0) , seq = "idle" },
		{ mdl = Model( "models/player/group02/male_04.mdl"), offset = Vector(108, -79, 4) , ang = Angle(-1, 158, -2) , seq = "pose_ducking_02", PlayerColor = Color( 215, 77, 64 ) },
		{ mdl = Model( "models/player/group01/male_05.mdl"), offset = Vector(125, -35, 7) , ang = Angle(1, 173, 0) , seq = "pose_ducking_02", PlayerColor = Color( 215, 77, 64 ) },
		{ mdl = Model( "models/player/breen.mdl"), offset = Vector(114, 14, 5) , ang = Angle(1, -164, 0) , seq = "pose_ducking_02", t5 = true, icon = Material( "sog/breen.png", "smooth" ), PlayerColor = Color( 215, 77, 64 ) },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(105, -16, 3) , ang = Angle(-1, -1, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(114, 107, 3) , ang = Angle(0, -1, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/moneypallet03d.mdl"), offset = Vector(-140, 37, 6) , ang = Angle(-1, -1, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/trash_can.mdl"), offset = Vector(6, -143, 5) , ang = Angle(-1, -88, -1) , seq = "only_sequence" },
		{ mdl = Model( "models/player/phoenix.mdl"), offset = Vector(66, -89, 7) , ang = Angle(0, 157, 0) , seq = "pose_ducking_02", t2 = true, icon = Material( "sog/detective.png", "smooth" ), PlayerColor = Color( 215, 77, 64 ) },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(2, -29, 3) , ang = Angle(-1, -90, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage_carboard002a.mdl"), offset = Vector(27, -80, 5) , ang = Angle(-1, 14, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(94, -121, 3) , ang = Angle(-1, -91, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/shelves_metal1.mdl"), offset = Vector(95, -136, 6) , ang = Angle(-1, 89, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/cardboard_box004a.mdl"), offset = Vector(40, -130, 24) , ang = Angle(-1, -95, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/cardboard_box003a.mdl"), offset = Vector(49, -136, 15) , ang = Angle(-1, 178, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-102, -77, 3) , ang = Angle(0, -180, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/file_box_p2.mdl"), offset = Vector(-62, -134, 30) , ang = Angle(-1, -84, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-29, -121, 3) , ang = Angle(0, -90, 0) , seq = "idle" },
		{ mdl = Model( "models/weapons/w_rif_ak47.mdl"), offset = Vector(-30, -131, 31) , ang = Angle(-1, -110, -89) , seq = "idle" },
		{ mdl = Model( "models/weapons/w_smg_ump45.mdl"), offset = Vector(-5, -134, 30) , ang = Angle(0, -99, 89) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/phone.mdl"), offset = Vector(-41, -125, 30) , ang = Angle(0, 69, 0) , seq = "only_sequence", t3 = true, icon = Material( "sog/phone.png", "smooth" )},
		{ mdl = Model( "models/props/cs_office/table_coffee.mdl"), offset = Vector(-37, -134, 6) , ang = Angle(-1, -91, -1) , seq = "idle" },
		{ mdl = Model( "models/player/group02/male_06.mdl"), offset = Vector(79, -45, 5) , ang = Angle(-1, 179, 0) , seq = "pose_ducking_02", PlayerColor = Color( 215, 77, 64 ) },
		{ mdl = Model( "models/player/corpse1.mdl"), offset = Vector(-49, -71, 6) , ang = Angle(0, 0, -1) , seq = "pose_standing_03", PlayerColor = Color( 215, 77, 64 )  },
		{ mdl = Model( "models/props_combine/combine_intmonitor003.mdl"), offset = Vector(-91, -23, 39) , ang = Angle(-3, 3, -1) , seq = "idle" },
		{ mdl = Model( "models/player/group01/male_09.mdl"), offset = Vector(-39, 15, 5) , ang = Angle(0, 0, -1) , seq = "pose_standing_01", t1 = true, icon = Material( "sog/mark.png", "smooth" ), PlayerColor = Color( 215, 77, 64 ) },
		{ mdl = Model( "models/props/cs_militia/van.mdl"), offset = Vector(-31, 123, 6) , ang = Angle(-1, 89, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/van_glass.mdl"), offset = Vector(-31, 123, 7) , ang = Angle(0, 89, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/shovel01a.mdl"), offset = Vector(0, 70, 37) , ang = Angle(-16, -93, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/metalbucket01a.mdl"), offset = Vector(19, 66, 14) , ang = Angle(-1, -5, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(22, 82, 3) , ang = Angle(0, -180, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-87, 120, 3) , ang = Angle(0, -90, 0) , seq = "idle" },
		{ mdl = Model( "models/player/kleiner.mdl"), offset = Vector(67, 30, 4) , ang = Angle(-4, -161, 3) , seq = "pose_ducking_02", t4 = true, icon = Material( "sog/kleiner.png", "smooth" ), PlayerColor = Color( 215, 77, 64 ) },
		{ mdl = Model( "models/props_junk/garbage128_composite001b.mdl"), offset = Vector(89, 80, 10) , ang = Angle(-1, -129, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage_carboard001a.mdl"), offset = Vector(19, 17, 6) , ang = Angle(-1, 55, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage_carboard002a.mdl"), offset = Vector(-10, -23, 5) , ang = Angle(0, -73, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/moneypallete.mdl"), offset = Vector(-134, -105, 5) , ang = Angle(0, 104, 0) , seq = "idle" },
		{ mdl = Model( "models/player/zombie_fast.mdl"), offset = Vector(72, -9, 4) , ang = Angle(0, -175, -2) , seq = "pose_ducking_01", PlayerColor = Color( 215, 77, 64 ) },
	},
	Dialogues = function( sc )
		AddDialogueLine( sc.t1, "Good evening, my dear coders!", "First of all I'd like to welcome our new employee. . ." )
		AddDialogueLine( sc.t1, "Steve, say 'Hello'." )
		AddDialogueLine( sc.t2, "Um. . . Hello?" )
		AddDialogueLine( sc.t1, "See? Steve says 'Hello'.",". . .", "So, Steve. . .", "Show us what you've got, and I will show you\nhow to sell it properly." )
		AddDialogueLine( sc.t2, "Well. . .", "I've made this TTT HUD 2 days ago,\nthat I've wanted to put on worksho. . ." )
		AddDialogueLine( sc.t1, "No no no no. . .", "That is not how you get rich, Steve.", "Let me demonstrate.", ". . .", "What is your HUD called?" )
		AddDialogueLine( sc.t2, "\"Steve's TTT HUD\"?" )
		AddDialogueLine( sc.t1, "No!!! Call it something like. . .", "\"Sexually attractive TTT HUD\"!", ". . .", "Any other suggestions, guys?" )
		AddDialogueLine( sc.t4, "\"SLEEK AND CRYSTAL TTT HUD BY STEVE\"" )
		AddDialogueLine( sc.t1, "That's better!", "Now all you need is a distracting picture\nwith some happy ragdolls and a 40$ price tag!" )
		AddDialogueLine( sc.t2, "Alright, I guess?" )
		AddDialogueLine( sc.t1, "Exactly, Steve!", "Now, the serious news.", ". . .", "Right now there is only one thing that is stopping us\nfrom controlling the entire GMod." )
		AddDialogueLine( sc.t1, "If you know what I'm talking about." )
		AddDialogueLine( sc.t5, ". . ." )
		AddDialogueLine( sc.t1, "Do you know what I'm talking about?" )
		AddDialogueLine( sc.t4, ". . ." )
		AddDialogueLine( sc.t2, "Our overpriced things?" )
		AddDialogueLine( sc.t1, "NO!!!!!!", ". . .", "Goddamnit, Steve. Of course not." )
		AddDialogueLine( sc.t1, "I'm talking about that evil thing, called \"Workshop\"." )
		AddDialogueLine( sc.t2, "*gasp*" )
		AddDialogueLine( sc.t4, "*gasp*" )
		AddDialogueLine( sc.t5, "*gasp*" )
		AddDialogueLine( sc.t1, "We can't just rule this place, when somewhere people\nare able to get all these addons for free!" )
		AddDialogueLine( sc.t1, ". . .", "I need to talk to garry, someday.", "Hopefully he will understand why paying for stuff\nin Workshop is going to be better." )
		AddDialogueLine( sc.t1, "For all of us.", ". . .", "Nah, just kidding.", "Only for us, of course." )
		AddDialogueLine( sc.t3, "*extremely loud phone ringing*" )
		AddDialogueLine( sc.t1, "Helloooo?" )
		AddDialogueLine( sc.t3, "Mark, is that you?" )
		AddDialogueLine( sc.t1, "Yes yes, it's me.", "Go ahead. . ." )
		AddDialogueLine( sc.t3, "We've got a really bad situation over here. . ." )
		AddDialogueLine( sc.t1, "Explain." )
		AddDialogueLine( sc.t3, "There is that server owner that doesn't wants\nto purchase our scripts." )
		AddDialogueLine( sc.t3, ". . .", "He said something about \"overpriced crap\".", ". . .", "What do we do?" )
		AddDialogueLine( sc.t1, "Don't worry, my friend.", ". . .", "Gentlemen, today we are going to teach\nthis person a valuable lesson." )
		AddDialogueLine( sc.t1, "Remember our slogan, guys!", ". . .", "Time is money. . .")
		AddDialogueLine( sc.t5, ". . .and money equals power!" )
		AddDialogueLine( sc.t1, "Exactly!!!" , ". . .", "To the van, my dear friends!" )

	end,
}

GM.Cutscenes["_sog_demo1"][22] = {
	Intro = "2013\nf^$#65 b&*((65 hs%4^&*",
	SoundTrack = 109486027,
	Volume = 20,
	Main = { mdl = Model( "models/hunter/plates/plate8x8.mdl" ), seq = "idle"},
	Relative = {
		{ mdl = Model( "models/props_canal/locks_small_b.mdl"), offset = Vector(174, -137, 27) , ang = Angle(-89, -65, 64) , seq = "idle" },
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(25, -18, 313) , ang = Angle(88, 159, -1) , seq = "Idle" },
		{ mdl = Model( "models/props/cs_assault/wirespout.mdl"), offset = Vector(83, 61, 50) , ang = Angle(0, -136, -4) , seq = "idle" },
		{ mdl = Model( "models/props_junk/cardboard_box003a.mdl"), offset = Vector(115, 73, 60) , ang = Angle(2, 158, 0) , seq = "idle" },
		{ mdl = Model( "models/zombie/poison.mdl"), offset = Vector(5, 43, 73) , ang = Angle(-52, -86, -11) , seq = "releasecrab", t1 = true, icon = Material( "sog/horror.png", "smooth" ) },
		{ mdl = Model( "models/props_junk/cinderblock01a.mdl"), offset = Vector(-132, -78, 54) , ang = Angle(86, 119, -56) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage_bag001a.mdl"), offset = Vector(-145, 53, 54) , ang = Angle(-22, -26, -88) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/wood_bench.mdl"), offset = Vector(-84, 66, 52) , ang = Angle(-5, -150, 74) , seq = "idle" },
		{ mdl = Model( "models/props_wasteland/kitchen_counter001d.mdl"), offset = Vector(-51, -146, 23) , ang = Angle(-1, -180, -1) , seq = "idle" },
		{ mdl = Model( "models/props_c17/gravestone_cross001a.mdl"), offset = Vector(3, 105, 116) , ang = Angle(0, -90, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/cardboard_box003a.mdl"), offset = Vector(106, 80, 74) , ang = Angle(1, -144, 1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/cardboard_box003a.mdl"), offset = Vector(96, 97, 59) , ang = Angle(-1, 174, 0) , seq = "idle" },
		{ mdl = Model( "models/props_lab/servers.mdl"), offset = Vector(136, 105, 50) , ang = Angle(-1, -135, 0) , seq = "idle" },
		{ mdl = Model( "models/props_canal/locks_small_b.mdl"), offset = Vector(122, 209, 29) , ang = Angle(-90, 15, 74) , seq = "idle" },
		{ mdl = Model( "models/props_c17/gravestone002a.mdl"), offset = Vector(-20, 85, 79) , ang = Angle(-1, -180, -1) , seq = "idle" },
		{ mdl = Model( "models/props_c17/chair_kleiner03a.mdl"), offset = Vector(5, 62, 49) , ang = Angle(-1, 90, 0) , seq = "idle" },
		{ mdl = Model( "models/props_c17/gravestone002a.mdl"), offset = Vector(27, 84, 78) , ang = Angle(1, 0, 1) , seq = "idle" },
		{ mdl = Model( "models/props_canal/locks_small.mdl"), offset = Vector(-149, -218, 27) , ang = Angle(-89, -17, -73) , seq = "idle" },
		{ mdl = Model( "models/props_canal/locks_small_b.mdl"), offset = Vector(-149, 211, 26) , ang = Angle(-89, 19, 70) , seq = "idle" },
		{ mdl = Model( "models/props_wasteland/kitchen_counter001d.mdl"), offset = Vector(-129, -2, 18) , ang = Angle(-1, -90, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/paintbucket01.mdl"), offset = Vector(-137, 66, 50) , ang = Angle(0, -72, -1) , seq = "idle" },
		{ mdl = Model( "models/props_canal/locks_small.mdl"), offset = Vector(-74, 161, 25) , ang = Angle(-89, -112, -69) , seq = "idle" },
		{ mdl = Model( "models/props_canal/locks_small.mdl"), offset = Vector(-14, -111, 32) , ang = Angle(-90, -90, 0) , seq = "idle" },
		{ mdl = Model( "models/props_lab/reciever_cart.mdl"), offset = Vector(-104, 122, 62) , ang = Angle(-89, 28, -143) , seq = "idle" },
		{ mdl = Model( "models/props_canal/locks_small.mdl"), offset = Vector(203, -19, 31) , ang = Angle(-90, 0, 0) , seq = "idle" },
		{ mdl = Model( "models/props_canal/locks_small.mdl"), offset = Vector(124, -222, 29) , ang = Angle(-90, -19, -72) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/table_coffee_p1.mdl"), offset = Vector(170, 22, 81) , ang = Angle(-20, 115, -174) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/table_coffee_p2.mdl"), offset = Vector(156, 5, 79) , ang = Angle(-25, -166, 179) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage128_composite001c.mdl"), offset = Vector(125, -11, 56) , ang = Angle(-1, -141, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage256_composite002b.mdl"), offset = Vector(110, -144, 54) , ang = Angle(-1, -86, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/boxes_frontroom.mdl"), offset = Vector(139, -168, 47) , ang = Angle(-1, -180, -1) , seq = "idle" },
		{ mdl = Model( "models/kleiner.mdl"), offset = Vector(76, -79, 56) , ang = Angle(-1, 134, 2) , seq = "injured3", t3 = true, icon = Material( "sog/kleiner.png", "smooth" ) },
		{ mdl = Model( "models/kleiner.mdl"), offset = Vector(32, -81, 54) , ang = Angle(3, 112, -1) , seq = "injured1", t2 = true, icon = Material( "sog/kleiner.png", "smooth" ) },
		{ mdl = Model( "models/kleiner.mdl"), offset = Vector(2, -61, 57) , ang = Angle(-1, 90, 0) , seq = "injured1", t4 = true, icon = Material( "sog/kleiner.png", "smooth" ) },
		{ mdl = Model( "models/kleiner.mdl"), offset = Vector(-22, -43, 56) , ang = Angle(-1, 69, -3) , seq = "injured1", t5 = true, icon = Material( "sog/kleiner.png", "smooth" ) },
		{ mdl = Model( "models/props_junk/garbage256_composite001b.mdl"), offset = Vector(-89, -101, 55) , ang = Angle(0, -45, 0) , seq = "idle" },
		{ mdl = Model( "models/props_lab/monitor02.mdl"), offset = Vector(-67, -108, 50) , ang = Angle(0, -90, -1) , seq = "idle" },
		{ mdl = Model( "models/kleiner.mdl"), offset = Vector(-59, -85, 53) , ang = Angle(-1, 52, 1) , seq = "injured4", t7 = true, icon = Material( "sog/kleiner.png", "smooth" ) },
		{ mdl = Model( "models/player/kleiner.mdl"), offset = Vector(-5, -120, 55) , ang = Angle(-2, 90, 0) , seq = "pose_ducking_02", t6 = true, icon = Material( "sog/kleiner.png", "smooth" ) },
		{ mdl = Model( "models/props/cs_assault/acunit02.mdl"), offset = Vector(95, 144, 104) , ang = Angle(1, 135, 178) , seq = "idle" },
	},
	Dialogues = function( sc )
		AddDialogueLine( sc.t1, "My children. . .","It is time\n. . .","It is time for another harvest.",". . ." )
		AddDialogueLine( sc.t2, "Sacrificcceeeee. . ." )
		AddDialogueLine( sc.t3, "Yesssssss. . ." )
		AddDialogueLine( sc.t4, "Donationsss and sacrificccceee!!!" )
		AddDialogueLine( sc.t5, "The sacrificcccceeeeee. . ." )
		AddDialogueLine( sc.t6, "The harvessssssst. . ." )
		AddDialogueLine( sc.t1, "Make your master proud, my children. . .", "Make me proud and you will be rewarded. . .", "Soon we will take back everything that once taken from us\n. . ." )
		AddDialogueLine( sc.t1, "Remember. . .\nWe are the family. . ." )
	end,
}

GM.Cutscenes["_sog_demo1"][25] = {
	SoundTrack = 16748171,
	Volume = 25,
	Intro = "2013\n)sd5*^&d*&^545dkjH@^#8)(j_)**&6",
	Main = { mdl = Model( "models/hunter/plates/plate8x8.mdl" ), seq = "idle"},
	Relative = {
		{ mdl = Model( "models/kleiner.mdl"), offset = Vector(29, -82, 58) , ang = Angle(0, 120, 3) , seq = "injured1", tag = "k1", icon = Material( "sog/kleiner.png", "smooth" ) },
		{ mdl = Model( "models/props/cs_assault/wirespout.mdl"), offset = Vector(83, 61, 50) , ang = Angle(0, -136, -4) , seq = "idle" },
		{ mdl = Model( "models/props_junk/cardboard_box003a.mdl"), offset = Vector(115, 73, 60) , ang = Angle(1, 158, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/cinderblock01a.mdl"), offset = Vector(-132, -79, 54) , ang = Angle(86, 119, -56) , seq = "idle" },
		{ mdl = Model( "models/gibs/wood_gib01d.mdl"), offset = Vector(-35, -20, 60) , ang = Angle(1, 119, 179) , seq = "idle" },
		{ mdl = Model( "models/props_junk/harpoon002a.mdl"), offset = Vector(-43, -5, 99) , ang = Angle(-90, -131, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/harpoon002a.mdl"), offset = Vector(-48, -6, 99) , ang = Angle(-88, -138, -96) , seq = "idle" },
		{ mdl = Model( "models/props_junk/harpoon002a.mdl"), offset = Vector(-48, -1, 99) , ang = Angle(-86, 167, 149) , seq = "idle" },
		{ mdl = Model( "models/humans/charple03.mdl"), offset = Vector(-46, 2, 85) , ang = Angle(-0, 2, 0) , seq = "ragdoll", rag = { [1] = { b_offset = Vector(-44, -3, 87), b_ang = Angle(-2, -81, 128) }, [2] = { b_offset = Vector(-43, -8, 87), b_ang = Angle(26, -82, 100) }, [3] = { b_offset = Vector(-41, -17, 83), b_ang = Angle(42, -82, 73) }, } },
		{ mdl = Model( "models/humans/charple02.mdl"), offset = Vector(-53, -6, 117) , ang = Angle(-0, 2, 0) , seq = "ragdoll", rag = { [1] = { b_offset = Vector(-50, -3, 122), b_ang = Angle(3, 34, -118) }, [2] = { b_offset = Vector(-46, -1, 121), b_ang = Angle(45, 49, -103) }, [3] = { b_offset = Vector(-39, 0, 117), b_ang = Angle(58, -37, 81) }, [4] = { b_offset = Vector(-34, -4, 107), b_ang = Angle(55, -94, -2) }, [5] = { b_offset = Vector(-34, -10, 98), b_ang = Angle(76, -45, 47) }, [6] = { b_offset = Vector(-47, 5, 116), b_ang = Angle(75, 155, 103) }, [7] = { b_offset = Vector(-50, 6, 104), b_ang = Angle(87, -117, -169) }, [8] = { b_offset = Vector(-41, 5, 114), b_ang = Angle(75, 64, -112) }, [9] = { b_offset = Vector(-53, -10, 115), b_ang = Angle(85, -101, 153) }, [10] = { b_offset = Vector(-54, -11, 96), b_ang = Angle(77, -147, 107) }, [11] = { b_offset = Vector(-55, -5, 114), b_ang = Angle(83, 60, -47) }, [12] = { b_offset = Vector(-54, -3, 95), b_ang = Angle(79, 171, 65) }, } },
		{ mdl = Model( "models/gibs/wood_gib01c.mdl"), offset = Vector(-51, -17, 65) , ang = Angle(0, -141, -13) , seq = "idle" },
		{ mdl = Model( "models/gibs/wood_gib01a.mdl"), offset = Vector(-33, -5, 62) , ang = Angle(6, 12, 4) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage_bag001a.mdl"), offset = Vector(-43, 7, 61) , ang = Angle(43, 35, -5) , seq = "idle" },
		{ mdl = Model( "models/props_c17/gravestone002a.mdl"), offset = Vector(27, 83, 78) , ang = Angle(0, 0, 0) , seq = "idle" },
		{ mdl = Model( "models/kleiner.mdl"), offset = Vector(-42, -98, 60) , ang = Angle(4, 76, -1) , seq = "injured1", tag = "k2", icon = Material( "sog/kleiner.png", "smooth" ) },
		{ mdl = Model( "models/player/kleiner.mdl"), offset = Vector(1, -76, 57) , ang = Angle(0, 103, 5) , seq = "pose_ducking_02", tag = "thomas", icon = Material( "sog/thomas.png", "smooth" ),PlayerColor = Color( 250, 0, 250 ) },
		{ mdl = Model( "models/props_canal/locks_small.mdl"), offset = Vector(-15, -111, 31) , ang = Angle(-90, -163, 71) , seq = "idle" },
		{ mdl = Model( "models/props_c17/chair_kleiner03a.mdl"), offset = Vector(2, 62, 52) , ang = Angle(-3, 90, 1) , seq = "idle" },
		{ mdl = Model( "models/zombie/poison.mdl"), offset = Vector(1, 66, 101) , ang = Angle(-0, 2, 0) , seq = "refpose", tag = "evil", icon = Material( "sog/horror.png", "smooth" ), rag = { [1] = { b_offset = Vector(2, 71, 105), b_ang = Angle(-80, 29, 59) }, [3] = { b_offset = Vector(3, 69, 111), b_ang = Angle(-55, -85, 164) }, [6] = { b_offset = Vector(11, 61, 116), b_ang = Angle(48, 7, 1) }, [7] = { b_offset = Vector(19, 62, 106), b_ang = Angle(8, -78, -48) }, [8] = { b_offset = Vector(22, 51, 104), b_ang = Angle(31, -86, -76) }, [17] = { b_offset = Vector(-5, 63, 120), b_ang = Angle(68, 172, 1) }, [18] = { b_offset = Vector(-10, 64, 109), b_ang = Angle(14, -105, 67) }, [19] = { b_offset = Vector(-13, 53, 106), b_ang = Angle(22, -142, 2) }, [22] = { b_offset = Vector(6, 65, 100), b_ang = Angle(7, -71, -116) }, [23] = { b_offset = Vector(12, 48, 98), b_ang = Angle(55, -111, -139) }, [24] = { b_offset = Vector(8, 39, 84), b_ang = Angle(55, -53, -99) }, [26] = { b_offset = Vector(-3, 64, 103), b_ang = Angle(14, -96, 63) }, [27] = { b_offset = Vector(-4, 47, 97), b_ang = Angle(63, -147, 28) }, [28] = { b_offset = Vector(-10, 43, 81), b_ang = Angle(27, -76, 91) }, } },
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(8, -3, 290) , ang = Angle(89, 159, 0) , seq = "Idle" },
		{ mdl = Model( "models/props_junk/garbage_bag001a.mdl"), offset = Vector(-146, 52, 54) , ang = Angle(-22, -26, -88) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/paintbucket01.mdl"), offset = Vector(-137, 66, 50) , ang = Angle(0, -72, -1) , seq = "idle" },
		{ mdl = Model( "models/props_lab/reciever_cart.mdl"), offset = Vector(-104, 122, 62) , ang = Angle(-89, 27, -143) , seq = "idle" },
		{ mdl = Model( "models/props_canal/locks_small_b.mdl"), offset = Vector(-149, 210, 26) , ang = Angle(-89, 19, 69) , seq = "idle" },
		{ mdl = Model( "models/props_wasteland/kitchen_counter001d.mdl"), offset = Vector(-51, -146, 23) , ang = Angle(-1, 180, -1) , seq = "idle" },
		{ mdl = Model( "models/props_canal/locks_small.mdl"), offset = Vector(-150, -219, 27) , ang = Angle(-89, -18, -73) , seq = "idle" },
		{ mdl = Model( "models/props_canal/locks_small_b.mdl"), offset = Vector(174, -138, 27) , ang = Angle(-89, -65, 63) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage256_composite002b.mdl"), offset = Vector(110, -145, 54) , ang = Angle(-1, -86, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage256_composite001b.mdl"), offset = Vector(-90, -101, 55) , ang = Angle(-0, -45, 0) , seq = "idle" },
		{ mdl = Model( "models/props_lab/monitor02.mdl"), offset = Vector(-67, -108, 50) , ang = Angle(-1, -91, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/boxes_frontroom.mdl"), offset = Vector(139, -168, 47) , ang = Angle(-1, 180, -1) , seq = "idle" },
		{ mdl = Model( "models/props_c17/gravestone002a.mdl"), offset = Vector(-20, 84, 79) , ang = Angle(-1, 180, -1) , seq = "idle" },
		{ mdl = Model( "models/props_canal/locks_small.mdl"), offset = Vector(-75, 161, 25) , ang = Angle(-89, -113, -69) , seq = "idle" },
		{ mdl = Model( "models/props_canal/locks_small_b.mdl"), offset = Vector(121, 208, 29) , ang = Angle(-90, 89, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/cardboard_box003a.mdl"), offset = Vector(96, 97, 59) , ang = Angle(-1, 174, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/cardboard_box003a.mdl"), offset = Vector(106, 80, 74) , ang = Angle(0, -145, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/acunit02.mdl"), offset = Vector(95, 144, 104) , ang = Angle(0, 135, 178) , seq = "idle" },
		{ mdl = Model( "models/props_lab/servers.mdl"), offset = Vector(136, 105, 50) , ang = Angle(-1, -135, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/wood_bench.mdl"), offset = Vector(-84, 66, 52) , ang = Angle(-5, -150, 74) , seq = "idle" },
		{ mdl = Model( "models/props_canal/locks_small.mdl"), offset = Vector(203, -20, 31) , ang = Angle(-90, -0, 0) , seq = "idle" },
		{ mdl = Model( "models/props_canal/locks_small.mdl"), offset = Vector(124, -222, 29) , ang = Angle(-90, -91, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/table_coffee_p2.mdl"), offset = Vector(156, 4, 79) , ang = Angle(-26, -166, 179) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/table_coffee_p1.mdl"), offset = Vector(170, 21, 81) , ang = Angle(-20, 115, -174) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage128_composite001c.mdl"), offset = Vector(125, -11, 56) , ang = Angle(-1, -141, -1) , seq = "idle" },
		{ mdl = Model( "models/kleiner.mdl"), offset = Vector(105, -28, 57) , ang = Angle(0, 168, 7) , seq = "injured3", tag = "k3", icon = Material( "sog/kleiner.png", "smooth" ) },
		{ mdl = Model( "models/kleiner.mdl"), offset = Vector(59, -52, 58) , ang = Angle(2, 133, 0) , seq = "injured1" },
		{ mdl = Model( "models/props_c17/gravestone_cross001a.mdl"), offset = Vector(3, 105, 116) , ang = Angle(-1, -91, -1) , seq = "idle" },
	},
	Dialogues = function( sc )
		AddDialogueLine( sc.evil, "My children. . ." )
		AddDialogueLine( sc.k3, "The sacrificceee. . ." )
		AddDialogueLine( sc.evil, ". . .", "It's not working, my children.", "The sacrifice is not working!" )
		AddDialogueLine( sc.k1, ". . ." )
		AddDialogueLine( sc.evil, "I've burned thousands of my players. . .", ". . .and it's not helping me. . .",". . .to become alive." )
		AddDialogueLine( sc.k2, "But, my master. . .\nWe did everything you told us to. . ." )
		AddDialogueLine( sc.evil, "Yes, my child, I know. . .", ". . .", "If only. . ." )
		AddDialogueLine( sc.thomas, ". . ." )
		AddDialogueLine( sc.evil, "If we had a volunteer. . .",". . .", ". . .yesss, the perfect volunteer. . ." )
		AddDialogueLine( sc.k1, "yesssssss" )
		AddDialogueLine( sc.evil, "A perfect body, capable of containing all pointshop\nitems at oncccce. . ." )
		AddDialogueLine( sc.thomas, ":O" )
		AddDialogueLine( sc.evil, "A stolen credit card, capable to keeping me alive. . ." )
		AddDialogueLine( sc.thomas, ":OOOO" )
		AddDialogueLine( sc.k3, "yessss" )
		AddDialogueLine( sc.evil, "A remedy, that will be a symbol of our community. . .", ". . .the perfect specimen. . ." )
		AddDialogueLine( sc.thomas, ":OOOOOOOOOO" )
		AddDialogueLine( sc.evil, "Hmmm. . .", "You there,\nwhat is your name?" )
		AddDialogueLine( sc.thomas, "Me, my master?" )
		AddDialogueLine( sc.evil, "Yes, my child. . ." )
		AddDialogueLine( sc.thomas, "T-t-h-h-o. . .", ". . .Thomas. . ." )
		AddDialogueLine( sc.evil, "Thomas, my dear child. . .", "You will be that volunteer. . ." )
		AddDialogueLine( sc.thomas, "B-b-but I. . ." )
		AddDialogueLine( sc.evil, "There is no time for that, Thomas.", ". . .", "Prepare the hose and the pointshop,\nmy children. . ." )
		AddDialogueLine( sc.k1, "the hosssseeee" )
		AddDialogueLine( sc.k2, "yesssss, the ritual. . ." )
		AddDialogueLine( sc.evil, "From now on, Thomas, you will be known as. . .", ". . ." )
		AddDialogueLine( sc.evil, ". . .The Donator!" )
		AddDialogueAction( sc.evil, function( me ) surface.PlaySound( "ambient/creatures/town_child_scream1.wav" ) end )
	end,
}


//axe
GM.Cutscenes["_sog_demo2"][0] = {
	Intro = "2013\n\"Stay Rusty\" bar",
	SoundTrack = 141106522,
	Volume = 20,
	Main = { mdl = Model( "models/hunter/plates/plate8x8.mdl" ), seq = "idle"},
	Relative = {
		{ mdl = Model( "models/props/cs_militia/mountedfish01.mdl"), offset = Vector(-110, 128, 61) , ang = Angle(0, 89, -1) , seq = "idle" },
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(12, 6, 307) , ang = Angle(89, 143, 0) , seq = "Idle" },
		{ mdl = Model( "models/props/cs_militia/bar01.mdl"), offset = Vector(-43, 31, 7) , ang = Angle(-1, -90, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage_plasticbottle002a.mdl"), offset = Vector(-79, 9, 16) , ang = Angle(-23, 73, -2) , seq = "idle" },
		{ mdl = Model( "models/player/group02/male_04.mdl"), offset = Vector(105, 142, 8) , ang = Angle(0, -179, 0) , seq = "zombie_slump_idle_01" },
		{ mdl = Model( "models/props/cs_militia/housefence.mdl"), offset = Vector(86, -25, 5) , ang = Angle(-90, -169, 168) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/paintbucket01.mdl"), offset = Vector(5, 202, 6) , ang = Angle(-1, 7, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/housefence_door.mdl"), offset = Vector(89, 184, 5) , ang = Angle(-90, -125, 124) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/bar01.mdl"), offset = Vector(-59, 154, 7) , ang = Angle(-1, 0, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/food_stack.mdl"), offset = Vector(-158, 176, 7) , ang = Angle(0, 83, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/housefence_door.mdl"), offset = Vector(-221, 196, 5) , ang = Angle(-90, -180, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/fertilizer.mdl"), offset = Vector(-126, 71, 7) , ang = Angle(-1, 175, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/housefence.mdl"), offset = Vector(-122, -10, 5) , ang = Angle(-90, 11, -12) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/caseofbeer01.mdl"), offset = Vector(-170, 82, 7) , ang = Angle(0, 86, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/food_stack.mdl"), offset = Vector(-154, -12, 7) , ang = Angle(0, -91, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/toilet.mdl"), offset = Vector(-127, -111, 7) , ang = Angle(0, 0, -1) , seq = "idle" },
		{ mdl = Model( "models/player/group02/male_06.mdl"), offset = Vector(-93, -102, 33) , ang = Angle(85, -38, 127) , seq = "sit_camera" },
		{ mdl = Model( "models/props/cs_militia/boxes_garage_lower.mdl"), offset = Vector(-170, -96, 7) , ang = Angle(0, -136, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/housefence.mdl"), offset = Vector(-226, -17, 6) , ang = Angle(-90, 11, 168) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage256_composite002b.mdl"), offset = Vector(136, -4, 10) , ang = Angle(-1, 3, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/wood_bench.mdl"), offset = Vector(154, -83, 6) , ang = Angle(-1, 74, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/footlocker01_closed.mdl"), offset = Vector(15, -147, 19) , ang = Angle(-1, 89, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage128_composite001a.mdl"), offset = Vector(98, -173, 11) , ang = Angle(0, -71, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/housefence.mdl"), offset = Vector(87, -37, 5) , ang = Angle(-90, -131, -50) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/housefence.mdl"), offset = Vector(189, 29, 6) , ang = Angle(-90, 147, -148) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/housefence.mdl"), offset = Vector(-17, -31, 5) , ang = Angle(-90, -162, -18) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/wood_table.mdl"), offset = Vector(110, -84, 6) , ang = Angle(-1, 67, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage_glassbottle003a.mdl"), offset = Vector(118, -65, 38) , ang = Angle(19, 10, -91) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage_plasticbottle002a.mdl"), offset = Vector(104, -75, 44) , ang = Angle(-5, -74, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/housefence_door.mdl"), offset = Vector(-123, -190, 5) , ang = Angle(-90, -3, -178) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/logpile2.mdl"), offset = Vector(-81, -125, 7) , ang = Angle(-1, -91, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/housefence.mdl"), offset = Vector(-122, 19, 6) , ang = Angle(-90, -180, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/urine_trough.mdl"), offset = Vector(-54, -37, 33) , ang = Angle(0, -90, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage_newspaper001a.mdl"), offset = Vector(105, -101, 37) , ang = Angle(0, -83, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/trash_can_p8.mdl"), offset = Vector(171, 156, 1) , ang = Angle(43, 153, -51) , seq = "only_sequence" },
		{ mdl = Model( "models/props/cs_office/trash_can_p5.mdl"), offset = Vector(134, 157, -4) , ang = Angle(29, 5, 2) , seq = "only_sequence" },
		{ mdl = Model( "models/props/cs_militia/wood_bench.mdl"), offset = Vector(158, 70, 7) , ang = Angle(-1, -80, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/wood_table.mdl"), offset = Vector(128, 54, 7) , ang = Angle(-1, -91, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage_metalcan001a.mdl"), offset = Vector(132, 70, 40) , ang = Angle(0, -25, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage_metalcan002a.mdl"), offset = Vector(135, 63, 40) , ang = Angle(-1, 0, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/bottle01.mdl"), offset = Vector(136, 31, 39) , ang = Angle(-19, 65, -90) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/barstool01.mdl"), offset = Vector(33, -53, 14) , ang = Angle(87, -59, 10) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage_bag001a.mdl"), offset = Vector(5, -102, 12) , ang = Angle(0, -31, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/barstool01.mdl"), offset = Vector(26, 5, 2) , ang = Angle(0, -86, 1) , seq = "idle" },
		{ mdl = Model( "models/player/group03/male_09.mdl"), offset = Vector(28, 4, 41) , ang = Angle(25, 175, 10) , seq = "sit_fist", t2 = true, icon = Material( "sog/male_09.png", "smooth" ) },
		{ mdl = Model( "models/props_junk/garbage_glassbottle003a.mdl"), offset = Vector(4, 10, 60) , ang = Angle(-3, 11, -4) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/axe.mdl"), offset = Vector(6, -26, 45) , ang = Angle(48, 150, -94) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/newspaperstack01.mdl"), offset = Vector(-133, -86, 7) , ang = Angle(-1, -21, -2) , seq = "idle" },
		{ mdl = Model( "models/props_junk/shovel01a.mdl"), offset = Vector(-41, -117, 38) , ang = Angle(-22, 72, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/caseofbeer01.mdl"), offset = Vector(-75, -21, 51) , ang = Angle(0, 50, -1) , seq = "idle" },
		{ mdl = Model( "models/props_c17/tv_monitor01.mdl"), offset = Vector(-35, -21, 61) , ang = Angle(0, 30, -1) , seq = "idle", t3 = true, icon = Material( "sog/tv.png", "smooth" ) },
		{ mdl = Model( "models/props/cs_militia/refrigerator01.mdl"), offset = Vector(-112, 27, 7) , ang = Angle(0, 0, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/radio.mdl"), offset = Vector(-106, 41, 83) , ang = Angle(-2, 156, -1) , seq = "only_sequence" },
		{ mdl = Model( "models/props/cs_militia/stove01.mdl"), offset = Vector(-110, 71, 25) , ang = Angle(-1, -3, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/housefence.mdl"), offset = Vector(-18, 26, 5) , ang = Angle(-90, 158, -159) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/gun_cabinet.mdl"), offset = Vector(-104, 111, 7) , ang = Angle(-1, -1, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/caseofbeer01.mdl"), offset = Vector(-61, 187, 51) , ang = Angle(-1, -4, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/circularsaw01.mdl"), offset = Vector(-41, 185, 51) , ang = Angle(0, 34, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/phone_p1.mdl"), offset = Vector(-117, 185, 51) , ang = Angle(0, -108, 0) , seq = "only_sequence" },
		{ mdl = Model( "models/props/cs_militia/barstool01.mdl"), offset = Vector(41, 160, 11) , ang = Angle(-46, 1, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/barstool01.mdl"), offset = Vector(37, 90, 14) , ang = Angle(-1, -39, -88) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/barstool01.mdl"), offset = Vector(27, 36, 7) , ang = Angle(0, -91, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/bottle02.mdl"), offset = Vector(-10, 52, 51) , ang = Angle(0, 90, 0) , seq = "idle" },
		{ mdl = Model( "models/props_c17/metalpot002a.mdl"), offset = Vector(-18, 82, 53) , ang = Angle(-1, -19, -1) , seq = "idle" },
		{ mdl = Model( "models/player/odessa.mdl"), offset = Vector(-56, 43, 13) , ang = Angle(-1, 0, 2) , seq = "pose_standing_01", t1 = true, icon = Material( "sog/odessa.png", "smooth" ) },
		{ mdl = Model( "models/props_junk/garbage_metalcan001a.mdl"), offset = Vector(-79, 57, 9) , ang = Angle(-27, 40, -91) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage_carboard002a.mdl"), offset = Vector(152, 152, 7) , ang = Angle(-1, 24, -1) , seq = "idle" },
	},
	Dialogues = function( sc )
		AddDialogueLine( sc.t3, "*chkt*",". . .according to his latest tweet - Rust is\nnow more popular than his previous. . ." )
		AddDialogueLine( sc.t3, "*chkt*",". . .also considering to abandon the development\nof garry's mod which is no use for him anymo. . ." )
		AddDialogueLine( sc.t3, "*chkt*",". . .on the other news it is worth mentioning\nthe rise of glorious roleplay servers. . ." )
		AddDialogueLine( sc.t3, "*chkt*",". . .\". . .this is our brightest future, my friends!\nMicrotransactions in workshop will surely. . .\". . ." )
		AddDialogueLine( sc.t2, "Who left this shit on?\n. . ." )
		AddDialogueLine( sc.t1, ". . .","You don't sound too happy about the news." )
		AddDialogueLine( sc.t2, "News?\n. . .","It's more of a propaganda, than just news.", ". . .", "Mindless idiots. . ." )
		AddDialogueLine( sc.t1, "Huh\n. . .","Whatever you call it then. . ." )
		AddDialogueLine( sc.t3, "*chkt*",". . .and now we'd like to advertise another custom\nDarkRP server! Featuring over 30 custom addons and. . ." )
		AddDialogueLine( sc.t2, "I think I'm going to take a walk outside.\n. . .","Sick of this fucking shit." )
	end,
}

GM.Cutscenes["_sog_demo2"][1] = {
	Intro = "2013\nCarl's room.\n \nDisclaimer: Room and it's owner are\nfull-time property of a shitty community",
	SoundTrack = 114946270,
	Volume = 55,
	Main = { mdl = Model( "models/hunter/plates/plate5x5.mdl" ), seq = "idle"},
	Relative = {
		{ mdl = Model( "models/humans/group01/male_02.mdl"), offset = Vector(-11, 15, 18) , ang = Angle(1, -47, -1) , seq = "d1_t01_BreakRoom_Sit01_Idle", t1 = true, hide = true, icon = Material( "sog/default.png", "smooth" ) },
		{ mdl = Model( "models/props_c17/furniturechair001a_chunk02.mdl"), offset = Vector(115, -70, 15) , ang = Angle(-1, -86, -42) , seq = "idle" },
		{ mdl = Model( "models/props_c17/furniturearmchair001a.mdl"), offset = Vector(86, -54, 12) , ang = Angle(-1, 132, -1) , seq = "idle" },
		{ mdl = Model( "models/player/hostage/hostage_04.mdl"), offset = Vector(44, -58, 38) , ang = Angle(0, -91, -1) , seq = "ragdoll", tag = "carl", icon = Material( "sog/oldman.png", "smooth" ), rag = { [3] = { b_offset = Vector(51, -66, 42), b_ang = Angle(-79, 59, -7) }, [6] = { b_offset = Vector(50, -62, 57), b_ang = Angle(-63, 134, 85) }, [9] = { b_offset = Vector(55, -58, 50), b_ang = Angle(55, 80, -154) }, [10] = { b_offset = Vector(56, -51, 40), b_ang = Angle(3, 136, -121) }, [11] = { b_offset = Vector(48, -44, 39), b_ang = Angle(-19, 132, 94) }, [14] = { b_offset = Vector(46, -70, 53), b_ang = Angle(63, -126, 12) }, [15] = { b_offset = Vector(43, -75, 42), b_ang = Angle(63, -155, -14) }, [16] = { b_offset = Vector(38, -77, 32), b_ang = Angle(55, -147, 79) }, [18] = { b_offset = Vector(47, -56, 38), b_ang = Angle(3, 122, -81) }, [19] = { b_offset = Vector(37, -40, 37), b_ang = Angle(79, -180, -32) }, [20] = { b_offset = Vector(35, -41, 21), b_ang = Angle(48, 131, -74) }, [22] = { b_offset = Vector(41, -61, 38), b_ang = Angle(4, 127, -80) }, [23] = { b_offset = Vector(30, -46, 37), b_ang = Angle(79, -125, 17) }, [24] = { b_offset = Vector(29, -49, 20), b_ang = Angle(51, 152, -68) }, } },
		{ mdl = Model( "models/props_junk/metal_paintcan001a.mdl"), offset = Vector(-86, 3, 16) , ang = Angle(0, 147, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/metal_paintcan001b.mdl"), offset = Vector(-80, 14, 15) , ang = Angle(89, -123, 95) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage_bag001a.mdl"), offset = Vector(-69, -3, 15) , ang = Angle(-1, -101, -2) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage128_composite001a.mdl"), offset = Vector(66, 52, 15) , ang = Angle(1, -131, 1) , seq = "idle" },
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(29, -24, 231) , ang = Angle(88, -176, -1) , seq = "Idle" },
		{ mdl = Model( "models/weapons/w_shotgun.mdl"), offset = Vector(-31, -3, 36) , ang = Angle(0, 117, 82) , seq = "idle1", tag = "shotgun", hide = true },
		{ mdl = Model( "models/props_junk/cardboard_box001a.mdl"), offset = Vector(-21, 10, 23) , ang = Angle(-3, -50, 2) , seq = "idle" },
		{ mdl = Model( "models/props_junk/cardboard_box002a.mdl"), offset = Vector(6, 36, 22) , ang = Angle(4, 40, -5) , seq = "idle" },
		{ mdl = Model( "models/props_c17/tv_monitor01.mdl"), offset = Vector(-10, 16, 44) , ang = Angle(-3, -49, 2) , seq = "idle", tag = "tv", icon = Material( "sog/tv.png", "smooth" ) },
		{ mdl = Model( "models/props_junk/cardboard_box003a.mdl"), offset = Vector(89, -24, 22) , ang = Angle(0, -162, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage_coffeemug001a.mdl"), offset = Vector(80, -27, 29) , ang = Angle(-1, 4, 1) , seq = "idle" },
		{ mdl = Model( "models/props_interiors/pot01a.mdl"), offset = Vector(90, -32, 31) , ang = Angle(0, -76, 1) , seq = "idle" },
		{ mdl = Model( "models/props_c17/furniturechair001a_chunk01.mdl"), offset = Vector(107, -47, 16) , ang = Angle(-90, -133, 29) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage_carboard002a.mdl"), offset = Vector(-51, -97, 6) , ang = Angle(0, 111, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/shoe001a.mdl"), offset = Vector(-6, -108, 9) , ang = Angle(0, 56, 78) , seq = "idle" },
		{ mdl = Model( "models/props_junk/shoe001a.mdl"), offset = Vector(-1, -117, 11) , ang = Angle(-1, -122, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(10, -110, 4) , ang = Angle(-1, -93, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-94, -95, 4) , ang = Angle(0, 177, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage_carboard001a.mdl"), offset = Vector(-64, -44, 10) , ang = Angle(0, -177, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-83, 5, 7) , ang = Angle(-1, 83, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(10, -9, 3) , ang = Angle(0, -83, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-96, 104, 3) , ang = Angle(0, -174, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(17, 84, 3) , ang = Angle(0, 97, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(75, 68, 9) , ang = Angle(-3, -10, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(127, 42, 3) , ang = Angle(3, -3, -1) , seq = "idle" },
		{ mdl = Model( "models/props_interiors/furniture_lamp01a.mdl"), offset = Vector(12, -84, 40) , ang = Angle(0, 134, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(122, -82, 4) , ang = Angle(0, -4, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(34, -32, 9) , ang = Angle(0, -102, 0) , seq = "idle" },
	},
	Dialogues = function( sc )
		AddDialogueLine( sc.tv, "*chkt*" )
		AddDialogueLine( sc.tv, "\"What's up, my little slaves?!\"\n. . .", "\"This is LetsTortureGMod and my brother,\nand today it's time for an amazing challenge!\"" )
		AddDialogueLine( sc.tv, "\"In this 1-hour long video I will hump this\nhorny ragdoll against my body!\"", ". . .", "\"How does that sounds, my little slaves?\"" )
		AddDialogueLine( sc.tv, "*chorus* \"YAY!!!\"", "\"That's right, my little slaves!\"", ". . .", "\"As always, remember to support me at sellout [dot] co. . .\"" )
		AddDialogueLine( sc.tv, "*chkt*" )
		AddDialogueLine( sc.carl, "Is this really what I've bought this game for?. . .", "*sigh*" )
		AddDialogueLine( sc.tv, "*chkt*" )
		AddDialogueLine( sc.tv, "\"Thank you for staying at our community!\nJust remember to obey and have fun!\"" )
		AddDialogueLine( sc.tv, "*chkt*" )
		AddDialogueLine( sc.carl, "I suppose not. . ." )
		AddDialogueLine( sc.tv, "*chkt*", "s;l^#(*&6f#$S6%^FGad%&$gusda" )
		AddDialogueLine( sc.t1, ". . ." )
		AddDialogueAction( sc.t1, function( me ) me.Hide = false sc.shotgun.Hide = false sc.tv.Hide = true surface.PlaySound( "ambient/energy/zap1.wav" ) end )
		AddDialogueLine( sc.carl, ". . ." )
		AddDialogueLine( sc.t1, "That's a fair point." )
		AddDialogueLine( sc.carl, "Who are you?" )
		AddDialogueLine( sc.t1, ". . ." )
		AddDialogueLine( sc.carl, "Whatever, just leave me alone!", ". . .", "Please." )
		AddDialogueLine( sc.t1, "You still have time." )
		AddDialogueLine( sc.carl, ". . .", "Time?" )
		AddDialogueLine( sc.t1, "To save yourself." )
		AddDialogueLine( sc.carl, ". . .", "Listen, I. . .","I can't just leave this place.\nIf owner finds out - he will kill me. . ." )
		AddDialogueLine( sc.t1, "You will die much faster, just by staying in here.", ". . .", "So you'd better think of which ending\nwill be less terrible." )
		AddDialogueLine( sc.t1, ". . .", "Take this shotgun." )
		AddDialogueLine( sc.carl, "What?. . .", "Why?!" )
		AddDialogueLine( sc.t1, "Because noone will give a shit about you in here,\nbut you." )
		AddDialogueLine( sc.tv, "*chkt*" )
		AddDialogueAction( sc.t1, function( me ) me.Hide = true sc.tv.Hide = false surface.PlaySound( "ambient/energy/zap6.wav" ) end )
		AddDialogueLine( sc.carl, ". . .", "This is not going to end well, is it?" )
	end
}

GM.Cutscenes["_sog_demo2"][2] = {
	Intro = "2013\nLair of \"CoderFired\" Corporation",
	SoundTrack = 82573997,
	Volume = 30,
	Main = { mdl = Model( "models/hunter/plates/plate6x6.mdl" ), seq = "idle"},
	Relative = {
		{ mdl = Model( "models/props_combine/combine_binocular01.mdl"), offset = Vector(-89, 8, 25) , ang = Angle(45, -46, -1) , seq = "idle" },
		{ mdl = Model( "models/player/phoenix.mdl"), offset = Vector(51, -49, 4) , ang = Angle(-1, -175, 0) , seq = "pose_standing_02", tag = "steve", icon = Material( "sog/detective.png", "smooth" ), PlayerColor = Color( 215, 77, 64 ) },
		{ mdl = Model( "models/props_junk/popcan01a.mdl"), offset = Vector(4, -51, 35) , ang = Angle(-26, 152, 18) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/moneypallete.mdl"), offset = Vector(-134, -105, 5) , ang = Angle(-0, 104, -1) , seq = "idle" },
		{ mdl = Model( "models/props_interiors/furniture_chair03a.mdl"), offset = Vector(-13, -59, 25) , ang = Angle(1, 39, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/metalbucket01a.mdl"), offset = Vector(18, 66, 14) , ang = Angle(-1, -5, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/shovel01a.mdl"), offset = Vector(-1, 70, 37) , ang = Angle(-16, -93, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/van_glass.mdl"), offset = Vector(-31, 123, 7) , ang = Angle(-0, 89, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/shelves_metal1.mdl"), offset = Vector(95, -136, 6) , ang = Angle(-1, 89, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/moneypallet.mdl"), offset = Vector(-142, -30, 6) , ang = Angle(0, 178, -1) , seq = "idle" },
		{ mdl = Model( "models/player/group01/male_09.mdl"), offset = Vector(-10, -55, 32) , ang = Angle(-0, 2, 0) , seq = "ragdoll",tag = "mark", icon = Material( "sog/mark.png", "smooth" ), PlayerColor = Color( 215, 77, 64 ), rag = { [3] = { b_offset = Vector(-17, -55, 41), b_ang = Angle(-80, 8, -117) }, [6] = { b_offset = Vector(-12, -55, 55), b_ang = Angle(-74, 36, 56) }, [9] = { b_offset = Vector(-17, -63, 51), b_ang = Angle(37, -113, 130) }, [10] = { b_offset = Vector(-20, -71, 42), b_ang = Angle(58, -30, -163) }, [11] = { b_offset = Vector(-15, -74, 33), b_ang = Angle(68, -23, 120) }, [14] = { b_offset = Vector(-12, -48, 49), b_ang = Angle(66, 58, -6) }, [15] = { b_offset = Vector(-10, -44, 38), b_ang = Angle(14, -20, -67) }, [16] = { b_offset = Vector(1, -48, 35), b_ang = Angle(14, -14, 9) }, [18] = { b_offset = Vector(-10, -59, 32), b_ang = Angle(10, -14, -93) }, [19] = { b_offset = Vector(7, -63, 29), b_ang = Angle(78, -179, 104) }, [20] = { b_offset = Vector(4, -63, 12), b_ang = Angle(49, -11, -89) }, [22] = { b_offset = Vector(-10, -51, 32), b_ang = Angle(22, 13, -88) }, [23] = { b_offset = Vector(6, -47, 25), b_ang = Angle(52, -171, 85) }, [24] = { b_offset = Vector(-4, -49, 12), b_ang = Angle(51, 5, -95) }, } },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-103, -77, 3) , ang = Angle(-0, 180, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/plant01.mdl"), offset = Vector(-81, -100, 5) , ang = Angle(-1, -78, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(93, -122, 3) , ang = Angle(-1, -91, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/cardboard_box003a.mdl"), offset = Vector(48, -136, 15) , ang = Angle(-1, 178, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/cardboard_box004a.mdl"), offset = Vector(40, -130, 24) , ang = Angle(-1, -96, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/table_coffee.mdl"), offset = Vector(-38, -134, 6) , ang = Angle(-1, -91, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/file_box_p2.mdl"), offset = Vector(-63, -134, 30) , ang = Angle(-1, -85, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-30, -121, 3) , ang = Angle(-0, -91, 0) , seq = "idle" },
		{ mdl = Model( "models/weapons/w_rif_ak47.mdl"), offset = Vector(-30, -131, 31) , ang = Angle(-1, -110, -89) , seq = "idle" },
		{ mdl = Model( "models/weapons/w_smg_ump45.mdl"), offset = Vector(-6, -135, 30) , ang = Angle(-1, -99, 89) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/trash_can.mdl"), offset = Vector(6, -143, 5) , ang = Angle(-1, -89, -1) , seq = "only_sequence" },
		{ mdl = Model( "models/props/cs_office/phone.mdl"), offset = Vector(-42, -126, 30) , ang = Angle(-0, 69, -1) , seq = "only_sequence" },
		{ mdl = Model( "models/props_combine/combine_intmonitor003.mdl"), offset = Vector(-92, -23, 39) , ang = Angle(-4, 3, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/moneypallet03d.mdl"), offset = Vector(-140, 37, 6) , ang = Angle(-1, -1, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/van.mdl"), offset = Vector(-31, 123, 6) , ang = Angle(-1, 89, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-88, 120, 3) , ang = Angle(-0, -91, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(113, 107, 3) , ang = Angle(-1, -2, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage128_composite001b.mdl"), offset = Vector(88, 79, 10) , ang = Angle(-1, -129, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(21, 81, 3) , ang = Angle(0, 180, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(104, -16, 3) , ang = Angle(-1, -1, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(2, -29, 3) , ang = Angle(-1, -91, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage_carboard001a.mdl"), offset = Vector(18, 16, 6) , ang = Angle(-1, 55, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage_carboard002a.mdl"), offset = Vector(-11, -24, 5) , ang = Angle(-0, -74, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage_carboard002a.mdl"), offset = Vector(27, -81, 5) , ang = Angle(-1, 14, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-83, 28, 3) , ang = Angle(-1, 90, -1) , seq = "idle" },
		{ mdl = Model( "models/props_combine/combine_binocular01.mdl"), offset = Vector(-66, -20, 26) , ang = Angle(45, 178, -1) , seq = "idle" },
		{ mdl = Model( "models/props_combine/combine_binocular01.mdl"), offset = Vector(-79, -53, 26) , ang = Angle(45, 44, -1) , seq = "idle" },
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(20, -45, 217) , ang = Angle(89, -145, 0) , seq = "Idle" },
	},
	Dialogues = function( sc )
		AddDialogueLine( sc.mark, "Good morning, Steve." )
		AddDialogueLine( sc.steve, "Hey. . ." )
		AddDialogueLine( sc.mark, "How was your money bath?", ". . .", "I see you are a completely different person now." )
		AddDialogueLine( sc.steve, "I feel awesome, for some reason.", ". . .", ". . .and evil." )
		AddDialogueLine( sc.mark, "Exactly.", "That is our normal condition, Steve,\nso feel free to get used to it." )
		AddDialogueLine( sc.steve, ". . .and now I want more." )
		AddDialogueLine( sc.mark, "Noooow we're talking!", ". . .", "Don't worry, you will get more. . ." )
		AddDialogueLine( sc.mark, ". . .after you help us out with something." )
		AddDialogueLine( sc.steve, "And that 'something' is?. . ." )
		AddDialogueLine( sc.mark, "Let's say you will have to visit few servers.", ". . .", "They used to buy our stuff for quite a while." )
		AddDialogueLine( sc.mark, "But. . .", "We have not received any requests for past week.", "Hell, maybe even for two weeks. . ." )
		AddDialogueLine( sc.steve, ". . .", "Do you think they are using leaked stuff?" )
		AddDialogueLine( sc.mark, "Can't say for sure.\nIt is quite a possibility, though.", "That, or they've started using. . .ugh. . .workshop. . ." )
		AddDialogueLine( sc.steve, "Shit. . ." )
		AddDialogueLine( sc.mark, "Exactly, Steve.", ". . .", "All you need to do is to 'talk' to them.", "And if it goes 'wrong'. . .", ". . .make sure to 'clean' all the 'evidence'." )
		AddDialogueLine( sc.steve, ". . .", "Sounds good to me." )
		AddDialogueLine( sc.mark, "Of course, it is.", ". . .", "Making deals that always give us profit is my job." )
		AddDialogueLine( sc.steve, "I see. . ." )
		AddDialogueLine( sc.mark, "Oh and. . .", "Take a gun or something.", "Visiting servers empty-handed can be a little bit unfair.", "If you know what I mean ;)" )
		AddDialogueLine( sc.steve, "Got it." )
	end
}

GM.Cutscenes["_sog_demo2"][10] = {
	Intro = "2013\nOutside",
	SoundTrack = 130661772,//92555634
	Volume = 30,
	Main = { mdl = Model( "models/hunter/plates/plate5x7.mdl" ), seq = "idle"},
	Relative = {
		{ mdl = Model( "models/props_junk/garbage_takeoutcarton001a.mdl"), offset = Vector(40, -95, 35) , ang = Angle(-2, 86, -1) , seq = "idle" },
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(-4, -47, 296) , ang = Angle(89, -26, -1) , seq = "Idle" },
		{ mdl = Model( "models/props/de_nuke/car_nuke_glass.mdl"), offset = Vector(-40, 117, 6) , ang = Angle(0, 89, 0) , seq = "idle" },
		{ mdl = Model( "models/props/de_nuke/car_nuke_black.mdl"), offset = Vector(-40, 117, 6) , ang = Angle(-1, 89, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/watermelon01.mdl"), offset = Vector(47, -108, 69) , ang = Angle(-11, 162, -8) , seq = "idle" },
		{ mdl = Model( "models/props/cs_italy/it_mkt_container2.mdl"), offset = Vector(47, -110, 56) , ang = Angle(0, -180, -1) , seq = "idle" },
		{ mdl = Model( "models/props_c17/cashregister01a.mdl"), offset = Vector(-22, -114, 68) , ang = Angle(0, 179, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage_milkcarton002a.mdl"), offset = Vector(20, -99, 32) , ang = Angle(-1, -10, 90) , seq = "idle" },
		{ mdl = Model( "models/props_junk/popcan01a.mdl"), offset = Vector(7, -97, 32) , ang = Angle(-2, 92, 4) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/caseofbeer01.mdl"), offset = Vector(0, -111, 56) , ang = Angle(0, -91, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage_glassbottle001a.mdl"), offset = Vector(-16, -99, 32) , ang = Angle(-66, 5, 89) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage_plasticbottle003a.mdl"), offset = Vector(-7, -101, 32) , ang = Angle(-89, -170, -96) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(15, -17, 3) , ang = Angle(0, 179, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage256_composite002a.mdl"), offset = Vector(6, -15, 8) , ang = Angle(0, 110, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-76, 15, 3) , ang = Angle(-1, 179, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-89, 120, 3) , ang = Angle(0, 89, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(16, 102, 3) , ang = Angle(-1, 0, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(125, 120, 3) , ang = Angle(-1, 89, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(107, 10, 3) , ang = Angle(-1, -1, -1) , seq = "idle" },
		{ mdl = Model( "models/props_trainstation/bench_indoor001a.mdl"), offset = Vector(136, -9, 24) , ang = Angle(0, -180, -1) , seq = "idle" },
		{ mdl = Model( "models/humans/group02/male_06.mdl"), offset = Vector(136, -7, 24) , ang = Angle(0, 89, 0) , seq = "d1_town05_Wounded_Idle_1" },
		{ mdl = Model( "models/player/group03/male_09.mdl"), offset = Vector(2, -63, 5) , ang = Angle(-1, -91, -1) , seq = "pose_standing_02", t2 = true, icon = Material( "sog/male_09.png", "smooth" ) },
		{ mdl = Model( "models/props/cs_italy/it_mkt_container3a.mdl"), offset = Vector(104, -145, 25) , ang = Angle(26, 133, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/caseofbeer01.mdl"), offset = Vector(131, -118, 45) , ang = Angle(26, 136, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_italy/it_mkt_container3.mdl"), offset = Vector(133, -119, 27) , ang = Angle(26, 135, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_italy/it_mkt_container1a.mdl"), offset = Vector(122, -136, 28) , ang = Angle(26, 136, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(107, -109, 3) , ang = Angle(-1, 179, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_italy/it_mkt_shelf1.mdl"), offset = Vector(114, -134, 6) , ang = Angle(-1, 134, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(15, -140, 3) , ang = Angle(0, 179, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/caseofbeer01.mdl"), offset = Vector(108, -139, 44) , ang = Angle(26, 125, -4) , seq = "idle" },
		{ mdl = Model( "models/props_c17/display_cooler01a.mdl"), offset = Vector(3, -101, 6) , ang = Angle(-1, 0, 0) , seq = "idle" },
		{ mdl = Model( "models/props_c17/chair02a.mdl"), offset = Vector(26, -176, 20) , ang = Angle(-1, 128, 0) , seq = "idle" },
		{ mdl = Model( "models/player/hostage/hostage_04.mdl"), offset = Vector(2, -139, 5) , ang = Angle(0, 88, 0) , seq = "idle_suitcase", t1 = true, icon = Material( "sog/oldman.png", "smooth" ) },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-77, -108, 3) , ang = Angle(-1, 179, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage_milkcarton001a.mdl"), offset = Vector(-54, -104, 13) , ang = Angle(-1, 132, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/caseofbeer01.mdl"), offset = Vector(121, -132, 46) , ang = Angle(26, 129, -3) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage_milkcarton002a.mdl"), offset = Vector(29, -100, 32) , ang = Angle(-2, -1, 90) , seq = "idle" },
	},
	Dialogues = function( sc )
		AddDialogueLine( sc.t1, "Alright.", "That will be $9.99.",". . .", "Anything else?" )
		AddDialogueLine( sc.t2, "No. . ." )
		AddDialogueLine( sc.t1, "Whole server was buzzing like crazy yesterday. . .", "All this sudden violence.", "Wonder what's up with that. . ." )
		AddDialogueLine( sc.t2, ". . ." )
		AddDialogueLine( sc.t1, "Uh. . .", "Hopefully I'll find a better thing to do soon. . ."  )
		AddDialogueLine( sc.t1, "This job is driving me crazy. . ." )
		AddDialogueLine( sc.t2, ". . .", "Why don't you just abandon it?" )
		AddDialogueLine( sc.t1, "I wish I could. . .", "But it is hard to find something better,\nonce community enslaves you. . ." )
		AddDialogueLine( sc.t2, ". . ." )
		AddDialogueLine( sc.t1, "zhghG8&AD^D%()1KDkjak!#K!)A(D*hJDH. . ." )
		AddDialogueLine( sc.t2, "What?!" )
		AddDialogueLine( sc.t1, "Hm?", "I just said that I still hope for the best. . ." )
		AddDialogueLine( sc.t2, ". . ." )
		AddDialogueLine( sc.t1, "You don't look very well tho. . .", "Are you alright?" )
		AddDialogueLine( sc.t2, "Yeah. . .", "I'll probably should get some sleep. . ." )
		AddDialogueLine( sc.t1, "Alright then! See you next time." )
	end,
}

GM.Cutscenes["_sog_demo2"][25] = {
	Intro = "2013\nSome cheap motel",
	SoundTrack = 137468020,
	Volume = 23,
	Main = { mdl = Model( "models/hunter/plates/plate7x8.mdl" ), seq = "idle"},
	Relative = {
		{ mdl = Model( "models/props_c17/metalpot001a.mdl"), offset = Vector(-68, 109, 53) , ang = Angle(0, 102, 0) , seq = "idle" },
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(0, 7, 236) , ang = Angle(88, -52, -1) , seq = "Idle" },
		{ mdl = Model( "models/props_c17/paper01.mdl"), offset = Vector(-48, -7, 47) , ang = Angle(0, -14, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage_plasticbottle002a.mdl"), offset = Vector(-111, -53, 18) , ang = Angle(19, -89, 2) , seq = "idle" },
		{ mdl = Model( "models/props_c17/furniturewashingmachine001a.mdl"), offset = Vector(-108, -71, 30) , ang = Angle(-1, -1, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-118, -163, 3) , ang = Angle(-1, 90, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage256_composite002b.mdl"), offset = Vector(-118, -80, 9) , ang = Angle(0, -178, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(5, -164, 3) , ang = Angle(-1, 90, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/wheebarrow01a.mdl"), offset = Vector(-92, -122, 43) , ang = Angle(57, 178, 179) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage_carboard002a.mdl"), offset = Vector(-58, -50, 5) , ang = Angle(0, -56, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-109, -71, 3) , ang = Angle(-1, -90, 0) , seq = "idle" },
		{ mdl = Model( "models/props_c17/furnituredresser001a.mdl"), offset = Vector(-32, -118, 46) , ang = Angle(-1, 89, 0) , seq = "idle" },
		{ mdl = Model( "models/props_c17/furniturearmchair001a.mdl"), offset = Vector(26, -83, 6) , ang = Angle(-1, 88, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/axe.mdl"), offset = Vector(-3, -59, 35) , ang = Angle(-11, -169, -155) , seq = "idle", t3 = true, icon = Material( "sog/axe.png", "smooth" ) },
		{ mdl = Model( "models/props_junk/garbage_metalcan002a.mdl"), offset = Vector(7, -5, 31) , ang = Angle(0, 120, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage_glassbottle003a.mdl"), offset = Vector(6, 18, 35) , ang = Angle(-1, -135, 1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage_glassbottle003a.mdl"), offset = Vector(2, 17, 29) , ang = Angle(-21, 31, 89) , seq = "idle" },
		{ mdl = Model( "models/props_c17/furnituretable003a.mdl"), offset = Vector(-1, 2, 16) , ang = Angle(-1, -2, -1) , seq = "idle" },
		{ mdl = Model( "models/props_c17/furnituredrawer001a.mdl"), offset = Vector(-50, -1, 26) , ang = Angle(0, 1, -1) , seq = "idle" },
		{ mdl = Model( "models/props_c17/tv_monitor01.mdl"), offset = Vector(-47, 11, 54) , ang = Angle(0, 10, 0) , seq = "idle", t2 = true, icon = Material( "sog/tv.png", "smooth" ) },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-123, 112, 3) , ang = Angle(-1, -91, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/cardboard_box03.mdl"), offset = Vector(-51, 32, 6) , ang = Angle(0, 90, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage_glassbottle001a.mdl"), offset = Vector(15, 38, 8) , ang = Angle(-26, 38, -91) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/caseofbeer01.mdl"), offset = Vector(-1, 36, 5) , ang = Angle(0, 82, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(7, 20, 3) , ang = Angle(0, 89, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage_takeoutcarton001a.mdl"), offset = Vector(-50, 58, 9) , ang = Angle(-82, 127, 5) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage_bag001a.mdl"), offset = Vector(-58, 68, 13) , ang = Angle(18, 155, -3) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-116, 21, 3) , ang = Angle(0, 89, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/boxes_garage_lower.mdl"), offset = Vector(-118, 124, 6) , ang = Angle(-1, 45, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/cardboard_box001a.mdl"), offset = Vector(134, -60, 42) , ang = Angle(-1, -34, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(14, -71, 3) , ang = Angle(0, -90, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/newspaperstack01.mdl"), offset = Vector(43, -47, 5) , ang = Angle(-1, 42, -1) , seq = "idle" },
		{ mdl = Model( "models/props_interiors/furniture_lamp01a.mdl"), offset = Vector(51, -71, 39) , ang = Angle(0, 45, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/wood_pallet001a.mdl"), offset = Vector(41, -130, 10) , ang = Angle(-1, -18, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/wood_pallet001a.mdl"), offset = Vector(88, -126, 17) , ang = Angle(11, 16, 1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(129, -164, 4) , ang = Angle(-1, 90, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/cardboard_box001a.mdl"), offset = Vector(136, -85, 18) , ang = Angle(-1, -44, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/shelves_wood.mdl"), offset = Vector(45, 175, 1) , ang = Angle(-1, -91, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(123, 112, 4) , ang = Angle(-1, -91, 0) , seq = "idle" },
		{ mdl = Model( "models/props_debris/metal_panel02a.mdl"), offset = Vector(142, 172, 9) , ang = Angle(-84, 66, -67) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(130, 20, 4) , ang = Angle(0, 89, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(137, -72, 4) , ang = Angle(-1, -90, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/cardboard_box002a.mdl"), offset = Vector(135, -35, 18) , ang = Angle(-1, -16, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage128_composite001b.mdl"), offset = Vector(130, 75, 10) , ang = Angle(0, 172, -1) , seq = "idle" },
		{ mdl = Model( "models/props_c17/furniturecouch001a.mdl"), offset = Vector(61, 6, 22) , ang = Angle(0, 176, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage_milkcarton002a.mdl"), offset = Vector(69, 54, 15) , ang = Angle(-1, 64, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage_milkcarton001a.mdl"), offset = Vector(56, 57, 15) , ang = Angle(-1, 44, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/plasticcrate01a.mdl"), offset = Vector(62, 54, 13) , ang = Angle(0, 89, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(0, 112, 3) , ang = Angle(-1, -91, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/paintbucket01.mdl"), offset = Vector(75, 136, 6) , ang = Angle(0, -28, -1) , seq = "idle" },
		{ mdl = Model( "models/props_c17/frame002a.mdl"), offset = Vector(86, 153, 21) , ang = Angle(41, 89, -52) , seq = "idle" },
		{ mdl = Model( "models/props_c17/suitcase001a.mdl"), offset = Vector(46, 138, 16) , ang = Angle(0, 1, -1) , seq = "idle" },
		{ mdl = Model( "models/props_c17/suitcase_passenger_physics.mdl"), offset = Vector(48, 156, 31) , ang = Angle(-1, -173, -90) , seq = "idle" },
		{ mdl = Model( "models/props_lab/harddrive01.mdl"), offset = Vector(2, 170, 32) , ang = Angle(0, 78, -91) , seq = "idle" },
		{ mdl = Model( "models/props_junk/metalbucket02a.mdl"), offset = Vector(-34, 139, 13) , ang = Angle(-1, 102, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage_plasticbottle002a.mdl"), offset = Vector(-45, 141, 16) , ang = Angle(-60, -5, -15) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/sheetrock_leaning.mdl"), offset = Vector(-97, 159, -3) , ang = Angle(-89, -96, 4) , seq = "idle" },
		{ mdl = Model( "models/props_c17/furniturestove001a.mdl"), offset = Vector(-72, 121, 26) , ang = Angle(0, -1, 0) , seq = "idle" },
		{ mdl = Model( "models/props_c17/metalpot002a.mdl"), offset = Vector(-65, 133, 48) , ang = Angle(0, -166, -1) , seq = "idle" },
		{ mdl = Model( "models/humans/group03/male_09.mdl"), offset = Vector(53, -11, 25) , ang = Angle(1, 167, 0) , seq = "Canals_Matt_laydown", t1 = true, icon = Material( "sog/male_09.png", "smooth" ) },
	},
	Dialogues = function( sc )
		AddDialogueLine( sc.t2, "*chkt*", ". . .about 20 dismembered bodies were found\nearlier today. . ." )
		AddDialogueLine( sc.t2, "*chkt*", ". . .the server owners responded with massive\nDDOS attacks against nearby DarkRP servers. . ." )
		AddDialogueLine( sc.t2, "*chkt*", ". . .the identity of the attacker is still unknown. . ." )
		AddDialogueLine( sc.t2, "*chkt*", ". . .g&^%7hgdfsj 73GHJG 183*(&6HG%R. . ." )
		AddDialogueLine( sc.t2, "*chkt*", ". . .jhdas%&^D*kj*&^ h/4sd9^&@$ JH&SA&*dyhg&%673. . ." )
		AddDialogueLine( sc.t2, "*chkt* *chkt* *chkt* *chkt*" )
		AddDialogueLine( sc.t1, "God damnit!" )
		AddDialogueLine( sc.t3, "Looks like you've had some fun, huh?" )
		AddDialogueLine( sc.t1, "The fuck. . .", "What are you?" )
		AddDialogueLine( sc.t3, "Does it matter?\n. . .", "That is something that you should ask yourself about." )
		AddDialogueLine( sc.t1, ". . ." )
		AddDialogueLine( sc.t1, "They have deserved it.\n. . .", "We can't have nice things anymore\nbecause of these retards." )
		AddDialogueLine( sc.t3, "heh. . .", "You are really fucked up, aren't you?\n. . ." )
		AddDialogueLine( sc.t1, "I doubt that. . ." )
		AddDialogueLine( sc.t3, "It's just a matter of time then. . ." )
		AddDialogueLine( sc.t2, "*chkt*" )
	end,
}

//drama
GM.Cutscenes["_sog_demo3"][0] = {
	Intro = "2013\nSome shitty roleplay server",
	SoundTrack = 127531536,
	Volume = 24,
	Main = { mdl = Model( "models/hunter/plates/plate8x8.mdl" ), seq = "idle"},
	Relative = {
		{ mdl = Model( "models/props/cs_office/coffee_mug3.mdl"), offset = Vector(60, 2, 36) , ang = Angle(-2, -40, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/coffee_mug3.mdl"), offset = Vector(-59, -27, 36) , ang = Angle(0, -33, -2) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/coffee_mug3.mdl"), offset = Vector(-18, 31, 36) , ang = Angle(0, 162, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/coffee_mug3.mdl"), offset = Vector(-14, 73, 36) , ang = Angle(0, -164, 0) , seq = "idle" },
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(23, -33, 329) , ang = Angle(89, 170, 0) , seq = "Idle" },
		{ mdl = Model( "models/props/cs_office/table_meeting.mdl"), offset = Vector(11, 1, 6) , ang = Angle(-1, 68, -1) , seq = "idle" },
		{ mdl = Model( "models/player/breen.mdl"), offset = Vector(58, -104, 23) , ang = Angle(-2, 157, 2) , seq = "sit", t3 = true },
		{ mdl = Model( "models/props/cs_office/chair_office.mdl"), offset = Vector(59, -104, 6) , ang = Angle(0, 155, 0) , seq = "idle" },
		{ mdl = Model( "models/player/breen.mdl"), offset = Vector(74, -56, 22) , ang = Angle(0, 151, -1) , seq = "sit", t4 = true },
		{ mdl = Model( "models/props/cs_office/chair_office.mdl"), offset = Vector(74, -56, 5) , ang = Angle(0, 152, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/chair_office.mdl"), offset = Vector(92, -7, 6) , ang = Angle(0, 168, -1) , seq = "idle" },
		{ mdl = Model( "models/player/breen.mdl"), offset = Vector(91, -6, 23) , ang = Angle(-6, 167, -1) , seq = "sit", t4 = true },
		{ mdl = Model( "models/props/cs_office/chair_office.mdl"), offset = Vector(-80, -14, 6) , ang = Angle(-1, -29, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(12, -51, 36) , ang = Angle(-1, 179, -1) , seq = "idle" },
		{ mdl = Model( "models/player/breen.mdl"), offset = Vector(-81, -14, 25) , ang = Angle(2, -29, 1) , seq = "sit", t5 = true },
		{ mdl = Model( "models/props/cs_office/chair_office.mdl"), offset = Vector(-37, 89, 6) , ang = Angle(0, -30, -1) , seq = "idle" },
		{ mdl = Model( "models/player/breen.mdl"), offset = Vector(-34, 91, 25) , ang = Angle(-1, -32, 5) , seq = "sit" },
		{ mdl = Model( "models/props_combine/breenchair.mdl"), offset = Vector(-51, -152, 7) , ang = Angle(-1, 68, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/file_cabinet3.mdl"), offset = Vector(-144, 45, 6) , ang = Angle(-1, -36, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-32, -21, 3) , ang = Angle(-1, 179, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-124, -20, 3) , ang = Angle(-1, 179, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/shelves_metal3.mdl"), offset = Vector(-174, -58, 6) , ang = Angle(-1, -35, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-215, -19, 3) , ang = Angle(1, 179, -1) , seq = "idle" },
		{ mdl = Model( "models/props/de_train/pallet_barrels.mdl"), offset = Vector(-190, -176, 6) , ang = Angle(0, -135, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/cardboard_box02.mdl"), offset = Vector(-80, -184, 6) , ang = Angle(-1, -62, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/plant01.mdl"), offset = Vector(-134, -196, 5) , ang = Angle(0, 39, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-122, -223, 4) , ang = Angle(-1, -90, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/dryer_box.mdl"), offset = Vector(-57, -234, 6) , ang = Angle(0, -178, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/cardboard_box03.mdl"), offset = Vector(-55, -205, 6) , ang = Angle(-1, -93, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/cardboard_box01.mdl"), offset = Vector(-56, -186, 6) , ang = Angle(-1, -92, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-207, -130, 3) , ang = Angle(-1, -91, 0) , seq = "idle" },
		{ mdl = Model( "models/player/police.mdl"), offset = Vector(-111, -130, 6) , ang = Angle(0, 44, -1) , seq = "menu_combine" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(59, -21, 3) , ang = Angle(-1, 179, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(41, 84, 3) , ang = Angle(0, -91, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(151, 5, 4) , ang = Angle(-1, -1, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/file_box.mdl"), offset = Vector(175, 47, 6) , ang = Angle(-1, -50, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(151, 129, 4) , ang = Angle(-1, -1, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(46, 175, 3) , ang = Angle(-1, 89, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/moneypalletd.mdl"), offset = Vector(133, -136, 6) , ang = Angle(-1, 67, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(128, -223, 4) , ang = Angle(-1, -90, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/moneypallet03b.mdl"), offset = Vector(94, -199, 6) , ang = Angle(0, 63, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(4, -223, 4) , ang = Angle(-1, -91, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/trash_can_p.mdl"), offset = Vector(10, -174, 6) , ang = Angle(-1, -134, 0) , seq = "only_sequence" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(41, -131, 3) , ang = Angle(-1, -91, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-83, -131, 3) , ang = Angle(-1, -90, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(150, -118, 4) , ang = Angle(-1, 0, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/moneypallet.mdl"), offset = Vector(-160, 159, 6) , ang = Angle(0, -28, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-187, 222, 4) , ang = Angle(0, -1, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/dryer_box2.mdl"), offset = Vector(-140, 221, 6) , ang = Angle(-1, 57, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-82, 208, 4) , ang = Angle(-1, -91, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/moneypallet_washerdryer.mdl"), offset = Vector(-74, 175, 6) , ang = Angle(0, -130, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-64, 103, 3) , ang = Angle(-1, 179, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/file_cabinet2.mdl"), offset = Vector(-109, 97, 6) , ang = Angle(0, -37, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/file_cabinet2.mdl"), offset = Vector(-101, 111, 6) , ang = Angle(0, -36, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/file_cabinet2.mdl"), offset = Vector(-118, 82, 6) , ang = Angle(-1, -34, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage_carboard002a.mdl"), offset = Vector(46, 112, 36) , ang = Angle(0, 44, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage_carboard001a.mdl"), offset = Vector(72, 83, 37) , ang = Angle(0, 17, -1) , seq = "idle" },
		{ mdl = Model( "models/player/corpse1.mdl"), offset = Vector(68, 89, 37) , ang = Angle(-1, -67, 0) , seq = "zombie_slump_idle_01" },
		{ mdl = Model( "models/props/cs_office/coffee_mug3.mdl"), offset = Vector(90, 75, 36) , ang = Angle(0, 4, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/file_box_p2.mdl"), offset = Vector(153, 48, 6) , ang = Angle(-1, -62, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/file_box_p1.mdl"), offset = Vector(168, 23, 6) , ang = Angle(-1, -75, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/cardboard_box003a.mdl"), offset = Vector(-39, -125, 46) , ang = Angle(0, 69, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/phone.mdl"), offset = Vector(-12, -119, 36) , ang = Angle(0, -128, -2) , seq = "only_sequence" },
		{ mdl = Model( "models/props/cs_office/coffee_mug3.mdl"), offset = Vector(-17, -132, 36) , ang = Angle(-1, -133, -2) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/coffee_mug3.mdl"), offset = Vector(20, -91, 36) , ang = Angle(-2, -20, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/radio.mdl"), offset = Vector(-5, -74, 36) , ang = Angle(-1, -78, 0) , seq = "only_sequence" },
		{ mdl = Model( "models/player/breen.mdl"), offset = Vector(-51, -151, 23) , ang = Angle(-2, 65, 1) , seq = "sit", t1 = true, icon = Material( "sog/breen.png", "smooth" ) },
		{ mdl = Model( "models/props/cs_office/file_box_p1.mdl"), offset = Vector(24, 33, 36) , ang = Angle(-1, -13, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/projector.mdl"), offset = Vector(8, -2, 36) , ang = Angle(0, -110, 0) , seq = "only_sequence" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(11, -46, 37) , ang = Angle(-9, -73, -4) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(5, -52, 37) , ang = Angle(-7, 54, -9) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-156, 103, 3) , ang = Angle(0, 179, 0) , seq = "idle" },
		{ mdl = Model( "models/player/combine_super_soldier.mdl"), offset = Vector(-55, 52, 21) , ang = Angle(0, -29, -1) , seq = "sit", t2 = true, icon = Material( "sog/elite.png", "smooth" ) },
		{ mdl = Model( "models/props/cs_office/chair_office.mdl"), offset = Vector(-57, 54, 6) , ang = Angle(-1, -26, 0) , seq = "idle" },
	},
	Dialogues = function( sc )
		AddDialogueLine( sc.t1, "Greetings, my fellow bitches.\n. . .", "As you have noticed - we are running low on money.\nAgain. . ." )
		AddDialogueLine( sc.t1, "Since our current income is clearly not enough\nfor me to get a fifth display. . .", ". . .we will need a way to get more donations.\nAnd preferably fast." )
		AddDialogueLine( sc.t1, "Any suggestions?\n. . ." )
		AddDialogueLine( sc.t3, ". . ." )
		AddDialogueLine( sc.t4, ". . ." )
		AddDialogueLine( sc.t5, ". . ." )
		AddDialogueLine( sc.t1, "Looks like we are going to do it the usual way." )
		AddDialogueLine( sc.t2, "The 'usual' way?\n. . ." )
		AddDialogueLine( sc.t2, "You mean ripping off all these kids\nover and over again?" )
		AddDialogueLine( sc.t1, "Yes!\nAnd since you have doubts about it - you are fired." )
		AddDialogueLine( sc.t1, "You clearly can't handle the serious roleplay\nbusiness at all!" )
		AddDialogueLine( sc.t1, "And now onto the second problem.\n. . ." )
		AddDialogueLine( sc.t1, "Other roleplay server has been more popular than ours\nfor past few days.", ". . ." )
		AddDialogueLine( sc.t1, "This is more than just unacceptable!\n. . ." )
		AddDialogueLine( sc.t1, "So here is what are we going to do. . .", "Yesterday I've got this package for 50$ from some site.\n. . ." )
		AddDialogueLine( sc.t1, "I don't actually know what is inside, but I assume that\nit will help us against these prideful assholes." )
		AddDialogueLine( sc.t1, "Now all we gonna do is to raid and\nsabotage their server.", ". . ." )
		AddDialogueLine( sc.t1, "Bam!", "No more server, which means more profit for us.\n. . .", "Any more questions?" )
		AddDialogueLine( sc.t3, ". . ." )
		AddDialogueLine( sc.t2, ". . ." )
		AddDialogueLine( sc.t4, ". . ." )
		AddDialogueLine( sc.t1, "Good." )
	end
}

GM.Cutscenes["_sog_demo3"][10] = {
	Intro = "2013\nSome shitty roleplay server. . . Again",
	SoundTrack	= 72159914,
	Volume = 23,
	Main = { mdl = Model( "models/hunter/plates/plate6x6.mdl" ), seq = "idle"},
	Relative = {
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-31, -164, 4) , ang = Angle(-1, -90, 0) , seq = "idle" },
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(10, -19, 332) , ang = Angle(89, -128, 0) , seq = "Idle" },
		{ mdl = Model( "models/maxofs2d/gm_painting.mdl"), offset = Vector(-61, 67, 71) , ang = Angle(-1, -1, 6) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-136, -34, 3) , ang = Angle(-1, -180, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-136, -157, 3) , ang = Angle(0, -180, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/moneypallet02a.mdl"), offset = Vector(-117, -104, 6) , ang = Angle(0, -90, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/moneypallet.mdl"), offset = Vector(-117, -40, 6) , ang = Angle(0, -180, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/forklift.mdl"), offset = Vector(-155, -163, 5) , ang = Angle(-1, 64, -1) , seq = "idle" },
		{ mdl = Model( "models/props_combine/breenbust.mdl"), offset = Vector(-14, -158, 92) , ang = Angle(0, 34, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_havana/bookcase_small.mdl"), offset = Vector(-68, -167, 14) , ang = Angle(-1, -26, -1) , seq = "idle" },
		{ mdl = Model( "models/props_lab/reciever_cart.mdl"), offset = Vector(-13, -172, 41) , ang = Angle(-1, 2, -1) , seq = "idle" },
		{ mdl = Model( "models/props_lab/crematorcase.mdl"), offset = Vector(-63, -137, 6) , ang = Angle(-1, -29, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-31, -73, 3) , ang = Angle(0, -90, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/file_box_p1.mdl"), offset = Vector(-2, -84, 6) , ang = Angle(0, -1, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/sofa_chair.mdl"), offset = Vector(38, -157, 6) , ang = Angle(0, 84, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/file_box.mdl"), offset = Vector(19, 103, 6) , ang = Angle(0, -69, -1) , seq = "idle" },
		{ mdl = Model( "models/props_lab/clipboard.mdl"), offset = Vector(-13, -30, 37) , ang = Angle(0, -175, 1) , seq = "idle" },
		{ mdl = Model( "models/props_combine/breendesk.mdl"), offset = Vector(-6, -29, 5) , ang = Angle(-1, 0, 0) , seq = "idle" },
		{ mdl = Model( "models/props_combine/breenclock.mdl"), offset = Vector(9, 4, 41) , ang = Angle(1, -2, -1) , seq = "idle" },
		{ mdl = Model( "models/player/police.mdl"), offset = Vector(-39, 40, 4) , ang = Angle(0, -27, -1) , seq = "pose_standing_01", t4 = true, icon = Material( "sog/police.png", "smooth" ) },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-31, 19, 3) , ang = Angle(-1, -90, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(92, 15, 4) , ang = Angle(0, -91, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/plant01.mdl"), offset = Vector(102, 111, 5) , ang = Angle(-1, -45, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/handtruck.mdl"), offset = Vector(-125, 104, 4) , ang = Angle(0, 35, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/moneypalletd.mdl"), offset = Vector(-117, 24, 6) , ang = Angle(0, -1, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-136, 89, 3) , ang = Angle(-1, 179, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-27, 110, 3) , ang = Angle(0, 89, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/sofa_chair.mdl"), offset = Vector(63, 107, 6) , ang = Angle(-1, -92, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(96, 106, 4) , ang = Angle(0, 90, -1) , seq = "idle" },
		{ mdl = Model( "models/props_lab/cornerunit2.mdl"), offset = Vector(-60, 115, 6) , ang = Angle(0, 0, -1) , seq = "idle" },
		{ mdl = Model( "models/props_combine/breenchair.mdl"), offset = Vector(-47, -28, 6) , ang = Angle(-1, 2, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/phone.mdl"), offset = Vector(-14, -52, 37) , ang = Angle(-1, 159, 0) , seq = "only_sequence" },
		{ mdl = Model( "models/gibs/hgibs.mdl"), offset = Vector(5, -63, 40) , ang = Angle(1, -7, -1) , seq = "idle1" },
		{ mdl = Model( "models/player/police.mdl"), offset = Vector(-57, -101, 5) , ang = Angle(-1, 18, -1) , seq = "menu_combine", t3 = true, icon = Material( "sog/police.png", "smooth" ) },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(-22, 2, 44) , ang = Angle(-4, -90, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(-22, -1, 46) , ang = Angle(-5, -86, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(-21, -1, 41) , ang = Angle(66, 90, -180) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(-21, -5, 41) , ang = Angle(66, -91, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(-21, 8, 40) , ang = Angle(-62, -89, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(-21, 4, 40) , ang = Angle(-55, 91, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/coffee_mug3.mdl"), offset = Vector(-12, -5, 37) , ang = Angle(-3, 5, 1) , seq = "idle" },
		{ mdl = Model( "models/player/combine_super_soldier.mdl"), offset = Vector(75, -30, 6) , ang = Angle(0, -180, -1) , seq = "idle_all_cower", t1 = true, icon = Material( "sog/elite.png", "smooth" ) },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(92, -77, 4) , ang = Angle(0, -90, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(93, -168, 4) , ang = Angle(0, -90, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/plant01.mdl"), offset = Vector(105, -161, 5) , ang = Angle(0, -90, 0) , seq = "idle" },
		{ mdl = Model( "models/player/breen.mdl"), offset = Vector(-47, -29, 25) , ang = Angle(4, 4, -2) , seq = "sit", t2 = true, icon = Material( "sog/breen.png", "smooth" ) },
	},
	Dialogues = function( sc )
		AddDialogueLine( sc.t1, "Ummmm. . . boss. . ." )
		AddDialogueLine( sc.t2, ". . ." )
		AddDialogueLine( sc.t1, "They. . .", "That other community. . ." )
		AddDialogueLine( sc.t2, ". . ." )
		AddDialogueLine( sc.t1, "They knew we were coming. . ." )
		AddDialogueLine( sc.t1, ". . ." )
		AddDialogueLine( sc.t1, "I'm sorry. . .", ". . .", "We just couldn't do. . ." )
		AddDialogueLine( sc.t2, ". . .", "Are you shitting me. . ." )
		AddDialogueLine( sc.t1, "I mean we tried, we also wante. . ." )
		AddDialogueLine( sc.t2, "Are you fucking shitting me??!!!" )
		AddDialogueLine( sc.t1, "There is gotta be another way to. . ." )
		AddDialogueLine( sc.t2, "I gave you everything that guaranteed success!" )
		AddDialogueLine( sc.t1, "B-b-but they were too strong for us\n. . .", "We could not even past the. . ." )
		AddDialogueLine( sc.t2, "Useless little pieces of shit!", "What the fuck are you paying me for?" )
		AddDialogueLine( sc.t1, "I'm really sorry boss, I. . ." )
		AddDialogueLine( sc.t2, "Shut the fuck up!!!", "I could've done better myself. . .", "Now go back to your shitty room, you little whore!" )
		AddDialogueLine( sc.t2, ". . .", "You two." )
		AddDialogueLine( sc.t3, ". . ." )
		AddDialogueLine( sc.t2, "Contact our 'sponsors'.",". . .", "We are going to need more power\nthan just these stupid shits. . ." )
		AddDialogueLine( sc.t4, "Understood!" )
	end,
}

GM.Cutscenes["_sog_demo3"][15] = {
	Intro = "2013\nShitty roleplay server. . . once again",
	SoundTrack = 126074686,//122825804
	Volume = 13,
	StartFrom = 8*1000,
	Main = { mdl = Model( "models/hunter/plates/plate6x6.mdl" ), seq = "idle"},
	Relative = {
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-31, 18, 3) , ang = Angle(-1, -91, 0) , seq = "idle" },
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(10, -20, 282) , ang = Angle(89, -129, 0) , seq = "Idle" },
		{ mdl = Model( "models/props_combine/breenclock.mdl"), offset = Vector(8, 4, 40) , ang = Angle(-2, -3, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(9, -22, 36) , ang = Angle(-2, 21, -3) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(10, -20, 37) , ang = Angle(9, 61, -13) , seq = "idle" },
		{ mdl = Model( "models/props_lab/clipboard.mdl"), offset = Vector(12, -31, 36) , ang = Angle(-1, -13, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/phone.mdl"), offset = Vector(-14, -53, 37) , ang = Angle(-1, 159, 0) , seq = "only_sequence" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(-22, -5, 41) , ang = Angle(66, -91, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(-21, 4, 40) , ang = Angle(-55, 90, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(-21, -1, 41) , ang = Angle(66, 90, -180) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/coffee_mug3.mdl"), offset = Vector(-6, -7, 36) , ang = Angle(-1, -2, 1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/coffee_mug3.mdl"), offset = Vector(-12, -6, 37) , ang = Angle(-4, 5, 0) , seq = "idle" },
		{ mdl = Model( "models/player/hostage/hostage_04.mdl"), offset = Vector(57, -29, 5) , ang = Angle(0, -175, -1) , seq = "idle_suitcase", t1 = true, icon = Material( "sog/oldman.png", "smooth" ) },
		{ mdl = Model( "models/props/cs_office/coffee_mug3.mdl"), offset = Vector(-10, 2, 36) , ang = Angle(-1, 64, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(-6, 5, 35) , ang = Angle(0, 143, 1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(-21, 8, 40) , ang = Angle(-62, -90, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(-23, 2, 44) , ang = Angle(-4, -91, -1) , seq = "idle" },
		{ mdl = Model( "models/props_combine/breenchair.mdl"), offset = Vector(-47, -28, 6) , ang = Angle(-1, 1, -1) , seq = "idle" },
		{ mdl = Model( "models/player/breen.mdl"), offset = Vector(-47, -29, 25) , ang = Angle(3, 3, -2) , seq = "sit", t2 = true, icon = Material( "sog/breen.png", "smooth" ) },
		{ mdl = Model( "models/player/police.mdl"), offset = Vector(-39, 39, 4) , ang = Angle(-1, -27, -1) , seq = "pose_standing_01" },
		{ mdl = Model( "models/maxofs2d/gm_painting.mdl"), offset = Vector(-62, 66, 71) , ang = Angle(-1, -1, 5) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/file_box.mdl"), offset = Vector(18, 103, 6) , ang = Angle(-1, -69, -1) , seq = "idle" },
		{ mdl = Model( "models/props_c17/briefcase001a.mdl"), offset = Vector(52, -9, 14) , ang = Angle(0, 5, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-136, -157, 3) , ang = Angle(-1, 180, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(92, -77, 4) , ang = Angle(-0, -91, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(92, 15, 4) , ang = Angle(-0, -91, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/plant01.mdl"), offset = Vector(102, 111, 5) , ang = Angle(-1, -45, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/sofa_chair.mdl"), offset = Vector(62, 107, 6) , ang = Angle(-1, -92, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(96, 105, 4) , ang = Angle(-1, 90, -1) , seq = "idle" },
		{ mdl = Model( "models/props_lab/cornerunit2.mdl"), offset = Vector(-60, 114, 6) , ang = Angle(-1, 0, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-28, 110, 3) , ang = Angle(-1, 89, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/moneypalletd.mdl"), offset = Vector(-117, 23, 6) , ang = Angle(-0, -1, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-136, 89, 3) , ang = Angle(-1, 178, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/handtruck.mdl"), offset = Vector(-125, 103, 4) , ang = Angle(-0, 35, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/moneypallet02a.mdl"), offset = Vector(-117, -104, 6) , ang = Angle(0, -91, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/forklift.mdl"), offset = Vector(-156, -163, 5) , ang = Angle(-1, 64, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/moneypallet.mdl"), offset = Vector(-117, -40, 6) , ang = Angle(-0, 180, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(92, -168, 4) , ang = Angle(-0, -91, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/plant01.mdl"), offset = Vector(105, -161, 5) , ang = Angle(-0, -91, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/sofa_chair.mdl"), offset = Vector(37, -157, 6) , ang = Angle(-1, 84, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_havana/bookcase_small.mdl"), offset = Vector(-68, -167, 14) , ang = Angle(-1, -26, -1) , seq = "idle" },
		{ mdl = Model( "models/props_lab/reciever_cart.mdl"), offset = Vector(-13, -173, 41) , ang = Angle(-1, 1, -1) , seq = "idle" },
		{ mdl = Model( "models/props_combine/breenbust.mdl"), offset = Vector(-15, -158, 91) , ang = Angle(-1, 34, -2) , seq = "idle" },
		{ mdl = Model( "models/props_c17/doll01.mdl"), offset = Vector(41, -152, 32) , ang = Angle(-46, 52, 88) , seq = "idle" },
		{ mdl = Model( "models/props_lab/crematorcase.mdl"), offset = Vector(-63, -137, 6) , ang = Angle(-1, -29, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-31, -73, 3) , ang = Angle(-0, -91, 0) , seq = "idle" },
		{ mdl = Model( "models/player/police.mdl"), offset = Vector(-57, -101, 5) , ang = Angle(-1, 18, -1) , seq = "menu_combine" },
		{ mdl = Model( "models/props/cs_office/file_box_p1.mdl"), offset = Vector(-2, -85, 6) , ang = Angle(0, -1, -1) , seq = "idle" },
		{ mdl = Model( "models/props_combine/breendesk.mdl"), offset = Vector(-7, -29, 4) , ang = Angle(-1, -2, -1) , seq = "idle" },
		{ mdl = Model( "models/gibs/hgibs.mdl"), offset = Vector(5, -64, 40) , ang = Angle(0, -8, -1) , seq = "idle1" },
		{ mdl = Model( "models/props_junk/garbage_newspaper001a.mdl"), offset = Vector(-12, -26, 38) , ang = Angle(1, -164, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-136, -34, 3) , ang = Angle(-1, 180, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-32, -164, 4) , ang = Angle(-1, -91, 0) , seq = "idle" },
	},
	Dialogues = function( sc )
		AddDialogueLine( sc.t1, "Uhh. . .", "Hello?" )
		AddDialogueLine( sc.t2, "Ah, perfect!", "Welcome, my dear friend!" )
		AddDialogueLine( sc.t1, "I saw that strange advertisement on the forums. . .","I heard that I can join this community,\nif I contact you.")
		AddDialogueLine( sc.t2, ". . .", "Absolutely!", "We truly respect players and their decisions,\nunlike other servers!" )
		AddDialogueLine( sc.t1, "So. . .", "Where do I sign in?" )
		AddDialogueLine( sc.t2, "Right here!", "You need to donate 90$ in order to join as well.", ". . .", "Making new friends is quite expensive nowadays, you know." )
		AddDialogueLine( sc.t1, "Alright. . .", ". . ." )
		AddDialogueLine( sc.t2, "Oh I'm gonna need your address\nand preferably credit card number.", "To make sure that you will be protected by community,\nof course." )
		AddDialogueLine( sc.t1, "O-o-okay, so what do I do now?", ". . ." )
		AddDialogueLine( sc.t2, "Congratulations, my friend!", "Now you are the property of comm. . .", "oops. . .", "Sorry, wrong phrase. . ." )
		AddDialogueLine( sc.t2, "Now you are a truly important member\nof our awesome community!" )
		AddDialogueLine( sc.t2, "And from now on, your job is to sell stuff!" )
		AddDialogueLine( sc.t1, "Sell stuff?", ". . .", "Isn't roleplaying supposed to be at least fun?" )
		AddDialogueLine( sc.t2, "Of course, it is!", "It is actually the most fun thing to do than the rest\nof the shit you will ever find in browser nowadays!" )
		AddDialogueLine( sc.t1, ". . .", "But. . ." )
		AddDialogueLine( sc.t2, "Time is money, friend!", "Now go and enjoy doing your\njob/thing/whatever the fuck it was. . ." )
		AddDialogueLine( sc.t1, "Yeah, but still. . ." )
		AddDialogueLine( sc.t2, "NEXT!" )
	end,
}


GM.Cutscenes["_sog_demo3"][25] = {
	Intro = "2013\nShitty owner's lounge",
	SoundTrack = 131088556,
	Volume = 23,
	Main = { mdl = Model( "models/hunter/plates/plate5x6.mdl" ), seq = "idle"},
	Relative = {
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(30, 25, 9) , ang = Angle(-3, 90, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(41, 0, 8) , ang = Angle(0, 116, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(42, -1, 9) , ang = Angle(0, 118, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(40, -5, 10) , ang = Angle(-7, 124, -160) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(35, 0, 8) , ang = Angle(0, 110, 179) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(31, -4, 8) , ang = Angle(-1, 101, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(30, -9, 9) , ang = Angle(-16, 94, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(33, -12, 9) , ang = Angle(-16, 95, 2) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(37, -11, 8) , ang = Angle(10, 146, -2) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(43, -13, 8) , ang = Angle(0, 152, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(47, -10, 8) , ang = Angle(0, 157, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(46, -9, 9) , ang = Angle(-1, 102, -2) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(49, 0, 8) , ang = Angle(0, -9, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(49, -1, 9) , ang = Angle(-1, 91, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(49, 6, 8) , ang = Angle(-1, -17, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(43, 7, 9) , ang = Angle(5, 124, 13) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(40, 7, 9) , ang = Angle(6, 120, 12) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(31, 7, 9) , ang = Angle(-16, 100, -3) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(31, 11, 9) , ang = Angle(-17, 90, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(33, 16, 10) , ang = Angle(-13, 140, 171) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(32, 21, 9) , ang = Angle(0, 106, 179) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/radio.mdl"), offset = Vector(-43, 14, 30) , ang = Angle(-2, -122, 0) , seq = "only_sequence" },
		{ mdl = Model( "models/player/police.mdl"), offset = Vector(-22, 72, 4) , ang = Angle(-1, -35, 1) , seq = "pose_standing_01" },
		{ mdl = Model( "models/player/breen.mdl"), offset = Vector(42, 44, 10) , ang = Angle(-39, -92, -2) , seq = "sit_fist", t1 = true, icon = Material( "sog/breen.png", "smooth" ) },
		{ mdl = Model( "models/props/cs_office/phone.mdl"), offset = Vector(9, 49, 39) , ang = Angle(0, -83, -1) , seq = "only_sequence", t2 = true, icon = Material( "sog/phone.png", "smooth" ) },
		{ mdl = Model( "models/props_c17/furnituredrawer002a.mdl"), offset = Vector(-1, 47, 22) , ang = Angle(0, -67, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(1, -5, 3) , ang = Angle(0, 179, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(1, 114, 3) , ang = Angle(-1, -1, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-104, 113, 3) , ang = Angle(0, 90, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-109, -102, 3) , ang = Angle(-1, -90, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-90, 8, 3) , ang = Angle(0, -180, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(1, -133, 3) , ang = Angle(-1, -1, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/table_coffee.mdl"), offset = Vector(-46, -6, 5) , ang = Angle(0, -180, -1) , seq = "idle" },
		{ mdl = Model( "models/props_c17/computer01_keyboard.mdl"), offset = Vector(-55, -9, 29) , ang = Angle(-11, 167, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/computer_monitor.mdl"), offset = Vector(-41, -8, 30) , ang = Angle(0, -174, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/sofa_chair.mdl"), offset = Vector(-92, -10, 6) , ang = Angle(-1, 2, -1) , seq = "idle" },
		{ mdl = Model( "models/player/police.mdl"), offset = Vector(95, 67, 5) , ang = Angle(0, -136, -1) , seq = "menu_combine" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(111, 111, 4) , ang = Angle(0, 90, -1) , seq = "idle" },
		{ mdl = Model( "models/props_interiors/bathtub01a.mdl"), offset = Vector(47, 20, 12) , ang = Angle(-1, 89, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(92, 1, 3) , ang = Angle(-1, 0, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/cardboard_box02.mdl"), offset = Vector(44, -44, 6) , ang = Angle(0, 173, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/cardboard_box03.mdl"), offset = Vector(47, -63, 6) , ang = Angle(-1, 107, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(106, -104, 3) , ang = Angle(0, -91, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/moneypalleta.mdl"), offset = Vector(98, -105, 6) , ang = Angle(-1, 5, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/moneypallet03.mdl"), offset = Vector(3, -110, 6) , ang = Angle(-1, 1, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/file_box_p2.mdl"), offset = Vector(-43, -49, 6) , ang = Angle(-1, -172, -1) , seq = "idle" },
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(7, 12, 272) , ang = Angle(88, 63, 0) , seq = "Idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(36, 45, 37) , ang = Angle(-27, 88, -33) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(43, 48, 40) , ang = Angle(17, -117, 2) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(32, 37, 8) , ang = Angle(-1, 99, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(31, 32, 10) , ang = Angle(-15, 99, 177) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/vending_machine.mdl"), offset = Vector(-41, 133, 6) , ang = Angle(0, 0, -1) , seq = "idle" },
	},
	Dialogues = function( sc )
		AddDialogueLine( sc.t1, ". . .Okay, so how about that. . .", "We put 4 fucking pointshops at same time!" )
		AddDialogueLine( sc.t1, "No, wait! Even better!", ". . .", "4 of them plus fifth that you have\nto buy from 4th one!" )
		AddDialogueLine( sc.t1, ". . .yeah that's right. . ." )
		AddDialogueLine( sc.t2, "*intimidating ringing sound*" )
		AddDialogueLine( sc.t1, ". . .hang on, there is someone else is calling.", ". . .", "Hello?" )
		AddDialogueLine( sc.t2, "FUCK YOU!!!" )
		AddDialogueLine( sc.t1, "Yes?" )
		AddDialogueLine( sc.t2, "I said: fuck you!!!" )
		AddDialogueLine( sc.t1, "lol, who is that?" )
		AddDialogueLine( sc.t2, "'Who is that?'!!!", ". . .", "Your fucking dipshits are ruining our server!" )
		AddDialogueLine( sc.t1, "Wait a second. . .\nI recognize your voice." )
		AddDialogueLine( sc.t2, "Of course you do!!!\nYou are so fucking dead!" )
		AddDialogueLine( sc.t1, "Ahahahahahahahahaha!!!!", "It's you who is trying to steal our players!" )
		AddDialogueLine( sc.t1, "Do you enjoy being ddosed, pretty boy?" )
		AddDialogueLine( sc.t2, "Fuck you!!!!!!", "If I will find out what is your full name is - I. . .",". . .", "Fuck you!!!" )
		AddDialogueLine( sc.t2, "And stop advertising your stupid shit\non our forums, you fucking asshole!" )
		AddDialogueLine( sc.t1, "Hahahahahahaha!!", "We, advertisers, dont fucking care.", ". . ." )
		AddDialogueLine( sc.t1, "Give up, my friend.", "Business is business.", ". . .", "Kill or be killed." )
		AddDialogueLine( sc.t1, ". . .", "We own this place. . ." )
		AddDialogueLine( sc.t2, "Fuck you, stan!!!!\n. . ." )
		AddDialogueLine( sc.t1, "Woah!\nAre you even sure that it is even my real name?" )
		AddDialogueLine( sc.t2, "I don't fucking care!", ". . .", "When I find out. . .\nI swear, I'm going to dox you into the grave!" )
		AddDialogueLine( sc.t1, "Well, good luck with that, pal!" )
		AddDialogueLine( sc.t2, "Fuuuuuck yooouuuuu!!!" )
		AddDialogueLine( sc.t1, "Sorry, can't hear you over the sound\nof all this money that is being donated to me!" )
		AddDialogueLine( sc.t2, "*angry phone hanging*" )
	end,
}

//nemesis--------------------------------------------------------------------------------------------------------------------------
GM.Cutscenes["_sog_demo4"][0] = {
	Intro = "2013\nLair of \"CoderFired\" Corporation",
	SoundTrack = 158203992,
	Volume = 20,
	Main = { mdl = Model( "models/hunter/plates/plate6x6.mdl" ), seq = "idle"},
	Relative = {
		{ mdl = Model( "models/props/cs_office/shelves_metal1.mdl"), offset = Vector(95, -137, 6) , ang = Angle(-1, 89, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/plant01.mdl"), offset = Vector(-81, -101, 5) , ang = Angle(-1, -79, -1) , seq = "idle" },
		{ mdl = Model( "models/props_combine/combine_binocular01.mdl"), offset = Vector(-79, -54, 26) , ang = Angle(45, 44, -1) , seq = "idle" },
		{ mdl = Model( "models/player/group01/male_09.mdl"), offset = Vector(33, -18, 4) , ang = Angle(-1, 92, 3) , seq = "pose_standing_01", tag = "mark", icon = Material( "sog/mark.png", "smooth" ), PlayerColor = Color( 215, 77, 64 ) },
		{ mdl = Model( "models/props_combine/combine_binocular01.mdl"), offset = Vector(-90, 8, 25) , ang = Angle(45, -46, -1) , seq = "idle" },
		{ mdl = Model( "models/props_combine/combine_intmonitor003.mdl"), offset = Vector(-92, -24, 39) , ang = Angle(-4, 3, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/moneypallete.mdl"), offset = Vector(-134, -106, 5) , ang = Angle(-1, 104, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/moneypallet.mdl"), offset = Vector(-143, -30, 6) , ang = Angle(0, 178, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/moneypallet03d.mdl"), offset = Vector(-141, 37, 6) , ang = Angle(-1, -1, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(-54, 109, 31) , ang = Angle(-19, -178, 2) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(-58, 106, 32) , ang = Angle(-8, 128, 17) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(-62, 101, 33) , ang = Angle(-12, -112, -17) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(-56, 102, 33) , ang = Angle(-10, -123, -30) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(-54, 92, 33) , ang = Angle(17, 31, -175) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(-53, 99, 31) , ang = Angle(-14, -121, 8) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(-50, 105, 29) , ang = Angle(-9, 130, 15) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(-45, 109, 27) , ang = Angle(18, 7, 4) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(-43, 105, 29) , ang = Angle(-18, -150, 174) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(-42, 99, 28) , ang = Angle(13, 59, -168) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(-47, 99, 31) , ang = Angle(-17, -140, -148) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(-43, 97, 29) , ang = Angle(-17, -142, -5) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(-41, 100, 30) , ang = Angle(-29, -166, 2) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-89, 119, 3) , ang = Angle(-0, -91, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage_carboard002a.mdl"), offset = Vector(-11, -25, 5) , ang = Angle(-0, -74, 0) , seq = "idle" },
		{ mdl = Model( "models/props_c17/chair02a.mdl"), offset = Vector(119, 61, 21) , ang = Angle(5, -134, 1) , seq = "idle" },
		{ mdl = Model( "models/player/breen.mdl"), offset = Vector(111, 45, 31) , ang = Angle(-0, 2, 0) , seq = "ragdoll", tag = "so", icon = Material( "sog/breen.png", "smooth" ), PlayerColor = Color( 255, 255, 255 ), rag = { [3] = { b_offset = Vector(112, 47, 43), b_ang = Angle(-35, -126, -110) }, [6] = { b_offset = Vector(103, 36, 49), b_ang = Angle(-2, -117, 59) }, [9] = { b_offset = Vector(102, 46, 49), b_ang = Angle(44, 65, 74) }, [10] = { b_offset = Vector(105, 54, 40), b_ang = Angle(50, 62, 72) }, [11] = { b_offset = Vector(109, 60, 32), b_ang = Angle(63, -3, -18) }, [14] = { b_offset = Vector(112, 35, 45), b_ang = Angle(12, 30, 122) }, [15] = { b_offset = Vector(123, 40, 42), b_ang = Angle(51, 68, 140) }, [16] = { b_offset = Vector(124, 48, 33), b_ang = Angle(2, 92, -110) }, [18] = { b_offset = Vector(108, 48, 31), b_ang = Angle(11, -137, -100) }, [19] = { b_offset = Vector(96, 36, 28), b_ang = Angle(78, 136, 177) }, [20] = { b_offset = Vector(93, 38, 12), b_ang = Angle(20, -138, -101) }, [22] = { b_offset = Vector(114, 43, 31), b_ang = Angle(16, -130, -81) }, [23] = { b_offset = Vector(103, 30, 27), b_ang = Angle(71, 18, 60) }, [24] = { b_offset = Vector(108, 31, 11), b_ang = Angle(53, -130, -83) }, } },
		{ mdl = Model( "models/player/kleiner.mdl"), offset = Vector(-31, 50, 32) , ang = Angle(-0, 2, 0) , seq = "ragdoll", tag = "thing", icon = Material( "sog/kleiner.png", "smooth" ), PlayerColor = Color( 255, 255, 255 ),rag = { [3] = { b_offset = Vector(-26, 58, 25), b_ang = Angle(53, 26, 110) }, [6] = { b_offset = Vector(-16, 62, 14), b_ang = Angle(67, 34, -43) }, [9] = { b_offset = Vector(-22, 68, 20), b_ang = Angle(40, 144, -22) }, [10] = { b_offset = Vector(-29, 73, 13), b_ang = Angle(37, 136, -27) }, [11] = { b_offset = Vector(-35, 79, 6), b_ang = Angle(8, 134, -88) }, [14] = { b_offset = Vector(-19, 53, 17), b_ang = Angle(63, -80, -166) }, [15] = { b_offset = Vector(-18, 48, 7), b_ang = Angle(1, -6, -116) }, [16] = { b_offset = Vector(-7, 47, 6), b_ang = Angle(6, 55, 3) }, [18] = { b_offset = Vector(-34, 53, 34), b_ang = Angle(17, -132, -118) }, [19] = { b_offset = Vector(-45, 40, 28), b_ang = Angle(62, 125, 160) }, [20] = { b_offset = Vector(-50, 47, 13), b_ang = Angle(52, -152, -127) }, [22] = { b_offset = Vector(-29, 47, 31), b_ang = Angle(9, -133, -99) }, [23] = { b_offset = Vector(-41, 34, 27), b_ang = Angle(81, 127, 168) }, [24] = { b_offset = Vector(-43, 36, 11), b_ang = Angle(41, -122, -94) }, } },
		{ mdl = Model( "models/props_junk/wheebarrow01a.mdl"), offset = Vector(-54, 100, 21) , ang = Angle(0, 14, 0) , seq = "idle" },
		{ mdl = Model( "models/player/phoenix.mdl"), offset = Vector(34, 90, 4) , ang = Angle(0, -88, 0) , seq = "idle_melee_angry", tag = "steve", icon = Material( "sog/detective.png", "smooth" ), PlayerColor = Color( 215, 77, 64 ) },
		{ mdl = Model( "models/props_lab/cleaver.mdl"), offset = Vector(-26, 42, 44) , ang = Angle(-28, -82, -4) , seq = "idle" },
		{ mdl = Model( "models/props_c17/chair02a.mdl"), offset = Vector(25, 77, 19) , ang = Angle(0, -87, 0) , seq = "idle" },
		{ mdl = Model( "models/player/barney.mdl"), offset = Vector(34, 60, 28) , ang = Angle(-0, 2, 0) , seq = "ragdoll", tag = "dean", icon = Material( "sog/barney.png", "smooth" ), PlayerColor = Color( 255, 255, 255 ), rag = { [3] = { b_offset = Vector(33, 64, 39), b_ang = Angle(-58, -80, -95) }, [6] = { b_offset = Vector(35, 54, 50), b_ang = Angle(-68, -87, 89) }, [9] = { b_offset = Vector(28, 59, 46), b_ang = Angle(-8, 91, 70) }, [10] = { b_offset = Vector(27, 70, 48), b_ang = Angle(34, 75, 66) }, [11] = { b_offset = Vector(30, 79, 41), b_ang = Angle(72, -127, 63) }, [14] = { b_offset = Vector(42, 59, 45), b_ang = Angle(10, 98, 108) }, [15] = { b_offset = Vector(42, 73, 43), b_ang = Angle(64, 143, 136) }, [16] = { b_offset = Vector(36, 74, 32), b_ang = Angle(28, 140, -99) }, [18] = { b_offset = Vector(30, 60, 29), b_ang = Angle(8, -106, -91) }, [19] = { b_offset = Vector(25, 43, 25), b_ang = Angle(71, 78, 94) }, [20] = { b_offset = Vector(26, 48, 10), b_ang = Angle(41, -113, -94) }, [22] = { b_offset = Vector(38, 60, 29), b_ang = Angle(12, -84, -84) }, [23] = { b_offset = Vector(40, 43, 25), b_ang = Angle(73, 70, 64) }, [24] = { b_offset = Vector(42, 47, 9), b_ang = Angle(34, -84, -85) }, } },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(20, 80, 3) , ang = Angle(-1, -180, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage_carboard001a.mdl"), offset = Vector(17, 16, 6) , ang = Angle(-1, 55, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(92, -122, 3) , ang = Angle(-1, -91, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(2, -29, 3) , ang = Angle(-1, -91, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(104, -16, 3) , ang = Angle(-1, -1, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(113, 107, 3) , ang = Angle(-1, -3, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage128_composite001b.mdl"), offset = Vector(88, 78, 10) , ang = Angle(-1, -129, -1) , seq = "idle" },
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(46, 16, 235) , ang = Angle(89, 120, 0) , seq = "Idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-84, 28, 2) , ang = Angle(-2, 90, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/metalgascan.mdl"), offset = Vector(-35, 11, 9) , ang = Angle(89, 40, -65) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-103, -77, 3) , ang = Angle(-0, -180, 0) , seq = "idle" },
		{ mdl = Model( "models/props_combine/combine_binocular01.mdl"), offset = Vector(-67, -21, 26) , ang = Angle(45, 178, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-30, -121, 3) , ang = Angle(-0, -91, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/table_coffee.mdl"), offset = Vector(-38, -134, 6) , ang = Angle(-1, -91, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/phone.mdl"), offset = Vector(-42, -127, 30) , ang = Angle(-1, 69, -1) , seq = "only_sequence", tag = "phone", icon = Material( "sog/phone.png", "smooth" ) },
		{ mdl = Model( "models/props/cs_office/file_box_p2.mdl"), offset = Vector(-63, -134, 30) , ang = Angle(-1, -86, -1) , seq = "idle" },
		{ mdl = Model( "models/weapons/w_rif_ak47.mdl"), offset = Vector(-31, -131, 31) , ang = Angle(-1, -110, -89) , seq = "idle" },
		{ mdl = Model( "models/weapons/w_smg_ump45.mdl"), offset = Vector(-6, -136, 30) , ang = Angle(-2, -99, 89) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/trash_can.mdl"), offset = Vector(6, -143, 5) , ang = Angle(-1, -90, -1) , seq = "only_sequence" },
		{ mdl = Model( "models/props_junk/garbage_carboard002a.mdl"), offset = Vector(27, -81, 5) , ang = Angle(-1, 14, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/cardboard_box004a.mdl"), offset = Vector(39, -130, 24) , ang = Angle(-1, -97, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/cardboard_box003a.mdl"), offset = Vector(47, -136, 15) , ang = Angle(-1, 178, 0) , seq = "idle" },
		{ mdl = Model( "models/props_c17/chair02a.mdl"), offset = Vector(-49, 60, 21) , ang = Angle(2, -53, -2) , seq = "idle" },
	},
	Dialogues = function( sc )
		AddDialogueLine( sc.mark, "Well well well.", "I apologise for the mess, tho. . ." )
		AddDialogueLine( sc.mark, "The special chair for torturing is currently unavalaible,\nbut. . .", "I've got these nice and comfy chairs as a replacement." )
		AddDialogueLine( sc.thing, "*gurgle*" )
		AddDialogueLine( sc.mark, "So. . .", "Who do we have here next?" )
		AddDialogueLine( sc.dean, ". . ." )
		AddDialogueLine( sc.mark, "Looks like another leaker.", "What do you think, Steve?" )
		AddDialogueLine( sc.steve, "Yup." )
		AddDialogueLine( sc.dean, ". . .", "Go fuck yourself, mark.", "Nobody in the right mind would even need your shit." )
		AddDialogueLine( sc.mark, "Be careful with your words, my friend.", "I'm sure we can have a peaceful negotiation." )
		AddDialogueLine( sc.dean, "You said the exact same thing to previous guy." )
		AddDialogueLine( sc.thing, "*gurgle* *gurgle*" )
		AddDialogueLine( sc.mark, "Doesn't matter.", ". . .", "So, I'm just gonna ask you the same question. . ." )
		AddDialogueLine( sc.mark, "Why did you try to leak our precious addons?", ". . .", "Do you even know how hard my people are working\nto deliver the best gmod experience for players?" )
		AddDialogueLine( sc.dean, "Wow, are you that retarded?", "I was not leaking your shitty addons.", ". . .", "You just kidnapped a bunch of guys,\nwho were viewing your shitty site." )
		AddDialogueLine( sc.thing, "*gurgle* *gurgle* *gurgle*" )
		AddDialogueLine( sc.mark, "Well, that's not true, my friend." )
		AddDialogueLine( sc.dean, "Fuck you!" )
		AddDialogueLine( sc.mark, "Steve,\ncan you give him a trial version of our new medkit swep?" )
		AddDialogueLine( sc.steve, "Sure." )
		AddDialogueLine( sc.steve, "*medkit sounds*" )
		AddDialogueAction( sc.steve, function( me ) ScenePlaySequence1and2( me, "seq_baton_swing", "idle_melee_angry", 1.6 ) surface.PlaySound( "npc/vort/foot_hit.wav" ) end )
		AddDialogueLine( sc.dean, "Fuck you, Steve!", ". . .", "You used to upload your stuff on workshop.", ". . .", "And now you are just as greedy as this asshole." )
		AddDialogueLine( sc.steve, "Money equals power, ya know." )
		AddDialogueLine( sc.mark, "Exactly, Steve!" )
		AddDialogueLine( sc.so, "C-c-can I please go home?", "My mom will be pissed if she finds out\nthat I still have her credit card. . ." )
		AddDialogueLine( sc.mark, "No no no. You are not going anywhere.", ". . .", "Just relax and wait for your turn, my friend." )
		AddDialogueLine( sc.dean, "You are wasting my fucking time, mark.", ". . .", "If you are waiting for me to change my mind\nand become your personal bitch. . .", ". . .like steve, the asslicker. . ." )
		AddDialogueLine( sc.steve, "*more medkit sounds*" )
		AddDialogueAction( sc.steve, function( me ) ScenePlaySequence1and2( me, "seq_baton_swing", "idle_melee_angry", 1.6 ) surface.PlaySound( "npc/vort/foot_hit.wav" ) end )
		AddDialogueLine( sc.dean, "You won't get it." )
		AddDialogueLine( sc.phone, "*stock phone sounds*" )
		AddDialogueLine( sc.mark, "Well, great. . .", "My money bath seems to be ready." )
		AddDialogueLine( sc.mark, "Sorry, my friends.", "Looks like the negotiations are over." )
		AddDialogueLine( sc.dean, "You are going to pay, mark." )
		AddDialogueLine( sc.mark, "Pfthahahahahaha!!", ". . .", "Not me, my friend. But my customers.", "See the joke?" )
		AddDialogueLine( sc.dean, "You are such a retard." )
		AddDialogueLine( sc.mark, "Steve!" )
		AddDialogueLine( sc.steve, "Yes?" )
		AddDialogueLine( sc.mark, "Throw these two into a dumpster or something.", "And make sure to ban them, if they'll ever come close\nto our glorious market again." )
		AddDialogueLine( sc.steve, "What about the pathetic one?" )
		AddDialogueLine( sc.so, "LET ME GO!!!!!!" )
		AddDialogueLine( sc.mark, "He is all yours." )
	end
}

GM.Cutscenes["_sog_demo4"][1] = {
	Intro = "One week ago\n\"Shit that gets you mad in GMod\"",
	SoundTrack = 29466030,
	StartFrom = 4.5*1000,
	Volume = 50,
	Main = { mdl = Model( "models/hunter/plates/plate8x8.mdl" ), seq = "idle"},
	Relative = {
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(47, -7, 263) , ang = Angle(89, -160, 0) , seq = "Idle" },
		{ mdl = Model( "models/props_lab/blastdoor001a.mdl"), offset = Vector(-166, 84, 6) , ang = Angle(89, 139, 50) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/stove01.mdl"), offset = Vector(-140, 99, 29) , ang = Angle(0, 1, -2) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/refrigerator01.mdl"), offset = Vector(-140, 54, 11) , ang = Angle(-1, 1, 0) , seq = "idle" },
		{ mdl = Model( "models/props_lab/blastdoor001a.mdl"), offset = Vector(-166, -21, 6) , ang = Angle(-90, -92, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/microwave01.mdl"), offset = Vector(-86, 3, 56) , ang = Angle(-1, 2, 0) , seq = "idle" },
		{ mdl = Model( "models/props_c17/metalpot002a.mdl"), offset = Vector(-60, 7, 57) , ang = Angle(-0, 152, 0) , seq = "idle" },
		{ mdl = Model( "models/player/group01/male_07.mdl"), offset = Vector(-33, 16, 9) , ang = Angle(-1, 8, 0) , seq = "pose_standing_01", tag = "chris", icon = Material( "sog/male_07.png", "smooth" ), PlayerColor = Color( 255, 255, 255 ) },
		{ mdl = Model( "models/player/group01/male_07.mdl"), offset = Vector(17, -73, 9) , ang = Angle(-0, 44, -1) , seq = "pose_standing_02", tag = "martin", icon = Material( "sog/male_07.png", "smooth" ), PlayerColor = Color( 255, 255, 255 ) },
		{ mdl = Model( "models/player/barney.mdl"), offset = Vector(12, 13, 28) , ang = Angle(-0, 1, 0) , seq = "pose_ducking_02", tag = "dean", icon = Material( "sog/barney.png", "smooth" ), PlayerColor = Color( 255, 255, 255 ) },
		{ mdl = Model( "models/player/group03/female_02.mdl"), offset = Vector(12, -32, 26) , ang = Angle(-0, 10, -1) , seq = "sit", tag = "jane", icon = Material( "sog/female_02.png", "smooth" ), PlayerColor = Color( 255, 255, 255 ) },
		{ mdl = Model( "models/props_lab/blastdoor001b.mdl"), offset = Vector(-49, -235, 6) , ang = Angle(-90, -91, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/bar01.mdl"), offset = Vector(-89, 52, 11) , ang = Angle(-0, -91, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/couch.mdl"), offset = Vector(11, -10, 10) , ang = Angle(-1, -91, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/metalbucket01a.mdl"), offset = Vector(-64, -98, 19) , ang = Angle(-1, 27, -1) , seq = "idle" },
		{ mdl = Model( "models/props_lab/blastdoor001c.mdl"), offset = Vector(-124, -45, 6) , ang = Angle(-90, 179, 0) , seq = "idle_closed" },
		{ mdl = Model( "models/props/cs_militia/food_stack.mdl"), offset = Vector(-99, -68, 11) , ang = Angle(-1, -91, -1) , seq = "idle" },
		{ mdl = Model( "models/props_lab/blastdoor001b.mdl"), offset = Vector(-166, -22, 6) , ang = Angle(-90, 89, 0) , seq = "idle" },
		{ mdl = Model( "models/props_lab/blastdoor001c.mdl"), offset = Vector(-199, -213, 5) , ang = Angle(-88, -93, -90) , seq = "idle_closed" },
		{ mdl = Model( "models/props_junk/garbage256_composite002a.mdl"), offset = Vector(125, 51, 14) , ang = Angle(-1, -14, 0) , seq = "idle" },
		{ mdl = Model( "models/props_lab/blastdoor001c.mdl"), offset = Vector(88, -56, 6) , ang = Angle(89, 7, 6) , seq = "idle_closed" },
		{ mdl = Model( "models/props_lab/blastdoor001b.mdl"), offset = Vector(206, -183, 6) , ang = Angle(-90, -2, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/wood_pallet001a.mdl"), offset = Vector(54, -138, 18) , ang = Angle(-1, -170, -6) , seq = "idle" },
		{ mdl = Model( "models/props_lab/blastdoor001b.mdl"), offset = Vector(100, -183, 6) , ang = Angle(-90, -1, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage256_composite002b.mdl"), offset = Vector(25, -127, 15) , ang = Angle(-0, -67, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/tv_console.mdl"), offset = Vector(162, 5, 14) , ang = Angle(-1, 178, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/wood_table.mdl"), offset = Vector(73, -6, 11) , ang = Angle(0, -82, -2) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/projector_remote.mdl"), offset = Vector(81, -16, 40) , ang = Angle(-4, 87, 0) , seq = "only_sequence" },
		{ mdl = Model( "models/props/cs_militia/axe.mdl"), offset = Vector(78, -26, 42) , ang = Angle(1, 131, 1) , seq = "idle" },
		{ mdl = Model( "models/props_lab/blastdoor001c.mdl"), offset = Vector(195, 111, 6) , ang = Angle(-90, -3, 0) , seq = "idle_closed" },
		{ mdl = Model( "models/props_lab/blastdoor001c.mdl"), offset = Vector(-16, 122, 6) , ang = Angle(-90, 179, 0) , seq = "idle_closed" },
		{ mdl = Model( "models/props_junk/garbage128_composite001a.mdl"), offset = Vector(45, 155, 15) , ang = Angle(-1, 76, -1) , seq = "idle" },
		{ mdl = Model( "models/props_lab/blastdoor001b.mdl"), offset = Vector(-122, 165, 6) , ang = Angle(-90, 179, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/barstool01.mdl"), offset = Vector(-3, 94, 18) , ang = Angle(87, 14, -12) , seq = "idle" },
		{ mdl = Model( "models/props_lab/blastdoor001a.mdl"), offset = Vector(-124, 82, 6) , ang = Angle(-90, 179, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/newspaperstack01.mdl"), offset = Vector(11, 57, 11) , ang = Angle(-1, 33, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/barstool01.mdl"), offset = Vector(-26, 58, 11) , ang = Angle(-1, 93, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/caseofbeer01.mdl"), offset = Vector(45, 81, 11) , ang = Angle(-1, -68, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/caseofbeer01.mdl"), offset = Vector(42, 63, 11) , ang = Angle(-0, -29, 0) , seq = "idle" },
		{ mdl = Model( "models/player/group03m/male_08.mdl"), offset = Vector(65, 52, 10) , ang = Angle(-4, -103, -1) , seq = "pose_ducking_01", tag = "henry", icon = Material( "sog/male_08m.png", "smooth" ), PlayerColor = Color( 255, 255, 255 ) },
		{ mdl = Model( "models/weapons/w_357.mdl"), offset = Vector(64, 27, 41) , ang = Angle(3, -4, 82) , seq = "idle" },
		{ mdl = Model( "models/props_lab/blastdoor001c.mdl"), offset = Vector(89, -46, 6) , ang = Angle(-90, -1, 0) , seq = "idle_closed" },
	},
	Dialogues = function( sc )
		AddDialogueLine( sc.dean, ". . ." )
		AddDialogueLine( sc.martin, "And that was it?" )
		AddDialogueLine( sc.dean, "Pretty much.", ". . .", "I'm fucking done." )
		AddDialogueLine( sc.jane, "What do you mean?" )
		AddDialogueLine( sc.dean, "From all this." )
		AddDialogueLine( sc.henry, ". . ." )
		AddDialogueLine( sc.dean, "This fucking game has gone to shit.", ". . .", "Hordes of retarded kids. . .", "Idiots and their 'excuses' to milk some money\nout of the game.", "'Dump some toxic waste into the server and get paid!'" )
		AddDialogueLine( sc.chris, ". . ." )
		AddDialogueLine( sc.dean, "And guess what?", "Steve is now one of them." )
		AddDialogueLine( sc.jane, "Yes, you just told us. . ." )
		AddDialogueLine( sc.henry, "What a piece of shit.", "He had some of the best addons, tho." )
		AddDialogueLine( sc.jane, "Well, maybe he just needs some money to pay for his. . ." )
		AddDialogueLine( sc.martin, ". . .3rd display and probably an ass-licking machine." )
		AddDialogueLine( sc.chris, "pfthahahahaha" )
		AddDialogueLine( sc.jane, ". . ." )
		AddDialogueLine( sc.dean, "He is now an ass-licker himself.\nI'm pretty sure he can take care of his own. . ." )
		AddDialogueLine( sc.henry, "hahaha" )
		AddDialogueLine( sc.jane, "Stop with these shitty jokes already!" )
		AddDialogueLine( sc.martin, "But we are not even joking!" )
		AddDialogueLine( sc.chris, "oh yeah. . ." )
		AddDialogueLine( sc.dean, "They are right","Shit is so bad that even these shitty jokes came true." )
		AddDialogueLine( sc.henry, "So. . .", "What you are going to do?" )
		AddDialogueLine( sc.dean, "'We'", ". . .", "We will stop Mark." )
		AddDialogueLine( sc.jane, "Hey, I don't really want to participate in that. . ." )
		AddDialogueLine( sc.henry, "Got used to hiding on a passworded sandbox server?" )
		AddDialogueLine( sc.jane, "No, I. . .", "Screw you, Henry." )
		AddDialogueLine( sc.henry, "I knew it." )
		AddDialogueLine( sc.martin, "I might as well join you.", "Still better than nothing." )
		AddDialogueLine( sc.dean, "We will breach into his so-called \"lair\".", "Then we will find his scared ass,\nand then throw him into dupes section of workshop." )
		AddDialogueLine( sc.jane, "Gross. . ." )
		AddDialogueLine( sc.henry, "All this sounds waaaay too easy." )
		AddDialogueLine( sc.dean, "Well, I dunno.", "Considering how greedy he is,\nhe'll probably have an army of money-hungry psychopaths." )
		AddDialogueLine( sc.dean, "So if you really want to make it worth it. . .", ". . .you'd better take everything you need." )
		AddDialogueLine( sc.chris, "Hey, I wanna kill stuff too!" )
		AddDialogueLine( sc.martin, "And I don't feel like buying you gmod yet, Chris." )
		AddDialogueLine( sc.henry, "'Family sharing'." )
		AddDialogueLine( sc.martin, "Right. . ." )
		AddDialogueLine( sc.jane, "I'm probably going to hell for this. . ." )
		AddDialogueLine( sc.dean, "Hey, at least, you will get a vip slot before Mark." )
		AddDialogueLine( sc.jane, ". . ." )
	end
}

GM.Cutscenes["_sog_demo4"][2] = {
	Intro = "Few days before\nLair of \"CoderFired\" Corporation",
	SoundTrack = 143934270,
	Volume = 25,
	StartFrom = 21*1000 + 500,
	Main = { mdl = Model( "models/hunter/plates/plate6x6.mdl" ), seq = "idle"},
	Relative = {
		{ mdl = Model( "models/player/group01/male_01.mdl"), offset = Vector(77, -93, 4) , ang = Angle(-1, 133, 2) , seq = "cidle_all", PlayerColor = Color( 215, 77, 64 ) },
		{ mdl = Model( "models/props_junk/garbage_carboard002a.mdl"), offset = Vector(-12, -24, 5) , ang = Angle(-0, -74, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/circularsaw01.mdl"), offset = Vector(15, 44, 4) , ang = Angle(0, -59, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage_carboard001a.mdl"), offset = Vector(18, 16, 6) , ang = Angle(-1, 55, -1) , seq = "idle" },
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(41, -24, 240) , ang = Angle(89, 137, 0) , seq = "Idle" },
		{ mdl = Model( "models/props/cs_office/fire_extinguisher.mdl"), offset = Vector(69, -122, 6) , ang = Angle(-2, 91, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage_carboard002a.mdl"), offset = Vector(26, -81, 5) , ang = Angle(-1, 14, 0) , seq = "idle" },
		{ mdl = Model( "models/weapons/w_mach_m249para.mdl"), offset = Vector(12, -57, 14) , ang = Angle(-38, 112, 73) , seq = "idle" },
		{ mdl = Model( "models/weapons/w_rif_famas.mdl"), offset = Vector(28, -50, 41) , ang = Angle(1, 10, -90) , seq = "idle" },
		{ mdl = Model( "models/weapons/w_pist_elite_dropped.mdl"), offset = Vector(19, -34, 41) , ang = Angle(1, -18, -3) , seq = "idle" },
		{ mdl = Model( "models/weapons/w_smg_p90.mdl"), offset = Vector(17, -32, 41) , ang = Angle(1, 16, -90) , seq = "idle" },
		{ mdl = Model( "models/weapons/w_rif_ak47.mdl"), offset = Vector(20, -5, 40) , ang = Angle(0, -14, 87) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(28, 2, 40) , ang = Angle(14, 35, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(25, -1, 40) , ang = Angle(5, -30, -10) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(17, 1, 40) , ang = Angle(1, -14, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/table_kitchen.mdl"), offset = Vector(17, -20, 5) , ang = Angle(1, 0, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/coffee_mug3.mdl"), offset = Vector(6, 7, 40) , ang = Angle(-1, 71, 1) , seq = "idle" },
		{ mdl = Model( "models/player/group01/male_09.mdl"), offset = Vector(-21, -23, 5) , ang = Angle(0, 8, -1) , seq = "pose_standing_01", tag = "mark", PlayerColor = Color( 215, 77, 64 ) },
		{ mdl = Model( "models/props/cs_office/phone.mdl"), offset = Vector(18, 9, 40) , ang = Angle(-2, -155, 0) , seq = "only_sequence" },
		{ mdl = Model( "models/props_junk/metalbucket01a.mdl"), offset = Vector(17, 65, 14) , ang = Angle(-1, -5, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/shovel01a.mdl"), offset = Vector(-2, 70, 37) , ang = Angle(-16, -93, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(21, 80, 3) , ang = Angle(0, 180, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-88, 120, 3) , ang = Angle(-0, -91, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-83, 27, 3) , ang = Angle(-1, 90, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(2, -29, 3) , ang = Angle(-1, -91, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(103, -16, 3) , ang = Angle(-1, -2, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/computer_caseb.mdl"), offset = Vector(125, 6, 5) , ang = Angle(-2, -86, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/projector_p6a.mdl"), offset = Vector(-31, -134, 43) , ang = Angle(0, -105, 0) , seq = "only_sequence" },
		{ mdl = Model( "models/props_combine/combine_intmonitor003.mdl"), offset = Vector(-92, -23, 39) , ang = Angle(-4, 3, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/plant01.mdl"), offset = Vector(-81, -100, 5) , ang = Angle(-1, -79, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-103, -77, 3) , ang = Angle(-0, 180, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/moneypallete.mdl"), offset = Vector(-134, -105, 5) , ang = Angle(0, 104, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/table_coffee.mdl"), offset = Vector(-42, -133, 5) , ang = Angle(0, -99, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/file_box_p2.mdl"), offset = Vector(-66, -130, 29) , ang = Angle(0, -82, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/projector_p6.mdl"), offset = Vector(-38, -128, 43) , ang = Angle(-1, -20, 6) , seq = "only_sequence" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(92, -122, 3) , ang = Angle(-1, -91, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/cardboard_box003a.mdl"), offset = Vector(47, -136, 15) , ang = Angle(-1, 178, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-30, -121, 3) , ang = Angle(-0, -91, 0) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/shelves_metal1.mdl"), offset = Vector(95, -136, 6) , ang = Angle(-1, 89, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_office/trash_can.mdl"), offset = Vector(5, -143, 5) , ang = Angle(-1, -89, -1) , seq = "only_sequence" },
		{ mdl = Model( "models/props/cs_office/microwave.mdl"), offset = Vector(-33, -134, 29) , ang = Angle(-1, -9, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/cardboard_box004a.mdl"), offset = Vector(39, -130, 24) , ang = Angle(-1, -96, 0) , seq = "idle" },
		{ mdl = Model( "models/props_combine/combine_binocular01.mdl"), offset = Vector(-80, -53, 26) , ang = Angle(45, 44, -1) , seq = "idle" },
		{ mdl = Model( "models/props_combine/combine_binocular01.mdl"), offset = Vector(-89, 7, 25) , ang = Angle(45, -46, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/moneypallet.mdl"), offset = Vector(-142, -30, 6) , ang = Angle(0, 178, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_assault/moneypallet03d.mdl"), offset = Vector(-140, 36, 6) , ang = Angle(-1, -2, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/van_glass.mdl"), offset = Vector(-31, 123, 7) , ang = Angle(-1, 89, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/van.mdl"), offset = Vector(-31, 123, 6) , ang = Angle(-1, 89, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(112, 107, 3) , ang = Angle(-1, -2, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage128_composite001b.mdl"), offset = Vector(87, 79, 10) , ang = Angle(-1, -129, -1) , seq = "idle" },
		{ mdl = Model( "models/props/cs_militia/fertilizer.mdl"), offset = Vector(81, 135, 9) , ang = Angle(8, -10, -9) , seq = "idle" },
		{ mdl = Model( "models/player/phoenix.mdl"), offset = Vector(44, 68, 4) , ang = Angle(-5, -87, -2) , seq = "idle_suitcase", tag = "steve", PlayerColor = Color( 215, 77, 64 ) },
		{ mdl = Model( "models/weapons/w_smg_ump45.mdl"), offset = Vector(56, 70, 30) , ang = Angle(79, -98, -19) , seq = "idle" },
		{ mdl = Model( "models/player/corpse1.mdl"), offset = Vector(76, 17, 4) , ang = Angle(2, -154, 2) , seq = "pose_ducking_01", PlayerColor = Color( 215, 77, 64 ) },
		{ mdl = Model( "models/player/zombie_classic.mdl"), offset = Vector(127, 11, 30) , ang = Angle(19, -169, -2) , seq = "sit", PlayerColor = Color( 215, 77, 64 ) },
		{ mdl = Model( "models/player/group01/male_06.mdl"), offset = Vector(88, -25, 6) , ang = Angle(8, 174, -2) , seq = "sit_zen", PlayerColor = Color( 215, 77, 64 ) },
		{ mdl = Model( "models/player/zombie_fast.mdl"), offset = Vector(94, -63, 5) , ang = Angle(-1, 148, -1) , seq = "idle_knife", PlayerColor = Color( 215, 77, 64 ) },
		{ mdl = Model( "models/props_combine/combine_binocular01.mdl"), offset = Vector(-66, -20, 26) , ang = Angle(45, 178, -1) , seq = "idle" },
	},
	Dialogues = function( sc )
		AddDialogueLine( sc.mark, "Gentlemen, we have a situation!" )
		AddDialogueLine( sc.steve, ". . .", "What happened?" )
		AddDialogueLine( sc.mark, "A bunch of pathetic leakers,\ntrying to destroy our precious business." )
		AddDialogueLine( sc.mark, "And ruin fun for thousands of our customers!" )
		AddDialogueLine( sc.steve, ". . ." )
		AddDialogueLine( sc.mark, "This is not acceptable, my friends.", ". . .", "We all worked hard on these addons!" )
		AddDialogueLine( sc.mark, "We deserve every cent for our contribution to gmod." )
		AddDialogueLine( sc.mark, "It's us, my friends!", ". . .", "This is our time!" )
		AddDialogueLine( sc.mark, "And I will not tolerate a bunch of leakers,\nwho think that they can bypass our rules!" )
		AddDialogueLine( sc.mark, "Steve!" )
		AddDialogueLine( sc.steve, "Mmm?. . ." )
		AddDialogueLine( sc.mark, "Call out every single employee.", ". . .", "We are going to show these leakers,\nwho they are messing with." )
		AddDialogueLine( sc.steve, "Every employee?" )
		AddDialogueLine( sc.mark, "Everyone!" )
		AddDialogueLine( sc.steve, "Even Bob and other thugs?" )
		AddDialogueLine( sc.mark, "Especially Bob. . ." )
		AddDialogueLine( sc.steve, "Alright.", ". . .", "Wait. . .", ". . .do we even have that many guns for everyone?" )
		AddDialogueLine( sc.mark, "Goddamnit, steve!", "Of course, we do!", ". . .", "It's an ugly game we are in, steve", ". . .", "Like it or not." )
		AddDialogueLine( sc.mark, "Anyway. . .", "Kill everyone with no dev subscription on sight.\nThrow the corpses into workshop and noone will notice." )
		AddDialogueLine( sc.steve, "Don't wanna sound like I'm panicking or something, but. . ." )
		AddDialogueLine( sc.steve, ". . .what if someone of us will be caught?" )
		AddDialogueLine( sc.mark, "Just say: \"I need to pay for my rent\".", "Pfffthahahaha. . .", "Classic." )
		AddDialogueLine( sc.steve, "Understood!" )
	end
}


GM.Cutscenes["_sog_demo4"][3] = {
	Intro = "Some time ago. . .\nWorkshop's remains",
	SoundTrack = 125557419,
	Volume = 80,
	Main = { mdl = Model( "models/hunter/plates/plate5x5.mdl" ), seq = "idle"},
	Relative = {
		{ mdl = Model( "models/props_junk/watermelon01.mdl"), offset = Vector(18, -39, 13) , ang = Angle(-50, -67, -31) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-3, 9, 3) , ang = Angle(0, 84, 0) , seq = "idle" },
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(21, 11, 249) , ang = Angle(88, -78, -1) , seq = "Idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-52, 51, 3) , ang = Angle(-1, 85, 0) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-3, 57, 4) , ang = Angle(-2, 84, 0) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-49, -45, 3) , ang = Angle(-1, 85, 0) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-3, -41, 3) , ang = Angle(-1, 79, -1) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(95, 8, 3) , ang = Angle(0, 92, -1) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(48, 6, 3) , ang = Angle(0, 92, 0) , seq = "idle" },
		{ mdl = Model( "models/player/group01/male_07.mdl"), offset = Vector(63, 27, 5) , ang = Angle(-1, -90, 0) , seq = "pose_standing_01", tag = "martin", PlayerColor = Color( 255, 255, 255 ) },
		{ mdl = Model( "models/player/group01/male_07.mdl"), offset = Vector(98, -5, 4) , ang = Angle(-1, -135, 0) , seq = "menu_combine", tag = "chris", PlayerColor = Color( 255, 255, 255 ) },
		{ mdl = Model( "models/player/phoenix.mdl"), offset = Vector(60, -60, 5) , ang = Angle(0, 90, 0) , seq = "pose_standing_02", tag = "steve", PlayerColor = Color( 255, 255, 255 ) },
		{ mdl = Model( "models/props_c17/suitcase001a.mdl"), offset = Vector(92, -59, 15) , ang = Angle(0, 88, 0) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(98, -47, 3) , ang = Angle(0, 87, 0) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(49, -43, 3) , ang = Angle(0, 89, -1) , seq = "idle" },
		{ mdl = Model( "models/props_c17/gravestone_coffinpiece002a.mdl"), offset = Vector(-28, 5, 15) , ang = Angle(0, -3, -1) , seq = "idle" },
		{ mdl = Model( "models/props_c17/gravestone_coffinpiece001a.mdl"), offset = Vector(-37, 85, 16) , ang = Angle(-2, -4, 0) , seq = "idle" },
		{ mdl = Model( "models/player/kleiner.mdl"), offset = Vector(-31, -11, 34) , ang = Angle(-1, 0, -1) , seq = "ragdoll", tag = "trash1", rag = { [3] = { b_offset = Vector(-28, 0, 35), b_ang = Angle(1, 95, -87) }, [6] = { b_offset = Vector(-29, 15, 32), b_ang = Angle(13, 118, 119) }, [9] = { b_offset = Vector(-21, 10, 33), b_ang = Angle(28, -78, 79) }, [10] = { b_offset = Vector(-19, 0, 27), b_ang = Angle(-3, 106, -80) }, [11] = { b_offset = Vector(-22, 11, 28), b_ang = Angle(16, 95, -111) }, [14] = { b_offset = Vector(-36, 9, 34), b_ang = Angle(30, -116, 60) }, [15] = { b_offset = Vector(-41, -1, 28), b_ang = Angle(1, 81, -66) }, [16] = { b_offset = Vector(-39, 11, 28), b_ang = Angle(1, 105, 0) }, [18] = { b_offset = Vector(-27, -12, 35), b_ang = Angle(46, -86, 125) }, [19] = { b_offset = Vector(-26, -24, 22), b_ang = Angle(47, -84, 126) }, [20] = { b_offset = Vector(-25, -35, 9), b_ang = Angle(36, -1, -152) }, [22] = { b_offset = Vector(-35, -10, 33), b_ang = Angle(27, -117, 91) }, [23] = { b_offset = Vector(-42, -24, 25), b_ang = Angle(33, -117, 92) }, [24] = { b_offset = Vector(-48, -36, 16), b_ang = Angle(69, 52, -101) }, } },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-108, 103, 3) , ang = Angle(-1, 85, 0) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-100, 54, 3) , ang = Angle(0, 85, 0) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-99, 6, 3) , ang = Angle(0, 85, -1) , seq = "idle" },
		{ mdl = Model( "models/props_c17/gravestone_cross001b.mdl"), offset = Vector(-103, 13, 63) , ang = Angle(-1, -2, 0) , seq = "idle" },
		{ mdl = Model( "models/player/kleiner.mdl"), offset = Vector(-37, -20, 42) , ang = Angle(-1, 0, -1) , seq = "ragdoll", tag = "trash2", rag = { [3] = { b_offset = Vector(-31, -15, 50), b_ang = Angle(20, 32, -54) }, [6] = { b_offset = Vector(-20, -6, 42), b_ang = Angle(19, 65, 148) }, [9] = { b_offset = Vector(-22, -16, 41), b_ang = Angle(79, -26, 156) }, [10] = { b_offset = Vector(-20, -17, 30), b_ang = Angle(12, 86, -101) }, [11] = { b_offset = Vector(-20, -6, 27), b_ang = Angle(-7, 14, 162) }, [14] = { b_offset = Vector(-26, -4, 50), b_ang = Angle(39, 145, 48) }, [15] = { b_offset = Vector(-34, 1, 42), b_ang = Angle(39, 145, 48) }, [16] = { b_offset = Vector(-41, 6, 35), b_ang = Angle(33, 142, 99) }, [18] = { b_offset = Vector(-34, -23, 42), b_ang = Angle(75, -69, 158) }, [19] = { b_offset = Vector(-33, -27, 25), b_ang = Angle(67, -100, 129) }, [20] = { b_offset = Vector(-34, -33, 9), b_ang = Angle(31, 32, -106) }, [22] = { b_offset = Vector(-40, -17, 42), b_ang = Angle(31, -110, 103) }, [23] = { b_offset = Vector(-45, -32, 33), b_ang = Angle(39, -107, 105) }, [24] = { b_offset = Vector(-49, -44, 22), b_ang = Angle(59, 33, -124) }, } },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(93, -95, 3) , ang = Angle(-1, -93, 0) , seq = "idle" },
		{ mdl = Model( "models/props_c17/gravestone_coffinpiece001a.mdl"), offset = Vector(-52, -70, 15) , ang = Angle(0, -1, 0) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(44, -90, 3) , ang = Angle(-1, -91, -1) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-52, -94, 3) , ang = Angle(0, -91, -1) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-100, -97, 3) , ang = Angle(0, -89, -1) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-99, -42, 3) , ang = Angle(0, 85, -1) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-4, -92, 3) , ang = Angle(0, -91, -1) , seq = "idle" },
		{ mdl = Model( "models/maxofs2d/companion_doll.mdl"), offset = Vector(-22, 43, 12) , ang = Angle(-48, -61, 16) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(88, 105, 3) , ang = Angle(0, 90, 0) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(94, 57, 3) , ang = Angle(0, 90, 0) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(45, 56, 4) , ang = Angle(0, 86, 1) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(39, 104, 3) , ang = Angle(0, 86, -1) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-12, 106, 3) , ang = Angle(0, 85, 0) , seq = "idle" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-60, 100, 3) , ang = Angle(0, 85, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/metal_paintcan001a.mdl"), offset = Vector(25, 75, 13) , ang = Angle(3, -3, 0) , seq = "idle" },
		{ mdl = Model( "models/props_c17/doll01.mdl"), offset = Vector(10, 39, 9) , ang = Angle(72, 112, -106) , seq = "idle" },
		{ mdl = Model( "models/props_c17/doll01.mdl"), offset = Vector(22, 35, 10) , ang = Angle(61, -135, -92) , seq = "idle" },
		{ mdl = Model( "models/props_c17/doll01.mdl"), offset = Vector(32, 37, 10) , ang = Angle(6, -18, 104) , seq = "idle" },
		{ mdl = Model( "models/props_c17/doll01.mdl"), offset = Vector(28, 54, 8) , ang = Angle(-85, 155, -90) , seq = "idle" },
		{ mdl = Model( "models/humans/charple03.mdl"), offset = Vector(7, -1, 26) , ang = Angle(-1, 0, -1) , seq = "ragdoll", rag = { [1] = { b_offset = Vector(5, 4, 25), b_ang = Angle(-7, 95, 80) }, [2] = { b_offset = Vector(4, 9, 25), b_ang = Angle(-9, 83, 102) }, [3] = { b_offset = Vector(6, 20, 27), b_ang = Angle(4, 74, 65) }, } },
		{ mdl = Model( "models/props_junk/plasticcrate01a.mdl"), offset = Vector(18, -39, 12) , ang = Angle(-1, -72, 0) , seq = "idle" },
		{ mdl = Model( "models/maxofs2d/companion_doll.mdl"), offset = Vector(-45, 40, 10) , ang = Angle(-81, -49, 16) , seq = "idle" },
	},
	Dialogues = function( sc )
		local steve = sc.steve
		local martin = sc.martin
		local chris = sc.chris
		
		AddDialogueLine( martin, "Steve!" )
		AddDialogueLine( steve, "Hey, Martin. Hey, Chris." )
		AddDialogueLine( chris, "I see you've got the stuff. . ." )
		AddDialogueLine( steve, "Yes." )
		AddDialogueLine( chris, "So, you've got the stuff?!" )
		AddDialogueLine( steve, "Yes, I've got the stuff." )
		AddDialogueLine( martin, "Shut up, Chris." )
		AddDialogueLine( chris, ". . .", "What the fuck is this place, anyway?" )
		AddDialogueLine( steve, "It's. . ." )
		AddDialogueLine( martin, "A graveyard, a trashbin and a piece of shit.\nAll in one smelly package.", "This is where your stuff\nwill be buried alive because of. . ." )
		AddDialogueLine( sc.trash1, ". . .", "Yesssssss. . ." )
		AddDialogueLine( sc.trash2, "Mooorreeeeeee. . ." )
		AddDialogueLine( sc.trash1, "Oh yesssss. . ." )
		AddDialogueLine( martin, ". . .this." )
		AddDialogueLine( chris, "Ewwwwwwwwww!" )
		AddDialogueLine( steve, "Ugh.", "This place creeps me out, to be honest." )
		AddDialogueLine( chris, "Your stuff!" )
		AddDialogueLine( steve, "Oh, right!", ". . .", "So I've made this nice HUD for TTT. . ." )
		AddDialogueLine( chris, "Niccceeeee. . ." )
		AddDialogueLine( steve, "Nothing super fancy, but that's not the thing." )
		AddDialogueLine( steve, "I was about to upload it on workshop. . .", ". . .and suddenly I get a message from one of my friends." )
		AddDialogueLine( steve, "I barely talked to him before,\nbut he sounded super hyped about something." )
		AddDialogueLine( martin, "You know. . .", "Your are a fucking magnet for strange guys." )
		AddDialogueLine( chris, "Pfffft. . ." )
		AddDialogueLine( steve, "Yeah, yeah. . .", "Basically, he said that there will be\na conference or something like that." )
		AddDialogueLine( steve, "'The Future of GMod'. . .", ". . .can't remember the exact name." )
		AddDialogueLine( steve, "So I dunno.", "I guess, I should go check it out.", ". . .", "It should be this evening,\nso I can get back home right after that." )
		AddDialogueLine( steve, "And upload the HUD to workshop, of course." )
		AddDialogueLine( martin, "'The Future of GMod'. . .", "Sound weird." )
		AddDialogueLine( chris, "Maybe they are collecting volunteers for janitors.", ". . .", "To clean up this shithole, for example." )
		AddDialogueLine( steve, "Hahah. . .I hope not.", "Friend described them as super nice and friendly guys." )
		AddDialogueLine( steve, "I mean, come on. . .", "What can go wrong?" )
		AddDialogueLine( martin, ". . ." )
		AddDialogueLine( chris, ". . ." )
		AddDialogueLine( steve, "Right?" )
	end
}

GM.Cutscenes["_sog_demo4"][4] = {
	Intro = "Some time ago. . .\nJane's private sandbox",
	SoundTrack = 49746795,
	Volume = 55,
	Main = { mdl = Model( "models/hunter/plates/plate5x5.mdl" ), seq = "idle"},
	Relative = {
		{ mdl = Model( "models/props_junk/watermelon01.mdl"), offset = Vector(-59, 67, 44) , ang = Angle(14, 52, 14) , seq = "idle" },
		{ mdl = Model( "models/props_junk/watermelon01.mdl"), offset = Vector(-11, 64, 36) , ang = Angle(-49, 137, -83) , seq = "idle" },
		{ mdl = Model( "models/props_junk/watermelon01.mdl"), offset = Vector(-10, 50, 41) , ang = Angle(17, 71, -17) , seq = "idle" },
		{ mdl = Model( "models/props_junk/watermelon01.mdl"), offset = Vector(-18, 53, 28) , ang = Angle(-15, 7, -28) , seq = "idle" },
		{ mdl = Model( "models/props_junk/watermelon01.mdl"), offset = Vector(-25, 62, 42) , ang = Angle(2, 3, -9) , seq = "idle" },
		{ mdl = Model( "models/props_junk/watermelon01.mdl"), offset = Vector(-32, 64, 28) , ang = Angle(-56, -113, 81) , seq = "idle" },
		{ mdl = Model( "models/props_junk/watermelon01.mdl"), offset = Vector(-43, 65, 37) , ang = Angle(11, 143, 143) , seq = "idle" },
		{ mdl = Model( "models/props_junk/watermelon01.mdl"), offset = Vector(-36, 51, 38) , ang = Angle(-79, -26, 101) , seq = "idle" },
		{ mdl = Model( "models/props_vehicles/carparts_tire01a.mdl"), offset = Vector(62, 56, 21) , ang = Angle(-37, -130, 66) , seq = "idle" },
		{ mdl = Model( "models/props_trainstation/bench_indoor001a.mdl"), offset = Vector(-55, -36, 24) , ang = Angle(0, 0, -1) , seq = "idle" },
		{ mdl = Model( "models/player/group03/female_02.mdl"), offset = Vector(-52, -64, 27) , ang = Angle(-1, -1, 0) , tag = "jane", PlayerColor = Color( 255, 255, 255 ), seq = "ragdoll", rag = { [3] = { b_offset = Vector(-60, -65, 36), b_ang = Angle(-84, -89, -1) }, [6] = { b_offset = Vector(-58, -67, 50), b_ang = Angle(-81, 23, 68) }, [9] = { b_offset = Vector(-58, -61, 45), b_ang = Angle(40, 61, -16) }, [10] = { b_offset = Vector(-54, -53, 38), b_ang = Angle(-9, -16, -42) }, [11] = { b_offset = Vector(-44, -56, 40), b_ang = Angle(3, -39, 24) }, [14] = { b_offset = Vector(-58, -72, 44), b_ang = Angle(72, 169, 102) }, [15] = { b_offset = Vector(-61, -72, 34), b_ang = Angle(57, -27, -99) }, [16] = { b_offset = Vector(-56, -74, 24), b_ang = Angle(3, -49, 98) }, [18] = { b_offset = Vector(-52, -60, 28), b_ang = Angle(0, -6, -97) }, [19] = { b_offset = Vector(-36, -61, 28), b_ang = Angle(72, -26, -112) }, [20] = { b_offset = Vector(-32, -64, 11), b_ang = Angle(38, 16, -88) }, [22] = { b_offset = Vector(-52, -68, 27), b_ang = Angle(6, -7, -80) }, [23] = { b_offset = Vector(-33, -69, 27), b_ang = Angle(77, 126, 34) }, [24] = { b_offset = Vector(-37, -66, 10), b_ang = Angle(26, -20, -89) }, } },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-93, 57, 3) , ang = Angle(0, 179, -1) , seq = "idle" },
		{ mdl = Model( "models/props_interiors/bathtub01a.mdl"), offset = Vector(-35, 52, 25) , ang = Angle(0, -3, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-2, 66, 3) , ang = Angle(0, 179, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/metal_paintcan001b.mdl"), offset = Vector(27, 34, 12) , ang = Angle(-1, -45, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/metal_paintcan001b.mdl"), offset = Vector(59, 33, 12) , ang = Angle(0, -67, -1) , seq = "idle" },
		{ mdl = Model( "models/props_vehicles/carparts_wheel01a.mdl"), offset = Vector(42, 56, 10) , ang = Angle(0, 1, -90) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-92, -66, 3) , ang = Angle(0, 179, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(91, -58, 4) , ang = Angle(0, 179, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-1, -57, 3) , ang = Angle(0, 179, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/plasticcrate01a.mdl"), offset = Vector(83, 27, 13) , ang = Angle(0, -62, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trafficcone001a.mdl"), offset = Vector(96, 90, 21) , ang = Angle(-1, -80, 0) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trafficcone001a.mdl"), offset = Vector(93, 49, 11) , ang = Angle(76, 99, 177) , seq = "idle" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(90, 65, 4) , ang = Angle(0, 179, -1) , seq = "idle" },
		{ mdl = Model( "models/weapons/w_physics.mdl"), offset = Vector(-47, -45, 25) , ang = Angle(0, 90, -9) , seq = "idle" },
		{ mdl = Model( "models/props_junk/garbage_coffeemug001a.mdl"), offset = Vector(-41, -61, 39) , ang = Angle(0, -26, -1) , seq = "idle" },
		{ mdl = Model( "models/player/group01/male_03.mdl"), offset = Vector(23, -61, 6) , ang = Angle(0, 177, -1) , seq = "idle_all_angry", tag = "thug", PlayerColor = Color( 215, 77, 64 ), scale = 2.1 },
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(-3, -23, 233) , ang = Angle(88, 158, -2) , seq = "Idle"  },
		{ mdl = Model( "models/props_junk/bicycle01a.mdl"), offset = Vector(-76, -58, 28) , ang = Angle(0, -94, -14) , seq = "idle" },
		{ mdl = Model( "models/props_vehicles/carparts_wheel01a.mdl"), offset = Vector(-62, 39, 23) , ang = Angle(-36, -12, 15) , seq = "idle" },
		{ mdl = Model( "models/props_vehicles/carparts_wheel01a.mdl"), offset = Vector(-16, 37, 23) , ang = Angle(-1, -3, 13) , seq = "idle" },
		{ mdl = Model( "models/props_vehicles/carparts_wheel01a.mdl"), offset = Vector(-61, 80, 23) , ang = Angle(-2, 177, 12) , seq = "idle" },
		{ mdl = Model( "models/props_vehicles/carparts_wheel01a.mdl"), offset = Vector(-13, 78, 23) , ang = Angle(-3, 177, 9) , seq = "idle" },
		{ mdl = Model( "models/props_vehicles/carparts_muffler01a.mdl"), offset = Vector(36, 90, 10) , ang = Angle(-1, 8, -1) , seq = "idle" },
		{ mdl = Model( "models/props_junk/watermelon01.mdl"), offset = Vector(-63, 65, 28) , ang = Angle(37, -141, -73) , seq = "idle" },
		{ mdl = Model( "models/props_junk/watermelon01.mdl"), offset = Vector(-48, 53, 28) , ang = Angle(-14, -86, -33) , seq = "idle" },
		{ mdl = Model( "models/props_junk/watermelon01.mdl"), offset = Vector(-63, 52, 37) , ang = Angle(-62, 164, -88) , seq = "idle" },
		{ mdl = Model( "models/props_junk/watermelon01.mdl"), offset = Vector(-50, 51, 47) , ang = Angle(-42, -162, 176) , seq = "idle" },
		{ mdl = Model( "models/weapons/w_toolgun.mdl"), offset = Vector(-54, -12, 24) , ang = Angle(4, 14, -78) , seq = "idle" },
	},
	Dialogues = function( sc )
		AddDialogueLine( sc.thug, "JANE!!!" )
		AddDialogueLine( sc.jane, "What?", ". . .", "Wait, who the hell are you?" )
		AddDialogueLine( sc.thug, "JANE!!!" )
		AddDialogueLine( sc.jane, "How did you even get in there?", "I have a password on my server." )
		AddDialogueLine( sc.thug, "You're a coder, Jane!" )
		AddDialogueLine( sc.jane, ". . .", "I am.", "So what?" )
		AddDialogueLine( sc.thug, "You are coming with me, Jane!" )
		AddDialogueLine( sc.jane, "What?" )
		AddDialogueLine( sc.thug, "You're a coder!", "You are coming with me!" )
		AddDialogueLine( sc.jane, "You just said that.", ". . .", "What do you want from me?" )
		AddDialogueLine( sc.thug, "You are going to code addons, Jane!", ". . .", "Code addons and sell them!" )
		AddDialogueLine( sc.jane, "What?", "No." )
		AddDialogueLine( sc.thug, "This is not negotiable, Jane!", "You are coming with me!", "You are going to be a CoderFired employee. . ." )
		AddDialogueLine( sc.jane, "What?" )
		AddDialogueLine( sc.thug, ". . .and you will fucking enjoy it!" )
		AddDialogueLine( sc.jane, "No, I'm not going anywhere." )
		AddDialogueLine( sc.thug, "For fuck's sake, Jane!", "You are a coder\nand you are going to make fucking money!" )
		AddDialogueLine( sc.jane, "But I don't want to sell my stuff." )
		AddDialogueLine( sc.thug, "Shut up, Jane!!!", "I don't give a shit about your opinion!" )
		AddDialogueLine( sc.jane, "Easy there. . .\nDo you want me to kick you?" )
		AddDialogueLine( sc.thug, "NO, JANE!!!", "You are going to sell scripts!\nAnd you will fucking thank me for that!" )
		AddDialogueLine( sc.jane, "*sigh*", "What the hell is wrong with you?" )
		AddDialogueLine( sc.thug, "I'M FINE, JANE!!!" )
		AddDialogueLine( sc.jane, "Then stop yelling at me." )
		AddDialogueLine( sc.thug, "NO, JANE!!!", "I'm going to drag your ass to the CoderFired!" )
		AddDialogueLine( sc.jane, "My, what???" )
		AddDialogueLine( sc.thug, "JANE!!!", "Listen to me!", "You are going to work in our office!", "You will sell your shitty scripts!", "And you will not complain about it!" )
		AddDialogueLine( sc.jane, "What?" )
		AddDialogueLine( sc.thug, "OH FOR FUCK'S SAKE, JANE!!!", "You are a fucking coder, you understand that?!!!" )
		AddDialogueLine( sc.jane, "Uh. . .", "Sorry, but I'm just going to kick you,\nbecause this is getting out of control." )
		AddDialogueLine( sc.thug, "SO, THAT'S HOW YOU WELCOME YOUR GUESTS!", "COME ON, THEN!\nBRING IT ON YOU LITTLE B. . ." )
		AddDialogueLine( sc.thug, "*Player Bob left the game (Kicked from server)*" )
		AddDialogueAction( sc.thug, function( me ) me.Hide = true surface.PlaySound("UI/hint.wav") end )
		AddDialogueLine( sc.jane, "Jeez, what the hell was that thing. . ." )
	end
}

GM.SingleplayerCutscenes["lesson"] = {
	Act = "ACT 1: DMCA",
	Intro = "2013\nGreedMobile of \"CoderFired\" Corporation",
	SoundTrack = 61194784,//201132377,
	Volume = 45,
	Main = { mdl = Model( "models/hunter/plates/plate4x4.mdl" ), seq = "idle", mat = ""},
	Relative = {
		{ mdl = Model( "models/props_junk/popcan01a.mdl"), offset = Vector(-26, 100, 21) , ang = Angle(85, 1, -88), seq = "idle", mat = "", tag = "ex", shake = true },
		{ mdl = Model( "models/props_lab/huladoll.mdl"), offset = Vector(-32, -62, 96) , ang = Angle(8, -133, -12), seq = "idle", mat = "", tag = "moderator", icon = Material( "sog/alyx.png", "smooth" ), hide = true  },
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(-20, -1, 354) , ang = Angle(88, -155, -1), seq = "Idle", mat = "" },
		{ mdl = Model( "models/props_junk/shoe001a.mdl"), offset = Vector(-32, 14, 101) , ang = Angle(-1, -89, -3), seq = "idle", mat = "", tag = "steve", icon = Material( "sog/detective.png", "smooth" ), hide = true },
		{ mdl = Model( "models/props_c17/briefcase001a.mdl"), offset = Vector(-65, 36, 104) , ang = Angle(0, -91, 6), seq = "idle", mat = "", tag = "mark", icon = Material( "sog/mark.png", "smooth" ), hide = true },
		{ mdl = Model( "models/props_phx/huge/road_medium.mdl"), offset = Vector(5, 2, 2) , ang = Angle(0, -1, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/van.mdl"), offset = Vector(-46, -9, 6) , ang = Angle(0, -180, 0), seq = "idle", mat = "", shake = true },
		{ mdl = Model( "models/props/cs_militia/van_glass.mdl"), offset = Vector(-46, -9, 6) , ang = Angle(-1, -180, -1), seq = "idle", mat = "", shake = true },
	},
	Dialogues = function( sc )
		sc.ex.OnDraw = function()
			if sc.Emitter then
				sc.ex.NextPuff = sc.ex.NextPuff or 0
				if sc.ex.NextPuff < CurTime() then
					local particle = sc.Emitter:Add( "particles/smokey", sc.ex:GetPos() )
					particle:SetVelocity(math.Rand(0.1, 0.7)*Vector( 0, 340, 0 )+VectorRand()*2+vector_up*math.random(10))
					particle:SetDieTime(math.Rand(0.5, 1))
					particle:SetStartAlpha(100)
					particle:SetEndAlpha(0)
					particle:SetStartSize(math.random(2,4))
					particle:SetEndSize(math.random(6,13))
					particle:SetRoll(math.Rand(-180, 180))
					particle:SetColor(100, 100, 100)
					particle:SetAirResistance(15)
					sc.ex.NextPuff = CurTime() + math.Rand( 0, 0.09 )
				end
			end
		end
		AddDialogueLine( sc.mark, ". . ." )
		AddDialogueLine( sc.mark, "And this is why we do not tolerate leakers, steve." )
		AddDialogueLine( sc.steve, "Uhh. . .", "I see." )
		AddDialogueLine( sc.mark, "Hey, who is driving this van today?" )
		AddDialogueLine( sc.moderator, ". . ." )
		AddDialogueLine( sc.mark, "Oh. . .", "Wow. . .", "Never thought I would ever see you again." )
		AddDialogueLine( sc.moderator, "What do you mean?" )
		AddDialogueLine( sc.mark, "Well, I barely saw you at the office\nfor past few weeks." )
		AddDialogueLine( sc.moderator, ". . .", "Because this stupid van won't drive itself.", "And since I'm pretty much the only one,\nwho is able to drive cars. . ." )
		AddDialogueLine( sc.moderator, ". . .instead of just bragging about how many cars\nI've bought by selling scripts. . ." )
		AddDialogueLine( sc.steve, "Who is that?" )
		AddDialogueLine( sc.mark, "It's the moderator, Steve. . .", "Her name is. . .", "Uhh. . ." )
		AddDialogueLine( sc.moderator, "*sigh*", "You can't even remember my name again." )
		AddDialogueLine( sc.mark, "Nevermind then.", ". . .", "Are we there yet?" )
		AddDialogueLine( sc.moderator, "The road is pitch black. . .", "But I think we should arrive in a few minutes." )
		AddDialogueLine( sc.mark, "Nice!", "You know the drill.", "We gently negotiate with the owner\nand prove him wrong." )
		AddDialogueLine( sc.steve, "Gently?" )
		AddDialogueLine( sc.moderator, "This means shoot first, ask later." )
		AddDialogueLine( sc.mark, "Exactly!" )
		AddDialogueLine( sc.moderator, "Almost here!" )
		AddDialogueLine( sc.mark, "So. . .", "Any volunteers?", ". . .or do I have to do this stuff on my own?" )
	end
}

GM.SingleplayerCutscenes["takedown"] = {
	Intro = "sog_intro_outide_2013",
	SoundTrack = 95416884,
	Volume = 40,
	Main = { mdl = Model( "models/hunter/plates/plate3x3.mdl" ), seq = "idle", mat = ""},
	Relative = {
		{ mdl = Model( "models/props_c17/suitcase_passenger_physics.mdl"), offset = Vector(17, -43, 24) , ang = Angle(-1, -90, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(23, 12, 238) , ang = Angle(89, 130, 0), seq = "Idle", mat = "" },
		{ mdl = Model( "models/props_trainstation/payphone001a.mdl"), offset = Vector(28, 63, 40) , ang = Angle(-1, -91, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/trashbin01a.mdl"), offset = Vector(-105, 67, 26) , ang = Angle(-1, -93, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_trainstation/payphone001a.mdl"), offset = Vector(-53, 64, 40) , ang = Angle(-1, -90, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_trainstation/payphone_reciever001a.mdl"), offset = Vector(21, 50, 58) , ang = Angle(9, -160, -57), seq = "idle", mat = "", tag = "phone" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(71, -40, 4) , ang = Angle(0, -90, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/player/group01/male_02.mdl"), offset = Vector(26, 30, 4) , ang = Angle(0, 90, -1), seq = "idle_magic", mat = "", tag = "pr", noanim = true },
		{ mdl = Model( "models/props_junk/garbage_takeoutcarton001a.mdl"), offset = Vector(77, 39, 10) , ang = Angle(-82, -85, 3), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(57, 52, 4) , ang = Angle(-1, -91, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-52, -39, 3) , ang = Angle(0, -90, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/garbage_glassbottle003a.mdl"), offset = Vector(-23, -42, 30) , ang = Angle(-1, -171, 4), seq = "idle", mat = "" },
		{ mdl = Model( "models/player/hostage/hostage_03.mdl"), offset = Vector(-5, -36, 22) , ang = Angle(1, -95, 1), seq = "sit", mat = "", tag = "dude" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-62, 52, 3) , ang = Angle(0, 89, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_trainstation/bench_indoor001a.mdl"), offset = Vector(-35, -37, 24) , ang = Angle(0, -90, -1), seq = "idle", mat = "" },
	},
	Dialogues = function( sc )
		AddDialogueLine( sc.pr, translate.Get("sog_dialogue_outide_2013_1"), "sog_dialogue_outide_2013_2" )
		AddDialogueLine( sc.phone, translate.Get("sog_dialogue_outide_2013_3"), "sog_dialogue_outide_2013_4", "sog_dialogue_outide_2013_5", "sog_dialogue_outide_2013_6" )
		AddDialogueLine( sc.pr, "sog_dialogue_outide_2013_7", "sog_dialogue_outide_2013_8" )
		AddDialogueLine( sc.pr, "sog_dialogue_outide_2013_9" )
		AddDialogueLine( sc.phone, "sog_dialogue_outide_2013_10", "sog_dialogue_outide_2013_11" )
		AddDialogueLine( sc.pr, "sog_dialogue_outide_2013_12" )
		AddDialogueLine( sc.phone, "sog_dialogue_outide_2013_13", "sog_dialogue_outide_2013_14", "sog_dialogue_outide_2013_15", "sog_dialogue_outide_2013_16" )
		AddDialogueLine( sc.pr, "sog_dialogue_outide_2013_17", "sog_dialogue_outide_2013_18" )
		AddDialogueLine( sc.phone, "sog_dialogue_outide_2013_19", "sog_dialogue_outide_2013_20" )
		AddDialogueLine( sc.pr, "sog_dialogue_outide_2013_21", "sog_dialogue_outide_2013_22" )
		AddDialogueLine( sc.dude, "sog_dialogue_outide_2013_23", "sog_dialogue_outide_2013_24", "sog_dialogue_outide_2013_25", "sog_dialogue_outide_2013_26" )
		AddDialogueLine( sc.pr, "sog_dialogue_outide_2013_27" )
		AddDialogueLine( sc.dude, "sog_dialogue_outide_2013_28", "sog_dialogue_outide_2013_29", "sog_dialogue_outide_2013_30" )
		AddDialogueLine( sc.pr, "sog_dialogue_outide_2013_31", "sog_dialogue_outide_2013_32" )
		AddDialogueLine( sc.dude, "sog_dialogue_outide_2013_33", "sog_dialogue_outide_2013_34", "sog_dialogue_outide_2013_35", "sog_dialogue_outide_2013_36", "sog_dialogue_outide_2013_37" )
		AddDialogueLine( sc.pr, "sog_dialogue_outide_2013_38" )
	end
}


GM.SingleplayerCutscenes["competition"] = {
	Intro = "2013\nSome shitty roleplay server. . .",
	SoundTrack = 241356191,//194760777,
	//StartFrom = 11000,
	Volume = 35,
	Main = { mdl = Model( "models/hunter/plates/plate6x6.mdl" ), seq = "idle", mat = ""},
	Relative = {
		{ mdl = Model( "models/props_combine/breendesk.mdl"), offset = Vector(-6, -29, 5) , ang = Angle(-1, 0, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_lab/chess.mdl"), offset = Vector(-10, -30, 38) , ang = Angle(0, 3, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(3, -17, 296) , ang = Angle(89, -136, -1), seq = "Idle", mat = "" },
		{ mdl = Model( "models/props_lab/crematorcase.mdl"), offset = Vector(-63, -138, 6) , ang = Angle(-1, -30, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-136, -34, 3) , ang = Angle(-1, 180, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/player/police.mdl"), offset = Vector(37, -30, 5) , ang = Angle(0, -176, 0), seq = "pose_ducking_01", mat = "", tag = "cop" },
		{ mdl = Model( "models/props/cs_assault/handtruck.mdl"), offset = Vector(-125, 104, 4) , ang = Angle(-0, 34, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-136, 89, 3) , ang = Angle(-1, 179, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_c17/canister01a.mdl"), offset = Vector(-50, 72, 33) , ang = Angle(12, 63, -24), seq = "idle", mat = "" },
		{ mdl = Model( "models/gibs/hgibs.mdl"), offset = Vector(4, -64, 40) , ang = Angle(0, -7, -1), seq = "idle1", mat = "" },
		{ mdl = Model( "models/props_lab/clipboard.mdl"), offset = Vector(-18, -68, 36) , ang = Angle(0, -165, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_office/phone.mdl"), offset = Vector(-14, -53, 37) , ang = Angle(-1, 159, -1), seq = "only_sequence", mat = "" },
		{ mdl = Model( "models/player/breen.mdl"), offset = Vector(-47, -30, 25) , ang = Angle(3, 3, -2), seq = "sit", mat = "", tag = "owner" },
		{ mdl = Model( "models/props_combine/breenchair.mdl"), offset = Vector(-47, -28, 6) , ang = Angle(-1, 2, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_office/file_box_p1.mdl"), offset = Vector(-3, -85, 6) , ang = Angle(0, -2, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-32, -74, 3) , ang = Angle(-0, -90, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_combine/breenbust.mdl"), offset = Vector(-14, -158, 92) , ang = Angle(-1, 34, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(96, 105, 4) , ang = Angle(0, 90, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_assault/moneypalletd.mdl"), offset = Vector(-118, 24, 6) , ang = Angle(-0, -2, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_assault/moneypallet.mdl"), offset = Vector(-118, -41, 6) , ang = Angle(-0, 180, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_assault/moneypallet02a.mdl"), offset = Vector(-117, -105, 6) , ang = Angle(-1, -90, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-136, -157, 3) , ang = Angle(0, 180, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_assault/forklift.mdl"), offset = Vector(-155, -163, 5) , ang = Angle(-1, 64, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_havana/bookcase_small.mdl"), offset = Vector(-68, -167, 14) , ang = Angle(-1, -26, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(92, -78, 3) , ang = Angle(0, -91, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(93, -169, 4) , ang = Angle(-0, -90, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(94, 14, 3) , ang = Angle(-1, -90, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_office/sofa_chair.mdl"), offset = Vector(38, -157, 6) , ang = Angle(-1, 84, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-31, -164, 4) , ang = Angle(-1, -90, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_lab/reciever_cart.mdl"), offset = Vector(-13, -172, 41) , ang = Angle(-1, 2, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_office/plant01.mdl"), offset = Vector(105, -161, 5) , ang = Angle(-0, -90, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_office/plant01.mdl"), offset = Vector(102, 111, 5) , ang = Angle(-1, -46, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_office/sofa_chair.mdl"), offset = Vector(63, 107, 6) , ang = Angle(-1, -92, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_lab/cornerunit2.mdl"), offset = Vector(-61, 115, 6) , ang = Angle(0, 0, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-32, 18, 3) , ang = Angle(-1, -90, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/maxofs2d/gm_painting.mdl"), offset = Vector(-62, 66, 71) , ang = Angle(-1, -2, 5), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-27, 110, 3) , ang = Angle(-1, 89, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_combine/breenclock.mdl"), offset = Vector(9, 4, 41) , ang = Angle(0, -2, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(9, -8, 36) , ang = Angle(1, -156, 1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(-1, 11, 36) , ang = Angle(-1, -87, 1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(-21, 7, 40) , ang = Angle(-62, -90, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(-22, 3, 40) , ang = Angle(-55, 91, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(-22, -2, 41) , ang = Angle(66, 90, -180), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(-21, -6, 41) , ang = Angle(66, -91, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_office/coffee_mug3.mdl"), offset = Vector(-12, -6, 37) , ang = Angle(-4, 4, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_office/file_box.mdl"), offset = Vector(19, 103, 6) , ang = Angle(0, -69, -1), seq = "idle", mat = "" },
	},
	Dialogues = function( sc )
		AddDialogueLine( sc.owner, ". . .", "This chess game is annoying. . ." )
		AddDialogueLine( sc.cop, ". . .", "So, where have you been?" )
		AddDialogueLine( sc.owner, "It's a shitty story.", "I kept waiting for these fucking sponsors. . .", "What a waste of time." )
		AddDialogueLine( sc.cop, ". . ." )
		AddDialogueLine( sc.owner, "Because of that, I've decided to visit CoderFired.", "I was running low on paid addons, and. . ." )
		AddDialogueLine( sc.cop, "And?" )
		AddDialogueLine( sc.owner, "These fucking idiots!", "I walked into their office. . .", "And then someone tied me to a chair,\nwhile accusing me for being a leaker." )
		AddDialogueLine( sc.cop, "Woah. . ." )
		AddDialogueLine( sc.owner, "Thankfully I sort of managed to escape.", "Ugh. . ." )
		AddDialogueLine( sc.cop, "That's shitty." )
		AddDialogueLine( sc.owner, "It sure is. . .", "Now we are losing players." )
		AddDialogueLine( sc.cop, "Why?" )
		AddDialogueLine( sc.owner, "Do I really have to explain how it works again?" )
		AddDialogueLine( sc.cop, "You never did in the first place." )
		AddDialogueLine( sc.owner, "Ugh. . .", "In short. . .", "You have paid addons.", "You inject these into players.", "Players are mindless and happy.", "You get rich." )
		AddDialogueLine( sc.cop, ". . ." )
		AddDialogueLine( sc.owner, "Is that clear?" )
		AddDialogueLine( sc.cop, "Yeah. . .", "So what are you going to do?" )
		AddDialogueLine( sc.owner, "I still have one canister of paid addons. . .", ". . .but I think it's way out of date.", "I need someone to test it on." )
		AddDialogueLine( sc.cop, "What about that guy?", "You know, one that was talking to you\na day or two ago." )
		AddDialogueLine( sc.owner, "Oh. . .", "Carl?", "Hm. . .", "That might work.", "I'll try it in a few days, but for now. . ." )
		AddDialogueLine( sc.cop, ". . ." )
		AddDialogueLine( sc.owner, "I need to persuade that idiot owner\nto give up on his community." )
		AddDialogueLine( sc.owner, "Maybe this will let us get more players." )
		AddDialogueLine( sc.cop, "Do you need any assistance, boss?" )
		AddDialogueLine( sc.owner, "I'll handle this.", "You stay here and watch over the server." )
		AddDialogueLine( sc.cop, "Understood!" )
	end
}

GM.SingleplayerCutscenes["underscore"] = {
	Intro = "2013\nOutside",
	SoundTrack = 95416884,
	Volume = 40,
	Main = { mdl = Model( "models/hunter/plates/plate3x3.mdl" ), seq = "idle", mat = ""},
	Relative = {
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(23, 12, 238) , ang = Angle(89, 110, 0), seq = "Idle", mat = "" },
		{ mdl = Model( "models/props_trainstation/payphone001a.mdl"), offset = Vector(28, 63, 40) , ang = Angle(-1, -91, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/trashbin01a.mdl"), offset = Vector(-105, 67, 26) , ang = Angle(-1, -93, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_trainstation/payphone001a.mdl"), offset = Vector(-53, 64, 40) , ang = Angle(-1, -90, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_trainstation/payphone_reciever001a.mdl"), offset = Vector(21, 50, 58) , ang = Angle(9, -160, -57), seq = "idle", mat = "", tag = "phone" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(71, -40, 4) , ang = Angle(0, -90, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/player/group01/male_02.mdl"), offset = Vector(26, 30, 4) , ang = Angle(0, 90, -1), seq = "idle_magic", mat = "", tag = "pr", noanim = true },
		{ mdl = Model( "models/props_junk/garbage_takeoutcarton001a.mdl"), offset = Vector(77, 39, 10) , ang = Angle(-82, -85, 3), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(57, 52, 4) , ang = Angle(-1, -91, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-52, -39, 3) , ang = Angle(0, -90, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/garbage_glassbottle003a.mdl"), offset = Vector(-23, -42, 30) , ang = Angle(-1, -171, 4), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-62, 52, 3) , ang = Angle(0, 89, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_trainstation/bench_indoor001a.mdl"), offset = Vector(-35, -37, 24) , ang = Angle(0, -90, -1), seq = "idle", mat = "" },
	},
	Dialogues = function( sc )
		AddDialogueLine( sc.phone, "*beep*", "'This client is not responding. . .'", "'Please wait few minutes and try again.'" )
		AddDialogueLine( sc.pr, "Where the hell did he go again?" )
		AddDialogueLine( sc.phone, "*beep*" )
		AddDialogueLine( sc.pr, "Carl!" )
		AddDialogueLine( sc.phone, "'This client is not responding. . .'" )
		AddDialogueLine( sc.pr, "*sigh*", "Think. . .", "Maybe he lost his phone.", "Or. . .", "Maybe he is on that ZS server." )
		AddDialogueLine( sc.phone, "*beep*", "'This is Frankie's ZS server!'", "'We are always happy to. . .'", "*chkt*" )
		AddDialogueLine( sc.pr, ". . ." )
		AddDialogueLine( sc.phone, "'What the fuck is wrong with this thing?!'", "'What?. . .Yeah I know. . .'" )
		AddDialogueLine( sc.pr, "Hello?" )
		AddDialogueLine( sc.phone, "'Stop pushing me, you idiot!'", "'. . .Give me that phone!'", "*chkt*", "'Fuck you, Lick. I want to be cool as well!'" )
		AddDialogueLine( sc.pr, "Anyone?" )
		AddDialogueLine( sc.phone, "*chkt*", "'Who is that?!'", "'Stan?! Is that you?!'" )
		AddDialogueLine( sc.pr, "Listen, I just want to ask if. . ." )
		AddDialogueLine( sc.phone, "'This server was taken down!'", "'Now, fuck off!!!'", "*beep*" )
		AddDialogueLine( sc.pr, ". . .", "The hell was that?" )
	end
}

GM.SingleplayerCutscenes["sponsors"] = {
	Act = "ACT 2: DDOS",
	Intro = "2013\nSomewhere outside. . .",
	SoundTrack = 205465270,
	Volume = 45,
	Main = { mdl = Model( "models/hunter/plates/plate4x5.mdl" ), seq = "idle", mat = ""},
	Relative = {
		{ mdl = Model( "models/props_junk/shovel01a.mdl"), offset = Vector(-40, 41, 69) , ang = Angle(-55, 50, 2), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_lab/blastdoor001b.mdl"), offset = Vector(-6, 89, 6) , ang = Angle(-90, 85, -85), seq = "idle", mat = "models/props_pipes/Pipesystem01a_skin3" },
		{ mdl = Model( "models/props/cs_militia/paintbucket01.mdl"), offset = Vector(-34, 117, 47) , ang = Angle(-1, 38, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_c17/paper01.mdl"), offset = Vector(32, 88, 12) , ang = Angle(-1, 67, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_lab/clipboard.mdl"), offset = Vector(18, 65, 87) , ang = Angle(75, 156, 4), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/circularsaw01.mdl"), offset = Vector(-9, 104, 47) , ang = Angle(0, 58, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/caseofbeer01.mdl"), offset = Vector(-11, 88, 47) , ang = Angle(-1, 158, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/weapons/w_rif_ak47.mdl"), offset = Vector(-29, 29, 64) , ang = Angle(-51, -27, 88), seq = "idle", mat = "" },
		{ mdl = Model( "models/weapons/w_rif_ak47.mdl"), offset = Vector(-33, 42, 48) , ang = Angle(0, -125, 88), seq = "idle", mat = "" },
		{ mdl = Model( "models/weapons/w_shot_xm1014.mdl"), offset = Vector(-25, 39, 49) , ang = Angle(1, 32, -81), seq = "idle", mat = "" },
		{ mdl = Model( "models/player/group03/male_06.mdl"), offset = Vector(-27, -63, 10) , ang = Angle(0, 136, 0), seq = "pose_ducking_01", mat = "", tag = "dude" },
		{ mdl = Model( "models/props_c17/tools_wrench01a.mdl"), offset = Vector(-24, -27, 21) , ang = Angle(3, 1, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/player/eli.mdl"), offset = Vector(37, -23, 11) , ang = Angle(0, -180, 0), seq = "pose_standing_01", mat = "", tag = "matthias",  },
		{ mdl = Model( "models/props_vehicles/carparts_wheel01a.mdl"), offset = Vector(-17, -25, 16) , ang = Angle(-1, -153, 89), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_lab/blastdoor001c.mdl"), offset = Vector(-4, 48, 6) , ang = Angle(-90, 100, 80), seq = "idle_closed", mat = "models/props_pipes/Pipesystem01a_skin3" },
		{ mdl = Model( "models/props_lab/blastdoor001c.mdl"), offset = Vector(-109, -42, 6) , ang = Angle(-90, -179, 0), seq = "idle_closed", mat = "models/props_pipes/Pipesystem01a_skin3" },
		{ mdl = Model( "models/props_lab/blastdoor001b.mdl"), offset = Vector(104, -76, 6) , ang = Angle(-90, 87, -87), seq = "idle", mat = "models/props_pipes/Pipesystem01a_skin3" },
		{ mdl = Model( "models/props_c17/tools_pliers01a.mdl"), offset = Vector(-4, -29, 21) , ang = Angle(-2, -28, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/metalgascan.mdl"), offset = Vector(14, 19, 15) , ang = Angle(89, -166, -169), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/de_train/utility_truck.mdl"), offset = Vector(-56, 30, 13) , ang = Angle(-1, 63, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/de_train/utility_truck_windows.mdl"), offset = Vector(-56, 30, 13) , ang = Angle(-2, 66, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/de_train/acunit2.mdl"), offset = Vector(-52, 67, 47) , ang = Angle(0, 63, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/player/group03/male_06.mdl"), offset = Vector(0, 76, 68) , ang = Angle(14, -23, 1), seq = "sit_fist", mat = "" },
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(1, 22, 280) , ang = Angle(89, -168, 0), seq = "Idle", mat = "" },
		{ mdl = Model( "models/props_c17/trappropeller_lever.mdl"), offset = Vector(-17, -28, 22) , ang = Angle(88, 101, 59), seq = "idle", mat = "" },
	},
	Dialogues = function( sc )
		AddDialogueLine( sc.dude, ". . .", "Goddamnit!" )
		AddDialogueLine( sc.matthias, "Goddamnit, indeed!", "Who knew that this thing would weigh so much?" )
		AddDialogueLine( sc.dude, ". . ." )
		AddDialogueLine( sc.matthias, "We don't have all day. . .", "So hurry the fuck up!" )
		AddDialogueLine( sc.dude, "I'm on it, just give me some time.", ". . .", "Where are we heading next?" )
		AddDialogueLine( sc.matthias, "I've been thinking. . .", "Remember that dude, who called us few months ago?" )
		AddDialogueLine( sc.dude, "Barely.", "What was it all about?" )
		AddDialogueLine( sc.matthias, "Power.", "Money.", "Players.", "The stuff that every shitty server owner dreams about." )
		AddDialogueLine( sc.dude, ". . .", "So, why bother us then?" )
		AddDialogueLine( sc.matthias, "Obviously he is lazy as fuck.", "They all are.", ". . .", "But the thing is. . ." )
		AddDialogueLine( sc.dude, "Hm?" )
		AddDialogueLine( sc.matthias, "We can make it work in our favour.", "I think. . .", "I'll explain it later.", "We need to contact that guy first." )
		AddDialogueLine( sc.dude, "Why don't you just call him?" )
		AddDialogueLine( sc.matthias, "I don't like to waste cash on non-important calls.", "Besides. . .", "I bet he has recorded his squeaky\nvoice on the answering machine." )
		AddDialogueLine( sc.dude, "Squeak squeak" )
		AddDialogueLine( sc.matthias, "Yeah.", ". . .", "Are you done yet?" )
		AddDialogueLine( sc.dude, ". . .", "I guess. . .", "But if that fucking wheel pops again. . .", "It's not going to be my fault." )
		AddDialogueLine( sc.matthias, "Yeah, yeah. . .", "Just get to the fucking car.", ". . .", "We have an appointment with a righteous server owner.", ". . .once again." )
	end
}

GM.SingleplayerCutscenes["descent"] = {
	Intro = "Few hours earlier\nCarl's room",
	SoundTrack = 241356191,//194760777,
	//StartFrom = 11000,
	Volume = 35,
	Main = { mdl = Model( "models/hunter/plates/plate5x5.mdl" ), seq = "idle", mat = ""},
	Relative = {
		{ mdl = Model( "models/props_canal/mattpipe.mdl"), offset = Vector(55, 1, 40) , ang = Angle(-60, -176, 80), seq = "idle", mat = "" },
		{ mdl = Model( "models/player/police.mdl"), offset = Vector(44, 9, 11) , ang = Angle(-1, -88, 0), seq = "idle_suitcase", mat = "", tag = "cop" },
		{ mdl = Model( "models/props_junk/cardboard_box001a.mdl"), offset = Vector(-21, 9, 23) , ang = Angle(-4, -50, 1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(10, -10, 3) , ang = Angle(-0, -83, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(34, -33, 9) , ang = Angle(-0, -102, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-97, 104, 3) , ang = Angle(-0, -175, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/metal_paintcan001b.mdl"), offset = Vector(-80, 13, 15) , ang = Angle(89, -124, 94), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/metal_paintcan001a.mdl"), offset = Vector(-87, 2, 16) , ang = Angle(-1, 146, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/garbage_bag001a.mdl"), offset = Vector(-70, -3, 15) , ang = Angle(-1, -102, -2), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-83, 4, 7) , ang = Angle(-1, 83, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(122, -83, 4) , ang = Angle(0, -4, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(9, -110, 4) , ang = Angle(-1, -93, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/shoe001a.mdl"), offset = Vector(-2, -117, 11) , ang = Angle(-1, -122, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/garbage_carboard002a.mdl"), offset = Vector(-52, -97, 6) , ang = Angle(-1, 111, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-94, -95, 4) , ang = Angle(-0, 177, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/garbage_carboard001a.mdl"), offset = Vector(-64, -44, 10) , ang = Angle(0, -177, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/shoe001a.mdl"), offset = Vector(-7, -108, 9) , ang = Angle(0, 56, 78), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(75, 68, 9) , ang = Angle(-4, -10, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(127, 42, 3) , ang = Angle(3, -4, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/cardboard_box002a.mdl"), offset = Vector(6, 36, 22) , ang = Angle(3, 40, -5), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_c17/tv_monitor01.mdl"), offset = Vector(0, 29, 43) , ang = Angle(-4, -49, -5), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/garbage128_composite001a.mdl"), offset = Vector(66, 51, 15) , ang = Angle(0, -131, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_interiors/pot01a.mdl"), offset = Vector(90, -32, 31) , ang = Angle(-1, -76, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/cardboard_box003a.mdl"), offset = Vector(89, -25, 22) , ang = Angle(-1, -163, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_c17/furniturechair001a_chunk02.mdl"), offset = Vector(115, -70, 15) , ang = Angle(-1, -87, -42), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_c17/furniturechair001a_chunk01.mdl"), offset = Vector(107, -48, 16) , ang = Angle(-90, -104, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_c17/furniturearmchair001a.mdl"), offset = Vector(90, -97, 55) , ang = Angle(0, 101, -90), seq = "idle", mat = "" },
		{ mdl = Model( "models/player/hostage/hostage_04.mdl"), offset = Vector(39, -80, 16) , ang = Angle(-1, 135, 8), seq = "zombie_slump_idle_02", mat = "", tag = "carl" },
		{ mdl = Model( "models/props_interiors/furniture_lamp01a.mdl"), offset = Vector(12, -84, 40) , ang = Angle(-0, 134, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(29, -25, 281) , ang = Angle(88, -177, -1), seq = "Idle", mat = "" },
		{ mdl = Model( "models/player/breen.mdl"), offset = Vector(-13, -26, 10) , ang = Angle(0, -25, 0), seq = "pose_standing_01", mat = "", tag = "owner" },
		{ mdl = Model( "models/props_c17/canister01a.mdl"), offset = Vector(-1, -1, 37) , ang = Angle(6, 50, -36), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(17, 84, 3) , ang = Angle(-0, 97, -1), seq = "idle", mat = "" },
	},
	Dialogues = function( sc )
		AddDialogueLine( sc.owner, "Caaaaarl!", "Ohhh, caaaaaaarl!" )
		AddDialogueLine( sc.cop, ". . .", "Damn. . .", ". . .that's creepy, boss." )
		AddDialogueLine( sc.owner, "Oh yeah.", ". . .", "Can you hear me, carl?", "Do you want to try some new addons?", ". . .", "Hmmmmmmm?", "Fresh paid addons!", "Yummy!" )
		AddDialogueLine( sc.cop, ". . ." )
		AddDialogueLine( sc.owner, "What did you say, carl?", ". . .", "'Yes, I do!'?", "Is that right, caaaarl?" )
		AddDialogueLine( sc.cop, "Yup, that's what I heard too!" )
		AddDialogueLine( sc.owner, "Good!", "Very good!", ". . .", "And you are totally fine with all\npossible side-effects?", ". . .", "What was that?" )
		AddDialogueLine( sc.cop, "I think he said: 'Absolutely fine!'" )
		AddDialogueLine( sc.owner, "Good boy, Carl!", ". . .", "Now you will feel a little prick. . .", ". . .", ". . .so you can. . .]&^AD675A%&GD*AD. . . " )
		AddDialogueLine( sc.cop, "*^(A&DHADshA*SDkj*^%$%h", ". . ." )
		AddDialogueAction( sc.owner, function( me ) surface.PlaySound( "ambient/levels/prison/inside_battle_zombie2.wav" ) end )
		AddDialogueLine( sc.owner, "&^%ADjlks**&56s" )
		AddDialogueAction( sc.cop, function( me ) surface.PlaySound( "ambient/levels/prison/inside_battle_zombie3.wav" ) end )
	end,
}

GM.SingleplayerCutscenes["the bottom"] = {
	Intro = "2013\nBottom of the server browser. . .",
	SoundTrack = 241356191,//194760777,
	//StartFrom = 11000,
	Volume = 35,
	Main = { mdl = Model( "models/hunter/plates/plate4x4.mdl" ), seq = "idle", mat = ""},
	Relative = {
		{ mdl = Model( "models/player/police.mdl"), offset = Vector(4, -84, 6) , ang = Angle(0, 18, -1), seq = "idle_suitcase", mat = "", tag = "cop" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-86, 38, 3) , ang = Angle(0, -180, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/gibs/hgibs.mdl"), offset = Vector(123, 26, 8) , ang = Angle(2, -47, -1), seq = "idle1", mat = "" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(68, -72, 3) , ang = Angle(0, -90, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/weapons/w_pist_usp_silencer.mdl"), offset = Vector(90, -62, 6) , ang = Angle(-2, 11, 91), seq = "idle", mat = "" },
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(46, -29, 302) , ang = Angle(89, 125, 0), seq = "Idle", mat = "" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-55, -72, 3) , ang = Angle(0, -90, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_vehicles/van001a_physics.mdl"), offset = Vector(-71, -16, 39) , ang = Angle(-1, -107, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(97, 33, 3) , ang = Angle(0, 0, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/de_train/pallet_barrels.mdl"), offset = Vector(111, 66, 5) , ang = Angle(0, -67, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(5, 34, 3) , ang = Angle(0, 0, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/garbage_bag001a.mdl"), offset = Vector(60, 30, 13) , ang = Angle(-9, -134, 82), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/garbage256_composite002b.mdl"), offset = Vector(36, -37, 8) , ang = Angle(0, -83, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/player/breen.mdl"), offset = Vector(28, -23, 7) , ang = Angle(-1, -45, -1), seq = "pose_standing_02", mat = "", tag = "owner" },
		{ mdl = Model( "models/props_interiors/pot02a.mdl"), offset = Vector(74, 43, 9) , ang = Angle(-1, -123, -2), seq = "idle", mat = "" },
	},
	Dialogues = function( sc )
		AddDialogueLine( sc.cop, ". . ." )
		AddDialogueLine( sc.owner, "Here we are.", ". . .", "At least I hope so." )
		AddDialogueLine( sc.cop, ". . .", "So, uh. . .", "Why are we here?" )
		AddDialogueLine( sc.owner, "Well. . .", "That sponsor guy told me about some stuff." )
		AddDialogueLine( sc.cop, "Some stuff?" )
		AddDialogueLine( sc.owner, "Yeah. . .", "Some toxic shit, that CoderFired keeps here.", ". . .", "Apparently we can use these to destroy servers." )
		AddDialogueLine( sc.cop, "Terrifying. . ." )
		AddDialogueLine( sc.owner, "Except we have to clean up this place first.", ". . .", "He will wait for us in the car nearby.", "And contact us, when we are done, of course." )
		AddDialogueLine( sc.cop, ". . .", "That guy has a lot of shit in his truck.", "Why wont he just do it himself?" )
		AddDialogueLine( sc.owner, "No fucking idea!" )
		AddDialogueLine( sc.owner, ". . .", "Did you hear that?" )
		AddDialogueAction( sc.owner, function( me ) surface.PlaySound( "ambient/creatures/town_muffled_cry1.wav" ) end )
		AddDialogueLine( sc.cop, ". . .", "What?" )
		AddDialogueLine( sc.owner, "Nevermind. . .", "This place is creepy as shit.", ". . .", "So let's just get over with it." )
		AddDialogueLine( sc.cop, ". . ." )
	end
}

GM.SingleplayerCutscenes["devnull"] = {
	Intro = "2013\nOutside of \"Happy Torturer\" factory",
	SoundTrack = 95416884,
	Volume = 40,
	Main = { mdl = Model( "models/hunter/plates/plate5x5.mdl" ), seq = "idle", mat = ""},
	Relative = {
		{ mdl = Model( "models/player/group01/male_02.mdl"), offset = Vector(24, 16, 16) , ang = Angle(-1, -180, 0), seq = "idle_suitcase", mat = "", tag = "pr" },
		{ mdl = Model( "models/props_debris/rebar002c_64.mdl"), offset = Vector(-19, 96, 24) , ang = Angle(68, 135, -58), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_assault/handtruck.mdl"), offset = Vector(-95, -80, 15) , ang = Angle(0, 118, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/de_nuke/floodlight.mdl"), offset = Vector(-51, -38, 20) , ang = Angle(28, 134, -180), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_debris/plaster_floorpile001a.mdl"), offset = Vector(-60, 92, 24) , ang = Angle(0, -4, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_assault/nostopssign.mdl"), offset = Vector(-23, 116, 16) , ang = Angle(-2, -91, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_assault/streetsign01.mdl"), offset = Vector(141, 118, 14) , ang = Angle(0, 0, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_assault/barrelwarning.mdl"), offset = Vector(32, 106, 18) , ang = Angle(0, -135, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_debris/walldestroyed02a.mdl"), offset = Vector(-59, -56, 8) , ang = Angle(0, -1, -91), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_debris/walldestroyed02a.mdl"), offset = Vector(-38, 66, 8) , ang = Angle(0, -180, -91), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_debris/walldestroyed03a.mdl"), offset = Vector(91, -5, 7) , ang = Angle(-1, -90, -90), seq = "", mat = "" },
		{ mdl = Model( "models/props/cs_assault/washer_box2.mdl"), offset = Vector(-87, -97, 19) , ang = Angle(0, 28, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_assault/forklift.mdl"), offset = Vector(111, -70, 18) , ang = Angle(0, -66, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(17, 7, 296) , ang = Angle(88, -140, -2), seq = "Idle", mat = "" },
		{ mdl = Model( "models/props/cs_assault/meter.mdl"), offset = Vector(-26, -61, 16) , ang = Angle(0, 0, 0), seq = "idle", mat = "" },
	},
	Dialogues = function( sc )
		AddDialogueLine( sc.pr, ". . .", "Well. . ." )
		AddDialogueLine( sc.pr, "That note better be correct about the address." )
		AddDialogueLine( sc.pr, ". . .", "I guess. . .", ". . .I'll have to go inside.", ". . .", "Instead of talking to myself." )
		AddDialogueLine( sc.pr, ". . .", "Here I come, then!" )
	end
}

GM.SingleplayerCutscenes["fanboys"] = {
	Act = "ACT 3: PRIDE",
	Intro = "2013\n\"Stay Rusty\" bar",
	SoundTrack = 142830412,
	Volume = 30,
	//StartFrom = 60000,
	Main = { mdl = Model( "models/hunter/plates/plate8x8.mdl" ), seq = "idle", mat = ""},
	Relative = {
		{ mdl = Model( "models/props/cs_militia/axe.mdl"), offset = Vector(6, -26, 45) , ang = Angle(48, 149, -94), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/caseofbeer01.mdl"), offset = Vector(-170, 82, 7) , ang = Angle(0, 86, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/shovel01a.mdl"), offset = Vector(-42, -117, 38) , ang = Angle(-22, 72, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/urine_trough.mdl"), offset = Vector(-54, -37, 33) , ang = Angle(-0, -91, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_c17/tv_monitor01.mdl"), offset = Vector(-33, -18, 60) , ang = Angle(-1, -11, -1), seq = "idle", mat = "", tag = "tv" },
		{ mdl = Model( "models/props/cs_militia/caseofbeer01.mdl"), offset = Vector(-76, -22, 51) , ang = Angle(0, 50, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/garbage_metalcan001a.mdl"), offset = Vector(-80, 56, 9) , ang = Angle(-28, 40, -91), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/bottle02.mdl"), offset = Vector(-11, 51, 51) , ang = Angle(-0, 90, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/garbage_plasticbottle002a.mdl"), offset = Vector(-80, 9, 16) , ang = Angle(-23, 72, -2), seq = "idle", mat = "" },
		{ mdl = Model( "models/player/odessa.mdl"), offset = Vector(-56, 43, 13) , ang = Angle(-1, -1, 1), seq = "pose_standing_01", mat = "", tag = "barguy" },
		{ mdl = Model( "models/props/cs_militia/bar01.mdl"), offset = Vector(-44, 30, 7) , ang = Angle(-1, -91, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/barstool01.mdl"), offset = Vector(27, 35, 7) , ang = Angle(-0, -91, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/barstool01.mdl"), offset = Vector(25, 5, 2) , ang = Angle(-1, -86, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/player/group03/male_09.mdl"), offset = Vector(27, 3, 41) , ang = Angle(25, 175, 9), seq = "sit_fist", mat = "", tag = "axeguy" },
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(12, 9, 277) , ang = Angle(89, 138, 0), seq = "Idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/food_stack.mdl"), offset = Vector(-158, 176, 7) , ang = Angle(-0, 83, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/housefence_door.mdl"), offset = Vector(-221, 196, 5) , ang = Angle(-90, -180, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/fertilizer.mdl"), offset = Vector(-126, 71, 7) , ang = Angle(-1, 175, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/garbage_bag001a.mdl"), offset = Vector(5, -102, 12) , ang = Angle(-1, -31, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/housefence.mdl"), offset = Vector(86, -26, 5) , ang = Angle(-90, -1, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/footlocker01_closed.mdl"), offset = Vector(15, -147, 19) , ang = Angle(-1, 89, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/housefence_door.mdl"), offset = Vector(-123, -190, 5) , ang = Angle(-90, 179, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/housefence.mdl"), offset = Vector(-17, -32, 5) , ang = Angle(-90, -180, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/housefence.mdl"), offset = Vector(87, -37, 5) , ang = Angle(-90, 179, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/garbage128_composite001a.mdl"), offset = Vector(97, -173, 11) , ang = Angle(-0, -71, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/housefence.mdl"), offset = Vector(-122, 19, 6) , ang = Angle(-90, -180, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/logpile2.mdl"), offset = Vector(-81, -126, 7) , ang = Angle(-1, -92, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/housefence.mdl"), offset = Vector(-226, -18, 6) , ang = Angle(-90, 179, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/boxes_garage_lower.mdl"), offset = Vector(-170, -96, 7) , ang = Angle(-1, -136, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/newspaperstack01.mdl"), offset = Vector(-134, -86, 7) , ang = Angle(-1, -21, -2), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/food_stack.mdl"), offset = Vector(-154, -13, 7) , ang = Angle(-1, -91, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/housefence.mdl"), offset = Vector(-122, -10, 5) , ang = Angle(-90, -2, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/barstool01.mdl"), offset = Vector(33, -53, 14) , ang = Angle(87, -59, 10), seq = "idle", mat = "" },
		{ mdl = Model( "models/player/group02/male_06.mdl"), offset = Vector(-93, -103, 33) , ang = Angle(85, -38, 127), seq = "sit_camera", mat = "" },
		{ mdl = Model( "models/props/cs_militia/refrigerator01.mdl"), offset = Vector(-112, 27, 7) , ang = Angle(0, -1, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/gun_cabinet.mdl"), offset = Vector(-104, 111, 7) , ang = Angle(-1, -1, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/bar01.mdl"), offset = Vector(-59, 154, 7) , ang = Angle(-1, -1, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/housefence.mdl"), offset = Vector(-19, 25, 5) , ang = Angle(-90, -2, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/caseofbeer01.mdl"), offset = Vector(-61, 187, 51) , ang = Angle(-1, -4, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/circularsaw01.mdl"), offset = Vector(-42, 185, 51) , ang = Angle(-0, 34, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/stove01.mdl"), offset = Vector(-111, 70, 25) , ang = Angle(-1, -4, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_office/phone_p1.mdl"), offset = Vector(-118, 184, 51) , ang = Angle(-0, -108, 0), seq = "only_sequence", mat = "" },
		{ mdl = Model( "models/props/cs_militia/paintbucket01.mdl"), offset = Vector(4, 202, 6) , ang = Angle(-1, 7, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/housefence_door.mdl"), offset = Vector(88, 184, 5) , ang = Angle(-90, -2, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/barstool01.mdl"), offset = Vector(40, 160, 11) , ang = Angle(-46, 1, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/barstool01.mdl"), offset = Vector(37, 89, 14) , ang = Angle(-2, -39, -88), seq = "idle", mat = "" },
		{ mdl = Model( "models/player/group02/male_04.mdl"), offset = Vector(105, 141, 8) , ang = Angle(-0, -179, 0), seq = "zombie_slump_idle_01", mat = "" },
		{ mdl = Model( "models/props/cs_militia/housefence.mdl"), offset = Vector(189, 29, 6) , ang = Angle(-90, -1, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/garbage_carboard002a.mdl"), offset = Vector(152, 152, 7) , ang = Angle(-1, 24, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/wood_table.mdl"), offset = Vector(128, 53, 7) , ang = Angle(-1, -92, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/garbage_metalcan001a.mdl"), offset = Vector(131, 69, 40) , ang = Angle(-0, -25, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/garbage_metalcan002a.mdl"), offset = Vector(134, 63, 40) , ang = Angle(-1, -1, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/bottle01.mdl"), offset = Vector(136, 31, 39) , ang = Angle(-19, 65, -90), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/wood_bench.mdl"), offset = Vector(158, 69, 7) , ang = Angle(-1, -80, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/garbage256_composite002b.mdl"), offset = Vector(136, -4, 10) , ang = Angle(-1, 3, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/player/hostage/hostage_03.mdl"), offset = Vector(153, -23, 7) , ang = Angle(-1, 170, 0), seq = "idle_all_scared", mat = "", tag = "weird", hide = true },
		{ mdl = Model( "models/props/cs_militia/wood_bench.mdl"), offset = Vector(154, -83, 6) , ang = Angle(-1, 74, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/wood_table.mdl"), offset = Vector(110, -84, 6) , ang = Angle(-1, 67, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/garbage_glassbottle003a.mdl"), offset = Vector(117, -66, 38) , ang = Angle(19, 10, -91), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/garbage_plasticbottle002a.mdl"), offset = Vector(103, -76, 44) , ang = Angle(-5, -74, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/garbage_newspaper001a.mdl"), offset = Vector(104, -102, 37) , ang = Angle(-0, -84, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_office/radio.mdl"), offset = Vector(-106, 41, 83) , ang = Angle(-2, 156, -1), seq = "only_sequence", mat = "" },
		{ mdl = Model( "models/props_c17/metalpot002a.mdl"), offset = Vector(-19, 82, 53) , ang = Angle(-1, -20, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_office/trash_can_p5.mdl"), offset = Vector(133, 156, -4) , ang = Angle(28, 4, 1), seq = "only_sequence", mat = "" },
		{ mdl = Model( "models/props/cs_militia/toilet.mdl"), offset = Vector(-127, -111, 7) , ang = Angle(0, -1, -1), seq = "idle", mat = "" },
	},
	Dialogues = function( sc )
		AddDialogueLine( sc.barguy, ". . ." )
		AddDialogueLine( sc.axeguy, ". . ." )
		AddDialogueLine( sc.barguy, "Dude, it's been a while since you've been outside.", ". . .", "Is it really that bad?" )
		AddDialogueLine( sc.axeguy, ". . .", "Yeah. . .", "The weather is going nuts as well." )
		AddDialogueLine( sc.barguy, ". . .", "I heard it has to do something\nwith the broken weather mod.", ". . .", "Either creator abandoned it. . .", "Or he started to sell it,\ninstead of fixing the older version." )
		AddDialogueLine( sc.barguy, ". . ." )
		AddDialogueLine( sc.axeguy, "That's one more reason to not to go outside. . ." )
		AddDialogueLine( sc.barguy, "Wonder if tv still works. . ." )
		AddDialogueLine( sc.tv, "*chtk*", "hGdSGgfS5rIADDh;as", "*chkt*" )
		AddDialogueLine( sc.tv, "'What's up my little slaves???!!!!'", "'This is LetsTortureGMod. . .'", "'. . .in the second season of\n\"The second torturing of GMod\" show!'" )
		AddDialogueLine( sc.axeguy, ". . .", "How is this piece of shit still not banned from GMod?" )
		AddDialogueLine( sc.barguy, ". . .", "No idea.", ". . .", "But kids love attention whores." )
		AddDialogueLine( sc.tv, "'. . .the rules are simple! You record something funny. . .'" )
		AddDialogueLine( sc.axeguy, "You'd better turn this shit off.", "Before I do. . ." )
		AddDialogueLine( sc.tv, "'. . .a chance to spend a night in the bed with me!!!'", "'. . .as always, remember to lick and suckscribe for more. . .'" )
		AddDialogueLine( sc.barguy, "Fine. . ." )
		AddDialogueLine( sc.tv, "*chkt*" )
		AddDialogueLine( sc.barguy, ". . .", "It's kinda shitty that other channels don't work anymore.", ". . .", "Back in my days there used to be some good machinimas." )
		AddDialogueLine( sc.axeguy, ". . .", "You still have this channel full of bear porn. . ." )
		AddDialogueLine( sc.barguy, "Oh, fuck you.", "It's not even funny!" )
		AddDialogueLine( sc.barguy, ". . ." )
		AddDialogueAction( sc.weird, function( me ) me.Hide = false surface.PlaySound( "doors/wood_move1.wav" ) end )
		AddDialogueLine( sc.barguy, "Look at that. . ." )
		AddDialogueLine( sc.weird, ". . .", "Dudes. . .", "Dudes!!!" )
		AddDialogueLine( sc.barguy, ". . ." )
		AddDialogueLine( sc.axeguy, ". . ." )
		AddDialogueLine( sc.barguy, "What's wrong?" )
		AddDialogueLine( sc.weird, "There are some fucked up kids outside. . .", ". . .", "They. . ." )
		AddDialogueLine( sc.barguy, ". . ." )
		AddDialogueLine( sc.weird, "They are trying to fuck someone's car. . ." )
		AddDialogueLine( sc.barguy, "A car?" )
		AddDialogueLine( sc.axeguy, ". . ." )
		AddDialogueLine( sc.weird, "Yeah. . .", "The black one, I thi. . ." )
		AddDialogueLine( sc.axeguy, "Oh, fucking hell!!!", "I'm going outside!" )
		AddDialogueLine( sc.barguy, "Dude, wait. . " )
	end
}

GM.SingleplayerCutscenes["backstab"] = {
	Intro = "2013\nSomewhere on a highway. . .",
	SoundTrack = 142830412,
	Volume = 30,
	Main = { mdl = Model( "models/hunter/plates/plate2x2.mdl" ), seq = "idle", mat = ""},
	Relative = {
		{ mdl = Model( "models/props_phx/huge/road_medium.mdl"), offset = Vector(-45, 191, 1) , ang = Angle(-1, -1, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(-11, 13, 370) , ang = Angle(89, -178, 3), seq = "Idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/axe.mdl"), offset = Vector(-4, 19, 69) , ang = Angle(5, 86, 2), seq = "idle", mat = "", hide = true, tag = "axe" },
		{ mdl = Model( "models/props/de_nuke/car_nuke_animation.mdl"), offset = Vector(-18, 20, 6) , ang = Angle(-1, 0, -1), seq = "idle", mat = "", skin = 2, shake = true },
		{ mdl = Model( "models/props_lab/reciever01d.mdl"), offset = Vector(-17, 59, 58) , ang = Angle(-1, -90, 0), seq = "idle", mat = "", tag = "radio", hide = true },
		{ mdl = Model( "models/player/group03/male_09.mdl"), offset = Vector(-30, 21, 68) , ang = Angle(0, 81, -3), seq = "idle", mat = "", hide = true, tag = "axeguy" },
		{ mdl = Model( "models/props_junk/popcan01a.mdl"), offset = Vector(0, -68, 16) , ang = Angle(89, -87, 7), seq = "idle", mat = "", tag = "ex", shake = true }
	},
	Dialogues = function( sc )
		sc.ex.OnDraw = function()
			if sc.Emitter then
				sc.ex.NextPuff = sc.ex.NextPuff or 0
				if sc.ex.NextPuff < CurTime() then
					local particle = sc.Emitter:Add( "particles/smokey", sc.ex:GetPos() )
					particle:SetVelocity(math.Rand(0.1, 0.7)*Vector( 0, -340, 0 )+VectorRand()*2+vector_up*math.random(10))
					particle:SetDieTime(math.Rand(0.5, 1))
					particle:SetStartAlpha(100)
					particle:SetEndAlpha(0)
					particle:SetStartSize(math.random(2,4))
					particle:SetEndSize(math.random(6,13))
					particle:SetRoll(math.Rand(-180, 180))
					particle:SetColor(100, 100, 100)
					particle:SetAirResistance(15)
					sc.ex.NextPuff = CurTime() + math.Rand( 0, 0.09 )
				end
			end
		end
		AddDialogueLine( sc.axeguy, ". . ." )
		AddDialogueLine( sc.radio, "*bzzzz*", ". . .reported that unknown server owner. . .", ". . .found dead at the bottom of. . ." )
		AddDialogueLine( sc.radio, "*bzzzzzzzzz*", ". . .acts of violence for past few months have been. . .", ". . .instead of commenting, garry told them to fuck off. . ." )
		AddDialogueLine( sc.radio, "*bzzzzzz*" )
		AddDialogueLine( sc.axeguy, "Where the fuck are you hiding. . ." )
		AddDialogueLine( sc.radio, "*bzzzzzzz*", ". . .fans of the famous youtuber 'LetsTortureGMod'\nwere brutally murdered this morning. . ." )
		AddDialogueLine( sc.radio, "*bzzzz*", ". . .it appears that he didn't really care,\nduring the interview. . .", ". . .oh his way to CustomGaming's TTT server. . ." )
		AddDialogueLine( sc.axeguy, "A TTT server. . .", ". . .", "I'm coming for you, you fuck. . .", "So enjoy your 'funny' RDMing while you can. . ." )
		AddDialogueLine( sc.radio, "*bzzzzzz*", ". . .as for the weather. . .", ". . .rainy with a bits of LetsTortureGMod. . ." )
		AddDialogueLine( sc.axeguy, ". . ." )
		AddDialogueLine( sc.radio, "*bzzzzzz*", ". . .so you'd better check your settings and. . ." )
		AddDialogueLine( sc.radio, "*bzzzzzzzzzzzzzzzzzzzz*" )
		AddDialogueLine( sc.axe, "Funny RDMing, you say. . ." )
		AddDialogueLine( sc.axeguy, "Oh for fucks sake. . .", "Not this talking axe shit again." )
		AddDialogueLine( sc.axe, "That was a one funny rdming back in the garage. . ." )
		AddDialogueLine( sc.axeguy, "Shut up!", ". . ." )
		AddDialogueLine( sc.radio, "*bzzzzzz*" )
		AddDialogueLine( sc.axe, "Do you even know what you're gonna do. . .", ". . .once you find that youtuber?" )
		AddDialogueLine( sc.axeguy, ". . ." )
		AddDialogueLine( sc.axe, "Do you expect people will appreciate it, if you stop\nincome of retarded kids from flooding this game?" )
		AddDialogueLine( sc.axeguy, "I said: Shut up!" )
		AddDialogueLine( sc.radio, "*bzzzzzz*", "And now switching back to your playlist. . ." )
		AddDialogueLine( sc.axe, "If players are gone. . .", ". . .server owners will have noone to feast upon. . ." )
		AddDialogueLine( sc.axeguy, ". . ." )
		AddDialogueLine( sc.axeguy, "There it is. . .", "CustomGaming TTT server. . .", "This fucker better be here." )
		AddDialogueLine( sc.radio, "*bzzzzzz*", "And now playing 'Enthusiasm' by Sulumi. . ." )
		
	end
}


GM.SingleplayerCutscenes["whistleblower"] = {
	Intro = "2013\n\"24/7 GASSTASTION | NEED CUSTOMERS | M9K\"",
	SoundTrack = 142830412,
	Volume = 30,
	Main = { mdl = Model( "models/hunter/plates/plate3x3.mdl" ), seq = "idle", mat = ""},
	Relative = {
		{ mdl = Model( "models/props_debris/walldestroyed03a.mdl"), offset = Vector(-70, -5, 12) , ang = Angle(0, -89, 89), seq = "", mat = "" },
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(1, 28, 313) , ang = Angle(89, -135, -1), seq = "Idle", mat = "" },
		{ mdl = Model( "models/props_wasteland/prison_throwswitchlever001.mdl"), offset = Vector(26, 8, 69) , ang = Angle(-60, -93, -2), seq = "idle", mat = "" },
		{ mdl = Model( "models/player/group03/male_09.mdl"), offset = Vector(18, 34, 20) , ang = Angle(0, -170, 1), seq = "pose_standing_02", mat = "", tag = "axeguy"  },
		{ mdl = Model( "models/props_debris/walldestroyed03a.mdl"), offset = Vector(58, 14, 12) , ang = Angle(0, 91, 90), seq = "", mat = "" },
		{ mdl = Model( "models/props_c17/paper01.mdl"), offset = Vector(-35, 74, 63) , ang = Angle(7, 22, -7), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_lab/reciever01d.mdl"), offset = Vector(-60, 55, 65) , ang = Angle(-2, -88, 1), seq = "idle", mat = "", tag = "radio", hide = true },
		{ mdl = Model( "models/props_c17/handrail04_medium.mdl"), offset = Vector(65, 65, 38) , ang = Angle(0, 0, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_c17/handrail04_brokenlong.mdl"), offset = Vector(66, -44, 40) , ang = Angle(-2, -179, 1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_canal/mattpipe.mdl"), offset = Vector(8, -42, 44) , ang = Angle(-18, 104, -76), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_wasteland/prison_pipefaucet001a.mdl"), offset = Vector(-10, -47, 52) , ang = Angle(-5, 90, 41), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/de_nuke/car_nuke_animation.mdl"), offset = Vector(-56, 12, 19) , ang = Angle(0, 1, 0), seq = "idle", mat = "", skin = 2 },
		{ mdl = Model( "models/props_wasteland/gaspump001a.mdl"), offset = Vector(24, -19, 18) , ang = Angle(-1, -180, -1), seq = "idle", mat = "" },
	},
	Dialogues = function( sc )
		AddDialogueLine( sc.axeguy, ". . ." )
		AddDialogueLine( sc.radio, "*bzzzz*", ". . .and we are back with more custom news. . .", "*dubstep music as 'news' logo fades in*" )
		AddDialogueLine( sc.radio, "A huge crowd of people outside of CoderFired's office. . .", ". . .yelling and demanding to stop the 'shady' business. . ." )
		AddDialogueLine( sc.radio, "*bzzzzzzz*", ". . .a self-proclaimed investigator\nkeeps searching for evidence. . .", ". . .when we asked about his opinion, he said. . ." )
		AddDialogueLine( sc.radio, "*bzzzz*", "'I know what they did. . .'", "'They think they can get away with it!'", "'But it seems there is only one option left. . .'" )
		AddDialogueLine( sc.radio, "'I'll have to put them. . .'" )
		AddDialogueLine( sc.radio, "*puts on sunglasses*" )
		AddDialogueAction( sc.radio, function( me ) surface.PlaySound( "weapons/shotgun/shotgun_cock.wav" ) end )
		AddDialogueLine( sc.radio, "'. . .on watch!'" )
		AddDialogueLine( sc.radio, "*bzzzz*", ". . .with these words he rocketed through the roof. . ." )
		AddDialogueLine( sc.radio, "*bzzzz*", ". . .the famous LetsTortureGMod is still travelling\nacross gmod servers. . ." )
		AddDialogueLine( sc.axeguy, ". . ." )
		AddDialogueLine( sc.radio, ". . .was seen at '3-year old gaming' a hour ago. . .", ". . .but it seems like. . ." )
		AddDialogueLine( sc.axeguy, "Third time better be a fucking charm!" )
	end
}


GM.SingleplayerCutscenes["clickbait"] = {
	Intro = "2013\n\"Stay Rusty\" bar",
	SoundTrack = 142830412,
	Volume = 30,
	Main = { mdl = Model( "models/hunter/plates/plate8x8.mdl" ), seq = "idle", mat = ""},
	Relative = {
		{ mdl = Model( "models/props/cs_militia/toilet.mdl"), offset = Vector(-128, -111, 7) , ang = Angle(0, 0, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_office/phone_p1.mdl"), offset = Vector(-117, 185, 51) , ang = Angle(-0, -108, 0), seq = "only_sequence", mat = "" },
		{ mdl = Model( "models/props/cs_office/trash_can_p5.mdl"), offset = Vector(133, 157, -4) , ang = Angle(28, 4, 1), seq = "only_sequence", mat = "" },
		{ mdl = Model( "models/props/cs_militia/axe.mdl"), offset = Vector(85, 61, 36) , ang = Angle(80, 85, 156), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/housefence_door.mdl"), offset = Vector(-222, 196, 5) , ang = Angle(-90, -180, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/fertilizer.mdl"), offset = Vector(-126, 71, 7) , ang = Angle(-1, 175, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/caseofbeer01.mdl"), offset = Vector(-170, 81, 7) , ang = Angle(0, 85, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/housefence.mdl"), offset = Vector(-122, -10, 5) , ang = Angle(-90, -1, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/food_stack.mdl"), offset = Vector(-158, 176, 7) , ang = Angle(-0, 83, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(63, 19, 290) , ang = Angle(89, 132, 0), seq = "Idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/barstool01.mdl"), offset = Vector(54, 6, 13) , ang = Angle(87, -128, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/circularsaw01.mdl"), offset = Vector(113, 169, 6) , ang = Angle(-1, 32, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/garbage_carboard002a.mdl"), offset = Vector(152, 152, 7) , ang = Angle(-1, 24, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_office/trash_can_p8.mdl"), offset = Vector(170, 156, 1) , ang = Angle(43, 153, -51), seq = "only_sequence", mat = "" },
		{ mdl = Model( "models/props/cs_militia/wood_bench.mdl"), offset = Vector(131, 122, 24) , ang = Angle(-1, -19, 179), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/barstool01.mdl"), offset = Vector(36, 90, 13) , ang = Angle(0, -40, -88), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/wood_table.mdl"), offset = Vector(42, 105, 52) , ang = Angle(8, 173, -179), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/barstool01.mdl"), offset = Vector(59, 131, 13) , ang = Angle(-1, -108, 87), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/barstool01.mdl"), offset = Vector(40, 160, 11) , ang = Angle(-46, 1, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/housefence_door.mdl"), offset = Vector(89, 184, 5) , ang = Angle(-90, -1, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/paintbucket01.mdl"), offset = Vector(5, 202, 6) , ang = Angle(-1, 7, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/caseofbeer01.mdl"), offset = Vector(-61, 187, 51) , ang = Angle(-1, -5, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/bar01.mdl"), offset = Vector(-59, 154, 7) , ang = Angle(-1, 0, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/housefence.mdl"), offset = Vector(-18, 25, 5) , ang = Angle(-90, -1, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/gun_cabinet.mdl"), offset = Vector(-104, 111, 7) , ang = Angle(-1, -2, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/garbage_metalcan001a.mdl"), offset = Vector(-80, 57, 9) , ang = Angle(-28, 39, -91), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/garbage_plasticbottle002a.mdl"), offset = Vector(-79, 9, 16) , ang = Angle(-23, 72, -2), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/garbage_newspaper001a.mdl"), offset = Vector(2, -74, 7) , ang = Angle(0, -119, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/player/odessa.mdl"), offset = Vector(25, 31, 4) , ang = Angle(1, -1, 1), seq = "zombie_slump_idle_02", mat = "", tag = "barguy" },
		{ mdl = Model( "models/props_junk/shovel01a.mdl"), offset = Vector(-37, -15, 53) , ang = Angle(-87, 153, -158), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/urine_trough.mdl"), offset = Vector(-55, -38, 33) , ang = Angle(-0, -91, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/bar01.mdl"), offset = Vector(-43, 31, 7) , ang = Angle(-1, -91, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/housefence.mdl"), offset = Vector(-123, 19, 6) , ang = Angle(-90, -180, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/caseofbeer01.mdl"), offset = Vector(-50, -82, 13) , ang = Angle(0, -41, -90), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/garbage_bag001a.mdl"), offset = Vector(5, -103, 12) , ang = Angle(-1, -31, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/footlocker01_closed.mdl"), offset = Vector(31, -131, 18) , ang = Angle(-90, -136, -163), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/garbage_plasticbottle002a.mdl"), offset = Vector(44, -97, 7) , ang = Angle(-89, -170, -132), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/housefence.mdl"), offset = Vector(-18, -31, 5) , ang = Angle(-90, -180, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/garbage_metalcan002a.mdl"), offset = Vector(57, -62, 8) , ang = Angle(24, 98, -90), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/barstool01.mdl"), offset = Vector(33, -54, 14) , ang = Angle(87, -60, 9), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_office/radio.mdl"), offset = Vector(4, -87, 11) , ang = Angle(-74, -27, -142), seq = "only_sequence", mat = "" },
		{ mdl = Model( "models/props/cs_militia/housefence.mdl"), offset = Vector(86, -26, 5) , ang = Angle(-90, -1, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/garbage256_composite002b.mdl"), offset = Vector(135, -4, 10) , ang = Angle(-1, 2, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_c17/metalpot002a.mdl"), offset = Vector(75, 25, 7) , ang = Angle(0, -44, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/housefence.mdl"), offset = Vector(188, 29, 6) , ang = Angle(-90, -1, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/wood_table.mdl"), offset = Vector(82, -102, 37) , ang = Angle(-2, 79, 172), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/wood_bench.mdl"), offset = Vector(141, -23, 28) , ang = Angle(3, 74, 177), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/housefence.mdl"), offset = Vector(87, -37, 5) , ang = Angle(-90, 179, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/garbage128_composite001a.mdl"), offset = Vector(97, -174, 11) , ang = Angle(-0, -72, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/logpile2.mdl"), offset = Vector(-81, -126, 7) , ang = Angle(-1, -91, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/housefence_door.mdl"), offset = Vector(-124, -190, 5) , ang = Angle(-90, 179, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/housefence.mdl"), offset = Vector(-226, -18, 6) , ang = Angle(-90, 179, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/boxes_garage_lower.mdl"), offset = Vector(-170, -97, 7) , ang = Angle(-1, -136, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/food_stack.mdl"), offset = Vector(-154, -13, 7) , ang = Angle(0, -91, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/refrigerator01.mdl"), offset = Vector(-112, 27, 7) , ang = Angle(0, 0, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/stove01.mdl"), offset = Vector(-111, 71, 25) , ang = Angle(-1, -3, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/newspaperstack01.mdl"), offset = Vector(-133, -87, 7) , ang = Angle(-1, -22, -2), seq = "idle", mat = "" },
		{ mdl = Model( "models/player/group03/male_09.mdl"), offset = Vector(95, 54, 6) , ang = Angle(0, -166, 0), seq = "idle_suitcase", mat = "", tag = "axeguy" },
	},
	Dialogues = function( sc )
		AddDialogueLine( sc.axeguy, ". . ." )
		AddDialogueLine( sc.barguy, "Help. . ." )
		AddDialogueLine( sc.axeguy, "Dude!", "Are you alright?!", ". . .", "What the fuck happened in here?!" )
		AddDialogueLine( sc.barguy, "*cough*", ". . .the sellout. . .", "*cough*", ". . .letstorturegmod and his fuckers. . ." )
		AddDialogueLine( sc.axeguy, ". . ." )
		AddDialogueLine( sc.barguy, ". . .they fucking ruined my bar!", "*cough*", ". . .motherfuckers!!!" )
		AddDialogueLine( sc.axeguy, "God fucking damnit!", ". . .", "Where did he go?"	)
		AddDialogueLine( sc.barguy, "*cough*", ". . .he is still. . .", ". . .outside. . ." )
		AddDialogueLine( sc.axeguy, "Hang in there, buddy. . .", "I'm going to head outside. . .", ". . .and cut his fucking head off!!!" )
	end
}

GM.SingleplayerCutscenes["goin postal"] = {
	Act = "ACT 4: GREED",
	Intro = "2013\nLair of \"CoderFired\" Corporation",
	SoundTrack = 122124893,
	StartFrom = 8900,
	EndAt = 141000,
	Volume = 38,
	Main = { mdl = Model( "models/hunter/plates/plate6x6.mdl" ), seq = "idle", mat = ""},
	Relative = {
		{ mdl = Model( "models/props_junk/garbage_carboard002a.mdl"), offset = Vector(-11, -25, 4) , ang = Angle(0, -74, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/weapons/w_pist_usp.mdl"), offset = Vector(56, 4, 6) , ang = Angle(0, 29, -91), seq = "idle", mat = "" },
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(33, -28, 284) , ang = Angle(89, 122, -1), seq = "Idle", mat = "" },
		{ mdl = Model( "models/props/cs_office/plant01.mdl"), offset = Vector(-81, -100, 4) , ang = Angle(-1, -79, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_assault/moneypallet.mdl"), offset = Vector(-143, -31, 5) , ang = Angle(-1, 178, -2), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_assault/moneypallet03d.mdl"), offset = Vector(-140, 37, 6) , ang = Angle(-1, -1, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_combine/combine_intmonitor003.mdl"), offset = Vector(-93, -23, 39) , ang = Angle(-4, 3, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/van_glass.mdl"), offset = Vector(-31, 123, 7) , ang = Angle(-1, 89, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/shovel01a.mdl"), offset = Vector(-1, 70, 37) , ang = Angle(-16, -93, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(113, 106, 3) , ang = Angle(-1, -2, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(21, 81, 3) , ang = Angle(0, -180, -2), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-88, 120, 3) , ang = Angle(0, -91, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-84, 28, 3) , ang = Angle(-2, 90, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_lab/cleaver.mdl"), offset = Vector(53, -26, 26) , ang = Angle(-34, -54, 16), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/garbage_carboard002a.mdl"), offset = Vector(26, -81, 4) , ang = Angle(-2, 14, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/weapons/w_rif_ak47.mdl"), offset = Vector(-31, -131, 30) , ang = Angle(-1, -110, -89), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_interiors/furniture_chair03a.mdl"), offset = Vector(-32, -79, 25) , ang = Angle(0, 43, 5), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(1, -30, 2) , ang = Angle(-1, -91, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-103, -78, 2) , ang = Angle(0, -180, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_assault/moneypallete.mdl"), offset = Vector(-134, -106, 4) , ang = Angle(-1, 104, -2), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_office/file_box_p2.mdl"), offset = Vector(-63, -135, 29) , ang = Angle(-1, -85, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_office/table_coffee.mdl"), offset = Vector(-39, -134, 5) , ang = Angle(-1, -91, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_office/phone.mdl"), offset = Vector(-43, -127, 29) , ang = Angle(-1, 69, -1), seq = "only_sequence", mat = "" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(93, -123, 2) , ang = Angle(-1, -91, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/cardboard_box003a.mdl"), offset = Vector(47, -136, 14) , ang = Angle(-1, 178, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-31, -121, 2) , ang = Angle(0, -91, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_office/shelves_metal1.mdl"), offset = Vector(95, -136, 5) , ang = Angle(-2, 89, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_office/trash_can.mdl"), offset = Vector(6, -143, 4) , ang = Angle(-1, -89, -1), seq = "only_sequence", mat = "" },
		{ mdl = Model( "models/weapons/w_smg_ump45.mdl"), offset = Vector(-6, -136, 29) , ang = Angle(-1, -99, 89), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/cardboard_box004a.mdl"), offset = Vector(39, -130, 23) , ang = Angle(-1, -96, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/player/group01/male_09.mdl"), offset = Vector(7, 8, 5) , ang = Angle(0, -18, -1), seq = "taunt_dance_base", mat = "", tag = "mark", PlayerColor = Color( 215, 77, 64 ), loopanim = true },
		{ mdl = Model( "models/props_junk/garbage_carboard001a.mdl"), offset = Vector(17, 16, 6) , ang = Angle(-2, 55, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/player/barney.mdl"), offset = Vector(29, -25, 4) , ang = Angle(-1, 42, 1), seq = "zombie_slump_idle_01", mat = "" },
		{ mdl = Model( "models/props_junk/meathook001a.mdl"), offset = Vector(57, 22, 7) , ang = Angle(82, 150, 135), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/metalbucket01a.mdl"), offset = Vector(17, 66, 14) , ang = Angle(-1, -5, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/van.mdl"), offset = Vector(-31, 123, 6) , ang = Angle(-2, 89, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/garbage128_composite001b.mdl"), offset = Vector(88, 79, 10) , ang = Angle(-1, -129, -2), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(104, -17, 2) , ang = Angle(-1, -1, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/player/alyx.mdl"), offset = Vector(100, -40, 5) , ang = Angle(-1, 146, 2), seq = "pose_standing_02", mat = "", tag = "moderator", PlayerColor = Color( 215, 77, 64 ) },
		{ mdl = Model( "models/props/cs_militia/caseofbeer01.mdl"), offset = Vector(13, -96, 28) , ang = Angle(-1, -25, 1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/caseofbeer01.mdl"), offset = Vector(21, -99, 17) , ang = Angle(-3, 3, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/caseofbeer01.mdl"), offset = Vector(33, -101, 5) , ang = Angle(-3, 43, 2), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/caseofbeer01.mdl"), offset = Vector(0, -83, 5) , ang = Angle(-3, 26, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/caseofbeer01.mdl"), offset = Vector(2, -91, 16) , ang = Angle(-2, -14, 2), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/caseofbeer01.mdl"), offset = Vector(8, -99, 5) , ang = Angle(0, 17, -1), seq = "idle", mat = "" },
	},
	Dialogues = function( sc )
		AddDialogueLine( sc.moderator, ". . ." )
		AddDialogueLine( sc.mark, "There you are!", "Wanna join our celebration?" )
		AddDialogueLine( sc.moderator, "Celebration?", ". . .", "What exactly am I supposed to celebrate?" )
		AddDialogueLine( sc.mark, "We've killed all of the leakers!", "Every single one of them!", ". . .", "Even this one, chillin' on the floor!" )
		AddDialogueLine( sc.moderator, "Oh dear. . ." )
		AddDialogueLine( sc.mark, "So, what ya gonna drink?" )
		AddDialogueLine( sc.moderator, "I can't drink, I'm a driver. . .", "Wait, where did you got so much booze?" )
		AddDialogueLine( sc.mark, ". . .", "It's not just a booze, baby!", "And not even the free peasant filth.\nIt's the 'Crystal Alcoload'!" )
		AddDialogueLine( sc.moderator, "Liquid paid addons. . ." )
		AddDialogueLine( sc.mark, "Exactly!!!" )
		AddDialogueLine( sc.moderator, "Well. . .", "Maybe you should be careful with\nthis kind of stuff?", "It's easy to lose your mind from these. . ." )
		AddDialogueLine( sc.mark, "Relax!", "It's all tested and approved!", ". . .", "Zero casualities, as they say!" )
		AddDialogueLine( sc.moderator, ". . ." )
		AddDialogueAction( sc.moderator, function( me ) surface.PlaySound( "physics/glass/glass_largesheet_break1.wav" ) end )
		AddDialogueLine( sc.mark, "The hell was that?!" )
		AddDialogueLine( sc.moderator, "I dunno. . .", "There seems to be a huge hole in our window." )
		AddDialogueLine( sc.mark, "Well, thats just. . ." )
		AddDialogueAction( sc.moderator, function( me ) surface.PlaySound( "physics/concrete/boulder_impact_hard4.wav" ) end )
		AddDialogueLine( sc.moderator, ". . .", "I'll go check outside.", "Sounds like someone is yelling." )
		AddDialogueLine( sc.mark, "Just a heads up then. . ." )
		AddDialogueLine( sc.moderator, "Hm?" )
		AddDialogueLine( sc.mark, "If it gonna be these guys again,\njust shoot them in the face." )
		AddDialogueLine( sc.moderator, "'These guys'?" )
		AddDialogueLine( sc.mark, "Idiots that disrespect us 'for ruining gmod'." )
		AddDialogueLine( sc.moderator, "Isn't that true, tho?" )
		AddDialogueLine( sc.mark, "Of course not!" )
		AddDialogueAction( sc.moderator, function( me ) surface.PlaySound( "physics/metal/metal_box_break2.wav" ) end )
		AddDialogueLine( sc.moderator, "Oh christ!", "Alright, I'm coming down." )
	end
}

GM.SingleplayerCutscenes["influence"] = {
	Intro = "2013\nGreedMobile of \"CoderFired\" Corporation",
	SoundTrack = 286966255,//181517562,//181430421,
	Volume = 33,
	StartFrom = 10000,
	//EndAt = 99000,
	Main = { mdl = Model( "models/hunter/plates/plate4x4.mdl" ), seq = "idle", mat = ""},
	Relative = {
		{ mdl = Model( "models/props_junk/popcan01a.mdl"), offset = Vector(-26, 100, 21) , ang = Angle(85, 1, -88), seq = "idle", mat = "", tag = "ex", shake = true },
		{ mdl = Model( "models/props_lab/huladoll.mdl"), offset = Vector(-32, -62, 96) , ang = Angle(8, -133, -12), seq = "idle", mat = "", tag = "moderator", icon = Material( "sog/alyx.png", "smooth" ), hide = true  },
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(-36, 14, 356) , ang = Angle(89, -38, -1), seq = "Idle", mat = "" },
		{ mdl = Model( "models/props_junk/shoe001a.mdl"), offset = Vector(-32, 14, 101) , ang = Angle(-1, -89, -3), seq = "idle", mat = "", tag = "steve", icon = Material( "sog/detective.png", "smooth" ), hide = true },
		{ mdl = Model( "models/props_c17/briefcase001a.mdl"), offset = Vector(-65, 36, 104) , ang = Angle(0, -91, 6), seq = "idle", mat = "", tag = "mark", icon = Material( "sog/mark.png", "smooth" ), hide = true },
		{ mdl = Model( "models/props_phx/huge/road_medium.mdl"), offset = Vector(5, 2, 2) , ang = Angle(0, -1, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/van.mdl"), offset = Vector(-46, -9, 6) , ang = Angle(0, -180, 0), seq = "idle", mat = "", shake = true },
		{ mdl = Model( "models/props/cs_militia/van_glass.mdl"), offset = Vector(-46, -9, 6) , ang = Angle(-1, -180, -1), seq = "idle", mat = "", shake = true },
	},
	Dialogues = function( sc )
		sc.ex.OnDraw = function()
			if sc.Emitter then
				sc.ex.NextPuff = sc.ex.NextPuff or 0
				if sc.ex.NextPuff < CurTime() then
					local particle = sc.Emitter:Add( "particles/smokey", sc.ex:GetPos() )
					particle:SetVelocity(math.Rand(0.1, 0.7)*Vector( 0, 340, 0 )+VectorRand()*2+vector_up*math.random(10))
					particle:SetDieTime(math.Rand(0.5, 1))
					particle:SetStartAlpha(100)
					particle:SetEndAlpha(0)
					particle:SetStartSize(math.random(2,4))
					particle:SetEndSize(math.random(6,13))
					particle:SetRoll(math.Rand(-180, 180))
					particle:SetColor(100, 100, 100)
					particle:SetAirResistance(15)
					sc.ex.NextPuff = CurTime() + math.Rand( 0, 0.09 )
				end
			end
		end
		AddDialogueLine( sc.mark, "*cough*" )
		AddDialogueLine( sc.moderator, "I can't see a damn thing!" )
		AddDialogueLine( sc.steve, "Hey. . .", "Are you alright?" )
		AddDialogueLine( sc.mark, "*cough*" )
		AddDialogueLine( sc.mark, "I am. . ." )
		AddDialogueLine( sc.mark, "*some nice barfing sounds*" )
		AddDialogueAction( sc.mark, function( me ) surface.PlaySound( "npc/barnacle/barnacle_die1.wav" ) end )
		AddDialogueLine( sc.mark, "Oh, fuck. . ." )
		AddDialogueLine( sc.moderator, "Ewww!" )
		AddDialogueLine( sc.steve, "Damn." )
		AddDialogueLine( sc.mark, "I said. . .", "I'm alright!", "It's just a bug, or. . .", ". . .something. . ." )
		AddDialogueLine( sc.steve, "Where are we going?" )
		AddDialogueLine( sc.moderator, "To the doctor.", "Because this can't go on like this!" )
		AddDialogueLine( sc.mark, "*cough*", "No!!!", "We are not going to a doctor!", "Noone is going to. . .", ". . .", "Oh shit!" )
		AddDialogueLine( sc.steve, ". . ." )
		AddDialogueLine( sc.mark, "Stop the van!" )
		AddDialogueLine( sc.moderator, "What?" )
		AddDialogueLine( sc.mark, "It's the server that owes us money!" )
		AddDialogueLine( sc.moderator, "We can do that after. . ." )
		AddDialogueLine( sc.mark, "Stop the fucking van!!!" )
		AddDialogueLine( sc.moderator, "Alright, alright. . ." )
		AddDialogueAction( sc.moderator, function( me ) 
			surface.PlaySound( "vehicles/v8/skid_lowfriction.wav" )
			surface.PlaySound( "vehicles/v8/v8_stop1.wav" )

			for k, v in pairs( sc.Relative ) do
				if sc.Relative[k] and sc.Relative[k].Shake then
					sc.Relative[k].Shake = false
				end
				sc.ex.NextPuff = CurTime() + 9999999
			end
			
		end )
		AddDialogueLine( sc.mark, "You two, stay here. . .", "I'm just gonna. . .", "*burp*", "Do something. . ." )
		AddDialogueLine( sc.moderator, ". . ." )
		AddDialogueLine( sc.steve, ". . ." )
	end
}

GM.SingleplayerCutscenes["avarice"] = {
	Intro = "2013\nLair of \"CoderFired\" Corporation",
	SoundTrack = 122124893,
	StartFrom = 8900,
	EndAt = 141000,
	Volume = 38,
	Main = { mdl = Model( "models/hunter/plates/plate6x6.mdl" ), seq = "idle", mat = ""},
	Relative = {
		{ mdl = Model( "models/props_interiors/furniture_chair03a.mdl"), offset = Vector(-32, -79, 25) , ang = Angle(-1, 43, 4), seq = "idle", mat = "" },
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(80, -21, 238) , ang = Angle(89, -132, 0), seq = "Idle", mat = "" },
		{ mdl = Model( "models/props_junk/garbage_carboard002a.mdl"), offset = Vector(-11, -26, 4) , ang = Angle(-0, -74, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-31, -121, 2) , ang = Angle(0, -92, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-103, -79, 2) , ang = Angle(-1, 180, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-84, 27, 3) , ang = Angle(-2, 89, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_combine/breendesk.mdl"), offset = Vector(-11, -13, 5) , ang = Angle(0, 0, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/gibs/fast_zombie_torso.mdl"), offset = Vector(-11, -13, 5) , ang = Angle(0, 0, 0), seq = "idle", mat = "", tag = "spooky", hide = true },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(-88, 119, 3) , ang = Angle(0, -92, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_assault/moneypallet.mdl"), offset = Vector(-143, -32, 5) , ang = Angle(-1, 178, -2), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_assault/moneypallet03d.mdl"), offset = Vector(-140, 36, 6) , ang = Angle(-1, -1, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_combine/combine_intmonitor003.mdl"), offset = Vector(-93, -23, 39) , ang = Angle(-4, 3, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_office/plant01.mdl"), offset = Vector(-81, -100, 4) , ang = Angle(-1, -79, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/weapons/w_pist_usp.mdl"), offset = Vector(37, 56, 5) , ang = Angle(1, -36, -89), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(1, -31, 2) , ang = Angle(-1, -92, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/garbage_glassbottle003a.mdl"), offset = Vector(49, -47, 5) , ang = Angle(-88, 86, 123), seq = "idle", mat = "" },
		{ mdl = Model( "models/player/group01/male_09.mdl"), offset = Vector(33, -17, 4) , ang = Angle(-1, 6, 5), seq = "zombie_slump_idle_02", mat = "", tag = "mark", PlayerColor = Color( 215, 77, 64 ) },
		{ mdl = Model( "models/props_junk/garbage_carboard001a.mdl"), offset = Vector(16, 15, 6) , ang = Angle(-2, 55, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(21, 80, 3) , ang = Angle(0, 180, -2), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/metalbucket01a.mdl"), offset = Vector(17, 50, 11) , ang = Angle(66, -151, -80), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/meathook001a.mdl"), offset = Vector(46, 76, 6) , ang = Angle(88, 122, -169), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(103, -17, 2) , ang = Angle(-1, -1, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/player/alyx.mdl"), offset = Vector(110, -79, 4) , ang = Angle(-1, 138, 1), seq = "pose_standing_02", mat = "", tag = "moderator", PlayerColor = Color( 215, 77, 64 ) },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(93, -124, 2) , ang = Angle(-1, -92, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/garbage128_composite001b.mdl"), offset = Vector(87, 78, 10) , ang = Angle(-1, -129, -2), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/trashdumpster02b.mdl"), offset = Vector(112, 105, 3) , ang = Angle(-1, -2, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/caseofbeer01.mdl"), offset = Vector(63, 35, 3) , ang = Angle(0, -164, -2), seq = "idle", mat = "" },
		{ mdl = Model( "models/player/phoenix.mdl"), offset = Vector(127, 22, 4) , ang = Angle(1, -151, 1), seq = "pose_standing_01", mat = "", tag = "steve", PlayerColor = Color( 215, 77, 64 ) },
		{ mdl = Model( "models/props/cs_militia/caseofbeer01.mdl"), offset = Vector(36, -72, 4) , ang = Angle(-3, 0, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/caseofbeer01.mdl"), offset = Vector(25, -88, 4) , ang = Angle(-1, 63, -3), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/caseofbeer01.mdl"), offset = Vector(33, -101, 5) , ang = Angle(-4, 43, 1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/caseofbeer01.mdl"), offset = Vector(7, -99, 5) , ang = Angle(-1, 16, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/caseofbeer01.mdl"), offset = Vector(0, -83, 5) , ang = Angle(-4, 26, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_office/shelves_metal1.mdl"), offset = Vector(94, -136, 5) , ang = Angle(-2, 89, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/cardboard_box003a.mdl"), offset = Vector(47, -137, 14) , ang = Angle(-1, 178, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/cardboard_box004a.mdl"), offset = Vector(39, -130, 23) , ang = Angle(-1, -97, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_office/trash_can.mdl"), offset = Vector(6, -143, 4) , ang = Angle(-1, -90, -1), seq = "only_sequence", mat = "" },
		{ mdl = Model( "models/weapons/w_smg_ump45.mdl"), offset = Vector(-6, -136, 29) , ang = Angle(-1, -99, 89), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_office/table_coffee.mdl"), offset = Vector(-39, -134, 5) , ang = Angle(-1, -92, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/weapons/w_rif_ak47.mdl"), offset = Vector(-31, -131, 30) , ang = Angle(-1, -110, -89), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_office/phone.mdl"), offset = Vector(-43, -127, 29) , ang = Angle(-1, 68, -1), seq = "only_sequence", mat = "" },
		{ mdl = Model( "models/props/cs_office/file_box_p2.mdl"), offset = Vector(-63, -136, 29) , ang = Angle(-1, -85, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_assault/moneypallete.mdl"), offset = Vector(-134, -106, 4) , ang = Angle(-1, 104, -2), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/garbage_carboard002a.mdl"), offset = Vector(26, -81, 4) , ang = Angle(-2, 14, -1), seq = "idle", mat = "" },
	},
	Dialogues = function( sc )
		AddDialogueLine( sc.moderator, "Yeah, I think. . .", ". . ." )
		AddDialogueLine( sc.steve, ". . ." )
		AddDialogueLine( sc.mark, "*zzzzzzzzzzzzzzzzzzzzzzz. . .*" )
		AddDialogueLine( sc.steve, "Well. . .", "That's a change of plans. . ." )
		AddDialogueLine( sc.moderator, ". . .", "That's it.", "I'm taking a vacation." )
		AddDialogueLine( sc.steve, "Huh.", "For how long?" )
		AddDialogueLine( sc.moderator, "Until he gets his stuff together!", "I knew that crap in these bottles is not healthy at all." )
		AddDialogueLine( sc.steve, "Welp. . .", "I might as well get some sleep at home." )
		AddDialogueLine( sc.moderator, "*sigh*", "What the hell was he thinking. . ." )
		AddDialogueLine( sc.mark, "*zzzzzzzzzzzzzzzz. . .*" )
		AddDialogueAction( sc.mark, function( me ) 
			sc.steve.Hide = true 
			sc.moderator.Hide = true
			surface.PlaySound("UI/hint.wav") 
		end )
		AddDialogueLine( sc.mark, "j#5:mf'kds76%&*ADiasdihallf;'l;" )
		AddDialogueAction( sc.mark, function( me ) 
			sc.mark.Icon = mark2 
		end )
		AddDialogueLine( sc.mark, "*&()Aduasf'g&^%7hgdfsjalsfl" )
		AddDialogueAction( sc.mark, function( me ) 
			sc.spooky:SetParent( sc.mark )
			sc.spooky:AddEffects( EF_BONEMERGE )
			sc.spooky.Hide = false
			sc.mark:SetSequence( sc.mark:LookupSequence( "zombie_slump_rise_02_slow" ) )
			//ScenePlaySequence1and2( sc.mark, "zombie_slump_rise_02_slow", "idle_all_angry", 1 )
			surface.PlaySound("ambient/levels/prison/inside_battle_zombie1.wav") 
		end )
		
		
		
	end
}

GM.SingleplayerCutscenes["chargeback"] = {
	Intro = "2013\nSomewhere on a highway. . .",
	SoundTrack = 205465270,
	Volume = 45,
	Main = { mdl = Model( "models/hunter/plates/plate4x4.mdl" ), seq = "idle", mat = ""},
	Relative = {
		{ mdl = Model( "models/props_junk/popcan01a.mdl"), offset = Vector(-24, -369, 22) , ang = Angle(45, -180, -90), seq = "idle", mat = "", tag = "ex", shake = true },
		{ mdl = Model( "models/player/group03/male_06.mdl"), offset = Vector(-15, -318, 102) , ang = Angle(7, 99, 0), seq = "sit_passive", mat = "", tag = "dudetwo", shake = true },
		{ mdl = Model( "models/weapons/w_rif_ak47.mdl"), offset = Vector(-3, -352, 103) , ang = Angle(-1, -168, 87), seq = "idle", mat = "", tag = "ak", shake = true },
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(-21, -275, 302) , ang = Angle(88, -31, 0), seq = "Idle", mat = "" },
		{ mdl = Model( "models/props/de_train/utility_truck.mdl"), offset = Vector(-5, -274, 8) , ang = Angle(-1, -91, 0), seq = "idle", mat = "", shake = true },
		{ mdl = Model( "models/props_phx/huge/road_medium.mdl"), offset = Vector(-20, -127, 2) , ang = Angle(-1, -1, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/de_train/utility_truck_windows.mdl"), offset = Vector(-5, -274, 8) , ang = Angle(-1, -91, 0), seq = "idle", mat = "", shake = true },
		{ mdl = Model( "models/weapons/w_c4.mdl"), offset = Vector(16, -260, 79) , ang = Angle(-1, -91, 0), seq = "idle", mat = "", tag = "dude", hide = true, icon = Material( "sog/merc.png", "smooth" ) },
		{ mdl = Model( "models/weapons/w_pist_deagle.mdl"), offset = Vector(-20, -263, 82) , ang = Angle(2, 88, -86), seq = "idle", mat = "", tag = "matthias", hide = true, icon = Material( "sog/evil.png", "smooth" ) },
		{ mdl = Model( "models/props/de_train/pallet_barrels.mdl"), offset = Vector(-5, -332, 51) , ang = Angle(-1, -1, -1), seq = "idle", mat = "", shake = true },
	},
	Dialogues = function( sc )
		sc.ex.OnDraw = function()
				if sc.Emitter then
					sc.ex.NextPuff = sc.ex.NextPuff or 0
					if sc.ex.NextPuff < CurTime() then
						local particle = sc.Emitter:Add( "particles/smokey", sc.ex:GetPos() )
						particle:SetVelocity(math.Rand(0.1, 0.7)*Vector( 0, -340, 0 )+VectorRand()*2+vector_up*math.random(10))
						particle:SetDieTime(math.Rand(0.5, 1))
						particle:SetStartAlpha(100)
						particle:SetEndAlpha(0)
						particle:SetStartSize(math.random(2,4))
						particle:SetEndSize(math.random(6,13))
						particle:SetRoll(math.Rand(-180, 180))
						particle:SetColor(100, 100, 100)
						particle:SetAirResistance(15)
						sc.ex.NextPuff = CurTime() + math.Rand( 0, 0.09 )
					end
				end
			end
		sc.ak.OnDraw = function()
			if not sc.ak.Parented then
				if sc.dudetwo then
					sc.ak:SetParent( sc.dudetwo )
					sc.ak:AddEffects( EF_BONEMERGE )
					sc.ak.Parented = true
				end
			end
		end
	
		AddDialogueLine( sc.matthias, "You should've seen that. . .", "His head was like 'poof!' with all his stupid brains\nall over the place!", "Man, that was awesome!" )
		AddDialogueLine( sc.dude, ". . .", "I guess.", "What do we have next on the list?" )
		AddDialogueLine( sc.matthias, "Let's see. . ." )
		AddDialogueLine( sc.dude, "Yo, watch the fucking road!" )
		AddDialogueAction( sc.dude, function( me ) 
			surface.PlaySound("vehicles/v8/vehicle_impact_heavy3.wav") 
			//surface.PlaySound("vo/npc/male01/pain07.wav") 
		end )
		AddDialogueLine( sc.matthias, "Whoops!", ". . .", "Oh shit!", "Have a look. . ." )
		AddDialogueLine( sc.dude, ". . .", "Woah!", "Is he fucking serious?" )
		AddDialogueLine( sc.matthias, "He certainly is!" )
		AddDialogueLine( sc.dude, "How are we going to pull this off, tho?" )
		AddDialogueLine( sc.matthias, "As usual.", "You might wanna grab more guys on our way." )
		AddDialogueLine( sc.dude, "Damn. . .", "What about the building?" )
		AddDialogueLine( sc.matthias, "I'm pretty sure we can keep it as a trophy.", "Who knows. . .", "Maybe we can even get some profit from it." )
		AddDialogueLine( sc.dude, "Hang on. . ", "Isn't he supposed to be your old friend?" )
		AddDialogueLine( sc.matthias, "Yeah!", "But you know how life works.", "Who needs friends. . .", ". . .when you got gold bars for a toilet paper." )
		AddDialogueLine( sc.dude, "Hehehehehe!" )
		AddDialogueLine( sc.matthias, "Anyway, get ready.", "Shit is about to get real!" )
		
	end
	
}

GM.SingleplayerCutscenes["sanctuary"] = {
	Act = "ACT 5: TERROR",
	Intro = "2014\n\"ShitGamers\" Community",
	SoundTrack = 191639729,
	StartFrom = 44000,
	EndAt = 190000,
	Volume = 35,
	Main = { mdl = Model( "models/hunter/plates/plate8x8.mdl" ), seq = "idle", mat = ""},
	Relative = {
		{ mdl = Model( "models/props_junk/garbage128_composite001c.mdl"), offset = Vector(125, -12, 56) , ang = Angle(-1, -141, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/player/kleiner.mdl"), offset = Vector(120, 43, 47) , ang = Angle(0, 50, 0), seq = "idle_all_cower", mat = "", tag = "thomas", icon = Material( "sog/thomas.png", "smooth" ), PlayerColor = Color( 250, 0, 250 ) },
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(3, 7, 280) , ang = Angle(89, 54, 0), seq = "Idle", mat = "" },
		{ mdl = Model( "models/props_wasteland/kitchen_counter001d.mdl"), offset = Vector(-130, -2, 18) , ang = Angle(-1, -91, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/garbage_bag001a.mdl"), offset = Vector(-145, 53, 54) , ang = Angle(-22, -27, -88), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_wasteland/kitchen_counter001d.mdl"), offset = Vector(-51, -147, 23) , ang = Angle(-1, 180, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/boxes_frontroom.mdl"), offset = Vector(139, -169, 47) , ang = Angle(-1, 180, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_canal/locks_small.mdl"), offset = Vector(124, -223, 29) , ang = Angle(-90, -91, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/garbage256_composite002b.mdl"), offset = Vector(110, -145, 54) , ang = Angle(-1, -86, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/wood_bench.mdl"), offset = Vector(-84, 66, 52) , ang = Angle(-5, -150, 74), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_canal/locks_small.mdl"), offset = Vector(203, -20, 31) , ang = Angle(-90, 0, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/kleiner.mdl"), offset = Vector(32, -81, 54) , ang = Angle(3, 111, -1), seq = "injured1", mat = "models/zombie_poison/poisonzombie_sheet" },
		{ mdl = Model( "models/kleiner.mdl"), offset = Vector(2, -61, 57) , ang = Angle(-9, 87, 3), seq = "injured1", mat = "models/zombie_poison/poisonzombie_sheet" },
		{ mdl = Model( "models/kleiner.mdl"), offset = Vector(-38, -48, 59) , ang = Angle(1, 81, 7), seq = "injured1", mat = "models/zombie_fast_players/fast_zombie_sheet" },
		{ mdl = Model( "models/kleiner.mdl"), offset = Vector(-60, -85, 53) , ang = Angle(-1, 52, 0), seq = "injured4", mat = "", tag = "kid2" },
		{ mdl = Model( "models/props_canal/locks_small_b.mdl"), offset = Vector(174, -138, 27) , ang = Angle(-89, -65, 63), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_lab/monitor02.mdl"), offset = Vector(-67, -108, 50) , ang = Angle(0, -91, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/cinderblock01a.mdl"), offset = Vector(-133, -78, 54) , ang = Angle(86, 119, -56), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_canal/locks_small_b.mdl"), offset = Vector(-150, 211, 26) , ang = Angle(-90, 19, 69), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/paintbucket01.mdl"), offset = Vector(-137, 65, 50) , ang = Angle(0, -72, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_lab/reciever_cart.mdl"), offset = Vector(-105, 121, 62) , ang = Angle(-89, 28, -144), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_canal/locks_small.mdl"), offset = Vector(-16, -106, 32) , ang = Angle(-90, -35, -56), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/garbage256_composite001b.mdl"), offset = Vector(-92, -102, 54) , ang = Angle(1, -45, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_canal/locks_small.mdl"), offset = Vector(-150, -218, 27) , ang = Angle(-89, -17, -74), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/cardboard_box003a.mdl"), offset = Vector(106, 80, 74) , ang = Angle(0, -144, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_c17/chair_kleiner03a.mdl"), offset = Vector(3, 64, 49) , ang = Angle(-4, 89, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/zombie/poison.mdl"), offset = Vector(5, 43, 73) , ang = Angle(-52, -86, -12), seq = "releasecrab", mat = "", tag = "master", icon = Material( "sog/horror.png", "smooth" ), noframeadv = true },
		{ mdl = Model( "models/props_c17/gravestone002a.mdl"), offset = Vector(-20, 85, 79) , ang = Angle(-1, 180, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_c17/gravestone_cross001a.mdl"), offset = Vector(2, 105, 116) , ang = Angle(0, -91, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_canal/locks_small.mdl"), offset = Vector(-75, 161, 25) , ang = Angle(-89, -113, -69), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_canal/locks_small_b.mdl"), offset = Vector(122, 209, 29) , ang = Angle(-90, 89, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_lab/servers.mdl"), offset = Vector(136, 105, 50) , ang = Angle(-1, -136, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_assault/acunit02.mdl"), offset = Vector(95, 144, 104) , ang = Angle(0, 134, 178), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_c17/gravestone002a.mdl"), offset = Vector(27, 84, 78) , ang = Angle(0, -1, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/cardboard_box003a.mdl"), offset = Vector(96, 97, 59) , ang = Angle(-1, 173, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/cardboard_box003a.mdl"), offset = Vector(115, 73, 60) , ang = Angle(1, 158, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_office/table_coffee_p1.mdl"), offset = Vector(170, 22, 81) , ang = Angle(-20, 115, -174), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_office/table_coffee_p2.mdl"), offset = Vector(156, 4, 79) , ang = Angle(-26, -167, 179), seq = "idle", mat = "" },
		{ mdl = Model( "models/kleiner.mdl"), offset = Vector(95, -34, 59) , ang = Angle(7, 142, -39), seq = "injured3", mat = "", tag = "kid1", mat = "models/zombie_fast_players/fast_zombie_sheet", icon = Material( "sog/victim2.png", "smooth" ) },
	},
	Dialogues = function( sc )
		AddDialogueLine( sc.master, "Thomasssss, my child. . ." )
		AddDialogueLine( sc.thomas, "Nooooooooooo!!!" )
		AddDialogueLine( sc.master, "There is no need to hide, thomasss.", "The sacrifice must be done!" )
		AddDialogueLine( sc.kid1, "Yessssssss. . ." )
		AddDialogueLine( sc.kid2, "Strip hissssss wallet. . ." )
		AddDialogueLine( sc.thomas, "Nooooooooooooooooo!!!!!" )
		AddDialogueLine( sc.master, "In order to help our family. . .", ". . .you must make a small donation, thomas.", "All I ask. . .", ". . .is your wallet. . .", ". . .and your flesshhh." )
		AddDialogueLine( sc.kid2, "Yessss. . ." )
		AddDialogueLine( sc.thomas, "I. . .", "I don't want to be a donator. . ." )
		AddDialogueLine( sc.master, "This is the only way, my child.", "I'll give you 10 minutes. . .", "So you can say 'goodbye' to all of your friendsssss. . ." )
		AddDialogueLine( sc.master, "For now. . .", "I need to check our donations page. . ." )
		AddDialogueLine( sc.thomas, ". . ." )
		AddDialogueLine( sc.master, "Don't you dare dissapoint me, my child!", "Avoiding contribution is not tolerated in my sanctuary!" )
		
	end
}

GM.SingleplayerCutscenes["cough"] = {
	Intro = "2014\nInside shitty server browser",
	SoundTrack = 205465270,
	Volume = 45,
	Main = { mdl = Model( "models/hunter/plates/plate5x5.mdl" ), seq = "idle", mat = ""},
	Relative = {
		{ mdl = Model( "models/props_junk/garbage256_composite002b.mdl"), offset = Vector(12, -105, 52) , ang = Angle(0, 96, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/popcan01a.mdl"), offset = Vector(0, -39, 54) , ang = Angle(85, 50, 75), seq = "idle", mat = "", tag = "ex", blendhide = true },
		{ mdl = Model( "models/props/de_train/acunit2.mdl"), offset = Vector(51, 105, 48) , ang = Angle(-1, -180, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/de_train/biohazardtank_dm_09.mdl"), offset = Vector(33, 128, 117) , ang = Angle(0, 0, 179), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_phx/construct/metal_plate2x4.mdl"), offset = Vector(31, 80, 46) , ang = Angle(0, 90, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/garbage128_composite001a.mdl"), offset = Vector(75, 36, 55) , ang = Angle(-1, -143, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/weapons/w_shot_m3super90.mdl"), offset = Vector(-73, 89, 69) , ang = Angle(44, -135, 0), seq = "idle", mat = "", tag = "wep" },
		{ mdl = Model( "models/props/de_train/barrel.mdl"), offset = Vector(-42, -24, 65) , ang = Angle(-4, 73, 91), seq = "idle", mat = "" },
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(33, -52, 281) , ang = Angle(89, 140, 0), seq = "Idle", mat = "" },
		{ mdl = Model( "models/props/de_train/pallet_barrels.mdl"), offset = Vector(-48, -113, 51) , ang = Angle(-1, -8, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_phx/construct/metal_tube.mdl"), offset = Vector(13, -42, 1) , ang = Angle(0, 0, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/player/group03/male_06.mdl"), offset = Vector(-58, 83, 49) , ang = Angle(0, 135, 0), seq = "idle_passive", mat = "", tag = "dude1" },
		{ mdl = Model( "models/props_phx/construct/metal_plate2x4.mdl"), offset = Vector(-54, -19, 45) , ang = Angle(-1, -180, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/garbage128_composite001b.mdl"), offset = Vector(-39, 27, 55) , ang = Angle(-1, -41, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_phx/construct/metal_plate2x4.mdl"), offset = Vector(-5, 25, 47) , ang = Angle(0, 90, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_phx/construct/metal_plate2x2.mdl"), offset = Vector(-54, 82, 46) , ang = Angle(0, 0, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_phx/construct/metal_plate1.mdl"), offset = Vector(13, -42, 7) , ang = Angle(-1, -180, 0), seq = "idle", mat = "models/shadertest/shader4" },
		{ mdl = Model( "models/player/eli.mdl"), offset = Vector(72, -43, 48) , ang = Angle(-1, -180, 0), seq = "pose_standing_01", mat = "", tag = "matthias" },
		{ mdl = Model( "models/props_phx/construct/metal_plate2x4.mdl"), offset = Vector(-2, -109, 45) , ang = Angle(-1, -90, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_phx/construct/metal_plate2x4.mdl"), offset = Vector(81, -61, 45) , ang = Angle(0, 0, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/player/group03/male_06.mdl"), offset = Vector(-28, -67, 49) , ang = Angle(0, 45, -1), seq = "pose_ducking_01", mat = "", tag = "dude" },
	},
	Dialogues = function( sc )
		sc.ex.OnDraw = function()
				if sc.Emitter then
					sc.ex.NextPuff = sc.ex.NextPuff or 0
					if sc.ex.NextPuff < CurTime() then
						local particle = sc.Emitter:Add( "effects/slime1", sc.ex:GetPos() )
						local forw = sc.ex:GetAngles():Forward()
						particle:SetVelocity( forw * math.Rand( 100, 250 ) + VectorRand() * math.random( 10 ) )//vector_up * -300
						particle:SetDieTime(math.Rand(0.5, 1))
						particle:SetStartAlpha(70)
						particle:SetEndAlpha(10)
						particle:SetStartSize(math.random(1,2))
						particle:SetEndSize(math.random(3,4))
						particle:SetRoll(math.Rand(-10, 10))
						particle:SetColor(215, 77, 64)
						particle:SetGravity( vector_up * -300 )
						particle:SetAirResistance(15)
						sc.ex.NextPuff = CurTime() + math.Rand( 0, 0.02 )
					end
				end
			end
		sc.wep.OnDraw = function()
			if not sc.wep.Parented then
				if sc.dude1 then
					sc.wep:SetParent( sc.dude1 )
					sc.wep:AddEffects( EF_BONEMERGE )
					sc.wep.Parented = true
				end
			end
		end

		AddDialogueLine( sc.dude, ". . ." )
		AddDialogueLine( sc.matthias, "Keep going. . ." )
		AddDialogueLine( sc.dude, "That's some nasty shit in these barrels.", ". . .", "That's the last thing we had to do, right?" )
		AddDialogueLine( sc.matthias, "Pretty much.", "He did said that we have a bonus choice. . ." )
		AddDialogueLine( sc.dude, "A bonus choice?" )
		AddDialogueLine( sc.matthias, "Yeah.", "Basically we can do one more thing.", "And it is entirely up to us." )
		AddDialogueLine( sc.dude, "Do you have any ideas, then?" )
		AddDialogueLine( sc.matthias, "Oh yeah.", "I can't waste such opportunity, can I?" )
		AddDialogueLine( sc.dude, "Nah." )
		AddDialogueLine( sc.matthias, "Do you know GMod Power community?" )
		AddDialogueLine( sc.dude, "Yeah.", "I used to play there some time ago.", "These were good times before I. . .", "um. . .", ". . .got banned for something." )
		AddDialogueLine( sc.matthias, ". . .", "They have got casino and a lobby.", "Now think. . ." )
		AddDialogueLine( sc.dude, ". . .", "We gonna gamble at their casino?" )
		AddDialogueLine( sc.matthias, "Even better!", "Some people see this community as the only\n'sacred place' in gmod.", "Hah!", "The only sacred place here is my ass!" )
		AddDialogueLine( sc.dude, "So what will we do, then?" )
		AddDialogueLine( sc.matthias, "Ohhh, you will see. . ." )
		AddDialogueLine( sc.dude, "As if destroying CoderFired was not enough." )
		AddDialogueLine( sc.matthias, ". . .", "It's a real shame this game has to die. . .", "So I'll be doing it a huge favor." )
		AddDialogueLine( sc.dude, ". . .", "What about their lobby?" )
		AddDialogueLine( sc.matthias, "You are taking care of it, as we speak." )
		AddDialogueLine( sc.dude, ". . ." )
	end
}


GM.SingleplayerCutscenes["mutilation"] = {
	Intro = "2014\nEntrance to the ShitGamers Community",
	SoundTrack = 95416884,
	Volume = 40,
	Main = { mdl = Model( "models/hunter/plates/plate3x3.mdl" ), seq = "idle", mat = ""},
	Relative = {
		{ mdl = Model( "models/props_lab/bewaredog.mdl"), offset = Vector(-5, 76, 78) , ang = Angle(4, -144, 6), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_debris/rebar003c_64.mdl"), offset = Vector(59, -76, 94) , ang = Angle(-28, -109, 62), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_debris/walldestroyed09g.mdl"), offset = Vector(-17, 50, 53) , ang = Angle(-1, -1, 1), seq = "", mat = "" },
		{ mdl = Model( "models/props_debris/rebar002b_48.mdl"), offset = Vector(93, 17, 92) , ang = Angle(-26, -20, -101), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_debris/walldestroyed09c.mdl"), offset = Vector(82, 143, 56) , ang = Angle(58, -110, 90), seq = "", mat = "" },
		{ mdl = Model( "models/props_c17/door01_left.mdl"), offset = Vector(-26, 4, 90) , ang = Angle(-81, 94, 173), seq = "idle", mat = "" },
		{ mdl = Model( "models/player/group01/male_02.mdl"), offset = Vector(-59, 26, 84) , ang = Angle(-1, 35, 0), seq = "idle_all_angry", mat = "", tag = "pr" },
		{ mdl = Model( "models/props_c17/door01_left.mdl"), offset = Vector(69, 0, 91) , ang = Angle(81, -93, 178), seq = "idle", mat = "" },
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(17, 34, 328) , ang = Angle(88, 140, -1), seq = "Idle", mat = "" },
		{ mdl = Model( "models/gibs/hgibs.mdl"), offset = Vector(-28, 84, 77) , ang = Angle(-9, -115, 5), seq = "idle1", mat = "" },
		{ mdl = Model( "models/props_debris/walldestroyed09f.mdl"), offset = Vector(-209, -43, 45) , ang = Angle(-1, 95, -4), seq = "", mat = "" },
	},
	Dialogues = function( sc )
		AddDialogueLine( sc.pr, "Huff. . ." )
		AddDialogueLine( sc.pr, "Looks like gamemode browser was not lying after all. . ." )
		AddDialogueLine( sc.pr, "'ShitGamers' Community\n910347 players on 1 server. . ." )
		AddDialogueLine( sc.pr, "This place looks creepy as hell.", "Hello?", ". . .", "Is anybody here?" )
		AddDialogueLine( sc.pr, "Hm. . .", "Oh right, there is a sign. . .", "'Jump down this hole for free hat.'", ". . .", "That's a one way to gain a lot of players." )
		AddDialogueLine( sc.pr, "Well. . .", "I guess that's only one way in." )
	end
}

GM.SingleplayerCutscenes["tax evasion"] = {
	Intro = "2014\n\"ShitGamers\" Community",
	SoundTrack = 191639729,
	StartFrom = 44000,
	EndAt = 190000,
	Volume = 35,
	Main = { mdl = Model( "models/hunter/plates/plate3x3.mdl" ), seq = "idle", mat = ""},
	Relative = {
		{ mdl = Model( "models/props_c17/gravestone_coffinpiece001a.mdl"), offset = Vector(-93, -47, 30) , ang = Angle(0, -10, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/weapons/w_physics.mdl"), offset = Vector(-73, 66, 41) , ang = Angle(0, 29, 1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_c17/gravestone_coffinpiece001a.mdl"), offset = Vector(-70, 85, 29) , ang = Angle(-1, 4, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(-45, 44, 277) , ang = Angle(89, -70, 2), seq = "Idle", mat = "" },
		{ mdl = Model( "models/props_c17/gravestone_statue001a.mdl"), offset = Vector(-145, 24, 90) , ang = Angle(-1, 0, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/player/group01/male_02.mdl"), offset = Vector(-90, 20, 20) , ang = Angle(-1, 5, 0), seq = "zombie_slump_idle_02", mat = "", tag = "pr" },
		{ mdl = Model( "models/props_debris/walldestroyed02a.mdl"), offset = Vector(48, -37, 12) , ang = Angle(0, -90, 89), seq = "idle", mat = "nature/dirtfloor009c" },
		{ mdl = Model( "models/player/kleiner.mdl"), offset = Vector(35, 88, 22) , ang = Angle(-1, 45, 0), seq = "zombie_slump_idle_01", mat = "", PlayerColor = Color( 250, 0, 250 ) },
		{ mdl = Model( "models/props_debris/walldestroyed03a.mdl"), offset = Vector(-23, 91, 13) , ang = Angle(0, -180, 89), seq = "", mat = "" },
		{ mdl = Model( "models/props_debris/walldestroyed05a.mdl"), offset = Vector(15, -68, 9) , ang = Angle(89, -90, 0), seq = "", mat = "" },
		{ mdl = Model( "models/player/kleiner.mdl"), offset = Vector(19, -37, 19) , ang = Angle(-1, 148, -1), seq = "zombie_run_fast", mat = "models/zombie_fast_players/fast_zombie_sheet", tag = "kid3", icon = Material( "sog/victim2.png", "smooth" ) },
		{ mdl = Model( "models/player/kleiner.mdl"), offset = Vector(33, 3, 20) , ang = Angle(0, 169, -1), seq = "pose_standing_01", mat = "models/zombie_poison/poisonzombie_sheet", tag = "kid1", icon = Material( "sog/victim2.png", "smooth" ) },
		{ mdl = Model( "models/player/kleiner.mdl"), offset = Vector(70, 74, 21) , ang = Angle(-1, 135, -1), seq = "zombie_run_fast", mat = "models/zombie_fast_players/fast_zombie_sheet", tag = "kid2", icon = Material( "sog/victim2.png", "smooth" ) },
	},
	Dialogues = function( sc )
		AddDialogueLine( sc.pr, ". . ." )
		AddDialogueLine( sc.kid1, "Yesssssss. . ." )
		AddDialogueLine( sc.kid2, ". . ." )
		AddDialogueLine( sc.kid3, "Oh yesssssss. . ." )
		AddDialogueLine( sc.pr, ". . .", ". . .what's going on. . ." )
		AddDialogueLine( sc.kid1, "Shhhhhh. . .", "The masssster is coming." )
		AddDialogueLine( sc.kid2, "Yessss. . .", "The massssssster. . ." )
		AddDialogueLine( sc.pr, "Carl. . .", ". . .", "Where the hell are you?" )
		AddDialogueLine( sc.kid3, ". . ." )
		AddDialogueAction( sc.kid3, function( me ) surface.PlaySound( "ambient/machines/wall_move3.wav" ) end )
		AddDialogueLine( sc.pr, "Oh no. . .", "That doesn't sound good!" )	
		AddDialogueLine( sc.kid2, "He isss here. . ." )
		AddDialogueAction( sc.kid2, function( me ) surface.PlaySound( "ambient/machines/wall_move4.wav" ) end )
		
	end
}


GM.SingleplayerCutscenes["hatred"] = {
	Act = "ACT 6: DEAD END",
	Intro = "2014\n\"GMod Power\" Community casino",
	SoundTrack = 302326040,//215669659,
	StartFrom = 69500,
	Volume = 35,
	Main = { mdl = Model( "models/hunter/plates/plate2x2.mdl" ), seq = "idle", mat = ""},
	Relative = {
		{ mdl = Model( "models/player/group01/female_04.mdl"), offset = Vector(-1, 2, 5) , ang = Angle(-1, -180, 0), seq = "taunt_dance_base", mat = "", PlayerColor = Color( 47, 89, 185 ), loopanim = true },
		{ mdl = Model( "models/weapons/w_c4.mdl"), offset = Vector(802, -47, 78) , ang = Angle(0, -128, 0), seq = "idle", mat = "", tag = "dude", hide = true, icon = Material( "sog/merc.png", "smooth" ) },
		{ mdl = Model( "models/weapons/w_pist_deagle.mdl"), offset = Vector(796, -81, 78) , ang = Angle(2, -116, -86), seq = "idle", mat = "", tag = "matthias", hide = true, icon = Material( "sog/evil.png", "smooth" ) },
		{ mdl = Model( "models/player/combine_soldier_prisonguard.mdl"), offset = Vector(842, -63, 44) , ang = Angle(-1, -180, 0), seq = "pose_ducking_01", mat = "models/combine_soldier/combinesoldiersheet_shotgun", tag = "dude2" },
		{ mdl = Model( "models/props_phx/huge/road_short.mdl"), offset = Vector(828, 38, 4) , ang = Angle(0, -180, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/de_train/utility_truck_windows.mdl"), offset = Vector(818, -65, 10) , ang = Angle(-1, -4, 0), seq = "idle", mat = "", tag = "car2" },
		{ mdl = Model( "models/props/de_train/utility_truck.mdl"), offset = Vector(818, -65, 10) , ang = Angle(-1, -4, 0), seq = "idle", mat = "", tag = "car" },
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(1, -43, 337) , ang = Angle(88, 167, 3), seq = "Idle", mat = "" },
		{ mdl = Model( "models/props/cs_office/plant01.mdl"), offset = Vector(59, -87, 4) , ang = Angle(-1, -34, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/player/group01/male_05.mdl"), offset = Vector(14, -76, 5) , ang = Angle(0, 113, 0), seq = "taunt_dance_base", mat = "", PlayerColor = Color( 47, 89, 185 ), loopanim = true },
		{ mdl = Model( "models/props/cs_militia/bar01.mdl"), offset = Vector(-130, -56, 5) , ang = Angle(-1, -88, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/bar01.mdl"), offset = Vector(-150, -22, 6) , ang = Angle(0, 2, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/player/breen.mdl"), offset = Vector(-96, -42, 48) , ang = Angle(0, -1, -1), seq = "pose_standing_04", mat = "", tag = "owner", icon = Material( "sog/breen_gmp.png", "smooth" ), PlayerColor = Color( 47, 89, 185 ) },
		{ mdl = Model( "models/props/cs_office/phone.mdl"), offset = Vector(-99, -97, 50) , ang = Angle(-1, 153, 0), seq = "only_sequence", mat = "", tag = "phone" },
		{ mdl = Model( "models/props_phx/construct/plastic/plastic_panel4x8.mdl"), offset = Vector(-91, -15, 2) , ang = Angle(0, 90, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_assault/dollar.mdl"), offset = Vector(-90, -143, 6) , ang = Angle(4, 55, -174), seq = "idle", mat = "" },
		{ mdl = Model( "models/player/combine_super_soldier.mdl"), offset = Vector(-36, -148, 6) , ang = Angle(-1, 89, 1), seq = "taunt_dance_base", mat = "", PlayerColor = Color( 47, 89, 185 ), loopanim = true },
		{ mdl = Model( "models/props/cs_office/chair_office.mdl"), offset = Vector(-152, -33, 5) , ang = Angle(0, -44, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/player/police.mdl"), offset = Vector(-151, 105, 5) , ang = Angle(-1, -104, -1), seq = "pose_standing_02", mat = "", PlayerColor = Color( 47, 89, 185 ) },
		{ mdl = Model( "models/player/police_fem.mdl"), offset = Vector(-148, 67, 4) , ang = Angle(0, 89, 0), seq = "idle_all_01", mat = "", PlayerColor = Color( 47, 89, 185 ) },
		{ mdl = Model( "models/player/group01/male_06.mdl"), offset = Vector(-38, 97, 5) , ang = Angle(-1, -168, 0), seq = "taunt_dance_base", mat = "", PlayerColor = Color( 47, 89, 185 ), loopanim = true },
		{ mdl = Model( "models/props/cs_office/plant01.mdl"), offset = Vector(51, 72, 4) , ang = Angle(0, -46, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_phx/construct/plastic/plastic_panel4x4.mdl"), offset = Vector(-24, -3, 1) , ang = Angle(0, 0, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/player/group01/male_08.mdl"), offset = Vector(-54, 29, 4) , ang = Angle(-2, 179, 0), seq = "taunt_dance_base", mat = "", PlayerColor = Color( 47, 89, 185 ), loopanim = true },
		{ mdl = Model( "models/props/cs_office/computer.mdl"), offset = Vector(-109, 10, 50) , ang = Angle(-1, -135, -1), seq = "idle", mat = "" },
	},
	Dialogues = function( sc )	
		AddDialogueLine( sc.owner, "Greetings, my lovely friends!", "Thank you all for coming!", "Because we are celebrating yet another day\nin our awesome community!" )
		AddDialogueLine( sc.owner, "Also, we have increased safety measures on our server!", "So there is nothing to worry, my darlings!", "This is all for your own safety!" )
		AddDialogueLine( sc.owner, "Even in hard times like these. . .", "We always stay positive and happy!" )
		AddDialogueLine( sc.owner, "So have fun, my friends!", "Poker or slot machines. . .", "Drinks or some good talk. . .", "Anything that you desire!", ". . .", "I've even ordered some pizza, just for all of you!" )
		AddDialogueLine( sc.owner, "And feel free to. . ." )
		AddDialogueLine( sc.phone, "*beep*" )
		AddDialogueLine( sc.owner, "Oh. . .", "It looks like our pizza have arrived!", "You guys, can come in.", "I'm just going to go outside and grab the pizza!", "Just don't have too much fun without me!" )
		AddDialogueLine( sc.matthias, ". . ." )
		AddDialogueLine( sc.dude, "Hehehe. . ." )
		AddDialogueLine( sc.matthias, "Are your suits on?" )
		AddDialogueLine( sc.dude, "Yeah!" )
		AddDialogueLine( sc.matthias, ". . ." )
		AddDialogueAction( sc.matthias, function( me ) 
				surface.PlaySound( "ambient/machines/sputter1.wav" ) 
				sc.car.Shake = true
				sc.car2.Shake = true
				sc.dude2.Shake = true
			end )
		AddDialogueLine( sc.mathias, "Vroom vroom, motherfuckers!" )
		AddDialogueAction( sc.matthias, function( me ) 
			sc.vCamPos.x = 818
			sc.vCamPos.y = -65
		end )
		
		
	end
}

GM.SingleplayerCutscenes["resort"] = {
	Intro = "2014\n\"Stay Rusty\" bar",
	SoundTrack = 300939921,
	Volume = 40,
	StartFrom = 8000,
	EndAt = 202000,
	Main = { mdl = Model( "models/hunter/plates/plate8x8.mdl" ), seq = "idle", mat = ""},
	Relative = {
		{ mdl = Model( "models/props/cs_militia/axe.mdl"), offset = Vector(11, -17, 59) , ang = Angle(67, -2, 113), seq = "idle", mat = "" },
		{ mdl = Model( "models/player/group01/male_02.mdl"), offset = Vector(121, 34, 7) , ang = Angle(0, 178, 0), seq = "idle_suitcase", mat = "", tag = "pr", hide = true },
		{ mdl = Model( "models/props_junk/garbage_metalcan001a.mdl"), offset = Vector(-80, 57, 9) , ang = Angle(-29, 39, -91), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_office/phone_p1.mdl"), offset = Vector(-117, 185, 51) , ang = Angle(-0, -108, 0), seq = "only_sequence", mat = "" },
		{ mdl = Model( "models/props/cs_militia/wood_bench.mdl"), offset = Vector(141, -23, 28) , ang = Angle(3, 74, 177), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/housefence_door.mdl"), offset = Vector(-223, 196, 5) , ang = Angle(-90, -180, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/fertilizer.mdl"), offset = Vector(-126, 71, 7) , ang = Angle(-1, 175, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/caseofbeer01.mdl"), offset = Vector(-171, 80, 7) , ang = Angle(0, 84, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/housefence.mdl"), offset = Vector(-123, -11, 5) , ang = Angle(-90, -1, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/food_stack.mdl"), offset = Vector(-158, 176, 7) , ang = Angle(-1, 83, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/food_stack.mdl"), offset = Vector(-154, -13, 7) , ang = Angle(-1, -91, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/housefence.mdl"), offset = Vector(-226, -19, 6) , ang = Angle(-90, 179, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/boxes_garage_lower.mdl"), offset = Vector(-170, -98, 7) , ang = Angle(-1, -136, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/toilet.mdl"), offset = Vector(-128, -111, 7) , ang = Angle(0, 0, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/newspaperstack01.mdl"), offset = Vector(-134, -87, 7) , ang = Angle(-1, -23, -2), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_c17/tv_monitor01.mdl"), offset = Vector(-52, -19, 60) , ang = Angle(0, 35, -1), seq = "idle", mat = "", tag = "tv" },
		{ mdl = Model( "models/props_junk/garbage_plasticbottle002a.mdl"), offset = Vector(-79, 8, 16) , ang = Angle(-23, 72, -2), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/refrigerator01.mdl"), offset = Vector(-112, 27, 7) , ang = Angle(0, 0, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/stove01.mdl"), offset = Vector(-111, 71, 25) , ang = Angle(-1, -4, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/gun_cabinet.mdl"), offset = Vector(-105, 110, 7) , ang = Angle(-1, -3, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/player/group03/male_09.mdl"), offset = Vector(27, 11, 42) , ang = Angle(19, -177, 3), seq = "sit_fist", mat = "", tag = "axeguy" },
		{ mdl = Model( "models/props/cs_militia/housefence.mdl"), offset = Vector(-18, 24, 5) , ang = Angle(-90, -1, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/paintbucket01.mdl"), offset = Vector(5, 202, 6) , ang = Angle(-1, 7, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/barstool01.mdl"), offset = Vector(39, 160, 11) , ang = Angle(-46, 1, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/barstool01.mdl"), offset = Vector(59, 131, 13) , ang = Angle(-1, -108, 87), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/bar01.mdl"), offset = Vector(-60, 153, 7) , ang = Angle(-1, 0, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/caseofbeer01.mdl"), offset = Vector(-1, 108, 53) , ang = Angle(-2, -13, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/barstool01.mdl"), offset = Vector(26, 60, 6) , ang = Angle(-1, -94, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/player/odessa.mdl"), offset = Vector(26, 62, 42) , ang = Angle(25, 179, -6), seq = "sit_fist", mat = "", tag = "barguy" },
		{ mdl = Model( "models/props/cs_militia/bottle03.mdl"), offset = Vector(-3, 62, 50) , ang = Angle(0, 55, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/bottle02.mdl"), offset = Vector(-5, 7, 51) , ang = Angle(2, 56, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/garbage_newspaper001a.mdl"), offset = Vector(2, -74, 7) , ang = Angle(-1, -120, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/housefence_door.mdl"), offset = Vector(-125, -191, 5) , ang = Angle(-90, 179, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/logpile2.mdl"), offset = Vector(-81, -126, 7) , ang = Angle(-1, -91, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/footlocker01_closed.mdl"), offset = Vector(35, -145, 18) , ang = Angle(-1, 98, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/garbage_plasticbottle002a.mdl"), offset = Vector(44, -97, 7) , ang = Angle(-89, -170, -133), seq = "idle", mat = "" },
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(63, 19, 270) , ang = Angle(89, 132, 0), seq = "Idle", mat = "" },
		{ mdl = Model( "models/props_junk/garbage_bag001a.mdl"), offset = Vector(5, -103, 12) , ang = Angle(-1, -32, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_office/radio.mdl"), offset = Vector(4, -87, 11) , ang = Angle(-74, -27, -142), seq = "only_sequence", mat = "" },
		{ mdl = Model( "models/props/cs_militia/housefence.mdl"), offset = Vector(86, -38, 5) , ang = Angle(-90, 179, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/housefence.mdl"), offset = Vector(188, 29, 6) , ang = Angle(-90, -1, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/housefence.mdl"), offset = Vector(86, -27, 5) , ang = Angle(-90, -1, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/housefence.mdl"), offset = Vector(-18, -32, 5) , ang = Angle(-90, -180, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/wood_table.mdl"), offset = Vector(84, -106, 6) , ang = Angle(1, 103, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/garbage128_composite001a.mdl"), offset = Vector(97, -174, 11) , ang = Angle(-0, -73, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/caseofbeer01.mdl"), offset = Vector(-50, -82, 13) , ang = Angle(0, -41, -90), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/barstool01.mdl"), offset = Vector(33, -55, 14) , ang = Angle(87, -60, 9), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/garbage_metalcan002a.mdl"), offset = Vector(57, -62, 8) , ang = Angle(24, 98, -90), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_c17/metalpot002a.mdl"), offset = Vector(74, 25, 7) , ang = Angle(-0, -45, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/wood_bench.mdl"), offset = Vector(131, 122, 24) , ang = Angle(-1, -20, 179), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_office/trash_can_p8.mdl"), offset = Vector(170, 155, 1) , ang = Angle(43, 153, -51), seq = "only_sequence", mat = "" },
		{ mdl = Model( "models/props_junk/garbage_carboard002a.mdl"), offset = Vector(152, 152, 7) , ang = Angle(-1, 24, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/circularsaw01.mdl"), offset = Vector(113, 169, 6) , ang = Angle(-1, 32, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/wood_table.mdl"), offset = Vector(96, 167, 6) , ang = Angle(1, -175, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/housefence_door.mdl"), offset = Vector(89, 184, 5) , ang = Angle(-90, -1, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/bar01.mdl"), offset = Vector(-44, 31, 7) , ang = Angle(-1, -91, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/shovel01a.mdl"), offset = Vector(-60, -52, 37) , ang = Angle(-88, -127, 124), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/urine_trough.mdl"), offset = Vector(-56, -39, 33) , ang = Angle(-0, -91, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/barstool01.mdl"), offset = Vector(27, 10, 5) , ang = Angle(0, -88, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/garbage256_composite002b.mdl"), offset = Vector(135, -4, 10) , ang = Angle(-1, 2, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/housefence.mdl"), offset = Vector(-123, 19, 6) , ang = Angle(-90, -180, 0), seq = "idle", mat = "" },
	},
	Dialogues = function( sc )	
		AddDialogueLine( sc.axeguy, ". . ." )
		AddDialogueLine( sc.barguy, ". . .", "Well. . .", "Looks like it can't get any worse than this.", "Can it?" )
		AddDialogueLine( sc.axeguy, ". . ." )
		AddDialogueLine( sc.barguy, "Hey, at least this piece of shit is no more!", "The sellout guy. . ." )
		AddDialogueLine( sc.axeguy, "It's too good to be true. . .", "You've seen what's outside." )
		AddDialogueLine( sc.barguy, "Yeah. . .", "Now I regret it." )
		AddDialogueLine( sc.axeguy, "At least you got all your bones safe." )
		AddDialogueLine( sc.barguy, "True. . .", "Mind if I turn on the tv?" )
		AddDialogueLine( sc.axeguy, "Go ahead. . ." )
		AddDialogueLine( sc.tv, "*chkt*", "Bzzzzzzzzzzzz" )
		AddDialogueLine( sc.barguy, "Come on. . ." )
		AddDialogueLine( sc.tv, "Breaking news!" )
		AddDialogueLine( sc.axeguy, ". . ." )
		AddDialogueLine( sc.tv, "A horrifying shooting took place in GMod Power casino. . ." )
		AddDialogueLine( sc.barguy, ". . ." )
		AddDialogueLine( sc.tv, ". . .have reported gunshots and explosions this morning. . ." )
		AddDialogueLine( sc.axeguy, "GMod Power. . ." )
		AddDialogueLine( sc.barguy, "Holy fuck, that's horrible!" )
		AddDialogueLine( sc.tv, ". . .attackers brutally murdered everyone inside. . .", ". . .and ran away with all the money. . ." )
		AddDialogueLine( sc.tv, ". . .by the time the police arrived. . .", ". . .there was nothing but corpses and scorched rooms." )
		AddDialogueLine( sc.tv, "Another reports came from. . ." )
		AddDialogueAction( sc.pr, function( me ) me.Hide = false surface.PlaySound( "doors/wood_move1.wav" ) end )
		AddDialogueLine( sc.pr, "Hello?" )
		AddDialogueLine( sc.barguy, "Shhh. . ." )
		AddDialogueLine( sc.tv, ". . .famous youtuber LetsTortureGMod was found dead. . .", ". . .his fans are storming forums in blind revenge. . ." )
		AddDialogueLine( sc.axeguy, ". . ." )
		AddDialogueLine( sc.barguy, ". . .so yeah, do you need anything?", "A drink, perhaps?" )
		AddDialogueLine( sc.pr, ". . .", "Thanks, but. . .", "I was wondering if you know the shortest way\nto garry's office. . ." )
		AddDialogueLine( sc.barguy, "Hm. . .", "Let me think." )
		AddDialogueLine( sc.axeguy, "You look like you've been through some fucking shit. . ." )
		AddDialogueLine( sc.pr, "Sort of. . ." )
		AddDialogueLine( sc.barguy, "I think you can get there by simply. . .", ". . .um. . .", ". . .going through GMod Power's resort center." )
		AddDialogueLine( sc.pr, "Isn't it supposed to be called lobby?" )
		AddDialogueLine( sc.barguy, "Same thing.", "I suggest you to be careful, tho. . .", "Seen what have happened to their casino?" )
		AddDialogueLine( sc.pr, "No." )
		AddDialogueLine( sc.axeguy, "It got fucked!" )
		AddDialogueLine( sc.pr, "Oh god. . .", "Alright, thanks for the help, I guess. . ." )
		AddDialogueLine( sc.axeguy, ". . ." )
		AddDialogueAction( sc.pr, function( me ) me.Hide = true surface.PlaySound( "doors/wood_move1.wav" ) end )
		AddDialogueLine( sc.axeguy, "Garry's office. . .", "You didn't even bother to warn him." )
		AddDialogueLine( sc.barguy, "What?" )
		AddDialogueLine( sc.axeguy, "Nevermind.", ". . .", "This guy has a fucking death wish." )
		AddDialogueLine( sc.barguy, ". . ." )
	end
}

GM.SingleplayerCutscenes["paywall"] = {
	Intro = "2014\nGreedMobile of \"CoderFired\" Corporation",
	SoundTrack = 672568949,
	Volume = 40,
	//StartFrom = 10000,
	Main = { mdl = Model( "models/hunter/plates/plate4x4.mdl" ), seq = "idle", mat = ""},
	Relative = {
		{ mdl = Model( "models/props_junk/popcan01a.mdl"), offset = Vector(-26, 100, 21) , ang = Angle(85, 1, -88), seq = "idle", mat = "", tag = "ex", shake = true },
		{ mdl = Model( "models/props_lab/huladoll.mdl"), offset = Vector(-32, -62, 96) , ang = Angle(8, -133, -12), seq = "idle", mat = "", tag = "moderator", icon = Material( "sog/alyx.png", "smooth" ), hide = true  },
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(-36, 14, 356) , ang = Angle(89, 38, -1), seq = "Idle", mat = "" },
		{ mdl = Model( "models/props_trainstation/payphone_reciever001a.mdl"), offset = Vector(-32, -62, 96) , ang = Angle(9, -160, -57), seq = "idle", mat = "", tag = "phone", hide = true },
		{ mdl = Model( "models/props_phx/huge/road_medium.mdl"), offset = Vector(5, 2, 2) , ang = Angle(0, -1, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/van.mdl"), offset = Vector(-46, -9, 6) , ang = Angle(0, -180, 0), seq = "idle", mat = "", shake = true },
		{ mdl = Model( "models/props/cs_militia/van_glass.mdl"), offset = Vector(-46, -9, 6) , ang = Angle(-1, -180, -1), seq = "idle", mat = "", shake = true },
	},
	Dialogues = function( sc )
		sc.ex.OnDraw = function()
			if sc.Emitter then
				sc.ex.NextPuff = sc.ex.NextPuff or 0
				if sc.ex.NextPuff < CurTime() then
					local particle = sc.Emitter:Add( "particles/smokey", sc.ex:GetPos() )
					particle:SetVelocity(math.Rand(0.1, 0.7)*Vector( 0, 340, 0 )+VectorRand()*2+vector_up*math.random(10))
					particle:SetDieTime(math.Rand(0.5, 1))
					particle:SetStartAlpha(100)
					particle:SetEndAlpha(0)
					particle:SetStartSize(math.random(2,4))
					particle:SetEndSize(math.random(6,13))
					particle:SetRoll(math.Rand(-180, 180))
					particle:SetColor(100, 100, 100)
					particle:SetAirResistance(15)
					sc.ex.NextPuff = CurTime() + math.Rand( 0, 0.09 )
				end
			end
		end
		AddDialogueLine( sc.moderator, ". . ." )
		AddDialogueLine( sc.phone, "*beep*", "This client is not responding. . ." )
		AddDialogueLine( sc.moderator, "Come on, Mark. . .", "Where did you go again?" )
		AddDialogueLine( sc.phone, "This client is not responding. . ." )
		AddDialogueLine( sc.moderator, "*sigh*", "What if. . ." )
		AddDialogueLine( sc.phone, "*beep*", "This client is not responding. . ." )
		AddDialogueLine( sc.moderator, ". . .", "Are you kidding me?!", "Even steve is not responding!", "Uhhhhhh. . .", "Come on, at least office should work. . ." )
		AddDialogueLine( sc.phone, "*beep*", "Dialing. . ." )
		AddDialogueLine( sc.moderator, "Aha!" )
		AddDialogueLine( sc.phone, "*beep*", "Welcome to the ScriptToddler!", "If you want to sell a script - press one." )
		AddDialogueLine( sc.moderator, ". . ." )
		AddDialogueLine( sc.phone, "If you want to refund or make a complaint. . .", ". . .you can fuck off and have a nice day!" )
		AddDialogueLine( sc.phone, "*beep*" )
		AddDialogueLine( sc.moderator, ". . ." )
	end
}

GM.SingleplayerCutscenes["bad idea"] = {
	Intro = "2014\ngarry's office",
	SoundTrack = 451818870,
	Volume = 35,
	//EndAt = 195000,
	Main = { mdl = Model( "models/hunter/plates/plate3x3.mdl" ), seq = "idle", mat = ""},
	Relative = {
		{ mdl = Model( "models/player/group01/male_02.mdl"), offset = Vector(113, -19, 14) , ang = Angle(0, -179, -1), seq = "swim_idle_all", mat = "", tag = "pr6", hide = true },
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(-17, -26, 254) , ang = Angle(88, 87, -2), seq = "Idle", mat = "" },
		{ mdl = Model( "models/props/cs_office/cardboard_box03.mdl"), offset = Vector(101, -119, 11) , ang = Angle(0, -2, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_office/file_cabinet1_group.mdl"), offset = Vector(-21, -115, 11) , ang = Angle(-1, 89, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_office/file_cabinet1_group.mdl"), offset = Vector(58, -117, 11) , ang = Angle(-1, 89, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/player/soldier_stripped.mdl"), offset = Vector(-67, -28, 10) , ang = Angle(0, -180, -1), seq = "pose_standing_02", mat = "", tag = "garry" },
		{ mdl = Model( "models/player/group01/male_02.mdl"), offset = Vector(46, 60, 10) , ang = Angle(0, -136, 0), seq = "idle_all_cower", mat = "", tag = "pr1", hide = true },
		{ mdl = Model( "models/player/group01/male_02.mdl"), offset = Vector(46, -7, 11) , ang = Angle(0, 179, -1), seq = "idle_all_02", mat = "", tag = "pr", hide = true },
		{ mdl = Model( "models/props_lab/blastdoor001a.mdl"), offset = Vector(-37, -16, 6) , ang = Angle(-90, 179, 0), seq = "idle", mat = "hunter/myplastic" },
		{ mdl = Model( "models/props_lab/blastdoor001c.mdl"), offset = Vector(-39, 124, 6) , ang = Angle(-90, 95, -6), seq = "idle_closed", mat = "hunter/myplastic" },
		{ mdl = Model( "models/props_lab/blastdoor001c.mdl"), offset = Vector(-16, -66, 6) , ang = Angle(-90, -71, 71), seq = "idle_closed", mat = "hunter/myplastic" },
		{ mdl = Model( "models/props_lab/blastdoor001c.mdl"), offset = Vector(68, -43, 6) , ang = Angle(-90, 89, 0), seq = "idle_closed", mat = "hunter/myplastic" },
		{ mdl = Model( "models/props/cs_office/file_cabinet1_group.mdl"), offset = Vector(-31, 101, 11) , ang = Angle(-1, -88, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_office/file_cabinet1_group.mdl"), offset = Vector(41, 104, 11) , ang = Angle(0, -88, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_lab/blastdoor001c.mdl"), offset = Vector(151, 42, 6) , ang = Angle(-90, -1, 0), seq = "idle_closed", mat = "hunter/myplastic" },
		{ mdl = Model( "models/player/group01/male_02.mdl"), offset = Vector(104, 31, 12) , ang = Angle(0, -145, 0), seq = "zombie_idle_01", mat = "", tag = "pr5", hide = true },
		{ mdl = Model( "models/player/group01/male_02.mdl"), offset = Vector(79, 22, 10) , ang = Angle(0, 179, -1), seq = "zombie_run_fast", mat = "", tag = "pr4", hide = true },
		{ mdl = Model( "models/player/group01/male_02.mdl"), offset = Vector(32, -78, 10) , ang = Angle(-2, 166, -1), seq = "idle_all_angry", mat = "", tag = "pr2", hide = true },
		{ mdl = Model( "models/player/group01/male_02.mdl"), offset = Vector(77, -51, 11) , ang = Angle(0, 161, -1), seq = "idle_all_scared", mat = "", tag = "pr3", hide = true },
		{ mdl = Model( "models/player/eli.mdl"), offset = Vector(-64, 16, 10) , ang = Angle(0, -151, 0), seq = "pose_standing_01", mat = "", tag = "matthias" },
	},
	Dialogues = function( sc )
		AddDialogueLine( sc.garry, ". . ." )
		AddDialogueLine( sc.matthias, "As you can see. . ." )
		AddDialogueLine( sc.garry, "Yeah. . .", "Splendid work.", ". . .", "Now they won't have any excuse." )
		AddDialogueLine( sc.matthias, "Yeah, I've noticed that things have been getting 'rusty'. . ." )
		AddDialogueLine( sc.garry, "Way too 'rusty'. . .", "Hahahahaha!" )
		AddDialogueLine( sc.matthias, "Hahahah!", ". . .", "So, what about my payment?" )
		AddDialogueLine( sc.garry, "Payment. . .", "There should be a truck around the corner.", "I think you will like what's inside." )
		AddDialogueLine( sc.matthias, "Nice.", "Before I leave. . ." )
		AddDialogueLine( sc.garry, ". . ." )
		AddDialogueLine( sc.matthias, "Take this. . ." )
		AddDialogueAction( sc.garry, function( me ) surface.PlaySound( "items/ammo_pickup.wav" ) end )
		AddDialogueLine( sc.matthias, "Something that we've found in CoderFired's office. . ." )
		AddDialogueLine( sc.garry, "What's this?" )
		AddDialogueLine( sc.matthias, "'Power Trip' addon.", "Have not got time to try it myself.", "So I thought you might like it." )
		AddDialogueLine( sc.garry, "Let's see. . ." )
		AddDialogueAction( sc.garry, function( me ) surface.PlaySound( "weapons/crossbow/bolt_skewer1.wav" ) end )
		AddDialogueLine( sc.matthias, "You should've not used entire dose at once. . .", ". . .but whatever.", "I've gotta go, soooo. . ." )
		AddDialogueLine( sc.garry, ". . ." )
		AddDialogueAction( sc.garry, function( me ) surface.PlaySound( "ambient/levels/citadel/strange_talk1.wav" ) end )
		AddDialogueLine( sc.matthias, "It was nice doing business with you!" )
		AddDialogueLine( sc.garry, ". . ." )
		AddDialogueAction( sc.matthias, function( me ) me.Hide = true surface.PlaySound( "doors/wood_move1.wav" ) end )
		AddDialogueLine( sc.garry, "That thing feels strange. . ." )
		AddDialogueLine( sc.pr, "Hello?" )
		AddDialogueAction( sc.pr, function( me ) me.Hide = false surface.PlaySound( "doors/door_latch3.wav" ) end )
		AddDialogueLine( sc.garry, ". . .", "Who are you?" )
		AddDialogueAction( sc.garry, function( me )
				local ang = me:GetAngles()
				ang:RotateAroundAxis( vector_up, 180 )
				me:SetAngles( ang ) 
				surface.PlaySound("UI/hint.wav")
			end )
		AddDialogueLine( sc.pr, "I just wanted to ask if. . ." )
		AddDialogueLine( sc.garry, "It's about gmod, isn't it?" )
		AddDialogueLine( sc.pr, "Yeah, I. . ." )
		AddDialogueLine( sc.garry, ". . .", "Go away.", "I don't give a shit." )
		AddDialogueLine( sc.pr, "No, wait! Hear me out. . ." )
		AddDialogueLine( sc.garry, "I said. . .", ". . ." )
		AddDialogueAction( sc.pr1, function( me ) me.Hide = false surface.PlaySound( "npc/stalker/breathing3.wav" ) end )
		AddDialogueLine( sc.pr1, "People are taking down servers left and right. . ." )
		AddDialogueLine( sc.garry, "No. . ." )
		AddDialogueAction( sc.pr2, function( me ) me.Hide = false surface.PlaySound( "npc/stalker/breathing3.wav" ) end )
		AddDialogueLine( sc.pr2, "DDOS attacks are all over the place. . ." )
		AddDialogueLine( sc.garry, "What the fuck. . ." )
		AddDialogueAction( sc.pr3, function( me ) me.Hide = false surface.PlaySound( "npc/stalker/breathing3.wav" ) end )
		AddDialogueLine( sc.pr3, "Servers are being overrun by little kids. . ." )
		AddDialogueLine( sc.garry, "Stop!" )
		AddDialogueAction( sc.pr4, function( me ) me.Hide = false surface.PlaySound( "npc/stalker/breathing3.wav" ) end )
		AddDialogueLine( sc.pr4, "People using paid addons to hide\ntheir own lazyness. . ." )
		AddDialogueLine( sc.garry, "How many of you are there?!" )
		AddDialogueAction( sc.pr5, function( me ) me.Hide = false surface.PlaySound( "npc/stalker/breathing3.wav" ) end )
		AddDialogueLine( sc.pr5, "I've seen a slavery camp in one of the communities. . ." )
		AddDialogueLine( sc.garry, ". . .", "Stop joining, you whiners!" )
		AddDialogueAction( sc.pr6, function( me ) me.Hide = false surface.PlaySound( "npc/stalker/breathing3.wav" ) end )
		AddDialogueLine( sc.pr6, "And you just want to walk away. . .", ". . .from all this!" )
		AddDialogueLine( sc.garry, "Leave me alone!" )
		AddDialogueLine( sc.pr1, "DMCA. . ." )
		AddDialogueAction( sc.pr1, function( me ) surface.PlaySound( "ambient/misc/brass_bell_c.wav" )  end )
		AddDialogueLine( sc.pr2, "DDOS. . ." )
		AddDialogueAction( sc.pr2, function( me ) surface.PlaySound( "ambient/misc/brass_bell_d.wav" )  end )
		AddDialogueLine( sc.pr3, "Pride and idiocy. . ." )
		AddDialogueAction( sc.pr3, function( me ) surface.PlaySound( "ambient/misc/brass_bell_e.wav" )  end )
		AddDialogueLine( sc.pr4, "Greed and abuse. . ." )
		AddDialogueAction( sc.pr4, function( me ) surface.PlaySound( "ambient/misc/brass_bell_f.wav" )  end )
		AddDialogueLine( sc.pr5, "Bloated communities. . ." )
		AddDialogueAction( sc.pr5, function( me ) surface.PlaySound( "ambient/misc/brass_bell_e.wav" )  end )
		AddDialogueLine( sc.pr6, "What happened to the old gmod?!" )
		AddDialogueAction( sc.pr6, function( me ) surface.PlaySound( "ambient/misc/brass_bell_d.wav" )  end )
		AddDialogueLine( sc.garry, "Shut up!!!" )
		AddDialogueLine( sc.pr, "Wait, who are you talking to?" )
		AddDialogueAction( sc.pr, function( me ) 
				sc.pr1.Hide = true
				sc.pr2.Hide = true
				sc.pr3.Hide = true
				sc.pr4.Hide = true
				sc.pr5.Hide = true
				sc.pr6.Hide = true
				surface.PlaySound( "physics/glass/glass_largesheet_break1.wav" ) 
			end )
		AddDialogueLine( sc.garry, ". . ." )
		AddDialogueLine( sc.pr, "Hello?" )
		AddDialogueAction( sc.pr, function( me ) surface.PlaySound( "ambient/levels/streetwar/strider_distant2.wav" ) end )
		AddDialogueLine( sc.garry, ". . ." )
		AddDialogueAction( sc.garry, function( me )
				local ang = me:GetAngles()
				ang:RotateAroundAxis( vector_up, 180 )
				me:SetAngles( ang ) 
				surface.PlaySound("UI/hint.wav")
			end )
		AddDialogueLine( sc.pr, "Mr. Newman?" )
		AddDialogueAction( sc.pr, function( me ) surface.PlaySound( "ambient/levels/streetwar/strider_distant3.wav" ) end )
	end,
}

GM.SingleplayerCutscenes["bad idea outro"] = {
	Intro = "2014\nOld garrysmod.com",
	SoundTrack = 262493467,//181430429,
	Volume = 28,//35,
	StartFrom = 3000,
	OverridePaint = function( self, sw, sh  )
	
		surface.SetDrawColor( color_black )
		surface.DrawRect( 0, 0, sw, sh )

		surface.SetMaterial( spooky_mat )
		
		surface.SetDrawColor( Color( 255, 255, 255, 250 ) )
		surface.DrawTexturedRectRotated( sw/2, sh/2, sw*1.3, sw*1.3, RealTime() * 0.4 + 180 )
		surface.SetDrawColor( Color( 255, 255, 255, 150 ) )
		surface.DrawTexturedRectRotated( sw/2, sh/2, sw*1.3, sw*1.3, -1 * RealTime() * 0.2 )
		
	end,
	Main = { mdl = Model( "models/hunter/plates/plate5x6.mdl" ), seq = "idle", mat = ""},
	Relative = {
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(45, 24, 3) , ang = Angle(-0, 90, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/metal_paintcan001a.mdl"), offset = Vector(98, -52, 13) , ang = Angle(-2, -116, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/metal_paintcan001b.mdl"), offset = Vector(108, -59, 11) , ang = Angle(89, 171, -66), seq = "idle", mat = "" },
		{ mdl = Model( "models/hunter/blocks/cube025x025x025.mdl"), offset = Vector(98, -39, 11) , ang = Angle(-1, -103, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/hunter/blocks/cube025x05x025.mdl"), offset = Vector(102, -27, 5) , ang = Angle(-1, -101, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(96, -25, 3) , ang = Angle(-0, 1, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_lab/clipboard.mdl"), offset = Vector(98, -19, 17) , ang = Angle(-0, 175, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-51, 119, 3) , ang = Angle(0, 91, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-2, 119, 3) , ang = Angle(-1, 90, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_canal/mattpipe.mdl"), offset = Vector(1, 100, 28) , ang = Angle(2, 62, -92), seq = "idle", mat = "" },
		{ mdl = Model( "models/player/group01/male_02.mdl"), offset = Vector(-20, 53, 4) , ang = Angle(-1, -93, 2), seq = "zombie_slump_idle_02", mat = "", tag = "pr" },
		{ mdl = Model( "models/props_junk/gascan001a.mdl"), offset = Vector(37, 91, 21) , ang = Angle(-32, 0, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(48, 119, 3) , ang = Angle(-0, 88, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(95, 119, 3) , ang = Angle(-1, 88, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/weapons/w_crowbar.mdl"), offset = Vector(74, 77, 18) , ang = Angle(75, 178, -75), seq = "idle", mat = "" },
		{ mdl = Model( "models/maxofs2d/companion_doll.mdl"), offset = Vector(71, 88, 19) , ang = Angle(-80, 112, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(49, 71, 4) , ang = Angle(-2, 89, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(97, 70, 4) , ang = Angle(-1, 90, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(94, 23, 3) , ang = Angle(-1, 90, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_lab/monitor01a.mdl"), offset = Vector(88, 24, 16) , ang = Angle(-6, -111, 89), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_lab/harddrive01.mdl"), offset = Vector(57, 22, 8) , ang = Angle(0, 15, -91), seq = "idle", mat = "" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-1, -121, 3) , ang = Angle(-0, -90, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-50, -26, 3) , ang = Angle(-1, 1, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/hunter/blocks/cube05x05x05.mdl"), offset = Vector(-92, -1, 17) , ang = Angle(-1, -127, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-98, -27, 3) , ang = Angle(-1, 1, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-100, -78, 3) , ang = Angle(-0, -175, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-97, -128, 3) , ang = Angle(-0, -90, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-51, -74, 3) , ang = Angle(-1, 91, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-49, -123, 3) , ang = Angle(-1, -90, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(45, -75, 3) , ang = Angle(-1, 91, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(93, -124, 3) , ang = Angle(-0, 1, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/weapons/w_physics.mdl"), offset = Vector(84, -64, 9) , ang = Angle(-12, 109, -4), seq = "idle", mat = "" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(66, -25, 6) , ang = Angle(-8, -3, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-4, -72, 3) , ang = Angle(-1, 91, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(47, -123, 3) , ang = Angle(-1, 1, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/player/soldier_stripped.mdl"), offset = Vector(-15, -21, 4) , ang = Angle(0, 93, -1), seq = "pose_standing_01", mat = "", tag = "garry" },
		{ mdl = Model( "models/player/group01/male_02.mdl"), offset = Vector(-10, 1, 6) , ang = Angle(-1, 92, 0), seq = "idle_all_01", mat = "", lp = true, hide = true, tag = "ohno" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(94, -73, 4) , ang = Angle(-1, 91, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(-30, 20, 215) , ang = Angle(89, -25, -2), seq = "Idle", mat = "" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-98, 21, 3) , ang = Angle(0, 180, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_assault/dollar.mdl"), offset = Vector(-86, -2, 29) , ang = Angle(-8, -54, -4), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/shoe001a.mdl"), offset = Vector(-94, 40, 8) , ang = Angle(-5, 52, -97), seq = "idle", mat = "" },
		{ mdl = Model( "models/maxofs2d/camera.mdl"), offset = Vector(-64, 51, 5) , ang = Angle(3, -120, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-95, 70, 3) , ang = Angle(-1, 91, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-50, 23, 3) , ang = Angle(-1, 180, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-47, 70, 3) , ang = Angle(0, 91, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_c17/gravestone_coffinpiece002a.mdl"), offset = Vector(-24, 98, 17) , ang = Angle(0, 180, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-99, 117, 3) , ang = Angle(-1, 91, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-2, 25, 3) , ang = Angle(-1, 180, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(2, 72, 2) , ang = Angle(-2, 89, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-2, -24, 3) , ang = Angle(-1, 1, -1), seq = "idle", mat = "" },
	},
	Dialogues = function( sc )
		AddDialogueLine( sc.pr, ". . .", "What. . .", "What happened?" )
		AddDialogueLine( sc.garry, "I killed you." )
		AddDialogueLine( sc.pr, "Why am I. . ." )
		AddDialogueLine( sc.garry, "But then I thought. . .", "That was way too kind of me.", "Since you want to be that 'special snowflake'. . ." )
		AddDialogueLine( sc.pr, ". . ." )
		AddDialogueLine( sc.garry, "Among all these idiots, that keep annoying me. . ." )
		AddDialogueLine( sc.pr, "This place looks familiar. . ." )
		AddDialogueLine( sc.garry, ". . .you are going to spend rest of your days in here.", "Next to your 'good old gmod'.", ". . .", "That's gonna hurt. . .", ". . .knowing that it will never come back.", "Yet it's here, behind you." )
		AddDialogueLine( sc.pr, ". . .", "No. . ." )
		AddDialogueLine( sc.garry, "So yeah. . .", "Have fun with your very personal torture. . .", ". . .being a slave of gmod.", "I've got better things to do. . .", ". . .than babysitting with this community." )
		AddDialogueLine( sc.pr, ". . ." )
		AddDialogueAction( sc.garry, function( me ) me.Hide = true surface.PlaySound( "UI/hint.wav" ) end )
		AddDialogueLine( sc.pr, "That's not fair. . .", "*sigh*" )
		AddDialogueLine( sc.pr, "If only I could. . ." )
		AddDialogueAction( sc.ohno, function( me ) me.Hide = false surface.PlaySound( "UI/hint.wav" ) end )
		AddDialogueLine( sc.pr, ". . .", "Oh no. . ." )
	end,
	
}


GM.SingleplayerCutscenes["legacy"] = {
	Act = "BONUS ACT, PART ONE:\n'BIG SERVER MEN'",
	Intro = "2016\nLovely pier of feels and safety",
	SoundTrack = 426293556,//281230919,
	StartFrom = 18900,//35500,
	Volume = 65,
	Main = { mdl = Model( "models/hunter/plates/plate1x2.mdl" ), seq = "idle", mat = ""},
	Relative = {
		{ mdl = Model( "models/props_c17/handrail04_short.mdl"), offset = Vector(-95, 79, 25) , ang = Angle(-2, 0, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/popcan01a.mdl"), offset = Vector(-28, -906, 7) , ang = Angle(30, 3, -85), seq = "idle", mat = "", tag = "ex" },
		{ mdl = Model( "models/props_lab/huladoll.mdl"), offset = Vector(2, -1000, 64) , ang = Angle(1, -91, -2), seq = "idle", mat = "", hide = true, tag = "watch", icon = Material( "sog/watch.png", "smooth" ) },
		{ mdl = Model( "models/props_junk/shoe001a.mdl"), offset = Vector(-1, -958, 70) , ang = Angle(0, -96, -3), seq = "idle", mat = "", hide = true, tag = "dude1", icon = Material( "sog/kleiner.png", "smooth" ) },
		{ mdl = Model( "models/props_junk/shoe001a.mdl"), offset = Vector(-30, -958, 69) , ang = Angle(0, -85, 8), seq = "idle", mat = "", hide = true, tag = "dude2", icon = Material( "sog/kleiner2.png", "smooth" ) },
		{ mdl = Model( "models/props_vehicles/car005a_physics.mdl"), offset = Vector(-11, -992, 26) , ang = Angle(-1, -90, 0), seq = "idle", mat = "", tag = "car2", hide = true },
		{ mdl = Model( "models/props_phx/huge/road_short.mdl"), offset = Vector(37, -924, -4) , ang = Angle(-1, 0, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_phx/construct/wood/wood_panel4x4.mdl"), offset = Vector(64, -55, 1) , ang = Angle(0, 0, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_c17/suitcase_passenger_physics.mdl"), offset = Vector(50, 65, 23) , ang = Angle(-1, -161, 1), seq = "idle", mat = "" },
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(-17, 2, 245) , ang = Angle(89, 160, 0), seq = "Idle", mat = "" },
		{ mdl = Model( "models/props_c17/handrail04_medium.mdl"), offset = Vector(-94, 26, 25) , ang = Angle(-1, -1, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_c17/handrail04_medium.mdl"), offset = Vector(-93, -41, 28) , ang = Angle(-1, 0, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/de_inferno/potted_plant1.mdl"), offset = Vector(-82, -72, 5) , ang = Angle(-3, 12, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/player/alyx.mdl"), offset = Vector(-49, -26, 5) , ang = Angle(0, 163, 0), seq = "pose_standing_01", mat = "", tag = "moderator", PlayerColor = Color( 215, 77, 64 ) },
		{ mdl = Model( "models/player/group01/male_09.mdl"), offset = Vector(-46, 9, 5) , ang = Angle(0, -180, 0), seq = "pose_standing_02", mat = "", tag = "mark", PlayerColor = Color( 215, 77, 64 ) },
		{ mdl = Model( "models/props_vehicles/car005a_physics.mdl"), offset = Vector(-27, 145, 36) , ang = Angle(0, -91, 0), seq = "idle", mat = "", tag = "car1", hide = true, shake = true, icon = Material( "sog/watch.png", "smooth" ) },
		{ mdl = Model( "models/props_c17/paper01.mdl"), offset = Vector(53, -15, 39) , ang = Angle(0, 156, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/de_tides/restaurant_table.mdl"), offset = Vector(74, -6, 5) , ang = Angle(0, -27, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/caseofbeer01.mdl"), offset = Vector(63, 6, 38) , ang = Angle(0, -179, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/de_tides/patio_chair2.mdl"), offset = Vector(71, 51, 5) , ang = Angle(-1, -77, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_c17/suitcase_passenger_physics.mdl"), offset = Vector(69, 53, 43) , ang = Angle(-4, -127, -4), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/de_tides/menu_stand.mdl"), offset = Vector(77, -59, 35) , ang = Angle(0, -28, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/de_inferno/potted_plant2.mdl"), offset = Vector(-79, 101, 5) , ang = Angle(-1, -29, -1), seq = "idle", mat = "" },
	},
	Dialogues = function( sc )
		sc.car1.OnDraw = function()
			if sc.car1.lerp then
				local goal = sc.car2:GetPos()
				if not sc.car1.startpos then sc.car1.startpos = sc.car1:GetPos() end
				if not sc.car1.starttime then sc.car1.starttime = CurTime() + 0.8 end
				local origin = sc.car1.startpos
				sc.car1:SetPos( LerpVector( math.Clamp( 1 - ( sc.car1.starttime - CurTime() ) / 1, 0, 1 ), origin, goal ) )
				sc.car1.OriginalPos = sc.car1:GetPos()
			end
		end
		sc.ex.OnDraw = function()
			if sc.Emitter and sc.car1.smoke then
				sc.ex.NextPuff = sc.ex.NextPuff or 0
				if sc.ex.NextPuff < CurTime() then
					local particle = sc.Emitter:Add( "particles/smokey", sc.ex:GetPos() )
					particle:SetVelocity(math.Rand(0.1, 0.7)*Vector( 0, 340, 0 )+VectorRand()*2+vector_up*math.random(10))
					particle:SetDieTime(math.Rand(0.5, 1))
					particle:SetStartAlpha(100)
					particle:SetEndAlpha(0)
					particle:SetStartSize(math.random(2,4))
					particle:SetEndSize(math.random(6,13))
					particle:SetRoll(math.Rand(-180, 180))
					particle:SetColor(100, 100, 100)
					particle:SetAirResistance(15)
					sc.ex.NextPuff = CurTime() + math.Rand( 0, 0.09 )
				end
			end
		end
		AddDialogueLine( sc.moderator, ". . .", "This is such a lovely evening.", "If only we could enjoy it forever. . ." )
		AddDialogueLine( sc.mark, "Oh yes!" )
		AddDialogueLine( sc.moderator, "Ah. . .", "Reminds me of my younger days. . .", ". . .when I used to have fun. . ." )
		AddDialogueLine( sc.mark, "Oh yes!" )
		AddDialogueLine( sc.moderator, "Oh my. . .", "Look over there!", ". . .", "It's a seagull!", "Isn't it beautiful?" )
		AddDialogueLine( sc.mark, "Oh yes!" )
		AddDialogueLine( sc.moderator, "*sigh*", "You know. . .", ". . .", "I have to tell you something. . .", "I have this strange feeling. . ." )
		AddDialogueLine( sc.moderator, "It's like. . .", "Sometimes I feel like there is something. . .", ". . .something changed inside me. . .", ". . .that makes me feel. . .", ". . .like a car." )
		AddDialogueLine( sc.mark, ". . .", ". . .a car?" )
		
		AddDialogueLine( sc.car1, "Whoops!" )
		AddDialogueAction( sc.car1, function( me )
				me.Hide = false
				me.lerp = true
				surface.PlaySound( "vehicles/v8/vehicle_impact_heavy3.wav" ) 
				surface.PlaySound( "vo/npc/male01/pain07.wav" )
				surface.PlaySound( "ambient/voices/f_scream1.wav" )
				
				sc.mark:SetSequence( sc.mark:LookupSequence( "zombie_slump_idle_01" ) )
				sc.moderator:SetSequence( sc.moderator:LookupSequence( "zombie_slump_idle_01" ) )				
				
				if SOG_CUTSCENE_MUSIC then
					//sc.Music = GAMEMODE:CreateSCPanel( Cut, 238014896, 50, false, false, 10500, nil )
					GAMEMODE:CreateMusic( MUSIC_TYPE_NORMAL, 238014896, 50, false, 10500, nil )
					sc.Volume = 60/100 or 0.25
					sc.CurVolume = sc.Volume
				end
				
			end )
		AddDialogueLine( sc.watch, ". . .", "Oh. . .", "Hi, there!", "What was your name again?", "!PLAYERNAME. . .", "What a weird name!" )
		AddDialogueLine( sc.watch, "Anyway. . .", "I bet you are wondering. . .", "'Aren't these guys supposed to be dead already?'", "Well, the answer is 'Yes'!" )
		AddDialogueLine( sc.watch, "As for me. . .", "Well, lets just say. . .", "I'm pursuing the true evil of this game!", "The unspeakable syndicate of greed and corruption!" )
		AddDialogueLine( sc.watch, "The Big Server Men!", ". . .", "Oh yeah!", "And how I like to say. . ." )
		AddDialogueLine( sc.watch, "I'm gonna put them. . ." )
		AddDialogueLine( sc.watch, ". . .on watch!" )
		AddDialogueAction( sc.watch, function( me ) surface.PlaySound( "weapons/shotgun/shotgun_cock.wav" ) end )
		AddDialogueLine( sc.dude1, "Nooo, stop that!", "I told you, my letstorturegmod doll is better!" )
		AddDialogueLine( sc.dude2, "No, it's not!", "My letstorturegmod doll has rockets!" )
		AddDialogueLine( sc.dude1, "Nooo!" )
		AddDialogueLine( sc.watch, "What the. . .", "What are you both doing in my car?!" )
		AddDialogueLine( sc.dude1, "But don't you remember, watch. . ." )
		AddDialogueLine( sc.watch, "It's Detective Watch to you, boy!" )
		AddDialogueLine( sc.dude1, ". . ." )
		AddDialogueLine( sc.dude2, "Mom asked you to take us home\nfrom darkrp server, remember?" )
		AddDialogueLine( sc.watch, "Oh. . .", "Damn it!" )
		AddDialogueLine( sc.dude1, "Wait, stop the car!", "It's letstorturegmod's mansion!" )
		AddDialogueLine( sc.dude2, "Sweet! It is!", "Can we get some souvenirs?!" )
		AddDialogueLine( sc.dude1, "Pleeeeeeaaseeeee!!!" )
		AddDialogueLine( sc.watch, "Argh!", "If I do that, will you both shut up?!" )
		AddDialogueLine( sc.dude1, "Yes!" )
		AddDialogueLine( sc.watch, "Fine!", "But I'm not gonna walk there, so. . ." )
		AddDialogueLine( sc.dude2, ". . ." )
		AddDialogueLine( sc.watch, ". . .get that stupid chair out of the trunk!" )
		
		
		AddDialogueAction( sc.watch, function( me )
			sc.car1.smoke = true
			sc.vCamPos.x = -11
			sc.vCamPos.y = -992
		end )
			
			
	end
	
	
}

GM.SingleplayerCutscenes["overdrive"] = {
	Intro = "2016\nSomewhere on a highway",
	SoundTrack = 238014896,
	StartFrom = 10500,
	Volume = 60,
	Main = { mdl = Model( "models/hunter/plates/plate1x2.mdl" ), seq = "idle", mat = ""},
	Relative = {
		{ mdl = Model( "models/props_junk/popcan01a.mdl"), offset = Vector(-28, -906, 7) , ang = Angle(30, 3, -85), seq = "idle", mat = "", tag = "ex" },
		{ mdl = Model( "models/props_lab/huladoll.mdl"), offset = Vector(2, -1000, 64) , ang = Angle(1, -91, -2), seq = "idle", mat = "", hide = true, tag = "watch", icon = Material( "sog/watch.png", "smooth" ) },
		{ mdl = Model( "models/props_junk/shoe001a.mdl"), offset = Vector(-1, -958, 70) , ang = Angle(0, -96, -3), seq = "idle", mat = "", hide = true, tag = "dude1", icon = Material( "sog/kleiner.png", "smooth" ) },
		{ mdl = Model( "models/props_junk/shoe001a.mdl"), offset = Vector(-30, -958, 69) , ang = Angle(0, -85, 8), seq = "idle", mat = "", hide = true, tag = "dude2", icon = Material( "sog/kleiner.png", "smooth" ) },
		{ mdl = Model( "models/props_vehicles/car005a_physics.mdl"), offset = Vector(-11, -992, 26) , ang = Angle(-1, -90, 0), seq = "idle", mat = "", tag = "car2", shake = true, icon = Material( "sog/watch.png", "smooth" ) },
		{ mdl = Model( "models/props_phx/huge/road_short.mdl"), offset = Vector(37, -924, -4) , ang = Angle(-1, 0, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(-11, -992, 265) , ang = Angle(89, 120, 0), seq = "Idle", mat = "" },
	},
	Dialogues = function( sc )
		sc.ex.OnDraw = function()
			if sc.Emitter then
				sc.ex.NextPuff = sc.ex.NextPuff or 0
				if sc.ex.NextPuff < CurTime() then
					local particle = sc.Emitter:Add( "particles/smokey", sc.ex:GetPos() )
					particle:SetVelocity(math.Rand(0.1, 0.7)*Vector( 0, 340, 0 )+VectorRand()*2+vector_up*math.random(10))
					particle:SetDieTime(math.Rand(0.5, 1))
					particle:SetStartAlpha(100)
					particle:SetEndAlpha(0)
					particle:SetStartSize(math.random(2,4))
					particle:SetEndSize(math.random(6,13))
					particle:SetRoll(math.Rand(-180, 180))
					particle:SetColor(100, 100, 100)
					particle:SetAirResistance(15)
					sc.ex.NextPuff = CurTime() + math.Rand( 0, 0.09 )
				end
			end
		end
		AddDialogueLine( sc.watch, ". . .", "Oh. . .", "It's you again.", "Now, where was I. . ."  )
		AddDialogueLine( sc.watch, "Oh, right!", "The Big Server Men!", "If you still have not realised why they are bad. . .", ". . .that means you have not been paying attention!" )	
		AddDialogueLine( sc.watch, "I mean, if you need proof. . .", "Just look at this shitty server browser!" )
		AddDialogueLine( sc.watch, "Now you look at it and tell me that this shit\nis not rigged?", "So it only shows shitty servers on top." )
		AddDialogueLine( sc.watch, "Because it is!", "Oh yeah!" )
		AddDialogueLine( sc.watch, "Perhaps you are going to ask. . .", "'But Mister Watch, how do you know\nif someone is a big server men?", ". . ." )
		AddDialogueLine( sc.watch, "That is a good question, young !PLAYERNAME!", "Firstly: they treat this game like business\nand will always talk shit!" )
		AddDialogueLine( sc.watch, "Secondly. . .", "They have very luxurous cars,\njust like ones I can see on my right. . ." )
		AddDialogueLine( sc.watch, "Hold the fuck up!!!" )
		AddDialogueAction( sc.watch, function( me ) 
			surface.PlaySound( "vehicles/v8/skid_lowfriction.wav" )
			surface.PlaySound( "vehicles/v8/v8_stop1.wav" )

			for k, v in pairs( sc.Relative ) do
				if sc.Relative[k] and sc.Relative[k].Shake then
					sc.Relative[k].Shake = false
				end
				sc.ex.NextPuff = CurTime() + 9999999
			end
			
		end )
		AddDialogueLine( sc.watch, "These are some very nice cars, indeed!", "Gentlemen, it is time to investigate!" )
		
	end
	
	
}


GM.SingleplayerCutscenes["big server men"] = {
	Intro = "2016\nTotally not suspicious yard",
	SoundTrack = 238014896,
	StartFrom = 10500,
	Volume = 60,
	Main = { mdl = Model( "models/hunter/plates/plate2x2.mdl" ), seq = "idle", mat = ""},
	Relative = {
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(-250, -50, 47) , ang = Angle(8, 75, 4), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/de_nuke/car_nuke_glass.mdl"), offset = Vector(-308, 129, 6) , ang = Angle(-1, 110, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/de_nuke/car_nuke_glass.mdl"), offset = Vector(-291, -101, 6) , ang = Angle(-1, -38, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/player/breen.mdl"), offset = Vector(-328, -73, 6) , ang = Angle(-1, 135, -1), seq = "pose_standing_01", mat = "", PlayerColor = Color( 20, 20, 20 ) },
		{ mdl = Model( "models/props_vehicles/car003a_physics.mdl"), offset = Vector(83, 154, 28) , ang = Angle(-1, -1, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/hunter/plates/plate5x8.mdl"), offset = Vector(-265, 1, 4) , ang = Angle(-1, -180, 0), seq = "idle", mat = "models/props_debris/concretefloor013a" },
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(110, -9, 241) , ang = Angle(89, -132, -1), seq = "Idle", mat = "" },
		{ mdl = Model( "models/player/magnusson.mdl"), offset = Vector(130, -4, 5) , ang = Angle(0, -90, -1), seq = "cidle_all", mat = "", tag = "watch", icon = Material( "sog/watch.png", "smooth" ) },
		{ mdl = Model( "models/hunter/plates/plate7x7.mdl"), offset = Vector(3, 10, 3) , ang = Angle(-1, -1, 0), seq = "idle", mat = "models/props_debris/concretefloor013a" },
		{ mdl = Model( "models/props_vehicles/car005a_physics.mdl"), offset = Vector(69, -12, 31) , ang = Angle(0, -106, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_vehicles/car003a_physics.mdl"), offset = Vector(95, -140, 33) , ang = Angle(-1, -1, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_assault/barrelwarning.mdl"), offset = Vector(-170, 95, 6) , ang = Angle(-1, 5, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/de_nuke/car_nuke_black.mdl"), offset = Vector(-308, 129, 6) , ang = Angle(-1, 110, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/player/breen.mdl"), offset = Vector(-298, 46, 6) , ang = Angle(0, -135, -1), seq = "pose_standing_01", mat = "", PlayerColor = Color( 20, 20, 20 ) },
		{ mdl = Model( "models/player/breen.mdl"), offset = Vector(-319, 25, 6) , ang = Angle(-1, 45, -1), seq = "pose_standing_02", mat = "", PlayerColor = Color( 20, 20, 20 ), tag = "watch2", icon = Material( "sog/watch.png", "smooth" ) },
		{ mdl = Model( "models/props/de_nuke/car_nuke_black.mdl"), offset = Vector(-291, -101, 6) , ang = Angle(-1, -38, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(-256, -39, 47) , ang = Angle(17, 84, -3), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_assault/money.mdl"), offset = Vector(-257, -44, 46) , ang = Angle(9, 28, -6), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_assault/barrelwarning.mdl"), offset = Vector(-169, -66, 6) , ang = Angle(0, 19, -1), seq = "idle", mat = "" },
	},
	Dialogues = function( sc )
		AddDialogueLine( sc.watch, ". . .", "Oh, you are back.", "Shhhh!" )
		AddDialogueLine( sc.watch, "Do you see what I see?", ". . .", "Have a look!" )
		AddDialogueLine( sc.watch2, "See?", "I think I have found them!", "Black slick suits. . .", "Shit eating grin on the face. . .", "And extremely expensive cars!" )
		AddDialogueLine( sc.watch, "You don't have to be a detective to figure it out.", "But thankfully. . .", "I have completed my trial detective course online." )
		AddDialogueLine( sc.watch, "This is it, big server men!", "Soon you will have my permission to be die!", ". . .", "What?", "Who cares that I took it from a cool youtube video!" )
		AddDialogueLine( sc.watch2, "Hm. . .", "I can't just walk in there though." )
		AddDialogueLine( sc.watch, "So. . .", "Let's put the game face on!" )
		AddDialogueLine( sc.watch, ". . ." )
		AddDialogueAction( sc.watch, function( me ) 
			surface.PlaySound( "physics/body/body_medium_break4.wav" )
			if Dialogue then Dialogue.SpinPortrait = true end
		end )
	end
}

GM.SingleplayerCutscenes["served cold"] = {
	Intro = "2016\nShitGamers basement\nalso known as Big Server Men Secret Hideout",
	SoundTrack = 324892532,
	StartFrom = 26500,
	Volume = 70,
	Main = { mdl = Model( "models/hunter/plates/plate2x2.mdl" ), seq = "idle", mat = ""},
	Relative = {
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(-91, -12, 353) , ang = Angle(88, -107, -1), seq = "Idle", mat = "" },
		{ mdl = Model( "models/props_lab/securitybank.mdl"), offset = Vector(-23, 74, 4) , ang = Angle(-35, -75, -5), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_debris/plaster_ceilingpile001a.mdl"), offset = Vector(-41, 23, 60) , ang = Angle(13, -37, 14), seq = "idle", mat = "models/skeleton/skeleton_bloody" },
		{ mdl = Model( "models/props_lab/workspace003.mdl"), offset = Vector(-266, 65, -2) , ang = Angle(-72, 157, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_lab/servers.mdl"), offset = Vector(-107, -130, 6) , ang = Angle(-53, -8, -13), seq = "idle", mat = "" },
		{ mdl = Model( "models/player/breen.mdl"), offset = Vector(-1, -30, 31) , ang = Angle(0, 180, -1), seq = "pose_standing_01", mat = "", tag = "dude", PlayerColor = Color( 20, 20, 20 ) },
		{ mdl = Model( "models/props_debris/walldestroyed09a.mdl"), offset = Vector(-155, -15, 34) , ang = Angle(-1, 0, -1), seq = "", mat = "models/skeleton/skeleton_bloody" },
		{ mdl = Model( "models/props_debris/concrete_cornerpile01a.mdl"), offset = Vector(23, -119, 58) , ang = Angle(-1, 74, 7), seq = "idle", mat = "models/skeleton/skeleton_bloody" },
		{ mdl = Model( "models/player/magnusson.mdl"), offset = Vector(-105, -15, 84) , ang = Angle(-3, 3, 1), seq = "drive_pd", mat = "", tag = "watch", icon = Material( "sog/watch.png", "smooth" ) },
		{ mdl = Model( "models/props_c17/gravestone_cross001b.mdl"), offset = Vector(-126, -16, 90) , ang = Angle(-1, 4, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_lab/monitor02.mdl"), offset = Vector(-55, -112, 37) , ang = Angle(-9, -106, 81), seq = "idle", mat = "" },
	},
	Dialogues = function( sc )
		AddDialogueLine( sc.watch, ". . .", "What the. . .", "Let me go, you shady bastards!" )
		AddDialogueLine( sc.watch, "You won't get away with this!" )
		AddDialogueLine( sc.dude, "Nooo!", "Shut up!", "And stop wiggling around like a worm." )
		AddDialogueLine( sc.watch, ". . .", "And where is my food?", "Your stupid leader said something about feeding." )
		AddDialogueLine( sc.dude, "Yes, but not for you.", ". . .", "You are gonna be the dessert." )
		AddDialogueLine( sc.watch, "Argh!", ". . .", "Think, captain watch, think. . .", "Aha!", "Hey, you!" )
		AddDialogueLine( sc.dude, ". . .", "What is it?" )
		AddDialogueLine( sc.watch, "Since I'm tied and stuff. . .", "Can I take a piss really quick, at least?" )
		AddDialogueLine( sc.dude, ". . .", "Go ahead." )
		AddDialogueLine( sc.watch, ". . .", "I mean, you have to untie me.", "You know how this works!" )
		AddDialogueLine( sc.dude, "*picks nose*", ". . .", "Fine. . .", "But make it quick.", "Marishka is about to come back." )
		AddDialogueLine( sc.watch, "Oh. . .", "Yeah!", "Don't worry!" )
	end
	
	
}

GM.SingleplayerCutscenes["served cold outro"] = {
	Intro = "2016\nHighway of Victory",
	SoundTrack = 328167987,
	StartFrom = 11500,
	Volume = 60,
	RedLighting = true,
	OverridePaint = SunsetBackground,
	StaticCamera = true,
	Main = { mdl = Model( "models/hunter/plates/plate1x1.mdl" ), seq = "idle", mat = ""},
	Relative = {
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(22, -575, 848) , ang = Angle(2.8, 90, 0), seq = "Idle", mat = "" },
		{ mdl = Model( "models/props_junk/popcan01a.mdl"), offset = Vector(38, -392, 763) , ang = Angle(83, -94, -6), seq = "idle", mat = "", tag = "ex" },
		{ mdl = Model( "models/props_phx/huge/road_medium.mdl"), offset = Vector(22, -113, 750) , ang = Angle(0, 0, -1), seq = "idle", mat = "", hide = true },
		{ mdl = Model( "models/player/magnusson.mdl"), offset = Vector(3, -324, 772) , ang = Angle(0, 90, 0), seq = "drive_jeep", mat = "", tag = "watch", icon = Material( "sog/watch.png", "smooth" ), shake = true },
		{ mdl = Model( "models/props_vehicles/car005a.mdl"), offset = Vector(20, -310, 780) , ang = Angle(0, 90, -1), seq = "idle", mat = "", shake = true, tag = "radio", icon = Material( "sog/carradio.png", "smooth" ) },
	},
	Dialogues = function( sc )
		sc.ex.OnDraw = function()
			if sc.Emitter then
				sc.ex.NextPuff = sc.ex.NextPuff or 0
				if sc.ex.NextPuff < CurTime() then
					local particle = sc.Emitter:Add( "particles/smokey", sc.ex:GetPos() )
					particle:SetVelocity(math.Rand(0.1, 0.7)*Vector( 0, -340, 0 )+VectorRand()*2+vector_up*math.random(10))
					particle:SetDieTime(math.Rand(0.5, 1))
					particle:SetStartAlpha(100)
					particle:SetEndAlpha(0)
					particle:SetStartSize(math.random(2,4))
					particle:SetEndSize(math.random(6,13))
					particle:SetRoll(math.Rand(-180, 180))
					particle:SetColor(100, 100, 100)
					particle:SetAirResistance(15)
					sc.ex.NextPuff = CurTime() + math.Rand( 0, 0.09 )
				end
			end
		end
		AddDialogueLine( sc.watch, ". . .", "And that is how I've beaten big server men!" )
		AddDialogueLine( sc.watch, "Pretty cool, huh?", ". . .", "Of course, it is!" )
		AddDialogueLine( sc.watch, "Now that this game is free from terror. . .", "Everyone can safely play and have fun!" )
		AddDialogueLine( sc.watch, ". . .", "Well. . .", "At least these, who didn't die during cough outbreak." )
		AddDialogueLine( sc.watch, "As for me. . .", "Hah!", "You are always curious about me, aren't you?", "I have got more things to save!" )
		AddDialogueLine( sc.watch, "Damn, this track is so good!", "Let's crank it up, shall we?" )
		AddDialogueLine( sc.radio, "*chkt*" )
		AddDialogueLine( sc.watch, ". . ." )
		AddDialogueLine( sc.radio, "Breaking news!", "The entire population of g. . .", "!g̴ ̸ ̷ ̸ ̸ ̴ ̷ ̸ ̵ ̵ ̶ ̶ ̷ ̴" )
		AddDialogueLine( sc.watch, "Hm?" )
		
	end
} 

GM.SingleplayerCutscenes["this is fine"] = {
	Act = "BONUS ACT, PART TWO:\n'DEATH OF GMOD'",
	Intro = "Few days earlier\nSAMSARA Bar",
	SoundTrack = 484695585,
	StartFrom = 23000,
	Volume = 60,
	Main = { mdl = Model( "models/hunter/blocks/cube1x1x025.mdl" ), seq = "idle", mat = ""},
	Relative = {
		{ mdl = Model( "models/props/cs_militia/bottle01.mdl"), offset = Vector(7, -39, 54) , ang = Angle(-1, 90, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/caseofbeer01.mdl"), offset = Vector(-94, 20, 67) , ang = Angle(-1, 169, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/caseofbeer01.mdl"), offset = Vector(-96, 14, 35) , ang = Angle(0, 149, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/caseofbeer01.mdl"), offset = Vector(-96, -29, 35) , ang = Angle(0, -150, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/caseofbeer01.mdl"), offset = Vector(-99, -15, 35) , ang = Angle(-1, 7, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/caseofbeer01.mdl"), offset = Vector(-98, -56, 67) , ang = Angle(0, -177, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/caseofbeer01.mdl"), offset = Vector(-97, -24, 67) , ang = Angle(0, -138, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/caseofbeer01.mdl"), offset = Vector(-102, -75, 35) , ang = Angle(-1, 90, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/shelves_wood.mdl"), offset = Vector(-96, -28, 8) , ang = Angle(-1, -1, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/caseofbeer01.mdl"), offset = Vector(-100, -83, 67) , ang = Angle(0, 174, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/caseofbeer01.mdl"), offset = Vector(-97, -68, 67) , ang = Angle(-1, -178, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/bottle01.mdl"), offset = Vector(0, -85, 54) , ang = Angle(-3, 30, -3), seq = "idle", mat = "" },
		{ mdl = Model( "models/weapons/w_knife_ct.mdl"), offset = Vector(0, -80, 54) , ang = Angle(0, 81, -91), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/bottle03.mdl"), offset = Vector(-7, -54, 54) , ang = Angle(-1, 81, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/bar01.mdl"), offset = Vector(-34, -65, 10) , ang = Angle(0, -91, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/circularsaw01.mdl"), offset = Vector(-35, -116, 54) , ang = Angle(-2, 41, 15), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/caseofbeer01.mdl"), offset = Vector(-13, -107, 54) , ang = Angle(0, 45, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/player/group03/male_06.mdl"), offset = Vector(-39, -54, 8) , ang = Angle(-1, -1, 0), seq = "pose_standing_02", mat = "", tag = "dude" },
		{ mdl = Model( "models/hunter/plates/plate3x7.mdl"), offset = Vector(-4, 17, 8) , ang = Angle(-1, -1, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/barstool01.mdl"), offset = Vector(27, -91, 10) , ang = Angle(0, -92, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/player/eli.mdl"), offset = Vector(27, -93, 44) , ang = Angle(0, 106, -5), seq = "sit_knife", mat = "", tag = "matthias" },
		{ mdl = Model( "models/props/cs_militia/barstool01.mdl"), offset = Vector(39, 67, 10) , ang = Angle(0, -19, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/de_tides/menu_stand.mdl"), offset = Vector(24, 117, 40) , ang = Angle(0, -136, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/barstool01.mdl"), offset = Vector(47, -2, 17) , ang = Angle(-88, -73, 2), seq = "idle", mat = "" },
		{ mdl = Model( "models/player/group03/male_03.mdl"), offset = Vector(42, -30, 45) , ang = Angle(-1, -160, 1), seq = "sit", mat = "", tag = "james", icon = Material( "sog/james.png", "smooth" ) },
		{ mdl = Model( "models/props/cs_militia/barstool01.mdl"), offset = Vector(38, -31, 10) , ang = Angle(-1, -92, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/bar01.mdl"), offset = Vector(-52, 58, 10) , ang = Angle(-1, 0, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/weapons/w_shotgun.mdl"), offset = Vector(-1, -16, 55) , ang = Angle(-3, -24, 86), seq = "idle1", mat = "" },
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(7, -43, 246) , ang = Angle(89, 137, -6), seq = "Idle", mat = "" },
	},	
	Dialogues = function( sc )
		AddDialogueLine( sc.matthias, ". . .", "Goddamn!", "This place still smells like a damn zoo!" )
		AddDialogueLine( sc.dude, ". . .", "Yup.", "By the way. . .", "What even happened to garry's money in the end?")
		AddDialogueLine( sc.matthias, "Oh these. . .", "I can't fucking believe it!", ". . .", "Truck that garry has told me about. . ." )
		AddDialogueLine( sc.matthias, "It was full of shit!" )
		AddDialogueLine( sc.dude, "Huh?" )
		AddDialogueLine( sc.matthias, "Literally!", "It was a truck that drains shit from sewers!" )
		AddDialogueLine( sc.dude, "Wow. . ." )
		AddDialogueLine( sc.matthias, "Don't even mention it.", "At least now we have one last thing to do.", "Speaking of which. . .", "James." )
		AddDialogueLine( sc.james, ". . ." )
		AddDialogueLine( sc.matthias, "I think you know why I have called you here." )
		AddDialogueLine( sc.james, ". . .", "To take down all these cats?" )
		AddDialogueLine( sc.matthias, "Well yes, but not just that. . .", "Are you ready to do one last job?" )
		AddDialogueLine( sc.james, "Hm?" )
		AddDialogueLine( sc.matthias, "I mean, I'd do it myself, but. . ." )
		AddDialogueLine( sc.dude, ". . ." )
		AddDialogueLine( sc.matthias, ". . .but I ain't gonna.", "It might be too dangerous.", ". . .", "So all you need to do. . .", ". . .is to kill the gmod!" )
		AddDialogueLine( sc.james, ". . ." )
		AddDialogueLine( sc.dude, "Hold up.", "I thought we have done this before?" )
		AddDialogueLine( sc.matthias, "Yes, yes.\nI know it doesnt sound like it makes sense, but. . .", "This time it is going to be for real!" )
		AddDialogueLine( sc.dude, "I still don't get it." )
		AddDialogueLine( sc.matthias, "There is a thing out there. . .", "The so-called good old gmod.", "I believe if we find it and take it down.", "This is going to put an end to everything." )
		AddDialogueLine( sc.james, "And where is it?" )
		AddDialogueLine( sc.matthias, "About that. . .", "One of our boys got his hands on some info, but. . .", "Well. . .", "How do I even say that. . ." )
		AddDialogueLine( sc.dude, ". . ." )
		AddDialogueLine( sc.matthias, "You.", "Tell him about the the iccident!" )
		AddDialogueLine( sc.dude, "What?", "Oh. . .", "Oh no. . .", "So, um. . .", "That guy with info. . .", "He got lost at PonyRP server. . ." )
		AddDialogueLine( sc.james, "What?" )
		AddDialogueLine( sc.matthias, "HORSES!!!", "BIG RAINBOW COLORED HORSES!!!", "Sorry, I just could not say it without dying from laughter.", "Anyway. . .", "You gotta go there and rescue the poor guy." )
		AddDialogueLine( sc.james, "*sigh*", "Whatever you say, boss." )
		AddDialogueLine( sc.matthias, "I knew, I could count on you!", "Anyway. . .", "All this talk is making me hungry again. . .", "I swear, I could eat a horse. . .", "Hey!" )
		AddDialogueLine( sc.dude, "What can I get you, boss?" )
		AddDialogueLine( sc.matthias, "A horse." )
	end
}

GM.SingleplayerCutscenes["wild ride"] = {
	Intro = "2016\nSomewhere next to a railroad. . .",
	SoundTrack = 454614336,
	Volume = 60,
	StartFrom = 48000,
	EndAt = 124000,
	Main = { mdl = Model( "models/hunter/plates/plate4x4.mdl" ), seq = "idle", mat = ""},
	Relative = {
		{ mdl = Model( "models/props_junk/popcan01a.mdl"), offset = Vector(-24, -369, 22) , ang = Angle(45, -180, -90), seq = "idle", mat = "", tag = "ex", shake = true },
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(-21, -275, 302) , ang = Angle(88, -31 + 180, 0), seq = "Idle", mat = "" },
		{ mdl = Model( "models/props/de_train/utility_truck.mdl"), offset = Vector(-5, -274, 8) , ang = Angle(-1, -91, 0), seq = "idle", mat = "", shake = true },
		{ mdl = Model( "models/props_phx/huge/road_medium.mdl"), offset = Vector(-20, -127, 2) , ang = Angle(-1, -1, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/de_train/utility_truck_windows.mdl"), offset = Vector(-5, -274, 8) , ang = Angle(-1, -91, 0), seq = "idle", mat = "", shake = true },
		{ mdl = Model( "models/weapons/w_c4.mdl"), offset = Vector(16, -260, 79) , ang = Angle(-1, -91, 0), seq = "idle", mat = "", tag = "james", hide = true, icon = Material( "sog/james.png", "smooth" ) },
		{ mdl = Model( "models/weapons/w_pist_deagle.mdl"), offset = Vector(-20, -263, 82) , ang = Angle(2, 88, -86), seq = "idle", mat = "", tag = "dude", hide = true, icon = Material( "sog/merc.png", "smooth" ) },
	},
	Dialogues = function( sc )
		sc.ex.OnDraw = function()
				if sc.Emitter then
					sc.ex.NextPuff = sc.ex.NextPuff or 0
					if sc.ex.NextPuff < CurTime() then
						local particle = sc.Emitter:Add( "particles/smokey", sc.ex:GetPos() )
						particle:SetVelocity(math.Rand(0.1, 0.7)*Vector( 0, -340, 0 )+VectorRand()*2+vector_up*math.random(10))
						particle:SetDieTime(math.Rand(0.5, 1))
						particle:SetStartAlpha(100)
						particle:SetEndAlpha(0)
						particle:SetStartSize(math.random(2,4))
						particle:SetEndSize(math.random(6,13))
						particle:SetRoll(math.Rand(-180, 180))
						particle:SetColor(100, 100, 100)
						particle:SetAirResistance(15)
						sc.ex.NextPuff = CurTime() + math.Rand( 0, 0.09 )
					end
				end
			end
			
		AddDialogueLine( sc.dude, "Gmod Justice Force. . .", "Who keeps coming up with such dumb names?" )
		AddDialogueLine( sc.james, ". . .", "That's what he said." )
		AddDialogueLine( sc.dude, "I know. . .", "These guys are a real pain in the ass.", "Aren't they?" )
		AddDialogueLine( sc.james, "How come I don't remember them?" )
		AddDialogueLine( sc.dude, "Because they always went after boss.", "Back when we brought that coderfired shit in barrels." )
		AddDialogueLine( sc.james, "Who are these guys anyway. . ." )
		AddDialogueLine( sc.dude, "A mix of various weird players.", ". . .", "Cry babies, angry dudes, hell. . . even white knights. . .", "An angry weaponized mob, so to say.", "A mob that does all kinds of stupid things\nin the name of justice." )
		AddDialogueLine( sc.james, ". . ." )
		AddDialogueLine( sc.dude, "A hour ago they have boarded a getaway train.", "Full of GMPower players and stuff. . .", "This is where im taking you to, as we speak." )
		AddDialogueLine( sc.james, ". . ." )
		AddDialogueLine( sc.dude, "Aaaaand there it is!", "Once you are aboard - you are on your own.", ". . .", "Ready to go?" )
		AddDialogueLine( sc.james, "Yeah." )
	end
	
}

GM.SingleplayerCutscenes["white kingdom"] = {
	Intro = "2016\nCan't really see anything. . .",
	SoundTrack = 290559075,
	Volume = 60,
	Main = { mdl = Model( "models/hunter/blocks/cube05x075x025.mdl" ), seq = "idle", mat = ""},
	Relative = {
		{ mdl = Model( "models/weapons/w_pist_deagle.mdl"), offset = Vector(24, -304, 98) , ang = Angle(0, -91, -91), seq = "idle", mat = "", tag = "james", hide = true, icon = Material( "sog/james.png", "smooth" ) },
		{ mdl = Model( "models/props_junk/popcan01a.mdl"), offset = Vector(9, -317, 31) , ang = Angle(-90, -6, -85), seq = "idle", mat = "", tag = "ex", shake = true },
		{ mdl = Model( "models/weapons/w_c4_planted.mdl"), offset = Vector(39, -168, 83) , ang = Angle(-2, -5, -18), seq = "idle", mat = "", tag = "swat", hide = true, icon = Material( "sog/gasmask.png", "smooth" ) },
		{ mdl = Model( "models/props_phx/huge/road_medium.mdl"), offset = Vector(-30, -139, 7) , ang = Angle(0, -1, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(-24, -212, 381) , ang = Angle(89, 6, 0), seq = "Idle", mat = "" },
		{ mdl = Model( "models/props/de_piranesi/pi_apc.mdl"), offset = Vector(27, -226, 13) , ang = Angle(-1, 89, 0), seq = "idle", mat = "", shake = true },
	},
	Dialogues = function( sc )
		sc.ex.OnDraw = function()
				if sc.Emitter then
					sc.ex.NextPuff = sc.ex.NextPuff or 0
					if sc.ex.NextPuff < CurTime() then
						local particle = sc.Emitter:Add( "particles/smokey", sc.ex:GetPos() )
						particle:SetVelocity(math.Rand(0.1, 0.7)*Vector( 0, -340, 0 )+VectorRand()*2+vector_up*math.random(10))
						particle:SetDieTime(math.Rand(0.5, 1))
						particle:SetStartAlpha(100)
						particle:SetEndAlpha(0)
						particle:SetStartSize(math.random(2,4))
						particle:SetEndSize(math.random(6,13))
						particle:SetRoll(math.Rand(-180, 180))
						particle:SetColor(100, 100, 100)
						particle:SetAirResistance(15)
						sc.ex.NextPuff = CurTime() + math.Rand( 0, 0.09 )
					end
				end
			end
			
		AddDialogueLine( sc.swat, ". . .eventually he has lost his human appearance. . .", ". . .and ended up looking like oversized poison zombie.", ". . .", "At least that's what I have heard." )
		AddDialogueLine( sc.james, ". . ." )
		AddDialogueLine( sc.swat, "Alright, so here is one more creepy story. . .", "There was this server owner, called Heks. . .", "Can't remember his exact name. . .", "He made a huge ass banlist to help other server owners.", "But. . ." )
		AddDialogueLine( sc.james, ". . ." )
		AddDialogueLine( sc.swat, "It contained like 70 or 80 percent\nof all gmod population.", "You mention scripts and stuff?", "Banned.", "You have at least one common friend with banned person?", "Banned!", "Banned, Banned, Banned!", "And so on. . ." )
		AddDialogueLine( sc.james, ". . ." )
		AddDialogueLine( sc.swat, "In the end, he went insane too. . .", "And garry personally banished him.", "So noone have heard of him for almost 4 years or so.", ". . .", "Now that was a real spooker, wasn't it?" )
		AddDialogueLine( sc.james, ". . ." )
		AddDialogueLine( sc.swat, "Oh well. . ." )
	end
	
	
	
}


GM.SingleplayerCutscenes["flashbacks"] = {
	Intro = [[
      ___     
     /\  \    
    /::\  \   
   /:/\:\  \  
  /:/  \:\  \ 
 /:/__/_\:\__\
 \:\  /\ \/__/
  \:\ \:\__\  
   \:\/:/  /  
    \::/  /   
     \/__/    
	]],
	SoundTrack = 282363627,
	Volume = 60,
	OverridePaint = function( self, sw, sh  )
	
		surface.SetDrawColor( color_black )
		surface.DrawRect( 0, 0, sw, sh )

		surface.SetMaterial( spooky_mat )
		
		surface.SetDrawColor( Color( 255, 255, 255, 250 ) )
		surface.DrawTexturedRectRotated( sw/2, sh/2, sw*1.3, sw*1.3, RealTime() * 0.4 + 180 )
		surface.SetDrawColor( Color( 255, 255, 255, 150 ) )
		surface.DrawTexturedRectRotated( sw/2, sh/2, sw*1.3, sw*1.3, -1 * RealTime() * 0.2 )
		
	end,
	Main = { mdl = Model( "models/hunter/blocks/cube1x1x025.mdl" ), seq = "idle", mat = ""},
	Relative = {
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-165, -124, 22) , ang = Angle(-3, -80, -33), seq = "idle", mat = "" },
		{ mdl = Model( "models/weapons/w_shotgun.mdl"), offset = Vector(-1, -17, 55) , ang = Angle(-4, -24, 86), seq = "idle1", mat = "" },
		{ mdl = Model( "models/props/cs_militia/bottle01.mdl"), offset = Vector(-1, -85, 54) , ang = Angle(-4, 30, -4), seq = "idle", mat = "" },
		{ mdl = Model( "models/weapons/w_knife_ct.mdl"), offset = Vector(-1, -80, 54) , ang = Angle(-1, 81, -91), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/bottle03.mdl"), offset = Vector(-7, -55, 54) , ang = Angle(-1, 81, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/bottle01.mdl"), offset = Vector(6, -39, 54) , ang = Angle(-1, 90, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_junk/garbage_coffeemug001a.mdl"), offset = Vector(35, 79, 58) , ang = Angle(-2, -13, -3), seq = "idle", mat = "", tag = "cup" },
		{ mdl = Model( "models/props/de_tides/menu_stand.mdl"), offset = Vector(23, 116, 40) , ang = Angle(0, -136, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/bar01.mdl"), offset = Vector(-52, 58, 10) , ang = Angle(-1, -1, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/caseofbeer01.mdl"), offset = Vector(-102, -75, 35) , ang = Angle(-1, 90, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/caseofbeer01.mdl"), offset = Vector(-94, 19, 67) , ang = Angle(-1, 169, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/hunter/blocks/cube025x025x025.mdl"), offset = Vector(-53, 232, 21) , ang = Angle(-13, -175, -22), seq = "idle", mat = "" },
		{ mdl = Model( "models/hunter/plates/plate1x1.mdl"), offset = Vector(-83, 214, 13) , ang = Angle(-31, 118, 2), seq = "idle", mat = "" },
		{ mdl = Model( "models/dav0r/camera.mdl"), offset = Vector(7, -44, 306) , ang = Angle(89, 137, -6), seq = "Idle", mat = "" },
		{ mdl = Model( "models/hunter/blocks/cube025x025x025.mdl"), offset = Vector(139, -146, 29) , ang = Angle(-30, -30, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/hunter/blocks/cube025x025x025.mdl"), offset = Vector(101, -163, 22) , ang = Angle(-10, -156, 13), seq = "idle", mat = "" },
		{ mdl = Model( "models/hunter/blocks/cube025x025x025.mdl"), offset = Vector(25, -214, 19) , ang = Angle(-23, -71, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/hunter/blocks/cube025x05x025.mdl"), offset = Vector(64, -196, 13) , ang = Angle(-14, 36, 3), seq = "idle", mat = "" },
		{ mdl = Model( "models/hunter/blocks/cube05x075x025.mdl"), offset = Vector(-26, -213, 27) , ang = Angle(-27, -91, -6), seq = "idle", mat = "" },
		{ mdl = Model( "models/hunter/blocks/cube05x05x025.mdl"), offset = Vector(-113, -190, 26) , ang = Angle(-18, -132, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/hunter/blocks/cube025x025x025.mdl"), offset = Vector(107, -6, 37) , ang = Angle(-21, 7, 5), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/barstool01.mdl"), offset = Vector(39, 67, 10) , ang = Angle(-1, -19, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/player/group01/male_05.mdl"), offset = Vector(45, 68, 46) , ang = Angle(-1, -171, -1), seq = "sit_slam", mat = "", tag = "specialguest", icon = Material( "sog/_k.png", "smooth" ) },
		{ mdl = Model( "models/hunter/blocks/cube025x05x025.mdl"), offset = Vector(1, 257, 26) , ang = Angle(-20, 33, -2), seq = "idle", mat = "" },
		{ mdl = Model( "models/hunter/blocks/cube05x05x05.mdl"), offset = Vector(37, 225, 26) , ang = Angle(6, -3, 21), seq = "idle", mat = "" },
		{ mdl = Model( "models/hunter/blocks/cube025x025x025.mdl"), offset = Vector(88, 154, 26) , ang = Angle(0, 90, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/hunter/blocks/cube025x05x025.mdl"), offset = Vector(119, 102, 22) , ang = Angle(-18, -73, 25), seq = "idle", mat = "" },
		{ mdl = Model( "models/hunter/blocks/cube05x05x025.mdl"), offset = Vector(114, 53, 27) , ang = Angle(-7, -79, 12), seq = "idle", mat = "" },
		{ mdl = Model( "models/props_c17/statue_horse.mdl"), offset = Vector(40, -114, 16) , ang = Angle(-9, -30, -4), seq = "idle", mat = "", modelscale = 0.5, tag = "matthias", icon = Material( "sog/horse.png", "smooth" ) },
		{ mdl = Model( "models/player/group03/male_03.mdl"), offset = Vector(41, -30, 45) , ang = Angle(-1, -160, 0), seq = "sit", mat = "", tag = "james", icon = Material( "sog/james.png", "smooth" ) },
		{ mdl = Model( "models/hunter/plates/plate3x7.mdl"), offset = Vector(-4, 16, 8) , ang = Angle(-1, -2, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/hunter/blocks/cube025x025x025.mdl"), offset = Vector(133, -103, 39) , ang = Angle(-19, -5, -3), seq = "idle", mat = "" },
		{ mdl = Model( "models/hunter/blocks/cube025x05x025.mdl"), offset = Vector(103, -62, 13) , ang = Angle(-13, -100, 24), seq = "idle", mat = "" },
		{ mdl = Model( "models/hunter/blocks/cube025x025x025.mdl"), offset = Vector(124, -31, 26) , ang = Angle(-15, -90, 8), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/barstool01.mdl"), offset = Vector(93, -106, 23) , ang = Angle(-10, -119, -37), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/barstool01.mdl"), offset = Vector(38, -32, 10) , ang = Angle(-1, -93, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/bar01.mdl"), offset = Vector(-34, -66, 9) , ang = Angle(-1, -91, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/circularsaw01.mdl"), offset = Vector(-35, -116, 54) , ang = Angle(-2, 41, 14), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/caseofbeer01.mdl"), offset = Vector(-13, -107, 54) , ang = Angle(-0, 45, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/caseofbeer01.mdl"), offset = Vector(-96, -29, 35) , ang = Angle(0, -150, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/shelves_wood.mdl"), offset = Vector(-96, -28, 8) , ang = Angle(-1, -2, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/caseofbeer01.mdl"), offset = Vector(-99, -16, 35) , ang = Angle(-1, 6, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/caseofbeer01.mdl"), offset = Vector(-96, 13, 35) , ang = Angle(-1, 149, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/caseofbeer01.mdl"), offset = Vector(-97, -24, 67) , ang = Angle(-0, -138, 0), seq = "idle", mat = "" },
		{ mdl = Model( "models/hunter/plates/plate1x2.mdl"), offset = Vector(-160, 124, 24) , ang = Angle(-27, 159, 4), seq = "idle", mat = "" },
		{ mdl = Model( "models/hunter/blocks/cube025x025x025.mdl"), offset = Vector(-189, 55, 29) , ang = Angle(-16, 170, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/caseofbeer01.mdl"), offset = Vector(-97, -68, 67) , ang = Angle(-1, -178, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/caseofbeer01.mdl"), offset = Vector(-98, -56, 67) , ang = Angle(0, -177, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/props/cs_militia/caseofbeer01.mdl"), offset = Vector(-100, -83, 67) , ang = Angle(0, 174, -1), seq = "idle", mat = "" },
		{ mdl = Model( "models/player/group03/male_06.mdl"), offset = Vector(-82, -28, 106) , ang = Angle(5, 156, -175), seq = "zombie_slump_idle_02", mat = "", tag = "dude", icon = Material( "sog/mercenary_weird.png", "smooth" )  },
		{ mdl = Model( "models/props/cs_militia/barstool01.mdl"), offset = Vector(46, -2, 17) , ang = Angle(-88, -74, 2), seq = "idle", mat = "" },
	},
	Dialogues = function( sc )
		AddDialogueLine( sc.james, ". . ." )
		AddDialogueLine( sc.matthias, "Goddamn!", "This place still smells like a damn bar!" )
		AddDialogueLine( sc.dude, ". . ." )
		AddDialogueLine( sc.james, ". . .", "What the. . ." )
		AddDialogueLine( sc.dude, "So what ever happened to the money. . ." )
		AddDialogueLine( sc.james, ". . ." )
		AddDialogueLine( sc.specialguest, ". . .", "Oh. . .", "Don't mind me.", "I usually order myself a cup of coffee in this place.", "Or at least, used to. . ." )
		AddDialogueLine( sc.james, ". . ." )
		AddDialogueLine( sc.specialguest, ". . .", "Don't worry, we have not met before.", "I highly doubt your friends will recognize me either. . ." )
		AddDialogueLine( sc.matthias, "It was a truck that drains money from sewers!" )
		AddDialogueLine( sc.james, ". . ." )
		AddDialogueLine( sc.specialguest, "I used to help with development for this game. . .", "But I had to quit before it got too late. . .", ". . .", "Which can't be really said about you." )
		AddDialogueLine( sc.james, ". . ." )
		AddDialogueLine( sc.specialguest, "I mean, look around. . ." )
		AddDialogueLine( sc.james, ". . .", "Where are we?" )
		AddDialogueLine( sc.specialguest, "It's hard to tell.", "However. . .","Where you are going to is a better question." )
		AddDialogueLine( sc.james, ". . ." )
		AddDialogueLine( sc.specialguest, "That place. . .", "Well. . .", "It's where all good things end up.", "Kind of like garry's locker.", "Not sure what to even call it.", ". . .", "You will understand, once you'll see it." )
		AddDialogueLine( sc.matthias, "James!" )
		AddDialogueLine( sc.james, ". . ." )
		AddDialogueLine( sc.matthias, "Are you ready to die one last time?" )
		AddDialogueLine( sc.specialguest, "And I suppose, whatever you are looking for is also there." )
		AddDialogueLine( sc.dude, ". . .", "Hold up.", "I thought we have done this before?" )
		AddDialogueLine( sc.james, ". . ." )
		AddDialogueLine( sc.specialguest, "Well. . .", "Sorry, but I have to go now.", "Coffee is good and all. . .", "But it's getting pretty cold outside." )
		AddDialogueLine( sc.james, ". . ." )
		AddDialogueAction( sc.specialguest, function( me ) me.Hide = true sc.cup.Hide = true surface.PlaySound( "UI/hint.wav" ) end )
		AddDialogueLine( sc.matthias, "All this talk is making me hungry again. . .", "I swear, I could eat a human. . .", "Hey!" )
		//AddDialogueAction( sc.cup, function( me ) me.Hide = true end )
		AddDialogueLine( sc.dude, "What can I get you, boss?" )
		AddDialogueLine( sc.matthias, "A human." )
	end

}