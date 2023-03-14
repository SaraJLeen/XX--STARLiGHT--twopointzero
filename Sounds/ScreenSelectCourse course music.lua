local course = GAMESTATE:GetCurrentCourse()
--Don't just assume that the group name exists though
if not course then return GetGroupMusicPath("course","51 - DDR XX") end
--Trace("Group: "..course:GetGroupName().."")
local groupname = course:GetGroupName()
if groupname == "03 - DDR 3rdMIX Korea" then
	groupname = "03 - DDR 3rdMIX"
elseif groupname == "03 - DDR 3rdMIX Korea v2" then
	groupname = "03 - DDR 3rdMIX"
elseif groupname == "03 - DDR 3rdMIX PLUS" then
	groupname = "03 - DDR 3rdMIX"
elseif groupname == "04 - DDR 4thMIX PLUS" then
	groupname = "04 - DDR 4thMIX"
elseif groupname == "09 - DDR SuperNOVA CS" then
	groupname = "09 - DDR SuperNOVA"
elseif groupname == "DDR Party Collection" then
	groupname = "DDR PS2"
elseif groupname == "Default" then
	groupname = "OutFox"
end
return GetGroupMusicPath("course",groupname)