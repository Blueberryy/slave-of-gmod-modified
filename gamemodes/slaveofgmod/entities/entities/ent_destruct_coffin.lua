AddCSLuaFile()

ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Initialize()
	
	self:SetModel("models/props_c17/gravestone_coffinpiece002a.mdl")
	
	if SERVER then

		self:SetMoveType( MOVETYPE_NONE )
		self:SetSolid( SOLID_VPHYSICS )
		self:PhysicsInit( SOLID_VPHYSICS  )
						
		local phys = self:GetPhysicsObject()
		
		if IsValid(phys) then
			phys:EnableMotion( false )
		end
		
		self:SetInteractable( false )
		self:SetFinishLevel( false )
		self:SetHitNumber( 0 )
		
	end
	
	if CLIENT then
		
		self:DrawShadow( false )
		self:SetRenderBounds( Vector(-318, -318, -318), Vector(318, 318, 318) )
		
	end
	
	BOSS_COFFIN = self

end

function ENT:SetBossRagdoll( ent )
	self:SetDTEntity( 0, ent )
end

function ENT:GetBossRagdoll( )
	return self:GetDTEntity( 0 )
end

function ENT:SetFinishLevel( bl )
	self:SetDTBool( 0, bl )
end

function ENT:GetFinishLevel()
	return self:GetDTBool( 0 )
end

function ENT:SetInteractable( bl )
	self:SetDTBool( 1, bl )
end

function ENT:IsInteractable()
	return self:GetDTBool( 1 )
end

function ENT:SetHitNumber( num )
	self:SetDTInt( 0, num )
end

function ENT:GetHitNumber( num )
	return self:GetDTInt( 0 )
end

function ENT:SetDoRubble( bl )
	self:SetDTBool( 2, bl )
end

function ENT:GetDoRubble()
	return self:GetDTBool( 2 )
end

if SERVER then

function ENT:Reset()
	self:SetInteractable( false )
end

function ENT:Think()
	
	if IsValid( Entity(1) ) then
		
		if !IsValid( self:GetBossRagdoll() ) and IsValid( BOSS_RAGDOLL ) then
			self:SetBossRagdoll( BOSS_RAGDOLL )
		end
		
		if CUR_STAGE == 2 then
			
			if self:GetFinishLevel() then
				if !self:IsInteractable() then
					self:SetInteractable( true )
				end
			else
				if IsValid( self:GetBossRagdoll() ) then
					
					local owner = self:GetBossRagdoll():GetOwner()
					
					if IsValid( owner ) and owner.Vulnerable and owner.RecoveryTime and owner.RecoveryTime >= CurTime() then
						if !self:IsInteractable() then
							self:SetInteractable( true )
						end
					else
						if self:IsInteractable() then
							self:SetInteractable( false )
						end
					end
					
				end
			end
			
		else
			if self:IsInteractable() then
				self:SetInteractable( false )
			end
		end	
		
	end
	
end

function ENT:OnRemove()
end


function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end
	
