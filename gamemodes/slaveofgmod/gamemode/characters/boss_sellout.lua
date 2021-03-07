CHARACTER.Reference = "boss sellout"

CHARACTER.Name = "LetsTortureGMod"
CHARACTER.Description = ""

CHARACTER.Health = 600
CHARACTER.Speed = 380

//CHARACTER.OverrideColor = Color( 0, 0, 0 )

CHARACTER.GametypeSpecific = "singleplayer"

CHARACTER.StartingWeapon = "boss_sellout"
CHARACTER.KnockdownImmunity = true

CHARACTER.InfiniteAmmo = true

CHARACTER.RequiredExecutionHitOverride = 3 //you thought you can decapitate this thing in 1 hit? Why not extend the pleasure of victory?

CHARACTER.Boss = true
CHARACTER.ImmuneToThrowables = true

CHARACTER.Icon = Material( "sog/sellout.png", "smooth" )

CHARACTER.Model = Model( "models/player/gman_high.mdl" )

function CHARACTER:OnSpawn( pl )
	
	if not SCENE_FIRST then
		SCENE_FIRST = true
		timer.Simple( 1, function() Entity(1):SendLua("CreateShittyFacecam()") end)
	end
	
	//pl.DOTCheck = 1
	pl.Pursuit = Entity(1)
	//because he is waaaay too brutal with default spotting
	pl.NoSpotDelta = true
	
	pl.OnThink = function( self )
	
		local realtime = RealTime()
		
		local r = 0.5*math.sin(realtime)*255 + 255/2
		local g = -0.5*math.sin(realtime)*255 + 255/2
		local b = 210
	
		pl:SetNextBotColor( Color( r, g, b ) )
		
	end
	
	pl:SetHealth( 900 )
	
	timer.Simple( 0.5, function() 
		local health = 300
			
		for k, v in pairs( NEXTBOTS ) do
			if v and v:IsValid() and v:Alive() and v ~= pl then///and v:GetBehaviour() == BEHAVIOUR_FOLLOWER and v:GetOwner() == pl then
				v.IsSlave = true
				health = health + 300
			end
		end
		
		if health <= 300 then
			health = 400
		end
		
		pl:SetHealth( health )

	end)
end

function CHARACTER:OnDeath( pl, attacker, dmginfo )
	Entity(1):SendLua("RemoveShittyFacecam()")
end

function CHARACTER:OnMeleeHit( pl, hitpos, hitnormal, dir, attacker ) 
	
	if SERVER then	
		if pl:Health() <= 300 then
			pl:DoKnockdown( 9999999, true, attacker )
		end
	end

	return false
end

function CHARACTER:OnBulletHit( pl, hitpos, hitnormal, dir, dmginfo ) 
	
	if pl:Health() <= 300 then
		pl:DoKnockdown( 9999999, true, attacker )
	end

	return false
end

if SERVER then
	hook.Add( "DoNextBotDeath", "Slaves", function( pl, attacker, dmginfo )
		if pl and pl:IsValid() and pl.IsSlave and pl:GetOwner():IsValid() then
			pl:GetOwner():SetHealth( math.max( 300, pl:GetOwner():Health() - 300 ) ) 
		end
	end)
end

if CLIENT then

local shitty_ads = {
	"sog_hud_clickbait_2013_boss_cam_ad1", "sog_hud_clickbait_2013_boss_cam_ad2", "sog_hud_clickbait_2013_boss_cam_ad3", "sog_hud_clickbait_2013_boss_cam_ad4",
	"sog_hud_clickbait_2013_boss_cam_ad5", "sog_hud_clickbait_2013_boss_cam_ad6", "sog_hud_clickbait_2013_boss_cam_ad7",
	"sog_hud_clickbait_2013_boss_cam_ad8", "sog_hud_clickbait_2013_boss_cam_ad9", "sog_hud_clickbait_2013_boss_cam_ad10",
	"sog_hud_clickbait_2013_boss_cam_ad11", "sog_hud_clickbait_2013_boss_cam_ad12", "sog_hud_clickbait_2013_boss_cam_ad13", 
	"sog_hud_clickbait_2013_boss_cam_ad14", "sog_hud_clickbait_2013_boss_cam_ad15", "sog_hud_clickbait_2013_boss_cam_ad16", 
	"sog_hud_clickbait_2013_boss_cam_ad17", "sog_hud_clickbait_2013_boss_cam_ad18"
}

function RemoveShittyFacecam()
	if GAMEMODE.Facecam then
		GAMEMODE.Facecam:Remove()
		GAMEMODE.Facecam = nil
	end
	if GAMEMODE.SelloutShit then
		GAMEMODE.SelloutShit:Remove()
		GAMEMODE.SelloutShit = nil
	end
