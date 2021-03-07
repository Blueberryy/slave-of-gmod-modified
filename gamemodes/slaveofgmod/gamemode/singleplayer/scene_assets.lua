//small file where I can add certain props and shit to scenes. ideally I'd like to have this feature in editor, but that's probably never gonna happen.
if CLIENT then return end

GM.SceneAssets = {}

GM.SceneAssets["scene_name_legacy"] = function()
	
	//pole
	local p = ents.Create( "prop_dynamic" )
	p:SetModel( "models/props_docks/dock01_pole01a_128.mdl" )
	p:SetPos( Vector( 675.32781982422, -49.601287841797, 64.750198364258 ) )
	p:SetAngles( Angle( 0.12942345440388, -44.910659790039, 0.066694773733616 ) )
	p:Spawn()
	p:Ignite( 9999999999, 0 )
	
	//dude
	local p = ents.Create( "prop_dynamic" )
	p:SetModel( "models/player/kleiner.mdl" )
	p:SetPos( Vector( 683.88610839844, -61.673572540283, 31.824758529663 ) )
	p:SetAngles( Angle( 5.2530612945557, -46.347793579102, -1.9484558105469 ) )
	p:Spawn()
	p:SetMaterial( "models/charple/charple1_sheet" )
	p:SetSequence( p:LookupSequence("drive_pd") )
	p:Ignite( 9999999999, 0 )
	
	//junk1
	local p = ents.Create( "prop_dynamic" )
	p:SetModel( "models/props_c17/furniturechair001a.mdl" )
	p:SetPos( Vector( 677.25396728516, -73.978477478027, 21.352708816528 ) )
	p:SetAngles( Angle( -43.394775390625, -89.728210449219, 0.57059669494629 ) )
	p:Spawn()
	p:SetHealth( 9999999 )
	p:Ignite( 9999999999, 0 )
	
	//junk2
	local p = ents.Create( "prop_dynamic" )
	p:SetModel( "models/props_c17/furnituredrawer003a.mdl" )
	p:SetPos( Vector( 704.21624755859, -69.696235656738, 22.654413223267 ) )
	p:SetAngles( Angle( -31.041431427002, -25.633020401001, 0.087211027741432 ) )
	p:Spawn()
	p:SetHealth( 9999999 )
	p:Ignite( 9999999999, 0 )
	
	//junk3
	local p = ents.Create( "prop_dynamic" )
	p:SetModel( "models/props_c17/furnituretable003a.mdl" )
	p:SetPos( Vector( 705.69317626953, -40.439907073975, 29.062671661377 ) )
	p:SetAngles( Angle( -0.039469916373491, 94.292739868164, -118.94117736816 ) )
	p:Spawn()
	p:SetHealth( 9999999 )
	p:Ignite( 9999999999, 0 )
	
end

GM.SceneAssets["scene_name_big_server_men"] = function()
	
	local p = ents.Create( "prop_dynamic_override" )
	p:SetModel( "models/props_junk/TrashDumpster01a.mdl" )
	p:SetPos( Vector( 3912.073242, 2378.987305, 26.34972 ) )
	p:SetAngles( Angle( -0.154, -89.148, 0.040 ) )
	p:SetKeyValue("solid", "6")
	p:Spawn()
	
	GAMEMODE:BlockNavAreas( p )
	
	local p = ents.Create( "prop_dynamic_override" )
	p:SetModel( "models/props_junk/TrashDumpster01a.mdl" )
	p:SetPos( Vector( 4020.047119, 2386.536865, 25.482080 ) )
	p:SetAngles( Angle( 0.036, 92.247, 0.003 ) )
	p:SetKeyValue("solid", "6")
	p:Spawn()
	
	GAMEMODE:BlockNavAreas( p )
	
	local p = ents.Create( "prop_dynamic_override" )
	p:SetModel( "models/props_junk/TrashBin01a.mdl" )
	p:SetPos( Vector( 4096.624512, 2307.608398, 22.240061 ) )
	p:SetAngles( Angle( 86.493, -94.617, -4.177 ) )
	p:SetKeyValue("solid", "6")
	p:Spawn()
	
	GAMEMODE:BlockNavAreas( p )
	
	local p = ents.Create( "prop_dynamic_override" )
	p:SetModel( "models/props_vehicles/car004a_physics.mdl" )
	p:SetPos( Vector( 3956.974609, 2863.574951, 29.722397 ) )
	p:SetAngles( Angle( -1.731, -178.556, 1.338 ) )
	p:SetKeyValue("solid", "6")
	p:Spawn()
	
	GAMEMODE:BlockNavAreas( p )
	
	local p = ents.Create( "prop_dynamic_override" )
	p:SetModel( "models/props_junk/TrashBin01a.mdl" )
	p:SetPos( Vector( 3894.906250, 1435.275757, 20.468857 ) )
	p:SetAngles( Angle( 0.209, -156.751, 0.000 ) )
	p:SetKeyValue("solid", "6")
	p:Spawn()
	
	GAMEMODE:BlockNavAreas( p )
	
	
