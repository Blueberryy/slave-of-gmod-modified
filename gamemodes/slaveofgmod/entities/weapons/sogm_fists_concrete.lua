AddCSLuaFile()

SWEP.Base 				= "sogm_melee_base" 

SWEP.WorldModel			= Model ( "models/props_junk/Shoe001a.mdl"  ) 
SWEP.HoldType			= "fist"
SWEP.DamageType 		= DMG_CLUB
SWEP.BloodMultiplier 	= 1
SWEP.HitsToExecute 		= 3

SWEP.AutoSwitchTo		= true

SWEP.Primary.Delay		= 0.4
SWEP.ExecutionDelay	 	= 0.33
SWEP.ExecutionPoints	= PTS_EXECUTION_BARE
SWEP.ExecutionSequence 	= "cidle_melee"
SWEP.ExecutionGesture 	= ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
SWEP.Hidden				= true
SWEP.KillPoints 		= PTS_BARE_KILL
SWEP.OverrideForce 		= 1900

function SWEP:SecondaryAttack()
	if CLIENT then return end
	if self.Owner:GetCharTable().OverrideSecondaryAttack then
		return self.Owner:GetCharTable():OverrideSecondaryAttack( self.Owner, self )
	end
end

for i=1,4 do 
	util.PrecacheSound("physics/concrete/boulder_impact_hard"..i..".wav")
end

function SWEP:PlayHitFleshSound()
	//self:EmitSound( "physics/body/body_medium_break"..math.random(2, 3)..".wav", 85, 100 )
	sound.Play( "physics/body/body_medium_break"..math.random(2, 3)..".wav", self:GetPos(), 85, 100, 1 )
	self:EmitSound( "physics/concrete/boulder_impact_hard"..math.random(4)..".wav", 100, math.random(85,110) )	
end 

function SWEP:PlaySwingSound()
	self.Owner:EmitSound("npc/zombie/claw_miss1.wav", 45, math.Rand(75, 80))
end 

/*function SWEP:OverrideAttackAnimation()
	self.Owner:SetLuaAnimation(self:GetDTBool( 0 ) and "fist_right" or "fist_left")
	self:SetDTBool( 0 , !self:GetDTBool( 0 ) )
end*/

function SWEP:OnKill( ply, attacker )
	ply.ToDismember = true
end

SWEP.WElements = {
	["left_finger1"] = { type = "Model", model = "models/props_wasteland/rockcliff01e.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.271, 0.639, -0.299), angle = Angle(-1.102, -89.46, -5.299), size = Vector(0.02, 0.02, 0.02), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["left_finger3++++"] = { type = "Model", model = "models/props_wasteland/rockcliff06d.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(3.796, 2.197, 1.207), angle = Angle(-86.522, 22.559, -1.078), size = Vector(0.014, 0.014, 0.014), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["left_spike1++"] = { type = "Model", model = "models/props_wasteland/rockcliff01k.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.157, 1.343, -1.221), angle = Angle(-83.923, -101.753, -90.575), size = Vector(0.039, 0.039, 0.039), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["left_finger2+"] = { type = "Model", model = "models/props_wasteland/rockcliff01g.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.155, 0.521, 2.069), angle = Angle(-13.535, 82.124, -89.393), size = Vector(0.019, 0.019, 0.019), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["left_finger3+"] = { type = "Model", model = "models/props_wasteland/rockcliff06d.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.466, 2.25, -0.562), angle = Angle(-93.093, 10.317, 0), size = Vector(0.014, 0.014, 0.014), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["left_finger1++"] = { type = "Model", model = "models/props_wasteland/rockcliff01e.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(4.271, 0.34, -0.15), angle = Angle(-180, -81.687, 9.376), size = Vector(0.02, 0.02, 0.02), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["left1"] = { type = "Model", model = "models/props_wasteland/rockcliff01f.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.033, 0.416, -0.459), angle = Angle(-96.503, -99.243, -93.112), size = Vector(0.037, 0.037, 0.037), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["left_finger3++"] = { type = "Model", model = "models/props_wasteland/rockcliff06d.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.466, 2.25, 0.345), angle = Angle(-86.569, 10.317, 0), size = Vector(0.014, 0.014, 0.014), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["left_finger3+++++++"] = { type = "Model", model = "models/props_wasteland/rockcliff06d.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(3.644, 1.868, -1.841), angle = Angle(-93.14, 22.856, 0.578), size = Vector(0.009, 0.009, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["left_spike1+++++"] = { type = "Model", model = "models/props_wasteland/rockcliff01k.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(5.309, 1.814, -0.9), angle = Angle(-44.527, -101.543, -86.842), size = Vector(0.039, 0.039, 0.039), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["left_finger2"] = { type = "Model", model = "models/props_wasteland/rockcliff01g.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.506, 1.164, -2.737), angle = Angle(172.843, 65.058, -90.52), size = Vector(0.019, 0.019, 0.019), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["left_finger3+++++"] = { type = "Model", model = "models/props_wasteland/rockcliff06d.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(3.944, 2.171, 0.162), angle = Angle(-83.32, 24.937, -1.078), size = Vector(0.014, 0.014, 0.014), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["left_spike1++++"] = { type = "Model", model = "models/props_wasteland/rockcliff01k.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(5.611, 1.345, 0.136), angle = Angle(-60.384, -101.543, -86.842), size = Vector(0.039, 0.039, 0.039), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["left_spike1+"] = { type = "Model", model = "models/props_wasteland/rockcliff01k.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.012, 1.343, -0.322), angle = Angle(-93.375, -104.714, -90.575), size = Vector(0.039, 0.039, 0.039), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["left_finger1+"] = { type = "Model", model = "models/props_wasteland/rockcliff01e.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.271, 1.541, -0.304), angle = Angle(-1.102, -89.46, -5.299), size = Vector(0.02, 0.02, 0.02), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["left1+"] = { type = "Model", model = "models/props_wasteland/rockcliff01f.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(1.883, 0.566, -0.459), angle = Angle(-73.442, -92.738, -91.398), size = Vector(0.037, 0.037, 0.037), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["left_spike1"] = { type = "Model", model = "models/props_wasteland/rockcliff01k.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.012, 1.493, 0.583), angle = Angle(-93.375, -106.178, -90.575), size = Vector(0.039, 0.039, 0.039), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["left_spike1+++"] = { type = "Model", model = "models/props_wasteland/rockcliff01k.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(5.611, 1.195, 1.335), angle = Angle(-69.584, -104.649, -90.575), size = Vector(0.039, 0.039, 0.039), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["left_finger3"] = { type = "Model", model = "models/props_wasteland/rockcliff06d.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.168, 2.25, -1.481), angle = Angle(-90.389, 10.317, 0), size = Vector(0.014, 0.014, 0.014), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["left_finger3++++++"] = { type = "Model", model = "models/props_wasteland/rockcliff06d.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(3.644, 2.022, -0.893), angle = Angle(-87.411, 22.954, -0.176), size = Vector(0.014, 0.014, 0.014), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["left_finger3+++"] = { type = "Model", model = "models/props_wasteland/rockcliff06d.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.769, 2.253, 1.284), angle = Angle(-79.13, 10.317, 0), size = Vector(0.009, 0.009, 0.009), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["left_finger1+++"] = { type = "Model", model = "models/props_wasteland/rockcliff01e.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(4.271, 1.09, -0.15), angle = Angle(-180, -81.687, 9.376), size = Vector(0.02, 0.02, 0.02), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

for k, v in pairs( SWEP.WElements ) do
	if v and v.size then
		v.size = v.size * 2
	end
end