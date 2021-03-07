AddCSLuaFile()

include("sck.lua")

//rpg_missile

SWEP.Base 					= "sogm_m4" 

SWEP.ViewModel 				= Model( "models/weapons/cstrike/c_rif_ak47.mdl" )
SWEP.WorldModel 			= Model( "models/weapons/w_rocket_launcher.mdl" )

SWEP.PrintName				= "RPG"

SWEP.Primary.Sound 			= Sound("PropAPC.FireRocket")

SWEP.Primary.ClipSize		= 6
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize
SWEP.Primary.Delay			= 1

SWEP.HoldType 				= "rpg"
SWEP.Gametype 				= "singleplayer"


local trace = { mask = MASK_SHOT}
function SWEP:FireBullet()

	local owner = self:GetOwner()
	local aim = owner:GetAimVector()	
	
	if game.SinglePlayer() then
		owner:ShakeView( math.random(4,7) ) 
	else
		if CLIENT then
			GAMEMODE:ShakeView( math.random(4,7) )
		end
	end
	
	if SERVER then
						
		local pr = ents.Create("rpg_missile")
		
		if IsValid(pr) then
			
			local att = "anim_attachment_RH"
			
			trace.start = owner:GetShootPos()
			trace.endpos = (owner:GetAttachment(owner:LookupAttachment(att)) and owner:GetAttachment(owner:LookupAttachment(att)).Pos or owner:GetShootPos()) + aim * 35
			trace.filter = { owner, self }
			
			local tr = util.TraceLine(trace)
			
			pr:SetPos( tr.HitPos or owner:GetShootPos() )
			pr.Inflictor = self
			pr:SetAngles(aim:Angle())
			pr:SetSaveValue( "m_flDamage", 0 ) 
			pr:SetOwner(owner)
			pr:SetCollisionGroup(COLLISION_GROUP_PUSHAWAY)
			pr:Spawn()
			pr:Activate()
			
			/*local dummy = ents.Create( "rocket_dummy" )
			dummy:SetPos( pr:GetPos() )
			dummy:SetAngles( pr:GetAngles() )
			dummy:SetParent( pr )
			dummy:Spawn()
			dummy:Activate()
			
			pr:DeleteOnRemove( dummy ) */
			
			pr:SetVelocity( aim:Angle():Forward() * 300 )

			pr.Owner = owner
			pr.Team = function() return owner:Team() end
						
		end
	
	end
	
end