end

GM.SceneAssets["scene_name_served_cold"] = function()
	
	GAMEMODE.MapProps = {} //small hack to let use fire lasers through these props
	
	local p = ents.Create( "prop_dynamic" )
	p:SetModel( "models/props_c17/lockers001a.mdl" )
	p:SetPos( Vector( 736.72821044922, -480.4196472168, 35.971927642822 ) )
	p:SetAngles( Angle( -0.0017138654366136, -40.712043762207, 0.00047896141768433 ) )
	p:SetKeyValue("solid", "6")
	p:Spawn()
	
	table.insert( GAMEMODE.MapProps, p )

	
	local p = ents.Create( "prop_dynamic" )
	p:SetModel( "models/props_wasteland/kitchen_fridge001a.mdl" )
	p:SetPos( Vector( 744.61248779297, -356.64779663086, 8.8201484680176 ) )
	p:SetAngles( Angle( -20.655876159668, -63.676239013672, 0.0010574976913631 ) )
	p:SetKeyValue("solid", "6")
	p:Spawn()
	
	table.insert( GAMEMODE.MapProps, p )
	
	local p = ents.Create( "prop_dynamic" )
	p:SetModel( "models/props_wasteland/kitchen_counter001c.mdl" )
	p:SetPos( Vector( 721.38299560547, -172.09703063965, 20.372993469238 ) )
	p:SetAngles( Angle( 0.043733257800341, -27.911993026733, -0.016143798828125 ) )
	p:SetKeyValue("solid", "6")
	p:Spawn()
	
	table.insert( GAMEMODE.MapProps, p )
	
	local p = ents.Create( "prop_dynamic" )
	p:SetModel( "models/props_c17/furniturecouch001a.mdl" )
	p:SetPos( Vector( 869.22393798828, 33.363891601563, 37.843055725098 ) )
	p:SetAngles( Angle( -0.31950724124908, -89.624900817871, -94.936492919922 ) )
	p:SetKeyValue("solid", "6")
	p:Spawn()
	
	table.insert( GAMEMODE.MapProps, p )
	
	local p = ents.Create( "prop_dynamic" )
	p:SetModel( "models/props_interiors/vendingmachinesoda01a.mdl" )
	p:SetPos( Vector( 1310.3482666016, 52.778205871582, 22.420015335083 ) )
	p:SetAngles( Angle( -89.235054016113, -89.577499389648, -45.868865966797 ) )
	p:SetKeyValue("solid", "6")
	p:Spawn()
	
	table.insert( GAMEMODE.MapProps, p )	

	local p = ents.Create( "prop_dynamic" )
	p:SetModel( "models/props_wasteland/laundry_washer003.mdl" )
	p:SetPos( Vector( 1587.2966308594, -389.18078613281, 41.586544036865 ) )
	p:SetAngles( Angle( 0.0045292982831597, 112.5764541626, 7.0534615516663 ) )
	p:SetKeyValue("solid", "6")
	p:Spawn()
	
	table.insert( GAMEMODE.MapProps, p )
	
	local p = ents.Create( "prop_dynamic" )
	p:SetModel( "models/props_wasteland/laundry_washer001a.mdl" )
	p:SetPos( Vector( 1572.2661132813, -490.17123413086, 45.806396484375 ) )
	p:SetAngles( Angle( 1.3715226650238, -179.71215820313, 5.3573923110962 ) )
	p:SetKeyValue("solid", "6")
	p:Spawn()
	
	table.insert( GAMEMODE.MapProps, p )

	local p = ents.Create( "prop_dynamic" )
	p:SetModel( "models/props_wasteland/kitchen_stove001a.mdl" )
	p:SetPos( Vector( 1357.9725341797, -797.79571533203, -3.6875736713409 ) )
	p:SetAngles( Angle( -0.22985796630383, 81.942817687988, 0.0015973976114765 ) )
	p:SetKeyValue("solid", "6")
	p:Spawn()
	
	table.insert( GAMEMODE.MapProps, p )
	
	local p = ents.Create( "prop_dynamic" )
	p:SetModel( "models/props_wasteland/kitchen_counter001b.mdl" )
	p:SetPos( Vector( 1004.3233032227, -807.88232421875, 20.485822677612 ) )
	p:SetAngles( Angle( -0.0042239911854267, 62.912601470947, -0.034088134765625 ) )
	p:SetKeyValue("solid", "6")
	p:Spawn()
	
	table.insert( GAMEMODE.MapProps, p )
		
	local p = ents.Create( "prop_dynamic" )
	p:SetModel( "models/gibs/antlion_gib_large_3.mdl" )
	p:SetPos( Vector( 1512.4541015625, -463.33697509766, 7.3432884216309 ) )
	p:SetAngles( Angle( -43.907970428467, 120.71269989014, -0.16839599609375 ) )
	p:Spawn()
	
	table.insert( GAMEMODE.MapProps, p )
	
	local p = ents.Create( "prop_dynamic" )
	p:SetModel( "models/gibs/antlion_gib_medium_2.mdl" )
	p:SetPos( Vector( 1516.1978759766, -399.01364135742, 2.4730951786041 ) )
	p:SetAngles( Angle( 0.22283294796944, 96.033416748047, -0.2841796875 ) )
	p:Spawn()

	table.insert( GAMEMODE.MapProps, p )

	
	local p = ents.Create( "ent_bsm_laser" )
	p:SetPos( Vector( 1685.3778076172, 130.98846435547, 137.11059570313 ) )
	p:SetAngles( Angle( -2.6462552635276e-11, 44.999725341797, 180 ) )
	p:SetLaserID( 1 )
	p:Spawn()
	
	p.PropFilter = GAMEMODE.MapProps
	
	local p = ents.Create( "ent_bsm_laser" )
	p:SetPos( Vector( 649.15130615234, 144.73190307617, 135.16737365723 ) )
	p:SetAngles( Angle( -3.7581803988274e-12, 134.99995422363, 180 ) )
	p:SetLaserID( 2 )
	p:Spawn()
	
	p.PropFilter = GAMEMODE.MapProps
	
	local p = ents.Create( "ent_bsm_laser" )
	p:SetPos( Vector( 614.94879150391, -899.50030517578, 138.20658874512 ) )
	p:SetAngles( Angle( -3.3871984328471e-08, -135, 180 ) )
	p:SetLaserID( 3 )
	p:Spawn()
	
	p.PropFilter = GAMEMODE.MapProps	
	
	local p = ents.Create( "ent_bsm_laser" )
	p:SetPos( Vector( 1664.9067382813, -917.67907714844, 133.58660888672 ) )
	p:SetAngles( Angle( -3.8986573843401e-13, -45.000015258789, 180 ) )
	p:SetLaserID( 4 )
	p:Spawn()

	p.PropFilter = GAMEMODE.MapProps
		

