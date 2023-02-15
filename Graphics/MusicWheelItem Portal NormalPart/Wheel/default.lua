local SongAttributes = LoadModule "SongAttributes.lua"

return Def.ActorFrame{
  Def.Sprite{
    Texture=THEME:GetPathG("","MusicWheelItem SectionCollapsed NormalPart/Wheel/Backing"),
    InitCommand=function(s) s:diffuse(Color.Blue) end,
  };
  Def.BitmapText{
		Font="_avenirnext lt pro bold/25px";
		InitCommand=function(s) s:halign(0):x(-420):maxwidth(250/0.8):wrapwidthpixels(2^24):zoom(2) end,
		SetMessageCommand=function(self, param)
      self:settext(THEME:GetString("MusicWheel","Portal"))
      self:diffuse(Color.Blue)
    end;
	};
  Def.BitmapText{
	  Font="_avenirnext lt pro bold/20px";
	  InitCommand=function(s) s:halign(1):x(360):y(10):maxwidth(300):zoom(1) end,
	  SetMessageCommand=function(self, param)
		self:settext("");
		self:visible(false)
		self:stopeffect()
		if param == nil then return end
		local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
		if not mw then return end
		if mw:GetSelectedType() ~= 'WheelItemDataType_Portal' then return end
		local group = GAMESTATE:GetExpandedSectionName();
		if group ~= "" then
			self:diffuse(ColorLightTone(SongAttributes.GetGroupColor(group)));
			self:settext(SongAttributes.GetGroupName(group));
		else
			self:rainbow();
			self:settext("All Music");
		end
		self:visible(true)
	  end;
      CurrentSongChangedMessageCommand=function(s) s:queuecommand("Set") end,
	CurrentStepsP1ChangedMessageCommand=function(s) s:playcommand("Set") end,
	CurrentStepsP2ChangedMessageCommand=function(s) s:playcommand("Set") end,
	CurrentTrailP1ChangedMessageCommand=function(s) s:playcommand("Set") end,
	CurrentTrailP2ChangedMessageCommand=function(s) s:playcommand("Set") end,
	};
};
