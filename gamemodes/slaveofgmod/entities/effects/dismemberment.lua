local table = table
local pairs = pairs
local math = math
local zero_vec = vector_origin
local VectorRand = VectorRand

local keys = {}

local Hitgroups = {
	[HITGROUP_HEAD] = {"ValveBiped.Bip01_Head1"},
	[HITGROUP_LEFTARM] = {"ValveBiped.Bip01_L_UpperArm", "ValveBiped.Bip01_L_Forearm", "ValveBiped.Bip01_L_Hand", 
						  "ValveBiped.Bip01_L_Elbow", "ValveBiped.Bip01_L_Ulna", "ValveBiped.Bip01_L_Wrist",
						  "ValveBiped.Bip01_L_Bicep", //"ValveBiped.Bip01_L_Finger4", "ValveBiped.Bip01_L_Finger41", "ValveBiped.Bip01_L_Finger42",
							},
	[HITGROUP_RIGHTARM] = {"ValveBiped.Bip01_R_UpperArm", "ValveBiped.Bip01_R_Forearm", "ValveBiped.Bip01_R_Hand", "ValveBiped.Bip01_R_Elbow", "ValveBiped.Bip01_R_Ulna", "ValveBiped.Bip01_R_Wrist", "ValveBiped.Bip01_R_Bicep"},
	[HITGROUP_LEFTLEG] = {"ValveBiped.Bip01_L_Thigh", "ValveBiped.Bip01_L_Calf", "ValveBiped.Bip01_L_Foot", "ValveBiped.Bip01_L_Toe0"},
	[HITGROUP_RIGHTLEG] = {"ValveBiped.Bip01_R_Thigh", "ValveBiped.Bip01_R_Calf", "ValveBiped.Bip01_R_Foot", "ValveBiped.Bip01_R_Toe0"},
	[HITGROUP_GEAR] = {"ValveBiped.Bip01_Pelvis","ValveBiped.Bip01_R_Thigh", "ValveBiped.Bip01_R_Calf", "ValveBiped.Bip01_R_Foot", "ValveBiped.Bip01_R_Toe0","ValveBiped.Bip01_L_Thigh", "ValveBiped.Bip01_L_Calf", "ValveBiped.Bip01_L_Foot", "ValveBiped.Bip01_L_Toe0"},
	
}

for i=0,4 do
	for i2=0,2 do
		table.insert( Hitgroups[HITGROUP_LEFTARM], "ValveBiped.Bip01_L_Finger"..i..""..(i2 == 0 and "" or i2) )
		table.insert( Hitgroups[HITGROUP_RIGHTARM], "ValveBiped.Bip01_R_Finger"..i..""..(i2 == 0 and "" or i2) )
	end
end

local count = 0
for k, v in pairs( Hitgroups ) do
	keys[ count ] = k
	count = count + 1
end

