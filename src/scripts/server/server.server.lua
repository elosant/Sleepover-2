-- Services
local serverStorage = game:GetService("ServerStorage")

local managers = serverStorage.server.managers
local controllers = serverStorage.server.controllers

for _, controller in pairs(controllers:GetChildren()) do
	spawn(function() require(controller); end)
end

for _, manager in pairs(managers:GetChildren()) do
	spawn(function() require(manager).init(); end)
end
