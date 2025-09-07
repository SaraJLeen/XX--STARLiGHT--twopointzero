SOUND:DimMusic(1,math.huge)
local num_players = GAMESTATE:GetHumanPlayers()
LoadFromProfilePrefs()

function setting(self,screen,pn)
	local index = screen:GetCurrentRowIndex(pn);
	local row = screen:GetOptionRow(index);
	local name = row:GetName();
	local choice = row:GetChoiceInRowWithFocus(pn);
	if name ~= "Exit" then
		--Trace("Setting option "..name..".")
		if name == "Steps" then
			self:settext("Change selected difficulty.");
			local ssteps = GAMESTATE:GetCurrentSteps(pn);
			local sname = ssteps:GetChartName();
			local sauth = ssteps:GetAuthorCredit();
			local sdesc = ssteps:GetDescription();
			local newtext = ""
			if sname and sname ~= "" then
				if newtext ~= "" then newtext = newtext.."\n" end
				newtext = newtext..sname
			end
			if sdesc and sdesc ~= "" then
				if newtext ~= "" then newtext = newtext.."\n" end
				newtext = newtext..sdesc
			end
			if sauth and sauth ~= "" then
				if newtext ~= "" then newtext = newtext.."\n" end
				if newtext == "" then
					newtext = newtext.."Chart by\n"..sauth
				else
					newtext = newtext.."by "..sauth
				end
			end
			if newtext ~= "" then self:settext(newtext) end			
		elseif THEME:GetMetric( "ScreenOptionsMaster",name.."Explanation" ) ~= false or name == "LuaNoteSkins" or name == "Characters" or name == "DanceStage" then
			--Trace("Setting "..name..tostring(choice)..".");
			if name == "Speed" then
				local choice2 = choice - #num_players;
				if choice2 < 0 then
					self:settext(THEME:GetString("OptionItemExplanations",name));
				else
					self:settext(THEME:GetString("OptionItemExplanations",name..tostring(choice2)));
				end
			elseif name == "LuaNoteSkins" or name == "Characters" or name == "DanceStage" then
				self:settext(THEME:GetString("OptionItemExplanations",name));
			else
				self:settext(THEME:GetString("OptionItemExplanations",name..tostring(choice)));
			end
		else
			self:settext("");
		end;
	else
		 self:settext("Proceed to the next screen.");
	end
end;

local song_bpms= {}
local bpm_text= ""
local function format_bpm(bpm)
	return ("%.0f"):format(bpm)
end

local t = Def.ActorFrame{
	Def.Quad{
		Condition=Var"LoadingScreen" == "ScreenPlayerOptionsPopup",
		InitCommand=function(s) s:FullScreen():diffuse(Alpha(Color.Black,0)):draworder(-11) end,
		OnCommand=function(s) s:smooth(0.3):diffusealpha(0.5) end,
		OffCommand=function(s) 
			s:smooth(0.3):diffusealpha(0)
		end,
	},
}

