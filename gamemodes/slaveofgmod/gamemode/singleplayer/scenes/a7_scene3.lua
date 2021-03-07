SCENE.Order = 27
SCENE.Act = 7
SCENE.Map = "sog_shady_v1"
SCENE.Cover = Material( "sog/covers/dvd_disk_default_bonus.png" , "alphatest")
SCENE.Enemies = {
 ["e3"] = {
	 ["immune"] = true, ["pos"] = Vector( 3133, 2941, 9 ), ["anim"] = "pose_standing_04", ["opt"] = true, ["stages"] = {
		 1, 2, 3, 4 
		}, ["ang"] = Angle( 0, 57, 0 ), ["beh"] = -1, ["char"] = "bonus bsm cool" 
	}, ["e15"] = {
	 ["pos"] = Vector( 3515, 2427, 1 ), ["stages"] = {
		 2 
		}, ["ang"] = Angle( 0, 100, 0 ), ["beh"] = 2, ["char"] = "thug kid" 
	}, ["e4"] = {
	 ["pos"] = Vector( 2876, 3229, 1 ), ["stages"] = {
		 2 
		}, ["ang"] = Angle( 0, -47, 0 ), ["beh"] = 0, ["char"] = "server owner", ["wep"] = "sogm_pipe" 
	}, ["e18"] = {
	 ["pos"] = Vector( 3215, 1632, 1 ), ["stages"] = {
		 2 
		}, ["ang"] = Angle( 0, 118, 0 ), ["beh"] = 0, ["char"] = "banned" 
	}, ["e16"] = {
	 ["pos"] = Vector( 3748, 2868, 1 ), ["char"] = "server owner", ["beh"] = 0, ["ang"] = Angle( 0, -129, 0 ), ["stages"] = {
		 2 
		}, ["wep"] = "sogm_physcannon" 
	}, ["e22"] = {
	 ["pos"] = Vector( 3642, 1910, 1 ), ["stages"] = {
		 2 
		}, ["beh"] = 4, ["char"] = "banned", ["ang"] = Angle( 0, 90, 0 ) 
	}, ["e8"] = {
	 ["pos"] = Vector( 3158, 3482, 1 ), ["ally"] = true, ["char"] = "server owner", ["stages"] = {
		 4 
		}, ["beh"] = 4, ["ang"] = Angle( 0, -86, 0 ), ["wep"] = "sogm_usp_silenced" 
	}, ["e5"] = {
	 ["pos"] = Vector( 3614, 2652, 1 ), ["stages"] = {
		 3 
		}, ["char"] = "shady car", ["ang"] = Angle( 0, 118, 0 ), ["beh"] = 0 
	}, ["e6"] = {
	 ["pos"] = Vector( 2906, 3478, 1 ), ["ally"] = true, ["char"] = "server owner", ["stages"] = {
		 4 
		}, ["beh"] = 4, ["ang"] = Angle( 0, -53, 0 ), ["wep"] = "sogm_usp_silenced" 
	}, ["e23"] = {
	 ["pos"] = Vector( 3466, 3208, 1 ), ["char"] = "server owner", ["beh"] = 1, ["ang"] = Angle( 0, 72, 0 ), ["stages"] = {
		 2 
		}, ["wep"] = "sogm_mp5" 
	}, ["e14"] = {
	 ["pos"] = Vector( 2538, 2946, 1 ), ["stages"] = {
		 2 
		}, ["ang"] = Angle( 0, 45, 0 ), ["beh"] = 1, ["char"] = "banned" 
	}, ["e10"] = {
	 ["pos"] = Vector( 2913, 3594, 11 ), ["ally"] = true, ["char"] = "server owner", ["stages"] = {
		 4 
		}, ["beh"] = 4, ["ang"] = Angle( 0, -77, 0 ), ["wep"] = "sogm_usp_silenced" 
	}, ["e9"] = {
	 ["pos"] = Vector( 3350, 3483, 1 ), ["ally"] = true, ["char"] = "server owner", ["stages"] = {
		 4 
		}, ["beh"] = 4, ["ang"] = Angle( 0, -102, 0 ), ["wep"] = "sogm_usp_silenced" 
	}, ["e7"] = {
	 ["pos"] = Vector( 3029, 3498, 1 ), ["ally"] = true, ["char"] = "server owner", ["stages"] = {
		 4 
		}, ["beh"] = 4, ["ang"] = Angle( 0, -86, 0 ), ["wep"] = "sogm_usp_silenced" 
	}, ["e12"] = {
	 ["pos"] = Vector( 3444, 3299, 1 ), ["ally"] = true, ["char"] = "server owner", ["stages"] = {
		 4 
		}, ["beh"] = 4, ["ang"] = Angle( 0, -138, 0 ), ["wep"] = "sogm_usp_silenced" 
	}, ["e21"] = {
	 ["pos"] = Vector( 3642, 1987, 1 ), ["stages"] = {
		 2 
		}, ["ang"] = Angle( 0, 90, 0 ), ["beh"] = 2, ["char"] = "server owner", ["wep"] = "sogm_pipe" 
	}, ["e19"] = {
	 ["pos"] = Vector( 2668, 2449, 1 ), ["stages"] = {
		 2 
		}, ["ang"] = Angle( 0, 63, 0 ), ["beh"] = 2, ["char"] = "server owner", ["wep"] = "sogm_pipe" 
	}, ["e11"] = {
	 ["pos"] = Vector( 3073, 3594, 9 ), ["ally"] = true, ["char"] = "server owner", ["stages"] = {
		 4 
		}, ["beh"] = 4, ["ang"] = Angle( 0, -86, 0 ), ["wep"] = "sogm_usp_silenced" 
	}, ["e1"] = {
	 ["CheckTriggers"] = {
		 "t1", "t29" 
		}, ["stages"] = {
		 1, 2, 3, 4 
		}, ["pos"] = Vector( 3174, 2930, 9 ), ["anim"] = "pose_standing_01", ["opt"] = true, ["ang"] = Angle( 0, 94, 0 ), ["immune"] = true, ["char"] = "bonus bsm cool leader", ["beh"] = -1 
	}, ["e2"] = {
	 ["immune"] = true, ["pos"] = Vector( 3217, 2947, 9 ), ["anim"] = "pose_standing_04", ["opt"] = true, ["stages"] = {
		 1, 2, 3, 4 
		}, ["ang"] = Angle( 0, 127, 0 ), ["beh"] = -1, ["char"] = "bonus bsm cool" 
	}, ["e17"] = {
	 ["pos"] = Vector( 3665, 1683, 1 ), ["stages"] = {
		 2 
		}, ["ang"] = Angle( 0, 118, 0 ), ["beh"] = 0, ["char"] = "server owner", ["wep"] = "sogm_physcannon" 
	}, ["e20"] = {
	 ["pos"] = Vector( 2817, 3478, 1 ), ["stages"] = {
		 2 
		}, ["char"] = "thug kid", ["ang"] = Angle( 0, 33, 0 ), ["beh"] = 1 
	} 
}
SCENE.StartFromAmbient = true
SCENE.PickupsPersistance = true
SCENE.NoPickups = true
SCENE.Pickups = {
 ["w1"] = {
	 ["wep"] = "sogm_pot", ["pos"] = Vector( 3238, 3083, 9 ) 
	} 
}
SCENE.MusicText = "Vêtu de Noir - Midnight In Hell (Feat. Chien Lune)"
SCENE.Dialogues = {
 ["d2"] = {
	 {
 ["person"] = "e5", ["text"] = {
	 "sog_dialogue_bigservermen_2016_26_npc" 
	} 
} 
	}, ["d1"] = {
	 {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_bigservermen_2016_1_npc", "sog_dialogue_bigservermen_2016_2_npc", "sog_dialogue_bigservermen_2016_3_npc", "sog_dialogue_bigservermen_2016_4_npc" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_bigservermen_2016_5_npc", "sog_dialogue_bigservermen_2016_6_npc" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_bigservermen_2016_7_npc", "sog_dialogue_bigservermen_2016_8_npc", "sog_dialogue_bigservermen_2016_9_npc", "sog_dialogue_bigservermen_2016_10_npc", "sog_dialogue_bigservermen_2016_11_npc", "sog_dialogue_bigservermen_2016_12_npc", "sog_dialogue_bigservermen_2016_13_npc" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_bigservermen_2016_14_npc", "sog_dialogue_bigservermen_2016_15_npc", "sog_dialogue_bigservermen_2016_16_npc" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_bigservermen_2016_17_npc", "sog_dialogue_bigservermen_2016_18_npc", "sog_dialogue_bigservermen_2016_19_npc", "sog_dialogue_bigservermen_2016_20_npc" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_bigservermen_2016_21_npc", "sog_dialogue_bigservermen_2016_22_npc", "sog_dialogue_bigservermen_2016_23_npc" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_bigservermen_2016_24_npc", "sog_dialogue_bigservermen_2016_25_npc" 
	} 
} 
	}, ["d3"] = {
	 {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_bigservermen_2016_27_npc", "sog_dialogue_bigservermen_2016_28_npc", "sog_dialogue_bigservermen_2016_29_npc", "sog_dialogue_bigservermen_2016_30_npc" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_bigservermen_2016_31_npc", "sog_dialogue_bigservermen_2016_32_npc" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_bigservermen_2016_33_npc" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_bigservermen_2016_34_npc", "sog_dialogue_bigservermen_2016_35_npc" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_bigservermen_2016_36_npc" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_bigservermen_2016_37_npc", "sog_dialogue_bigservermen_2016_38_npc", "sog_dialogue_bigservermen_2016_39_npc", "sog_dialogue_bigservermen_2016_40_npc" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_bigservermen_2016_41_npc", "sog_dialogue_bigservermen_2016_42_npc" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_bigservermen_2016_43_npc", "sog_dialogue_bigservermen_2016_44_npc", "sog_dialogue_bigservermen_2016_45_npc", "sog_dialogue_bigservermen_2016_46_npc" 
	} 
} 
	} 
}
SCENE.StartFrom = 30400 //28500
SCENE.Characters = {
 "watch" 
}
SCENE.AmbientStartFrom = 3000
SCENE.Volume = 55
SCENE.ShowLastEnemies = true
SCENE.Triggers = {
 ["t10"] = {
	 ["size"] = 10, ["pos"] = Vector( 3424, 3005, 11 ), ["CheckTriggers"] = {
		 "t12" 
		}, ["action"] = "removearrows" 
	}, ["t16"] = {
	 ["pos"] = Vector( 3721, 2673, 1 ), ["size"] = 10, ["action"] = "dialogue", ["CheckTriggers"] = {
		 "t17" 
		}, ["objects"] = {
		 "d2" 
		} 
	}, ["t12"] = {
	 ["pos"] = Vector( 3429, 2905, 11 ), ["size"] = 10, ["event"] = "OnDialogueStarted", ["action"] = "event", ["data"] = {
		 "d1" 
		}, ["objects"] = {
		 "t10" 
		} 
	}, ["t14"] = {
	 ["pos"] = Vector( 3125, 3742, 9 ), ["CheckTriggers"] = {
		 "t15" 
		}, ["stages"] = {
		 2 
		}, ["action"] = "activate_stage", ["size"] = 10, ["data"] = 3 
	}, ["t27"] = {
	 ["pos"] = Vector( 3015, 3075, 9 ), ["size"] = 10, ["action"] = "spawn", ["CheckTriggers"] = {
		 "t28" 
		}, ["objects"] = {
		 "t22" 
		} 
	}, ["t18"] = {
	 ["pos"] = Vector( 3765, 2887, 1 ), ["data"] = {
		 ["start"] = 229500, ["endpos"] = 429000 
		}, ["action"] = "music_time", ["size"] = 10, ["CheckTriggers"] = {
		 "t19" 
		} 
	}, ["t28"] = {
	 ["pos"] = Vector( 2969, 3149, 9 ), ["size"] = 10, ["event"] = "OnLevelClear", ["action"] = "event", ["objects"] = {
		 "t27" 
		} 
	}, ["t24"] = {
	 ["pos"] = Vector( 2951, 3308, 1 ), ["size"] = 10, ["event"] = "OnStageStart", ["action"] = "event", ["data"] = 4, ["objects"] = {
		 "t23" 
		} 
	}, ["t19"] = {
	 ["pos"] = Vector( 3805, 2990, 1 ), ["size"] = 10, ["event"] = "OnDialogueFinished", ["action"] = "event", ["data"] = {
		 "d2" 
		}, ["objects"] = {
		 "t18" 
		} 
	}, ["t8"] = {
	 ["pos"] = Vector( 3350, 3050, 11 ), ["CheckTriggers"] = {
		 "t9" 
		}, ["action"] = "playmusic", ["size"] = 10, ["trigger_once"] = true 
	}, ["t25"] = {
	 ["size"] = 10, ["pos"] = Vector( 2833, 3685, 9 ), ["CheckTriggers"] = {
		 "t26" 
		}, ["action"] = "nextlevel" 
	}, ["t13"] = {
	 ["pos"] = Vector( 3542, 2830, 1 ), ["size"] = 10, ["event"] = "OnStageStart", ["action"] = "event", ["data"] = 2, ["objects"] = {
		 "t11" 
		} 
	}, ["t4"] = {
	 ["pos"] = Vector( 3380, 3733, 9 ), ["CheckTriggers"] = {
		 "t5" 
		}, ["stages"] = {
		 3 
		}, ["action"] = "levelclear", ["size"] = 32 
	}, ["t9"] = {
	 ["pos"] = Vector( 3350, 3123, 1 ), ["size"] = 10, ["event"] = "OnDialogueFinished", ["action"] = "event", ["data"] = {
		 "d1" 
		}, ["objects"] = {
		 "t8" 
		} 
	}, ["t1"] = {
	 ["pos"] = Vector( 3430, 2736, 9 ), ["size"] = 10, ["action"] = "arrow", ["CheckTriggers"] = {
		 "t2" 
		}, ["objects"] = {
		 "e1" 
		} 
	}, ["t3"] = {
	 ["pos"] = Vector( 3175, 3034, 9 ), ["size"] = 32, ["stages"] = {
		 1 
		}, ["action"] = "dialogue", ["objects"] = {
		 "d1" 
		} 
	}, ["t5"] = {
	 ["pos"] = Vector( 3301, 3731, 9 ), ["size"] = 60, ["event"] = "OnAllEnemiesKilled", ["stages"] = {
		 3 
		}, ["action"] = "event", ["objects"] = {
		 "t4" 
		} 
	}, ["t15"] = {
	 ["pos"] = Vector( 3021, 3704, 9 ), ["size"] = 10, ["event"] = "OnAllEnemiesKilled", ["action"] = "event", ["objects"] = {
		 "t14" 
		} 
	}, ["t23"] = {
	 ["pos"] = Vector( 2951, 3392, 1 ), ["size"] = 10, ["action"] = "dialogue", ["CheckTriggers"] = {
		 "t24" 
		}, ["objects"] = {
		 "d3" 
		} 
	}, ["t30"] = {
	 ["pos"] = Vector( 2884, 3131, 9 ), ["size"] = 10, ["event"] = "OnLevelClear", ["action"] = "event", ["objects"] = {
		 "t29" 
		} 
	}, ["t26"] = {
	 ["pos"] = Vector( 2833, 3607, 11 ), ["size"] = 10, ["event"] = "OnDialogueFinished", ["action"] = "event", ["data"] = {
		 "d3" 
		}, ["objects"] = {
		 "t25" 
		} 
	}, ["t17"] = {
	 ["pos"] = Vector( 3721, 2757, 1 ), ["size"] = 10, ["event"] = "OnStageStart", ["action"] = "event", ["data"] = 3, ["objects"] = {
		 "t16" 
		} 
	}, ["t29"] = {
	 ["pos"] = Vector( 2896, 3061, 9 ), ["size"] = 10, ["action"] = "arrow", ["CheckTriggers"] = {
		 "t30" 
		}, ["objects"] = {
		 "e1" 
		} 
	}, ["t6"] = {
	 ["pos"] = Vector( 3347, 2981, 9 ), ["CheckTriggers"] = {
		 "t7" 
		}, ["stages"] = {
		 1 
		}, ["action"] = "activate_stage", ["size"] = 10, ["data"] = 2 
	}, ["t20"] = {
	 ["size"] = 10, ["pos"] = Vector( 3173, 3103, 9 ), ["CheckTriggers"] = {
		 "t21" 
		}, ["action"] = "newspawnpoint" 
	}, ["t11"] = {
	 ["pos"] = Vector( 3541, 2943, 1 ), ["size"] = 10, ["action"] = "pauseenemies", ["CheckTriggers"] = {
		 "t13" 
		}, ["data"] = "false" 
	}, ["t7"] = {
	 ["pos"] = Vector( 3351, 2888, 9 ), ["size"] = 10, ["event"] = "OnDialogueFinished", ["action"] = "event", ["data"] = {
		 "d1" 
		}, ["objects"] = {
		 "t6" 
		} 
	}, ["t2"] = {
	 ["pos"] = Vector( 3427, 2825, 9 ), ["size"] = 10, ["event"] = "OnLevelLoaded", ["action"] = "event", ["objects"] = {
		 "t1" 
		} 
	}, ["t22"] = {
	 ["pos"] = Vector( 3179, 3038, 9 ), ["CheckTriggers"] = {
		 "t27" 
		}, ["action"] = "activate_stage", ["size"] = 26, ["data"] = 4 
	}, ["t21"] = {
	 ["pos"] = Vector( 3086, 3151, 9 ), ["size"] = 10, ["event"] = "OnDialogueStarted", ["action"] = "event", ["data"] = {
		 "d1" 
		}, ["objects"] = {
		 "t20" 
		} 
	} 
}
SCENE.EndAt = 182200//115500
SCENE.SoundTrack = 927953923//309414904
SCENE.Ambient = 298081381
SCENE.Vehicle = {
 ["type"] = 10, ["pos"] = Vector( 4061, 3099, 36 ), ["mdl"] = "models/props_vehicles/car005a.mdl", ["ang"] = Angle( 0, -77, 0 ) 
}
SCENE.AmbientVolume = 75
SCENE.Name = "scene_name_big_server_men"
SCENE.FlipPlayerIcon = true

SCENE.Initialize = function()
end

SCENE.Loaded = function()
	PLAYER_SPAWNPOINT = Vector( 3872, 3105, 1 )
end

