CHARACTER.Reference = "swat sniper"

CHARACTER.Name = "SWAT Sniper"
CHARACTER.Description = "Mom get the camera!"

CHARACTER.Health = 100
CHARACTER.Speed = 0

CHARACTER.StartingWeapon = "sogm_sniperrifle"

CHARACTER.Model = Model( "models/player/riot.mdl" )

CHARACTER.CantExecute = true
CHARACTER.DontLoseWeapon = true

CHARACTER.GametypeSpecific = "singleplayer"
CHARACTER.NoMenu = true

CHARACTER.InfiniteAmmo = true

CHARACTER.BulletScale = 2

local vec_add = Vector(128, 128, 128)
function CHARACTER:OnSpawn( pl )
	
	pl.SpotDistance = 3000
	pl.AttackDistance = 3000
	pl.ChaseDistance = 3000
	
end

function CHARACTER:OnClientSpawn( pl )
	
	local tr = pl:GetEyeTrace()
	
	if tr.Hit and tr.HitPos then
		pl:SetRenderBoundsWS( pl:GetPos(), tr.HitPos, vec_add )
	end
	
end

local NewActivityTranslate = {}
NewActivityTranslate[ACT_MP_STAND_IDLE] = ACT_HL2MP_IDLE_CROUCH_AR2
NewActivityTranslate[ACT_MP_WALK] = ACT_HL2MP_WALK_CROUCH_AR2
NewActivityTranslate[ACT_MP_RUN] = ACT_HL2MP_WALK_CROUCH_AR2

function CHARACTER:TranslateActivity( pl, act )
	if NewActivityTranslate[act] ~= nil then
		return NewActivityTranslate[act]
	end

	return -1
end


function CHARACTER:OnDraw( pl )

	local tr = pl:GetEyeTrace()
	
	if tr.Hit and tr.HitPos then
		pl:SetRenderBoundsWS( pl:GetPos(), tr.HitPos, vec_add )
	end

end