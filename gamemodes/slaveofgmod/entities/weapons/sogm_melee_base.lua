AddCSLuaFile()

SWEP.Author			= "NECROSSIN"
SWEP.Purpose		= ""

SWEP.AdminSpawnable		= true
SWEP.Spawnable			= true

SWEP.ViewModel			= Model("models/weapons/w_crowbar.mdl") 
SWEP.WorldModel			= Model("models/weapons/w_crowbar.mdl") 

SWEP.ViewModelFOV		= 50

SWEP.AutoSwitchTo		= true
SWEP.AutoSwitchFrom		= false

SWEP.Weight 			= 3

SWEP.HoldType			= "melee"

SWEP.PrintName			= "Melee"
SWEP.Slot				= 1
SWEP.SlotPos			= 1
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= false

SWEP.IsMelee 			= true

SWEP.ExecutionSequence 	= "cidle_melee2"
SWEP.ExecutionGesture 	= ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2
SWEP.HitsToExecute 		= 2
SWEP.BloodMultiplier 	= 2

SWEP.DamageType 		= DMG_CLUB

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Delay			= 0.8

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.WElements = {}
SWEP.ShowWorldModel = false

SWEP.FilterTable = {}

SWEP.SwingDuration = 0.1


function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
	self:SetHoldType(self.HoldType)	
	if CLIENT then
		self:CreateModels(self.WElements)
	end
	self:DrawShadow(false)
	
end

function SWEP:Deploy()
	self.Weapon:SetNextPrimaryFire(CurTime() + 0.2)
end

function SWEP:CanPrimaryAttack()
	if self.Owner:IsNextBot() then
		return true
	end
	return not self:IsSwinging()
end

function SWEP:PrimaryAttack()
	
	if not self.Owner then return end
	if IsValid(self.Owner.Execution) then return false end
	if !self:CanPrimaryAttack() then return end
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	
	self:OnPrimaryAttack()
	
	if self.Throwable then
		self:Throw( self.Throwable )
		return
	end
	
	local owner = self.Owner

	if owner:GetCharTable() and owner:GetCharTable().MeleeGesture then
		owner:PlayGesture( owner:GetCharTable().MeleeGesture )
	else
		if self.OverrideAttackGesture then
			if SERVER then
				owner:PlayGesture( self.OverrideAttackGesture )
			end
		elseif self.OverrideAttackAnimation then
			self:OverrideAttackAnimation()
		else
			if owner:IsPlayer() then
				owner:SetAnimation(PLAYER_ATTACK1)
			else
				owner:RestartGesture( owner:GetCharTable() and owner:GetCharTable().MeleeGesture or self.ExecutionGesture  )//ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2
			end
		end
	end
	
	//clear all filers
	//table.Empty( self.FilterTable )
	//self.FilterTable = nil
	//self.FilterTable = {}
	
	self.FirstHit = true
	//self.FirstHitSound = true
	//self.FirstSwingSound = true
	

	self:SetFirstHitSound( true )
	self:SetFirstSwingSound( true )

	
	//if SERVER then
	//	self:SetFirstSound( true )
	//end
	
	//nextbots still use 1 frame attack because for some reason they refuse to refresh the filter table for melee attacks
	if self.Owner:IsNextBot() then
		table.Empty( self.FilterTable )
	end
	
	//do the initial check
	if self.NoDamage then
		self:Knockout( self.KnockdownDamage )
	else
		self:Slash()
	end
	
	if self:IsNextBot() then
		//table.Empty( self.FilterTable )
	else
		self:StartSwinging()
	end
	
	
	/*if self.PlaySwingSound then
		self:PlaySwingSound()
	end	*/
	
	//save
	/*
	if self.NoDamage then
		self:Knockout( self.KnockdownDamage )
	else
		self:Slash()
	end*/
	
	
end

function SWEP:SecondaryAttack()
	if CLIENT then return end
	if self.Owner:GetCharTable().OverrideSecondaryAttack then
		return self.Owner:GetCharTable():OverrideSecondaryAttack( self.Owner, self )
	end
	if IsValid(self.Owner.CanSwitch) then return end
	if IsValid(self.Owner.Execution) then return end
	self.Owner:ThrowCurrentWeapon()
end

