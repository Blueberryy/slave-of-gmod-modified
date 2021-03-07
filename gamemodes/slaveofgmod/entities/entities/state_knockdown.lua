AddCSLuaFile()

ENT.Type = "anim"

ENT.Sound = Sound( "npc/vort/foot_hit.wav" )

util.PrecacheModel("models/props_trainstation/trainstation_clock001.mdl")


local trace = { mask = MASK_SOLID_BRUSHONLY, mins = Vector(-6, -6, 0), maxs = Vector(6, 6, 64) }
function ENT:Initialize()

	self.Entity:GetOwner().Knockdown = self
	self.Entity.Owner = self.Entity:GetOwner()
	self.Entity:DrawShadow( false )	

	if SERVER then
		self:SetRecoveryTime( 0.5 )
	
		self:SetModel("models/props_trainstation/trainstation_clock001.mdl")
		//self.DieTime = CurTime() + (self.Time or 3)
		self:SetDieTime( CurTime() + ( self:GetDuration() or 3 ) )
		
		self.Entity:GetOwner():Freeze( true )
		if !self.Entity:GetOwner():GetCharTable().DontLoseWeapon then
			self.Entity:GetOwner():ThrowCurrentWeapon( 20, true, true )
		end
		//self.Entity:GetOwner():SetMoveType( MOVETYPE_NONE )
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
		
		self:SetModelScale( 0.7, 0 )

		self.Entity:SetTrigger( true )
				
		trace.start = self.Entity.Owner:GetPos() + vector_up * 5
		trace.endpos = trace.start - self.Entity.Owner:GetAimVector():GetNormal() * 30
		trace.filter = self.Entity.Owner
		
		local tr = util.TraceHull( trace )
				
		if tr.Hit then
			self:SetSkin( 1 )
		end
		
		self:Fire("kill", '', math.max( 10, self:GetDuration() ))
		
	end
	
	if self.Attacker and self.Attacker == self.Entity:GetOwner() then return end
	
	if SERVER then
		sound.Play( self.Sound, self:GetPos(), 100, 100, 1 )
	end
	
end

function ENT:SetDieTime( time )
	self:SetDTFloat( 0, time )
end

function ENT:GetDieTime()
	return self:GetDTFloat( 0 )
end

function ENT:SetDuration( time )
	self:SetDTFloat( 1, time )
end

function ENT:GetDuration( )
	return self:GetDTFloat( 1 )
end

function ENT:ShouldRecover()
	return ( self:GetDieTime() - CurTime() ) <= self:GetRecoveryTime()
end

function ENT:SetRecoveryTime( time )
	self:SetDTFloat( 2, time )
end

function ENT:GetRecoveryTime()
	return self:GetDTFloat( 2 )
end

function ENT:GetRecoveryCycle()
	return 1 - math.Clamp( ( self:GetDieTime() - CurTime() ) / math.max( 0.5, self:GetRecoveryTime() ), 0, 1 )
end

if SERVER then

function ENT:OnRemove()
	
	if IsValid(self.Entity.Owner) then
		if !self.NoUnfreezing then
			self.Entity.Owner:Freeze( false )
		end
		self.Entity.Owner.Knockdown = nil
		if self.Entity:GetOwner():GetCharTable().OnRemoveKnockdown then
			self.Entity:GetOwner():GetCharTable():OnRemoveKnockdown( self.Entity:GetOwner() )
		end
	end

end


function ENT:Think()
	if self:GetDieTime() <= CurTime() then 
		self:Remove()
		return 
	end
	
	if !IsValid(self.Entity.Owner) or IsValid(self.Entity.Owner) and !self.Entity.Owner:Alive() then
		self:Remove()
		return
	end
end

ENT.NextTouch = 0
function ENT:Touch( ent )
		
	if IsValid( ent ) and ent:IsPlayer() and ent ~= self.Entity:GetOwner() and not IsValid(ent.Knockdown) and !IsValid(ent.Execution) and !IsValid(ent.HostageEnt) and !ent:IsRolling() and !IsValid(self.Parent) and GAMEMODE:PlayerShouldTakeDamage(self.Entity:GetOwner(), ent) and !ent:GetCharTable().CantExecute and !self.Entity:GetOwner().CantBeExecuted and !ent:IsCharging() then
		ent.NextRoll = CurTime() + 1.5
		if ent:KeyDown( IN_JUMP ) then
			if self.NextTouch >= CurTime() then return end
			
			self.NextTouch = CurTime() + 1
			
			local wep = ent:GetActiveWeapon()
			
			/*if wep and IsValid(wep) and wep.HumanShield then
				local ex = ents.Create( "state_humanshield" )
				ex:SetHumanShield( self.Entity:GetOwner(), ent )
				ex:Spawn()
				
				self.NoUnfreezing = true
				self:Remove()
			else*/
			
				local ex = ents.Create( "state_execution" )
				ex:SetPos( ent:GetPos() )
				ex:SetOwner( ent )
				ex:SetParent( ent )
				ex:SetVictim( self.Entity:GetOwner() )
				ex:Spawn()
				
				self.Parent = ex
			//end
			
			
			
		end
		
	end
	
end

end

hook.Add("CalcMainActivity","KnockdownAnims",function(pl,vel)
	if pl.Knockdown and IsValid(pl.Knockdown) then
		local iSeq, iIdeal
		if pl.Knockdown:GetSkin() == 1 then
			if pl.Knockdown:ShouldRecover() then
				iSeq, iIdeal = pl:LookupSequence("zombie_slump_rise_02_fast")
			else
				iSeq, iIdeal = pl:LookupSequence("zombie_slump_idle_02")
			end
			//local iSeq, iIdeal = pl:LookupSequence("zombie_slump_idle_02")
			return iIdeal, iSeq 
		else
			if pl.Knockdown:ShouldRecover() then
				iSeq, iIdeal = pl:LookupSequence("zombie_slump_rise_01")
			else
				iSeq, iIdeal = pl:LookupSequence("zombie_slump_idle_01")
			end
			//local iSeq, iIdeal = pl:LookupSequence("zombie_slump_idle_01")
			return iIdeal, iSeq
		end
	end	
end)

hook.Add("UpdateAnimation","KnockdownAnims",function(pl, velocity, maxseqgroundspeed)
	if pl.Knockdown and IsValid(pl.Knockdown) then
		if pl.Knockdown:ShouldRecover() then
			pl:SetCycle( pl.Knockdown:GetRecoveryCycle() )
		else
			pl:SetCycle( 0 )
		end
		//pl:SetPlaybackRate(0)
		return true
	end
end)

if CLIENT then

function ENT:Draw()
	//self:DrawModel()
end	
	
end
