CHARACTER.Reference = "james"

CHARACTER.Name = "James"
CHARACTER.Description = ""

CHARACTER.Health = 100
CHARACTER.Speed = 380

//CHARACTER.StartingWeapon = "sogm_james_bladegun"
CHARACTER.GametypeSpecific = "singleplayer"

CHARACTER.Icon = Material( "sog/james.png", "smooth" )

CHARACTER.CantExecute = true

CHARACTER.Model = Model( "models/player/group03/male_03.mdl" )

if BADASS_MODE then
	CHARACTER.CantExecute = false
	if SCENE and SCENE.Name == "return end" then
		CHARACTER.StartingWeapon = "sogm_m4_cursed"
	end
else
	CHARACTER.StartingWeapon = "sogm_james_bladegun"
end

local function ZERO_SCALING( ent, bonecount, exception_table )//, bone_table, scaledown_table )
	
	if not exception_table then return end
	
	local pl = ent:GetParent()
	
	if pl and pl:IsValid() then
				
		for i=0, bonecount do
			
			local name = ent:GetBoneName( i )
			
			if not name then continue end
			
			if exception_table[ name ] then
			
				local v = exception_table[ name ]
		
				local bone = i
				
				if bone then
				
					if not ent.HideTo then
						ent.HideTo = i
					end
				
					local m = ent:GetBoneMatrix( bone )
					
					if m then
						
						if v.add then
							m:Translate( v.add )
						end
						if v.rot then
							m:Rotate( v.rot )
						end
						if v.sc then
							m:SetScale( v.sc )
						end
						
						ent:SetBoneMatrix( bone, m )
						
					end
					
				end
			else
				local m = ent:GetBoneMatrix( i )
				if m then
					if ent.HideTo then
						local m_p = ent:GetBoneMatrix( ent.HideTo )
						if m_p then
							m:SetTranslation( m_p:GetTranslation() )
						end
					end
					m:SetScale( vector_origin )
					ent:SetBoneMatrix( i, m )
				end
			end
			
		end
				
	end

end


local arm1_table = {
	["Bone01_T"] = {},
	["Bone02_T"] = {},
	["Bone03_T"] = {},
}

local arm2_table = {
	["Bone04_T"] = { sc = Vector( 1.3, 1, 1.5 )},
	["Bone05_T"] = { add = Vector( 0, -4.2, 0 )},
}

local arm3_table = {
	["Bone03_T"] = { sc = Vector( 0.6, 1, 0.8 ), add = Vector( 0, 2, 0 )},
	["Bone04_T"] = { sc = Vector( 0.7, 1, 0.8 ) },
}

if CLIENT then
CreateMaterial( "james_arm", "VertexLitGeneric", 
{
	["$basetexture"] = "models/shield_scanner/minelayer_sheet", 
	["$model"] = 1, 
	["$selfillum"] = 1, 
	["$selfillummask"] = "models/shield_scanner/minelayer_sheet", 
	["$selfillumtint"] = "[3 2 2]" 
} )

CreateMaterial( "james_arm_1", "VertexLitGeneric", 
{
	["$basetexture"] = "models/weapons/c_arms_combine/c_arms_combinesoldier", 
	["$bumpmap"] = "models/weapons/c_arms_combine/c_arms_combinesoldier_normal", 
	["$model"] = 1, 
	["$selfillum"] = 1, 
	["$selfillummask"] = "models/weapons/c_arms_combine/c_arms_combinesoldier", 
	["$selfillumtint"] = "[2 2 2]" 
} )

CreateMaterial( "james_arm_2", "VertexLitGeneric", 
{
	["$basetexture"] = "models/weapons/c_arms_combine/c_arms_combinesoldier_hands", 
	["$bumpmap"] = "models/weapons/c_arms_combine/c_arms_combinesoldier_hands_normal", 
	["$model"] = 1, 
	["$selfillum"] = 1, 
	["$selfillummask"] = "models/weapons/c_arms_combine/c_arms_combinesoldier_hands", 
	["$selfillumtint"] = "[2 2 2]" 
} )

end

local arm_table = {}
local did_arm_table = false

