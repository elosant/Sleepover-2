-- Local story modules are essentially listeners for story specific, replicated code. They needn't have any excess information.
-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local playersService = game:GetService("Players")
local tweenService = game:GetService("TweenService")
local runService = game:GetService("RunService")
local lightingService = game:GetService("Lighting")

-- Player
local player = playersService.LocalPlayer
local playerScripts = player:WaitForChild("PlayerScripts")
local client = playerScripts.client

local lib = client.lib
local cameraLib = require(lib.cameraLib)

local shared = replicatedStorage.shared

local sharedData = shared.data
local assetPool = require(sharedData.assetPool)

local sharedUtil = shared.util
local audioUtil = sharedUtil.audioUtil
local playAmbientSound = require(audioUtil.playAmbientSound)
local fadeOutSound = require(audioUtil.fadeOutSound)

local sharedLib = shared.lib
local networkLib = require(sharedLib.networkLib)
local signalLib =  require(sharedLib.signalLib)

local function MoveShuttle(shuttle, target, travelTime)
	local movementCFrameValue = Instance.new("CFrameValue")
	movementCFrameValue.Value = shuttle.PrimaryPart.CFrame

	local movementTween = tweenService:Create(
		movementCFrameValue,
		TweenInfo.new(travelTime, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
		{ Value = CFrame.new(target) }
	)
	movementTween:Play()

	local steppedConnection
	steppedConnection = runService.Heartbeat:Connect(function()
		shuttle:SetPrimaryPartCFrame(movementCFrameValue.Value)
	end)

	local finishedConnection
	finishedConnection = movementTween.Completed:Connect(function()
		steppedConnection:Disconnect()
		finishedConnection:Disconnect()
	end)

	return movementTween
end

local function RotateThruster(thruster, rotation, time)
	local vector3Value = Instance.new("Vector3Value")
	vector3Value.Parent = thruster
	vector3Value.Value = thruster.PrimaryPart.Orientation

	local rotationTween
	rotationTween = tweenService:Create(
		vector3Value,
		TweenInfo.new(time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
		{ Value = (vector3Value.Value * Vector3.new(1, 1, 0)) + Vector3.new(0, 0, rotation) }
	)
	rotationTween:Play()

	spawn(function()
		local startTime = tick()
		local elapsedTime = tick() - startTime

		while elapsedTime < time do
			elapsedTime = tick() - startTime
			runService.Stepped:Wait()
			for _, part in pairs(thruster:GetChildren()) do
				if part:IsA("BasePart") then
					part.Orientation = vector3Value.Value
				end
			end
		end
		wait(2)
		vector3Value:Destroy()
	end)

	return rotationTween
end

-- Invoked in introController
signalLib.subscribeAsync("moveShuttle", function()
	local shuttle = workspace.Shuttle
	local dockPoints = workspace.DockPoints
	local target = dockPoints.A.Position

	playAmbientSound(assetPool.Sound.CountdownTenMale)

	-- Preferably replicate thruster data to client, lack of synchroninity needn't matter.
	RotateThruster(shuttle.LeftThruster, -45, 4)
	RotateThruster(shuttle.RightThruster, 45, 4)

	wait(5)
	shuttle.LeftThruster.PrimaryPart.ParticleEmitter.Enabled = true
	shuttle.RightThruster.PrimaryPart.ParticleEmitter.Enabled = true

	wait(6)
	local shuttleLaunchSound = playAmbientSound(assetPool.Sound.ShuttleLaunch)
	wait(2)

	local movementTween = MoveShuttle(shuttle, target, 10)

	-- Play sounds until reached
	local targetReached do
		local highAltitudeWindSound = playAmbientSound(assetPool.Sound.HighAltitudeWind, { Looped = true }, true)
		local rocketRoarSound = playAmbientSound(assetPool.Sound.RocketRoar, { Looped = true }, true)

		-- Shake until reached target
		spawn(function()
			while not targetReached do
				cameraLib.shake(math.random(5,8), math.random(1,2.5), math.random(1,2))
				playAmbientSound(assetPool.Sound.RattleSound, { PlaybackSpeed = 5 })
				wait(math.random(2.5, 6))
			end
		end)

		movementTween.Completed:Connect(function()
			targetReached = true

			fadeOutSound(highAltitudeWindSound, 2)
			fadeOutSound(rocketRoarSound, 2)
		end)
	end

	-- Transition to night
	do
		local transitionToTime = 24
		spawn(function()
			while not targetReached do
				if shuttle.PrimaryPart.Position.Y > 2900 then
					tweenService:Create(
						lightingService,
						TweenInfo.new(18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
						{ ClockTime = transitionToTime }
					):Play()
	--				replicatedStorage.Sky.Parent = lightingService
					break
				end
				wait()
			end
		end)
	end

	-- Wait until (first) target reached
	movementTween.Completed:Wait()
	wait(2) -- Give time for other callbacks to get invoked
	movementTween:Destroy()

	-- Calls MoveShuttle and RotateThruster and yields
	local function TargetShuttle(shuttle, target, movementTime, leftRotation, rightRotation, rotationTime)
		RotateThruster(shuttle.LeftThruster, leftRotation, rotationTime)
		RotateThruster(shuttle.RightThruster, rightRotation, rotationTime)
		wait(rotationTime)

		MoveShuttle(shuttle, target, movementTime)
		wait(movementTime)
	end

	-- Move inside and above the landing pad
	target = dockPoints.B.Position
	TargetShuttle(shuttle, target, 7, 0, 0, 4)
	wait(0.5)

	-- Move down onto the pad
	target = dockPoints.C.Position
	TargetShuttle(shuttle, target, 4, -90, 90, 4)

	-- Fade out shuttle launch sound which is just a faint roar at this point.
	fadeOutSound(shuttleLaunchSound, 2)

	shuttle.LeftThruster.PrimaryPart.ParticleEmitter.Enabled = false
	shuttle.RightThruster.PrimaryPart.ParticleEmitter.Enabled = false

	networkLib.fireToServer("shuttleLanded")
end)

return nil
