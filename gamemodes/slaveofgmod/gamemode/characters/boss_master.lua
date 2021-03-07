CHARACTER.Reference = "boss master"

CHARACTER.Name = "The Master"
CHARACTER.Description = ""

CHARACTER.Health = 100
CHARACTER.Speed = 0

CHARACTER.KnockdownImmunity = true
CHARACTER.NoPickups = true

CHARACTER.NoMenu = true

CHARACTER.Model = Model( "models/zombie/poison.mdl" )

CHARACTER.Icon = Material( "sog/horror.png" )

local warn = {
	Sound( "npc/zombie_poison/pz_throw2.wav" ),
	Sound( "npc/zombie_poison/pz_throw3.wav" ),
	
	Sound( "npc/zombie_poison/pz_warn1.wav" ),
	Sound( "npc/zombie_poison/pz_warn2.wav" ),
	
	Sound( "npc/zombie_poison/pz_alert1.wav" ),
	Sound( "npc/zombie_poison/pz_alert2.wav" ),
	
	Sound( "npc/zombie_poison/pz_pain1.wav" ),
	Sound( "npc/zombie_poison/pz_pain2.wav" ),
	Sound( "npc/zombie_poison/pz_pain3.wav" ),
	
	Sound( "npc/ichthyosaur/attack_growl3.wav" ),
}

game.AddDecal( "tear_master", "particle/warp2_warp" ) 


game.AddDecal( "tear_master_concrete1", "decals/plaster020a" )
game.AddDecal( "tear_master_concrete2", "decals/plaster016a" )
game.AddDecal( "tear_master_concrete3", "decals/plaster012a" ) 
game.AddDecal( "tear_master_concrete4", "decals/plaster006a" ) 
game.AddDecal( "tear_master_concrete5", "decals/plaster015a" )


//probably the only boss with bigger room for improvisation
local AttackPatterns = {
	
	//single claw
	[1] = function( self, target )
		target:EmitSound( warn[math.random(3,4)], 150, math.random(80, 100), 1, CHAN_STATIC )
		
		local pos = target:GetPos() + vector_up * 3
		timer.Simple( 0.7, function() 
			if self and self.ClawAttack then
				self:ClawAttack()
			end
		end)

	end,
	
	//double claw
	[2] = function( self, target )
		target:EmitSound( warn[math.random(1,2)], 150, math.random(80, 100), 1, CHAN_STATIC )
		
		local pos = target:GetPos() + vector_up * 3
		timer.Simple( 0.7, function() 
			if self and self.ClawAttack then
				pos = target:GetPos() + vector_up * 3
				self:ClawAttack()
			end
		end)
		timer.Simple( 0.7 * 2, function() 
			if self and self.ClawAttack then
				self:ClawAttack()
			end
		end)

	end,
	
	//bite
	[3] = function( self, target )
		target:EmitSound( warn[math.random(5,6)], 150, math.random(80, 100), 1, CHAN_STATIC )
		
		local pos = target:GetPos() + vector_up * 3
		timer.Simple( 1.1, function() 
			if self and self.BiteAttack then
				self:BiteAttack()
			end
		end)

	end,
	
	//claw, bite, claw
	[4] = function( self, target )
		target:EmitSound( warn[math.random(7,9)], 150, math.random(80, 100), 1, CHAN_STATIC )
		
		timer.Simple( 0.58, function() 
			if self and self.ClawAttack then
				self:ClawAttack()
			end
		end)
		
		timer.Simple( 0.58 * 2, function() 
			if self and self.BiteAttack then
				self:BiteAttack()
			end
		end)
		
		timer.Simple( 0.58 * 3, function() 
			if self and self.ClawAttack then
				self:ClawAttack()
			end
		end)

	end,
	
	//6 claws in a row
	[5] = function( self, target )
		target:EmitSound( warn[10], 150, math.random(80, 100), 1, CHAN_STATIC )
		
		for i=1, 6 do
			timer.Simple( 0.45 * i + 0.3, function() 
				if self and self.ClawAttack then
					self.usedmulclaws = true
					self:ClawAttack()
				end
			end)
		end
	end,

}

local server_pos = {
	Vector(-19.780737, -157.866180, 64.031250),//Vector(-559.968750, -163.255936, 64.031250),
	Vector(2624.930420, -122.064308, 64.031250),
	Vector(2196.874268, -804.467529, 64.031250),
}

