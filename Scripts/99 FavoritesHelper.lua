function FaveCount(pn)
	return #PROFILEMAN:GetProfile(pn):GetFavorites()
end

function IsFavorite(song)
	local ret = 0
	if not song then return ret end
	local profile1 = PROFILEMAN:GetProfile(PLAYER_1)
	local profile2 = PROFILEMAN:GetProfile(PLAYER_2)
	if (profile1) and (profile1:SongIsFavorite(song)) then ret = ret+1 end
	if (profile2) and (profile2:SongIsFavorite(song)) then ret = ret+2 end
	return ret
end

function GetProfileColor(profile,flag)
	-- Trace("GetProfileColor called\n")
	if profile then
		-- Trace("Profile exists\n")
		if     profile:GetGUID() == "b3fa54eb35f58674" then	return color("#bd0078") --Pink-red
		elseif profile:GetGUID() == "2269a6209c6291a3" then	return color("#369ad8") --Blue
		elseif profile:GetGUID() == "5ad12c91e4ef0685" then	return color("#00c5db") --Cyan
		elseif profile:GetGUID() == "ab5180d49b0ca87b" then	return color("#e64b40") --Orange
		elseif profile:GetGUID() == "00000004" then	return color("#a979ab") --Purple
		elseif profile:GetGUID() == "00000005" then	return color("#2999ab") --Teal
		end
	end
	if flag then return PlayerColor(flag) end --Use 1P/2P colors
	-- Trace("Reached end...\n")
	return Color.White
end


function GetFavoritesColor(get_pn)
	for _, pn in pairs(GAMESTATE:GetEnabledPlayers()) do
		if PROFILEMAN:IsPersistentProfile(pn) and (get_pn == nil or pn == get_pn) then
			profile = PROFILEMAN:GetProfile(pn)
			return GetProfileColor(profile,pn)
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
