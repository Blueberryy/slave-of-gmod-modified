//Pretty much a mix of some some stuff with physical bullets from Awesome Strike.
AddCSLuaFile()

ENT.Type = "anim"
ENT.RenderGroup 		= RENDERGROUP_BOTH

ENT.LoudnessRadius = 320

util.PrecacheModel("models/Weapons/w_bullet.mdl")
util.PrecacheModel("models/Items/CrossbowRounds.mdl")

local bulletmins = Vector(-0.75, -0.75, -0.75)
local bulletmaxs = Vector(0.75, 0.75, 0.75)
local bullettrace = { mask = MASK_SHOT, mins = bulletmins, maxs = bulletmaxs }
function BulletTrace(startposition, endposition, filter)
	
	bullettrace.start = startposition
	bullettrace.endpos = endposition
	bullettrace.filter = filter
	
	return util.TraceHull( bullettrace )

	//local tr = util.TraceHull({start = startposition, endpos = endposition, mask = MASK_SHOT, filter = filter, mins = bulletmins, maxs = bulletmaxs})
	//return tr
end

if SERVER then
local pairs = pairs
function ENT:Initialize()

	/*if self.CanPenetrate then
		//this is the stupidest workaround I've ever done so far
		self:SetModel("models/Items/CrossbowRounds.mdl")
		self:SetTrigger( true )
		self:PhysicsInitSphere(1)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_PUSHAWAY)
		self.Touched = {}
	else*/	
		self:SetModel("models/Weapons/w_bullet.mdl")
		self:PhysicsInitSphere(1)
		self:SetSolid(SOLID_NONE)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
	//end
		
	if self.CanPenetrate then
		self.Touched = {}
	end

	self.DamageMultiplier = 1
	
	self:DrawShadow(false)

	local inflictor = self:GetOwner() and self:GetOwner():GetActiveWeapon()
	
	if inflictor and inflictor.Silenced or self:GetOwner() and self:GetOwner().GetCharTable and self:GetOwner():GetCharTable().SilencedShots then
		self.Silenced = true
	end
	
	if inflictor and inflictor.Akimbo then
		self.LoudnessRadius = self.LoudnessRadius * 2
	end
	
	if inflictor and inflictor.IsLoud then
		self.LoudnessRadius = self.LoudnessRadius * 2
	end
	
	//self:SetCollisionBounds(Vector(-1,-1,-1),Vector(1,1,1))
	
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then 
		phys:EnableDrag(false)
		phys:EnableGravity(false)
		phys:SetBuoyancyRatio(0.00001)
		phys:Wake()
		
		phys:AddGameFlag( FVPHYSICS_WAS_THROWN )
	end
	
	self.StartPos = self:GetPos()
	self.LastPosition = self:GetPos()

	self:Fire("Kill","",3)
	
	local checkowner = self:GetOwner() and self:GetOwner():IsNextBot() and IsValid(self:GetOwner():GetOwner()) and self:GetOwner():GetOwner()
	
	if checkowner and checkowner:IsValid() then
		self:SetOwner(checkowner)
	end
	
	local owner = self:GetOwner()
	
	if owner and owner:IsValid() and owner:IsPlayer() and !self.Silenced then
		//how about we try to minimize the loops?
		
		for tm, team_tbl in pairs( NEXTBOTS_TEAM ) do
			if tm == TEAM_DM or tm ~= owner:Team() then
				for k, bot in pairs( team_tbl ) do
					if bot and bot:IsValid() and bot:Alive() and owner:GetShootPos():DistToSqr( bot:GetShootPos() ) <= self.LoudnessRadius * self.LoudnessRadius and bot:GetBehaviour() ~= BEHAVIOUR_IDLE 
					and bot:GetBehaviour() ~= BEHAVIOUR_DUMB and !bot.Target and ( ( bot.NextBulletReact or 0 ) < CurTime() ) then
						bot:StopAllPaths( 10 )
						bot.NextBulletReact = CurTime() + 3
						bot.NextIdle = CurTime() + 3
						bot.CheckPosition = owner:GetShootPos()
					end
				end
			end
		end
		
		
		/*for k, v in pairs( NEXTBOTS ) do
			if v and v:IsValid() and v:Alive() and owner:GetShootPos():Distance( v:GetShootPos() ) <= self.LoudnessRadius and v:GetBehaviour() ~= BEHAVIOUR_IDLE then
				if ( v:Team() == TEAM_DM or v:Team() ~= owner:Team() ) and !v.Target and (v.NextBulletReact or 0 < CurTime() ) then
					v:StopAllPaths( 10 )
					v.NextBulletReact = CurTime() + 3
					v.NextIdle = CurTime() + 3
					v.CheckPosition = owner:GetShootPos()
				end
			end
		end*/
	end
	
	if SUPERHOT and game.GetTimeScale() < 1 then
		local scale = self:GetOwner() and self:GetOwner().GetCharTable and self:GetOwner():GetCharTable().BulletScale or 1
		local size = 5 * scale
		util.SpriteTrail( self, 0, color_white, true, size, 0, 0.05, 1/(size+0)*0.5, "trails/tube")
		self.HasTrail = true
	end
	
	self:NextThink(CurTime())
	
