ENT.Type = "point"

INFO_PLAYER_MAIN = INFO_PLAYER_MAIN or {}

if SERVER then
	function ENT:Initialize()
		
		table.insert( INFO_PLAYER_MAIN, self )
		
	end
end