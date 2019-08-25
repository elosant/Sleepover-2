-- Services
local playersService = game:GetService("Players")

local playerRng = Random.new()
return function()
	local players = playersService:GetPlayers()
	return players[playerRng:NextInteger(1, #players)]
end
