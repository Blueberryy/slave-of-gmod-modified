AddCSLuaFile()

ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

//ENT.Team = function()
	//return TEAM_STUPID
//end

game.AddParticles("particles/fire_01.pcf" )

PrecacheParticleSystem( "explosion_huge" )

if CLIENT then
	RegisterParticleEffect( "explosion_huge" )
end


if SERVER then
	ACTIVE_SECURE_ENTS = ACTIVE_SECURE_ENTS or 0
end

ENT.PlantTime = 2
ENT.DisarmTime = 5
ENT.DieTime = 25

util.PrecacheSound( "ambient/alarms/combine_bank_alarm_loop4.wav" )

for i=1,4 do
	util.PrecacheSound( "ambient/explosions/explode_"..i..".wav" )
end

function ENT:Initialize()
	
	if SERVER then
		
		self:SetModel("models/props_lab/workspace001.mdl")
		ACTIVE_SECURE_ENTS = ACTIVE_SECURE_ENTS + 1
		self:SetMoveType( MOVETYPE_NONE )
		self:SetSolid( SOLID_VPHYSICS )
		self:PhysicsInit( SOLID_VPHYSICS )
		
		if !self.DontRotate then
			local ang = self:GetAngles()
			ang:RotateAroundAxis( vector_up, math.random(85,90) )
			self:SetAngles( ang )
		end
		
		self:SetUseType( SIMPLE_USE  )
		
		local phys = self:GetPhysicsObject()
		
		if IsValid(phys) then
			phys:EnableMotion( false )
		end
		
		self:SetArmed( false ) 
		self:SetArmingProgress( 0 )
		self:SetDisarmingProgress( 0 )
		
		SERVER_ARMED = false
				
	end
	
	if CLIENT then
		
		self:DrawShadow( false )
		self:SetRenderBounds( Vector(-318, -318, -318), Vector(318, 318, 318) )
		
		self.ArmedSound = CreateSound( self, "ambient/alarms/combine_bank_alarm_loop4.wav" )
		
	end

end

function ENT:SetArmed( bl )
	self:SetDTBool( 0, bl )
end

function ENT:IsArmed()
	return self:GetDTBool( 0 )
end

function ENT:SetArmingProgress( t )
	self:SetDTFloat( 0, t )
end

function ENT:GetArmingProgress()
	return self:GetDTFloat( 0 )
end

function ENT:SetDisarmingProgress( t )
	self:SetDTFloat( 1, t )
end

function ENT:GetDisarmingProgress()
	return self:GetDTFloat( 1 )
end

function ENT:SetDetonationTime( t )
	self:SetDTFloat( 2, t )
end

function ENT:GetDetonationTime()
	return self:GetDTFloat( 2 )
end

function ENT:TimeToDetonation()
	return math.Round( self:GetDetonationTime() - CurTime() ) or 0
end

function ENT:IsArming()
	return self:GetArmingProgress() > 0
end

function ENT:IsDisarming()
	return self:GetDisarmingProgress() > 0
end

if SERVER then
function ENT:Use( pl )
	if IsValid(pl) then
	
		if !IsValid(self.CurrentUser) and self:GetPos():Distance(pl:GetPos()) <= 60 then
			if !self:IsArmed() and pl:Team() == TEAM_EVIL and IsValid( pl:GetWeapon( "obj_package" ) ) then
				self.CurrentUser = pl
				self:SetArmingProgress( CurTime() + self.PlantTime )
			end
			if self:IsArmed() and pl:Team() == TEAM_STUPID then
				self.CurrentUser = pl
				self:SetDisarmingProgress( CurTime() + self.DisarmTime )
			end
		end

	end
end

