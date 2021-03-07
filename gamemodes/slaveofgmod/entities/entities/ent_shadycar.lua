AddCSLuaFile()

ENT.Type = "anim"
ENT.RenderGroup = RENDERGROUP_BOTH 

local mins = Vector(-318, -318, -318)
local maxs = Vector(318, 318, 318)

ENT.CarModel = Model( "models/props/de_nuke/car_nuke_black.mdl" )

util.PrecacheSound( "vehicles/v8/v8_idle_loop1.wav" )
util.PrecacheSound( "vehicles/v8/v8_turbo_on_loop1.wav" )
util.PrecacheSound( "vehicles/chopper_rotor2.wav" )
util.PrecacheSound( "vehicles/v8/v8_firstgear_rev_loop1.wav" )
util.PrecacheSound( "npc/barnacle/barnacle_die1.wav" )
util.PrecacheSound( "ambient/voices/citizen_beaten2.wav" )
for i=1,4 do
	util.PrecacheSound( "physics/flesh/flesh_squishy_impact_hard"..i..".wav" )
end

for i=2,4 do
	util.PrecacheSound( "physics/body/body_medium_break"..i..".wav" )
end

local friction_snds = {
	Sound( "vehicles/v8/skid_highfriction.wav" ),
	Sound( "vehicles/v8/skid_lowfriction.wav" ),
	Sound( "vehicles/v8/skid_normalfriction.wav" )
}

local flip_snds = {
	Sound( "vehicles/v8/vehicle_rollover1.wav" ),
	Sound( "vehicles/v8/vehicle_rollover2.wav" )
}

local car_gibs = {
	Model( "models/props_junk/Wheebarrow01a.mdl" ),
	Model( "models/props_vehicles/carparts_door01a.mdl" ),
	Model( "models/props_vehicles/carparts_axel01a.mdl" ),
	Model( "models/props_c17/TrapPropeller_Engine.mdl" ),
	Model( "models/props_vehicles/carparts_muffler01a.mdl" ),
	Model( "models/props_vehicles/carparts_wheel01a.mdl" ),
}

local right_light_offset = Vector( 23, 97, 29 )
local left_light_offset = Vector( -23, 97, 29 )

local driver_model = Model( "models/player/breen.mdl" )

local driver_stuff = {
	[1] = { vec = Vector( -13, 3, 24 ), ang = Angle( -9, 92, -6 ) }, //normal
	[2] = { vec = Vector( -19, 11, 35 ), ang = Angle( -1, 112, -45 ) }, //puke
}

ENT.Hits = 2

ENT.Taunts = {
	"fuck yoouu", "time to die", "run boy", "stand still", "die already", "vroom"
}

ENT.WheelModel = Model( "models/props_vehicles/carparts_wheel01a.mdl" )

ENT.WheelData = {
	[1] = { vec = Vector( -33, 60, 13 ), ang = Angle( 0, -90, 0 ) },
	[2] = { vec = Vector( -33, -53, 13 ), ang = Angle( 0, -90, 0 ) },
	[3] = { vec = Vector( 33, -53, 13 ), ang = Angle( 0, -90, 0 ) },
	[4] = { vec = Vector( 33, 60, 13 ), ang = Angle( 0, -90, 0 ) },
}

ENT.EngineData = { vec = Vector( 2.092062, 66.718636, 43.668175 ), ang = Angle( -90, -90, 0 ) }

ENT.NeonLightModel = Model( "models/props_c17/gasmeterpipes001a.mdl" )
ENT.NeonData = { vec = Vector( 3.670169, 1.505371, 7.439925 ), ang = Angle( 90, -90, 0 ) }


