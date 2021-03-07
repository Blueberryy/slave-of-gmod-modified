SCENE.Order = 11
SCENE.Act = 3
SCENE.Map = "sog_oxy_v1"
SCENE.Name = "scene_name_whistleblower"
SCENE.ShowLastEnemies = true
SCENE.Pickups = {
 //["w1"] = {
	 //["wep"] = "sogm_axe", ["pos"] = Vector( -621, 2242, 1 ) 
	//} 
}
SCENE.Enemies = {
 ["e3"] = {
	 ["ang"] = Angle( 0, 90, 0 ), ["pos"] = Vector( -637, 1943, 1 ), ["beh"] = 1, ["char"] = "greed crew default" 
	}, ["e11"] = {
	 ["ang"] = Angle( 0, 100, 0 ), ["pos"] = Vector( 193, 1853, 1 ), ["beh"] = 2, ["char"] = "greed crew trusted" 
	}, ["e4"] = {
	 ["ang"] = Angle( 0, -86, 0 ), ["pos"] = Vector( -630, 1987, 1 ), ["beh"] = 0, ["char"] = "greed crew starter" 
	}, ["e18"] = {
	 ["ang"] = Angle( 0, 94, 0 ), ["pos"] = Vector( 64, -39, 1 ), ["beh"] = 1, ["char"] = "greed crew shield" 
	}, ["e8"] = {
	 ["ang"] = Angle( 0, 180, 0 ), ["pos"] = Vector( -813, 1223, 1 ), ["beh"] = 4, ["char"] = "banned" 
	}, ["e5"] = {
	 ["ang"] = Angle( 0, -86, 0 ), ["pos"] = Vector( -597, 1389, 1 ), ["beh"] = 2, ["char"] = "greed crew leaker" 
	}, ["e6"] = {
	 ["ang"] = Angle( 0, 5, 0 ), ["pos"] = Vector( -1196, 951, 1 ), ["beh"] = 0, ["char"] = "greed crew starter" 
	}, ["e14"] = {
	 ["ang"] = Angle( 0, 5, 0 ), ["pos"] = Vector( 562, 422, 1 ), ["beh"] = 2, ["char"] = "greed crew featured" 
	}, ["e19"] = {
	 ["ang"] = Angle( 0, 94, 0 ), ["pos"] = Vector( 826, 917, 1 ), ["beh"] = 2, ["char"] = "greed crew premium" 
	}, ["e9"] = {
	 ["ang"] = Angle( 0, 180, 0 ), ["pos"] = Vector( -620, 797, 1 ), ["beh"] = 2, ["char"] = "greed crew shield" 
	}, ["e7"] = {
	 ["ang"] = Angle( 0, 180, 0 ), ["pos"] = Vector( -891, 1223, 1 ), ["beh"] = 2, ["char"] = "greed crew trusted" 
	}, ["e16"] = {
	 ["ang"] = Angle( 0, 94, 0 ), ["pos"] = Vector( -448, 585, 1 ), ["beh"] = 2, ["char"] = "greed crew trusted" 
	}, ["e10"] = {
	 ["ang"] = Angle( 0, 2, 0 ), ["pos"] = Vector( -210, 1090, 1 ), ["beh"] = 2, ["char"] = "greed crew thug" 
	}, ["e20"] = {
	 ["ang"] = Angle( 0, -86, 0 ), ["pos"] = Vector( 92, 2350, 1 ), ["beh"] = 2, ["char"] = "banned" 
	}, ["e15"] = {
	 ["ang"] = Angle( 0, 180, 0 ), ["pos"] = Vector( -348, 70, 1 ), ["beh"] = 2, ["char"] = "greed crew featured" 
	}, ["e1"] = {
	 ["pos"] = Vector( 482, -315, 1 ), ["anim"] = "idle_all_cower", ["char"] = "kid", ["ang"] = Angle( 0, 0, 0 ), ["beh"] = -1, ["immune"] = true 
	}, ["e2"] = {
	 ["ang"] = Angle( 0, -16, 0 ), ["pos"] = Vector( 419, -285, 1 ), ["beh"] = 1, ["char"] = "greed crew leaker" 
	}, ["e17"] = {
	 ["ang"] = Angle( 0, 5, 0 ), ["pos"] = Vector( 191, 73, 1 ), ["beh"] = 2, ["char"] = "greed crew trusted" 
	}, ["e13"] = {
	 ["ang"] = Angle( 0, 180, 0 ), ["pos"] = Vector( 392, 1348, 1 ), ["beh"] = 0, ["char"] = "greed crew thug" 
	} 
}
SCENE.Characters = {
 "axe guy" 
}
SCENE.PickupsPersistance = true
SCENE.NoPickups = true
SCENE.Triggers = {
 ["t5"] = {
	 ["size"] = 98, ["pos"] = Vector( -641, 2228, 1 ), ["CheckTriggers"] = {
		 "t11" 
		}, ["action"] = "nextlevel" 
	}, ["t1"] = {
	 ["pos"] = Vector( -631, 2248, 1 ), ["data"] = "true", ["action"] = "pauseenemies", ["size"] = 60, ["trigger_once"] = true 
	}, ["t9"] = {
	 ["pos"] = Vector( 307, -207, 1 ), ["data"] = "sog_hud_obj_interrogate", ["action"] = "hudmessage", ["size"] = 10, ["CheckTriggers"] = {
		 "t10" 
		} 
	}, ["t10"] = {
	 ["pos"] = Vector( 279, -150, 1 ), ["size"] = 10, ["event"] = "OnLevelClear", ["action"] = "event", ["objects"] = {
		 "t9", "t8" 
		} 
	}, ["t6"] = {
	 ["pos"] = Vector( 496, -312, 1 ), ["size"] = 63, ["action"] = "dialogue", ["CheckTriggers"] = {
		 "t8" 
		}, ["objects"] = {
		 "d2" 
		} 
	}, ["t11"] = {
	 ["pos"] = Vector( 298, -29, 1 ), ["size"] = 10, ["event"] = "OnDialogueFinished", ["action"] = "event", ["data"] = {
		 "d2" 
		}, ["objects"] = {
		 "t5" 
		} 
	}, ["t8"] = {
	 ["pos"] = Vector( 341, -158, 1 ), ["size"] = 10, ["action"] = "spawn", ["CheckTriggers"] = {
		 "t10" 
		}, ["objects"] = {
		 "t6" 
		} 
	}, ["t2"] = {
	 ["pos"] = Vector( -799, 2246, 1 ), ["size"] = 10, ["action"] = "dialogue", ["CheckTriggers"] = {
		 "t3" 
		}, ["objects"] = {
		 "d1" 
		} 
	}, ["t3"] = {
	 ["pos"] = Vector( -816, 2192, 1 ), ["size"] = 10, ["event"] = "OnLevelLoaded", ["action"] = "event", ["objects"] = {
		 "t2" 
		} 
	} 
}
SCENE.StartFrom = 8000//10000
SCENE.EndAt = 198000//10000
SCENE.AddThunder = true
SCENE.Volume = 35
SCENE.SoundTrack = 219807497//129311883
SCENE.MusicText = "Street Fever - Chamber"//"Francophilippe - Caesar"
SCENE.Dialogues = {
 ["d2"] = {
	 {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_whisteblower_2013_5_npc", "sog_dialogue_whisteblower_2013_6_npc" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_whisteblower_2013_7_npc", "sog_dialogue_whisteblower_2013_8_npc" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_whisteblower_2013_9_npc", "sog_dialogue_whisteblower_2013_10_npc", "sog_dialogue_whisteblower_2013_11_npc", "sog_dialogue_whisteblower_2013_12_npc" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_whisteblower_2013_13_npc", "sog_dialogue_whisteblower_2013_14_npc", "sog_dialogue_whisteblower_2013_15_npc" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_whisteblower_2013_16_npc", "sog_dialogue_whisteblower_2013_17_npc" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_whisteblower_2013_18_npc", "sog_dialogue_whisteblower_2013_19_npc", "sog_dialogue_whisteblower_2013_20_npc" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_whisteblower_2013_21_npc", "sog_dialogue_whisteblower_2013_22_npc" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_whisteblower_2013_23_npc", "sog_dialogue_whisteblower_2013_24_npc" 
	} 
} 
	}, ["d1"] = {
	 {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_whisteblower_2013_1_npc", "sog_dialogue_whisteblower_2013_2_npc", "sog_dialogue_whisteblower_2013_3_npc", "sog_dialogue_whisteblower_2013_4_npc" 
	} 
} 
	} 
}

SCENE.Initialize = function()
end

SCENE.Loaded = function()
	PLAYER_SPAWNPOINT = Vector( -638, 2248, 1 )
end
 