local loader
local function getbgloader()
	--Trace("Option: "..tostring(ThemePrefs.Get("GameplayBackground")).." | BGChanges: "..tostring(GAMESTATE:GetCurrentSong():HasBGChanges()).." ("..tostring(#GAMESTATE:GetCurrentSong():GetBGChanges())..") | HasVideo: "..tostring(HasVideo()).." | VideoStage: "..tostring(VideoStage()).." | Song: "..tostring(GAMESTATE:GetCurrentSong()).."")
	if (ThemePrefs.Get("GameplayBackground")=='DanceStages' and VideoStage() and (GAMESTATE:GetCurrentSong() and (GAMESTATE:GetCurrentSong():HasBGChanges() or #GAMESTATE:GetCurrentSong():GetBGChanges()>0 or HasVideo()))) then
		-- Trace("Using dancestage loader; there is a video, but this is a video stage")
		loader = "DanceStages"
		SetUserPref("RandomRNG",'false');
		PREFSMAN:SetPreference('RandomBackgroundMode','RandomBackgroundMode_RandomMovies');
	elseif (GAMESTATE:GetCurrentSong() and (GAMESTATE:GetCurrentSong():HasBGChanges() or #GAMESTATE:GetCurrentSong():GetBGChanges()>0 or HasVideo())) then
		-- Trace("Using BG loader because there is a video")
		loader = "Background"
		SetUserPref("RandomRNG",'false');
		PREFSMAN:SetPreference('RandomBackgroundMode','RandomBackgroundMode_RandomMovies');
	elseif ThemePrefs.Get("GameplayBackground")=='DanceStages' and GetUserPref("RandomRNG")=='true' and not GAMESTATE:IsDemonstration() then
		-- Trace("Using BG loader because RNG dictated it")
		loader = "Background"
		SetUserPref("RandomRNG",'false');
		PREFSMAN:SetPreference('RandomBackgroundMode','RandomBackgroundMode_RandomMovies');
	elseif ThemePrefs.Get("GameplayBackground")=='DanceStages' then
		-- Trace("Using dancestage loader")
		loader = "DanceStages"
		SetUserPref("RandomRNG",'false');
		PREFSMAN:SetPreference('RandomBackgroundMode','RandomBackgroundMode_Off');
	elseif ThemePrefs.Get("GameplayBackground")=='SNCharacters' then
		-- Trace("Using sncharacters loader")
		loader = "SNCharacters"
		SetUserPref("RandomRNG",'false');
		PREFSMAN:SetPreference('RandomBackgroundMode','RandomBackgroundMode_Off');
	else
		-- Trace("Using BG loader by default")
		loader = "Background"
		SetUserPref("RandomRNG",'false');
		PREFSMAN:SetPreference('RandomBackgroundMode','RandomBackgroundMode_RandomMovies');
	end;
	return loader
end

return Def.ActorFrame{
	loadfile(THEME:GetPathB("ScreenGameplay","background/"..getbgloader()))()
};