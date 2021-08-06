//Uses LUA Animations API and couple other things, that I hopefully have not forgot to credit.

game.AddDecal( "BloodHuge1", "decals/bloodstain_001" )
game.AddDecal( "BloodHuge2", "decals/bloodstain_002" )
game.AddDecal( "BloodHuge3", "decals/bloodstain_003" )
game.AddDecal( "BloodHuge4", "decals/bloodstain_003b" )
game.AddDecal( "BloodHuge5", "decals/bloodstain_101" )
game.AddDecal( "BloodHuge6", "decals/bloodstain_201" )

game.AddDecal( "StainHuge1", "decals/decalstain003a" )
game.AddDecal( "StainHuge2", "decals/decalstain005a" )
game.AddDecal( "StainHuge3", "decals/decalstain006a" )
game.AddDecal( "StainHuge4", "decals/decalstain007a" )
game.AddDecal( "StainHuge5", "decals/decalstain008a" )
game.AddDecal( "StainHuge6", "decals/decalstain009a" )
game.AddDecal( "StainHuge7", "decals/decalstain010a" )

game.AddDecal( "BloodHugePurple1", "decals/purple_blood1")
game.AddDecal( "BloodHugePurple2", "decals/purple_blood2")
game.AddDecal( "BloodHugePurple3", "decals/purple_blood3")
game.AddDecal( "BloodHugePurple4", "decals/purple_blood4")

game.AddDecal( "BloodHugeBlack1", "decals/black_blood1")
game.AddDecal( "BloodHugeBlack2", "decals/black_blood2")
game.AddDecal( "BloodHugeBlack3", "decals/black_blood3")
game.AddDecal( "BloodHugeBlack4", "decals/black_blood4")



GM.Gametypes = GM.Gametypes or {}
GM.AvalaibleGametypes = GM.AvalaibleGametypes or {}

include("sh_translate.lua")

//i know it is kinda shitty way
function GM:AddAvalaibleGametype( key, n )
	self.AvalaibleGametypes[key] = { name = n, votes = 0}
end

GM:AddAvalaibleGametype( "none", "sog_gametype_name_rdm" )

ROUND_PLAY_TIME = 15*60//todo: use convars

MUSIC_TYPE_NORMAL = 1
MUSIC_TYPE_LEVEL_CLEAR = 2
MUSIC_TYPE_AMBIENT = 3

local a, b = file.Find(GM.FolderName.."/gamemode/gametypes/*.lua", "LUA")
for _, gm in ipairs( a ) do
	AddCSLuaFile("gametypes/"..gm)
	include("gametypes/"..gm)
end

if game.SinglePlayer() then
	AddCSLuaFile("singleplayer/singleplayer.lua")
	include("singleplayer/singleplayer.lua")
	
	AddCSLuaFile("singleplayer/editor.lua")
	include("singleplayer/editor.lua")
	
	AddCSLuaFile("singleplayer/scene_assets.lua")
	include("singleplayer/scene_assets.lua")
end

AKIMBO_MOVE = 0.3 //seconds
BLEEDOUT_TIME = 2

PTS_MELEE_KILL = 800
PTS_RANGED_KILL = 600
PTS_BARE_KILL = 700
PTS_EXECUTION_BARE = 1000
PTS_EXECUTION = 1200

COMBO_WINDOW = 3 //how much time allowed for combo
COMBO_PTS = 250 //points per each combo gained, gets increased with each one

TEAM_DM = 5

STORY = true

GM.Name 		= "Slave of GMod"
GM.Author 		= "Necrossin"
GM.Version		= "sog_gm_version" 

GM.Email 		= ""
GM.Website 		= ""

team.SetUp(TEAM_DM, "DEATHMATCH", Color(255,255,21,255))

