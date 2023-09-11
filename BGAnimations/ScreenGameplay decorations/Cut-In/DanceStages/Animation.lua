local pn = ({...})[1] --only argument to file
local short_pn = ToEnumShortString(pn)
local sizemod = 2.25
local doublemod = 204
local style = GAMESTATE:GetCurrentStyle():GetStyleType();

local maskfile = {
	P1 = THEME:GetPathB("ScreenGameplay", "decorations/Cut-In/DanceStages/_Mask_down"),
	P2 = THEME:GetPathB("ScreenGameplay", "decorations/Cut-In/DanceStages/_Mask_up")
}

maskfile = maskfile[short_pn]

local versus_y = {
	P1 = -(130*sizemod),
	P2 = 230*sizemod
}
versus_y = versus_y[short_pn]

local t = Def.ActorFrame{};

local charComboA   = "/Characters/"..WhichRead(pn).."/Cut-In/comboA.png";
local charComboB   = "/Characters/"..WhichRead(pn).."/Cut-In/comboB.png";
local charCombo100 = "/Characters/"..WhichRead(pn).."/Cut-In/combo100.png";
local charCircles  = "/Characters/"..WhichRead(pn).."/Cut-In/Tex_0035.png";
local charColor    = "/Characters/"..WhichRead(pn).."/Cut-In/Tex_0036.png";
local charLight    = "/Characters/"..WhichRead(pn).."/Cut-In/Tex_0037.png";

