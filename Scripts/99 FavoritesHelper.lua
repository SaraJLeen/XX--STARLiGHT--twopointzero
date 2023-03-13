local GetFileContents = function(path)
	local contents = ""

	if FILEMAN:DoesFileExist(path) then
		-- create a generic RageFile that we'll use to read the contents
		local file = RageFileUtil.CreateRageFile()
		-- the second argument here (the 1) signifies
		-- that we are opening the file in read-only mode
		if file:Open(path, 1) then
			contents = file:Read()
		end

		-- destroy the generic RageFile now that we have the contents
		file:destroy()
	end

	-- split the contents of the file on newline
	-- to create a table of lines as strings
	local lines = {}
	for line in contents:gmatch("[^\r\n]+") do
		lines[#lines+1] = line
	end

	return lines
end

local faveCacheP1 = {}
local faveCacheP2 = {}
local isFaveCacheP1 = false
local isFaveCacheP2 = false
local faveCountP1 = -1
local faveCountP2 = -1

function ClearFaveCache()
	faveCacheP1 = {}
	faveCacheP2 = {}
	isFaveCacheP1 = false
	isFaveCacheP2 = false
	faveCountP1 = -1
	faveCountP2 = -1
end

local function table_locate( table, value )
	if table ~= nil then
		for i = 1, #table do
			if table[i] == value then return true end
		end
	end
	return false
end

local default_fcompval = function( value ) return value end
local fcompf = function( a,b ) return a < b end
local fcompr = function( a,b ) return a > b end
function table_binsearch( tbl,value,fcompval,reversed )
	-- Initialise functions
	local fcompval = fcompval or default_fcompval
	local fcomp = reversed and fcompr or fcompf
	--  Initialise numbers
	local iStart,iEnd,iMid = 1,#tbl,0
	-- Binary Search
	while iStart <= iEnd do
		-- calculate middle
		iMid = math.floor( (iStart+iEnd)/2 )
		-- get compare value
		local value2 = fcompval( tbl[iMid] )
		-- get all values that match
		if value == value2 then
			local tfound,num = { iMid,iMid },iMid - 1
			while value == fcompval( tbl[num] ) do -- ERROR: this may cause fail in fcompval if num is out of range and tbl[num] is nil
				tfound[1],num = num,num - 1
			end
			num = iMid + 1
			while value == fcompval( tbl[num] ) do -- ERROR: this may cause fail in fcompval if num is out of range and tbl[num] is nil
				tfound[2],num = num,num + 1
			end
			return tfound
		-- keep searching
		elseif fcomp( value,value2 ) then
			iEnd = iMid - 1
		else
			iStart = iMid + 1
		end
	end
	return false
end

local fcomp_default = function( a,b ) return a < b end
function table_bininsert(t, value, fcomp)
	-- Initialise compare function
	local fcomp = fcomp or fcomp_default
	--  Initialise numbers
	local iStart,iEnd,iMid,iState = 1,#t,1,0
	-- Get insert position
	while iStart <= iEnd do
		-- calculate middle
		iMid = math.floor( (iStart+iEnd)/2 )
		-- compare
		if fcomp( value,t[iMid] ) then
			iEnd,iState = iMid - 1,0
		else
			iStart,iState = iMid + 1,1
		end
	end
	table.insert( t,(iMid+iState),value )
	return (iMid+iState)
end

function FaveCount(pn)
	if pn == PLAYER_1 and (not isFaveCacheP1) then GetFaveSongs(PLAYER_1) end
	if pn == PLAYER_2 and (not isFaveCacheP2) then GetFaveSongs(PLAYER_2) end
	if pn == PLAYER_1 then return faveCountP1 end
	if pn == PLAYER_2 then return faveCountP2 end
	return 0
end

function IsFavorite(song)
	local ret = 0
	value = string.lower(song:GetSongDir())
	if not isFaveCacheP1 then GetFaveSongs(PLAYER_1) end
	if not isFaveCacheP2 then GetFaveSongs(PLAYER_2) end
	if table_binsearch(faveCacheP1,value) then ret = ret+1 end
	if table_binsearch(faveCacheP2,value) then ret = ret+2 end
	--for i = 1, #faveCacheP1 do
	--	if faveCacheP1[i] == value then ret = ret+1 break end
	--end
	--for i = 1, #faveCacheP2 do
	--	if faveCacheP2[i] == value then ret = ret+2 break end
	--end
	--Trace("Checking favorite status for "..value.."... "..tostring(ret)..".")
	return ret
end

function GetFaveSongs(pn,force)
	local profileDir
	if not force then
		if pn == PLAYER_1 and isFaveCacheP1 then return faveCacheP1 end
		if pn == PLAYER_2 and isFaveCacheP2 then return faveCacheP2 end
	end
	if pn == PLAYER_1 then profileDir = 'ProfileSlot_Player1' end
	if pn == PLAYER_2 then profileDir = 'ProfileSlot_Player2' end
	local path = PROFILEMAN:GetProfileDir(profileDir)..'Stats.xml'
	local contents = ""
	local faveSongs = {}
	if path == 'Stats.xml' or profileDir == nil then return faveSongs end
	--Trace("Searching favorite songs in path "..path..(force and " (forced)" or ""))
	if FILEMAN:DoesFileExist(path) then
		contents = GetFileContents(path)
		local in_faves = false
		for line in ivalues(contents) do
			if string.find(line,"</FavSongs>") then
				in_faves = false
				break
			end
			if in_faves then
				local insert_string = string.gsub(string.match(line, "%>(.+)%<"),"&apos;","'")
				insert_string = string.lower(insert_string)
				table_bininsert(faveSongs,insert_string)
			end
			if string.find(line,"<FavSongs>") then
				in_faves = true
			end
		end
		--table.sort(faveSongs)
	end
	if pn == PLAYER_1 then
		faveCacheP1 = faveSongs;
		isFaveCacheP1 = true
		if #faveSongs > faveCountP1 and force then MESSAGEMAN:Broadcast("AddedFave") end
		if #faveSongs < faveCountP1 and force then MESSAGEMAN:Broadcast("RemovedFave") end
		faveCountP1 = #faveSongs;
	elseif pn == PLAYER_2 then
		faveCacheP2 = faveSongs;
		isFaveCacheP2 = true
		if #faveSongs > faveCountP2 and force then MESSAGEMAN:Broadcast("AddedFave") end
		if #faveSongs < faveCountP2 and force then MESSAGEMAN:Broadcast("RemovedFave") end
		faveCountP2 = #faveSongs;
	end
	--PrintTable(faveSongs)
	return faveSongs
end

function GetFavoritesColor(get_pn)
	for _, pn in pairs(GAMESTATE:GetEnabledPlayers()) do
		if PROFILEMAN:IsPersistentProfile(pn) and (get_pn == nil or pn == get_pn) then
			profile = PROFILEMAN:GetProfile(pn)
			if     GetProfileIDForPlayer(pn) == "00000000" then	return color("#bd0078") --Pink-red
			elseif GetProfileIDForPlayer(pn) == "00000001" then	return color("#369ad8") --Blue
			elseif GetProfileIDForPlayer(pn) == "00000002" then	return color("#00c5db") --Cyan
			elseif GetProfileIDForPlayer(pn) == "00000003" then	return color("#e64b40") --Orange
			elseif GetProfileIDForPlayer(pn) == "00000004" then	return color("#a979ab") --Purple
			elseif GetProfileIDForPlayer(pn) == "00000005" then	return color("#2999ab") --Teal
			else									return PlayerColor(pn)	end --Use 1P/2P colors
		end
	end
	return Color.White
end

function GetFavoritesName()
	if #GAMESTATE:GetEnabledPlayers() > 1 then
		profilestring = ""
		local has_profile = false
		for _, pn in pairs(GAMESTATE:GetEnabledPlayers()) do
			if PROFILEMAN:IsPersistentProfile(pn) then
				profile = PROFILEMAN:GetProfile(pn)
				if has_profile then profilestring = profilestring.." & " end
				has_profile = true
				profilestring = profilestring..profile:GetDisplayName()
			end
		end
		if (not has_profile) or (profilestring == "") then return "FAVORITES" end
		return "FAVORITES - "..profilestring
	end
	for _, pn in pairs(GAMESTATE:GetEnabledPlayers()) do
		if PROFILEMAN:IsPersistentProfile(pn) then
			profile = PROFILEMAN:GetProfile(pn)
			return "FAVORITES - "..profile:GetDisplayName()
		end;
	end
	return "FAVORITES"
end