function CHARACTER:OnSpawn( pl )
	
	pl.IdleAnim = "releasecrab"
	
	pl:SetBehaviour( BEHAVIOUR_DUMB )
	
	pl:SetModelScale( 5, 0 )

	local down = -30
	
	local bone = pl:LookupBone( "ValveBiped.Bip01" )
	if bone then
		pl:ManipulateBoneAngles( bone, Angle( 0, 0, -90 ) )
		pl:ManipulateBoneAngles( bone, Angle( 0, 0, -90 ) )
		pl:ManipulateBonePosition( bone, Vector( 0, 0, down))
	end
	
	pl:SetImmune( true )
	
	if SINGLEPLAYER then
		if game.GetMap() == "sog_apartments" then
			for i=1, 3 do
				local pr = ents.Create( "ent_master_server" )
				pr:SetPos( server_pos[i] - vector_up * 40 )
				pr:SetAngles( Angle( 0, 90, 0 ) )
				pr:Spawn()
				timer.Simple( 0.1, function()
					if Entity(1) and Entity(1):Alive() then
						Entity(1):AddArrow( pr, nil, true, true )
					end
				end )
			end
		else
			local points = POINT_SERVER
			if #points > 0 then
				for i=1, math.min( 3, #points ) do
					local v = points[i]
					local pr = ents.Create( "ent_master_server" )
					pr:SetPos( v:GetPos() )
					pr:Spawn()
				end
			end
		end
	end
	
	
	pl.ClawAttack = function( self )

		
		local target = Entity(1):IsValid() and Entity(1):Alive() and Entity(1)
		if target then
		
			local pos = target:GetPos() + vector_up * 3
			
			timer.Simple( 0.12, function() 
				if GAMEMODE:GetRoundState() == ROUNDSTATE_RESTARTING then return end
				if self and self:IsValid() and pos then
					local e = EffectData()
						e:SetOrigin( pos )
					util.Effect( "master_claw", e, true, true )
			
					util.BlastDamage( Entity(1), Entity(1), pos, 72, 9999 )
					//util.BlastDamage( game.GetWorld(), game.GetWorld(), pos, 73, 9999 )
				end
			end)
			
			//local dmginfo = DamageInfo()
			//util.BlastDamageInfo( CTakeDamageInfo dmg, target:GetPos() + vector_up * 3, 200 ) 
			
		end
	end
	
	pl.BiteAttack = function( self )

		local target = Entity(1):IsValid() and Entity(1):Alive() and Entity(1)
		if target then
		
			local pos = target:GetPos() + vector_up * 3
			
			timer.Simple( 0.2, function() 
				if GAMEMODE:GetRoundState() == ROUNDSTATE_RESTARTING then return end
				if self and self:IsValid() and pos then
					local e = EffectData()
						e:SetOrigin( pos )
					util.Effect( "master_bite", e, true, true )
			
					util.BlastDamage( Entity(1), Entity(1), pos, 90, 9999 )
					//util.BlastDamage( game.GetWorld(), game.GetWorld(), pos, 90, 9999 )
				end
			end)
			
		end
	end
	
	pl.OnThink = function( self )
	
		if !SINGLEPLAYER then return end
		if CUR_DIALOGUE then return end
		if GAMEMODE:GetRoundState() == ROUNDSTATE_RESTARTING then return end
	
		self.NextClaw = self.NextClaw or CurTime() + math.random(1,5)//8
		
		local target = Entity(1):IsValid() and Entity(1):Alive() and Entity(1)
		
		if target then
			if self.NextClaw < CurTime() then
				
				if MASTER_SERVERS_COUNT == 3 then
					AttackPatterns[math.random(1,3)]( self, target )
				elseif MASTER_SERVERS_COUNT < 3 then
					local rand = self.usedmulclaws and 4 or math.random( 4, 5 )
					if rand == 4 then
						self.usedmulclaws = false
					end
					AttackPatterns[rand]( self, target )
				end
				
				//AttackPatterns[math.random(5)]( self, target )
								
				self.NextClaw = CurTime() + 6 - (3 - MASTER_SERVERS_COUNT)
			end
		end
	
	end
	

end

local duration = 2

function CHARACTER:OnBodyUpdate( pl )
	
	pl.NextSeq = pl.NextSeq or CurTime() + duration
	
	if pl.NextSeq <= CurTime() then
		pl.NextSeq = CurTime() + duration
	end
	
	//local cycle = math.Clamp( 1 - ( pl.NextSeq - CurTime() ) / duration, 0, 1 )
	local cycle = math.sin( RealTime() * 0.6 ) * 0.02
	
	pl:SetSequence("releasecrab")
	pl:SetCycle( 0.63 + cycle )
	
end

function CHARACTER:OnMeleeHit( pl, hitpos, hitnormal, dir, attacker ) 
	return false
end