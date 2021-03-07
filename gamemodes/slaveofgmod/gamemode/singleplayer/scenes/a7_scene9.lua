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
	 ". . ." 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "You still do not realise how pointless it is.", "All what you are doing." 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 ". . ." 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "!gy̵o̴u̵.̴ ̵.̵ ̶.̵", "Staring at everything from above." 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 ". . ." 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "Let's see if you are as confident\\nwhen you are down there." 
	} 
} 
	}, ["d1"] = {
	 {
 ["person"] = "player", ["text"] = {
	 ". . ." 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 ". . .", "You. . .", "A freelancer and a coder named James. . .", "Also known as Matt's personal bodyguard and his bitch. . .", ". . .when it comes to jobs where he is afraid\\nto get his own hands dirty." 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 ". . ." 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "You should've given up back then, James.", "When you had a chance.", "But no. . .", "This community is as stubborn\\nas it is good at making things worse. . .", "You are no exception." 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 "Who the hell are you?" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "Does it matter?", "I used to be a server owner.", "And a very good one!", "Not like these shitheads. . .", ". . .that should not even allowed to be in charge." 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 ". . ." 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "Unlike you, I wanted to make gmod better.", "So I did my part.", "I made a fantastic banlist addon.", "It was pretty strict, but better safe than sorry.", "But this salty community was not happy about it.", "Because of them - garry has locked me in here. ", "And look how the tides have turned now!", "Look around you." 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 ". . ." 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "They and their servers are all gone.", "I have been there for so long. . .", ". . .that I guess now I am a part of gmod too.", "And you know what this means?" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 ". . .", "No?" 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "This means that I am a goddamn savior of gmod!", "This small remnant of gmod will still exist.", "As long as I'm here.", "So, I'd say your task to kill gmod is not over yet.", "Don't you agree?" 
	} 
}, {
 ["person"] = "player", ["text"] = {
	 ". . ." 
	} 
}, {
 ["person"] = "e1", ["text"] = {
	 "I will fix that." 
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
SCENE.Name = "return end"
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