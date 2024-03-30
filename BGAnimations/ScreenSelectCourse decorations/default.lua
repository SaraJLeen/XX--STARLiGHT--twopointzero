local t = LoadFallbackB();

local function InputHandler(event)
	local player = event.PlayerNumber
	local MusicWheel = SCREENMAN:GetTopScreen("ScreenSelectMusic"):GetChild("MusicWheel");
	local overlay = SCREENMAN:GetTopScreen()
	if event.type == "InputEventType_Release" then return false end
	if event.DeviceInput.button == "DeviceButton_left mouse button" then
		MESSAGEMAN:Broadcast("MouseLeftClick")
	  end
end

t[#t+1] = Def.Actor{
	OnCommand=function(s)
		--SCREENMAN:GetTopScreen():SetPrevScreenName("ScreenSelectMusic")
		SCREENMAN:GetTopScreen():SetPrevScreenName("ScreenSelectPlayCourseMode")
		local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
		local SB = mw:GetChild("ScrollBar")
		if not SB then return end
		SB:visible(false)
		mw:zbuffer(true):diffusealpha(0):sleep(0.05):diffusealpha(1):sleep(0.05):diffusealpha(0):sleep(0.05):diffusealpha(1)
		:sleep(0.05):diffusealpha(0):sleep(0.05):diffusealpha(1)
		:SetDrawByZPosition(true)
		SCREENMAN:GetTopScreen():AddInputCallback(InputHandler)
	end,
	OffCommand=function(self)
		SCREENMAN:GetTopScreen():RemoveInputCallback(InputHandler)
		local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
			mw:bouncebegin(0.15):zoomx(3):diffusealpha(0)
	end,
	MouseLeftClickMessageCommand = function(self)
		if ThemePrefs.Get("Touch") == true then
		  self:queuecommand("PlayTopPressedActor")
		end
	end;
	PlayTopPressedActorCommand = function(self)
		playTopPressedActor()
		resetPressedActors()
	end;
	Def.Sprite{
		Texture="../_cursor",
	};
	CodeMessageCommand = function(self,params)
		if params.Name == "Back" then
			GAMESTATE:SetCurrentPlayMode("PlayMode_Regular")
			SCREENMAN:GetTopScreen():Cancel()
		end
	end
}

t[#t+1] = Def.Sprite{
	Texture=THEME:GetPathB("","ScreenSelectMusic underlay/A/ADeco"),
	InitCommand=function(s) s:halign(0):xy(SCREEN_LEFT,_screen.cy):blend(Blend.Add):diffusealpha(1) end,
	OnCommand=function(s) s:diffusealpha(0):linear(0.2):diffusealpha(0.75) end,
	OffCommand=function(s) s:linear(0.2):diffusealpha(0) end,
};


for i=1,2 do
	Name="Arrows";
	t[#t+1] = Def.ActorFrame{
		InitCommand=function(s) s:draworder(99):xy(i==1 and _screen.cx-200 or _screen.cx+500,_screen.cy):zoomx(i==1 and 1 or -1) end,
		OnCommand=function(s)
			s:diffusealpha(0):addx(i==1 and -100 or 100)
			:sleep(0.6):decelerate(0.3):addx(i==1 and 100 or -100):diffusealpha(1)
			s:bounce():effectclock("beat"):effectperiod(1):effectmagnitude(i==2 and 10 or -10,0,0):effectoffset(0.2)
		end,
		OffCommand=function(s) s:stoptweening():sleep(0.2):accelerate(0.2):addx(i==1 and -100 or 100):diffusealpha(0) end,
		StartSelectingStepsMessageCommand=function(s)
			s:accelerate(0.3):addx(i==1 and -100 or 100):diffusealpha(0)
		end,
		NextSongMessageCommand=function(s)
			if i==2 then s:stoptweening():x(_screen.cx+520):decelerate(0.5):x(_screen.cx+500) end
		end, 
		PreviousSongMessageCommand=function(s)
			if i==1 then s:stoptweening():x(_screen.cx-220):decelerate(0.5):x(_screen.cx-200) end
		end, 
		Def.Sprite{ Texture=THEME:GetPathG("","_shared/arrows/base");};
		Def.Sprite{
			Texture=THEME:GetPathG("","_shared/arrows/color");
			InitCommand=function(s) s:diffuse(color("#00f0ff")) end,
			NextSongMessageCommand=function(s)
				if i==2 then
					s:stoptweening():diffuse(color("#ff00ea")):sleep(0.5):diffuse(color("#00f0ff"))
				end
			end, 
			PreviousSongMessageCommand=function(s)
				if i==1 then
					s:stoptweening():diffuse(color("#ff00ea")):sleep(0.5):diffuse(color("#00f0ff"))
				end
			end, 
		};
	};
