local ScoreAndGrade = LoadModule('ScoreAndGrade.lua')
local t = Def.ActorFrame{};
wheelsong = nil;

--return Def.ActorFrame{
t[#t+1] = Def.ActorFrame{
	ChangedLanguageDisplayMessageCommand=function(s) s:queuecommand("Set") end,
	SetMessageCommand=function(s,p)
		wheelsong = p.Song
		if wheelsong then
			local TitleChild = s:GetChild("Title")
			local ArtistChild = s:GetChild("Artist")
			if TitleChild:GetText() ~= wheelsong:GetDisplayFullTitle() or ArtistChild:GetText() ~= wheelsong:GetDisplayArtist() then
				local MenuColor = SongAttributes_GetMenuColor(wheelsong)
				TitleChild:settext(wheelsong:GetDisplayFullTitle()):diffuse(MenuColor):strokecolor(ColorDarkTone(MenuColor))
				if wheelsong:GetDisplayArtist() == "Unknown artist" then ArtistChild:settext("♪♪♪♪♪"):diffuse(MenuColor):strokecolor(ColorDarkTone(MenuColor))
				else ArtistChild:settext(wheelsong:GetDisplayArtist()):diffuse(MenuColor):strokecolor(ColorDarkTone(MenuColor)) end
			end
			--Trace("Setting stuff for song "..tostring(p.Song)..".");
			local isFave = IsFavorite(wheelsong)
			if isFave == 1 then
				s:GetChild("Favorite"):visible(true):diffuse(GetFavoritesColor(PLAYER_1))
			elseif isFave == 2 then
				s:GetChild("Favorite"):visible(true):diffuse(GetFavoritesColor(PLAYER_2))
			elseif isFave == 3 then
				s:GetChild("Favorite"):visible(true):diffuse(Color.White):diffusetopedge(GetFavoritesColor(PLAYER_1)):diffusebottomedge(GetFavoritesColor(PLAYER_2))
			else
				s:GetChild("Favorite"):visible(false):diffuse(Color.White)
			end
			--Trace("isFave is now "..tostring(isFave)..".");
		end
	end,
	InitCommand=function(s) s:queuecommand("Set") end,
	AddedFaveMessageCommand=function(s) s:queuecommand("Set") end,
	RemovedFaveMessageCommand=function(s) s:queuecommand("Set") end,

	Def.Sprite{
		Texture="backing",
	};
	Def.BitmapText{
		Name="Title",
		Font="_avenirnext lt pro bold/25px";
		InitCommand=function(s) s:halign(0):xy(-420,-14):maxwidth(400):zoom(1.1) end,
	};
	Def.BitmapText{
		Name="Artist",
		Font="_avenirnext lt pro bold/25px";
		InitCommand=function(s) s:halign(0):xy(-420,14):maxwidth(400):zoom(0.95) end,
	};
	Def.BitmapText{
		Font="_avenirnext lt pro bold/25px";
		InitCommand=function(s) s:halign(0):xy(-420,-32):uppercase(true):zoomy(0.7):zoomx(1.2):diffuse(Color.Red):shadowlength(1):strokecolor(Color.Black):draworder(6) end,
		SetMessageCommand=function(s,params)
			wheelsong = params.Song
			local text;
			if wheelsong then
				if wheelsong:IsLong() then
					text = "Long Version"
					s:diffuse(Color.Red)
					s:strokecolor(ColorDarkTone(Color.Red))
				elseif wheelsong:IsMarathon() then
					text = "Marathon Version"
					s:diffuse(Color.Orange)
					s:strokecolor(ColorDarkTone(Color.Orange))
				elseif wheelsong:MusicLengthSeconds() < 70 then
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
		end
	},
	Def.Sprite{
		Name="Favorite",
		Texture="fave",
		InitCommand=function(s) s:halign(0):xy(-474,0):visible(false):diffuse(Color.White) end,
	};
}
for _, pn in pairs(GAMESTATE:GetEnabledPlayers()) do
t[#t+1] = Def.ActorFrame{
	InitCommand=function(self)
		local short = ToEnumShortString(pn)
		self:x(240):halign(0)
		if(pn == PLAYER_2) then
			self:x(300)
		end
		if(#GAMESTATE:GetEnabledPlayers()<2) then
			self:x(300)
		end
	end;
	SetMessageCommand=function(self,params)
		if params then
			wheelsong = params.Song;
			if wheelsong then
				local steps = GAMESTATE:GetCurrentSteps(pn)

				local profile, scorelist;
				local text = "";
				if wheelsong and steps then
					local st = steps:GetStepsType();
					local diff = steps:GetDifficulty();
					steps = wheelsong:GetOneSteps(st,diff);
				end
				if wheelsong and steps then

					if PROFILEMAN:IsPersistentProfile(pn) then
						profile = PROFILEMAN:GetProfile(pn);
					else
						profile = PROFILEMAN:GetMachineProfile();
						self:visible(false)
						return
					end;

					scorelist = profile:GetHighScoreListIfExists(wheelsong,steps)
					if scorelist == nil then self:visible(false) return end
					local scores = scorelist:GetHighScores();
					if scores == nil then self:visible(false) return end
					local topscore=0;
					if scores[1] then
						topscore = scores[1]:GetScore()
					end;

					local topgrade;
					if scores[1] then
						topgrade = scores[1]:GetGrade();
						local tier = scores[1]:GetGrade();
						if ThemePrefs.Get("ConvertScoresAndGrades") then
							tier = SN2Grading.ScoreToGrade(topscore, diff)
						end
						assert(topgrade);
						if scores[1]:GetScore()>1  then
							self:playcommand('SetScore', { Stats = scores[1], Steps = steps })
							self:visible(true)
						else
							self:visible(false)
						end;
					else
						self:visible(false)
					end;
				else
					self:visible(false)
				end;
			end
		end
	end;
	--CurrentSongChangedMessageCommand=function(s) s:queuecommand("Set") end,
	--CurrentTrailP1ChangedMessageCommand=function(s) s:queuecommand("Set") end,
	CurrentStepsP1ChangedMessageCommand=function(s) s:queuecommand("Set") end,
	--CurrentCourseChangedMessageCommand=function(s) s:queuecommand("Set") end,
	ScoreAndGrade.CreateGradeActor{
		Name='Grade',
		Big=true,
		AlternativeFC=true,
		InitCommand=function(self)
			self:xy(0,0):zoom(0.1)
			self:GetChild('FullCombo'):zoom(1.5):xy(300,0)
		end,
	},
};
end

return t;