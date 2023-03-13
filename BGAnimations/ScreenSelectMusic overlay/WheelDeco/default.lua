local ex = ""
if GAMESTATE:IsAnExtraStage() then
  ex = "ex_"
end
local SongAttributes = LoadModule "SongAttributes.lua"

local t = Def.ActorFrame{
  Def.Actor{
    Name="WheelActor",
    BeginCommand=function(s)
			local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
      mw:xy(_screen.cx+360,_screen.cy+20)
      SCREENMAN:GetTopScreen():GetChild("Header"):visible(false)
		end,
		OnCommand=function(s)
			local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
			mw:rotationy(30)
				:addx(1100):sleep(0.412):linear(0.196):addx(-1100)
			mw:SetDrawByZPosition(true)
		end,
		OffCommand=function(s)
			local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
			mw:bouncebegin(0.15):zoomx(3):diffusealpha(0)
		end
  };
}

local DescPane = Def.ActorFrame{
	InitCommand = function(s) s:xy(SCREEN_LEFT+0,SCREEN_TOP+0):visible(true) end,
	CurrentSongChangedMessageCommand=function(s) s:queuecommand("Set") end,
	loadfile(THEME:GetPathB("ScreenSelectMusic","overlay/WheelDeco/GroupDesc.lua"))();
}

local RecordPane = Def.ActorFrame{
  InitCommand = function(s) s:xy(SCREEN_LEFT+470,SCREEN_BOTTOM-150) end,
  OnCommand=function(s) s:addy(600):sleep(0.4):decelerate(0.3):addy(-600)
    MESSAGEMAN:Broadcast("HelpText",{Text=THEME:GetString(Var "LoadingScreen","HelpText")})
    if #GAMESTATE:GetEnabledPlayers() < 2 then MESSAGEMAN:Broadcast("HelpText",{Text=THEME:GetString(Var "LoadingScreen","HelpText1P")}); end
  end,
  OffCommand=function(s) s:sleep(0.3):decelerate(0.3):addy(600) end,
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
    Texture=ex.."RadarBack",
  };
  Def.Sprite{
    Texture="eq",
    InitCommand = function(s) s:diffuse(color("0.25,0.25,0.25,0.5")) end,
  };
  loadfile(THEME:GetPathB("ScreenSelectMusic","overlay/WheelDeco/BPM.lua"))();
  Def.ActorFrame{
    Def.Quad {
    	InitCommand = function(s) s:zoomto(916,204):y(-10) end,
    	OnCommand = function(s) s:bounce():effectclock("beatnooffset")
		s:effectperiod(1) -- Change this to 2 to pump every 2 beats instead - Sara
		s:effectmagnitude(0,254,0):MaskSource(true)
      end,
    };
    Def.Sprite{
      Texture="eq",
    	InitCommand = function(s) s:MaskDest():ztestmode("ZTestMode_WriteOnFail") end,
    };
  };
}

