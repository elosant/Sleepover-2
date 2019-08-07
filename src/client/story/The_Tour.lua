-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local playersService = game:GetService("Players")

-- Player
local player = playersService.LocalPlayer
local playerScripts = player.PlayerScripts

local client = playerScripts.client

local shared = replicatedStorage.shared

local sharedLib = shared.lib
local networkLib = require(sharedLib.networkLib)
local signalLib = require(sharedLib.signalLib)

networkLib.listenToServer("startTour", function()
	local station = workspace.Station
	local tourGuide = station.scientist

	signalLib.dispatchAsync("newChapter", "The Tour")
	wait(4)
	signalLib.dispatchAsync("newObjective", "Meet the Tour Guide")
	signalLib.dispatchAsync("newWorldObjective", tourGuide.HumanoidRootPart.Position)
	wait(4)
	signalLib.dispatchAsync("removeObjective", "Meet the Tour Guide")
end)

return nil
