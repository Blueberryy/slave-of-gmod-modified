SCENE.Order = 8
SCENE.Act = 2
SCENE.Map = "sog_wrath_v1"
SCENE.Cover = Material( "sog/covers/dvd_disk_8.png" , "alphatest")
SCENE.Achievement = "wrath"
SCENE.Enemies = {
 ["e5"] = {
	 ["pos"] = Vector( -1589, -1701, 2 ), ["anim"] = "idle_all_cower", ["CheckTriggers"] = {
		 "t32" 
		}, ["immune"] = true, ["char"] = "kid", ["beh"] = -1, ["ang"] = Angle( 0, -123, 0 ) 
	}, ["e3"] = {
	 ["pos"] = Vector( 401, -1280, 1 ), ["anim"] = "pose_standing_02", ["CheckTriggers"] = {
		 "t14" 
		}, ["immune"] = true, ["char"] = "victim", ["beh"] = -1, ["ang"] = Angle( 0, 180, 0 ) 
	}, ["e4"] = {
	 ["pos"] = Vector( -388, -1735, 1 ), ["anim"] = "zombie_slump_idle_02", ["CheckTriggers"] = {
		 "t18" 
		}, ["ang"] = Angle( 0, -39, 0 ), ["char"] = "victim", ["beh"] = -1, ["immune"] = true 
	}, ["e1"] = {
	 ["pos"] = Vector( 2446, -45, 1 ), ["anim"] = "zombie_slump_idle_02", ["immune"] = true, ["ang"] = Angle( 0, 111, 0 ), ["beh"] = -1, ["char"] = "victim" 
	}, ["e2"] = {
	 ["pos"] = Vector( 1446, -902, 1 ), ["anim"] = "idle_all_cower", ["CheckTriggers"] = {
		 "t8" 
		}, ["ang"] = Angle( 0, 2, 0 ), ["char"] = "victim", ["beh"] = -1, ["immune"] = true 
	}, ["e6"] = {
	 ["pos"] = Vector( -1088, -1758, 1 ), ["CheckTriggers"] = {
		 "t24" 
		}, ["ang"] = Angle( 0, 180, 0 ), ["beh"] = 0, ["char"] = "boss stan" 
	} 
}
SCENE.StartFromAmbient = true
SCENE.PickupsPersistance = true
SCENE.AddThunder = true
//SCENE.StartFrom = 45850
SCENE.SoundTrack = 204866683//108199763
SCENE.MusicText = "Carpenter Brut - Mandarin's Claws"//"Carpenter Brut - Roller Mobster"
SCENE.Dialogues = {
 ["d6"] = {
	 {
 ["person"] = "player", ["text"] = {
	 "The hell is this place?", ". . .", "All these hubs. . .", "It's like someone is using them to DDOS servers." 
	} 
}, {
 ["person"] = "e5", ["text"] = {
	 "Heeee iiissss heeeereeeee. . ." 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 ". . .", "Where?" 
	} 
}, {
 ["person"] = "e6", ["text"] = {
	 "Behind you, asshole!" 
	} 
} 
	}, ["d5"] = {
	 {
 ["person"] = "e4", ["text"] = {
	 "Or perhaps I should send your organs in a box. . .", "That abomination from 'ShitGamers' loves\\nhis players freshhh. . ." 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 ". . ." 
	} 
} 
	}, ["d7"] = {
	 {
 ["person"] = "player", ["text"] = {
	 "Ugh. . .", "Looks like an order.", ". . .", "\". . .requesting 3 meat packages. . .\"", "\". . .for the needs of 'ShitGamers' community. . .\"", "\". . .also need a bunch of DMCA sheets. . .\"", "\". . .with the \"Property of Ase \"Master\" Lick\" on it. . .\"", "\". . expect these 2 idiots within few days.\\n- 'Master', the head owner of 'ShitGamers'\"", "hm. . ." 
	} 
} 
	}, ["d2"] = {
	 {
 ["person"] = "e1", ["text"] = {
	 "You are not welcome. . ." 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "Jesus christ!", "What happened to your face?" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "You'd better leave now. . ." 
	} 
} 
	}, ["d1"] = {
	 {
 ["person"] = "player", ["text"] = {
	 "Looks like this is the right place. . ." 
	} 
} 
	}, ["d4"] = {
	 {
 ["person"] = "e3", ["text"] = {
	 "I am not going to warn you again. . ." 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "What the hell is wrong with you all?" 
	} 
} 
	}, ["d3"] = {
	 {
 ["person"] = "e2", ["text"] = {
	 "You don't know what you are walking into. . ." 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 ". . ." 
	} 
} 
	} 
}
SCENE.Characters = {
 "protagonist" 
}
SCENE.Name = "devnull"
SCENE.Triggers = {
 ["t1"] = {
	 ["pos"] = Vector( 2495, 334, 1 ), ["size"] = 13, ["action"] = "dialogue", ["CheckTriggers"] = {
		 "t2" 
		}, ["objects"] = {
		 "d1" 
		} 
	}, ["t19"] = {
	 ["pos"] = Vector( -162, -1718, 1 ), ["size"] = 29, ["event"] = "OnDialogueFinished", ["action"] = "event", ["data"] = {
		 "d4" 
		}, ["objects"] = {
		 "t18" 
		} 
	}, ["t4"] = {
	 ["action"] = "linker", ["pos"] = Vector( 2406, 267, 1 ), ["size"] = 105, ["objects"] = {
		 "t3" 
		} 
	}, ["t36"] = {
	 ["pos"] = Vector( 2483, 170, 1 ), ["size"] = 149, ["action"] = "nextlevel" 
	}, ["t5"] = {
	 ["pos"] = Vector( 2259, -75, 1 ), ["data"] = "Pull back", ["action"] = "hudmessage", ["size"] = 34, ["CheckTriggers"] = {
		 "t6" 
		} 
	}, ["t15"] = {
	 ["pos"] = Vector( 456, -988, 1 ), ["size"] = 42, ["event"] = "OnDialogueFinished", ["action"] = "event", ["data"] = {
		 "d3" 
		}, ["objects"] = {
		 "t14" 
		} 
	}, ["t26"] = {
	 ["pos"] = Vector( -1426, -1630, 1 ), ["size"] = 10, ["action"] = "pauseenemies", ["CheckTriggers"] = {
		 "t22" 
		}, ["data"] = "true" 
	}, ["t37"] = {
	 ["pos"] = Vector( 386, -1781, 1 ), ["size"] = 10, ["action"] = "hudmessage", ["CheckTriggers"] = {
		 "t38" 
		}, ["data"] = translate.Get("sog_hud_obj_leave_area") 
	}, ["t11"] = {
	 ["pos"] = Vector( 1244, -843, 1 ), ["size"] = 34, ["event"] = "OnDialogueFinished", ["action"] = "event", ["data"] = {
		 "d3" 
		}, ["objects"] = {
		 "t10" 
		} 
	}, ["t7"] = {
	 ["pos"] = Vector( 1447, -898, 1 ), ["size"] = 101, ["action"] = "dialogue", ["CheckTriggers"] = {
		 "t8" 
		}, ["objects"] = {
		 "d3" 
		} 
	}, ["t22"] = {
	 ["pos"] = Vector( -1346, -1617, 1 ), ["size"] = 10, ["event"] = "OnDialogueStarted", ["action"] = "event", ["data"] = {
		 "d6" 
		}, ["objects"] = {
		 "t26" 
		} 
	}, ["t33"] = {
	 ["pos"] = Vector( -1652, -1496, 1 ), ["size"] = 10, ["event"] = "OnDialogueFinished", ["action"] = "event", ["data"] = {
		 "d5" 
		}, ["objects"] = {
		 "t32" 
		} 
	}, ["t27"] = {
	 ["pos"] = Vector( -1659, -2047, 0.031250 ), ["size"] = 10, ["data"] = "true", ["action"] = "pauseenemies", ["CheckTriggers"] = {
		 "t30" 
		}, ["trigger_once"] = true 
	}, ["t40"] = {
	 ["pos"] = Vector( 325, -1860, 1 ), ["size"] = 10, ["event"] = "OnLevelClear", ["action"] = "event", ["objects"] = {
		 "t39" 
		} 
	}, ["t12"] = {
	 ["pos"] = Vector( 499, -1280, 1 ), ["size"] = 13, ["action"] = "hudmessage", ["CheckTriggers"] = {
		 "t16" 
		}, ["data"] = "I warned you. . ." 
	}, ["t31"] = {
	 ["pos"] = Vector( -1510, -1634, 1 ), ["size"] = 60, ["event"] = "OnDialogueStarted", ["action"] = "event", ["data"] = {
		 "d6" 
		}, ["objects"] = {
		 "t25" 
		} 
	}, ["t3"] = {
	 ["pos"] = Vector( 2406, 65, 1 ), ["size"] = 105, ["action"] = "dialogue", ["CheckTriggers"] = {
		 "t4" 
		}, ["objects"] = {
		 "d2" 
		} 
	}, ["t29"] = {
	 ["pos"] = Vector( -1340, -1713, 1 ), ["size"] = 10, ["event"] = "OnDialogueFinished", ["action"] = "event", ["data"] = {
		 "d6" 
		}, ["objects"] = {
		 "t28" 
		} 
	}, ["t20"] = {
	 ["pos"] = Vector( -264, -1822, 1 ), ["size"] = 20, ["action"] = "hudmessage", ["CheckTriggers"] = {
		 "t21" 
		}, ["data"] = "none" 
	}, ["t8"] = {
	 ["pos"] = Vector( 1470, -708, 1 ), ["size"] = 34, ["action"] = "spawn", ["CheckTriggers"] = {
		 "t9" 
		}, ["objects"] = {
		 "e2", "t7", "d2" 
		} 
	}, ["t25"] = {
	 ["pos"] = Vector( -1403, -1816, 2 ), ["size"] = 10, ["action"] = "newspawnpoint", ["CheckTriggers"] = {
		 "t31" 
		}, ["trigger_once"] = true 
	}, ["t21"] = {
	 ["pos"] = Vector( -194, -1809, 1 ), ["size"] = 20, ["event"] = "OnDialogueFinished", ["action"] = "event", ["data"] = {
		 "d5" 
		}, ["objects"] = {
		 "t20" 
		} 
	}, ["t23"] = {
	 ["pos"] = Vector( -1659, -2047, 0.031250 ), ["size"] = 10, ["action"] = "dialogue", ["CheckTriggers"] = {
		 "t30" 
		}, ["objects"] = {
		 "d6" 
		} 
	}, ["t30"] = {
	 ["pos"] = Vector( -1403, -1816, 2 ), ["size"] = 59, ["action"] = "linker", ["CheckTriggers"] = {
		 "t32" 
		}, ["objects"] = {
		 "t23", "t27", "t24" 
		} 
	}, ["t14"] = {
	 ["pos"] = Vector( 467, -1106, 1 ), ["size"] = 42, ["action"] = "spawn", ["CheckTriggers"] = {
		 "t15" 
		}, ["objects"] = {
		 "e3", "t13" 
		} 
	}, ["t39"] = {
	 ["pos"] = Vector( 353, -1926, 1 ), ["size"] = 10, ["action"] = "dialogue", ["CheckTriggers"] = {
		 "t40" 
		}, ["objects"] = {
		 "d7" 
		} 
	}, ["t24"] = {
	 ["pos"] = Vector( -1659, -2047, 0.031250 ), ["size"] = 10, ["action"] = "spawn", ["CheckTriggers"] = {
		 "t30" 
		}, ["objects"] = {
		 "e6" 
		} 
	}, ["t6"] = {
	 ["pos"] = Vector( 2252, 18, 1 ), ["size"] = 34, ["event"] = "OnDialogueFinished", ["action"] = "event", ["data"] = {
		 "d2" 
		}, ["objects"] = {
		 "t5" 
		} 
	}, ["t18"] = {
	 ["pos"] = Vector( -239, -1718, 1 ), ["size"] = 29, ["action"] = "spawn", ["CheckTriggers"] = {
		 "t19" 
		}, ["objects"] = {
		 "e4", "t17" 
		} 
	}, ["t13"] = {
	 ["pos"] = Vector( 421, -1280, 1 ), ["size"] = 80, ["action"] = "dialogue", ["CheckTriggers"] = {
		 "t14" 
		}, ["objects"] = {
		 "d4" 
		} 
	}, ["t10"] = {
	 ["pos"] = Vector( 1368, -738, 1 ), ["data"] = "go away", ["action"] = "hudmessage", ["size"] = 34, ["CheckTriggers"] = {
		 "t11" 
		} 
	}, ["t17"] = {
	 ["pos"] = Vector( -391, -1741, 1 ), ["size"] = 93, ["action"] = "dialogue", ["CheckTriggers"] = {
		 "t18" 
		}, ["objects"] = {
		 "d5" 
		} 
	}, ["t16"] = {
	 ["pos"] = Vector( 584, -1296, 1 ), ["size"] = 42, ["event"] = "OnDialogueFinished", ["action"] = "event", ["data"] = {
		 "d4" 
		}, ["objects"] = {
		 "t12" 
		} 
	}, ["t9"] = {
	 ["pos"] = Vector( 1551, -678, 1 ), ["size"] = 34, ["event"] = "OnDialogueFinished", ["action"] = "event", ["data"] = {
		 "d2" 
		}, ["objects"] = {
		 "t8" 
		} 
	}, ["t28"] = {
	 ["pos"] = Vector( -1301, -1674, 1 ), ["CheckTriggers"] = {
		 "t29" 
		}, ["action"] = "playmusic", ["size"] = 10, ["trigger_once"] = true 
	}, ["t32"] = {
	 ["pos"] = Vector( -1629, -1572, 1 ), ["size"] = 10, ["trigger_once"] = true, ["action"] = "spawn", ["CheckTriggers"] = {
		 "t33" 
		}, ["objects"] = {
		 "e5", "t30" 
		} 
	}, ["t34"] = {
	 ["pos"] = Vector( -1209, -1651, 1 ), ["size"] = 10, ["trigger_once"] = true, ["action"] = "spawn", ["CheckTriggers"] = {
		 "t35" 
		}, ["objects"] = {
		 "w3", "w4", "w1", "w2" 
		} 
	}, ["t35"] = {
	 ["pos"] = Vector( -1223, -1693, 1 ), ["size"] = 10, ["event"] = "OnDialogueFinished", ["action"] = "event", ["data"] = {
		 "d6" 
		}, ["objects"] = {
		 "t34" 
		} 
	}, ["t2"] = {
	 ["pos"] = Vector( 2423, 339, 1 ), ["size"] = 13, ["event"] = "OnLevelLoaded", ["action"] = "event", ["objects"] = {
		 "t1" 
		} 
	}, ["t38"] = {
	 ["pos"] = Vector( 380, -1684, 1 ), ["size"] = 10, ["event"] = "OnLevelClear", ["action"] = "event", ["objects"] = {
		 "t37" 
		} 
	} 
}
SCENE.BloodMoonScreen = true
SCENE.Pickups = {
 ["w3"] = {
	 ["pos"] = Vector( 537, -824, 3 ), ["CheckTriggers"] = {
		 "t34" 
		}, ["wep"] = "sogm_hook" 
	}, ["w4"] = {
	 ["pos"] = Vector( 171, -1448, 1 ), ["CheckTriggers"] = {
		 "t34" 
		}, ["wep"] = "sogm_hook" 
	}, ["w1"] = {
	 ["pos"] = Vector( -1611, -644, 1 ), ["CheckTriggers"] = {
		 "t34" 
		}, ["wep"] = "sogm_hook" 
	}, ["w2"] = {
	 ["pos"] = Vector( 330, -188, 1 ), ["CheckTriggers"] = {
		 "t34" 
		}, ["wep"] = "sogm_hook" 
	} 
}
SCENE.Ambient = 206560688
SCENE.NoPickups = true
SCENE.AmbientVolume = 30
SCENE.Volume = 30

SCENE.Initialize = function()
end

SCENE.Loaded = function()
	PLAYER_SPAWNPOINT = Vector( 2554, 124, 1 )
end
 