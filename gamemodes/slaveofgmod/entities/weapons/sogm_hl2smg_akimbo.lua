AddCSLuaFile()

include("sck.lua")

SWEP.Base 				= "sogm_hl2smg" 

SWEP.HoldType				= "duel"

SWEP.Primary.ClipSize		= 60
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize

SWEP.SingleClass = "sogm_hl2smg"
SWEP.Akimbo = true

SWEP.WElements = {
	["1"] = { type = "Model", model = "models/weapons/w_smg1.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(10.927, 3.482, 4.177), angle = Angle(7.951, -10.216, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
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
local ang_flip = Angle(0,0,-40)
local vec_up = vector_up
function SWEP:DrawWorldModel()
	
	local owner = self:GetOwner()
	if IsValid(owner) and owner.HideWeapon then return end
	
	owner:DrawShadow( false )
	
	self:DrawModel()
	
	if IsValid(self.Owner) then
		local bone = self.Owner:LookupBone("ValveBiped.Bip01_R_Hand")
		if bone then 
			self.Owner:ManipulateBoneAngles( bone, ang_flip )
		end
		local bone = self.Owner:LookupBone("ValveBiped.Bip01_L_Hand")
		if bone then 
			self.Owner:ManipulateBoneAngles( bone, ang_flip * -1 )
		end
		
		self:AkimboDraw()
		
	end
	
	self:SCK_DrawWorldModel()
		
end
end