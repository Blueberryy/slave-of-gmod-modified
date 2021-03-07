AddCSLuaFile()

ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

if SERVER then

ACTIVE_PICKUPS = ACTIVE_PICKUPS or 0

DROPPED_WEAPONS = DROPPED_WEAPONS or {}

function ENT:Initialize()

	self:PhysicsInit(SOLID_OBB)
	self:SetSolid(SOLID_BBOX)
	self:SetCollisionGroup(COLLISION_GROUP_PUSHAWAY)
	self:SetCollisionBounds( self:OBBMins()*1.1, self:OBBMaxs()*1.1)
	self:DrawShadow( false )

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMaterial("material")
		phys:Wake()
	end
	
	//if !self.Thrown then
		self:SetTrigger( true )
	//end

	self:SetCustomCollisionCheck( true )
	
	self.NextTouch = 0
	
	DROPPED_WEAPONS[ tostring(self) ] = self
	
	if self.Exception then return end
	if self.Thrown then return end
	
	ACTIVE_PICKUPS = ACTIVE_PICKUPS + 1
	
end

function ENT:SpawnAsWeapon( wep_class )
	
	local wep = weapons.Get( wep_class )
	if not wep then return end
	
	self:SetWeaponClass( wep_class )
	self:SetModel( wep.WorldModel or "models/props_junk/cinderblock01a.mdl" )
	if wep.DroppedModel then
		self:SetDroppedModel( wep.DroppedModel )
	end
	self:SetType( wep.IsMelee and "melee" or "ranged" )
	self:StoreClip( wep, true )

	if wep.KillOnThrow then
		self.KillOnThrow = true
	end
	if wep.NoDamage then
		self.NoDamage = true
	end
	if wep.RemoveOnHit then
		self.RemoveOnHit = true
	end
	if wep.AkimboClass then
		self.AkimboClass = wep.AkimboClass
	end
	if wep.DontRemove then
		self.DontRemove = wep.DontRemove
	end
	self.Reloads = 0
	if wep.Team then
		self.Team = wep.Team
		self:SetImportant( wep.Team )
	end
		
	//self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
	
	//self:Fire("Kill", "", 20)
	
end

function ENT:DropAsWeapon( wep, force_akimbo )
	
	if !IsValid(wep) then self:Remove() return end
	if not wep then self:Remove() return end
	
	self:SetWeaponClass( force_akimbo and wep.SingleClass or wep:GetClass() )
	self:SetModel( wep.WorldModel or "models/props_junk/cinderblock01a.mdl" )
	if wep.DroppedModel then
		self:SetDroppedModel( wep.DroppedModel )
	end
	if wep.Durability then
		self.Durability = wep.Durability
	end
	self:SetType( wep.IsMelee and "melee" or "ranged" )
	self:StoreClip( wep, false, force_akimbo )
	if wep.KillOnThrow then
		self.KillOnThrow = true
	end
	if wep.NoDamage then
		self.NoDamage = true
	end
	if wep.RemoveOnHit then
		self.RemoveOnHit = true
	end
	if wep.PlayHitFleshSound then
		self.PlayHitFleshSound = wep.PlayHitFleshSound
	end
	if wep.OnKill then
		self.OnKill = wep.OnKill
	end
	if wep.AkimboClass then
		self.AkimboClass = wep.AkimboClass
	end
	if wep.DontRemove then
		self.DontRemove = wep.DontRemove
	end
	if wep.GetReloads then
		self.Reloads = wep:GetReloads() or 0
	end
	if wep.Team then
		self.Team = wep.Team
		self:SetImportant( wep.Team )
	end
	
	self.Thrown = true
	
	//self:SetTrigger( false )
	
	//self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
	
	if PICKUP_PERSISTANCE then return end
	
	if !self.DontRemove then
		self:Fire("Kill", "", PICKUP_REMOVE_TIME or math.random(8,11))
	end
	
end

function ENT:Think()
	
	if self.Thrown and self:GetVelocityLength() < 50 then
		self:SetLocalVelocity( vector_origin )
		self.Thrown = false
		//self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
	end
	
	if self.NextThink then
		self:NextThink(CurTime())
	end
	return true
end

function ENT:OnRemove()

	if DROPPED_WEAPONS[ tostring(self) ] then
		DROPPED_WEAPONS[ tostring(self) ] = nil
	end

	if IsValid(self.LastPlayer) then
		self.LastPlayer.CanSwitch = nil
	end
	
	if IsValid(self.SpawnEntity) then
		self.SpawnEntity.Pickup = nil
	end
	
	if self.Exception then return end
	if self.Thrown then return end
	
	ACTIVE_PICKUPS = ACTIVE_PICKUPS - 1