GM.Achievements = {
	["envy"] = { Name = "sog_achievement_envy", Desc = "sog_achievement_envy_desc", DescClosed = "sog_achievement_envy_closed" },
	["wrath"] = { Name = "sog_achievement_wrath", Desc = "sog_achievement_wrath_desc", DescClosed = "sog_achievement_wrath_closed" },
	["pride"] = { Name = "sog_achievement_pride", Desc = "sog_achievement_pride_desc", DescClosed = "sog_achievement_pride_closed" },
	["greed"] = { Name = "sog_achievement_greed", Desc = "sog_achievement_greed_desc", DescClosed = "sog_achievement_greed_closed" },
	["lust"] = { Name = "sog_achievement_lust", Desc = "sog_achievement_lust_desc", DescClosed = "sog_achievement_lust_closed" },
	["gluttony"] = { Name = "sog_achievement_gluttony", Desc = "sog_achievement_gluttony_desc", DescClosed = "sog_achievement_gluttony_closed" },
	["sloth"] = { Name = "sog_achievement_sloth", Desc = "sog_achievement_sloth_desc", DescClosed = "sog_achievement_sloth_closed" },
	["sorry"] = { Name = "sog_achievement_sorry", Desc = "sog_achievement_sorry_desc", DescClosed = "sog_achievement_sorry_closed" },
	["safety"] = { Name = "sog_achievement_safety", Desc = "sog_achievement_safety_desc", DescClosed = "sog_achievement_safety_closed" },
	["sog"] = { Name = "sog_achievement_sog", Desc = "sog_achievement_sog_desc", DescClosed = "sog_achievement_sog_closed" },
	["20x"] = { Name = "sog_achievement_combo", Desc = "sog_achievement_combo_desc", DescClosed = "sog_achievement_combo_closed" },
	["comfy"] = { Name = "sog_achievement_comfy", Desc = "sog_achievement_comfy_desc", DescClosed = "sog_achievement_comfy_closed" },
	["shadycar"] = { Name = "sog_achievement_shadycar", Desc = "sog_achievement_shadycar_desc", DescClosed = "sog_achievement_shadycar_closed" },
	["bsm"] = { Name = "sog_achievement_bsm", Desc = "sog_achievement_bsm_desc", DescClosed = "sog_achievement_bsm_closed" },
	["cptedge"] = { Name = "sog_achievement_cptedge", Desc = "sog_achievement_cptedge_desc", DescClosed = "sog_achievement_cptedge_closed" },
	["protagonist"] = { Name = "sog_achievement_protagonist", Desc = "sog_achievement_protagonist_desc", DescClosed = "sog_achievement_protagonist_closed" },
	["remnant"] = { Name = "sog_achievement_remnant", Desc = "sog_achievement_remnant_desc", DescClosed = "sog_achievement_remnant_closed" },
}

GM.PlayerAchievements = {}

function GM:GetGameDescription()
	return self.Name
end

-- small code snippet made by rubat some time ago for slowing down sounds
function GM:EntityEmitSound( data ) 
	if game.GetTimeScale() != 1 then 
		data.Pitch = math.Clamp( data.Pitch * game.GetTimeScale(), data.Pitch * 0.5, 255 ) 
		return true 
	end
end

GM.TimeScaleApproach = 1
function GM:SetupMove( pl, mv, cmd ) 
	
	if game.SinglePlayer() and SERVER then
		if SUPERHOT then
			if pl == Entity(1) then
				if pl:Alive() and not IsValid( pl.Knockdown ) and not IsValid( pl.Execution ) and self:GetRoundState() ~= ROUNDSTATE_RESTARTING then
										
					if mv:KeyDown( IN_MOVELEFT ) or mv:KeyDown( IN_MOVERIGHT ) or mv:KeyDown( IN_FORWARD ) or mv:KeyDown( IN_BACK ) or mv:KeyDown( IN_ATTACK ) or mv:KeyDown( IN_ATTACK2 ) then
						local incr = 0.25
						if mv:KeyDown( IN_ATTACK ) or mv:KeyDown( IN_ATTACK2 ) then
							incr = 0.15
						end
						self.TimeScaleApproach = math.Approach( self.TimeScaleApproach, 1, incr )
					else
						self.TimeScaleApproach = math.Approach( self.TimeScaleApproach, 0.1, 0.15 )
					end

					if game.GetTimeScale() ~= self.TimeScaleApproach then
						game.SetTimeScale( self.TimeScaleApproach )
					end
				else
					if game.GetTimeScale() ~= 1 then
						game.SetTimeScale( 1 )
						self.TimeScaleApproach = 1
					end
				end
			end
		else
			if self.TimeScaleApproach ~= 1 then
				game.SetTimeScale( 1 )
				self.TimeScaleApproach = 1
			end
		end
	end
	
