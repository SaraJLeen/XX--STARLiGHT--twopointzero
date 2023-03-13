local ex = ""
if GAMESTATE:IsAnExtraStage() then
  ex = "ex_"
end
local jk = LoadModule "Jacket.lua"
local LastStyle = nil

--Banner cache has been disabled because of severe artifacting it can cause
local cached_banners = false

return Def.ActorFrame{
--Jacket
  Def.ActorFrame{
    InitCommand=function(s) s:xy(_screen.cx-256,_screen.cy-254):visible(IsUsingWideScreen()) end,
    OnCommand=function(s) s:addy(-800):sleep(0.4):decelerate(0.5):addy(800) end,
    OffCommand=function(s) s:sleep(0.3):decelerate(0.5):addy(-800) end,
    CurrentSongChangedMessageCommand=function(s) s:finishtweening():queuecommand("Set") end,
    Def.Sprite{
      Texture=ex.."Jacket Backer",
    },
    Def.Quad{
      InitCommand=function(s) s:diffuse(Color.Black):setsize(240,240):scaletofit(-120,-120,120,120):xy(-2,-4) end,
    },
    Def.Banner{
      SetCommand=function(self,params)
        self:finishtweening()
        local song = GAMESTATE:GetCurrentSong();
        local so = GAMESTATE:GetSortOrder();
        local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
        if not mw then return end
        if song then
          if song:HasPreviewVid() then
            self:Load(song:GetPreviewVidPath())
          else
            self:LoadFromCached("jacket",jk.GetSongGraphicPath(song,"Jacket"))
          end
        elseif mw:GetSelectedType() == 'WheelItemDataType_Random' then
          self:LoadFromCached("jacket",THEME:GetPathG("","_jackets/Random"))
        elseif mw:GetSelectedType() == 'WheelItemDataType_Roulette' then
          self:LoadFromCached("jacket",THEME:GetPathG("","_jackets/Roulette"))
        elseif mw:GetSelectedType() == 'WheelItemDataType_Custom' then
          self:LoadFromCached("jacket",THEME:GetPathG("","_jackets/COURSE"))
        elseif mw:GetSelectedSection() == "<Favorites>" then
          if #GAMESTATE:GetEnabledPlayers() < 2 then self:LoadFromCached("jacket",THEME:GetPathG("","_jackets/favesbg"))
          else self:LoadFromCached("jacket",THEME:GetPathG("","_jackets/favorites")) end
        elseif mw:GetSelectedType() == 'WheelItemDataType_Section' then
          self:LoadFromCached("jacket",jk.GetGroupGraphicPath(mw:GetSelectedSection(),"Jacket",so))
        else
          self:LoadFromCached("jacket", THEME:GetPathG("","MusicWheelItem fallback") );
        end;
        self:scaletofit(-120,-120,120,120):xy(-2,-4)
          end;
    },
	Def.Sprite {
		SetCommand=function(self)
			if GAMESTATE:GetCurrentSong() then self:visible(false) return end
			if #GAMESTATE:GetEnabledPlayers()>1 then self:visible(false) return end
			local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
			if not mw then self:visible(false) return end
			if mw:GetSelectedSection() ~= "<Favorites>" then self:visible(false) return end
			for _, pn in pairs(GAMESTATE:GetEnabledPlayers()) do
				if not PROFILEMAN:IsPersistentProfile(pn) then self:visible(false) return end
				self:Load(LoadModule("Options.GetProfileData.lua")(GetProfileIDForPlayer(pn),true)["Image"]);
				self:scaletofit(-120,-120,120,120):xy(-2,-4)
				self:visible(true)
			end
		end,
	},
    LoadFont("_avenirnext lt pro bold/46px")..{
        InitCommand=function(s) s:y(-20):visible(true):maxwidth(200):diffusebottomedge(color("#d8d8d8")):diffusetopedge(color("#8c8c8c")):strokecolor(Color.Black) end,
        SetMessageCommand=function(self,params)
          local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
          local so = GAMESTATE:GetSortOrder();
          if mw and  mw:GetSelectedType() == "WheelItemDataType_Section" then
            local group = mw:GetSelectedSection()
            if so == "SortOrder_Genre" then
              self:settext(group):visible(true)
            else
              self:settext(""):visible(false)
            end;
          else
            self:settext(""):visible(false)
          end
        end,
      };
  };
  
  --Banner
  Def.ActorFrame{
    InitCommand=function(s) s:xy(SCREEN_LEFT+286,_screen.cy-254) end,
    OnCommand=function(s) s:addx(-800):sleep(0.3):decelerate(0.3):addx(800) end,
    OffCommand=function(s) s:sleep(0.3):decelerate(0.3):addx(-800) end,
    CurrentSongChangedMessageCommand=function(s) s:finishtweening():queuecommand("Set") end,
    Def.Quad{
      InitCommand=function(s)
        s:setsize(478,150):scaletofit(-239,-75,239,75):xy(-24,-20):diffuse(Color.Black) end,
    },
    Def.Banner{
      SetCommand=function(self,params)
        self:finishtweening()
        local song = GAMESTATE:GetCurrentSong();
        local so = GAMESTATE:GetSortOrder();
        local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
        if not mw then return end
        --self:visible(true)
        if song then
		  setenv("getgroupname","song");
            if cached_banners then
              self:LoadFromCached("banner",jk.GetSongGraphicPath(song,"Banner"))
            else
          self:Load(jk.GetSongGraphicPath(song,"Banner"))
            end
        elseif mw:GetSelectedType() == 'WheelItemDataType_Random' then
		setenv("getgroupname","random");
		self:LoadFromCached("banner",THEME:GetPathG("","_banners/Random"))
        elseif mw:GetSelectedType() == 'WheelItemDataType_Roulette' then
		setenv("getgroupname","random");
		self:LoadFromCached("banner",THEME:GetPathG("","_banners/Roulette"))
        elseif mw:GetSelectedType() == 'WheelItemDataType_Custom' then
		setenv("getgroupname","course");
		self:LoadFromCached("banner",THEME:GetPathG("","_banners/COURSE"))
        elseif mw:GetSelectedSection() == "<Favorites>" then
		setenv("getgroupname","favorites");
		if #GAMESTATE:GetEnabledPlayers() > 1 then self:LoadFromCached("banner",THEME:GetPathG("","_banners/favesbg"))
		else self:LoadFromCached("banner",THEME:GetPathG("","_banners/favorites")) end
        elseif mw:GetSelectedType() == 'WheelItemDataType_Section' then
		setenv("getgroupname",mw:GetSelectedSection());
          self:LoadFromCached("banner",jk.GetGroupGraphicPath(mw:GetSelectedSection(),"Banner",so))
        else
            self:LoadFromCached("banner", THEME:GetPathG("","MusicWheelItem fallback") );
		--self:visible(false)
        end;
        self:scaletofit(-239,-75,239,75):xy(-24,-20)
        self:scaletofit(-239,-75,239,75):xy(-24,-20)
      end;
    },
	Def.Sprite {
		SetCommand=function(self)
			if GAMESTATE:GetCurrentSong() then self:visible(false) return end
			if #GAMESTATE:GetEnabledPlayers()<2 then self:visible(false) return end
			local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
			if not mw then self:visible(false) return end
			if mw:GetSelectedSection() ~= "<Favorites>" then self:visible(false) return end
			local found_player = false
			for _, pn in pairs(GAMESTATE:GetEnabledPlayers()) do
				if pn == PLAYER_1 then found_player = true end
			end
			if not found_player then self:visible(false) return end
			if not PROFILEMAN:IsPersistentProfile(PLAYER_1) then self:visible(false) return end
			self:Load(LoadModule("Options.GetProfileData.lua")(GetProfileIDForPlayer(PLAYER_1),true)["Image"]);
			self:scaletofit(-75,-75,75,75)
			self:xy(-187,-19)
			self:visible(true)
		end,
	},
	Def.Sprite {
		SetCommand=function(self)
			if GAMESTATE:GetCurrentSong() then self:visible(false) return end
			if #GAMESTATE:GetEnabledPlayers()<2 then self:visible(false) return end
			local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
			if not mw then self:visible(false) return end
			if mw:GetSelectedSection() ~= "<Favorites>" then self:visible(false) return end
			local found_player = false
			for _, pn in pairs(GAMESTATE:GetEnabledPlayers()) do
				if pn == PLAYER_2 then found_player = true end
			end
			if not found_player then self:visible(false) return end
			if not PROFILEMAN:IsPersistentProfile(PLAYER_2) then self:visible(false) return end
			self:Load(LoadModule("Options.GetProfileData.lua")(GetProfileIDForPlayer(PLAYER_2),true)["Image"]);
			self:scaletofit(-75,-75,75,75)
			self:xy(139,-19)
			self:visible(true)
		end,
	},
    Def.Sprite{
      Texture=ex.."BannerFrame",
    },
    Def.Sprite{
      OnCommand=function(self)
        local style = GAMESTATE:GetCurrentStyle():GetStyleType()
        if style == 'StyleType_OnePlayerOneSide' then
          self:Load(THEME:GetPathB("","ScreenEvaluationSummary decorations/1Pad"))
        else
          self:Load(THEME:GetPathB("","ScreenEvaluationSummary decorations/2Pad"))
        end;
        LastStyle = style
        self:xy(-210,85):zoom(0.6)
      end;
	SetMessageCommand=function(self,params)
		local style = GAMESTATE:GetCurrentStyle():GetStyleType()
		if style == 'StyleType_OnePlayerOneSide' then
			if style ~= LastStyle then
				self:Load(THEME:GetPathB("","ScreenEvaluationSummary decorations/1Pad"))
				self:zoom(0.7)
				self:accelerate(0.2):zoom(0.8)
				self:decelerate(0.3):zoom(0.6)
				self:xy(-210,85):zoom(0.6)
			end
		else
			if style ~= LastStyle then
				self:Load(THEME:GetPathB("","ScreenEvaluationSummary decorations/2Pad"))
				self:zoom(0.7)
				self:accelerate(0.2):zoom(0.8)
				self:decelerate(0.3):zoom(0.6)
				self:xy(-210,85):zoom(0.6)
			end
		end;
		LastStyle = style
	end;
    },
    Def.BitmapText{
      Font="_avenirnext lt pro bold/46px";
		  InitCommand=function(s) s:xy(-20,-20):visible(true):maxwidth(460):diffusebottomedge(color("#d8d8d8")):diffusetopedge(color("#8c8c8c")):strokecolor(Color.Black) end,
      SetMessageCommand=function(self,params)
        local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
        local so = GAMESTATE:GetSortOrder();
        if mw and mw:GetSelectedType() == "WheelItemDataType_Section" then
		if so == "SortOrder_Genre" then
            self:settext(mw:GetSelectedSection())
            self:visible(true)
			    else
            self:visible(false)
			    end;
		    else
          self:visible(false)
        end
      end,
	  },
    loadfile(THEME:GetPathB("ScreenSelectMusic","overlay/_CDTITLE.lua"))(180,-70)..{
      InitCommand=function(s)
        s:visible(ThemePrefs.Get("CDTITLE")):draworder(1)
      end,
    }
  };
};
