-- Services
local serverStorage = game:GetService("ServerStorage")

local managers = serverStorage.server.managers
local controllers = serverStorage.server.controllers

 -- Cannot be initialized here (may be dependencies of other managers, like loadingManager for example)
local excludedManagers = {
	storyManager = true
}

for _, controller in pairs(controllers:GetChildren()) do
	spawn(function() require(controller); end)
end

for _, manager in pairs(managers:GetChildren()) do
	if not excludedManagers[manager.Name] then
		spawn(function() require(manager).init(); end)
	end
end
