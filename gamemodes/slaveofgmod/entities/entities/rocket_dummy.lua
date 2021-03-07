AddCSLuaFile()

ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

if SERVER then
	
function ENT:Initialize()
	
	self:SetModel( "models/weapons/w_missile_launch.mdl" )

	self:PhysicsInit(SOLID_OBB)
	self:SetSolid(SOLID_BBOX)
	self:SetCollisionGroup(COLLISION_GROUP_PUSHAWAY)
	self:SetCollisionBounds( self:OBBMins()*1.1, self:OBBMaxs()*1.1)
	self:DrawShadow( false )
	
	self:SetTrigger( true )
	
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMaterial("material")
		phys:Wake()
	end
	
end

function ENT:Touch ( ent )
	print("touch" ..tostring(ent))
	if ent and ent:IsValid() and ent:IsNextBot() and IsValid( self:GetParent() ) and self:GetParent():Team() ~= ent:Team() then
		self:GetParent():Fire("Kill", "", 0)
		//self:GetParent( "Explode", "", 0)	
	end
end

end

if CLIENT then

function ENT:Draw()
	self:SetModelScale(4, 0)
	self:DrawModel()
end

end