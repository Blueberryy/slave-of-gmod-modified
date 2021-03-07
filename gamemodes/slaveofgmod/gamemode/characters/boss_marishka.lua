CHARACTER.Reference = "boss marishka"

CHARACTER.Name = "Marishka"
CHARACTER.Description = ""

CHARACTER.Health = 900
CHARACTER.Speed = 120
CHARACTER.KnockdownImmunity = true
CHARACTER.NoPickups = true
CHARACTER.YellowBlood = true

CHARACTER.MeleeGesture = "shove"

CHARACTER.NoMenu = true

CHARACTER.StartingWeapon = "sogm_fists_thug"

CHARACTER.Model = Model( "models/antlion_guard.mdl" )

CHARACTER.Icon = Material( "sog/horror_gf.png", "smooth" )

CHARACTER.WElements = {
	["body"] = { type = "Model", model = "models/player/mossman_arctic.mdl", bone = "Antlion_Guard.spine2", seq = "idle_knife", rel = "", pos = Vector(-11.268, -45.993, 1.279), angle = Angle(0, 14.362, 90), size = Vector(1.5, 1.5, 1.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {}, sub_mat = { [1] = "models/headcrab/allinonebacup2" } },
	["clip"] = { type = "ClipPlane", bone = "ValveBiped.Bip01", rel = "body", pos = Vector(2.332, -5.472, 50.486), angle = Angle(-22.108, 0, 0) },
}

local scale_down = {
	"Antlion_Guard.spine3",
	"Antlion_Guard.head",
	"Antlion_Guard.teeth1",
	"Antlion_Guard.teeth2",
	"Antlion_Guard.teeth3",
	
	"Antlion_Guard.arm1_L",
	"Antlion_Guard.arm2_L",
	"Antlion_Guard.finger1_L",
	"Antlion_Guard.finger2_L",
	
	"Antlion_Guard.arm1_R",
	"Antlion_Guard.arm2_R",
	"Antlion_Guard.finger1_R",
	"Antlion_Guard.finger2_R",
	
}

local scale_up = {
	"Antlion_Guard.body",

	"Antlion_Guard.claw1_L",
	"Antlion_Guard.claw2_L",
	"Antlion_Guard.claw3_L",
	
	"Antlion_Guard.claw1_R",
	"Antlion_Guard.claw2_R",
	"Antlion_Guard.claw3_R",
}

local trace = { mask = MASK_SOLID }

function CHARACTER:OnSpawn( pl )
	
	pl:SetMaterial("models/zombie_fast_players/fast_zombie_sheet" )
	
	for i=1, #scale_down do
		local bone = pl:LookupBone( scale_down[ i ] )
	
		if bone then
			pl:ManipulateBoneScale( bone, Vector( 0, 0, 0 ) )
		end
	end
	
	for i=1, #scale_up do
		local bone = pl:LookupBone( scale_up[ i ] )
	
		if bone then
			pl:ManipulateBoneScale( bone, Vector( 1.3, 1.3, 1.3 ) )
		end
	end
	
	local bone = pl:LookupBone( "Antlion_Guard.spine1" )
	
	if bone then
		pl:ManipulateBoneScale( bone, Vector( 1.2, 1.2, 1.2 ) )
	end
	
	if not BOSS_MARISHKA_INTRO then
		pl.IntroAnim = CurTime() + 3.76
		pl:SetSequence( "floor_break" )
		pl.NextSequence = CurTime() + 3.76
		BOSS_MARISHKA_INTRO = true
	end
	
	pl.SpotDistance = 3000
	pl.ChaseDistance = 3000
	
	pl.DOTCheck = 1
	
	pl.Hits = 2
	
	pl.DoSecondPuke = false
	
	pl.NextAttack2 = 0
	
	pl.NextAttackType = 1
	
	pl.IgnoreDmgType = DMG_BLAST
	
	pl.PukeAttack = function( self )
		
		if self:GetBehaviour() == BEHAVIOUR_DUMB then return end
		
		if self.NextAttack2 < CurTime() then
		
			self:EmitSound( "npc/antlion_guard/angry"..math.random( 3 )..".wav", 100, 100, 1, CHAN_AUTO + 2 )
			
			//if self.Hits == 1 then
				//pl.FreezeAimTime = CurTime() + 0.35
			//end
			
			timer.Simple( 1, function() 
			
				if !IsValid( self ) or !self:Alive() then return end
						
						self:ResetSequenceInfo()
						self:ResetSequence( "fireattack" )
						self:SetCycle( 0 )
						self.NextSequence = CurTime() + 2.2
						
						local owner = self
						local aim = owner:GetAimVector()	
						
						self:EmitSound( "physics/body/body_medium_break"..math.random( 2, 4 )..".wav", 80, math.random( 70, 80 ) ) 

						local am = self.Hits == 1 and 10 or 5
						
						for i=1, am do
							
							local pr = ents.Create("sogm_puke")
							
							if IsValid(pr) then
							
								local att = "1"//math.random( 2 ) == 2 and "1" or "2"

								local rand = math.Rand( self.Hits == 1 and -0.5 or -0.1, self.Hits == 1 and 0.5 or 0.1 )
								
								trace.start = owner:GetShootPos()
								trace.endpos = (owner:GetAttachment( owner:LookupAttachment(att) ) and owner:GetAttachment( owner:LookupAttachment(att) ).Pos or owner:GetShootPos()) + aim * 25
								trace.filter = owner
								
								local tr = util.TraceLine( trace )
								
								local spread = aim:Angle():Right() * rand
													
								pr:SetPos( owner:GetShootPos() )//tr.HitPos or 
								pr.Inflictor = self
								pr:SetAngles( aim:Angle() )
								pr:SetOwner( owner )
								pr:Spawn()
								pr:Activate()
													
								local vel = math.random( 1180, 1200 )
								
								pr:SetVelocity( ( aim + spread ) * vel )
								
								local phys = pr:GetPhysicsObject()
								if phys:IsValid() then
									phys:SetVelocityInstantaneous( ( aim + spread ) * vel )
								end
								pr.Owner = owner
								
								pr.Team = function() return owner:Team() end
											
							end
						end
					
						
					
				end)
			
			
			self.NextAttack2 = CurTime() + 5
		end
		
	end
	
	pl.RealClawAttack = function( self )
		
		if self:GetBehaviour() == BEHAVIOUR_DUMB then return end
	
		local target = Entity(1):IsValid() and Entity(1):Alive() and Entity(1)
		if target then
		
			local pos = target:GetPos() + vector_up * 3
				
			timer.Simple( 0.12, function() 
				if GAMEMODE:GetRoundState() == ROUNDSTATE_RESTARTING then return end
				if self and self:IsValid() and pos then
					/*local e = EffectData()
						e:SetOrigin( pos )
					util.Effect( "marishka_claw", e, true, true )
				
					util.BlastDamage( Entity(1), Entity(1), pos, 72, 9999 )*/
					
					local m = ents.Create( "marishka_maw" )
					if m and m:IsValid() then
						m:SetPos( pos )
						m:Spawn()
						m:Activate()
							
						self:DeleteOnRemove( m )
						
						pl.Maws = pl.Maws or {}
						
						table.insert( pl.Maws, m )
							
					end
					
				end
			end)
		end
	end
	
	pl.ClawAttack = function( self )

		if self:GetBehaviour() == BEHAVIOUR_DUMB then return end
		
		if self.NextAttack2 < CurTime() then
		
			self:EmitSound( "npc/fast_zombie/fz_scream1.wav", 85, 85 )
		
			local am = self.Hits == 1 and 5 or 3
			local time = self.Hits == 1 and 4 or 3.5
			
			self:ResetSequenceInfo()
			self:ResetSequence( "charge_crash" )
			self:SetCycle( 0 )
			self.NextSequence = CurTime() + time
		
			for i=1, am do
				timer.Simple( 0.35 * i + 0.3, function() 
					if self and self.RealClawAttack then
						self:RealClawAttack()
					end
				end)
			end
			
			pl.FreezeAimTime = CurTime() + time
			
			self.Vulnerable = CurTime() + time
			
			self.NextAttack2 = CurTime() + 3
			
		end
		
			
	end
	
	pl.SlamAttack = function( self )
		if self:GetBehaviour() == BEHAVIOUR_DUMB then return end
		
		if self.NextAttack2 < CurTime() then
		
			self:EmitSound( "npc/fast_zombie/fz_alert_close1.wav", 100, 85 )
		
			timer.Simple( 1, function() 
				
				if !IsValid( self ) or !self:Alive() then return end

				self:EmitSound( "vehicles/v8/vehicle_impact_heavy"..math.random( 4 )..".wav", 100, 85, 1, CHAN_AUTO + 20 )
						
				self.NextSprint = 0
						
				self:ResetSequenceInfo()
				self:ResetSequence( "roar" )
				self:SetCycle( 0 )
				self.NextSequence = CurTime() + 4
				
				local e = EffectData()
					e:SetOrigin( self:GetPos() + vector_up * 3 )
					e:SetMagnitude( math.random( 1000, 1100 ) )
				util.Effect( "refract_effect", e, nil, true )
						
				local ent = Entity(1)
						
				if ent and ent:Alive() then
							
					local k = ent:DoKnockdown( 2, true, self )
					if IsValid( k ) then
						k:SetRecoveryTime( 1 )
					end
							
					ent:SetGroundEntity( NULL )
					ent:SetLocalVelocity( self:GetForward() * 2000 )
						
				end
				
				if self.Maws then
					
					for k, v in pairs( pl.Maws ) do
						
						if v and v:IsValid() then
							v.RemoveByGame = true
							v:Remove()
						end
					
					end
					
				end
				
				
			
			end )
			
			self.NextAttack2 = CurTime() + 3
		
		end
		
	end

	
end

//time to override a lot of animation stuff
function CHARACTER:OverrideBodyUpdate( pl )
	
	pl.NextSequence = pl.NextSequence or 0
	local next_seq = 0
	
	local velocity = pl.loco:GetVelocity()
	
	local eye_ang = pl:EyeAngles()

	pl:SetPlaybackRate( 1 )
	
	local len2d = velocity:Length2D()
	
	local seq = "idle"
	
	if len2d > 150 then
		seq = "charge_loop"
	elseif len2d > 0.5 then
		seq = "sneak1"
	end

		if pl.IsGuarding then
			seq = "cover_loop"
			if len2d > 0.5 then
				seq = "cover_creep1"
			end
		end
	//end
	
	if pl.IntroAnim and pl.IntroAnim > CurTime() then
		//seq = "floor_break"
		//next_seq = CurTime() + 3.76
		//pl:SetSequence( "floor_break" )
	end
	
	local seq_id, seq_dur = pl:LookupSequence( seq )
	
	//print( "seq = "..seq, "   ", seq_dur )
		
	if pl.NextSequence < CurTime() then
	//if pl:GetSequence() == seq_id then return end

		pl:ResetSequence( seq )
	end
	//pl:SetCycle( 0 )
		
end

function CHARACTER:OnThink( pl )
	
	if pl.Doomed then return end
	
	pl.DontAttack = pl.Vulnerable and pl.Vulnerable > CurTime() or false
		
	local wep = IsValid( pl:GetActiveWeapon() ) and pl:GetActiveWeapon()
	
	if wep then
		wep.KnockoutPower = 9
		wep.KnockoutDuration = 2
		wep.KnockdownDamage = 0
		wep.NoDamage = pl.IsGuarding
	end
	
	pl.FreezeAim = pl.FreezeAimTime and pl.FreezeAimTime > CurTime() or false
	
	if pl.FreezeAim then
		if not pl.LookAt2 then
			pl.LookAt2 = Entity(1):GetPos()
		end
	else
		if pl.LookAt2 then
			pl.LookAt2 = nil
		end
	end
	
	if pl.LookAt2 then
		pl.loco:FaceTowards( pl.LookAt2 )
		pl.loco:FaceTowards( pl.LookAt2 )
		pl.loco:FaceTowards( pl.LookAt2 )
	else
		if Entity(1) then
			pl.loco:FaceTowards( Entity(1):GetPos() )
			pl.loco:FaceTowards( Entity(1):GetPos() )
			pl.loco:FaceTowards( Entity(1):GetPos() )
		end
	end
	
	
	if pl.Vulnerable and pl.Vulnerable > CurTime() then
		pl.WalkSpeed = 0
		pl.IdleSpeed = 0
		
		pl.NextAttack2 = CurTime() + 3		
		pl.NextSprint = CurTime() + 5
		pl.NextAttack = CurTime() + 3
		
		if pl:GetMaterial() ~= "models/spawn_effect2" then
			pl:SetMaterial( "models/spawn_effect2" )
			pl:SetColor( Color( 215, 0, 215 ) )
		end
		
		//pl.loco:SetMaxYawRate( 0 ) 
		
		if pl.IsGuarding then
					
			pl.IsGuarding = false
				
			//pl:SetMaterial("models/zombie_fast_players/fast_zombie_sheet" )
				
		end
		
		return
	else
		/*if pl.FreezeAimTime and pl.FreezeAimTime > CurTime() then
			pl.FreezeAim = true
		else
			if pl.FreezeAim then
				pl.FreezeAim = false
			end
		end*/
	end
	
	//pl.loco:SetMaxYawRate( 250 ) 
	
	if pl:GetMaterial() ~= "models/zombie_fast_players/fast_zombie_sheet" then
		pl:SetMaterial( "models/zombie_fast_players/fast_zombie_sheet" )
		pl:SetColor( Color( 255, 255, 255 ) )
	end
	
	if Entity(1):IsValid() and Entity(1):Alive() then
		
		//player has no weapon (aka fists equipped) - chase him
		if IsValid( Entity(1):GetActiveWeapon() ) and Entity(1):GetActiveWeapon():GetClass() == "sogm_fists" then
			
			if pl.VictimHasWeapon then
				pl.VictimHasWeapon = false
				pl.NextSprint = CurTime() + 7
			end
			
			pl.NextSprint = pl.NextSprint or CurTime() + 7
			pl.SprintDuration = pl.SprintDuration or 0
			
			if pl.IsGuarding then	
				pl.IsGuarding = false
				pl.GuardAnim = CurTime() + 1.2
				//pl:SetColor( Color( 255, 255, 255 ) )
				//pl:SetMaterial("models/zombie_fast_players/fast_zombie_sheet" )
			end
			
			
			if pl.NextSprint < CurTime() then
				pl.NextSprint = CurTime() + 10
				pl.SprintDuration = CurTime() + 7
			end
			
			
			//if pl.SprintDuration > CurTime() then
				pl.WalkSpeed = 450
				pl.IdleSpeed = 450
		//	else
		//		pl.WalkSpeed = 120
		//		pl.IdleSpeed = 120
		//	end
			
			if pl.GuardAnim and pl.GuardAnim > CurTime() then
				pl.WalkSpeed = 0
				pl.IdleSpeed = 0
			end
			
			if pl.NextSequence and pl.NextSequence > CurTime() then
				pl.WalkSpeed = 0
				pl.IdleSpeed = 0
			end
			
			pl.loco:SetAcceleration( pl.WalkSpeed ) 
			pl.loco:SetDeceleration( pl.WalkSpeed ) 
			
		//player has a weapon
		else
			
			if not pl.VictimHasWeapon then
				pl.VictimHasWeapon = true
				pl.NextAttack2 = CurTime() + 3
			end
			
			if Entity(1):GetPos():DistToSqr( pl:GetPos() ) < 150 * 150 then
				
				if not pl.IsGuarding then
					
					pl.IsGuarding = true
					pl.GuardAnim = CurTime() + 0.9
					
					
					pl.NextSprint = 0

				else
					if pl.NextAttack2 < CurTime() then
						if SERVER then
							pl:SlamAttack()
						end
						pl.NextAttackType = 1
					end
				end
				
			else
			
				if pl.IsGuarding then
					
					pl.IsGuarding = false
					pl.GuardAnim = CurTime() + 1.2
					
					pl.NextAttack2 = CurTime() + 3
					
					pl.NextSprint = 0//CurTime() + 5
					
					//pl:SetColor( Color( 255, 255, 255 ) )
					pl:SetMaterial("models/zombie_fast_players/fast_zombie_sheet" )
				
				end
				
				if !pl.IsGuarding and pl.NextAttack2 < CurTime() and Entity(1):GetPos():DistToSqr( pl:GetPos() ) < 600 * 600 then
					
					if pl.NextAttackType == 1 then
						if SERVER then
							pl:PukeAttack()
						end						
						if pl.Hits == 1 and not pl.DoSecondPuke then
							pl.DoSecondPuke = true
							pl.NextAttackType = 1
						else
							pl.NextAttackType = 2
						end
						
					else
						if SERVER then
							pl:ClawAttack()
						end
						pl.NextAttackType = 1
						pl.DoSecondPuke = false
					end
					
				end
			
			end
		
			if pl.IsGuarding then
				pl.WalkSpeed = 0
				pl.IdleSpeed = 0
			else
				pl.WalkSpeed = 90
				pl.IdleSpeed = 90
			end
			
			if pl.NextSequence and pl.NextSequence > CurTime() then
				pl.WalkSpeed = 0
				pl.IdleSpeed = 0
			end
			
			
			pl.loco:SetAcceleration( pl.WalkSpeed ) 
			pl.loco:SetDeceleration( pl.WalkSpeed )
		
		end
		
	end
	
end

function CHARACTER:OnMeleeHit( pl, hitpos, hitnormal, dir, attacker ) 
	
	if pl.Vulnerable and pl.Vulnerable > CurTime() then
		
		pl.Hits = pl.Hits - 1
		
		pl:ResetSequenceInfo()
		pl:ResetSequence( "charge_crash02" )
		pl:SetCycle( 0 )
		pl.NextSequence = CurTime() + 4
		
		pl:EmitSound( "npc/zombie_poison/pz_pain"..math.random( 2 )..".wav", 75, 115 )
		
		if pl.Hits == 0 then
		
			pl.Doomed = true
			
			if SERVER then
				pl:SetBehaviour( BEHAVIOUR_DUMB )
			end
			
			LASER_ATTACK_TARGET = pl
		
			//do destruction here
		end
		
		pl.Vulnerable = 0
		
		pl.FreezeAimTime = CurTime() + 4
		
		return true
	end

	return false
end

function CHARACTER:OnBulletHit( pl, hitpos, hitnormal, dir ) 
	
	

	return false
end