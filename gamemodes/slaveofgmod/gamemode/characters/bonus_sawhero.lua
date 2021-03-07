CHARACTER.Reference = "saw hero"

CHARACTER.Name = "Saw Hero"
CHARACTER.Description = "You called it"

CHARACTER.Health = 100
CHARACTER.Speed = 380

CHARACTER.Model = Model( "models/player/group01/male_07.mdl" )
CHARACTER.StartingWeapon = "sogm_napalmthrower"

CHARACTER.InfiniteAmmo = true 

CHARACTER.Icon = Material( "sog/sawhero.png", "smooth" )
CHARACTER.KnockdownImmunity = true

CHARACTER.GametypeSpecific = "singleplayer"
CHARACTER.NoMenu = true

CHARACTER.WElements = {
	["earphones"] = { type = "Model", model = "models/player/items/engineer/engy_earphones.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-67.805, 12.517, 0), angle = Angle(0, -81.436, -90), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["shades"] = { type = "Model", model = "models/player/items/demo/ttg_glasses.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(1.179, -0.447, 0.15), angle = Angle(0, -90, -90), size = Vector(0.949, 0.949, 0.949), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

function CHARACTER:OnSpawn( pl )
	if pl:IsNextBot() then
		pl:SetNextBotColor( Color( 208, 43, 46 ) )
	end
	
	//pl.Pursuit = Entity(1)
	pl.ChaseDistance = 3000
	
end

function CHARACTER:OnThink( pl )
	
	if pl:GetBehaviour() == BEHAVIOUR_DUMB then
		pl.Pursuit = nil
	else
		pl.Pursuit = Entity(1)
	end

end

function CHARACTER:PreOnDeath( pl, attacker, dmginfo )

	if pl:GetActiveWeapon() and pl:GetActiveWeapon():IsValid() and pl:GetActiveWeapon():GetClass() == "sogm_napalmthrower" then
		
		local e = EffectData()
			e:SetOrigin( pl:GetShootPos() )
			e:SetScale( 1 )
		util.Effect( "Explosion", e, nil, true )
		
		local e = EffectData()
			e:SetOrigin( pl:GetShootPos() )
			e:SetScale( 1 )
		util.Effect( "HelicopterMegaBomb", e, nil, true )
		
		pl.DoExplosion = true
		
		//util.BlastDamage( Entity(1), Entity(1), pl:GetShootPos(), 250, 330 )
		
		//util.BlastDamage( pl, pl, pl:GetShootPos(), 250, 330 )
	end
	
end

function CHARACTER:OnDeath( pl, attacker, dmginfo )

	if pl.DoExplosion then
		
		local pos = pl:GetShootPos() 
		
		timer.Simple( 0, function()
			if pl and pos then
				util.BlastDamage( Entity(1), Entity(1), pos, 130, 330 )
			end
		end)
		
		//util.BlastDamage( pl, pl, pl:GetShootPos(), 250, 330 )
	end
	
end
