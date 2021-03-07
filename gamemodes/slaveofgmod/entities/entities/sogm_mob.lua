AddCSLuaFile()

local Vector = Vector
local pairs = pairs
local CurTime = CurTime
local team = team
local player = player
local tostring = tostring
local util = util
local traceline = util.TraceLine
local tracehull = util.TraceHull


ENT.Base = "base_nextbot"

ENT.WalkSpeed = 380
ENT.IdleSpeed = 100
ENT.HP = 100
ENT.SpotDistance = 300
ENT.ChaseDistance = ENT.SpotDistance + 50//100
ENT.AttackDistance = 270//220
ENT.NextBot = true
ENT.AllowRespawn = true
ENT.DOTCheck = 0.05

NEXTBOTS = NEXTBOTS or {}
NEXTBOTS_TEAM = NEXTBOTS_TEAM or {}

//some stuff for behaviours
BEHAVIOUR_DUMB = -1 //doesnt do anything, needed in editor
BEHAVIOUR_DEFAULT = 0 //normal one, wandering to random pickups
BEHAVIOUR_IDLE = 1 //stand still, until you see something
BEHAVIOUR_CCW = 2 //hotline miami-like, counter-clockwise movement
BEHAVIOUR_RANDOM = 3 //uh, walk randomly?
BEHAVIOUR_FOLLOWER = 4 //needs an owner, othwerise will revert to default
BEHAVIOUR_SCARED = 5 //runs away on sight?

function ENT:SetBehaviour( enum )
	self.Behaviour = enum or BEHAVIOUR_DEFAULT
end

function ENT:GetBehaviour()
	return self.Behaviour or BEHAVIOUR_DEFAULT
end

function ENT:SetTeam( t )
	self:SetDTInt( 1, t )
end

function ENT:Team()
	return self:GetDTInt( 1 ) or TEAM_DM
end

function ENT:SetNextBotColor( col )
	self:SetDTVector( 0, Vector( col.r/255, col.g/255, col.b/255 ) )
end

function ENT:SetCharacter( id )
	
	if type(id) == "string" then
		id = GAMEMODE:GetCharacterIdByReference( id )
	end
	
	if not id then return end
	self:SetDTInt( 0, id )
end

function ENT:Initialize()
		
	if SERVER then

		self:SetModel( self:GetCharTable().Model or "models/player/kleiner.mdl" )
		
		self.WalkSpeed = self:GetCharTable().Speed or 380
		self.IdleSpeed = self.WalkSpeed / 2.1
		self.HP = self:GetCharTable().Health or 100
		
		self.Target = nil
		self.WeaponToTake = nil
		self.CurSpeed = self.IdleSpeed
		
		//self:SetCustomCollisionCheck( true )
		
		self:SetHealth( self.HP )
		self:SetBloodColor( BLOOD_COLOR_RED or 0 )
		self:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
		self:SetSolidMask( MASK_PLAYERSOLID )
		self:SetCollisionBounds( Vector(-10,-10,0), Vector(10,10,72) )
		self:DrawShadow( false )
		
		//when there are a lot of bots, its better to disable this
		if self:GetCharTable().NoLights then
		
		else
			if not DISABLE_NEXTBOTLIGHT then
				self:AddEffects( EF_DIMLIGHT )
			end
		end
				
		self.loco:SetStepHeight( 18 ) 
		self.loco:SetAcceleration( self.WalkSpeed ) 
		self.loco:SetDeceleration( self.WalkSpeed ) 
		//self.loco:SetAcceleration( self.WalkSpeed * 1.5 ) 
		//self.loco:SetDeceleration( self.WalkSpeed * 1.5 ) 
		
		self.SpawnProtection = CurTime() + ( self:GetCharTable().SpawnProtection or 3 )
		
		
		self.SpawnTime = CurTime()
		
		self:SetLagCompensated( true ) 
		
		if self:GetCharTable().OnSpawn then
			self:GetCharTable():OnSpawn( self )
		end
		
		if self.Pursuit then
			self.Target = self.Pursuit
		end
		
		//fix thugs from getting stuck
		if self:GetModelScale() > 1 then
			local fix = 4
			self:SetCollisionBounds( Vector(-fix,-fix,0), Vector(fix,fix,72) )
		end
		
		
		NEXTBOTS[tostring(self)] = self
	
	end
	
	if CLIENT then
		if self:GetCharTable().WElements then
			self.WElements = table.Copy( self:GetCharTable().WElements )
			self:CreateModels( self.WElements )
		end
		
		if self:GetCharTable().OnClientSpawn then
			self:GetCharTable():OnClientSpawn( self )
		end
		
	end
	
end

function ENT:AddToTeams()

	if self.Optional then 
		self:RemoveEffects( EF_DIMLIGHT )
		return 
	end //test!
	if self.AddedToTeams then return end
	if not NEXTBOTS_TEAM[ self:Team() ] then
		NEXTBOTS_TEAM[ self:Team() ] = {}
	end
	NEXTBOTS_TEAM[ self:Team() ][tostring(self)] = self
	self.AddedToTeams = true
	
end

function ENT:OnContact( ent ) 
	/*if ent:GetClass() == "rpg_missile" then// and ent:Team() ~= self:Team() then
		print(tostring(self.Bodyguard))
		print(tostring(self:Team()).." rocket team: "..tostring(ent:Team()))
		print"rocket!"
	end*/
end

function ENT:SetImmune( bl )

	self.Immune = bl
	self.IgnoreDeaths = bl

end

function ENT:SpawnBodywear( mdl )
	
	mdl = mdl or "models/player/combine_super_soldier.mdl"
	
	local b = ents.Create( "ent_bodywear" )
	b:SetPos( self:GetPos() )
	b:SetParent( self )
	b:SetOwner( self )
	b:SetModel( mdl )
	b:Spawn()
	
	return b
	
end

function ENT:IsValidTarget( target )
	
	local check = target or self.Target

	return check and check:IsValid() and check.Alive and check:Alive()
end

//ENT.NextClosestCheck = 0
local vis_mins = Vector( -3, -3, 0 )
local vis_maxs = Vector( 3, 3, 3 )
local visible_trace = { mask = MASK_SOLID_BRUSHONLY, mins = vis_mins, maxs = vis_maxs }
local util = util
local table = table

function ENT:GetClosestTarget()

	if self.NoTargets then return end

	local check = false
	
	if !self.Target or !self:IsValidTarget() then
		check = true
	end
	
	if not self.NextClosestCheck then
		self.NextClosestCheck = CurTime() + math.Rand( 0, 2 )
	end
	
	local ct = CurTime()

	if ct < self.NextClosestCheck and !check then return end
	
	local dist = self.Target and self.Target:IsValid() and self:GetRangeSquaredTo( self.Target:GetShootPos() ) or 9999999
		
	self.NextClosestCheck = ct + 1
	
	if self.IgnorePlayers and self.IgnorePlayers > ct then return end
	
	local enemies 

	if self.EnemyTeam then
		if SINGLEPLAYER and self.EnemyTeam == TEAM_PLAYER then
			enemies = { Entity(1) }
		else
			enemies = team.GetPlayers( self.EnemyTeam )
		end
	else
		enemies = player.GetAll()
	end
	
	local check_nextbots_team = false
	
	if self.KillNextBots then
		if NEXTBOTS_TEAM[ self.KillNextBots ] then
			enemies = table.Add( enemies, NEXTBOTS_TEAM[ self.KillNextBots ] )
		else
			if type( self.KillNextBots ) == "boolean" then
				enemies = table.Add( enemies, NEXTBOTS )
			end
		end
	end
	
	
	for k, v in ipairs( enemies ) do
		local pl = enemies[k]
		
			if pl == self then continue end
			if !self:IsValidTarget( pl ) then continue end
			if pl.Immune then continue end
			if pl.SpawnProtection and pl.SpawnProtection > ct then continue end
			if pl:IsNextBot() and pl.IgnoreDeath and !pl.Bodyguard then continue end
			//if pl:IsNextBot() and check_nextbots_team and pl:Team() ~= self.KillNextBots then continue end
			if pl:GetSolid() == SOLID_NONE then continue end
			
			
			visible_trace.start = self:GetShootPos()
			visible_trace.endpos = pl:GetShootPos()
			
			local tr = tracehull( visible_trace )
			
			if tr.Hit or tr.HitWorld then continue end
			
			local range = self:GetRangeSquaredTo( pl:GetShootPos() )
			
			if range < dist and range < self.SpotDistance * self.SpotDistance and self:IsInView( pl, self.DOTCheck or 0.05 ) then
				dist = range
				self.Target = pl
			end
		
	end
	
	//even in hotline miami enemies have tiny reaction delay, so I added this
	if check and self:IsValidTarget() then
		local delay = self.Target and self.Target.GetCharTable and self.Target:GetCharTable().SpotDelay or 0.6
		if self.ReduceSpotDelay then
			delay = math.max( delay - self.ReduceSpotDelay, 0.1 )
		end
		local delta = math.Clamp( self:GetRangeSquaredTo( self.Target:GetShootPos() )/ ( self.SpotDistance * self.SpotDistance ), 0, 1 )
		self.NextAttack = ct + math.max( delay * delta, delay/2 )//0.1
	end
	
