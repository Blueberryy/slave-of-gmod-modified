SCENE.Order = 23
SCENE.Act = 6
SCENE.Map = "sog_storm"
SCENE.FlipView = true
SCENE.ShowLastEnemies = true
SCENE.Enemies = {
 ["e3"] = {
	 ["pos"] = Vector( -1223, -464, 1 ), ["anim"] = "pose_standing_01", ["CheckTriggers"] = {
		 "t24" 
		}, ["ang"] = Angle( 0, 5, 0 ), ["beh"] = 2, ["char"] = "mercenary", ["wep"] = "sogm_usp" 
	}, ["e19"] = {
	 ["pos"] = Vector( -463, -744, 1 ), ["CheckTriggers"] = {
		 "t24" 
		}, ["ang"] = Angle( 0, 90, 0 ), ["beh"] = 2, ["char"] = "mercenary" 
	}, ["e4"] = {
	 ["pos"] = Vector( -387, -451, 1 ), ["CheckTriggers"] = {
		 "t24" 
		}, ["ang"] = Angle( 0, -180, 0 ), ["char"] = "mercenary", ["beh"] = 2 
	}, ["e18"] = {
	 ["pos"] = Vector( 1072, -761, 1 ), ["CheckTriggers"] = {
		 "t24" 
		}, ["ang"] = Angle( 0, 90, 0 ), ["beh"] = 2, ["char"] = "mercenary" 
	}, ["e8"] = {
	 ["pos"] = Vector( -790, -1750, 1 ), ["CheckTriggers"] = {
		 "t24" 
		}, ["ang"] = Angle( 0, -1, 0 ), ["char"] = "mercenary", ["beh"] = 2 
	}, ["e5"] = {
	 ["pos"] = Vector( -1050, -1251, 1 ), ["CheckTriggers"] = {
		 "t24" 
		}, ["ang"] = Angle( 0, 94, 0 ), ["char"] = "mercenary", ["beh"] = 1 
	}, ["e6"] = {
	 ["pos"] = Vector( 321, -1006, 1 ), ["CheckTriggers"] = {
		 "t24" 
		}, ["ang"] = Angle( 0, 5, 0 ), ["char"] = "mercenary", ["beh"] = 2 
	}, ["e14"] = {
	 ["pos"] = Vector( -1126, -1477, 1 ), ["CheckTriggers"] = {
		 "t24" 
		}, ["ang"] = Angle( 0, -1, 0 ), ["char"] = "mercenary", ["beh"] = 2 
	}, ["e15"] = {
	 ["pos"] = Vector( -803, -506, 1 ), ["CheckTriggers"] = {
		 "t24" 
		}, ["ang"] = Angle( 0, 94, 0 ), ["beh"] = 1, ["char"] = "mercenary", ["wep"] = "sogm_axe" 
	}, ["e9"] = {
	 ["pos"] = Vector( -106, -1384, 1 ), ["CheckTriggers"] = {
		 "t24" 
		}, ["ang"] = Angle( 0, -1, 0 ), ["char"] = "mercenary", ["beh"] = 2 
	}, ["e7"] = {
	 ["pos"] = Vector( 1091, -339, 1 ), ["CheckTriggers"] = {
		 "t24" 
		}, ["ang"] = Angle( 0, -86, 0 ), ["char"] = "mercenary", ["beh"] = 2 
	}, ["e16"] = {
	 ["pos"] = Vector( -185, -322, 1 ), ["CheckTriggers"] = {
		 "t24" 
		}, ["ang"] = Angle( 0, 90, 0 ), ["beh"] = 2, ["char"] = "mercenary" 
	}, ["e12"] = {
	 ["pos"] = Vector( 1316, -902, 1 ), ["CheckTriggers"] = {
		 "t24" 
		}, ["ang"] = Angle( 0, -180, 0 ), ["char"] = "mercenary", ["beh"] = 2 
	}, ["e17"] = {
	 ["pos"] = Vector( 828, -546, 1 ), ["CheckTriggers"] = {
		 "t24" 
		}, ["ang"] = Angle( 0, 90, 0 ), ["beh"] = 2, ["char"] = "mercenary" 
	}, ["e13"] = {
	 ["pos"] = Vector( 665, -471, 1 ), ["CheckTriggers"] = {
		 "t24" 
		}, ["ang"] = Angle( 0, 130, 0 ), ["char"] = "mercenary", ["beh"] = 1 
	}, ["e10"] = {
	 ["pos"] = Vector( -1229, -1021, 1 ), ["CheckTriggers"] = {
		 "t24" 
		}, ["ang"] = Angle( 0, -1, 0 ), ["char"] = "mercenary", ["beh"] = 2 
	}, ["e2"] = {
	 ["CheckTriggers"] = {
		 "t10" 
		}, ["pos"] = Vector( -774, 62, 1 ), ["anim"] = "pose_standing_01", ["beh"] = 1, ["ang"] = Angle( 0, -99, 0 ), ["char"] = "matthias", ["immune"] = true, ["wep"] = "sogm_magnum" 
	}, ["e1"] = {
	 ["pos"] = Vector( -860, 63, 1 ), ["anim"] = "pose_standing_01", ["immune"] = true, ["ang"] = Angle( 0, -86, 0 ), ["beh"] = -1, ["char"] = "mercenary", ["wep"] = "none" 
	}, ["e11"] = {
	 ["pos"] = Vector( -90, 148, 1 ), ["CheckTriggers"] = {
		 "t24" 
		}, ["ang"] = Angle( 0, -83, 0 ), ["char"] = "mercenary", ["beh"] = 2 
	} 
}
SCENE.StartFromAmbient = true
SCENE.PickupsPersistance = true
SCENE.BloodyScreen = true
SCENE.AddThunder = true
SCENE.NoPickups = true
SCENE.SoundTrack = 149207008
SCENE.MusicText = "Nemix - Upheaval"
SCENE.Dialogues = {
 ["d5"] = {
	 {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_paywall_2014_46_npc" 
	} 
}, {
 ["person"] = "e2", ["text"] = {
	 "sog_dialogue_paywall_2014_47_npc", "sog_dialogue_paywall_2014_48_npc", "sog_dialogue_paywall_2014_49_npc", "sog_dialogue_paywall_2014_50_npc" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_paywall_2014_51_npc", "sog_dialogue_paywall_2014_52_npc" 
	} 
}, {
 ["person"] = "e2", ["text"] = {
	 "sog_dialogue_paywall_2014_53_npc", "sog_dialogue_paywall_2014_54_npc", "sog_dialogue_paywall_2014_55_npc" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_paywall_2014_56_npc" 
	} 
}, {
 ["person"] = "e2", ["text"] = {
	 "sog_dialogue_paywall_2014_57_npc", "sog_dialogue_paywall_2014_58_npc", "sog_dialogue_paywall_2014_59_npc" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_paywall_2014_60_npc" 
	} 
}, {
 ["person"] = "e2", ["text"] = {
	 "sog_dialogue_paywall_2014_61_npc", "sog_dialogue_paywall_2014_62_npc" 
	} 
} 
	}, ["d2"] = {
	 {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_paywall_2014_3_npc" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_paywall_2014_4_npc", "sog_dialogue_paywall_2014_5_npc" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_paywall_2014_6_npc", "sog_dialogue_paywall_2014_7_npc" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_paywall_2014_8_npc" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_paywall_2014_9_npc" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_paywall_2014_10_npc", "sog_dialogue_paywall_2014_11_npc" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_paywall_2014_12_npc", "sog_dialogue_paywall_2014_13_npc", "sog_dialogue_paywall_2014_14_npc" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_paywall_2014_15_npc", "sog_dialogue_paywall_2014_16_npc", "sog_dialogue_paywall_2014_17_npc" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_paywall_2014_18_npc" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_paywall_2014_19_npc", "sog_dialogue_paywall_2014_20_npc" 
	} 
} 
	}, ["d1"] = {
	 {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_paywall_2014_1_npc", "sog_dialogue_paywall_2014_2_npc" 
	} 
} 
	}, ["d4"] = {
	 {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_paywall_2014_21_npc" 
	} 
} 
	}, ["d3"] = {
	 {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_paywall_2014_22_npc" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_paywall_2014_23_npc" 
	} 
}, {
 ["person"] = "e2", ["text"] = {
	 "sog_dialogue_paywall_2014_24_npc" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_paywall_2014_25_npc" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_paywall_2014_26_npc" 
	} 
}, {
 ["person"] = "e2", ["text"] = {
	 "sog_dialogue_paywall_2014_27_npc" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_paywall_2014_28_npc", "sog_dialogue_paywall_2014_29_npc" 
	} 
}, {
 ["person"] = "e2", ["text"] = {
	 "sog_dialogue_paywall_2014_30_npc", "sog_dialogue_paywall_2014_31_npc", "sog_dialogue_paywall_2014_32_npc" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "sog_dialogue_paywall_2014_33_npc" 
	} 
}, {
 ["person"] = "e2", ["text"] = {
	 "sog_dialogue_paywall_2014_34_npc", "sog_dialogue_paywall_2014_35_npc", "sog_dialogue_paywall_2014_36_npc", "sog_dialogue_paywall_2014_37_npc" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_paywall_2014_38_npc", "sog_dialogue_paywall_2014_39_npc", "sog_dialogue_paywall_2014_40_npc" 
	} 
}, {
 ["person"] = "e2", ["text"] = {
	 "sog_dialogue_paywall_2014_41_npc" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "sog_dialogue_paywall_2014_42_npc" 
	} 
}, {
 ["person"] = "e2", ["text"] = {
	 "sog_dialogue_paywall_2014_43_npc", "sog_dialogue_paywall_2014_44_npc", "sog_dialogue_paywall_2014_45_npc" 
	} 
} 
	} 
}
SCENE.Characters = {
 "moderator" 
}
SCENE.Name = "scene_name_paywall"
SCENE.Volume = 40
SCENE.Triggers = {
 ["t16"] = {
	 ["pos"] = Vector( -852, -294, 1 ), ["size"] = 10, ["action"] = "dialogue", ["CheckTriggers"] = {
		 "t17", "t19" 
		}, ["objects"] = {
		 "d5" 
		} 
	}, ["t18"] = {
	 ["pos"] = Vector( -758, -223, 1 ), ["size"] = 10, ["event"] = "OnDialogueFinished", ["action"] = "event", ["data"] = {
		 "d3" 
		}, ["objects"] = {
		 "t17" 
		} 
	}, ["t21"] = {
	 ["pos"] = Vector( -950, -210, 1 ), ["size"] = 10, ["action"] = "spawn", ["CheckTriggers"] = {
		 "t22" 
		}, ["objects"] = {
		 "t20" 
		} 
	}, ["t2"] = {
	 ["pos"] = Vector( -1060, -1561, 1 ), ["size"] = 10, ["event"] = "OnDialogueFinished", ["action"] = "event", ["data"] = {
		 "d1" 
		}, ["objects"] = {
		 "t1" 
		} 
	}, ["t8"] = {
	 ["pos"] = Vector( -699, -38, 1 ), ["size"] = 10, ["event"] = "OnDialogueFinished", ["action"] = "event", ["data"] = {
		 "d2" 
		}, ["objects"] = {
		 "t6", "t7" 
		} 
	}, ["t25"] = {
	 ["pos"] = Vector( -652, -174, 1 ), ["size"] = 60, ["event"] = "OnDialogueStarted", ["action"] = "event", ["data"] = {
		 "d2" 
		}, ["objects"] = {
		 "t24" 
		} 
	}, ["t14"] = {
	 ["pos"] = Vector( -1056, -76, 1 ), ["data"] = "true", ["action"] = "pauseenemies", ["size"] = 10, ["CheckTriggers"] = {
		 "t15" 
		} 
	}, ["t4"] = {
	 ["pos"] = Vector( -1160, -1755, 1 ), ["size"] = 10, ["event"] = "OnLevelLoaded", ["action"] = "event", ["objects"] = {
		 "t3" 
		} 
	}, ["t3"] = {
	 ["pos"] = Vector( -1160, -1672, 1 ), ["size"] = 10, ["action"] = "dialogue", ["CheckTriggers"] = {
		 "t4" 
		}, ["objects"] = {
		 "d1" 
		} 
	}, ["t23"] = {
	 ["pos"] = Vector( -1061, -299, 1 ), ["size"] = 10, ["event"] = "OnDialogueFinished", ["action"] = "event", ["data"] = {
		 "d5" 
		}, ["objects"] = {
		 "t20" 
		} 
	}, ["t24"] = {
	 ["pos"] = Vector( -616, -194, 1 ), ["size"] = 10, ["trigger_once"] = true, ["action"] = "spawn", ["CheckTriggers"] = {
		 "t25" 
		}, ["objects"] = {
		 "e3", "e15", "e4", "e18", "e8", "e5", "e6", "e14", "e19", "e9", "e7", "e16", "e17", "e11", "e10", "e12", "e13" 
		} 
	}, ["t5"] = {
	 ["action"] = "dialogue", ["pos"] = Vector( -858, 33, 1 ), ["size"] = 48, ["objects"] = {
		 "d2" 
		} 
	}, ["t15"] = {
	 ["pos"] = Vector( -1065, -142, 1 ), ["size"] = 10, ["event"] = "OnDialogueFinished", ["action"] = "event", ["data"] = {
		 "d4" 
		}, ["objects"] = {
		 "t14" 
		} 
	}, ["t1"] = {
	 ["pos"] = Vector( -1060, -1659, 1 ), ["size"] = 32, ["data"] = "true", ["action"] = "pauseenemies", ["CheckTriggers"] = {
		 "t2" 
		}, ["trigger_once"] = true 
	}, ["t10"] = {
	 ["pos"] = Vector( -688, 58, 1 ), ["size"] = 10, ["action"] = "spawn", ["CheckTriggers"] = {
		 "t12" 
		}, ["objects"] = {
		 "e2", "t9" 
		} 
	}, ["t17"] = {
	 ["pos"] = Vector( -759, -292, 1 ), ["size"] = 10, ["action"] = "spawn", ["CheckTriggers"] = {
		 "t18" 
		}, ["objects"] = {
		 "t16" 
		} 
	}, ["t13"] = {
	 ["pos"] = Vector( -1036, 38, 1 ), ["size"] = 10, ["event"] = "OnLevelClear", ["action"] = "event", ["objects"] = {
		 "t11" 
		} 
	}, ["t9"] = {
	 ["pos"] = Vector( -773, 19, 1 ), ["size"] = 28, ["action"] = "dialogue", ["CheckTriggers"] = {
		 "t10" 
		}, ["objects"] = {
		 "d3" 
		} 
	}, ["t6"] = {
	 ["size"] = 10, ["pos"] = Vector( -844, -157, 1 ), ["CheckTriggers"] = {
		 "t8" 
		}, ["action"] = "newspawnpoint" 
	}, ["t20"] = {
	 ["size"] = 10, ["pos"] = Vector( -958, -266, 1 ), ["CheckTriggers"] = {
		 "t21", "t23" 
		}, ["action"] = "nextlevel" 
	}, ["t11"] = {
	 ["pos"] = Vector( -1036, -18, 1 ), ["size"] = 10, ["action"] = "dialogue", ["CheckTriggers"] = {
		 "t13" 
		}, ["objects"] = {
		 "d4" 
		} 
	}, ["t7"] = {
	 ["pos"] = Vector( -676, -96, 1 ), ["CheckTriggers"] = {
		 "t8" 
		}, ["action"] = "playmusic", ["size"] = 10, ["trigger_once"] = true 
	}, ["t12"] = {
	 ["pos"] = Vector( -977, -89, 1 ), ["size"] = 10, ["event"] = "OnLevelClear", ["action"] = "event", ["objects"] = {
		 "t10" 
		} 
	}, ["t22"] = {
	 ["pos"] = Vector( -1019, -228, 1 ), ["size"] = 10, ["event"] = "OnDialogueStarted", ["action"] = "event", ["data"] = {
		 "d5" 
		}, ["objects"] = {
		 "t21" 
		} 
	}, ["t19"] = {
	 ["pos"] = Vector( -857, -236, 1 ), ["size"] = 10, ["event"] = "OnPlayerDeath", ["action"] = "event", ["objects"] = {
		 "t16" 
		} 
	} 
}
SCENE.Pickups = {
 
}
SCENE.AmbientEndAt = 48000 
SCENE.Ambient = 149207008
SCENE.StartFrom = 59000
SCENE.AmbientVolume = 40

SCENE.Initialize = function()
end

SCENE.Loaded = function()
	PLAYER_SPAWNPOINT = Vector( -722, -2862, 1 )
end

