AddCSLuaFile()

ENT.Base = "sogm_mob"

ENT.AllowRespawn = false
ENT.GiveNetworkedWeapons = true 
ENT.CanDamageNextBots = true
ENT.IsBuddy = true
ENT.CantBeExecuted = true

function ENT:Initialize()

	if SERVER then
		self:SetModel( self:GetCharTable().Model or "models/player/kleiner.mdl" )
		
		self.WalkSpeed = self:GetCharTable().Speed or 380
		self.IdleSpeed = self.WalkSpeed / 3
		self.HP = self:GetCharTable().Health or 100
		
		self.Target = nil
		self.WeaponToTake = nil
		self.CurSpeed = self.IdleSpeed
		
		self:SetCustomCollisionCheck( true )
		
		self:SetHealth( self.HP )
		self:SetBloodColor( BLOOD_COLOR_RED )
		self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
		//self:SetCollisionBounds( Vector(-16,-16,0), Vector(16,16,72) )
		self:DrawShadow( false )
		
		self:AddEffects( EF_DIMLIGHT )
		
		self.loco:SetStepHeight( 18 ) 
		self.loco:SetAcceleration( self.WalkSpeed * 1.5 ) 
		
		self.SpawnProtection = CurTime() + 1
		
		if self:GetCharTable().OnSpawn then
			self:GetCharTable():OnSpawn( self )
		end
		
		self.Filter = { self, self:GetOwner() } 
		
		for k,v in pairs( team.GetPlayers( TEAM_MAIN ) ) do
			if v and v:IsValid() and v ~= self:GetOwner() then
				table.insert( self.Filter, v )
			end
		end
	end
	
end

local bmins = Vector(-0.75, -0.75, -0.75)
local bmaxs = Vector(0.75, 0.75, 0.75)
local owner_trace = { mask = MASK_SHOT, mins = bmins, maxs = bmaxs }
function ENT:Think()
	
	if SERVER then
		if !self:IsFrozen() then
			self:FindWeapon( 200, true )
		end
		
		local owner = self:GetOwner()

		if owner and owner:IsValid() then
			self.CurSpeed = self.WalkSpeed// * math.Clamp( self:GetRangeTo( owner:GetPos() )/70, 1, 1.5 )
			self.loco:SetAcceleration( self.WalkSpeed * (math.Clamp( self:GetRangeTo( owner:GetPos() )/50, 1, 10 ) * 1.3)  )
		end
		
		if !self:IsMoving() then
			//self:CheckAiming( owner )
		end
		
		if self.CallAttack and self.CallAttack > CurTime() then
			self:PrimaryAttack( true )
		end
		
		self:NextThink(CurTime())
		return true
	end
	
end

function ENT:OnInjured( dmginfo )
	
	if self.SpawnProtection and self.SpawnProtection > CurTime() then
		dmginfo:SetDamage( 0 )
		return 
	end
	
	local attacker = dmginfo:GetAttacker()
	
	if attacker and attacker:IsValid() and ( attacker:IsNextBot() and attacker ~= self or attacker:IsPlayer() ) then
		dmginfo:SetDamage( 0 )
	end
	
end

function ENT:CheckAiming( owner )
	
	owner = owner or self:GetOwner()
	
	if owner and owner:IsValid() and owner:Alive() and not self.WeaponToTake then// and self.AimTime and self.AimTime > CurTime() then
			
		owner_trace.start = owner:GetShootPos()
		owner_trace.endpos = self:GetShootPos() + owner:GetAimVector() * 9999
		owner_trace.filter = self.Filter
			
		local tr = util.TraceHull( owner_trace )
		
		for i=1,25 do
			//self:SetAngles( tr.Normal:Angle() )
			self.loco:FaceTowards( tr.HitPos )
		end
	end
	
end

function ENT:IsMoving()
	return self.loco:GetVelocity():Length() > 1//self.Moving
end

function ENT:MoveToPos( pos, options )

	local options = options or {}

	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( options.lookahead or 300 )
	path:SetGoalTolerance( options.tolerance or 20 )
	path:Compute( self, pos )
	
	local owner = self:GetOwner()

	if ( !path:IsValid() ) then 
		self.Moving = false
		return "failed" 
	end

	while ( path:IsValid() ) do

		path:Update( self )

		if ( options.draw ) then
			path:Draw()
		end
		
		self:CheckAiming( owner )
		
		self.Moving = true

		if ( self.loco:IsStuck() ) then

			self:HandleStuck();
			
			return "stuck"

		end

		if ( options.maxage ) then
			if ( path:GetAge() > options.maxage ) then return "timeout" end
		end
		
		if ( options.repath ) then
			if ( path:GetAge() > options.repath ) then path:Compute( self, pos ) end
		end

		coroutine.yield()

	end

	return "ok"

end


local options = { maxage = 0.1 }
local idle_options = { maxage = 0.01, idle = true }
local vec_up = vector_up
function ENT:RunBehaviour()

	while ( true ) do
 
		local owner = self:GetOwner()
 
		if self:IsFrozen() then

		else


			self.loco:SetDesiredSpeed( self.CurSpeed )
			
			self.Moving = false
						
			if owner and owner:IsValid() and owner:Alive() then	

				//if !self:IsMoving() then
					self:CheckAiming( owner )
				//end
			
				if self:GetRangeTo( owner:GetPos() ) > 60 or (self.WeaponToTake and self.WeaponToTake:IsValid()) then
				
					if self.WeaponToTake and self.WeaponToTake:IsValid() then
						self:MoveToPos( self.WeaponToTake:GetPos() + vec_up * 10 + VectorRand() * 13, options )
					else
						//self:CheckAiming( owner )
						self:MoveToPos( owner:GetPos(), idle_options )
					end
				end
				
				

			end	

		end
		coroutine.yield()
	end
	
end

