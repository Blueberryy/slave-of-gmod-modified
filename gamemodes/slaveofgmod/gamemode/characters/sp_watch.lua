CHARACTER.Reference = "watch"

CHARACTER.Name = "Watch"
CHARACTER.Description = "The Cure."

CHARACTER.Health = 100
CHARACTER.Speed = 400

CHARACTER.GametypeSpecific = "singleplayer"

CHARACTER.Icon = Material( "sog/watch.png", "smooth" )

CHARACTER.Model = Model( "models/player/magnusson.mdl" )

if SCENE and SCENE.Name == "legacy" then
	CHARACTER.StartingWeapon = "sogm_villainchair"
end

CHARACTER.WElements = {
	//["glasses"] = { type = "Model", model = "models/player/items/heavy/cop_glasses.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(-1.724, 0.032, 0.01), angle = Angle(0, -69.825, -90), size = Vector(0.949, 0.949, 0.949), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
}

/*
CHARACTER.Styles = {
	{ 	
		Name = "12 a.m.", 
		Description = "",
		Icon = Material( "sog/watch.png", "smooth" ),
		func = function( pl ) 
			pl:Give("sogm_magnum") 
			pl:SelectWeapon("sogm_magnum") 
		end },
	{ 
		Name = "Hero", 
		Description = "",
		Icon = Material( "sog/watch.png", "smooth" ),
		func = function( pl ) 
			pl:Give("sogm_villainchair") 
			pl:SelectWeapon("sogm_villainchair") 
		end },
}*/

local bones = {}

bones[ "ValveBiped.Bip01_Head1" ] = { scale = Vector( 0.001, 0.001, 0.001 ) }
bones[ "ValveBiped.Bip01_Spine1" ] = { scale = Vector( 1.2, 1.2, 1.2 ) }
bones[ "ValveBiped.Bip01_Spine2" ] = { scale = Vector( 1.3, 1.3, 1.3 ) }
bones[ "ValveBiped.Bip01_L_Forearm" ] = { scale = Vector( 1.5, 1.5, 1.5 ) }
bones[ "ValveBiped.Bip01_R_Forearm" ] = { scale = Vector( 1.5, 1.5, 1.5 ) }
bones[ "ValveBiped.Bip01_R_UpperArm" ] = { scale = Vector( 1.5, 1.5, 1.5 ) }
bones[ "ValveBiped.Bip01_L_UpperArm" ] = { scale = Vector( 1.5, 1.5, 1.5 ) }


function CHARACTER:OnSpawn( pl )
	local armor = pl:SpawnBodywear( "models/player/magnusson.mdl" )	
end



function CHARACTER:ArmorBoneScaling( ent )
	
	for k, v in pairs( bones ) do
		local bone = ent:LookupBone( k )
		if bone then
			if v.ang then
				if ent:GetManipulateBoneAngles( bone ) ~= v.ang then
					ent:ManipulateBoneAngles( bone, v.ang  )
				end
			end
			if v.scale then
				if ent:GetManipulateBoneScale( bone ) ~= v.scale then
					ent:ManipulateBoneScale( bone, v.scale  )
				end
			end
		end
	end
	
end

//models/player/group01/female_02.mdl
//SetSubMaterial( 2, "models/gman/gman_facehirez" )


