CHARACTER.Reference = "heks aid"

CHARACTER.Name = "Heks Spawn"
CHARACTER.Description = ""

CHARACTER.Health = 100
CHARACTER.Speed = 150

CHARACTER.GametypeSpecific = "singleplayer"
CHARACTER.NoMenu = true
CHARACTER.KnockdownImmunity = true
CHARACTER.NoLights = true

CHARACTER.StartingWeapon = "sogm_fists_thug"

CHARACTER.Model = Model( "models/player.mdl")

local NewActivityTranslate = {}
NewActivityTranslate[ACT_MP_STAND_IDLE] = ACT_IDLE
NewActivityTranslate[ACT_MP_WALK] = ACT_WALK
NewActivityTranslate[ACT_MP_RUN] = ACT_WALK
NewActivityTranslate[ACT_MP_CROUCH_IDLE] = ACT_IDLE
NewActivityTranslate[ACT_MP_CROUCHWALK] = ACT_WALK
NewActivityTranslate[ACT_MP_JUMP] = ACT_WALK

local function DoDamageEfects( pl, delta )
	
	local pos
	local bone
	
	if delta < 0.85 then
		
		for i=0, pl:GetBoneCount() - 1 do
			local bonename = pl:GetBoneName( i )
			if bonename and string.find( bonename, "L Finger" ) then
				pl:ManipulateBoneScale( i, vector_origin )
			end
		end
		
		bone = pl:LookupBone( "Bip01 L Hand" )
	
		if bone then
			pl:ManipulateBoneScale( bone, vector_origin )
		end
		
	end
	
	if delta < 0.65 then
		
		bone = pl:LookupBone( "Bip01 L Forearm" )
	
		if bone then
			pl:ManipulateBoneScale( bone, vector_origin )
		end
		
	end
	
	if delta < 0.45 then
		
		bone = pl:LookupBone( "Bip01 L UpperArm" )
	
		if bone then
			pl:ManipulateBoneScale( bone, vector_origin )
		end
		
		bone = pl:LookupBone( "Bip01 L Clavicle" )
	
		if bone then
			pl:ManipulateBoneScale( bone, vector_origin )
		end
		
	end
	
	if delta < 0.35 then
		
		bone = pl:LookupBone( "Bip01 Head" )
	
		if bone then
			pl:ManipulateBoneScale( bone, vector_origin )
		end
		
		bone = pl:LookupBone( "Bip01 Neck" )
	
		if bone then
			pl:ManipulateBoneScale( bone, vector_origin )
		end
		
		bone = pl:LookupBone( "Bip01 Spine3" )
	
		if bone then
			pl:ManipulateBoneScale( bone, vector_origin )
		end
		
	end
	
	if delta < 0.2 then
		
		bone = pl:LookupBone( "Bip01 Spine2" )
	
		if bone then
			pl:ManipulateBoneScale( bone, vector_origin )
		end
		
	end
	
	if delta <= 0 then
		
		for i=0, pl:GetBoneCount() - 1 do
			local bonename = pl:GetBoneName( i )
			if bonename and string.find( bonename, "R Finger" ) then
				pl:ManipulateBoneScale( i, vector_origin )
			end
		end
		
		bone = pl:LookupBone( "Bip01 R Hand" )
	
		if bone then
			pl:ManipulateBoneScale( bone, vector_origin )
		end
		
		bone = pl:LookupBone( "Bip01 R Forearm" )
	
		if bone then
			pl:ManipulateBoneScale( bone, vector_origin )
		end
		
		bone = pl:LookupBone( "Bip01 R UpperArm" )
	
		if bone then
			pl:ManipulateBoneScale( bone, vector_origin )
		end
		
		bone = pl:LookupBone( "Bip01 R Clavicle" )
	
		if bone then
			pl:ManipulateBoneScale( bone, vector_origin )
		end
		
		
	end
	
	if bone then
		pos = pl:GetBonePosition( bone )
	end
	
	if pos then
		local e = EffectData()
			e:SetOrigin( pos )
			e:SetScale( 10 )
		util.Effect( "BloodImpact", e )
	end
	
	pl:EmitSound( "physics/body/body_medium_break"..math.random( 2, 4 )..".wav", 75, math.random( 100, 110 ) )
	
end

function CHARACTER:OnSpawn( pl )
	
	local bone = pl:LookupBone( "Bip01 R Forearm" )
	
	if bone then
		pl:ManipulateBoneAngles( bone, Angle( 0, 90, 0 ) )
	end
	
	pl.HitPoints = 500
	pl.MaxHitPoints = pl.HitPoints * 1
	
	pl.OverrideSpeed = math.random( 60, 170 )
	
	pl.OverrideRepath = math.Rand( 0.5, 1.7 )
	
	pl.loco:SetJumpHeight( 250 )
	
	for i=0, pl:GetBoneCount() - 1 do
		pl:ManipulateBoneScale( i, vector_origin )
	end
	
	pl.BoneTime = CurTime() + 1
	
	/*local ent = Entity(1)
	local norm = ( ent:GetPos() - pl:GetPos() ):GetNormal()
	
	pl.loco:JumpAcrossGap( pl:GetPos() + norm * 100, norm )*/
	
end

function CHARACTER:OnAttack( pl )
	
	local bone = pl:LookupBone( "Bip01 R Forearm" )
	
	if bone then
		pl:ManipulateBoneAngles( bone, Angle( 0, 90, 90 ) )
	end
	
	local bone = pl:LookupBone( "Bip01 R UpperArm" )
	
	if bone then
		pl:ManipulateBoneAngles( bone, Angle( 0, -90, 0 ) )
	end

