local t = Def.ActorFrame{};

local yval = 1080-40;

t[#t+1] = Def.ActorFrame{
	InitCommand=function(s)
		s:visible(true)
	end,
	Def.ActorFrame{
		InitCommand=function(s) s:xy(_screen.cx,yval+6) end,
		Def.Sprite{
			Texture="mid.png",
		};
		Def.Sprite{
			Texture="midglow.png",
			OnCommand=function(s)
				s:diffuseshift():effectcolor1(color("1,1,1,1")):effectcolor2(color("1,1,1,0.5")):effectclock('beatnooffset')
			end
		},
	},
	Def.TextBanner{
		InitCommand = function(self) self:Load("TextBannerGameplay")
	  		:x(SCREEN_CENTER_X):y(yval+6):zoom(1.1)
	  		if GAMESTATE:GetCurrentSong() then
				self:SetFromSong(GAMESTATE:GetCurrentSong())
	  		end
		end;
		CurrentSongChangedMessageCommand = function(self)
	  		self:SetFromSong(GAMESTATE:GetCurrentSong())
		end;
	}
};

return t;