AddCSLuaFile()

include("sck.lua")

SWEP.Base 					= "sogm_m4" 

SWEP.ViewModel 				= Model( "models/weapons/cstrike/c_rif_ak47.mdl" )
SWEP.WorldModel 			= Model( "models/weapons/w_rocket_launcher.mdl" )

SWEP.PrintName				= "Napalm Thrower"

SWEP.Primary.Sound 			= Sound("ambient/fire/gascan_ignite1.wav")

SWEP.Primary.ClipSize		= 150
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize
SWEP.Primary.Delay			= 0.07
SWEP.Primary.Spread 		= 0.14

SWEP.HoldType 				= "crossbow"
SWEP.ShowWorldModel			= false
SWEP.MapOnly				= true

SWEP.WElements = {
	["pipe"] = { type = "Model", model = "models/props_canal/mattpipe.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "canister", pos = Vector(0.769, 4.989, 1.985), angle = Angle(102.138, -107.918, 0), size = Vector(0.514, 0.514, 0.514), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["gascan"] = { type = "Model", model = "models/props_junk/metalgascan.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(3.542, 3.552, 4.981), angle = Angle(164.485, 84.484, 90), size = Vector(0.483, 0.483, 0.483), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["barrel"] = { type = "Model", model = "models/weapons/w_rocket_launcher.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(25.138, -4.318, -2.576), angle = Angle(0, -176.017, -100.501), size = Vector(0.864, 0.864, 0.864), color = Color(255, 255, 255, 255), surpresslightning = false, material = "models/props_canal/mattpipe_sheet", skin = 0, bodygroup = {} },
	["canister"] = { type = "Model", model = "models/props_citizen_tech/firetrap_propanecanister01a.mdl", bone = "ValveBiped.Bip01_Spine2", rel = "", pos = Vector(-7.901, 4.205, -5.712), angle = Angle(0, -90, -86.397), size = Vector(0.326, 0.326, 0.326), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
	self:SetHoldType(self.HoldType)		
	if CLIENT then
		self:CreateModels(self.WElements)
	end
	self:DrawShadow(false)
end

function SWEP:EmitFireSound()
end

function SWEP:Think()

	if SERVER then
				
		if not self.FireSound then
			self.FireSound = CreateSound( self.Owner, "ambient/fire/fire_big_loop1.wav" )
		end
		
		if self.FireSound then
			if self.PlayFireSound and self.PlayFireSound >= CurTime() then//self:GetDTFloat( 1 ) >= CurTime() then
				self.FireSound:PlayEx( 1, 80 )
			else
				self.FireSound:Stop()
			end
		end
		
		
	end
	
end

if SERVER then
function SWEP:OnRemove()
	if self.FireSound then
		self.FireSound:Stop()
	end
end
end

function SWEP:NextbotThink()
	self:Think()
end

local Rand = math.Rand
local trace = { mask = MASK_SOLID }
function SWEP:FireBullet()

	local owner = self:GetOwner()
	local aim = owner:GetAimVector()	
	
	
	
	if SERVER then
		
		local pr = ents.Create("sogm_napalm")
		
		if IsValid(pr) then
		
			//self:SetDTFloat( 1, CurTime() + 0.1 )
			local att = "anim_attachment_RH"
			
			self.PlayFireSound = CurTime() + 0.1
			
			local rand = Rand(-self.Primary.Spread, self.Primary.Spread) * (owner:GetCharTable().SpreadMultiplier or 1)
			
			trace.start = owner:GetShootPos()
			trace.endpos = (owner:GetAttachment(owner:LookupAttachment(att)) and owner:GetAttachment(owner:LookupAttachment(att)).Pos or owner:GetShootPos()) + aim * 25
			trace.filter = {owner, self }
			
			local tr = util.TraceLine(trace)
			
			local spread = aim:Angle():Right() * rand
								
			pr:SetPos( tr.HitPos or owner:GetShootPos() )
			pr.Inflictor = self
			pr:SetAngles( aim:Angle() )
			pr:SetOwner(owner)
			pr:Spawn()
			pr:Activate()
			
			//pr:Ignite( 9999, 0 )
			
			local vel = math.random( 650, 700 )
			
			pr:SetVelocity( ( aim + spread ) * vel )
			local phys = pr:GetPhysicsObject()
			if phys:IsValid() then
				phys:SetVelocityInstantaneous( ( aim + spread ) * vel )
			end
			pr.Owner = owner
			
			pr.Team = function() return owner:Team() end
						
		end
	
	end
	
end


if CLIENT then
function SWEP:DrawWorldModel()
	local owner = self:GetOwner()
	if IsValid(owner) and owner.HideWeapon then return end
	
	owner:DrawShadow( false )

	self:SCK_DrawWorldModel()	
end
end