SCENE.Order = 9
SCENE.Act = 3
SCENE.Cover = Material( "sog/covers/dvd_disk_9.png" , "alphatest")
SCENE.Map = "sog_garage_v1"
SCENE.ShowLastEnemies = true
SCENE.Enemies = {
 ["e3"] = {
	 ["pos"] = Vector( 515, -1379, 65 ), ["ang"] = Angle( 0, 176, 0 ), ["beh"] = 0, ["char"] = "kid", ["wep"] = "sogm_physcannon" 
	}, ["e19"] = {
	 ["ang"] = Angle( 0, 97, 0 ), ["pos"] = Vector( 1503, -1317, 65 ), ["beh"] = 4, ["char"] = "thug kid" 
	}, ["e4"] = {
	 ["pos"] = Vector( 371, -1305, 65 ), ["ang"] = Angle( 0, -44, 0 ), ["beh"] = 0, ["char"] = "kid", ["wep"] = "sogm_physcannon" 
	}, ["e18"] = {
	 ["ang"] = Angle( 0, -86, 0 ), ["pos"] = Vector( 352, -275, 17 ), ["beh"] = 0, ["char"] = "banned" 
	}, ["e8"] = {
	 ["pos"] = Vector( 1504, -1214, 65 ), ["ang"] = Angle( 0, 90, 0 ), ["beh"] = 2, ["char"] = "kid", ["wep"] = "sogm_physcannon" 
	}, ["e5"] = {
	 ["ang"] = Angle( 0, 180, 0 ), ["pos"] = Vector( 1134, -121, 65 ), ["beh"] = 2, ["char"] = "banned" 
	}, ["e6"] = {
	 ["pos"] = Vector( 1943, -590, 65 ), ["ang"] = Angle( 0, 180, 0 ), ["beh"] = 0, ["char"] = "kid", ["wep"] = "sogm_physcannon" 
	}, ["e14"] = {
	 ["pos"] = Vector( 832, -353, 65 ), ["ang"] = Angle( 0, -1, 0 ), ["beh"] = 0, ["char"] = "kid", ["wep"] = "sogm_physcannon" 
	}, ["e9"] = {
	 ["pos"] = Vector( 1157, -1751, 129 ), ["ang"] = Angle( 0, 2, 0 ), ["beh"] = 0, ["char"] = "kid", ["wep"] = "sogm_physcannon" 
	}, ["e7"] = {
	 ["pos"] = Vector( 2014, -590, 65 ), ["ang"] = Angle( 0, 180, 0 ), ["beh"] = 4, ["char"] = "kid", ["wep"] = "sogm_physcannon" 
	}, ["e12"] = {
	 ["pos"] = Vector( 1401, -205, 65 ), ["ang"] = Angle( 0, -180, 0 ), ["beh"] = 2, ["char"] = "kid", ["wep"] = "sogm_physcannon" 
	}, ["e16"] = {
	 ["ang"] = Angle( 0, -178, 0 ), ["pos"] = Vector( 1146, -169, 65 ), ["beh"] = 4, ["char"] = "cop kid" 
	}, ["e17"] = {
	 ["ang"] = Angle( 0, -178, 0 ), ["pos"] = Vector( 1113, -418, 65 ), ["beh"] = 0, ["char"] = "thug kid" 
	}, ["e11"] = {
	 ["ang"] = Angle( 0, -178, 0 ), ["pos"] = Vector( 2353, -331, 65 ), ["beh"] = 4, ["char"] = "thug kid" 
	}, ["e1"] = {
	 ["pos"] = Vector( 447, -1295, 65 ), ["anim"] = "taunt_muscle_base", ["ang"] = Angle( 0, -90, 0 ), ["beh"] = 0, ["char"] = "kid" 
	}, ["e2"] = {
	 ["pos"] = Vector( 509, -1443, 65 ), ["ang"] = Angle( 0, 167, 0 ), ["beh"] = 0, ["char"] = "kid", ["wep"] = "sogm_pipe" 
	}, ["e13"] = {
	 ["pos"] = Vector( 2248, -1233, 17 ), ["ang"] = Angle( 0, -83, 0 ), ["beh"] = 0, ["char"] = "kid", ["wep"] = "sogm_physcannon" 
	}, ["e10"] = {
	 ["pos"] = Vector( 2269, -331, 65 ), ["ang"] = Angle( 0, -178, 0 ), ["beh"] = 0, ["char"] = "admin", ["wep"] = "sogm_shotgun" 
	} 
}
SCENE.StartFromAmbient = true
SCENE.PickupsPersistance = true
SCENE.AddThunder = true
SCENE.NoPickups = true
SCENE.Pickups = {
	["w2"] = {
	 ["wep"] = "sogm_cinderblock", ["pos"] = Vector( 779, -1181, 65 ) 
	} 
}
SCENE.MusicText = "NEUS - Analogies"
SCENE.Dialogues = {
 ["d2"] = {
	 {
 ["person"] = "player", ["text"] = {
	 "Fucking fanboys. . .", "Someone is going to pay for that." 
	} 
} 
	}, ["d1"] = {
	 {
 ["person"] = "e1", ["text"] = {
	 "hehehehehehe. . .", "Are you recording?" 
	} 
}, {
 ["person"] = "e3", ["text"] = {
	 "Yessss. . .", "This is gonna be good!" 
	} 
}, {
 ["person"] = "e4", ["text"] = {
	 "This video will let us win a night in the bed\\nwith 'LetsTortureGMod'!!!" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "Yesssss. . ." 
	} 
}, {
 ["person"] = "e2", ["text"] = {
	 "Oh yessss. . ." 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "Looking pretty good, ms. car!", "Mind if I 'inspect' you?" 
	} 
}, {
 ["person"] = "e3", ["text"] = {
	 "Hahahahaha" 
	} 
}, {
 ["person"] = "e4", ["text"] = {
	 "Hahahahahahahaha" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "Hands off my car, you little fucks!!!" 
	} 
}, {
 ["person"] = "e2", ["text"] = {
	 "Nooo!!!", "He wants to ruin our chance!" 
	} 
} 
	} 
}
SCENE.Characters = {
 "axe guy" 
}
SCENE.Name = "fanboys"
SCENE.Triggers = {
 ["t5"] = {
	 ["pos"] = Vector( 678, -1477, 65 ), ["CheckTriggers"] = {
		 "t6" 
		}, ["action"] = "hudmessage", ["data"] = "Go to car", ["size"] = 10 
	}, ["t1"] = {
	 ["pos"] = Vector( 221, -1118, 65 ), ["data"] = "true", ["action"] = "pauseenemies", ["size"] = 60, ["trigger_once"] = true 
	}, ["t10"] = {
	 ["pos"] = Vector( 151, -978, 65 ), ["size"] = 10, ["event"] = "OnDialogueFinished", ["action"] = "event", ["data"] = {
		 "d1" 
		}, ["objects"] = {
		 "t9" 
		} 
	}, ["t6"] = {
	 ["pos"] = Vector( 650, -1413, 65 ), ["size"] = 10, ["event"] = "OnLevelClear", ["action"] = "event", ["objects"] = {
		 "t5" 
		} 
	}, ["t9"] = {
	 ["CheckTriggers"] = {
		 "t10" 
		}, ["pos"] = Vector( 214, -982, 65 ), ["size"] = 10, ["trigger_once"] = true, ["action"] = "playmusic" 
	}, ["t8"] = {
	 ["pos"] = Vector( 792, -1015, 65 ), ["size"] = 10, ["event"] = "OnLevelClear", ["action"] = "event", ["objects"] = {
		 "t7" 
		} 
	}, ["t7"] = {
	 ["pos"] = Vector( 792, -1072, 65 ), ["size"] = 10, ["action"] = "dialogue", ["CheckTriggers"] = {
		 "t8" 
		}, ["objects"] = {
		 "d2" 
		} 
	}, ["t2"] = {
	 ["pos"] = Vector( 246, -1258, 65 ), ["size"] = 10, ["action"] = "dialogue", ["CheckTriggers"] = {
		 "t3" 
		}, ["objects"] = {
		 "d1" 
		} 
	}, ["t4"] = {
	 ["pos"] = Vector( 430, -1395, 65 ), ["size"] = 122, ["action"] = "nextlevel" 
	}, ["t3"] = {
	 ["pos"] = Vector( 336, -1221, 65 ), ["size"] = 10, ["event"] = "OnLevelLoaded", ["action"] = "event", ["objects"] = {
		 "t2" 
		} 
	} 
}
SCENE.SoundTrack = 365385926
SCENE.Volume = 40
SCENE.StartFrom = 21000
SCENE.EndAt = 246000
SCENE.Ambient = 365385926
SCENE.AmbientVolume = 40
SCENE.AmbientEndAt = 20500
SCENE.Vehicle = {
 ["pos"] = Vector( 437, -1417, 65 ), ["mdl"] = "models/props/de_nuke/car_nuke_black.mdl", ["type"] = 1, ["glass_mdl"] = "models/props/de_nuke/car_nuke_glass.mdl", ["ang"] = Angle( 0, -183, 0 ) 
}

SCENE.Initialize = function()
end

SCENE.Loaded = function()
	PLAYER_SPAWNPOINT = Vector( 214, -1121, 65 )
end

