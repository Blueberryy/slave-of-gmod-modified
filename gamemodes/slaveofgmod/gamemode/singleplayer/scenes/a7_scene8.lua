SCENE.Order = 32
SCENE.Act = 7
SCENE.Map = "sog_destruct_v3"
SCENE.Achievement = "protagonist"
SCENE.NoPickupsRespawn = true
SCENE.OverrideStoryProgress = true
SCENE.Cover = Material( "sog/covers/dvd_disk_default_bonus.png" , "alphatest")
SCENE.Enemies = {
 ["e1"] = {
	 ["pos"] = Vector( -1519, -3327, 1 ), ["stages"] = {
		 1, 2 
		}, ["beh"] = 0, ["char"] = "boss protagonist", ["ang"] = Angle( 0, 0, 0 ) 
	} 
}
SCENE.SpookyBackground = true
SCENE.BloodyScreen = true
SCENE.Volume = 30
SCENE.PickupsPersistance = true
SCENE.AmbientPlayback = 0.5
SCENE.StartFrom = 33900
SCENE.SoundTrack = 516186612
SCENE.MusicText = "FUNERAL DIRECTOR - Downstairs"
SCENE.Dialogues = {
 ["d1"] = {
	 {
 ["person"] = "player", ["text"] = {
	 ". . ." 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "!g. . .", "Please. . .", "!gd̶o̴n̵'̷t̶ ̸y̶o̶u̴ ̷d̶a̴r̷e̶" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 ". . ." 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "Make it stop. . .", "This voice in my head. . .", "I can't take it. . .", "!g. . .", "I. . .", "!ga̴r̵g̵h̷!̸!̷!̷" 
	} 
} 
	} 
}
SCENE.NoPickups = true
SCENE.Pickups = {
 ["w1"] = {
	 ["wep"] = "sogm_pipe_special", ["pos"] = Vector( -1305, -3313, 1 ) 
	} 
}
SCENE.MusicPlayback = 1
SCENE.Name = "flashbacks"
SCENE.BloodMoonScreen = true
SCENE.Characters = {
 "james" 
}
SCENE.AmbientStartFrom = 140000
SCENE.EndAt = 138200
SCENE.Triggers = {
 ["t5"] = {
	 ["pos"] = Vector( -728, -3043, -7 ), ["size"] = 10, ["event"] = "OnDialogueFinished", ["stages"] = {
		 1 
		}, ["action"] = "event", ["data"] = {
		 "d1" 
		}, ["objects"] = {
		 "t4" 
		} 
	}, ["t1"] = {
	 ["pos"] = Vector( -737, -3256, -7 ), ["size"] = 10, ["CheckTriggers"] = {
		 "t2" 
		}, ["stages"] = {
		 1 
		}, ["action"] = "pauseenemies", ["data"] = "true", ["trigger_once"] = true 
	}, ["t6"] = {
	 ["pos"] = Vector( -782, -3036, -7 ), ["CheckTriggers"] = {
		 "t7" 
		}, ["action"] = "playmusic", ["size"] = 10, ["trigger_once"] = true 
	}, ["t9"] = {
	 ["pos"] = Vector( -1315, -3258, 1 ), ["size"] = 10, ["event"] = "OnStageStart", ["action"] = "event", ["data"] = 2, ["objects"] = {
		 "t8" 
		} 
	}, ["t8"] = {
	 ["CheckTriggers"] = {
		 "t9" 
		}, ["pos"] = Vector( -1315, -3352, 1 ), ["size"] = 10, ["action"] = "newspawnpoint" 
	}, ["t7"] = {
	 ["pos"] = Vector( -838, -3031, -7 ), ["size"] = 10, ["event"] = "OnStageStart", ["action"] = "event", ["data"] = 2, ["objects"] = {
		 "t6" 
		} 
	}, ["t2"] = {
	 ["pos"] = Vector( -739, -3190, -7 ), ["size"] = 10, ["event"] = "OnLevelLoaded", ["stages"] = {
		 1 
		}, ["action"] = "event", ["objects"] = {
		 "t1" 
		} 
	}, ["t4"] = {
	 ["pos"] = Vector( -669, -3031, -7 ), ["CheckTriggers"] = {
		 "t5" 
		}, ["stages"] = {
		 1 
		}, ["action"] = "activate_stage", ["size"] = 10, ["data"] = 2 
	}, ["t3"] = {
	 ["pos"] = Vector( -1451, -3332, 1 ), ["size"] = 88, ["stages"] = {
		 1 
		}, ["action"] = "dialogue", ["objects"] = {
		 "d1" 
		} 
	} 
}
SCENE.AmbientEndAt = 179000
SCENE.DisableNextbotLights = true
SCENE.Ambient = 516186612
SCENE.BadassMode = true
SCENE.AmbientVolume = 30
SCENE.StartFromAmbient = true

SCENE.Initialize = function()
end

SCENE.Loaded = function()
	PLAYER_SPAWNPOINT = Vector( 1750, -2687, -7 )
end

