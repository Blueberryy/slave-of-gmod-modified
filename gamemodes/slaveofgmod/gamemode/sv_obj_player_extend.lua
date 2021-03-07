local meta = FindMetaTable( "Player" )
if (!meta) then return end 

util.PrecacheSound( "npc/fast_zombie/claw_miss1.wav" )

local wtrace = { mask = MASK_SOLID }
function meta:ThrowCurrentWeapon( force, noknockback, instant )
	
	local wep = self:GetActiveWeapon()
	
	if !IsValid( wep ) then return false end
	if wep.Hidden then return end //preventing few weapons from being dropped
	if self:GetCharTable().RemoveWeaponOnDeath then return end
	
	self.NextThrow = self.NextThrow or 0
	
	if not instant then
		if self.NextThrow >= CurTime() then return false end
	end
	
	wtrace.start = self:GetShootPos()
	wtrace.endpos = self:GetShootPos() + self:GetAimVector() * math.min( 0, 20 - wep:OBBMaxs():Distance(wep:OBBMins())/1.8 ) 
	wtrace.filter = self
	
	local tr = util.TraceLine(wtrace)
			
	local pr = ents.Create( "dropped_weapon" )
	
	pr:SetPos( tr.HitPos )
	
	local ang = self:GetAimVector():Angle()
	if not wep.NoRotation then
		ang:RotateAroundAxis( self:GetAimVector(), 90)
	end
	
	pr:SetAngles( ang )
	pr:DropAsWeapon( wep, self:GetCharTable().UseAkimboGuns and wep.Akimbo )
	pr:SetAttacker( self )
	pr.NoKnockback = noknockback or false
	pr:Spawn()
	
	local phys = pr:GetPhysicsObject()
	if IsValid(phys) then
		phys:SetVelocityInstantaneous( self:GetAimVector() * ( ( force or 430 ) * (self:GetCharTable().ThrowMultiplier or 1) ) /*+ ( !noknockback and self:GetVelocity()*0.7 or vector_origin ) */)
		phys:Wake()
	end
	
	self:StripWeapon( wep:GetClass() )
	
	if not noknockback then
		self:EmitSound( "weapons/slam/throw.wav" )
	end
	
	self.NextThrow = CurTime() + 1
	
	self:ResetBoneMatrix()
	self:ResetBoneMatrix()
	self:ResetBoneMatrix()
	
	//self:PlayGesture( ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE )
	
	return true
	
end

function meta:GetRandomNearbyPosition( dist )
	dist = dist or 43
	
	local rand = VectorRand()
	rand.z = 0
	local pos = self:GetShootPos() + rand * dist
	
	wtrace.start = self:GetShootPos()
	wtrace.endpos = pos
	wtrace.filter = self
	
	local tr = util.TraceLine(wtrace)
	
	return tr.HitPos
	
end


function meta:SpawnNearbyWeapon( class )
	
	local pos = self:GetRandomNearbyPosition()
	
	local pr = ents.Create( "dropped_weapon" )
		pr:SetPos( pos )
		pr:SpawnAsWeapon( class )
		pr.NoKnockback = false
		pr.Exception = true
	pr:Spawn()

	local phys = pr:GetPhysicsObject()
	if IsValid(phys) then
		phys:SetVelocityInstantaneous( vector_up * 130 )
	end
	
	return pr
	
end

function meta:IsCharging()
	local wep = IsValid( self:GetActiveWeapon() ) and self:GetActiveWeapon()
	
	return wep and wep.IsChargeAttacking and wep:IsChargeAttacking()
end

