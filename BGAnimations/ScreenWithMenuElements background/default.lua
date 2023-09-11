local function getmenubgloader()
    if (MonthOfYear()+1) == 4 and DayOfMonth() == 1 then
	  return "ITG1"
    end
	return ThemePrefs.Get("MenuBG")
end
return Def.ActorFrame{
	Def.Quad {	--- needed for course gameplay shutter
		InitCommand=function(s) s:FullScreen():diffuse(color('0,0,0,1')) end,
	},
	loadfile(THEME:GetPathB("ScreenWithMenuElements","background/"..getmenubgloader().."/default.lua"))()
} 