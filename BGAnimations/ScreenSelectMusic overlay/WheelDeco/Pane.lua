local t = Def.ActorFrame{};

local xPosPlayer = {
  P1 = -320,
  P2 = -20
};

function TopRecord(pn) -- ???
	local SongOrCourse, StepsOrTrail;
	local myScoreSet = {
		["HasScore"] = 0;
		["SongOrCourse"] =0;
		["topscore"] = 0;
		["topW1"]=0;
		["topW2"]=0;
		["topW3"]=0;
		["topW4"]=0;
		["topW5"]=0;
		["topMiss"]=0;
		["topOK"]=0;
		["topEXScore"]=0;
		["topMAXCombo"]=0;
		["topDate"]=0;
		};

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

		scorelist = profile:GetHighScoreListIfExists(SongOrCourse,StepsOrTrail);
		if scorelist == nil then
			myScoreSet["SongOrCourse"]=1;
			myScoreSet["HasScore"] = 0;
			myScoreSet["topW1"]  = 0
			myScoreSet["topW2"]  = 0
			myScoreSet["topW3"]  = 0
			myScoreSet["topW4"]  = 0
			myScoreSet["topW5"]  = 0
			myScoreSet["topMiss"]  = 0
			myScoreSet["topOK"]  = 0
			myScoreSet["topMAXCombo"]  = 0
			myScoreSet["topDate"]  = 0
			myScoreSet["topEXScore"]  = 0
			return myScoreSet;
		end
		local scores = scorelist:GetHighScores();
		if scores == nil then
			myScoreSet["SongOrCourse"]=1;
			myScoreSet["HasScore"] = 0;
			myScoreSet["topW1"]  = 0
			myScoreSet["topW2"]  = 0
			myScoreSet["topW3"]  = 0
			myScoreSet["topW4"]  = 0
			myScoreSet["topW5"]  = 0
			myScoreSet["topMiss"]  = 0
			myScoreSet["topOK"]  = 0
			myScoreSet["topMAXCombo"]  = 0
			myScoreSet["topDate"]  = 0
			myScoreSet["topEXScore"]  = 0
			return myScoreSet;
		end
		-- local topscore=0;
		-- local topW1=0;
		-- local topW2=0;
		-- local topW3=0;
		-- local topW4=0;
		-- local topW5=0;
		-- local topMiss=0;
		-- local topOK=0;
		-- local topEXScore=0;
		-- local topMAXCombo=0;
		if scores[1] then
			myScoreSet["SongOrCourse"]=1;
			myScoreSet["HasScore"] = 1;
			myScoreSet["topscore"] = scores[1]:GetScore();
			myScoreSet["topW1"]  = scores[1]:GetTapNoteScore("TapNoteScore_W1");
			myScoreSet["topW2"]  = scores[1]:GetTapNoteScore("TapNoteScore_W2");
			myScoreSet["topW3"]  = scores[1]:GetTapNoteScore("TapNoteScore_W3");
			myScoreSet["topW4"]  = scores[1]:GetTapNoteScore("TapNoteScore_W4")+scores[1]:GetTapNoteScore("TapNoteScore_W5");
			myScoreSet["topW5"]  = scores[1]:GetTapNoteScore("TapNoteScore_W5");
			myScoreSet["topMiss"]  = scores[1]:GetHoldNoteScore("HoldNoteScore_LetGo")+scores[1]:GetTapNoteScore("TapNoteScore_Miss");
			myScoreSet["topOK"]  = scores[1]:GetHoldNoteScore("HoldNoteScore_Held");
			myScoreSet["topMAXCombo"]  = scores[1]:GetMaxCombo();
			myScoreSet["topDate"]  = scores[1]:GetDate() ;
			--myScoreSet["topEXScore"]  = scores[1]:GetTapNoteScore("TapNoteScore_W1")*3+scores[1]:GetTapNoteScore("TapNoteScore_W2")*2+scores[1]:GetTapNoteScore("TapNoteScore_W3")+scores[1]:GetHoldNoteScore("HoldNoteScore_Held")*3;
			if (StepsOrTrail:GetRadarValues( pn ):GetValue( "RadarCategory_TapsAndHolds" ) >=0) then --If it is not a random course
				if scores[1]:GetGrade() ~= "Grade_Failed" then
					myScoreSet["topEXScore"] = scores[1]:GetTapNoteScore("TapNoteScore_W1")*3+scores[1]:GetTapNoteScore("TapNoteScore_W2")*2+scores[1]:GetTapNoteScore("TapNoteScore_W3")+scores[1]:GetHoldNoteScore("HoldNoteScore_Held")*3;
				else
					myScoreSet["topEXScore"] = (StepsOrTrail:GetRadarValues( pn ):GetValue( "RadarCategory_TapsAndHolds" )*3+StepsOrTrail:GetRadarValues( pn ):GetValue( "RadarCategory_Holds" )*3)*scores[1]:GetPercentDP();
				end
			else --If it is Random Course then the scores[1]:GetPercentDP() value will be -1
				if scores[1]:GetGrade() ~= "Grade_Failed" then
					myScoreSet["topEXScore"]  = scores[1]:GetTapNoteScore("TapNoteScore_W1")*3+scores[1]:GetTapNoteScore("TapNoteScore_W2")*2+scores[1]:GetTapNoteScore("TapNoteScore_W3")+scores[1]:GetHoldNoteScore("HoldNoteScore_Held")*3;
				else
					myScoreSet["topEXScore"]  = 0;
				end
			end
			myScoreSet["topMAXCombo"]  = scores[1]:GetMaxCombo();
			myScoreSet["topDate"]  = scores[1]:GetDate() ;
		else
			myScoreSet["SongOrCourse"]=1;
			myScoreSet["HasScore"] = 0;
		end;
	else
		myScoreSet["HasScore"] = 0;
		myScoreSet["SongOrCourse"]=0;

	end
	return myScoreSet;

