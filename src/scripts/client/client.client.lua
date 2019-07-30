-- Services
local playersService = game:GetService("Players")

-- Player
local player = playersService.LocalPlayer
local playerScripts = player:WaitForChild("PlayerScripts")

local client = playerScripts:WaitForChild("client")
local managers = client.managers
local controllers = client.controllers
local story = client.story

local function displayError(callType, err, traceback)
	local errOut = string.format("%s_ERROR: %s \nTRACEBACK: %s", callType:upper(), err, traceback)
	warn(errOut)
end

for _, controllerModule in pairs(controllers:GetChildren()) do
	spawn(function()
		local success, err = pcall(require, controllerModule)
		if not success then
			displayError("controller", err, debug.traceback())
		end
	end)
end

for _, storyModule in pairs(story:GetChildren()) do
	spawn(function()
		local success, err = pcall(require, storyModule)
		if not success then
			displayError("story_node", err, debug.traceback())
		end
	end)
end

for _, managerModule in pairs(managers:GetChildren()) do
	spawn(function()
		local success, data

		success, data = pcall(require, managerModule)
		if not success then
			displayError("manager_require", data, debug.traceback())
			warn(string.format("%s: will not attempt to init", managerModule.Name))
			return
		end

		success, data = pcall(data.init)
		if not success then
			displayError("manager_init", data, debug.traceback())
		end
	end)
end