end

GM.SceneAssets["scene_name_this_is_fine"] = function()
	
	/*local ent = ents.Create("env_projectedtexture")
	if ent:IsValid() then
		ent:SetPos( Vector( -1018.0651245117, -2432.2639160156, 185.17742919922 ) )
		ent:SetAngles( ( vector_up ):Angle() )
		ent:SetKeyValue( "enableshadows", 1 )
		ent:SetKeyValue("farz", 148)
		ent:SetKeyValue("nearz", 1)
		ent:SetKeyValue("lightfov", 20)
		ent:SetKeyValue("lightcolor", "215 115 215 255")
		ent:Spawn()
		ent:Input("SpotlightTexture", NULL, NULL, "effects/flashlight001")
	end*/

	
end

GM.SceneAssets["scene_name_wild_ride"] = function()
	
	local ent = ents.Create("ent_menacingheli")
	if ent:IsValid() then
		ent:SetPos( ent.StartPos )
		ent:SetAngles( ent.DefaultAngles )
		ent:Spawn()
	end
	
	local p = ents.Create( "prop_dynamic" )
	p:SetModel( "models/props/de_piranesi/pi_apc.mdl" )
	p:SetPos( Vector( -302.79766845703, -4117.02734375, -18.910446166992 ) )
	p:SetAngles( Angle( -26.966917037964, -123.96841430664, 16.044973373413 ) )
	p:SetKeyValue("solid", "6")
	p:Spawn()
		


