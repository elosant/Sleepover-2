-- Services
local playersService = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local starterGui = game:GetService("StarterGui")
local runService = game:GetService("RunService")

-- Player
local player = playersService.LocalPlayer
local playerScripts = player.PlayerScripts

local client = playerScripts.client

local managers = client.managers
local controllers = client.controllers
local story = client.story
local systems = client.systems

local shared = replicatedStorage.shared

local sharedUtil = shared.util
local moduleUtil = sharedUtil.moduleUtil
local requireModule = require(moduleUtil.requireModule)

local sharedLib = shared.lib
local networkLib = require(sharedLib.networkLib)

-- Disable reset
delay(nil, function()
	pcall(starterGui.SetCore, starterGui, "ResetButtonCallback", false)
end)

local excludedModules = {
}

-- Require (and init/update) modules.
for _, controllerModule in pairs(controllers:GetChildren()) do
	if not excludedModules[controllerModule.Name] then
		requireModule("controller", controllerModule)
	end
end

for _, storyModule in pairs(story:GetChildren()) do
	if not excludedModules[storyModule.Name] then
		requireModule("story_node", storyModule)
	end
end

for _, managerModule in pairs(managers:GetChildren()) do
	if not excludedModules[managerModule.Name] then
		requireModule("manager", managerModule)
	end
end

for _, systemModule in pairs(systems:GetChildren()) do
	if not excludedModules[systemModule.Name] then
		requireModule("system", systemModule)
	end
end