for _,pn in ipairs(GAMESTATE:GetHumanPlayers()) do
	-- Notefield Preview Area
	-- TODO: Until I can deal with regenerating the preview, this has to be disabled.
	if GAMESTATE:GetCurrentSteps(pn) then
	t[#t+1] = Def.ActorFrame {
		InitCommand=function(self)
			local nf = self:GetChild("NoteField")
			if GAMESTATE:GetNumSidesJoined() > 1 then return end
			nf:halign(0.5)
			nf:valign(0.5)
			nf:x( pn == PLAYER_1 and SCREEN_WIDTH * .5 or -SCREEN_WIDTH * .5 )
			nf:xy(pn == PLAYER_2 and _screen.cx-800 or _screen.cx+800,-800)
			nf:draworder(-100)
			nf:zoom(2.0)
			if GAMESTATE:GetCurrentStyle():GetStyleType() == "StyleType_OnePlayerTwoSides" then
				nf:xy(pn == PLAYER_2 and _screen.cx-680 or _screen.cx+680,0)
			end
			SOUND:PlayMusicPart(GAMESTATE:GetCurrentSong():GetMusicPath(),GAMESTATE:GetCurrentSong():GetSampleStart(),-1,0,0,true,true,false,GAMESTATE:GetCurrentSong():GetTimingData())
			MESSAGEMAN:Broadcast("UpdateNotefield",{ pn = pn, Steps = GAMESTATE:GetCurrentSteps(pn), Style = GAMESTATE:GetCurrentStyle() })
		end,
		OnCommand=function(self)
			self:GetChild("NoteField"):playcommand("CalculatePosition")
		end,
		OffCommand=function(self)
			self:accelerate(0.2)
			self:diffusealpha(0)
		end,
		SetCommand=function(self)
			MESSAGEMAN:Broadcast("UpdateNotefield",{ pn = pn, Steps = GAMESTATE:GetCurrentSteps(pn), Style = GAMESTATE:GetCurrentStyle() })
			self:GetChild("NoteField"):playcommand("PlayerOptionChangeMessage");
		end,
		SetStepsCommand=function(self)
			local chartint = -1
			for k,v in ipairs( GAMESTATE:GetCurrentSong():GetAllSteps() ) do
				if v == GAMESTATE:GetCurrentSteps(pn) then chartint = k break end
			end
			MESSAGEMAN:Broadcast("PlayerSwitchedStep",{ Player = pn, Index = chartint, Song = GAMESTATE:GetCurrentSong() })
			--MESSAGEMAN:Broadcast("UpdateOnlineChartInfo",{ Player = pn, Steps = GAMESTATE:GetCurrentSteps(pn), Toggle = 0 })
			self:GetChild("NoteField"):playcommand("PlayerOptionChangeMessage");
		end,
	    	MenuLeftP1MessageCommand=function(s) if pn == PLAYER_1 then	s:queuecommand("Set") end end,
		MenuRightP1MessageCommand=function(s) if pn == PLAYER_1 then s:queuecommand("Set") end end,
	    	MenuUpP1MessageCommand=function(s) if pn == PLAYER_1 then	s:queuecommand("Set") end end,
		MenuDownP1MessageCommand=function(s) if pn == PLAYER_1 then s:queuecommand("Set") end end,
		MenuStartP1MessageCommand=function(s) if pn == PLAYER_1 then s:queuecommand("Set") end end,
		MenuLeftP2MessageCommand=function(s) if pn == PLAYER_2 then s:queuecommand("Set") end end,
		MenuRightP2MessageCommand=function(s) if pn == PLAYER_2 then s:queuecommand("Set") end end,
		MenuUpP2MessageCommand=function(s) if pn == PLAYER_2 then s:queuecommand("Set") end end,
		MenuDownP2MessageCommand=function(s) if pn == PLAYER_2 then s:queuecommand("Set") end end,
		MenuStartP2MessageCommand=function(s) if pn == PLAYER_2 then s:queuecommand("Set") end end,
	    	ChangeRowMessageCommand=function(s,param) s:queuecommand("Set") end,
		SpeedChoiceChangedMessageCommand=function(s,param) s:queuecommand("Set") end,
		ChangeCommand=function(s,param) s:queuecommand("Set") end,
		CurrentStepsP1ChangedMessageCommand=function(s) s:playcommand("SetSteps") end,
		CurrentStepsP2ChangedMessageCommand=function(s) s:playcommand("SetSteps") end,
		LoadModule("OptionsNotefield.lua"){
			Player = pn,
			Width = 650,
			Height = 550,
			isOnline = false,
		}..{ Name="NoteField" },
	}
	end
end

local bars = Def.ActorFrame{}

for i=1,7 do
	bars[#bars+1] = Def.Quad{
		InitCommand=function(s) s:y(80*i):diffuse(Alpha(Color.White,0.2)):setsize(1276,34) end,
	};
end

