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

local shared = replicatedStorage.shared

local sharedUtil = shared.util
local moduleUtil = sharedUtil.moduleUtil
local requireModule = require(moduleUtil.requireModule)

local sharedLib = shared.lib
local networkLib = require(sharedLib.networkLib)

-- Disable reset
starterGui:SetCore("ResetButtonCallback", false)

-- Require (and init) modules.
for _, controllerModule in pairs(controllers:GetChildren()) do
	requireModule("controller", controllerModule)
end

for _, storyModule in pairs(story:GetChildren()) do
	requireModule("story_node", storyModule)
end

for _, managerModule in pairs(managers:GetChildren()) do
	requireModule("manager", managerModule)
end