end

function ENT:StartTouch ( ent )
	if IsValid( ent ) and (ent:IsPlayer() or ent:IsNextBot()) then
	

	
		if self.Thrown and ent ~= self:GetAttacker() and not self.NoKnockback and !IsValid(ent.Knockdown) and !IsValid(ent.Execution) and !ent.Ally then
			
			local vel = self:GetVelocity()
			vel.z = 0
			
			//ent:SetVelocity( vel:GetNormal() * 550 )
			
			
			if (self.KillOnThrow or self:GetAttacker():GetCharTable().ThrowingKills) and GAMEMODE:PlayerShouldTakeDamage(ent, self:GetAttacker()) and !IsValid( ent.Roll ) then
				if self.PlayHitFleshSound then
					self:PlayHitFleshSound()
					ent:SetVelocity( vel:GetNormal() * 550 )
				end
			else
				if !ent:GetCharTable().ImmuneToThrowables and !IsValid( ent.Roll ) then
					ent:SetVelocity( vel:GetNormal() * 550 )
					ent:DoKnockdown( 2.5, false, self:GetAttacker() )
				end
			end
			
			self:SetVelocity(self:GetVelocity() * 0.65)
			
			if (self.KillOnThrow or self:GetAttacker():GetCharTable().ThrowingKills) and GAMEMODE:PlayerShouldTakeDamage(ent, self:GetAttacker()) and !IsValid( ent.Roll ) and !ent:GetCharTable().ImmuneToThrowables then
				
				local dmginfo = DamageInfo()
					dmginfo:SetDamagePosition(self:GetPos())
					dmginfo:SetDamage(250)//ent:Health() * 2
					dmginfo:SetAttacker(self:GetAttacker())
					dmginfo:SetInflictor(self)
					dmginfo:SetDamageType(DMG_CLUB)
					dmginfo:SetDamageForce(vel:GetNormal() * 13255)
				ent:TakeDamageInfo(dmginfo)
				
				self:GetAttacker():ShakeView( math.random(2,4) )
				if ent.ShakeView then
					ent:ShakeView( math.random(2,4) )
				end
				
			end
			
			if self.RemoveOnHit then
				self:Remove()
				return
			end
			
		else
			if !IsValid(ent.CanSwitch) then
				ent.CanSwitch = self
			end
			self.LastPlayer = ent
		end
	end
end

function ENT:EndTouch ( ent )
	if IsValid( ent ) and ent:IsPlayer() then
		if IsValid(ent.CanSwitch) then
			ent.CanSwitch = nil
		end
		self.LastPlayer = nil
	end
end

//because we can't have proper collisions so enemies can pick up weapons, yet not to get stuck
function ENT:BypassCollision( ent )
	if ent and ent:IsNextBot() and self:GetCollisionGroup() == COLLISION_GROUP_PUSHAWAY and !self.Thrown and !IsValid(ent.Knockdown) then
		//bot has weapon, let him through
		if IsValid( ent:GetActiveWeapon() ) then
			self:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
			self:Fire( "restore", "", 1 )
		end
		//bot wants to get this weapon, but its not his weapon, let him trhough
		if !IsValid( ent:GetActiveWeapon() ) and ent.WeaponToTake and ent.WeaponToTake ~= self then
			self:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
			self:Fire( "restore", "", 1 )
		end
		//bot still wants the weapond and (oh goodness) its actually his weapon
		if !IsValid( ent:GetActiveWeapon() ) and ent.WeaponToTake and ent.WeaponToTake == self then
			self:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
			self:Fire( "restore", "", 1 )
			self.NextBypass = CurTime() + 1.5
		end
	end
end

function ENT:RestoreCollision()
	self:SetCollisionGroup( COLLISION_GROUP_PUSHAWAY )
end

function ENT:AcceptInput(name, activator, caller, args)
	name = string.lower(name)
	if name == "restore" then
		self:RestoreCollision()
	end
end

function ENT:ShouldPickupWeapon( ent )
	
	if ent:IsPlayer() then
		return ent:KeyDown( IN_ATTACK2 )
	end
	
	if ent:IsNextBot() then
		return ent.WeaponToTake and ent.WeaponToTake:IsValid() and ent.WeaponToTake == self
	end
	
	return false
end