t[#t+1] = Def.ActorFrame{
	OnCommand=function(s) s:draworder(-10):addy(SCREEN_HEIGHT):sleep(0.2):decelerate(0.2):addy(-SCREEN_HEIGHT) end,
	OffCommand=function(s) 
		ProfilePrefs.SaveAll()
		s:accelerate(0.2):addy(-SCREEN_HEIGHT)
	end,
	Def.ActorFrame{
		InitCommand=function(s) s:xy(_screen.cx,SCREEN_CENTER_Y-90) end,
		Def.ActorFrame{
			InitCommand=function(s) s:diffusealpha(0.5) end,
			Def.Quad{
				InitCommand=function(s) s:setsize(1280,596):diffuse(Alpha(Color.White,0.25)) end,
			},
			Def.Quad{
				InitCommand=function(s) s:setsize(1276,592):diffuse(Color.Black) end,
			},
			Def.Quad{
				InitCommand=function(s) s:setsize(1276,592):diffuse(Color.Black) end,
			},
		},
		Def.Sprite{
			Texture=THEME:GetPathB("ScreenOptionsService","decorations/DialogTop"),
			InitCommand=function(s) s:y(-320) end,
		};
		bars..{
			InitCommand=function(s) s:y(-342) end,
		}
	};
};

for _,pn in ipairs(GAMESTATE:GetHumanPlayers()) do
	local function p(text)
		return text:gsub("%%", ToEnumShortString(pn));
	end
	t[#t+1] = Def.ActorFrame{
		InitCommand=function(s) s:xy(pn == PLAYER_1 and _screen.cx-320 or _screen.cx+320,GAMESTATE:GetCurrentSteps(pn) and SCREEN_BOTTOM-100 or SCREEN_BOTTOM-250) end,
		OnCommand=function(s) s:diffusealpha(1):sleep(0.05):diffusealpha(0):sleep(0.05):diffusealpha(1):sleep(0.05):diffusealpha(0):sleep(0.05):diffusealpha(1):sleep(0.05):diffusealpha(0):sleep(0.05):linear(0.05):diffusealpha(1) end,
		OffCommand=function(s) s:diffusealpha(1):sleep(0.05):diffusealpha(0):sleep(0.05):diffusealpha(1):sleep(0.05):diffusealpha(0):sleep(0.05):diffusealpha(1):sleep(0.05):diffusealpha(0):sleep(0.05) 	ProfilePrefs.SaveAll() end,
		Def.Sprite{
			Texture="exp.png",
		};
		Def.BitmapText{
			Font="_avenirnext lt pro bold/25px",
	    	InitCommand=function(s) s:y(-6):maxwidth(400):zoom(1.3) end,
			BeginCommand=function(s) s:queuecommand("Set") end,
	    	SetCommand=function(self)
	      		local screen = SCREENMAN:GetTopScreen();
	      		if screen then
	        		setting(self,screen,pn);
	      		end;
	    	end;
	    	[p"MenuLeft%MessageCommand"]=function(s) s:playcommand("Set") end,
			[p"MenuRight%MessageCommand"]=function(s) s:playcommand("Set") end,
	    	ChangeRowMessageCommand=function(s,param)
        	    if param.PlayerNumber == pn then s:playcommand "Set"; end;
        	end;
	  	};
	};
	t[#t+1] = Def.BitmapText{
		File="_avenirnext lt pro bold/25px",
		Name="Speed Mod";
		InitCommand=function(s) s:xy(pn == PLAYER_1 and _screen.cx-630 or _screen.cx+630,_screen.cy-400):draworder(-9)
			:uppercase(true):halign(pn == PLAYER_1 and 0 or 1):strokecolor(color("0,0,0,0.25")):diffusealpha(0)
		end,
		OnCommand=function(s) s:sleep(0.4):decelerate(0.2):diffusealpha(1) end,
		OffCommand=function(s) s:accelerate(0.2):diffusealpha(0) end,
		ArbitrarySpeedModsSavedMessageCommand=function(s,p)
			if p.Player == pn then
				s:playcommand("Adjust")
			end
		end,
		AdjustCommand=function(self)
			local poptions= GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred")
			local speed= nil
			local mode= nil
			if poptions:MaxScrollBPM() > 0 then
				mode= "M"
				speed= math.round(poptions:MaxScrollBPM())
			elseif poptions:TimeSpacing() > 0 then
				mode= "C"
				speed= math.round(poptions:ScrollBPM())
			elseif poptions:AverageScrollBPM() > 0 then
				mode= "A"
				speed= math.round(poptions:AverageScrollBPM())
			elseif poptions:XMod() > 0 then
				mode= "x"
				speed= math.round(poptions:ScrollSpeed() * 100)
			else
				mode= "what"
				speed= 69
			end
			-- Courses don't have GetDisplayBpms.
			if GAMESTATE:GetCurrentSong() then
				song_bpms= GAMESTATE:GetCurrentSong():GetDisplayBpms()
				song_bpms[1]= math.round(song_bpms[1])
				song_bpms[2]= math.round(song_bpms[2])
				if song_bpms[1] == song_bpms[2] then
					bpm_text= format_bpm(song_bpms[1])
				else
					bpm_text= format_bpm(song_bpms[1]) .. " - " .. format_bpm(song_bpms[2])
				end
			end
			local text= ""
			local no_change= true
			if mode == "x" then
				if not song_bpms[1] then
					text= ""
				elseif song_bpms[1] == song_bpms[2] then
					text= "x"..(speed/100).." ("..format_bpm(song_bpms[1] * speed*.01)..")"
				else
					text= "x"..(speed/100).." ("..format_bpm(song_bpms[1] * speed*.01) .. " - " ..
						format_bpm(song_bpms[2] * speed*.01)..")"
				end
				no_change= speed == 100
			elseif mode == "C" then
				text= mode .. speed
				no_change= speed == song_bpms[2] and song_bpms[1] == song_bpms[2]
			elseif mode == "M" then
				no_change= speed == song_bpms[2]
				if song_bpms[1] == song_bpms[2] then
					text= mode .. speed
				else
					local factor= song_bpms[1] / song_bpms[2]
					text= format_bpm(speed * factor) .. " - " .. speed
				end
			elseif mode == "A" then 
				no_change= speed == song_bpms[2]
				if song_bpms[1] == song_bpms[2] then
					text= mode .. speed
				else
					local factor= math.average({song_bpms[1], song_bpms[2]})
					text= speed .. " - " .. format_bpm(factor)
				end
			else
				text = "??? What speed mod are you using? Like. Actually."
			end
			if GAMESTATE:IsCourseMode() then
				if mode == "x" then
					text = "x"..(speed/100)
				else
					text = mode .. speed
				end
				self:settext("Current Velocity: "..text)
			else
				self:settext("Current Velocity: "..text):zoom(1)
			end
		end;
	}
