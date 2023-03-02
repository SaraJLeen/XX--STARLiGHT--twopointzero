local main = "main.png"
if ANNOUNCER:GetCurrentAnnouncer() == "DDR Extreme Customized AF" then ANNOUNCER:SetCurrentAnnouncer("DDR Extreme Customized") end

if MonthOfYear() == 4 and DayOfMonth() == 1 then
  main = "itg_main.png"
  if ANNOUNCER:GetCurrentAnnouncer() == "DDR Extreme Customized" then ANNOUNCER:SetCurrentAnnouncer("DDR Extreme Customized AF") end
end

return Def.ActorFrame{
  Def.Sprite{
      Texture="XX.png",
      InitCommand=function(s) s:xy(362,16) end,
  },
  Def.Sprite{
      Texture="starlight.png",
      InitCommand=function(s) s:xy(22,84) end,
  };
  Def.Sprite{
      Texture="twopointzero.png",
      InitCommand=function(s) s:xy(112,126) end,
  };
  Def.Sprite{
    Texture=main,
    InitCommand=function(s)
      s:xy(-64,-32)
    end,
  };
}