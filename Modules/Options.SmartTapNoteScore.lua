return function()
    local Timings = {}
    local CurrentTiming = LoadModule("Options.ReturnCurrentTiming.lua")()

    for k,v2 in pairs( LoadModule("Gameplay.UseTimingTable.lua")(CurrentTiming) ) do
        if string.find(k, "W") then Timings[#Timings+1] = ToEnumShortString(k) end
    end
    return Timings,#Timings
end