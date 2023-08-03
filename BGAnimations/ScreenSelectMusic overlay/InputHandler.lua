local function WheelMove(mov)
  local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel");
  mw:Move(mov)
end

local screen = Var"LoadingScreen"
local StyleCode = 0
local holding_select = false

local function InputHandler(event)
  local player = event.PlayerNumber
  local MusicWheel = SCREENMAN:GetTopScreen("ScreenSelectMusic"):GetChild("MusicWheel");
  local overlay = SCREENMAN:GetTopScreen():GetChild("Overlay")
  if event.type == "InputEventType_Release" then return false end
  if event.DeviceInput.button == "DeviceButton_left mouse button" then
    MESSAGEMAN:Broadcast("MouseLeftClick")
  end
  if MusicWheel ~= nil and getenv("OPList") == 0 then
    if ThemePrefs.Get("WheelType") == "A" then
      if event.GameButton == "MenuLeft" and GAMESTATE:IsPlayerEnabled(player) then
        overlay:GetChild("MWChange"):play()
      end
      if event.GameButton == "MenuRight" and GAMESTATE:IsPlayerEnabled(player) then
        overlay:GetChild("MWChange"):play()
      end
      if event.GameButton == "MenuDown" and GAMESTATE:IsPlayerEnabled(player) and PREFSMAN:GetPreference("OnlyDedicatedMenuButtons") then
        if MusicWheel:GetSelectedType() == 'WheelItemDataType_Song' then
          WheelMove(3)
          if MusicWheel:GetSelectedType() ~= 'WheelItemDataType_Song' then
            WheelMove(-2)
            if MusicWheel:GetSelectedType() == "WheelItemDataType_Song" then
              WheelMove(2)
              if MusicWheel:GetSelectedType() ~= "WheelItemDataType_Song" then
                WheelMove(-1)
                if MusicWheel:GetSelectedType() == "WheelItemDataType_Song" then
                  WheelMove(1)
                end
              end
            end
          end
        else
          MusicWheel:Move(1)
        end
        MusicWheel:Move(0)
        overlay:GetChild("MWChange"):play()
      end
      if event.GameButton == "MenuUp" and GAMESTATE:IsPlayerEnabled(player) and PREFSMAN:GetPreference("OnlyDedicatedMenuButtons") then
        if MusicWheel:GetSelectedType() == 'WheelItemDataType_Song' then
          WheelMove(-3)
          if MusicWheel:GetSelectedType() ~= 'WheelItemDataType_Song' then
            WheelMove(2)
            if MusicWheel:GetSelectedType() == "WheelItemDataType_Song" then
              WheelMove(-2)
              if MusicWheel:GetSelectedType() ~= "WheelItemDataType_Song" then
                WheelMove(1)
                if MusicWheel:GetSelectedType() == "WheelItemDataType_Song" then
                  WheelMove(-1)
                end
              end
            end
          end
        else
          WheelMove(-1)
        end
        WheelMove(0)
        overlay:GetChild("MWChange"):play()
      end
    end
	if #GAMESTATE:GetEnabledPlayers() < 2 and event.type == "InputEventType_FirstPress" and player ~= nil and GAMESTATE:IsPlayerEnabled(player) then
		    if (StyleCode == 0 and event.GameButton == "MenuLeft")  then StyleCode = 1;
		elseif (StyleCode == 1 and event.GameButton == "MenuLeft")  then StyleCode = 2;
		elseif (StyleCode == 2 and event.GameButton == "MenuLeft")  then StyleCode = 3;
		elseif (StyleCode == 3 and event.GameButton == "MenuRight") then StyleCode = 4;
		elseif (StyleCode == 4 and event.GameButton == "MenuRight") then StyleCode = 5;
		elseif (StyleCode == 5 and event.GameButton == "MenuRight") then StyleCode = 6;
		elseif (StyleCode == 6 and event.GameButton == "MenuLeft")  then StyleCode = 7;
		elseif (StyleCode == 7 and event.GameButton == "MenuRight") then StyleCode = 8;
		else StyleCode = 0 end
		if StyleCode > 7 then
			StyleCode = 0
			if GAMESTATE:GetCurrentStyle():GetName() == "single" then GAMESTATE:SetCurrentStyle("double"); SOUND:PlayOnce(THEME:GetPathS("ScreenSelectPlayMode", "in"), true); SOUND:PlayAnnouncer("select style comment double");
			elseif GAMESTATE:GetCurrentStyle():GetName() == "double" then GAMESTATE:SetCurrentStyle("single"); SOUND:PlayOnce(THEME:GetPathS("ScreenSelectPlayMode", "in"), true); SOUND:PlayAnnouncer("select style comment single"); end
		end
	end
	if event.type == "InputEventType_FirstPress" and player ~= nil and GAMESTATE:IsPlayerEnabled(player) then
		if (event.GameButton == "Select")  then holding_select = true; end
	end
	if event.type == "InputEventType_Release" and player ~= nil and GAMESTATE:IsPlayerEnabled(player) then
		if (event.GameButton == "Select")  then holding_select = false; end
	end
	if holding_select and event.type == "InputEventType_FirstPress" and MusicWheel ~= nil and player ~= nil and GAMESTATE:IsPlayerEnabled(player) and GAMESTATE:GetCurrentSong() ~= nil then
		if (event.GameButton == "MenuUp") then
			--GetFaveSongs(player,true)
			local song = GAMESTATE:GetCurrentSong()
			if PROFILEMAN:GetProfile(player):SongIsFavorite(song) then
				--MESSAGEMAN:Broadcast("AddedFave")
				SOUND:PlayOnce(THEME:GetPathS("GameplayAssist", "metronome measure"), true);
			elseif PROFILEMAN:GetProfile(player):SongIsFavorite(song) ~= true then
				--MESSAGEMAN:Broadcast("RemovedFave")
				SOUND:PlayOnce(THEME:GetPathS("GameplayAssist", "metronome beat"), true);
			end
		end
	end
  end