for _,pn in pairs(GAMESTATE:GetEnabledPlayers()) do
  t[#t+1] = LoadActor(THEME:GetPathB("ScreenSelectMusic","overlay/_ShockArrow/default.lua"),pn)..{
		InitCommand=function(s)
			s:xy(pn==PLAYER_1 and SCREEN_LEFT+80 or SCREEN_LEFT+263,SCREEN_BOTTOM-200):zoom(0.25)
		end,
		SetCommand=function(s)
			local song = GAMESTATE:GetCurrentSong()
			s:diffusealpha(1)
			if song then
				local steps = GAMESTATE:GetCurrentSteps(pn)
				if steps then
					if steps:GetRadarValues(pn):GetValue('RadarCategory_Mines') >= 1 then
						s:queuecommand("Anim")
					else
						s:queuecommand("Hide")
					end
				else
					s:queuecommand("Hide")
				end
			else
				s:diffusealpha(0)
			end
		end,
		CurrentSongChangedMessageCommand=function(s) s:stoptweening():queuecommand("Set") end,
		["CurrentSteps"..ToEnumShortString(pn).."ChangedMessageCommand"]=function(s) s:stoptweening():queuecommand("Set") end,
		OffCommand=function(s) s:queuecommand("Hide") end,	
	}
	t[#t+1] = Def.BitmapText{
		Font="_avenirnext lt pro bold/36px",
		Name="GimmickLabel"..ToEnumShortString(pn);
		InitCommand=function(s)
			s:diffusealpha(0);
			s:diffuse(Color.White)
			s:xy(#GAMESTATE:GetEnabledPlayers() < 2 and 460 or (pn==PLAYER_1 and SCREEN_LEFT+40 or SCREEN_LEFT+900),SCREEN_BOTTOM-290)
			s:halign(#GAMESTATE:GetEnabledPlayers() < 2 and 0.5 or (pn==PLAYER_1 and 0 or 1));
			s:zoom(0.75)
			s:strokecolor(color("0.2,0.9,1,0.5"))
			s:settext( "Shock Arrows" );
			s:maxwidth(#GAMESTATE:GetEnabledPlayers() < 2 and 1080 or 540);
			s:zoom(0);
		end,
		SetCommand=function(s)
			--if #GAMESTATE:GetEnabledPlayers() > 1 then s:diffusealpha(0) return end
			local gimmicks = ""
			local gimcount = 0
			local song = GAMESTATE:GetCurrentSong()
			local minepos = -1
			local handpos = -1
			local rollpos = -1
			local liftpos = -1
			local fakepos = -1
			if song then
				local steps = GAMESTATE:GetCurrentSteps(pn)
				if steps then
					if steps:GetRadarValues(pn):GetValue('RadarCategory_Mines') >= 1 then
						minepos = gimcount>0 and string.len(gimmicks)+2 or string.len(gimmicks)
						gimmicks = gimmicks..(gimcount>0 and ", " or "").."Shock Arrows"
						gimcount = gimcount+1
					end
					if steps:GetRadarValues(pn):GetValue('RadarCategory_Hands') >= 1 then
						handpos = gimcount>0 and string.len(gimmicks)+2 or string.len(gimmicks)
						gimmicks = gimmicks..(gimcount>0 and ", " or "").."Hands"
						gimcount = gimcount+1
						--s:AddAttribute(gimpos,{ Diffuse = Color.AutogenStep, Length = 5; });
					end
					if steps:GetRadarValues(pn):GetValue('RadarCategory_Rolls') >= 1 then
						rollpos = gimcount>0 and string.len(gimmicks)+2 or string.len(gimmicks)
						gimmicks = gimmicks..(gimcount>0 and ", " or "").."Roll Arrows"
						gimcount = gimcount+1
						--s:AddAttribute(gimpos,{ Diffuse = Color.AutogenStep, Length = 11; });
					end
					if steps:GetRadarValues(pn):GetValue('RadarCategory_Lifts') >= 1 then
						liftpos = gimcount>0 and string.len(gimmicks)+2 or string.len(gimmicks)
						gimmicks = gimmicks..(gimcount>0 and ", " or "").."Lifts"
						gimcount = gimcount+1
						--s:AddAttribute(gimpos,{ Diffuse = Color.AutogenStep, Length = 5; });
					end
					if steps:GetRadarValues(pn):GetValue('RadarCategory_Fakes') >= 1 then
						fakepos = gimcount>0 and string.len(gimmicks)+2 or string.len(gimmicks)
						gimmicks = gimmicks..(gimcount>0 and ", " or "").."Fake Arrows"
						gimcount = gimcount+1
						--s:AddAttribute(gimpos,{ Diffuse = Color.AutogenStep, Length = 11; });
					end
				end
			else
				s:diffusealpha(0)
			end
			--s:diffusealpha(0)
			--if(string.len(gimmicks)>0) then s:diffusealpha(1) s:z end
			if(string.len(gimmicks)>0) then
				s:settext(gimmicks)
				s:ClearAttributes()
				s:diffuse(Color.White)
				if minepos >= 0 then s:AddAttribute(minepos,{ Diffuse = color("0.0,1.0,1.0,1"), Length = 12; }); end
				if handpos >= 0 then s:AddAttribute(handpos,{ Diffuse = color("0.5,1.0,0.5,1"), Length = 5; }); end
				if rollpos >= 0 then s:AddAttribute(rollpos,{ Diffuse = color("0.8,0.0,1.0,1"), Length = 11; }); end
				if liftpos >= 0 then s:AddAttribute(liftpos,{ Diffuse = color("1.0,1.0,0.5,1"), Length = 5; }); end
				if fakepos >= 0 then s:AddAttribute(fakepos,{ Diffuse = color("1.0,0.25,0.25,1"), Length = 11; }); end
				s:diffusealpha(1)
				s:xy(#GAMESTATE:GetEnabledPlayers() < 2 and 472 or (pn==PLAYER_1 and SCREEN_LEFT+40 or SCREEN_LEFT+900),SCREEN_BOTTOM-290)
				s:zoom(0.85):addx(#GAMESTATE:GetEnabledPlayers() < 2 and 0 or (pn==PLAYER_1 and -20 or pn==PLAYER_2 and 20)):linear(0.5):zoom(0.75):addx(#GAMESTATE:GetEnabledPlayers() < 2 and 0 or (pn==PLAYER_1 and 20 or pn==PLAYER_2 and -20))
			else
				s:linear(0.1)
				s:diffusealpha(0)
			end
		end,
		OffCommand=function(s)
			s:linear(0.1)
			s:zoom(0)
			--s:diffusealpha(0)
		end,
		CurrentSongChangedMessageCommand=function(s) s:stoptweening():queuecommand("Set") end,
		["CurrentSteps"..ToEnumShortString(pn).."ChangedMessageCommand"]=function(s) s:stoptweening():queuecommand("Set") end,
	}
  t[#t+1] = Def.ActorFrame{
    loadfile(THEME:GetPathB("ScreenSelectMusic","overlay/WheelDeco/RadarHandler.lua"))(pn)..{
      InitCommand = function(s)
      s:xy(SCREEN_LEFT+172,SCREEN_BOTTOM-130)
      s:zoom(0.65)
	--local profile = PROFILEMAN:GetProfile(pn) or PROFILEMAN:GetMachineProfile()
	--if profile and PROFILEMAN:IsPersistentProfile(pn) then
	--	profile:SetLastUsedHighScoreName(profile:GetDisplayName())
	--	GAMESTATE:StoreRankingName(pn,profile:GetDisplayName())
	--end
      end,
    };
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
    loadfile(THEME:GetPathB("ScreenSelectMusic","overlay/WheelDeco/Pane.lua"))()..{
      InitCommand = function(s) s:xy(SCREEN_LEFT+480,SCREEN_BOTTOM-145) end,
	    OnCommand=function(s) s:addy(600):sleep(0.4):decelerate(0.3):addy(-600) end,
	    OffCommand=function(s) s:sleep(0.3):decelerate(0.3):addy(600) end,
      CurrentSongChangedMessageCommand=function(self)
        local song = GAMESTATE:GetCurrentSong()
  	    if song then
  	    	self:zoom(1);
  	    else
  	    	self:zoom(1);
  	    end;
  	  end;
    };
  };
end

return Def.ActorFrame{
  SongUnchosenMessageCommand=function(s) 
		s:sleep(0.2):queuecommand("Remove")
	end,
	RemoveCommand=function(s) s:RemoveChild("TwoPartDiff") end,
	SongChosenMessageCommand=function(self)
		self:AddChildFromPath(THEME:GetPathB("ScreenSelectMusic","overlay/TwoPartDiff"));
	end;
  loadfile(THEME:GetPathB("ScreenSelectMusic","overlay/WheelDeco/BannerHandler.lua"))();
  StandardDecorationFromFileOptional("StageDisplay","StageDisplay")..{
    InitCommand=function(s) s:xy(SCREEN_LEFT+340,_screen.cy-160):zoom(1) end,
  };
  DescPane;
  RecordPane;
  t;
  Def.Sprite{
    Texture=ex.."Header",
    InitCommand=function(s) s:align(0,0):xy(SCREEN_LEFT,SCREEN_TOP+16) end,
    OnCommand=function(s) s:addx(-1000):sleep(0.1):decelerate(0.3):addx(1000) end,
    OffCommand=function(s) s:sleep(0.3):decelerate(0.3):addx(-1000) end,
  };
  Def.ActorFrame{
    Name="HLFrame",
    InitCommand=function(s) s:xy(SCREEN_CENTER_X+436,_screen.cy+24):draworder(5):diffusealpha(0.9) end,
    OnCommand=function(s) s:addx(1100):sleep(0.5):decelerate(0.2):addx(-1100) end,
    OffCommand=function(s) s:sleep(0.3):decelerate(0.3):addx(1100) end,
    Def.Sprite{Texture=ex.."frame.png",};
    Def.Sprite{
      Texture=ex.."frame deco.png",
      InitCommand=function(s) s:diffuseshift():effectcolor1(Color.White):effectcolor2(Alpha(Color.White,0.75)):effectperiod(1) end,
    };
  };
  Def.ActorFrame{
    Name="DiffStuff",
    InitCommand=function(self) self:xy(IsUsingWideScreen() and SCREEN_LEFT+408 or SCREEN_LEFT+330,SCREEN_CENTER_Y+80) end,
    OnCommand=function(s) s:zoom(IsUsingWideScreen() and 1 or 0.8):addx(-800):sleep(0.3):decelerate(0.3):addx(800) end,
    OffCommand=function(s) s:sleep(0.3):decelerate(0.3):addx(-800) end,
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
      Texture="DiffBacker",
    };
    Def.Sprite{
      Texture=ex.."DiffFrame",
      InitCommand=function(self) self:x(4)
      end
    };
    --[[loadfile(THEME:GetPathB("ScreenSelectMusic","overlay/WheelDeco/DDRDifficultyList.lua"))()..{
      InitCommand=function(self) self:x(4) end,
    };]]
    loadfile(THEME:GetPathB("ScreenSelectMusic","overlay/WheelDeco/NewDiff.lua"))()..{
      InitCommand=function(self) self:x(4) end,
    };
  };
  Def.Sprite{
		Name="SongLength",
		Texture=THEME:GetPathG("","_shared/SongIcon 2x1"),
		InitCommand=function(s) s:animate(0):zoom(0.7):xy(SCREEN_LEFT+100,_screen.cy-104):zoomy(0) end,
		OnCommand=function(s) s:zoomy(0):sleep(0.3):bounceend(0.175):zoomy(0.7) end,
  		OffCommand=function(s) s:sleep(0.2):bouncebegin(0.175):zoomy(0) end,
		SetCommand=function(s,p)
			local song = GAMESTATE:GetCurrentSong()
			if song then
				if song:IsLong() then
					s:setstate(0)
					s:visible(true)
				elseif song:IsMarathon() then
					s:setstate(1)
					s:visible(true)
				else
					s:visible(false)
				end
			else
				s:visible(false)
			end
		end,
		CurrentSongChangedMessageCommand=function(s) s:queuecommand("Set") end,
  };
  Def.BitmapText{
    Font="_avenirnext lt pro bold/36px",
    Name="LengthLabel";
    InitCommand=function(s)
      s:diffusealpha(0);
      s:x(700);
      s:y(400);
      s:halign(0.5);
      s:zoom(0.75)
      s:strokecolor(Color.Black)
      s:settext( "" );
    end,
    OnCommand=function(s)
      s:sleep(0.5)
      s:decelerate(0.5)
      s:y(440);
      s:zoom(1)
      s:diffusealpha(1);
    end,
    OffCommand=function(s)
      s:decelerate(0.0)
      s:y(440);
      s:zoom(1)
      s:diffusealpha(1);
      s:decelerate(0.2)
      s:y(440);
      s:zoom(0.75)
      s:diffusealpha(0);
    end,
    CurrentSongChangedMessageCommand=function(s)
      local song = GAMESTATE:GetCurrentSong()
      if song then
        if false and song:MusicLengthSeconds() < 60 then
            resultxt, discardtxt = math.modf(song:MusicLengthSeconds());
            s:settext( resultxt.."s" );
        elseif song:MusicLengthSeconds() > 3600 then
          s:settext( SecondsToHHMMSS(song:MusicLengthSeconds()) );
        else
          s:settext( SecondsToMSS(song:MusicLengthSeconds()) );
        end
      else
        s:settext( "" );
      end
    end,
  };
  Def.BitmapText{
    Font="_avenirnext lt pro bold/36px",
    Name="GroupLabel";
    InitCommand=function(s)
      s:diffusealpha(0);
      s:x(548);
      s:y(400);
      s:halign(1.0);
      s:zoom(0.75)
      s:strokecolor(Color.Black)
      s:settext( "" );
      s:maxwidth(410);
    end,
    OnCommand=function(s)
      s:sleep(0.5)
      s:decelerate(0.5)
      s:y(440);
      s:zoom(1)
      s:diffusealpha(1);
    end,
    OffCommand=function(s)
      s:decelerate(0.0)
      s:y(440);
      s:zoom(1)
      s:diffusealpha(1);
      s:decelerate(0.2)
      s:y(440);
      s:zoom(0.75)
      s:diffusealpha(0);
    end,
    CurrentSongChangedMessageCommand=function(s)
      local song = GAMESTATE:GetCurrentSong()
      if song then
        group = song:GetGroupName()
        if group == "<Favorites>" then group = string.match(song:GetSongDir(), "/Songs/(.-)/") end
        s:settext( SongAttributes.GetGroupName(group) );
        s:diffuse( SongAttributes.GetGroupColor(group) );
      else
        s:settext( "" );
        s:diffuse(Color.White)
      end
    end,
  };
}