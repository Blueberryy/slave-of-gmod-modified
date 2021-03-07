SCENE.Order = 26
SCENE.Act = 7
SCENE.Map = "sog_sawmill_v1"
SCENE.Cover = Material( "sog/covers/dvd_disk_default_bonus.png" , "alphatest")
SCENE.NoPickupsRespawn = true
SCENE.Enemies = {
 ["e8"] = {
	 ["pos"] = Vector( 297, 413, 17 ), ["ang"] = Angle( 0, -74, 0 ), ["beh"] = 1, ["stages"] = {
		 3 
		}, ["char"] = "camera crew" 
	}, ["e5"] = {
	 ["pos"] = Vector( 1082, 98, 17 ), ["stages"] = {
		 1, 3 
		}, ["ang"] = Angle( 0, -96, 0 ), ["beh"] = 2, ["char"] = "camera crew" 
	}, ["e3"] = {
	 ["pos"] = Vector( 343, 300, 17 ), ["stages"] = {
		 1 
		}, ["ang"] = Angle( 0, 180, 0 ), ["beh"] = 0, ["char"] = "camera crew" 
	}, ["e15"] = {
	 ["pos"] = Vector( -125, 231, 17 ), ["char"] = "security guard", ["beh"] = 2, ["ang"] = Angle( 0, 0, 0 ), ["stages"] = {
		 3 
		}, ["wep"] = "sogm_axe" 
	}, ["e14"] = {
	 ["pos"] = Vector( 170, 245, 17 ), ["stages"] = {
		 1 
		}, ["char"] = "camera crew", ["ang"] = Angle( 0, -4, 0 ), ["beh"] = 0 
	}, ["e12"] = {
	 ["pos"] = Vector( 1118, 138, 17 ), ["char"] = "security guard", ["beh"] = 2, ["ang"] = Angle( 0, 87, 0 ), ["stages"] = {
		 3 
		}, ["wep"] = "sogm_axe" 
	}, ["e13"] = {
	 ["pos"] = Vector( -20, 352, 17 ), ["stages"] = {
		 1, 3 
		}, ["char"] = "camera crew", ["ang"] = Angle( 0, 20, 0 ), ["beh"] = 0 
	}, ["e7"] = {
	 ["pos"] = Vector( 742, 273, 17 ), ["stages"] = {
		 1 
		}, ["ang"] = Angle( 0, 90, 0 ), ["beh"] = 2, ["char"] = "camera crew" 
	}, ["e16"] = {
	 ["stages"] = {
		 3 
		}, ["pos"] = Vector( 61, -637, 1 ), ["anim"] = "idle_all_cower", ["CheckTriggers"] = {
		 "t31" 
		}, ["char"] = "server owner", ["ang"] = Angle( 0, 42, 0 ), ["immune"] = true, ["beh"] = -1 
	}, ["e6"] = {
	 ["pos"] = Vector( 505, 351, 17 ), ["stages"] = {
		 3, 1 
		}, ["ang"] = Angle( 0, 0, 0 ), ["beh"] = 2, ["char"] = "camera crew" 
	}, ["e10"] = {
	 ["pos"] = Vector( 732, -21, 17 ), ["stages"] = {
		 3 
		}, ["ang"] = Angle( 0, 42, 0 ), ["beh"] = 1, ["char"] = "camera crew", ["wep"] = "sogm_sawblade" 
	}, ["e4"] = {
	 ["pos"] = Vector( 384, 320, 17 ), ["stages"] = {
		 1 
		}, ["ang"] = Angle( 0, 180, 0 ), ["beh"] = 4, ["char"] = "camera crew" 
	}, ["e1"] = {
	 ["CheckTriggers"] = {
		 "t11", "t13", "t14", "t18" 
		}, ["pos"] = Vector( 515, 168, 150 ), ["anim"] = "taunt_dance_base", ["opt"] = true, ["immune"] = true, ["ang"] = Angle( 0, -93, 0 ), ["beh"] = -1, ["char"] = "saw hero" 
	}, ["e2"] = {
	 ["pos"] = Vector( 45, 128, 17 ), ["stages"] = {
		 1 
		}, ["ang"] = Angle( 0, -62, 0 ), ["beh"] = 0, ["char"] = "camera crew" 
	}, ["e9"] = {
	 ["pos"] = Vector( 1157, 401, 17 ), ["stages"] = {
		 1, 3 
		}, ["ang"] = Angle( 0, -123, 0 ), ["beh"] = 1, ["char"] = "camera crew" 
	}, ["e11"] = {
	 ["pos"] = Vector( 934, 332, 17 ), ["ang"] = Angle( 0, -178, 0 ), ["char"] = "security guard", ["beh"] = 0, ["stages"] = {
		 3 
		} 
	} 
}
SCENE.StartFromAmbient = true
SCENE.PickupsPersistance = true
SCENE.StartFrom = 9000
SCENE.SoundTrack = 240089474
SCENE.MusicText = "Hollywood Burns - Burn Hard"
SCENE.Dialogues = {
 ["d2"] = {
	 {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_overdrive_2016_17_npc", "sog_dialogue_overdrive_2016_18_npc", "sog_dialogue_overdrive_2016_19_npc" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_overdrive_2016_20_npc", "sog_dialogue_overdrive_2016_21_npc" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_overdrive_2016_22_npc", "sog_dialogue_overdrive_2016_23_npc" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_overdrive_2016_24_npc", "sog_dialogue_overdrive_2016_25_npc", "sog_dialogue_overdrive_2016_26_npc", "sog_dialogue_overdrive_2016_27_npc" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_overdrive_2016_28_npc", "sog_dialogue_overdrive_2016_29_npc" 
	} 
} 
	}, ["d1"] = {
	 {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_overdrive_2016_1_npc", "sog_dialogue_overdrive_2016_2_npc", "sog_dialogue_overdrive_2016_3_npc" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_overdrive_2016_4_npc", "sog_dialogue_overdrive_2016_5_npc", "sog_dialogue_overdrive_2016_6_npc" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_overdrive_2016_7_npc" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_overdrive_2016_8_npc", "sog_dialogue_overdrive_2016_9_npc" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_overdrive_2016_10_npc" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_overdrive_2016_11_npc", "sog_dialogue_overdrive_2016_12_npc" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_overdrive_2016_13_npc", "sog_dialogue_overdrive_2016_14_npc", "sog_dialogue_overdrive_2016_15_npc" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_overdrive_2016_16_npc" 
	} 
} 
	}, ["d3"] = {
	 {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_overdrive_2016_30_npc", "sog_dialogue_overdrive_2016_31_npc", "sog_dialogue_overdrive_2016_32_npc", "sog_dialogue_overdrive_2016_33_npc", "sog_dialogue_overdrive_2016_34_npc" 
	} 
}, {
 ["person"] = "e16", ["text"] = {
	 "sog_dialogue_overdrive_2016_35_npc" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_overdrive_2016_36_npc", "sog_dialogue_overdrive_2016_37_npc" 
	} 
}, {
 ["person"] = "e16", ["text"] = {
	 "sog_dialogue_overdrive_2016_38_npc" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_overdrive_2016_39_npc" 
	} 
} 
	} 
}
SCENE.Vehicle = {
 ["type"] = 10, ["pos"] = Vector( 390, -408, 36 ), ["mdl"] = "models/props_vehicles/car005a.mdl", ["ang"] = Angle( 0, -59, 0 ) 
}
SCENE.Characters = {
 "watch" 
}
SCENE.Name = "scene_name_overdrive"
SCENE.Triggers = {
 ["t18"] = {
	 ["pos"] = Vector( 771, 43, 17 ), ["size"] = 10, ["trigger_once"] = true, ["action"] = "arrow", ["CheckTriggers"] = {
		 "t19" 
		}, ["objects"] = {
		 "e1" 
		} 
	}, ["t14"] = {
	 ["pos"] = Vector( -41, 577, 17 ), ["size"] = 10, ["trigger_once"] = true, ["stages"] = {
		 2, 3 
		}, ["action"] = "remove_optional", ["CheckTriggers"] = {
		 "t17" 
		}, ["objects"] = {
		 "e1" 
		} 
	}, ["t1"] = {
	 ["pos"] = Vector( 139, -12, 17 ), ["CheckTriggers"] = {
		 "t2" 
		}, ["action"] = "playmusic", ["size"] = 10, ["trigger_once"] = true 
	}, ["t27"] = {
	 ["pos"] = Vector( 496, -574, 1 ), ["size"] = 10, ["event"] = "OnDialogueFinished", ["action"] = "event", ["data"] = {
		 "d3" 
		}, ["objects"] = {
		 "t26" 
		} 
	}, ["t10"] = {
	 ["pos"] = Vector( 46, 248, 17 ), ["size"] = 10, ["event"] = "OnDialogueFinished", ["action"] = "event", ["data"] = {
		 "d2" 
		}, ["objects"] = {
		 "t9" 
		} 
	}, ["t12"] = {
	 ["pos"] = Vector( -43, 449, 17 ), ["size"] = 10, ["data"] = {
		 ["start"] = 148800, ["endpos"] = 331000 
		}, ["stages"] = {
		 2, 3 
		}, ["action"] = "music_time", ["CheckTriggers"] = {
		 "t17" 
		}, ["trigger_once"] = true 
	}, ["t28"] = {
	 ["pos"] = Vector( 8, -346, 1 ), ["CheckTriggers"] = {
		 "t29" 
		}, ["data"] = "sog_hud_obj_leave_area", ["stages"] = {
		 3 
		}, ["action"] = "hudmessage", ["size"] = 10, ["trigger_once"] = true 
	}, ["t20"] = {
	 ["pos"] = Vector( 823, 82, 17 ), ["CheckTriggers"] = {
		 "t21" 
		}, ["action"] = "removearrows", ["size"] = 10, ["trigger_once"] = true 
	}, ["t29"] = {
	 ["pos"] = Vector( -66, -340, 1 ), ["size"] = 10, ["event"] = "OnLevelClear", ["action"] = "event", ["objects"] = {
		 "t28" 
		} 
	}, ["t13"] = {
	 ["pos"] = Vector( -56, 525, 17 ), ["size"] = 10, ["trigger_once"] = true, ["stages"] = {
		 2, 3 
		}, ["action"] = "remove_immune", ["CheckTriggers"] = {
		 "t17" 
		}, ["objects"] = {
		 "e1" 
		} 
	}, ["t16"] = {
	 ["pos"] = Vector( 111, -267, 1 ), ["size"] = 10, ["event"] = "OnAllEnemiesKilled", ["action"] = "event", ["objects"] = {
		 "t15" 
		} 
	}, ["t8"] = {
	 ["pos"] = Vector( -30, 285, 17 ), ["size"] = 10, ["event"] = "OnAllEnemiesKilled", ["action"] = "event", ["objects"] = {
		 "t7" 
		} 
	}, ["t25"] = {
	 ["pos"] = Vector( 527, -323, 1 ), ["CheckTriggers"] = {
		 "t30" 
		}, ["stages"] = {
		 3 
		}, ["action"] = "spawn", ["size"] = 10, ["objects"] = {
		 "t24" 
		} 
	}, ["t32"] = {
	 ["pos"] = Vector( -31, -502, 1 ), ["size"] = 10, ["event"] = "OnLevelClear", ["action"] = "event", ["objects"] = {
		 "t31" 
		} 
	}, ["t4"] = {
	 ["pos"] = Vector( 52, 46, 17 ), ["size"] = 10, ["event"] = "OnLevelLoaded", ["action"] = "event", ["objects"] = {
		 "t3" 
		} 
	}, ["t9"] = {
	 ["pos"] = Vector( 10, 188, 17 ), ["data"] = 3, ["stages"] = {
		 2 
		}, ["action"] = "activate_stage", ["size"] = 10, ["CheckTriggers"] = {
		 "t10" 
		} 
	}, ["t21"] = {
	 ["pos"] = Vector( 916, 82, 17 ), ["size"] = 10, ["event"] = "OnDialogueStarted", ["action"] = "event", ["data"] = {
		 "d2" 
		}, ["objects"] = {
		 "t20" 
		} 
	}, ["t30"] = {
	 ["pos"] = Vector( 506, -219, 1 ), ["size"] = 10, ["event"] = "OnLevelClear", ["action"] = "event", ["objects"] = {
		 "t25" 
		} 
	}, ["t5"] = {
	 ["pos"] = Vector( 534, 112, 17 ), ["size"] = 55, ["stages"] = {
		 2 
		}, ["action"] = "dialogue", ["CheckTriggers"] = {
		 "t6" 
		}, ["objects"] = {
		 "d2" 
		} 
	}, ["t15"] = {
	 ["pos"] = Vector( 42, -278, 1 ), ["CheckTriggers"] = {
		 "t16" 
		}, ["stages"] = {
		 3 
		}, ["action"] = "levelclear", ["size"] = 10 
	}, ["t19"] = {
	 ["pos"] = Vector( 859, -1, 17 ), ["size"] = 10, ["event"] = "OnStageStart", ["action"] = "event", ["data"] = 2, ["objects"] = {
		 "t18" 
		} 
	}, ["t3"] = {
	 ["pos"] = Vector( 28, -1, 17 ), ["size"] = 10, ["action"] = "dialogue", ["CheckTriggers"] = {
		 "t4" 
		}, ["objects"] = {
		 "d1" 
		} 
	}, ["t26"] = {
	 ["pos"] = Vector( 425, -617, 1 ), ["CheckTriggers"] = {
		 "t27" 
		}, ["stages"] = {
		 3 
		}, ["action"] = "nextlevel", ["size"] = 10 
	}, ["t17"] = {
	 ["pos"] = Vector( 31, 405, 17 ), ["size"] = 10, ["event"] = "OnStageStart", ["action"] = "event", ["data"] = 3, ["objects"] = {
		 "t12", "t13", "t11", "t14" 
		} 
	}, ["t23"] = {
	 ["pos"] = Vector( 34, 665, 1 ), ["size"] = 10, ["event"] = "OnStageStart", ["action"] = "event", ["data"] = 3, ["objects"] = {
		 "t22" 
		} 
	}, ["t6"] = {
	 ["pos"] = Vector( 536, 252, 17 ), ["size"] = 55, ["stages"] = {
		 2 
		}, ["action"] = "linker", ["objects"] = {
		 "t5" 
		} 
	}, ["t24"] = {
	 ["pos"] = Vector( 372, -379, 1 ), ["size"] = 114, ["stages"] = {
		 3 
		}, ["action"] = "dialogue", ["CheckTriggers"] = {
		 "t25" 
		}, ["objects"] = {
		 "d3" 
		} 
	}, ["t11"] = {
	 ["trigger_once"] = true, ["pos"] = Vector( -69, 391, 17 ), ["CheckTriggers"] = {
		 "t17" 
		}, ["data"] = 0, ["stages"] = {
		 2, 3 
		}, ["action"] = "set_behaviour", ["size"] = 10, ["objects"] = {
		 "e1" 
		} 
	}, ["t7"] = {
	 ["pos"] = Vector( -70, 194, 17 ), ["data"] = 2, ["stages"] = {
		 1 
		}, ["action"] = "activate_stage", ["size"] = 10, ["CheckTriggers"] = {
		 "t8" 
		} 
	}, ["t31"] = {
	 ["pos"] = Vector( 26, -526, 1 ), ["size"] = 10, ["objects"] = {
		 "e16" 
		}, ["stages"] = {
		 3 
		}, ["action"] = "spawn", ["CheckTriggers"] = {
		 "t32" 
		}, ["trigger_once"] = true 
	}, ["t22"] = {
	 ["pos"] = Vector( -61, 665, 1 ), ["CheckTriggers"] = {
		 "t23" 
		}, ["action"] = "pauseenemies", ["data"] = "false", ["size"] = 10 
	}, ["t2"] = {
	 ["pos"] = Vector( 112, 62, 17 ), ["size"] = 10, ["event"] = "OnDialogueFinished", ["action"] = "event", ["data"] = {
		 "d1" 
		}, ["objects"] = {
		 "t1" 
		} 
	} 
}
SCENE.EndAt = 148000
SCENE.Pickups = {
 ["w3"] = {
	 ["wep"] = "sogm_sawblade", ["pos"] = Vector( 780, -43, 17 ) 
	}, ["w1"] = {
	 ["wep"] = "sogm_extinguisher", ["pos"] = Vector( 431, -30, 17 ) 
	}, ["w2"] = {
	 ["wep"] = "sogm_extinguisher", ["pos"] = Vector( 221, -19, 17 ) 
	} 
}
SCENE.Volume = 30
SCENE.Ambient = 152969285
SCENE.NoPickups = true
SCENE.AmbientVolume = 30

SCENE.Initialize = function()
end

SCENE.Loaded = function()
	PLAYER_SPAWNPOINT = Vector( 289, -107, 17 )
end

