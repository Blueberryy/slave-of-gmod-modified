CHARACTER.Reference = "pr2"

CHARACTER.Name = "Jane"
CHARACTER.Description = "Agile and Stylish."

CHARACTER.Health = 100
CHARACTER.Speed = 420

//CHARACTER.PenetratingBullets = true
//CHARACTER.SilencedShots = true

CHARACTER.StartingWeapon = "sogm_katana"//"sogm_usp_silenced"
CHARACTER.Stylish = true //why not
CHARACTER.SpotDelay = 0.8

//CHARACTER.BonusPtsOnKill = 100

//CHARACTER.Hidden = true
CHARACTER.GametypeSpecific = "nemesis"

CHARACTER.Icon = Material( "sog/female_02.png", "smooth" )

CHARACTER.Model = Model( "models/player/group03/female_02.mdl" )

function CHARACTER:OnSpawn( pl )
	
	pl:SetGoal( "Hold [SPACEBAR] to slide. You avoid ALL damage while sliding.", 25 )

end

function CHARACTER:OverrideExecution( pl ) 
	pl:PerformRoll()
end

//should not need these two anymore, since roll immunity is handled outside

//return true to allow damage, false to not
/*function CHARACTER:OnBulletHit( pl, hitpos, hitnormal, dir ) 	
	return !pl:IsRolling()
end

function CHARACTER:OnMeleeHit( pl, hitpos, hitnormal, dir ) 
	
	//if !SERVER then return true end
	return !pl:IsRolling()
	
end*/



