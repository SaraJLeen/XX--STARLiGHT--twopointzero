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
	if GetUserPref("OptionRowGameplayBackground")=='DanceStages' then
		return "1,2,3,4,5,6,7,10,8,9,13,Steps,12,E2,E3,15,SelectStage" --,16"
	elseif GetUserPref("OptionRowGameplayBackground")=='SNCharacters' then
		return "1,2,3,4,5,6,7,10,8,9,13,Steps,12,E2,E3,15" --,16"
	else
		return "1,2,3,4,5,6,7,10,8,9,13,Steps,12,E2,E3" --,16"
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

function GetDifficultyName(diff,song)
	local diffn = ToEnumShortString(diff)
	local res = THEME:GetString("CustomDifficulty",diffn)
     if not song then return string.upper(res); end
	local groupn = song:GetGroupName()
	if
		   groupn == "01 - DDR 1st"
		or groupn == "02 - DDR 2ndMIX"
		or groupn == "DDR Club Version"
		then
		-- if diffn == 'Beginner' then res = "Beginner"; end
		if diffn == 'Easy' then res = "Basic"; end
		if diffn == 'Medium' then res = "Another"; end
		if diffn == 'Hard' then res = "Maniac"; end
		-- if diffn == 'Challenge' then res = "Challenge"; end
	elseif
		   groupn == "03 - DDR 3rdMIX"
		then
		if diffn == 'Easy' then res = "Basic"; end
		if diffn == 'Medium' then res = "Another"; end
		if diffn == 'Hard' then res = "SSR"; end
	elseif
		   groupn == "04 - DDR 4thMIX"
		or groupn == "DDR Solo"
		or groupn == "05 - DDR 5thMIX"
		then
		if diffn == 'Easy' then res = "Basic"; end
		if diffn == 'Medium' then res = "Trick"; end
		if diffn == 'Hard' then res = "Maniac"; end
	elseif
		   groupn == "06 - DDR MAX"
		or groupn == "07 - DDR MAX2"
		or groupn == "08 - DDR EXTREME"
		or groupn == "Sara's Classics"
		then
		if diffn == 'Easy' then res = "Light"; end
		if diffn == 'Medium' then res = "Standard"; end
		if diffn == 'Hard' then res = "Heavy"; end
	elseif
		   groupn == "DDR ULTRAMIX"
		or groupn == "DDR UNIVERSE"
		then
		if diffn == 'Easy' then res = "Light"; end
		if diffn == 'Medium' then res = "Standard"; end
		if diffn == 'Hard' then res = "Heavy"; end
		if diffn == 'Challenge' then res = "Oni"; end
	elseif
		   groupn == "ITG 01 - 1"
		or groupn == "ITG 02 - 2"
		or groupn == "ITG 03 - 3"
		or groupn == "ITG 04 - Rebirth"
		or groupn == "ITG 05 - Rebirth 2"
		or groupn == "Ace of Arrows"
		or groupn == "SPEIRMIX GALAXY"
		or groupn == "Sudziosis"
		then
		if diffn == 'Beginner' then res = "Novice"; end
		if diffn == 'Easy' then res = "Easy"; end
		if diffn == 'Medium' then res = "Medium"; end
		if diffn == 'Hard' then res = "Hard"; end
		if diffn == 'Challenge' then res = "Expert"; end
	elseif
		   groupn == "PIU 01 - 1st ~ Perf"
		or groupn == "PIU 02 - Extra ~ PREX3"
		or groupn == "PIU 03 - Exceed ~ Zero"
		or groupn == "PIU 04 - NX ~ NX Absolute"
		or groupn == "PIU 05 - Fiesta ~ Fiesta 2"
		or groupn == "PIU 06 - Prime"
		or groupn == "PIU 07 - Prime 2"
		or groupn == "PIU 08 - XX"
		or groupn == "PIU 50 - Pro ~ Pro 2"
		or groupn == "PIU 51 - Infinity"
		then
		if diffn == 'Beginner' then res = "Easy"; end
		if diffn == 'Easy' then res = "Normal"; end
		if diffn == 'Medium' then res = "Hard"; end
		if diffn == 'Hard' then res = "Crazy"; end
		if diffn == 'Challenge' then res = "Extra"; end
		if diffn == 'Edit' then res = "Pump"; end
	end
	if song:GetMainTitle() == "ayu trance 2" then
		if diffn == 'Easy' then res = "Marathon"; end
		if diffn == 'Medium' then res = "Excessive"; end
		if diffn == 'Hard' then res = "Inhumane"; end
	elseif song:GetMainTitle() == "DDR EXTREME NONSTOP MEGAMIX" then
		if diffn == 'Easy' then res = "Marathon"; end
		if diffn == 'Medium' then res = "Excessive"; end
		if diffn == 'Hard' then res = "Inhumane"; end
	end
	return string.upper(res);
end
