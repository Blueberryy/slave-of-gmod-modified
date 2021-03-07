CHARACTER.Reference = "horse abomination"

CHARACTER.Name = "Horse Abomination"
CHARACTER.Description = ""

CHARACTER.Health = 99999
CHARACTER.Speed = 100
CHARACTER.KnockdownImmunity = true
CHARACTER.NoPickups = true
CHARACTER.YellowBlood = true

CHARACTER.NoMenu = true
CHARACTER.DontAttack = true

CHARACTER.Horse = true
//CHARACTER.YellowBlood = true

CHARACTER.StartingWeapon = "sogm_fists_thug"

CHARACTER.Model = Model( "models/headcrabblack.mdl" )

CHARACTER.WElements = {
	["crab2+++"] = { type = "Model", model = "models/headcrab.mdl", bone = "HCblack.body", rel = "", pos = Vector(14.5, -87.832, 43.262), angle = Angle(-0.352, 70.778, -90.824), size = Vector(1.365, 1.365, 1.365), color = Color(228, 31, 229, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {}, seq = "Idle01", seq_pb = 0.2 },
	["crab2"] = { type = "Model", model = "models/headcrab.mdl", bone = "HCblack.body", rel = "", pos = Vector(20.11, -43.281, 0), angle = Angle(-5.593, 85.455, -38.183), size = Vector(2.865, 2.865, 2.865), color = Color(228, 31, 229, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {}, seq = "Idle01", seq_pb = 0.2 },
	["crab"] = { type = "Model", model = "models/headcrabclassic.mdl", bone = "HCblack.body", rel = "", pos = Vector(0.379, -42.43, 0), angle = Angle(4.48, 77.115, -94.177), size = Vector(3.756, 3.756, 3.756), color = Color(228, 31, 229, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {}, seq = "Idle01", seq_pb = 0.5 },
	["statue"] = { type = "Model", model = "models/props_c17/statue_horse.mdl", bone = "HCblack.body", rel = "", pos = Vector(14.904, 14.277, -47.089), angle = Angle(-50.382, 90, 0), size = Vector(0.876, 0.876, 0.876), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["crab+++"] = { type = "Model", model = "models/headcrabclassic.mdl", bone = "HCblack.body", rel = "", pos = Vector(-1.675, -44.019, -36.264), angle = Angle(-4.913, 86.713, -133.305), size = Vector(2.453, 2.453, 2.453), color = Color(228, 31, 229, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {}, seq = "Idle01", seq_pb = 0.5 },
	["crab++"] = { type = "Model", model = "models/headcrabclassic.mdl", bone = "HCblack.body", rel = "", pos = Vector(11.616, -42.916, -36.264), angle = Angle(-5.768, 88.138, 131.813), size = Vector(2.894, 2.894, 2.894), color = Color(228, 31, 229, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {}, seq = "Idle01", seq_pb = 0.5 },
	["crab+"] = { type = "Model", model = "models/headcrabclassic.mdl", bone = "HCblack.body", rel = "", pos = Vector(18.822, -46.626, 0), angle = Angle(4.304, 92.865, 82.347), size = Vector(3.756, 3.756, 3.756), color = Color(228, 31, 229, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {}, seq = "Idle01", seq_pb = 0.2 },
	["crab2++"] = { type = "Model", model = "models/headcrab.mdl", bone = "HCblack.body", rel = "", pos = Vector(-4.656, -38.283, 12.977), angle = Angle(83.907, 68.96, 180), size = Vector(2.818, 2.818, 2.818), color = Color(228, 31, 229, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {}, seq = "Idle01", seq_pb = 0.2 },
	["crab2+"] = { type = "Model", model = "models/headcrab.mdl", bone = "HCblack.body", rel = "", pos = Vector(8.56, -32.584, -17.701), angle = Angle(-16.923, 15.194, 4.774), size = Vector(3.092, 3.092, 3.092), color = Color(228, 31, 229, 255), surpresslightning = false, material = "models/flesh", skin = 0, bodygroup = {}, seq = "Idle01", seq_pb = 0.2 },
	["glow"] = { type = "Sprite", sprite = "effects/redflare", bone = "ValveBiped.Bip01_R_Hand", rel = "statue", pos = Vector(27.625, -34.964, 168.151), size = { x = 31.261, y = 31.261 }, color = Color(255, 255, 255, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
	["glow+"] = { type = "Sprite", sprite = "effects/redflare", bone = "ValveBiped.Bip01_R_Hand", rel = "statue", pos = Vector(23.305, -27.823, 180.981), size = { x = 31.261, y = 31.261 }, color = Color(255, 255, 255, 255), nocull = true, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false}
}

local scale_up = {
	"HCblack.leg_bone1_L",
	"HCblack.leg_bone2_L",
	"HCblack.leg_bone1_R",
	"HCblack.leg_bone2_R",
	
	"HCblack.arm_bone1_L",
	"HCblack.arm_bone2_L",
	"HCblack.arm_bone1_R",
	"HCblack.arm_bone2_R",
}

util.PrecacheModel( "models/headcrab.mdl" )
util.PrecacheModel( "models/headcrabclassic.mdl" )
util.PrecacheModel( "models/props_c17/statue_horse.mdl" )

function CHARACTER:OnSpawn( pl )
	

	pl:SetModelScale( 4, 0 )
	
	//pl:SetMaterial( "models/flesh" )
	pl:SetColor( Color(228, 31, 229, 255) )

	//pl.DebugPath = true
	
	for i=1, #scale_up do
		local bone = pl:LookupBone( scale_up[ i ] )
	
		if bone then
			pl:ManipulateBoneScale( bone, Vector( 1.1, 1,1, 1.1 ) )
		end
	end
	
	pl.SpotDistance = 0
	
end

function CHARACTER:OverrideBodyUpdate( pl )
	
	pl.NextSequence = pl.NextSequence or 0
	local next_seq = 0
	
	local velocity = pl.loco:GetVelocity()
	
	local eye_ang = pl:EyeAngles()
	
	pl:SetPlaybackRate( 1 )
	
	local len2d = velocity:Length2D()
	
	local seq = "Idle01"
	
	if len2d > 0.5 then
		seq = "walk_All"
	end
		
	local seq_id, seq_dur = pl:LookupSequence( seq )
		
	if pl.NextSequence < CurTime() then
		pl:ResetSequence( seq )
	end
		
end

function CHARACTER:OnThink( pl )
	
	pl:SetCollisionBounds( Vector( -1, -1, 0 ), Vector( 1, 1, 1 ) )
	
	if pl:GetBehaviour() == BEHAVIOUR_DUMB then return end
	
	pl.NextScreech = pl.NextScreech or 0
	
	pl.WalkSpeed = pl.NextSequence and pl.NextSequence > CurTime() and 0 or 100
	pl.IdleSpeed = pl.NextSequence and pl.NextSequence > CurTime() and 0 or 100
	
	if pl.NextScreech < CurTime() then
		
		if Entity(1):IsValid() and Entity(1):Alive() and Entity(1):GetPos():DistToSqr( pl:GetPos() ) < 90000 and pl:IsInView( Entity(1), 0.05 ) then
			
			pl:ResetSequenceInfo()
			pl:ResetSequence( "Threatdisplay" )
			pl:SetCycle( 0 )
			pl.NextSequence = CurTime() + 1.2
			
			pl:EmitSound( "npc/stalker/go_alert2a.wav", 75, math.random( 80, 90 ) )
			
			for tm, team_tbl in pairs( NEXTBOTS_TEAM ) do
				if tm == pl:Team() then
					for k, bot in pairs( team_tbl ) do
						if bot and bot:IsValid() and bot:Alive() and pl:GetShootPos():Distance( bot:GetShootPos() ) <= 650 and bot:GetBehaviour() ~= BEHAVIOUR_DUMB and !bot.Target then
							bot:StopAllPaths( 10 )
							bot.NextIdle = CurTime() + 3
							bot.NextBulletReact = CurTime() + 3
							bot.CheckPosition = Entity(1):GetShootPos()
						end
					end
				end
			end
			
			Entity(1):ShakeView( math.random(15,20), 0.8 )
			
			pl.NextScreech = CurTime() + 15
		end
	end
	
	
end

function CHARACTER:OnDraw( pl )
	pl:SetLOD( 0 )
end

function CHARACTER:OnMeleeHit( pl, hitpos, hitnormal, dir, attacker ) 
	
	local e = EffectData()
		e:SetOrigin( hitpos )
		e:SetNormal( hitnormal )
		e:SetScale( 2 )
	util.Effect( "StunstickImpact", e, nil, true )
		
	pl:EmitSound( "physics/metal/metal_box_impact_bullet"..math.random(3)..".wav" )
	pl:EmitSound( "weapons/stunstick/stunstick_impact"..math.random(2)..".wav" )
	
	return false

end

function CHARACTER:OnBulletHit( pl, hitpos, hitnormal, dir ) 

	local e = EffectData()
		e:SetOrigin( hitpos )
		e:SetNormal( hitnormal )
		e:SetScale( 2 )
	util.Effect( "StunstickImpact", e, nil, true )
		
	pl:EmitSound( "physics/metal/metal_box_impact_bullet"..math.random(3)..".wav" )
	pl:EmitSound( "weapons/stunstick/stunstick_impact"..math.random(2)..".wav" )
	
	return false
end




//scale 6
/*
SWEP.WElements = {
	["crab2+++"] = { type = "Model", model = "models/headcrab.mdl", bone = "HCblack.body", rel = "", pos = Vector(14.5, -87.832, 43.262), angle = Angle(-0.352, 70.778, -90.824), size = Vector(1.365, 1.365, 1.365), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["crab2"] = { type = "Model", model = "models/headcrab.mdl", bone = "HCblack.body", rel = "", pos = Vector(20.11, -43.281, 0), angle = Angle(-5.593, 85.455, -38.183), size = Vector(2.865, 2.865, 2.865), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["crab"] = { type = "Model", model = "models/headcrabclassic.mdl", bone = "HCblack.body", rel = "", pos = Vector(0.379, -42.43, 0), angle = Angle(4.48, 77.115, -94.177), size = Vector(3.756, 3.756, 3.756), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["statue"] = { type = "Model", model = "models/props_c17/statue_horse.mdl", bone = "HCblack.body", rel = "", pos = Vector(14.904, 14.277, -47.089), angle = Angle(-50.382, 90, 0), size = Vector(0.876, 0.876, 0.876), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["crab+++"] = { type = "Model", model = "models/headcrabclassic.mdl", bone = "HCblack.body", rel = "", pos = Vector(-1.675, -44.019, -36.264), angle = Angle(-4.913, 86.713, -133.305), size = Vector(2.453, 2.453, 2.453), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["crab++"] = { type = "Model", model = "models/headcrabclassic.mdl", bone = "HCblack.body", rel = "", pos = Vector(11.616, -42.916, -36.264), angle = Angle(-5.768, 88.138, 131.813), size = Vector(2.894, 2.894, 2.894), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["crab+"] = { type = "Model", model = "models/headcrabclassic.mdl", bone = "HCblack.body", rel = "", pos = Vector(18.822, -46.626, 0), angle = Angle(4.304, 92.865, 82.347), size = Vector(3.756, 3.756, 3.756), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["crab2++"] = { type = "Model", model = "models/headcrab.mdl", bone = "HCblack.body", rel = "", pos = Vector(-4.656, -38.283, 12.977), angle = Angle(83.907, 68.96, 180), size = Vector(2.818, 2.818, 2.818), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["crab2+"] = { type = "Model", model = "models/headcrab.mdl", bone = "HCblack.body", rel = "", pos = Vector(8.56, -32.584, -17.701), angle = Angle(-16.923, 15.194, 4.774), size = Vector(3.092, 3.092, 3.092), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}*/