function ENT:OnTakeDamage( dmginfo )
	
	if not self:IsInteractable() then return end
	
	local attacker = dmginfo:GetAttacker()
	local inflictor = dmginfo:GetInflictor()
	//local isblast = dmginfo:IsDamageType( DMG_BLAST )
	
	self.NextDamage = self.NextDamage or 0
	
	if self.NextDamage >= CurTime() then return end
	
	if IsValid( attacker ) and attacker:IsPlayer() then
		
		if CUR_STAGE == 2 and IsValid( self:GetBossRagdoll() ) then

			if not self:GetFinishLevel() then
			
				local owner = self:GetBossRagdoll():GetOwner()
				
				if IsValid( owner ) then
					
					GAMEMODE:FinishRound()
					owner:SetBehaviour( BEHAVIOUR_DUMB )
					owner.SpecialAttack = nil
					self:SetFinishLevel( true )
					
					Entity(1):PopHUDMessage( "sog_hud_finish_the_job" )
					
					local bone = self:GetBossRagdoll():LookupBone("ValveBiped.Bip01_Head1")
					if bone then
						local p, a = self:GetBossRagdoll():GetBonePosition( bone )
						if p and a then
							GAMEMODE:DoBloodSpray( p + vector_up * 3, a:Forward(), VectorRand() * 5 , math.random(5,7), math.random( 500, 600 ) + 80 * 220 )
							GAMEMODE:DoBloodSpray( p + vector_up * 3, a:Forward(), VectorRand() * 5 , math.random(5,7), math.random( 50, 400 ) + 80 * 220 )
						end
						self:GetBossRagdoll():ManipulateBoneScale( bone, Vector( 0.0001, 0.0001, 0.0001 ) )
					end
					
					self.NextDamage = CurTime() + 5
					
					local e = EffectData()
						e:SetOrigin( self:GetPos() + vector_up*40 )
						e:SetMagnitude( math.random( 500, 700 ) )
					util.Effect( "refract_effect", e, nil, true )
					
					attacker:ShakeView( math.random(25,30), 4 )
					
					self:EmitSound("physics/metal/metal_box_break"..math.random(2)..".wav",100, math.Rand(95, 130), 1, CHAN_AUTO ) 
					self:EmitSound( "npc/dog/car_impact1.wav" )
					attacker:EmitSound( "ambient/levels/citadel/citadel_hit1_adpcm.wav", 100 )
					
				end
			
			else
				
				self.Hits = self.Hits or 0
				
				self.Hits = self.Hits + 1
				
				if self.Hits <= 3 then
					self:EmitSound("physics/metal/metal_box_break"..math.random(2)..".wav",100, math.Rand(95, 130)) 
					attacker:ShakeView( math.random(20,25), 2 )
				end
				
				if self.Hits == 3 then
					
					attacker:EmitSound( "ambient/thunder/hm2_lightning2.wav", 100 )
					self:SetDoRubble( true )
					
					for k, v in pairs( ents.FindByClass( "prop_*" ) ) do
						if v and v:IsValid() then
							v:SetMaterial( "!dev30_model" )
						end
					end
					
				end
				
				if self.Hits > 3 then
					self:SetHitNumber( self.Hits )
				end
				
				self.NextDamage = CurTime() + 1
				
				if self.Hits > 6 then
					attacker:StripWeapons()
					attacker:ConCommand( "-attack" )
					attacker:SetLocalVelocity( vector_origin )
					attacker:SetMoveType( MOVETYPE_NONE )
					Entity(1):SendLua( "CallFakeMenu()" )
					self.NextDamage = CurTime() + 9999
				end
				
				
				
			end
			
		end
	
	end
	
	
end
end

// put it in shared so they are also precached for physics
local rubble_models = {
	Model( "models/props_debris/concrete_chunk01a.mdl" ),
	Model( "models/props_debris/concrete_chunk01b.mdl" ),
	Model( "models/props_debris/concrete_chunk01c.mdl" ),
	Model( "models/props_debris/concrete_chunk07a.mdl" ),
	Model( "models/props_debris/concrete_column001a_chunk01.mdl" ),
	Model( "models/props_debris/concrete_column001a_chunk02.mdl" ),
	Model( "models/props_debris/concrete_column001a_chunk03.mdl" ),
	Model( "models/props_debris/concrete_column001a_chunk05.mdl" ),
	Model( "models/props_debris/tile_wall001a_chunk07.mdl" ),
}

if CLIENT then

local mat_overlay = CreateMaterial( "coffin1",
    "VertexLitGeneric",
    {
        ["$basetexture"] = "Models/flesh",
        ["$bumpmap"] = "models/flesh_nrm",
        ["$nodecal"] = "0",
        ["$halflambert"] = 1,
        ["$translucent"] = 1,
        ["$model"] = 1,

        ["$detail"] = "Models/flesh",
        ["$detailscale"] = 1.5,
        ["$detailblendfactor"] = 7,
        ["$detailblendmode"] = 3,

        ["$phong"] = "1",
        ["$phongboost"] = "5",
        ["$phongfresnelranges"] = "[10 3 10]",
        ["$phongexponent"] = "500"
    }
)