ENT.NextClick = 0
function ENT:Think()
		
	if IsValid( self.CurrentUser ) and self.CurrentUser:Alive() then
		
		if self:IsArming() then
			//print( self.ArmingProgress - CurTime() )
		end
		
		if self:IsDisarming() then
			//print( self.DisarmingProgress - CurTime() )
		end
		
		if self:IsArming() or self:IsDisarming() then
			if self.NextClick <= CurTime() then
				self.CurrentUser:EmitSound( "ambient/machines/keyboard_fast"..math.random(3).."_1second.wav",75)
				self.NextClick = CurTime() + 1
			end
		end
		
		if self:IsArming() and self:GetArmingProgress() <= CurTime() then
			self:SetArmingProgress( 0 )
			self:SetArmed( true ) 
			SERVER_ARMED = true
			for k,v in pairs( team.GetPlayers(TEAM_EVIL) ) do
				if v == self.CurrentUser then
					v:AddScore( 3000, self )
				else
					v:AddScore( 2500, self )
				end
			end
			local pack = self.CurrentUser:GetWeapon( "obj_package" )
			if IsValid( pack ) then
				self.CurrentUser:StripWeapon( "obj_package" )
			end
			self:SetDetonationTime( CurTime() + self.DieTime )
			self:Fire( "destroy", "", self.DieTime )
			for k,v in ipairs(player.GetAll()) do
				v:ChatPrint("The server was armed by "..tostring(self.CurrentUser:Name()))
				if v:Team() == TEAM_STUPID and v:Alive() then
					v:AddObjectiveArrow( nil, self:GetPos(), math.random(8,10) )
					v:SetGoal( "Disarm [hold USE KEY] the shitty server!!!", math.random(8,12) )
				end
			end
			self.CurrentUser = nil
		end
		
		if self:IsDisarming() and self:GetDisarmingProgress() <= CurTime() then
			self:SetDisarmingProgress( 0 )
			self:SetArmed( false ) 
			SERVER_ARMED = false
			//if self.ArmedSound then
				//self.ArmedSound:Stop()
			//end
			//print(tostring(self).." was disarmed by "..tostring(self.CurrentUser))
			self.CurrentUser = nil
			
			if GAMEMODE:GetRoundState() == ROUNDSTATE_RESTARTING or GAMEMODE:GetRoundState() == ROUNDSTATE_END then return end
					
			GAMEMODE:SetRoundState( ROUNDSTATE_RESTARTING )
			
			for k,v in pairs( team.GetPlayers(TEAM_STUPID) ) do
				if v == self.CurrentUser then
					v:AddScore( 4000, self )
				else
					v:AddScore( 2500, self )
				end
			end
			
			team.AddScore( TEAM_STUPID, 1 )
			
			for k,v in ipairs(player.GetAll()) do
				
				if v:Team() == TEAM_EVIL and v:Alive() then
					v:StripWeapons()
					GAMEMODE:SetPlayerSpeed( v, 90, 90 )
				end
			
				v:ChatPrint("The server was successfully disarmed.")
				v:ChatPrint("Starting new round in 5 seconds...")
			end
			
			GAMEMODE:RestartRoundIn( 5 )
			
		end
		
		if self:IsArming() and (not self.CurrentUser:KeyDown(IN_USE) or !IsValid( self.CurrentUser:GetWeapon( "obj_package" ) ) or self:GetPos():Distance(self.CurrentUser:GetPos()) > 60 ) then
			self:SetArmingProgress( 0 )
			self.CurrentUser = nil
		end
		
		if self:IsDisarming() and (not self.CurrentUser:KeyDown(IN_USE) or self:GetPos():Distance(self.CurrentUser:GetPos()) > 60 ) then
			self:SetDisarmingProgress( 0 )
			self.CurrentUser = nil
		end
	
	else
		if !self:IsArmed() then
			self:SetArmingProgress( 0 )
			self.CurrentUser = nil
		end
		
		if self:IsArmed() then
			self:SetDisarmingProgress( 0 )
			self.CurrentUser = nil
		end
		
	end
	
end

function ENT:AcceptInput(name, activator, caller, args)
	name = string.lower(name)
	if name == "destroy" then
		self:DestroyServer()
	end
end