end

function CHARACTER:OverrideBodyUpdate( pl )
	
	pl.NextSequence = pl.NextSequence or 0
	local next_seq = 0
	
	local velocity = pl.loco:GetVelocity()
	
	local eye_ang = pl:EyeAngles()
	
	local playback = 1
	
	local len2d = velocity:Length2DSqr()
	
	local seq = "Idle01"
	
	if len2d > 1 then
		seq = "walk"
		playback = ( len2d / ( pl.OverrideSpeed * pl.OverrideSpeed ) ) * 2
	end

	if pl.Dead and pl.DieTime and pl.DieDuration then
		
		local cycle = math.Clamp( 1 - ( pl.DieTime - CurTime() ) / pl.DieDuration, 0, 0.8 )

		pl:SetCycle( cycle )
		pl:ResetSequence( pl:LookupSequence( "diesimple" ) )
		
		return
	end
	
	pl:SetPlaybackRate( playback )
	
	local seq_id, seq_dur = pl:LookupSequence( seq )
			
	if pl.NextSequence < CurTime() then
		pl:ResetSequence( seq )
		//pl.NextSequence = CurTime() + seq_dur
	end
		
end


function CHARACTER:TranslateActivity( pl, act )
	
	local tbl = NewActivityTranslate
	
	if tbl[ act ] ~= nil then
		return tbl[ act ]
	end

	return -1
end

function CHARACTER:OnBulletHit( pl, hitpos, hitnormal, dir, dmginfo, bullet ) 
	return false
end

local vec_one = Vector( 1, 1, 1 )
function CHARACTER:OnThink( pl )
	
	if pl.Dead then pl:SetBehaviour( BEHAVIOUR_DUMB ) end

	if pl.BoneTime and pl.BoneTime > CurTime() then
		local scale = math.Clamp( 1 - ( pl.BoneTime - CurTime() ), 0, 1 )
		for i=0, pl:GetBoneCount() - 1 do
			pl:ManipulateBoneScale( i, vec_one * scale )
		end
	end
	
	pl.Pursuit = Entity(1)
	pl.SpotDistance = 3000
	pl.ChaseDistance = 3000
end

function CHARACTER:OnBulletHit( pl, hitpos, hitnormal, dir, dmginfo, bullet ) 
		
	if SERVER then
		if pl.Dead then return false end
		if pl:GetBehaviour() == BEHAVIOUR_DUMB then return false end
		
		pl.HitPoints = math.Clamp( pl.HitPoints - dmginfo:GetDamage(), 0, pl.MaxHitPoints )
		
		DoDamageEfects( pl, pl.HitPoints / pl.MaxHitPoints )
		
		if pl.HitPoints <= 0 then
			pl.Dead = true
			pl.DieDuration = 1.3
			pl.DieTime = CurTime() + pl.DieDuration
		end
		
	end
	
	return false
end

if CLIENT then
local dev_mat = CreateMaterial( 
	"dev30_model2", 
	"VertexLitGeneric", 
	{
		["$basetexture"] = "dev/reflectivity_30", 
		["$model"] = 1,
	}
)

local goop_mat = CreateMaterial( "coffin5",
    "VertexLitGeneric",
    {
        ["$basetexture"] = "Models/flesh",
        ["$bumpmap"] = "models/flesh_nrm",
        ["$nodecal"] = "0",
        ["$halflambert"] = 1,
        ["$translucent"] = 1,
        ["$model"] = 1,

        ["$detail"] = "Models/flesh",
        ["$detailscale"] = 1.2,
        ["$detailblendfactor"] = 7,
        ["$detailblendmode"] = 3,

        ["$phong"] = "1",
        ["$phongboost"] = "5",
        ["$phongfresnelranges"] = "[10 3 10]",
        ["$phongexponent"] = "500"
    }
)

local goop_mat2 = CreateMaterial( "coffin6",
    "VertexLitGeneric",
    {
        ["$basetexture"] = "Models/flesh",
        ["$bumpmap"] = "models/flesh_nrm",
        ["$nodecal"] = "0",
        ["$halflambert"] = 1,
        ["$translucent"] = 1,
        ["$model"] = 1,

        ["$detail"] = "Models/flesh",
        ["$detailscale"] = 1.2,
        ["$detailblendfactor"] = 7,
        ["$detailblendmode"] = 3,

        ["$phong"] = "1",
        ["$phongboost"] = "5",
        ["$phongfresnelranges"] = "[10 3 10]",
        ["$phongexponent"] = "500"
    }
)

function CHARACTER:OnDraw( pl )
	render.MaterialOverride( dev_mat )
end

function CHARACTER:PostDraw( pl )

	render.MaterialOverride()
	
	goop_mat:SetFloat( "$detailscale", 1 + math.sin(RealTime() * 0.2) * 0.9 )
	goop_mat2:SetFloat( "$detailscale", 1 + math.cos(RealTime() * 0.2) * 0.9 )
	
	render.SetColorModulation( 0, 0, 0 )
	
	pl:SetupBones()
	render.MaterialOverride( goop_mat )
	pl:DrawModel()
	render.MaterialOverride(  )
	
	pl:SetupBones()
	render.MaterialOverride( goop_mat2 )
	pl:DrawModel()
	render.MaterialOverride(  )
	
	render.SetColorModulation( 1, 1, 1 )

end
end