function SWEP:Think()

	if self:IsSwinging() then
		if self.NoDamage then
			self:Knockout( self.KnockdownDamage )
		else
			self:Slash()
		end
	end
	
	if self:IsSwinging() and self:GetSwingEnd() <= CurTime() then
		table.Empty( self.FilterTable )
		self:StopSwinging()
		//if SERVER then
		//	self:SetFirstSound( true )
		//end
	end
	
	if self.OnThink then
		self:OnThink()
	end
	
end

function SWEP:Reload()
end

function SWEP:OnPrimaryAttack()
end

local swing = Sound("npc/zombie/claw_miss1.wav")
function SWEP:PlaySwingSound()
	if IsValid( self.Owner ) then
		self.Owner:EmitSound(swing, 75, math.Rand(75, 90), 1)
	end
end 

function SWEP:PlayHitFleshSound()
	self:EmitSound("physics/body/body_medium_break"..math.random(2, 3)..".wav")
end 

local trace = {mask = MASK_SHOT, mins = Vector(-16,-16,-15), maxs = Vector(16, 16, 15)}

function SWEP:Knockout( damage )

	local owner = self.Owner

	//local tr = util.TraceHull( trace )
	if self.Owner:IsPlayer() then owner:LagCompensation( true ) end
	local traces = owner:PenetratingMeleeTrace( self.MeleeRange or 46 , 15, self.FilterTable )
	if self.Owner:IsPlayer() then owner:LagCompensation( false ) end
	local hit = false
	
	for _, tr in ipairs(traces) do
		if not tr.Hit then continue end
		
		if tr.Hit and tr.Entity and tr.Entity.Immune then continue end
		if tr.Hit and tr.Entity and tr.Entity:GetOwner() == owner then continue end
		if tr.Hit and tr.Entity and tr.Entity == owner:GetOwner() then continue end
		if tr.Hit and tr.Entity and tr.Entity.SpawnProtection and tr.Entity.SpawnProtection > CurTime() and !tr.Entity.NoSpawnProtection then continue end
		
		hit = true
		
		if SERVER then
			if IsValid(tr.Entity) and (tr.Entity:IsPlayer() or tr.Entity:IsNextBot()) and not IsValid(tr.Entity.Knockdown) then
				
				if damage then
								
					local dmginfo = DamageInfo()
					dmginfo:SetDamagePosition(tr.HitPos)
					dmginfo:SetDamage( damage )
					dmginfo:SetAttacker( owner )
					dmginfo:SetInflictor( owner )
					dmginfo:SetDamageType( DMG_CLUB )
					dmginfo:SetDamageForce(820 * (owner:GetAimVector() + vector_up*-0.2) * 18) 
					
					local e = EffectData()
						e:SetOrigin( tr.HitPos )
						e:SetNormal( tr.HitNormal )
						e:SetScale( 1 )
					util.Effect( "BloodImpact", e, nil, true )
									
				
					tr.Entity:TakeDamageInfo(dmginfo)	
					
				end
			
				tr.Entity:SetVelocity( owner:GetAimVector() * 350 * ( self.KnockoutPower or 1 ) )
				tr.Entity:DoKnockdown( self.KnockoutDuration or 2, false, owner, true )
				if self.Owner:IsPlayer() then
					self.Owner:SetComboTime()
				end
				
				if self.OnKnockoutHit then
					self:OnKnockoutHit( owner, tr.Entity )
				end
				
				return
			end
			if IsValid(tr.Entity) and tr.Entity:GetClass() == "func_breakable_surf" then
				tr.Entity:Fire("break", "", 0)
			end
		end
	end
	
	//if self.FirstSwingSound then
	if self:GetFirstSwingSound() then
		if self.PlaySwingSound then
			self:PlaySwingSound()
		end	
		self:SetFirstSwingSound( false )
		//self.FirstSwingSound = false
	end
	
end

function SWEP:Throw( force )
	
	local owner = self.Owner

	owner:SetAnimation(PLAYER_ATTACK1)

	if CLIENT then return end
	owner:ThrowCurrentWeapon( force )
	
end

function SWEP:StopSwinging()
	self:SetSwingEnd(0)
end

function SWEP:IsSwinging()
	return self:GetSwingEnd() > 0
end

function SWEP:SetSwingEnd(swingend)
	self:SetDTFloat( 0, swingend )
end

