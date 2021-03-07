AddCSLuaFile()

include("sck.lua")

SWEP.Base 					= "sogm_magnum" 

SWEP.HoldType				= "duel"

SWEP.Primary.ClipSize		= 12
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize

SWEP.SingleClass 			= "sogm_magnum"
SWEP.Akimbo 				= true

SWEP.WElements = {
	["1"] = { type = "Model", model = "models/weapons/w_357.mdl", bone = "ValveBiped.Bip01_L_Hand", rel = "", pos = Vector(1.952, 1.179, 2.111), angle = Angle(-3.021, -12.263, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
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