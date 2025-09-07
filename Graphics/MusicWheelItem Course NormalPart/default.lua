local lights = Def.ActorFrame{}

for i=1,2 do
	lights[#lights+1] = Def.ActorFrame{
		Def.Sprite{
			Texture="light.png",
			InitCommand=function(s) s:x(i==1 and -290 or 290):rotationz(i==2 and 180 or 0):blend(Blend.Add):diffusealpha(0.6):addx(54.5):addy(0):z(99) end,
		};
	};
end

return Def.ActorFrame{
	InitCommand=function(s,p)
		if p.Type == "Course" then
			s:visible(true)
		else
			s:visible(false)
		end
	end, 
	Def.Sprite{
		Texture="coursebox",
	};
	Def.Sprite{
		Texture=THEME:GetPathG("","Common fallback banner");
		InitCommand=function(s) s:scaletoclipped(512,160):visible(false) end,
	};
	Def.Sprite {
		Name="SongBanner";
		InitCommand=function(s) s:scaletoclipped(512,160):x(54.5):y(0):z(100) end,
		SetMessageCommand=function(self,params)
			if params.Type == "Course" then
				self:LoadFromCached("Banner",params.Course:GetBannerPath());
				-- self:LoadFromCourse(params.Course);
			end
		end;
	};
	lights;
};