function SWEP:GetSwingEnd()
	return self:GetDTFloat( 0 )
end

function SWEP:SetFirstHitSound( bl )
	self:SetDTBool( 20, bl )
end

function SWEP:GetFirstHitSound()
	return self:GetDTBool( 20 )
end	

function SWEP:SetFirstSwingSound( bl )
	self:SetDTBool( 21, bl )
end

function SWEP:GetFirstSwingSound()
	return self:GetDTBool( 21 )
end	

function SWEP:SetHitFlesh( bl )
	self:SetDTBool( 22, bl )
end

function SWEP:GetHitFlesh()
	return self:GetDTBool( 22 )
end

function SWEP:StartSwinging()
	self:SetSwingEnd( CurTime() + self.SwingDuration )
end

local trace = { mask = MASK_SOLID }
function SWEP:Slash()

	//if not IsFirstTimePredicted() then return end

	local owner = self.Owner

	if owner:IsNextBot() then
		//NEXTBOT_NEXT_MELEE_ATTACK = NEXTBOT_NEXT_MELEE_ATTACK or 0
		owner.NextMeleeAttack = owner.NextMeleeAttack or 0
		
		if owner.NextMeleeAttack < CurTime() then
			owner.NextMeleeAttack = CurTime() + 1
		else
			return
		end
		
		//if NEXTBOT_NEXT_MELEE_ATTACK < CurTime() then
		//	NEXTBOT_NEXT_MELEE_ATTACK = CurTime() + 1
		//else
		//	return
		//end
		
	end
	
	
	
	local hit = false
	//local hitfl = false
	
	self:SetHitFlesh( false )
	
	if self.Owner:IsPlayer() then owner:LagCompensation( true ) end
	local traces = owner:PenetratingMeleeTrace( self.MeleeRange or 46, 15, self.FilterTable)
	if self.Owner:IsPlayer() then owner:LagCompensation( false ) end 

	//local tr = util.TraceHull( trace )	
	
	for _, tr in ipairs(traces) do
		if not tr.Hit then continue end
		
		/*trace.start = owner:GetShootPos()
		trace.endpos = owner:GetShootPos() + owner:GetAimVector() * 70
		trace.filter = owner*/
		if tr.Hit and tr.Entity and tr.Entity.Immune then continue end
		if tr.Hit and tr.Entity and tr.Entity:GetOwner() == owner then continue end
		if tr.Hit and tr.Entity and tr.Entity == owner:GetOwner() then continue end
		if tr.Hit and tr.Entity and tr.Entity:GetClass() == "sogm_buddy" and tr.Entity:GetOwner() == owner then continue end
		if tr.Hit and tr.Entity and tr.Entity.SpawnProtection and tr.Entity.SpawnProtection > CurTime() and !tr.Entity.NoSpawnProtection then continue end

		hit = true
		if tr.Hit then
		
			local takedamage = true
		
			local hitent = tr.Entity
			//local tr_decal = util.TraceLine( trace )//owner:GetEyeTrace()
			local hitflesh = tr.MatType == MAT_FLESH or tr.MatType == MAT_BLOODYFLESH or tr.MatType == MAT_ANTLION or tr.MatType == MAT_ALIENFLESH 
			
			if hitent.FleshMaterial then
				//hitfl = true
				self:SetHitFlesh( true )
			end
			
			if IsValid(hitent) and (tr.Entity:IsPlayer() or tr.Entity:IsNextBot()) and hitent:GetCharTable().OnMeleeHit then
				takedamage = hitent:GetCharTable():OnMeleeHit( hitent, tr.HitPos, owner:GetAimVector():GetNormal()*-1, owner:GetAimVector():GetNormal(), owner )
			end
			
			if IsValid(hitent) and (tr.Entity:IsPlayer() or tr.Entity:IsNextBot()) then
				local wep = hitent.GetActiveWeapon and IsValid( hitent:GetActiveWeapon() ) and hitent:GetActiveWeapon()
				if wep and wep.OnMeleeHit then
					takedamage = wep:OnMeleeHit( hitent, tr.HitPos, owner:GetAimVector():GetNormal()*-1, owner:GetAimVector():GetNormal(), owner )
				end
			end
	
		
			if IsValid(hitent) and (hitent:IsPlayer() or hitent:IsNextBot()) and takedamage then //hitflesh and  //and tr_decal.Hit and IsValid(tr_decal.Entity) and IsValid(hitent) and hitent == tr_decal.Entity then

				//hitfl = true
				self:SetHitFlesh( true )
				

				local nearest = hitent:NearestPoint(tr.StartPos + VectorRand() * 3)
					
				//util.Decal("Blood", nearest + (nearest - tr.StartPos):GetNormalized() * 10, nearest - (nearest - tr.StartPos):GetNormalized() * 10)
				//util.Decal("Blood", nearest + (nearest - tr.StartPos):GetNormalized() * 10, nearest - (nearest - tr.StartPos):GetNormalized() * 10)
										
				nearest = nearest + VectorRand() * 3
					
				local nearest2 = owner:NearestPoint(nearest)
									
				//util.Decal("Blood", nearest2 + (nearest2 - nearest):GetNormalized() * 10, nearest2 - (nearest2 - nearest):GetNormalized() * 10)
				//util.Decal("Blood", nearest2 + (nearest2 - nearest):GetNormalized() * 10, nearest2 - (nearest2 - nearest):GetNormalized() * 10)
				
			end
		
			if SERVER and IsValid(hitent) then
				if hitent:GetClass() == "func_breakable_surf" then
					hitent:Fire("break", "", 0)
				else	
					local dmginfo = DamageInfo()
					dmginfo:SetDamagePosition(tr.HitPos)
					dmginfo:SetDamage(300)//210)
					dmginfo:SetAttacker(owner)
					dmginfo:SetInflictor(self.Weapon)
					dmginfo:SetDamageType(self.DamageType)
					local force = self.OverrideForce or 720
					if !hitent:IsPlayer() and !hitent:IsNextBot() then
						force = 50
					end
					dmginfo:SetDamageForce( ( force ) * (owner:GetAimVector() + vector_up*-0.2) * 18) 
					
					/*if hitent:IsPlayer() then
						local e = EffectData()
							e:SetOrigin( tr.HitPos )
							e:SetNormal( tr.HitNormal )
							e:SetScale( 1 )
						util.Effect( "BloodImpact", e, nil, true )
					end*/
					
					if !IsValid(hitent.Knockdown) and takedamage then
						if self.AllowDismembement then hitent.ToDismember = true end
							if hitent:IsPlayer() or hitent:IsNextBot() then
								if self.FirstHit then
									owner:ShakeView( math.random(7,13) )
									self.FirstHit = false
								end
								if hitent.ShakeView then
									hitent:ShakeView( math.random(7,13) ) 
								end
							end
							hitent:TakeDamageInfo(dmginfo)
						if self.AllowDismembement then hitent.ToDismember = nil end
					end
					
					
				end
			end
			
			//if !takedamage then break end
			
		end
	end
	
	
	//if owner:IsNextBot() then
		//NEXTBOT_NEXT_MELEE_SOUND = NEXTBOT_NEXT_MELEE_SOUND or 0
		//self.NextSound = self.NextSound or 0
	//end
	
	//local allow = owner:IsPlayer() or owner:IsNextBot() and NEXTBOT_NEXT_MELEE_SOUND < CurTime()
	
	//if allow then
		
		//if owner:IsNextBot() then
		//	NEXTBOT_NEXT_MELEE_SOUND = CurTime() + 1
		//end
	
		//if hitfl then
		if self:GetHitFlesh() then
			//if self.FirstHitSound then
			if self:GetFirstHitSound() then
				//if SERVER then
					self:PlayHitFleshSound()
				//end
				//self.FirstHitSound = false
				self:SetFirstHitSound( false )
			end
		end
		//else
			//if self.FirstSwingSound then
			if self:GetFirstSwingSound() then
				if self.PlaySwingSound and SERVER then
					self:PlaySwingSound()
				end	
				//self.FirstSwingSound = false
				self:SetFirstSwingSound( false )
			end
		//end
		
		/*if not hit then
			self:PlaySwingSound()		
		end*/
	//end
	
