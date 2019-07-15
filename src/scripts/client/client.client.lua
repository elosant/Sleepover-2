-- Services
local playersService = game:GetService("Players")

-- Player
local player = playersService.LocalPlayer
local playerScripts = player:WaitForChild("PlayerScripts")

local client = playerScripts:WaitForChild("Client")
local managers = client.managers

for _, manager in pairs(managers:GetChildren()) do
	manager.Init()
end
