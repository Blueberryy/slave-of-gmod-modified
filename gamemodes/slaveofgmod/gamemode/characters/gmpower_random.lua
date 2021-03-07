CHARACTER.Reference = "gmpower random"

CHARACTER.Name = "GMod Power Player"
CHARACTER.Description = ""

CHARACTER.Health = 100
CHARACTER.Speed = 380

CHARACTER.NoMenu = true

CHARACTER.StartingWeapon = nil//"sogm_fists"
CHARACTER.RemoveDefaultFists = true

CHARACTER.Model = Model( "models/player/group02/male_06.mdl" )

CHARACTER.OverrideColor = Color( 47, 89, 185 )

local models = {
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

function CHARACTER:OnSpawn( pl )
	pl:SetModel( models[ math.random(#models) ] )
	if pl:IsNextBot() then
		pl:SetNextBotColor( Color( 47, 89, 185 ) )
	end	
end