function ENT:DestroyServer()
	
	if !self:IsArmed() then return end
	
	SERVER_ARMED = false
	
	local e = EffectData()
		e:SetOrigin( self:GetPos() )
		e:SetScale( 3 )
	util.Effect( "HelicopterMegaBomb", e, nil, true )
	
	local e = EffectData()
		e:SetOrigin( self:GetPos() )
		e:SetScale( 2 )
	util.Effect( "Explosion", e, nil, true )
	
	local e = EffectData()
		e:SetOrigin(self:GetPos())
		e:SetNormal(vector_origin)
	util.Effect("explosion_huge", e, nil, true)
	
	for k,v in pairs( team.GetPlayers(TEAM_EVIL) ) do
		v:AddScore( 2000, self )
	end

	if GAMEMODE:GetRoundState() == ROUNDSTATE_RESTARTING then return end
					
	GAMEMODE:SetRoundState( ROUNDSTATE_RESTARTING )
	
	util.BlastDamage( self, self, self:GetPos() + vector_up*40, 500, 330 )
	
	self:EmitSound("ambient/explosions/explode_"..math.random(4)..".wav")
	
	if GAMEMODE:GetRoundState() ~= ROUNDSTATE_END then
		GAMEMODE:ShowLevelClear()
	end	
	
	team.AddScore( TEAM_EVIL, 1 )
	
	for k,v in pairs( team.GetPlayers(TEAM_EVIL) ) do
		if v:Alive() then
			v:AddScore( 250, v )
		end
	end

	
	for k,v in ipairs(player.GetAll()) do
		
		if v:Team() ~= TEAM_SPECTATOR or v:Team() ~= TEAM_CONNECTING then
			v:ShakeView( math.random(15,30), 1 )
		end
		
		if v:Team() == TEAM_STUPID and v:Alive() then
			v:StripWeapons()
			GAMEMODE:SetPlayerSpeed( v, 90, 90 )
		end
	
		v:ChatPrint("The server was destroyed!")
		v:ChatPrint("Starting new round in 10 seconds...")
	end
			
	GAMEMODE:RestartRoundIn( 10 )
	
	self:Remove()
end
end

function ENT:OnRemove()
	
	if CLIENT then
		if self.ArmedSound then
			self.ArmedSound:Stop()
		end
	end

end

if CLIENT then

function ENT:Think()
	
	if self:IsArmed() then
		if self.ArmedSound then
			self.ArmedSound:PlayEx(1,90 + 50 * ( (self.DieTime - self:TimeToDetonation())/self.DieTime))
		end
	else
		if self.ArmedSound then
			self.ArmedSound:Stop()
		end
	end
	
end