end

function ENT:GetClosestTarget2()

	if self.NoTargets then return end

	local check = false
	
	if !self.Target or !self:IsValidTarget() then
		check = true
	end
	
	if not self.NextClosestCheck then
		self.NextClosestCheck = CurTime() + math.Rand( 0, 2 )
	end
	
	local ct = CurTime()

	if ct < self.NextClosestCheck and !check then return end
	
	local dist = self.Target and self.Target:IsValid() and self:GetRangeSquaredTo( self.Target:GetShootPos() ) or 9999999
		
	self.NextClosestCheck = ct + 1
	
	if self.IgnorePlayers and self.IgnorePlayers > ct then return end
	
	/*local enemies 

	if self.EnemyTeam then
		if SINGLEPLAYER and self.EnemyTeam == TEAM_PLAYER then
			enemies = { Entity(1) }
		else
			enemies = team.GetPlayers( self.EnemyTeam )
		end
	else
		enemies = player.GetAll()
	end
	
	local check_nextbots_team = false
	
	if self.KillNextBots then
		if NEXTBOTS_TEAM[ self.KillNextBots ] then
			enemies = table.Add( enemies, NEXTBOTS_TEAM[ self.KillNextBots ] )
		else
			if type( self.KillNextBots ) == "boolean" then
				enemies = table.Add( enemies, NEXTBOTS )
			end
		end
	end*/
	
	local enemies = ents.FindInBox( self:GetShootPos() - self.SpotDistance * Vector(1, 1, 1), self:GetShootPos() + self.SpotDistance * Vector(1, 1, 1) )
	
	
	//for k, v in ipairs( enemies ) do
	for k = 1, #enemies do
		local pl = enemies[k]
		
		//test code here
		
		if pl and pl:IsValid() and ( pl:IsNextBot() or pl:IsPlayer() ) then
		
			if self.EnemyTeam then
				if SINGLEPLAYER and self.EnemyTeam == TEAM_PLAYER and pl:IsPlayer() and pl ~= Entity(1) then
					continue
				else
					if pl:IsPlayer() and pl:Team() ~= self.EnemyTeam then
						continue
					end
				end
			end
			
			if self.KillNextBots then
				if type( self.KillNextBots ) != "boolean" and pl:IsNextBot() and pl:Team() ~= self.KillNextBots then
					continue
				end
			else
				if pl:IsNextBot() then 
					continue 
				end
			end
		
			//////////

			if pl == self then continue end
			if !self:IsValidTarget( pl ) then continue end
			if pl.Immune then continue end
			if pl.SpawnProtection and pl.SpawnProtection > ct then continue end
			if pl:IsNextBot() and pl.IgnoreDeath and !pl.Bodyguard then continue end
			//if pl:IsNextBot() and check_nextbots_team and pl:Team() ~= self.KillNextBots then continue end
			if pl:GetSolid() == SOLID_NONE then continue end
			
			
			visible_trace.start = self:GetShootPos()
			visible_trace.endpos = pl:GetShootPos()
			
			local tr = tracehull( visible_trace )
			
			if tr.Hit or tr.HitWorld then continue end
			
			local range = self:GetRangeSquaredTo( pl:GetShootPos() )
			
			if range < dist and range < self.SpotDistance * self.SpotDistance and self:IsInView( pl, self.DOTCheck or 0.05 ) then
				dist = range
				self.Target = pl
			end
		
		end
		
	end
	
	//even in hotline miami enemies have tiny reaction delay, so I added this
	if check and self:IsValidTarget() then
		local delay = self.Target and self.Target.GetCharTable and self.Target:GetCharTable().SpotDelay or 0.6
		if self.ReduceSpotDelay then
			delay = math.max( delay - self.ReduceSpotDelay, 0.1 )
		end
		local delta = math.Clamp( self:GetRangeSquaredTo( self.Target:GetShootPos() ) / ( self.SpotDistance * self.SpotDistance ), 0, 1 )
		self.NextAttack = ct + math.max( delay * delta, delay/2 )//0.1
		
		if self:GetCharTable().OnTargetSpotted then
			self:GetCharTable():OnTargetSpotted( self, self.Target )
		end
		
	end
	
end

local vector_up = vector_up
ENT.NextWeaponCheck = 0
function ENT:FindWeapon( look_ahead, guns_only )
			
	local dist = 9999999
	
	local ct = CurTime()
	
	if self.Weapon and self.Weapon:IsValid() then return end
	if self.WeaponToTake and self.WeaponToTake:IsValid() then return end
	
	if ct < self.NextWeaponCheck then return end
	
	self.NextWeaponCheck = ct + 2
	
	for _, wep in pairs( DROPPED_WEAPONS ) do//ents.FindByClass( "dropped_weapon" )
		
		if !(wep and wep:IsValid()) then continue end
		local range = self:GetRangeSquaredTo( wep:GetPos() )
		
		if look_ahead and look_ahead * look_ahead < range then continue end
		if wep.StoredClip and wep.StoredClip <= 0 or wep.NoDamage then continue end
		if wep.Reserved and wep.Reserved:IsValid() then continue end
		if guns_only and wep:GetType() != "ranged" then continue end
		
		if range < dist then
			dist = range
			self.WeaponToTake = wep
		end
		
	end
	
	if self.WeaponToTake then
		self.WeaponToTake.Reserved = self
	end
	
end

local eye_trace = { }
function ENT:GetEyeTrace()
	eye_trace.start = self:GetShootPos()
	eye_trace.endpos = self:GetShootPos() + self:GetAimVector() * 9999
	eye_trace.filter = self
	return traceline( eye_trace )
end

function ENT:GetShootPos()
	if self:GetCharTable().OverrideShootPosOffset then
		return self:GetPos() + self:GetCharTable().OverrideShootPosOffset
	end
	return self:GetPos() + self:OBBCenter()
end

function ENT:GetAimVector()
	return self:GetForward()
end

function ENT:OnStuck()

	local tr = self:GetEyeTrace()
	
	if tr.Hit and tr.Entity and tr.Entity:GetClass() == "func_breakable" then
		self:PrimaryAttack( true )
	end
	
	//if self.SpawnPos and self.SpawnPos:Distance(self:GetPos()) < 20 then
	//	self:SetPos(self:GetRandomNearbyPosition( math.random(30,90) ))
	//end
end

function ENT:OnRemove()
	if SERVER then
		if NEXTBOTS[tostring(self)] then
			NEXTBOTS[tostring(self)] = nil
		end
		if NEXTBOTS_TEAM[ self:Team() ] and NEXTBOTS_TEAM[ self:Team() ][tostring(self)] then
			NEXTBOTS_TEAM[ self:Team() ][tostring(self)] = nil
		end
	end
	if CLIENT then
		self:RemoveModels()
	end
	if self:GetCharTable().OnRemove then
		self:GetCharTable():OnRemove( self )
	end
end

function ENT:OnInjured( dmginfo )
	
	if self.Immune then
		dmginfo:SetDamage( 0 )
		return true
	end
	
	if self.IgnoreDmgType and dmginfo:GetDamageType() == self.IgnoreDmgType then
		dmginfo:SetDamage( 0 )
		return true
	end
	
	if self.NoSpawnProtection then
	
	else
		if self.SpawnProtection and self.SpawnProtection >= CurTime() then
			dmginfo:SetDamage( 0 )
			return true
		end
	end
	
	local attacker = dmginfo:GetAttacker()
	
	if attacker and attacker:IsValid() and attacker:IsNextBot() and !attacker.KillNextBots and !attacker.CanDamageNextBots or attacker.Team and attacker:Team() == self.IgnoreTeamDamage then
		dmginfo:SetDamage( 0 )
	end
	
	if attacker and attacker:IsValid() and attacker:IsPlayer() and !(attacker.Team and attacker:Team() == self.IgnoreTeamDamage) then
		self.Target = attacker
	end
	
end

function ENT:PrimaryAttack( forced )

	if self:GetCharTable().DontAttack then return end
	if self.DontAttack then return end
	
	if self:GetCharTable().OverridePrimaryAttack then
		self:GetCharTable():OverridePrimaryAttack( self )
		return
	end

	if self.Weapon and self.Weapon:IsValid() then
		
		if self.Weapon.PrimaryAttack then
			self.NextAttack = self.NextAttack or 0
			if self.NextAttack < CurTime() then
				if self:GetCharTable().OnAttack then 
					self:GetCharTable():OnAttack( self )
				end
				self.NextAttack = CurTime() + self.Weapon.Primary.Delay
				if !self.Weapon.IsMelee and self.Weapon:Clip1() <= 0 then
					self.CanSwitch = nil
					self.Weapon:SecondaryAttack()
				else
					if self:IsInView() and !forced or forced then
						self.Weapon:PrimaryAttack()
						if self.NWwep then
							self:SetDTInt( 2, self.Weapon:Clip1() )
						end
					end
				end
			end
		end
		
	end
	
