SCENE.Order = 28
SCENE.Act = 7
SCENE.OutroCutscene = "served cold outro"
SCENE.Map = "sog_business_v1"
SCENE.Cover = Material( "sog/covers/dvd_disk_default_bonus.png" , "alphatest")
SCENE.Enemies = {
 ["e3"] = {
	 ["pos"] = Vector( 1029, -61, 1 ), ["ang"] = Angle( 0, -90, 0 ), ["beh"] = 1, ["stages"] = {
		 1 
		}, ["char"] = "bonus bsm creepy" 
	}, ["e17"] = {
	 ["pos"] = Vector( 925, -371, 6 ), ["stages"] = {
		 3 
		}, ["beh"] = 0, ["char"] = "boss marishka", ["ang"] = Angle( 0, 0, 0 ) 
	}, ["e4"] = {
	 ["pos"] = Vector( 999, -719, 1 ), ["ang"] = Angle( 0, 94, 0 ), ["beh"] = 1, ["stages"] = {
		 1 
		}, ["char"] = "bonus bsm creepy" 
	}, ["e18"] = {
	 ["pos"] = Vector( 1365, -576, 4 ), ["stages"] = {
		 1 
		}, ["ang"] = Angle( 0, 136, 0 ), ["beh"] = 0, ["char"] = "bonus bsm creepy" 
	}, ["e8"] = {
	 ["pos"] = Vector( 820, -172, 1 ), ["ang"] = Angle( 0, 2, 0 ), ["beh"] = 1, ["stages"] = {
		 1 
		}, ["char"] = "bonus bsm creepy" 
	}, ["e5"] = {
	 ["pos"] = Vector( 1356, -719, 1 ), ["ang"] = Angle( 0, 94, 0 ), ["beh"] = 1, ["stages"] = {
		 1 
		}, ["char"] = "bonus bsm creepy" 
	}, ["e14"] = {
	 ["pos"] = Vector( 924, -101, 3 ), ["ang"] = Angle( 0, -41, 0 ), ["beh"] = 0, ["stages"] = {
		 1 
		}, ["char"] = "bonus bsm creepy" 
	}, ["e15"] = {
	 ["pos"] = Vector( 1381, -101, 1 ), ["ang"] = Angle( 0, -96, 0 ), ["beh"] = 0, ["stages"] = {
		 1 
		}, ["char"] = "bonus bsm creepy" 
	}, ["e9"] = {
	 ["pos"] = Vector( 908, -587, 4 ), ["ang"] = Angle( 0, 48, 0 ), ["beh"] = 0, ["stages"] = {
		 1 
		}, ["char"] = "bonus bsm creepy" 
	}, ["e7"] = {
	 ["pos"] = Vector( 820, -478, 1 ), ["ang"] = Angle( 0, 2, 0 ), ["beh"] = 1, ["stages"] = {
		 1 
		}, ["char"] = "bonus bsm creepy" 
	}, ["e12"] = {
	 ["pos"] = Vector( 1477, -75, 1 ), ["ang"] = Angle( 0, -132, 0 ), ["beh"] = 1, ["stages"] = {
		 1 
		}, ["char"] = "bonus bsm creepy" 
	}, ["e21"] = {
	 ["pos"] = Vector( 1084, -684, 1 ), ["stages"] = {
		 1 
		}, ["ang"] = Angle( 0, 78, 0 ), ["beh"] = 0, ["char"] = "bonus bsm creepy" 
	}, ["e20"] = {
	 ["pos"] = Vector( 1169, -54, 1 ), ["stages"] = {
		 1 
		}, ["ang"] = Angle( 0, -86, 0 ), ["beh"] = 0, ["char"] = "bonus bsm creepy" 
	}, ["e16"] = {
	 ["pos"] = Vector( 1273, -689, 1 ), ["ang"] = Angle( 0, 121, 0 ), ["beh"] = 0, ["stages"] = {
		 1 
		}, ["char"] = "bonus bsm creepy" 
	}, ["e10"] = {
	 ["pos"] = Vector( 1671, -374, 2 ), ["anim"] = "pose_standing_01", ["opt"] = true, ["immune"] = true, ["ang"] = Angle( 0, -180, 0 ), ["beh"] = -1, ["char"] = "bonus bsm cool leader" 
	}, ["e19"] = {
	 ["pos"] = Vector( 1347, -235, 1 ), ["stages"] = {
		 1 
		}, ["ang"] = Angle( 0, -135, 0 ), ["beh"] = 0, ["char"] = "bonus bsm creepy" 
	}, ["e13"] = {
	 ["pos"] = Vector( 1684, -427, 1 ), ["anim"] = "idle_all_cower", ["opt"] = true, ["immune"] = true, ["ang"] = Angle( 0, 164, 0 ), ["beh"] = -1, ["char"] = "server owner" 
	}, ["e11"] = {
	 ["pos"] = Vector( 1485, -700, 1 ), ["ang"] = Angle( 0, 130, 0 ), ["beh"] = 1, ["stages"] = {
		 1 
		}, ["char"] = "bonus bsm creepy" 
	} 
}
SCENE.StartFromAmbient = true
SCENE.Terror = true
SCENE.BloodyScreen = false
SCENE.AddThunder = true
SCENE.AmbientPlayback = 0.6
SCENE.NoPickups = true
SCENE.Pickups = {
 ["w1"] = {
	 ["wep"] = "sogm_body", ["pos"] = Vector( 1463, -452, 1 ) 
	} 
}
SCENE.MusicText = "Perturbator - The Church"
SCENE.Dialogues = {
 ["d2"] = {
	 {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_servedcold_2016_10_npc", "sog_dialogue_servedcold_2016_11_npc" 
	} 
}, {
 ["person"] = "e10", ["text"] = {
	 "sog_dialogue_servedcold_2016_12_npc", "sog_dialogue_servedcold_2016_13_npc", "sog_dialogue_servedcold_2016_14_npc", "sog_dialogue_servedcold_2016_15_npc" 
	} 
}, {
 ["person"] = "e13", ["text"] = {
	 "sog_dialogue_servedcold_2016_16_npc", "sog_dialogue_servedcold_2016_17_npc" 
	} 
}, {
 ["person"] = "e10", ["text"] = {
	 "sog_dialogue_servedcold_2016_18_npc" 
	} 
}, {
 ["person"] = "e13", ["text"] = {
	 "sog_dialogue_servedcold_2016_19_npc" 
	} 
}, {
 ["person"] = "e10", ["text"] = {
	 "sog_dialogue_servedcold_2016_20_npc" 
	} 
} 
	}, ["d1"] = {
	 {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_servedcold_2016_1_npc", "sog_dialogue_servedcold_2016_2_npc", "sog_dialogue_servedcold_2016_3_npc" 
	} 
}, {
 ["person"] = "e10", ["text"] = {
	 "sog_dialogue_servedcold_2016_4_npc" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_servedcold_2016_5_npc" 
	} 
}, {
 ["person"] = "e10", ["text"] = {
	 "sog_dialogue_servedcold_2016_6_npc", "sog_dialogue_servedcold_2016_7_npc" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_servedcold_2016_8_npc", "sog_dialogue_servedcold_2016_9_npc" 
	} 
} 
	}, ["d4"] = {
	 {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_servedcold_2016_43_npc" 
	} 
}, {
 ["person"] = "e13", ["text"] = {
	 "sog_dialogue_servedcold_2016_44_npc", "sog_dialogue_servedcold_2016_45_npc", "sog_dialogue_servedcold_2016_46_npc" 
	} 
}, {
 ["person"] = "e10", ["text"] = {
	 "sog_dialogue_servedcold_2016_47_npc" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_servedcold_2016_48_npc", "sog_dialogue_servedcold_2016_49_npc", "sog_dialogue_servedcold_2016_50_npc" 
	} 
} 
	}, ["d3"] = {
	 {
 ["person"] = "e10", ["text"] = {
	 "sog_dialogue_servedcold_2016_21_npc" 
	} 
}, {
 ["person"] = "e13", ["text"] = {
	 "sog_dialogue_servedcold_2016_22_npc", "sog_dialogue_servedcold_2016_23_npc" 
	} 
}, {
 ["person"] = "e10", ["text"] = {
	 "sog_dialogue_servedcold_2016_24_npc", "sog_dialogue_servedcold_2016_25_npc" 
	} 
}, {
 ["person"] = "e17", ["text"] = {
	 "sog_dialogue_servedcold_2016_26_npc" 
	} 
}, {
 ["person"] = "e13", ["text"] = {
	 "sog_dialogue_servedcold_2016_27_npc" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_servedcold_2016_28_npc" 
	} 
}, {
 ["person"] = "e17", ["text"] = {
	 "sog_dialogue_servedcold_2016_29_npc", "sog_dialogue_servedcold_2016_30_npc", "sog_dialogue_servedcold_2016_31_npc" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_servedcold_2016_32_npc" 
	} 
}, {
 ["person"] = "e17", ["text"] = {
	 "sog_dialogue_servedcold_2016_33_npc" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_servedcold_2016_34_npc", "sog_dialogue_servedcold_2016_35_npc", "sog_dialogue_servedcold_2016_36_npc" 
	} 
}, {
 ["person"] = "e17", ["text"] = {
	 "sog_dialogue_servedcold_2016_37_npc", "sog_dialogue_servedcold_2016_38_npc", "sog_dialogue_servedcold_2016_39_npc" 
	} 
}, {
 ["person"] = "e13", ["text"] = {
	 "sog_dialogue_servedcold_2016_40_npc" 
	} 
}, {
 ["person"] = "e17", ["text"] = {
	 "sog_dialogue_servedcold_2016_41_npc", "sog_dialogue_servedcold_2016_42_npc" 
	} 
} 
	} 
}
SCENE.PickupsPersistance = true
SCENE.SoundTrack = 299448796
SCENE.AmbientEndAt = 18000
SCENE.DisableNextbotLights = true
SCENE.Name = "scene_name_served_cold"
SCENE.BloodMoonScreen = true
SCENE.Triggers = {
 ["t12"] = {
	 ["pos"] = Vector( 628, -342, 3 ), ["size"] = 10, ["action"] = "music_time", ["CheckTriggers"] = {
		 "t13" 
		}, ["data"] = {
		 ["start"] = 159000, ["endpos"] = 175500 
		} 
	}, ["t8"] = {
	 ["pos"] = Vector( 903, 148, 2 ), ["CheckTriggers"] = {
		 "t9" 
		}, ["action"] = "music_time", ["data"] = {
		 ["start"] = 100300, ["endpos"] = 158300 
		}, ["size"] = 10 
	}, ["t19"] = {
	 ["action"] = "levelclear", ["pos"] = Vector( 539, 213, 1 ), ["size"] = 10, ["trigger_once"] = true 
	}, ["t4"] = {
	 ["pos"] = Vector( 1725, -189, 2 ), ["size"] = 10, ["event"] = "OnDialogueFinished", ["action"] = "event", ["data"] = {
		 "d1" 
		}, ["objects"] = {
		 "t3" 
		} 
	}, ["t9"] = {
	 ["pos"] = Vector( 861, 82, 1 ), ["size"] = 10, ["event"] = "OnDialogueFinished", ["action"] = "event", ["data"] = {
		 "d2" 
		}, ["objects"] = {
		 "t7", "t8" 
		} 
	}, ["t5"] = {
	 ["pos"] = Vector( 595, 135, 1 ), ["CheckTriggers"] = {
		 "t6" 
		}, ["stages"] = {
		 1 
		}, ["action"] = "dialogue", ["size"] = 10, ["objects"] = {
		 "d2" 
		} 
	}, ["t15"] = {
	 ["pos"] = Vector( 545, -88, 1 ), ["size"] = 10, ["event"] = "OnDialogueFinished", ["action"] = "event", ["data"] = {
		 "d3" 
		}, ["objects"] = {
		 "t14" 
		} 
	}, ["t1"] = {
	 ["pos"] = Vector( 1662, -588, 1 ), ["size"] = 10, ["action"] = "dialogue", ["CheckTriggers"] = {
		 "t2" 
		}, ["objects"] = {
		 "d1" 
		} 
	}, ["t18"] = {
	 ["pos"] = Vector( 1497, -962, 5 ), ["size"] = 10, ["event"] = "OnAllEnemiesKilled", ["stages"] = {
		 3 
		}, ["action"] = "event", ["objects"] = {
		 "t17" 
		} 
	}, ["t16"] = {
	 ["pos"] = Vector( 1729, -793, 2 ), ["size"] = 60, ["event"] = "OnDialogueFinished", ["action"] = "event", ["data"] = {
		 "d4" 
		}, ["objects"] = {
		 "t10" 
		} 
	}, ["t17"] = {
	 ["pos"] = Vector( 1602, -977, 6 ), ["CheckTriggers"] = {
		 "t18" 
		}, ["stages"] = {
		 3 
		}, ["action"] = "dialogue", ["size"] = 10, ["objects"] = {
		 "d4" 
		} 
	}, ["t3"] = {
	 ["pos"] = Vector( 1722, -267, 3 ), ["CheckTriggers"] = {
		 "t4" 
		}, ["action"] = "playmusic", ["size"] = 10, ["trigger_once"] = true 
	}, ["t6"] = {
	 ["pos"] = Vector( 595, 72, 2 ), ["size"] = 10, ["event"] = "OnAllEnemiesKilled", ["stages"] = {
		 1 
		}, ["action"] = "event", ["objects"] = {
		 "t5" 
		} 
	}, ["t10"] = {
	 ["CheckTriggers"] = {
		 "t16" 
		}, ["pos"] = Vector( 1717, -951, 1 ), ["size"] = 10, ["action"] = "nextlevel" 
	}, ["t11"] = {
	 ["pos"] = Vector( 628, -427, 3 ), ["size"] = 10, ["action"] = "dialogue", ["CheckTriggers"] = {
		 "t13" 
		}, ["objects"] = {
		 "d3" 
		} 
	}, ["t7"] = {
	 ["pos"] = Vector( 837, 152, 3 ), ["CheckTriggers"] = {
		 "t9" 
		}, ["action"] = "activate_stage", ["data"] = 2, ["size"] = 10 
	}, ["t2"] = {
	 ["pos"] = Vector( 1662, -497, 4 ), ["size"] = 10, ["event"] = "OnLevelLoaded", ["action"] = "event", ["objects"] = {
		 "t1" 
		} 
	}, ["t13"] = {
	 ["pos"] = Vector( 600, -500, 2 ), ["size"] = 10, ["event"] = "OnStageStart", ["action"] = "event", ["data"] = 3, ["objects"] = {
		 "t11", "t12" 
		} 
	}, ["t14"] = {
	 ["pos"] = Vector( 545, -159, 1 ), ["data"] = {
		 ["start"] = 175500, ["endpos"] = 242000 
		}, ["action"] = "music_time", ["size"] = 10, ["CheckTriggers"] = {
		 "t15" 
		} 
	} 
}
SCENE.Volume = 30
SCENE.EndAt = 100200
SCENE.Ambient = 299448796
SCENE.StartFrom = 21000
SCENE.AmbientVolume = 30
SCENE.Characters = {
 "watch" 
}

SCENE.Initialize = function()
end

SCENE.Loaded = function()
	PLAYER_SPAWNPOINT = Vector( 1167, -375, 1 )
end