end

function ENT:CheckTrace(tr)

	local remove = true
	local bulletdamage = true
	
	local hitent = tr.Entity
	
	if self.Hit then return end
	
	if hitent and hitent:IsValid() and hitent.IsBuddy then return end
	if hitent and hitent:IsValid() and hitent:GetClass() == "dropped_weapon" then return end
	if hitent and IsValid(hitent.Knockdown) then return end
	if hitent and IsValid( hitent.Roll ) then return end
	if self:GetOwner() and self:GetOwner().Bodyguard and hitent.Bodyguard then return end
	if self:GetOwner() and hitent.Bodyguard and hitent:GetOwner() == self:GetOwner() then return end
	if self:GetOwner() and self:GetOwner().Team and hitent and hitent.Team and self:GetOwner():Team() == hitent:Team() and hitent:Team() ~= TEAM_DM then return end
	if self.CanPenetrate and self.Touched and hitent:IsValid() and self.Touched[ tostring(hitent) ] then return end
	
	if hitent:IsValid() then
			
			if hitent:GetClass() == "func_breakable_surf" then
				hitent:Fire("break", "", 0)
			else
			
				if hitent.IsCharging and hitent:IsCharging() then
					self.DamageMultiplier = 0.5
				end
			
				local dmginfo = DamageInfo()
				dmginfo:SetDamagePosition(tr.HitPos)
				dmginfo:SetDamage(self.Damage * self.DamageMultiplier or 50)
				local attacker = self.Entity
				
				if self:GetOwner() and self:GetOwner():IsValid() then
					if self:GetOwner().IsNextBot and self:GetOwner():IsNextBot() and IsValid(self:GetOwner():GetOwner()) then
						attacker = self:GetOwner():GetOwner()
					else
						attacker = self:GetOwner()
					end
				end
				
				dmginfo:SetAttacker( attacker or self.Entity )
				if self.Inflictor and IsValid(self.Inflictor) then
					dmginfo:SetInflictor(self.Inflictor)
				end
				dmginfo:SetDamageType( self.DamageType or DMG_BULLET )
				//dmginfo:SetDamageForce((self.Damage * self.Force * self:GetAngles():Forward() * ( hitent:IsPlayer() and hitent:GetCharTable().BulletForceMultiplier or 1 ))* 0.1)
				dmginfo:SetDamageForce((45 * self.Force * self:GetAngles():Forward() * ( hitent:IsPlayer() and hitent:GetCharTable().BulletForceMultiplier or 1 ))* 0.1)

				if hitent:IsPlayer() or hitent.NextBot then
					
					if self.CanPenetrate then
						self.Touched[ tostring(hitent) ] = true
						remove = false
					end
						
					if hitent:GetCharTable().OnBulletHit then
						bulletdamage = hitent:GetCharTable():OnBulletHit( hitent, tr.HitPos, tr.HitNormal, (tr.HitPos - self.LastPosition):GetNormal(), dmginfo, self.Entity )
					end
					
					//now with weapon's flavour
					local wep = hitent:GetActiveWeapon() and hitent:GetActiveWeapon():IsValid() and hitent:GetActiveWeapon()
					if wep and wep.OnBulletHit then
						bulletdamage = wep:OnBulletHit( hitent, tr.HitPos, tr.HitNormal, (tr.HitPos - self.LastPosition):GetNormal(), dmginfo, self.Entity )
					end
					
					if bulletdamage then
						if not hitent:GetCharTable().NoBulletHits then
							if game.GetMap() ~= "sog_deathloop_v7" then
								GAMEMODE:DoBloodSpray( tr.HitPos, tr.HitNormal, VectorRand() * 4 , math.random(3,5) * ( self.Damage / 50 ), math.random( 100, 400 ) + 60 * ( self.Damage / 50 ), hitent:GetCharTable().Horse and 2 or hitent:GetCharTable().YellowBlood )
								GAMEMODE:DoBloodSpray( tr.HitPos, tr.HitNormal*-1, VectorRand() * 4 , math.random(3,4) * ( self.Damage / 50 ), math.random( 0, 200 ) + 10 * ( self.Damage / 50 ), hitent:GetCharTable().Horse and 2 or hitent:GetCharTable().YellowBlood )
							end
							hitent:EmitSound("Flesh.BulletImpact")
						end
						//util.Decal("Blood", tr.HitPos - (tr.HitPos - self.LastPosition):GetNormal() * 10, tr.HitPos + (tr.HitPos - self.StartPos):GetNormal() * 10)
	
					end
					
				elseif hitent:IsNPC() then
					hitent:EmitSound("Flesh.BulletImpact")
				end
				if !IsValid(hitent.Knockdown) and bulletdamage then
					hitent:TakeDamageInfo(dmginfo)
				end

				local phys = hitent:GetPhysicsObject()
				if hitent:GetMoveType() == MOVETYPE_VPHYSICS and phys:IsValid() and phys:IsMoveable() then
					hitent:SetPhysicsAttacker(self:GetOwner())
				end
			end

	end

	if remove then
		self.Hit = true
		if bulletdamage then
			self:FakeBullet(self.LastPosition, (tr.HitPos - self.LastPosition):GetNormal())
		end
		self.LastPosition = self:GetPos()
		//self:SetMoveType( MOVETYPE_NONE )
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then 
			phys:EnableMotion( false )
		end
		self:Remove()
	else
		self.LastPosition = self:GetPos()
		self:NextThink(CurTime())
	end
	return true