end

function ENT:OnLandOnGround( ground_ent ) 
	
	//if ground_ent == game.GetWorld() then print"ground" end
	
	if self:GetCharTable().OnLandOnGround then
		self:GetCharTable():OnLandOnGround( self, ground_ent )
	end
	
end

function ENT:Think()
	
	if SERVER then
		
		if self:GetActiveWeapon() and self:GetActiveWeapon():IsValid() and self:GetActiveWeapon().NextbotThink then
			self:GetActiveWeapon():NextbotThink()
		end
		
		if self.OnThink then
			self:OnThink()
		end
		
		if self:GetCharTable().OnThink then
			self:GetCharTable():OnThink( self )
		end
		
		if self.Spawned then
			self:AddToTeams()
		end
	
		if not self.IsFrozen or self:GetBehaviour() == BEHAVIOUR_DUMB then
			return
		end
	
		if self.IsFrozen and !self:IsFrozen() then
			//if self.Bodyguard or self.Ally then
				//print"ally"
				
				self:GetClosestTarget2()
				
			//else
				//print"normal"
				//self:GetClosestTarget()
			//end
			self:FindWeapon()
				
			if self.CallAttack and self.CallAttack > CurTime() then
				self:PrimaryAttack( false )
			end
		end
		self:NextThink(CurTime())
		return true
	end
	
end

function ENT:Alive()
	return self:Health() > 0
end

function ENT:DoKnockdown( time, bypass, attacker, punch )

	if self.Immune then return end
	if !self:Alive() then return end
	if IsValid(self.Knockdown) then return end
	if IsValid(self.Execution) then return end
	if IsValid(self.HumanShield) then return end
	if IsValid(self.HostageEnt) then return end
	if self.NoKnockdown then return end
	if attacker and attacker:GetCharTable().CantKnockdown and !bypass then return end
	if self:GetCharTable().KnockdownImmunity and !bypass then return end
	if punch and attacker and attacker:Team() == self:Team() and DISABLE_TEAM_PUNCHING then return end
	
	if self:GetCharTable().KnockdownTimePenalty then
		time = time + self:GetCharTable().KnockdownTimePenalty
	end
	
	local k = ents.Create( "state_knockdown" )
	k:SetParent( self )
	k:SetPos( self:GetPos() + vector_up * 20 )
	k:SetAngles(Angle(90,0,0))
	k:SetOwner( self )
	//k.Time = time or 3
	k:SetDuration( time or 3 )
	k:Spawn()
	
	if attacker and attacker:IsValid() and attacker:IsPlayer() and !(attacker.Team and attacker:Team() == self.IgnoreTeamDamage) then
		self.Target = attacker
	end
	
	hook.Call("OnNextBotKnockdown", GAMEMODE, self, attacker)
	
	return k
end

function ENT:Freeze( bl )
	self.m_Frozen = bl
end

function ENT:IsFrozen()
	return self.m_Frozen
end

function ENT:Give( class, networked )
	
	self.NWwep = false
	
	local wep = ents.Create( class )
	wep:SetPos( self:GetPos())
	wep:SetAngles( self:GetAngles() )
	
	self.Weapon = wep
	
	wep:SetOwner( self )
	wep:SetParent( self )
	wep:Spawn()

	wep:SetCollisionGroup(COLLISION_GROUP_NONE)
	wep:SetSolid(SOLID_NONE)
	wep:AddEffects(EF_BONEMERGE)
	
	if !string.find( class, "fists" ) then
		wep:Fire( "SetParentAttachment", "anim_attachment_RH" )
	end
	
	if wep.Equip then
		wep:Equip(self)
	end
	wep.Owner = self
	if wep.Deploy then
		wep:Deploy()
	end
	self:DeleteOnRemove( wep ) 
	
	if !wep.IsMelee and networked then
		self:SetDTEntity( 0, wep )
		self:SetDTInt( 2, wep:Clip1() )
		self.NWwep = true
	end
	
	self.WeaponToTake = nil
	
end

function ENT:StripWeapon( class )
	if self.Weapon and self.Weapon:IsValid() then
		if self.Weapon.OnRemove then
			self.Weapon:OnRemove()
		end
		self.Weapon:Remove()
		self.Weapon = nil
	end
end

function ENT:GetActiveWeapon()
	return self.Weapon
end

function ENT:GetWeapon()
	return self.Weapon
end

function ENT:SelectWeapon()
end

function ENT:ShowSpawnProtectionEffect( time )
	if self.NoSpawnProtection then return end
	local e = EffectData( )
		e:SetOrigin( self:GetPos() )
		e:SetEntity( self )
		e:SetRadius( time or 1 )
	util.Effect( "spawn_protection" , e, nil, true)
end

local wtrace = { mask = MASK_SOLID }
function ENT:ThrowCurrentWeapon( force, noknockback, instant )
	
	local wep = self:GetActiveWeapon()
	
	if !IsValid( wep ) then return false end
	if wep.Hidden then return end
	if self:GetCharTable().RemoveWeaponOnDeath then return end
	
	
	self.NextThrow = self.NextThrow or 0
	
	if not instant then
		if self.NextThrow >= CurTime() then return false end
	end

	wtrace.start = self:GetShootPos()
	wtrace.endpos = self:GetShootPos() + self:GetAimVector() * math.min( 0, 20 - wep:OBBMaxs():Distance(wep:OBBMins())/1.8 ) 
	wtrace.filter = self
	
	local tr = traceline(wtrace)
	
	local pr = ents.Create( "dropped_weapon" )
	pr:SetPos( tr.HitPos )
	local ang = self:GetAimVector():Angle()
	if not wep.NoRotation then
		ang:RotateAroundAxis( self:GetAimVector(), 90)
	end
	pr:SetAngles( ang )
	pr:DropAsWeapon( wep, self:GetCharTable().UseAkimboGuns and wep.Akimbo )
	pr:SetAttacker( self )
	pr.NoKnockback = noknockback or false
	pr:Spawn()
	
	local phys = pr:GetPhysicsObject()
	if IsValid(phys) then
		phys:SetVelocityInstantaneous( self:GetAimVector() * ( ( force or 430 ) * (self:GetCharTable().ThrowMultiplier or 1) ))
		phys:Wake()
	end
	
	self:StripWeapon( wep:GetClass() )
	
	if not noknockback then
		self:EmitSound( "weapons/slam/throw.wav" )
	end
	
	self.NextThrow = CurTime() + 1
	
	self:ResetBoneMatrix()
	self:ResetBoneMatrix()
	self:ResetBoneMatrix()
		
	return true
	
end

local nearby_trace = { mask = MASK_SOLID_BRUSHONLY }
function ENT:GetRandomNearbyPosition( dist, mask )
	dist = dist or 43
	
	local rand = VectorRand()
	rand.z = 0
	local pos = self:GetShootPos() + rand * dist
	
	nearby_trace.start = self:GetShootPos()
	nearby_trace.endpos = pos
	nearby_trace.filter = self
	
	if mask then
		nearby_trace.mask = mask
	end
	
	local tr = traceline(nearby_trace)
	
	return tr.HitPos
	
end


function ENT:SpawnNearbyWeapon( class )
	
	local pos = self:GetRandomNearbyPosition()
	
	local pr = ents.Create( "dropped_weapon" )
		pr:SetPos( pos )
		pr:SpawnAsWeapon( class )
		pr.NoKnockback = false
		pr.Exception = true
	pr:Spawn()

	local phys = pr:GetPhysicsObject()
	if IsValid(phys) then
		phys:SetVelocityInstantaneous( vector_up * 130 )
	end
	
	return pr
	
end

function ENT:LagCompensation( bl )
end

function ENT:SetGoal()
end

function ENT:IsRolling()
	return IsValid( self.Roll )
end

function ENT:GetAttackDistance()
	
	if self.OverrideAttackDistance then
		return self.OverrideAttackDistance
	end

	if self.Weapon and self.Weapon:IsValid() and self.Weapon.IsMelee and !self.Weapon.Throwable then
		return math.max( ( self.Weapon.MeleeRange or 53 ) - 10, 45 ) * math.min( 2, self:GetModelScale() ) //45
	else
		return self.AttackDistance
	end
end

function ENT:IsInView( ent, dot )
	
	ent = ent or self.Target
	dot = dot or -0.35
	
	if not ent then return false end
	
	local norm = (self:GetPos() - ent:GetPos()):GetNormal()
	
	return norm:Dot(self:GetAimVector()) <= dot
	
end

function ENT:IsTargetInRange()
	return IsValid( self.Target ) and self:GetRangeSquaredTo( self.Target:NearestPoint( self:GetShootPos() ) ) <= ( self:GetAttackDistance() * self:GetAttackDistance() )
end

