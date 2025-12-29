local ex = ""
if GAMESTATE:IsAnExtraStage() then
  ex = "ex_"
end
local jk = LoadModule "Jacket.lua"

return Def.ActorFrame{
    CurrentSongChangedMessageCommand=function(s) 
        s:finishtweening()
        local Jacket = s:GetChild("Jacket")
        local Banner = s:GetChild("BannerArea")

        local song = GAMESTATE:GetCurrentSong()
        local so = GAMESTATE:GetSortOrder()
        local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")

        if not mw then return end

        if song then
			setenv("getgroupname","song");
            Jacket:GetChild("Graphic"):Load(jk.GetSongGraphicPath(song,"Jacket"))
            --Banner:GetChild("Graphic"):Load(jk.GetSongGraphicPath(song,"Banner"))
        else
            if mw:GetSelectedType('WheelItemDataType_Section') then
                if mw:GetSelectedSection() ~= "" then
                	setenv("getgroupname",mw:GetSelectedSection());
                    --Banner:GetChild("Graphic"):Load(jk.GetGroupGraphicPath(mw:GetSelectedSection(),"Banner",GAMESTATE:GetSortOrder()))
                    Jacket:GetChild("Graphic"):Load(jk.GetGroupGraphicPath(mw:GetSelectedSection(),"Jacket",GAMESTATE:GetSortOrder()))
                else
                    if mw:GetSelectedType() == 'WheelItemDataType_Random' then
                    	setenv("getgroupname","random");
                        --Banner:GetChild("Graphic"):Load(THEME:GetPathG("","_banners/random"))
                        Jacket:GetChild("Graphic"):Load(THEME:GetPathG("","_jackets/random"))
                    elseif mw:GetSelectedType() == 'WheelItemDataType_Roulette' then
                    	setenv("getgroupname","roulette");
                        --Banner:GetChild("Graphic"):Load(THEME:GetPathG("","_banners/roulette"))
                        Jacket:GetChild("Graphic"):Load(THEME:GetPathG("","_jackets/roulette"))
                    elseif mw:GetSelectedType('WheelItemDataType_Custom') then
                    	setenv("getgroupname","course");
                        --Banner:GetChild("Graphic"):Load(THEME:GetPathG("","_banners/COURSE"))
                        Jacket:GetChild("Graphic"):Load(THEME:GetPathG("","_jackets/COURSE"))
                    end
                end
            end
        if not GAMESTATE:GetCurrentSong() and mw:GetSelectedSection() == "<Favorites>" then
			setenv("getgroupname","favorites");
			if #GAMESTATE:GetEnabledPlayers() > 1 then Banner:GetChild("Graphic"):Load(THEME:GetPathG("","_banners/favesbg"))
			else Banner:GetChild("Graphic"):Load(THEME:GetPathG("","_banners/favorites")) end
			if #GAMESTATE:GetEnabledPlayers() < 2 then Jacket:GetChild("Graphic"):Load(THEME:GetPathG("","_jackets/favesbg"))
			else Jacket:GetChild("Graphic"):Load(THEME:GetPathG("","_jackets/favorites")) end
			Banner:GetChild("Graphic"):visible(true)
		else
			Banner:GetChild("Graphic"):visible(false):z(-10000)
		end
        end
        Jacket:GetChild("Graphic"):scaletofit(-120,-120,120,120)
        Banner:GetChild("Graphic"):scaletofit(-239,-75,239,75):xy(-24,-20)
        s:queuecommand("Set")
    end,
    Def.ActorFrame{
        Name="Jacket",
        InitCommand=function(s) 
            s:visible(IsUsingWideScreen())
            :xy(_screen.cx-256,_screen.cy-254)
        end,
        OnCommand=function(s) s:addy(-800):sleep(0.4):decelerate(0.5):addy(800) end,
        OffCommand=function(s) s:sleep(0.3):decelerate(0.5):addy(-800) end,
        Def.Sprite{
            Texture=ex.."Jacket Backer",
        },
        Def.Sprite{
            Name="Graphic",
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
				self:scaletofit(-120,-120,120,120):xy(0,0)
				self:visible(true)
			end
		end,
	},
    Def.BitmapText{
      Font="_avenirnext lt pro bold/46px",
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
    }
    },
    Def.ActorFrame{
        Name="BannerArea",
        InitCommand=function(s) s:xy(SCREEN_LEFT+286,_screen.cy-254) end,
        OnCommand=function(s) s:addx(-800):sleep(0.3):decelerate(0.3):addx(800) end,
        OffCommand=function(s) s:sleep(0.3):decelerate(0.3):addx(-800) end,
        Def.Quad{
            InitCommand=function(s) s:setsize(478,150):xy(-24,-20):diffuse(Color.Black) end,
        },
        Def.Sprite{
            Name="Graphic",
            --SetCommand=function(s) s:visible(false):opacity(0.0) end,
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
            Name="Style",
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
        loadfile(THEME:GetPathB("ScreenSelectMusic","decorations/_shared/_CDTITLE.lua"))(180,-70)..{
            InitCommand=function(s)
              s:visible(ThemePrefs.Get("CDTITLE")):draworder(1)
            end,
        }
    }
}