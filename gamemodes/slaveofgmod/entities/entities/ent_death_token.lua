AddCSLuaFile()

ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_BOTH

ENT.AnimDuration = 1.2

util.PrecacheSound( "physics/surfaces/underwater_impact_bullet1.wav" )
util.PrecacheSound( "physics/surfaces/underwater_impact_bullet2.wav" )
util.PrecacheSound( "physics/surfaces/underwater_impact_bullet3.wav" )

function ENT:Initialize()
	
	self:SetModel("models/player/group03/male_03.mdl")
	
	self:ResetSequence( "seq_preskewer" )
	
	if SERVER then

		self:SetMoveType( MOVETYPE_NONE )
		self:SetSolid( SOLID_NONE )
		
		local start_length = 16
		local end_length = 6
		
		for k, v in pairs( self:GetAttachments() ) do
			util.SpriteTrail( self, v.id, Color( 20, 20, 20, math.random( 190, 200 ) ), true, start_length, end_length, math.Rand( 0.3, 0.7 ), 1 / ( start_length + end_length ) * 0.5, "Effects/bloodstream.vmt")
		end
			
	end
	
	if CLIENT then
		
		self:DrawShadow( false )
		self:SetRenderBounds( Vector(-318, -318, -318), Vector(318, 318, 318) )
		
	end

end

function ENT:SetDieTime( tm )
	self:SetDTFloat( 0, tm + self.AnimDuration )
end

function ENT:GetDieTime()
	return self:GetDTFloat( 0 )
end

local mins = Vector( -24, -24, 0 )
local maxs = Vector( 24, 24, 82 )

function ENT:Think()
	
	if SERVER then
		local objects = ents.FindInBox( self:GetPos() + mins, self:GetPos() + maxs )
		
		for k = 1, #objects do
			local v = objects[k]
			if v and v:IsValid() and v:GetClass() == "sogm_bullet" and v:GetOwner() == Entity(1) and not v.Cursed then
				self:EmitSound( "physics/surfaces/underwater_impact_bullet"..math.random( 3 )..".wav", math.random(70,80), math.random(100, 115) )
				v.Cursed = true
			end
		end
		
	end
	
	self:NextThink( CurTime() )
	return true
end

if CLIENT then

local goop_mat = CreateMaterial( "coffin3",
    "VertexLitGeneric",
    {
        ["$basetexture"] = "Models/flesh",
        ["$bumpmap"] = "models/flesh_nrm",
        ["$nodecal"] = "0",
        ["$halflambert"] = 1,
        ["$translucent"] = 1,
        ["$model"] = 1,

        ["$detail"] = "Models/flesh",
        ["$detailscale"] = 1.2,
        ["$detailblendfactor"] = 7,
        ["$detailblendmode"] = 3,

        ["$phong"] = "1",
        ["$phongboost"] = "5",
        ["$phongfresnelranges"] = "[10 3 10]",
        ["$phongexponent"] = "500"
    }
)

local goop_mat2 = CreateMaterial( "coffin4",
    "VertexLitGeneric",
    {
        ["$basetexture"] = "Models/flesh",
        ["$bumpmap"] = "models/flesh_nrm",
        ["$nodecal"] = "0",
        ["$halflambert"] = 1,
        ["$translucent"] = 1,
        ["$model"] = 1,

        ["$detail"] = "Models/flesh",
        ["$detailscale"] = 1.2,
        ["$detailblendfactor"] = 7,
        ["$detailblendmode"] = 3,

        ["$phong"] = "1",
        ["$phongboost"] = "5",
        ["$phongfresnelranges"] = "[10 3 10]",
        ["$phongexponent"] = "500"
    }
)

local mat = Material( "models/spawn_effect2" )

local dev_mat = Material( "!devwall_model" )

function ENT:Draw()
	
	local cycle = math.Clamp( 1 - ( self:GetDieTime() - CurTime() ) / self.AnimDuration, 0, 1 )
	
	local pos = self:GetPos()
	
	self:SetCycle( cycle )
	
	if cycle < 1 then
		self:DrawModel()
	end
	
	render.MaterialOverride( dev_mat )
	render.SetBlend( cycle )
	self:DrawModel()
	render.SetBlend( 1 )
	render.MaterialOverride()
	
	//self:SetPos( pos + VectorRand( -1, 1 ) * cycle )
	
	goop_mat:SetFloat( "$detailscale", 1 + math.sin(RealTime() * 0.2) * 0.9 )
	
	render.MaterialOverride( goop_mat )
	render.SetColorModulation( 0, 0, 0 )
	render.SetBlend( cycle )
	self:DrawModel()
	render.SetBlend( 1 )
	render.SetColorModulation( 1, 1, 1 )
	render.MaterialOverride()
	
	goop_mat2:SetFloat( "$detailscale", 1 + math.cos(RealTime() * 0.2) * 0.9 )
	
	render.MaterialOverride( goop_mat2 )
	render.SetColorModulation( 0, 0, 0 )
	render.SetBlend( cycle )
	self:DrawModel()
	render.SetBlend( 1 )
	render.SetColorModulation( 1, 1, 1 )
	render.MaterialOverride()
	
	//self:SetPos( pos )
	
	
end
end