local mat = Material( "models/spawn_effect2" )
local mat2 = Material( "models/flesh" )
local dark_beam = Material( "effects/bloodstream" )
local sprite1 = Material( "effects/select_dot" )
local sprite2 = Material( "decals/black_blood2" )
local col_beam = Color( 10, 10, 10, 255 )
local lerp = 0

ENT.LastHitNumber = 0

local function CollideCallback(particle, hitpos, hitnormal)	
	util.Decal("BloodHugeBlack"..math.random(1,3), hitpos + hitnormal, hitpos - hitnormal)	
	particle:SetDieTime(0)	
end

local dev_mat = CreateMaterial( 
	"dev30_model", 
	"VertexLitGeneric", 
	{
		["$basetexture"] = "dev/reflectivity_30", 
		["$model"] = 1,
	}
)


local gib_render = function( self )
	
	render.MaterialOverride( dev_mat )
	self:DrawModel()
	render.MaterialOverride( )
	
end

local maxbound = Vector(6, 6, 6)
local minbound = maxbound * -1

function ENT:DoRubble()
	
	for i=1, 9 do
		
		local rand = VectorRand( -250, 250 )
		rand.z = math.Clamp( rand.z, -40, 40 )
		
		local ent = ClientsideModel( rubble_models[ i ] , RENDERGROUP_OPAQUE)
		if ent:IsValid() then
			//ent:SetMaterial("skybox/starfield")
			ent:SetModelScale( math.Rand(1.1, 1.3), 0 )
			ent:SetPos( self:GetPos() + vector_up * 600 + rand )
			ent:PhysicsInit( SOLID_VPHYSICS )
			ent:SetSolid( SOLID_VPHYSICS )
			ent:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
			//ent:PhysicsInitBox(minbound, maxbound)
			//ent:SetCollisionBounds(minbound, maxbound)

			local phys = ent:GetPhysicsObject()
			if phys:IsValid() then
				phys:SetMaterial("concrete")
				phys:Wake()
				phys:AddAngleVelocity(VectorRand() * 500)
			end
			
			ent.RenderOverride = gib_render

			SafeRemoveEntityDelayed( ent, math.Rand(23, 36))
		end
	end
	
