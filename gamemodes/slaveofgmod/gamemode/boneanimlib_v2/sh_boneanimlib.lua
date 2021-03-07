--[[

Bone Animations Library
Created by William "JetBoom" Moodhe (williammoodhe@gmail.com / www.noxiousnet.com)
Because I wanted custom, dynamic animations.
Give credit or reference if used in your creations.

]]

TYPE_GESTURE = 0 -- Gestures are keyframed animations that use the current position and angles of the bones. They play once and then stop automatically.
TYPE_POSTURE = 1 -- Postures are static animations that use the current position and angles of the bones. They stay that way until manually stopped. Use TimeToArrive if you want to have a posture lerp.
TYPE_STANCE = 2 -- Stances are keyframed animations that use the current position and angles of the bones. They play forever until manually stopped. Use RestartFrame to specify a frame to go to if the animation ends (instead of frame 1).
TYPE_SEQUENCE = 3 -- Sequences are keyframed animations that use the reference pose. They play forever until manually stopped. Use RestartFrame to specify a frame to go to if the animation ends (instead of frame 1).
-- You can also use StartFrame to specify a starting frame for the first loop.

INTERP_LINEAR = 0 -- Straight linear interp.
INTERP_COSINE = 1 -- Best compatability / quality balance.
INTERP_CUBIC = 2 -- Overall best quality blending but may cause animation frames to go 'over the top'.
INTERP_DEFAULT = INTERP_COSINE

local Animations = {}

function GetLuaAnimations()
	return Animations
end

function RegisterLuaAnimation(sName, tInfo)
	if tInfo.FrameData then
		local BonesUsed = {}
		for iFrame, tFrame in ipairs(tInfo.FrameData) do
			for iBoneID, tBoneTable in pairs(tFrame.BoneInfo) do
				BonesUsed[iBoneID] = (BonesUsed[iBoneID] or 0) + 1
				tBoneTable.MU = tBoneTable.MU or 0
				tBoneTable.MF = tBoneTable.MF or 0
				tBoneTable.MR = tBoneTable.MR or 0
				tBoneTable.RU = tBoneTable.RU or 0
				tBoneTable.RF = tBoneTable.RF or 0
				tBoneTable.RR = tBoneTable.RR or 0
			end
		end

		if #tInfo.FrameData > 1 then
			for iBoneUsed, iTimesUsed in pairs(BonesUsed) do
				for iFrame, tFrame in ipairs(tInfo.FrameData) do
					if not tFrame.BoneInfo[iBoneUsed] then
						tFrame.BoneInfo[iBoneUsed] = {MU = 0, MF = 0, MR = 0, RU = 0, RF = 0, RR = 0}
					end
				end
			end
		end
	end
	Animations[sName] = tInfo
end

-----------------------------
-- Deserialize / Serialize --
-----------------------------
function Deserialize(sIn)
	SRL = nil

	RunString(sIn)

	return SRL
end

local allowedtypes = {}
allowedtypes["string"] = true
allowedtypes["number"] = true
allowedtypes["table"] = true
allowedtypes["Vector"] = true
allowedtypes["Angle"] = true
allowedtypes["boolean"] = true
local function MakeTable(tab, done)
	local str = ""
	local done = done or {}

	local sequential = table.IsSequential(tab)

	for key, value in pairs(tab) do
		local keytype = type(key)
		local valuetype = type(value)

		if allowedtypes[keytype] and allowedtypes[valuetype] then
			if sequential then
				key = ""
			else
				if keytype == "number" or keytype == "boolean" then 
					key ="["..tostring(key).."]="
				else
					key = "["..string.format("%q", tostring(key)).."]="
				end
			end

			if valuetype == "table" and not done[value] then
				done[value] = true
				if type(value._serialize) == "function" then
					str = str..key..value:_serialize()..","
				else
					str = str..key.."{"..MakeTable(value, done).."},"
				end
			else
				if valuetype == "string" then 
					value = string.format("%q", value)
				elseif valuetype == "Vector" then
					value = "Vector("..value.x..","..value.y..","..value.z..")"
				elseif valuetype == "Angle" then
					value = "Angle("..value.pitch..","..value.yaw..","..value.roll..")"
				else
					value = tostring(value)
				end

				str = str .. key .. value .. ","
			end
		end
	end

	if string.sub(str, -1) == "," then
		return string.sub(str, 1, #str - 1)
	else
		return str
	end
end

function Serialize(tIn, bRaw)
	if bRaw then
		return "{"..MakeTable(tIn).."}"
	end

	return "SRL={"..MakeTable(tIn).."}"
end
---------------------------------
-- End Deserialize / Serialize --
---------------------------------

RegisterLuaAnimation('aaaa2', {
	FrameData = {
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine'] = {
					RU = 30,
					RR = 30
				},
				['ValveBiped.Bip01_Head1'] = {
				}
			},
			FrameRate = 1
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine'] = {
					RU = -30,
					RR = -30
				},
				['ValveBiped.Bip01_Head1'] = {
					RF = 102
				}
			},
			FrameRate = 1
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Head1'] = {
					RF = -227
				},
				['ValveBiped.Bip01_Spine'] = {
				}
			},
			FrameRate = 1
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Head1'] = {
					RF = 128
				},
				['ValveBiped.Bip01_Spine'] = {
				}
			},
			FrameRate = 1
		}
	},
	RestartFrame = 1,
	Type = TYPE_STANCE
})