function meta:DoKnockdown( time, bypass, attacker, punch )

	if !self:Alive() then return end
	if IsValid(self.Knockdown) then return end
	if IsValid(self.Execution) then return end
	if IsValid(self.HumanShield) then return end
	if IsValid(self.HostageEnt) then return end
	if self:IsCharging() then return end
	if self:IsRolling() then return end
	if self.NoKnockdown then return end
	if attacker and attacker:GetCharTable().CantKnockdown and !bypass then return end
	if self:GetCharTable().KnockdownImmunity and !bypass then return end
	if punch and attacker and attacker:Team() == self:Team() and DISABLE_TEAM_PUNCHING then return end
	
	local knockdown = true
	
	if self:GetCharTable().OnKnockdown then 
		knockdown = self:GetCharTable():OnKnockdown( self, attacker, punch )
	end
	
	if !knockdown then return end
	
	if self:GetCharTable().KnockdownTimePenalty then
		time = time + self:GetCharTable().KnockdownTimePenalty
	end
	
	local k = ents.Create( "state_knockdown" )
	k:SetParent( self )
	k:SetPos( self:GetPos() + vector_up * 20 )
	k:SetAngles(Angle(90,0,0))
	k:SetOwner( self )
	k:SetDuration( time or 3 )
	k.Attacker = attacker
	k:Spawn()
	
	return k

end

function meta:AddOverrideAnimation( seq_id )
	
	local k = ents.Create( "state_animationoverride" )
	k:SetParent( self )
	k:SetPos( self:GetPos() + vector_up * 20 )
	k:SetAngles( self:GetAngles() )
	k:SetOwner( self )
	k:Spawn()
	
	k:SetOverrideSequence( seq_id ) 
	
	return k
	
end

local RandomDism = {
	HITGROUP_HEAD,
	HITGROUP_LEFTARM,
	HITGROUP_RIGHTARM,
	HITGROUP_RIGHTLEG,
	HITGROUP_LEFTLEG,
	HITGROUP_GEAR,
}

