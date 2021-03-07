local exp = {
	"scary", "custom", "terrible", "paid", "corrupted", "realistic", "disgusting", "pointless", "true", "awkward", "false",
	"boring", "dark", "stupid", "exciting", "sarcastic", "satiric", "violent", "hopeless", "pointy", "dead", "milked", "gruesome",
	"fake", "vip", "fucked up", "your", "banned", "ddosed", "dmca", "rusty", "educational", "generic", "tyrannical", "childish", "ambitious"
}

//And this is why we can't have nice stuff in GMod anymore
local tags = {
	"POINTSHOP", "Shitty Admins" , "Paid Admins", "0 k start", "CUSTOM!!!", "Puberty", "Fun", "3X FUN!!1", "3+ Admins",
	"Mature", "Boys only", "Poop SWEP", "GENERIC", "No Lag", "No Fun", "Jihad", "N00B FRIENDLY", "No Parents",
	"SlowDL", "CoderHire scripts", "PAY 2 WIN", "RTV", "HORSE PLAYERMODELS!!!", "Toys", "7/24", "Lazy Staff", "Drugs", "Corn",
	"K9M", "ATM", "Semi-srs", "Free PERP", "Custom Loading Screen!", "Gym", "DMCA", "YouPube addon", "12-year old gentlemen", "Wiryamod",
	"Hiring Janitors", "NEW", "SCors", "1-year old owner", "BallPit!", "Respect the Admins!", "xDDD", "Nude", "Not so Unique", "Diapers",
	"2 custom taunts", "new uniqye servr", "New Hets", "More Horses", "Minyacravt Map!", "Approved by gary!!!", "Better than others!", "JOIN ASS",
	"Professional kids", "Donate to join", "Low Karma", "C-C-C-CUSTOM", "Excitement", "Moustaches", "RDM or kick", "Lorepray", "SCREAMING KIDS", 
	"Moni Printers", "-=EPIC=-", "Even more CUSTOM", "JOIN TODAY!", "Terrible tags", "JOIN NOW, ASK LATER", "Pinion-Powered", "POPPORN",
	"VIP", "CUSTOM DOORS", "Clean seats", "69Tick", "XP!", "DEV VERSION", "Unique Rank System", "Heavily Customized", "100% Original", "Chairs", "140+ useless jobs!",
	"Loading screen with Dubstep!", "Real Admins", "KFC", "Juicy", "Leaked Addons!", "Amazing Donator BJs", "MAKE MY MOMMY PROUD!", "The Best", "Pointpop 2.0!", 
	"DRAMA-FREE", "Secksy!", "Everybody vape!" 
}

/*local function textspin( freq )
	return math.sin( RealTime() * ( freq ) ) * 2
end*/

local function textspin( freq, am, shift )
	return math.sin( ( RealTime() + (shift or 0) ) * ( freq ) ) * ( am or 2 )
end