RegisterLuaAnimation('fist_right', {
	FrameData = {
		{
			BoneInfo = {
				['ValveBiped.Bip01_R_UpperArm'] = {
				},
				['ValveBiped.Bip01_R_Hand'] = {
				},
				['ValveBiped.Bip01_Spine4'] = {
				},
				['ValveBiped.Bip01_R_Clavicle'] = {
				},
				['ValveBiped.Bip01_Spine2'] = {
				},
				['ValveBiped.Bip01_R_Forearm'] = {
				}
			},
			FrameRate = 12
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_R_UpperArm'] = {
					RU = -20.970212715127,
					RR = 9.7170009622594,
					RF = 10.324555320337
				},
				['ValveBiped.Bip01_R_Hand'] = {
					RU = 6.4787086646191,
					RR = -8.365586384832,
					RF = 5.064495102246
				},
				['ValveBiped.Bip01_Spine4'] = {
					RU = -11.819131909661,
					RR = 0.52786404500042,
					RF = -27.478708664619
				},
				['ValveBiped.Bip01_R_Clavicle'] = {
					RU = 20.69842594896,
					RR = -44.812559200041,
					RF = -6.2360925615282
				},
				['ValveBiped.Bip01_Spine2'] = {
					RF = 4.5857864376269
				},
				['ValveBiped.Bip01_R_Forearm'] = {
					RU = -100.44870671782,
					RF = -20.478708664619,
					RR = -17.480209389979,
				}
			},
			FrameRate = 8
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_R_UpperArm'] = {
					RU = -67.621182385745,
					RR = 46.416229535483,
					RF = 2.6742737804639
				},
				['ValveBiped.Bip01_R_Hand'] = {
					RU = 10.721349351738,
					RR = -8.365586384832,
					RF = -31.171572875254
				},
				['ValveBiped.Bip01_Spine4'] = {
					RF = 13.928026786694
				},
				['ValveBiped.Bip01_R_Clavicle'] = {
					RR = 9.2911079367554
				},
				['ValveBiped.Bip01_Spine2'] = {
					RF = 11.242640687119
				},
				['ValveBiped.Bip01_R_Forearm'] = {
					RU = -3.6070100959121,
					RF = -47.480209389979,
					RR = -27.480209389979,
				}
			},
			FrameRate = 7
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_R_UpperArm'] = {
				},
				['ValveBiped.Bip01_R_Forearm'] = {
				},
				['ValveBiped.Bip01_Spine4'] = {
				},
				['ValveBiped.Bip01_R_Clavicle'] = {
				},
				['ValveBiped.Bip01_Spine2'] = {
				},
				['ValveBiped.Bip01_R_Hand'] = {
				}
			},
			FrameRate = 7
		}
	},
	Type = TYPE_GESTURE
})