end

local bpm_text= ""
local function format_bpm(bpm)
	return ("%.0f"):format(bpm)
end

for _,pn in ipairs(GAMESTATE:GetHumanPlayers()) do

	t[#t+1] = Def.ActorFrame{
		Def.Sprite {
			Name="100 char",
  			InitCommand=function(self)
				self:diffusealpha(0)
				self:playcommand("Set")
				if pn == PLAYER_1 then
					self:addx(-500)
				else
					self:addx(500)
				end
  			end,
			OnCommand=function(s)
				s:sleep(0.2)
				s:decelerate(0.2)
				s:diffusealpha(1)
				s:xy(pn == PLAYER_1 and _screen.cx-800 or _screen.cx+800,SCREEN_TOP+896)
			end,
			OffCommand=function(s)
				s:accelerate(0.2)
				s:diffusealpha(0)
				if pn == PLAYER_1 then
					s:addx(-500)
				else
					s:addx(500)
				end
			end,
  			SetCommand=function(self)
				if ThemePrefs.Get("GameplayBackground")=='DanceStages' then
					local profileID = GetProfileIDForPlayer(pn)
					local pPrefs = ProfilePrefs.Read(profileID)
					local stageName = pPrefs.dancestage
					local name = stageName
					-- Trace("Charname: "..charName..". Name: "..name)
					-- Trace("Name: "..name)
					if (name) and (name ~= "") and (string.lower(name) ~= "default") and (string.lower(name) ~= "random") then
						if FILEMAN:DoesFileExist(DanceStagesFolder..name.."/card.png") then
							self:Load(DanceStagesFolder..name.."/card.png")
			    	 			self:scaletofit(0,0,268,640)
							self:xy(pn == PLAYER_1 and _screen.cx-800 or _screen.cx+800,SCREEN_TOP+896)
				    			self:finishtweening();
						else
							-- Trace("It doesn't exist...")
							self:visible(false);
						end
						self:visible(true);
					else
						self:visible(false);
					end
				else
					self:visible(false);
				end
  			end,
	    	MenuLeftP1MessageCommand=function(s) 
				if pn == PLAYER_1 then
					s:playcommand("Set")
				end
			end,
			MenuRightP1MessageCommand=function(s) 
				if pn == PLAYER_1 then
					s:playcommand("Set")
				end
			end,
			MenuLeftP2MessageCommand=function(s) 
				if pn == PLAYER_2 then
					s:playcommand("Set")
				end
			end,
			MenuRightP2MessageCommand=function(s) 
				if pn == PLAYER_2 then
					s:playcommand("Set")
				end
			end,
	    	ChangeRowMessageCommand=function(s,param)
        	    if param.PlayerNumber == pn then s:playcommand "Set"; end;
        	end;
		};
	};
	t[#t+1] = Def.ActorFrame{
		Def.Sprite {
			Name="100 char",
  			InitCommand=function(self)
				self:diffusealpha(0)
				self:playcommand("Set")
				if pn == PLAYER_1 then
					self:addx(-500)
				else
					self:addx(500)
				end
  			end,
			OnCommand=function(s)
				s:sleep(0.2)
				s:decelerate(0.2)
				s:diffusealpha(1)
				s:xy(pn == PLAYER_1 and _screen.cx-800 or _screen.cx+800,SCREEN_TOP+424)
			end,
			OffCommand=function(s)
				s:accelerate(0.2)
				s:diffusealpha(0)
				if pn == PLAYER_1 then
					s:addx(-500)
				else
					s:addx(500)
				end
			end,
  			SetCommand=function(self)
				if ThemePrefs.Get("GameplayBackground")=='DanceStages' then
					local charName = ResolveCharacterNameEn(pn)
					local name = GAMESTATE:GetCharacter(pn):GetCharacterID() or ""
					-- Trace("Charname: "..charName..". Name: "..name)
					-- Trace("Name: "..name)
					if (name) and (name ~= "") and (string.lower(name) ~= "default") and (string.lower(name) ~= "random") then
			    			--this forces StepMania to have these all in memory so gameplay doesn't freeze up
						if FILEMAN:DoesFileExist("/Characters/"..name.."/Cut-In") then
							-- Trace("Cut-in folder exists")
							if FILEMAN:DoesFileExist("/Characters/"..name.."/Cut-In/comboA.png") then
								self:Load("/Characters/"..name.."/Cut-In/comboA.png")
								-- Trace("Found A")
							elseif FILEMAN:DoesFileExist("/Characters/"..name.."/Cut-In/comboB.png") then
								self:Load("/Characters/"..name.."/Cut-In/comboB.png")
								-- Trace("Found B")
							elseif FILEMAN:DoesFileExist("/Characters/"..name.."/Cut-In/combo100.png") then
								self:Load("/Characters/"..name.."/Cut-In/combo100.png")
								-- Trace("Found 100")
							else
								--self:Load("/Characters/"..name.."/Cut-In/comboB.png")
								-- Trace("Found...?")
							end
						else
							-- Trace("It doesn't exist...")
							self:Load("/Characters/"..name.."/card.png")
						end
		    	 			self:scaletofit(0,0,268,640)
						self:xy(pn == PLAYER_1 and _screen.cx-800 or _screen.cx+800,SCREEN_TOP+424)
			    			self:finishtweening();
						self:visible(true);
					else
						self:visible(false);
					end
				elseif ThemePrefs.Get("GameplayBackground")=='SNCharacters' then
					local charName = ResolveCharacterNameSN(pn)
					local name = (GAMESTATE:Env())['SNCharacter'..ToEnumShortString(pn)] or ""
					--Trace("Charname: "..charName..". Name: "..name)
					if (charName) and (charName ~= "") and (string.lower(name) ~= "random") then
					  	local charVer = (Characters.GetConfig(charName)).version
			    			--this forces StepMania to have these all in memory so gameplay doesn't freeze up
						if FILEMAN:DoesFileExist(Characters.GetAssetPath(charName, "comboA.png")) then
							self:Load(Characters.GetAssetPath(charName, "comboA.png"))
						elseif FILEMAN:DoesFileExist(Characters.GetAssetPath(charName, "comboB.png")) then
							self:Load(Characters.GetAssetPath(charName, "comboB.png"))
						elseif FILEMAN:DoesFileExist(Characters.GetAssetPath(charName, "combo100.png")) then
							self:Load(Characters.GetAssetPath(charName, "combo100.png"))
						else
							--self:Load(Characters.GetAssetPath(charName, "comboB.png"))
						end
						if charVer <= 2 then
			      			self:setsize(268,640)
			    			else
			    	 			self:scaletoclipped(268,640)
			    			end;
						self:xy(pn == PLAYER_1 and _screen.cx-800 or _screen.cx+800,SCREEN_TOP+424)
			    			self:finishtweening();
						self:visible(true);
					else
						self:visible(false);
					end
				else
					self:visible(false);
				end
  			end,
	    	MenuLeftP1MessageCommand=function(s) 
				if pn == PLAYER_1 then
					s:playcommand("Set")
				end
			end,
			MenuRightP1MessageCommand=function(s) 
				if pn == PLAYER_1 then
					s:playcommand("Set")
				end
			end,
			MenuLeftP2MessageCommand=function(s) 
				if pn == PLAYER_2 then
					s:playcommand("Set")
				end
			end,
			MenuRightP2MessageCommand=function(s) 
				if pn == PLAYER_2 then
					s:playcommand("Set")
				end
			end,
	    	ChangeRowMessageCommand=function(s,param)
        	    if param.PlayerNumber == pn then s:playcommand "Set"; end;
        	end;
		};
	};
	t[#t+1] = Def.ActorFrame{
		InitCommand=function(s) s:diffusealpha(0):xy(pn == PLAYER_1 and _screen.cx-800 or _screen.cx+800,SCREEN_TOP+270) end,
		OnCommand=function(s) s:sleep(0.2):decelerate(0.2):diffusealpha(1) end,
		OffCommand=function(s) s:accelerate(0.2):diffusealpha(0) end,
		Def.BitmapText{
			Font="_avenirnext lt pro bold/25px",
			InitCommand=function(s) s:y(-6-28-28):maxwidth(400):zoom(1.3) end,
			BeginCommand=function(s) s:queuecommand("Set") end,
			SetCommand=function(self)
				self:strokecolor(Color.Black)
				self:shadowlength(3)
	      		self:settext("")
				if GAMESTATE:GetCurrentSong() then
					self:settext("BPM")
				else
					self:settext("")
				end
			end;
	  	};
		Def.BitmapText{
			Font="_avenirnext lt pro bold/25px",
			InitCommand=function(s) s:y(-6-28):maxwidth(400):zoom(1.3) end,
			BeginCommand=function(s) s:queuecommand("Set") end,
			SetCommand=function(self)
				self:strokecolor(Color.Black)
				self:shadowlength(3)
	      		self:settext("")
				if GAMESTATE:GetCurrentSong() then
					song_bpms= GAMESTATE:GetCurrentSong():GetDisplayBpms()
					song_bpms[1]= math.round(song_bpms[1])
					song_bpms[2]= math.round(song_bpms[2])
					if song_bpms[1] == song_bpms[2] then
						bpm_text= format_bpm(song_bpms[1])
					else
						bpm_text= format_bpm(song_bpms[1]) .. " - " .. format_bpm(song_bpms[2])
					end
					self:settext(bpm_text)
				else
					self:settext("")
				end
			end;
	  	};
		Def.BitmapText{
			Font="_avenirnext lt pro bold/25px",
	    	InitCommand=function(s) s:y(-6):maxwidth(400):zoom(1.3) end,
			BeginCommand=function(s)
				local speed, mode= GetSpeedModeAndValueFromPoptions(pn)
				s:queuecommand("Set",speed,mode)
			end,
	    	SetCommand=function(self,param)
				self:strokecolor(Color.Black)
				self:shadowlength(3)
	      		self:settext("")
				if param and param.speed and param.mode then
					speed = param.speed
					mode = param.mode
				else
					speed, mode= GetSpeedModeAndValueFromPoptions(pn)
				end
                    -- Courses don't have GetDisplayBpms.
                    if GAMESTATE:GetCurrentSong() then
	                    song_bpms= GAMESTATE:GetCurrentSong():GetDisplayBpms()
	                    song_bpms[1]= math.round(song_bpms[1])
	                    song_bpms[2]= math.round(song_bpms[2])
	                    if song_bpms[1] == song_bpms[2] then
		                    bpm_text= format_bpm(song_bpms[1])
	                    else
		                    bpm_text= format_bpm(song_bpms[1]) .. " - " .. format_bpm(song_bpms[2])
	                    end
                    end
                    local text= ""
                    local no_change= true
                    if mode == "x" then
                        if not song_bpms[1] then
                            text= ""
                        elseif song_bpms[1] == song_bpms[2] then
                            text= "x"..(speed/100).." ("..format_bpm(song_bpms[1] * speed*.01)..")"
                        else
                            text= "x"..(speed/100).." ("..format_bpm(song_bpms[1] * speed*.01) .. " - " ..
                                format_bpm(song_bpms[2] * speed*.01)..")"
                        end
                        no_change= speed == 100
                    elseif mode == "C" then
                        text= mode .. speed
                        no_change= speed == song_bpms[2] and song_bpms[1] == song_bpms[2]
                    else
                        no_change= speed == song_bpms[2]
                        if song_bpms[1] == song_bpms[2] then
                            text= mode .. speed
                        else
                            local factor= song_bpms[1] / song_bpms[2]
                            text= mode .. format_bpm(speed * factor) .. " - "
                                .. mode .. speed
                        end
                    end
                    if GAMESTATE:IsCourseMode() then
                        if mode == "x" then
                            text = "x"..(speed/100)
                        else
                            text = mode .. speed
                        end
                        self:settext(""..text)
                    else
                        self:settext(""..text):zoom(1)
                    end
	    	end;
		SpeedChoiceChangedMessageCommand=function(s,param)
			if pn == param.pn then
				s:playcommand("Set",param)
			end
		end,
	  	};
	};
end

t[#t+1] = LoadFallbackB()

--Totally didn't pull this from Outfox default lol -Inori
-- Load all noteskins for the previewer.
local icol = 2
if pn and GAMESTATE:GetCurrentSteps(pn) then
  if GAMESTATE:GetCurrentStyle():ColumnsPerPlayer() < 2 then
	  icol = 1
  end
 local column = GAMESTATE:GetCurrentStyle():GetColumnInfo( GAMESTATE:GetMasterPlayerNumber(), 3 )
	for _,v in pairs(NOTESKIN:GetNoteSkinNames()) do
		local noteskinset = NOTESKIN:LoadActorForNoteSkin( column["Name"] , "Tap Note", v )

		if noteskinset then
			t[#t+1] = noteskinset..{
				Name="NS"..string.lower(v), InitCommand=function(s) s:visible(false) end,
				OnCommand=function(s) s:diffusealpha(0):sleep(0.2):linear(0.2):diffusealpha(1) end,
				OffCommand=function(s) s:linear(0.2):diffusealpha(0) end
			}
		else
			lua.ReportScriptError(string.format("The noteskin %s failed to load.", v))
			t[#t+1] = Def.Actor{ Name="NS"..string.lower(v) }
		end
	end
end


return t