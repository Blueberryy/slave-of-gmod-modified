CHARACTER.Reference = "pr3"

CHARACTER.Name = "Martin and Chris"
CHARACTER.Description = "Axe and guns."//"Glock and axe.  No other pickups."

CHARACTER.Health = 100
CHARACTER.Speed = 380

CHARACTER.StartingWeapon = "sogm_axe"//"sogm_glock_axe"
//CHARACTER.AllowReload = true
//CHARACTER.Hidden = true
CHARACTER.GametypeSpecific = "nemesis"
CHARACTER.DontLoseWeapon = true
CHARACTER.NoPickups = true
CHARACTER.SpotDelay = 0.85//1.1

CHARACTER.CanKnockThugs = true

CHARACTER.Icon = Material( "sog/male_07.png", "smooth" )

CHARACTER.Model = Model( "models/player/group01/male_07.mdl" )

function CHARACTER:OnSpawn( pl )
	
	if pl.Buddy and pl.Buddy:IsValid() then
		pl.Buddy:Remove()
		pl.Buddy = nil
	end
	
	local b = ents.Create( "sogm_buddy" )
	b:SetPos( pl:GetPos() )
	b:SetCharacter( 0 )
	b:SetNextBotColor( color_white )//Vector( 1, 1, 1 ) 
	b:SetOwner( pl )
	
	pl.Buddy = b
	pl:SetBuddy( b )
		
	b:Spawn()
	b:SetModel( "models/player/group01/male_07.mdl" )
	
	//b.WalkSpeed = 500

	//b.loco:SetAcceleration( b.WalkSpeed * 2 ) 
	//b.loco:SetDeceleration( b.WalkSpeed * 4 ) 
	
	b:Give( "sogm_shotgun", true )
	
	pl:SetGoal( translate.Get("sog_play_tip_protagonist3"), 25 )
	
	//pl:SetGoal( translate.Get("sog_play_tip2_protagonist3"), 15 )//  Walk over the guns when out of ammo.

end

function CHARACTER:OnDeath( pl, attacker, dmginfo )
	
	if pl.Buddy and pl.Buddy:IsValid() then// and pl.Buddy:Alive()
	
		local dmginfo = DamageInfo()
			dmginfo:SetDamagePosition( pl.Buddy:GetPos() )
			dmginfo:SetDamage( pl.Buddy:Health() )
			dmginfo:SetAttacker( pl.Buddy )
			dmginfo:SetInflictor( pl.Buddy )
			dmginfo:SetDamageType( DMG_SLASH )
			dmginfo:SetDamageForce( VectorRand() * 200) 
		//pl.Buddy.DeathSequence = { Anim = "death_04", Speed = math.Rand(1, 1.2) }
		pl.Buddy:TakeDamageInfo( dmginfo )
		//pl.Buddy:Remove()
	end
	
end

if SERVER then
	hook.Add("PlayerDisconnected","RemoveBuddy",function(pl)
		if pl.Buddy and pl.Buddy:IsValid() then
			pl.Buddy:Remove()
		end
	end)
end

function CHARACTER:OnKnockdown( pl, attacker, punch )
	if attacker and attacker == pl.Buddy then
		return false
	end
	
	return true
end

function CHARACTER:OnBulletHit( pl, hitpos, hitnormal, dir, dmginfo ) 
	
	local attacker = dmginfo:GetAttacker()
	
	if attacker and (attacker == pl.Buddy or attacker == pl) then
		return false
	end
	
	return true
end

function CHARACTER:OnMeleeHit( pl, hitpos, hitnormal, dir, attacker ) 
		
	if SERVER and attacker and attacker == pl.Buddy then
		return false
	end

	return true
end

local owner_trace = { mask = MASK_SOLID_BRUSHONLY }
function CHARACTER:OverrideSecondaryAttack( pl, weapon ) 
	
	
	if SERVER and pl.Buddy and pl.Buddy:IsValid() then
	
		local wep = pl.Buddy.Weapon and pl.Buddy.Weapon:IsValid()

		if wep then
			weapon.Secondary.Automatic = pl.Buddy.Weapon.Primary.Automatic
		else
			weapon.Secondary.Automatic = false
		end
	
		owner_trace.start = pl:GetShootPos()
		owner_trace.endpos = pl:GetShootPos() + pl:GetAimVector() * 9999
			
		local tr = util.TraceLine( owner_trace )
			
		//for i=1,20 do
			//pl.Buddy.loco:FaceTowards( tr.HitPos )
		//end
		
		//pl.Buddy:SetAngles( tr.Normal:Angle())
		
		pl.Buddy.AimTime = CurTime() + 0.4
		
		pl.Buddy.CallAttack = CurTime() + 0.1
		//pl.Buddy:PrimaryAttack( true )
		
		//for i=1, 10 do
			//pl.Buddy.loco:FaceTowards( pl:GetEyeTrace().HitPos )
		//end
		
		
		//pl.Buddy.loco:FaceTowards( tr.HitPos )
		
		//pl.Buddy:PrimaryAttack( true )
		
	end
	return false
end

/*function CHARACTER:OnWeaponTouch( pl, wep )
	
	local w = pl:GetActiveWeapon()
	
	if w and IsValid(w) and w:GetClass() == "sogm_glock_axe" and w:Clip1() < 1 and wep:GetType() == "ranged" then
	
		pl:EmitSound( "items/itempickup.wav" )
		pl:GiveAmmo( w.Primary.ClipSize, w.Primary.Ammo, false )
		w:DefaultReload( ACT_VM_RELOAD )
		//pl:DoReloadEvent()
		pl:PlayGesture( ACT_HL2MP_GESTURE_RELOAD_REVOLVER  )
		wep:Remove()
		
		return true
	end
end*/