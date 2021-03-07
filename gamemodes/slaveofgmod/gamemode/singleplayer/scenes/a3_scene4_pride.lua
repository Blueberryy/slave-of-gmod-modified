SCENE.Order = 12
SCENE.Act = 3
SCENE.Map = "sog_garage_v1"
SCENE.Achievement = "pride"
SCENE.FlipView = true
SCENE.Enemies = {
 ["e12"] = {
	 ["pos"] = Vector( 1841, -546, 65 ), ["ang"] = Angle( 0, 173, 0 ), ["beh"] = 4, ["char"] = "kid", ["wep"] = "sogm_physcannon" 
	}, ["e5"] = {
	 ["pos"] = Vector( 1693, -531, 65 ), ["ang"] = Angle( 0, -4, 0 ), ["beh"] = 4, ["char"] = "kid", ["wep"] = "sogm_pipe" 
	}, ["e3"] = {
	 ["ang"] = Angle( 0, -132, 0 ), ["pos"] = Vector( 1824, -498, 65 ), ["char"] = "kid", ["beh"] = 4, ["wep"] = "sogm_pipe" 
	}, ["e4"] = {
	 ["pos"] = Vector( 1766, -454, 65 ), ["ang"] = Angle( 0, -90, 0 ), ["beh"] = 4, ["char"] = "kid", ["wep"] = "sogm_physcannon" 
	}, ["e1"] = {
	 ["pos"] = Vector( 1757, -544, 65 ), ["anim"] = "taunt_muscle_base", ["ang"] = Angle( 0, 0, 0 ), ["CheckTriggers"] = {
		 "t9" 
		}, ["beh"] = 0, ["char"] = "boss sellout" 
	}, ["e2"] = {
	 ["ang"] = Angle( 0, 130, 0 ), ["pos"] = Vector( 1815, -606, 65 ), ["char"] = "banned", ["beh"] = 4 
	}, ["e6"] = {
	 ["ang"] = Angle( 0, 66, 0 ), ["pos"] = Vector( 1734, -625, 65 ), ["char"] = "thug kid", ["beh"] = 4 
	} 
}
SCENE.StartFromAmbient = true
SCENE.BloodyScreen = false
SCENE.AddThunder = true
SCENE.StartFrom = 42900
SCENE.EndAt = 240000//223000
SCENE.SoundTrack = 236488787//5323848
SCENE.Ambient = 236488787
SCENE.AmbientEndAt = 42800//36000
SCENE.AmbientStartFrom = 12500 
SCENE.AmbientVolume = 40
SCENE.MusicText = "Fixions - Gremlins 2 - The Office (NES)"
SCENE.Dialogues = {
 ["d2"] = {
	 {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_clickbait_2013_24_npc", "sog_dialogue_clickbait_2013_25_npc" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_clickbait_2013_26_npc" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_clickbait_2013_27_npc", "sog_dialogue_clickbait_2013_28_npc", "sog_dialogue_clickbait_2013_29_npc", "sog_dialogue_clickbait_2013_30_npc", "sog_dialogue_clickbait_2013_31_npc", "sog_dialogue_clickbait_2013_32_npc", "sog_dialogue_clickbait_2013_33_npc" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_clickbait_2013_34_npc" 
	} 
} 
	}, ["d1"] = {
	 {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_clickbait_2013_1_npc" ,"sog_dialogue_clickbait_2013_2_npc", "sog_dialogue_clickbait_2013_3_npc"
	} 
}, {
 ["person"] = "e4", ["text"] = {
	 "sog_dialogue_clickbait_2013_4_npc" 
	} 
}, {
 ["person"] = "e3", ["text"] = {
	 "sog_dialogue_clickbait_2013_5_npc" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_clickbait_2013_6_npc", "sog_dialogue_clickbait_2013_7_npc" 
	} 
}, {
 ["person"] = "e5", ["text"] = {
	 "sog_dialogue_clickbait_2013_8_npc" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_clickbait_2013_9_npc", "sog_dialogue_clickbait_2013_10_npc" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_clickbait_2013_11_npc", "sog_dialogue_clickbait_2013_12_npc" 
	} 
}, {
 ["person"] = "e4", ["text"] = {
	 "sog_dialogue_clickbait_2013_13_npc" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_clickbait_2013_14_npc", "sog_dialogue_clickbait_2013_15_npc", "sog_dialogue_clickbait_2013_16_npc", "sog_dialogue_clickbait_2013_17_npc", "sog_dialogue_clickbait_2013_18_npc", "sog_dialogue_clickbait_2013_19_npc", "sog_dialogue_clickbait_2013_20_npc", "sog_dialogue_clickbait_2013_21_npc" 
	} 
}, {
 ["person"] = "e5", ["text"] = {
	 "sog_dialogue_clickbait_2013_22_npc" 
	} 
}, {
 ["person"] = "e3", ["text"] = {
	 "sog_dialogue_clickbait_2013_23_npc" 
	} 
} 
	} 
}
SCENE.Characters = {
 "axe guy" 
}
SCENE.Name = "scene_name_clickbait"
SCENE.BloodMoonScreen = true
SCENE.Volume = 40
SCENE.LightStyle = "c"
SCENE.Triggers = {
 ["t5"] = {
	 ["pos"] = Vector( 1832, -296, 65 ), ["size"] = 10, ["event"] = "OnNextBotKnockdown", ["action"] = "event", ["data"] = {
		 "e1" 
		}, ["objects"] = {
		 "t4" 
		} 
	}, ["t1"] = {
	 ["pos"] = Vector( 2120, -539, 65 ), ["data"] = "true", ["action"] = "pauseenemies", ["size"] = 60, ["trigger_once"] = true 
	}, ["t11"] = {
	 ["pos"] = Vector( 1957, -633, 65 ), ["size"] = 10, ["event"] = "OnDialogueFinished", ["action"] = "event", ["data"] = {
		 "d1" 
		}, ["objects"] = {
		 "t10" 
		} 
	}, ["t10"] = {
	 ["CheckTriggers"] = {
		 "t11" 
		}, ["pos"] = Vector( 1985, -668, 65 ), ["size"] = 10, ["trigger_once"] = true, ["action"] = "playmusic" 
	}, ["t6"] = {
	 ["pos"] = Vector( 2420, -396, 65 ), ["size"] = 122, ["action"] = "nextlevel" 
	}, ["t9"] = {
	 ["action"] = "arrow", ["pos"] = Vector( 2126, -542, 65 ), ["size"] = 60, ["objects"] = {
		 "e1" 
		} 
	}, ["t8"] = {
	 ["pos"] = Vector( 2216, -268, 65 ), ["size"] = 10, ["event"] = "OnLevelClear", ["action"] = "event", ["objects"] = {
		 "t7" 
		} 
	}, ["t7"] = {
	 ["pos"] = Vector( 2272, -196, 65 ), ["CheckTriggers"] = {
		 "t8" 
		}, ["action"] = "hudmessage", ["data"] = "sog_hud_obj_go_to_car", ["size"] = 10 
	}, ["t2"] = {
	 ["pos"] = Vector( 2103, -707, 65 ), ["size"] = 10, ["action"] = "dialogue", ["CheckTriggers"] = {
		 "t3" 
		}, ["objects"] = {
		 "d1" 
		} 
	}, ["t4"] = {
	 ["pos"] = Vector( 1764, -324, 65 ), ["size"] = 10, ["action"] = "dialogue", ["CheckTriggers"] = {
		 "t5" 
		}, ["objects"] = {
		 "d2" 
		} 
	}, ["t3"] = {
	 ["pos"] = Vector( 2090, -835, 65 ), ["size"] = 10, ["event"] = "OnLevelLoaded", ["action"] = "event", ["objects"] = {
		 "t2" 
		} 
	} 
}
SCENE.NoPickups = true
SCENE.Pickups = {
 
}
SCENE.PickupsPersistance = true
SCENE.Vehicle = {
 ["pos"] = Vector( 2423, -477, 65 ), ["mdl"] = "models/props/de_nuke/car_nuke_black.mdl", ["type"] = 1, ["glass_mdl"] = "models/props/de_nuke/car_nuke_glass.mdl", ["ang"] = Angle( 0, 77, 0 ) 
}

SCENE.Initialize = function()
end

SCENE.Loaded = function()
	PLAYER_SPAWNPOINT = Vector( 2124, -540, 65 )
end

