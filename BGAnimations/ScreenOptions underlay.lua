local t = Def.ActorFrame{
  Def.Quad{
		InitCommand=function(s) s:diffuse(color("0,0,0,0")):FullScreen()
			SetUserPref("RandomRNG",'false');
			PREFSMAN:SetPreference('RandomBackgroundMode','RandomBackgroundMode_RandomMovies');
		end,
	};
};

return t;
