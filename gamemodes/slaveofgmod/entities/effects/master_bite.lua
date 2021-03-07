for i=1, 4 do
 util.PrecacheSound( "physics/concrete/boulder_impact_hard"..i..".wav" )
end

local trace = { mask = MASK_SOLID }
local mat_decal = Material( "decals/bloodstain_002" )
//mat_decal:SetInt( "nocull", 1 ) 

function EFFECT:Init( data )
	
	local duration = 4
	
	self.Entity:SetModel( "models/zombie/poison.mdl" )
	self.Entity:SetAngles( Angle( 0, math.random(-10, 10) + (LocalPlayer():FlipView() and 180 or 0), 0 ) )
	self.SaveAng = self.Entity:GetAngles()
	local id, dur = self.Entity:LookupSequence( "releasecrab" )
	self.Entity:SetSequence( "releasecrab" )
	self.Entity:SetCycle( dur )
	self.Entity:SetModelScale( 24, 0 )
	
	self.Entity:SetLOD( 0 )
	
	trace.start = data:GetOrigin()
	trace.endpos = trace.start - vector_up * 20
	trace.filter = self.Entity
	
	local tr = util.TraceLine( trace )
	
	local col = Vector( 1, 1, 1 )
	
	if tr.Hit and tr.HitWorld then
		//util.DecalEx( mat_decal, Entity(0), tr.HitPos, tr.HitNormal, color_white, 800, 800 )
		//util.Decal( "tear_master", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal )
		/*for i=1, math.random( 5, 6 ) do
			local offset = VectorRand() * i * 20
			offset.z = tr.HitPos.z
			util.Decal( "BloodHuge2", tr.HitPos + tr.HitNormal + offset, tr.HitPos - tr.HitNormal + offset )
		end*/
		self.RefractPos = tr.HitPos
		col = render.ComputeLighting( tr.HitPos, tr.HitNormal ) 
	end
	
	//self.Spin = math.random(-90,90)
	//self.CurSpin = self.Spin - math.random( -40, 40 )
	
	local bone = self:LookupBone( "ValveBiped.Bip01_Spine4" )
	for i=1, 2 do
		self.Entity:ManipulateBonePosition( bone, Vector( 50, 0, 0) )
	end
		
	local bone = self:LookupBone( "ValveBiped.Bip01_Spine4" )
	local bonepos, boneang = self:GetBonePosition( bone )
	local diff = data:GetOrigin() - bonepos

	self.Entity:SetPos( data:GetOrigin() + diff - vector_up * 110 )
	
	self.SavePos = data:GetOrigin() + diff - vector_up * 110
		
	self.Time = 0.2
	self.IdleTime = 2
	self.GrowTime = CurTime() + self.Time
	self.StartPos = data:GetOrigin()
	self.CurHeight = -30
	
	sound.Play( "physics/concrete/boulder_impact_hard"..math.random(4)..".wav", self.StartPos )
	surface.PlaySound( "npc/antlion_guard/angry"..math.random(3)..".wav" )
	//sound.Play( "npc/antlion_guard/angry"..math.random(3)..".wav", self.StartPos, 150, math.random( 80,90 ), 1 )
	sound.Play( "npc/antlion_guard/shove1.wav", self.StartPos )
	//sound.Play( "npc/antlion/land1.wav", self.StartPos, 150, math.random( 80,90 ), 1 )
	
	if LocalPlayer():GetPos():Distance( self.StartPos ) < 400 then
		GAMEMODE:ShakeView( math.random(13,20), math.Rand(0.1, 0.3) )
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
			local pos = self.StartPos + vector_up * ( 30 + i * 2 ) +  rand * 130 
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
		self.Time = 0.6
		self.GrowTime = CurTime() + self.Time
		self.Lowering = true
	end

	return CurTime() < self.Duration
end

local mat2 = Material( "particle/warp2_warp" )

function EFFECT:Render()

	local delta = 1 - math.Clamp( (self.GrowTime - CurTime()) / self.Time, 0, 1 )
	
	if self.Lowering then
		delta = 1 - delta
	end
	
	if not self.StoreX and not self.StoreY then
		self.StoreX = math.Rand(-1,1)
		self.StoreY = math.Rand(-1,1)
	end
	
	if self.RefractPos then
		mat2:SetFloat("$refractamount", 0.1 * delta)
		mat2:SetInt("$ignorez", 0 )
		render.SetMaterial( mat2 )
		render.UpdateRefractTexture()
		render.DrawQuadEasy( self.RefractPos, vector_up, 400, 400, Color( 255, 255, 255, 255 * delta ), 0 )
	end

	local bone = self:LookupBone( "ValveBiped.Bip01" )
	self.Entity:ManipulateBonePosition( bone, Vector( -self.StoreX + self.StoreX * delta, -self.StoreY + self.StoreY * delta, -10 + 10 * delta) )	

	
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