end

function ENT:Think()

	local pos = self:GetPos()
	
	if SUPERHOT and game.GetTimeScale() < 1 and not self.HasTrail then
		local scale = self:GetOwner() and self:GetOwner().GetCharTable and self:GetOwner():GetCharTable().BulletScale or 1
		local size = 5 * scale
		util.SpriteTrail( self, 0, color_white, true, size, 0, 0.05, 1/(size+0)*0.5, "trails/tube")
		self.HasTrail = true
	end
	
	if self.Cursed and not self.HasTrail then
		local start_length = 10
		local end_length = 0

		util.SpriteTrail( self, 0, Color( 20, 20, 20, math.random( 230, 250 ) ), true, start_length, end_length, 0.08, 1 / ( start_length + end_length ) * 0.5, "Effects/bloodstream.vmt")
		//util.SpriteTrail( self, 0, color_white, true, start_length, end_length, 0.05, 1/( start_length + end_length ) * 0.5, "trails/tube")
		self.HasTrail = true
	end
	
	//if !self.CanPenetrate then
		local tr = BulletTrace(self.LastPosition, pos, self:GetOwner())

		if not (tr.Hit and self:CheckTrace(tr)) then
			self.LastPosition = pos
		end
	/*else
		if self.PhysicsData and not self.Hit then
			self.Hit = true
			//self:SetMoveType( MOVETYPE_NONE )
			local phys = self:GetPhysicsObject()
			if phys:IsValid() then 
				phys:EnableMotion( false )
			end
			self:Remove()
			//self:Fire("Kill","",0.1)
		end
	end*/

	self:NextThink(CurTime())
	return true
end

function ENT:PhysicsCollide(data, phys)
	/*if self.CanPenetrate then
		self:FakeBullet(self.StartPos, (data.HitPos - self.StartPos):GetNormal())
		self.PhysicsData = data
	end
	self:NextThink(CurTime())*/
end