end
local texturizer_mat = Material( "pp/texturize/obra.png" )
function ENT:Draw()

	if not self.StorePos then 
		self.StorePos = self:GetPos()
	end
	
	if self:GetFinishLevel() then
	
		if self.LastHitNumber ~= self:GetHitNumber() then
			self:AddFakeError()
			print( translate.ClientFormat(self, "sog_error_message_console", tostring(self), tostring( Entity( 1 ) ) ))
			if self:GetHitNumber() > 6 then
				print( translate.ClientGet(self, "sog_error_message2_console"))
			end
			self.LastHitNumber = self:GetHitNumber()
		end
		
		if self:GetDoRubble() and not self.DidRubble then
			self:DoRubble()
			WORLD_OVERRIDE_MAT = GAMEMODE.WorldMaterials[1]
			self.DidRubble = true
		end
	
		local rand = VectorRand( -1, 1 )
		rand.z = 0
		self:SetPos( self.StorePos + rand )
		
		self.NextBlood = self.NextBlood or 0
		
		if self.NextBlood < CurTime() then
		
			local emitter = ParticleEmitter( self:GetPos() )
			
			if emitter then
				
				for i=1, 3 do
					
					local rand = VectorRand( -1, 1 )
					rand.z = 0
					local particle = emitter:Add( "decals/black_blood"..math.random(4), self:GetPos() + VectorRand( -10, 10 ) )
					particle:SetVelocity( rand * math.random( 100, 300 ) + vector_up * 300 )
					particle:SetDieTime(2)
					particle:SetStartAlpha(250)
					particle:SetStartSize(20)
					particle:SetEndSize(26)
					particle:SetRoll(math.random(-180, 180))
					particle:SetColor(0, 0, 0)
					particle:SetLighting(true)
					particle:SetCollide(true)
					particle:SetAirResistance(16)
					particle:SetGravity( vector_up * -1500 )
					particle:SetCollideCallback( CollideCallback )
					
				end
				
			
				emitter:Finish() emitter = nil collectgarbage("step", 64)
			
			end
		
		
			self.NextBlood = CurTime() + math.Rand( 0.1, 0.3 )
		end
		
	end

	self:DrawModel()
		
	if self:IsInteractable() then

		mat_overlay:SetFloat( "$detailscale", 2.1 + math.sin(RealTime() * 0.1) * 1)
		
		if self:GetFinishLevel() then
		
			render.ClearStencil()
			render.SetStencilEnable(true)
			
			render.SetStencilCompareFunction( STENCIL_ALWAYS )
			render.SetStencilPassOperation( STENCIL_REPLACE )
			render.SetStencilFailOperation( STENCIL_KEEP )
			render.SetStencilZFailOperation( STENCIL_KEEP )
			
			render.SetStencilReferenceValue( 1 )

			render.SetBlend(0)
			self:DrawModel()
			render.SetBlend(1)
			
			render.SetStencilCompareFunction( STENCIL_EQUAL )
			render.SetStencilPassOperation( STENCIL_REPLACE )

			DrawTexturize( 32, texturizer_mat )
						
			render.SetStencilEnable( false )
		
		end
		
		render.MaterialOverride( mat_overlay )
		render.SetColorModulation( 0, 0, 0 )
		render.SetBlend( lerp or 1 )
		self:DrawModel()
		render.SetBlend( 1 )
		render.SetColorModulation( 1, 1, 1 )
		render.MaterialOverride( )
		
		
		if !self:GetFinishLevel() then
			render.ModelMaterialOverride( mat )
			render.SetColorModulation( 1, 0, 0 )
			self:DrawModel()
			render.SetColorModulation( 1, 1, 1 )
			render.ModelMaterialOverride( )	
		end
	end
	
	self.LerpTime = self.LerpTime or 0

	if self:IsInteractable() then
		
		if self.LerpTime == 0 then self.LerpTime = CurTime() + 1.3 end
		
		lerp = math.Clamp( 1 - ( self.LerpTime - CurTime() ) / 1.3, 0, 1 )

	else
		
		if lerp > 0 then
			lerp = Lerp( 0.01, lerp, 0 )
		end
		
		if self.LerpTime ~= 0 then 
			self.LerpTime = 0 
		end	
	end
	
	
	if IsValid( self:GetBossRagdoll() ) and lerp > 0 then
		
		//self:SetRenderBoundsWS( self:GetBossRagdoll():GetPos(), self:GetPos() )
		self:SetRenderBounds( Vector(-2318, -2318, -318), Vector(2318, 2318, 318) )
		
		local rag = self:GetBossRagdoll()
		
		if not self.Offsets then
			self.Offsets = {}
		end
		
		if not self.StartPos then
			self.StartPos = {}
		end
		
		if not self.ShuffleTable then
			self.ShuffleTable = {}
		end
		
		for k, v in pairs( rag:GetAttachments() ) do
			
			local att = rag:GetAttachment( v.id )
			
			if att and att.Pos then
				
				local pos = att.Pos

				if self:GetFinishLevel() then
					
					self.ShuffleTable[ k ] = self.ShuffleTable[ k ] or {}
					
					self.ShuffleTable[ k ].time = self.ShuffleTable[ k ].time or 0
					
					if self.ShuffleTable[ k ].time < CurTime() then
						
						local rand = VectorRand( -250, 250 )
						rand.z = 0
						self.ShuffleTable[ k ].origin = self:GetPos() + rand
						self.ShuffleTable[ k ].time = CurTime() + math.random( 2, 4 )
						
					end
					
					if self.ShuffleTable[ k ].origin then
						pos = self.ShuffleTable[ k ].origin
					end
					
				end
				
				self.StartPos[ k ] = self.StartPos[ k ] or self:NearestPoint( self:GetPos() + VectorRand( -50, 50 ) )
				self.Offsets[ k ] = self.Offsets[ k ] or {}

				local self_pos = self.StartPos[ k ]
				local dir = ( self_pos - pos ):GetNormal()
				
				local bits = 14//math.random( 4, 6 )
				local dist = pos:Distance( self_pos )
				
				
				local prev_pos = self_pos * 1
				local tex_offset
				for i=1, bits do
				
					if i == 1 then
						render.SetMaterial( sprite2 )
						render.DrawSprite( self_pos, 10, 10, col_beam )
					end
					
					render.SetMaterial( dark_beam )
				
					local def = VectorRand( -80 + i*2, 80 - i*2 )
					def.z = math.max( 0, def.z )
					self.Offsets[ k ][ i ] = self.Offsets[ k ][ i ] or def
				
					local cur_pos = prev_pos - dir * ( dist / bits ) * lerp + self.Offsets[ k ][ i ] * lerp
					
					if i == bits then 
						cur_pos = LerpVector( lerp or 1, self.StartPos[ k ], pos * 1 )//pos * 1 
					end
				
					//local draw_cur_pos = LerpVector( lerp or 1, self_pos, cur_pos )
					
					tex_offset = tex_offset or RealTime()*0.6
					
					render.DrawBeam( cur_pos, prev_pos, 24 - i, tex_offset, tex_offset + 0.3, col_beam )
					
					render.SetMaterial( i == bits and sprite1 or sprite2 )
					render.DrawSprite( cur_pos, 6, 6, col_beam )
					
					tex_offset = tex_offset + 0.3
					prev_pos = cur_pos * 1
					
					local goal = VectorRand( -80 + i*2, 80 - i*2 )
					goal.z = math.max( 0, goal.z )
					
					self.Offsets[ k ][ i ].x = math.Approach( self.Offsets[ k ][ i ].x, goal.x, RealFrameTime() * 52 )
					self.Offsets[ k ][ i ].y = math.Approach( self.Offsets[ k ][ i ].y, goal.y, RealFrameTime() * 52 )
					self.Offsets[ k ][ i ].z = math.Approach( self.Offsets[ k ][ i ].z, goal.z, RealFrameTime() * 52 )
					
					//self.Offsets[ k ][ i ] = LerpVector( 0.02, self.Offsets[ k ][ i ], VectorRand( -30 - i, 30 + i ) )  

				end
				
			end
			
		end
	end
	
