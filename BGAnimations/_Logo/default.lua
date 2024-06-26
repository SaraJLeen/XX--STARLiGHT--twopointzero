local main = "main.png"
if ANNOUNCER:GetCurrentAnnouncer() == "DDR Extreme Customized AF" then ANNOUNCER:SetCurrentAnnouncer("DDR Extreme Customized") end

if (MonthOfYear()+1) == 4 and DayOfMonth() == 1 then
  main = "mainowo.png"
  if ANNOUNCER:GetCurrentAnnouncer() == "DDR Extreme Customized" then ANNOUNCER:SetCurrentAnnouncer("DDR Extreme Customized AF") end
end

return Def.ActorFrame{
  Def.Sprite{
      Texture="XX.png",
      InitCommand=function(s)
        if Branding() == "ddr_" then
          s:x(362)
        else
          s:x(280)
        end
        s:y(16)
      end,
  },
  Def.Sprite{
      Texture="starlight.png",
      InitCommand=function(s)
        if Branding() == "ddr_" then
          s:y(84)
        else
          s:y(60)
        end
        s:x(22)
      end,
  };
  --[[Def.Sprite{
      Texture="twopointzero.png",
      InitCommand=function(s)
        if Branding() == "ddr_" then
          s:y(126)
        else
          s:y(100)
        end
        s:x(112)
      end,
  };]]
  Def.Sprite{
    Texture=Branding()..main,
    InitCommand=function(s)
      s:xy(-64,-32)
    end,
  };
}