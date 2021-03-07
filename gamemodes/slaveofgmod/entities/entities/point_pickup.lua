ENT.Type = "point"

if SERVER then

POINT_PICKUPS = POINT_PICKUPS or {}

function ENT:Initialize()
	
	table.insert( POINT_PICKUPS, self )
	
	if GAMEMODE:GetGametype() == "drama" then return end
	if NO_PICKUPS then return end
	
	self:SpawnRandomPickup()
	self:Fire("CheckPickups", "", PICKUP_RESPAWN_TIME or 20)
	
end

function ENT:SpawnRandomPickup()
	
	if GAMEMODE.PickupWeapons then
		local wepclass = GAMEMODE.PickupWeapons[ math.random( #GAMEMODE.PickupWeapons ) ]
		local pr = ents.Create( "dropped_weapon" )
			pr:SetPos( self:GetPos() + vector_up * 15 )
			//pr:SetAngles( prop:GetAngles() )
			pr:SpawnAsWeapon( wepclass )
			pr.NoKnockback = false
			pr.MapBased = true
		pr:Spawn()
		self.Pickup = pr
		pr.SpawnEntity = self
		local phys = pr:GetPhysicsObject()
		if IsValid(phys) then
			phys:SetVelocityInstantaneous( vector_up * 130 )
		end
	end
	
end

function ENT:AcceptInput(name, activator, caller, args)
	name = string.lower(name)
	if name == "checkpickups" then
		self:CheckPickups()
	end
end

function ENT:CheckPickups()
	
	if IsValid(self.Pickup) then
		self:Fire("CheckPickups", "", PICKUP_RESPAWN_TIME or 20)
	else
		if ACTIVE_PICKUPS < GAMEMODE:GetMaxPickupAmount() then
			self:SpawnRandomPickup()
			self:Fire("CheckPickups", "", PICKUP_RESPAWN_TIME or 25)
		else
			self:Fire("CheckPickups", "", PICKUP_RESPAWN_TIME or 10)
		end
	end

end

function ENT:ResetPickups()
	
	if IsValid(self.Pickup) then
		
		self.Pickup:Remove()
		
		self:SpawnRandomPickup()
		self:Fire("CheckPickups", "", PICKUP_RESPAWN_TIME or 20)
	
	end
	
end

end