-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local playersService = game:GetService("Players")
local tweenService = game:GetService("TweenService")
local lightingService = game:GetService("Lighting")

-- Player
local player = playersService.LocalPlayer
local playerScripts = player.PlayerScripts

local client = playerScripts.client

local lib = client.lib
local cameraLib = require(lib.cameraLib)

local shared = replicatedStorage.shared

local sharedLib = shared.lib
local networkLib = require(sharedLib.networkLib)
local signalLib = require(sharedLib.signalLib)

local sharedData = shared.data
local assetPool = require(sharedData.assetPool)

local sharedUtil = shared.util

local modelUtil = sharedUtil.modelUtil
local tweenModel = require(modelUtil.tweenModel)

local audioUtil = sharedUtil.audioUtil
local playAmbientSound = require(audioUtil.playAmbientSound)

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

		wait(6)
		local cameraCFrame = CFrame.new(chamber.cameraFocusPart.Position, chamber.doorFrame.focusPart.Position)

		cameraLib.enableCinematicView(true)
		cameraLib.tweenCFrame(cameraCFrame, 2)
		cameraLib.setFocus(chamber.cameraFocusPart.CFrame)
	end)

	networkLib.listenToServer("tweenChamberExitDoor", function(isOpen)
		tweenModel(
			chamber.door,
			chamber.door.PrimaryPart.CFrame + (isOpen and 1 or -1) * Vector3.new(0, 15, 0),
			TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
			true
		)
		wait(1.5)
		cameraLib.setFocus()
		cameraLib.enableCinematicView(false)
	end)

	local function tweenElevatorDoor(elevator, isOpen, leftDoorOpenDir)
		local leftDoor = elevator.leftDoor
		local rightDoor = elevator.rightDoor

		tweenModel(
			leftDoor,
			leftDoor.PrimaryPart.CFrame + (isOpen and leftDoorOpenDir or -leftDoorOpenDir) * Vector3.new(7, 0, 0),
			TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
			false
		)
		tweenModel(
			rightDoor,
			rightDoor.PrimaryPart.CFrame + (isOpen and -leftDoorOpenDir or leftDoorOpenDir) * Vector3.new(7, 0, 0),
			TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
			false
		)

	end

	networkLib.listenToServer("tweenChamberElevatorDoor", function(isOpen)
		local elevator = station.elevator
		tweenElevatorDoor(elevator, isOpen, 1)

		local connection
		connection = elevator.base.Touched:Connect(function(part)
			if not part:IsDescendantOf(player.Character) then
				return
			end
			local targetCFrame = CFrame.new(elevator.cameraPart.Position, elevator.cameraFocus.Position)
			cameraLib.tweenCFrame(targetCFrame, 2)
			cameraLib.setFocus(targetCFrame)
			connection:Disconnect()
		end)
	end)

	local cafeteria = station.cafeteria
	networkLib.listenToServer("tweenCafeEntranceDoor", function(isOpen)
		cameraLib.setFocus()
		tweenElevatorDoor(cafeteria.entrance.elevator, isOpen, -1)
	end)

	networkLib.listenToServer("tweenCafeExitDoor", function(isOpen)
		local elevator = cafeteria.exit.elevator
		tweenElevatorDoor(elevator, isOpen, 1)

		local connection
		connection = elevator.base.Touched:Connect(function(part)
			if not part:IsDescendantOf(player.Character) then
				return
			end
			local targetCFrame = CFrame.new(elevator.cameraPart.Position, elevator.cameraFocus.Position)
			cameraLib.tweenCFrame(targetCFrame, 2)
			cameraLib.setFocus(targetCFrame)
			connection:Disconnect()
		end)
	end)

	local lab = station.lab
	networkLib.listenToServer("tweenLabElevatorDoor", function(isOpen)
		cameraLib.setFocus()
		tweenElevatorDoor(lab.elevator, isOpen, 1)
	end)

	networkLib.listenToServer("fadeDavidGlass", function(isOpen)
		tweenService:Create(
			lab.glassPart,
			TweenInfo.new(30, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
			{ Transparency = 0.8 }
		):Play()

		local cameraCFrame = CFrame.new(lab.David.PrimaryPart.Position + Vector3.new(0, 0, 8), lab.David.PrimaryPart.Position)
		cameraLib.enableCinematicView(true)
		cameraLib.setFocus(lab.David.PrimaryPart, Vector3.new(0, 0, -25))
		cameraLib.tweenCFrame(cameraCFrame, 35)
	end)

	networkLib.listenToServer("powerFlicker", function()
		cameraLib.setFocus(lab.glassPart, Vector3.new(0, 0, -8))
		cameraLib.tweenCFrame(lab.glassPart.CFrame + Vector3.new(0, 0, 8), 1)

		tweenService:Create(
			lightingService,
			TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
			{ Ambient = Color3.fromRGB(20, 20, 20) }
		):Play()

		for _, light in pairs(lab:GetDescendants()) do
			if light:IsA("Light") then
				tweenService:Create(
					light,
					TweenInfo.new(0.25, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
					{ Brightness = 0 }
				):Play()
			elseif light:IsA("BasePart") and light.Material == Enum.Material.Neon then
				tweenService:Create(
					light,
					TweenInfo.new(0.25, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
					{ Color = Color3.fromRGB(213, 58, 61) }
				):Play()
			end
		end

		cameraLib.shake(14, 1, 1.1)

		playAmbientSound(assetPool.IntenseSituation)
	end)
end)

return nil
