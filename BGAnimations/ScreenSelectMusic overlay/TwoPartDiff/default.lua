local Y_SPACING = 140
local Radar = LoadModule "DDR Groove Radar.lua"
local numItems = 7

local keyset={false,false}

local function DiffInputHandler(event)
	local pn= event.PlayerNumber
	local button = event.button
	if event.type == "InputEventType_Release" then return end

	if (button == "Start") and GAMESTATE:IsPlayerEnabled(pn) and not keyset[pn] and getenv("OPList") == 0 then
		keyset[pn] = true
		MESSAGEMAN:Broadcast("OK"..pn)
	end
end

local af = Def.ActorFrame{
	InitCommand=function(s) s:visible(ThemePrefs.Get("ShowDiffSelect")) end,
	StartSelectingStepsMessageCommand=function(s)
		s:sleep(0.5):queuecommand("Add")
	end,
	SongUnchosenMessageCommand=function(self)
		self:playcommand("Remove")
	end,
	RemoveCommand=function(self)
		SCREENMAN:GetTopScreen():RemoveInputCallback(DiffInputHandler)
		setenv("OPStop",1)
	end,
	AddCommand=function(self)
		SCREENMAN:GetTopScreen():AddInputCallback(DiffInputHandler)
		setenv("OPStop",0)
	end,
	OffCommand=function(self)
		self:playcommand("Remove")
	end,
}

-- Store the player's selections.
local selection = {
	["PlayerNumber_P1"] = nil,
	["PlayerNumber_P2"] = nil
}

local stepsData = {}

local compareSteps = LoadModule "StepsUtil.lua".CompareSteps
local function SetActiveSelections()
	for pn in EnabledPlayers() do
		local playerSteps = GAMESTATE:GetCurrentSteps(pn)
		for i=1,#stepsData do
			if compareSteps(playerSteps, stepsData[i]) == 0 then
				selection[pn] = i
			end
		end
		assert(selection[pn], "couldn't set selection for "..pn)
	end
end

local function RadarPanel(pn)
    local GR = {
        {-1,-122, "Stream"}, --STREAM
        {-120,-43, "Voltage"}, --VOLTAGE
        {-108,72, "Air"}, --AIR
        {108,72, "Freeze"}, --FREEZE
        {120,-43, "Chaos"}, --CHAOS
    }
    local t = Def.ActorFrame{
		StartSelectingStepsMessageCommand=function(s) s:queuecommand("Set") end,
		ChangeStepsMessageCommand=function(s) s:queuecommand("Set") end,
	}

    t[#t+1] = Def.ActorFrame{
        Def.ActorFrame{
            Name="Radar",
            Def.Sprite{
                Texture=THEME:GetPathB("ScreenSelectMusic","overlay/RadarHandler/GrooveRadar base.png"),
            },
            Def.Sprite{
                Texture=THEME:GetPathB("ScreenSelectMusic","overlay/RadarHandler/sweep.png"),
                InitCommand = function(s) s:zoom(1.35):spin():effectmagnitude(0,0,100) end,
            },
            Radar.create_ddr_groove_radar("radar",0,0,pn,125,Alpha(PlayerColor(pn),0.25))
        }
    }

    for i,v in ipairs(GR) do
        t[#t+1] = Def.ActorFrame{
            InitCommand=function(s)
                s:xy(v[1],v[2])
            end,
            Def.Sprite{
                Texture=THEME:GetPathB("ScreenSelectMusic","overlay/RadarHandler/RLabels"),
                InitCommand=function(s) s:animate(0):setstate(i-1) end,
            },
            Def.BitmapText{
                Font="_avenirnext lt pro bold/20px",
                SetCommand=function(s)
                    local song = GAMESTATE:GetCurrentSong()
                    if song then
                        local steps = GAMESTATE:GetCurrentSteps(pn)
                        local value = lookup_ddr_radar_values(song, steps, pn)[i]
                        s:settext(math.floor(value*100+0.5))
                    else
                        s:settext("")
                    end
                    s:strokecolor(color("#1f1f1f")):y(28)
                end,
            }
        }
    end
    return t
end

