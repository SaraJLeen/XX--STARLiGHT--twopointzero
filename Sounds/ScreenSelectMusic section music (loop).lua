local course = GAMESTATE:GetCurrentCourse()
local song = GAMESTATE:GetCurrentSong()
--Don't just assume that the group name exists though
if not course and not song and getenv("getgroupname") then
	--Trace("Group: "..getenv("getgroupname").."")
	local groupname = ""..string.lower(getenv("getgroupname"))..""
	return GetGroupMusicPath("group",groupname)
end
return GetMenuMusicPath "common"