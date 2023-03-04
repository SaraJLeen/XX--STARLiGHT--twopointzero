local jk = LoadModule"Jacket.lua"
return Def.CourseContentsList {


	NumItemsToDraw=9,
	MaxSongs= 20,
	LoopScroller=false,
	WrapScroller=false,
	ShowCommand=function(s) s:bouncebegin(0.3):zoomy(1):align(0,0) end,
	HideCommand=function(s) s:linear(0.3):zoomy(0) end,
	WrapScroller = false,
	LoopScroller = false,
	SetCommand=function(self)
		self:pause()
		self:finishtweening()
		self:SetFromGameState();
		self:SetCurrentAndDestinationItem(4);
		self:SetPauseCountdownSeconds(1);
		self:SetSecondsPauseBetweenItems( 0.5 );
		MaxSongs= GAMESTATE:GetCurrentCourse() and GAMESTATE:GetCurrentCourse():GetEstimatedNumStages() or 0
		if GAMESTATE:GetCurrentCourse():GetEstimatedNumStages() > 9 then
			self:SetDestinationItem(8+GAMESTATE:GetCurrentCourse():GetEstimatedNumStages());
			seconds = self:GetSecondsToDestination();
			self:queuecommand("Reset");
		else
		end;
	end;
	ResetCommand=function(self)
		self:sleep(seconds+5):queuecommand("Set");
	end;
	CurrentTrailP1ChangedMessageCommand=function(s) s:playcommand("Set") end,
	CurrentTrailP2ChangedMessageCommand=function(s) s:playcommand("Set") end,

	Display = Def.ActorFrame {
		InitCommand=function(s) s:setsize(402,28) end,
		--------------Song Text
		LoadFont("_avenirnext lt pro bold/20px") .. {
			InitCommand=function(s) s:x(-210+10):maxwidth(362):halign(0) end,
			SetSongCommand=function(self, params)
				if params.Secret ==true then
					songname = params.Song:GetDisplayFullTitle()
					songname = songname:gsub("%w","?");
					songname = songname:gsub("%W","?");
					self:settext(songname);
					self:diffuse(ColorLightTone(CustomDifficultyToColor(params.Difficulty)));
					self:strokecolor(ColorDarkTone(CustomDifficultyToColor(params.Difficulty)));
				else
					if params.Song then
						self:settext(params.Song:GetDisplayFullTitle());
						self:diffuse(ColorLightTone(CustomDifficultyToColor(params.Difficulty)));
						self:strokecolor(ColorDarkTone(CustomDifficultyToColor(params.Difficulty)));
					end;
				end;
				self:finishtweening():diffusealpha(0):sleep(0.125*params.Number):linear(0.125):diffusealpha(1)
			end;
		};
		Def.ActorFrame{
			SetSongCommand=function(self, params)
				self:finishtweening():x(0):diffusealpha(0):sleep(0.125*params.Number):linear(0.125):diffusealpha(1):x(194-10)
			end,
			Def.Quad{
				InitCommand=function(s) s:setsize(20,20) end,
				SetSongCommand=function(self, params)
					if params.PlayerNumber ~= GAMESTATE:GetMasterPlayerNumber() then return end
					self:diffuse( CustomDifficultyToColor(params.Difficulty) );
				end,
			};
			LoadFont("_avenirnext lt pro bold/20px") .. {
				Name="Meter";
				SetSongCommand=function(self, params)
					self:diffuse(Color.White)
					if params.PlayerNumber ~= GAMESTATE:GetMasterPlayerNumber() then return end
					self:settext( params.Meter ):strokecolor(Color.Black):zoom(0.7)
					if string.find( params.Meter, "-") then return end
					local mt = '_MeterType_Default'
					mt = LoadModule"SongAttributes.lua".GetMeterType(params.Song)
					if (mt ~= '_MeterType_DDRX' and mt ~= '_MeterType_Default') then
						newdiff = GetConvertDifficulty_DDRX(params.Song,params.Steps,mt)
						self:settext( tostring(newdiff) )
						self:diffuse(Color.ConvDiffStep)
					end
					if params.Steps:IsAutogen() then self:diffuse(Color.AutogenStep) end
				end;
			};
		}
		
 		

	};
};
