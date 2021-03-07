AddCSLuaFile()

SWEP.Base 				= "sogm_usp" 

SWEP.WorldModel			= Model( "models/weapons/w_snip_awp.mdl" )

SWEP.PrintName			= "Motherfucking Magnum"

SWEP.Primary.Sound		= Sound("Weapon_AWP.Single") 
SWEP.Primary.ClipSize	= 6
SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize
SWEP.Primary.Damage		= 500
SWEP.Primary.Delay		= 0.7
SWEP.Primary.Spread 	= 0
SWEP.PenetratingBullets = true

SWEP.MinShake 			= 5
SWEP.MaxShake 			= 8

SWEP.ShellEffect		= "ef_shelleject_rifle" 
SWEP.HoldType 			= "ar2"
SWEP.Gametype 			= "singleplayer"

SWEP.AkimboClass 		= false

function SWEP:OnKill( ply, attacker )
	ply.ToDismember = HITGROUP_HEAD
	if math.random(3) ~= 3 then
		ply.DeathSequence = { Anim = "death_04", Speed = math.Rand(1, 1.8) }
	end
end

if CLIENT then
local vec_up = vector_up
local mat_beam = Material( "effects/laser1" )
local mat_glow = Material( "effects/yellowflare" )
local vec_add = Vector( 128, 128, 128 )

local trace = { mask = MASK_PLAYERSOLID }

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
	
	local att = self:GetAttachment( 2 )
	//local tr = owner:GetEyeTrace()
	
	if att and att.Pos and att.Ang then
	
		trace.start = att.Pos
		trace.endpos = trace.start + owner:GetForward() * 9999
		trace.filter = owner
	
		//local tr
		
		//if owner:IsNextBot() then
		//	tr = owner:GetEyeTrace()
		//else
			tr = util.TraceLine( trace )
		//end
	
		if tr.Hit and tr.HitPos then

			self:SetRenderBoundsWS( att.Pos, tr.HitPos, vec_add ) 
			--if owner:IsNextBot() then
				--owner:SetRenderBoundsWS( att.Pos, tr.HitPos, vec_add ) 
			--end
		
			render.SetMaterial( mat_beam )
			render.DrawBeam( tr.HitPos, att.Pos, 20 + math.sin( RealTime() * 35 ) * 2, RealTime()*1.7, RealTime()*1.7 + 1.8 + math.cos( RealTime() * 1 )*0.2, Color( 235, 0, 0, 255 ) )
			
			local sz = 30 + math.sin( RealTime() * 60 ) * 5
			
			render.SetMaterial( mat_glow )
			render.DrawSprite( tr.HitPos, sz, sz,Color( 235, 0, 0, 255 )  ) 
		end
	
	end
	
	self:DrawModel()
	
end
end