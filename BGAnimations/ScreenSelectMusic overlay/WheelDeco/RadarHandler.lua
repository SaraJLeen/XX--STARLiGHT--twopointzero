local pn = ({...})[1] --only argument to file
local GR = {
    {-1,-112, "Stream"}, --STREAM
    {-120,-43, "Voltage"}, --VOLTAGE
    {-108,72, "Air"}, --AIR
    {108,72, "Freeze"}, --FREEZE
    {120,-43, "Chaos"}, --CHAOS
};
local Radar = LoadModule "DDR Groove Radar.lua"

local lab = Def.ActorFrame{};
local radars = Def.ActorFrame{}
local diffy = Def.ActorFrame{}
local rivalspanel = Def.ActorFrame{}

local ver = ""
if ThemePrefs.Get("SV") == "onepointzero" then
  ver = "1_"
end

for _,pn in pairs(GAMESTATE:GetEnabledPlayers()) do
    radars[#radars+1] = Def.ActorFrame{
          SetCommand=function(s)
            local song = GAMESTATE:GetCurrentSong();
            if song then
              s:visible(true)
            else
              s:visible(false)
            end
          end,
          CurrentSongChangedMessageCommand=function(s) s:queuecommand("Set") end,
	CurrentStepsP1ChangedMessageCommand=function(s) s:playcommand("Set") end,
	CurrentStepsP2ChangedMessageCommand=function(s) s:playcommand("Set") end,
	CurrentTrailP1ChangedMessageCommand=function(s) s:playcommand("Set") end,
	CurrentTrailP2ChangedMessageCommand=function(s) s:playcommand("Set") end,
        OnCommand=function(s) s:zoom(0):rotationz(-360):sleep(0.3):decelerate(0.4):zoom(1):rotationz(0) end,
        OffCommand=function(s) s:sleep(0.3):decelerate(0.3):rotationz(-360):zoom(0) end,
        Radar.create_ddr_groove_radar("radar",0,0,pn,125,Alpha(PlayerColor(pn),0.25))
    }
    diffy[#diffy+1] = Def.ActorFrame{
      OnCommand=function(s)
          if (pn==PLAYER_1) then
            s:xy(-100,-140)
          else
            s:xy(105,-140)
          end
          s:diffusealpha(0)
          if (pn==PLAYER_1) then
          s:addx(-10)
          else
          s:addx(10)
          end
          s:sleep(0.1+0/10)
          s:linear(0.1)
          s:diffusealpha(1)
          if (pn==PLAYER_1) then
          s:addx(10)
          else
          s:addx(-10)
          end
      end;
      OffCommand=function(s)
          s:sleep(0/10)
          s:linear(0.1)
          s:diffusealpha(0)
          if (pn==PLAYER_1) then
          s:addx(-10)
          else
          s:addx(10)
          end
      end;
      Def.BitmapText{
        Font="_avenirnext lt pro bold/20px";
          SetCommand=function(s)
            local song = GAMESTATE:GetCurrentSong();
            s:diffuse(Color.White)
            if song then
              local steps = GAMESTATE:GetCurrentSteps(pn)
			s:strokecolor(Color.HoloBlue)
			s:diffuse(Color.White)
			if steps ~= nil then
	              local value = steps:GetMeter()
				local diff = steps:GetDifficulty();
				local mt = '_MeterType_Default'
				mt = SongAttributes_GetMeterType(song)
	              s:settext("Diff "..value.."")
				if mt == '_MeterType_Pump' then
					s:settext("PIU "..value.."")
				elseif mt == '_MeterType_ITG' then
					s:settext("ITG "..value.."")
				elseif mt == '_MeterType_DDR' then
					s:settext("Old "..value.."")
				end
			if mt == '_MeterType_Pump' then
				s:strokecolor(Color.HoloDarkOrange)
			elseif mt == '_MeterType_ITG' then
				s:strokecolor(Color.HoloDarkRed)
			elseif mt == '_MeterType_DDR' then
				s:strokecolor(Color.HoloDarkGreen)
			end

			else
				s:settext("")
			end
			--Trace("Diff: "..tostring(diff)..".")
			if steps and steps:IsAutogen() then
				s:diffuse(Color.Black)
				mt = SongAttributes_GetMeterType(song)
				if mt == '_MeterType_Pump' then
					s:diffuse(ColorDarkTone(Color.HoloDarkOrange))
				elseif mt == '_MeterType_ITG' then
					s:diffuse(ColorDarkTone(Color.HoloDarkRed))
				elseif mt == '_MeterType_DDR' then
					s:diffuse(ColorDarkTone(Color.HoloDarkGreen))
				end
				s:strokecolor(Color.AutogenStep)
			end
            else
              s:settext("")
            end
            s:y(28)
            s:shadowcolor(Color.Black)
            s:shadowlength(2.0)
          end,
          CurrentSongChangedMessageCommand=function(s) s:queuecommand("Set") end,
          ["CurrentSteps"..ToEnumShortString(pn).."ChangedMessageCommand"]=function(s) s:queuecommand("Set") end,
          ["CurrentTrail"..ToEnumShortString(pn).."ChangedMessageCommand"]=function(s) s:queuecommand("Set") end,
      };
      Def.BitmapText{
        Font="_avenirnext lt pro bold/20px";
          SetCommand=function(s)
            local song = GAMESTATE:GetCurrentSong();
            if song then
              local steps = GAMESTATE:GetCurrentSteps(pn)
			  if steps ~= nil then
	                local value = steps:GetAuthorCredit()
	                s:settext(""..value.."")
			  else
	                s:settext("")
			  end
            else
              s:settext("")
            end
            s:strokecolor(Color.HoloBlue)
            s:shadowcolor(Color.Black)
            s:shadowlength(2.0)
            s:y(60)
            if (pn==PLAYER_1) then
              s:x(30)
              s:halign(1)
              s:maxwidth(150)
            else
              s:x(-35)
              s:halign(0)
              s:maxwidth(150)
            end
          end,
          CurrentSongChangedMessageCommand=function(s) s:queuecommand("Set") end,
          ["CurrentSteps"..ToEnumShortString(pn).."ChangedMessageCommand"]=function(s) s:queuecommand("Set") end,
          ["CurrentTrail"..ToEnumShortString(pn).."ChangedMessageCommand"]=function(s) s:queuecommand("Set") end,
      };
    };
