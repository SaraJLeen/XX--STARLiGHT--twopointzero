-- Relative amount of meteors to create
local starriness = 1

-- Scale based on how much sky is visible
local nMeteors = ((_screen.h > 1080) and (_screen.h+260)/49 or _screen.w/64) * starriness

local t = Def.ActorFrame {
	LoadActor("background")..{
		OnCommand=function(s) s:Center():setsize(IsUsingWideScreen() and SCREEN_WIDTH or 1920,SCREEN_HEIGHT) end,
	};
}

local AFT1 = Def.ActorFrameTexture{
	InitCommand = function(self)
		self:SetTextureName( "AFT_Meteor" )

		-- These are the dimensions of the meteor textures.
		-- The dimensions of the AFT will be brought up to nearest power of 2,
		-- but the actual drawable space will be this.
		self:SetWidth(64):SetHeight(62)

		-- Enable transparency.
		self:EnableAlphaBuffer( false )

		self:Create()
	end,

	-- After the initializer command, any actors included inside will be projected.
	-- The actors here act exactly the same as a ActorFrame, so they will start on the top-left
	-- corner of the available draw area given.

	Def.Sprite {
		Texture = "meteor-arrow.png",
		InitCommand = function (s)
			-- Align the sprite to the AFT by its upper-left corner.
			s:valign(0):halign(0)
		end,
	},
}

local AFT2 = Def.ActorFrameTexture {
	InitCommand = function(self)
		self:SetTextureName( "AFT_Glow" )
		self:SetWidth(64):SetHeight(62)
		self:EnableAlphaBuffer( false )
		self:Create()
	end,
	Def.Sprite {
		Texture = "meteor-glow.png",
		InitCommand = function (s)
			s:valign(0):halign(0)
		end,
	},
}

t[#t+1] = AFT1
t[#t+1] = AFT2

for _ = 1, nMeteors do
	t[#t+1] = Def.ActorFrame{
		InitCommand = function(s)
			s:valign(1)
		end,
		OnCommand = function(s) s:sleep(math.random()*2):SetTextureFiltering(false):queuecommand("Animate") end,
		AnimateCommand = function(s)
			-- Random size between half- and full-size, weighted toward full
			s:zoom(0.5 + 0.5 * math.sqrt(math.random()))
			-- Appear somewhere random
			:xy(math.random(_screen.w)+40,math.random(_screen.h/2))
			-- Move in the direction of the arrow, slowing down when
			-- it starts to burn out.  (Note: this is slightly
			-- below the 42° angle of the arrow, because I like the
			-- resultant "falling" effect.)
			:linear(0.3):addx(-100):addy(100)
			:linear(0.15):addx(-60):addy(60)
			-- Wait a random amount of time
			:sleep(math.random()*5)
			-- and start again
			:queuecommand("Animate")
		end,

		Def.Sprite{
			-- Sprite name given inside the SetTextureName command in the AFT.
			Texture = "AFT_Meteor",
			InitCommand = function (s)
				s:blend("BlendMode_Add")
			end,
			AnimateCommand=function(s)
				-- Start partially visible
				s:diffusealpha(0)
				-- Come into sight
				:linear(0.15):diffusealpha(1)
				-- Let the glow brighten (see below)
				:sleep(0.15)
				-- Burn out
				:linear(0.15):diffusealpha(0)
			end,
		},
		Def.Sprite{
			-- Sprite name given inside the SetTextureName command in the AFT.
			Texture = "AFT_Glow",
			InitCommand = function (s)
				s:blend("BlendMode_Add")
			end,
			AnimateCommand=function(s)
				-- Glow is almost white, with a chance of being tinted slightly.
				-- Invisible to start with.
				s:diffuse(HSVA(360*math.random(), 0.5*math.random(), 1, 0))
				-- Don't start to glow until the meteor's fully visible
				:sleep(0.15)
				-- Flare up!
				:linear(0.15):diffusealpha(1)
				-- Burn out
				:linear(0.15):diffusealpha(0)
			end,
		}
	}
end

t[#t+1] = ClearZ
return t;
