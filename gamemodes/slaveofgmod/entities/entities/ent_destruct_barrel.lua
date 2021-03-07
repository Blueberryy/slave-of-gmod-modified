AddCSLuaFile()

ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Initialize()
	
	self:SetModel("models/props/de_train/processor_nobase.mdl") //models/props/de_train/barrel.mdl
	//self:SetModelScale( 1.2, 0 )
	
	if SERVER then

		self:SetMoveType( MOVETYPE_NONE )
		self:SetSolid( SOLID_BBOX )
		self:PhysicsInit( SOLID_BBOX )
						
		local phys = self:GetPhysicsObject()
		
		if IsValid(phys) then
			phys:EnableMotion( false )
		end
		
		self:SetInteractable( false )
		self:SetDestroy( false )
						
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

function ENT:SetInteractable( bl )
	self:SetDTBool( 1, bl )
end

function ENT:IsInteractable()
	return self:GetDTBool( 1 )
end

if SERVER then

function ENT:Reset()
	if not self:IsDestroyed() then return end
	self:SetDestroy( false )
	self:SetSolid( SOLID_BBOX )
end

function ENT:Think()
	
	if IsValid( Entity(1) ) then
			
		if CUR_STAGE == 2 and not self:IsInteractable() and GAMEMODE:GetRoundState() ~= ROUNDSTATE_RESTARTING then
			self:SetInteractable( true )
		end
		
		if GAMEMODE:GetRoundState() == ROUNDSTATE_RESTARTING and self:IsInteractable() then
			self:SetInteractable( false )
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
	if not self:IsInteractable() then return end
	
	local attacker = dmginfo:GetAttacker()
	local inflictor = dmginfo:GetInflictor()
	local isblast = dmginfo:IsDamageType( DMG_BLAST ) // prevent calling TakeDamage on itself
	
	if IsValid( attacker ) and ( attacker:IsPlayer() or attacker:IsNextBot() ) and not isblast then
							
		self:EmitSound("physics/metal/metal_box_break"..math.random(2)..".wav",100, math.Rand(95, 130)) 
				
		local e = EffectData()
			e:SetOrigin( self:GetPos() + vector_up*10 )
			e:SetScale( 4 )
		util.Effect( "Explosion", e, true, true )	
		
		local e = EffectData()
			e:SetOrigin( self:GetPos() )
			e:SetNormal( vector_origin )
		util.Effect("explosion_huge", e, nil, true)

		util.BlastDamage( self, attacker, self:GetPos() + vector_up*40, 150, 330 )
			
		self:SetDestroy( true )
		self:SetSolid( SOLID_NONE )

		if attacker:IsNextBot() then
			attacker:DoKnockdown( 3, true, attacker )
			attacker:EmitSound( "vo/npc/male01/pain0"..math.random( 7, 9 )..".wav", 75, math.random( 70, 80 ) )
		end
		
	end

end
end

if CLIENT then

local mat = Material( "models/spawn_effect2" )

function ENT:Draw()
	if self:IsDestroyed() then return end
	self:DrawModel()
	
	if self:IsInteractable() then
		
		render.ModelMaterialOverride( mat )
		render.SetBlend( 0.8 )
		//render.SetColorModulation( 1, 0, 0 )
		self:DrawModel()
		//render.SetColorModulation( 1, 1, 1 )
		render.SetBlend( 1 )
		render.ModelMaterialOverride( )
		
	end
	
end
end
