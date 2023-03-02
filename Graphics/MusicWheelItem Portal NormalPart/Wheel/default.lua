local SongAttributes = LoadModule "SongAttributes.lua"
local t = Def.ActorFrame{};

--return Def.ActorFrame{
t[#t+1] = Def.ActorFrame{
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
				-- self:diffuse(ColorLightTone(SongAttributes.GetGroupColor(group)));
				self:diffuse(SongAttributes.GetGroupColor(group));
				self:strokecolor(ColorDarkTone(SongAttributes.GetGroupColor(group)));
				self:settext(SongAttributes.GetGroupName(group));
			else
				self:rainbow();
				self:strokecolor(Color.Black);
				self:settext("All Music");
			end
			self:visible(true)
		end,
		CurrentSongChangedMessageCommand=function(s) s:queuecommand("Set") end,
	};
	Def.BitmapText{
		Name="Title",
		Font="_avenirnext lt pro bold/25px";
		InitCommand=function(s) s:halign(0):xy(-200,-14):maxwidth(400):zoom(1.1) end,
		SetMessageCommand=function(self, param)
			self:settext("")
			local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
			if not mw then return end
			if mw:GetSelectedType() ~= 'WheelItemDataType_Portal' then return end
			if not GAMESTATE:GetCurrentSong() then return end
			self:settext(GAMESTATE:GetCurrentSong():GetDisplayFullTitle());
			self:diffuse(SongAttributes.GetMenuColor(GAMESTATE:GetCurrentSong())):strokecolor(ColorDarkTone(SongAttributes.GetMenuColor(GAMESTATE:GetCurrentSong())))
		end,
		CurrentSongChangedMessageCommand=function(s) s:queuecommand("Set") end,
	};
	Def.BitmapText{
		Name="Artist",
		Font="_avenirnext lt pro bold/25px";
		InitCommand=function(s) s:halign(0):xy(-200,14):maxwidth(400):zoom(0.95) end,
		SetMessageCommand=function(self, param)
			self:settext("")
			local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
			if not mw then return end
			if mw:GetSelectedType() ~= 'WheelItemDataType_Portal' then return end
			if not GAMESTATE:GetCurrentSong() then return end
			self:settext(GAMESTATE:GetCurrentSong():GetDisplayArtist());
			self:diffuse(SongAttributes.GetMenuColor(GAMESTATE:GetCurrentSong())):strokecolor(ColorDarkTone(SongAttributes.GetMenuColor(GAMESTATE:GetCurrentSong())))
		end,
		CurrentSongChangedMessageCommand=function(s) s:queuecommand("Set") end,
	};
	Def.BitmapText{
		Font="_avenirnext lt pro bold/25px";
		InitCommand=function(s) s:halign(0):xy(-450,0):maxwidth(200):uppercase(true):zoomy(0.7):zoomx(1.2):diffuse(Color.Red):shadowlength(1):strokecolor(Color.Black):draworder(6) end,
		SetMessageCommand=function(s,params)
			s:settext("")
			local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
			if not mw then return end
			if mw:GetSelectedType() ~= 'WheelItemDataType_Portal' then return end
			if not GAMESTATE:GetCurrentSong() then return end
			local text;
			if GAMESTATE:GetCurrentSong() then
				if GAMESTATE:GetCurrentSong():IsLong() then
					text = "Long Version"
					s:diffuse(Color.Red)
					s:strokecolor(ColorDarkTone(Color.Red))
				elseif GAMESTATE:GetCurrentSong():IsMarathon() then
					text = "Marathon Version"
					s:diffuse(Color.Orange)
					s:strokecolor(ColorDarkTone(Color.Orange))
				elseif GAMESTATE:GetCurrentSong():MusicLengthSeconds() < 70 then
					text = "Short Cut"
					s:diffuse(Color.Green)
					s:strokecolor(ColorDarkTone(Color.Green))
				else
					text = ""
				end
			else
				text = ""
			end
			s:settext(text)
		end,
		CurrentSongChangedMessageCommand=function(s) s:queuecommand("Set") end,
	},
};

return t;