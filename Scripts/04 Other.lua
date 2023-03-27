function UseStaticBackground()
	if ReadPrefFromFile("OptionRowGameplayBackground") ~= nil then
		if GetUserPref("OptionRowGameplayBackground")=='DanceStages' then
			return false
		else
			return true
		end
	else
		return true
	end
end

function OptionNumber()
	--1: Speed, 2: Accel, 3: Hidden/Sudden, 4: Turn, 5: Hide, 6: Scroll
	--7: Noteskin, 8: Freeze, 9: Jump, 10: Cut, 12: Gauge, 13: Filter
	--15: Character, E1: Guideline, E2: Score, E3: Bias
	--A1: Acceleration, A2: Effect, A3: EffectsReceptor, A4: EffectsArrow
	--A5: Appearance2, A6: Turn2, A7: Insert, A8: RemoveCombinations,
	--A9: RemoveFeatures, A10: Scroll2, A11: Holds2, A12: Mines
	--A13: Attacks, A14: PlayerAutoPlay, A15: Hide2, A16: Persp
	if GetUserPref("OptionRowGameplayBackground")=='DanceStages' then
		return "1,2,3,4,5,6,A1,A3,A4,A10,A16,7,13,Steps,12,E3,15,SelectStage" --,16"
	elseif GetUserPref("OptionRowGameplayBackground")=='SNCharacters' then
		return "1,2,3,4,5,6,A1,A3,A4,A10,A16,7,13,Steps,12,E3,15" --,16"
	else
		return "1,2,3,4,5,6,A1,A3,A4,A10,A16,7,13,Steps,12,E3" --,16"
	end
end

function CharactersOption()
	if GetUserPref("OptionRowGameplayBackground")=='DanceStages' then
		return "lua,SelectCharacter()"
	elseif GetUserPref("OptionRowGameplayBackground")=='SNCharacters' then
		return "lua,OptionRowCharacters()"
	end
end

--Loads the file at path and runs it in the specified environment,
--or an empty one if no environment is provided. Catches any errors that occur.
--Returns false if the called function failed, true and anything else the function returned if it worked
function dofile_safer(path, env)
    env = env or {}
    if not FILEMAN:DoesFileExist(path) then
        --the file doesn't exist
        return false
    end
    local handle = RageFileUtil.CreateRageFile()
    handle:Open(path, 1)
    local code = loadstring(handle:Read(), path)
    handle:Close()
    handle:destroy()
    if not code then
        --an error occurred while compiling the file
        return false
    end
    setfenv(code, env)
    return pcall(code)
end

function PrepareAllMainScreens()
	return "ScreenWithMenuElements,ScreenMovie"
	--return "ScreenMovie,ScreenTitleJoin,ScreenTitleMenu,ScreenWithMenuElements,ScreenCaution,ScreenMDSplash,ScreenSelectMusic,ScreenSelectCourse"
end

function PersistAllMainScreens()
	return "ScreenWithMenuElements,ScreenMovie,ScreenTitle,ScreenTitleJoin,ScreenTitleMenu"
	--return "ScreenMovie,ScreenOptions,ScreenTitleMenu,ScreenSelectMode,ScreenProfileLoad,ScreenGameOver,ScreenSelectCourse,ScreenSelectProfile,ScreenSelectPlayCourseMode,ScreenPHOTwON,ScreenOptionsService,ScreenOptionsCustomize,ScreenOptionsCustomizeProfile,ScreenMapControllers,ScreenLogo,ScreenGraphicsAlert,ScreenGameplayHowTo,ScreenEditProfileList,ScreenDataSaveSummary,ScreenClear,ScreenAvatarImageSelection,ScreenCaution,ScreenSortList,ScreenTitleJoin,ScreenWarning,ScreenWithMenuElements,ScreenStageInformation,ScreenSelectMusic,ScreenPlayerOptions,ScreenEvaluation,ScreenEvaluationNormal,ScreenEvaluationSummary,ScreenProfileSave,ScreenProfileSaveSummary,ScreenMDSplash"
end

function GetValidStyleSelect()
	if (GAMESTATE:GetNumPlayersEnabled() > 1) then
		return "Versus"
	elseif (GAMESTATE:GetNumPlayersEnabled() == 1) then
		return "Single,Versus,Double"
	end
	return "Single,Versus,Double"
end