RegisterLuaAnimation('fist_left', {
	FrameData = {
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_UpperArm'] = {
				},
				['ValveBiped.Bip01_L_Hand'] = {
				},
				['ValveBiped.Bip01_Spine4'] = {
				},
				['ValveBiped.Bip01_L_Clavicle'] = {
				},
				['ValveBiped.Bip01_Spine2'] = {
				},
				['ValveBiped.Bip01_L_Forearm'] = {
				}
			},
			FrameRate = 12
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_UpperArm'] = {
					RU = 20.970212715127,
					RR = -9.7170009622594,
					RF = -10.324555320337
				},
				['ValveBiped.Bip01_L_Hand'] = {
					RU = 6.4787086646191,
					RR = -8.365586384832,
					RF = 5.064495102246
				},
				['ValveBiped.Bip01_Spine4'] = {
					RU = -11.819131909661,
					RR = 0.52786404500042,
					RF = 27.478708664619
				},
				['ValveBiped.Bip01_L_Clavicle'] = {
					RU = 20.69842594896,
					RR = 44.812559200041,
					RF = 6.2360925615282
				},
				['ValveBiped.Bip01_Spine2'] = {
					RF = -4.5857864376269
				},
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = -100.44870671782,
					RF = 20.478708664619,
					RR = 17.480209389979,
				}
			},
			FrameRate = 8
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_UpperArm'] = {
					RU = -67.621182385745,
					RR = -46.416229535483,
					RF = -2.6742737804639
				},
				['ValveBiped.Bip01_L_Hand'] = {
					RU = 10.721349351738,
					RR = 8.365586384832,
					RF = 31.171572875254
				},
				['ValveBiped.Bip01_Spine4'] = {
					RF = -13.928026786694
				},
				['ValveBiped.Bip01_L_Clavicle'] = {
					RR = -9.2911079367554
				},
				['ValveBiped.Bip01_Spine2'] = {
					RF = -11.242640687119
				},
				['ValveBiped.Bip01_L_Forearm'] = {
					RU = -3.6070100959121,
					RF = 47.480209389979,
					RR = 27.480209389979,
				}
			},
			FrameRate = 7
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_L_UpperArm'] = {
				},
				['ValveBiped.Bip01_L_Forearm'] = {
				},
				['ValveBiped.Bip01_Spine4'] = {
				},
				['ValveBiped.Bip01_L_Clavicle'] = {
				},
				['ValveBiped.Bip01_Spine2'] = {
				},
				['ValveBiped.Bip01_L_Hand'] = {
				}
			},
			FrameRate = 7
		}
	},
	Type = TYPE_GESTURE
})

RegisterLuaAnimation('roll', {
	FrameData = {
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine2'] = {
				},
				['ValveBiped.Bip01_Pelvis'] = {
				}
			},
			FrameRate = 10
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine2'] = {
					RU = 78.955341028598
				},
				['ValveBiped.Bip01_Pelvis'] = {
					RF = 54.162392153687
				}
			},
			FrameRate = 10
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine2'] = {
					RU = 78.955341028598
				},
				['ValveBiped.Bip01_Pelvis'] = {
					MU = -1.430643773264,
					RF = 131.48823637521
				}
			},
			FrameRate = 10
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine2'] = {
					RU = 78.955341028598
				},
				['ValveBiped.Bip01_Pelvis'] = {
					MU = -5.3347083681082,
					RF = 192.75567192718
				}
			},
			FrameRate = 10
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine2'] = {
					RU = 78.955341028598
				},
				['ValveBiped.Bip01_Pelvis'] = {
					MU = -7.950579786573,
					RF = 235.48087148308
				}
			},
			FrameRate = 10
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine2'] = {
					RU = 78.955341028598
				},
				['ValveBiped.Bip01_Pelvis'] = {
					MU = -7.950579786573,
					RF = 297.04672252115
				}
			},
			FrameRate = 10
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine2'] = {
					RU = 78.955341028598
				},
				['ValveBiped.Bip01_Pelvis'] = {
					MU = -4.2442135559418,
					RF = 329.24175943415
				}
			},
			FrameRate = 10
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine2'] = {
					RU = 35.560587500262
				},
				['ValveBiped.Bip01_Pelvis'] = {
					RF = 360
				}
			},
			FrameRate = 10
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine2'] = {
				},
				['ValveBiped.Bip01_Pelvis'] = {
					RF = 360
				}
			},
			FrameRate = 10
		}
	},
	Type = TYPE_GESTURE
})