end;

for _, pn in pairs(GAMESTATE:GetEnabledPlayers()) do
t[#t+1] = Def.ActorFrame{
  InitCommand=function(self)
    local short = ToEnumShortString(pn)
    self:x(xPosPlayer[short]):halign(0)
  end;
  Def.Sprite{
    Texture="Player 1x2";
    InitCommand=function(s) s:xy(260,-80):pause():setstate(0) end,
    BeginCommand=function(self)
      if pn == PLAYER_1 then
        self:setstate(0)
      else
        self:setstate(1)
      end;
    end;
  };
  Def.Sprite{
    Texture="Judge Stroke",
    InitCommand=function(s) s:xy(230,5):visible(false) end,
  };
  Def.Quad{
    InitCommand=function(s) s:xy(400,-30):zoom(0.2) end,
    BeginCommand=function(s) s:playcommand("Set") end,
    SetCommand=function(self)
      local song = GAMESTATE:GetCurrentSong()
      local steps = GAMESTATE:GetCurrentSteps(pn)

      local profile, scorelist;
      local text = "";
      if song and steps then
        local st = steps:GetStepsType();
        local diff = steps:GetDifficulty();

        if PROFILEMAN:IsPersistentProfile(pn) then
          profile = PROFILEMAN:GetProfile(pn);
        else
          profile = PROFILEMAN:GetMachineProfile();
        end;

        scorelist = profile:GetHighScoreListIfExists(song,steps)
		if scorelist == nil then self:diffusealpha(0) return end
        local scores = scorelist:GetHighScores();
		if scores == nil then self:diffusealpha(0) return end
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
		if topgrade == nil then self:diffusealpha(0) return end
          if scores[1]:GetScore()>1  then
            self:LoadBackground(THEME:GetPathB("ScreenEvaluationNormal decorations/grade/GradeDisplayEval",ToEnumShortString(tier)));
            self:diffusealpha(1);
          end;
        else
          self:diffusealpha(0)
        end;
      else
        self:diffusealpha(0)
      end;
    end;
    CurrentSongChangedMessageCommand=function(s) s:queuecommand("Set") end,
    CurrentTrailP1ChangedMessageCommand=function(s) s:queuecommand("Set") end,
    CurrentStepsP1ChangedMessageCommand=function(s) s:queuecommand("Set") end,
    CurrentCourseChangedMessageCommand=function(s) s:queuecommand("Set") end,
  };
  Def.BitmapText{
    Font="_avenirnext lt pro bold/25px",
    Name="Score";
    InitCommand=function(s) s:xy(400,15):zoom(0.8) end,
    BeginCommand=function(s) s:playcommand("Set") end,
    SetCommand=function(self)
      self:settext("")
      self:strokecolor(Color.Black)
      self:shadowcolor(Color.Black)
      self:shadowlength(2.0)

      local st=GAMESTATE:GetCurrentStyle():GetStepsType()
      local song=GAMESTATE:GetCurrentSong()
      local steps = GAMESTATE:GetCurrentSteps(pn)
      if song and steps then
        local diff = steps:GetDifficulty();
        if song:HasStepsTypeAndDifficulty(st,diff) then
          local steps = song:GetOneSteps(st,diff)

          if PROFILEMAN:IsPersistentProfile(pn) then
            profile = PROFILEMAN:GetProfile(pn)
          else
            profile = PROFILEMAN:GetMachineProfile()
          end;

          scorelist = profile:GetHighScoreListIfExists(song,steps)
		if scorelist == nil then self:settext("") return end
          local scores = scorelist:GetHighScores()
		if scores == nil then self:settext("") return end
          local topscore = 0

          if scores[1] then
            if ThemePrefs.Get("ConvertScoresAndGrades") then
              topscore = SN2Scoring.GetSN2ScoreFromHighScore(steps, scores[1])
            else
              topscore = scores[1]:GetScore();
            end
          end;
		if topscore == nil then self:settext("") return end

          self:diffusealpha(1)

          if topscore ~= 0 then
            local scorel3 = topscore%1000
            local scorel2 = (topscore/1000)%1000
            local scorel1 = (topscore/1000000)%1000000
            self:settextf("%01d"..",".."%03d"..",".."%03d",scorel1,scorel2,scorel3)
          end;
        end;
      end;
    end;
    CurrentSongChangedMessageCommand=function(s) s:queuecommand("Set") end,
    CurrentTrailP1ChangedMessageCommand=function(s) s:queuecommand("Set") end,
    CurrentStepsP1ChangedMessageCommand=function(s) s:queuecommand("Set") end,
    CurrentCourseChangedMessageCommand=function(s) s:queuecommand("Set") end,
  };
  Def.ActorFrame{
    InitCommand=function(s) s:xy(325,6):halign(1) end,
    CurrentSongChangedMessageCommand=function(s) s:queuecommand("Set") end,
    CurrentTrailP1ChangedMessageCommand=function(s) s:queuecommand("Set") end,
    CurrentStepsP1ChangedMessageCommand=function(s) s:queuecommand("Set") end,
    CurrentCourseChangedMessageCommand=function(s) s:queuecommand("Set") end,
    Def.BitmapText{
      Font="_avenirnext lt pro bold/25px";
      InitCommand=function(s) s:xy(-65,-68):zoom(0.5) end,
      BeginCommand=function(s) s:playcommand("Set") end,
      SetCommand=function(self)
        self:strokecolor(Color.Black)
        self:shadowcolor(Color.Black)
        self:shadowlength(2.0)
        myScoreSet = TopRecord(pn);
        local temp = myScoreSet["topDate"];
        if (myScoreSet["SongOrCourse"]==1) then
          if (myScoreSet["HasScore"]==1) then
            self:settext( temp);
            self:diffusealpha(1);
          else
            self:diffusealpha(0);
          end
        else
          self:diffusealpha(0);
        end
      end;
    };
    Def.BitmapText{
      File = THEME:GetPathF("","_avenirnext lt pro bold/20px");
      InitCommand=function(s) s:halign(1):x(-45):y(-53):zoom(0.75) end,
      BeginCommand=function(s) s:playcommand("Set") end,
      SetCommand=function(self)
	self:diffuse(Color.White)
        self:strokecolor(Color.Black)
        self:shadowcolor(Color.Black)
        self:shadowlength(2.0)
        self:halign(1)
        self:settext("MAX COMBO")
      end;
    };
    Def.RollingNumbers{
      File = THEME:GetPathF("","_avenirnext lt pro bold/20px");
      InitCommand=function(s) s:halign(1):y(-53):zoom(0.75) end,
      BeginCommand=function(s) s:playcommand("Set") end,
      SetCommand=function(self)
        self:strokecolor(Color.Black)
        self:shadowcolor(Color.Black)
        self:shadowlength(2.0)
        self:Load("RollingNumbersJudgment");
        myScoreSet = TopRecord(pn)
        if (myScoreSet["SongOrCourse"]==1) then
          if (myScoreSet["HasScore"]==1) then
            local topscore = myScoreSet["topMAXCombo"];
            self:targetnumber(topscore)
          else
            self:targetnumber(0);
          end;
        end;
      end;
    };
    Def.BitmapText{
      File = THEME:GetPathF("","_avenirnext lt pro bold/20px");
      InitCommand=function(s) s:halign(1):x(-45):y(-37):zoom(0.75) end,
      BeginCommand=function(s) s:playcommand("Set") end,
      SetCommand=function(self)
	self:diffuse(color("#FFF4BAFF"))
        self:strokecolor(Color.Black)
        self:shadowcolor(Color.Black)
        self:shadowlength(2.0)
        self:halign(1)
        self:settext("MARVELOUS")
      end;
    };
    Def.RollingNumbers{
      File = THEME:GetPathF("","_avenirnext lt pro bold/20px");
      InitCommand=function(s) s:halign(1):y(-37):zoom(0.75) end,
      BeginCommand=function(s) s:playcommand("Set") end,
      SetCommand=function(self)
        self:strokecolor(Color.Black)
        self:shadowcolor(Color.Black)
        self:shadowlength(2.0)
        self:Load("RollingNumbersJudgment");
        myScoreSet = TopRecord(pn)
        if (myScoreSet["SongOrCourse"]==1) then
          if (myScoreSet["HasScore"]==1) then
            local topscore = myScoreSet["topW1"];
            self:targetnumber(topscore)
          else
            self:targetnumber(0);
          end;
        end;
      end;
    };
    Def.BitmapText{
      File = THEME:GetPathF("","_avenirnext lt pro bold/20px");
      InitCommand=function(s) s:halign(1):x(-45):y(-20):zoom(0.75) end,
      BeginCommand=function(s) s:playcommand("Set") end,
      SetCommand=function(self)
	self:diffuse(color("#FFE345FF"))
        self:strokecolor(Color.Black)
        self:shadowcolor(Color.Black)
        self:shadowlength(2.0)
        self:halign(1)
        self:settext("PERFECT")
      end;
    };
    Def.RollingNumbers{
      File = THEME:GetPathF("","_avenirnext lt pro bold/20px");
      InitCommand=function(s) s:halign(1):y(-20):zoom(0.75) end,
      BeginCommand=function(s) s:playcommand("Set") end,
      SetCommand=function(self)
        self:strokecolor(Color.Black)
        self:shadowcolor(Color.Black)
        self:shadowlength(2.0)
        self:Load("RollingNumbersJudgment");
        myScoreSet = TopRecord(pn)
        if (myScoreSet["SongOrCourse"]==1) then
          if (myScoreSet["HasScore"]==1) then
            local topscore = myScoreSet["topW2"];
            self:targetnumber(topscore)
          else
            self:targetnumber(0);
          end;
        end;
      end;
    };
    Def.BitmapText{
      File = THEME:GetPathF("","_avenirnext lt pro bold/20px");
      InitCommand=function(s) s:halign(1):x(-45):y(-3):zoom(0.75) end,
      BeginCommand=function(s) s:playcommand("Set") end,
      SetCommand=function(self)
	self:diffuse(color("#3DEA2FFF"))
        self:strokecolor(Color.Black)
        self:shadowcolor(Color.Black)
        self:shadowlength(2.0)
        self:halign(1)
        self:settext("GREAT")
      end;
    };
    Def.RollingNumbers{
      File = THEME:GetPathF("","_avenirnext lt pro bold/20px");
      InitCommand=function(s) s:halign(1):y(-3):zoom(0.75) end,
      BeginCommand=function(s) s:playcommand("Set") end,
      SetCommand=function(self)
        self:strokecolor(Color.Black)
        self:shadowcolor(Color.Black)
        self:shadowlength(2.0)
        self:Load("RollingNumbersJudgment");
        myScoreSet = TopRecord(pn)
        if (myScoreSet["SongOrCourse"]==1) then
          if (myScoreSet["HasScore"]==1) then
            local topscore = myScoreSet["topW3"];
            self:targetnumber(topscore)
          else
            self:targetnumber(0);
          end;
        end;
      end;
    };
    Def.BitmapText{
      File = THEME:GetPathF("","_avenirnext lt pro bold/20px");
      InitCommand=function(s) s:halign(1):x(-45):y(14):zoom(0.75) end,
      BeginCommand=function(s) s:playcommand("Set") end,
      SetCommand=function(self)
	self:diffuse(color("#5AD3FFFF"))
        self:strokecolor(Color.Black)
        self:shadowcolor(Color.Black)
        self:shadowlength(2.0)
        self:halign(1)
        self:settext("GOOD")
      end;
    };
    Def.RollingNumbers{
      File = THEME:GetPathF("","_avenirnext lt pro bold/20px");
      InitCommand=function(s) s:halign(1):y(14):zoom(0.75) end,
      BeginCommand=function(s) s:playcommand("Set") end,
      SetCommand=function(self)
        self:strokecolor(Color.Black)
        self:shadowcolor(Color.Black)
        self:shadowlength(2.0)
        self:Load("RollingNumbersJudgment");
        myScoreSet = TopRecord(pn)
        if (myScoreSet["SongOrCourse"]==1) then
          if (myScoreSet["HasScore"]==1) then
            local topscore = myScoreSet["topW4"];
            self:targetnumber(topscore)
          else
            self:targetnumber(0);
          end;
        end;
      end;
    };
    Def.BitmapText{
      File = THEME:GetPathF("","_avenirnext lt pro bold/20px");
      InitCommand=function(s) s:halign(1):x(-45):y(31):zoom(0.75) end,
      BeginCommand=function(s) s:playcommand("Set") end,
      SetCommand=function(self)
	self:diffuse(color("#FF9C00FF"))
        self:strokecolor(Color.Black)
        self:shadowcolor(Color.Black)
        self:shadowlength(2.0)
        self:halign(1)
        self:settext("O.K.")
      end;
    };
    Def.RollingNumbers{
      File = THEME:GetPathF("","_avenirnext lt pro bold/20px");
      InitCommand=function(s) s:halign(1):y(31):zoom(0.75) end,
      BeginCommand=function(s) s:playcommand("Set") end,
      SetCommand=function(self)
        self:strokecolor(Color.Black)
        self:shadowcolor(Color.Black)
        self:shadowlength(2.0)
        self:Load("RollingNumbersJudgment");
        myScoreSet = TopRecord(pn)
        if (myScoreSet["SongOrCourse"]==1) then
          if (myScoreSet["HasScore"]==1) then
            local topscore = myScoreSet["topOK"];
            self:targetnumber(topscore)
          else
            self:targetnumber(0);
          end;
        end;
      end;
    };
    Def.BitmapText{
      File = THEME:GetPathF("","_avenirnext lt pro bold/20px");
      InitCommand=function(s) s:halign(1):x(-45):y(48):zoom(0.75) end,
      BeginCommand=function(s) s:playcommand("Set") end,
      SetCommand=function(self)
	self:diffuse(color("#FF2860FF"))
        self:strokecolor(Color.Black)
        self:shadowcolor(Color.Black)
        self:shadowlength(2.0)
        self:halign(1)
        self:settext("MISS")
      end;
    };
    Def.RollingNumbers{
      File = THEME:GetPathF("","_avenirnext lt pro bold/20px");
      InitCommand=function(s) s:halign(1):y(48):zoom(0.75) end,
      BeginCommand=function(s) s:playcommand("Set") end,
      SetCommand=function(self)
        self:strokecolor(Color.Black)
        self:shadowcolor(Color.Black)
        self:shadowlength(2.0)
        self:Load("RollingNumbersJudgment");
        myScoreSet = TopRecord(pn)
        if (myScoreSet["SongOrCourse"]==1) then
          if (myScoreSet["HasScore"]==1) then
            local topscore = myScoreSet["topMiss"];
            self:targetnumber(topscore)
          else
            self:targetnumber(0);
          end;
        end;
      end;
    };
    Def.Sprite{
      Texture=THEME:GetPathG("Player","Badge FullCombo"),
      Name="Img_fc",
      InitCommand=function(s) s:zoom(0.35):xy(130,-10):visible(false) end,
	SetCommand=function(self)
     	myScoreSet = TopRecord(pn);
		local misses = 1
		local boos = 0
		local goods = 0
		local greats = 0
		local perfects = 0
		local marvelous = 0
		if myScoreSet then
			misses = myScoreSet["topMiss"]
			boos = myScoreSet["topW5"]
			goods = myScoreSet["topW4"]
			greats = myScoreSet["topW3"]
			perfects = myScoreSet["topW2"]
			marvelous = myScoreSet["topW1"]
		end
		if (misses+boos) == 0 and myScoreSet["topscore"] > 0 and (marvelous+perfects)>0 then
			if (greats+perfects) == 0 then
				self:visible(true):diffuse(GameColor.Judgment["JudgmentLine_W1"])
				:glowblink():effectperiod(0.20)
				--Trace("Marvelous combo")
			elseif greats == 0 then
				self:visible(true):diffuse(GameColor.Judgment["JudgmentLine_W2"])
				:glowshift()
				--Trace("Perfect combo")
			elseif (misses+boos+goods) == 0 then
				self:visible(true):diffuse(GameColor.Judgment["JudgmentLine_W3"])
				:stopeffect()
				--Trace("Great combo")
			elseif (misses+boos) == 0 then
				self:visible(true):diffuse(GameColor.Judgment["JudgmentLine_W4"])
				:stopeffect()
				--Trace("Good combo")
			else
				self:visible(false)
				--Trace("No FC")
			end;
			self:diffusealpha(0.8);
		else
			self:visible(false)
		end;
	end;
    };
  };
};

end;

return t;
