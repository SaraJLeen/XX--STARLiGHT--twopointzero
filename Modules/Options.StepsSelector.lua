local function List(pn)
	return GAMESTATE:GetCurrentSong():GetStepsByStepsType(GAMESTATE:GetCurrentSteps(pn):GetStepsType())
end

local function SmartSort(input, rawvalue)
	local output = {}
	local difftab = {
		"Difficulty_Beginner",
		"Difficulty_Easy",
		"Difficulty_Medium",
		"Difficulty_Hard",
		"Difficulty_Challenge",
		"Difficulty_Edit",
		"Difficulty_D7",
		"Difficulty_D8",
		"Difficulty_D9",
		"Difficulty_D10",
		"Difficulty_D11",
		"Difficulty_D12",
		"Difficulty_D13",
		"Difficulty_D14",
		"Difficulty_D15",
	}

	for _,d in ipairs(difftab) do
		local temp = {}
		for _,v in ipairs(input) do
			local diffnametranslit = THEME:GetString("CustomDifficulty",ToEnumShortString(v:GetDifficulty()))
			local result = rawvalue and v or v:GetMeter().." "..diffnametranslit
			if v:GetDifficulty() == d then 
				local numberround = string.format("%.4g", v:GetMeter())
				if rawvalue then
					table.insert(temp,v)
				else
					if v:GetChartName() ~= "" then
						table.insert(temp,numberround.." "..v:GetChartName())
					else
						table.insert(temp,numberround.." "..diffnametranslit )
					end
				end
			end
		end
		if rawvalue then 
			table.sort(temp, function(a,b) return a:GetMeter() < b:GetMeter() end) 
		else 
			table.sort(temp) 
		end
		for _,v in ipairs(temp) do
			table.insert(output,v)
		end
	end

	return output
end

return function(pn)
	return {
		Name = "Step"..ToEnumShortString(pn),
		LayoutType = "ShowAllInRow",
		SelectType = "SelectOne",
		OneChoiceForAllPlayers = true,
		-- Don't allow the other player take control of this, could lead to unwanted situations.
		EnabledForPlayers = function() return {pn} end,
		ExportOnChange = false,
		Choices = SmartSort(List(pn)),			-- Obtain the strings for the difficulties
		Values = SmartSort(List(pn), true),		-- Obtain the raw step objects
		LoadSelections = function(self, list)
			local Default = GAMESTATE:GetCurrentSteps(pn)
			for i,v in pairs(self.Values) do
				if v == Default then
					list[i] = true
					return
				end
			end
		end,
		SaveSelections = function(self, list)
			for i,v in pairs(self.Values) do
				if list[i] then
					GAMESTATE:SetCurrentSteps(pn,SmartSort(List(pn),true)[i])
				end
			end
		end
	}
end