function ENT:Initialize()

	self:SetModel( self.CarModel )
	
	if SERVER then
		
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetCollisionGroup( COLLISION_GROUP_PLAYER )
		self:SetSolid( SOLID_VPHYSICS )
		self:PhysicsInit( SOLID_VPHYSICS )
				
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
			phys:SetMaterial( "metalvehicle" )
			phys:SetMass( 3000 )
			//phys:EnableDrag( true )
			//print( phys:GetDamping())
			phys:SetDamping( 0, 1 )
			//constraint.Keepupright( self, phys:GetAngles(), 0, 999999 ) 
		end

		self.EngineSound = CreateSound( self, "vehicles/v8/v8_idle_loop1.wav" )
		self.GasSound = CreateSound( self, "vehicles/v8/v8_firstgear_rev_loop1.wav" )
		self.TurboSound = CreateSound( self, "vehicles/v8/v8_turbo_on_loop1.wav" )
		self.RotorSound = CreateSound( self, "vehicles/chopper_rotor2.wav" )
		self.YellSound = CreateSound( self, "vo/npc/male01/stopitfm.wav" )
		
		self:CreateLight( 1 )
		self:CreateLight( 2 )
		
		local light1, light2 = self:GetLight( 1 ), self:GetLight( 2 )
	
		if light1 and light1:IsValid() then
			light1:SetPos( self:LocalToWorld( right_light_offset ) )	
			light1:SetAngles( ( self:GetRight() * -1 ):Angle() ) 
			light1:SetParent( self )
		end
		
		if light2 and light2:IsValid() then
			light2:SetPos( self:LocalToWorld( left_light_offset ) )	
			light2:SetAngles( ( self:GetRight() * -1 ):Angle() ) 
			light2:SetParent( self )
		end
		
		self:CreateGlass()
		self:CreateEngineAndStuff()
		self:CreateWheels()
		
		self.AllowCrushDamage = true
		
		if not BIG_SERVER_MEN_FIRST_CAR then
			local e = EffectData()
				e:SetOrigin( self:LocalToWorld( self:OBBCenter() ) )
				e:SetScale( 10 )
			util.Effect( "Explosion", e, nil, true )
			BIG_SERVER_MEN_FIRST_CAR = true
		end

	end
	
	if CLIENT then
		self:SetRenderBounds( mins, maxs )
		
		self:CreateMrCoolBoy()		
	end
	
	
end

function ENT:CreateMrCoolBoy()
	
	self.Driver = ClientsideModel( driver_model, RENDERGROUP_BOTH )
	if self.Driver then
		self.Driver:SetPos( self:GetPos() )
		self.Driver:SetAngles( self:GetAngles() )
		self.Driver:SetParent( self )
		self.Driver:SetNoDraw( true )

		local seq = self.Driver:LookupSequence( "sit_duel" )
		self.Driver:SetSequence( seq )
		
		self.Driver.GetPlayerColor = function() return Vector( 20 / 255, 20 / 255, 20 / 255 ) end
		
	end
end

function ENT:RemoveMrCoolBoy()
	if self.Driver and self.Driver:IsValid() then
		self.Driver:Remove()
	end
end

function ENT:CreateGlass()
	
	local ent = ents.Create("prop_dynamic")
	ent:SetModel( "models/props/de_nuke/car_nuke_glass.mdl" )
	ent:SetPos( self:GetPos() )
	ent:SetAngles( self:GetAngles() )
	ent:SetSolid( SOLID_NONE )
	ent:SetParent( self )
	ent:Spawn()
		
	ent:SetColor( Color( 100, 100, 100, 255 ) )
	
	self.Glass = ent
	
	self:DeleteOnRemove( ent )
	
end

function ENT:CreateEngineAndStuff()
	
	/*local ent = ents.Create("prop_dynamic")
	ent:SetModel( "models/props_c17/TrapPropeller_Engine.mdl" )
	ent:SetPos( self:LocalToWorld( self.EngineData.vec ) )
	ent:SetAngles( self:LocalToWorldAngles( self.EngineData.ang ) )
	ent:SetSolid( SOLID_NONE )
	ent:SetParent( self )
	ent:Spawn()
	
	self:DeleteOnRemove( ent )*/
	
	local ent = ents.Create("prop_dynamic")
	ent:SetModel( self.NeonLightModel )
	ent:SetPos( self:LocalToWorld( self.NeonData.vec ) )
	ent:SetAngles( self:LocalToWorldAngles( self.NeonData.ang ) )
	ent:SetSolid( SOLID_NONE )
	ent:SetParent( self )
	ent:SetMaterial( "models/shiny" )
	ent:Spawn()
	
	self:DeleteOnRemove( ent )
	
end

//ugh
function ENT:CreateWheels()
	
	self.Wheels = {}
	
	for i=1, 4 do
		local tbl = self.WheelData[ i ]
		
		local p = ents.Create( "prop_physics" )
		p:SetModel( self.WheelModel )
		p:SetPos( self:LocalToWorld( tbl.vec ) )
		p:SetAngles( self:LocalToWorldAngles( tbl.ang ) )
		p:Spawn()
		
		p:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
		
		
		local phys = p:GetPhysicsObject()
		
		if phys:IsValid() then

			local new_offset = Vector( tbl.vec.x, tbl.vec.y, tbl.vec.z )
			new_offset.x = new_offset.x + 5
			
			constraint.Axis( p, self.Entity, 0, 0, p:OBBCenter(), new_offset, 0, 0, 35, 1 ) 
		
			phys:Wake()
		end
		
		self.Wheels[ i ] = p
		
		self:DeleteOnRemove( p )
		
	end
	