function ENT:StopAllPaths( cooldown )
	self.StopPath = true
	self.NextStopPath = CurTime() + ( cooldown or 5 )
end

function ENT:OnNavAreaChanged( old, new ) 
	if self.StoreAreas then
		self.OldArea = old
		self.NewArea = new
	end
end

//time for a bunch of new and exciting workarounds
function ENT:PathGenerator( area, fromArea, ladder, elevator, length )
	
	if ( !IsValid( fromArea ) ) then

		// first area in path, no cost
		return 0

	else

		if ( !self.loco:IsAreaTraversable( area ) ) then
			// our locomotor says we can't move here
			return -1
		end
		
		if GAMEMODE and GAMEMODE.BlockedAreas and GAMEMODE.BlockedAreas[ tostring( area ) ] then
			return -1
		end

		// compute distance traveled along path so far
		local dist = 0

		if ( IsValid( ladder ) ) then
			dist = ladder:GetLength()
		elseif ( length > 0 ) then
			// optimization to avoid recomputing length
			dist = length
		else
			dist = ( area:GetCenter() - fromArea:GetCenter() ):GetLength()
		end

		local cost = dist + fromArea:GetCostSoFar()

		// check height change
		local deltaZ = fromArea:ComputeAdjacentConnectionHeightChange( area )
		if ( deltaZ >= self.loco:GetStepHeight() ) then
			if ( deltaZ >= self.loco:GetMaxJumpHeight() ) then
				// too high to reach
				return -1
			end

			// jumping is slower than flat ground
			local jumpPenalty = 5
			cost = cost + jumpPenalty * dist
		elseif ( deltaZ < -self.loco:GetDeathDropHeight() ) then
			// too far to drop
			return -1
		end

		return cost
	end
end

if SERVER then
local E_PathFollower = FindMetaTable("PathFollower")

PF_SetMinLookAheadDistance = E_PathFollower.SetMinLookAheadDistance
PF_SetGoalTolerance = E_PathFollower.SetGoalTolerance
PF_Compute = E_PathFollower.Compute
PF_GetAge = E_PathFollower.GetAge
 

function ENT:MoveToPos( pos, options )

	self.NextMove = self.NextMove or 0
	
	//if self.NextMove > CurTime() then return end
	
	//if self:GetCharTable().OverrideBodyUpdate then
	
	//else
	//	self.NextMove = CurTime() + 0.25
	//end

	local options = options or {}

	if not self.Path then // or self.Path and !self.Path:IsValid() then
		self.Path = Path( "Follow" )
	end
	
	local path = self.Path
	
	//local path = Path( "Follow" )
	
	if self.NextMove < CurTime() then 
	
		PF_SetMinLookAheadDistance( path, options.lookahead or 300 )
		PF_SetGoalTolerance( path, options.tolerance or 20 )
		PF_Compute( path, self, pos, self.PathGenerator )
		
		self.NextMove = CurTime() + 0.25
	end
	

	
	self.PathObject = path
	
	self.CheckForStuck = 0
	
	if self.OverrideRepath then
		options.repath = self.OverrideRepath
	end

	if ( !path:IsValid() ) then return "failed" end

	while ( path:IsValid() ) do

		path:Update( self )

		if ( options.draw ) or self.DebugPath then// or self.Bodyguard then
			path:Draw()
		end
		
		//Basically this should instantly cancel idle behaviour when bot sees someone
		if self:IsValidTarget() and options.idle then
			//print"Stopping idle path"
			return "ok"
		end
		
		if self.NextBulletReact and self.NextBulletReact > CurTime() and self.CheckPosition and self:GetRangeSquaredTo( self.CheckPosition ) < 8100 then
			self.CheckPosition = nil
			return "ok"
		end
		
		if self.StopPath and ( self.NextStopPath or 0 ) <= CurTime() then
			self.StopPath = nil
			return "ok"
		end
		
		if self.loco:GetVelocity():LengthSqr() < 1 then
			self.CheckForStuck = self.CheckForStuck + 1
		else
			self.CheckForStuck = 0
		end
		
		if self.CheckForStuck > 10 and self.SpawnTime + 10 > CurTime() then

			self.CheckForStuck = 0
			
			self:OnStuck()
			
			return "stuck"
		end
		
		if ( self.loco:IsStuck() ) then
			
			self:HandleStuck();
			
			return "stuck"

		end

		if ( options.maxage ) then
			if ( path:GetAge() > options.maxage ) then return "timeout" end
		end
		
		if ( options.repath ) then
			if ( path:GetAge() > options.repath ) then PF_Compute( path, self, pos, self.PathGenerator ) end
		end

		coroutine.yield()

	end

	return "ok"

end
end

