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
	return "ScreenWithMenuElements"
	-- return "ScreenMovie,ScreenTitleJoin,ScreenTitleMenu,ScreenWithMenuElements,ScreenCaution,ScreenMDSplash"
end

function PersistAllMainScreens()
	return "ScreenWithMenuElements"
	-- return "ScreenMovie,ScreenOptions,ScreenTitleMenu,ScreenSelectMode,ScreenProfileLoad,ScreenGameOver,ScreenSelectCourse,ScreenSelectProfile,ScreenSelectPlayCourseMode,ScreenPHOTwON,ScreenOptionsService,ScreenOptionsCustomize,ScreenOptionsCustomizeProfile,ScreenMapControllers,ScreenLogo,ScreenGraphicsAlert,ScreenGameplayHowTo,ScreenEditProfileList,ScreenDataSaveSummary,ScreenClear,ScreenAvatarImageSelection,ScreenCaution,ScreenSortList,ScreenTitleJoin,ScreenWarning,ScreenWithMenuElements,ScreenStageInformation,ScreenSelectMusic,ScreenPlayerOptions,ScreenEvaluation,ScreenEvaluationNormal,ScreenEvaluationSummary,ScreenProfileSave,ScreenProfileSaveSummary,ScreenMDSplash"
end

function GetValidStyleSelect()
	if (GAMESTATE:GetNumPlayersEnabled() > 1) then
		return "Versus"
	elseif (GAMESTATE:GetNumPlayersEnabled() == 1) then
		return "Single,Versus,Double"
	end
	return "Single,Versus,Double"
end