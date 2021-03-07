ENT.Base = "base_brush"
ENT.Type = "brush"

local mins = Vector(-100,-100,0)
local maxs = Vector(100,100,30)

TRIGGERS = TRIGGERS or {}

function ENT:Initialize() 
	
	TRIGGER_NEXTLEVEL = self
	
    self:SetSolid( SOLID_BBOX )   
    self:SetCollisionBounds( mins, maxs)
    self:SetTrigger(true)
	
	TRIGGERS[ tostring(self) ] = self
	
	self.Active = false
end

function ENT:StartTouch( ent )

	if GAMEMODE:GetRoundState() == ROUNDSTATE_RESTARTING then
		self.Active = true
	end
		
	if not self.Active then return end
	if ent and ent:IsValid() and ent:IsPlayer() then
		if not self.Activated then
			GAMEMODE:LoadNextLevel()
			self.Activated = true
		end
	end
	
end

function ENT:OnRemove()

	if TRIGGERS[ tostring(self) ] then
		TRIGGERS[ tostring(self) ] = nil
	end
	
end

function ENT:SetSize( size )
	self:SetCollisionBounds( Vector( -size, -size, 0 ), Vector( size, size, 30 ) )
end