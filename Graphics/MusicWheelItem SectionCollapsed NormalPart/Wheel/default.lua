return Def.ActorFrame{
  Def.Sprite{
	Texture="Backing",
    SetMessageCommand=function(self, param)
	local group = param.Text;
      self:diffuse(SongAttributes_GetGroupColor(group));
    end;
  };
  Def.BitmapText{
	  Font="_avenirnext lt pro bold/25px";
	  InitCommand=function(s) s:halign(0):x(-420):maxwidth(250/0.8):wrapwidthpixels(2^24):zoom(2) end,
	  SetMessageCommand=function(self, param)
		local group = param.Text;
		self:diffuse(SongAttributes_GetGroupColor(group));
		self:settext(SongAttributes_GetGroupName(group));
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
		if song_count <= 0 then self:visible(false) return end
		self:diffuse(ColorLightTone(SongAttributes_GetGroupColor(group)));
		self:settext(tostring(song_count).." songs");
		self:visible(true)
	  end;
      CurrentSongChangedMessageCommand=function(s) s:queuecommand("Set") end,
	CurrentStepsP1ChangedMessageCommand=function(s) s:playcommand("Set") end,
	CurrentStepsP2ChangedMessageCommand=function(s) s:playcommand("Set") end,
	CurrentTrailP1ChangedMessageCommand=function(s) s:playcommand("Set") end,
	CurrentTrailP2ChangedMessageCommand=function(s) s:playcommand("Set") end,
	};
--[[  Def.BitmapText{
	Font="_avenirnext lt pro bold/20px";
	SetMessageCommand=function(self, param)
		if param == nil then return end
		local player = PLAYER_1;
		local profile = PROFILEMAN:GetProfile(player)
		local profileName = profile:GetDisplayName()
		if (not GAMESTATE:IsPlayerEnabled(player)) or profileName == "" or GAMESTATE:GetSortOrder() ~= 'SortOrder_Group' then 
			self:visible(false)
		else
			self:visible(true)
			local scores = {
				Grade_Tier01 = 0,
				Grade_Tier02 = 0,
				Grade_Tier03 = 0,
				Grade_Tier04 = 0,
				Passes = 0
			}
			local grades = {
				Grade_Tier01 = 0,
				Grade_Tier02 = 1,
				Grade_Tier03 = 2,
				Grade_Tier04 = 3,
				Grade_Tier05 = 4,
				Grade_Tier06 = 5,
				Grade_Tier07 = 6,
				Grade_Tier08 = 7,
				Grade_Tier09 = 8,
				Grade_Tier10 = 9,
				Grade_Tier11 = 10,
				Grade_Tier12 = 11,
				Grade_Tier13 = 12,
				Grade_Tier14 = 13,
				Grade_Tier15 = 14,
				Grade_Tier16 = 15,
				Grade_Tier17 = 16,
				Grade_Tier18 = 17,
				Grade_Tier19 = 18,
				Grade_Tier20 = 19,
				Grade_Failed = 20,
			}
			local countSongs = 0
			local folderName = param.Text
			local songs = SONGMAN:GetSongsInGroup(folderName)
			local stepstype = GAMESTATE:GetCurrentStyle():GetStepsType()
			local steps = GAMESTATE:GetCurrentSteps(player)
			for k,v in pairs (grades) do
				scores[k] = 0
			end
			if steps then
				local difficulty = steps:GetDifficulty()
				-- Get profile and current difficulty
				for song in ivalues(songs) do
					local allsteps = song:GetAllSteps()
					for songsteps in ivalues(allsteps) do
						local stepsdiff = songsteps:GetDifficulty()
						if difficulty == stepsdiff and stepstype == songsteps:GetStepsType() then
							countSongs = countSongs + 1
							HighScoreList = profile:GetHighScoreListIfExists(song,songsteps)
							if HighScoreList ~= nil then 
								HighScores = HighScoreList:GetHighScores()
								-- Get highest score
								if #HighScores > 0 then
									local grade = HighScores[1]:GetGrade()
									if grade ~= "Grade_Failed" then
										scores["Passes"] = scores["Passes"] + 1
										if grades[grade] < 4 then
											scores[grade] = scores[grade] + 1
										end
									else
											scores[grade] = scores[grade] + 1
									end
								end
							end
						end
					end
				end
				self:settext("1: "..scores['Grade_Tier01'].."/2: "..scores['Grade_Tier02'].."/3: "..scores['Grade_Tier03'].."/4: "..scores['Grade_Tier04'].."/F: "..scores['Grade_Failed'].."/T: "..#songs.."")
			else
				self:visible(false)
			end
		end;
	end;
      CurrentSongChangedMessageCommand=function(s) s:queuecommand("Set") end,
	CurrentStepsP1ChangedMessageCommand=function(s) s:playcommand("Set") end,
	CurrentStepsP2ChangedMessageCommand=function(s) s:playcommand("Set") end,
	CurrentTrailP1ChangedMessageCommand=function(s) s:playcommand("Set") end,
	CurrentTrailP2ChangedMessageCommand=function(s) s:playcommand("Set") end,
	};
--]]

};
