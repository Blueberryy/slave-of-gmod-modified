ENT.Type = "point"

POINT_SERVER = POINT_SERVER or {}

if SERVER then
	function ENT:Initialize()
		table.insert( POINT_SERVER, self )
	end
end