local check_bones = {
	"ValveBiped.Bip01_R_Clavicle",
	"ValveBiped.Bip01_R_UpperArm",
	"ValveBiped.Bip01_R_Forearm",
	"ValveBiped.Bip01_R_Hand",
	"ValveBiped.Bip01_R_Finger4",
	"ValveBiped.Bip01_R_Finger41",
	"ValveBiped.Bip01_R_Finger42",
	"ValveBiped.Bip01_R_Finger3",
	"ValveBiped.Bip01_R_Finger31",
	"ValveBiped.Bip01_R_Finger32",
	"ValveBiped.Bip01_R_Finger2",
	"ValveBiped.Bip01_R_Finger21",
	"ValveBiped.Bip01_R_Finger22",
	"ValveBiped.Bip01_R_Finger1",
	"ValveBiped.Bip01_R_Finger11",
	"ValveBiped.Bip01_R_Finger12",
	"ValveBiped.Bip01_R_Finger0",
	"ValveBiped.Bip01_R_Finger01",
	"ValveBiped.Bip01_R_Finger02",
	"ValveBiped.Anim_Attachment_RH",
	"ValveBiped.Bip01_R_Ulna",
	"ValveBiped.Bip01_R_Wrist"
}

local arm_scale = Vector( 1, 1.1, 1.1 )
local arm_rotate = Angle( 0, 0, 180 )
local function body_bbp( ent, bonecount )
	
	local pl = ent:GetParent()
	
	if pl.GetRagdollEntity and IsValid( pl:GetRagdollEntity() ) then
		pl = pl:GetRagdollEntity()
	end
	
	//if not ent.HideTo then
		//local bone = pl:LookupBone( "ValveBiped.Bip01_R_Clavicle" )
		//if bone then
			//ent.HideTo = bone//pl:GetBoneMatrix( bone )
		//end
	//end
	
	ent:SetLOD( 0 )
	
	if not did_arm_table then
		
		for k, v in pairs( check_bones ) do
			local pl_bone = pl:LookupBone( v )
			local ent_bone = ent:LookupBone( v )
			
			if pl_bone and ent_bone then
				arm_table[ ent_bone ] = pl_bone
				
				/*for _, child in pairs( ent:GetChildBones( ent_bone ) ) do
					local child_name = ent:GetBoneName( child )
					
					local pl_child_bone = pl:LookupBone( child_name )
					
					if pl_child_bone then
						arm_table[ child ] = pl_child_bone
					end
					
				end*/
				
			end
			
		end
		
		//arm_table[ 20 ] = 53
		arm_table[ 24 ] = 11
		arm_table[ 25 ] = 11
		arm_table[ 26 ] = 11
		arm_table[ 27 ] = 11
		arm_table[ 28 ] = 11
		arm_table[ 29 ] = 11
		
		did_arm_table = true
	end
	
	ent.HideTo = pl:GetBoneMatrix( 8 )
	
	for i=0, bonecount - 1 do
		
		local m_ent = ent:GetBoneMatrix( i )
		
		//print( i.."   "..tostring(m_ent).." --- "..tostring( ent:GetBoneName( i ) ) )
		
		if arm_table[ i ] then
			
			local m_pl = pl:GetBoneMatrix( arm_table[ i ] )
			//local pos, ang = pl:GetBonePosition( arm_table[ i ] )
			
			if m_ent and m_pl then//pos and ang then
				m_ent:SetTranslation( m_pl:GetTranslation() )
				m_ent:SetAngles( m_pl:GetAngles() )
				//if i == 19 or i == 20 then
				//	m_ent:Rotate( arm_rotate )
				//end
				m_ent:SetScale( arm_scale )
				ent:SetBoneMatrix( i, m_ent )
			end
			
		else
			if ent.HideTo and m_ent then
				m_ent:SetTranslation( ent.HideTo:GetTranslation() )
				m_ent:SetAngles( ent.HideTo:GetAngles() )
				m_ent:SetScale( vector_origin )
				ent:SetBoneMatrix( i, m_ent )
			end
		end
		
	end
	
	
end