end

GM.SceneAssets["scene_name_white_kingdom"] = function()
	
	GAMEMODE.MapProps = {}
	
	local p = ents.Create( "prop_dynamic" )
	p:SetModel( "models/maxofs2d/logo_gmod_b.mdl" )
	p:SetPos( Vector( 734.43963623047, -90.30615234375, 52.395240783691 ) )
	p:SetAngles( Angle( -89.842163085938, -173.28831481934, 172.74020385742 ) )
	p:SetKeyValue("solid", "6")
	p:SetModelScale( 0.5, 0 )
	p:Spawn()
	
	local logo_pos = p:GetPos()


	local p = ents.Create( "ent_gjf_server" )
	p:SetPos( Vector( 1539.8157958984, -820.61950683594, 0.404779702425 ) )
	p:SetAngles( Angle( 0.026582412421703, 179.63331604004, 0.00067380629479885 ) )
	p:Spawn()
	p.LogoPos = logo_pos

	local p = ents.Create( "ent_gjf_server" )
	p:SetPos( Vector( 1568.3951416016, -719.90258789063, 0.32731384038925 ) )
	p:SetAngles( Angle( 0.038366172462702, 0.0014534685760736, 0.0086013646796346 ) )
	p:Spawn()
	p.LogoPos = logo_pos

		
	local p = ents.Create( "ent_gjf_server" )
	p:SetPos( Vector( 1280.2913818359, -718.93499755859, 0.40496000647545 ) )
	p:SetAngles( Angle( 0.039053544402122, 0.00027989843511023, -0.001922607421875 ) )
	p:Spawn()
	p.LogoPos = logo_pos

	local p = ents.Create( "ent_gjf_server" )
	p:SetPos( Vector( 1419.712890625, 380.04296875, 0.49942272901535 ) )
	p:SetAngles( Angle( -0.0025029433891177, 89.977905273438, 0.00033555104164407 ) )
	p:Spawn()
	p.LogoPos = logo_pos

	local p = ents.Create( "ent_gjf_server" )
	p:SetPos( Vector( 1544.2878417969, 607.89935302734, 0.37351316213608 ) )
	p:SetAngles( Angle( 0.042281344532967, -90.001129150391, -0.000946044921875 ) )
	p:Spawn()
	p.LogoPos = logo_pos

	local p = ents.Create( "ent_gjf_server" )
	p:SetPos( Vector( 1544.2053222656, 799.69763183594, 0.43946218490601 ) )
	p:SetAngles( Angle( 0.02913361042738, -90.093032836914, 0 ) )
	p:Spawn()
	p.LogoPos = logo_pos
		
	local p = ents.Create( "ent_gjf_server" )
	p:SetPos( Vector( 1647.4913330078, 636.43359375, 0.28750053048134 ) )
	p:SetAngles( Angle( 0.028756065294147, 89.940574645996, -0.001190185546875 ) )
	p:Spawn()
	p.LogoPos = logo_pos

	local p = ents.Create( "ent_gjf_server" )
	p:SetPos( Vector( 1335.8842773438, 828.43743896484, 0.35333651304245 ) )
	p:SetAngles( Angle( -0.013003580272198, 89.996917724609, 0.013761164620519 ) )
	p:Spawn()
	p.LogoPos = logo_pos
		
		
	local p = ents.Create( "prop_dynamic" )
		p:SetModel( "models/props/de_nuke/truck_nuke.mdl" )
		p:SetPos( Vector( 3091.8740234375, 77.881965637207, 1.1241512298584 ) )
		p:SetAngles( Angle( -0.059436362236738, 92.42113494873, -0.030181884765625 ) )
		p:SetKeyValue("solid", "6")
		p:Spawn()

	local p = ents.Create( "prop_dynamic" )
		p:SetModel( "models/props/cs_assault/handtruck.mdl" )
		p:SetPos( Vector( 2891.2561035156, 61.304340362549, -0.5147784948349 ) )
		p:SetAngles( Angle( 0.9470591545105, -162.35691833496, 0.53577536344528 ) )
		p:SetKeyValue("solid", "6")
		p:Spawn()
		
	local p = ents.Create( "prop_dynamic" )
		p:SetModel( "models/props/cs_assault/moneypallet02.mdl" )
		p:SetPos( Vector( 2807.2448730469, 222.67137145996, 0.43648648262024 ) )
		p:SetAngles( Angle( -0.015301063656807, -96.020027160645, 0.10892210900784 ) )
		p:SetKeyValue("solid", "6")
		p:Spawn()

	local p = ents.Create( "prop_dynamic" )
		p:SetModel( "models/props/cs_assault/moneypallet.mdl" )
		p:SetPos( Vector( 2786.7778320313, 130.57614135742, 0.49898797273636 ) )
		p:SetAngles( Angle( 0.088772118091583, -173.88357543945, -0.08544921875 ) )
		p:SetKeyValue("solid", "6")
		p:Spawn()

	local p = ents.Create( "prop_dynamic" )
		p:SetModel( "models/props/cs_assault/moneypallet02.mdl" )
		p:SetPos( Vector( 2781.962890625, 49.24898147583, 0.5498178601265 ) )
		p:SetAngles( Angle( 0.1824372112751, -6.9393534660339, -0.36456298828125 ) )
		p:SetKeyValue("solid", "6")
		p:Spawn()
		
	local p = ents.Create( "prop_dynamic" )
		p:SetModel( "models/props/cs_assault/moneypallet_washerdryer.mdl" )
		p:SetPos( Vector( 2810.7290039063, -48.692478179932, 0.40288916230202 ) )
		p:SetAngles( Angle( -0.084692552685738, -31.953416824341, 0.03856372833252 ) )
		p:SetKeyValue("solid", "6")
		p:Spawn()
		
