SCENE.Order = 14
SCENE.Act = 4
SCENE.Map = "sog_siege_v3"
SCENE.Enemies = {
 ["e3"] = {
	 ["ang"] = Angle( 0, 94, 0 ), ["pos"] = Vector( -533, -549, 17 ), ["beh"] = 1, ["char"] = "banned" 
	}, ["e13"] = {
	 ["pos"] = Vector( -541, 438, 17 ), ["ang"] = Angle( 0, -86, 0 ), ["beh"] = 2, ["char"] = "kid", ["wep"] = "sogm_physcannon" 
	}, ["e24"] = {
	 ["pos"] = Vector( -353, 313, 17 ), ["ang"] = Angle( 0, 90, 0 ), ["beh"] = 1, ["char"] = "admin", ["wep"] = "sogm_shotgun" 
	}, ["e18"] = {
	 ["pos"] = Vector( -232, 451, 17 ), ["ang"] = Angle( 0, 180, 0 ), ["beh"] = 2, ["char"] = "kid", ["wep"] = "sogm_physcannon" 
	}, ["e4"] = {
	 ["pos"] = Vector( -769, -613, 17 ), ["ang"] = Angle( 0, 0, 0 ), ["beh"] = 4, ["char"] = "banned" 
	}, ["e8"] = {
	 ["pos"] = Vector( -1514, -549, 17 ), ["ang"] = Angle( 0, 90, 0 ), ["beh"] = 1, ["char"] = "admin", ["wep"] = "sogm_usp" 
	}, ["e5"] = {
	 ["pos"] = Vector( -515, -464, 17 ), ["ang"] = Angle( 0, 180, 0 ), ["beh"] = 1, ["char"] = "cop kid", ["wep"] = "sogm_shotgun" 
	}, ["e6"] = {
	 ["pos"] = Vector( -1320, 511, 17 ), ["ang"] = Angle( 0, 0, 0 ), ["beh"] = 4, ["char"] = "banned" 
	}, ["e12"] = {
	 ["ang"] = Angle( 0, 36, 0 ), ["pos"] = Vector( -585, -150, 17 ), ["beh"] = 0, ["char"] = "cop kid" 
	}, ["e14"] = {
	 ["pos"] = Vector( -737, -97, 17 ), ["ang"] = Angle( 0, 0, 0 ), ["beh"] = 2, ["char"] = "admin", ["wep"] = "sogm_m4" 
	}, ["e11"] = {
	 ["pos"] = Vector( -1221, -677, 17 ), ["ang"] = Angle( 0, 6, 0 ), ["beh"] = 2, ["char"] = "admin", ["wep"] = "sogm_uzi" 
	}, ["e9"] = {
	 ["ang"] = Angle( 0, 94, 0 ), ["pos"] = Vector( -674, 381, 17 ), ["beh"] = 2, ["char"] = "banned" 
	}, ["e7"] = {
	 ["ang"] = Angle( 0, 6, 0 ), ["pos"] = Vector( -674, -617, 17 ), ["beh"] = 2, ["char"] = "banned" 
	}, ["e16"] = {
	 ["pos"] = Vector( -121, -243, 17 ), ["ang"] = Angle( 0, 70, 0 ), ["beh"] = 1, ["char"] = "cop kid", ["wep"] = "sogm_magnum" 
	}, ["e2"] = {
	 ["pos"] = Vector( -817, 359, 17 ), ["ang"] = Angle( 0, -90, 0 ), ["beh"] = 2, ["char"] = "admin", ["wep"] = "sogm_uzi" 
	}, ["e10"] = {
	 ["ang"] = Angle( 0, 6, 0 ), ["pos"] = Vector( -1761, -328, 17 ), ["beh"] = 2, ["char"] = "cop kid" 
	}, ["e1"] = {
	 ["ang"] = Angle( 0, 2, 0 ), ["pos"] = Vector( -298, 569, 17 ), ["beh"] = 1, ["char"] = "thug kid" 
	}, ["e23"] = {
	 ["pos"] = Vector( -435, -129, 17 ), ["ang"] = Angle( 0, -83, 0 ), ["beh"] = 2, ["char"] = "kid", ["wep"] = "sogm_physcannon" 
	}, ["e22"] = {
	 ["pos"] = Vector( -439, 23, 17 ), ["ang"] = Angle( 0, -45, 0 ), ["beh"] = 1, ["char"] = "kid", ["wep"] = "sogm_physcannon" 
	}, ["e17"] = {
	 ["pos"] = Vector( -439, 166, 17 ), ["ang"] = Angle( 0, 2, 0 ), ["beh"] = 2, ["char"] = "kid", ["wep"] = "sogm_physcannon" 
	} 
}
SCENE.PickupsPersistance = true
SCENE.AddThunder = true
SCENE.NoPickups = true
SCENE.SoundTrack = 79782621//152415622
SCENE.MusicText = "AIRMANN - The Blackening"//"Tom Clayton - The Shadow"
SCENE.Dialogues = {
 
}
SCENE.Nightmare = false
SCENE.Vehicle = {
 ["pos"] = Vector( 368, 672, 17 ), ["mdl"] = "models/props/cs_militia/van.mdl", ["type"] = 2, ["glass_mdl"] = "models/props/cs_militia/van_glass.mdl", ["ang"] = Angle( 0, 0, 0 ) 
}
SCENE.Name = "influence"
//SCENE.StartFrom = 45000
SCENE.Triggers = {
 ["t5"] = {
	 ["pos"] = Vector( -706, -405, 17 ), ["size"] = 38, ["event"] = "OnAllEnemiesKilled", ["action"] = "event", ["objects"] = {
		 "t2", "t3" 
		} 
	}, ["t1"] = {
	 ["pos"] = Vector( 282, 634, 17 ), ["size"] = 139, ["action"] = "nextlevel" 
	}, ["t6"] = {
	 ["pos"] = Vector( 65, 452, 17 ), ["CheckTriggers"] = {
		 "t7" 
		}, ["action"] = "hudmessage", ["size"] = 38, ["data"] = "Leave Area" 
	}, ["t9"] = {
	 ["pos"] = Vector( -956, -623, 17 ), ["size"] = 42, ["event"] = "OnAllEnemiesKilled", ["action"] = "event", ["objects"] = {
		 "t8" 
		} 
	}, ["t8"] = {
	 ["pos"] = Vector( -917, -501, 17 ), ["CheckTriggers"] = {
		 "t9" 
		}, ["action"] = "arrow", ["size"] = 42, ["objects"] = {
		 "w1" 
		} 
	}, ["t7"] = {
	 ["pos"] = Vector( -53, 391, 17 ), ["size"] = 38, ["event"] = "OnWeaponRemoved", ["action"] = "event", ["data"] = {
		 "w1" 
		}, ["objects"] = {
		 "t6", "t4" 
		} 
	}, ["t2"] = {
	 ["pos"] = Vector( -617, -468, 17 ), ["CheckTriggers"] = {
		 "t5" 
		}, ["action"] = "spawn", ["size"] = 38, ["objects"] = {
		 "w1" 
		} 
	}, ["t4"] = {
	 ["size"] = 38, ["pos"] = Vector( 67, 569, 17 ), ["CheckTriggers"] = {
		 "t7" 
		}, ["action"] = "levelclear" 
	}, ["t3"] = {
	 ["pos"] = Vector( -802, -399, 17 ), ["CheckTriggers"] = {
		 "t5" 
		}, ["action"] = "hudmessage", ["size"] = 38, ["data"] = "Get the briefcase" 
	} 
}
//SCENE.EndAt = 209000
SCENE.Characters = {
 "mark" 
}
SCENE.Volume = 33
SCENE.DrugEffect = true
SCENE.Pickups = {
 ["w1"] = {
	 ["pos"] = Vector( -537, -636, 17 ), ["CheckTriggers"] = {
		 "t2", "t8" 
		}, ["wep"] = "sogm_briefcase" 
	} 
}

SCENE.Initialize = function()
end

SCENE.Loaded = function()
	PLAYER_SPAWNPOINT = Vector( 250, 639, 17 )
end
 