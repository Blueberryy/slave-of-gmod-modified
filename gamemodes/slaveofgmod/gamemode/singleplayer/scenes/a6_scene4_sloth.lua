SCENE.Order = 24
SCENE.Act = 6
SCENE.OutroCutscene = "bad idea outro"
SCENE.Map = "sog_construction_v3"
SCENE.Achievement = "sloth"
SCENE.Enemies = {
 ["e1"] = {
	 ["ang"] = Angle( 0, -86, 0 ), ["pos"] = Vector( 1542, 128, 9 ), ["beh"] = 0, ["char"] = "protagonist victim" 
	} 
}
SCENE.StartFromAmbient = true
SCENE.Terror = true
SCENE.BloodyScreen = true
SCENE.AddThunder = true
SCENE.Nightmare = true
SCENE.Volume = 30
SCENE.Pickups = {
 ["w1"] = {
	 ["wep"] = "sogm_extinguisher", ["pos"] = Vector( 1200, 225, 9 ) 
	} 
}
SCENE.MusicText = "L'Enfant De La Foret - The Rope"
SCENE.DrugEffect = true
SCENE.StartFrom = 34500
SCENE.SoundTrack = 203463137
SCENE.NoPickups = true
SCENE.NoMapProps = true
SCENE.Triggers = {
 ["t5"] = {
	 ["CheckTriggers"] = {
		 "t6" 
		}, ["pos"] = Vector( 1275, -198, 9 ), ["size"] = 10, ["action"] = "dialogue", ["objects"] = {
		 "d2" 
		} 
	}, ["t1"] = {
	 ["pos"] = Vector( 1430, -65, 9 ), ["size"] = 10, ["action"] = "dialogue", ["CheckTriggers"] = {
		 "t2" 
		}, ["objects"] = {
		 "d1" 
		} 
	}, ["t10"] = {
	 ["pos"] = Vector( 1310, 56, 9 ), ["size"] = 10, ["event"] = "OnDialogueFinished", ["action"] = "event", ["data"] = {
		 "d2" 
		}, ["objects"] = {
		 "t7" 
		} 
	}, ["t6"] = {
	 ["pos"] = Vector( 1275, -148, 9 ), ["size"] = 10, ["event"] = "OnLevelClear", ["action"] = "event", ["objects"] = {
		 "t5" 
		} 
	}, ["t9"] = {
	 ["pos"] = Vector( 1239, -0, 9 ), ["size"] = 10, ["event"] = "OnDialogueStarted", ["action"] = "event", ["data"] = {
		 "d2" 
		}, ["objects"] = {
		 "t8" 
		} 
	}, ["t8"] = {
	 ["CheckTriggers"] = {
		 "t9" 
		}, ["pos"] = Vector( 1255, -64, 9 ), ["size"] = 10, ["action"] = "spawn", ["objects"] = {
		 "t7" 
		} 
	}, ["t7"] = {
	 ["CheckTriggers"] = {
		 "t8", "t10" 
		}, ["pos"] = Vector( 1283, -16, 9 ), ["size"] = 10, ["action"] = "nextlevel" 
	}, ["t2"] = {
	 ["pos"] = Vector( 1430, -8, 9 ), ["size"] = 10, ["event"] = "OnLevelLoaded", ["action"] = "event", ["objects"] = {
		 "t1" 
		} 
	}, ["t4"] = {
	 ["pos"] = Vector( 1640, -34, 9 ), ["size"] = 10, ["event"] = "OnDialogueFinished", ["action"] = "event", ["data"] = {
		 "d1" 
		}, ["objects"] = {
		 "t3" 
		} 
	}, ["t3"] = {
	 ["pos"] = Vector( 1668, -77, 9 ), ["CheckTriggers"] = {
		 "t4" 
		}, ["action"] = "playmusic", ["size"] = 10, ["trigger_once"] = true 
	} 
}
SCENE.Characters = {
 "garry" 
}
SCENE.Name = "bad idea"
SCENE.EndAt = 244000
SCENE.BloodMoonScreen = true
SCENE.AmbientEndAt = 34000
SCENE.Dialogues = {
 ["d2"] = {
	 {
 ["person"] = "player", ["text"] = {
	 "Hahahahahaha!!!", "See what happens to the crybabies like you?!", "*cough*", "I'm not done with you yet. . .", "Oh, I'm not. . ." 
	} 
} 
	}, ["d1"] = {
	 {
 ["person"] = "e1", ["text"] = {
	 "Are you okay?" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "You idiots do not learn. . .", ". . .that complaining changes nothing!" 
	} 
} 
	} 
}
SCENE.Ambient = 203463137
SCENE.AmbientVolume = 30
SCENE.PickupsPersistance = true

SCENE.Initialize = function()
end

SCENE.Loaded = function()
	PLAYER_SPAWNPOINT = Vector( 1538, -53, 9 )
end
 