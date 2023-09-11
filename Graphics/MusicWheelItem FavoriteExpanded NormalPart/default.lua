if GAMESTATE:IsCourseMode() then return Def.ActorFrame{} end

local t = Def.ActorFrame{}

local wheel = ThemePrefs.Get("WheelType");

if wheel == "A" then
    t[#t+1] = loadfile(THEME:GetPathG("MusicWheelItem","FavoriteExpanded NormalPart/A.lua"))()
elseif wheel == "Banner" then
    t[#t+1] = loadfile(THEME:GetPathG("MusicWheelItem","FavoriteExpanded NormalPart/Banner.lua"))()
else
    t[#t+1] = loadfile(THEME:GetPathG("MusicWheelItem","FavoriteCollapsed NormalPart/"..wheel.."/default.lua"))()
end

return t;
