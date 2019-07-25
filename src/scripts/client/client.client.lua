-- Services
local playersService = game:GetService("Players")

-- Player
local player = playersService.LocalPlayer
local playerScripts = player:WaitForChild("PlayerScripts")

local client = playerScripts:WaitForChild("client")
local managers = client.managers
local controllers = client.controllers
local story = client.story

for _, controllerModule in pairs(controllers:GetChildren()) do
	spawn(function() require(controllerModule); end)
end

for _, storyModule in pairs(story:GetChildren()) do
	spawn(function() require(storyModule); end)
end

for _, managerModule in pairs(managers:GetChildren()) do
	spawn(function() require(managerModule).init(); end)
end

