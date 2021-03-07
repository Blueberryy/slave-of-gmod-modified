AddCSLuaFile()

ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

ENT.Team = function()
	return TEAM_MOB
end

ENT.health = 550
ENT.radius = 400

// "models/props_lab/crematorcase.mdl"

//models/props_lab/workspace001.mdl

//models/props_junk/cardboard_box003a.mdl


if SERVER then
	ACTIVE_SECURE_ENTS = ACTIVE_SECURE_ENTS or 0
	SECURE_ENTS = SECURE_ENTS or {}
end

function ENT:Initialize()
	
	if SERVER then
		
		self:SetModel("models/props_lab/reciever_cart.mdl")
		ACTIVE_SECURE_ENTS = ACTIVE_SECURE_ENTS + 1
		self:SetMoveType( MOVETYPE_NONE )
		self:SetSolid( SOLID_VPHYSICS )
		self:PhysicsInit(SOLID_VPHYSICS)
		
		local phys = self:GetPhysicsObject()
		
		if IsValid(phys) then
			phys:EnableMotion( false )
		end
		SECURE_ENTS[tostring(self)] = self
	end
	
	if CLIENT then
		
		self:DrawShadow( false )
		self:SetRenderBounds(Vector(-318, -318, -318), Vector(318, 318, 318))
		
	end

end

if SERVER then

function ENT:OnRemove()
	ACTIVE_SECURE_ENTS = ACTIVE_SECURE_ENTS - 1
	
	if SECURE_ENTS[tostring(self)] then
		SECURE_ENTS[tostring(self)] = nil
	end
	
	if IsValid( self.SpawnPoint ) then
		self.SpawnPoint.Secure = nil
	end
	
	if ACTIVE_SECURE_ENTS <= 0 and self.RemoveByDamage then
		
		if GAMEMODE:GetRoundState() == ROUNDSTATE_RESTARTING then return end
		
		GAMEMODE:SetRoundState( ROUNDSTATE_RESTARTING )
		
		CHANGE_AXE = true
		
		if GAMEMODE:GetRoundState() ~= ROUNDSTATE_END then
			GAMEMODE:ShowLevelClear()
		end		
		
		for k,v in pairs( NEXTBOTS ) do
			if v and v:IsValid() and v:Alive() then
				v:StripWeapon()
				v.WalkSpeed = 90
			end
		end
		
		for k,v in ipairs(player.GetAll()) do
			v:ChatPrint("Axe guy has destroyed shitty money printers. The DarkRP kids are in tears.")
			v:ChatPrint("Starting a new round in 20 seconds...")
			
			if v:Team() == TEAM_MOB and v:Alive() then
				v:StripWeapons()
				GAMEMODE:SetPlayerSpeed( v, 90, 90 )
			end
			
			if v:Team() == TEAM_AXE and v:Alive() then
				v:AddFrags( 1 )
				v.Tries = 0
			end
			
		end
		
		GAMEMODE:RestartRoundIn( 20 )
		
		/*timer.Simple(20, function() 
			if GAMEMODE then
				GAMEMODE:RestartRound()
				end
			end)*/
	end
	
end

function ENT:OnTakeDamage( dmginfo )
	
	local attacker = dmginfo:GetAttacker()
	
	if IsValid( attacker ) and attacker:IsPlayer() and attacker:Team() ~= self:Team() then
		
		local scale = 1
		
		for _, mob in ipairs( team.GetPlayers( TEAM_MOB )) do
			if IsValid( mob ) and mob:Alive() and mob:GetShootPos():Distance( self:GetPos() ) < self.radius then
				scale = 0.8
				break
			end
		end
		
		dmginfo:ScaleDamage( scale )
		
		self.health = self.health - dmginfo:GetDamage()
		
		self:EmitSound("physics/metal/metal_box_break"..math.random(2)..".wav",100, math.Rand(95, 130)) 
		
		if self.health <= 0 then
			local e = EffectData()
				e:SetOrigin( self:GetPos() )
				e:SetScale( 2 )
			util.Effect( "Explosion", e, nil, true )
			
			attacker:AddScore( 2000, self )
			attacker:SetComboTime()
			
			self.RemoveByDamage = true
			
			for k,v in ipairs(player.GetAll()) do
				if v:Team() ~= TEAM_SPECTATOR or v:Team() ~= TEAM_CONNECTING and v:Alive() and self:GetPos():Distance(v:GetPos()) <= 300 then
					v:ShakeView( math.random(15,20), 0.4)
				end
			end
			
			self:Remove()
		end
		
	end

end

end

if CLIENT then

function ENT:Draw()
	
	local pos = self:GetPos()
	local angle = Angle(0,90 * (LocalPlayer():FlipView() and -1 or 1),0)
	
	self:DrawModel()
	
	local shift = math.sin(RealTime()*3)*1.5 + 3
	
	cam.IgnoreZ( true )
	cam.Start3D2D(pos,angle,0.35)
		
		local w, h = 120, 90
		
		draw.RoundedBox( 0, -w/2, -h/2, w, h, Color(10, 10, 10, 145))
	
		draw.SimpleText("shitty", "NumbersSmallest", 0 + 3, -26 + 3, Color(10, 10, 10, 185), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("money", "NumbersSmallest", 0 + 3, 0 + 3, Color(10, 10, 10, 185), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("printer", "NumbersSmallest", 0 + 3, 26 + 3, Color(10, 10, 10, 185), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
		draw.SimpleText("shitty", "NumbersSmallest", 0, -26, Color(97, 0, 27, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("money", "NumbersSmallest", 0, 0, Color(97, 0, 27, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("printer", "NumbersSmallest", 0, 26, Color(97, 0, 27, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
		draw.SimpleText("shitty", "NumbersSmallest", 0 - shift, -26 - shift, Color(210, 210, 210, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("money", "NumbersSmallest", 0 - shift, 0 - shift, Color(210, 210, 210, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText("printer", "NumbersSmallest", 0 - shift, 26 - shift, Color(210, 210, 210, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		
	cam.End3D2D()
	cam.IgnoreZ( false )
	

end
end