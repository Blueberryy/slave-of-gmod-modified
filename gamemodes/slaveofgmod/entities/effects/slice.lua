local eff = util.Effect
local math = math
local render = render
local ipairs = ipairs
local pairs = pairs
local Matrix = Matrix
local OrderVectors = OrderVectors
local EffectData = EffectData
local WorldToLocal = WorldToLocal
local LocalPlayer = LocalPlayer
local VectorRand = VectorRand


//local storeconvex

function EFFECT:Init( data )

	if not LocalPlayer().fake_bodies_sliced then return end
	
	if #LocalPlayer().fake_bodies_sliced >= math.min(40, SOG_MAX_CORPSES) then return end

	self.ent = data:GetEntity()
	
	self.MakeSecondPart = math.Round(data:GetRadius()) == 1
	
	if !IsValid(self.ent) then return end
	
	self.DieTime = CurTime() + math.Rand(2,4)
	
	//local col = team.GetColor( self.ent:Team() )
	
	//self.StoredColor = Vector( col.r/255, col.g/255, col.b/255 )
	
	if self.ent.GetPlayerColor then
		self.StoredColor = self.ent:GetPlayerColor()
	end
	
	if self.ent:IsNextBot() then
		self.StoredColor = self.ent:GetDTVector( 0 )
	end
	
	//self.GetPlayerColor = function() return Vector( col.r/255,col.g/255,col.b/255 ) end
	
	self.Origin = data:GetOrigin()

	self.Ang = data:GetNormal()
	self.Ang2 = self.Ang:Angle():Forward() * 20
	
	self.Normal = ( self.Ang2 - self.Ang ):GetNormalized()
		
	self.Up = math.ceil(data:GetScale())
	
	self.Origin.z = self.Up
	
	if self.MakeSecondPart then
				
		data:SetRadius( 0 )
		eff("slice",data)
		
	end
	
	if IsValid(self.ent) then
	
		if self.ent:GetMaterial() ~= "" then
			self:SetMaterial(self.ent:GetMaterial())
		end
	
		if self.ent.GetRagdollEntity and IsValid(self.ent:GetRagdollEntity()) then
			self.ent:GetRagdollEntity():SetNoDraw(true)
			
			local rag = self.ent:GetRagdollEntity()
			
			//rag:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
			
			self.transform = {}
	
			local pos, ang = rag:GetPos(), rag:GetAngles()
			for i=0, rag:GetPhysicsObjectCount()-1 do
				local phys = rag:GetPhysicsObjectNum(i)
				if IsValid(phys) then
					local pos2, ang2 = WorldToLocal(phys:GetPos(), phys:GetAngles(), pos, ang)
					
					self.transform[i] = {pos = pos2, ang = ang2}
				end
			end
			

			self:CreateDummy( rag )
			
		end
	end
	
	//print("----")
	//PrintTable(self.Origin:ToScreen())
	
	self.DieTime = CurTime() + 10
	
	table.insert( LocalPlayer().fake_bodies_sliced, self.Entity )

end

local mins = Vector(math.huge, math.huge, math.huge)
local maxs = Vector(-math.huge, -math.huge, -math.huge)

