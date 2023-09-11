if GAMESTATE:IsCourseMode() then return Def.ActorFrame{} end

local t = Def.ActorFrame{}

local jk = LoadModule"Jacket.lua"

return Def.ActorFrame{
    loadfile(THEME:GetPathG("MusicWheelItem","Song NormalPart/"..ThemePrefs.Get("WheelType").."/default.lua"))(jk)
} 
