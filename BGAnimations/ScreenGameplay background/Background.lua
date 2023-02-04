local bgScripts = dofile(THEME:GetCurrentThemeDirectory().."/BGAnimations/BGScripts/default.lua")
if bgScripts.worked then
	--Trace("Loading bgscript");
    return Def.ActorFrame{
        background,
        bgScripts.bg,
    }
else
	--Trace("No bgscript");
    return Def.ActorFrame{
        background
    }
end