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
				ArtistChild:settext(wheelsong:GetDisplayArtist()):diffuse(MenuColor):strokecolor(ColorDarkTone(MenuColor))
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
		local fc = nil
		if self then
			fc = self:GetChild("Img_fc")
		end
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
						fc:visible(false)
						return
					end;

					scorelist = profile:GetHighScoreListIfExists(wheelsong,steps)
					if scorelist == nil then self:visible(false) fc:visible(false) return end
					local scores = scorelist:GetHighScores();
					if scores == nil then self:visible(false) fc:visible(false) return end
					local topscore=0;
					if scores[1] then
						if ThemePrefs.Get("ConvertScoresAndGrades") then
							topscore = SN2Scoring.GetSN2ScoreFromHighScore(steps, scores[1])
						else
							topscore = scores[1]:GetScore()
						end
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
							self:visible(true)
							local RStats = scores[1]
							local misses = 1
							local boos = 0
							local goods = 0
							local greats = 0
							local perfects = 0
							local marvelous = 0
							if RStats then
								misses = RStats:GetTapNoteScore("TapNoteScore_Miss")+RStats:GetTapNoteScore("TapNoteScore_CheckpointMiss")
								boos = RStats:GetTapNoteScore("TapNoteScore_W5")
								goods = RStats:GetTapNoteScore("TapNoteScore_W4")
								greats = RStats:GetTapNoteScore("TapNoteScore_W3")
								perfects = RStats:GetTapNoteScore("TapNoteScore_W2")
								marvelous = RStats:GetTapNoteScore("TapNoteScore_W1")
							end
							if fc and (misses+boos) == 0 and scores[1]:GetScore() > 0 and (marvelous+perfects)>0 then
								if (greats+perfects) == 0 then
									fc:visible(true):diffuse(GameColor.Judgment["JudgmentLine_W1"])
									:glowblink():effectperiod(0.20)
								elseif greats == 0 then
									fc:visible(true):diffuse(GameColor.Judgment["JudgmentLine_W2"])
									:glowshift()
								elseif (misses+boos+goods) == 0 then
									fc:visible(true):diffuse(GameColor.Judgment["JudgmentLine_W3"])
									:stopeffect()
								elseif (misses+boos) == 0 then
									fc:visible(true):diffuse(GameColor.Judgment["JudgmentLine_W4"])
									:stopeffect()
								else
									fc:visible(false)
								end;
								fc:diffusealpha(0.8);
							else
								if fc then
									fc:visible(false)
								end
							end;
						else
							self:visible(false)
							if fc then
								fc:visible(false)
							end
						end;
					else
						self:visible(false)
						if fc then
							fc:visible(false)
						end
					end;
				else
					self:visible(false)
					if fc then
						fc:visible(false)
					end
				end;
			end
		end
	end;
	--CurrentSongChangedMessageCommand=function(s) s:queuecommand("Set") end,
	--CurrentTrailP1ChangedMessageCommand=function(s) s:queuecommand("Set") end,
	CurrentStepsP1ChangedMessageCommand=function(s) s:queuecommand("Set") end,
	--CurrentCourseChangedMessageCommand=function(s) s:queuecommand("Set") end,
	Def.Quad{
		InitCommand=function(s)
			s:xy(0,0)
			s:zoom(0.1)
		end,
		BeginCommand=function(s) s:playcommand("Set") end,
		SetMessageCommand=function(self,params)
			if params then
				--local song = GAMESTATE:GetCurrentSong()
				wheelsong = params.Song;
				if wheelsong then
					local steps = GAMESTATE:GetCurrentSteps(pn)
					--Trace("Setting grade for song: "..tostring(wheelsong).." on steps "..tostring(steps)..".")

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
							if ThemePrefs.Get("ConvertScoresAndGrades") then
								topscore = SN2Scoring.GetSN2ScoreFromHighScore(steps, scores[1])
							else
								topscore = scores[1]:GetScore()
							end
						end;

						local topgrade;
						if scores[1] then
							topgrade = scores[1]:GetGrade();
							local tier = scores[1]:GetGrade();
							if ThemePrefs.Get("ConvertScoresAndGrades") then
								tier = SN2Grading.ScoreToGrade(topscore, diff)
							end
							if topgrade == nil then self:visible(false) end
							if scores[1]:GetScore()>1  then
								self:LoadBackground(THEME:GetPathB("ScreenEvaluationNormal decorations/grade/GradeDisplayEval",ToEnumShortString(tier)));
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
	};
	Def.Sprite{
		Texture=THEME:GetPathG("Player","Badge FullCombo"),
		Name="Img_fc",
		InitCommand=function(s) s:zoom(0.35):xy(28,8):visible(false):draworder(-10) end,
	};
};
end

return t;