end

if CLIENT then
	
	local zero_vec = Vector( 0, 0, 0 )
	local zero_ang = Angle( 0, 0, 0 )
	local vec_up = vector_up
	
	function SWEP:OnDrawWorldModel()
	end
	
	SWEP.wRenderOrder = nil
	function SWEP:DrawWorldModel()
		
		local owner = self:GetOwner()
		if not IsValid(owner) then return end
		if IsValid(owner) and owner.HideWeapon then return end
		
		owner:DrawShadow( false )
		
		/*if owner:IsNextBot() then
			local dlight = DynamicLight( owner:EntIndex() )
			if ( dlight ) then
				local size = 50
				dlight.Pos = owner:GetPos()+vec_up*2
				dlight.r = 255
				dlight.g = 255
				dlight.b = 255
				dlight.Brightness = 3.5
				dlight.Size = size
				dlight.Decay = size * 1
				dlight.DieTime = CurTime() + 1
				dlight.Style = 0
				dlight.NoModel = true
			end
		end*/

		
		self:OnDrawWorldModel()
	
		if (self.ShowWorldModel == nil or self.ShowWorldModel) then
			self:DrawModel()
		end
		
		if self.CheckWorldModelElements then
			self:CheckWorldModelElements()	
		end
		
		if (!self.WElements) then return end
		
		if (!self.wRenderOrder) then

			self.wRenderOrder = {}

			for k, v in pairs( self.WElements ) do
				if (v.type == "Model") then
					table.insert(self.wRenderOrder, 1, k)
				elseif (v.type == "Sprite" or v.type == "Quad") then
					table.insert(self.wRenderOrder, k)
				end
			end

		end
		
		if (IsValid(self.Owner)) then
			bone_ent = self.Owner
		else
			// when the weapon is dropped
			bone_ent = self
		end
		
		for i = 1, #self.wRenderOrder do
			
			local name = self.wRenderOrder[ i ]
			local v = self.WElements[name]
			if (!v) then self.wRenderOrder = nil break end
			
			local pos, ang
			
			if (v.bone) then
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent )
			else
				pos, ang = self:GetBoneOrientation( self.WElements, v, bone_ent, "ValveBiped.Bip01_R_Hand" )
			end
			
			if (!pos) then continue end
			
			local model = v.modelEnt
			local sprite = v.spriteMaterial
			
			if (v.type == "Model" and IsValid(model)) then

				model:SetPos(pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z )

				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				

				local size = (v.size.x + v.size.y + v.size.z)/3
				model:SetAngles(ang)
				
				if v.fix_scale then
					local matrix = Matrix()
					matrix:Scale(v.size)
					model:EnableMatrix( "RenderMultiply", matrix )
				else
					if model:GetModelScale() ~= size then
						model:SetModelScale(size,0)
					end
				end
				
				if (v.material == "") then
					model:SetMaterial("")
				elseif (model:GetMaterial() != v.material) then
					model:SetMaterial( v.material )
				end
				
				if (v.skin and v.skin != model:GetSkin()) then
					model:SetSkin(v.skin)
				end
				
				if (v.bodygroup) then
					for k, v in pairs( v.bodygroup ) do
						if (model:GetBodygroup(k) != v) then
							model:SetBodygroup(k, v)
						end
					end
				end
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(true)
				end
				
				render.SetColorModulation(v.color.r/255, v.color.g/255, v.color.b/255)
				render.SetBlend(v.color.a/255)
				model:SetupBones()
				model:DrawModel()
				render.SetBlend(1)
				render.SetColorModulation(1, 1, 1)
				
				if (v.surpresslightning) then
					render.SuppressEngineLighting(false)
				end
				
			elseif (v.type == "Sprite" and sprite) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				render.SetMaterial(sprite)
				render.DrawSprite(drawpos, v.size.x, v.size.y, v.color)
				
			elseif (v.type == "Quad" and v.draw_func) then
				
				local drawpos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
				ang:RotateAroundAxis(ang:Up(), v.angle.y)
				ang:RotateAroundAxis(ang:Right(), v.angle.p)
				ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
				cam.Start3D2D(drawpos, ang, v.size)
					v.draw_func( self )
				cam.End3D2D()

			end
			
		end
		
	end

	function SWEP:GetBoneOrientation( basetab, tab, ent, bone_override )
		
		local bone, pos, ang
		if (tab.rel and tab.rel != "") then
			
			local v = basetab[tab.rel]
			
			if (!v) then return end
			
			// Technically, if there exists an element with the same name as a bone
			// you can get in an infinite loop. Let's just hope nobody's that stupid.
			pos, ang = self:GetBoneOrientation( basetab, v, ent )
			
			if (!pos) then return end
			
			pos = pos + ang:Forward() * v.pos.x + ang:Right() * v.pos.y + ang:Up() * v.pos.z
			ang:RotateAroundAxis(ang:Up(), v.angle.y)
			ang:RotateAroundAxis(ang:Right(), v.angle.p)
			ang:RotateAroundAxis(ang:Forward(), v.angle.r)
				
		else
		
			if tab.cached_bone then
				bone = tab.cached_bone
			else
				bone = ent:LookupBone(bone_override or tab.bone)
				tab.cached_bone = bone
			end

			if (!bone) then return end
			
			pos, ang = zero_vec, zero_ang//Vector(0,0,0), Angle(0,0,0)
			local m = ent:GetBoneMatrix(bone)
			if (m) then
				pos, ang = m:GetTranslation(), m:GetAngles()
			end
			
			if (IsValid(self.Owner) and self.Owner:IsPlayer() and 
				ent == self.Owner:GetViewModel() and self.ViewModelFlip) then
				ang.r = -ang.r // Fixes mirrored models
			end
		
		end
		
		return pos, ang
	end

	function SWEP:CreateModels( tab )

		if (!tab) then return end

		// Create the clientside models here because Garry says we can't do it in the render hook
		for k, v in pairs( tab ) do
			if (v.type == "Model" and v.model and v.model != "" and (!IsValid(v.modelEnt) or v.createdModel != v.model) and 
					string.find(v.model, ".mdl") and file.Exists (v.model,"GAME") ) then
				
				v.modelEnt = ClientsideModel(v.model, RENDER_GROUP_VIEW_MODEL_OPAQUE)
				if (IsValid(v.modelEnt)) then
					v.modelEnt:SetPos(self:GetPos())
					v.modelEnt:SetAngles(self:GetAngles())
					v.modelEnt:SetParent(self)
					v.modelEnt:SetNoDraw(true)
					v.modelEnt:DrawShadow( false )
					v.createdModel = v.model
					
					if v.seq then
						v.modelEnt:SetSequence( v.modelEnt:LookupSequence( v.seq ) )
					end
					
					if v.bbp then
						v.modelEnt:AddCallback("BuildBonePositions", v.bbp )
					end
														
					if self.WElementsBoneMods and self.WElementsBoneMods[k] then
						for bn,tbl in pairs(self.VElementsBoneMods[k]) do
							local bone = v.modelEnt:LookupBone(bn)
							if (!bone) then continue end
							v.modelEnt:ManipulateBoneScale( bone, tbl.scale )
							v.modelEnt:ManipulateBoneAngles( bone, tbl.angle )
							v.modelEnt:ManipulateBonePosition( bone, tbl.pos )
						end
					end
					
					
				else
					v.modelEnt = nil
				end
				
			elseif (v.type == "Sprite" and v.sprite and v.sprite != "" and (!v.spriteMaterial or v.createdSprite != v.sprite) 
				and file.Exists ("materials/"..v.sprite..".vmt","GAME")) then
				
				local name = v.sprite.."-"
				local params = { ["$basetexture"] = v.sprite }
				// make sure we create a unique name based on the selected options
				local tocheck = { "nocull", "additive", "vertexalpha", "vertexcolor", "ignorez" }
				for i, j in pairs( tocheck ) do
					if (v[j]) then
						params["$"..j] = 1
						name = name.."1"
					else
						name = name.."0"
					end
				end

				v.createdSprite = v.sprite
				v.spriteMaterial = CreateMaterial(name,"UnlitGeneric",params)
				
			end
		end
		
	end

	function SWEP:OnRemove()
		self:RemoveModels()
		if IsValid(self.Owner) then
			self.Owner:ResetBoneMatrix()
			self.Owner:ResetBoneScale()
		end
	end

	function SWEP:RemoveModels()
		if (self.VElements) then
			for k, v in pairs( self.VElements ) do
				if (IsValid( v.modelEnt )) then v.modelEnt:Remove() end
			end
		end
		if (self.WElements) then
			for k, v in pairs( self.WElements ) do
				if (IsValid( v.modelEnt )) then v.modelEnt:Remove() end
			end
		end
		self.VElements = nil
		self.WElements = nil
	end


end

