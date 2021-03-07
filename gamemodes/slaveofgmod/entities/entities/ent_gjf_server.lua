AddCSLuaFile()

ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Initialize()
		
	if SERVER then
				
		self:SetModel("models/props_lab/servers.mdl")
		
		self:SetMoveType( MOVETYPE_NONE )
		self:SetSolid( SOLID_VPHYSICS )
		self:PhysicsInit( SOLID_VPHYSICS )
		
		self.health = 400
				
		local phys = self:GetPhysicsObject()
		
		if IsValid(phys) then
			phys:EnableMotion( false )
		end
						
	end
	
	if CLIENT then
		
		self:DrawShadow( false )
		self:SetRenderBounds( Vector(-318, -318, -318), Vector(318, 318, 318) )
		
	end

end

function ENT:SetDestroy( bl )
	self:SetDTBool( 0, bl )
end

function ENT:IsDestroyed()
	return self:GetDTBool( 0 )
end

if SERVER then

function ENT:Reset()
	if not self:IsDestroyed() then return end
	self:SetDestroy( false )
	self:SetSolid( SOLID_VPHYSICS )
	self.health = 400
end

function ENT:SpawnStuff()
	
	local p = ents.Create( "prop_dynamic" )
		p:SetModel( "models/effects/splodeglass.mdl" )
		p:SetPos( Vector( 986.98199462891, -143.90307617188, 130.08470153809 ) )
		p:SetAngles( Angle( 2.2584409657082e-13, -58.251628875732, 3.7145980513742e-06 ) )
		p:Spawn()

	local p = ents.Create( "prop_dynamic" )
		p:SetModel( "models/effects/splodeglass.mdl" )
		p:SetPos( Vector( 1097.4877929688, 655.64422607422, 117.16593170166 ) )
		p:SetAngles( Angle( -2.7325659638679e-13, -156.89965820313, 5.8157038438367e-06 ) )
		p:Spawn()
		
	local p = ents.Create( "prop_dynamic" )
		p:SetModel( "models/effects/splodearc.mdl" )
		p:SetPos( Vector( 1368.3049316406, -827.17468261719, 76.274742126465 - 290 ) )
		p:SetAngles( Angle( 4.4708035423736e-14, -131.68780517578, 7.9168075899361e-06 ) )
		p:SetColor( Color( 200, 100, 100, 255 ) )
		p:Spawn()

	local p = ents.Create( "prop_dynamic" )
		p:SetModel( "models/effects/splodearc.mdl" )
		p:SetPos( Vector( 722.10797119141, -164.16323852539, 183.8451385498 - 290 ) )
		p:SetAngles( Angle( 2.7208647727966, -77.745590209961, -12.954772949219 ) )
		p:SetColor( Color( 200, 100, 100, 255 ) )
		p:Spawn()
		
	local p = ents.Create( "prop_dynamic" )
		p:SetModel( "models/effects/splodearc.mdl" )
		p:SetPos( Vector( 2016.3948974609, -128.25813293457, 57.829090118408 - 290 ) )
		p:SetAngles( Angle( -6.849217414856, 42.303630828857, 5.7061514854431 ) )
		p:SetColor( Color( 200, 100, 100, 255 ) )
		p:Spawn()


end

-- instead of respawning every time player dies, I can just make them invisible and stuff
function ENT:Think()
	
	if IsValid( Entity(1) ) then
	
		-- some hardcoded stuff, because why not
		
		if CUR_STAGE == 3 and not SUPERHOT then
			SUPERHOT = true
			Entity(1):SendLua( "WORLD_OVERRIDE_MAT = GAMEMODE.WorldMaterials[1]" )
			Entity(1):EmitSound( "npc/stalker/breathing3.wav" )
			Entity(1):SendLua( "BLACK_BLOOD = true" )
			Entity(1):SendLua( "SCENE.MusicPlayback = 1" )
			Entity(1):SendLua( "UPDATE_PLAYBACK = true" )

			Entity(1):ScreenFade( SCREENFADE.IN, Color( 255, 255, 255, 255 ), 0.5, 0.2 )
			Entity(1):SetFlipView( true )
			Entity(1):ShakeView( math.random(5,10), 0.7)
			
			self:SpawnStuff()
			
		end
		
		if GAMEMODE:GetRoundState() == ROUNDSTATE_RESTARTING and not SPAWNED_PORTAL then
			SPAWNED_PORTAL = true
			local e = EffectData()
				e:SetOrigin( Vector( 734.43963623047, -90.30615234375, 72.395240783691 ) )
				e:SetMagnitude( math.random( 1200, 1400 ) )
			util.Effect( "refract_effect", e, nil, true )
			
			local p = ents.Create( "prop_dynamic" )
				p:SetModel( "models/effects/portalrift.mdl" )
				p:SetPos( Vector( 734.43963623047, -90.30615234375, 72.395240783691 ) )
				p:SetAngles( Angle( 3.4580368719617e-06, -179.33985900879, 180 ) )
				p:SetModelScale( 0.1, 0 )
			p:Spawn()
			
			
		end
		
		
		
		if Entity(1):Alive() then
			if self.CanReset then
				self.CanReset = false
				self:Reset()
			end
		else
			if not self.CanReset then
				self.CanReset = true
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
	
	if self:IsDestroyed() then return end
	
	local attacker = dmginfo:GetAttacker()
	local inflictor = dmginfo:GetInflictor()
	local isblast = dmginfo:IsDamageType( DMG_BLAST ) // prevent calling TakeDamage on itself
	
	if IsValid( attacker ) and ( attacker:IsPlayer() or attacker:IsNextBot() ) and not isblast then
					
		self.health = self.health - dmginfo:GetDamage()
		
		self:EmitSound("physics/metal/metal_box_break"..math.random(2)..".wav",100, math.Rand(95, 130)) 
				
		if self.health <= 0 then
			local e = EffectData()
				e:SetOrigin( self:GetPos() + vector_up*40 )
				e:SetScale( 2 )
			util.Effect( "Explosion", e, nil, true )	

			if SUPERHOT and game.GetTimeScale() < 1 then
				local e = EffectData()
					e:SetOrigin( self:GetPos() + vector_up*40 )
					e:SetMagnitude( math.random( 500, 700 ) )
				util.Effect( "refract_effect", e, nil, true )
			end
			
			if GAMEMODE:GetRoundState() ~= ROUNDSTATE_RESTARTING then
			
				util.BlastDamage( self, attacker, self:GetPos() + vector_up*40, 200, 330 )
			
			end
			
			self:SetDestroy( true )
			self:SetSolid( SOLID_NONE )

		end
		
	end

end
end

if CLIENT then
function ENT:Draw()
	if self:IsDestroyed() then return end
	self:DrawModel()
end
end