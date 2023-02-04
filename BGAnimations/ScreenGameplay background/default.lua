local loader
local function getbgloader()
	if (GetUserPref("OptionRowGameplayBackground")=='DanceStages' and VideoStage()) and (GAMESTATE:GetCurrentSong() and GAMESTATE:GetCurrentSong():HasBGChanges()) then
		Trace("Using dancestage loader; there is a video, but this is a video stage")
		loader = "DanceStages"
		SetUserPref("RandomRNG",'false');
		PREFSMAN:SetPreference('RandomBackgroundMode','RandomBackgroundMode_RandomMovies');
	elseif (GAMESTATE:GetCurrentSong() and GAMESTATE:GetCurrentSong():HasBGChanges()) then
		Trace("Using BG loader because there is a video")
		loader = "Background"
		SetUserPref("RandomRNG",'false');
		PREFSMAN:SetPreference('RandomBackgroundMode','RandomBackgroundMode_RandomMovies');
	elseif GetUserPref("OptionRowGameplayBackground")=='DanceStages' and GetUserPref("RandomRNG")=='true' and not GAMESTATE:IsDemonstration() then
		Trace("Using BG loader because RNG dictated it")
		loader = "Background"
		SetUserPref("RandomRNG",'false');
		PREFSMAN:SetPreference('RandomBackgroundMode','RandomBackgroundMode_RandomMovies');
	elseif GetUserPref("OptionRowGameplayBackground")=='DanceStages' then
		Trace("Using dancestage loader")
		loader = "DanceStages"
		SetUserPref("RandomRNG",'false');
		PREFSMAN:SetPreference('RandomBackgroundMode','RandomBackgroundMode_Off');
	elseif GetUserPref("OptionRowGameplayBackground")=='SNCharacters' then
		Trace("Using sncharacters loader")
		loader = "SNCharacters"
		SetUserPref("RandomRNG",'false');
		PREFSMAN:SetPreference('RandomBackgroundMode','RandomBackgroundMode_Off');
	else
		Trace("Using BG loader by default")
		loader = "Background"
		SetUserPref("RandomRNG",'false');
		PREFSMAN:SetPreference('RandomBackgroundMode','RandomBackgroundMode_RandomMovies');
	end;
	return loader
end

return Def.ActorFrame{
	LoadActor(getbgloader())
};