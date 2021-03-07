local trace = { mask = MASK_SOLID }
local mat_decal = Material( "Decals/bloodstain_002" )

function EFFECT:Init( data )
	
	local add_ang = math.Round( data:GetRadius() )
	
	local duration = 6
	
	self.Entity:SetModel( "models/zombie/fast.mdl" )
	//self.Entity:SetAngles( Angle( 0, math.random(-90, 90), 0 ) )
	self.Entity:SetAngles( Angle( 0, 0, 0 ) )
	self.SaveAng = self.Entity:GetAngles()
	//self.Entity:SetAngles( Angle( 0, 0, 90 ) )
	//self.Entity:SetSequence( "FireWalk" )
	local id, dur = self.Entity:LookupSequence( "ragdoll" )
	self.Entity:SetSequence( "ragdoll" )
	self.Entity:SetCycle( dur )
	self.Entity:SetModelScale( 15, 0 )
	
	self.Entity:SetLOD( 0 )
	
	trace.start = data:GetOrigin()
	trace.endpos = trace.start - vector_up * 20
	trace.filter = self.Entity
	
	local tr = util.TraceLine( trace )
	
	local col = Vector( 1, 1, 1 )
	
	if tr.Hit and tr.HitWorld then
		//util.DecalEx( mat_decal, Entity(0), tr.HitPos, tr.HitNormal, color_white, 800, 800 )
		util.Decal( "BloodHuge"..math.random(1,2), tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal )
		col = render.ComputeLighting( tr.HitPos, tr.HitNormal ) 
	end
	
	self.Spin = math.random(-90,90)
	self.CurSpin = self.Spin - math.random( -40, 40 )
		
	local bone = self:LookupBone( "ValveBiped.Bip01_L_UpperArm" )
	for i=1, 2 do
		//self.Entity:ManipulateBoneAngles( bone, Angle( math.random( -20, -10 ), -180, 0) )
		self.Entity:ManipulateBoneAngles( bone, Angle( -30, -180, -120) )
	end
	
	local bone = self:LookupBone( "ValveBiped.Bip01_L_Forearm" )
	for i=1, 2 do
		self.Entity:ManipulateBoneAngles( bone, Angle( 0, 30, math.random( -180, 180 )) )
	end
	
	local bone = self:LookupBone( "ValveBiped.Bip01_L_Clavicle" )
	for i=1, 2 do
		self.Entity:ManipulateBonePosition( bone, Vector( 60, 0, 0) )
	end
	
	local bone = self:LookupBone( "ValveBiped.Bip01_L_UpperArm" )
	local bonepos, boneang = self:GetBonePosition( bone )
	local diff = data:GetOrigin() - bonepos

	self.Entity:SetPos( data:GetOrigin() + diff - vector_up * 30 )
	
	self.SavePos = data:GetOrigin() + diff - vector_up * 30
	
	self.Time = 0.3
	self.IdleTime = 2
	self.GrowTime = CurTime() + self.Time
	self.StartPos = data:GetOrigin()
	self.CurHeight = -30
	
	sound.Play( "physics/concrete/boulder_impact_hard"..math.random(4)..".wav", self.StartPos )
	//sound.Play( "npc/antlion_guard/shove1.wav", self.StartPos )
	sound.Play( "npc/strider/strider_skewer1.wav", self.StartPos )
	
	if LocalPlayer():GetPos():Distance( self.StartPos ) < 400 then
		GAMEMODE:ShakeView( math.random(11,16), math.Rand(0.1, 0.3) )
	end
	
	local mins = self.StartPos + Vector( -14060, -14060, -14060 )
	local maxs = self.StartPos + Vector( 14060, 14060, 14000 )
	
	self:SetRenderBoundsWS( mins, maxs )
	
	self.Duration = CurTime() + duration
	
	local emitter = ParticleEmitter( self.StartPos )
	
	if emitter then
		for i=1, math.random( 18, 30 ) do
			local rand = VectorRand()
			rand.z = 0
			local pos = self.StartPos + vector_up * ( 30 + i * 2 ) +  rand * 90 
			local particle = emitter:Add( "effects/fleck_cement"..math.random(2), pos)
			particle:SetVelocity( (pos - self.StartPos):GetNormal() * math.random( 90, 140 ) + vector_up * 60 )
			particle:SetDieTime( math.Rand( 2, 4 ) )
			particle:SetStartAlpha( 255 )
			particle:SetEndAlpha( 10 )
			local sz = math.random( 3, 7 )
			particle:SetStartSize( sz )
			particle:SetEndSize( sz )
			particle:SetRoll(math.random(-180,180))
			particle:SetRollDelta(math.random(-10,10))
			particle:SetColor(col.x*255, col.y*255, col.z*255)
			particle:SetLighting(true)
			particle:SetCollide(true)
			particle:SetGravity( vector_up * -4500 )
			particle:SetBounce( math.Rand(0.1, 1) )
		end

		emitter:Finish() emitter = nil collectgarbage("step", 64)
	end
	
end