local function genScrollerFrame(pn)
	local t = Def.ActorFrame{}

	t[#t+1] = Def.DynamicActorScroller{
		NumItemsToDraw = numItems,
		SecondsPerItem = 0.1,
		-- LoopScroller = true,
		OnCommand=function(self)
			-- For more information about this Input Controller, check "Custom Input".
			-- https://outfox.wiki/dev/theming/Theming-Custom-Input/
	
			-- TRICK: Make the scroller be outside of range, so by the time it comes back,
			-- it has been loaded with the present steps data.
			self:SetCurrentAndDestinationItem( numItems+2 )
		end,
		RemoveCommand=function (self)
			self:SetDestinationItem( numItems+2 )
		end,
		StartSelectingStepsMessageCommand=function (self)
			local song = GAMESTATE:GetCurrentSong()
			stepsData = SongUtil.GetPlayableSteps(song)
	
			SetActiveSelections()
	
			-- Force the scroller to update its items.
			self:SetCurrentAndDestinationItem( selection[pn]-1 )
			self:playcommand("CheckItem")
		end,
		LoadFunction = function(self, itemIndex)
			-- This will tell the scroller how many items will be generated for the scroller. It just needs a number.
			-- "Call the expression with line = nil to find out the number of lines."
	
			-- Self is the actor represented for the actor set.
			-- itemIndex is the item relative to the current selection from the user.
			if self then
				local steps = stepsData[itemIndex+1]
				self:visible( steps ~= nil )
				if steps then 
					local diff = steps:GetDifficulty()
					local diffItem = THEME:GetString("CustomDifficulty",ToEnumShortString(diff))
					self:GetChild("DifficultyBG"):Load( THEME:GetPathB("ScreenSelectMusic","overlay/TwoPartDiff/".. diffItem) )
					self:GetChild("Meter"):settext( IsMeterDec(steps:GetMeter()) ):diffuse(CustomDifficultyTwoPartToColor(diff))
					self:GetChild("CFBPMDisplay"):settext( steps:GetAuthorCredit() ):diffuse(CustomDifficultyTwoPartToColor(diff))
					self:GetChild("ShockArrow"):visible( steps:GetRadarValues(pn):GetValue('RadarCategory_Mines') >= 1 )
					self:GetChild("Highlight").indexValue = itemIndex

					-- Handle highscore lamp.
					local profile
					local song = GAMESTATE:GetCurrentSong()

					if not song then return numItems end

					if PROFILEMAN:IsPersistentProfile(pn) then
						profile = PROFILEMAN:GetProfile(pn)
					else
						profile = PROFILEMAN:GetMachineProfile()
					end

					local scorelist = profile:GetHighScoreList(song,steps)
					local scores = scorelist:GetHighScores()
					local topscore

					local lampActor = self:GetChild("Lamp")
					if scores[1] then
						topscore = scores[1]
						assert(topscore)
                		local misses = topscore:GetTapNoteScore("TapNoteScore_Miss")+topscore:GetTapNoteScore("TapNoteScore_CheckpointMiss")
                		local boos = topscore:GetTapNoteScore("TapNoteScore_W5")
                		local goods = topscore:GetTapNoteScore("TapNoteScore_W4")
                		local greats = topscore:GetTapNoteScore("TapNoteScore_W3")
                		local perfects = topscore:GetTapNoteScore("TapNoteScore_W2")
                		local marvelous = topscore:GetTapNoteScore("TapNoteScore_W1")
						if (misses+boos) == 0 and scores[1]:GetScore() > 0 and (marvelous+perfects)>0 then
							if (greats+perfects) == 0 then
								lampActor:diffuse(FullComboEffectColor["JudgmentLine_W1"]):glowblink():effectperiod(0.20)
							elseif greats == 0 then
								lampActor:diffuse(GameColor.Judgment["JudgmentLine_W2"]):glowshift()
							elseif (misses+boos+goods) == 0 then
								lampActor:diffuse(GameColor.Judgment["JudgmentLine_W3"]):stopeffect()
							elseif (misses+boos) == 0 then
								lampActor:diffuse(GameColor.Judgment["JudgmentLine_W4"]):stopeffect()
							end
							lampActor:visible(true)
						else
							if topscore:GetGrade() ~= 'Grade_Failed' then
								lampActor:visible(true):diffuse(color("#f70b9e"))
							else
								lampActor:visible(true):diffuse(color("#555452"))
							end
						end
					else
						lampActor:visible(false)
					end
				end
			end
			return numItems
		end,
		TransformFunction=function(self, offset, itemIndex, numItems)
			self:y( offset * Y_SPACING )

			self:diffusealpha( (offset < -3 or offset > 3) and 0 or 1 )
		end,
		-- By the rules, this is only adding a single item, which is an ActorFrame holding a BitmapText.
		-- The actor in this case will be provided with a ItemIndex attribute attached. This can be accessed
		-- using self. This is only given initially and doesn't update. Use the LoadFunction to get a new
		-- version of the value.
		Def.ActorFrame{
			Def.Sprite{
				Name="DifficultyBG"
			},
			Def.BitmapText{
				Font="_avenirnext lt pro bold/46px",
				Name="Meter",
				InitCommand=function(s)
					s:y(-15)
				end,
			},
			Def.BitmapText{
				Font="_avenirnext lt pro bold/46px",
				Name="CFBPMDisplay",
				InitCommand=function(s)
					s:y(-40):maxwidth(200):zoom(0.5)
				end,
			},
			Def.Sprite{
				Texture="cursor",
				Name="Highlight",
				InitCommand=function(s) s:visible(false):diffuseramp():effectcolor1(Alpha(PlayerColor(pn),0)):effectcolor2(Alpha(PlayerColor(pn),1)):effectclock("beatnooffset") end,
				CheckItemCommand=function (self)
					if self.indexValue then
						local scrollerActor = self:GetParent():GetParent()
						self:visible( self.indexValue == scrollerActor:GetDestinationItem() )
					end
				end,
				["OK"..pn.."MessageCommand"]=function(self)
					self:stopeffect():diffuse(PlayerColor(pn))
				end,
			},
			Def.Sprite{
				Name="Lamp",
				Texture="lamp",
				InitCommand=function(s) s:queuecommand("Set"):visible(false) end,
			},
			Def.Sprite{
				Texture="../_ShockArrow/ShockArrowText",
				Name="ShockArrow",
				InitCommand=function(s) s:y(10):visible(false):zoom(0.3):glowblink():effectcolor1(color("1,1,1,0.6")):effectcolor2(color("1,1,1,0")):effectperiod(0.15) end,
			},
		},
		-- Let's add input to this scroller.
		ChangeStepsMessageCommand=function (self, param)
			if param.Player ~= pn then return end
			local dir = param.Direction
			if selection[pn] ~= nil then
				selection[pn] = selection[pn] + dir
				self:SetDestinationItem( selection[pn]-1 )
				self:playcommand("CheckItem")
			end
		end,
	}

	return t
