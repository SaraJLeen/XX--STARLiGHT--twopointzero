function SetRandomTheme()
	--April Fools (Sara)
	if (MonthOfYear()+1) == 4 and DayOfMonth() == 1 then
		if ANNOUNCER:GetCurrentAnnouncer() == "DDR Extreme Customized" then ANNOUNCER:SetCurrentAnnouncer("DDR Extreme Customized AF") end
	else
		if ANNOUNCER:GetCurrentAnnouncer() == "DDR Extreme Customized AF" then ANNOUNCER:SetCurrentAnnouncer("DDR Extreme Customized") end
	end

	--Cycling themes (Sara)
	--[[
	local frames = {
	  {"Default","DEFAULT"},
	  {"OG","STARLiGHT 1.0"},
	  {"OLD","STARLiGHT 2011"},
	  {"SN1","SuperNOVA"},
	  {"SN2", "SuperNOVA2"},
	  {"X1", "X"},
	  {"X2", "X2"},
	  {"SN3","SuperNOVA3"},
	  {"NG2","Next Generation 2"},
	  {"Retrowave","Retrowave"},
	  {"ITG1","In The Groove"},
	  {"ITG2","In The Groove 2"},
	};
	local frames = {
	  {"Default", "DEFAULT (fz)", "Default"},
	  {"saiiko", "saiiko", "sk2_menu2"},
	  {"vortivask", "DJ Vortivask", "djvortivask"},
	  {"inori", "Inori", "inori"},
	  {"RGTM", "RGTM", "128beat"},
	  {"fancy cake", "fancy cake!!", "fancycake"},
	  {"leeium", "leeium", "leeium"},
	  {"SN3", "SuperNOVA3", "SN3"},
	  {"A", "A", "A"},
	  {"Off", "Off", "Off"},
	};
	--]]
	local yday = DayOfYear()
	local ymod = math.fmod(yday,6)
	if ymod == 0 or ymod == 6 then
		ThemePrefs.Set("MenuBG","Default")
		ThemePrefs.Set("SV","twopointzero")
		ThemePrefs.Set("MenuMusic","saiiko")
		-- Trace("Day 1")
	elseif ymod == 1 then
		ThemePrefs.Set("MenuBG","SN3")
		ThemePrefs.Set("SV","twopointzero")
		ThemePrefs.Set("MenuMusic","SN3")
		-- Trace("Day 2")
	elseif ymod == 2 then
		ThemePrefs.Set("MenuBG","NG2")
		ThemePrefs.Set("SV","twopointzero")
		ThemePrefs.Set("MenuMusic","RGTM")
		-- Trace("Day 3")
	elseif ymod == 3 then
		ThemePrefs.Set("MenuBG","SN2")
		ThemePrefs.Set("SV","onepointzero")
		ThemePrefs.Set("MenuMusic","Default")
		-- Trace("Day 4")
	elseif ymod == 4 then
		ThemePrefs.Set("MenuBG","Retrowave")
		ThemePrefs.Set("SV","onepointzero")
		ThemePrefs.Set("MenuMusic","inori")
		-- Trace("Day 5")
	elseif ymod == 5 then
		ThemePrefs.Set("MenuBG","OG")
		ThemePrefs.Set("SV","onepointzero")
		ThemePrefs.Set("MenuMusic","A")
		-- Trace("Day 6")
	else --How did we get here??
		ThemePrefs.Set("MenuBG","ITG1")
		ThemePrefs.Set("SV","onepointzero")
		ThemePrefs.Set("MenuMusic","saiiko")
		-- Trace("Day ???")
	end
end