end

for i,v in ipairs(GR) do
    lab[#lab+1] = Def.ActorFrame{
        OnCommand=function(s)
            s:xy(v[1],v[2])
            :diffusealpha(0):addx(-10):sleep(0.1+i/10):linear(0.1):diffusealpha(1):addx(10)
        end;
        OffCommand=function(s)
            s:sleep(i/10):linear(0.1):diffusealpha(0):addx(-10)
        end;
        Def.Sprite{
            Texture=THEME:GetPathB("ScreenSelectMusic","overlay/RadarHandler/"..ver.."RLabels"),
            OnCommand=function(s) s:animate(0):setstate(i-1) end,
        };
        Def.BitmapText{
            Font="_avenirnext lt pro bold/20px";
            SetCommand=function(s)
                local song = GAMESTATE:GetCurrentSong();
                    if song then
                        local steps = GAMESTATE:GetCurrentSteps(pn)
						if steps ~= nil then
							local value = lookup_ddr_radar_values(song, steps, pn)[i]
							s:settext(math.floor(value*100+0.5))
						else
							s:settext("")
						end
                    else
                        s:settext("")
                    end
                s:strokecolor(color("#1f1f1f")):shadowcolor(Color.Black):shadowlength(2.0):y(28)
                if GAMESTATE:GetNumPlayersEnabled() == 2 then
                    s:x(pn==PLAYER_2 and 30 or -30)
                else
                    s:x(0)
                end
            end,
            CurrentSongChangedMessageCommand=function(s) s:queuecommand("Set") end,
            ["CurrentSteps"..ToEnumShortString(pn).."ChangedMessageCommand"]=function(s) s:queuecommand("Set") end,
            ["CurrentTrail"..ToEnumShortString(pn).."ChangedMessageCommand"]=function(s) s:queuecommand("Set") end,
        };
    };