end

local normal_ang = Angle(0,0,0)
local flip_ang = Angle(0,180,0)
function GM:Move( pl,cmd )
	
	if self:GetFirstPerson() then
	else
		if pl:FlipView()then
			cmd:SetMoveAngles(normal_ang)
		else
			cmd:SetMoveAngles(flip_ang)
		end
	end
	
	if IsValid( pl.HostageEnt ) then
		cmd:SetMaxSpeed( pl:GetMaxSpeed() * .75 ) 
	end
	
	if IsValid( pl.Roll ) then		
		pl:SetGroundEntity(NULL)
		cmd:SetForwardSpeed(0)
		cmd:SetVelocity(cmd:GetVelocity() * (1 - FrameTime() * 0.4))
	end
	
	if IsValid( pl.AnimationOverride ) and pl.AnimationOverride:GetOverrideSpeed() and pl.AnimationOverride:GetOverrideSpeed() > 0 then
		cmd:SetMaxSpeed( pl.AnimationOverride:GetOverrideSpeed() )
	end
	
	local wep = IsValid(pl:GetActiveWeapon()) and pl:GetActiveWeapon()
	if wep and wep.Move then
		wep:Move( cmd )
	end
	
end

function GM:InitializeGametype()
	self.Gametype = "none"
end

function GM:GetGametype()
	return self.Gametype or "none"
end

function GM:ShouldCollide( ent1, ent2 )
	if ent1.IsPlayer and ent1:IsPlayer() and ent2.IsPlayer and ent2:IsPlayer() then
		return false
	end
	//if ent1.IsNextBot and ent1:IsNextBot() and ent2.IsPlayer and ent2:IsPlayer() then
		//return false
	//end
	//if ent1.IsPlayer and ent1:IsPlayer() and ent2.IsNextBot and ent2:IsNextBot() then
	//	return false
	//end
	if ent1.IsPlayer and ent1:IsPlayer() and ent2:GetClass() == "dropped_weapon" then
		return false
	end
	if ent2.IsPlayer and ent2:IsPlayer() and ent1:GetClass() == "dropped_weapon" then
		return false
	end

	if ent1.IsPlayer and ent1:IsPlayer() and ent2:GetClass() == "state_knockdown" then
		return false
	end
	if ent2.IsPlayer and ent2:IsPlayer() and ent1:GetClass() == "state_knockdown" then
		return false
	end
	//if ent1.IsNextBot and ent1:IsNextBot() and ent2.IsNextBot and ent2:IsNextBot() then
	//	return false
	//end
	
	//if ent2.IsNextBot and ent2:IsNextBot() and ent1.IsNextBot and ent1:IsNextBot() then
	//	return false
	//end
	
	return true
end

function GM:PlayerFootstep( pl, pos, foot, sound, volume, rf ) 
	return true
end

function GM:SetFirstPerson( bl )
	game.GetWorld():SetDTBool( 0, bl )
end

function GM:GetFirstPerson()
	// small hack to avoid errors on client
	if !game.SinglePlayer() then return false end

	return game.GetWorld():GetDTBool( 0 )
end

for name, modelpath in pairs( player_manager.AllValidModels() ) do
	util.PrecacheModel( modelpath )
end

