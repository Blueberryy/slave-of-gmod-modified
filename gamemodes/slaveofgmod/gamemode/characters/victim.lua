//should've used a better way to make misc characters, but whatever
CHARACTER.Reference = "victim"

CHARACTER.Name = "Victim"
CHARACTER.Description = ""

CHARACTER.Health = 100
CHARACTER.Speed = 380

CHARACTER.NoMenu = true

CHARACTER.Icon = Material( "sog/victim1.png" )

CHARACTER.Model = Model( "models/player/kleiner.mdl" )

function CHARACTER:OnSpawn( pl )
	pl:SetSubMaterial( 3 , "models/monk/grigori_head" )
end