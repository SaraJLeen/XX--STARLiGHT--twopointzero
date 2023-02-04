local TNS = {
    ['TapNoteScore_ProW1'] = {"Note","Score"},
	['TapNoteScore_ProW2'] = {"Note","Score"},
	['TapNoteScore_ProW3'] = {"Note","Score"},
	['TapNoteScore_ProW4'] = {"Note","Score"},
	['TapNoteScore_ProW5'] = {"Note","Score"},
	['TapNoteScore_W1'] = {"Note","Score"},
	['TapNoteScore_W2'] = {"Note","Score"},
	['TapNoteScore_W3'] = {"Note","Score"},
	['TapNoteScore_W4'] = {"Note","Score"},
	['TapNoteScore_W5'] = {"Note","Score"},
    ['TapNoteScore_HitMine'] = {"Mine","Score"},
    ['TapNoteScore_Attack'] = {"Attack", "Score"},
    ['TapNoteScore_Hold'] = {"Hold","Timing"},
    ['TapNoteScore_Roll'] = {"Roll","Timing"},
    ['TapNoteScore_Checkpoint'] = {"Checkpoint","Timing"}
}
return Def.ActorFrame{
    InitCommand=function(self)
        self.mode = LoadModule("Config.Load.lua")("SmartTimings","Save/OutFoxPrefs.ini") or "Original"
        self.PadRelation = LoadModule("Config.Load.lua")("DisableLowerWindows","Save/OutFoxPrefs.ini") or false
        self.TimingTable = nil
        self.TimingOrdering = {}

        -- When in para mode, always force it to para.
        if GAMESTATE:GetCurrentGame():GetName() == "para" then
            self.mode = "ParaParaParadise"
        end

        if GAMESTATE:GetCurrentGame():GetName() == "kbx" then
            self.mode = "KBX"
        end

        self.TimingTable = LoadModule("Options.ReturnCurrentTiming.lua")().Timings

        -- If a TimingTable was never defined (Likely caused by accidental erasing,
        -- custom timing mode not present on the base Timing.lua)
        -- reset it back to Original because without any, the user will not be able to hit any notes.
        if self.TimingTable == nil then
            -- Alert the user about it.
            local TW = TimingWindow[1]()
            Trace("LuaTiming: Timing Mode '".. self.mode .. "' has no timing data assigned. Resetting to '".. TW.Name .."'...")
			self.TimingTable = LoadModule("Gameplay.UseTimingTable.lua")( TW )
            -- LoadModule("Config.Save.lua")("SmartTimings",Name,"Save/OutFoxPrefs.ini")
        end

        -- lua.ReportScriptError( rin_inspect(self.TimingTable) )
        self.TimingOrdering = TimingOrder(self.TimingTable)

        self.Scale = PREFSMAN:GetPreference("TimingWindowScale")
        self.Add = PREFSMAN:GetPreference("TimingWindowAdd")
    end,
    JudgmentWindowMessageCommand=function(self, params)
        local score = 'TapNoteScore_None'

        -- lua.ReportScriptError( rin_inspect(self.TimingOrdering) )

        for _,v in pairs( self.TimingOrdering ) do
            local CurTiming = GetWindowSeconds(v[2], self.Scale, self.Add)
            if TNS[v[1]] and TNS[v[1]][1] == params.Type then
                if TNS[v[1]] and TNS[v[1]][2] == "Timing" then params.timing = CurTiming break
                else if (CurTiming >= params.Window and (CurTiming*-1) <= params.Window) then score = v[1] break end
                end
            end
        end

        if score == 'TapNoteScore_Attack' then score = 'TapNoteScore_W1' end
        if self.PadRelation then
            for i=0,1 do
                if (score == 'TapNoteScore_W'..(5-i) and tonumber(self.PadRelation) >= (i+1)) then score = 'TapNoteScore_None' end
            end
        end

        params.score = score
    end
}