for i=1,3 do
	local a,b = file.Find( "models/humans/group0"..i.."/*.mdl", "GAME" )
	
	for k, v in pairs( a ) do
		util.PrecacheModel( "models/humans/group0"..i.."/"..v )
	end
end

local a,b = file.Find( "models/humans/group03m/*.mdl", "GAME" )
	
for k, v in pairs( a ) do
	util.PrecacheModel( "models/humans/group03m/"..v )
end

for name, modelpath in pairs( player_manager.AllValidModels() ) do
	util.PrecacheModel( modelpath )
end

local Gibs = {
	Model( "models/Gibs/HGIBS.mdl" ),
	Model( "models/props_junk/watermelon01_chunk02a.mdl" ),
	Model( "models/props_junk/watermelon01_chunk02b.mdl" ),
	Model( "models/props_junk/watermelon01_chunk02c.mdl" ),
	Model( "models/Gibs/HGIBS_rib.mdl" ),
	Model( "models/Gibs/HGIBS_scapula.mdl" ),
	Model( "models/Gibs/HGIBS_spine.mdl" ),
	Model( "models/Gibs/Antlion_gib_medium_1.mdl" ),	
	Model( "models/Gibs/Shield_Scanner_Gib6.mdl" ),
}

util.PrecacheModel( "models/humans/charple03.mdl" )
util.PrecacheModel( "models/humans/charple02.mdl" )
util.PrecacheModel( "models/zombie/poison.mdl" )
util.PrecacheModel( "models/error.mdl")


function GM:GetCharacterIdByReference( ref )
	for k,v in pairs( self.Characters ) do
		if v and v.Reference and v.Reference == ref then
			return k
		end
	end
	return
end

function GM:GetCharacterReferenceById( id )
	for k,v in pairs( self.Characters ) do
		if k and k == id and v.Reference then
			return v.Reference
		end
	end
	return translate.Get("sog_menu_error")
end


//Random deathmatch should have only 6 characters
//"No!",  says the greedy server owner. "I can add more donate-only characters for cheap and dirty profit!"
//"No!", says the stupid kid. "I will just edit one value and re-upload whole gamemode, so it will be truly CUSTOM(tm)"
//"No!", says the 6-year old admin. "I will add overpowered character only for me, because I deserve it!"
function GM:AddAvalaibleCharacters()
	
	self.Characters = {}
	
	local a, b = file.Find(self.FolderName.."/gamemode/characters/*.lua", "LUA")
	for _, char in ipairs( a ) do
	
		AddCSLuaFile("characters/"..char)
		
		CHARACTER = {}
		
		include("characters/"..char)
			
		if !CHARACTER.Hidden then
			if CHARACTER.id then
				//basically if there is already a taken slot, switch to new one
				local id = CHARACTER.id
				if self.Characters[ CHARACTER.id ] then
					id = #self.Characters + 1//self:GetCharacterCount() + 1
				end
				self.Characters[ id ] = CHARACTER
				CHARACTER.id = id
			else
				local id = #self.Characters + 1//self:GetCharacterCount() + 1
				self.Characters[ id ] = CHARACTER
				CHARACTER.id = id
			end
		end

		CHARACTER = nil
	end
		
end

function GM:GetCharacterCount()
	
	local count = 0
	
	for _, char in pairs( self.Characters ) do
		count = count + 1
	end
	
	return count
	
end

GM:AddAvalaibleCharacters()

local rand = math.random
function table.Shuffle(t)
  local n = #t
 
  while n > 2 do

    local k = rand(n) 

    t[n], t[k] = t[k], t[n]
    n = n - 1
  end
 
  return t
end

function table.Resequence( oldtable )
	local newtable = table.Copy( oldtable )
	local id = 0
	
	table.Empty( oldtable )
	
	for k,v in pairs( newtable ) do
		id = id + 1
		oldtable[id] = newtable[k]
	end
end


function GM:HandlePlayerJumping( ply, velocity )
	return false
end

