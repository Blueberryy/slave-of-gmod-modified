CHARACTER.Reference = "protagonist victim"

CHARACTER.Name = "Victim Protagonist"
CHARACTER.Description = "But that's the evil one?"

CHARACTER.Health = 100
CHARACTER.Speed = 380

CHARACTER.StartingWeapon = nil
CHARACTER.GametypeSpecific = "singleplayer"
CHARACTER.OverrideColor = Color( 62, 88, 106 )
CHARACTER.NormalHoldType = true
CHARACTER.NoMenu = true

CHARACTER.InfiniteAmmo = true
CHARACTER.RemoveWeaponOnDeath = true
//CHARACTER.SpawnProtection = 0.6

CHARACTER.Icon = Material( "sog/default.png", "smooth" )

CHARACTER.Model = Model( "models/player/group01/male_02.mdl")


local PROTAGONIST_DEFAULT = 0
local PROTAGONIST_MELEE = 1
local PROTAGONIST_THUG = 2
local PROTAGONIST_GUN = 3
local PROTAGONIST_MELEE2 = 4
local PROTAGONIST_GUN2 = 5
local PROTAGONIST_MELEE3 = 6


local tree = {}
tree[PROTAGONIST_DEFAULT] = { tospawn = PROTAGONIST_THUG, am = 1 }
tree[PROTAGONIST_THUG] = { tospawn = PROTAGONIST_MELEE, am = 2, wep = "sogm_fists_thug" }
tree[PROTAGONIST_MELEE] = { tospawn = PROTAGONIST_GUN, am = 2, wep = "sogm_pipe" }
tree[PROTAGONIST_GUN] = { tospawn = PROTAGONIST_MELEE2, am = 1, wep = "sogm_usp" }
tree[PROTAGONIST_MELEE2] = { tospawn = PROTAGONIST_GUN2, am = 1, wep = "sogm_dog" }
tree[PROTAGONIST_GUN2] = { tospawn = PROTAGONIST_MELEE3, am = 1, wep = "sogm_m249" }
tree[PROTAGONIST_MELEE3] = { wep = "sogm_dog_stand" }


//TODO:FIX THE CRASHES!!!!!!!!!!!!!!!!!!!!!!

function CHARACTER:OnSpawn( pl )
	if pl:IsNextBot() then
		pl:SetNextBotColor( Color( 62, 88, 106 ) )
		pl.DOTCheck = 1
		pl.Pursuit = Entity(1)
		pl.ChaseDistance = 3000
		pl.StoreAreas = true
		pl.NoSpawnProtection = true
		//self.SpawnProtection = CurTime() + 0.05
	end
end

local function spawnchar( pl, tier, am )
	
	//if not tree[pl:GetSkin()].tospawn then return end
	if not tree[tier] then return end
	
	local myteam = pl:Team()
	local enemyteam = myteam == TEAM_PLAYER and TEAM_MOB or TEAM_PLAYER
		
	for i = 1, ( am or 1 ) do
		
		local area = nil
		
		if pl.OldArea then area = pl.OldArea end
		if not area then 
			if pl.NewArea then area = pl.NewArea end
		end
		
		if not area then 
			local check = navmesh.Find( pl.SpawnPos, 90, 10, 10 ) 
			if check then
				area = check[ math.random( #check ) ]
			end
		end
		
		local pos = nil
		
		if area then
			local sub_areas = area:GetAdjacentAreas()
			local super_sub_areas = sub_areas[math.min( #sub_areas, i )]:GetAdjacentAreas()
			pos = super_sub_areas[math.random(#super_sub_areas)]:GetCenter()
			//pos = sub_areas[math.min( #sub_areas, i )]:GetCenter()
			//pos = sub_areas[math.random(#sub_areas)]:GetCenter()
			//pos = area:GetCenter()
		else
			pos = pl.SpawnPos
		end

		local b = GAMEMODE:SpawnBot( tree[tier].wep or nil, "protagonist victim", pos, myteam, enemyteam, enemyteam )
		b:SetSkin( tier )
		b:SetAngles( pl:GetAngles() )
		b.IgnoreTeamDamage = myteam
		b.AllowRespawn = false
		b:SetBehaviour( BEHAVIOUR_DEFAULT )//BEHAVIOUR_CCW
			
		if tier == PROTAGONIST_THUG then
			//b:SetModelScale( 2.1, 0 )
			//local armor = b:SpawnBodywear( "models/player/group01/male_02.mdl" )
			//armor:SetDTVector( 0, Vector(62/255, 88/255, 106/255))
			b:SetThug()
		end
		
		if tier == PROTAGONIST_GUN2 then
			local armor = b:SpawnBodywear( "models/combine_soldier.mdl" )
			armor:SetSkin( 1 )
		end
		
		if tier == PROTAGONIST_MELEE3 then
			b.WalkSpeed = 200
		end
		
		b.NextAttack = CurTime() + 1
			
		
		
	end	
	
end

function CHARACTER:PreOnDeath( pl, attacker, dmginfo )
	if tree[pl:GetSkin()] and tree[pl:GetSkin()].tospawn then
		spawnchar( pl, tree[pl:GetSkin()].tospawn, tree[pl:GetSkin()].am )
	end
end

function CHARACTER:OnMeleeHit( pl, hitpos, hitnormal, dir, attacker ) 
	
	if pl:GetSkin() == PROTAGONIST_THUG then
		if SERVER then
			local wep = attacker and attacker.GetActiveWeapon and attacker:GetActiveWeapon()
			if wep and wep:IsValid() and ( wep:GetClass() == "sogm_fists_kill" or wep:GetClass() == "sogm_fists_concrete" or wep:GetClass() == "sogm_fists_henry" or wep:GetClass() == "sogm_axe" ) then
				pl:DoKnockdown( 2.3, true, attacker )
			end
		end

		return false
	else
		return true
	end
end