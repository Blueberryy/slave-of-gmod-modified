SCENE.Order = 4
SCENE.Act = 1
SCENE.Cover = Material( "sog/covers/dvd_disk_4.png" , "alphatest")
SCENE.Achievement = "envy"
SCENE.Map = "sog_disco"
SCENE.FlipView = true
SCENE.LightStyle = "z"
SCENE.Enemies = {
 ["e1"] = {
	 ["ang"] = Angle( 0, 180, 0 ), ["pos"] = Vector( -430, 39, 1 ), ["beh"] = 0, ["char"] = "boss ase" 
	}, ["e2"] = {
	 ["ang"] = Angle( 0, 180, 0 ), ["pos"] = Vector( -428, -14, 1 ), ["beh"] = 4, ["char"] = "boss lick" 
	} 
}
SCENE.AddThunder = true
SCENE.NoPickups = true
SCENE.Pickups = {
 ["w1"] = {
	 ["pos"] = Vector( 56, -176, 1 ), ["CheckTriggers"] = {
		 "t6", "t10" 
		}, ["wep"] = "sogm_dmca" 
	} 
}
SCENE.MusicText = "Ravayek - Menace"//"Owl Vision - Zyborg"
SCENE.Dialogues = {
 ["d2"] = {
	 {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_underscore_2013_6_npc", "sog_dialogue_underscore_2013_7_npc", "sog_dialogue_underscore_2013_8_npc", "sog_dialogue_underscore_2013_9_npc", "sog_dialogue_underscore_2013_10_npc" 
	} 
} 
	}, ["d1"] = {
	 {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_underscore_2013_1_npc" 
	} 
}, {
 ["person"] = "e2", ["text"] = {
	 "sog_dialogue_underscore_2013_2_npc" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_underscore_2013_3_npc" 
	} 
}, {
 ["person"] = "e2", ["text"] = {
	 "sog_dialogue_underscore_2013_4_npc" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_underscore_2013_5_npc" 
	} 
} 
	} 
}
SCENE.Characters = {
 "protagonist" 
}
SCENE.Name = "scene_name_underscore"
SCENE.Triggers = {
 ["t9"] = {
	 ["pos"] = Vector( -1120, -2, 73 ), ["size"] = 118, ["action"] = "nextlevel" 
	}, ["t5"] = {
	 ["action"] = "pauseenemies", ["pos"] = Vector( -570, 8, 1 ), ["data"] = "false", ["size"] = 151 
	}, ["t14"] = {
	 ["pos"] = Vector( 307, -337, 1 ), ["size"] = 55, ["event"] = "OnDialogueFinished", ["action"] = "event", ["data"] = {
		 "d2" 
		}, ["objects"] = {
		 "t12", "t13" 
		} 
	}, ["t12"] = {
	 ["CheckTriggers"] = {
		 "t14" 
		}, ["pos"] = Vector( 273, -198, 1 ), ["size"] = 55, ["action"] = "levelclear" 
	}, ["t1"] = {
	 ["action"] = "dialogue", ["pos"] = Vector( -742, -0, 49 ), ["size"] = 109, ["objects"] = {
		 "d1" 
		} 
	}, ["t13"] = {
	 ["pos"] = Vector( 421, -209, 1 ), ["CheckTriggers"] = {
		 "t14" 
		}, ["action"] = "hudmessage", ["size"] = 55, ["data"] = "sog_hud_obj_leave_area" 
	}, ["t7"] = {
	 ["pos"] = Vector( 124, -235, 1 ), ["CheckTriggers"] = {
		 "t8" 
		}, ["action"] = "dialogue", ["size"] = 60, ["objects"] = {
		 "d2" 
		} 
	}, ["t6"] = {
	 ["pos"] = Vector( 7, -279, 1 ), ["CheckTriggers"] = {
		 "t11" 
		}, ["action"] = "arrow", ["size"] = 60, ["objects"] = {
		 "w1" 
		} 
	}, ["t11"] = {
	 ["pos"] = Vector( -35, -446, 1 ), ["size"] = 55, ["event"] = "OnAllEnemiesKilled", ["action"] = "event", ["objects"] = {
		 "t10", "t6" 
		} 
	}, ["t8"] = {
	 ["pos"] = Vector( 146, -360, 1 ), ["size"] = 60, ["event"] = "OnWeaponRemoved", ["action"] = "event", ["data"] = {
		 "w1" 
		}, ["objects"] = {
		 "t7" 
		} 
	}, ["t2"] = {
	 ["action"] = "pauseenemies", ["pos"] = Vector( -862, 8, 73 ), ["data"] = "true", ["size"] = 60 
	}, ["t10"] = {
	 ["pos"] = Vector( -95, -286, 1 ), ["CheckTriggers"] = {
		 "t11" 
		}, ["action"] = "spawn", ["size"] = 55, ["objects"] = {
		 "w1" 
		} 
	}, ["t4"] = {
	 ["action"] = "pauseenemies", ["pos"] = Vector( -829, 313, 73 ), ["data"] = "false", ["size"] = 185 
	}, ["t3"] = {
	 ["action"] = "pauseenemies", ["pos"] = Vector( -829, -284, 73 ), ["data"] = "false", ["size"] = 185 
	} 
}
SCENE.PickupsPersistance = true
SCENE.SoundTrack = 192597956//195375501
SCENE.StartFrom = 52000
SCENE.Volume = 30
SCENE.BloodMoonScreen = true

SCENE.Initialize = function()
end

SCENE.Loaded = function()
	PLAYER_SPAWNPOINT = Vector( -871, 3, 73 )
end