end

	local rivals = {1,2,3,4,5}
	local yspacing = 30
	for rival in ivalues(rivals) do
		local test_it = false
		rivalspanel[#rivalspanel+1] = Def.ActorFrame{
			InitCommand=function(s)
				s:visible(true)
				playercount = 0
				s:x(400)
				if (pn == PLAYER_1) then s:x(900) end
				s:y(-100+(rivals[rival]*yspacing)-yspacing)
				s:diffusealpha(1)
				--Trace("Enabled player count is "..#GAMESTATE:GetEnabledPlayers()..".")
				if(#GAMESTATE:GetEnabledPlayers() > 1) then
					--s:diffusealpha(0);
					s:x(20+((rival)*340)-340);
					s:y(-260+4);
					if(pn == PLAYER_2) then
						s:y(-230+4)
					end
					if(rival>3) then s:visible(false) end
				end;
			end,
			OnCommand=function(s) s:zoom(0):sleep(0.3):decelerate(0.4):zoom(1):rotationz(0) end,
			OffCommand=function(s) s:sleep(0.3):decelerate(0.3):zoom(0) end,
			SetCommand=function(s)
			--Trace("Setting rival window")
			local c = s:GetChildren();

			local song = GAMESTATE:GetCurrentSong()
			local topgrade
			if song then
				s:visible(true)
				if(#GAMESTATE:GetEnabledPlayers() > 1 and rival>3) then s:visible(false) end
				local steps = GAMESTATE:GetCurrentSteps(pn)
				if steps then
					c.Bar_underlay:visible(true)
					if rival == 1 then
						c.Bar_place:diffuse(color("#3cbbf6"))
					elseif rival == 2 then
						c.Bar_place:diffuse(color("#d6d7d4"))
					elseif rival == 3 then
						c.Bar_place:diffuse(color("#f6cc40"))
					else
						c.Bar_place:diffuse(color("#f22133"))
					end
				end
				local profile = PROFILEMAN:GetMachineProfile();
				scorelist = nil
				if steps then
					scorelist = PROFILEMAN:GetMachineProfile():GetHighScoreListIfExists(song,steps)
				end
				scores = nil
				if scorelist then
					scores = scorelist:GetHighScores()
				end
				local topscore = 0
				local RStats = nil
				if scores and scores[rival] then
					if ThemePrefs.Get("ConvertScoresAndGrades") then
						topscore = SN2Scoring.GetSN2ScoreFromHighScore(steps, scores[rival])
						topgrade = SN2Grading.ScoreToGrade(topscore,steps)
					else
						topscore = scores[rival]:GetScore()
						topgrade = scores[rival]:GetGrade()
					end
					if scores[1] then
						RStats = scores[1];
					end
				end
				if test_it and not topscore then
					topscore = 100
				end
				if test_it and not topgrade then
					topgrade = 'Grade_Tier01'
				end
				--Trace("Scores have just been set")
				if test_it or topscore ~= 0 then
					s:visible(true)
					if(#GAMESTATE:GetEnabledPlayers() > 1 and rival>3) then s:visible(false) end
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
					c.Bar_underlay:diffuse(Color.White)
					c.Text_name:diffuse(Color.White)
					c.Text_score:settext(commify(topscore))
					if test_it or scores[rival]:GetName() ~= nil then
						if not scores or not rival or not scores[rival] or not scores[rival]:GetName() or scores[rival]:GetName() == "" then
							c.Text_name:settext("NO NAME")
						else
							c.Text_name:settext(scores[rival]:GetName())
							for _,pns in pairs(GAMESTATE:GetEnabledPlayers()) do
								local prof = PROFILEMAN:GetProfile(pns)
								if(scores[rival]:GetName() == prof:GetDisplayName()) then
									c.Text_name:diffusecolor( (GetProfileColor(PROFILEMAN:GetProfile(pns)) ) )
								end
							end
						end
					else
						c.Text_name:settext("STEP")
					end
					c.Img_grade:visible(true)
					--Trace("Grade is "..topgrade..".");
					c.Img_grade:Load(THEME:GetPathG("myMusicWheel/GradeDisplayEval",ToEnumShortString(topgrade)))
					if (misses+boos) == 0 and scores[1]:GetScore() > 0 and (marvelous+perfects)>0 then
						if (greats+perfects) == 0 then
							c.Img_fc:visible(true):diffuse(GameColor.Judgment["JudgmentLine_W1"])
							:glowblink():effectperiod(0.20)
						elseif greats == 0 then
							c.Img_fc:visible(true):diffuse(GameColor.Judgment["JudgmentLine_W2"])
							:glowshift()
						elseif (misses+boos+goods) == 0 then
							c.Img_fc:visible(true):diffuse(GameColor.Judgment["JudgmentLine_W3"])
							:stopeffect()
						elseif (misses+boos) == 0 then
							c.Img_fc:visible(true):diffuse(GameColor.Judgment["JudgmentLine_W4"])
							:stopeffect()
						else
							c.Img_fc:visible(false)
						end;
						c.Img_fc:diffusealpha(0.8);
					else
						c.Img_fc:visible(false)
					end;
				else
					s:visible(false)
					c.Bar_underlay:diffuse(Alpha(Color.White,0.2))
					c.Text_score:settext("")
					c.Text_name:settext("")
					c.Img_grade:visible(false)
					c.Img_fc:visible(false) 
				end
			else
				s:visible(false)
			end
		end,
		CurrentSongChangedMessageCommand=function(s) s:queuecommand("Set") end,
		["CurrentSteps"..ToEnumShortString(pn).."ChangedMessageCommand"]=function(s) s:queuecommand("Set") end,
		["CurrentTrail"..ToEnumShortString(pn).."ChangedMessageCommand"]=function(s) s:queuecommand("Set") end,
		Def.ActorFrame{
			Name="Bar_underlay";
			Def.Quad{
				InitCommand=function(s) s:setsize(312,26):faderight(0.75):diffusealpha(0.5) end,
			};
			Def.Quad{
				InitCommand=function(s) s:y(-12):setsize(312,2):faderight(0.5):diffusealpha(0.5) end,
			};
		};
		Def.Quad{
			Name="Bar_place",
			InitCommand=function(s) s:x(-140):setsize(20,20) end,
		};
		Def.BitmapText{
			Font="_avenirnext lt pro bold/36px",
			Name="Text_label";
			Text="Top Scores";
			InitCommand=function(s)
				s:x(-70-2)
				s:y(-30-2)
				s:visible(true)
				if(#GAMESTATE:GetEnabledPlayers() > 1) then
					s:visible(false)
					--s:x(-240);
					--s:y(0);
					--if(pn == PLAYER_1) then
					--	s:settext("Top Scores 1P");
					--end
				end;
				if(rival ~= 1) then
					s:visible(false)
				end
				--s:strokecolor(Alpha(Color.Black,0.5))
				--s:strokecolor(Color.Black)
				s:shadowcolor(Color.Black)
				s:shadowlength(2)
				s:zoom(0.7)
			end,
		};
		Def.BitmapText{
			Font="_avenirnext lt pro bold/25px",
			Name="Text_place";
			Text=rival;
			InitCommand=function(s) s:x(-140):strokecolor(Alpha(Color.Black,0.5)):zoom(0.7) end,
		};
		Def.BitmapText{
			Name="Text_name",
			Font="_avenirnext lt pro bold/20px",
			InitCommand=function(s) s:x(-120):halign(0):diffuse(Color.White):strokecolor(Color.Black) end,
		};
		Def.BitmapText{
			Name="Text_score",
			Font="_avenirnext lt pro bold/20px",
			InitCommand=function(s) s:x(120):halign(1):diffuse(Color.White):strokecolor(Color.Black) end,
		};
		Def.Sprite{
			Texture=THEME:GetPathG("Player","Badge FullCombo"),
			Name="Img_fc",
			InitCommand=function(s) s:zoom(0.35):xy(166,0) end,
		};
		Def.Sprite{
			Name="Img_grade",
			InitCommand=function(s) s:x(146) end,
		};
	}
	end

return Def.ActorFrame{
    Def.ActorFrame{
        Name="Radar",
        InitCommand=function(s) s:zoom(0) end,
          SetCommand=function(s)
            local song = GAMESTATE:GetCurrentSong();
            if song then
              s:visible(true)
            else
              s:visible(false)
            end
          end,
          CurrentSongChangedMessageCommand=function(s) s:queuecommand("Set") end,
	CurrentStepsP1ChangedMessageCommand=function(s) s:playcommand("Set") end,
	CurrentStepsP2ChangedMessageCommand=function(s) s:playcommand("Set") end,
	CurrentTrailP1ChangedMessageCommand=function(s) s:playcommand("Set") end,
	CurrentTrailP2ChangedMessageCommand=function(s) s:playcommand("Set") end,
        OnCommand=function(s) s:zoom(0):rotationz(-360):sleep(0.4):decelerate(0.4):zoom(1):rotationz(0) end,
        OffCommand=function(s) s:sleep(0.3):decelerate(0.3):rotationz(-360):zoom(0) end,
        Def.Sprite{
            Texture=THEME:GetPathB("ScreenSelectMusic","overlay/RadarHandler/"..ver.."GrooveRadar base"),
        };
        Def.Sprite{
            Texture=THEME:GetPathB("ScreenSelectMusic","overlay/RadarHandler/sweep"),
            InitCommand = function(s) s:zoom(1.275):spin():effectmagnitude(0,0,100) end,
        };
    };
    lab;
    diffy;
    radars;
    rivalspanel;
}

