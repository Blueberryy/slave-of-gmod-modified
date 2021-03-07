SCENE.Order = 20
SCENE.Act = 5
SCENE.Map = "sog_apartments"
SCENE.Achievement = "gluttony"
SCENE.FlipView = true
SCENE.Enemies = {
 ["e5"] = {
	 ["pos"] = Vector( 2897, -471, 1 ), ["anim"] = "idle_all_cower", ["ang"] = Angle( 0, 94, 0 ), ["beh"] = 2, ["char"] = "mutilated banned" 
	}, ["e3"] = {
	 ["pos"] = Vector( -53, -651, 1 ), ["ang"] = Angle( 0, -86, 0 ), ["beh"] = 2, ["char"] = "mutilated kid", ["wep"] = "sogm_physcannon" 
	}, ["e4"] = {
	 ["pos"] = Vector( 2559, 232, 1 ), ["ang"] = Angle( 0, -86, 0 ), ["beh"] = 2, ["char"] = "mutilated kid", ["wep"] = "sogm_physcannon" 
	}, ["e1"] = {
	 ["ang"] = Angle( 0, -102, 0 ), ["pos"] = Vector( 1230, -155, 12 ), ["beh"] = -1, ["char"] = "boss master" 
	}, ["e6"] = {
	 ["pos"] = Vector( 295, 678, 1 ), ["anim"] = "idle_all_cower", ["ang"] = Angle( 0, -1, 0 ), ["beh"] = 2, ["char"] = "mutilated kid", ["wep"] = "sogm_physcannon" 
	} 
}
SCENE.Terror = true
SCENE.AddThunder = true
SCENE.Volume = 41
SCENE.SoundTrack = 137503500
SCENE.MusicText = "Nemix - Monster"
SCENE.Dialogues = {
 ["d2"] = {
	 {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_evasion_2014_18_npc", "sog_dialogue_evasion_2014_19_npc" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_evasion_2014_20_npc", "sog_dialogue_evasion_2014_21_npc", "sog_dialogue_evasion_2014_22_npc", "sog_dialogue_evasion_2014_23_npc", "sog_dialogue_evasion_2014_24_npc", "sog_dialogue_evasion_2014_25_npc" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_evasion_2014_26_npc", "sog_dialogue_evasion_2014_27_npc" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_evasion_2014_28_npc" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_evasion_2014_29_npc", "sog_dialogue_evasion_2014_30_npc", "sog_dialogue_evasion_2014_31_npc", "sog_dialogue_evasion_2014_32_npc", "sog_dialogue_evasion_2014_33_npc", "sog_dialogue_evasion_2014_34_npc" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_evasion_2014_35_npc" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_evasion_2014_36_npc", "sog_dialogue_evasion_2014_37_npc" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_evasion_2014_38_npc" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_evasion_2014_39_npc", "sog_dialogue_evasion_2014_40_npc", "sog_dialogue_evasion_2014_41_npc", "sog_dialogue_evasion_2014_42_npc", "sog_dialogue_evasion_2014_43_npc", "sog_dialogue_evasion_2014_44_npc" 
	} 
} 
	}, ["d1"] = {
	 {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_evasion_2014_1_npc", "sog_dialogue_evasion_2014_2_npc" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_evasion_2014_3_npc", "sog_dialogue_evasion_2014_4_npc", "sog_dialogue_evasion_2014_5_npc" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_evasion_2014_6_npc" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_evasion_2014_7_npc", "sog_dialogue_evasion_2014_8_npc", "sog_dialogue_evasion_2014_9_npc", "sog_dialogue_evasion_2014_10_npc" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_evasion_2014_11_npc", "sog_dialogue_evasion_2014_12_npc" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_evasion_2014_13_npc", "sog_dialogue_evasion_2014_14_npc", "sog_dialogue_evasion_2014_15_npc", "sog_dialogue_evasion_2014_16_npc", "sog_dialogue_evasion_2014_17_npc" 
	} 
} 
	} 
}
SCENE.Characters = {
 "protagonist" 
}
SCENE.Name = "scene_name_tax_evasion"
SCENE.Triggers = {
 ["t14"] = {
	 ["CheckTriggers"] = {
		 "t15" 
		}, ["pos"] = Vector( 1234, 205, 1 ), ["size"] = 10, ["action"] = "pauseenemies", ["data"] = "true" 
	}, ["t5"] = {
	 ["pos"] = Vector( 1205, 31, -3 ), ["size"] = 10, ["action"] = "spawn", ["CheckTriggers"] = {
		 "t6" 
		}, ["objects"] = {
		 "t4" 
		} 
	}, ["t15"] = {
	 ["pos"] = Vector( 1171, 219, 1 ), ["size"] = 10, ["event"] = "OnLevelClear", ["action"] = "event", ["objects"] = {
		 "t14" 
		} 
	}, ["t9"] = {
	 ["pos"] = Vector( 2865, -10, 1 ), ["size"] = 10, ["event"] = "OnDialogueFinished", ["action"] = "event", ["data"] = {
		 "d2" 
		}, ["objects"] = {
		 "t8" 
		} 
	}, ["t1"] = {
	 ["pos"] = Vector( 949, 91, 7 ), ["size"] = 10, ["action"] = "dialogue", ["CheckTriggers"] = {
		 "t2" 
		}, ["objects"] = {
		 "d1" 
		} 
	}, ["t10"] = {
	 ["pos"] = Vector( 1037, 106, 7 ), ["data"] = "sog_hud_obj_leave_area", ["action"] = "hudmessage", ["size"] = 10, ["CheckTriggers"] = {
		 "t11" 
		} 
	}, ["t13"] = {
	 ["pos"] = Vector( 960, -463, 1 ), ["size"] = 10, ["event"] = "OnDialogueFinished", ["action"] = "event", ["data"] = {
		 "d2" 
		}, ["objects"] = {
		 "t12" 
		} 
	}, ["t12"] = {
	 ["pos"] = Vector( 960, -540, 1 ), ["data"] = "true", ["action"] = "pauseenemies", ["size"] = 10, ["CheckTriggers"] = {
		 "t13" 
		} 
	}, ["t6"] = {
	 ["pos"] = Vector( 1098, 170, 1 ), ["size"] = 10, ["event"] = "OnLevelClear", ["action"] = "event", ["objects"] = {
		 "t5", "t3" 
		} 
	}, ["t7"] = {
	 ["size"] = 71, ["pos"] = Vector( 2931, 176, 3 ), ["CheckTriggers"] = {
		 "t8" 
		}, ["action"] = "nextlevel" 
	}, ["t8"] = {
	 ["pos"] = Vector( 2907, 26, 1 ), ["size"] = 10, ["action"] = "spawn", ["CheckTriggers"] = {
		 "t9" 
		}, ["objects"] = {
		 "t7" 
		} 
	}, ["t2"] = {
	 ["pos"] = Vector( 949, 140, 1 ), ["size"] = 10, ["event"] = "OnLevelLoaded", ["action"] = "event", ["objects"] = {
		 "t1" 
		} 
	}, ["t11"] = {
	 ["pos"] = Vector( 1052, 26, -3 ), ["size"] = 10, ["event"] = "OnDialogueFinished", ["action"] = "event", ["data"] = {
		 "d2" 
		}, ["objects"] = {
		 "t10" 
		} 
	}, ["t4"] = {
	 ["pos"] = Vector( 1128, -151, -2 ), ["size"] = 122, ["action"] = "dialogue", ["CheckTriggers"] = {
		 "t5" 
		}, ["objects"] = {
		 "d2" 
		} 
	}, ["t3"] = {
	 ["pos"] = Vector( 940, 374, 1 ), ["data"] = "sog_hud_obj_return_to_master", ["action"] = "hudmessage", ["size"] = 10, ["CheckTriggers"] = {
		 "t6" 
		} 
	} 
}
SCENE.PickupsPersistance = true
SCENE.BloodMoonScreen = true
SCENE.NoPickups = true
SCENE.Pickups = {
 ["w1"] = {
	 ["wep"] = "sogm_pipe", ["pos"] = Vector( 1595, 365, 1 ) 
	}, ["w2"] = {
	 ["wep"] = "sogm_physcannon", ["pos"] = Vector( 1004, -89, 19 ) 
	} 
}
SCENE.DisableNextbotLights = false

SCENE.Initialize = function()
end

SCENE.Loaded = function()
	PLAYER_SPAWNPOINT = Vector( 1017, -133, 18 )
end
 