//todo: move this
local meta = FindMetaTable( "Player" )
if (!meta) then return end



local util = util
local table = table
local Vector = Vector



function GM:OnReloaded( ) 
	if self.Gametypes[self.Gametype] then
		self.Gametypes[self.Gametype](self)
	end
end

//meta.OldFrags = meta.Frags

//function meta:Frags()
	//return self:GetMaxScore()
//end

//meta.OldDeaths = meta.Deaths

//function meta:Deaths()
//	return self:GetScore()
//end

function meta:GetScore()
	return self:GetDTInt( 0 ) or 0
end

function meta:GetMaxScore()
	return self:GetDTInt( 1 ) or 0
end

function meta:FlipView()
	return self:GetDTBool( 0 )
end

function meta:GetBuddy()
	return self:GetDTEntity( 1 )
end

function meta:IsRolling()
	return IsValid( self.Roll )
end

if CLIENT then
	function meta:PlayGesture(name)
		self:AnimRestartGesture(GESTURE_SLOT_GRENADE, name, true)
	end

	net.Receive("PlayGesture", function(len)

		local ent = net.ReadEntity()
		local name = net.ReadInt( 32 )
				
		if IsValid(ent) then
			ent:PlayGesture( name )
		end
		
	end)
end

hook.Add("CalcMainActivity","SoG_Animations",function( pl, vel )
	
	local wep = pl:GetActiveWeapon()
	if IsValid( wep ) and wep.CalcMainActivity then
		return wep:CalcMainActivity( vel )
	end
	
end)

hook.Add("UpdateAnimation","SoG_UpdateAnimations",function( pl, velocity, maxseqgroundspeed )
	
	local wep = pl:GetActiveWeapon()
	if IsValid( wep ) and wep.UpdateAnimation then
		return wep:UpdateAnimation( velocity, maxseqgroundspeed )
	end

end)

//in case if I'll need to fuck with reload animations or worse (not literally)
hook.Add( "DoAnimationEvent", "SoG_DoAnimationEvent", function( pl, event, data )
	if event == PLAYERANIMEVENT_RELOAD and data == 111 then
			
		pl:AddVCDSequenceToGestureSlot( GESTURE_SLOT_ATTACK_AND_RELOAD, pl:LookupSequence( "range_fists_r" ), 0, true )
		pl:AddVCDSequenceToGestureSlot( GESTURE_SLOT_GRENADE, pl:LookupSequence( "range_fists_l" ), 0, true )
		
		pl:AnimSetGestureWeight( GESTURE_SLOT_ATTACK_AND_RELOAD, 1 )
		pl:AnimSetGestureWeight( GESTURE_SLOT_GRENADE, 1 )
		
		return ACT_INVALID
	end
	if event == PLAYERANIMEVENT_ATTACK_PRIMARY and data == 111 then
			
		pl:AddVCDSequenceToGestureSlot( GESTURE_SLOT_ATTACK_AND_RELOAD, pl:LookupSequence( "range_dual_r" ), 0, true )
		
		pl:AnimSetGestureWeight( GESTURE_SLOT_ATTACK_AND_RELOAD, 1 )
		
		return ACT_INVALID
	end
	if event == PLAYERANIMEVENT_ATTACK_SECONDARY and data == 111 then
			
		pl:AddVCDSequenceToGestureSlot( GESTURE_SLOT_ATTACK_AND_RELOAD, pl:LookupSequence( "range_dual_l" ), 0, true )
		
		pl:AnimSetGestureWeight( GESTURE_SLOT_ATTACK_AND_RELOAD, 1 )
		
		return ACT_INVALID
	end
	
	
end )

local meta = FindMetaTable( "Entity" )
if (!meta) then return end

if not meta.old_bonepos then
	meta.old_bonepos = meta.ManipulateBonePosition
end
if not meta.old_boneang then
	meta.old_boneang = meta.ManipulateBoneAngles
end
if not meta.old_bonescale then
	meta.old_bonescale = meta.ManipulateBoneScale