end

setenv("OPOpened",0)
setenv("DList",0)
return Def.ActorFrame{
  OnCommand=function(self) SCREENMAN:GetTopScreen():AddInputCallback(InputHandler)
    SCREENMAN:GetTopScreen():AddInputCallback(DDRInput(self))
  end;
  OffCommand=function(self) 
    SCREENMAN:GetTopScreen():RemoveInputCallback(InputHandler)
    SCREENMAN:GetTopScreen():RemoveInputCallback(DDRInput(self))
  end,
  SongChosenMessageCommand=function(self) setenv("DList",1) self:playcommand("Off") end;
  SongUnchosenMessageCommand=function(self)
    setenv("DList",0)
    self:sleep(0.5):queuecommand("On");
  end;
  MouseLeftClickMessageCommand = function(self)
    if ThemePrefs.Get("Touch") == true then
      self:queuecommand("PlayTopPressedActor")
    end
  end;
  --[[StartReleaseCommand=function(s)
    local song = GAMESTATE:GetCurrentSong()
    local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
    if song and getenv("OPList") == 0 then
      if not ShowTwoPart() and getenv("SortList") == 0 then
        SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_MenuTimer")
      else
      end
    end
  end,]]
  StartRepeatCommand=function(s)
    local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
    local song = GAMESTATE:GetCurrentSong()
    --if song then
    --  if GAMESTATE:IsPlayerEnabled(PLAYER_1) then
    --    if ShowTwoPart() and getenv("OPStop") == 0 then
    --      SCREENMAN:GetTopScreen():OpenOptionsList(PLAYER_1)
    --    else
    --      SCREENMAN:GetTopScreen():OpenOptionsList(PLAYER_1)
    --    end
    --  end
    --  if GAMESTATE:IsPlayerEnabled(PLAYER_2) then 
    --    if ShowTwoPart() and getenv("OPStop") == 0 then
    --      SCREENMAN:GetTopScreen():OpenOptionsList(PLAYER_2)
    --    else
    --      SCREENMAN:GetTopScreen():OpenOptionsList(PLAYER_2)
    --    end
    --  end
    --end
  end,
  PlayTopPressedActorCommand = function(self)
    playTopPressedActor()
    resetPressedActors()
  end;
	--AddedFaveMessageCommand=function(self)
	--	SOUND:PlayOnce(THEME:GetPathS("GameplayAssist", "metronome measure"), true);
	--end;
	--RemovedFaveMessageCommand=function(self)
	--	SOUND:PlayOnce(THEME:GetPathS("GameplayAssist", "metronome beat"), true);
	--end;
  loadfile(THEME:GetPathB("","_cursor"))();
};

--[[
local function WheelMove(mov)
  local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel");
	mw:Move(mov)
end

local t = Def.ActorFrame{
  OnCommand=function(self) SCREENMAN:GetTopScreen():AddInputCallback(DDRInput(self))
  OffCommand=function(self)
    SCREENMAN:GetTopScreen():RemoveInputCallback(DDRInput(self))
  end;
  SongChosenMessageCommand=function(self) self:queuecommand("Off") end;
  SongUnchosenMessageCommand=function(self)
    self:sleep(0.5):queuecommand("On");
  end;
  StartReleaseCommand=function(self)
	  local mw = SCREENMAN:GetTopScreen("ScreenSelectMusic"):GetChild("MusicWheel");
    local song = GAMESTATE:GetCurrentSong() 
    if ThemePrefs.Get("WheelType") == "Jukebox" or ThemePrefs.Get("WheelType") == "Wheel" then
		  if song then
        SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_MenuTimer")
      end
    else
		end;
  end;
  StartRepeatCommand=function(self)
    local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
    local song = GAMESTATE:GetCurrentSong()
    if song then
      if ThemePrefs.Get("WheelType") == "Jukebox" or ThemePrefs.Get("WheelType") == "Wheel" then
        SCREENMAN:AddNewScreenToTop("ScreenPlayerOptionsPopup","SM_MenuTimer")
      else
        SCREENMAN:AddNewScreenToTop("ScreenPlayerOptionsPopup")
      end
    else
    end;
  end;
  SongUnchosenMessageCommand=function(self)
    self:sleep(0.5):queuecommand("On");
  end;
};]]
