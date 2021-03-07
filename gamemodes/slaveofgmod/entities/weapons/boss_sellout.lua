AddCSLuaFile()

include("sck.lua")

SWEP.Base 					= "sogm_shotgun" 

SWEP.ViewModel 				= Model( "models/weapons/cstrike/c_rif_ak47.mdl" )
SWEP.WorldModel 			= Model( "models/weapons/w_shotgun.mdl" )

SWEP.PrintName				= "Like and Subscribe"

SWEP.Primary.Sound			= Sound("Weapon_Shotgun.Single")

SWEP.Primary.ClipSize		= 10
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize
SWEP.Primary.Delay			= 0.53

SWEP.HoldType 				= "ar2"
SWEP.Hidden					= true

SWEP.WElements = {
	["cam"] = { type = "Model", model = "models/maxofs2d/camera.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "sellout_jr", pos = Vector(2.466, -0.65, -1.703), angle = Angle(0, 19.753, -0.213), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["sellout_jr"] = { type = "Model", model = "models/props_c17/doll01.mdl", bone = "ValveBiped.Bip01_Spine4", rel = "", pos = Vector(5.889, 0.713, 6.119), angle = Angle(11.519, 42.891, 98.847), size = Vector(0.497, 0.497, 0.497), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
	self:SetHoldType(self.HoldType)		
	if CLIENT then
		self:CreateModels(self.WElements)
	end
	self:DrawShadow(false)
end


if CLIENT then
function SWEP:DrawWorldModel()
	local owner = self:GetOwner()
	if IsValid(owner) and owner.HideWeapon then return end
	
	owner:DrawShadow( false )
	
	self:DrawModel()

	self:SCK_DrawWorldModel()	
end
end