end

for _,pn in pairs(GAMESTATE:GetEnabledPlayers()) do
	af[#af+1] = Def.ActorFrame{
		InitCommand=function(s)
			s:xy(pn==PLAYER_1 and SCREEN_LEFT+(SCREEN_WIDTH/4.9) or SCREEN_RIGHT-(SCREEN_WIDTH/4.9),_screen.cy+30)
		end,
		genScrollerFrame(pn) .. {
			InitCommand=function(self)
				self:xy(pn==PLAYER_1 and 400 or -400,-40)
			end,
			StartSelectingStepsMessageCommand=function(self)
				self:finishtweening():y(pn==PLAYER_1 and -SCREEN_HEIGHT*2 or SCREEN_HEIGHT*2)
				:decelerate(0.4):y(-40)
			end,
			RemoveCommand=function(s) s:finishtweening():accelerate(0.5):addy(pn==PLAYER_1 and SCREEN_HEIGHT*2 or -SCREEN_HEIGHT*2) end,
		},
		-- Now generate the difficulty info frame.
		Def.ActorFrame{
			InitCommand=function (self)
				self:x(pn==PLAYER_1 and -800 or 800)
			end,
			StartSelectingStepsMessageCommand=function(s) s:x(pn==PLAYER_1 and -800 or 800):decelerate(0.35):x(0) end,
			RemoveCommand=function(s) s:stoptweening():accelerate(0.35):addx(pn==PLAYER_1 and -800 or 800) end,
			Def.ActorFrame{
				Name="WINDOW FRAME",
				InitCommand=function(s)
					s:zoomx(pn==PLAYER_2 and -1 or 1)
				end,
				Def.Sprite{ Texture="WINDOW INNER",
					InitCommand=function(s) s:diffuse(color("#333333")):y(14) end,
				},
				Def.Sprite{ Texture="WINDOW FRAME"}
			},
			Def.ActorFrame{
				Name="DIFF HEADER",
				--Blaze it
				InitCommand=function(s) s:y(-420) end,
				Def.Sprite{
					Texture="Header Box",
					InitCommand=function(s) s:zoomx(pn==PLAYER_2 and -1 or 1) end,
				},
				Def.Sprite{
					Texture="Diff Text",
				}
			},
			RadarPanel(pn)..{
				InitCommand=function(s) s:diffusealpha(0) end,
				StartSelectingStepsMessageCommand=function(s) s:sleep(0.4):smooth(0.1):diffusealpha(0.5)
					:smooth(0.1):diffusealpha(0.3):decelerate(0.3):diffusealpha(1)
				end,
			},
			loadfile(THEME:GetPathB("ScreenSelectMusic","overlay/TwoPartDiff/_Diff.lua"))(pn)..{
				InitCommand=function(s) s:y(-360) end,
				StartSelectingStepsMessageCommand=function(s) s:queuecommand("Set") end,
				ChangeStepsMessageCommand=function(s) s:queuecommand("Set") end,
			}
		},
		--Yes I'm loading a version of the diff list that literally only has the frame removed. Fight me.
		Def.BitmapText{
			Font="_avenirnext lt pro bold/25px",
			Text="Please wait...",
			InitCommand=function(s) s:diffusealpha(0):y(60):strokecolor(Color.Black):sleep(0.4) end,
			AnimCommand=function(s) s:finishtweening():cropright(0.2):linear(0.5):cropright(0):queuecommand("Anim") end,
			["OK"..pn.."MessageCommand"]=function(s)
				s:x(-100):decelerate(0.4):x(0):diffusealpha(1):queuecommand("Anim")
			end,
			RemoveCommand=function (self)
				self:stoptweening():decelerate(0.4):x(0)
			end,
			OffCommand=function(s) 
				s:settext("O.K.!")
				:finishtweening():diffusealpha(1):sleep(1):decelerate(0.3):diffusealpha(0)
			end,
		}
	}
end

return af