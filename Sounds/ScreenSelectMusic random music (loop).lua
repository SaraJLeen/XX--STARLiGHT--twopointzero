local course = GAMESTATE:GetCurrentCourse()
local song = GAMESTATE:GetCurrentSong()
--Don't just assume that the group name exists though
if not course and not song and getenv("getgroupname") then
	--Trace("Group: random")
	local groupname = "random"
	return GetGroupMusicPath("group",groupname)
end
return GetMenuMusicPath "common"