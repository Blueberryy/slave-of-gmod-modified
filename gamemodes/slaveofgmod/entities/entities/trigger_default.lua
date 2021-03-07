ENT.Base = "base_brush"
ENT.Type = "brush"

TRIGGERS = TRIGGERS or {}

local mins = Vector(-100,-100,0)
local maxs = Vector(100,100,30)

function ENT:Initialize() 
    self:SetSolid( SOLID_BBOX )   
    self:SetCollisionBounds(mins, maxs)
    self:SetTrigger(true)
	
	TRIGGERS[ tostring(self) ] = self
	
	self.Active = true
	
end

function ENT:StartTouch( ent )
	if not self.Active then return end
	if ent and ent:IsValid() and ent:IsPlayer() then
		if not self.Activated then
			self:Trigger( ent )
			self.Activated = true
		end
	end
	
end

function ENT:OnRemove()

	if TRIGGERS[ tostring(self) ] then
		TRIGGERS[ tostring(self) ] = nil
	end
	
end

function ENT:Trigger( ent )

end

function ENT:SetSize( size )
	self:SetCollisionBounds( Vector( -size, -size, 0 ), Vector( size, size, 30 ) )
end