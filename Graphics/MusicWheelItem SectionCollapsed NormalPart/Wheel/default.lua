local SongAttributes = LoadModule "SongAttributes.lua"

return Def.ActorFrame{
  LoadActor("Backing")..{
    SetMessageCommand=function(self, param)
		  local group = param.Text;
      self:diffuse(SongAttributes.GetGroupColor(group));
    end;
  };
  Def.BitmapText{
	  Font="_avenirnext lt pro bold/25px";
	  InitCommand=function(s) s:halign(0):x(-420):maxwidth(250/0.8):wrapwidthpixels(2^24):zoom(2) end,
	  SetMessageCommand=function(self, param)
		local group = param.Text;
		self:diffuse(SongAttributes.GetGroupColor(group));
		self:settext(SongAttributes.GetGroupName(group));
	end;
	};
  Def.BitmapText{
	  Font="_avenirnext lt pro bold/20px";
	  InitCommand=function(s) s:halign(1):x(360):y(10):maxwidth(100):zoom(1) end,
	  SetMessageCommand=function(self, param)
		if param == nil then return end
		local group = param.Text;
		if group == nil then return end
		self:visible(false)
		local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
		if not mw then return end
		if mw:GetSelectedType() ~= 'WheelItemDataType_Section' then return end
		if mw:GetSelectedSection() ~= group then return end
		local song_count = #SONGMAN:GetSongsInGroup(group)
		if song_count <= 0 then self:visible(false) return end
		self:diffuse(ColorLightTone(SongAttributes.GetGroupColor(group)));
		self:settext(tostring(song_count).." songs");
		self:visible(true)
	  end;
      CurrentSongChangedMessageCommand=function(s) s:queuecommand("Set") end,
	CurrentStepsP1ChangedMessageCommand=function(s) s:playcommand("Set") end,
	CurrentStepsP2ChangedMessageCommand=function(s) s:playcommand("Set") end,
	CurrentTrailP1ChangedMessageCommand=function(s) s:playcommand("Set") end,
	CurrentTrailP2ChangedMessageCommand=function(s) s:playcommand("Set") end,
	};
};
