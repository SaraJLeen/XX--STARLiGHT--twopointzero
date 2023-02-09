return Def.ActorFrame { 
	LoadModule("Options.SmartTiming.lua"), 
	LoadModule("Options.SmartScoring.lua"),
	LoadModule("Options.SmartCombo.lua"),
	OnCommand=function(self)
		if(SCREENMAN:GetTopScreen():GetName() == "ScreenGameplay") then
			if THEME:GetMetric("ScreenGameplay","UsePauseMenu") then
				-- Can be modified by the theme to have their own interface or options.
				self:AddChildFromPath(GetModule("Gameplay.Pause.lua"))
			end
		end
	end
}
