ENT.Type = "point"

if SERVER then

POINT_SECURE = POINT_SECURE or {}

function ENT:Initialize()
	
	table.insert( POINT_SECURE, self )
	
	if GAMEMODE:GetGametype() == "axecution" then 
		//self:SpawnSecure()
		return 
	end
	
	if GAMEMODE:GetGametype() == "drama" and ACTIVE_SECURE_ENTS < 1 then 
		return 
	end
	
	

end

function ENT:SpawnSecure()
	
	if !IsValid( self.Secure ) then
		local pr = ents.Create( OBJECTIVE_CLASS or "ent_secure" )
		pr:SetPos( self:GetPos() + (OBJECTIVE_CLASS == "ent_secure" and vector_up * 50 or vector_origin) )
		pr:Spawn()
		self.Secure = pr
		pr.SpawnPoint = self
	end
		
end

function ENT:AcceptInput(name, activator, caller, args)
	name = string.lower(name)
	if name == "spawn" then
		self:SpawnSecure()
	end
end

function ENT:RespawnSecure( removeonly, class )
	
	if IsValid( self.Secure ) then
		self.Secure:Remove()
		self.Secure = nil
	end
	if not removeonly then
		self:Fire("spawn", "", 0.1)
	end

end

end