RegisterLuaAnimation('roll_back', {
	FrameData = {
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine2'] = {
				},
				['ValveBiped.Bip01_Pelvis'] = {
				}
			},
			FrameRate = 10
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine2'] = {
					RU = 78.955341028598
				},
				['ValveBiped.Bip01_Pelvis'] = {
					RF = -54.162392153687
				}
			},
			FrameRate = 10
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine2'] = {
					RU = 78.955341028598
				},
				['ValveBiped.Bip01_Pelvis'] = {
					MU = -1.430643773264,
					RF = -131.48823637521
				}
			},
			FrameRate = 10
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine2'] = {
					RU = 78.955341028598
				},
				['ValveBiped.Bip01_Pelvis'] = {
					MU = -5.3347083681082,
					RF = -192.75567192718
				}
			},
			FrameRate = 10
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine2'] = {
					RU = 78.955341028598
				},
				['ValveBiped.Bip01_Pelvis'] = {
					MU = -7.950579786573,
					RF = -235.48087148308
				}
			},
			FrameRate = 10
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine2'] = {
					RU = 78.955341028598
				},
				['ValveBiped.Bip01_Pelvis'] = {
					MU = -7.950579786573,
					RF = -297.04672252115
				}
			},
			FrameRate = 10
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine2'] = {
					RU = 78.955341028598
				},
				['ValveBiped.Bip01_Pelvis'] = {
					MU = -4.2442135559418,
					RF = -329.24175943415
				}
			},
			FrameRate = 10
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine2'] = {
					RU = 35.560587500262
				},
				['ValveBiped.Bip01_Pelvis'] = {
					RF = -360
				}
			},
			FrameRate = 10
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine2'] = {
				},
				['ValveBiped.Bip01_Pelvis'] = {
					RF = -360
				}
			},
			FrameRate = 10
		}
	},
	Type = TYPE_GESTURE
})

RegisterLuaAnimation('roll_left', {
	FrameData = {
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine2'] = {
				},
				['ValveBiped.Bip01_Pelvis'] = {
				}
			},
			FrameRate = 10
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine2'] = {
					RU = 78.955341028598
				},
				['ValveBiped.Bip01_Pelvis'] = {
					RU = -54.162392153687
				}
			},
			FrameRate = 10
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine2'] = {
					RU = 78.955341028598
				},
				['ValveBiped.Bip01_Pelvis'] = {
					MU = -1.430643773264,
					RU = -131.48823637521
				}
			},
			FrameRate = 10
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine2'] = {
					RU = 78.955341028598
				},
				['ValveBiped.Bip01_Pelvis'] = {
					MU = -5.3347083681082,
					RU = -192.75567192718
				}
			},
			FrameRate = 10
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine2'] = {
					RU = 78.955341028598
				},
				['ValveBiped.Bip01_Pelvis'] = {
					MU = -7.950579786573,
					RU = -235.48087148308
				}
			},
			FrameRate = 10
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine2'] = {
					RU = 78.955341028598
				},
				['ValveBiped.Bip01_Pelvis'] = {
					MU = -7.950579786573,
					RU = -297.04672252115
				}
			},
			FrameRate = 10
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine2'] = {
					RU = 78.955341028598
				},
				['ValveBiped.Bip01_Pelvis'] = {
					MU = -4.2442135559418,
					RU = -329.24175943415
				}
			},
			FrameRate = 10
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine2'] = {
					RU = 35.560587500262
				},
				['ValveBiped.Bip01_Pelvis'] = {
					RU = -360
				}
			},
			FrameRate = 10
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine2'] = {
				},
				['ValveBiped.Bip01_Pelvis'] = {
					RU = -360
				}
			},
			FrameRate = 10
		}
	},
	Type = TYPE_GESTURE
})

