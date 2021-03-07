CHARACTER.Reference = "axe guy"

CHARACTER.Name = "Axe Guy"
CHARACTER.Description = "Walking vengeance.  Fast."

CHARACTER.Health = 100

CHARACTER.Speed = 420

CHARACTER.StartingWeapon = nil //he gets one from the car, but not in singleplayer. Might actually change it

if SINGLEPLAYER then
	CHARACTER.StartingWeapon = "sogm_axe"
end
CHARACTER.CanKnockThugs = true

CHARACTER.GametypeSpecific = "axecution"

CHARACTER.Icon = Material( "sog/male_09.png", "smooth" )

CHARACTER.Model = Model( "models/player/group03/male_09.mdl" )