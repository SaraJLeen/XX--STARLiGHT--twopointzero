local t = Def.ActorFrame{};

if not GAMESTATE:IsCourseMode() then
  t[#t+1] = loadfile(THEME:GetPathB("","ScreenSelectMusic underlay/Wheel/default.lua"))();
end

return t;
