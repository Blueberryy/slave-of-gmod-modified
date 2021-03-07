//vanilla character. yes it's you.
CHARACTER.id = 0
CHARACTER.Reference = "default"

CHARACTER.Name = "You"
CHARACTER.Description = "Nothing fancy."

CHARACTER.Health = 100 //Wait a second, but all weapons are 1hk! Why should I bother with it? Reason is: I treat each hit as 100 hp. Could be useful for bosses anyway.

CHARACTER.Speed = 380//360 //Certain gametypes override this anyway

CHARACTER.StartingWeapon = nil //you know

CHARACTER.Icon = Material( "sog/default.png", "smooth" )

CHARACTER.Model = nil

function CHARACTER:OnSpawn( pl )
	if GAMEMODE:GetGametype() == "none" then
		pl:SetGoal( translate.Get(GAMEMODE:GetRandomHint()), 10 )
	end
end

