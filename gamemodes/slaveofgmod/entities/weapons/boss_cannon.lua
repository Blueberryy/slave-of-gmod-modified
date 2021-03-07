AddCSLuaFile()

include("sck.lua")

//rpg_missile

SWEP.Base 					= "sogm_m4" 

SWEP.ViewModel 				= Model( "models/weapons/cstrike/c_rif_ak47.mdl" )
SWEP.WorldModel 			= Model( "models/weapons/w_rocket_launcher.mdl" )

SWEP.PrintName				= "DDOS Cannon"

SWEP.Primary.Sound 			= Sound("PropAPC.FireRocket")

SWEP.Primary.ClipSize		= 10
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize
SWEP.Primary.Delay			= 0.53

SWEP.HoldType 				= "duel"
SWEP.ShowWorldModel			= false
SWEP.Hidden					= true

SWEP.WElements = {
	["cannon1"] = { type = "Model", model = "models/weapons/w_rocket_launcher.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(16.471, 4.222, -0.604), angle = Angle(-180, -9.077, 176.13), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["cannon1+"] = { type = "Model", model = "models/weapons/w_rocket_launcher.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(17.093, 3.023, 0.282), angle = Angle(-180, -9.077, 5.607), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
	self:SetHoldType(self.HoldType)		
	if CLIENT then
		self:CreateModels(self.WElements)
	end
	self:DrawShadow(false)
end

function SWEP:FireBullet()

	local owner = self:GetOwner()
	local aim = owner:GetAimVector()	
	
	if game.SinglePlayer() then
		owner:ShakeView( math.random(1,4) ) 
	else
		if CLIENT then
			GAMEMODE:ShakeView( math.random(1,4) )
		end
	end
	
	if SERVER then
			
		local pr = ents.Create("rpg_missile")
		
		if IsValid(pr) then
			
			local att = "anim_attachment_RH"
			
			self.Switch = self.Switch or false
			att = self.Switch and "anim_attachment_LH" or "anim_attachment_RH"
			self.Switch = !self.Switch
									
			pr:SetPos((owner:GetAttachment(owner:LookupAttachment(att)) and owner:GetAttachment(owner:LookupAttachment(att)).Pos or owner:GetShootPos()) + aim * 35)
			pr.Inflictor = self
			pr:SetAngles(aim:Angle())
			pr:SetSaveValue( "m_flDamage", 0 ) 
			pr:SetOwner(owner)
			pr:Spawn()
			pr:Activate()
			
			pr:SetVelocity( aim:Angle():Forward() * 300 )
			
			pr.Owner = owner
			//PrintTable(pr:GetSaveTable())
			pr.Team = function() return owner:Team() end
						
		end
	
	end
	
end

if SERVER then
	hook.Add( "EntityRemoved", "FixRocketDamage", function( ent )
		if ent and ent:IsValid() and ent:GetClass() == "rpg_missile" then
			util.BlastDamage( ent, ent.GetOwner and IsValid(ent:GetOwner()) and ent:GetOwner() or ent, ent:GetPos(), 150, 330 )
		end
	end)
end

if CLIENT then
function SWEP:DrawWorldModel()
	local owner = self:GetOwner()
	if IsValid(owner) and owner.HideWeapon then return end
	
	owner:DrawShadow( false )

	self:SCK_DrawWorldModel()	
end
end