local vanity_difficulties = {
	Beginner = {
		["ITG 01 - 1"]			= "Novice";
		["ITG 02 - 2"]			= "Novice";
		["ITG 03 - 3"]			= "Novice";
		["ITG 04 - Rebirth"]		= "Novice";
		["ITG 05 - Rebirth 2"]		= "Novice";
		["Ace of Arrows"]			= "Novice";
		["SPEIRMIX GALAXY"]		= "Novice";
		["Sudziosis"]			= "Novice";
		["OutFox"]				= "Novice";
		["PIU 01 - 1st ~ Perf"]		= "Easy";
		["PIU 02 - Extra ~ PREX3"]	= "Easy";
		["PIU 03 - Exceed ~ Zero"]	= "Easy";
		["PIU 04 - NX ~ NX Absolute"]	= "Easy";
		["PIU 05 - Fiesta ~ Fiesta 2"]= "Easy";
		["PIU 06 - Prime"]		= "Easy";
		["PIU 07 - Prime 2"]		= "Easy";
		["PIU 08 - XX"]			= "Easy";
		["PIU 50 - Pro ~ Pro 2"]	= "Easy";
		["PIU 51 - Infinity"]		= "Easy";
	};
	Easy = {
		["01 - DDR 1st"]			= "Basic";
		["02 - DDR 2ndMIX"]		= "Basic";
		["DDR Club Version"]		= "Basic";
		["03 - DDR 3rdMIX"]		= "Basic";
		["04 - DDR 4thMIX"]		= "Basic";
		["DDR Solo"]			= "Basic";
		["05 - DDR 5thMIX"]		= "Basic";
		["06 - DDR MAX"]			= "Light";
		["07 - DDR MAX2"]			= "Light";
		["08 - DDR EXTREME"]		= "Light";
		["Sara's Classics"]		= "Light";
		["DDR ULTRAMIX"]			= "Light";
		["DDR UNIVERSE"]			= "Light";
		["ITG 01 - 1"]			= "Easy";
		["ITG 02 - 2"]			= "Easy";
		["ITG 03 - 3"]			= "Easy";
		["ITG 04 - Rebirth"]		= "Easy";
		["ITG 05 - Rebirth 2"]		= "Easy";
		["Ace of Arrows"]			= "Easy";
		["SPEIRMIX GALAXY"]		= "Easy";
		["Sudziosis"]			= "Easy";
		["OutFox"]				= "Easy";
		["PIU 01 - 1st ~ Perf"]		= "Normal";
		["PIU 02 - Extra ~ PREX3"]	= "Normal";
		["PIU 03 - Exceed ~ Zero"]	= "Normal";
		["PIU 04 - NX ~ NX Absolute"]	= "Normal";
		["PIU 05 - Fiesta ~ Fiesta 2"]= "Normal";
		["PIU 06 - Prime"]		= "Normal";
		["PIU 07 - Prime 2"]		= "Normal";
		["PIU 08 - XX"]			= "Normal";
		["PIU 50 - Pro ~ Pro 2"]	= "Normal";
		["PIU 51 - Infinity"]		= "Normal";
	};
	Medium = {
		["01 - DDR 1st"]			= "Another";
		["02 - DDR 2ndMIX"]		= "Another";
		["DDR Club Version"]		= "Another";
		["03 - DDR 3rdMIX"]		= "Another";
		["04 - DDR 4thMIX"]		= "Trick";
		["DDR Solo"]			= "Trick";
		["05 - DDR 5thMIX"]		= "Trick";
		["06 - DDR MAX"]			= "Standard";
		["07 - DDR MAX2"]			= "Standard";
		["08 - DDR EXTREME"]		= "Standard";
		["Sara's Classics"]		= "Standard";
		["DDR ULTRAMIX"]			= "Standard";
		["DDR UNIVERSE"]			= "Standard";
		["ITG 01 - 1"]			= "Medium";
		["ITG 02 - 2"]			= "Medium";
		["ITG 03 - 3"]			= "Medium";
		["ITG 04 - Rebirth"]		= "Medium";
		["ITG 05 - Rebirth 2"]		= "Medium";
		["Ace of Arrows"]			= "Medium";
		["SPEIRMIX GALAXY"]		= "Medium";
		["Sudziosis"]			= "Medium";
		["OutFox"]				= "Medium";
		["PIU 01 - 1st ~ Perf"]		= "Hard";
		["PIU 02 - Extra ~ PREX3"]	= "Hard";
		["PIU 03 - Exceed ~ Zero"]	= "Hard";
		["PIU 04 - NX ~ NX Absolute"]	= "Hard";
		["PIU 05 - Fiesta ~ Fiesta 2"]= "Hard";
		["PIU 06 - Prime"]		= "Hard";
		["PIU 07 - Prime 2"]		= "Hard";
		["PIU 08 - XX"]			= "Hard";
		["PIU 50 - Pro ~ Pro 2"]	= "Hard";
		["PIU 51 - Infinity"]		= "Hard";
	};
	Hard = {
		["01 - DDR 1st"]			= "Maniac";
		["02 - DDR 2ndMIX"]		= "Maniac";
		["DDR Club Version"]		= "Maniac";
		["03 - DDR 3rdMIX"]		= "S.S.R.";
		["04 - DDR 4thMIX"]		= "Maniac";
		["DDR Solo"]			= "Maniac";
		["05 - DDR 5thMIX"]		= "Maniac";
		["06 - DDR MAX"]			= "Heavy";
		["07 - DDR MAX2"]			= "Heavy";
		["08 - DDR EXTREME"]		= "Heavy";
		["Sara's Classics"]		= "Heavy";
		["DDR ULTRAMIX"]			= "Heavy";
		["DDR UNIVERSE"]			= "Heavy";
		["ITG 01 - 1"]			= "Hard";
		["ITG 02 - 2"]			= "Hard";
		["ITG 03 - 3"]			= "Hard";
		["ITG 04 - Rebirth"]		= "Hard";
		["ITG 05 - Rebirth 2"]		= "Hard";
		["Ace of Arrows"]			= "Hard";
		["SPEIRMIX GALAXY"]		= "Hard";
		["Sudziosis"]			= "Hard";
		["OutFox"]				= "Hard";
		["PIU 01 - 1st ~ Perf"]		= "Crazy";
		["PIU 02 - Extra ~ PREX3"]	= "Crazy";
		["PIU 03 - Exceed ~ Zero"]	= "Crazy";
		["PIU 04 - NX ~ NX Absolute"]	= "Crazy";
		["PIU 05 - Fiesta ~ Fiesta 2"]= "Crazy";
		["PIU 06 - Prime"]		= "Crazy";
		["PIU 07 - Prime 2"]		= "Crazy";
		["PIU 08 - XX"]			= "Crazy";
		["PIU 50 - Pro ~ Pro 2"]	= "Crazy";
		["PIU 51 - Infinity"]		= "Crazy";
	};
	Challenge = {
		["DDR ULTRAMIX"]			= "Oni";
		["DDR UNIVERSE"]			= "Oni";
		["ITG 01 - 1"]			= "Expert";
		["ITG 02 - 2"]			= "Expert";
		["ITG 03 - 3"]			= "Expert";
		["ITG 04 - Rebirth"]		= "Expert";
		["ITG 05 - Rebirth 2"]		= "Expert";
		["Ace of Arrows"]			= "Expert";
		["SPEIRMIX GALAXY"]		= "Expert";
		["Sudziosis"]			= "Expert";
		["OutFox"]				= "Expert";
		["PIU 01 - 1st ~ Perf"]		= "Nightmare";
		["PIU 02 - Extra ~ PREX3"]	= "Nightmare";
		["PIU 03 - Exceed ~ Zero"]	= "Nightmare";
		["PIU 04 - NX ~ NX Absolute"]	= "Nightmare";
		["PIU 05 - Fiesta ~ Fiesta 2"]= "Nightmare";
		["PIU 06 - Prime"]		= "Nightmare";
		["PIU 07 - Prime 2"]		= "Nightmare";
		["PIU 08 - XX"]			= "Nightmare";
		["PIU 50 - Pro ~ Pro 2"]	= "Nightmare";
		["PIU 51 - Infinity"]		= "Nightmare";
	};
	Edit = {
		["PIU 01 - 1st ~ Perf"]		= "Pump";
		["PIU 02 - Extra ~ PREX3"]	= "Pump";
		["PIU 03 - Exceed ~ Zero"]	= "Pump";
		["PIU 04 - NX ~ NX Absolute"]	= "Pump";
		["PIU 05 - Fiesta ~ Fiesta 2"]= "Pump";
		["PIU 06 - Prime"]		= "Pump";
		["PIU 07 - Prime 2"]		= "Pump";
		["PIU 08 - XX"]			= "Pump";
		["PIU 50 - Pro ~ Pro 2"]	= "Pump";
		["PIU 51 - Infinity"]		= "Pump";
	};
};

function GetDifficultyName(diff,song)
	local diffn = ToEnumShortString(diff)
	local res = THEME:GetString("CustomDifficulty",diffn)
	if not song then return string.upper(res); end
	local groupn = song:GetGroupName()
	if groupn == "<Favorites>" then groupn = string.match(song:GetSongDir(), "/Songs/(.-)/") end
	local possibles = vanity_difficulties[diffn]
	if possibles[groupn] then
		res = possibles[groupn]
	else
		res = THEME:GetString("CustomDifficulty",diffn)
	end
	if song:MusicLengthSeconds() >= 600 then
		if diffn == 'Beginner' then res = "Tedious"; end
		if diffn == 'Easy' then res = "Marathon"; end
		if diffn == 'Medium' then res = "Excessive"; end
		if diffn == 'Hard' then res = "Inhumane"; end
		if diffn == 'Challenge' then res = "Pain"; end
	end
	return string.upper(res);
end
