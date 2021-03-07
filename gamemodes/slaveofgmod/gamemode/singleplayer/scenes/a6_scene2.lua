SCENE.Order = 22
SCENE.Act = 6
SCENE.Map = "sog_coastal_v1"
SCENE.FlipView = false
SCENE.ShowLastEnemies = true
SCENE.Enemies = {
 ["e3"] = {
	 ["pos"] = Vector( 1406, 277, 1 ), ["anim"] = "zombie_slump_idle_02", ["ally"] = true, ["ang"] = Angle( 0, 118, 0 ), ["beh"] = -1, ["char"] = "gmpower mod", ["wep"] = "none" 
	}, ["e19"] = {
	 ["ang"] = Angle( 0, -180, 0 ), ["pos"] = Vector( 1530, -1281, 1 ), ["beh"] = 2, ["char"] = "infected" 
	}, ["e17"] = {
	 ["ang"] = Angle( 0, 180, 0 ), ["pos"] = Vector( 1973, 588, 1 ), ["beh"] = 2, ["char"] = "infected" 
	}, ["e4"] = {
	 ["ang"] = Angle( 0, 90, 0 ), ["pos"] = Vector( 1556, -256, 2 ), ["beh"] = 2, ["char"] = "infected" 
	}, ["e18"] = {
	 ["ang"] = Angle( 0, -90, 0 ), ["pos"] = Vector( 2103, 759, 1 ), ["beh"] = 2, ["char"] = "infected" 
	}, ["e23"] = {
	 ["pos"] = Vector( 2489, -305, 2 ), ["ang"] = Angle( 0, 180, 0 ), ["beh"] = 2, ["char"] = "mercenary", ["wep"] = "sogm_magnum" 
	}, ["e10"] = {
	 ["pos"] = Vector( 2232, -1079, 1 ), ["ang"] = Angle( 0, 2, 0 ), ["beh"] = 2, ["char"] = "mercenary", ["wep"] = "sogm_magnum" 
	}, ["e26"] = {
	 ["pos"] = Vector( 2490, 796, 1 ), ["ang"] = Angle( 0, -86, 0 ), ["beh"] = 2, ["char"] = "mercenary", ["wep"] = "sogm_magnum" 
	}, ["e8"] = {
	 ["ang"] = Angle( 0, -22, 0 ), ["pos"] = Vector( 1638, -876, 1 ), ["beh"] = 1, ["char"] = "infected" 
	}, ["e5"] = {
	 ["ang"] = Angle( 0, 0, 0 ), ["pos"] = Vector( 1240, -235, 2 ), ["beh"] = 2, ["char"] = "infected" 
	}, ["e6"] = {
	 ["ang"] = Angle( 0, -180, 0 ), ["pos"] = Vector( 1789, -884, 1 ), ["beh"] = 1, ["char"] = "infected" 
	}, ["e22"] = {
	 ["pos"] = Vector( 940, -247, 2 ), ["ang"] = Angle( 0, 2, 0 ), ["beh"] = 2, ["char"] = "mercenary", ["wep"] = "sogm_magnum" 
	}, ["e14"] = {
	 ["ang"] = Angle( 0, -86, 0 ), ["pos"] = Vector( 2481, 340, 2 ), ["beh"] = 2, ["char"] = "infected" 
	}, ["e27"] = {
	 ["pos"] = Vector( 1538, 29, 2 ), ["ang"] = Angle( 0, -86, 0 ), ["beh"] = 2, ["char"] = "mercenary", ["wep"] = "sogm_magnum" 
	}, ["e9"] = {
	 ["ang"] = Angle( 0, -22, 0 ), ["pos"] = Vector( 1601, -834, 1 ), ["beh"] = 1, ["char"] = "infected" 
	}, ["e7"] = {
	 ["ang"] = Angle( 0, -22, 0 ), ["pos"] = Vector( 1673, -892, 1 ), ["beh"] = 1, ["char"] = "infected" 
	}, ["e12"] = {
	 ["ang"] = Angle( 0, 90, 0 ), ["pos"] = Vector( 700, 366, 1 ), ["beh"] = 2, ["char"] = "infected" 
	}, ["e25"] = {
	 ["ang"] = Angle( 0, 87, 0 ), ["pos"] = Vector( 1437, -981, 1 ), ["beh"] = 2, ["char"] = "infected" 
	}, ["e24"] = {
	 ["ang"] = Angle( 0, 180, 0 ), ["pos"] = Vector( 2515, -739, 1 ), ["beh"] = 2, ["char"] = "infected" 
	}, ["e28"] = {
	 ["ang"] = Angle( 0, -86, 0 ), ["pos"] = Vector( 977, -788, 1 ), ["beh"] = 2, ["char"] = "infected" 
	}, ["e1"] = {
	 ["pos"] = Vector( 1374, 359, 1 ), ["ang"] = Angle( 0, -68, 0 ), ["beh"] = 0, ["char"] = "mercenary", ["wep"] = "sogm_shotgun" 
	}, ["e2"] = {
	 ["pos"] = Vector( 1324, 358, 1 ), ["anim"] = "idle_passive", ["ang"] = Angle( 0, -74, 0 ), ["beh"] = 4, ["char"] = "steve" 
	}, ["e13"] = {
	 ["ang"] = Angle( 0, 90, 0 ), ["pos"] = Vector( 2253, -130, 2 ), ["beh"] = 2, ["char"] = "infected" 
	}, ["e15"] = {
	 ["ang"] = Angle( 0, 90, 0 ), ["pos"] = Vector( 2925, -1214, 1 ), ["beh"] = 2, ["char"] = "infected" 
	} 
}
SCENE.StartFromAmbient = true
SCENE.PickupsPersistance = true
SCENE.BloodyScreen = true
SCENE.AddThunder = true
SCENE.StartFrom = 47700
SCENE.SoundTrack = 889742410
SCENE.MusicText = "Donbor - Return"
SCENE.LightStyle = "k"
SCENE.Dialogues = {
 ["d2"] = {
	 {
 ["person"] = "player", ["text"] = {
	 "Jesus. . .", "I need to get out of here.", "Wonder if their car is still around somewhere. . ." 
	} 
} 
	}, ["d1"] = {
	 {
 ["person"] = "player", ["text"] = {
	 ". . .", "This place isn't as happy as thought. . .", "What the hell happened in here?", ". . ." 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "Hm. . .", "You must be the new guy, huh?", "What's your name?" 
	} 
}, {
 ["person"] = "e2", ["text"] = {
	 "Steve. . ." 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "Nice!" 
	} 
}, {
 ["person"] = "e2", ["text"] = {
	 "What exactly are we doing in here?" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "Observing the damage." 
	} 
}, {
 ["person"] = "e2", ["text"] = {
	 ". . ." 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "Let's just say. . .", "Someone, who made this game. . .", ". . .promised our boss a good amount of money. . .", ". . .to get rid of the content and community." 
	} 
}, {
 ["person"] = "e2", ["text"] = {
	 ". . ." 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "'To tie up the loose ends'" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "Oh no. . ." 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "So as you can see. . .", "Boss has a specific taste, when it comes\\nto destroying stuff.", "But don't worry.", "He says that 'it will be all over soon'." 
	} 
}, {
 ["person"] = "e2", ["text"] = {
	 ". . ." 
	} 
}, {
 ["person"] = "e3", ["text"] = {
	 ". . .the cough. . .", ". . .this can not be. . ." 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "Oh shit!", "That thing is still breathing, eh?" 
	} 
} 
	} 
}
SCENE.AmbientEndAt = 48000
SCENE.NoPickups = true
SCENE.Characters = {
 "protagonist" 
}
SCENE.Name = "resort"
SCENE.EndAt = 283000
SCENE.Triggers = {
 ["t7"] = {
	 ["pos"] = Vector( 366, -677, 1 ), ["data"] = "Escape", ["action"] = "hudmessage", ["size"] = 10, ["CheckTriggers"] = {
		 "t8" 
		} 
	}, ["t6"] = {
	 ["pos"] = Vector( 328, -774, 1 ), ["size"] = 10, ["action"] = "dialogue", ["CheckTriggers"] = {
		 "t8" 
		}, ["objects"] = {
		 "d2" 
		} 
	}, ["t5"] = {
	 ["pos"] = Vector( 363, -1043, 1 ), ["size"] = 118, ["action"] = "nextlevel" 
	}, ["t8"] = {
	 ["pos"] = Vector( 415, -741, 1 ), ["size"] = 10, ["event"] = "OnLevelClear", ["action"] = "event", ["objects"] = {
		 "t6", "t7" 
		} 
	}, ["t2"] = {
	 ["pos"] = Vector( 1237, 814, 1 ), ["size"] = 10, ["event"] = "OnLevelLoaded", ["action"] = "event", ["objects"] = {
		 "t1" 
		} 
	}, ["t1"] = {
	 ["pos"] = Vector( 1222, 893, 1 ), ["size"] = 10, ["action"] = "dialogue", ["CheckTriggers"] = {
		 "t2" 
		}, ["objects"] = {
		 "d1" 
		} 
	}, ["t4"] = {
	 ["pos"] = Vector( 1234, 1086, 1 ), ["size"] = 10, ["event"] = "OnDialogueFinished", ["action"] = "event", ["data"] = {
		 "d1" 
		}, ["objects"] = {
		 "t3" 
		} 
	}, ["t3"] = {
	 ["pos"] = Vector( 1213, 1009, 1 ), ["CheckTriggers"] = {
		 "t4" 
		}, ["action"] = "playmusic", ["size"] = 10, ["trigger_once"] = true 
	} 
}
SCENE.Pickups = {
 ["w1"] = {
	 ["wep"] = "sogm_briefcase", ["pos"] = Vector( 1502, 317, 2 ) 
	} 
}
SCENE.Vehicle = {
 ["pos"] = Vector( 352, -1057, 1 ), ["mdl"] = "models/props/de_train/utility_truck.mdl", ["type"] = 6, ["glass_mdl"] = "models/props/de_train/utility_truck_windows.mdl", ["ang"] = Angle( 0, -315, 0 ) 
}
SCENE.Ambient = 889742410
SCENE.Volume = 40
SCENE.AmbientVolume = 40
//SCENE.AmbientStartFrom = 2500

SCENE.Initialize = function()
end

SCENE.Loaded = function()
	PLAYER_SPAWNPOINT = Vector( 1362, 828, 1 )
end

