local ex = ""
if GAMESTATE:IsAnExtraStage() then
  ex = "ex_"
end
local jk = LoadModule "Jacket.lua"
local LastStyle = nil

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
      InitCommand=function(s) s:diffuse(Color.Black):setsize(240,240):xy(-2,-4) end,
    },
    Def.Banner{
      SetCommand=function(self,params)
        self:finishtweening()
        local song = GAMESTATE:GetCurrentSong();
        local so = GAMESTATE:GetSortOrder();
        local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
        if not mw then return end
        if song then
          local bg = song:GetSongDir()
          local bgvideo = {}
          local listing = FILEMAN:GetDirListing(bg, false, true)
          if listing then
            for _,file in pairs(listing) do
              if ActorUtil.GetFileType(file) == 'FileType_Movie' then
                table.insert(bgvideo,file)
              end
            end
            if #bgvideo ~= 0 then
              self:Load(bgvideo[1])
            else
              self:LoadFromCached("jacket",jk.GetSongGraphicPath(song,"Jacket"))
            end
          else
            self:LoadFromCached("jacket",jk.GetSongGraphicPath(song,"Jacket"))
          end
        elseif mw:GetSelectedType() == 'WheelItemDataType_Random' then
          self:LoadFromCached("jacket",THEME:GetPathG("","_jackets/Random"))
        elseif mw:GetSelectedType() == 'WheelItemDataType_Roulette' then
          self:LoadFromCached("jacket",THEME:GetPathG("","_jackets/Roulette"))
        elseif mw:GetSelectedType() == 'WheelItemDataType_Custom' then
          self:LoadFromCached("jacket",THEME:GetPathG("","_jackets/COURSE"))
        elseif mw:GetSelectedType() == 'WheelItemDataType_Section' then
          self:LoadFromCached("jacket",jk.GetGroupGraphicPath(mw:GetSelectedSection(),"Jacket",so))
        else
          self:LoadFromCached("jacket", THEME:GetPathG("","MusicWheelItem fallback") );
        end;
        self:scaletofit(-120,-120,120,120):xy(-2,-4)
          end;
    };
    LoadFont("_avenirnext lt pro bold/46px")..{
        InitCommand=function(s) s:y(-20):diffusealpha(1):maxwidth(200):diffusebottomedge(color("#d8d8d8")):diffusetopedge(color("#8c8c8c")):strokecolor(Color.Black) end,
        SetMessageCommand=function(self,params)
          local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
          local so = GAMESTATE:GetSortOrder();
          if mw and  mw:GetSelectedType() == "WheelItemDataType_Section" then
            local group = mw:GetSelectedSection()
            if so == "SortOrder_Genre" then
              self:settext(group)
            else
              self:settext("")
            end;
          else
            self:settext("")
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
        s:setsize(478,150):xy(-24,-20):diffuse(Color.Black) end,
    },
    Def.Banner{
      SetCommand=function(self,params)
        self:finishtweening()
        local song = GAMESTATE:GetCurrentSong();
        local so = GAMESTATE:GetSortOrder();
        local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
        if not mw then return end
        if song then
		  setenv("getgroupname","song");
		--Banner cache has been disabled because of severe artifacting it can cause
          --self:LoadFromCached("banner",jk.GetSongGraphicPath(song,"Banner"))
          self:Load(jk.GetSongGraphicPath(song,"Banner"))
        elseif mw:GetSelectedType() == 'WheelItemDataType_Random' then
		setenv("getgroupname","random");
		self:LoadFromCached("banner",THEME:GetPathG("","_banners/Random"))
        elseif mw:GetSelectedType() == 'WheelItemDataType_Roulette' then
		setenv("getgroupname","random");
		self:LoadFromCached("banner",THEME:GetPathG("","_banners/Roulette"))
        elseif mw:GetSelectedType() == 'WheelItemDataType_Custom' then
		setenv("getgroupname","course");
		self:LoadFromCached("banner",THEME:GetPathG("","_banners/COURSE"))
        elseif mw:GetSelectedType() == 'WheelItemDataType_Section' then
		setenv("getgroupname",mw:GetSelectedSection());
          self:LoadFromCached("banner",jk.GetGroupGraphicPath(mw:GetSelectedSection(),"Banner",so))
        else
		self:visible(false)
        end;
        self:scaletofit(-239,-75,239,75):xy(-24,-20)
      end;
    };
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
    };
    Def.BitmapText{
      Font="_avenirnext lt pro bold/46px";
		  InitCommand=function(s) s:xy(-20,-20):diffusealpha(1):maxwidth(460):diffusebottomedge(color("#d8d8d8")):diffusetopedge(color("#8c8c8c")):strokecolor(Color.Black) end,
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
	  };
    loadfile(THEME:GetPathB("ScreenSelectMusic","overlay/_CDTITLE.lua"))(180,-70)..{
      InitCommand=function(s)
        s:visible(ThemePrefs.Get("CDTITLE")):draworder(1)
      end,
    }
  };
};