end

/*function meta:ManipulateBonePosition( bone, vec )
	if bone and self:GetManipulateBonePosition( bone ) ~= vec then
		self:old_bonepos( bone, vec )
	end
end
*/
function meta:ManipulateBoneAngles( bone, ang )
	if bone and self:GetManipulateBoneAngles( bone ) ~= ang then
		self:old_boneang( bone, ang )
	end
end
/*
function meta:ManipulateBoneScale( bone, vec )
	if bone and self:GetManipulateBoneScale( bone ) ~= vec then
		self:old_bonescale( bone, vec )
	end
end*/

local OldGetRagdollOwner = meta.GetRagdollOwner
function meta:GetRagdollOwner()
	if self.OverrideRagdollOwner then
		return self:GetOwner()
	else
		return OldGetRagdollOwner( self )
	end
end

function meta:ResetBoneMatrix()
	for i=0, self:GetBoneCount() - 1 do
		self:ManipulateBoneAngles(i, Angle(0,0,0))
		self:ManipulateBoneAngles(i, Angle(0,0,0))
		self:ManipulateBonePosition(i, vector_origin)
		self:ManipulateBonePosition(i, vector_origin)
		self:ManipulateBoneScale(i, Vector(1,1,1))
		self:ManipulateBoneScale(i, Vector(1,1,1))
	end
end

function meta:ResetBoneScale()
	for i=0, self:GetBoneCount() - 1 do
		self:ManipulateBoneScale(i, Vector(1,1,1))
		self:ManipulateBoneScale(i, Vector(1,1,1))
	end
end

function meta:IsNextBot()
	return self and ( self.NextBot or self:IsValid() and self.GetClass and ( self:GetClass() == "sogm_mob" or self:GetClass() == "sogm_buddy" ) )// or self.NextBot
end

function meta:GetCharacter()
	if self:IsPlayer() then
		return self:GetDTInt( 2 ) or 0
	end
	
	if self:IsNextBot() then
		return self:GetDTInt( 0 ) or 0
	end
end

function meta:GetCharTable()
	local char = self:GetCharacter()
	if char and GAMEMODE.Characters and GAMEMODE.Characters[ char ] then
		return GAMEMODE.Characters[ char ]
	end
	return self.dummy_table or {}
end

function meta:GetCharIcon()
	return self:GetCharTable() and self:GetCharTable().Icon
end

