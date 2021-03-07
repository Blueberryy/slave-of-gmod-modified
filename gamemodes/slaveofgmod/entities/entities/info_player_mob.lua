ENT.Type = "point"

INFO_PLAYER_MOB = INFO_PLAYER_MOB or {}

if SERVER then
	function ENT:Initialize()
		
		table.insert( INFO_PLAYER_MOB, self )
		
	end
end