function ENT:StartTouch( ent )
	if !self.CanPenetrate then return end
	if IsValid( ent ) and (ent:IsPlayer() or ent:IsNextBot()) and ent ~= self:GetOwner() and !ent.IsBuddy and ent:GetClass() ~= "dropped_weapon" and !IsValid(ent.Knockdown) and !IsValid( ent.Roll ) and (ent.Team and self:GetOwner().Team and ( ent:Team() ~= self:GetOwner():Team() or ent:Team() == TEAM_DM)) then
		if self.Touched[ tostring(ent) ] then return end
		local bulletdamage = true
		
		if ent.IsCharging and ent:IsCharging() then
			self.DamageMultiplier = 0.5
		end
		
		local dmginfo = DamageInfo()
		dmginfo:SetDamagePosition(self:GetPos())
		dmginfo:SetDamage(self.Damage * self.DamageMultiplier or 50)
		dmginfo:SetAttacker(self:GetOwner() and self:GetOwner():IsNextBot() and IsValid(self:GetOwner():GetOwner()) and self:GetOwner():GetOwner() or self:GetOwner())
		if self.Inflictor and IsValid(self.Inflictor) then
			dmginfo:SetInflictor(self.Inflictor)
		end
		dmginfo:SetDamageType( self.DamageType or DMG_BULLET )
		dmginfo:SetDamageForce(7 * self:GetVelocityLength() * (self:GetPos() - self.StartPos):GetNormal())
		
		if ent:GetCharTable().OnBulletHit then
			bulletdamage = ent:GetCharTable():OnBulletHit( ent, self:GetPos(), (self.StartPos - self:GetPos()):GetNormal(), (self.StartPos - self:GetPos()):GetNormal()*-1, dmginfo, self.Entity )
		end
		
		if not bulletdamage then
			self:SetMoveType( MOVETYPE_NONE )
			self:Remove()
			return
		end
		
		if ent:IsPlayer() or ent:IsNextBot() then
			GAMEMODE:DoBloodSpray( self:GetPos(), (self.StartPos - self:GetPos()):GetNormal(), VectorRand() * 5 , math.random(3,5) * ( self.Damage / 50 ), math.random( 100, 400 ) + 60 * ( self.Damage / 50 ) )
			GAMEMODE:DoBloodSpray( self:GetPos(), (self.StartPos - self:GetPos()):GetNormal()*-1, VectorRand() * 5 , math.random(3,4) * ( self.Damage / 50 ), math.random( 0, 200 ) + 10 * ( self.Damage / 50 ) )
			ent:EmitSound("Flesh.BulletImpact")
			//util.Decal("Blood", self:GetPos() - (self:GetPos() - self.StartPos):GetNormal() * 10, self:GetPos() + (self:GetPos() - self.StartPos):GetNormal() * 10)
		end
		
		self:FakeBullet(self.StartPos, (self.StartPos - self:GetPos()):GetNormal())
		
		
		if !IsValid(ent.Knockdown) then
			ent:TakeDamageInfo(dmginfo)
		end
		
		self.Touched[ tostring(ent) ] = true
	end
	
end

local nodamage = {damage = false, effects = true}
local function BulletCallback(attacker, tr, dmginfo) 
	if tr.Entity and tr.Entity:IsPlayer() then
		//util.Decal("Blood", tr.HitPos + tr.HitNormal * 10, tr.HitPos - tr.HitNormal * 10)
	end
	return nodamage 
end
local fakebullet = {Num = 1, Tracer = 0, Force = 0, Damage = 0, Spread = Vector(0, 0, 0), Callback = BulletCallback}
function ENT:FakeBullet(src, dir)
	fakebullet.Src = src
	fakebullet.Dir = dir
	fakebullet.Filter = self:GetOwner() or self
	self:FireBullets(fakebullet)
end

function ENT:Penetrating( bl )
	self.CanPenetrate = bl
end


end

if CLIENT then

function ENT:Think()
	self:SetNextClientThink(CurTime())
	return true
end

local matBeam = Material("effects/spark")
local matBeam2 = Material( "effects/bloodstream" )
local matGlow = Material("sprites/glow04_noz")
local mins = Vector(-318, -318, -318)
local maxs = Vector(318, 318, 318)
local col_white = color_white
local col_trail = Color(250, 200,0,255)
function ENT:Initialize()

	self:SetModel("models/Weapons/w_bullet.mdl")
	
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)

	self:SetModelScale(1.3,0)
	self:DrawShadow(false)
	self:SetRenderBounds( mins, maxs )
	
	self:SetColor(col_trail)
	
	self:NextThink( CurTime() ) 
end


function ENT:Draw()
	self:SetModel("models/Weapons/w_bullet.mdl")
		
	local vel = self:GetVelocity()
	if vel ~= vector_origin then
		self:SetAngles(vel:Angle())
	end
	
	//self:DrawModel()
	
	local scale = self:GetOwner() and self:GetOwner().GetCharTable and self:GetOwner():GetCharTable().BulletScale or 1
	
	local pos = self:GetPos()+vector_up*0.8
	
	local sz = 10 * scale
	local sz2 = 4 * scale
	
	
	local endpos = pos - self:GetAngles():Forward() * math.max(self:GetVelocityLength()/1700 * 10, 15) * scale
	render.SetMaterial(matBeam)
	render.DrawBeam(pos, endpos - self:GetAngles():Forward() * sz, sz2, 1, 0, col_white)
	render.DrawBeam(pos, endpos, sz, 1, 0, col_trail)
		

	end
end