end

function CreateShittyFacecam()
	
	//if !SINGLEPLAYER then return end
	
	if not FACECAM_STARTTIME then
		FACECAM_STARTTIME = CurTime()
	end
	
	if GAMEMODE.Facecam then
		GAMEMODE.Facecam:Remove()
		GAMEMODE.Facecam = nil
	end
	
	if GAMEMODE.SelloutShit then
		GAMEMODE.SelloutShit:Remove()
		GAMEMODE.SelloutShit = nil
	end

	
	local gw, gh = ScrW(), ScrH()
	
	GAMEMODE.Facecam = GAMEMODE.CursorFix:Add( "DModelPanel" )
	GAMEMODE.Facecam:SetKeyboardInputEnabled( false )
	GAMEMODE.Facecam:SetMouseInputEnabled( false ) 
	GAMEMODE.Facecam:SetSize( gh/4, gh/4 )
	GAMEMODE.Facecam:SetPos( gw - gh/4, gh - gh/4 )
	GAMEMODE.Facecam.Ads = table.Copy( shitty_ads )
	GAMEMODE.Facecam.Ads = table.Shuffle( GAMEMODE.Facecam.Ads )
	GAMEMODE.Facecam.AdsString = ""
	GAMEMODE.Facecam.MaxSizeTime = FACECAM_STARTTIME + 4*60
	
	
	for _, shit in ipairs( GAMEMODE.Facecam.Ads ) do
		GAMEMODE.Facecam.AdsString = translate.Format("sog_hud_clickbait_2013_boss_cam", translate.Get(shit), translate.Get(GAMEMODE.Facecam.AdsString))
	end
	
	GAMEMODE.Facecam.SetModel = function( self )

		if ( IsValid( self.Entity ) ) then
			self.Entity:Remove()
			self.Entity = nil
		end

		if ( !ClientsideModel ) then return end

		self.Entity = ClientsideModel( "models/player/gman_high.mdl", RENDER_GROUP_OPAQUE_ENTITY )
		if ( !IsValid( self.Entity ) ) then return end

		self.Entity:SetNoDraw( true )

		local iSeq, dur = self.Entity:LookupSequence( "taunt_dance_base" )//"taunt_dance_base"
		self.iSeq = iSeq
		self.Duration = dur
		if ( self.iSeq > 0 ) then self.Entity:ResetSequence( self.iSeq ) end
		
		self.NextPlay = CurTime() + self.Duration
		
		self.Entity.GetPlayerColor = function()
		
			local realtime = RealTime()
		
			local r = 0.5*math.sin(realtime)*255 + 255/2
			local g = -0.5*math.sin(realtime)*255 + 255/2
			local b = 210
			
			return Vector ( r/255, g/255, b/255 ) 
		end
		
		local function flex( ent, num, tbl )
			
			if not self.Entity.FlexTable then
				self.Entity.FlexTable = table.Copy( tbl )
			end
			
			if not self.Entity.CurFlexTable then
				self.Entity.CurFlexTable = table.Copy( tbl )
			end
			
			self.Entity.NextFlex = self.Entity.NextFlex or 0
			
			if self.Entity.NextFlex < CurTime() then
				for i = 0, num do
					if self.Entity.FlexTable[ i ] then
						self.Entity.FlexTable[ i ] = math.Rand( -self.PanelScale ^ 2, self.PanelScale ^ 2 )//math.Rand( -2, 2 )
					end
				end

				self.Entity.NextFlex = CurTime() + math.Rand(0.05,0.1)// math.Rand(0.1,0.4)
			end
			
			for i = 0, num do
				if tbl[ i ] and self.Entity.FlexTable[ i ] and self.Entity.CurFlexTable[ i ] then
					self.Entity.CurFlexTable[ i ] = math.Approach( self.Entity.CurFlexTable[ i ], self.Entity.FlexTable[ i ], FrameTime() * 20 )
					tbl[ i ] = self.Entity.CurFlexTable[ i ]
				end
			end
		end

		self.Entity:AddCallback(  "BuildFlexWeights", flex )
	end

	
	GAMEMODE.Facecam:SetModel()
	
	GAMEMODE.Facecam.LayoutEntity = function( self, ent )

		ent:FrameAdvance( ( RealTime() - self.LastPaint ) * 1 )
		
		self.NextPlay = self.NextPlay or 0
		
		if self.NextPlay < CurTime() then
				
			self.NextPlay = CurTime() + ( self.Duration or 0 )
			ent:SetCycle( 0 ) 
			//ent:ResetSequence( self.iSeq )
		end
	end
	
	GAMEMODE.Facecam.Think = function( self )
		//self:SetRandomFace()
		self.MaxScale = 2.5
		self.PanelScale = self.PanelScale or 1
		
		local delta = 1 - ( self.MaxSizeTime - CurTime() ) / ( 4*60 )
		
		self.PanelScale = math.Clamp( 1 + delta, 1, self.MaxScale )
		
		local sz = gh/4 * self.PanelScale
		
		self:SetSize( sz, sz )
		self:SetPos( gw - sz, gh - sz )
		
		
	end
	
	GAMEMODE.Facecam.Paint = function( self, w, h )

		if Dialogue and Dialogue:IsValid() then return end
	
		surface.SetDrawColor( 10, 10, 10, 55 )
		surface.DrawRect( 0, 0, w, h )
		surface.SetDrawColor( 10, 10, 10, 105 )
		surface.DrawRect( 0, 0, w-2, h-2 )
	
		if ( !IsValid( self.Entity ) ) then return end

		local x, y = self:LocalToScreen( 0, 0 )
		
		self:LayoutEntity( self.Entity )

		self.ang = self.aLookAngle
		self.pos = self.vCamPos

		local head_bone = self.Entity:LookupBone("ValveBiped.Bip01_Head1")
		if head_bone then
			local b_pos,b_ang = self.Entity:GetBonePosition( head_bone )
			if b_pos and b_ang then
			
				b_ang:RotateAroundAxis( b_ang:Up(), 100 )
				b_ang:RotateAroundAxis( b_ang:Forward(), 90 )
				b_ang:RotateAroundAxis( b_ang:Up(), 15 )
			
				//b_ang.p = b_ang.p + 90
			
				self.ang = b_ang
				self.pos = b_pos - self.ang:Forward() * 20 + self.ang:Up() * (math.sin(RealTime()*(10))*0.1 + 2)
				
			end
		end	

		
		if ( !self.ang ) then
			self.ang = (self.vLookatPos-self.vCamPos):Angle()
		end
		
		self.Entity:SetEyeTarget( self.pos - self.ang:Right() * 1 )

		cam.Start3D( self.pos, self.ang, 50, x, y, w, h, 1, 200 )
			
			render.SuppressEngineLighting( true )
			render.SetLightingOrigin( self.Entity:GetPos() )
			render.ResetModelLighting( self.colAmbientLight.r/255, self.colAmbientLight.g/255, self.colAmbientLight.b/255 )
			render.SetColorModulation( self.colColor.r/255, self.colColor.g/255, self.colColor.b/255 )
			render.SetBlend( self.colColor.a/255 )

			for i=0, 6 do
				local col = self.DirectionalLight[ i ]
				if ( col ) then
					render.SetModelLighting( i, col.r/255, col.g/255, col.b/255 )
				end
			end

			self.Entity:SetupBones()
			self.Entity:DrawModel()

			render.SuppressEngineLighting( false )
		cam.End3D()
		
		//local r = 255
		//local g = 0.5*math.sin((RealTime()+0.8)*2)*180 + 180/2
		//local b = 31
		
		//draw.TextRotated( "The Second Tor†uring of GMod", w/2, 25, Color(r,g,b,250), "PixelSmaller",0, 1, false )
		//draw.TextRotated( "The Second Tor†uring of GMod", w/2, 25, color_white, "PixelSmaller",0, 1, false )
		
		draw.ScrollingTextRotated( self.AdsString or "error", 0, h-25, w, -100, color_white, "PixelSmaller", 0, 1, true )
		
		self.LastPaint = RealTime()

	end
	
	//just more shit that you see on each channel
	GAMEMODE.SelloutShit = GAMEMODE.CursorFix:Add( "DPanel" )
	GAMEMODE.SelloutShit:SetKeyboardInputEnabled( false )
	GAMEMODE.SelloutShit:SetMouseInputEnabled( false ) 
	GAMEMODE.SelloutShit:SetSize( gw, gh )
	GAMEMODE.SelloutShit:SetPos( 0, 0 )
	
	GAMEMODE.SelloutShit.Paint = function( self, w, h )
		
		/*local am = 8
		
		for i=0,am do
		
			local r = 255
			local g = 0.5*math.sin((RealTime()+0.8*i/am)*2)*180 + 180/2
			local b = 31
			
			if i == 0 or i == am then
				draw.TextRotated( "The Second Tor†uring of GMod", w/2, 60, Color(r,g,b,250), "PixelCutsceneBiggerScaled",0, 0.7 + 0.005*i, 0.5 )
			else
				draw.TextRotated( "The Second Tor†uring of GMod", w/2, 60, Color(r,g,b,250), "PixelCutsceneBiggerScaled",0, 0.7 + 0.005*i, false )
			end
			
		end*/
		
	end
	
		
end
end