end

/// a bit lazy copypaste for fake errors to use in the final boss stage
local matAlert = Material( "icon16/error.png" )

local FakeErrors = {}

function ENT:AddFakeError()
	local text = "sog_error_message_someone_creating_errors"

	local error = {
		first	= SysTime(),
		last	= SysTime(),
		times	= 1,
		title	= addontitle,
		x		= 32,
		text	= translate.Get(text)
	}

	FakeErrors[ 0 ] = error
end

hook.Add( "DrawOverlay", "FakeLuaErrors", function()

	if ( table.IsEmpty( FakeErrors ) ) then return end

	local idealy = 32
	local height = 30
	local EndTime = SysTime() - 10
	local Recent = SysTime() - 0.5

	for k, v in SortedPairsByMemberValue( FakeErrors, "last" ) do

		surface.SetFont( "DermaDefaultBold" )
		if ( v.y == nil ) then v.y = idealy end
		if ( v.w == nil ) then v.w = surface.GetTextSize( v.text ) + 48 end

		draw.RoundedBox( 2, v.x + 2, v.y + 2, v.w, height, Color( 40, 40, 40, 255 ) )
		draw.RoundedBox( 2, v.x, v.y, v.w, height, Color( 240, 240, 240, 255 ) )

		if ( v.last > Recent ) then

			draw.RoundedBox( 2, v.x, v.y, v.w, height, Color( 255, 200, 0, ( v.last - Recent ) * 510 ) )

		end

		surface.SetTextColor( 90, 90, 90, 255 )
		surface.SetTextPos( v.x + 34, v.y + 8 )
		surface.DrawText( v.text )

		surface.SetDrawColor( 255, 255, 255, 150 + math.sin( v.y + SysTime() * 30 ) * 100 )
		surface.SetMaterial( matAlert )
		surface.DrawTexturedRect( v.x + 6, v.y + 6, 16, 16 )

		v.y = idealy

		idealy = idealy + 40

		if ( v.last < EndTime ) then
			FakeErrors[k] = nil
		end

	end

end )



end


