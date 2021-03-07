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
SCENE.MusicText = "THE ENCOUNTER - Pure"
SCENE.Dialogues = {
 ["d2"] = {
	 {
 ["person"] = "e5", ["text"] = {
	 "FUCK YOU, WATCH!!!!!" 
	} 
} 
	}, ["d1"] = {
	 {
 ["person"] = "e1", ["text"] = {
	 ". . .and so I'm like. . .", "\"Boy, your server can't even reach 800 player limit. . .\"", ". . .and he is like. . .", ". . ." 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 ". . .", "Hi." 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "Well, well, well. . .", "Look who we have got there, boys!", "Looks like some random. . .", ". . .", "Wait a second. . .", "Your face!", "It's upside down!" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "That's right, you shady bastards!", "King watch here!", "And you are all under arrest!" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 ". . .", "Hahahahahahaha!", "Not so fast, chinboy.", "Do you seriously think, you can take\\non big server men all by yourself?" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "That's right!", "I know all your dirty tricks,\\nand I know that you only attack 2 times. . .", "Now shut up and let me handcuff you!" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "Hahahahaha!!!", "Big server men, attack!" 
	} 
} 
	}, ["d3"] = {
	 {
 ["person"] = "player", ["text"] = {
	 ". . .", "Hey, what the shit?!", "You are not supposed to send a 3rd wave at me!", "You cheating bastards!" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 ". . .", "Oh boy. . ." 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "You really like to say \"boy\" a lot." 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "I will say it as much as I please. . .", ". . .boy." 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "*sigh*" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "Don't worry, boy.", "We gonna take you to marishka for a dinner.", "Since master is not in mood to eat lately. . .", "We gonna serve you good. . ." 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "Cool.", "You gonna feed me to death?" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 ". . .", "No.", "Big server men!", "Take him to our secret hideout. . ." 
	} 
} 
	} 
}
SCENE.StartFrom = 28500
SCENE.Characters = {
 "watch" 
}
SCENE.AmbientStartFrom = 3000
SCENE.Volume = 85
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
		 ["start"] = 116100, ["endpos"] = 252000 
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
SCENE.EndAt = 115500
SCENE.SoundTrack = 309414904
SCENE.Ambient = 298081381
SCENE.Vehicle = {
 ["type"] = 10, ["pos"] = Vector( 4061, 3099, 36 ), ["mdl"] = "models/props_vehicles/car005a.mdl", ["ang"] = Angle( 0, -77, 0 ) 
}
SCENE.AmbientVolume = 75
SCENE.Name = "big server men"
SCENE.FlipPlayerIcon = true

SCENE.Initialize = function()
end

SCENE.Loaded = function()
	PLAYER_SPAWNPOINT = Vector( 3872, 3105, 1 )
end