function ENT:Touch( ent )	
	if IsValid( ent ) and (ent:IsPlayer() or ent:IsNextBot()) then
		//hit something
		if self.Thrown then return end
		
		self.NextBypass = self.NextBypass or 0
		
		if self.NextBypass < CurTime() then
			self:BypassCollision( ent )
		end
		
		self.LastPlayer = ent
		
		if ent:GetCharTable().OnWeaponTouch then
			local override = ent:GetCharTable():OnWeaponTouch( ent, self )
			if override then return end
		end
		
		if self.ShouldPickupWeapon and self:ShouldPickupWeapon( ent ) and !IsValid(ent.Knockdown) and !IsValid(ent.Execution) and not ent:GetCharTable().NoPickups and not ( self:GetType() == "melee" and ent:GetCharTable().NoMelee ) and ( GAMEMODE:GetRoundState() ~= ROUNDSTATE_RESTARTING ) and not (self.Team and ent:Team() ~= self.Team) then
			if self.NextTouch >= CurTime() then return end
			local wep = ent:GetActiveWeapon()
			local give = IsValid( wep ) and !(wep.Akimbo and wep.GetAkimboMoveMul and wep:GetAkimboMoveMul() > 0) and !(wep.Akimbo and self:GetType() == "melee") and ent:ThrowCurrentWeapon( 200 ) or IsValid( wep ) and wep.Fists or !IsValid( wep )
			if give then
				
				local akimbo = ent:GetCharTable().UseAkimboGuns and self.AkimboClass
				if akimbo then
					ent:Give(self.AkimboClass, ent.GiveNetworkedWeapons)
					if self.StoredClip then
						ent:GetWeapon(self.AkimboClass):SetClip1(self.StoredClip * 2)
					end
					if self.Reloads and ent:GetWeapon( self.AkimboClass ).SetReloads then
						ent:GetWeapon( self.AkimboClass ):SetReloads( self.Reloads )
					end
					ent:SelectWeapon(self.AkimboClass)
				else
					ent:Give(self:GetWeaponClass(), ent.GiveNetworkedWeapons)
					if self.StoredClip then
						ent:GetWeapon(self:GetWeaponClass()):SetClip1(self.StoredClip)
					end
					if self.Reloads and ent:GetWeapon( self:GetWeaponClass() ).SetReloads then
						ent:GetWeapon( self:GetWeaponClass() ):SetReloads( self.Reloads )
					end
					ent:SelectWeapon(self:GetWeaponClass())
				end
				if self.Durability then
					ent:GetWeapon(self:GetWeaponClass()).Durability = self.Durability
				end
				
				ent.CanSwitch = self
				self.NextTouch = CurTime() + 1
				ent.NextThrow = CurTime() + 0.3
				self:Remove()
			end
		end
		//ent.NextThrow = CurTime() + 1
	end
	
end

function ENT:SetAttacker( pl )
	self.Attacker = pl or NULL
end

function ENT:GetAttacker()
	return self.Attacker or NULL
end

function ENT:SetType( t )
	self.WeaponType = t or "melee"
end

function ENT:GetType()
	return self.WeaponType or "melee"
end

function ENT:StoreClip( wep, spawned, force_akimbo )
	if self:GetType() ~= "ranged" then return end
	if force_akimbo then
		self.StoredClip = math.ceil(wep:Clip1()/2)
		return
	end
	self.StoredClip = spawned and wep.Primary.DefaultClip or wep:Clip1()
end

function ENT:SetWeaponClass( name )
	self.WeaponClass = name
end

function ENT:GetWeaponClass()
	return self.WeaponClass or "none"
end

end

function ENT:SetDroppedModel( mdl )
	self:SetDTString( 0, mdl )
end

function ENT:GetDroppedModel()
	return self:GetDTString( 0 )
end

function ENT:SetImportant( team_id )
	self:SetDTInt( 0, team_id )
end

function ENT:IsImportant( team_id )
	return self:GetDTInt( 0 ) == team_id
end

if CLIENT then

local OverrideScale = {
	["models/props_junk/cinderblock01a.mdl"] = 0.6,
	["models/props_junk/sawblade001a.mdl"] = 0.375,
	["models/props/cs_office/Table_coffee.mdl"] = 0.6,
	["models/props_junk/wood_crate001a.mdl"] = 0.4,
	["models/player/kleiner.mdl"] = 0.68,
}

local OverrideSequence = {
	["models/player/kleiner.mdl"] = "zombie_slump_idle_01",
}

local vec_up = vector_up

