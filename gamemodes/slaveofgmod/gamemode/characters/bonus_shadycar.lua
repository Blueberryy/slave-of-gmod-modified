CHARACTER.Reference = "shady car"

CHARACTER.Name = "Shady car"
CHARACTER.Description = "Honk honk."

CHARACTER.Health = 100
CHARACTER.Speed = 380

CHARACTER.Speed = 0
CHARACTER.StartingWeapon = "sogm_fists"

CHARACTER.DontAttack = true
CHARACTER.HideOriginalModel = true
CHARACTER.NoLights = true

CHARACTER.Model = Model( "models/player/breen.mdl" )

CHARACTER.Icon = Material( "sog/shadydriver.png", "smooth" )

CHARACTER.GametypeSpecific = "singleplayer"

util.PrecacheModel( "models/props/de_nuke/car_nuke_black.mdl" )

function CHARACTER:OnSpawn( pl )
	
	/*local car = ents.Create( "prop_physics" )
	car:SetModel( "models/props/de_nuke/car_nuke_black.mdl" )
	car:SetPos( pl:GetPos() )
	car:SetAngles( pl:GetAngles() )
	car:SetCollisionGroup( COLLISION_GROUP_PLAYER  )
	pl:SetParent( car )
	car:Spawn()
	
	pl:DeleteOnRemove( car )*/
	
	
	
	local car = ents.Create( "ent_shadycar" )
	car:SetPos( pl:GetPos() + vector_up * 7 )
	car:SetAngles( pl:GetAngles() )
	//pl:SetParent( car )
	car:Spawn()
	car:Activate()
	
	pl:DeleteOnRemove( car )
		
	car:SetOwner( pl )
	
	//pl.DebugPath = true
	
	pl.ChaseDistance = 4000
	pl.IdleSpeed = pl.WalkSpeed
	pl.DOTCheck = 1
	
	pl.Pursuit = Entity(1)
	
	pl:AddEffects( EF_NODRAW )
	
	pl:SetSolid( SOLID_NONE )
	//pl:SetMoveType( MOVETYPE_NONE )
	
	pl.OverrideRepath = 0.1
	
	local mins, maxs = car:OBBMins(), car:OBBMaxs()
		
	pl:SetCollisionBounds( Vector( -43, -43, 0 ), Vector( 43, 44, 62 ) )
	
	pl:SetNextBotColor( Color( 20, 20, 20 ) )
	
end
