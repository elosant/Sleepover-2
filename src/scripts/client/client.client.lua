-- Services
local playersService = game:GetService("Players")

-- Player
local player = playersService.LocalPlayer
local playerScripts = player:WaitForChild("PlayerScripts")

local client = playerScripts:WaitForChild("client")
local managers = client.managers
local view = client.view

for _, managerModule in pairs(managers:GetChildren()) do
	require(managerModule).init()
end

