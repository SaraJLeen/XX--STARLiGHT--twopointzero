local gc = Var("GameCommand");
local t = Def.ActorFrame {};
-- Emblem Frame
t[#t+1] = Def.ActorFrame {
	FOV=90;
	InitCommand=function(s) s:x(0):zoom(1) end,
	-- Main Emblem
	loadfile(THEME:GetPathG("ScreenSelectPlayCourseMode","scroller/"..gc:GetName()))();
};
return t
