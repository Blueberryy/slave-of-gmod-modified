CHARACTER.Reference = "mutilated admin"

CHARACTER.Name = "Mutilated Admin"
CHARACTER.Description = ""

CHARACTER.Health = 1
CHARACTER.Speed = 380

CHARACTER.AddComboWindow = 2
CHARACTER.ThrowMultiplier = 0.6

CHARACTER.NoMenu = true

CHARACTER.Model = Model( "models/player/zombie_soldier.mdl" )

function CHARACTER:OnSpawn( pl )
	if math.random(2) == 2 then
		pl:SetMaterial( "models/zombie_classic/zombie_players_sheet" )
	else
		pl:SetMaterial( "models/zombie_fast_players/fast_zombie_sheet" )
	end
	//local armor = pl:SpawnBodywear( "models/player/zombie_fast.mdl" )
end