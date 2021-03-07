AddCSLuaFile()

ENT.Type = "anim"

for i=1,3 do
	util.PrecacheSound( "player/damage"..i..".wav" )
end

function ENT:Initialize()

	self.Entity:GetOwner().HumanShield = self
	self.Entity.Owner = self.Entity:GetOwner()
	self.Entity:DrawShadow( false )	
	self.Entity.Carrier = self:GetParent()
	
	self.Entity.Carrier.HostageEnt = self

	if SERVER then
		self.Entity:GetOwner():ThrowCurrentWeapon( 20, true, true )
		self.Entity:GetOwner():Freeze( true )

		//self.Entity:GetOwner():SetParent( self )
		
		self.Entity:GetOwner():SetMoveType(MOVETYPE_NOCLIP)

		if IsValid( self.Entity.Carrier ) then
			local carrier = self.Entity.Carrier
			//self.Entity.Carrier.HostageEnt = self
			//self.Entity:GetOwner():SetPos( carrier:GetPos() + carrier:GetAimVector() * 15 + carrier:GetAimVector():Angle():Right() * -8 )
			self.Entity:GetOwner():SetParent( self.Entity.Carrier )
		end
	end
	
end

if SERVER then

function ENT:OnRemove()
	
	if IsValid(self.Entity.Owner) then
		self.Entity:GetOwner():SetMoveType(MOVETYPE_WALK)
		//self.Entity.Owner:SetPos
		self.Entity.Owner:SetParent( NULL )
		self.Entity.Owner:Freeze( false )
		self.Entity.Owner.HumanShield = nil
	end
	
	if IsValid(self.Entity.Carrier) then
		self.Entity.Carrier.HostageEnt = nil
	end

end


function ENT:Think()
	
	
		
	if !IsValid(self.Entity.Owner) or IsValid(self.Entity.Owner) and !self.Entity.Owner:Alive() then
		self:Remove()
		return
	end
	
	if !IsValid(self.Entity.Carrier) or IsValid(self.Entity.Carrier) and !self.Entity.Carrier:Alive() then
		self:Remove()
		return
	else
		//self.Entity:GetOwner():RemoveEffects( EF_BONEMERGE ) 
		//self.Entity.Owner:SetPos( self.Entity.Carrier:GetPos() + self.Entity.Carrier:GetForward() * 36 )
		self.Entity.Owner:SetEyeAngles( self.Entity.Carrier:GetForward():Angle() )
		if !self.Entity.Owner:IsFrozen() then
			self.Entity.Owner:Freeze( true )
		end
		//self.Entity.Owner:SetPos( self.Entity.Carrier:GetPos() + self.Entity.Carrier:GetAimVector() * 15 + self.Entity.Carrier:GetAimVector():Angle():Right() * -8 )
		//self.Entity:GetOwner():AddEffects( EF_BONEMERGE ) 
	end
	
	if self.Entity.Carrier:KeyDown( IN_ATTACK2 ) then
		
		local dmginfo = DamageInfo()
			dmginfo:SetDamagePosition( self:GetPos() )
			dmginfo:SetDamage( self.Entity.Owner:Health()*2 )
			dmginfo:SetAttacker( self.Entity.Carrier )
			dmginfo:SetInflictor(self.Entity.Carrier )
			dmginfo:SetDamageType( DMG_CLUB )
			dmginfo:SetDamageForce( self.Entity.Carrier:GetAimVector() * 1400 )
		self.Entity.Owner.DeathSequence = { Anim = "death_04", Speed = math.Rand(1, 1.5) }
		self.Entity.Owner:TakeDamageInfo( dmginfo )
		self.Entity.Owner:EmitSound( "player/damage"..math.random(3)..".wav" )
		self.Entity.Carrier:PlayGesture( ACT_GMOD_GESTURE_ITEM_THROW )
		//self:Remove()
		return
	end
	
	self:NextThink( CurTime() )
end

function ENT:SetHumanShield( victim, carrier )
	
	self:SetOwner( victim )
	self:SetPos( carrier:GetPos() )
	self:SetParent( carrier )
	victim:SetPos( carrier:GetPos() + carrier:GetAimVector() * 15 + carrier:GetAimVector():Angle():Right() * -8 )
	victim:SetEyeAngles( carrier:GetForward():Angle() )
	
	self.Carrier = carrier
	
end

	function ENT:UpdateTransmitState()
		return TRANSMIT_ALWAYS
	end



end

if CLIENT then

function ENT:Draw()
end	
	
end

hook.Add("CalcMainActivity","HumanShieldAnims",function(pl,vel)
	if pl.HumanShield and IsValid(pl.HumanShield) then
		local iSeq, iIdeal = pl:LookupSequence("drive_pd")
		return iIdeal, iSeq
	end	
	if pl.HostageEnt and IsValid(pl.HostageEnt) then
		local iSeq, iIdeal = pl:LookupSequence("idle_dual")
		
		if vel:Length2D() > 0.5 then
			iSeq, iIdeal = pl:LookupSequence("walk_dual")
		end		
		
		return iIdeal, iSeq
	end	
end)

hook.Add("UpdateAnimation","HumanShieldAnims",function(pl, velocity, maxseqgroundspeed)
	//if pl.Knockdown and IsValid(pl.Knockdown) then
		//pl:SetPlaybackRate(0)
		//return true
	//end
end)