CHARACTER.WElements = {
	["cigar"] = { type = "Model", model = "models/props_debris/concrete_column001a_core.mdl", bone = "ValveBiped.Bip01_Head1", rel = "", pos = Vector(0.509, 4.626, 0.266), angle = Angle(-7.112, -2.77, -113.541), size = Vector(0.024, 0.024, 0.024), color = Color(113, 70, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["cigar_tip"] = { type = "Model", model = "models/props_junk/popcan01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "cigar", pos = Vector(0, 0, -2.78), angle = Angle(116.575, 71.517, 90), size = Vector(0.108, 0.108, 0.108), color = Color(255, 255, 255, 0), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	--["arm1"] = { type = "Model", model = "models/shield_scanner.mdl", bone = "ValveBiped.Bip01_R_UpperArm", rel = "", pos = Vector(-6.104, -2.478, -1.03), angle = Angle(0, -67.043, 90), size = Vector(1.06, 1.06, 1.06), color = Color(255, 255, 255, 255), surpresslightning = false, material = "!james_arm", skin = 0, bodygroup = {}, bbp = function( ent, bc ) ZERO_SCALING(ent, bc, arm1_table) end, fix_scale = true },
	--["arm2"] = { type = "Model", model = "models/shield_scanner.mdl", bone = "ValveBiped.Bip01_R_Forearm", rel = "", pos = Vector(-18.775, -11.853, -4.717), angle = Angle(-4.261, -96.296, 102.192), size = Vector(1.208, 1.208, 1.208), color = Color(255, 255, 255, 255), surpresslightning = false, material = "!james_arm", skin = 0, bodygroup = {}, bbp = function( ent, bc ) ZERO_SCALING(ent, bc, arm2_table) end, fix_scale = true },
	--["arm3"] = { type = "Model", model = "models/shield_scanner.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(13.329, -0.346, -13.436), angle = Angle(107.945, 178.121, -1.614), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "!james_arm", skin = 0, bodygroup = {}, bbp = function( ent, bc ) ZERO_SCALING(ent, bc, arm3_table) end, fix_scale = true },
	--["body"] = { type = "Model", model = "models/player/group03/male_03.mdl", bone = "ValveBiped.Bip01_Pelvis", rel = "", pos = Vector(0, 37.819, 0), angle = Angle(90, -90, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, fix_scale = true, bonemerge = true }
	["body"] = { type = "Model", model = "models/weapons/c_arms_combine.mdl", bone = "ValveBiped.Bip01_Pelvis", rel = "", pos = Vector(0, 37.819, 0), angle = Angle(90, -90, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, bbp = function( ent, bc ) body_bbp( ent, bc ) end, sub_mat2 = { [0] = "!james_arm_1", [1] = "!james_arm_2" } }
}


function CHARACTER:PostSpawn( pl )

	if SCENE and SCENE.Name == "flashbacks" and CUR_STAGE == 1 then
		local override = pl:AddOverrideAnimation( pl:LookupSequence( "run_all_protected" ) )
		override:SetOverrideSpeed( 160 )
		
		local k = pl:DoKnockdown( 5, true, pl )
		k:SetRecoveryTime( 3.2 )
	end
	
	if SCENE and SCENE.Name == "return end" then
		if CUR_STAGE == 1 then
			local override = pl:AddOverrideAnimation( pl:LookupSequence( "run_passive" ) )
			override:SetOverrideSpeed( 120 )
			override.RemoveOnStage = 2 //remove when stage 2 kicks in

			local k = pl:DoKnockdown( 5, true, pl )
			k:SetRecoveryTime( 3.2 )
			
			pl:SetAngles( Angle( 0, 90, 0 ) )
		end
		if DEATH_TOKEN and DEATH_TOKEN:IsValid() then
			pl:AddArrow( DEATH_TOKEN, nil, true, true )
		end
	end
	
	if SCENE and SCENE.Name == "this is fine" then
		pl:SetGoal( "Hold [RMB] for melee stance. Dropped guns will refill your ammunition", 25 )
	end

end

if SCENE and SCENE.Name == "return end" then
	function CHARACTER:OverrideDeathEffects( pl, attacker, dmginfo )
		
		if CUR_STAGE == 2 then
			if DEATH_TOKEN and DEATH_TOKEN:IsValid() then
				DEATH_TOKEN:SetPos( pl:GetPos() )
				DEATH_TOKEN:SetAngles( pl:GetAngles() )
				DEATH_TOKEN:SetDieTime( CurTime() )
			else
				local e = ents.Create( "ent_death_token" )
				e:SetPos( pl:GetPos() )
				e:SetAngles( pl:GetAngles() )
				e:Spawn()
				e:SetDieTime( CurTime() )
				e:Activate()
				
				DEATH_TOKEN = e
			end
		end
		
		
	end
end


function CHARACTER:OnWeaponTouch( pl, wep )
	
	local w = pl:GetActiveWeapon()
	
	if w and IsValid(w) and w:GetClass() == "sogm_james_bladegun" and w:Clip1() < w.Primary.ClipSize and wep:GetType() == "ranged" and wep.StoredClip and wep.StoredClip > 0 then
	
		local desired = math.floor( w.Primary.ClipSize )
		local actual = math.Clamp( w:Clip1() + desired, 0, w.Primary.ClipSize )
	
		pl:EmitSound( "items/itempickup.wav" )
		//pl:GiveAmmo( w.Primary.ClipSize, w.Primary.Ammo, false )
		w:SetClip1( actual )
		wep:Remove()
		
		return true
	end
end

function CHARACTER:PostPlayerDraw( pl )
	
	if pl.WElements and pl.WElements["cigar_tip"] and pl.WElements["cigar_tip"].modelEnt then
		
		
		local tip = pl.WElements["cigar_tip"].modelEnt
		
		if GAMEMODE:GetFirstPerson() then
			pl.WElements["cigar_tip"].color.a = 0
			pl.WElements["cigar"].color.a = 0
			return
		end
			
		pl.NextSmoke = pl.NextSmoke or 0
			
		if pl.NextSmoke < CurTime() and !IsValid( pl.Knockdown )then
			local emitter = ParticleEmitter( pl:GetPos() )
					
			for i=1, 12 do
					
				local particle = emitter:Add( "particles/smokey", tip:GetPos() )
					particle:SetVelocity( math.Rand(6, 30.7) * tip:GetForward() * -1 + VectorRand() * 2 + vector_up * math.random( 10 ) )
					particle:SetDieTime( math.Rand(0.5, 4) )
					particle:SetStartAlpha( 100 )
					particle:SetEndAlpha(0)
					particle:SetStartSize( math.random(2,4) )
					particle:SetEndSize( math.random(13,20) )
					particle:SetRoll( math.Rand(-180, 180) )
					particle:SetColor( 240, 240, 240 )
					particle:SetAirResistance( 15 )
						
			end
						
			pl.NextSmoke = CurTime() + math.Rand( 5, 8 )
				
			emitter:Finish() emitter = nil collectgarbage("step", 64)
		end
			
		pl.NextPuff = pl.NextPuff or 0
			
		if pl.NextPuff < CurTime() then
			local emitter = ParticleEmitter( pl:GetPos() )
					
					//for i=1, 12 do
					
			local particle = emitter:Add( "particles/smokey", tip:GetPos() )
				particle:SetVelocity( math.Rand(2, 5) * tip:GetForward() * -1 + VectorRand() * 1 + vector_up * ( math.random( 10 ) + 30 ) ) 
				particle:SetDieTime( math.Rand(0.2, 0.5) )
				particle:SetStartAlpha( 100 )
				particle:SetEndAlpha(0)
				particle:SetStartSize( 1 )
				particle:SetEndSize( math.Rand(2,3) )
				particle:SetRoll( math.Rand(-180, 180) )
				particle:SetColor( 240, 240, 240 )
				particle:SetAirResistance( 15 )
						
					//end
						
			pl.NextPuff = CurTime() + math.Rand( 0.02, 0.06 )
				
			emitter:Finish() emitter = nil collectgarbage("step", 64)
		end
			
			
	end
	
end