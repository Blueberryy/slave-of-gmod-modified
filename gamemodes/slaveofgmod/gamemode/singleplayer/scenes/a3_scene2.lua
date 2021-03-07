SCENE.Order = 10
SCENE.Act = 3
SCENE.Map = "sog_siege_v3"
SCENE.Cover = Material( "sog/covers/dvd_disk_10.png" , "alphatest")
SCENE.FlipView = true
SCENE.Enemies = {
 ["e3"] = {
	 ["ang"] = Angle( 0, 6, 0 ), ["pos"] = Vector( -462, 176, 17 ), ["beh"] = 2, ["char"] = "traitor" 
	}, ["e13"] = {
	 ["pos"] = Vector( -674, 353, 17 ), ["ang"] = Angle( 0, 104, 0 ), ["beh"] = 1, ["char"] = "detective", ["wep"] = "sogm_usp" 
	}, ["e20"] = {
	 ["pos"] = Vector( -965, 793, 17 ), ["ang"] = Angle( 0, -79, 0 ), ["beh"] = 0, ["char"] = "admin", ["wep"] = "sogm_m4" 
	}, ["e15"] = {
	 ["pos"] = Vector( -1124, -3, 17 ), ["ang"] = Angle( 0, -103, 0 ), ["beh"] = 0, ["char"] = "detective", ["wep"] = "sogm_shotgun" 
	}, ["e8"] = {
	 ["pos"] = Vector( -617, -106, 17 ), ["ang"] = Angle( 0, -15, 0 ), ["beh"] = 1, ["char"] = "admin", ["wep"] = "sogm_usp" 
	}, ["e21"] = {
	 ["ang"] = Angle( 0, -79, 0 ), ["pos"] = Vector( -929, 871, 17 ), ["beh"] = 4, ["char"] = "traitor" 
	}, ["e6"] = {
	 ["ang"] = Angle( 0, 2, 0 ), ["pos"] = Vector( -800, -617, 17 ), ["beh"] = 2, ["char"] = "traitor" 
	}, ["e26"] = {
	 ["ang"] = Angle( 0, 2, 0 ), ["pos"] = Vector( -1535, 584, 17 ), ["beh"] = 4, ["char"] = "traitor" 
	}, ["e14"] = {
	 ["pos"] = Vector( -711, 350, 17 ), ["ang"] = Angle( 0, 84, 0 ), ["beh"] = 1, ["char"] = "traitor", ["wep"] = "sogm_pipe" 
	}, ["e10"] = {
	 ["ang"] = Angle( 0, -117, 0 ), ["pos"] = Vector( -983, 1075, 17 ), ["beh"] = 0, ["char"] = "traitor" 
	}, ["e9"] = {
	 ["ang"] = Angle( 0, -56, 0 ), ["pos"] = Vector( -1237, 843, 17 ), ["beh"] = 0, ["char"] = "traitor" 
	}, ["e7"] = {
	 ["ang"] = Angle( 0, 0, 0 ), ["pos"] = Vector( -1093, -577, 17 ), ["beh"] = 0, ["char"] = "traitor" 
	}, ["e16"] = {
	 ["ang"] = Angle( 0, -103, 0 ), ["pos"] = Vector( -1077, 40, 17 ), ["beh"] = 4, ["char"] = "traitor" 
	}, ["e25"] = {
	 ["pos"] = Vector( -1467, 584, 17 ), ["ang"] = Angle( 0, 2, 0 ), ["beh"] = 0, ["char"] = "detective", ["wep"] = "sogm_ak47" 
	}, ["e22"] = {
	 ["ang"] = Angle( 0, 90, 0 ), ["pos"] = Vector( -1174, -281, 17 ), ["beh"] = 2, ["char"] = "traitor" 
	}, ["e17"] = {
	 ["ang"] = Angle( 0, -50, 0 ), ["pos"] = Vector( -578, 464, 17 ), ["beh"] = 1, ["char"] = "traitor" 
	}, ["e1"] = {
	 ["ang"] = Angle( 0, -86, 0 ), ["pos"] = Vector( 109, -234, 17 ), ["beh"] = 0, ["char"] = "detective" 
	}, ["e2"] = {
	 ["ang"] = Angle( 0, 90, 0 ), ["pos"] = Vector( -532, -309, 17 ), ["beh"] = 2, ["char"] = "traitor" 
	}, ["e12"] = {
	 ["pos"] = Vector( -695, 444, 17 ), ["anim"] = "idle_all_cower", ["ang"] = Angle( 0, -90, 0 ), ["beh"] = -1, ["char"] = "traitor" 
	}, ["e11"] = {
	 ["ang"] = Angle( 0, 2, 0 ), ["pos"] = Vector( -1563, -311, 17 ), ["beh"] = 2, ["char"] = "traitor" 
	} 
}
SCENE.AddThunder = true
SCENE.Volume = 37
SCENE.Pickups = {
 ["w1"] = {
	 ["wep"] = "sogm_pipe", ["pos"] = Vector( -165, -240, 17 ) 
	}, 
	//["w2"] = {
	// ["wep"] = "sogm_axe", ["pos"] = Vector( 63, -448, 17 ) 
	//} 
}
SCENE.MusicText = "Sulumi - Enthusiasm"
SCENE.Dialogues = {
 ["d1"] = {
	 {
 ["person"] = "player", ["text"] = {
	 "Fuck, I don't see him in there." 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "Why are you looking at me like that?!", "You want to RDM me!" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 ". . .", "Where is that asshole with a camera?!", "Where the fuck did he go?" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "Stop looking at me!!!", "ADMIN!!!", "RDM! RDM! RDM!" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "You stupid pieces of shit. . ." 
	} 
} 
	} 
}
SCENE.Characters = {
 "axe guy" 
}
SCENE.Name = "backstab"
SCENE.Triggers = {
 ["t7"] = {
	 ["pos"] = Vector( 367, -267, 17 ), ["data"] = translate.Get("sog_hud_obj_leave_area"), ["action"] = "hudmessage", ["size"] = 42, ["CheckTriggers"] = {
		 "t8" 
		} 
	}, ["t6"] = {
	 ["pos"] = Vector( 176, -427, 17 ), ["size"] = 118, ["action"] = "nextlevel" 
	}, ["t5"] = {
	 ["action"] = "linker", ["pos"] = Vector( 176, -460, 17 ), ["size"] = 63, ["objects"] = {
		 "t3" 
		} 
	}, ["t8"] = {
	 ["pos"] = Vector( 361, -422, 17 ), ["size"] = 42, ["event"] = "OnLevelClear", ["action"] = "event", ["objects"] = {
		 "t7" 
		} 
	}, ["t2"] = {
	 ["pos"] = Vector( -77, -474, 17 ), ["size"] = 21, ["event"] = "OnLevelLoaded", ["action"] = "event", ["objects"] = {
		 "t1" 
		} 
	}, ["t1"] = {
	 ["pos"] = Vector( -72, -362, 17 ), ["data"] = "true", ["action"] = "pauseenemies", ["size"] = 21, ["CheckTriggers"] = {
		 "t2" 
		} 
	}, ["t4"] = {
	 ["action"] = "linker", ["pos"] = Vector( 10, -446, 17 ), ["size"] = 42, ["objects"] = {
		 "t3" 
		} 
	}, ["t3"] = {
	 ["pos"] = Vector( 85, -368, 17 ), ["size"] = 34, ["action"] = "dialogue", ["CheckTriggers"] = {
		 "t4", "t5" 
		}, ["objects"] = {
		 "d1" 
		} 
	} 
}
SCENE.Vehicle = {
 ["pos"] = Vector( 213, -437, 17 ), ["mdl"] = "models/props/de_nuke/car_nuke_black.mdl", ["type"] = 1, ["glass_mdl"] = "models/props/de_nuke/car_nuke_glass.mdl", ["ang"] = Angle( 0, -79, 0 ) 
}
SCENE.SoundTrack = 205254613
SCENE.NoPickups = true
SCENE.PickupsPersistance = true
SCENE.LightStyle = "z"

SCENE.Initialize = function()
end

SCENE.Loaded = function()
	PLAYER_SPAWNPOINT = Vector( 88, -445, 17 )
end
 