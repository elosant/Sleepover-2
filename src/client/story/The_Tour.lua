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
	local station = workspace.Station
	local chamber = station.decompressionChamber

	networkLib.listenToServer("tweenChamberDoor", function(isOpen)
		tweenModel(
			station.door,
			station.door.PrimaryPart.CFrame + (isOpen and 1 or -1) * Vector3.new(0, 15, 0),
			TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
			true
		)
	end)
	networkLib.listenToServer("tweenChamberExitDoor", function(isOpen)
		tweenModel(
			chamber.door,
			chamber.door.PrimaryPart.CFrame + (isOpen and 1 or -1) * Vector3.new(0, 15, 0),
			TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
			true
		)
	end)

	local function tweenElevatorDoor(elevator, isOpen, leftDoorOpenDir)
		local leftDoor = elevator.leftDoor
		local rightDoor = elevator.rightDoor

		tweenModel(
			station.elevator.leftDoor,
			leftDoor.PrimaryPart.CFrame + (isOpen and leftDoorOpenDir or -leftDoorOpenDir) * Vector3.new(7, 0, 0),
			TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
			false
		)
		tweenModel(
			station.elevator.rightDoor,
			rightDoor.PrimaryPart.CFrame + (isOpen and -leftDoorOpenDir or leftDoorOpenDir) * Vector3.new(7, 0, 0),
			TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
			false
		)

	end

	networkLib.listenToServer("tweenChamberElevatorDoor", function(isOpen)
		tweenElevatorDoor(station.elevator, isOpen, 1)
	end)

	local cafeteria = station.cafeteria
	networkLib.listenToServer("tweenCafeEntranceDoor", function(isOpen)
		tweenElevatorDoor(cafeteria.entrance.elevator, isOpen, -1)
	end)

	networkLib.listenToServer("tweenCafeExitDoor", function(isOpen)
		tweenElevatorDoor(cafeteria.exit.elevator, isOpen, 1)
	end)
end)

return nil
