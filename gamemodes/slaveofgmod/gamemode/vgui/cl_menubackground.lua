local exp = {
	"sog_exp_scary", "sog_exp_custom", "sog_exp_terrible", "sog_exp_paid", "sog_exp_corrupted", "sog_exp_realistic", "sog_exp_disgusting", "sog_exp_pointless", "sog_exp_true", "sog_exp_awkward", "sog_exp_false",
	"sog_exp_boring", "sog_exp_dark", "sog_exp_stupid", "sog_exp_exciting", "sog_exp_sarcastic", "sog_exp_satiric", "sog_exp_violent", "sog_exp_hopeless", "sog_exp_pointy", "sog_exp_dead", "sog_exp_milked", "sog_exp_gruesome",
	"sog_exp_fake", "sog_exp_vip", "sog_exp_fucked_up", "sog_exp_your", "sog_exp_banned", "sog_exp_ddosed", "sog_exp_dmca", "sog_exp_rusty", "sog_exp_educational", "sog_exp_generic", "sog_exp_tyrannical", "sog_exp_childish", "sog_exp_ambitious"
}

//And this is why we can't have nice stuff in GMod anymore
local tags = {
	"sog_tag_pointshop", "sog_tag_shitty_admins" , "sog_tag_paid_admins", "sog_tag_zero_k_start", "sog_tag_custom", "sog_tag_puberty", "sog_tag_fun", "sog_tag_mul_thee_fun", "sog_tag_plus_three_admins",
	"sog_tag_mature", "sog_tag_boys_only", "sog_tag_poop_swep", "sog_tag_generic", "sog_tag_no_lag", "sog_tag_no_fun", "sog_tag_jihad", "sog_tag_noob_friendly", "sog_tag_no_parents",
	"sog_tag_slow_dl", "sog_tag_coderhire_scripts", "sog_tag_pay_to_win", "sog_tag_rtv", "sog_tag_horse_player_models", "sog_tag_toys", "sog_tag_all_day", "sog_tag_lazy_staff", "sog_tag_drugs", "sog_tag_corn",
	"sog_tag_k9m", "sog_tag_atm", "sog_tag_semi_srs", "sog_tag_free_perp", "sog_tag_custom_loading_screen", "sog_tag_gym", "sog_tag_dmca", "sog_tag_youpube_addon", "sog_tag_twelve_yo_gentlemen", "sog_tag_wirymod",
	"sog_tag_hiring_janitors", "sog_tag_new", "sog_tag_scors", "sog_tag_one_yo_owner", "sog_tag_ballpit", "sog_tag_respect_the_admins", "sog_tag_haha", "sog_tag_nude", "sog_tag_not_so_unique", "sog_tag_diapers",
	"sog_tag_two_custom_taunts", "sog_tag_new_uniqye_servr", "sog_tag_new_hets", "sog_tag_more_horses", "sog_tag_minyacravt_map", "sog_tag_approved_by_gary", "sog_tag_better_than_others", "sog_tag_join_ass",
	"sog_tag_pro_kids", "sog_tag_donate_to_join", "sog_tag_low_karma", "sog_tag_ccccustom", "sog_tag_excitement", "sog_tag_moustaches", "sog_tag_rdm_or_kick", "sog_tag_lorepray", "sog_tag_screaming_kids", 
	"sog_tag_moni_printers", "sog_tag_epic", "sog_tag_more_custom", "sog_tag_join_today", "sog_tag_terrible_tags", "sog_tag_join_now_ask_later", "sog_tag_pinion_powered", "sog_tag_popporn",
	"sog_tag_vip", "sog_tag_custom_doors", "sog_tag_clean_seats", "sog_tag_sixtynine_tick", "sog_tag_xp", "sog_tag_dev_version", "sog_tag_unique_rank_system", "sog_tag_heavily_customized", "sog_tag_onehundred_original", "sog_tag_chairs", "sog_tag_onehundredforty_useless_jobs",
	"sog_tag_loading_screens_with_dubstep", "sog_tag_real_admins", "sog_tag_kfc", "sog_tag_juicy", "sog_tag_leaked_addons", "sog_tag_amazing_donator_bjs", "sog_tag_make_my_mommy_proud", "sog_tag_the_best", "sog_tag_pointpop_two_dot_zero", 
	"sog_tag_drama_free", "sog_tag_secksy", "sog_tag_everybody_vape" 
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
	p.TitleText = translate.Get("sog_gm_name")
	
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
			p.shittags[i] = translate.Get(shit).." | "..p.shittags[i]
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
			self.CurWord = translate.Get(exp[math.random(#exp)])
		end
		
		if self.NextWord < CurTime() and pushout < 0 then
			self.CurWord = translate.Get(exp[math.random(#exp)])
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
				
				draw.TextRotated(translate.Format("sog_title_x_exp", self.CurWord), sw/2 + rotation*(i/am * pushout), sh/5 + rotation2*(i/am * pushout) + 90 , col,"NumbersSmall", spin, 1.5)
				
				//if game.SinglePlayer() then
				//	draw.TextRotated(translate.Format("sog_title_x_exp", self.CurWord), sw/2 + rotation*(i/am * pushout), sh/5 + rotation2*(i/am * pushout) + 90 ,Color( 250, 107 + pushout*3*i, 31, 255),"NumbersSmall", spin, 1.5)
				//else
					//draw.TextRotated(translate.Format("sog_title_x_exp", self.CurWord), sw/2 + rotation*(i/am * pushout), sh/5 + rotation2*(i/am * pushout) + 90 ,Color( 107 + pushout*3*i, 0, 37, 255),"NumbersSmall", spin, 1.5)
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
		draw.SimpleText( translate.Get(GAMEMODE.Version) or translate.Get("sog_menu_error"), "PixelSmaller", sw-10, 25, Color(10, 10, 10, 155), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )
		draw.SimpleText( gametype or translate.Get("sog_menu_error"), "PixelSmaller", sw-10, 50, Color(10, 10, 10, 155), TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER )


	end
	
	return p

end