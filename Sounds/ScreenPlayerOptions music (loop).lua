if GAMESTATE:GetSong() ~= nil then return GAMESTATE:GetSong():GetMusicPath() end
return "_silent"