local mat_whole = Material( "models/spawn_effect2" )
function ENT:Draw()

	self:DrawModel()
	
	render.SuppressEngineLighting( true )
		render.MaterialOverride( mat_whole )
		render.SetColorModulation( 100/255, 10/255, 10/255 )
		
		self:SetupBones()
		self:DrawModel()
				
		render.SetColorModulation( 1, 1, 1 )
		render.MaterialOverride( nil )
	render.SuppressEngineLighting( false )

	local pos = self:LocalToWorld(self:OBBCenter())
	local angle = Angle(0,90 * (LocalPlayer():FlipView() and -1 or 1),0)
	
	local w, h = 200, 30
	
	if self:IsArming() or self:IsDisarming() then
	
		local mul = self:IsArming() and ( self.PlantTime + CurTime() - self:GetArmingProgress())/self.PlantTime or self:IsDisarming() and (self:GetDisarmingProgress() - CurTime())/self.DisarmTime or 0
		
		cam.IgnoreZ( true )
			cam.Start3D2D(pos,angle,0.35)
				surface.SetDrawColor( 220, 220, 220, 255 )
				surface.DrawRect( -w/2, 0, w, h )
				surface.SetDrawColor( 47, 0, 27, 255 )
				surface.DrawRect( -w/2+2, 0+2, w-4, h-4 )
				surface.SetDrawColor( 220, 220, 220, 255 )
				surface.DrawRect( -w/2+4, 0+4, (w-8)*mul, h-8 )
			cam.End3D2D()
		cam.IgnoreZ( false )
	else
	
		if !self:IsArmed() and LocalPlayer():Team() == TEAM_EVIL and IsValid( LocalPlayer():GetWeapon( "obj_package" ) ) and self:GetPos():Distance(LocalPlayer():GetPos()) <= 60 then
			local shift = math.sin(RealTime()*3)*1.5 + 3
			
			local r = 0.5*math.sin(RealTime()*1.5)*255 + 255/2
			local g = -0.5*math.sin(RealTime()*1.5)*255 + 255/2
			local b = 215
			
			surface.SetFont( "PixelSmall" )
			
			local text = "Hold [ "..string.upper( input.LookupBinding( "+use", true ) ).." ] to arm the server"
			
			local tw, th = surface.GetTextSize( text )
			
			cam.IgnoreZ( true )
				cam.Start3D2D(pos,angle,0.4)
					surface.SetDrawColor( 10, 10, 10, 205 )
					surface.DrawRect( -(tw+16)/2, -45, tw+16, th+3 )
					draw.DrawText(text, "PixelSmall", 0 , -45, Color(r, g, b, 155),TEXT_ALIGN_CENTER)
					draw.DrawText(text, "PixelSmall", 0 - shift, -45 - shift, Color(210, 210, 210, 255),TEXT_ALIGN_CENTER)
				cam.End3D2D()
			cam.IgnoreZ( false )
		end
		
		if self:IsArmed() and LocalPlayer():Team() == TEAM_STUPID and self:GetPos():Distance(LocalPlayer():GetPos()) <= 60 then
			local shift = math.sin(RealTime()*3)*1.5 + 3
			
			local r = 0.5*math.sin(RealTime()*1.5)*255 + 255/2
			local g = -0.5*math.sin(RealTime()*1.5)*255 + 255/2
			local b = 215
			
			surface.SetFont( "PixelSmall" )
			
			local text = "Hold [ "..string.upper( input.LookupBinding( "+use", true ) ).." ] to disarm the server"
			
			local tw, th = surface.GetTextSize( text )
			
			cam.IgnoreZ( true )
				cam.Start3D2D(pos,angle,0.4)
					surface.SetDrawColor( 10, 10, 10, 205 )
					surface.DrawRect( -(tw+16)/2, 0, tw+16, th+3 )
					draw.DrawText(text, "PixelSmall", 0 , 0, Color(r, g, b, 155),TEXT_ALIGN_CENTER)
					draw.DrawText(text, "PixelSmall", 0 - shift, 0 - shift, Color(210, 210, 210, 255),TEXT_ALIGN_CENTER)
				cam.End3D2D()
			cam.IgnoreZ( false )
		end
	
	end
	
	if self:IsArmed() then
	
		local shift = math.sin(RealTime()*3)*1.5 + 3
		
		local r = 0.5*math.sin(RealTime()*1.5)*255 + 255/2
		local g = -0.5*math.sin(RealTime()*1.5)*255 + 255/2
		local b = 215
		
		surface.SetFont( "PixelSmall" )
		
		local text = "Detonation in "..math.Clamp(self:TimeToDetonation(),0,9999).." seconds"
		
		local tw, th = surface.GetTextSize( text )
		
		cam.IgnoreZ( true )
			cam.Start3D2D(pos,angle,0.4)
				surface.SetDrawColor( 10, 10, 10, 205 )
				surface.DrawRect( -(tw+16)/2, -45, tw+16, th+3 )
				draw.DrawText(text, "PixelSmall", 0 , -45, Color(r, g, b, 155),TEXT_ALIGN_CENTER)
				draw.DrawText(text, "PixelSmall", 0 - shift, -45 - shift, Color(210, 210, 210, 255),TEXT_ALIGN_CENTER)
			cam.End3D2D()
		cam.IgnoreZ( false )
	
	end
	
	/*self.CheckedArrow = self.CheckedArrow or false
	if !self.CheckedArrow then
		if !GAMEMODE:ExistArrow( self ) then
			GAMEMODE:AddArrow( self, self:LocalToWorld(self:OBBCenter()) )
		end
		self.CheckedArrow = true
	end*/


end

end