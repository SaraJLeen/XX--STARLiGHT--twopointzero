local t = Def.ActorFrame{
  Def.Quad{
		InitCommand=function(s) s:diffuse(color("0,0,0,0")):FullScreen()
			SetUserPref("RandomRNG",'true');
			PREFSMAN:SetPreference('RandomBackgroundMode','RandomBackgroundMode_RandomMovies');
		end,
	};
};

return t;
