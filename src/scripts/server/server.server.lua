-- Services
local serverStorage = game:GetService("ServerStorage")
local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")

local managers = serverStorage.server.managers
local controllers = serverStorage.server.controllers

local shared = replicatedStorage.shared

local sharedUtil = shared.util

local moduleUtil = sharedUtil.moduleUtil
local requireModule = require(moduleUtil.requireModule)

-- Cannot be initialized here (may be dependencies of other managers, like loadingManager for example)
local excludedModules = {
	storyManager = true
}

for _, controller in pairs(controllers:GetChildren()) do
	if not excludedModules[controller.Name] then
		requireModule("controller", controller)
	end
end

for _, manager in pairs(managers:GetChildren()) do
	if not excludedModules[manager.Name] then
		requireModule("manager", manager)
	end
end
