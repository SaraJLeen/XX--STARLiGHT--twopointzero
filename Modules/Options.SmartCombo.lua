local ComboTable = {}
local ActiveFever = {PLAYER_1 = false, PLAYER_2 = false}

return Def.ActorFrame{
	InitCommand=function(self)
		-- Load any custom timing sets set by the current TimingWindow.
		-- This will be performed by overwriting existing values from the local tables above.
		self.mode = LoadModule("Config.Load.lua")("SmartTimings","Save/OutFoxPrefs.ini") or "Original"

		for k,v in pairs( TimingWindow ) do
			local TW = TimingWindow[k]()
            if self.mode == TW.Name then
				if( TW.Combo ) then
					for a,b in pairs( TW.Combo ) do ComboTable[a] = b end
				end
                break
            end
        end
	end,
	FeverMessageCommand=function(self,params)
		ActiveFever[params.pn] = params.Active
	end,
    ScoringComboMessageCommand=function(self,params)
		local percent = 1
		
		for k,v in pairs(ComboTable) do
			if params.Combo >= v then
				percent = k
				break
			end
		end
		
		if ActiveFever[params.pn] then percent = percent * 2 end
		params.percent = percent
	end
}