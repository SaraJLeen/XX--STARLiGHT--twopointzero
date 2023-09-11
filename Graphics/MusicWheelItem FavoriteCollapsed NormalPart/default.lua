if GAMESTATE:IsCourseMode() then return Def.ActorFrame{} end

local t = Def.ActorFrame{}

local wheel = ThemePrefs.Get("WheelType");
return Def.ActorFrame{
    loadfile(THEME:GetPathG("MusicWheelItem","FavoriteCollapsed NormalPart/"..wheel.."/default.lua"))()
} 
