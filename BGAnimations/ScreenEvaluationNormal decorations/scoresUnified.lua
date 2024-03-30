local pn = ...

local t = Def.ActorFrame {};
-- Holy fcuk yes it's finally working (inefficient as it may be)
local MyGrooveRadar = LoadModule "MyGrooveRadar.lua"
local function RivalScore(pn,rival)
	local t=Def.ActorFrame {
		CurrentSongChangedMessageCommand=function(s) s:playcommand("Set") end,
		CurrentCourseChangedMessageCommand=function(s) s:playcommand("Set") end,
		["CurrentSteps"..ToEnumShortString(pn).."ChangedMessageCommand"]=function(s) s:queuecommand("Set") end,
        ["CurrentTrail"..ToEnumShortString(pn).."ChangedMessageCommand"]=function(s) s:queuecommand("Set") end,
		Def.BitmapText{
			Font="_avenirnext lt pro bold/36px",
			InitCommand=function(s) s:zoom(0.8):halign(0):x(-100):strokecolor(Color.Black) end,
			OnCommand=function(self)
				local SongOrCourse, StepsOrTrail;
				if GAMESTATE:IsCourseMode() then
					SongOrCourse = GAMESTATE:GetCurrentCourse();
					StepsOrTrail = GAMESTATE:GetCurrentTrail(pn);
				else
					SongOrCourse = GAMESTATE:GetCurrentSong();
					StepsOrTrail = GAMESTATE:GetCurrentSteps(pn);
				end;

				local profile, scorelist;
				if SongOrCourse and StepsOrTrail then
					local st = StepsOrTrail:GetStepsType();
					local diff = StepsOrTrail:GetDifficulty();
					local courseType = GAMESTATE:IsCourseMode() and SongOrCourse:GetCourseType() or nil;

					if PROFILEMAN:IsPersistentProfile(pn) then
						-- player profile
						profile = PROFILEMAN:GetProfile(pn);
					else
						-- machine profile
						profile = PROFILEMAN:GetMachineProfile();
					end;

					--This displays only personal scores...
					--scorelist = PROFILEMGetHighScoreListIfExists(SongOrCourse,StepsOrTrail);
					scorelist = PROFILEMAN:GetMachineProfile():GetHighScoreListIfExists(SongOrCourse,StepsOrTrail);
					if scorelist == nil then self:settext("") return end
					local scores = scorelist:GetHighScores();
					if scores == nil then self:settext("") return end
					local topscore=0;
					if scores[rival] then
						topscore = scores[rival]:GetScore();
						if ThemePrefs.Get("ConvertScoresAndGrades") == true then
							topscore = SN2Scoring.GetSN2ScoreFromHighScore(st, scores[rival]:GetScore())
						end
					end;
					if topscore == nil then self:settext("") return end
					if topscore ~= 0  then
						self:settext(scores[rival]:GetName());
						self:diffuse( Color.White )
						for _,pns in pairs(GAMESTATE:GetEnabledPlayers()) do
							local prof = PROFILEMAN:GetProfile(pns)
							if(scores[rival]:GetName() == prof:GetDisplayName()) then
								self:diffuse( PlayerColor(pns) )
								self:diffusecolor((GetProfileColor(prof)))
							end
						end
					else
						self:settext("");
					end;
				end;
			end;
		};
		Def.BitmapText{
			Font="_avenirnext lt pro bold/36px",
			InitCommand=function(s) s:x(260):halign(1):zoom(0.8) end,
			BeginCommand=function(s) s:playcommand("Set") end,
			SetCommand=function(self)
				local SongOrCourse, StepsOrTrail;
				if GAMESTATE:IsCourseMode() then
					SongOrCourse = GAMESTATE:GetCurrentCourse();
					StepsOrTrail = GAMESTATE:GetCurrentTrail(pn);
				else
					SongOrCourse = GAMESTATE:GetCurrentSong();
					StepsOrTrail = GAMESTATE:GetCurrentSteps(pn);
				end;

				local profile, scorelist;
				local text = "";
				if SongOrCourse and StepsOrTrail then
					local st = StepsOrTrail:GetStepsType();
					local diff = StepsOrTrail:GetDifficulty();
					local courseType = GAMESTATE:IsCourseMode() and SongOrCourse:GetCourseType() or nil;

					if PROFILEMAN:IsPersistentProfile(pn) then
						-- player profile
						profile = PROFILEMAN:GetProfile(pn);
					else
						-- machine profile
						profile = PROFILEMAN:GetMachineProfile();
					end;

					--if profile ~= nil and profile
			            profile:SetLastUsedHighScoreName(profile:GetDisplayName())
			            GAMESTATE:StoreRankingName(pn,profile:GetDisplayName())
					--end
					--This is only personal scores
					--scorelist = profile:GetHighScoreListIfExists(SongOrCourse,StepsOrTrail);
					scorelist = PROFILEMAN:GetMachineProfile():GetHighScoreListIfExists(SongOrCourse,StepsOrTrail);
					if scorelist == nil then self:settext("") return end
					local scores = scorelist:GetHighScores();
					if scores == nil then self:settext("") return end
					local topscore=0;
					if scores[rival] then
						topscore = scores[rival]:GetScore();
						if ThemePrefs.Get("ConvertScoresAndGrades") == true then
							topscore = SN2Scoring.GetSN2ScoreFromHighScore(st, scores[rival]:GetScore())
						end
					end;
					if topscore == nil then self:settext("") return end
					if topscore ~= 0  then
							local scorel3 = topscore%1000;
							local scorel2 = (topscore/1000)%1000;
							local scorel1 = (topscore/1000000)%1000000;
					text = string.format("%01d"..",".."%03d"..",".."%03d",scorel1,scorel2,scorel3);
					else
						text = "";
					end;
				else
					text = "";
				end;
				GAMESTATE:SaveLocalData();
				GAMESTATE:SaveProfiles();
				MyGrooveRadar.SaveAllRadarData()
				ProfilePrefs.SaveAll()
				self:settext(text);
			end;
		};
		Def.ActorFrame{
			InitCommand=function(s) s:x(60) end,
			Def.Quad{
				InitCommand=function(s) s:zoom(1.2):draworder(2) end,
					BeginCommand=function(s) s:playcommand("Set") end,
					SetCommand=function(self)
						local SongOrCourse, StepsOrTrail;
						if GAMESTATE:IsCourseMode() then
							SongOrCourse = GAMESTATE:GetCurrentCourse();
							StepsOrTrail = GAMESTATE:GetCurrentTrail(pn);
						else
							SongOrCourse = GAMESTATE:GetCurrentSong();
							StepsOrTrail = GAMESTATE:GetCurrentSteps(pn);
						end;
		
						local profile, scorelist;
						local text = "";
						if SongOrCourse and StepsOrTrail then
							local st = StepsOrTrail:GetStepsType();
							local diff = StepsOrTrail:GetDifficulty();
							local courseType = GAMESTATE:IsCourseMode() and SongOrCourse:GetCourseType() or nil;
		
							if PROFILEMAN:IsPersistentProfile(pn) then
								-- player profile
								profile = PROFILEMAN:GetProfile(pn);
							else
								-- machine profile
								profile = PROFILEMAN:GetMachineProfile();
							end;
		
							--if profile ~= nil and profile
					            profile:SetLastUsedHighScoreName(profile:GetDisplayName())
					            GAMESTATE:StoreRankingName(pn,profile:GetDisplayName())
							--end
							--This is personal only
							--scorelist = profile:GetHighScoreListIfExists(SongOrCourse,StepsOrTrail);
							scorelist = PROFILEMAN:GetMachineProfile():GetHighScoreListIfExists(SongOrCourse,StepsOrTrail);
							if scorelist == nil then self:diffusealpha(0) return end
								local scores = scorelist:GetHighScores();
							if scores == nil then self:diffusealpha(0) return end
								local topscore=0;
								if scores[rival] then
									topscore = scores[rival]:GetScore();
									if ThemePrefs.Get("ConvertScoresAndGrades") == true then
										topscore = SN2Scoring.GetSN2ScoreFromHighScore(st, scores[rival]:GetScore())
									end
								end;
							if topscore == nil then self:diffusealpha(0) return end
								local topgrade;
								if scores[rival] then
									topgrade = scores[rival]:GetGrade();
									if ThemePrefs.Get("ConvertScoresAndGrades") == true then
										topgrade = SN2Grading.ScoreToGrade(topscore, diff)
									end
									tier = topgrade
									assert(topgrade);
									if scores[rival]:GetScore()>1  then
										if scores[rival]:GetScore()==1000000 and topgrade=="Grade_Tier07" then
											self:LoadBackground(THEME:GetPathG("","myMusicWheel/GradeDisplayEval Tier01"));
											self:diffusealpha(1);
										else
											self:LoadBackground(THEME:GetPathG("","myMusicWheel/GradeDisplayEval "..ToEnumShortString(topgrade)));
											self:diffusealpha(1);
										end;	
									else
										self:diffusealpha(0);
									end;
								else
									self:diffusealpha(0);
								end;
						else
							self:diffusealpha(0);
						end;
						GAMESTATE:SaveLocalData();
						GAMESTATE:SaveProfiles();
						MyGrooveRadar.SaveAllRadarData()
						ProfilePrefs.SaveAll()
					end;
				};
				Def.Sprite{
					Texture=THEME:GetPathG("Player","Badge FullCombo"),
					InitCommand=function(s) s:zoom(0.5):shadowlength(2):x(20):draworder(1) end,
					BeginCommand=function(s) s:playcommand("Set") end,
					SetCommand=function(self)
						local SongOrCourse, StepsOrTrail;
						if GAMESTATE:IsCourseMode() then
							SongOrCourse = GAMESTATE:GetCurrentCourse();
							StepsOrTrail = GAMESTATE:GetCurrentTrail(pn);
						else
							SongOrCourse = GAMESTATE:GetCurrentSong();
							StepsOrTrail = GAMESTATE:GetCurrentSteps(pn);
						end;
		
						local profile, scorelist;
						local text = "";
						if SongOrCourse and StepsOrTrail then
							local st = StepsOrTrail:GetStepsType();
							local diff = StepsOrTrail:GetDifficulty();
							local courseType = GAMESTATE:IsCourseMode() and SongOrCourse:GetCourseType() or nil;
		
							if PROFILEMAN:IsPersistentProfile(pn) then
								-- player profile
								profile = PROFILEMAN:GetProfile(pn);
							else
								-- machine profile
								profile = PROFILEMAN:GetMachineProfile();
							end;
		
							--if not(profile == nil)
					            profile:SetLastUsedHighScoreName(profile:GetDisplayName())
					            GAMESTATE:StoreRankingName(pn,profile:GetDisplayName())
							--end
							--This is personal only
							--scorelist = profile:GetHighScoreListIfExists(SongOrCourse,StepsOrTrail);
							scorelist = PROFILEMAN:GetMachineProfile():GetHighScoreListIfExists(SongOrCourse,StepsOrTrail);
							if scorelist == nil then self:diffusealpha(0) return end
								local scores = scorelist:GetHighScores();
								if scores == nil then self:diffusealpha(0) return end
								local topscore;
								if scores[rival] then
									topscore = scores[rival];
									if topscore == nil then self:diffusealpha(0) return end
									local misses = topscore:GetTapNoteScore("TapNoteScore_Miss")+topscore:GetTapNoteScore("TapNoteScore_CheckpointMiss")
									local boos = topscore:GetTapNoteScore("TapNoteScore_W5")
									local goods = topscore:GetTapNoteScore("TapNoteScore_W4")
									local greats = topscore:GetTapNoteScore("TapNoteScore_W3")
									local perfects = topscore:GetTapNoteScore("TapNoteScore_W2")
									local marvelous = topscore:GetTapNoteScore("TapNoteScore_W1")
									if (misses+boos) == 0 and scores[rival]:GetScore() > 0 and (marvelous+perfects)>0 then
										if (greats+perfects) == 0 then
											self:diffuse(GameColor.Judgment["JudgmentLine_W1"]);
											self:glowblink();
											self:effectperiod(0.20);
										elseif greats == 0 then
											self:diffuse(GameColor.Judgment["JudgmentLine_W2"]);
											self:glowshift();
										elseif (misses+boos+goods) == 0 then
											self:diffuse(GameColor.Judgment["JudgmentLine_W3"]);
											self:stopeffect();
										elseif (misses+boos) == 0 then
											self:diffuse(GameColor.Judgment["JudgmentLine_W4"]);
											self:stopeffect();
										end;
										self:diffusealpha(1);
									else
										self:diffusealpha(0);
									end;
								else
									self:diffusealpha(0);
								end;
						else
							self:diffusealpha(0);
						end;
						GAMESTATE:SaveLocalData();
						GAMESTATE:SaveProfiles();
						MyGrooveRadar.SaveAllRadarData()
						ProfilePrefs.SaveAll()
					end;
				};
		}
	};
	return t;
end

t[#t+1] = Def.Sprite{
	Texture="ScoreFrame.png",
};

for i=1,6 do
	t[#t+1] = RivalScore(pn,i)..{
		InitCommand=function(s)
			s:y((i*43)-150)
		end
	}
end


return t;