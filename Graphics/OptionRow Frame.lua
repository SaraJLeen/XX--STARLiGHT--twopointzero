local Judges = Def.ActorFrame{}

local function WideToMax( minscale, maxscale )
	return SCREEN_WIDTH <= 1280 and scale( SCREEN_WIDTH, 960, 1280, minscale, maxscale ) or maxscale
end

-- Generate Block background for element.
-- Usual size can be found in OptionRow
for _,pn in ipairs(GAMESTATE:GetEnabledPlayers()) do

	local OriType = LoadModule("Config.Load.lua")("SmartTimings","Save/OutFoxPrefs.ini") or "Original"
	Judges[#Judges+1] = Def.Sprite{
		OnCommand=function(self)
			if self:GetParent():GetParent():GetParent():GetName() == "SmartJudgments" then
				self:x( SCREEN_CENTER_X + (pn == PLAYER_1 and WideToMax(-160,-200) or 380) ):zoom(.5)
				self:Load(LoadModule("Options.SmartJudgments.lua")()[LoadModule("Options.ChoiceToValue.lua")(LoadModule("Options.SmartJudgments.lua")("Show"),LoadModule("Config.Load.lua")("SmartJudgments",CheckIfUserOrMachineProfile(string.sub(pn,-1)-1).."/OutFoxPrefs.ini") or THEME:GetMetric("Common","DefaultJudgment"))])
				self:playcommand("ReanimateState")
			end
		end,
		SmartJudgmentsChangeMessageCommand=function(self,params)
			if params.pn == pn and self:GetParent():GetParent():GetParent() and self:GetParent():GetParent():GetParent():GetName() == "SmartJudgments" then
				self:Load(LoadModule("Options.SmartJudgments.lua")()[LoadModule("Options.ChoiceToValue.lua")(LoadModule("Options.SmartJudgments.lua")("Show"),LoadModule("Options.SmartJudgeChoices.lua")("Value")[params.choice])])
				self:playcommand("ReanimateState")
			end
		end,
		SmartTimingsChangeMessageCommand=function(self,params)
			if self:GetParent():GetParent():GetParent() and self:GetParent():GetParent():GetParent():GetName() == "SmartJudgments" then
				self:stoptweening():playcommand("Change"):playcommand("ReanimateState")
			end
		end,
		ReanimateStateCommand=function(self)
			self:SetAllStateDelays(1)
		end,
		ChangeCommand=function(self)
			local found = nil
			if TimingWindow[getenv("SmartTimings")]().Name then
				found = LoadModule("Options.SmartJudgments.lua")()[
					LoadModule("Options.ChoiceToValue.lua")(LoadModule("Options.SmartJudgments.lua")("Show"),
					LoadModule("Options.SmartJudgeChoices.lua")("Value")[1])
				]
			end
			if found then
				self:Load( found )
			end
		end
	}

    Judges[#Judges+1] = Def.ActorProxy{
		OnCommand=function(self)
			if self:GetParent():GetParent():GetParent():GetName() == "LuaNoteSkins" then
                if SCREENMAN:GetTopScreen() then
                    local CurNoteSkin = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred"):NoteSkin()
					if SCREENMAN:GetTopScreen():GetChild("NS"..string.lower(CurNoteSkin)) then
						self:SetTarget( SCREENMAN:GetTopScreen():GetChild("NS"..string.lower(CurNoteSkin)) )
					end
					self:zoom(0.6):x( pn == PLAYER_1 and 220 or 550 )
                end
            end
        end,
        LuaNoteSkinsChangeMessageCommand=function(self,param)
			if self:GetParent():GetParent():GetParent() and self:GetParent():GetParent():GetParent():GetName() == "LuaNoteSkins" then
				if param.pn == pn then
					local name = NOTESKIN:GetNoteSkinNames()[param.choice]
					self:SetTarget( SCREENMAN:GetTopScreen():GetChild("NS"..string.lower(param.choicename)) )
				end
			end
		end,
    }
end
return Judges