local VectorRand = VectorRand
local options = { maxage = 0.1, repath = 1 }
local weapon_take_options = { maxage = 0.1, repath = 1, tolerance = 1 }
local idle_options = { maxage = 0.1, idle = true, repath = 1}
local ccw_trace = { mask = MASK_SOLID_BRUSHONLY, mins = Vector( -2, -2, -35 ), maxs = Vector( 2, 2, 0 ) }
ENT.PathOptions = options
function ENT:RunBehaviour()

	while ( true ) do
				
		if self:IsFrozen() or self:GetBehaviour() == BEHAVIOUR_DUMB then

		else
			self.loco:SetDesiredSpeed( self.OverrideSpeed or self.CurSpeed )
			
			if self.Pursuit and self.Target == nil then
				self.Target = self.Pursuit
			end
			
			//beep boop, target aquired
			if self:IsValidTarget() and self:GetActiveWeapon() and self:GetActiveWeapon():IsValid() and self:GetRangeSquaredTo( self.Target:GetPos() ) <= self.ChaseDistance * self.ChaseDistance then
				
				if self:GetActiveWeapon() and self:GetActiveWeapon():IsValid() and !self:GetActiveWeapon().IsMelee then
					self.CurSpeed = self.Pursuit and self.IdleSpeed or self.IdleSpeed/3
				else
					self.CurSpeed = self.WalkSpeed
				end
				
				if self.Pursuit or !self:IsTargetInRange() then
					local norm = ( self.Target:GetPos() - self:GetPos() ):GetNormal() // just so they dont facehug target too hard
					self:MoveToPos( self.Target:GetPos() - norm * 18 - norm * ( self.KeepDistance or 0 ) - ( self.KeepDistanceVectorOffset or vector_origin ), options )
				end
				//add delay here
				if self:IsTargetInRange() and !IsValid(self.Target.Knockdown) then
					
					visible_trace.start = self:GetShootPos()
					visible_trace.endpos = self.Target:GetShootPos()
		
					local tr = tracehull( visible_trace )
		
					if !( tr.Hit or tr.HitWorld ) then
					
						//local vec = VectorRand() * math.random(0, 13)
						//vec.z = 0
						//self.loco:FaceTowards( self.Target:GetShootPos() )
						if not self.FreezeAim then
							self.loco:FaceTowards( self.Target:GetShootPos() )// + vec
						end
						self.CallAttack = CurTime() + 0.1
					else
						
						//if target is not in sight - check the last position, instead of slowly walking and knowing where it was
						//if not self.Pursuit then
							self:StopAllPaths( 10 )
							self.NextBulletReact = CurTime() + 3
							self.NextIdle = CurTime() + 3
							self.CheckPosition = self.Target:GetPos()
								
							//if self.Target ~= nil then
								self.Target = nil
							//end
						//end

					end
				
				end
				
				
			//idle behaviour	
			else
								
				//if self.Target ~= nil then
					self.Target = nil
				//end
				
				//no weapons, get one
				if self.WeaponToTake and self.WeaponToTake:IsValid() then
					self.CurSpeed = self.WalkSpeed
					//self:MoveToPos( self.WeaponToTake:GetPos()+vector_up * 10, options )//+VectorRand()*12
					//self:MoveToPos( self.WeaponToTake:LocalToWorld( self.WeaponToTake:OBBCenter()+VectorRand() * ( self:GetRangeTo( self.WeaponToTake:GetPos() ) < 100 and 12 or 3 ) ) + vector_up * 10, options )
					local wep_pos = self.WeaponToTake:LocalToWorld( self.WeaponToTake:OBBCenter())
					local my_pos = self:GetPos() - self:GetAimVector() * 10
					local wep_dir = (wep_pos - my_pos):GetNormal()
					local goalpos = wep_pos + wep_dir * 60
					//if self:GetRangeTo( goalpos ) > 10 then
						//debugoverlay.Cross( goalpos, 2, 7, color_white, true )
						self:MoveToPos( goalpos, options )
					//end

				else
					
					self.IdlePos = self.IdlePos or nil
					
					//normal behaviour
					if self:GetBehaviour() == BEHAVIOUR_DEFAULT then
						
						if CurTime() > ( self.NextIdle or 0 ) or !self.IdlePos then
							
							
							if WANDER_POINTS and #WANDER_POINTS > 0 then
								self.IdlePos = WANDER_POINTS[math.random(#WANDER_POINTS)]
							else
								if POINT_PICKUPS and #POINT_PICKUPS > 0 then
									self.IdlePos = POINT_PICKUPS[math.random(#POINT_PICKUPS)]:GetPos()
								else
									self.IdlePos = self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 100
								end
							end
							
							if self.GoalTable and #self.GoalTable > 0 and math.random(3) == 2 then
								local togo = self.GoalTable[math.random(#self.GoalTable)]
								if togo and togo:IsValid() and togo:IsPlayer() and togo:Alive() then
									self.IdlePos = togo:GetPos()
								end
							end
														
							self.NextIdle = CurTime()+math.random(7,13)

						end
						
						//this should fix weird spazzing out behaviour
						if self:GetRangeSquaredTo( self.IdlePos ) > 400 then
							self.IdlePos = self.IdlePos	
						else
							self.IdlePos = nil
						end
					
					//idle
					elseif self:GetBehaviour() == BEHAVIOUR_IDLE then
						
						local pos = self.SpawnPos or self:GetPos()
						local look_at = self.LookAt or self:GetShootPos() + self:GetAimVector() * 170
						
						if self:GetRangeSquaredTo( pos ) > 400 then
							self.IdlePos = self.IdlePos or pos	
						else
							self.IdlePos = nil
						end
						
						self.LookAt = self.LookAt or look_at
						
					//counter clockwise
					elseif self:GetBehaviour() == BEHAVIOUR_CCW then
												
						self.DirAng = self.DirAng or self:GetAngles()
						self.NextRotation = self.NextRotation or 0
						//first time or we are already facing the obstacle						
						if ( not self.IdlePos or self.IdlePos and self.IdlePos:DistToSqr( self:GetShootPos() ) < 1600 ) or self.loco:GetVelocity():Length() < self.CurSpeed/2 then//CurTime() > ( self.NextIdle or 0 )
							
							
							ccw_trace.start = self:GetShootPos()
							ccw_trace.endpos = self:GetShootPos() + self.DirAng:Forward() * -800
							ccw_trace.filter = self
								
							if self.NextRotation < CurTime() then
								self.DirAng:RotateAroundAxis( vector_up, 90 )
								self.NextRotation = CurTime() + 2
							end
							//print(self.DirAng)
							
							local tr = tracehull( ccw_trace )
																		
							self:StopAllPaths( 0 )

							self.IdlePos = tr.HitPos
							
							self.NextIdle = CurTime() + 9
							
						end

					elseif self:GetBehaviour() == BEHAVIOUR_FOLLOWER then
						
						local owner = self:GetOwner()
						
						if owner and owner:IsValid() and owner:Alive() then
							self.CurSpeed = self.WalkSpeed
							
							if self:GetRangeSquaredTo( owner:GetPos() ) > 3600 then
								self.IdlePos = owner:GetPos()
								if self.FollowOffset then
									self.IdlePos = self.IdlePos + self.FollowOffset * 30//math.random(30,50)
								end
							else
								self.IdlePos = nil //let's stop calling MoveToPos, because this will cause bot to have shivers
								
								if LEVEL_CLEAR then
									self.LookAt = self:GetOwner():GetPos()
								end
							end
							
						else
							//try looking up for new owner as enemy
							local found = false
							
							if self:Team() == TEAM_MOB then
								local max = 99999 * 99999
								local cur_closest
								
								for k, v in pairs( NEXTBOTS ) do
									if v and v:IsValid() and v:Alive() and v ~= self and v:GetPos():DistToSqr( self:GetPos() ) <= max and v:Team() == self:Team() and v:GetBehaviour() != BEHAVIOUR_FOLLOWER then
										max = v:GetPos():DistToSqr( self:GetPos() )
										cur_closest = v
									end
								end
								
								if cur_closest and cur_closest:IsValid() then
									found = true
									self:SetOwner( cur_closest )
								end
								
							end
							if not found then
								if self.Ally or self.Bodyguard then
									self:SetBehaviour( BEHAVIOUR_DUMB )
									self.IdleAnim = "idle_all_cower"
								else
									self:SetBehaviour( BEHAVIOUR_DEFAULT )//BEHAVIOUR_IDLE
								end
							end
						end
						
					end
					
					if self.NextBulletReact and self.NextBulletReact > CurTime() and self.CheckPosition then
						if self:GetActiveWeapon() and self:GetActiveWeapon():IsValid() and !self:GetActiveWeapon().IsMelee then
							self.CurSpeed = self.IdleSpeed
						else
							self.CurSpeed = self.WalkSpeed
						end
						//self.CurSpeed = self.WalkSpeed
						self:MoveToPos( self.CheckPosition, idle_options )
					else
						self.CurSpeed = self.IdleSpeed
						if self.IdlePos then
							self:MoveToPos( self.IdlePos, idle_options )
						end
						if self.LookAt and not self.FreezeAim then
							self.loco:FaceTowards( self.LookAt )
							self.loco:FaceTowards( self.LookAt )
						end
					end
					
				end
			
			end	
		
			
		end
		
		if not self:IsFrozen() then
			if self.OverrideSpeed then
				self.loco:SetDesiredSpeed( self.OverrideSpeed )
			end
			if self.OverrideMovePos then
				self:MoveToPos( self.OverrideMovePos, options )
			end
			if self.OverrideLookAt then
				self.loco:FaceTowards( self.OverrideLookAt )
				self.loco:FaceTowards( self.OverrideLookAt )
			end
		end
		
		coroutine.yield()
	end
	
end

function ENT:OnKilled( dmginfo )
	
	self.Dead = true
	
	local attacker = dmginfo:GetAttacker()
	local inflictor = dmginfo:GetInflictor()
	
	if self:GetCharTable().PreOnDeath then
		self:GetCharTable():PreOnDeath( self, attacker, dmginfo )
	end
	
	hook.Call("DoNextBotDeath", GAMEMODE, self, attacker, dmginfo)
	
	if self.AllowRespawn then
		GAMEMODE:SpawnBot( nil, self:GetCharacter(), nil, self:Team(), self.EnemyTeam, self.KillNextBots )
	end
	
	self:ThrowCurrentWeapon( 16, true )
	
	local force_dism = false
	
	if dmginfo:GetDamageType() == DMG_BLAST then
		force_dism = true
	end
	
	if dmginfo:GetDamageType() == DMG_BURN then
		self:SetMaterial( "models/charple/charple1_sheet" )
	end
	

	if NIGHTMARE and DRUG_EFFECT then
		force_dism = true
	end
	
	if ( attacker:IsValid() and ( attacker:IsPlayer() or attacker.NextBot ) ) then
		
		if inflictor and inflictor.OnKill then
			inflictor:OnKill( self, attacker, dmginfo )
		end
		
		if inflictor and inflictor.OnExecution and IsValid( self.Knockdown ) then
			inflictor:OnExecution( self, attacker, dmginfo )
		end
		
		if attacker ~= self then
			
			if attacker:GetCharTable().AlwaysDismemberment then
				force_dism = true
			end
			
			if !attacker.NextBot then
				if IsValid( self.Knockdown ) then
					if inflictor == attacker then
						attacker:AddScore( PTS_EXECUTION_BARE + ( attacker:GetCharTable().BonusPtsOnKill or 0 ), self )
					else
						attacker:AddScore( ( inflictor.ExecutionPoints or PTS_EXECUTION ) + ( attacker:GetCharTable().BonusPtsOnKill or 0 ), self )
					end
				else
					if inflictor then
						if inflictor.IsMelee then
							attacker:AddScore( ( inflictor.KillPoints or PTS_MELEE_KILL ) + ( attacker:GetCharTable().BonusPtsOnKill or 0 ) , self )
						else
							if inflictor == attacker then
								attacker:AddScore( PTS_BARE_KILL + ( attacker:GetCharTable().BonusPtsOnKill or 0 ), self )
							else
								attacker:AddScore( PTS_RANGED_KILL + ( attacker:GetCharTable().BonusPtsOnKill or 0 ), self )
							end
						end
					end
				end
				
				attacker:CheckCombo( inflictor.IsMelee or inflictor == attacker )
			end
		end
		
	end

	if self:GetCharTable().Horse then
		self:SetModel( "models/player/skeleton.mdl" )
	end
	
	if self:GetCharTable().DeathModel then
		self:SetModel( self:GetCharTable().DeathModel )
	end
	
	self:BecomeRagdoll( dmginfo )
	
	if self:GetCharTable().OnDeath then
		self:GetCharTable():OnDeath( self, attacker, dmginfo )
	end
	
	if self:GetCharTable().OverrideDeathEffects then
		self:GetCharTable():OverrideDeathEffects( self, attacker, dmginfo )
		return
	end

	if self:GetCharTable().Horse then
		local e = EffectData()
			e:SetOrigin( self:GetShootPos() )
			e:SetEntity( self )
			e:SetNormal( dmginfo:GetDamageForce():GetNormal() )
		util.Effect( "bloody_dissolve", e, nil, true )
		return
	end
	
	local slice = false
						
	if attacker and ( attacker:IsPlayer() or attacker.NextBot ) and inflictor and inflictor.AllowSlicing then
			
		local ang = (attacker:GetAttachment(attacker:LookupAttachment("eyes")).Ang+(VectorRand()*math.random(-35,35)):Angle()):Up()
		local check_trace = attacker:GetEyeTrace()
		local pos = self:GetShootPos() + VectorRand()*math.Rand(-4,4)//ply:NearestPoint(dmginfo:GetDamagePosition())
		local zpos = pos.z
					
		local slice_rotation = math.random( 30,130 )
		local change_rotation = false
		
		if math.abs( pos.x - self:GetPos().x ) > 6 then
			pos.x = self:GetPos().x + math.random( -3, 3 )
			change_rotation = true
		end
			
		if math.abs( pos.y - self:GetPos().y ) > 6 then
			pos.y = self:GetPos().y + math.random( -3, 3 )
			change_rotation = true
		end
			
		if change_rotation then
			slice_rotation = math.random( 40,120 )
		end
		
		if zpos < self:GetPos().z then
			zpos = self:GetPos().z + math.random( 10, 20 )
		end
			
		if zpos > self:GetPos().z + 60 then
			zpos = self:GetPos().z + 60 - math.random( 15, 30 )
		end
			
		if check_trace.Entity and check_trace.Entity:IsValid() and check_trace.Entity == self then
			pos = check_trace.HitPos
			zpos = pos.z
			slice_rotation = math.random( 30,130 )
		end
			
		if attacker:GetGroundEntity() ~= game.GetWorld() or self:GetGroundEntity() ~= game.GetWorld() or IsValid(self.Knockdown) or attacker:IsRolling() then
			ang = attacker:GetAimVector():Angle():Right():Angle()
			ang:RotateAroundAxis( attacker:GetAimVector(), math.random( -4,4 ) )
			ang = ang:Forward()
			zpos = zpos - math.random( 10 )
		else
			ang = attacker:GetAimVector():Angle():Right():Angle()
			ang:RotateAroundAxis( attacker:GetAimVector(), slice_rotation )
			ang = ang:Forward()
		end
			
		local e = EffectData()
		e:SetEntity( self )
		e:SetOrigin( self:GetPos() )
		e:SetStart( pos )
		e:SetScale( zpos )
		e:SetNormal( ang )
		e:SetRadius( 1 )
			
		util.Effect("slice",e,nil,true)
		
		/*local e = EffectData()
		e:SetEntity( self )
		e:SetOrigin( self:GetPos() )
		e:SetStart( pos )
		e:SetScale( zpos )
		e:SetNormal( ang*-1 )
		e:SetRadius( 1 )
			
		util.Effect("slice",e,nil,true)*/
			
		slice = true
			
	end
	
	if (force_dism or self.ToDismember) then// and !slice 
		self:Dismember( force_dism or self.ToDismember, dmginfo )
	end
	
	if attacker ~= self then
		local e = EffectData()
			e:SetOrigin( self:GetPos() )
			e:SetEntity( self )
			e:SetNormal( dmginfo:GetDamageForce():GetNormal() )
			e:SetMagnitude( dmginfo:GetDamageForce():Length() )
		util.Effect( "generic_death", e, nil, true )
	end
	
	if self.DeathSequence and !slice then
		local id, duration = self:LookupSequence( NIGHTMARE and "taunt_dance_base" or self.DeathSequence.Anim )
		local e = EffectData()
			e:SetEntity(self)
			e:SetOrigin(self:GetPos())
			e:SetAngles(self:GetAngles())
			e:SetMagnitude( id )
			e:SetScale( self.DeathSequence.Speed or 1 )
		util.Effect( "death_sequence", e, nil, true )
	end

	if !slice then
		local e = EffectData()
			e:SetOrigin(self:GetPos())
			e:SetEntity(self)
			e:SetScale( IsValid( self.ent_bodywear ) and self.ent_bodywear:EntIndex() or 0 )
		util.Effect( "fake_body", e, nil, true )
	end

end

function ENT:ShakeView()
end

local RandomDism = {
	HITGROUP_HEAD,
	HITGROUP_LEFTARM,
	HITGROUP_RIGHTARM,
	HITGROUP_RIGHTLEG,
	HITGROUP_LEFTLEG,
	HITGROUP_GEAR,
}

function ENT:Dismember( hitgroup )

	hitgroup = hitgroup or RandomDism[math.random(1,#RandomDism)]
	
	if type( hitgroup ) ~= "number" then hitgroup = -1 end
	
	if NIGHTMARE and DRUG_EFFECT then//  and hitgroup == -1 
		local e = EffectData()
			e:SetEntity( self )
			e:SetOrigin( self:GetPos() )
			e:SetNormal( dmginfo and dmginfo:GetDamageForce():GetNormal() or VectorRand() )
		util.Effect("player_gib", e, nil, true)
	else
		local e = EffectData()
			e:SetEntity( self )
			e:SetOrigin( self:GetPos() )
			e:SetScale( hitgroup )
		util.Effect("dismemberment", e, nil, true)
	end


end

function ENT:SetBleeding( bl )
	self:SetDTBool( 1, bl )
end

function ENT:IsBleeding()
	return self:GetDTBool( 1 )
end

function ENT:PlayGesture( gesture )
	
	if type( gesture ) == "string" then
		self:AddGestureSequence( self:LookupSequence( gesture ) )
	else
		self:AddGesture( gesture )
	end
	//self:RestartGesture( gesture )
end

function ENT:BodyUpdate()

	//in case if I want to use sequences and shit. a lot.
	if self:GetCharTable() and self:GetCharTable().OverrideBodyUpdate then
		self:GetCharTable():OverrideBodyUpdate( self )
		self:FrameAdvance()
		return
	end
	
	/*if self.IsFrozen and !self:IsFrozen() then
		
		local newact = self:CalcMainActivity( self.loco:GetVelocity() )

		if self:GetActivity() ~= newact then
			self:StartActivity( newact )	
		end
		
		self:BodyMoveXY()
	else
		if self.Knockdown and IsValid(self.Knockdown) then
			if self.Knockdown:GetSkin() == 1 then
				self:SetSequence("zombie_slump_idle_02")//pl:LookupSequence("zombie_slump_rise_02_slow")
			else
				self:SetSequence("zombie_slump_idle_01")
			end
			
			self:FrameAdvance()
			return
		end	
	end*/
	
	if self.Knockdown and IsValid(self.Knockdown) then
		
		if self.Knockdown:GetSkin() == 1 then
			if self.Knockdown:ShouldRecover() then
				self:ResetSequence("zombie_slump_rise_02_fast")
				self:SetCycle( self.Knockdown:GetRecoveryCycle() )
			else
				self:ResetSequence("zombie_slump_idle_02")
				self:SetCycle( 0 )
			end
		else
			if self.Knockdown:ShouldRecover() then
				self:ResetSequence("zombie_slump_rise_01")
				self:SetCycle( self.Knockdown:GetRecoveryCycle() )
			else
				self:ResetSequence("zombie_slump_idle_01")
				self:SetCycle( 0 )
			end
		end
		
		return
	else
		local newact = self:CalcMainActivity( self.loco:GetVelocity() )

		local knockdown_anim = self:LookupSequence("zombie_slump_rise_02_slow")
		
		if self:GetActivity() ~= newact or self:GetSequence() == knockdown_anim then
			self:StartActivity( newact )	
		end
		
		self:BodyMoveXY()
	end	
	
	self.NextIdleAnim = self.NextIdleAnim or 0
	if self.IdleAnim and not self.IdleAnimDuration then
		local _, time = self:LookupSequence( self.IdleAnim )
		if time then
			self.IdleAnimDuration = time * 1
		end
	end
	
	if ( IsValid( self.Target ) or IsValid( self.Knockdown ) ) and self.IdleAnim then
		self.NextIdleAnim = 0
	end
	
	if self:GetBehaviour() == BEHAVIOUR_DUMB and !self:IsFrozen() and self.IdleAnim and self.IdleAnimDuration then// or CUR_DIALOGUE and self:GetBehaviour() == BEHAVIOUR_IDLE and self.IdleAnim then
		
		if self.NextIdleAnim < CurTime() then
			self.NextIdleAnim = CurTime() + self.IdleAnimDuration
		end
		
		local cycle = math.Clamp( 1 - ( self.NextIdleAnim - CurTime() ) / math.max( self.IdleAnimDuration, 0.2 ), 0, 1 )
				
		self:SetSequence( self.IdleAnim )
		self:SetCycle( cycle )
		
		/*if self.NextIdleAnim <= CurTime() then			
			if not self.FirstAnim then
				self:SetSequence( self.IdleAnim )
				self.FirstAnim = true
			else
				//self:ResetSequence( self.IdleAnim )
				self:SetSequence( self.IdleAnim )
				//self:SetCycle( 0 )
			end
			self.NextIdleAnim = CurTime() + self.IdleAnimDuration
		end*/
	end
	

	
	if self.IdleAnim and self.loco:GetVelocity():Length2D() <= 1 and !IsValid( self.Knockdown ) and !IsValid( self.Target ) and self.IdleAnimDuration then 
		
		if self.NextIdleAnim < CurTime() then
			self.NextIdleAnim = CurTime() + self.IdleAnimDuration
		end
		
		local cycle = math.Clamp( 1 - ( self.NextIdleAnim - CurTime() ) / math.max( self.IdleAnimDuration, 0.2 ), 0, 1 )
				
		self:SetSequence( self.IdleAnim )
		self:SetCycle( cycle )
		
		/*if self.NextIdleAnim <= CurTime() then
			if not self.FirstAnim then
				self:SetSequence( self.IdleAnim )
				self.FirstAnim = true
			else
				self:ResetSequence( self.IdleAnim )
			end
			self.NextIdleAnim = CurTime() + self.IdleAnimDuration
		end*/
	end

	if self:GetCharTable() and self:GetCharTable().OnBodyUpdate then
		self:GetCharTable():OnBodyUpdate( self )
	end
	
	self:FrameAdvance()
	
end

function ENT:CalcMainActivity( velocity )	

	self.CalcIdeal = ACT_MP_STAND_IDLE

	
	local len2d = velocity:Length2DSqr()
	if ( len2d > 28900 ) then
		self.CalcIdeal = ACT_MP_RUN
	elseif ( len2d > 0.5 ) then
		self.CalcIdeal = ACT_MP_WALK
	end
	
	if not self.loco:IsOnGround() then
		self.CalcIdeal = ACT_MP_JUMP
	end

	//print(len2d)
	//print(self.CalcIdeal)
	
	return self:TranslateActivity( self.CalcIdeal )

end

local IdleActivity = ACT_HL2MP_IDLE
local IdleActivityTranslate = {}
IdleActivityTranslate [ ACT_MP_STAND_IDLE ] = IdleActivity
IdleActivityTranslate [ ACT_MP_WALK ] = IdleActivity+1
IdleActivityTranslate [ ACT_MP_RUN ] = IdleActivity+2
IdleActivityTranslate [ ACT_MP_CROUCH_IDLE ] = IdleActivity+3
IdleActivityTranslate [ ACT_MP_CROUCHWALK ] = IdleActivity+4
IdleActivityTranslate [ ACT_MP_ATTACK_STAND_PRIMARYFIRE ] = IdleActivity+5
IdleActivityTranslate [ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ]	= IdleActivity+5
IdleActivityTranslate [ ACT_MP_RELOAD_STAND ]	= IdleActivity+6
IdleActivityTranslate [ ACT_MP_RELOAD_CROUCH ]	= IdleActivity+6
IdleActivityTranslate [ ACT_MP_JUMP ] = ACT_HL2MP_JUMP_SLAM
IdleActivityTranslate [ ACT_MP_SWIM_IDLE ] = ACT_MP_SWIM_IDLE
IdleActivityTranslate [ ACT_MP_SWIM ] = ACT_MP_SWIM
IdleActivityTranslate [ ACT_LAND ] = ACT_LAND

function ENT:TranslateActivity( act )

	local newact = self:TranslateWeaponActivity( act )

	
	if ( act == newact ) then
		return IdleActivityTranslate[ act ]
	end

	//print(act.."    "..newact)
	
	return newact

end

function ENT:TranslateWeaponActivity(act)
	
	//just so i dont have to make 4000 same weapons but with different anims
	if self:GetCharTable() and self:GetCharTable().TranslateActivity then
		return self:GetCharTable():TranslateActivity( self, act )
	end
	
	if self.Weapon and self.Weapon:IsValid() and self.Weapon.TranslateActivity then
		return self.Weapon:TranslateActivity(act)
	end
	return act
end

function ENT:Ping()
	return 0
end

if SERVER then

	function ENT:AcceptInput(name, activator, caller, args)
		name = string.lower(name)
		if name == "bleedout" and self.Bleeding and self.BleedingDmgInfo then
			self.BleedingDmgInfo:SetDamageForce( vector_origin )
			self.BleedingDmgInfo:SetAttacker( self.Bleeding )
			self.BleedingDmgInfo:SetInflictor( self.Bleeding )
			self.BleedingDmgInfo:SetDamage( 999999 )
			self.DeathSequence = { Anim = "death_04", Speed = math.Rand(1, 1.2) }
			self:TakeDamageInfo( self.BleedingDmgInfo )
		end
	end

	function ENT:UpdateTransmitState()
		if self:GetCharTable().TransmitState then
			return self:GetCharTable().TransmitState
		end
		return TRANSMIT_PVS
	end


	hook.Add("PlayerCanPickupWeapon", "BotWeapons", function(ply,wep)
		if wep.GetOwner and wep:GetOwner():IsValid() and wep:GetOwner().NextBot then
			return false
		end
	end)
end

local thug_bones = {
	["ValveBiped.Bip01_Spine2"] = { scale = Vector(2.131, 2.121, 2.131), pos = Vector(2.335, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Foot"] = { scale = Vector(1.299, 1.299, 1.299), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Clavicle"] = { scale = Vector(1.631, 1.631, 1.631), pos = Vector(0, 0, 6.666), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger01"] = { scale = Vector(1.824, 1.824, 1.824), pos = Vector(0.984, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Finger01"] = { scale = Vector(1.824, 1.824, 1.824), pos = Vector(0.984, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger22"] = { scale = Vector(1.751, 1.751, 1.751), pos = Vector(0.017, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Finger22"] = { scale = Vector(1.751, 1.751, 1.751), pos = Vector(0.017, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_Spine"] = { scale = Vector(1.651, 1.651, 1.651), pos = Vector(0, 2.019, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Bicep"] = { scale = Vector(2.104, 2.104, 2.104), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger21"] = { scale = Vector(1.506, 1.506, 1.506), pos = Vector(0.347, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Finger21"] = { scale = Vector(1.506, 1.506, 1.506), pos = Vector(0.347, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Forearm"] = { scale = Vector(1.516, 1.516, 1.516), pos = Vector(4.809, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_Spine1"] = { scale = Vector(1.623, 1.68, 1.623), pos = Vector(3.536, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger12"] = { scale = Vector(1.822, 1.822, 1.822), pos = Vector(0.393, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Finger12"] = { scale = Vector(1.822, 1.822, 1.822), pos = Vector(0.393, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Ulna"] = { scale = Vector(2.066, 2.066, 2.066), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Thigh"] = { scale = Vector(1.269, 1.269, 1.269), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger11"] = { scale = Vector(2.273, 2.273, 2.273), pos = Vector(0.105, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Finger11"] = { scale = Vector(2.273, 2.273, 2.273), pos = Vector(0.105, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Toe0"] = { scale = Vector(1.401, 1.401, 1.401), pos = Vector(2.759, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Ulna"] = { scale = Vector(2.039, 2.039, 2.039), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Foot"] = { scale = Vector(1.245, 1.245, 1.245), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_UpperArm"] = { scale = Vector(1.575, 1.575, 1.575), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Calf"] = { scale = Vector(1.213, 1.213, 1.213), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Thigh"] = { scale = Vector(1.302, 1.302, 1.302), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger02"] = { scale = Vector(1.965, 1.965, 1.965), pos = Vector(0.845, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Finger02"] = { scale = Vector(1.965, 1.965, 1.965), pos = Vector(0.845, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Hand"] = { scale = Vector(1.562, 1.562, 1.562), pos = Vector(1.373, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Calf"] = { scale = Vector(1.273, 1.273, 1.273), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger1"] = { scale = Vector(1.805, 1.805, 1.805), pos = Vector(1.605, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Finger1"] = { scale = Vector(1.805, 1.805, 1.805), pos = Vector(1.605, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Toe0"] = { scale = Vector(1.376, 1.376, 1.376), pos = Vector(2.434, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_Pelvis"] = { scale = Vector(1.263, 1.215, 1.225), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Clavicle"] = { scale = Vector(1.621, 1.621, 1.621), pos = Vector(0, 0, -5.229), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Forearm"] = { scale = Vector(1.083, 1.083, 1.083), pos = Vector(4.308, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Bicep"] = { scale = Vector(2.104, 2.104, 2.104), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Hand"] = { scale = Vector(1.57, 1.57, 1.57), pos = Vector(0.398, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger2"] = { scale = Vector(1.506, 1.506, 1.506), pos = Vector(1.549, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Finger2"] = { scale = Vector(1.506, 1.506, 1.506), pos = Vector(1.549, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_Spine4"] = { scale = Vector(1.447, 1.447, 1.447), pos = Vector(3.171, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_UpperArm"] = { scale = Vector(1.753, 1.753, 1.753), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_R_Finger0"] = { scale = Vector(1.83, 1.83, 1.83), pos = Vector(1.212, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Bip01_L_Finger0"] = { scale = Vector(1.83, 1.83, 1.83), pos = Vector(1.212, 0, 0), angle = Angle(0, 0, 0) }
}

function ENT:SetThug()
	
	for k, v in pairs( thug_bones ) do
		local bone = self:LookupBone(k)
		if (!bone) then continue end
		self:ManipulateBoneScale( bone, v.scale  )
		self:ManipulateBoneAngles( bone, v.angle  )
		self:ManipulateBonePosition( bone, v.pos  )
	end
	
end

if CLIENT then

	ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
	
	local zero_vec = Vector( 0, 0, 0 )
	local zero_ang = Angle( 0, 0, 0 )
	
	ENT.wRenderOrder = nil
	function ENT:SCK_DrawWorldModel()
		
		local owner = self
		if !IsValid(owner) then return end
		
		if (!self.WElements) then return end
		
		if (!self.wRenderOrder) then

			self.wRenderOrder = {}

			for k, v in pairs( self.WElements ) do
				if (v.type == "Model") then
					table.insert(self.wRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.wRenderOrder, k)
				end
			end
			
			//its shitty but hey, I need clipplanes on top
			for k, v in pairs( self.WElements ) do
				if (v.type == "ClipPlane") then
					table.insert(self.wRenderOrder, 1, k)
				end
			end

		end
		
		bone_ent = self.GetRagdollEntity and IsValid( self:GetRagdollEntity() ) and self:GetRagdollEntity() or self
		if !IsValid(bone_ent) then return end
		
		for i = 1, #self.wRenderOrder do
			
			local name = self.wRenderOrder[ i ]
			local v = self.WElements[name]
			if (!v) then self.wRenderOrder = nil break end
			
			local pos, ang
			
			if (v.bone) then
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent )
			else
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent, "ValveBiped.Bip01_R_Hand" )
			end
			
			if (!pos) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			
			if (v.type == "Model" and IsValid(model)) then

				if v.seq then
					model:FrameAdvance( (RealTime()-(model.LastPaint or 0)) * 1 )	
				end
				
				if v.seq_pb then
					model:SetPlaybackRate( v.seq_pb )
				end
			
				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )

				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				

				local size = (v.size.x + v.size.y + v.size.z)/3
				model:SetAngles(ang)

				if v.fix_scale then
					local matrix = Matrix()
					matrix:Scale(v.size)
					model:EnableMatrix( "RenderMultiply", matrix )
				else
					if model:GetModelScale() ~= size then
						model:SetModelScale(size,0)
					end
				end

				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				
								
				if v.bonemerge then
					model:AddEffects( EF_BONEMERGE )
				end
				
				//model:SetupBones()

				
				if model.clipplane_pos and model.clipplane_ang then				
					local clip_pos, clip_ang = model.clipplane_pos, model.clipplane_ang
				
					render.EnableClipping( true )
					render.PushCustomClipPlane( clip_ang:Up(), clip_ang:Up():Dot( clip_pos ) )
				end
						
				
				model:DrawModel()
				
				if model.clipplane_pos and model.clipplane_ang then
					render.PopCustomClipPlane()
					render.EnableClipping( false )
				end
				
				if v.bonemerge then
					model:RemoveEffects( EF_BONEMERGE )
				end				
				
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
				if v.seq then
					model.LastPaint = RealTime()
				end
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()
				
			elseif (v.type == "ClipPlane" and v.rel) then
				
				local mdl = self.WElements[ v.rel ] and IsValid( self.WElements[ v.rel ].modelEnt ) and self.WElements[ v.rel ].modelEnt
				
				if mdl then//and not mdl.clipplane then
					
					local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
					ang:RotateAroundAxis(ang:Up(), v.angle.y)
					ang:RotateAroundAxis(ang:Right(), v.angle.p)
					ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
					mdl.clipplane_pos = drawpos//{ pos = drawpos, ang = ang }
					mdl.clipplane_ang = ang
				
				end

			end
			
		end
		
	end

	function ENT:GetBoneOrientation( basetab, tab, ent, bone_override )
		
		local bone, pos, ang
		if (tab.rel and tab.rel != "") then
			
			local v = basetab[tab.rel]
			
			if (!v) then return end

			pos, ang = self:GetBoneOrientation( basetab, v, ent )
			
			if (!pos) then return end
			
			pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
		else
		
			if tab.cached_bone then
				bone = tab.cached_bone
			else
				bone = ent:LookupBone(bone_override or tab.bone)
				tab.cached_bone = bone
			end

			if (!bone) then return end
			
			pos, ang = zero_vec, zero_ang//Vector(0,0,0), Angle(0,0,0)
			local m = ent:GetBoneMatrix(bone)
			if (m) then
				pos, ang = m:GetTranslation(), m:GetAngles()
			end
		
		end
		
		return pos, ang
	end

	function ENT:CreateModels( tab )

		if (!tab) then return end

		// Create the clientside models here because Garry says we can't do it in the render hook
		for k, v in pairs( tab ) do
			if (v.type == "Model" and v.model and v.model != "" and (!IsValid(v.modelEnt) or v.createdModel != v.model) and 
					string.find(v.model, ".mdl") and file.Exists (v.model,"GAME") ) then
				
				v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)
				if (IsValid(v.modelEnt)) then
					v.modelEnt:SetPos(self:GetPos())
					v.modelEnt:SetAngles(self:GetAngles())
					v.modelEnt:SetParent(self)
					v.modelEnt:SetNoDraw(true)
					v.modelEnt:DrawShadow( false )
					v.createdModel = v.model
					
					if v.bbp then
						v.modelEnt:AddCallback("BuildBonePositions", v.bbp )
					end
					
					if v.seq then
						v.modelEnt:SetSequence( v.modelEnt:LookupSequence( v.seq ) )
						v.modelEnt.LastPaint = 0
					end
					
					if v.sub_mat then
						for ind, mat in pairs( v.sub_mat ) do
							v.modelEnt:SetSubMaterial( ind, mat )
						end
					end
					
				else
					v.modelEnt = nil
				end
				
			elseif (v.type == "Sprite" and v.sprite and v.sprite != "" and (!v.spriteMaterial or v.createdSprite != v.sprite) 
				and file.Exists ("materials/"..v.sprite..".vmt","GAME")) then
				
				local name = v.sprite.."-"
				local params = { ["$basetexture"] = v.sprite }
				// make sure we create a unique name based on the selected options
				local tocheck = { "nocull", "additive", "vertexalpha", "vertexcolor", "ignorez" }
				for i, j in pairs( tocheck ) do
					if (v[j]) then
						params["$"..j] = 1
						name = name.."1"
					else
						name = name.."0"
					end
				end

				v.createdSprite = v.sprite
				v.spriteMaterial = CreateMaterial(name,"UnlitGeneric",params)
				
			end
		end
		
	end


	function ENT:RemoveModels()
		if (self.WElements) then
			for k, v in pairs( self.WElements ) do
				if (IsValid( v.modelEnt )) then v.modelEnt:Remove() end
			end
		end
		self.WElements = nil
	end
	
	function ENT:Draw()
	
		local draw_model = true 
		
		if self:GetCharTable().OnDraw then
			self:GetCharTable():OnDraw( self )
		end
		
		if self:GetCharTable().HideOriginalModel or self.HideModel then
			draw_model = false
		end
		
		if not self.FireEffect and self:GetMaterial() == "models/charple/charple1_sheet" then
			self.FireEffect = true
			ParticleEffectAttach( "env_fire_medium", PATTACH_ABSORIGIN_FOLLOW, self, 0 )
		end
		
		if draw_model then
			if self:GetCharTable().OverrideMaterial then render.MaterialOverride( self:GetCharTable().OverrideMaterial ) end
			if self:GetCharTable().OverrideColor then 
				render.SetColorModulation( self:GetCharTable().OverrideColor.r/255, self:GetCharTable().OverrideColor.g/255, self:GetCharTable().OverrideColor.b/255 ) 
			end
			self:DrawModel()
			if self:GetCharTable().OverrideColor then 
				render.SetColorModulation( 1, 1, 1 ) 
			end
			if self:GetCharTable().OverrideMaterial then render.MaterialOverride() end

		end
		
		self:SCK_DrawWorldModel()
		
		if self:GetCharTable().PostDraw then
			self:GetCharTable():PostDraw( self )
		end
		
		if self:IsBleeding() then
			self.NextBleed = self.NextBleed or 0
			if self.NextBleed < CurTime() then
				local e = EffectData()
					e:SetOrigin( self:GetShootPos() )
					e:SetNormal( vector_up * -1 + VectorRand() * 0.8 )
					e:SetStart( VectorRand() * 6 )
					e:SetMagnitude( math.random(5,7) )
					e:SetScale( math.random(100,200) )
					e:SetRadius( 0 )
				util.Effect( "blood_spray", e, nil, true )
				self.NextBleed = CurTime() + 0.1
			end
		end
	end

end