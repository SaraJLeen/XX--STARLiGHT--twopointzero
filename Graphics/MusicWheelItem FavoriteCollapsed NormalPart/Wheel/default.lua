return Def.ActorFrame{
  LoadActor("Backing")..{
    SetMessageCommand=function(self, param)
	local group = param.Text;
      self:diffuse(GetFavoritesColor());
	if #GAMESTATE:GetEnabledPlayers() > 1 then self:diffusetopedge(GetFavoritesColor(PLAYER_1)):diffusebottomedge(GetFavoritesColor(PLAYER_2)) end
    end;
  };
  Def.BitmapText{
	  Font="_avenirnext lt pro bold/25px";
	  InitCommand=function(s) s:halign(0):x(-420):maxwidth(250/0.8):wrapwidthpixels(2^24):zoom(2) end,
	  SetMessageCommand=function(self, param)
		local group = param.Text;
		self:diffuse(GetFavoritesColor());
		if #GAMESTATE:GetEnabledPlayers() > 1 then self:diffusetopedge(GetFavoritesColor(PLAYER_1)):diffusebottomedge(GetFavoritesColor(PLAYER_2)) end
		self:settext(GetFavoritesName());
	end;
	};
  Def.BitmapText{
	  Font="_avenirnext lt pro bold/20px";
	  InitCommand=function(s) s:halign(1):x(360):y(10):maxwidth(100):zoom(1) end,
	  SetMessageCommand=function(self, param)
		if param == nil then return end
		local group = param.Text;
		if group == nil then return end
		local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
		if not mw then return end
		self:visible(false)
		if mw:GetSelectedType() ~= 'WheelItemDataType_Section' then return end
		if mw:GetSelectedSection() ~= group then return end
		local song_count = #SONGMAN:GetSongsInGroup(group)
		self:diffuse(ColorLightTone(GetFavoritesColor()));
		if #GAMESTATE:GetEnabledPlayers() > 1 then
			self:diffusetopedge(ColorLightTone(GetFavoritesColor(PLAYER_1))):diffusebottomedge(ColorLightTone(GetFavoritesColor(PLAYER_2)))
			if FaveCount(PLAYER_1) > 0 or FaveCount(PLAYER_2) > 0 then
				self:settext(tostring(FaveCount(PLAYER_1)).."/"..tostring(FaveCount(PLAYER_2)).." faves");
				self:visible(true)
			end
		else
			for _,pn in pairs(GAMESTATE:GetEnabledPlayers()) do
				if FaveCount(pn) > 0 then
					self:settext(tostring(FaveCount(pn)).." faves");
					self:visible(true)
				end
			end
		end
		return
		self:visible(true)
	  end;
      CurrentSongChangedMessageCommand=function(s) s:queuecommand("Set") end,
	CurrentStepsP1ChangedMessageCommand=function(s) s:playcommand("Set") end,
	CurrentStepsP2ChangedMessageCommand=function(s) s:playcommand("Set") end,
	CurrentTrailP1ChangedMessageCommand=function(s) s:playcommand("Set") end,
	CurrentTrailP2ChangedMessageCommand=function(s) s:playcommand("Set") end,
	};
};
