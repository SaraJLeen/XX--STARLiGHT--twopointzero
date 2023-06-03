--Thank you for using this project.
--Please consider all the effort that has been made, so remember to play fair.
--Enjoy! See you later alligator.
--Author: Enciso0720
--Last Update: 20220126

local StagesFolder="/DanceStages/"

local t = Def.ActorFrame{
	SPos = GAMESTATE:GetSongPosition();

	OnCommand=function(self)
		self:Center():fov(gFOV());
		Camera = self
		local isJukeBox = false
		if not (HasVideo() and _VERSION ~= "Lua 5.3") then Camera:SetUpdateFunction(SlowMotion) end
		if SCREENMAN ~= nil and SCREENMAN:GetTopScreen() ~= nil and SCREENMAN:GetTopScreen():GetName() ~= nil and SCREENMAN:GetTopScreen():GetName() == "ScreenJukebox" then
			isJukeBox = true
		end
		if isJukeBox then
			local bg = SCREENMAN:GetTopScreen():GetChild("SongBackground")
			if bg then
				bg:visible(true);
			end
		elseif (VideoStage() and GAMESTATE:GetCurrentSong():HasBGChanges()) or (not GAMESTATE:GetCurrentSong():HasBGChanges()) then
			local bg = SCREENMAN:GetTopScreen():GetChild("SongBackground")
			if bg then
				bg:visible(false);
			end
		else
			local bg = SCREENMAN:GetTopScreen():GetChild("SongBackground")
			if bg then
				bg:visible(true);
			end
		end
	end;
};
------- DANCESTAGE LOADER -------
local DanceStage = DSLoader()

--if (VideoStage() and GAMESTATE:GetCurrentSong():HasBGChanges() and not PotentialModSong()) or (not GAMESTATE:GetCurrentSong():HasBGChanges()) then
if (not HasVideo() and not PotentialModSong()) or (HasVideo() and VideoStage() and not PotentialModSong()) or (HasVideo() and not VideoStage() and not VoverS()) then
	
------- DANCESTAGE LOADER 1 -------

t[#t+1] = LoadActor(StagesFolder..DanceStage.."/LoaderA.lua" )

-------------- CHARACTERS --------------

t[#t+1] = LoadActor("Characters");

------- DANCESTAGE LOADER 2 -------

if FILEMAN:DoesFileExist(StagesFolder..DanceStage.."/LoaderB.lua") then
	t[#t+1] = LoadActor(StagesFolder..DanceStage.."/LoaderB.lua" )
end

------- CAMERA -------

	t[#t+1] = LoadActor(StagesFolder..DanceStage.."/Cameras.lua" )


	CamRan=1
	local CameraRandomList = {}
	
	for i = 1, NumCameras do
		CameraRandomList[i] = i
	end
	
	for i = 1, NumCameras do
		local CamRandNumber = math.random(1,NumCameras)
		local TempRand = CameraRandomList[i]
			CameraRandomList[i] = CameraRandomList[CamRandNumber]
			CameraRandomList[CamRandNumber] = TempRand
	end


	t[#t+1] = Def.Quad{
		OnCommand=function(self)
			self:visible(false)
			:queuemessage("Camera"..CameraRandomList[6]):sleep(WaitTime[CameraRandomList[6]]):queuecommand("TrackTime");
		end;
		TrackTimeCommand=function(self)
		DEDICHAR:SetTimingData()
		self:sleep(1/60)
		self:queuemessage("Camera"..CameraRandomList[CamRan]):sleep(WaitTime[CameraRandomList[CamRan]])
			CurrentStageCamera = CurrentStageCamera
				CamRan=CamRan+1
				if CamRan==NumCameras then
					CamRan = 1
				end
			self:queuecommand("TrackTime")
		end,
	};
end;

return t;