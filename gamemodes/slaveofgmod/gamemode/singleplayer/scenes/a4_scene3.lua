SCENE.Order = 15
SCENE.Act = 4
SCENE.Map = "sog_greed_v2"
SCENE.FlipView = true
SCENE.ShowLastEnemies = true
SCENE.Enemies = {
 ["e3"] = {
	 ["pos"] = Vector( -736, -257, 1 ), ["anim"] = "taunt_dance_base", ["ang"] = Angle( 0, -147, 0 ), ["icon"] = "sog/mark_weird.png", ["beh"] = 0, ["char"] = "mark", ["wep"] = "none" 
	}, ["e13"] = {
	 ["ang"] = Angle( 0, 180, 0 ), ["pos"] = Vector( 580, -345, 1 ), ["beh"] = 0, ["char"] = "mark" 
	}, ["e4"] = {
	 ["pos"] = Vector( -847, -282, 1 ), ["anim"] = "zombie_slump_idle_02", ["ang"] = Angle( 0, 94, 0 ), ["icon"] = "sog/mark_weird.png", ["beh"] = 0, ["char"] = "mark", ["wep"] = "none" 
	}, ["e18"] = {
	 ["CheckTriggers"] = {
		 "t8" 
		}, ["pos"] = Vector( -977, -352, 1 ), ["anim"] = "pose_standing_01", ["beh"] = -1, ["ang"] = Angle( 0, 2, 0 ), ["char"] = "mercenary", ["immune"] = true, ["wep"] = "none" 
	}, ["e8"] = {
	 ["ang"] = Angle( 0, -86, 0 ), ["pos"] = Vector( 1050, 87, 1 ), ["beh"] = 0, ["char"] = "mark" 
	}, ["e5"] = {
	 ["ang"] = Angle( 0, 180, 0 ), ["pos"] = Vector( 37, 229, 1 ), ["beh"] = 0, ["char"] = "mark" 
	}, ["e6"] = {
	 ["pos"] = Vector( 556, -945, 1 ), ["ang"] = Angle( 0, 180, 0 ), ["beh"] = 0, ["char"] = "mark", ["wep"] = "none" 
	}, ["e14"] = {
	 ["ang"] = Angle( 0, 180, 0 ), ["pos"] = Vector( 65, -1129, 1 ), ["beh"] = 0, ["char"] = "mark" 
	}, ["e9"] = {
	 ["pos"] = Vector( 558, 169, 1 ), ["ang"] = Angle( 0, -86, 0 ), ["beh"] = 0, ["char"] = "mark", ["wep"] = "none" 
	}, ["e7"] = {
	 ["ang"] = Angle( 0, 90, 0 ), ["pos"] = Vector( -172, -969, 1 ), ["beh"] = 0, ["char"] = "mark" 
	}, ["e16"] = {
	 ["ang"] = Angle( 0, -86, 0 ), ["pos"] = Vector( 306, 425, 1 ), ["beh"] = 0, ["char"] = "mark", ["wep"] = "none" 
	}, ["e11"] = {
	 ["pos"] = Vector( 847, -648, 1 ), ["ang"] = Angle( 0, 90, 0 ), ["beh"] = 0, ["char"] = "mark", ["wep"] = "sogm_deagle" 
	}, ["e15"] = {
	 ["pos"] = Vector( -331, -639, 1 ), ["ang"] = Angle( 0, 26, 0 ), ["beh"] = 0, ["char"] = "mark", ["wep"] = "none" 
	}, ["e17"] = {
	 ["ang"] = Angle( 0, -180, 0 ), ["pos"] = Vector( 884, 455, 1 ), ["beh"] = 0, ["char"] = "mark" 
	}, ["e1"] = {
	 ["pos"] = Vector( -732, -446, 1 ), ["anim"] = "pose_standing_01", ["ang"] = Angle( 0, 152, 0 ), ["icon"] = "sog/mark_weird.png", ["beh"] = 0, ["char"] = "mark", ["wep"] = "none" 
	}, ["e2"] = {
	 ["pos"] = Vector( -687, -352, 1 ), ["anim"] = "pose_standing_02", ["ang"] = Angle( 0, -169, 0 ), ["icon"] = "sog/mark_weird.png", ["beh"] = 0, ["char"] = "mark", ["wep"] = "none" 
	}, ["e10"] = {
	 ["pos"] = Vector( 405, 452, 1 ), ["ang"] = Angle( 0, -180, 0 ), ["beh"] = 0, ["char"] = "mark", ["wep"] = "none" 
	}, ["e12"] = {
	 ["ang"] = Angle( 0, 11, 0 ), ["pos"] = Vector( 325, -1103, 1 ), ["beh"] = 0, ["char"] = "mark", ["wep"] = "none" 
	} 
}
SCENE.AddThunder = true
SCENE.Volume = 26
SCENE.Pickups = {
 ["w3"] = {
	 ["wep"] = "sogm_glassbottle_broken", ["pos"] = Vector( -629, 93, 1 ) 
	}, ["w5"] = {
	 ["wep"] = "sogm_glassbottle_broken", ["pos"] = Vector( 558, -964, 1 ) 
	}, ["w1"] = {
	 ["wep"] = "sogm_glassbottle", ["pos"] = Vector( -45, -415, 1 ) 
	}, ["w12"] = {
	 ["wep"] = "sogm_glassbottle_broken", ["pos"] = Vector( 572, -3, 1 ) 
	}, ["w6"] = {
	 ["wep"] = "sogm_glassbottle_broken", ["pos"] = Vector( -218, -539, 1 ) 
	}, ["w11"] = {
	 ["wep"] = "sogm_extinguisher", ["pos"] = Vector( 427, -1207, 1 ) 
	}, ["w8"] = {
	 ["wep"] = "sogm_glassbottle_broken", ["pos"] = Vector( -857, -427, 1 ) 
	}, ["w2"] = {
	 ["wep"] = "sogm_glassbottle", ["pos"] = Vector( -580, 93, 1 ) 
	}, ["w7"] = {
	 ["wep"] = "sogm_glassbottle", ["pos"] = Vector( -837, -414, 1 ) 
	}, ["w4"] = {
	 ["wep"] = "sogm_glassbottle_broken", ["pos"] = Vector( 96, -26, 1 ) 
	}, ["w9"] = {
	 ["wep"] = "sogm_glassbottle_broken", ["pos"] = Vector( 537, 222, 1 ) 
	}, ["w10"] = {
	 ["wep"] = "sogm_glassbottle_broken", ["pos"] = Vector( -151, -1179, 1 ) 
	} 
}
SCENE.MusicText = "L'Enfant De La Foret - Angst"
SCENE.Dialogues = {
 ["d2"] = {
	 {
 ["person"] = "player", ["text"] = {
	 "Fucking headache!!!" 
	} 
} 
	}, ["d1"] = {
	 {
 ["person"] = "player", ["text"] = {
	 "Shit. . .", "My head. . ." 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "Celebrating already?", "But what about your best friend?!" 
	} 
}, {
 ["person"] = "e2", ["text"] = {
	 "We are rich!", "We can afford to celebrate!" 
	} 
}, {
 ["person"] = "e3", ["text"] = {
	 "It's laggy as shit. . .", "Help!" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "What the fuck is going on?" 
	} 
}, {
 ["person"] = "e4", ["text"] = {
	 "Leakers are dead!\\nWe won, once again!", "Come on, mark.", "Just one more." 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "Yeah.", "One more would not hurt!" 
	} 
}, {
 ["person"] = "e2", ["text"] = {
	 "This place is heavily guarded!" 
	} 
}, {
 ["person"] = "e3", ["text"] = {
	 "So we can walk in and say 'Hi'!" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "Christ. . .shut up, you freaks!!!" 
	} 
} 
	}, ["d3"] = {
	 {
 ["person"] = "player", ["text"] = {
	 ". . ." 
	} 
}, {
 ["person"] = "e18", ["text"] = {
	 "How can I help you?" 
	} 
} 
	} 
}
SCENE.Characters = {
 "mark" 
}
SCENE.Name = "avarice"
SCENE.Triggers = {
 ["t5"] = {
	 ["pos"] = Vector( -62, -174, 1 ), ["size"] = 10, ["action"] = "dialogue", ["CheckTriggers"] = {
		 "t7" 
		}, ["objects"] = {
		 "d2" 
		} 
	}, ["t9"] = {
	 ["pos"] = Vector( -816, -541, 1 ), ["size"] = 10, ["event"] = "OnDialogueFinished", ["action"] = "event", ["data"] = {
		 "d2" 
		}, ["objects"] = {
		 "t8" 
		} 
	}, ["t1"] = {
	 ["pos"] = Vector( -791, -364, 1 ), ["data"] = "true", ["action"] = "pauseenemies", ["size"] = 44, ["trigger_once"] = true 
	}, ["t10"] = {
	 ["CheckTriggers"] = {
		 "t11", "t12" 
		}, ["pos"] = Vector( -550, -348, 1 ), ["size"] = 67, ["action"] = "nextlevel" 
	}, ["t13"] = {
	 ["pos"] = Vector( -761, -185, 1 ), ["size"] = 10, ["event"] = "OnDialogueStarted", ["action"] = "event", ["data"] = {
		 "d3" 
		}, ["objects"] = {
		 "t12" 
		} 
	}, ["t12"] = {
	 ["pos"] = Vector( -712, -155, 1 ), ["size"] = 10, ["action"] = "spawn", ["CheckTriggers"] = {
		 "t13" 
		}, ["objects"] = {
		 "t10" 
		} 
	}, ["t6"] = {
	 ["pos"] = Vector( -928, -350, 1 ), ["size"] = 63, ["action"] = "dialogue", ["CheckTriggers"] = {
		 "t8" 
		}, ["objects"] = {
		 "d3" 
		} 
	}, ["t7"] = {
	 ["pos"] = Vector( -95, -268, 1 ), ["size"] = 63, ["event"] = "OnLevelClear", ["action"] = "event", ["objects"] = {
		 "t5", "t4" 
		} 
	}, ["t8"] = {
	 ["pos"] = Vector( -907, -534, 1 ), ["size"] = 10, ["action"] = "spawn", ["CheckTriggers"] = {
		 "t9" 
		}, ["objects"] = {
		 "e18", "t6" 
		} 
	}, ["t2"] = {
	 ["pos"] = Vector( -818, -140, 1 ), ["size"] = 10, ["action"] = "dialogue", ["CheckTriggers"] = {
		 "t3" 
		}, ["objects"] = {
		 "d1" 
		} 
	}, ["t11"] = {
	 ["pos"] = Vector( -637, -473, 1 ), ["size"] = 67, ["event"] = "OnDialogueFinished", ["action"] = "event", ["data"] = {
		 "d3" 
		}, ["objects"] = {
		 "t10" 
		} 
	}, ["t4"] = {
	 ["pos"] = Vector( -48, -231, 1 ), ["CheckTriggers"] = {
		 "t7" 
		}, ["action"] = "hudmessage", ["data"] = "Get back to the office", ["size"] = 10 
	}, ["t3"] = {
	 ["pos"] = Vector( -861, -192, 1 ), ["size"] = 10, ["event"] = "OnLevelLoaded", ["action"] = "event", ["objects"] = {
		 "t2" 
		} 
	} 
}
SCENE.PickupsPersistance = true
SCENE.Nightmare = true
SCENE.SoundTrack = 196694696
SCENE.NoPickups = true

SCENE.EndAt = 148000

SCENE.Initialize = function()
end

SCENE.Loaded = function()
	PLAYER_SPAWNPOINT = Vector( -795, -362, 1 )
end
 