function EFFECT:Think()
	
	self.Entity:SetPos( self.SavePos )
	self.Entity:SetAngles( self.SaveAng )
	
	if self.GrowTime + self.IdleTime < CurTime() and not self.Lowering then
		self.Time = 1
		self.GrowTime = CurTime() + self.Time
		self.Lowering = true
	end

	return CurTime() < self.Duration
end

function EFFECT:Render()

	//self:SetRenderBounds(Vector(-2760,-2760,0),Vector(2760,2760,2760))

	local delta = 1 - math.Clamp( (self.GrowTime - CurTime()) / self.Time, 0, 1 )
	
	if self.Lowering then
		delta = 1 - delta
	end
	
	if not self.StoreX and not self.StoreY then
		self.StoreX = math.Rand(-1,1)
		self.StoreY = math.Rand(-1,1)
	end

	local bone = self:LookupBone( "ValveBiped.Bip01" )
	//self.Entity:ManipulateBonePosition( bone, Vector( -self.StoreX + self.StoreX * delta, -35 + 35 * delta, -self.StoreZ + self.StoreZ * delta) )	
	self.Entity:ManipulateBonePosition( bone, Vector( -self.StoreX + self.StoreX * delta, -self.StoreY + self.StoreY * delta, -60 + 60 * delta) )	

	if !self.Lowering then
		local bone = self:LookupBone( "ValveBiped.Bip01_L_Hand" )
		self.Entity:ManipulateBoneAngles( bone, Angle( 0, -80 + 80 * delta, 0) )
		//self.Entity:ManipulateBoneScale( bone, Vector( 1 + 1 * delta, 1 + 1 * delta, 1 + 1 * delta ) )
	end
	
	local bone = self:LookupBone( "ValveBiped.Bip01_L_Finger1" )
	self.Entity:ManipulateBoneAngles( bone, Angle( 0, -90 + 90 * delta, 0) )
	self.Entity:ManipulateBoneScale( bone, Vector( 1 + 0.6 * delta, 1 + 0.6 * delta, 1 + 0.6 * delta ) )
	local bone = self:LookupBone( "ValveBiped.Bip01_L_Finger11" )
	self.Entity:ManipulateBoneAngles( bone, Angle( 0, -90 + 90 * delta, 0) )
	self.Entity:ManipulateBoneScale( bone, Vector( 1 + 1 * delta, 1 + 1 * delta, 1 + 1 * delta ) )
	local bone = self:LookupBone( "ValveBiped.Bip01_L_Finger12" )
	self.Entity:ManipulateBoneAngles( bone, Angle( 0, -90 + 90 * delta, 0) )
	self.Entity:ManipulateBoneScale( bone, Vector( 1 + 1 * delta, 1 + 1 * delta, 1 + 1 * delta ) )
	
	local bone = self:LookupBone( "ValveBiped.Bip01_L_Finger2" )
	self.Entity:ManipulateBoneAngles( bone, Angle( 0, -90 + 90 * delta, 0) )
	self.Entity:ManipulateBoneScale( bone, Vector( 1 + 0.6 * delta, 1 + 0.6 * delta, 1 + 0.6 * delta ) )
	local bone = self:LookupBone( "ValveBiped.Bip01_L_Finger21" )
	self.Entity:ManipulateBoneAngles( bone, Angle( 0, -90 + 90 * delta, 0) )
	self.Entity:ManipulateBoneScale( bone, Vector( 1 + 1 * delta, 1 + 1 * delta, 1 + 1 * delta ) )
	local bone = self:LookupBone( "ValveBiped.Bip01_L_Finger22" )
	self.Entity:ManipulateBoneAngles( bone, Angle( 0, -90 + 90 * delta, 0) )
	self.Entity:ManipulateBoneScale( bone, Vector( 1 + 1 * delta, 1 + 1 * delta, 1 + 1 * delta ) )
	
	local bone = self:LookupBone( "ValveBiped.Bip01_L_Finger3" )
	self.Entity:ManipulateBoneAngles( bone, Angle( 0, -90 + 90 * delta, 0) )
	self.Entity:ManipulateBoneScale( bone, Vector( 1 + 0.6 * delta, 1 + 0.6 * delta, 1 + 0.6 * delta ) )
	local bone = self:LookupBone( "ValveBiped.Bip01_L_Finger31" )
	self.Entity:ManipulateBoneAngles( bone, Angle( 0, -90 + 90 * delta, 0) )
	self.Entity:ManipulateBoneScale( bone, Vector( 1 + 1 * delta, 1 + 1 * delta, 1 + 1 * delta ) )
	local bone = self:LookupBone( "ValveBiped.Bip01_L_Finger32" )
	self.Entity:ManipulateBoneAngles( bone, Angle( 0, -90 + 90 * delta, 0) )
	self.Entity:ManipulateBoneScale( bone, Vector( 1 + 1 * delta, 1 + 1 * delta, 1 + 1 * delta ) )
	
	render.SuppressEngineLighting( true )
		render.EnableClipping( true )
			render.PushCustomClipPlane( vector_up, vector_up:Dot( self.StartPos ) )
			cam.IgnoreZ( true )
			self:DrawModel()
			cam.IgnoreZ( false )
			render.PopCustomClipPlane()
		render.EnableClipping( false )
	render.SuppressEngineLighting( false )
	
end