RegisterLuaAnimation('roll_right', {
	FrameData = {
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine2'] = {
				},
				['ValveBiped.Bip01_Pelvis'] = {
				}
			},
			FrameRate = 10
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine2'] = {
					RU = 78.955341028598
				},
				['ValveBiped.Bip01_Pelvis'] = {
					RU = 54.162392153687
				}
			},
			FrameRate = 10
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine2'] = {
					RU = 78.955341028598
				},
				['ValveBiped.Bip01_Pelvis'] = {
					MU = -1.430643773264,
					RU = 131.48823637521
				}
			},
			FrameRate = 10
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine2'] = {
					RU = 78.955341028598
				},
				['ValveBiped.Bip01_Pelvis'] = {
					MU = -5.3347083681082,
					RU = 192.75567192718
				}
			},
			FrameRate = 10
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine2'] = {
					RU = 78.955341028598
				},
				['ValveBiped.Bip01_Pelvis'] = {
					MU = -7.950579786573,
					RU = 235.48087148308
				}
			},
			FrameRate = 10
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine2'] = {
					RU = 78.955341028598
				},
				['ValveBiped.Bip01_Pelvis'] = {
					MU = -7.950579786573,
					RU = 297.04672252115
				}
			},
			FrameRate = 10
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine2'] = {
					RU = 78.955341028598
				},
				['ValveBiped.Bip01_Pelvis'] = {
					MU = -4.2442135559418,
					RU = 329.24175943415
				}
			},
			FrameRate = 10
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine2'] = {
					RU = 35.560587500262
				},
				['ValveBiped.Bip01_Pelvis'] = {
					RU = 360
				}
			},
			FrameRate = 10
		},
		{
			BoneInfo = {
				['ValveBiped.Bip01_Spine2'] = {
				},
				['ValveBiped.Bip01_Pelvis'] = {
					RU = 360
				}
			},
			FrameRate = 10
		}
	},
	Type = TYPE_GESTURE
})

/* EXAMPLES!

-- If your animation is only used on one model, use numbers instead of bone names (cache the lookup).
-- If it's being used on a wide array of models (including default player models) then you should use bone names.
-- You can use Callback as a function instead of MU, RR, etc. which will allow you to do some interesting things.
-- See cl_boneanimlib.lua for the full format.

STANCE: stancetest
A simple looping stance that stretches the model's spine up and down until stopped.

RegisterLuaAnimation("stancetest", {
	FrameData = {
		{
			BoneInfo = {
				["ValveBiped.Bip01_Spine"] = {
					MU = 64
				}
			},
			FrameRate = 0.25
		},
		{
			BoneInfo = {
				["ValveBiped.Bip01_Spine"] = {
					MU = -32
				}
			},
			FrameRate = 1.5
		},
		{
			BoneInfo = {
				["ValveBiped.Bip01_Spine"] = {
					MU = 32
				}
			},
			FrameRate = 4
		}
	},
	RestartFrame = 2,
	Type = TYPE_STANCE
})

--[[
STANCE: staffholdspell
To be used with the ACT_HL2MP_IDLE_MELEE2 animation.
Player holds the staff so that their left hand is over the top of it.
]]

RegisterLuaAnimation("staffholdspell", {
	FrameData = {
		{
			BoneInfo = {
				["ValveBiped.Bip01_R_Forearm"] = {
					RU = 40,
					RF = -40
				},
				["ValveBiped.Bip01_R_Upperarm"] = {
					RU = 40
				},
				["ValveBiped.Bip01_R_Hand"] = {
					RU = -40
				},
				["ValveBiped.Bip01_L_Forearm"] = {
					RU = 40
				},
				["ValveBiped.Bip01_L_Hand"] = {
					RU = -40
				}
			},
			FrameRate = 6
		},
		{
			BoneInfo = {
				["ValveBiped.Bip01_R_Forearm"] = {
					RU = 2,
				},
				["ValveBiped.Bip01_R_Upperarm"] = {
					RU = 1
				},
				["ValveBiped.Bip01_R_Hand"] = {
					RU = -10
				},
				["ValveBiped.Bip01_L_Forearm"] = {
					RU = 8
				},
				["ValveBiped.Bip01_L_Hand"] = {
					RU = -12
				}
			},
			FrameRate = 0.4
		},
		{
			BoneInfo = {
				["ValveBiped.Bip01_R_Forearm"] = {
					RU = -2,
				},
				["ValveBiped.Bip01_R_Upperarm"] = {
					RU = -1
				},
				["ValveBiped.Bip01_R_Hand"] = {
					RU = 10
				},
				["ValveBiped.Bip01_L_Forearm"] = {
					RU = -8
				},
				["ValveBiped.Bip01_L_Hand"] = {
					RU = 12
				}
			},
			FrameRate = 0.1
		}
	},
	RestartFrame = 2,
	Type = TYPE_STANCE,
	ShouldPlay = function(pl, sGestureName, tGestureTable, iCurFrame, tFrameData)
		local wepstatus = pl.WeaponStatus
		return wepstatus and wepstatus:IsValid() and wepstatus:GetSkin() == 1 and wepstatus.IsStaff
	end
})

*/
