SCENE.Order = 19
SCENE.Act = 5
SCENE.Map = "sog_apartments"
//SCENE.Achievement = "lust"
SCENE.FlipView = true
SCENE.Enemies = {
 ["e5"] = {
	 ["ang"] = Angle( 0, 139, 0 ), ["pos"] = Vector( 1239, -214, 14 ), ["beh"] = 1, ["char"] = "boss donator" 
	}, ["e3"] = {
	 ["ang"] = Angle( 0, 69, 0 ), ["pos"] = Vector( 1075, -295, -3 ), ["beh"] = 1, ["char"] = "boss donator" 
	}, ["e4"] = {
	 ["ang"] = Angle( 0, -68, 0 ), ["pos"] = Vector( 1087, 31, -3 ), ["beh"] = 1, ["char"] = "boss donator" 
	}, ["e1"] = {
	 ["ang"] = Angle( 0, 3, 0 ), ["pos"] = Vector( 997, -136, 14 ), ["beh"] = 1, ["char"] = "boss donator" 
	}, ["e2"] = {
	 ["ang"] = Angle( 0, -138, 0 ), ["pos"] = Vector( 1246, -11, 11 ), ["beh"] = 1, ["char"] = "boss donator" 
	}, ["e6"] = {
	 ["pos"] = Vector( 1123, -120, -1 ), ["anim"] = "zombie_slump_idle_02", ["immune"] = true, ["ang"] = Angle( 0, 0, 0 ), ["beh"] = -1, ["char"] = "thomas" 
	}, ["e7"] = {
	 ["pos"] = Vector( 1160, 121, 1 ), ["anim"] = "pose_standing_02", ["CheckTriggers"] = {
		 "t22" 
		}, ["ang"] = Angle( 0, 170, 0 ), ["char"] = "mutilated kid", ["beh"] = -1, ["immune"] = true 
	} 
}
SCENE.StartFromAmbient = true
SCENE.BloodyScreen = true
SCENE.AddThunder = true
SCENE.DisableNextbotLights = true
SCENE.NoPickups = true
SCENE.Pickups = {
 ["w1"] = {
	 ["pos"] = Vector( 1406, -1031, 1 ), ["CheckTriggers"] = {
		 "t11", "t13" 
		}, ["wep"] = "sogm_cleaver" 
	}, ["w2"] = {
	 ["pos"] = Vector( 943, 218, 1 ), ["CheckTriggers"] = {
		 "t19", "t20" 
		}, ["wep"] = "sogm_shotgun" 
	} 
}
SCENE.MusicText = "Vondkreistan - Saint Schambles"
SCENE.Dialogues = {
 ["d5"] = {
	 {
 ["person"] = "player", ["text"] = {
	 "I dont think it is a good idea. . .", "Bending over just to get these hooks. . .", ". . .sounds dangerous." 
	} 
} 
	}, ["d2"] = {
	 {
 ["person"] = "player", ["text"] = {
	 ". . ." 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "Yesssss. . ." 
	} 
}, {
 ["person"] = "e2", ["text"] = {
	 "Oh yessss. . ." 
	} 
}, {
 ["person"] = "e3", ["text"] = {
	 "The Sacrificccccceee is almossst complete. . ." 
	} 
}, {
 ["person"] = "e4", ["text"] = {
	 "Your flesh and wallet. . .", ". . .will help our Massster. . ." 
	} 
}, {
 ["person"] = "e5", ["text"] = {
	 "So he can continue helping ussss. . ." 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "Yesssss, Thomasssss. . .", "Soon you will become the top donator. . ." 
	} 
}, {
 ["person"] = "e2", ["text"] = {
	 "Yesss. . ." 
	} 
}, {
 ["person"] = "e3", ["text"] = {
	 "Jussst like usss. . ." 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "Hey!" 
	} 
}, {
 ["person"] = "e5", ["text"] = {
	 "Whatssss that?!" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "The mortal!" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "Leave this guy alone!", "He didn't do anything!" 
	} 
}, {
 ["person"] = "e4", ["text"] = {
	 "It's none of your businessss, human!" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "It'ssss Mastersssss. . ." 
	} 
}, {
 ["person"] = "e3", ["text"] = {
	 "You are nothing, compared to usss. . ." 
	} 
}, {
 ["person"] = "e2", ["text"] = {
	 "Die, mortal!!!" 
	} 
} 
	}, ["d1"] = {
	 {
 ["person"] = "player", ["text"] = {
	 "Christ. . .", "What is that smell?", ". . .", "I'd better find the server owner.", ". . .", "Or anyone, at least. . ." 
	} 
} 
	}, ["d4"] = {
	 {
 ["person"] = "player", ["text"] = {
	 ". . .", "Is this Carl's shotgun?", "It looks really familiar. . ." 
	} 
}, {
 ["person"] = "e7", ["text"] = {
	 "The Massssster awaaaitsssssssssss. . ." 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "What?!" 
	} 
} 
	}, ["d3"] = {
	 {
 ["person"] = "player", ["text"] = {
	 "What have they done. . .", "Are you alright?" 
	} 
}, {
 ["person"] = "e6", ["text"] = {
	 ". . ." 
	} 
} 
	} 
}
SCENE.Triggers = {
 ["t1"] = {
	 ["pos"] = Vector( 2927, 184, 3 ), ["size"] = 33, ["data"] = "true", ["action"] = "pauseenemies", ["CheckTriggers"] = {
		 "t4" 
		}, ["trigger_once"] = true 
	}, ["t19"] = {
	 ["pos"] = Vector( 950, 301, 1 ), ["size"] = 10, ["action"] = "spawn", ["CheckTriggers"] = {
		 "t21" 
		}, ["objects"] = {
		 "w2" 
		} 
	}, ["t4"] = {
	 ["pos"] = Vector( 2941, 72, 1 ), ["size"] = 10, ["event"] = "OnDialogueFinished", ["action"] = "event", ["data"] = {
		 "d1" 
		}, ["objects"] = {
		 "t1" 
		} 
	}, ["t3"] = {
	 ["pos"] = Vector( 2833, 64, 1 ), ["size"] = 10, ["event"] = "OnLevelLoaded", ["action"] = "event", ["objects"] = {
		 "t2" 
		} 
	}, ["t5"] = {
	 ["pos"] = Vector( 1216, 86, 1 ), ["size"] = 60, ["action"] = "dialogue", ["CheckTriggers"] = {
		 "t6" 
		}, ["objects"] = {
		 "d2" 
		} 
	}, ["t15"] = {
	 ["pos"] = Vector( 969, -407, 1 ), ["size"] = 10, ["event"] = "OnDialogueFinished", ["action"] = "event", ["data"] = {
		 "d2" 
		}, ["objects"] = {
		 "t14" 
		} 
	}, ["t26"] = {
	 ["pos"] = Vector( 1302, 220, 1 ), ["size"] = 10, ["event"] = "OnDialogueFinished", ["action"] = "event", ["data"] = {
		 "d4" 
		}, ["objects"] = {
		 "t25" 
		} 
	}, ["t6"] = {
	 ["action"] = "linker", ["pos"] = Vector( 1105, -148, 2 ), ["size"] = 194, ["objects"] = {
		 "t5" 
		} 
	}, ["t11"] = {
	 ["pos"] = Vector( 1429, -960, 1 ), ["size"] = 10, ["trigger_once"] = true, ["action"] = "spawn", ["CheckTriggers"] = {
		 "t12" 
		}, ["objects"] = {
		 "w1" 
		} 
	}, ["t7"] = {
	 ["pos"] = Vector( 949, 177, 1 ), ["CheckTriggers"] = {
		 "t8" 
		}, ["action"] = "playmusic", ["size"] = 10, ["trigger_once"] = true 
	}, ["t22"] = {
	 ["pos"] = Vector( 1125, 211, 1 ), ["size"] = 10, ["action"] = "spawn", ["CheckTriggers"] = {
		 "t24" 
		}, ["objects"] = {
		 "e7" 
		} 
	}, ["t33"] = {
	 ["pos"] = Vector( 1899, -310, 1 ), ["size"] = 10, ["event"] = "OnDialogueStarted", ["action"] = "event", ["data"] = {
		 "d2" 
		}, ["objects"] = {
		 "t32" 
		} 
	}, ["t16"] = {
	 ["pos"] = Vector( 1133, -122, -3 ), ["size"] = 62, ["action"] = "dialogue", ["CheckTriggers"] = {
		 "t17" 
		}, ["objects"] = {
		 "d3" 
		} 
	}, ["t2"] = {
	 ["pos"] = Vector( 2833, 22, 1 ), ["size"] = 10, ["action"] = "dialogue", ["CheckTriggers"] = {
		 "t3" 
		}, ["objects"] = {
		 "d1" 
		} 
	}, ["t8"] = {
	 ["pos"] = Vector( 1009, 195, 1 ), ["size"] = 10, ["event"] = "OnDialogueFinished", ["action"] = "event", ["data"] = {
		 "d2" 
		}, ["objects"] = {
		 "t7" 
		} 
	}, ["t21"] = {
	 ["pos"] = Vector( 997, 331, 1 ), ["size"] = 10, ["event"] = "OnDialogueFinished", ["action"] = "event", ["data"] = {
		 "d3" 
		}, ["objects"] = {
		 "t19", "t20" 
		} 
	}, ["t20"] = {
	 ["pos"] = Vector( 994, 266, 1 ), ["size"] = 10, ["action"] = "arrow", ["CheckTriggers"] = {
		 "t21" 
		}, ["objects"] = {
		 "w2" 
		} 
	}, ["t35"] = {
	 ["pos"] = Vector( 1954, -187, 1 ), ["size"] = 10, ["event"] = "OnDialogueFinished", ["action"] = "event", ["data"] = {
		 "d5" 
		}, ["objects"] = {
		 "t34" 
		} 
	}, ["t9"] = {
	 ["pos"] = Vector( 1102, -445, 9 ), ["CheckTriggers"] = {
		 "t10" 
		}, ["action"] = "newspawnpoint", ["size"] = 28, ["trigger_once"] = true 
	}, ["t18"] = {
	 ["pos"] = Vector( 1077, 104, 6 ), ["size"] = 10, ["event"] = "OnAllEnemiesKilled", ["action"] = "event", ["objects"] = {
		 "t17" 
		} 
	}, ["t25"] = {
	 ["size"] = 10, ["pos"] = Vector( 1344, 240, 1 ), ["CheckTriggers"] = {
		 "t26" 
		}, ["action"] = "nextlevel" 
	}, ["t24"] = {
	 ["pos"] = Vector( 1080, 176, 1 ), ["size"] = 10, ["event"] = "OnWeaponRemoved", ["action"] = "event", ["data"] = {
		 "w2" 
		}, ["objects"] = {
		 "t23", "t22" 
		} 
	}, ["t14"] = {
	 ["pos"] = Vector( 1012, -401, 1 ), ["size"] = 10, ["trigger_once"] = true, ["action"] = "spawn", ["CheckTriggers"] = {
		 "t15" 
		}, ["objects"] = {
		 "t13" 
		} 
	}, ["t13"] = {
	 ["pos"] = Vector( 1106, -444, 9 ), ["size"] = 23, ["action"] = "arrow", ["CheckTriggers"] = {
		 "t14" 
		}, ["objects"] = {
		 "w1" 
		} 
	}, ["t30"] = {
	 ["pos"] = Vector( 1294, 159, 1 ), ["size"] = 10, ["event"] = "OnWeaponRemoved", ["action"] = "event", ["data"] = {
		 "w2" 
		}, ["objects"] = {
		 "t27" 
		} 
	}, ["t12"] = {
	 ["pos"] = Vector( 1429, -884, 1 ), ["size"] = 10, ["event"] = "OnDialogueFinished", ["action"] = "event", ["data"] = {
		 "d2" 
		}, ["objects"] = {
		 "t11" 
		} 
	}, ["t17"] = {
	 ["pos"] = Vector( 998, 98, 7 ), ["size"] = 10, ["action"] = "spawn", ["CheckTriggers"] = {
		 "t18" 
		}, ["objects"] = {
		 "t16" 
		} 
	}, ["t23"] = {
	 ["pos"] = Vector( 1080, 232, 1 ), ["size"] = 10, ["action"] = "dialogue", ["CheckTriggers"] = {
		 "t24" 
		}, ["objects"] = {
		 "d4" 
		} 
	}, ["t27"] = {
	 ["size"] = 10, ["pos"] = Vector( 1344, 150, 1 ), ["CheckTriggers"] = {
		 "t30" 
		}, ["action"] = "levelclear" 
	}, ["t28"] = {
	 ["pos"] = Vector( 1215, 219, 1 ), ["size"] = 10, ["action"] = "hudmessage", ["CheckTriggers"] = {
		 "t29" 
		}, ["data"] = "Go to Thomas" 
	}, ["t32"] = {
	 ["pos"] = Vector( 1869, -360, 1 ), ["size"] = 10, ["action"] = "disarm", ["CheckTriggers"] = {
		 "t33" 
		}, ["objects"] = {
		 "t31" 
		} 
	}, ["t34"] = {
	 ["pos"] = Vector( 1892, -247, 1 ), ["data"] = "true", ["action"] = "pauseenemies", ["size"] = 10, ["CheckTriggers"] = {
		 "t35" 
		} 
	}, ["t31"] = {
	 ["pos"] = Vector( 1783, -279, 1 ), ["size"] = 42, ["action"] = "dialogue", ["CheckTriggers"] = {
		 "t32" 
		}, ["objects"] = {
		 "d5" 
		} 
	}, ["t29"] = {
	 ["pos"] = Vector( 1179, 196, 1 ), ["size"] = 10, ["event"] = "OnAllEnemiesKilled", ["action"] = "event", ["objects"] = {
		 "t28" 
		} 
	}, ["t10"] = {
	 ["pos"] = Vector( 1197, -463, 1 ), ["size"] = 28, ["event"] = "OnDialogueStarted", ["action"] = "event", ["data"] = {
		 "d2" 
		}, ["objects"] = {
		 "t9" 
		} 
	} 
}
SCENE.Characters = {
 "protagonist" 
}
SCENE.Name = "mutilation"
SCENE.PickupsPersistance = true
SCENE.BloodMoonScreen = true
SCENE.SoundTrack = 163817496
SCENE.StartFrom = 21400
SCENE.Ambient = 203462882
SCENE.AmbientEndAt = 66000
SCENE.AmbientPlayback = 0.8
SCENE.Volume = 55
SCENE.AmbientVolume = 40
SCENE.Terror = true

SCENE.Initialize = function()
end

SCENE.Loaded = function()
	PLAYER_SPAWNPOINT = Vector( 2924, 183, 3 )
end
 