end

GM.SceneAssets["scene_name_flashbacks"] = function()
	
	local p = ents.Create( "ent_destruct_coffin" )
	//p:SetModel( "models/props_c17/gravestone_coffinpiece002a.mdl" )
	p:SetPos( Vector( -1575.7611083984, -3326.978515625, 10.515537261963 ) )
	p:SetAngles( Angle( -5.1213531193639e-09, -87.814933776855, -1 ) )
	p:SetKeyValue("solid", "6")
	p:Spawn()

		
	local p = ents.Create( "prop_dynamic" )
	p:SetModel( "models/maxofs2d/camera.mdl" )
	p:SetPos( Vector( -1519.3454589844, -3395.9606933594, -0.015380859375 ) )
	p:SetAngles( Angle( 3.0000009536743, -34.304946899414, 7.9615501817898e-06 ) )
	//p:SetKeyValue("solid", "6")
	p:Spawn()

	local p = ents.Create( "prop_dynamic" )
	p:SetModel( "models/props_junk/gascan001a.mdl" )
	p:SetPos( Vector( -1581.0528564453, -3266.1516113281, 15.117567062378 ) )
	p:SetAngles( Angle( -32, 90.865135192871, 0 ) )
	//p:SetKeyValue("solid", "6")
	p:Spawn()

	local p = ents.Create( "prop_dynamic" )
	p:SetModel( "models/maxofs2d/companion_doll.mdl" )
	p:SetPos( Vector( -1561.2995605469, -3242.4558105469, 8.8339691162109 ) )
	p:SetAngles( Angle( -80, -159.11491394043, 0 ) )
	//p:SetKeyValue("solid", "6")
	p:Spawn()

	local p = ents.Create( "prop_dynamic" )
	p:SetModel( "models/props_lab/monitor01a.mdl" )
	p:SetPos( Vector( -1538.0905761719, -3194.7185058594, 14.771909713745 ) )
	p:SetAngles( Angle( -5.9999980926514, -23.325059890747, 89 ) )
	//p:SetKeyValue("solid", "6")
	p:Spawn()

	local p = ents.Create( "prop_dynamic" )
	p:SetModel( "models/props_lab/harddrive01.mdl" )
	p:SetPos( Vector( -1520.2485351563, -3221.0056152344, 4.1109461784363 ) )
	p:SetAngles( Angle( -5.7324984936713e-07, 102.51003265381, -91 ) )
	//p:SetKeyValue("solid", "6")
	p:Spawn()
		

	local p = ents.Create( "prop_dynamic" )
	p:SetModel( "models/hunter/blocks/cube025x05x025.mdl" )
	p:SetPos( Vector( -1474.642578125, -3205.0732421875, 0.28120613098145 ) )
	p:SetAngles( Angle( -1, -12.554615974426, -1 ) )
	//p:SetKeyValue("solid", "6")
	p:Spawn()
		
	local p = ents.Create( "prop_dynamic" )
	p:SetModel( "models/props_lab/clipboard.mdl" )
	p:SetPos( Vector( -1480.5700683594, -3207.5007324219, 12.469197273254 ) )
	p:SetAngles( Angle( -1.0920609441701e-13, -104.03447723389, 7.9168075899361e-06 ) )
	//p:SetKeyValue("solid", "6")
	p:Spawn()
		
	local p = ents.Create( "prop_dynamic" )
	p:SetModel( "models/hunter/blocks/cube025x025x025.mdl" )
	p:SetPos( Vector( -1464.1236572266, -3211.4187011719, 6.1856412887573 ) )
	p:SetAngles( Angle( -0.99999994039536, -10.540565490723, -1 ) )
	//p:SetKeyValue("solid", "6")
	p:Spawn()
		
	local p = ents.Create( "prop_dynamic" )
	p:SetModel( "models/props_junk/metal_paintcan001a.mdl" )
	p:SetPos( Vector( -1450.0581054688, -3215.107421875, 7.0430850982666 ) )
	p:SetAngles( Angle( -2, -26.399150848389, 7.9291112342617e-06 ) )
	//p:SetKeyValue("solid", "6")
	p:Spawn()

	local p = ents.Create( "prop_dynamic" )
	p:SetModel( "models/props_junk/metal_paintcan001b.mdl" )
	p:SetPos( Vector( -1445.4884033203, -3205.5495605469, 5.595682144165 ) )
	p:SetAngles( Angle( 89, -90.324844360352, -66.000183105469 ) )
	//p:SetKeyValue("solid", "6")
	p:Spawn()
		

	local p = ents.Create( "prop_dynamic" )
	p:SetModel( "models/weapons/w_physics.mdl" )
	p:SetPos( Vector( -1427.8851318359, -3228.9265136719, 4.8338623046875 ) )
	p:SetAngles( Angle( -12.000000953674, -172.3447265625, -4 ) )
	//p:SetKeyValue("solid", "6")
	p:Spawn()
	
	
	// explosive stuff
	
	local p = ents.Create( "ent_destruct_barrel" )
	p:SetPos( Vector( -1425.1076660156, -2817.0671386719, -14.9141023159027 ) )
	p:SetAngles( Angle( -13.125458717346, -17.443672180176, 2.3249025344849 ) )
	p:Spawn()
	
	local p = ents.Create( "ent_destruct_barrel" )
	p:SetPos( Vector( -693.34228515625, -3609.361328125, -15.0294748544693 ) )
	p:SetAngles( Angle( -17.702606201172, -63.616443634033, 1.6328530311584 ) )
	p:Spawn()

	local p = ents.Create( "ent_destruct_barrel" )
	p:SetPos( Vector( -1554.3312988281, -3822.4565429688, -18.1735181808472 ) )
	p:SetAngles( Angle( -2.4420170783997, 32.994205474854, 1.2669005393982 ) )
	p:Spawn()

	local p = ents.Create( "ent_destruct_barrel" )
	p:SetPos( Vector( -2127.42578125, -3399.2824707031, -16.4076189994812 ) )
	p:SetAngles( Angle( -8.3489265441895, -27.112380981445, -8.0121765136719 ) )
	p:Spawn()
	
	/*local p = ents.Create( "ent_destruct_barrel" )
	p:SetPos( Vector( -621.37066650391, -3583.9553222656, -16.874071598053 ) )
	p:SetAngles( Angle( -8.9445142745972, -120.70050811768, 21.193033218384 ) )
	p:Spawn()
	
	local p = ents.Create( "ent_destruct_barrel" )
	p:SetPos( Vector( -2053.658203125, -3525.9538574219, -16.3024752140045 ) )
	p:SetAngles( Angle( 11.262080192566, -16.875030517578, 19.102577209473 ) )
	p:Spawn()

	local p = ents.Create( "ent_destruct_barrel" )
	p:SetPos( Vector( -1545.0789794922, -2852.5322265625, -16.5553069114685 ) )
	p:SetAngles( Angle( 8.373140335083, 63.441791534424, -28.350982666016 ) )
	p:Spawn()

	local p = ents.Create( "ent_destruct_barrel" )
	p:SetPos( Vector( -1669.7943115234, -3975.5991210938, -17.3997865915298 ) )
	p:SetAngles( Angle( 15.619074821472, 80.64868927002, -22.070159912109 ) )
	p:Spawn()*/

	
	
end



function GM:LoadSceneAssets( scene )
	
	if scene and scene.Name and self.SceneAssets[ scene.Name ] then
		self.SceneAssets[ scene.Name ]()
	end
	
end