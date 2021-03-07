CHARACTER.Reference = "bonus slave2"

CHARACTER.Name = "Slave 2 (BobbleHead Corrupt)"
CHARACTER.Description = ""

CHARACTER.Health = 300
CHARACTER.Speed = 300
CHARACTER.KnockdownImmunity = true
CHARACTER.NoPickups = true
CHARACTER.YellowBlood = true


CHARACTER.NoMenu = true
CHARACTER.HideOriginalModel = true
CHARACTER.NoArmorBoneScale = true

CHARACTER.StartingWeapon = "sogm_fists_scary"

CHARACTER.Model = Model( "models/zombie/poison.mdl" )

function CHARACTER:OnSpawn( pl )
	pl:SetMaterial( "models/flesh" )
	//pl:SetMaterial( "models/gman/gman_facehirez" )
	pl:SetModelScale( 1.7, 0 )
	local armor = pl:SpawnBodywear( "models/player/gman_high.mdl" )
	
	armor:SetSubMaterial( 1, "models/flesh" )
	//armor:SetSubMaterial( 3, "models/gman/plyr_sheet" )
	//armor:SetSubMaterial( 2, "models/gman/gman_facehirez" )
end

/*function CHARACTER:OnMeleeHit( pl, hitpos, hitnormal, dir, attacker ) 
	
	if SERVER then
		local wep = attacker and attacker.GetActiveWeapon and attacker:GetActiveWeapon()
		if wep and wep:IsValid() and ( wep:GetClass() == "sogm_fists_kill" or wep:GetClass() == "sogm_fists_concrete" or wep:GetClass() == "sogm_fists_henry" or wep:GetClass() == "sogm_axe" ) then
			pl:DoKnockdown( 2.3, true, attacker )
		end
	end

	return true
end*/

local bones = {}

bones[ "ValveBiped.Bip01_Head1" ] = { ang = Angle( 0, 0, -90 ), scale = Vector( 1.6, 1.6, 1.6 ) }
bones[ "ValveBiped.Bip01_Spine4" ] = { scale = Vector( 1.5, 2, 1.5 ) }
bones[ "ValveBiped.Bip01_Spine2" ] = { scale = Vector( 1.5, 1.5, 1.5 ) }

function CHARACTER:ArmorBoneScaling( ent )
	
	for k, v in pairs( bones ) do
		local bone = ent:LookupBone( k )
		if bone then
			if v.ang then
				if ent:GetManipulateBoneAngles( bone ) ~= v.ang then
					ent:ManipulateBoneAngles( bone, v.ang  )
				end
			end
			if v.scale then
				if ent:GetManipulateBoneScale( bone ) ~= v.scale then
					ent:ManipulateBoneScale( bone, v.scale  )
				end
			end
		end
	end
	
end

function CHARACTER:OnBulletHit( pl, hitpos, hitnormal, dir, dmginfo ) 
	
	if not pl.Bleeding then
		pl.Bleeding = dmginfo:GetAttacker()
		pl:SetBleeding( true )
		pl.BleedingDmgInfo = dmginfo
		
		pl:Fire( "bleedout", "", BLEEDOUT_TIME )	
	end

	return true
end