local pn = ({...})[1] --only argument to file
local GR = {
    {-1,-112, "Stream"}, --STREAM
    {-120,-43, "Voltage"}, --VOLTAGE
    {-108,72, "Air"}, --AIR
    {108,72, "Freeze"}, --FREEZE
    {120,-43, "Chaos"}, --CHAOS
};

local ver = ""
if ThemePrefs.Get("SV") == "onepointzero" then
  ver = "1_"
end

local Radar = LoadModule "DDR Groove Radar.lua"
local ScoreAndGrade = LoadModule('ScoreAndGrade.lua')

local lab = Def.ActorFrame{};
local radars = Def.ActorFrame{}
local diffy = Def.ActorFrame{}
local rivalspanel = Def.ActorFrame{}

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

function GetRivalScoreData(pn,scoreno)
	local data = {
		HasScore = false,
		Name     = "STARLiGHT",
		Date     = nil,
		Score    = 0,
		EXScore  = 0,
		MAXCombo = 0,
		W1       = 0,
		W2       = 0,
		W3       = 0,
		W4       = 0,
		W5       = 0,
		Miss     = 0,
		OK       = 0,
		internal = nil,
	}

	local SongOrCourse, StepsOrTrail
	if GAMESTATE:IsCourseMode() then
		SongOrCourse = GAMESTATE:GetCurrentCourse()
		StepsOrTrail = GAMESTATE:GetCurrentTrail(pn)
	else
		SongOrCourse = GAMESTATE:GetCurrentSong()
		StepsOrTrail = GAMESTATE:GetCurrentSteps(pn)
	end
	if not (SongOrCourse and StepsOrTrail) then
		return data
	end

	local profile
	profile = PROFILEMAN:GetMachineProfile()
	
	local scores = profile:GetHighScoreList(SongOrCourse, StepsOrTrail):GetHighScores()
	local score = scores[scoreno]
	if not score then
		return data
	end
	
	data.HasScore  = true
	if(score:GetName() ~= nil) then
		data.Name = score:GetName()
	else
		data.Name = "STARLiGHT"
	end
	data.Date     = score:GetDate() 
	data.Score    = ScoreAndGrade.GetScore(score, StepsOrTrail, false)
	data.EXScore  = ScoreAndGrade.GetScore(score, StepsOrTrail, true)
	data.MAXCombo = score:GetMaxCombo()
	data.W1       = score:GetTapNoteScore('TapNoteScore_W1')
	data.W2       = score:GetTapNoteScore('TapNoteScore_W2')
	data.W3       = score:GetTapNoteScore('TapNoteScore_W3')
	data.W4       = score:GetTapNoteScore('TapNoteScore_W4')
	data.Miss     = score:GetTapNoteScore('TapNoteScore_W5') + score:GetTapNoteScore('TapNoteScore_Miss') + score:GetHoldNoteScore('HoldNoteScore_LetGo')
	data.OK       = score:GetHoldNoteScore('HoldNoteScore_Held')
	data.internal = score
	
	Trace(tostring(scoreno)..": "..tostring(data.Name).." "..tostring(data.HasScore).." "..tostring(data.Score).." "..tostring(data.EXScore).." ")
	
	return data
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
        Def.Sprite{
            Texture=THEME:GetPathG("","_shared/Radar/"..ver.."RLabels"),
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

	local rivals = {1,2,3,4,5,6,7,8}
	local yspacing = 30
	for rival in ivalues(rivals) do
		rivalspanel[#rivalspanel+1] = Def.ActorFrame{
			InitCommand=function(s)
				s:visible(true)
				playercount = 0
				s:x(400)
				if (pn == PLAYER_1) then s:x(900) end
				--s:y(-100+(rivals[rival]*yspacing)-yspacing)
				s:y(-128+(rivals[rival]*yspacing)-yspacing)
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
           		local scoreData = GetRivalScoreData(pn,rival)
				local c = s:GetChildren();

				if scoreData.Name ~= nil then
					c.Text_name:settext(scoreData.Name)
				else
					c.Text_name:settext("STARLiGHT")
				end
				c.Text_name:diffusecolor(Color.White)
				for _,pns in pairs(GAMESTATE:GetEnabledPlayers()) do
					local prof = PROFILEMAN:GetProfile(pns)
					if(scoreData.Name == prof:GetDisplayName()) then
						c.Text_name:diffusecolor( (GetProfileColor(PROFILEMAN:GetProfile(pns)) ) )
					end
				end

				local test_it = false

				if (scoreData.HasScore == nil or scoreData.HasScore == false) and test_it == false then
					s:visible(false)
					return
				end

				s:visible(true)
				if(#GAMESTATE:GetEnabledPlayers() > 1 and rival>3) then s:visible(false) end
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

				local steps = GAMESTATE:GetCurrentSteps(pn)
				if steps then
					s:playcommand('SetScore', { Stats = scoreData.internal, Steps = steps })
				else
					s:playcommand('SetScore', { Stats = nil, Steps = nil })
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
					end;
					if(rival ~= 1) then
						s:visible(false)
					end
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
			ScoreAndGrade.CreateScoreActor{
				Name='Score',
				Font='_avenirnext lt pro bold/25px',
				Load='RollingNumbersSongData',
				InitCommand=function(s) s:x(120):halign(1):diffuse(Color.White):strokecolor(Color.Black) end,
			},
			ScoreAndGrade.CreateGradeActor{
				Name='Grade',
				InitCommand=function(self)
					self:xy(146,0):zoom(1.0)
					self:GetChild('FullCombo'):zoom(0.5):xy(20,0)
				end,
			},
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
            Texture=THEME:GetPathG("","_shared/Radar/"..ver.."GrooveRadar base"),
        };
        Def.Sprite{
            Texture=THEME:GetPathG("","_shared/Radar/sweep"),
            InitCommand = function(s) s:zoom(1.275):spin():effectmagnitude(0,0,100) end,
        };
    };
    lab;
    diffy;
    radars;
    rivalspanel;
}