local shift_vec1 = Vector(1,0.5,0)
local shift_vec2 = Vector(-6,-3,0)

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetRenderBounds(Vector(-318, -318, -318), Vector(318, 318, 318))
	
	self.NoDraw = CurTime() + 1
	
	self.r, self.g, self.b = math.Rand(0,1), math.Rand(0,1), math.Rand(0,1)
	
	if MUSIC_SYNC then
		self.r, self.g, self.b = math.Rand(0.9,1), 0, math.Rand(0.9,1)
	end
	
end

local mat = Material( "white_outline" )
local mat_whole = Material( "models/spawn_effect2" )

local OWN_TF2 = file.Exists ("models/player/items/soldier/cigar.mdl","GAME")

function ENT:Draw()

	self.CheckedArrow = self.CheckedArrow or false
	if self:IsImportant( LocalPlayer():Team() ) and !self.CheckedArrow then
		if !GAMEMODE:ExistArrow( self ) then
			GAMEMODE:AddArrow( self, nil, true, true ) 
		end
		self.CheckedArrow = true
	end
	
	if !IsValid(LocalPlayer()) then return end
	
	local MySelf = IsValid( LocalPlayer():GetObserverTarget() ) and LocalPlayer():GetObserverTarget() or LocalPlayer()
	
	local visible = MySelf:GetPos():DistToSqr(self:GetPos()) < DRAW_DISTANCE * DRAW_DISTANCE
	
	if not visible then return end
	
	if self:GetDroppedModel() and self:GetDroppedModel() ~= "" then
		if not (!OWN_TF2 and string.find(self:GetDroppedModel(), "katana")) then
			self:SetModel( self:GetDroppedModel() )
		end
	end

	local vel = self:GetVelocityLength()//self:GetVelocity():Length()
	
	
	if vel <= 30 and self.NoDraw <= CurTime() then
		if not self.DrawPos or self.DrawPos and self.DrawPos:DistToSqr(self:GetPos()) > 169 then
			self.DrawPos = self:GetPos()+vec_up*13
		end
	else
		if self.DrawPos then
			self.DrawPos = nil
		end
	end
	
	local modelscale = 1
	
	if OverrideScale[ self:GetModel() ] then
		modelscale = OverrideScale[ self:GetModel() ]
	end
	
	if OverrideSequence[ self:GetModel() ] then
		self:SetSequence( self:LookupSequence( OverrideSequence[ self:GetModel() ] ) )
	end
	
	if self.DrawPos then
			
		self:SetPos(self.DrawPos - vec_up*13)
		
		render.SuppressEngineLighting( true )
		render.SetAmbientLight( 1, 1, 1 )
		
		self:SetModelScale( modelscale + 0.15,0 )
		
		render.MaterialOverride( mat )
		render.SetColorModulation( 0, 0, 0 )

		self:SetupBones()
		self:DrawModel()
				
		render.MaterialOverride( nil )
		
		local realtime = RealTime()
		
		local mul1 = 2
		local mul2 = 3
		
		local mul3 = 1
		
		if MUSIC_SYNC then
			if GAMEMODE.BeatTime and GAMEMODE.BeatTime >= CurTime() then
				mul3 = -2
			end
			//if GAMEMODE.MusicFFTSmooth and GAMEMODE.Music and GAMEMODE.Music:IsValid() then
				//realtime = GAMEMODE.MusicSyncCount
				//if GAMEMODE.MusicFFTSmooth[ 1 ] then
				//	mul3 = GAMEMODE.MusicFFTSmooth[ 1 ] * 3
				//end
			//end
		end
		
		
		if LocalPlayer():FlipView() then
			self:SetPos(self.DrawPos+vec_up*math.sin(realtime*mul1)*4-shift_vec1*math.sin(realtime*mul2)*2*mul3-shift_vec2)
		else
			self:SetPos(self.DrawPos+vec_up*math.sin(realtime*mul1)*4+shift_vec1*math.sin(realtime*mul2)*2*mul3+shift_vec2)
		end
				
		
		render.SetColorModulation( 1, 1, 1 )
					   
		render.SuppressEngineLighting( false )

	else
		
		self:SetModelScale( modelscale, 0 )
	
	end
	
	if self.DrawPos then 

	end
	self:SetupBones()
	self:DrawModel()
	if self.DrawPos then 
			
		render.SuppressEngineLighting( true )
		render.MaterialOverride( mat_whole )
		render.SetColorModulation( self.r, self.g, self.b )
		
		self:SetupBones()
		self:DrawModel()
				
		render.SetColorModulation( 1, 1, 1 )
		render.MaterialOverride( nil )
		render.SuppressEngineLighting( false )
		
	end
	
end

end