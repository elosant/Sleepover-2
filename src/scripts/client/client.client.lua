-- Services
local playersService = game:GetService("Players")
local starterGui = game:GetService("StarterGui")

-- Player
local player = playersService.LocalPlayer
local playerScripts = player.PlayerScripts

local client = playerScripts.client
local managers = client.managers
local controllers = client.controllers
local story = client.story

-- Disable reset
starterGui:SetCore("ResetButtonCallback", false)

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

-- In case the player joins too late, prepare a message before teleporting them back (server side).
do
	local replicatedStorage = game:GetService("ReplicatedStorage")
	local shared = replicatedStorage.shared
	local sharedLib = shared.lib
	local networkLib = require(sharedLib.networkLib)

	networkLib.listenToServer("lateJoinWarning", function()
		local camera = workspace.CurrentCamera
		camera.CameraType = Enum.CameraType.Scriptable
		camera.CFrame = CFrame.new(0, 0, 0)

		for _, gui in pairs(player.PlayerGui:GetChildren()) do
			gui:Destroy()
		end

		local message = Instance.new("Message")
		message.Parent = workspace
		message.Text = "Joined too late, your internet connection may not be fast enough to join the game within the join time!\nTeleporting back to lobby."
	end)
end