function EFFECT:Init( data )
	self.ent = data:GetEntity()
	self.dism = math.Round(data:GetScale()) or 0
	self.DieTime = CurTime() + math.Rand(1,3)
			
	if IsValid(self.ent) then
		//self.Emitter = ParticleEmitter(self.ent:GetPos())

		if self.dism == 1 then
			sound.Play("physics/flesh/flesh_bloody_break.wav", self:GetPos(), 130,100,1)
		end
	end
	
	self.DismemberTable = {}
	//table.Empty( DismemberTable )
	
	if self.dism == -1 then
		for i = 1, math.random( 1, 10 ) do
			local rand = keys[ math.random( #keys ) ]
			if not self.DismemberTable[ rand ] then
				self.DismemberTable[ rand ] = table.Copy( Hitgroups[ rand ] )
			end
		end
	else
		if Hitgroups[self.dism] then
			self.DismemberTable[self.dism] = table.Copy( Hitgroups[self.dism] )
		end
	end
	
	//PrintTable( DismemberTable )
	
	
end


local mins = Vector(-128, -128, -128)
local maxs = Vector(128, 128, 128)
function EFFECT:Think( )
	
	if IsValid(self.ent) then
		self.Entity:SetRenderBounds(mins, maxs)	
	else
		//if self.Emitter then
			//self.Emitter:Finish()
		//end
	end
	return CurTime() < self.DieTime or IsValid(self.ent) and self.ent.GetRagdollEntity and IsValid(self.ent:GetRagdollEntity())
end

local function CollideCallbackSmall(particle, hitpos, hitnormal)
	if not particle.HitAlready then
	
		particle.HitAlready = true
		
		if math.random(1, 10) == 3 then
			sound.Play("physics/flesh/flesh_bloody_impact_hard1.wav", hitpos, 50, math.random(95, 105))
		end
		if DRUG_EFFECT then
			util.Decal(math.random(25) == 25 and "YellowBlood" or "Impact.Antlion", hitpos + hitnormal, hitpos - hitnormal)
		else
			util.Decal(math.random(25) == 25 and "Blood" or "Impact.Flesh", hitpos + hitnormal, hitpos - hitnormal)
		end

		particle:SetDieTime(0)
	end	
end

local grav_vec1 = Vector(0, 0, -1800)
local grav_vec2 = Vector(0, 0, 100)
function EFFECT:Render()

	local rag = IsValid(self.ent) and self.ent.GetRagdollEntity and self.ent:GetRagdollEntity()
	
	if IsValid(rag) then
		if rag.Rag then
			self.Rag = rag.Rag
		end
	end
	
	if IsValid(self.Rag) then
		rag = self.Rag
	end
	
	local MySelf = IsValid( LocalPlayer():GetObserverTarget() ) and LocalPlayer():GetObserverTarget() or LocalPlayer()
	
	local visible = MySelf:GetPos():DistToSqr(self:GetPos()) < DRAW_DISTANCE * DRAW_DISTANCE
	
	if not visible then return end
	
	local ct = CurTime()
	
	if rag and IsValid(rag) and self.DismemberTable then

		for dism, tbl in pairs(	self.DismemberTable ) do
			tbl.NextDrip = tbl.NextDrip or 0
			if tbl.NextDrip <= ct then
				tbl.NextDrip = ct + 0.1//0.075
				
				local emitter = ParticleEmitter(rag:GetPos())

				local bonename = tbl[1]
				local bone = rag:LookupBone(bonename)
				if bone then	
					local pos, ang = rag:GetBonePosition(bone)
					if pos and ang then
						if not self.Done then
							self.Done = true
						end
	
						if emitter then
								
							emitter:SetPos(pos)
								
							local delta = math.max(0, self.DieTime - ct)
							if 0 < delta then

								for i=1, math.random(1, 3) do
								
									local mat = DRUG_EFFECT and "Decals/alienflesh/shot"..math.random(1,5) or "Decals/flesh/Blood"..math.random(1,5)
									local particle = emitter:Add( mat, pos + VectorRand() )
									local force = math.min(1.5, delta) * math.Rand(65, 320)
												
									particle:SetVelocity(force * ang:Forward() + 0.35 * force * VectorRand())
									particle:SetDieTime(math.Rand(2.25, 3))
									particle:SetStartAlpha(250)
									particle:SetEndAlpha(0)
									particle:SetStartSize(math.random(1, 8))
									particle:SetEndSize(0)
									particle:SetRoll(math.Rand(0, 360))
									particle:SetRollDelta(math.Rand(-40, 40))
									if DRUG_EFFECT then
										particle:SetColor(255, 255, 255)
									else
										particle:SetColor(255, 0, 0)
									end
									particle:SetAirResistance(15)
									particle:SetBounce(0)
									particle:SetGravity(grav_vec1)
									particle:SetCollide(true)
									particle:SetCollideCallback(CollideCallbackSmall)
									particle:SetLighting(true)
												
									local particle = emitter:Add("effects/blood_core.vmt", pos + VectorRand() * 3)
												
									particle:SetVelocity(VectorRand()*40)
									particle:SetDieTime(math.Rand(0.15, 0.25))
									particle:SetStartAlpha(50)
									particle:SetEndAlpha(0)
									particle:SetStartSize(math.random(3, 8))
									particle:SetEndSize(math.random(3, 8))
									particle:SetRoll(math.Rand(0, 360))
									particle:SetRollDelta(math.Rand(-10, 10))
									particle:SetColor(155, 0, 0)
									particle:SetAirResistance(15)
									particle:SetBounce(0)
									particle:SetGravity(grav_vec2)
									particle:SetCollide(true)
									particle:SetCollideCallback(CollideCallbackSmall)
									particle:SetLighting(true)
												
								end
										
							end	

							emitter:Finish() emitter = nil collectgarbage("step", 64)
						
						end
							
					end	
				end				
			end
			
			for _,bonename in pairs( tbl ) do
				local bone = rag:LookupBone(bonename)
				if bone then
					if !rag:IsPlayer() then
						rag:ManipulateBoneScale( bone, zero_vec )	
					end
				end
			end
			
		end
	end
	
end
