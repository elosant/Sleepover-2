-- Services
local serverStorage = game:GetService("ServerStorage")
local replicatedStorage = game:GetService("ReplicatedStorage")

local server = serverStorage.server

local managers = server.managers
local controllers = server.controllers
local systems = server.systems

local shared = replicatedStorage.shared

local sharedUtil = shared.util

local moduleUtil = sharedUtil.moduleUtil
local requireModule = require(moduleUtil.requireModule)

-- Cannot be initialized here (may be dependencies of other managers, like loadingManager for example)
local excludedModules = {
	storyManager = true
}

for _, controllerModule in pairs(controllers:GetChildren()) do
	if not excludedModules[controllerModule.Name] then
		requireModule("controller", controllerModule)
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
