CHARACTER.Reference = "infected"

CHARACTER.Name = "Infected"
CHARACTER.Description = ""

CHARACTER.Health = 100
CHARACTER.Speed = 380

CHARACTER.NoMenu = true

CHARACTER.StartingWeapon = "sogm_dog"
CHARACTER.RemoveDefaultFists = true

CHARACTER.Model = Model( "models/player/group02/male_06.mdl" )

CHARACTER.OverrideColor = Color( 47, 89, 185 )

local models = {
	Model( "models/player/police.mdl" ),
	Model( "models/player/combine_super_soldier.mdl" ),
	Model( "models/player/breen.mdl" ),
	Model( "models/player/group02/male_06.mdl" ),
	Model( "models/player/group01/female_01.mdl" ),
	Model( "models/player/group01/female_02.mdl" ),
	Model( "models/player/group01/female_03.mdl" ),
	Model( "models/player/group01/female_04.mdl" ),
	Model( "models/player/group01/female_05.mdl" ),
	Model( "models/player/group01/female_06.mdl" ),
	Model( "models/player/group01/male_01.mdl" ),
	Model( "models/player/group01/male_03.mdl" ),
	Model( "models/player/group01/male_08.mdl" ),
	Model( "models/player/group01/male_05.mdl" )
}

local sounds = {
	Sound( "ambient/voices/cough1.wav" ),
	Sound( "ambient/voices/cough2.wav" ),
	Sound( "ambient/voices/cough3.wav" ),
	Sound( "ambient/voices/cough4.wav" ),
}

function CHARACTER:OnSpawn( pl )
	pl:SetModel( models[ math.random(#models) ] )
	
	local b = ents.Create( "ent_doppler" )
		b:SetPos( pl:GetPos() )
		b:SetParent( pl )
		b:SetOwner( pl )
	b:Spawn()
	b:SetDistorted( true )
	
	if pl:IsNextBot() then
		pl:SetNextBotColor( Color( 47, 89, 185 ) )
		pl:SetModelScale( 1, 0 )
	end
	
	//local armor = pl:SpawnBodywear( "models/player/zombie_fast.mdl" )
	
	pl.OnThink = function( self )
		
		if !SINGLEPLAYER then return end
		
		pl.NextCough = pl.NextCough or ( CurTime() + math.random(1,20) )
		
		if pl.NextCough < CurTime() then
			pl:EmitSound( sounds[math.random(#sounds)], 130, math.random( 75, 125 ), 1)
			pl.NextCough = CurTime() + math.random(3,20)
		end
		
	end
	
end