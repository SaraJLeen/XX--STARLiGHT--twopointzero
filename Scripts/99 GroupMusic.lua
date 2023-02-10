do
	--if there isn't music for a specific screen it falls back to common
	local musicg = {
		group = {
			["01 - ddr 1st"]			= "GroupMusic/group/DDR 1st (loop).ogg";
			["02 - ddr 2ndmix"]			= "GroupMusic/group/DDR 2nd Mix (loop).ogg";
			["03 - ddr 3rdmix"]			= "GroupMusic/group/DDR 3rd Mix (loop).ogg";
			["04 - ddr 4thmix"]			= "GroupMusic/group/DDR 4th Mix (loop).ogg";
			["05 - ddr 5thmix"]			= "GroupMusic/group/DDR 5th Mix (loop).ogg";
			["06 - ddr max"]			= "GroupMusic/group/DDRMAX (loop).ogg";
			["07 - ddr max2"]			= "GroupMusic/group/DDRMAX2 (loop).ogg";
			["08 - ddr extreme"]		= "GroupMusic/group/DDREXTREME (loop).ogg";
			["09 - ddr supernova"]		= "GroupMusic/group/DDR SuperNOVA (loop).ogg";
			["10 - ddr supernova2"]		= "GroupMusic/group/DDR SuperNOVA 2 (loop).ogg";
			["11 - ddr x"]				= "GroupMusic/group/DDR X (loop).ogg";
			["12 - ddr x2"]			= "GroupMusic/group/DDR X2 (loop).ogg";
			["13 - ddr x3 vs 2ndmix"]	= "GroupMusic/group/DDR X3 (loop).ogg";
			["14 - ddr 2013 ~ 2014"]	= "GroupMusic/group/DDR 2013 (loop).ogg";
			["15 - ddr a"]				= "GroupMusic/group/DDR A (loop).ogg";
			["16 - ddr a20"]			= "GroupMusic/group/DDR A20 Plus (loop).ogg";
			["17 - ddr a3"]			= "GroupMusic/group/DDR A3 (loop).ogg";
			["50 - ddr supernova3"]		= "GroupMusic/group/DDR SuperNOVA 3 (loop).ogg";
			["51 - ddr xx"]			= "GroupMusic/group/DDR XX (loop).ogg";
			["ace of arrows"]			= "GroupMusic/group/Connect -Arcade-.ogg";
			["ddr club version"]		= "GroupMusic/group/IIDX 3rd Style (loop).ogg";
			["dancing stage collection"]	= "GroupMusic/group/DDR STRIKE (loop).ogg";
			["ddr disney"]				= "GroupMusic/group/DDR Disney's Rave (loop).ogg";
			["ddr grand prix"]			= "GroupMusic/group/DDR A3 (loop).ogg";
			["ddr hottest party"]		= "GroupMusic/group/DDR Hottest Party 2 (loop).ogg";
			["ddr mario mix"]			= "GroupMusic/group/DDR Mario Mix (loop).ogg";
			["ddr misc"]				= "GroupMusic/group/DDR 5th Mix Alt (loop)";
			["ddr ps2"]				= "GroupMusic/group/DDR Party Collection (loop).ogg";
			["ddr ps3"]				= "GroupMusic/group/DDR PS3 (loop).ogg";
			["ddr solo"]				= "GroupMusic/group/DDR Solo 2000 (loop).ogg";
			["ddr ultramix"]			= "GroupMusic/group/DDR ULTRAMIX 3 (loop).ogg";
			["ddr universe"]			= "GroupMusic/group/DDR UNIVERSE 3 (loop).ogg";
			["ddr wii"]				= "GroupMusic/group/DDR Winx Club (loop).ogg";
			["gradi and galamoth"]		= "GroupMusic/group/StripE - Fighting For Freedom (loop).ogg";
			["itg 01 - 1"]				= "GroupMusic/group/ITG 1 (loop).ogg";
			["itg 02 - 2"]				= "GroupMusic/group/ITG 2 (loop).ogg";
			["itg 03 - 3"]				= "GroupMusic/group/ITG 3 (loop).ogg";
			["itg 04 - rebirth"]		= "GroupMusic/group/ITG Rebirth (loop).ogg";
			["itg 05 - rebirth 2"]		= "GroupMusic/group/ITG Rebirth 2 (loop).ogg";
			["outfox"]				= "GroupMusic/group/OutFox (loop).ogg";
			["piu 01 - 1st ~ perf"]		= "GroupMusic/group/PIU 1 (loop).ogg";
			["piu 02 - extra ~ prex3"]	= "GroupMusic/group/PIU Extra (loop).ogg";
			["piu 03 - exceed ~ zero"]	= "GroupMusic/group/PIU EX (loop).ogg";
			["piu 04 - nx ~ nx absolute"]= "GroupMusic/group/PIU Zero (loop).ogg";
			["piu 05 - fiesta ~ fiesta 2"]="GroupMusic/group/PIU Fiesta EX (loop).ogg";
			["piu 06 - prime"]			= "GroupMusic/group/PIU Prime (loop).ogg";
			["piu 07 - prime 2"]		= "GroupMusic/group/PIU Prime 2 (loop).ogg";
			["piu 08 - xx"]			= "GroupMusic/group/PIU XX (loop).ogg";
			["piu 50 - pro ~ pro 2"]	= "GroupMusic/group/PIU Pro 2 (loop).ogg";
			["piu 51 - infinity"]		= "GroupMusic/group/PIU Infinity (loop).ogg";
			["sara's classics"]			= "GroupMusic/group/KaW - Stepper (loop).ogg";
			["speirmix"]				= "GroupMusic/group/StepMania 5 (loop).ogg";
			["speirmix galaxy"]			= "GroupMusic/group/StepMania 5 (loop).ogg";
			["speirmix vs"]			= "GroupMusic/group/StepMania 5 (loop).ogg";
			["sudziosis"]				= "GroupMusic/group/StepMania 4 (loop).ogg";
			["course"]				= "GroupMusic/DDR Modern Course (loop).ogg";
			["random"]				= "GroupMusic/DDREXTREME Random (loop).ogg";
			["roulette"]				= "GroupMusic/DDR Festival Random (loop).ogg";
			["Off"]					= "_silent.ogg";
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