// extremely huge thanks to _Kilburn for this nice "statue" code
function EFFECT:CreateDummy( rag )
	
	self:SetModel( rag:GetModel() )
	self:SetPos( rag:GetPos() + vector_up * 3 )
	self:SetAngles( rag:GetAngles() )
		
	local convexes = {}
	local mass = 0
	self.PhysBoneTransforms = {}
	self.BoneTransforms = {}
	self.BoneReference = nil
	

	for i=0, rag:GetPhysicsObjectCount()-1 do	
		local helper = self.transform[i]
		local phys = rag:GetPhysicsObjectNum(i)	
		
		local M = Matrix()
		
		self.PhysBoneTransforms[i] = {pos = helper.pos, ang = helper.ang}
		self.BoneTransforms[rag:TranslatePhysBoneToBone(i)] = self.PhysBoneTransforms[i]
		
		M:Translate(helper.pos)
		M:Rotate(helper.ang)
		
		if !self.MakeSecondPart and self.Normal:Dot(phys:GetPos() - self.Origin) > 0 and phys:GetPos():Distance( self.Origin ) > 13 then continue end
		if self.MakeSecondPart and self.Normal:Dot(phys:GetPos() - self.Origin) < 0 and phys:GetPos():Distance( self.Origin ) > 13 then continue end
		
		mass = mass + phys:GetMass()
		
		for _,c in ipairs(phys:GetMeshConvexes()) do
			local cvx = {}
			
			local max_vertices = 15
			local min = math.min(max_vertices, #c)
			local dif = math.ceil(#c/min)
									
			for _,p in ipairs(c) do
			
				if _ % dif ~= 0 then continue end
			
				local M1 = Matrix() * M
				M1:Translate(p.pos)
				
				local pos = M1:GetTranslation()
				
				cvx[#cvx+1] = pos
				
				OrderVectors(mins, pos*1)
				OrderVectors(pos*1, maxs)
				
			end
			convexes[#convexes+1] = cvx
		end
	end
	
	
	
	self:PhysicsInitMultiConvex(convexes)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	
	
	local phys = self:GetPhysicsObject()
	
	if IsValid(phys) then
		phys:Wake()
		phys:SetMass(mass)
		phys:SetMaterial("zombieflesh")
		phys:SetVelocity( self.Normal:GetNormal() * ( self.MakeSecondPart and 100 or -100 ) + VectorRand() * 50 + vector_up * 20 )
	end
	
	self:EnableCustomCollisions(true)
	
	
		
	self.SavePos = self:WorldToLocal( self.Origin )
	self.NormalPos1 = self:WorldToLocal( self.Ang )
	self.NormalPos2 = self:WorldToLocal( self.Ang2 )
	
	if not self.ReferencePoseTable then
		self.ReferencePoseTable = {}
		
		for k = 0, self.ent:GetBoneCount() - 1 do
			local m = self.ent:GetBoneMatrix( k )
			if m then
				local pos, ang = m:GetTranslation(), m:GetAngles()
				local local_pos, local_ang = WorldToLocal( pos, ang, rag:GetPos(), rag:GetAngles())
				
				self.ReferencePoseTable[ k ] = { pos = local_pos, ang = local_ang }
			else

				local pos, ang = self.ent:GetBonePosition( k )
				if pos and ang then
					local local_pos, local_ang = WorldToLocal( pos, ang, rag:GetPos(), rag:GetAngles())
					self.ReferencePoseTable[ k ] = { pos = local_pos, ang = local_ang }
				end
			end

		end
		
		//self.ReferencePoseTable = rag.ReferencePoseTable
		
	end
	
	if self.MakeSecondPart then
		//PrintTable(convexes)
		rag:SetParent( self )
		rag:AddEffects( EF_BONEMERGE )
	end
	
end


local function MatrixWorldToLocal(refMat, worldMat)
	local pos, ang = WorldToLocal(refMat:GetTranslation(), refMat:GetAngles(), worldMat:GetTranslation(), worldMat:GetAngles())
	local localM = Matrix()
	localM:Translate(pos)
	localM:Rotate(ang)
	
	return localM
end

function EFFECT:CaptureReferencePose()
	local old_BuildBonePositions = self.BuildBonePositions
	
	self.BuildBonePositions = function(self, n)
		self.BoneReference = {}
		
		local function processChildBones(parent, parentMat)
			local children
			if parent then
				children = self:GetChildBones(parent)
			else
				children = {0}
			end
			
			for _,child in ipairs(children) do
				local childName = self:GetBoneName(child)
				if childName then
					local childMat = self:GetBoneMatrix(child)
					self.BoneReference[childName] = MatrixWorldToLocal(childMat, parentMat)
					processChildBones(child, childMat)
				end
			end
		end
		
		local rootMat = Matrix()
		processChildBones(nil, rootMat)
	end
	self:SetupBones()
	
	self.BuildBonePositions = old_BuildBonePositions
end

function EFFECT:PropagateBoneTransform(parent, parentMat)
	local children
	if parent then
		children = self:GetChildBones(parent)
	else
		children = {0}
	end
	
	for _,child in ipairs(children) do
		if not self.BoneTransforms[child] then
			local childName = self:GetBoneName(child)
			if childName and self.BoneReference[childName] then
				local childMat = parentMat * self.BoneReference[childName]
				if self.BoneTransforms and self.BoneTransforms[childName] then
					local tr = self.BoneTransforms[childName]
					childMat:Translate(tr.pos)
					childMat:Rotate(tr.ang)
				end
				
				local ang = self:GetManipulateBoneAngles(child)
				childMat:Rotate(ang)
				
				self:SetBoneMatrix(child, childMat)
				self:PropagateBoneTransform(child, childMat)
			end
		end
	end
end

function EFFECT:BuildBonePositions(nbones)
	if self.BoneTransforms and self.BoneReference then
		for b, tr in pairs(self.BoneTransforms) do
			local M0 = self:GetBoneMatrix(b)
			
			if M0 then
				local M = Matrix()
				M:Translate(self:GetPos())
				M:Rotate(self:GetAngles())
				M:Translate(tr.pos)
				M:Rotate(tr.ang)
				self:SetBoneMatrix(b, M)
				self:PropagateBoneTransform(b, M)
			end
		end
	end
end

local M_Entity = FindMetaTable("Entity")
local M_VMatrix = FindMetaTable("VMatrix")

local VM_SetTranslation = M_VMatrix.SetTranslation
local VM_GetTranslation = M_VMatrix.GetTranslation
local VM_GetAngles = M_VMatrix.GetAngles
local VM_SetAngles = M_VMatrix.SetAngles
local VM_SetScale = M_VMatrix.SetScale

local E_GetBoneMatrix = M_Entity.GetBoneMatrix
local E_SetBoneMatrix = M_Entity.SetBoneMatrix

function EFFECT:BuildBonePositions2( nbones )
	
	//local ragdoll = self.ent.GetRagdollEntity and self.ent:GetRagdollEntity()
	
	//if !IsValid( ragdoll ) then return end
	
	if not self.ReferencePoseTable then return end
	
	for bone, tbl in pairs( self.ReferencePoseTable ) do
		
		local m = E_GetBoneMatrix( self, bone )--self:GetBoneMatrix( bone )
		
		if m then
			local pos, ang = LocalToWorld( tbl.pos, tbl.ang, self:GetPos(), self:GetAngles() )
			
			VM_SetTranslation( m, pos )
			VM_SetAngles( m, ang )
			
			E_SetBoneMatrix( self, bone, m )
			
		end	
	end
	
end

function EFFECT:Think( )
	
	if IsValid(self.ent) and self.ent.GetRagdollEntity and IsValid(self.ent:GetRagdollEntity()) then
		if not self.Frozen then
			for i = 1, self.ent:GetRagdollEntity():GetPhysicsObjectCount() do
				local bone = self.ent:GetRagdollEntity():GetPhysicsObjectNum(i)
				if bone and bone.IsValid and bone:IsValid() then
					bone:EnableMotion(false)
				end
			end
			self.Frozen = true
		end
		
		self.Entity:SetRenderBounds(Vector(-128, -128, -128), Vector(128, 128, 128))
		
	else
		//SafeRemoveEntity(self.Dummy)
	end
	
	

	return self.DieTime and self.DieTime > CurTime()//true
end

local function CollideCallbackSmall(particle, hitpos, hitnormal)
	if not particle.HitAlready then
	
		particle.HitAlready = true
		
		if math.random(1, 10) == 3 then
			sound.Play("physics/flesh/flesh_bloody_impact_hard1.wav", hitpos, 50, math.random(95, 105))
		end
		util.Decal(math.random(25) == 25 and "Blood" or "Impact.Flesh", hitpos + hitnormal, hitpos - hitnormal)

		particle:SetDieTime(0)
	end	
end

local flesh = Material("models/flesh")
local meat = CreateMaterial( "Meat", "UnlitGeneric", { [ "$basetexture" ] = "models/flesh" } )
local meatcol = Color(115,15,15,255)

local grav_vec1 = Vector(0, 0, -1800)
local grav_vec2 = Vector(0, 0, 100)

function EFFECT:Render()
	local rag = self
	
	/*if self and self:IsValid() then
	
		if not self.InitBuildBonePositions or not self.BoneReference then
			self:AddCallback("BuildBonePositions", function(self, nbones) self:BuildBonePositions(nbones) end)
			self:CaptureReferencePose()
			self.InitBuildBonePositions = true
			//self:SetupBones()
		end
	end*/
	
	if !IsValid(LocalPlayer()) then return end
	if Cut and Cut:IsValid() and Cut:IsVisible() then return end
	
	local MySelf = IsValid( LocalPlayer():GetObserverTarget() ) and LocalPlayer():GetObserverTarget() or LocalPlayer()
	
	//hide the corpses outside of the screen to save some fps
	local visible = MySelf:GetPos():DistToSqr(self:GetPos()) < DRAW_DISTANCE * DRAW_DISTANCE
	
	if not visible then return end
	
	//local ragdoll = self.ent.GetRagdollEntity and self.ent:GetRagdollEntity()
	
	//if ragdoll and IsValid(ragdoll) then
		
		if not self.InitBuildBonePositions and self.ReferencePoseTable then
			self:AddCallback("BuildBonePositions", function(self, nbones) self:BuildBonePositions2(nbones) end)
			self.InitBuildBonePositions = true
			self:SetupBones()
		end	
		
		//if not ragdoll.Sliced then
		//	ragdoll.Sliced = true
		//end
	//end
	
	local ct = CurTime()
	
	if rag and IsValid(rag) then			
				
			if not self.SavePos then return end
				
			local pos = self:LocalToWorld( self.SavePos )
				
			local normal1 = self:LocalToWorld( self.NormalPos1 )
			local normal2 = self:LocalToWorld( self.NormalPos2 )
				
			local normal = ( normal2 - normal1 ):GetNormalized()
								
			if !self.MakeSecondPart then
				normal = normal * -1
			end
				
			local distance = normal:Dot( pos )
				
			render.ClearStencil()
			render.SetStencilEnable( true )
				
			render.EnableClipping( true )
			render.PushCustomClipPlane( normal, distance )

			render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
			render.SetStencilFailOperation( STENCILOPERATION_REPLACE )
			render.SetStencilZFailOperation( STENCILOPERATION_KEEP )
			render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_ALWAYS )
			render.SetStencilReferenceValue( 1 )
				
			//render.ModelMaterialOverride( meat )
				render.CullMode( MATERIAL_CULLMODE_CW )
				//rag:SetModelScale( 0.9,0 )
				rag:DrawModel();
				render.CullMode( MATERIAL_CULLMODE_CCW )
			//render.ModelMaterialOverride(  )
								
			render.SetStencilReferenceValue( 2 )
				
			rag:SetModelScale( 1,0 )
			rag:DrawModel()
				
			render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
			render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
			render.SetStencilReferenceValue( 1 )
				
			render.PopCustomClipPlane()
			render.EnableClipping( false );
				
			//render.SetMaterial( meat )
			//render.DrawQuadEasy( pos, normal*-1, 120, 120, meatcol, 0 )
			
			if not self.MeatAng and not self.MeatPos then
					
				local meat_ang = ( normal * -1 ):Angle()
				meat_ang:RotateAroundAxis( meat_ang:Right(), -90 )
				
				local mpos, mang = WorldToLocal( pos, meat_ang, self:GetPos(), self:GetAngles())
					
				self.MeatAng = mang
				self.MeatPos = mpos
			end
				
			local meat_pos, meat_ang = LocalToWorld( self.MeatPos, self.MeatAng, self:GetPos(), self:GetAngles())
				
			render.OverrideDepthEnable( true, true )
				
			cam.Start3D2D( meat_pos, meat_ang, 1 )
				surface.SetMaterial( meat )
				surface.SetDrawColor( meatcol )
				surface.DrawTexturedRectRotated( 0, 0, 120, 120, 0 ) 
			cam.End3D2D()
				
			render.OverrideDepthEnable( false )
			
				
			render.SetStencilEnable( false )
				
			if !self.MakeSecondPart then
			self.NextDrip = self.NextDrip or 0
			if self.NextDrip <= ct then
				self.NextDrip = ct + 0.075
				
				local ang = (normal*-1):Angle()
				ang.p = ang.p + 90
				
				local rnd = ang:Right() * math.Rand(-2,2) + ang:Forward() * math.Rand(-2,2)
				local vec_rand = VectorRand()
					
				pos = self:LocalToWorld(self:OBBCenter())
				
				local emitter = ParticleEmitter(pos)
				
				emitter:SetPos(pos + rnd)			

				if emitter then
					local delta = math.max(0, self.DieTime - ct)
					if 0 < delta then

						for i=1, math.random(1, 3) do
							local particle = emitter:Add("Decals/flesh/Blood"..math.random(1,5), pos + rnd + vec_rand*5)
							local force = math.min(1.5, delta) * math.Rand(65, 320)
											
								particle:SetVelocity(force * vector_up + 0.35 * force * vec_rand)
								particle:SetDieTime(math.Rand(2.25, 3))
								particle:SetStartAlpha(250)
								particle:SetEndAlpha(0)
								particle:SetStartSize(math.random(1, 8))
								particle:SetEndSize(0)
								particle:SetRoll(math.Rand(0, 360))
								particle:SetRollDelta(math.Rand(-40, 40))
								particle:SetColor(255, 0, 0)
								particle:SetAirResistance(15)
								particle:SetBounce(0)
								particle:SetGravity(grav_vec1)
								particle:SetCollide(true)
								particle:SetCollideCallback(CollideCallbackSmall)
								particle:SetLighting(true)
											
								local particle = emitter:Add("effects/blood_core.vmt", pos + rnd + vec_rand * 3)
											
								particle:SetVelocity(vec_rand*40)
								particle:SetDieTime(math.Rand(0.15, 0.25))
								particle:SetStartAlpha(50)
								particle:SetEndAlpha(0)
								particle:SetStartSize(math.random(3, 8))
								particle:SetEndSize(math.random(3, 8))
								particle:SetRoll(math.Rand(0, 360))
								particle:SetRollDelta(math.Rand(-10, 10))
								particle:SetColor(155, 0, 0)
								particle:SetAirResistance(15)
								particle:SetBounce(0)
								particle:SetGravity(grav_vec2)
								particle:SetCollide(true)
								particle:SetCollideCallback(CollideCallbackSmall)
								particle:SetLighting(true)
											
																	
						end
							
					end	
					emitter:Finish() emitter = nil collectgarbage("step", 64)
				end
					
				
				end
				
			end
				
	end
end