end;

t[#t+1] = Def.ActorFrame{
	OnCommand=function(s)
		s:diffusealpha(0):linear(0.05):diffusealpha(0.75)
		:linear(0.1):diffusealpha(0.25):linear(0.1):diffusealpha(1)
	end,
	OffCommand=function(s)
		s:diffusealpha(1):sleep(0.05):diffusealpha(0):sleep(0.05):diffusealpha(0.5)
		:sleep(0.05):diffusealpha(0):sleep(0.05):diffusealpha(0.25):sleep(0.05)
		:linear(0.05):diffusealpha(0)
	end,
	InitCommand=function(s) s:xy(_screen.cx-250,_screen.cy-400):diffusealpha(0):draworder(99) end,
	Def.Sprite{Texture="course title.png"},
	Def.BitmapText{
		Font="_avenirnext lt pro bold/36px";
		InitCommand = function(s) s:halign(0):xy(-350,-26):maxwidth(600):diffuse(Color.Black):uppercase(true) end,
		SetCommand = function(self)
			local course = GAMESTATE:GetCurrentCourse()
			self:settext(course and course:GetDisplayFullTitle() or "")
		end,
		CurrentCourseChangedMessageCommand = function(s) s:queuecommand("Set") end,
		ChangedLanguageDisplayMessageCommand = function(s) s:queuecommand("Set") end,
	};
	Def.BitmapText{
		Font="_avenirnext lt pro bold/36px";
		InitCommand = function(s) s:halign(0):xy(-350,8):maxwidth(600):diffuse(Color.White):uppercase(false) end,
		SetCommand = function(self)
			local course = GAMESTATE:GetCurrentCourse()
			self:settext(course and course:GetDescription() or "")
		end,
		CurrentCourseChangedMessageCommand = function(s) s:queuecommand("Set") end,
		ChangedLanguageDisplayMessageCommand = function(s) s:queuecommand("Set") end,
	};
	Def.BitmapText{
		Font="_avenirnext lt pro bold/25px";
		InitCommand = function(s) s:xy(320,54):maxwidth(120):zoom(0.65):align(0.5,0) end,
		SetCommand = function(self)
			local curTrail = GAMESTATE:GetCurrentTrail(GAMESTATE:GetMasterPlayerNumber())
			if curTrail then
				if curTrail:IsSecret() then
					self:settext("???")
				else
					local bpmlow = {}
					local bpmhigh = {}
					for i=1,#curTrail:GetTrailEntries() do
						local ce = curTrail:GetTrailEntry(i-1):GetSong():GetDisplayBpms()
						table.insert(bpmlow,ce[1])
						table.insert(bpmhigh,ce[#ce])
					end
					self:settextf("%03d - %03d",math.floor(math.min(unpack(bpmlow))+0.5),math.floor(math.max(unpack(bpmhigh)))+0.5)
				end
			end
		end,
		CurrentCourseChangedMessageCommand = function(s) s:queuecommand("Set") end,
		ChangedLanguageDisplayMessageCommand = function(s) s:queuecommand("Set") end,
	};
	Def.Sprite{
		Texture="course title.png",
		InitCommand=function(s) s:MaskSource(true) end,
    };
	Def.Sprite{
		Texture=THEME:GetPathB("","ScreenSelectMusic overlay/ADeco/grad.png"),
		InitCommand=function(s) s:setsize(102,144):diffusealpha(0.5):blend(Blend.Add):MaskDest():ztestmode("ZTestMode_WriteOnFail") end,
		OnCommand=function(s) s:queuecommand("Anim") end,
		AnimCommand=function(s) s:x(-480):sleep(4):smooth(1.5):x(480):queuecommand("Anim") end,
		OffCommand=function(s) s:stoptweening() end,
	};
	Def.BitmapText{
		Font="_avenirnext lt pro bold/36px";
		InitCommand = function(s) s:halign(0.5):xy(-30,55):maxwidth(550):diffuse(Color.White):uppercase(false) end,
		SetCommand = function(self)
			local course = GAMESTATE:GetCurrentCourse()
			if course == nil or course:GetGroupName() == nil then self:settext("") return true end
			local gname = course:GetGroupName()
			local gcolor = Color.White
			if gname == "03 - DDR 3rdMIX Korea" then
				gname = SongAttributes_GetGroupName("03 - DDR 3rdMIX");
				gcolor = color("0.50,0.63,0.69,1")
			elseif gname == "03 - DDR 3rdMIX Korea v2" then
				gname = SongAttributes_GetGroupName("03 - DDR 3rdMIX");
				gcolor = color("0.44,0.53,0.63,1")
			elseif gname == "03 - DDR 3rdMIX PLUS" then
				gname = SongAttributes_GetGroupName("03 - DDR 3rdMIX");
				gcolor = color("0.43,0.68,0.13,1")
			elseif gname == "04 - DDR 4thMIX PLUS" then
				gname = SongAttributes_GetGroupName("04 - DDR 4thMIX");
				gcolor = color("0.90,0.00,0.90,1")
			elseif gname == "09 - DDR SuperNOVA CS" then
				gname = SongAttributes_GetGroupName("09 - DDR SuperNOVA CS");
				gcolor = color("0.87,0.71,0.60,1.0")
			elseif gname == "DDR Party Collection" then
				--gname = SongAttributes_GetGroupName("DDR PS2");
				gcolor = color("0.80,0.24,0.05,1.0")
			elseif gname == "Default" then
				gname = SongAttributes_GetGroupName("Project OutFox");
				gcolor = color("#8FBCFF")
			else
				gname = SongAttributes_GetGroupName(course:GetGroupName());
				gcolor = SongAttributes_GetGroupColor(course:GetGroupName());
			end
			self:settext( gname );
			self:diffuse( gcolor );
			self:strokecolor( ColorDarkTone(gcolor) );
			self:shadowcolor( Color.Black );
			self:shadowlength(3);
			--self:settext(gname)
		end,
		CurrentCourseChangedMessageCommand = function(s) s:queuecommand("Set") end,
		ChangedLanguageDisplayMessageCommand = function(s) s:queuecommand("Set") end,
	};
};

t[#t+1] = Def.ActorFrame{
	InitCommand=function(s) s:xy(SCREEN_LEFT+218,_screen.cy+240):zoom(0.75) end,
	OnCommand=function(s) s:addx(-SCREEN_WIDTH):sleep(0.2):decelerate(0.2):addx(SCREEN_WIDTH) end,
	OffCommand=function(s) s:linear(0.2):addx(-SCREEN_WIDTH) end,
	Def.Sprite{
		Texture=THEME:GetPathB("","ScreenSelectMode decorations/windowmid"),
		OnCommand=function(self)
			self:accelerate(0.1):croptop(0.5):cropbottom(0.5):sleep(0.1):accelerate(0.2):croptop(0):cropbottom(0)
		end;
	};
	Def.ActorFrame{
		OnCommand=function(self)
			self:accelerate(0.1):y(0):sleep(0.1):accelerate(0.2):y(-172)
		end;
		Def.Sprite{
			Texture=THEME:GetPathB("","ScreenSelectMode decorations/windowtop"),
			InitCommand=function(s) s:valign(1) end,
		};
		Def.Sprite{
			Texture="SONG LIST.png",
			InitCommand=function(s) s:zoom(1.35):y(-20) end,
		};
	};
	Def.Sprite{
		Texture=THEME:GetPathB("","ScreenSelectMode decorations/windowbottom"),
		InitCommand=function(s) s:y(172):valign(0); end,
		OnCommand=function(self)
			self:accelerate(0.1)
			:y(0)
			:sleep(0.1)
			:accelerate(0.2)
			:y(172)
		end;
	};
	StandardDecorationFromFileOptional("CourseContentsList","CourseContentsList")..{
		InitCommand=function(s) s:zoom(1.25):xy(0,0) end,
	},
	Def.BitmapText{
		Font="_avenirnext lt pro bold/25px";
		InitCommand = function(s) s:halign(0.5):xy(10,190):maxwidth(450):diffuse(Color.White):uppercase(false) end,
		SetCommand = function(self)
			self:diffuse(Color.White)
			self:strokecolor(ColorDarkTone(Color.White))
			local course = GAMESTATE:GetCurrentCourse()
			if course == nil then self:settext("") return end
			local worktext = ""
			if course:IsEndless() then
				worktext = worktext.."Endless"
			elseif course:GetCourseType() == 'CourseType_Survival' then
				worktext = worktext.."Survival"
			elseif course:IsOni() then
				if (not course:AllSongsAreFixed()) or course:IsAutogen() then worktext = worktext.."Generated, " end
				worktext = worktext.."4 lives, "
				worktext = worktext..tostring(course:GetNumCourseEntries())
				worktext = worktext.." songs"
			elseif course:IsNonstop() then
				if (not course:AllSongsAreFixed()) or course:IsAutogen() then worktext = worktext.."Generated, " end
				worktext = worktext.."Nonstop, "
				worktext = worktext..tostring(course:GetNumCourseEntries())
				worktext = worktext.." songs"
			else
				if (not course:AllSongsAreFixed()) or course:IsAutogen() then worktext = worktext.."Generated, " end
				worktext = worktext..tostring(course:GetNumCourseEntries())
				worktext = worktext.." songs"
			end
			if course:IsRanking() then worktext = worktext..", Ranking" end
			local pn = GAMESTATE:GetMasterPlayerNumber()
			local ctrail = GAMESTATE:GetCurrentTrail(pn)
			local csecs = SecondsToMSS(TrailUtil.GetTotalSeconds(ctrail))
			if ctrail ~= nil then
				local csecs = SecondsToMSS(TrailUtil.GetTotalSeconds(ctrail))
				if csecs ~= nil then
					worktext = worktext..", "..csecs
				end
			end
			self:settext(worktext)
		end,
		CurrentCourseChangedMessageCommand = function(s) s:queuecommand("Set") end,
		CurrentTrailP1ChangedMessageCommand = function(s) s:queuecommand("Set") end,
		CurrentTrailP2ChangedMessageCommand = function(s) s:queuecommand("Set") end,
		ChangedLanguageDisplayMessageCommand = function(s) s:queuecommand("Set") end,
	};
};

t[#t+1] = Def.ActorFrame{
	InitCommand=function(s) s:xy(SCREEN_LEFT,_screen.cy-320) end,
	OnCommand=function(s) s:stoptweening():addx(-400):decelerate(0.2):addx(400) end,
		OffCommand=function(s) s:decelerate(0.2):addx(-400) end,
	Def.Sprite{
		Texture="headerbox.png",
		InitCommand=function(s) s:halign(0) end,
	};
	Def.Sprite{
		Texture="headertext.png",
		InitCommand=function(s) s:x(190)
			:diffuseshift():effectcolor1(Alpha(Color.White,1)):effectcolor2(Alpha(Color.White,0.5)):effectperiod(2)
		end,
	};
}

t[#t+1] = loadfile(THEME:GetPathB("ScreenSelectMusic","overlay/_OptionsList/default.lua"))()..{
	InitCommand=function(s) s:draworder(100) end,
}

for pn in EnabledPlayers() do
	t[#t+1] = loadfile(THEME:GetPathB("ScreenSelectCourse","decorations/_Difficulty"))(pn)..{
		InitCommand=function(s) s:diffusealpha(0):draworder(40)
			:xy((pn==PLAYER_1 or #GAMESTATE:GetEnabledPlayers()<2) and SCREEN_LEFT+200 or SCREEN_RIGHT-200,_screen.cy-230)
		end,
		OnCommand=function(s) s:diffusealpha(0):linear(0.2):diffusealpha(1) end,
		OffCommand=function(s) s:linear(0.2):diffusealpha(0) end,
	};
--end

	local rivals = {1,2,3,4,5}
	local yspacing = 30
	for rival in ivalues(rivals) do
		local test_it = false
		t[#t+1] = Def.ActorFrame{
			InitCommand=function(s)
				s:visible(true)
				playercount = 0
				s:x(600)
				s:y(700+(rivals[rival]*yspacing)-yspacing)
				s:diffusealpha(1)
				--Trace("Enabled player count is "..#GAMESTATE:GetEnabledPlayers()..".")
				if(#GAMESTATE:GetEnabledPlayers() > 1) then
					if (pn == PLAYER_1) then s:x(600) end
					if (pn == PLAYER_2) then s:x(1700) end
				end;
			end,
			OnCommand=function(s) s:zoom(0):sleep(0.3):decelerate(0.4):zoom(1):rotationz(0) end,
			OffCommand=function(s) s:sleep(0.3):decelerate(0.3):zoom(0) end,
			SetCommand=function(s)
			--Trace("Setting rival window")
			local c = s:GetChildren();

			local topgrade;
			local song = GAMESTATE:GetCurrentCourse()
			if song then
				s:visible(true)
				if(#GAMESTATE:GetEnabledPlayers() > 1 and rival>3) then s:visible(false) end
				local steps = GAMESTATE:GetCurrentTrail(pn)
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
				s:visible(false)
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
									c.Text_name:diffuse( PlayerColor(pns) )
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
		CurrentTrailP1ChangedMessageCommand=function(s) s:queuecommand("Set") end,
		CurrentTrailP2ChangedMessageCommand=function(s) s:queuecommand("Set") end,
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
			Text="Course Ranking";
			InitCommand=function(s)
				if(rival == 1) then
					s:diffusealpha(1.0)
				else
					s:diffusealpha(0)
				end
				s:x(0)
				s:y(-33)
				s:visible(true)
				if(#GAMESTATE:GetEnabledPlayers() > 1) then
					s:visible(false)
					--s:x(-240);
					--s:y(0);
					--if(pn == PLAYER_1) then
					--	s:settext("Top Scores 1P");
					--end
				end;
				--s:strokecolor(Alpha(Color.Black,0.5))
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
end


return t;