local mat = Material( "sog/bg_gradient3.png" )
function CreateMenuBackground( parent )
	
	local dead = SOG_BEAT_STORY
	
	if NORMAL_BACKGROUND then
		dead = false
	end
	
	local p = parent:Add( "DPanel" )
	p:SetSize( parent:GetSize() )
	p:SetPos( 0, 0 )
	p.TitleText = "slave of Gmod"
	
	if SOG_MENU_MUSIC then
		if game.SinglePlayer() then
			if dead then
				GAMEMODE:CreateMusic( MUSIC_TYPE_NORMAL, 341536885, 50, false, 35*1000, nil )
			else
				GAMEMODE:CreateMusic( MUSIC_TYPE_NORMAL, 252181721, 50, false, nil, nil )
			end
		else
			GAMEMODE:CreateMusic( MUSIC_TYPE_NORMAL, 71985069, 60, false, 48*1000, nil )
		end
	end
	
	if dead then
		p.BW = true
		BLACK_AND_WHITE = true
	end
	
	
	p.shittags = {}
	
	p.lines = 13
	
	for i = 0, p.lines do
		
		local shittags = table.Copy( tags )
		shittags = table.Shuffle( shittags )
	
		p.shittags[i] = ""
		for _, shit in ipairs( shittags ) do
			p.shittags[i] = shit.." | "..p.shittags[i]
		end
	
	end
	
	if dead then
		for i = 0, p.lines do	
			p.shittags[i] = " Server is not responding | Server is not responding | Server is not responding | Server is not responding | Server is not responding | Server is not responding | Server is not responding | Server is not responding |"
		end
	end
	
	p.OnRemove = function( self )
		if self.shittags then
			table.Empty(self.shittags)
			self.shittags = nil
		end
	end
	
	
	p.Paint = function ( self, sw, sh )
		
		if Cut and Cut:IsValid() and Cut:IsVisible() then return end
		
		local timemul = 1
		
		local r = 0.5*math.sin(RealTime()*timemul)*255 + 255/2
		local g = -0.5*math.sin(RealTime()*timemul)*255 + 255/2
		local b = 210
	
		surface.SetDrawColor( Color(0, 0, 0, 255) )
		surface.DrawRect( 0, 0, sw, sh )
	
		if game.SinglePlayer() then
			r = 250
			g = 0.5*math.sin( RealTime() * timemul ) * 180 + 180/2
			b = 51
		end
		
		if self.BW then
			r = math.sin( RealTime() * timemul ) * 25 + 235
			g = math.sin( RealTime() * timemul ) * 25 + 235
			b = math.sin( RealTime() * timemul ) * 25 + 235
		end
		
		surface.SetDrawColor( Color( r, g, b, 180) )
		surface.SetMaterial( mat )
		surface.DrawTexturedRect( -sw/2, 0, sw, sh*1.4 )
		surface.DrawTexturedRect( sw/2, 0, sw, sh*1.4 )
		
		
		surface.SetTextColor( color_white )
		surface.SetFont( "MenuHeader" )
		
		local spin = textspin( 1 )
		
		local rotation = -6.5
		local rotation2 = 4.5
		
		local pushout = math.sin( RealTime() * ( 3 ) ) * 3
		
		local tw, th = surface.GetTextSize( self.TitleText )
				
		local dist = 2
		
		self.NextWord = self.NextWord or 0
		
		if not self.CurWord then
			self.CurWord = exp[math.random(#exp)]
		end
		
		if self.NextWord < CurTime() and pushout < 0 then
			self.CurWord = exp[math.random(#exp)]
			self.NextWord = CurTime() + 1.5
		end
		
		if self.OverrideCurWord then
			self.CurWord = self.OverrideCurWord
		end
		
		local step = 1
		local add = 50
		
		for i=0, self.lines do
			if self.shittags then
				draw.ScrollingTextRotated( self.shittags[i], sw/4-130 - add * i , sh/2, sw, -1*(50 + 15 * i ), Color( 10, 10, 10, math.Clamp(85 - 5*i,0,255 )), "PixelSmall", 50, 1)
				draw.ScrollingTextRotated( self.shittags[i], 3*sw/4+130 + add * i, sh/2, sw, 50 + 15 * i, Color( 10, 10, 10, math.Clamp(85 - 5*i,0,255 )), "PixelSmall", -50, 1)
			end	
		end
		
		local am = 15 //the bigger the more fps drops
		
		for i=0,am do
		
			local r = 0.5*math.sin((RealTime()+0.8*i/am)*2)*180 + 180/2
			local g = -0.5*math.sin((RealTime()+0.8*i/am)*2)*180 + 180/2
			local b = 255
			
			if game.SinglePlayer() then
				r = 255
				g = 0.5*math.sin( ( RealTime() + 0.8 * i/am ) * 2 )*180 + 180/2
				b = 31
			end
			
			if self.BW then
				r = math.sin( ( RealTime() + 0.8 * i/am ) * 2 ) * 55 + 220
				g = math.sin( ( RealTime() + 0.8 * i/am ) * 2 ) * 55 + 220
				b = math.sin( ( RealTime() + 0.8 * i/am ) * 2 ) * 55 + 220
			end
		
			if i==0 or pushout > 0 then
				local col = Color( 107 + pushout*3*i, 0, 37, 255 )
				
				if game.SinglePlayer() then
					col = Color( 250, 107 + pushout*3*i, 31, 255 )
				end
				
				if self.BW then
					col = Color( 190 + pushout*3*i, 190 + pushout*3*i, 190 + pushout*3*i, 255 )
				end
				
				draw.TextRotated(self.CurWord.." gmod experience", sw/2 + rotation*(i/am * pushout), sh/5 + rotation2*(i/am * pushout) + 90 , col,"NumbersSmall", spin, 1.5)
				
				//if game.SinglePlayer() then
				//	draw.TextRotated(self.CurWord.." gmod experience", sw/2 + rotation*(i/am * pushout), sh/5 + rotation2*(i/am * pushout) + 90 ,Color( 250, 107 + pushout*3*i, 31, 255),"NumbersSmall", spin, 1.5)
				//else
					//draw.TextRotated(self.CurWord.." gmod experience", sw/2 + rotation*(i/am * pushout), sh/5 + rotation2*(i/am * pushout) + 90 ,Color( 107 + pushout*3*i, 0, 37, 255),"NumbersSmall", spin, 1.5)
				//end
			end
			
			if i == 0 or i == am then
				draw.TextRotated( self.TitleText, sw/2, sh/5 - 30, Color(r,g,b,250), "MenuHeader",textspin(1,2,0.9*i/am), 1.5 + 0.01*i, 1 )
			else
				draw.TextRotated( self.TitleText, sw/2, sh/5 - 30, Color(r,g,b,250), "MenuHeader",textspin(1,2,0.9*i/am), 1.5 + 0.01*i, false )
			end
		end
		
		local gametype = GAMEMODE:GetGametype() and GAMEMODE.AvalaibleGametypes[GAMEMODE:GetGametype()] and GAMEMODE.AvalaibleGametypes[GAMEMODE:GetGametype()].name
		if SINGLEPLAYER then
			gametype = "Story Mode"
		end
		draw.SimpleText( GAMEMODE.Version or "error", "PixelSmaller", sw-10, 25, Color(10, 10, 10, 155), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
		draw.SimpleText( gametype or "error", "PixelSmaller", sw-10, 50, Color(10, 10, 10, 155), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )


	end
	
	return p

end