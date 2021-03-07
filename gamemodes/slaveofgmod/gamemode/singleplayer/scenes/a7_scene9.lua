SCENE.Order = 33
SCENE.Act = 7
SCENE.Map = "sog_deathloop_v7"
SCENE.Cover = Material( "sog/covers/dvd_disk_blank_broken.png" , "alphatest")
SCENE.SpookyBackground = true
SCENE.NoPickupsRespawn = true
SCENE.Enemies = {
 ["e1"] = {
	 ["ang"] = Angle( 0, -86, 0 ), ["pos"] = Vector( -1170, 114, 69 ), ["beh"] = 0, ["char"] = "boss heks" 
	} 
}
SCENE.StartFromAmbient = true
SCENE.PickupsPersistance = true
SCENE.NoPickups = true
SCENE.BloodyScreen = true
SCENE.AddThunder = true
SCENE.Volume = 50
SCENE.AmbientEndAt = 192000
SCENE.StartFrom = 28200
SCENE.Pickups = {
 
}
SCENE.MusicText = "Reznyck - SHOCK DOCTRINE (+ remix by Perturbator)"
SCENE.Dialogues = {
 ["d2"] = {
	 {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_return_end_41_npc" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_return_end_42_npc", "sog_dialogue_return_end_43_npc" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_return_end_44_npc" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_return_end_45_npc", "sog_dialogue_return_end_46_npc" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_return_end_47_npc" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_return_end_48_npc" 
	} 
} 
	}, ["d1"] = {
	 {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_return_end_49_npc" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_return_end_1_npc", "sog_dialogue_return_end_2_npc", "sog_dialogue_return_end_3_npc", "sog_dialogue_return_end_4_npc", "sog_dialogue_return_end_5_npc" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_return_end_6_npc" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_return_end_7_npc", "sog_dialogue_return_end_8_npc", "sog_dialogue_return_end_9_npc", "sog_dialogue_return_end_10_npc", "sog_dialogue_return_end_11_npc" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_return_end_12_npc" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_return_end_13_npc", "sog_dialogue_return_end_14_npc", "sog_dialogue_return_end_15_npc", "sog_dialogue_return_end_16_npc", "sog_dialogue_return_end_17_npc" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_return_end_18_npc" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_return_end_19_npc", "sog_dialogue_return_end_20_npc", "sog_dialogue_return_end_21_npc", "sog_dialogue_return_end_22_npc", "sog_dialogue_return_end_23_npc", "sog_dialogue_return_end_24_npc", "sog_dialogue_return_end_25_npc", "sog_dialogue_return_end_26_npc" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_return_end_27_npc" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_return_end_28_npc", "sog_dialogue_return_end_29_npc", "sog_dialogue_return_end_30_npc", "sog_dialogue_return_end_31_npc" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_return_end_32_npc", "sog_dialogue_return_end_33_npc" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_return_end_34_npc", "sog_dialogue_return_end_35_npc", "sog_dialogue_return_end_36_npc", "sog_dialogue_return_end_37_npc", "sog_dialogue_return_end_38_npc" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_return_end_39_npc" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_return_end_40_npc" 
	} 
} 
	} 
}
SCENE.DarkArrows = true
SCENE.EndAt = 141000
SCENE.MusicPlayback = 0.9
SCENE.NoMapProps = true
SCENE.DisableDefaultHUD = true
SCENE.Characters = {
 "james" 
}
SCENE.AmbientStartFrom = 28000
SCENE.Name = "scene_name_return_end"
SCENE.Triggers = {
 ["t5"] = {
	 ["pos"] = Vector( -965, 247, 69 ), ["size"] = 10, ["event"] = "OnDialogueFinished", ["stages"] = {
		 1 
		}, ["action"] = "event", ["data"] = {
		 "d1" 
		}, ["objects"] = {
		 "t4" 
		} 
	}, ["t1"] = {
	 ["pos"] = Vector( -1345, -993, 69 ), ["size"] = 10, ["CheckTriggers"] = {
		 "t2" 
		}, ["stages"] = {
		 1 
		}, ["action"] = "pauseenemies", ["data"] = "true", ["trigger_once"] = true 
	}, ["t9"] = {
	 ["pos"] = Vector( -734, 557, 69 ), ["size"] = 10, ["event"] = "OnStageStart", ["action"] = "event", ["data"] = 3, ["objects"] = {
		 "t8" 
		} 
	}, ["t10"] = {
	 ["pos"] = Vector( -541, 320, 69 ), ["size"] = 10, ["action"] = "activate_stage", ["CheckTriggers"] = {
		 "t11" 
		}, ["data"] = 4 
	}, ["t6"] = {
	 ["pos"] = Vector( -887, 536, 69 ), ["CheckTriggers"] = {
		 "t7" 
		}, ["action"] = "playmusic", ["size"] = 10, ["trigger_once"] = true 
	}, ["t11"] = {
	 ["pos"] = Vector( -596, 312, 69 ), ["size"] = 10, ["event"] = "OnDialogueFinished", ["action"] = "event", ["data"] = {
		 "d2" 
		}, ["objects"] = {
		 "t10" 
		} 
	}, ["t8"] = {
	 ["pos"] = Vector( -667, 465, 69 ), ["size"] = 10, ["action"] = "dialogue", ["CheckTriggers"] = {
		 "t9" 
		}, ["objects"] = {
		 "d2" 
		} 
	}, ["t7"] = {
	 ["pos"] = Vector( -894, 472, 69 ), ["size"] = 10, ["event"] = "OnStageStart", ["action"] = "event", ["data"] = 2, ["objects"] = {
		 "t6" 
		} 
	}, ["t2"] = {
	 ["pos"] = Vector( -1315, -908, 69 ), ["size"] = 10, ["event"] = "OnLevelLoaded", ["stages"] = {
		 1 
		}, ["action"] = "event", ["objects"] = {
		 "t1" 
		} 
	}, ["t4"] = {
	 ["pos"] = Vector( -962, 327, 69 ), ["size"] = 10, ["CheckTriggers"] = {
		 "t5" 
		}, ["stages"] = {
		 1 
		}, ["action"] = "activate_stage", ["data"] = 2, ["trigger_once"] = true 
	}, ["t3"] = {
	 ["pos"] = Vector( -1173, 103, 69 ), ["size"] = 94, ["stages"] = {
		 1 
		}, ["action"] = "dialogue", ["objects"] = {
		 "d1" 
		} 
	} 
}
SCENE.Spooky = true
SCENE.SoundTrack = 119381317
SCENE.Ambient = 482364471
SCENE.BadassMode = true
SCENE.AmbientVolume = 50
SCENE.Final = true

SCENE.Initialize = function()
end

SCENE.Loaded = function()
	PLAYER_SPAWNPOINT = Vector( -1176, -957, 69 )
end