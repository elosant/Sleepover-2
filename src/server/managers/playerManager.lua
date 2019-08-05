-- Handles revivals and initial spawn.
-- Services
local playersService = game:GetService("Players")

local PlayerManager = {}

local function onPlayerAdded(player)
	player:LoadCharacter()
end

function PlayerManager.init()
	for _, player in pairs(playersService:GetPlayers()) do
		onPlayerAdded(player)
	end

	playersService.PlayerAdded:Connect(onPlayerAdded)
end

return PlayerManager
