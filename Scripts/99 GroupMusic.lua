do
	--if there isn't music for a specific screen it falls back to common
	local musicg = {
		group = {
			["01 - ddr 1st"]			= "GroupMusic/group/DDR 1st";
			["02 - ddr 2ndmix"]			= "GroupMusic/group/DDR 2nd Mix";
			["03 - ddr 3rdmix"]			= "GroupMusic/group/DDR 3rd Mix";
			["04 - ddr 4thmix"]			= "GroupMusic/group/DDR 4th Mix (loop).ogg";
			["05 - ddr 5thmix"]			= "GroupMusic/group/DDR 5th Mix (loop).ogg";
			["06 - ddr max"]			= "GroupMusic/group/DDRMAX";
			["07 - ddr max2"]			= "GroupMusic/group/DDRMAX2";
			["08 - ddr extreme"]		= "GroupMusic/group/DDREXTREME";
			["09 - ddr supernova"]		= "GroupMusic/group/DDR SuperNOVA";
			["10 - ddr supernova2"]		= "GroupMusic/group/DDR SuperNOVA 2";
			["11 - ddr x"]				= "GroupMusic/group/DDR X";
			["12 - ddr x2"]			= "GroupMusic/group/DDR X2";
			["13 - ddr x3 vs 2ndmix"]	= "GroupMusic/group/DDR X3";
			["14 - ddr 2013 ~ 2014"]	= "GroupMusic/group/DDR 2013";
			["15 - ddr a"]				= "GroupMusic/group/DDR A";
			["16 - ddr a20"]			= "GroupMusic/group/DDR A20 Plus";
			["17 - ddr a3"]			= "GroupMusic/group/DDR A3";
			["50 - ddr supernova3"]		= "GroupMusic/group/DDR SuperNOVA 3";
			["51 - ddr xx"]			= "GroupMusic/group/DDR XX";
			["ace of arrows"]			= "GroupMusic/group/Connect -Arcade-";
			["ddr club version"]		= "GroupMusic/group/IIDX 3rd Style";
			["dancing stage collection"]	= "GroupMusic/group/DDR STRIKE";
			["ddr disney"]				= "GroupMusic/group/DDR Disney's Rave";
			["ddr grand prix"]			= "GroupMusic/group/DDR A3";
			["ddr hottest party"]		= "GroupMusic/group/DDR Hottest Party 2";
			["ddr mario mix"]			= "GroupMusic/group/DDR Mario Mix";
			["ddr misc"]				= "GroupMusic/group/DDR 5th Mix Alt";
			["ddr ps2"]				= "GroupMusic/group/DDR Party Collection";
			["ddr ps3"]				= "GroupMusic/group/DDR PS3";
			["ddr solo"]				= "GroupMusic/group/DDR Solo 2000";
			["ddr ultramix"]			= "GroupMusic/group/DDR ULTRAMIX 3";
			["ddr universe"]			= "GroupMusic/group/DDR UNIVERSE 3";
			["ddr wii"]				= "GroupMusic/group/DDR Winx Club";
			["gradi and galamoth"]		= "GroupMusic/group/StripE - Fighting For Freedom";
			["itg 01 - 1"]				= "GroupMusic/group/ITG 1";
			["itg 02 - 2"]				= "GroupMusic/group/ITG 2";
			["itg 03 - 3"]				= "GroupMusic/group/ITG 3";
			["itg 04 - rebirth"]		= "GroupMusic/group/ITG Rebirth";
			["itg 05 - rebirth 2"]		= "GroupMusic/group/ITG Rebirth 2";
			["outfox"]				= "GroupMusic/group/OutFox (loop).ogg";
			["piu 01 - 1st ~ perf"]		= "GroupMusic/group/PIU 1";
			["piu 02 - extra ~ prex3"]	= "GroupMusic/group/PIU Extra";
			["piu 03 - exceed ~ zero"]	= "GroupMusic/group/PIU EX";
			["piu 04 - nx ~ nx absolute"]= "GroupMusic/group/PIU Zero";
			["piu 05 - fiesta ~ fiesta 2"]="GroupMusic/group/PIU Fiesta EX";
			["piu 06 - prime"]			= "GroupMusic/group/PIU Prime";
			["piu 07 - prime 2"]		= "GroupMusic/group/PIU Prime 2";
			["piu 08 - xx"]			= "GroupMusic/group/PIU XX";
			["piu 50 - pro ~ pro 2"]	= "GroupMusic/group/PIU Pro 2";
			["piu 51 - infinity"]		= "GroupMusic/group/PIU Infinity";
			["sara's classics"]			= "GroupMusic/group/KaW - Stepper";
			["speirmix"]				= "GroupMusic/group/StepMania 5";
			["speirmix galaxy"]			= "GroupMusic/group/StepMania 5";
			["speirmix vs"]			= "GroupMusic/group/StepMania 5";
			["sudziosis"]				= "GroupMusic/group/StepMania 4";
			["course"]				= "GroupMusic/DDR Modern Course";
			["random"]				= "GroupMusic/DDREXTREME Random";
			["roulette"]				= "GroupMusic/DDR Festival Random";
			["Off"]					= "_silent";
		};
		course = {
			["01 - ddr 1st"]			= "GroupMusic/DDR 3rd Mix Course";
			["02 - ddr 2ndmix"]			= "GroupMusic/DDR 3rd Mix Course";
			["03 - ddr 3rdmix"]			= "GroupMusic/DDR 3rd Mix Course";
			["04 - ddr 4thmix"]			= "GroupMusic/group/DDR 4th Mix Link (loop).ogg";
			["05 - ddr 5thmix"]			= "GroupMusic/group/DDR 5th Mix Alt (loop).ogg";
			["06 - ddr max"]			= "GroupMusic/DDRMAX2 Course";
			["07 - ddr max2"]			= "GroupMusic/DDRMAX2 Course";
			["08 - ddr extreme"]		= "GroupMusic/DDRMAX2 Course";
			["09 - ddr supernova"]		= "GroupMusic/DDR Modern Course";
			["10 - ddr supernova2"]		= "GroupMusic/DDR Modern Course";
			["11 - ddr x"]				= "GroupMusic/DDR Modern Course";
			["12 - ddr x2"]			= "GroupMusic/DDR Modern Course";
			["13 - ddr x3 vs 2ndmix"]	= "GroupMusic/DDR Modern Course";
			["14 - ddr 2013 ~ 2014"]	= "GroupMusic/DDR Modern Course";
			["15 - ddr a"]				= "GroupMusic/DDR Modern Course";
			["16 - ddr a20"]			= "GroupMusic/DDR Modern Course";
			["17 - ddr a3"]			= "GroupMusic/DDR Modern Course";
			["50 - ddr supernova3"]		= "GroupMusic/DDR Modern Course";
			["51 - ddr xx"]			= "GroupMusic/DDR XX Course";
			["ace of arrows"]			= "GroupMusic/DDR Modern Course";
			["ddr club version"]		= "GroupMusic/ITG2 Course";
			["dancing stage collection"]	= "GroupMusic/DDR Festival Course";
			["ddr disney"]				= "GroupMusic/DDR Festival Course";
			["ddr grand prix"]			= "GroupMusic/DDR Modern Course";
			["ddr hottest party"]		= "GroupMusic/DDR Festival Course";
			["ddr mario mix"]			= "GroupMusic/DDR Festival Course";
			["ddr misc"]				= "GroupMusic/DDR 3rd Mix Course";
			["ddr ps2"]				= "GroupMusic/DDR Party Collection Course";
			["ddr ps3"]				= "GroupMusic/DDR Festival Course";
			["ddr solo"]				= "GroupMusic/DDR Modern Course";
			["ddr ultramix"]			= "GroupMusic/DDR Festival Course";
			["ddr universe"]			= "GroupMusic/DDR Festival Course";
			["ddr wii"]				= "GroupMusic/DDR Festival Course";
			["gradi and galamoth"]		= "GroupMusic/ITG2 Course";
			["itg 01 - 1"]				= "GroupMusic/ITG2 Course";
			["itg 02 - 2"]				= "GroupMusic/ITG2 Course";
			["itg 03 - 3"]				= "GroupMusic/ITG3 Course";
			["itg 04 - rebirth"]		= "GroupMusic/ITG3 Course";
			["itg 05 - rebirth 2"]		= "GroupMusic/ITG3 Course";
			["outfox"]				= "GroupMusic/group/OutFox (loop).ogg";
			["piu 01 - 1st ~ perf"]		= "GroupMusic/DDR Modern Course";
			["piu 02 - extra ~ prex3"]	= "GroupMusic/DDR Modern Course";
			["piu 03 - exceed ~ zero"]	= "GroupMusic/DDR Modern Course";
			["piu 04 - nx ~ nx absolute"]= "GroupMusic/DDR Modern Course";
			["piu 05 - fiesta ~ fiesta 2"]="GroupMusic/DDR Modern Course";
			["piu 06 - prime"]			= "GroupMusic/DDR Modern Course";
			["piu 07 - prime 2"]		= "GroupMusic/DDR Modern Course";
			["piu 08 - xx"]			= "GroupMusic/DDR Modern Course";
			["piu 50 - pro ~ pro 2"]	= "GroupMusic/DDR Modern Course";
			["piu 51 - infinity"]		= "GroupMusic/DDR Modern Course";
			["sara's classics"]			= "GroupMusic/DWI Course";
			["speirmix"]				= "GroupMusic/ITG2 Course";
			["speirmix galaxy"]			= "GroupMusic/ITG2 Course";
			["speirmix vs"]			= "GroupMusic/ITG2 Course";
			["sudziosis"]				= "GroupMusic/ITG2 Course";
			["course"]				= "GroupMusic/DDR Modern Course";
			["random"]				= "GroupMusic/DDREXTREME Random";
			["roulette"]				= "GroupMusic/DDR Festival Random";
			["Off"]					= "_silent";
		};
	}
	--thanks to this code
	for name,child in pairs(musicg) do
		if name ~= "group" then
			setmetatable(child, {__index=musicg.group})
		end
	end
	function GetGroupMusicPathDefault(type,relative)
		type = string.lower(type)
		--These must always be relative because otherwise it'll double up the path
		if type == "group" then return GetMenuMusicPath("common",true) end
		return GetMenuMusicPath("common",true)
	end
	function GetGroupMusicPath(type, type2, relative)
		relative = false
		--Trace("Getting group music. Type: "..type..". Type2: "..type2..".")
		local possibles = musicg[string.lower(type)]
			or error("GetMenuMusicPath: unknown group music type "..string.lower(type), 2)
		local selection = string.lower(type2)
		local file = possibles[selection]
			or GetGroupMusicPathDefault(string.lower(type),relative)
		return relative and file or THEME:GetPathS("", file)
	end
end
