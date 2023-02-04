return function(Mode)
	local Game = GAMESTATE:GetCurrentGame():GetName()
	local Dir = FILEMAN:GetDirListing("Appearance/BackPlates/"..Game.."/",false,true)
	local NewDir = {}
	for _,v in pairs(Dir) do
		print(v)
		if Mode == "Show" then
			local temp = string.match(v,".+/(.-)%.")
			temp = string.gsub(temp, "%(.+%)", "")
			NewDir[#NewDir+1] = temp
		else
			NewDir[#NewDir+1] = v
		end
	end
	return NewDir
end