t[#t+1] = Def.ActorFrame{
  ComboChangedMessageCommand=function(self, params)
    if params.Player ~= pn then return end
    local tapsAndHolds = GAMESTATE:GetCurrentSteps(params.Player):GetRadarValues(params.Player)
    	:GetValue('RadarCategory_TapsAndHolds')
    local CurCombo = params.PlayerStageStats:GetCurrentCombo()
    if CurCombo == 0 or CurCombo == params.OldCombo then
    	return
    elseif CurCombo == math.floor(tapsAndHolds/2)
    	or CurCombo == math.floor(tapsAndHolds*0.9) then
      self:playcommand("Popup", {type='B'})
    elseif CurCombo % 100 == 0 then
      self:playcommand("Popup", {type='C'})
    elseif CurCombo == 20 or (CurCombo % 50 == 0) then
      self:playcommand("Popup", {type='A'})
    end;
  end;

------------------
-- Mask --
	Def.Sprite{
		InitCommand=function(self)
		self:clearzbuffer(true);
		self:zwrite(true);
		self:blend('BlendMode_NoEffect');
			if style == "StyleType_TwoPlayersTwoSides" or GAMESTATE:GetPlayMode() == 'PlayMode_Rave' then
				self:Load(maskfile);
			else
				self:visible(false);
			end
		end
	};
-----------------------------
-- Cutin background --
Def.Sprite{
  Texture=charColor,
  InitCommand=function(self)
    self:setsize(200*sizemod,SCREEN_HEIGHT+(100*sizemod))
    self:diffusealpha(0)
	self:texcoordvelocity(-0.2,0)
	self:texcoordvelocity(-0.053,0) 
	self:texcoordvelocity(-0.053,0) 
	self:texcoordvelocity(-0.053,0)  
	self:texcoordvelocity(-0.053,0)  
	self:texcoordvelocity(-0.053,0)  
	self:texcoordvelocity(-0.053,0)  
	self:texcoordvelocity(-0.053,0)  
	self:texcoordvelocity(-0.053,0)  
	self:texcoordvelocity(-0.053,0)  
	self:texcoordvelocity(-0.053,0)  
	self:texcoordvelocity(-0.053,0)  
	self:texcoordvelocity(-0.053,0)  
	self:texcoordvelocity(-0.053,0)  
	self:texcoordvelocity(-0.053,0)  
	self:texcoordvelocity(-0.053,0)  
	self:texcoordvelocity(-0.053,0)  
	self:texcoordvelocity(-0.053,0)  
	self:texcoordvelocity(-0.053,0)  
	self:texcoordvelocity(-0.053,0)  
	self:texcoordvelocity(-0.2,0)
    self:MaskDest();
	if style == "StyleType_OnePlayerTwoSides" then
		self:x(pn== PLAYER_1 and -(doublemod*sizemod) or doublemod*sizemod)
	end
  end;
	PopupCommand=function(self)
		self:finishtweening();
		self:linear(0.2);
		self:diffusealpha(1);
		--self:diffuse(unpack(charColor));
		self:diffusealpha(0.9);
		self:sleep(1);
		self:linear(0.2);
		self:diffusealpha(0);
	end;
};
---------------------------

-- 100 Combos character Sprite
Def.Sprite {
  InitCommand=function(self)
    self:MaskDest();
    self:diffusealpha(0);
    self:zoom(1)
    if style == "StyleType_TwoPlayersTwoSides" or GAMESTATE:GetPlayMode() == 'PlayMode_Rave' then
      self:y(versus_y)
    end
	if style == "StyleType_OnePlayerTwoSides" then
		self:x(pn== PLAYER_1 and -(doublemod*sizemod) or doublemod*sizemod)
	end
    --this forces StepMania to have these all in memory so gameplay doesn't freeze up
    self:Load(charComboA)
    self:Load(charComboB)
    self:Load(charCombo100)
  end;
  PopupCommand=function(self, params)
  	if params.type == 'A' then
  		self:Load(charComboA)
		self:scaletoclipped(200*sizemod,SCREEN_HEIGHT)
  	elseif params.type == 'B' then
  		self:Load(charComboB)
		self:scaletoclipped(200*sizemod,SCREEN_HEIGHT)
  	elseif params.type == 'C' then
  		self:Load(charCombo100)
		self:scaletoclipped(200*sizemod,SCREEN_HEIGHT)
  	end
    self:finishtweening();
	self:addy(13);
  	self:sleep(0.1);
  	self:linear(0.1);
  	self:diffusealpha(1);
  	self:linear(1);
  	self:addy(-13)
  	self:linear(0.1);
  	self:diffusealpha(0);
end;
};

-- Light
Def.Sprite{
        Texture=charLight,
	InitCommand=function(self)
		self:MaskDest()
		self:diffusealpha(0)
		self:blend('BlendMode_Add')
		self:setsize(200*sizemod,SCREEN_HEIGHT)
		if style == "StyleType_TwoPlayersTwoSides" or GAMESTATE:GetPlayMode() == 'PlayMode_Rave' then
			self:y(versus_y)
		end
		if style == "StyleType_OnePlayerTwoSides" then
			self:x(pn== PLAYER_1 and -(doublemod*sizemod) or doublemod*sizemod)
		end
	end;
	PopupCommand=function(self)
		self:finishtweening();
		self:sleep(0);
		self:linear(0.2);
		self:diffusealpha(0.5);
		self:sleep(0.8);
		self:linear(0.2);
		self:diffusealpha(0);
	end;
};

Def.ActorFrame {
	InitCommand=function(self)
		self:MaskDest()
	--	self:diffuse(CutInColor())
		if style == "StyleType_TwoPlayersTwoSides" or GAMESTATE:GetPlayMode() == 'PlayMode_Rave' then
			self:y(versus_y)
    	end;
		if style == "StyleType_OnePlayerTwoSides" then
			self:x(pn== PLAYER_1 and -(doublemod*sizemod) or doublemod*sizemod)
		end
	end;
	-- Left 1
        Def.Sprite{
           Texture=charCircles,
		InitCommand=cmd(diffusealpha,0;blend,'BlendMode_Add';vertalign,top);
		PopupCommand=function(self)
			self:finishtweening();
			self:sleep(0.17);
			self:diffusealpha(1);
			self:x(-(85*sizemod));
			self:y(90*sizemod);
			self:zoomx(0.7);
			self:zoomy(2.2);
			self:linear(0.4);
			self:y(-150);
			self:diffusealpha(0);
		end;
	};
	-- Right 1
        Def.Sprite{
            Texture=charCircles,
		InitCommand=cmd(diffusealpha,0;blend,'BlendMode_Add';vertalign,top);
		PopupCommand=function(self)
			self:finishtweening();
			self:sleep(0.17);
			self:diffusealpha(1);
			self:x(60*sizemod);
			self:y(155*sizemod);
			self:zoomx(0.95);
			self:zoomy(1.6);
			self:linear(0.4);
			self:y(-10);
			self:diffusealpha(0);
		end;
	};
	-- Center 2 Right
        Def.Sprite{
          Texture=charCircles,
		InitCommand=cmd(diffusealpha,0;blend,'BlendMode_Add';vertalign,top);
		PopupCommand=function(self)
			self:finishtweening();
			self:sleep(0.33);
			self:diffusealpha(1);
			self:x(10*sizemod);
			self:y(150*sizemod);
			self:zoomx(0.8);
			self:zoomy(1.75);
			self:linear(0.4);
			self:y(-30);
			self:diffusealpha(0);
		end;
	};
	-- Center 2 Left
        Def.Sprite{
                Texture=charCircles,
		InitCommand=cmd(diffusealpha,0;blend,'BlendMode_Add';vertalign,top);
		PopupCommand=function(self)
			self:finishtweening();
			self:sleep(0.33);
			self:diffusealpha(1);
			self:x(-(40*sizemod));
			self:y(210*sizemod);
			self:zoomx(0.8);
			self:zoomy(1);
			self:linear(0.4);
			self:y(110);
			self:diffusealpha(0);
		end;
	};
	-- Right 3
        Def.Sprite{
                Texture=charCircles,
		InitCommand=cmd(diffusealpha,0;blend,'BlendMode_Add';vertalign,top);
		PopupCommand=function(self)
			self:finishtweening();
			self:sleep(0.53);
			self:diffusealpha(1);
			self:x(70*sizemod);
			self:y(120*sizemod);
			self:zoomx(0.6);
			self:zoomy(2.07);
			self:linear(0.4);
			self:y(-120);
			self:diffusealpha(0);
		end;
	};
	-- Left 3 big
        Def.Sprite{
                Texture=charCircles,
		InitCommand=cmd(diffusealpha,0;blend,'BlendMode_Add';vertalign,top);
		PopupCommand=function(self)
			self:finishtweening();
			self:sleep(0.5);
			self:diffusealpha(1);
			self:x(-(75*sizemod));
			self:y(-(90*sizemod));
			self:zoomx(1);
			self:zoomy(4.45);
			self:linear(0.4);
			self:y(-320);
			self:diffusealpha(0);
		end;
	};
	-- Left 4
        Def.Sprite{
                Texture=charCircles,
		InitCommand=cmd(diffusealpha,0;blend,'BlendMode_Add';vertalign,top);
		PopupCommand=function(self)
			self:finishtweening();
			self:sleep(0.63);
			self:diffusealpha(1);
			self:x(-(75*sizemod));
			self:y(85*sizemod);
			self:zoomx(1.2);
			self:zoomy(2.2);
			self:linear(0.4);
			self:y(-150);
			self:diffusealpha(0);
		end;
	};
	-- Right 4 small
        Def.Sprite{
                Texture=charCircles,
		InitCommand=cmd(diffusealpha,0;blend,'BlendMode_Add';vertalign,top);
		PopupCommand=function(self)
			self:finishtweening();
			self:sleep(0.63);
			self:diffusealpha(1);
			self:x(40*sizemod);
			self:y(185*sizemod);
			self:zoomx(0.6);
			self:zoomy(1.1);
			self:linear(0.4);
			self:y(85);
			self:diffusealpha(0);
		end;
	};
	-- Right 5 big
        Def.Sprite{
                Texture=charCircles,
		InitCommand=cmd(diffusealpha,0;blend,'BlendMode_Add';vertalign,top);
		PopupCommand=function(self)
			self:finishtweening();
			self:sleep(0.86);
			self:diffusealpha(1);
			self:x(70*sizemod);
			self:y(20*sizemod);
			self:zoomx(0.9);
			self:zoomy(3);
			self:linear(0.4);
			self:y(-190);
			self:diffusealpha(0);
		end;
	};
	-- Left 5
        Def.Sprite{
                Texture=charCircles,
		InitCommand=cmd(diffusealpha,0;blend,'BlendMode_Add';vertalign,top);
		PopupCommand=function(self)
			self:finishtweening();
			self:sleep(0.86);
			self:diffusealpha(1);
			self:x(-(30*sizemod));
			self:y(150*sizemod);
			self:zoomx(0.6);
			self:zoomy(1.7);
			self:linear(0.4);
			self:y(-25);
			self:diffusealpha(0);
		end;
	};
};
};
--end;

return t;