function meta:Dismember( hitgroup, dmginfo )

	hitgroup = hitgroup or RandomDism[math.random(1,#RandomDism)]
	
	if type( hitgroup ) ~= "number" then hitgroup = -1 end
	
	/*if NIGHTMARE and hitgroup == -1 then
		local e = EffectData()
			e:SetEntity( self )
			e:SetOrigin( self:GetPos() )
			e:SetNormal( dmginfo and dmginfo:GetDamageForce():GetNormal() or VectorRand() )
		util.Effect("player_gib", e, nil, true)
	else*/
		local e = EffectData()
			e:SetEntity( self )
			e:SetOrigin( self:GetPos() )
			e:SetScale( hitgroup )
		util.Effect("dismemberment", e, nil, true)
	//end


end

local trace = {mask = MASK_SHOT, mins = Vector(-16,-16,-16), maxs = Vector(16, 16, 15)}

function meta:Punch( kill )

	if IsValid(self:GetActiveWeapon()) then return end
	if IsValid(self.Knockdown) then return end
	if IsValid(self.Execution) then return end
	if IsValid(self.HostageEnt) then return end
	if !self:Alive() then return end
	
	self.NextPunch = self.NextPunch or 0
	
	if self.NextPunch >= CurTime() then return end
	
	self.NextPunch = CurTime() + 0.3
	
	self:LagCompensation( true )
	local traces = self:PenetratingMeleeTrace( 48, 3, nil )//range 28 adding 20
	self:LagCompensation( false )
	
	self:SetLuaAnimation(math.random(2) == 2 and "fist_right" or "fist_left")
	
	local playhit = false
	
	for _, tr in ipairs(traces) do
		if not tr.Hit then continue end
		
		if IsValid(tr.Entity) and tr.Entity:IsPlayer() and not IsValid(tr.Entity.Knockdown) then
			if kill then
				
				playhit = true
			
				local dmginfo = DamageInfo()
					dmginfo:SetDamagePosition(tr.HitPos)
					dmginfo:SetDamage(300)
					dmginfo:SetAttacker( self )
					dmginfo:SetInflictor( self )
					dmginfo:SetDamageType( DMG_CLUB )
					dmginfo:SetDamageForce(1620 * (self:GetAimVector() + vector_up*-0.2) * 18) 
					
					/*local e = EffectData()
						e:SetOrigin( tr.HitPos )
						e:SetNormal( tr.HitNormal )
						e:SetScale( 1 )
					util.Effect( "BloodImpact", e, nil, true )*/
					
				local dism = true//math.random(2) == 2
				
				if dism then tr.Entity.ToDismember = true end
					if tr.Entity:IsPlayer() then 
						self:ShakeView( math.random(7,13) )  
						tr.Entity:ShakeView( math.random(7,13) )
					end
					tr.Entity:TakeDamageInfo(dmginfo)	
				if dism then tr.Entity.ToDismember = false end			
			else
				tr.Entity:SetVelocity( self:GetAimVector() * 350 )
				tr.Entity:DoKnockdown( 2, false, self, true )
				self:SetComboTime()
			end
		end
		if IsValid(tr.Entity) and tr.Entity:GetClass() == "func_breakable_surf" then
			tr.Entity:Fire("break", "", 0)
		end
		
	end
	
	if playhit then
		self:EmitSound( "npc/vort/foot_hit.wav", 100, 95 )	
	else
		self:EmitSound("npc/zombie/claw_miss1.wav", 45, math.Rand(75, 80))
	end
	
	
	
end

function meta:PerformRoll( noknockdown )
	
	if IsValid(self.Knockdown) then return end
	if IsValid(self.Execution) then return end
	if !self:Alive() then return end
	if self:GetVelocityLength() < self:GetMaxSpeed()/2 then return end
	
	self.NextRoll = self.NextRoll or 0
	
	if self.NextRoll >= CurTime() then return end
	
	self.NextRoll = CurTime() + 0.7
	
	local anim = "roll"
	local dir = self:GetAimVector()
		
	
	/*local dot = math.Round(self:GetAimVector():GetNormal():DotProduct(self:GetVelocity():GetNormal()))
	local dot2 = math.Round(self:GetAimVector():Angle():Right():DotProduct(self:GetVelocity():GetNormal()))
	
	if dot == -1 then
		anim = "roll_back"
	end
	
	if dot2 == -1 then
		anim = "roll_left"
	elseif dot2 == 1 then
		anim = "roll_right"
	end
		
	self:SetLuaAnimation( anim )*/
	
	self:SetVelocity(self:GetVelocity() * 0.3)
	
	local r = ents.Create( "state_roll" )
	r:SetParent( self )
	r:SetPos( self:GetPos() + vector_up * 20 )
	r:SetOwner( self )
	if noknockdown then
		r.NoKnockdown = true
	end
	r:Spawn()
	
end


function meta:BalanceTeams( team1, team2 )
	if team.NumPlayers(TEAM_SPECTATOR) >= 2 then return end
	//if self.BalanceTo then self.BalanceTo = nil return end
	
	local myteam = self:Team()
	local enemyteam = team1
	if myteam == team1 then
		enemyteam = team2
	end
	
	if team.NumPlayers(myteam) - team.NumPlayers(enemyteam) >= 2 then
		//self.BalanceTo = enemyteam
		self:SetTeam(enemyteam)
		self:ChatPrint("You were moved into opposite team for balance!")
	end
	
end

util.AddNetworkString( "LevelClear" )

function meta:ShowLevelClear()
	
	net.Start( "LevelClear" )
	net.Send( self )
	
end

/*meta.OldFreeze = meta.Freeze

function meta:Freeze( bl )
	
	self.m_bFrozen = bl
	
	self:OldFreeze( bl )
	
end

function meta:IsFrozen()
	return self.m_bFrozen
end*/

//id number or "reference" value
function meta:SetCharacter( id )
	
	if type(id) == "string" then
		id = GAMEMODE:GetCharacterIdByReference( id )
	end
	
	if not id then return end
	self:SetDTInt( 2, id or 0 )
end

function meta:SetScore( am )
	self:SetDTInt( 0 , am )
	if self:GetScore() > self:GetMaxScore() then
		self:SetMaxScore( self:GetScore() )
	end
end

function meta:AddScore( toadd, ent )
	if self.NoScore then return end
	toadd = math.abs( toadd )
	self:SetScore( self:GetScore() + toadd )
	
	if IsValid( ent ) then
		local pos = ent:GetPos() + vector_up * 58
		
		self:AddScoreMessage( translate.Format("sog_hud_x_points_screen", toadd), pos, 1 )
		
	end
	
end

function meta:ResetScore()
	self:SetScore( 0 )
end

function meta:ResetMaxScore()
	self:SetMaxScore( 0 )
end

function meta:ResetAllScore()
	self:ResetScore()
	self:ResetMaxScore()
end

function meta:SetMaxScore( am )
	self:SetDTInt( 1 , am )
end

util.AddNetworkString( "ResetComboMeter" )

function meta:ResetComboTime()
	self.ComboTime = 0
	net.Start( "ResetComboMeter" )
	net.Send( self )
end

function meta:SetComboTime()
	self.ComboTime = CurTime() + math.Clamp( COMBO_WINDOW + ( self:GetCharTable().AddComboWindow or 0 ), 0, 9999 )
end

function meta:GetComboTime()
	return self.ComboTime or 0
end

util.AddNetworkString( "IncreaseComboMeter" )

function meta:AddCombo()
	self:SetComboTime()
	self:SetComboCounter( self:GetComboCounter() + 1 )
	
	//singleplayer only!
	if SINGLEPLAYER then
		if self:GetComboCounter() >= 20 then
			GAMEMODE:UnlockAchievement( "20x" )
		end
	end
	
	net.Start( "IncreaseComboMeter" )
	net.WriteInt( self:GetComboCounter(), 32 )
	net.Send( self )
end 

function meta:SetComboCounter( am )
	self.ComboCounter = am
end

function meta:GetComboCounter()
	return self.ComboCounter or 0
end

function meta:IsInCombo()
	return self:GetComboTime() > 0
end

function meta:CheckCombo( melee )
	if self.NoScore then return end
	self:AddCombo()
	self.MeleeCombo = melee
end

function meta:HasMeleeCombo()
	return self.MeleeCombo or false
end

function meta:CleanAllCombo()
	self:ResetComboTime()
	self:SetComboCounter( 0 )
end

function meta:FinishCombo()
	
	//it was worth sneaking into dennaton in order to get the secret combo formula
	
	local toadd = COMBO_PTS * (self:GetComboCounter() + 1)
	
	toadd = toadd * self:GetComboCounter()
	
	self:AddScore( toadd )
	
	local pos = self:GetPos() + vector_up * 68
		
	self:AddScoreMessage( self:GetComboCounter().."xcombo", pos, 1.3 )
	
	self:ResetComboTime()
	self:SetComboCounter( 0 )
end

function meta:Think()
	
	if self:IsInCombo() and self:GetComboTime() <= CurTime() then
		if self:GetComboCounter() > 1 then
			self:FinishCombo()
		else
			self:CleanAllCombo()
		end
	end
	
end

function meta:SetBuddy( ent )
	self:SetDTEntity( 1, ent )
end

function meta:RTV()
	
	if GAMEMODE.RTV_Players[self:SteamID()] then return end
	
	GAMEMODE.RTV_Players[self:SteamID()] = true
	
	if VOTING then return end
	if NEXT_MAP then return end

	RTV_NUM = RTV_NUM + 1
	
	local desired = math.Round(#player.GetAll()*0.8)
	
	for k,v in pairs(player.GetAll()) do
		v:ChatPrint("Player "..self:Nick().." wants to rock the vote ("..RTV_NUM.."/"..desired.."). Press F3 to participate.")
	end
	
	if RTV_NUM >= desired then
		for k,v in pairs(player.GetAll()) do
			v:ChatPrint("Rock the vote has started!")
		end
		GAMEMODE:StartVoting( VOTING_TIME )
	end
	
end

function meta:SpawnBodywear( mdl )
	
	mdl = mdl or "models/player/combine_super_soldier.mdl"
	
	local b = ents.Create( "ent_bodywear" )
	b:SetPos( self:GetPos() )
	b:SetParent( self )
	b:SetOwner( self )
	b:SetModel( mdl )
	b:Spawn()
	
	return b
	
end

util.AddNetworkString( "SendMapList" )

function meta:SendMapList()
	
	if self.GotMaps then return end
	
	self.GotMaps = true
	
	net.Start( "SendMapList" )
		net.WriteTable( GAMEMODE.AvalaibleMaps )
	net.Send( self )
	
end

util.AddNetworkString( "SetGoal" )

function meta:SetGoal( goal, time )
	net.Start( "SetGoal" )
		net.WriteString( goal )
		net.WriteInt( time or -1, 32 )
	net.Send( self )
end

util.AddNetworkString( "ClearGoal" )

function meta:ClearGoal()
	net.Start( "ClearGoal" )
	net.Send( self )
end

util.AddNetworkString( "HUDMessage" )

function meta:PopHUDMessage( txt )
	net.Start( "HUDMessage" )
		net.WriteString( txt )
	net.Send( self )
end

util.AddNetworkString( "AddArrow" )

function meta:AddArrow( ent, pos, follow, screencheck )
	
	net.Start( "AddArrow" )
		net.WriteEntity( ent )
		net.WriteVector( pos or vector_origin )
		net.WriteBit( follow and 1 or 0 )
		net.WriteBit( screencheck and 1 or 0 )
	net.Send( self )
	
end

util.AddNetworkString( "CleanArrows" )

function meta:CleanArrows()
	
	net.Start( "CleanArrows" )
	net.Send( self )
	
end


util.AddNetworkString( "AddObjArrow" )

function meta:AddObjectiveArrow( pos, endpos, time )
	
	net.Start( "AddObjArrow" )
		net.WriteVector( pos or self:GetPos() )
		net.WriteVector( endpos or vector_origin )
		net.WriteFloat( time or 10 )
	net.Send( self )
	
end

util.AddNetworkString( "AddObjArrowFollow" )

function meta:AddObjectiveArrowFollow( target )
	
	net.Start( "AddObjArrowFollow" )
		net.WriteEntity( target )
	net.Send( self )
	
end

util.AddNetworkString( "RecScoreMessage" )

function meta:AddScoreMessage( text, pos, decay )
	
	net.Start( "RecScoreMessage" )
		net.WriteString( text )
		net.WriteVector( pos )
		net.WriteFloat( decay )
	net.Send( self )
	
end

util.AddNetworkString( "ShowHugeMessage" )

function meta:ShowHugeMessage( text )
	
	net.Start( "ShowHugeMessage" )
		net.WriteString( text )
	net.Send( self )
	
end


util.AddNetworkString( "PlayGesture" )

function meta:PlayGesture(name)

	self:AnimRestartGesture(GESTURE_SLOT_GRENADE, name, true)
	
	net.Start( "PlayGesture" )
		net.WriteEntity( self )
		net.WriteInt( name, 32 )
	net.Broadcast()
	
end

util.AddNetworkString( "CleanBodies" )

function meta:CleanBodies()

	net.Start( "CleanBodies" )
	net.Send( self )
	
end

function meta:SetFlipView( bl )
	self:SetDTBool( 0, bl )
end

util.AddNetworkString( "ShakeView" )

function meta:ShakeView( am, dur )

	net.Start( "ShakeView" )
		net.WriteInt( am, 32 )
		net.WriteFloat( dur or 0.1 )
	net.Send( self )
	
end

util.AddNetworkString( "SetClientsideModelScale" )

function meta:SetClientsideModelScale( scale )
	
	self.ClientSideScale = scale
	
	net.Start( "SetClientsideModelScale" )
		net.WriteEntity( self )
		net.WriteFloat( scale )
	net.Broadcast()
	
end