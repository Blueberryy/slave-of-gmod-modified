AddCSLuaFile()

SWEP.Base 				= "sogm_magnum" 

SWEP.WorldModel			= Model( "models/weapons/w_pist_deagle.mdl" )

SWEP.PrintName			= "Desert Eagle"

SWEP.Primary.Sound		= Sound("Weapon_Deagle.Single")
SWEP.Primary.ClipSize	= 7
SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize
SWEP.Primary.Damage		= 300
SWEP.Primary.Delay		= 0.25
SWEP.Primary.Spread 	= 0.042
SWEP.PenetratingBullets = true

SWEP.ShellEffect		= "ef_shelleject" 

SWEP.AkimboClass 		= "sogm_deagle_akimbo"

function SWEP:OnKill( ply, attacker )
	ply.ToDismember = math.random(4) ~= 4 and HITGROUP_HEAD or true
	if math.random(3) ~= 3 then
		ply.DeathSequence = { Anim = "death_04", Speed = math.Rand(1, 1.8) }
	end
end

if CLIENT then
local ang_flip = Angle(0,0,-90)
local vec_up = vector_up
function SWEP:DrawWorldModel()
	
	local owner = self:GetOwner()
	if IsValid(owner) and owner.HideWeapon then return end
	
	owner:DrawShadow( false )
	
		if owner:IsNextBot() then
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
		end
	
	if IsValid(self.Owner) then
		local bone = self.Owner:LookupBone("ValveBiped.Bip01_R_Hand")
		if bone and self.Owner:GetManipulateBoneAngles(bone) ~= ang_flip then 
			self.Owner:ManipulateBoneAngles( bone, ang_flip  )
		end
	end
	
	self:DrawModel()
	
end
end