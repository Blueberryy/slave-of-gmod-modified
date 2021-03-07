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
	 "Oh snap!" 
	} 
}, {
 ["person"] = "e2", ["text"] = {
	 "Now tell me. . .", "Was that so hard to do?", "Without letting her kill. . .I dunno. . .", ". . .pretty much everyone in the park." 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "Dunno.", "It was a girl, after all. . ." 
	} 
}, {
 ["person"] = "e2", ["text"] = {
	 "\"It was a girl! Waaah!\"", "At the same time it could be some ugly as fuck guy. . .", ". . .using same playermodel." 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 ". . ." 
	} 
}, {
 ["person"] = "e2", ["text"] = {
	 "Let's go back inside.", "Thankfully there are still some\\nuseful CoderFired 'employees' left. . .", "That won't care what they do,\\nas long as they are gettting paid." 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "Neat." 
	} 
}, {
 ["person"] = "e2", ["text"] = {
	 "Now go!", "We have to milk the shit out of this game\\nwhile we can." 
	} 
} 
	}, ["d2"] = {
	 {
 ["person"] = "player", ["text"] = {
	 ". . ." 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "This is a private property, sweetheart!", "No entry." 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 ". . .", "I work here." 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "There is no more CoderFired." 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "What?" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "It was closed down.", "So I think you'd better leave." 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 ". . .", "Closed?", "What the hell are you talking about?" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "You heard that right.", "This is you last chance to leave.", "Don't make this worse than it needs to be. . ." 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "Let me through." 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "Welp.", "I warned you." 
	} 
} 
	}, ["d1"] = {
	 {
 ["person"] = "player", ["text"] = {
	 "That looks. . .", ". . .weird." 
	} 
} 
	}, ["d4"] = {
	 {
 ["person"] = "player", ["text"] = {
	 "Ugh. . ." 
	} 
} 
	}, ["d3"] = {
	 {
 ["person"] = "e1", ["text"] = {
	 "Not bad." 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "Now, let me th. . ." 
	} 
}, {
 ["person"] = "e2", ["text"] = {
	 "What the fuck is all this noise?" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "See for yourself. . ." 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "Who are you?" 
	} 
}, {
 ["person"] = "e2", ["text"] = {
	 "Same question, my dear. . ." 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 ". . .", "Where the hell is Mark?!" 
	} 
}, {
 ["person"] = "e2", ["text"] = {
	 "Mark. . .", "Oh right!", "Mark decided to take a long vacation. . ." 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "Eternal vacation." 
	} 
}, {
 ["person"] = "e2", ["text"] = {
	 "Hahaha!", "It's funny, because it's true.", ". . .", "Anyway, what do you want?" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "I told you.", "I work here and I have some of my stuff in there.", "Now let me through!" 
	} 
}, {
 ["person"] = "e2", ["text"] = {
	 "And that's it?" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "Yes!" 
	} 
}, {
 ["person"] = "e2", ["text"] = {
	 "Why didn't you said so in a first place?", "Welcome to the team!", "Here is your very personal entry ticket." 
	} 
} 
	} 
}
SCENE.Characters = {
 "moderator" 
}
SCENE.Name = "paywall"
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

