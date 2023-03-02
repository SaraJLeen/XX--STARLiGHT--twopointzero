local BGOVERLAY = "bgoverlay"
local streakcolor = color("#999983")
local itg_magnify = 2.25
local oldcol
return Def.ActorFrame{
	Def.ActorFrame{
	InitCommand=function(self)
		self:wag():effectmagnitude(0,5,0):effectperiod(12)
	end;
		Def.ActorFrame{
			InitCommand=function(self)
				self:fov(105):zoom(1.3)
			end;
			-- Overlay
			
			LoadActor(BGOVERLAY)..{
				 InitCommand=function(self)
					oldcol = true
					self:vertalign(bottom):zoomtowidth((SCREEN_WIDTH*1.1)*itg_magnify):zoomy(1.1*itg_magnify):rotationy(180)
				end;
				UpdateColoringMessageCommand=function(s)
					if true ~= oldcol then
						s:linear(0.25):diffuse(Color.Black):queuecommand("LoadNewBG")
					end
				end;
				LoadNewBGCommand=function(s)
					s:Load( THEME:GetPathB("_shared background no","streaks/"..BGOVERLAY) ):linear(0.25):diffuse(Color.White)
					oldcol = true
				end;
			},
			
			LoadActor(BGOVERLAY)..{
				 InitCommand=function(self)
					self:vertalign(bottom):zoomtowidth((SCREEN_WIDTH*1.1)*itg_magnify):zoomy(-1.1*itg_magnify)
				end;
				UpdateColoringMessageCommand=function(s)
					if true ~= oldcol then
						s:linear(0.25):diffuse(Color.Black):queuecommand("LoadNewBG")
					end
				end;
				LoadNewBGCommand=function(s)
					s:Load( THEME:GetPathB("_shared background no","streaks/"..BGOVERLAY) ):linear(0.25):diffuse(Color.White)
					oldcol = true
				end;
			},
		},

		-- upper top dots
		
		Def.Sprite{ Texture="dots",
			InitCommand=function(self)
				self:zoom(1.5*itg_magnify):y(-200):z(-400):customtexturerect(0.2,0,1.2,1):texcoordvelocity(-0.06,0):diffuse(streakcolor):diffusealpha(0.1)
			end;
			UpdateColoringMessageCommand=function(s)
				streakcolor = color("#999983")
				BGOVERLAY = "bgoverlay"
				s:linear(0.5):diffuse(streakcolor):diffusealpha(0.1)
			end;
		},
		
		Def.Sprite{ Texture="dots",
			InitCommand=function(self)
				self:zoom(1.5*itg_magnify):y(-200):z(-200):customtexturerect(0.5,0,1.5,1):texcoordvelocity(0.03,0):diffuse(streakcolor):diffusealpha(0.1)
			end;
			UpdateColoringMessageCommand=function(s) s:finishtweening():linear(0.5):diffuse(streakcolor):diffusealpha(0.1) end;
		},
		
		Def.Sprite{ Texture="dots",
			InitCommand=function(self)
				self:zoom(1.5*itg_magnify):y(-200):z(-100):customtexturerect(0.8,0,1.8,1):texcoordvelocity(0.06,0):diffuse(streakcolor):diffusealpha(0.15)
			end;
			UpdateColoringMessageCommand=function(s) s:finishtweening():linear(0.5):diffuse(streakcolor):diffusealpha(0.15) end;
		},
		
		Def.Sprite{ Texture="dots",
			InitCommand=function(self)
				self:zoom(1.5*itg_magnify):y(-200):z(-050):customtexturerect(0.1,0,1.1,1):texcoordvelocity(0.06,0):diffuse( ColorLightTone(streakcolor) ):diffusealpha(0.15)
			end;
			UpdateColoringMessageCommand=function(s) s:finishtweening():linear(0.5):diffuse( ColorLightTone(streakcolor) ):diffusealpha(0.15) end;
		},
		
		Def.Sprite{ Texture="dots",
			InitCommand=function(self)
				self:zoom(1.5*itg_magnify):y(-200):z(000):customtexturerect(0.1,0,1.1,1):texcoordvelocity(0.06,0):diffuse( ColorLightTone(streakcolor) ):diffusealpha(0.2)
			end;
			UpdateColoringMessageCommand=function(s) s:finishtweening():linear(0.5):diffuse( ColorLightTone(streakcolor) ):diffusealpha(0.2) end;
		},

		-- lower top dots
		
		Def.Sprite{ Texture="dots",
			InitCommand=function(self)
				self:zoom(1.5*itg_magnify):y(-100):z(-400):customtexturerect(0.4,0,1.4,1):texcoordvelocity(-0.06,0):diffuse(streakcolor):diffusealpha(0.1)
			end;
			UpdateColoringMessageCommand=function(s) s:finishtweening():linear(0.5):diffuse(streakcolor):diffusealpha(0.1) end;
		},
		
		Def.Sprite{ Texture="dots",
			InitCommand=function(self)
				self:zoom(1.5*itg_magnify):y(-150):z(-200):customtexturerect(0.7,0,1.7,1):texcoordvelocity(0.03,0):diffuse(streakcolor):diffusealpha(0.1)
			end;
			UpdateColoringMessageCommand=function(s) s:finishtweening():linear(0.5):diffuse(streakcolor):diffusealpha(0.1) end;
		},
		
		Def.Sprite{ Texture="dots",
			InitCommand=function(self)
				self:zoom(1.5*itg_magnify):y(-100):z(-100):customtexturerect(0.0,0,1.0,1):texcoordvelocity(0.06,0):diffuse(streakcolor):diffusealpha(0.15)
			end;
			UpdateColoringMessageCommand=function(s) s:finishtweening():linear(0.5):diffuse(streakcolor):diffusealpha(0.15) end;
		},
		
		Def.Sprite{ Texture="dots",
			InitCommand=function(self)
				self:zoom(1.5*itg_magnify):y(-150):z(-50):customtexturerect(0.3,0,1.3,1):texcoordvelocity(0.06,0):diffuse( ColorLightTone(streakcolor) ):diffusealpha(0.15)
			end;
			UpdateColoringMessageCommand=function(s) s:finishtweening():linear(0.5):diffuse( ColorLightTone(streakcolor) ):diffusealpha(0.15) end;
		},
		
		Def.Sprite{ Texture="dots",
			InitCommand=function(self)
				self:zoom(1.5*itg_magnify):y(-150):z(000):customtexturerect(0.3,0,1.3,1):texcoordvelocity(0.06,0):diffuse( ColorLightTone(streakcolor) ):diffusealpha(0.2)
			end;
			UpdateColoringMessageCommand=function(s) s:finishtweening():linear(0.5):diffuse( ColorLightTone(streakcolor) ):diffusealpha(0.2) end;
		},

		-- upper bottom dots
		
		Def.Sprite{ Texture="dots",
			InitCommand=function(self)
				self:zoom(1.5*itg_magnify):y(100):z(-400):customtexturerect(0.0,0,1.0,1):texcoordvelocity(-0.06,0):diffuse(streakcolor):diffusealpha(0.1)
			end;
			UpdateColoringMessageCommand=function(s) s:finishtweening():linear(0.5):diffuse(streakcolor):diffusealpha(0.1) end;
		},
		
		Def.Sprite{ Texture="dots",
			InitCommand=function(self)
				self:zoom(1.5*itg_magnify):y(150):z(-200):customtexturerect(0.3,0,1.3,1):texcoordvelocity(0.03,0):diffuse(streakcolor):diffusealpha(0.1)
			end;
			UpdateColoringMessageCommand=function(s) s:finishtweening():linear(0.5):diffuse(streakcolor):diffusealpha(0.1) end;
		},
		
		Def.Sprite{ Texture="dots",
			InitCommand=function(self)
				self:zoom(1.5*itg_magnify):y(100):z(-100):customtexturerect(0.6,0,1.6,1):texcoordvelocity(0.06,0):diffuse(streakcolor):diffusealpha(0.15)
			end;
			UpdateColoringMessageCommand=function(s) s:finishtweening():linear(0.5):diffuse(streakcolor):diffusealpha(0.15) end;
		},
		
		Def.Sprite{ Texture="dots",
			InitCommand=function(self)
				self:zoom(1.5*itg_magnify):y(150):z(-050):customtexturerect(0.9,0,1.9,1):texcoordvelocity(0.06,0):diffuse( ColorLightTone(streakcolor) ):diffusealpha(0.15)
			end;
			UpdateColoringMessageCommand=function(s) s:finishtweening():linear(0.5):diffuse( ColorLightTone(streakcolor) ):diffusealpha(0.15) end;
		},
		
		Def.Sprite{ Texture="dots",
			InitCommand=function(self)
				self:zoom(1.5*itg_magnify):y(150):z(000):customtexturerect(0.9,0,1.9,1):texcoordvelocity(0.06,0):diffuse( ColorLightTone(streakcolor) ):diffusealpha(0.2)
			end;
			UpdateColoringMessageCommand=function(s) s:finishtweening():linear(0.5):diffuse( ColorLightTone(streakcolor) ):diffusealpha(0.2) end;
		},

		-- lower bottom dots
		
		Def.Sprite{ Texture="dots",
			InitCommand=function(self)
				self:zoom(1.5*itg_magnify):y(200):z(-400):customtexturerect(0.8,0,1.8,1):texcoordvelocity(-0.06,0):diffuse(streakcolor):diffusealpha(0.1)
			end;
			UpdateColoringMessageCommand=function(s) s:finishtweening():linear(0.5):diffuse(streakcolor):diffusealpha(0.1) end;
		},
		
		Def.Sprite{ Texture="dots",
			InitCommand=function(self)
				self:zoom(1.5*itg_magnify):y(200):z(-200):customtexturerect(0.1,0,1.1,1):texcoordvelocity(0.03,0):diffuse(streakcolor):diffusealpha(0.1)
			end;
			UpdateColoringMessageCommand=function(s) s:finishtweening():linear(0.5):diffuse(streakcolor):diffusealpha(0.1) end;
		},
		
		Def.Sprite{ Texture="dots",
			InitCommand=function(self)
				self:zoom(1.5*itg_magnify):y(200):z(-100):customtexturerect(0.4,0,1.4,1):texcoordvelocity(0.06,0):diffuse(streakcolor):diffusealpha(0.15)
			end;
			UpdateColoringMessageCommand=function(s) s:finishtweening():linear(0.5):diffuse(streakcolor):diffusealpha(0.15) end;
		},
		
		Def.Sprite{ Texture="dots",
			InitCommand=function(self)
				self:zoom(1.5*itg_magnify):y(200):z(-050):customtexturerect(0.7,0,1.7,1):texcoordvelocity(0.06,0):diffuse( ColorLightTone(streakcolor) ):diffusealpha(0.15)
			end;
			UpdateColoringMessageCommand=function(s) s:finishtweening():linear(0.5):diffuse( ColorLightTone(streakcolor) ):diffusealpha(0.15) end;
		},
		
		Def.Sprite{ Texture="dots",
			InitCommand=function(self)
				self:zoom(1.5*itg_magnify):y(200):z(000):customtexturerect(0.7,0,1.7,1):texcoordvelocity(0.06,0):diffuse( ColorLightTone(streakcolor) ):diffusealpha(0.2)
			end;
			UpdateColoringMessageCommand=function(s) s:finishtweening():linear(0.5):diffuse( ColorLightTone(streakcolor) ):diffusealpha(0.2) end;
		},

		-- top blocks 
		
		LoadActor("BLOCK")..{
			InitCommand=function(self)
				self:zoom(3*itg_magnify):y(-100):z(-350):customtexturerect(0.3,0,1.3,1):texcoordvelocity(-0.06,0):diffuse(streakcolor):diffusealpha(0.05)
			end;
			UpdateColoringMessageCommand=function(s) s:finishtweening():linear(0.5):diffuse(streakcolor):diffusealpha(0.05) end;
		},
		
		LoadActor("ARROWS")..{
			InitCommand=function(self)
				self:zoom(3*itg_magnify):y(-100):z(-200):customtexturerect(0.6,0,1.6,1):texcoordvelocity(0.03,0):diffuse(streakcolor):diffusealpha(0.1)
			end;
			UpdateColoringMessageCommand=function(s) s:finishtweening():linear(0.5):diffuse(streakcolor):diffusealpha(0.1) end;
		},
		
		LoadActor("TICKS")..{
			InitCommand=function(self)
				self:zoom(3*itg_magnify):y(-150):z(-200):customtexturerect(0.6,0,1.6,1):texcoordvelocity(0.03,0):diffuse(streakcolor):diffusealpha(0.1)
			end;
			UpdateColoringMessageCommand=function(s) s:finishtweening():linear(0.5):diffuse(streakcolor):diffusealpha(0.1) end;
		},
		
		LoadActor("ARROWS")..{
			InitCommand=function(self)
				self:zoomx(1.5*itg_magnify):zoomy(3*itg_magnify):y(-200):z(-100):customtexturerect(0.9,0,1.4,1):texcoordvelocity(0.06,0):diffuse( ColorLightTone(streakcolor) ):diffusealpha(0.2)
			end;
			UpdateColoringMessageCommand=function(s) s:finishtweening():linear(0.5):diffuse( ColorLightTone(streakcolor) ):diffusealpha(0.2) end;
		},
		
		LoadActor("BLOCK")..{
			InitCommand=function(self)
				self:zoom(3*itg_magnify):y(-150):z(-050):customtexturerect(0.2,0,1.2,1):texcoordvelocity(0.06,0):diffuse( ColorLightTone(streakcolor) ):diffusealpha(0.1)
			end;
			UpdateColoringMessageCommand=function(s) s:finishtweening():linear(0.5):diffuse( ColorLightTone(streakcolor) ):diffusealpha(0.1) end;
		},
		
		LoadActor("TICKS")..{
			InitCommand=function(self)
				self:zoom(3*itg_magnify):y(-50):z(-050):customtexturerect(0.9,0,1.9,1):texcoordvelocity(0.06,0):diffuse( ColorLightTone(streakcolor) ):diffusealpha(0.1)
			end;
			UpdateColoringMessageCommand=function(s) s:finishtweening():linear(0.5):diffuse( ColorLightTone(streakcolor) ):diffusealpha(0.1) end;
		},

		-- bottom blocks 
		
		LoadActor("BLOCK")..{
			InitCommand=function(self)
				self:zoom(3*itg_magnify):y(100):z(-350):customtexturerect(0.5,0,1.5,1):texcoordvelocity(-0.06,0):diffuse(streakcolor):diffusealpha(0.05)
			end;
			UpdateColoringMessageCommand=function(s) s:finishtweening():linear(0.5):diffuse(streakcolor):diffusealpha(0.05) end;
		},
		
		LoadActor("ARROWS")..{
			InitCommand=function(self)
				self:zoom(3*itg_magnify):y(100):z(-200):customtexturerect(0.0,0,1.0,1):texcoordvelocity(0.03,0):diffuse(streakcolor):diffusealpha(0.1)
			end;
			UpdateColoringMessageCommand=function(s) s:finishtweening():linear(0.5):diffuse(streakcolor):diffusealpha(0.1) end;
		},
		
		LoadActor("TICKS")..{
			InitCommand=function(self)
				self:zoom(3*itg_magnify):y(150):z(-200):customtexturerect(0.8,0,1.8,1):texcoordvelocity(0.03,0):diffuse(streakcolor):diffusealpha(0.1)
			end;
			UpdateColoringMessageCommand=function(s) s:finishtweening():linear(0.5):diffuse(streakcolor):diffusealpha(0.1) end;
		},
		
		LoadActor("ARROWS")..{
			InitCommand=function(self)
				self:zoomx(1.5*itg_magnify):zoomy(3*itg_magnify):y(200):z(-100):customtexturerect(0.1,0,0.6,1):texcoordvelocity(0.06,0):diffuse( ColorLightTone(streakcolor) ):diffusealpha(0.2)
			end;
			UpdateColoringMessageCommand=function(s) s:finishtweening():linear(0.5):diffuse( ColorLightTone(streakcolor) ):diffusealpha(0.2) end;
		},
		
		LoadActor("BLOCK")..{
			InitCommand=function(self)
				self:zoom(3*itg_magnify):y(150):z(-050):customtexturerect(0.4,0,1.4,1):texcoordvelocity(0.06,0):diffuse( ColorLightTone(streakcolor) ):diffusealpha(0.1)
			end;
			UpdateColoringMessageCommand=function(s) s:finishtweening():linear(0.5):diffuse( ColorLightTone(streakcolor) ):diffusealpha(0.1) end;
		},
		
		LoadActor("TICKS")..{
			InitCommand=function(self)
				self:zoom(3*itg_magnify):y(50):z(-050):customtexturerect(0.8,0,1.8,1):texcoordvelocity(0.06,0):diffuse( ColorLightTone(streakcolor) ):diffusealpha(0.1)
			end;
			UpdateColoringMessageCommand=function(s) s:finishtweening():linear(0.5):diffuse( ColorLightTone(streakcolor) ):diffusealpha(0.1) end;
		}
	}
}
