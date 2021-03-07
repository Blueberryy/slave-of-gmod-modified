AddCSLuaFile()

include("sck.lua")

SWEP.Base 					= "sogm_uzi" 

SWEP.ViewModel 				= Model( "models/weapons/cstrike/c_pist_glock18.mdl" )
SWEP.WorldModel 			= Model( "models/weapons/w_alyx_gun.mdl" )

SWEP.PrintName				= "Gun and Axe"

SWEP.Primary.Sound 			= Sound( "GunAxe.SingleHeavy" )

SWEP.HoldType				= "duel"

SWEP.Primary.ClipSize		= 18
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize
SWEP.Primary.Damage			= 100
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "pistol"
SWEP.Primary.Delay			= 0.12
SWEP.Primary.Spread 		= 0.05
SWEP.BulletSpeed			= 2700

SWEP.Hidden 				= true
SWEP.ShowWorldModel 		= false

SWEP.ShellEffect			= "ef_shelleject" 

SWEP.FilterTable = {}

SWEP.SwingDuration = 0.1

SWEP.AkimboClass = nil

sound.Add( {
	name = "GunAxe.SingleHeavy",
	channel = CHAN_WEAPON,
	volume = 0.63,
	level = 80,
	pitch = {240,250},
	sound = Sound( "weapons/sg550/sg550-1.wav" )
} )

SWEP.WElements = {
	["axe"] = { type = "Model", model = "models/props/cs_militia/axe.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(2.832, 1.47, -0.48), angle = Angle(14.602, 180, 86.024), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["gun"] = { type = "Model", model = "models/weapons/w_alyx_gun.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.506, 2.233, -3.468), angle = Angle(5.026, -180, -169.452), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}


function SWEP:GetBulletOffset( aim )
	return vector_origin
end

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)	
	self:SetHoldType(self.HoldType)	
	if CLIENT then
		self:CreateModels(self.WElements)
	end
	self:DrawShadow(false)
end

function SWEP:PrimaryAttack()
	
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	if not self:CanPrimaryAttack() then return end	
	
	self:EmitFireSound()
	self:TakeAmmo()

	self.Owner:SetAnimation(PLAYER_ATTACK1)
	
	self:FireBullet()
	//self:FireBullet()
	
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
	end
	
end

local swing = Sound("npc/zombie/claw_miss1.wav")
function SWEP:PlaySwingSound()
	self.Owner:EmitSound(swing, 75, math.Rand(75, 90))
end

function SWEP:PlayHitFleshSound()
	self:EmitSound("weapons/knife/knife_hit"..math.random(3)..".wav", 130, math.random(94,98))
end 

function SWEP:SetNextSwing( time )
	self:SetDTFloat( 1, time )
end

function SWEP:GetNextSwing()
	return self:GetDTFloat( 1 ) or 0
end

function SWEP:SecondaryAttack()
	self.Weapon:SetNextSecondaryFire(CurTime() + 0.5)
	self:SetNextSwing( CurTime() + 0.2 )
	
	local pl = self.Owner
	
	if SERVER then
		pl:PlayGesture( ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN )
	else
		pl:AnimRestartGesture( GESTURE_SLOT_GRENADE, ACT_HL2MP_GESTURE_RANGE_ATTACK_SHOTGUN, true )
	end
	
	self.FirstHit = true
	
	//do the initial check
	
	self:Slash()

	
	self:StartSwinging()
	
	if self.PlaySwingSound then
		self:PlaySwingSound()
	end	
	
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

function SWEP:StartSwinging()
	self:SetSwingEnd( CurTime() + self.SwingDuration )
end