//Kilburn would be proud :v
local minDot = math.cos(math.rad(60))
local trace = { mask = MASK_SOLID_BRUSHONLY }
function meta:PenetratingMeleeTrace(distance, size, filter_table)
	
	local offset = 15
	
	distance = distance + offset// + 16
	
	
	//local ang = self:EyeAngles()
	//ang.p = 0
	//local dir = ang:Forward()
	local dir = self:GetForward()
	local ang = dir:Angle()
	
	local pos = self:GetShootPos() - dir * offset
	
	local scale = self:GetModelScale() or 1
		
	local t = {}
	
	//trace.filter = { self }	
	
	for _,ent in ipairs(ents.FindInBox(pos - distance * scale * Vector(1, 1, 1), pos + distance * scale * Vector(1, 1, 1))) do
		if ent and ent:IsValid() and !IsValid( ent.Roll ) and ent:GetSolid() ~= SOLID_NONE and ent ~= self and filter_table and !filter_table[tostring(ent)] and not ent.Dead then//( ent:IsPlayer() or ent:IsNextBot() )
						
			if not ent.GetShootPos then
				ent.GetShootPos = function( s )
					return s:GetPos() + s:OBBCenter()
				end
			end
			
			local vec = ent:NearestPoint( pos ) - pos//ent:GetShootPos() - pos
			vec.z = 0
			local len = vec:Length()
			
			scale = ent:GetModelScale() or 1
			if scale == 1 then
				scale = self:GetModelScale() or 1
			end
			
			if len > 0.0001 and len <= distance * scale then
				
				vec:Mul(1/len)
				if vec:Dot(dir) > minDot then
				
					trace.start = self:GetShootPos()
					trace.endpos = self:GetShootPos() + vec * ( 17 )//ent:GetShootPos()
					
					local wall_tr = util.TraceLine( trace )
					
					if !wall_tr.HitWorld then			
						//make a dummy trace, so i dont have to remake base melee code again
						local tr = {}
						tr.Hit = true
						tr.StartPos = pos
						tr.HitPos = ent:NearestPoint( pos )
						tr.MatType = ( ent:IsPlayer() or ent:IsNextBot() ) and MAT_FLESH or MAT_DEFAULT 
						tr.Entity = ent
						tr.Normal = dir
						tr.HitNormal = dir * -1

						table.insert(t, tr)
						filter_table[tostring(ent)] = ent
					end
				end
			end
		end
	end
	
	/*ang:RotateAroundAxis( vector_up, 55 )
	local one = pos + ang:Forward() * distance
	
	debugoverlay.Cross( pos, 2, 7, color_white, false )
	debugoverlay.Cross( pos + dir * distance, 2, 7, color_white, false )
	debugoverlay.Cross( one, 2, 7, color_white, false ) 
	
	ang:RotateAroundAxis( vector_up, -55 -55 )
	
	local two = pos + ang:Forward() * distance
	
	debugoverlay.Cross( two, 2, 7, color_white, false ) 
	
	ang:RotateAroundAxis( vector_up, 55/2 )
	
	local three = pos + ang:Forward() * distance
	
	debugoverlay.Cross( three, 2, 7, color_white, false ) 
	
	ang:RotateAroundAxis( vector_up, 55 )
	
	local four = pos + ang:Forward() * distance
	
	debugoverlay.Cross( four, 2, 7, color_white, false ) 
	
	debugoverlay.Line( pos, one, 7, color_white, false )
	debugoverlay.Line( four, one, 7, color_white, false )
	debugoverlay.Line( pos + dir * distance, four, 7, color_white, false )
	debugoverlay.Line( pos + dir * distance, three, 7, color_white, false )
	debugoverlay.Line( two, three, 7, color_white, false )
	debugoverlay.Line( pos, two, 7, color_white, false )*/
	
	return t
end

/*local trace = { mask = MASK_SHOT }
function meta:PenetratingMeleeTrace(distance, size, prehit, start)
	start = start or self:GetShootPos()
	
	local scale = self:GetModelScale() or 1
	
	local t = {}
	trace.start = start - self:GetAimVector() * 6
	trace.endpos = start + self:GetAimVector() * distance
	trace.mins = Vector(-size, -size, -size )
	trace.maxs = Vector(size, size, size)
	trace.filter = { self }
	
	//debugoverlay.Box( trace.start, trace.mins, trace.maxs, 10, color_white )
	//debugoverlay.Line( trace.start, trace.endpos, 10, color_white, false )
	//debugoverlay.Box( trace.endpos, trace.mins, trace.maxs, 10, color_white )

	for i=1, 10 do
		local tr = util.TraceHull(trace)
		
		//PrintTable(tr)
		
		if not tr.Hit or tr.HitWorld then break end

		local ent = tr.Entity
		if ent and ent.IsValid and ent:IsValid() and !IsValid( ent.Roll ) then
			table.insert(t, tr)
			table.insert(trace.filter, ent)
		end
	end
	
	return t
end*/

local reg = debug.getregistry()
local GetVelocity = reg.Entity.GetVelocity
local Length = reg.Vector.Length

function meta:GetVelocityLength()
	return Length( GetVelocity( self ) )
end

local util_OldDecal = util.Decal
local get_map = game.GetMap()

// instead of going through all util decals, lets just stop them there once and for all to prevent crashing
util.Decal = function( ... )
	
	if get_map == "sog_deathloop_v7" then 
		return 
	end
	
	util_OldDecal( ... )
	
end