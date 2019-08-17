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

local sharedUtil = shared.util

local modelUtil = sharedUtil.modelUtil
local tweenModel = require(modelUtil.tweenModel)

networkLib.listenToServer("startTour", function()
	signalLib.dispatchAsync("newChapter", "The Tour")

	networkLib.listenToServer("tweenChamberDoor", function(isOpen)
		local station = workspace.Station
		tweenModel(
			station.door,
			station.door.PrimaryPart.CFrame + (isOpen and 1 or -1) * Vector3.new(0, 15, 0),
			TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
			true
		)
	end)
end)

return nil