function SWEP:Slash()

	local owner = self.Owner
	
	local hit = false
	local hitfl = false
	owner:LagCompensation(true) 
	local traces = owner:PenetratingMeleeTrace( 46, 15, self.FilterTable)
	owner:LagCompensation(false) 
		
	
	for _, tr in ipairs(traces) do
		if not tr.Hit then continue end

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
				hitfl = true
			end
			
			if IsValid(hitent) and (tr.Entity:IsPlayer() or tr.Entity:IsNextBot()) and hitent:GetCharTable().OnMeleeHit then
				takedamage = hitent:GetCharTable():OnMeleeHit( hitent, tr.HitPos, owner:GetAimVector():GetNormal()*-1, owner:GetAimVector():GetNormal(), owner )
			end
		
			if hitflesh and IsValid(hitent) and (hitent:IsPlayer() or hitent:IsNextBot()) and takedamage then//and tr_decal.Hit and IsValid(tr_decal.Entity) and IsValid(hitent) and hitent == tr_decal.Entity then

				hitfl = true
				
				local nearest = hitent:NearestPoint(tr.StartPos + VectorRand() * 3)
					
				util.Decal("Blood", nearest + (nearest - tr.StartPos):GetNormalized() * 10, nearest - (nearest - tr.StartPos):GetNormalized() * 10)
				util.Decal("Blood", nearest + (nearest - tr.StartPos):GetNormalized() * 10, nearest - (nearest - tr.StartPos):GetNormalized() * 10)
										
				nearest = nearest + VectorRand() * 3
					
				local nearest2 = owner:NearestPoint(nearest)
									
				util.Decal("Blood", nearest2 + (nearest2 - nearest):GetNormalized() * 10, nearest2 - (nearest2 - nearest):GetNormalized() * 10)
				util.Decal("Blood", nearest2 + (nearest2 - nearest):GetNormalized() * 10, nearest2 - (nearest2 - nearest):GetNormalized() * 10)
				
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
					dmginfo:SetDamageType( DMG_SLASH )
					local force = self.OverrideForce or 720
					if !hitent:IsPlayer() and !hitent:IsNextBot() then
						force = 50
					end
					dmginfo:SetDamageForce( ( force ) * (owner:GetAimVector() + vector_up*-0.2) * 18) 
					
					if !IsValid(hitent.Knockdown) and takedamage then
							hitent.ToDismember = true
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
							hitent.ToDismember = nil
					end
					
					
				end
			end
			
		end
	end
	
	if hitfl then
		self:PlayHitFleshSound()
	end
	
	
end

function SWEP:Reload()
		
	if self:Clip1() > 0 then return end
		
	self.Weapon:SetNextPrimaryFire(CurTime() + 2)
	if SERVER then
		self.Owner:Give( "sogm_axe" )
		self.Owner:SelectWeapon( "sogm_axe" )
		self:Remove()
	end
	return 
end



function SWEP:OnKill( ply, attacker )
	if self:IsSwinging() or self.FirstHit then
	
	else
		ply.ToDismember = HITGROUP_HEAD
	end
	if math.random(3) == 3 then
		ply.DeathSequence = { Anim = "death_04", Speed = math.Rand(0.7, 2) }//"death_04"
	end
end


if CLIENT then
function SWEP:DrawWorldModel()
	
	local owner = self:GetOwner()
	if IsValid(owner) and owner.HideWeapon then return end
	
	if IsValid(owner) then
	
		
		//self:SetSequence( self:LookupSequence( "weapon_pistol" ) )
		
		local delta = math.Clamp( 1 - (self:GetNextSwing() - CurTime())/0.2,0,1 )
		
		if delta == 1 then
			delta = math.Clamp( (self:GetNextSwing() + 0.2 - CurTime())/0.2,0,1 )
		end
		
		delta = delta ^ 0.2
		
		
		local bone = owner:LookupBone("ValveBiped.Bip01_L_Forearm")
		if bone then 
			owner:ManipulateBoneAngles( bone, Angle(55,30+50*delta,60)  )
		end
		
		bone = owner:LookupBone("ValveBiped.Bip01_L_Clavicle")
		if bone then 
			owner:ManipulateBoneAngles( bone, Angle(130*delta,0,30*delta)  )
		end
		
		bone = owner:LookupBone("ValveBiped.Bip01_L_UpperArm")
		if bone then 
			owner:ManipulateBoneAngles( bone, Angle(10-50*delta,-80,20-40*delta)  )
		end
		bone = owner:LookupBone("ValveBiped.Bip01_L_Hand")
		if bone then 
			owner:ManipulateBoneAngles( bone, Angle(-1,0,-10)  )
		end
		
		bone = owner:LookupBone("ValveBiped.Bip01_R_Clavicle")
		if bone then 
			owner:ManipulateBoneAngles( bone, Angle(0,40,0)  )
		end
		
		bone = owner:LookupBone("ValveBiped.Bip01_R_UpperArm")
		if bone then 
			owner:ManipulateBoneAngles( bone, Angle(-5,-40,-10)  )
		end
		
		bone = owner:LookupBone("ValveBiped.Bip01_R_Forearm")
		if bone then 
			owner:ManipulateBoneAngles( bone, Angle(0,40,40)  )
		end
		
		bone = owner:LookupBone("ValveBiped.Bip01_R_Hand")
		if bone then 
			owner:ManipulateBoneAngles( bone, Angle(-10,20,-10)  )
		end
	
	end
	
	//self:DrawModel()
	
	self:SCK_DrawWorldModel()
	
end
end