end

function ENT:CreateLight( ind )
	
	local ent = ents.Create("env_projectedtexture")
	if ent:IsValid() then
		ent:SetLocalPos( Vector(16000, 16000, 16000) )
		ent:SetKeyValue("enableshadows", 1)
		ent:SetKeyValue("farz", 348)
		ent:SetKeyValue("nearz", 1)
		ent:SetKeyValue("lightfov", 110)
		ent:SetKeyValue("lightcolor", "115 115 255 255")
		ent:Spawn()
		ent:Input("SpotlightTexture", NULL, NULL, "effects/flashlight001")
		
		self:DeleteOnRemove( ent )

		self:SetDTEntity( ind, ent )
	end
	
end

function ENT:SetShowDamage( bl )
	self:SetDTBool( 0, bl )
end

function ENT:ShouldShowDamage()
	return self:GetDTBool( 0 )
end

function ENT:GetLight( ind )
	return self:GetDTEntity( ind )
end

function ENT:SetVulnerableTime( time )
	self:SetDTFloat( 0, time )
end

function ENT:GetVulnerableTime()
	return self:GetDTFloat( 0 )
end

function ENT:IsVulnerable()
	return self:GetVulnerableTime() > CurTime()
end

function ENT:Think()

	if SERVER then
		
		local owner = self:GetOwner()
		
		if owner and owner:IsValid() then
		
			if self:GetDestroyTime() < CurTime() and self:GetDestroyTime() ~= 0 and not self.DoDebris then
				self:RealDeath()
				return
			end
			
			if self.Dead then return end
			if owner:GetBehaviour() == BEHAVIOUR_DUMB then return end
			
			/*if CUR_STAGE == 2 or CUR_STAGE == 3 and not CUR_DIALOGUE then
				if Entity(1):IsValid() and Entity(1):Alive() then
					self.NextTaunt = self.NextTaunt or CurTime() + 3
					if self.NextTaunt < CurTime() then
						Entity(1):AddScoreMessage( self.Taunts[ math.random( #self.Taunts ) ], self:GetPos() + VectorRand() * 5, math.Rand( 1, 1.5 ) )
						self.NextTaunt = CurTime() + math.Rand( 8, 14 )
					end
				end
			end*/
		
			if self.CheckForStop then
				if self:GetVelocity():Length() < 10 then
					self:SetVulnerableTime( CurTime() + 2 )
					self.VulnerableHit = true
					self.NextMove = CurTime() + 3
					self.CheckForStop = false
					self.NextCharge = CurTime() + math.random( 8, 10 )//math.random( 8, 10 )
					self:EmitSound( "npc/barnacle/barnacle_die1.wav", 55, 110 )
					self:EmitSound( "ambient/voices/citizen_beaten2.wav", 120, math.random( 60, 75 ) )
				else
					self.NextMove = CurTime() + 2
					self.FlipCooldown = CurTime() + 3
					self.NextCharge = CurTime() + math.random( 4, 6 )//math.random( 8, 10 )
				end
			end
		
			if self.EngineSound then
				self.EngineSound:PlayEx( 1, math.Clamp( 20 * ( self:GetVelocity():Length2D() / 300 ), 90, 110 ) )
			end
			
			if self.GasSound then
				//self.GasSound:PlayEx( math.Clamp( self:GetVelocity():Length2D() / 300, 0, 0.7 ), 100 )
			end
		
			self.NextMove = self.NextMove or 0
			
			self.NextCharge = self.NextCharge or CurTime() + 3
			
			//self.TornadoChance = math.random( 3 ) == 1
			
			self.TargetCharge = self.Hits == 2 and 2 or 3
			
			self.CurAttack = self.CurAttack or 1
			
			local path = owner.PathObject
			
			local charge = true
			
			if path and path:GetEnd() then
				if self:GetPos():Distance( path:GetEnd() ) > 300 then
					charge = false
				end
			end
			
			local light1, light2 = self:GetLight( 1 ), self:GetLight( 2 )
			
			if ( self.NextCharge - 1.5 ) < CurTime() and charge then //and self.CurAttack ~= self.TargetCharge
				if light1 and light2 then
					if self.CurAttack == self.TargetCharge then
						light1:SetKeyValue("lightcolor", "245 245 0 255")
						light2:SetKeyValue("lightcolor", "245 245 0 255")
					else
						light1:SetKeyValue("lightcolor", "245 0 0 255")
						light2:SetKeyValue("lightcolor", "245 0 0 255")
					end
				end
			else
				if light1 and light2 then
					light1:SetKeyValue("lightcolor", "115 115 255 255")
					light2:SetKeyValue("lightcolor", "115 115 255 255")
				end
			end
			
			
			if self.NextCharge < CurTime() and charge then

				
				if self.CurAttack == self.TargetCharge then
					self.TornadoChance = true
					//self.CurAttack = 0
				else	
					self.TornadoChance = false
				end
			
				self.NextCharge = CurTime() + math.random( 8, 10 )
				self.Charge = true
				
				if self.TornadoChance then
					self.TornadoTime = CurTime() + 2
				end
				
			end
			
			if self.YellSound then
				if self.PlayStopSound and self.PlayStopSound > CurTime() then
					self.YellSound:PlayEx( 1, 110 )
				else
					self.YellSound:Stop()
				end
			end
			
			
			if self.ChargeSound and self.TurboSound then
				if self.ChargeSound > CurTime() then
					self.TurboSound:Play()
					self.PlayingTurbo1 = true
				else
					self.TurboSound:Stop()
					if self.PlayingTurbo1 then
						self:EmitSound( friction_snds[ math.random( 1, #friction_snds ) ] )
						self.PlayingTurbo1 = false
					end
				end
			end
			
			if self.ChargeSoundRotor then
				if self.ChargeSoundRotor > CurTime() then
					self.RotorSound:PlayEx( 0.8, 110 )
					self.PlayingTurbo2 = true
				else
					self.RotorSound:Stop()
					if self.PlayingTurbo2 then
						self:EmitSound( friction_snds[ math.random( 1, #friction_snds ) ] )
						self.PlayingTurbo2 = false
						//self:SetVulnerableTime( CurTime() + 2 )
						//self.VulnerableHit = true
						//self.NextMove = CurTime() + 2
						self.CheckForStop = true
					end
				end
				
			end
			
			if self.VulnerableHit and not self:IsVulnerable() then
				self.VulnerableHit = false
			end
			
			owner:SetPos( self:LocalToWorld( self:OBBCenter() ) )	
			
			
			if self.NextMove <= CurTime() then
					
			self.NextMove = CurTime() + ( self.Charge and not self.TornadoChance and 2 or 0 )
			
			/*if self.Charge and self.TornadoChance then
				self.NextMove = CurTime() + 6
			end*/
			
			
			local path = owner.PathObject
				
			if path then
					
				local first_seg = path:FirstSegment()
					
					
				if first_seg then
				
						local forw = first_seg.forward
						local goal_pos = first_seg.pos
						
							
						local phys = self:GetPhysicsObject()
						
						if phys and phys:IsValid() then
						
						
							if self:IsBeingDestroyed() then
								phys:Wake()	
								
								phys:AddAngleVelocity( vector_up * 70 )
								phys:AddAngleVelocity( self:GetRight() * 70 )
								
								self.NextScream = self.NextScream or 0
								
								if self.NextScream < CurTime() then
									self:EmitSound( "vo/npc/male01/pain0"..math.random( 7, 9 )..".wav", 100, 110 )
									self.NextScream = CurTime() + 0.7
								end
								
								
							else
								forw = forw:Angle()
								forw.p = 0							
								forw = forw:Forward()
							
								local ang_fixed = forw:Angle()
							
								//ang_fixed:RotateAroundAxis( vector_up, -90 )
								//ang_fixed:RotateAroundAxis( forw:Angle():Right(), 5 )
								
								phys:Wake()	
															
								local car_ang = self:GetAngles()
								
								local car_forw = -1 * self:GetAngles():Right()
								local car_right = car_forw:Angle():Right()
								local car_up = car_forw:Angle():Up()
								
								local car_yaw = car_forw:Angle().y
								local goal_yaw = ang_fixed.y
								
								local yaw_diff = math.NormalizeAngle( goal_yaw - car_yaw )
								local yaw_diff_abs = math.abs( yaw_diff )
								
								
								
								local car_roll = car_up:Angle()
								
								local check_up = self:GetUp():Angle().p						
								
								//make sure it wont flip upside down
								//local dot2 = ( self:GetUp() ):Dot( vector_up )
								
								//local roll_diff = 270 - car_roll //math.NormalizeAngle( 270 - car_roll )
								//local roll_diff_abs = math.abs( roll_diff )
								
								//print( roll_diff )
								
								local tornado = false
								
								if self.TornadoTime and self.TornadoTime > CurTime() then
									tornado = true
								end
								
								local flipped = false
								
								self.FlipCooldown = self.FlipCooldown or 0
								self.FlipDir = self.FlipDir or 1
								
								if self.FlipCooldown < CurTime() and ( self:GetVelocity():Length() < 40 or self:GetVelocity():Length() > 290 ) and not tornado and not self.CheckForStop then
									//if dot2 < 0.5 then
										//if check_up < 180 or check_up > 360 then
										if check_up < 110 or check_up > 430 then
										
										local power = 1//math.abs( 1 - dot2 )
										//phys:AddAngleVelocity( self:GetAngles():Forward() * 1300 * self.FlipDir * power )
										
										local fix_ang = self:GetUp():Angle()
										fix_ang.p = 0
										//fix_ang.y = 0
										//fix_ang.r = 0
										
										
										self:SetAngles( fix_ang )
										
										
										self.FlipDir = self.FlipDir * -1
										//flipped = true
										self.FlipCooldown = CurTime() + 1//3
										
										self:EmitSound( flip_snds[ math.random( 1, #flip_snds ) ] )
										
										if not self.Charge then
											self.NextCharge = CurTime() + math.random( 4, 6 )//math.random( 8, 10 )
										end
									end
								end
									
								
								
								if not flipped and self.FlipCooldown < CurTime() and not tornado then
								
									local turn_power = 20
								
									if ( self.NextCharge - 1.5 ) < CurTime() and charge then
										turn_power = 10
									end
				
									if yaw_diff_abs > 15 then
										local dir = yaw_diff > 0 and 1 or -1
										local power = math.Clamp( yaw_diff_abs/40, 0.1, 1 )
										phys:AddAngleVelocity( self:GetAngles():Up() * turn_power * dir * power ) 
									end
									
									
								end
								
								
								if tornado then
									phys:AddAngleVelocity( vector_up * 90 )
								end
															
								//local acceleration = self.Charge and 760000 or 120000
								
								local acceleration = self.Charge and 2000 or 330//220
								
								if self.Charge and tornado then
									acceleration = 5500 //2500
								end
								
								if self.Charge and !tornado then
									forw = car_forw * 1
								end
								

								if not flipped and self.FlipCooldown < CurTime() then
									
									//phys:SetVelocityInstantaneous( forw * acceleration + vector_up * 3 ) 
									
									//forw = forw:Angle()
									//forw:RotateAroundAxis( car_right, 1 )
									//forw = forw:Forward()
									
									phys:SetVelocityInstantaneous( forw * acceleration )
									
									if self.Charge then
										self.Charge = false
										
										self.CurAttack = self.CurAttack + 1
										
										if self.CurAttack > self.TargetCharge then
											self.CurAttack = 1
										end
										
										if self.TornadoChance then
											//self:EmitSound( "vehicles/v8/vehicle_rollover2.wav", 75, 90 )
											self.ChargeSoundRotor = CurTime() + 3
										else	
											self.ChargeSound = CurTime() + 1
										end
									end	
								end	
							end
								
						end
					end
				end
					
			end
		
		end
		
	end
	
	self:NextThink( CurTime() )
	
	return true

end

function ENT:PhysicsCollide(data, phys)
	
	if data.HitEntity and data.HitEntity:IsValid() then
		
		if data.HitEntity:IsPlayer() and data.Speed > 1000 and self.AllowCrushDamage then
			self:EmitSound( "physics/body/body_medium_break"..math.random( 2, 4 )..".wav", 75, 90 )
		end
	
	end
	
end

function ENT:OnTakeDamage( dmginfo )
	
	local attacker = dmginfo:GetAttacker()
	local inflictor = dmginfo:GetInflictor()
	
	if self:IsBeingDestroyed() then return end
	
	if IsValid( attacker ) and attacker:IsPlayer() and attacker:Team() == TEAM_PLAYER and inflictor and not inflictor:IsPlayer() then
	
		if self:IsVulnerable() then
			
			if self.VulnerableHit then
				self:EmitSound( "physics/metal/metal_box_break"..math.random( 2 )..".wav", 65, 90 )
				//self:EmitSound( "vo/npc/male01/pain0"..math.random( 7, 9 )..".wav", 100, 110 )
				
				if math.random( 2 ) == 2 then
					self.PlayStopSound = CurTime() + 0.45
				else
					self:EmitSound( "vo/npc/male01/watchwhat.wav", 100, 110 )
				end
				
				self.VulnerableHit = false
				
				self.Hits = self.Hits - 1
				
				self:SetShowDamage( true )
				
				if self.Glass then
					//self.Glass:SetMaterial( "metal/metalpipe009b" )
					//self.Glass:SetColor( Color( 110, 110, 110, 255 ) )
				end
				
				if self.Hits <= 0 then
					self:DoDestroy()
				end
				
			end
			
		else
			
			if math.random( 5 ) ~= 5 then
				if math.random( 2 ) == 2 then
					self:EmitSound( "vo/npc/male01/hi0"..math.random( 2 )..".wav", 70, 110 )
				else
					self:EmitSound( "vo/npc/male01/heydoc0"..math.random( 2 )..".wav", 70, 110 )
				end
			else
				self:EmitSound( "vo/npc/male01/question05.wav", 70, 110 )
			end
			
			
			local e = EffectData()
				e:SetOrigin( dmginfo:GetDamagePosition() )
				e:SetNormal( dmginfo:GetDamageForce():GetNormal() * -1 )
				e:SetScale( 2 )
			util.Effect( "StunstickImpact", e, nil, true )
			
			self:EmitSound( "physics/metal/metal_box_impact_bullet"..math.random(3)..".wav" )
			
		end
	
	end
	
	
end

function ENT:SetDestroyTime( time )
	self:SetDTFloat( 1, time )
end

function ENT:GetDestroyTime()
	return self:GetDTFloat( 1 )
end

function ENT:IsBeingDestroyed()
	return self:GetDestroyTime() > CurTime()
end

function ENT:DoDestroy()
	
	self.AllowCrushDamage = false
	self.NextMove = 0
	self.NextCharge = CurTime() + 99999
	self:SetDestroyTime( CurTime() + 6 )
	
end

function ENT:RealDeath()

	local owner = self:GetOwner()
	
	if owner and owner:IsValid() then
		
		self.DoDebris = true
		self.Dead = true
		
		self:EmitSound( "vo/npc/male01/myleg0"..math.random(2)..".wav", 100, 110 )
		
		owner:TakeDamage( 99999, Entity(1), Entity(1) )
		
		local e = EffectData()
			e:SetEntity( self )
			e:SetOrigin( self:LocalToWorld( self:OBBCenter() ) )
		util.Effect( "car_destroy", e, nil, true )
		
		self:EmitSound("ambient/explosions/explode_"..math.random(4)..".wav")
		
		if self.Wheels then
			for i=1, 4 do
				local w = self.Wheels[ i ]
				if w and w:IsValid() then
					constraint.RemoveConstraints( w, "Axis" )
					
					//w:Fire( "kill", "", 5 )
					
				end
			end
		end
		
	end
	
end


function ENT:OnRemove()
	if SERVER then
		if self.EngineSound then
			self.EngineSound:Stop()
		end
		if self.GasSound then
			self.GasSound:Stop()
		end
		if self.TurboSound then
			self.TurboSound:Stop()
		end
		if self.RotorSound then
			self.RotorSound:Stop()
		end
		if self.YellSound then
			self.YellSound:Stop()
		end
	end
	if CLIENT then
		self:RemoveMrCoolBoy()
		
		if self.DoGibsOnRemove then
			/*local e = EffectData()
				e:SetOrigin( self:LocalToWorld( self:OBBCenter() ) )
			util.Effect( "car_destroy", e )*/
		end
		
	end
end

if CLIENT then
local glass = Model( "models/props/de_nuke/car_nuke_glass.mdl" )
local smoke_offset = Vector( -24, -84, 10 )
local driver_delta = 0

local function CollideCallback(particle, hitpos, hitnormal)

	util.Decal(math.random(5) == 5 and "Impact.Antlion" or "YellowBlood", hitpos + hitnormal, hitpos - hitnormal)
	
	if math.random(1, 8) == 5 then
		sound.Play("physics/flesh/flesh_squishy_impact_hard"..math.random(4)..".wav", hitpos, 100, math.random(95, 125))
	end
	
	particle:SetBounce( math.Rand(0.01, 0.02) )
	local vel = particle.StartVelocity
	particle:SetVelocity( vel * math.Rand(4,9) + VectorRand() * 200 )
	if particle.Hits < particle.MaxHits then
		particle.Hits = particle.Hits + 1
	else
		particle:SetDieTime(0)
	end	
	
end

function ENT:DrawMrCoolBoy()
	
	if self.Driver and self.Driver:IsValid() then
	
		driver_delta = math.Approach( driver_delta, self:IsVulnerable() and 1 or 0, FrameTime() * 2 )
		
		local lerp_pos = LerpVector( driver_delta, driver_stuff[ 1 ].vec, driver_stuff[ 2 ].vec ) 
		local lerp_ang = LerpAngle( driver_delta, driver_stuff[ 1 ].ang, driver_stuff[ 2 ].ang ) 
	
		//local pos, ang = driver_stuff[ 1 ].vec, driver_stuff[ 1 ].ang
		
		if lerp_pos and lerp_ang then
		
			local l_pos = self:LocalToWorld( lerp_pos )
			local l_ang = self:LocalToWorldAngles( lerp_ang )
		
			self.Driver:SetPos( l_pos )
			self.Driver:SetAngles( l_ang )
			
			self.Driver:DrawModel()
		end
		
		
		if self:IsVulnerable() or self:IsBeingDestroyed() then
			
			local bone = self.Driver:LookupBone( "ValveBiped.Bip01_Head1" )
			if bone then
			
				local pos, ang = self.Driver:GetBonePosition( bone )
				
				if pos and ang then
					
					self.NextPuke = self.NextPuke or 0
					
					if self.NextPuke < CurTime() then
					
						self.NextPuke = CurTime() + 0.1
					
						local emitter = ParticleEmitter( pos )
						
							local particle = emitter:Add( math.random(2) == 2 and "Decals/alienflesh/shot"..math.random(5) or "Decals/yblood"..math.random(6), pos )
							particle:SetVelocity( VectorRand() * 15 + ang:Forward() * 60 )
							particle:SetDieTime( 1 )
							particle:SetStartAlpha( 250 )
							particle:SetStartSize( 3 )
							particle:SetEndSize( math.random(3,5) )
							particle:SetRoll(math.random(-180, 180))
							particle:SetColor(255, 255, 255)
							particle:SetLighting(true)
							particle:SetCollide(true)
							particle:SetAirResistance(16)
							particle:SetGravity( vector_up * -1900 )
							particle:SetCollideCallback(CollideCallback)
							particle.StartVelocity = particle:GetVelocity()
							particle.Hits = 0
							particle.MaxHits = math.random(0,15)
						
						emitter:Finish()
					
					end
					
				end
			end
		end
		
		
	end
	
end

function ENT:DrawNeon()

	local realtime = RealTime()
	
	local r = 0.5 * math.sin(realtime)*255 + 255/2
	local g = -0.5 * math.sin(realtime)*255 + 255/2
	local b = 210

	local dlight = DynamicLight( self:EntIndex() )
	if dlight then
		dlight.pos = self:GetPos() - self:GetUp() * 5
		dlight.r = r
		dlight.g = g
		dlight.b = b
		dlight.brightness = 5
		dlight.Decay = 1000
		dlight.Size = 236
		dlight.DieTime = CurTime() + 1
	end
end

local damage_mat = Material( "models/flesh" ) //I know, that doesn't really makes any sense, but at least it looks somewhat decent
function ENT:Draw()
	
	self:SetModel( self.CarModel )
	
	self.NextSmoke = self.NextSmoke or 0
		
	if self.NextSmoke < CurTime() then
	
		local emitter = ParticleEmitter( self:GetPos() )
		
		local particle = emitter:Add( "particles/smokey", self:LocalToWorld( smoke_offset ) )
			particle:SetVelocity( math.Rand(25, 68.7) * self:GetRight() + VectorRand() * 2 + vector_up * math.random( 10 ) )
			particle:SetDieTime( math.Rand(0.5, 4) )
			particle:SetStartAlpha( 100 )
			particle:SetEndAlpha(0)
			particle:SetStartSize( math.random(2,4) )
			particle:SetEndSize( math.random(13,23) )
			particle:SetRoll( math.Rand(-180, 180) )
			particle:SetColor( 100, 100, 100 )
			particle:SetAirResistance( 15 )
				
		if self:ShouldShowDamage() then
			
			local particle = emitter:Add( "particles/smokey", self:LocalToWorld( self.EngineData.vec ) + VectorRand() * 10 )
			particle:SetVelocity( VectorRand() * 10 + vector_up * math.random( 40 ) )
			particle:SetDieTime( math.Rand(0.5, 1) )
			particle:SetStartAlpha( 180 )
			particle:SetEndAlpha(0)
			particle:SetStartSize( math.random(20,30) )
			particle:SetEndSize( math.random(43,53) )
			particle:SetRoll( math.Rand(-180, 180) )
			particle:SetColor( 15, 15, 15 )
			particle:SetAirResistance( 5 )
			
		end
				
		self.NextSmoke = CurTime() + math.Rand( 0.05, 0.1 )
		
		emitter:Finish()
	end
	
	self:DrawMrCoolBoy()
	
	self:DrawModel()
	
	if self:ShouldShowDamage() then	
		self:SetupBones()
		
		render.MaterialOverride( damage_mat )
		render.SetBlend( 0.9 )
		render.SetColorModulation( 0.2, 0.2, 0.2 )
			self:DrawModel()
		render.SetColorModulation( 1, 1, 1 )
		render.SetBlend( 1 )
		render.MaterialOverride()
		
	end
	
	if self:IsBeingDestroyed() then
	
		self.DoGibsOnRemove = true
		
		self.NextBoom = self.NextBoom or 0
		
		if self.NextBoom < CurTime() then
			
			self.NextBoom = CurTime() + 0.4
			
			local e = EffectData()
				e:SetOrigin( self:LocalToWorld( self:OBBCenter() + VectorRand() * 25 ) )
				e:SetScale( math.Rand( 1, 2 ) )
			util.Effect( "Explosion", e, nil, true )
			
		end
		
	end
	
	self:DrawNeon()

end



effects.Register(
            {
                Init = function(self, data)
				
					self.ent = data:GetEntity()
                    local pos = data:GetOrigin()
					local norm = data:GetNormal()
					
										
					local car = IsValid(self.ent) and self.ent
					
					if car and car:IsValid() then
						car:AddEffects( EF_NODRAW )
						for k, v in pairs( car:GetChildren() ) do
							if v and v:IsValid() then
								v:AddEffects( EF_NODRAW )
							end
						end
					end
										
					//self.Entity:EmitSound( "physics/flesh/flesh_bloody_break.wav" )
					
					for i = 1, #car_gibs do
						local e = EffectData()
							e:SetOrigin( pos + vector_up * 10 + VectorRand() * 15 )
							e:SetScale( i )
						util.Effect( "car_gib", e )
					end	

					local e = EffectData()
						e:SetOrigin( pos )
						e:SetNormal( vector_origin )
					util.Effect( "explosion_huge", e )
					
                end,
 
                Think = function() end,
 
                Render = function(self) end
            },
 
			"car_destroy"
)

effects.Register(
            {
                Init = function(self, data)
				
						local modelid = math.Round(data:GetScale()) or math.random( #car_gibs )
						self.Entity:SetModel(car_gibs[ modelid ])

						self.Entity:PhysicsInit( SOLID_VPHYSICS )
						self.Entity:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
						self.Entity:SetCollisionBounds( Vector( -128 -128, -128 ), Vector( 128, 128, 128 ) )
						
						local dir = VectorRand()
						local power = math.random( 800, 1200 )
													
						local phys = self.Entity:GetPhysicsObject()
						if ( phys && phys:IsValid() ) then
							phys:Wake()
							phys:SetMass( 1 )
							phys:SetMaterial("metalvehicle")
							phys:SetAngles( VectorRand():Angle() )
							phys:SetVelocityInstantaneous( dir * power + VectorRand() * 30 + vector_up*20 )
							phys:AddAngleVelocity( VectorRand() * power ) 
						end
						
						ParticleEffectAttach( "env_fire_tiny", PATTACH_ABSORIGIN_FOLLOW, self.Entity, 0 )
						
						
						//self.Time = CurTime() + math.random(8, 10)
									
					
                end,
 
                Think = function( self ) 
					/*if CurTime() > self.Time then
						return false
					end*/
					return true
				end,
 
                Render = function(self) 
					if IsValid(self.Entity) then
						self.Entity:DrawModel()
					end
				
				end
            },
 
			"car_gib"
)
	
end