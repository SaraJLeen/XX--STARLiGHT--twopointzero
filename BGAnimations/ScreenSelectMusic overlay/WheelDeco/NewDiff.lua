local basespacing = 0
local yspacing = 40
local DiffList = Def.ActorFrame{};
SaraDiffNum = 1
SaraDiffNum2 = 1
SaraDiffSlots = {}
SaraTotalDiff = 0
local mt = '_MeterType_Default'
for i=0, 1000 do
  SaraDiffSlots[i] = 0
end
local crop_old_meters = false
local convert_meters = true

local function DrawDiffListItem(diff)
  local DifficultyListItem = Def.ActorFrame{
    InitCommand=function(s)
      s:y(0)
    end,
    CurrentSongChangedMessageCommand=function(s) s:queuecommand("Set") end,
    SetCommand=function(self)
      local st=GAMESTATE:GetCurrentStyle():GetStepsType()
      local song=GAMESTATE:GetCurrentSong()
      if song then
		mt = LoadModule"SongAttributes.lua".GetMeterType(song)
		if mt == '_MeterType_Pump' then
			--Trace("Song meter type: Pump.");
		elseif mt == '_MeterType_ITG' then
			--Trace("Song meter type: In The Groove.");
		elseif mt == '_MeterType_DDR' then
			--Trace("Song meter type: Classic DDR.");
		elseif mt == '_MeterType_DDRX' then
			--Trace("Song meter type: Modern X.");
		else
			--Trace("Song meter type: "..tostring(mt)..".");
		end
        if song:HasStepsTypeAndDifficulty( st, diff ) then
          local steps = song:GetOneSteps( st, diff )
          self:diffusealpha(1)
          if diff ~= nil then
            if Difficulty:Reverse()[diff] ~= nil then
              self:y(((SaraDiffSlots[tonumber(Difficulty:Reverse()[diff])+1]-1) * yspacing) + basespacing)
            end
          end
        else
          self:diffusealpha(0.0)
          return DifficultyListItem
        end
      else
		mt = '_MeterType_Default';
        self:diffusealpha(0.0)
        return DifficultyListItem
      end;
    end,
    Def.BitmapText{
      Font="_avenirnext lt pro bold/20px",
      Name="DiffLabel";
      InitCommand=function(self)
        self:halign(0):draworder(99):diffuse(CustomDifficultyToColor(diff)):strokecolor(Color.Black):zoom(1.2)
        self:x(-210)
	   local song=GAMESTATE:GetCurrentSong()
	   if song then
          self:settext(string.upper(GetDifficultyName(diff,song)))
        else
          self:settext(THEME:GetString("CustomDifficulty",ToEnumShortString(diff)))
        end
      end;
      SetCommand=function(self)
	   local song=GAMESTATE:GetCurrentSong()
	   if song then
          self:settext(string.upper(GetDifficultyName(diff,song)))
        else
          self:settext(THEME:GetString("CustomDifficulty",ToEnumShortString(diff)))
        end
      end;
    };
    Def.BitmapText{
      Font="_avenirnext lt pro bold/25px",
      Name="Meter";
      InitCommand=function(s) s:draworder(99):strokecolor(Color.Black):x(-30):halign(0.50):valign(0.50) end,
      SetCommand=function(self)
        self:settext("")
        local st=GAMESTATE:GetCurrentStyle():GetStepsType()
        local song=GAMESTATE:GetCurrentSong()
        if song then
          if song:HasStepsTypeAndDifficulty( st, diff ) then
            local steps = song:GetOneSteps( st, diff )
		if (diff == "Difficulty_Edit") then
			self:valign(0)
			self:halign(0.50)
			self:y(-9)
			self:x(224)
			steps1 = GAMESTATE:GetCurrentSteps(PLAYER_1);
			steps2 = GAMESTATE:GetCurrentSteps(PLAYER_2);
			name1 = nil
			name2 = nil
			desc1 = nil
			desc2 = nil
			if steps1 then
				name1 = steps1:GetChartName();
				desc1 = steps1:GetDescription();
				if name1 and name1 == "" then name1 = nil end
				if desc1 and desc1 == "" then desc1 = nil end
			end
			if steps2 then
				name2 = steps2:GetChartName();
				desc2 = steps2:GetDescription();
				if name2 and name2 == "" then name2 = nil end
				if desc2 and desc2 == "" then desc2 = nil end
			end
			if GAMESTATE:GetNumPlayersEnabled() >= 2 and steps1 and steps1:GetDifficulty() == "Difficulty_Edit" and steps2 and steps2:GetDifficulty() == "Difficulty_Edit" then
				local meter1 = steps1:GetMeter()
				local meter2 = steps2:GetMeter()
				if convert_meters and (mt ~= '_MeterType_DDRX' and mt ~= '_MeterType_Default') then
					meter1 = GetConvertDifficulty_DDRX(song,steps1,mt)
					meter2 = GetConvertDifficulty_DDRX(song,steps2,mt)
				end
				workstring = "&UP;&UP; 1P: "..meter1.."/2P: "..meter2.." &DOWN;&DOWN;"
				if mt == '_MeterType_DDR' then
					--workstring = "&UP;&UP; 1P: Classic "..meter1.."/2P: Classic "..steps2:GetMeter().." &DOWN;&DOWN;"
				elseif mt == '_MeterType_DDRX' then
					--workstring = "&UP;&UP; 1P: DDR "..meter1.."/2P: DDR "..meter2.." &DOWN;&DOWN;"
				elseif mt == '_MeterType_ITG' then
					--workstring = "&UP;&UP; 1P: ITG "..meter1.."/2P: ITG "..meter2.." &DOWN;&DOWN;"
				elseif mt == '_MeterType_Pump' then
					--workstring = "&UP;&UP; 1P: Pump "..meter1.."/2P: Pump "..meter2.." &DOWN;&DOWN;"
				end
				needlines = 6
				has1p = false
				has2p = false
				if(name1 == name2 and desc1 == desc2) then
					if(SaraDiffSlots[tonumber(Difficulty:Reverse()[diff])+1] < needlines) and name1 then
						workstring = workstring.."\n"..name1..""
						needlines = needlines-1
					end
					if(SaraDiffSlots[tonumber(Difficulty:Reverse()[diff])+1] < needlines) and desc1 then
						workstring = workstring.."\n"..desc1..""
						needlines = needlines-1
					end
				else
					if(SaraDiffSlots[tonumber(Difficulty:Reverse()[diff])+1] < needlines) and name1 then
						if not has1p then
							workstring = workstring.."\n(1P) "
							has1p = true
						else workstring = workstring.."\n" end
						workstring = workstring..""..name1..""
						needlines = needlines-1
					end
					if(SaraDiffSlots[tonumber(Difficulty:Reverse()[diff])+1] < needlines) and desc1 then
						if not has1p then
							workstring = workstring.."\n(1P) "
							has1p = true
						else workstring = workstring.."\n" end
						workstring = workstring..""..desc1..""
						needlines = needlines-1
					end
					if(SaraDiffSlots[tonumber(Difficulty:Reverse()[diff])+1] < needlines) and name2 then
						if not has2p then
							workstring = workstring.."\n(2P) "
							has2p = true
						else workstring = workstring.."\n" end
						workstring = workstring..""..name2..""
						needlines = needlines-1
					end
					if(SaraDiffSlots[tonumber(Difficulty:Reverse()[diff])+1] < needlines) and desc2 then
						if not has2p then
							workstring = workstring.."\n(2P) "
							has2p = true
						else workstring = workstring.."\n" end
						workstring = workstring..""..desc2..""
						needlines = needlines-1
					end
				end
				self:settext( workstring )
				self:ClearAttributes()
				self:diffuse(Color.White)
				if steps1:IsAutogen() then
					self:AddAttribute(7,{ Diffuse = Color.AutogenStep, Length = #tostring(meter1); });
				elseif convert_meters and (mt ~= '_MeterType_DDRX' and mt ~= '_MeterType_Default') then
					self:AddAttribute(7,{ Diffuse = Color.ConvDiffStep, Length = #tostring(meter1); });
				end
				if steps2:IsAutogen() then
					self:AddAttribute(12+#tostring(meter1),{ Diffuse = Color.AutogenStep, Length = #tostring(meter2); });
				elseif convert_meters and (mt ~= '_MeterType_DDRX' and mt ~= '_MeterType_Default') then
					self:AddAttribute(12+#tostring(meter1),{ Diffuse = Color.ConvDiffStep, Length = #tostring(meter2); });
				end
	              --if(steps1:IsAutogen() or steps2:IsAutogen()) then
				--	self:diffuse(Color.AutogenStep)
				--end
			elseif GAMESTATE:IsPlayerEnabled(PLAYER_1) and steps1 and steps1:GetDifficulty() == "Difficulty_Edit" then
				local meter1 = steps1:GetMeter()
				if convert_meters and (mt ~= '_MeterType_DDRX' and mt ~= '_MeterType_Default') then
					meter1 = GetConvertDifficulty_DDRX(song,steps1,mt)
				end
				workstring = "&UP;&UP; 1P: "..meter1.." &DOWN;&DOWN;"
				if mt == '_MeterType_DDR' then
					--workstring = "&UP;&UP; 1P: Classic "..meter1.." &DOWN;&DOWN;"
				elseif mt == '_MeterType_DDRX' then
					--workstring = "&UP;&UP; 1P: DDR "..meter1.." &DOWN;&DOWN;"
				elseif mt == '_MeterType_ITG' then
					--workstring = "&UP;&UP; 1P: ITG "..meter1.." &DOWN;&DOWN;"
				elseif mt == '_MeterType_Pump' then
					--workstring = "&UP;&UP; 1P: Pump "..meter1.." &DOWN;&DOWN;"
				end
				needlines = 6
				if(SaraDiffSlots[tonumber(Difficulty:Reverse()[diff])+1] < needlines) and name1 then
					workstring = workstring.."\n"..name1..""
					needlines = needlines-1
				end
				if(SaraDiffSlots[tonumber(Difficulty:Reverse()[diff])+1] < needlines) and desc1 then
					workstring = workstring.."\n"..desc1..""
					needlines = needlines-1
				end
				self:settext( workstring )
				self:ClearAttributes()
				self:diffuse(Color.White)
				if steps1:IsAutogen() then
					self:AddAttribute(7,{ Diffuse = Color.AutogenStep, Length = #tostring(meter1); });
				elseif convert_meters and (mt ~= '_MeterType_DDRX' and mt ~= '_MeterType_Default') then
					self:AddAttribute(7,{ Diffuse = Color.ConvDiffStep, Length = #tostring(meter1); });
				end
	              --if(steps1:IsAutogen()) then
				--	self:diffuse(Color.AutogenStep)
				--end
			elseif GAMESTATE:IsPlayerEnabled(PLAYER_2) and steps2 and steps2:GetDifficulty() == "Difficulty_Edit" then
				local meter2 = steps2:GetMeter()
				if convert_meters and (mt ~= '_MeterType_DDRX' and mt ~= '_MeterType_Default') then
					meter2 = GetConvertDifficulty_DDRX(song,steps2,mt)
				end
				workstring = "&UP;&UP; 2P: "..meter2.." &DOWN;&DOWN;"
				if mt == '_MeterType_DDR' then
					--workstring = "&UP;&UP; 2P: Classic "..meter2.." &DOWN;&DOWN;"
				elseif mt == '_MeterType_DDRX' then
					--workstring = "&UP;&UP; 2P: DDR "..meter2.." &DOWN;&DOWN;"
				elseif mt == '_MeterType_ITG' then
					--workstring = "&UP;&UP; 2P: ITG "..meter2.." &DOWN;&DOWN;"
				elseif mt == '_MeterType_Pump' then
					--workstring = "&UP;&UP; 2P: Pump "..meter2.." &DOWN;&DOWN;"
				end
				needlines = 6
				if(SaraDiffSlots[tonumber(Difficulty:Reverse()[diff])+1] < needlines) and name2 then
					workstring = workstring.."\n"..name2..""
					needlines = needlines-1
				end
				if(SaraDiffSlots[tonumber(Difficulty:Reverse()[diff])+1] < needlines) and desc2 then
					workstring = workstring.."\n"..desc2..""
					needlines = needlines-1
				end
				self:settext( workstring )
				self:ClearAttributes()
				self:diffuse(Color.White)
				if steps1:IsAutogen() then
					self:AddAttribute(7,{ Diffuse = Color.AutogenStep, Length = #tostring(meter2); });
				elseif convert_meters and (mt ~= '_MeterType_DDRX' and mt ~= '_MeterType_Default') then
					self:AddAttribute(7,{ Diffuse = Color.ConvDiffStep, Length = #tostring(meter2); });
				end
	              --if(steps2:IsAutogen()) then
				--	self:diffuse(Color.AutogenStep)
				--end
			else
				self:diffuse(Color.White)
				self:valign(0.50)
				self:halign(0.50)
				self:x(224)
				self:y(0)
				self:settext( "Additional difficulties are hidden here" )
			end
            else
              self:valign(0.50)
              self:halign(0.50)
              self:y(0)
              self:x(-30)
              self:settext( steps:GetMeter() )
			self:diffuse(Color.White)
              if(steps:IsAutogen()) then
				self:diffuse(Color.AutogenStep)
			elseif convert_meters and (mt ~= '_MeterType_DDRX' and mt ~= '_MeterType_Default') then
				self:settext( tostring(GetConvertDifficulty_DDRX(song,steps,mt)) )
				self:diffuse(Color.ConvDiffStep)
			end
			if false and mt == '_MeterType_Pump' then
	              self:settext( "Pump "..tostring(steps:GetMeter()).."" )
				self:x(224)
			end
			--Trace( "GCD_DDRX: "..tostring(GetConvertDifficulty_DDRX(song,steps,mt)).."." )
            end
          end
        end;
      end,
      CurrentSongChangedMessageCommand=function(s) s:queuecommand("Set") end,
	CurrentStepsP1ChangedMessageCommand=function(s) s:playcommand("Set") end,
	CurrentStepsP2ChangedMessageCommand=function(s) s:playcommand("Set") end,
	CurrentTrailP1ChangedMessageCommand=function(s) s:playcommand("Set") end,
	CurrentTrailP2ChangedMessageCommand=function(s) s:playcommand("Set") end,
    };
    Def.Sprite{
        Texture="ticks",
        InitCommand=function(s)
        if (diff == "Difficulty_Edit") then
          s:diffusealpha(0.0)
        else
          s:diffusealpha(1.0)
        end
        s:halign(0)
        if (diff ~= "Difficulty_Edit") then
          s:diffuse(CustomDifficultyToColor(diff))
            local song = GAMESTATE:GetCurrentSong()
			s:cropright(1)
            if song then
                local steps = song:GetOneSteps(GAMESTATE:GetCurrentStyle():GetStepsType(),diff)
                if steps then
				s:cropright(0)
				if(steps:IsAutogen()) then
					s:diffuse(Color.AutogenStep)
				end
			end
		end
        end
        end,
      CurrentSongChangedMessageCommand=function(s) s:queuecommand("Init") end,
	CurrentStepsP1ChangedMessageCommand=function(s) s:playcommand("Init") end,
	CurrentStepsP2ChangedMessageCommand=function(s) s:playcommand("Init") end,
	CurrentTrailP1ChangedMessageCommand=function(s) s:playcommand("Init") end,
	CurrentTrailP2ChangedMessageCommand=function(s) s:playcommand("Init") end,
    };
    Def.Sprite{
        Texture="ticks",
        InitCommand=function(s)
        if (diff == "Difficulty_Edit") then
          s:diffusealpha(0.0)
        else
          s:diffusealpha(1.0)
        end
        s:halign(0)
        end,
        SetCommand=function(s)
            if (diff == "Difficulty_Edit") then
            else
            local song = GAMESTATE:GetCurrentSong()
            if song then
                local steps = song:GetOneSteps(GAMESTATE:GetCurrentStyle():GetStepsType(),diff)
                if steps then
	                s:cropleft(30)
                    local meter = steps:GetMeter()
				if convert_meters and (mt ~= '_MeterType_DDRX' and mt ~= '_MeterType_Default') then
					meter = GetConvertDifficulty_DDRX(song,steps,mt)
				end
				if crop_old_meters and (mt == '_MeterType_DDR' or mt == '_MeterType_ITG') then
					s:cropright(0.5)
				end
				--if mt == '_MeterType_Pump' then
				--	s:cropright(1)
				--end
                    s:diffuse(CustomDifficultyToDarkColor(diff)):cropleft(math.min(1,meter/20))
                else
                    s:cropleft(1)
                end
            else
                s:cropleft(1)
            end
            end
        end
    };
  };
  return DifficultyListItem
end

local difficulties = {"Difficulty_Beginner", "Difficulty_Easy", "Difficulty_Medium", "Difficulty_Hard", "Difficulty_Challenge", "Difficulty_Edit"}


for diff in ivalues(difficulties) do
  DiffList[#DiffList+1] = DrawDiffListItem(diff)
end

local ind = Def.ActorFrame{};

for pn in EnabledPlayers() do
    ind[#ind+1] = Def.ActorFrame{
        ["CurrentSteps" .. ToEnumShortString(pn) .. "ChangedMessageCommand"]=function(s)
            local song=GAMESTATE:GetCurrentSong()
            local olddiff=diff
            SaraTotalDiff = 0
            basespacing = 0
            if song then
              SaraDiffNum = 1
              SaraDiffNum2 = 1
              for i=0, 1000 do
                SaraDiffSlots[i] = 0
              end
              for diff in ivalues(difficulties) do
                local st=GAMESTATE:GetCurrentStyle():GetStepsType();
                if song:HasStepsTypeAndDifficulty( st, diff ) then
                  local steps = song:GetOneSteps( st, diff )
                  SaraDiffSlots[tonumber(Difficulty:Reverse()[diff])+1] = SaraDiffNum2
                  SaraDiffNum2 = SaraDiffNum2 + 1
                  SaraDiffNum = SaraDiffNum + 1
                  SaraTotalDiff = SaraTotalDiff + 1
                  --Trace( "Drawing "..diff..". Current SaraDiffNum is "..SaraDiffNum.." and SaraDiffNum2 is "..SaraDiffNum2..". Reversed "..Difficulty:Reverse()[diff]..". Array value "..SaraDiffSlots[tonumber(Difficulty:Reverse()[diff])].."." )
                else
                  SaraDiffNum = SaraDiffNum + 1
                  --Trace( "Drawing "..diff..". Current SaraDiffNum is "..SaraDiffNum.." and SaraDiffNum2 is "..SaraDiffNum2..". Reversed "..Difficulty:Reverse()[diff]..". Array value "..SaraDiffSlots[tonumber(Difficulty:Reverse()[diff])].."." )
                end
              end;
            end
            if (SaraTotalDiff < 6) then basespacing = 10; end
            diff=olddiff
            if song then
              local steps = GAMESTATE:GetCurrentSteps(pn)
              if steps then
                local diff = steps:GetDifficulty();
                local st=GAMESTATE:GetCurrentStyle():GetStepsType();
                --Trace( "Current diff is "..Difficulty:Reverse()[diff]..". Array value "..SaraDiffSlots[tonumber(Difficulty:Reverse()[diff])].."." )
                s:y(((SaraDiffSlots[tonumber(Difficulty:Reverse()[diff])+1]-1) * yspacing) + basespacing)
              end;
            end;
        end,
        CurrentSongChangedMessageCommand=function(s)
            s:visible(GAMESTATE:GetCurrentSong() ~= nil)
        end,
        Def.Sprite{ Texture="cursorglow 1x2",
            InitCommand=function(s) s:setstate(pn==PLAYER_1 and 0 or 1):animate(false) end,
            --blahblahblah But Inori, why don't you use the fancy function you used right above?
            --This way both actors get updated correctly.
            CurrentStepsP1ChangedMessageCommand=function(s) s:queuecommand("Set") end,
            CurrentStepsP2ChangedMessageCommand=function(s) s:queuecommand("Set") end,
            SetCommand=function(s)
                local p1diff = GAMESTATE:GetCurrentSteps(PLAYER_1)
                local p2diff = GAMESTATE:GetCurrentSteps(PLAYER_2)
                if p1diff == p2diff and GAMESTATE:GetNumPlayersEnabled() == 2 then
                    s:cropleft(pn==PLAYER_2 and 0.5 or 0):cropright(pn==PLAYER_1 and 0.5 or 0)
                else
                    s:cropleft(0):cropright(0)
                end
            end
        };
        Def.Sprite{
            Texture=THEME:GetPathG("","_shared/Diff/"..ToEnumShortString(pn)),
            InitCommand=function(s) s:x(pn == PLAYER_1 and -380 or 380) end,
        };
    }
end

return Def.ActorFrame{
    InitCommand=function(s) s:y(-90) end,
    ind;
    DiffList..{
        InitCommand=function(s) s:x(-140) end,
    };
}