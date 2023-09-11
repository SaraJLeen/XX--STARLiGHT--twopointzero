local streakcolor = color("#6A6ADA")
local arrowcolor = color("#33DADA")
local itg_magnify = 2.25
return Def.ActorFrame{
	
	Def.Sprite..{ Texture="_shared background no streaks",InitCommand=function(self) self:Center() end },

	Def.ActorFrame{
		InitCommand=function(self)
			self:x(SCREEN_CENTER_X):y(SCREEN_CENTER_Y):wag():effectmagnitude(10,0,0):effectperiod(8)
		end;
		Def.ActorFrame{
			InitCommand=function(self)
				self:wag():effectmagnitude(0,5,0):effectperiod(12)
			end;
			
			Def.Sprite{
				 Texture="streak", InitCommand=function(self)
					self:zoom(1.5*itg_magnify):zoomx(2*itg_magnify):y(-200):z(-100):customtexturerect(0.6,0,0.65,1):texcoordvelocity(0.16,0):diffuse(streakcolor):diffusealpha(0.1)
				end;
				UpdateColoringMessageCommand=function(self) self:finishtweening():linear(0.5):diffuse(streakcolor):diffusealpha(0.1) end;
			},
			
			Def.Sprite{
				 Texture="streak", InitCommand=function(self)
					self:zoom(1.5*itg_magnify):zoomx(2*itg_magnify):y(-160):z(-200):customtexturerect(0.9,0,0.95,1):texcoordvelocity(0.14,0):diffuse(streakcolor):diffusealpha(0.1)
				end;
				UpdateColoringMessageCommand=function(self) self:finishtweening():linear(0.5):diffuse(streakcolor):diffusealpha(0.1) end;
			},
			
			Def.Sprite{
				 Texture="streak", InitCommand=function(self)
					self:zoom(1.5*itg_magnify):zoomx(2*itg_magnify):y(-120):z(-300):customtexturerect(0.2,0,0.25,1):texcoordvelocity(0.12,0):diffuse(streakcolor):diffusealpha(0.2)
				end;
				UpdateColoringMessageCommand=function(self) self:finishtweening():linear(0.5):diffuse(streakcolor):diffusealpha(0.1) end;
			},
			
			Def.Sprite{
				 Texture="streak", InitCommand=function(self)
					self:zoom(1.5*itg_magnify):zoomx(2*itg_magnify):y(-80):z(-400):customtexturerect(0.5,0,0.55,1):texcoordvelocity(0.10,0):diffuse(streakcolor):diffusealpha(0.2)
				end;
				UpdateColoringMessageCommand=function(self) self:finishtweening():linear(0.5):diffuse(streakcolor):diffusealpha(0.1) end;
			},
			
			Def.Sprite{
				 Texture="streak", InitCommand=function(self)
					self:zoom(1.5*itg_magnify):zoomx(2*itg_magnify):y(-40):z(-500):customtexturerect(0.5,0,0.55,1):texcoordvelocity(0.08,0):diffuse(streakcolor):diffusealpha(0.3)
				end;
				UpdateColoringMessageCommand=function(self) self:finishtweening():linear(0.5):diffuse(streakcolor):diffusealpha(0.1) end;
			},
			
			Def.Sprite{
				 Texture="streak", InitCommand=function(self)
					self:zoom(1.5*itg_magnify):zoomx(2*itg_magnify):y(0):z(-600):customtexturerect(0.8,0,0.85,1):texcoordvelocity(0.07,0):diffuse(streakcolor):diffusealpha(0.3)
				end;
				UpdateColoringMessageCommand=function(self) self:finishtweening():linear(0.5):diffuse(streakcolor):diffusealpha(0.1) end;
			},
			
			Def.Sprite{
				 Texture="streak", InitCommand=function(self)
					self:zoom(1.5*itg_magnify):zoomx(2*itg_magnify):y(40):z(-500):customtexturerect(0.9,0,0.95,1):texcoordvelocity(0.09,0):diffuse(streakcolor):diffusealpha(0.3)
				end;
				UpdateColoringMessageCommand=function(self) self:finishtweening():linear(0.5):diffuse(streakcolor):diffusealpha(0.1) end;
			},
			
			Def.Sprite{
				 Texture="streak", InitCommand=function(self)
					self:zoom(1.5*itg_magnify):zoomx(2*itg_magnify):y(80):z(-400):customtexturerect(0.2,0,0.25,1):texcoordvelocity(0.11,0):diffuse(streakcolor):diffusealpha(0.2)
				end;
				UpdateColoringMessageCommand=function(self) self:finishtweening():linear(0.5):diffuse(streakcolor):diffusealpha(0.1) end;
			},
			
			Def.Sprite{
				 Texture="streak", InitCommand=function(self)
					self:zoom(1.5*itg_magnify):zoomx(2*itg_magnify):y(120):z(-300):customtexturerect(0.2,0,0.25,1):texcoordvelocity(0.13,0):diffuse(streakcolor):diffusealpha(0.2)
				end;
				UpdateColoringMessageCommand=function(self) self:finishtweening():linear(0.5):diffuse(streakcolor):diffusealpha(0.1) end;
			},
			
			Def.Sprite{
				 Texture="streak", InitCommand=function(self)
					self:zoom(1.5*itg_magnify):zoomx(2*itg_magnify):y(160):z(-200):customtexturerect(0.5,0,0.55,1):texcoordvelocity(0.15,0):diffuse(streakcolor):diffusealpha(0.1)
				end;
				UpdateColoringMessageCommand=function(self) self:finishtweening():linear(0.5):diffuse(streakcolor):diffusealpha(0.1) end;
			},
			
			Def.Sprite{
				 Texture="streak", InitCommand=function(self)
					self:zoom(1.5*itg_magnify):zoomx(2*itg_magnify):y(200):z(-100):customtexturerect(0.8,0,0.85,1):texcoordvelocity(0.17,0):diffuse(streakcolor):diffusealpha(0.1)
				end;
				UpdateColoringMessageCommand=function(self) self:finishtweening():linear(0.5):diffuse(streakcolor):diffusealpha(0.1) end;
			}
		}
	},

	Def.ActorFrame{
	InitCommand=function(self)
		self:fov(45):x(SCREEN_CENTER_X):y(SCREEN_CENTER_Y):rotationz(-30):rotationx(-30):rotationy(-15)
	end,		
		Def.Model{ Meshes="arrow.txt", Materials="ITG2arrowmaterial.txt", Bones="arrow.txt",
			InitCommand=function(self)
				self:diffusealpha(0):zoom(2*itg_magnify):wag():effectmagnitude(0,0,5):effectperiod(5)
			end,
			UpdateColoringMessageCommand=function(self) self:finishtweening():linear(0.5):diffusealpha(0) end
		},		
		Def.Model{ Meshes="arrow.txt", Materials="ITG1arrowmaterial.txt", Bones="arrow.txt",
			InitCommand=function(self)
				self:diffusealpha(.12):zoom(2*itg_magnify):wag():effectmagnitude(0,0,5):effectperiod(5)
			end,
			UpdateColoringMessageCommand=function(self) self:finishtweening():linear(0.5):diffusealpha(.12) end
		}
	},

	-- clear the zbuffer so that screens can draw without having to clear it
	
	Def.Quad{
		 InitCommand=function(self)
			self:clearzbuffer(1):zoom(0)
		end
	},
}