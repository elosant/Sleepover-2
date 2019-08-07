-- Local story modules are essentially listeners for story specific, replicated code. They needn't have any excess information.
-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local playersService = game:GetService("Players")
local tweenService = game:GetService("TweenService")
local runService = game:GetService("RunService")
local lightingService = game:GetService("Lighting")

-- Player
local player = playersService.LocalPlayer
local playerScripts = player.PlayerScripts
local camera = workspace.CurrentCamera

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

local guiUtil = sharedUtil.guiUtil
local fadeObject = require(guiUtil.fadeObject)

local sharedLib = shared.lib
local networkLib = require(sharedLib.networkLib)
local signalLib = require(sharedLib.signalLib)

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
		if not shuttle or not shuttle.PrimaryPart then
			steppedConnection:Disconnect()
			return
		end
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
	local station = workspace.Station
	local dockPoints = workspace.DockPoints
	local target = dockPoints.A.Position
	local activeColor = Color3.fromRGB(13, 105, 172) -- Bright blue brick color

	wait(1.5)
	signalLib.dispatchAsync("newChapter", "Liftoff")

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

	local movementTween = MoveShuttle(shuttle, target, 1)--30)

	-- Play sounds until reached
	local targetReached do
		local highAltitudeWindSound = playAmbientSound(assetPool.Sound.HighAltitudeWind, { Looped = true }, true)
		local rocketRoarSound = playAmbientSound(assetPool.Sound.RocketRoar, { Looped = true }, true)

		-- Shake until reached target
		spawn(function()
			while not targetReached do
				cameraLib.shake(math.random(5.5,9), math.random(1,2.5), math.random(1,2))
				playAmbientSound(assetPool.Sound.RattleSound, { PlaybackSpeed = 5 })
				wait(math.random(2.5, 6))
			end
		end)

		movementTween.Completed:Connect(function()
			targetReached = true

			fadeOutSound(highAltitudeWindSound, 0.5)
			fadeOutSound(rocketRoarSound, 0.5)
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
	wait(1)
	movementTween:Destroy()

	-- Calls MoveShuttle and RotateThruster and yields
	local function TargetShuttle(shuttle, target, movementTime, leftRotation, rightRotation, rotationTime)
		RotateThruster(shuttle.LeftThruster, leftRotation, rotationTime)
		RotateThruster(shuttle.RightThruster, rightRotation, rotationTime)
		wait(rotationTime)

		MoveShuttle(shuttle, target, movementTime)
		wait(movementTime)
	end

	-- Recolor the forcefield and surrounding neon parts
	local doorRecolorParts = station.recolor:GetChildren()
	doorRecolorParts[#doorRecolorParts+1] = station.forcefieldLayer

	for _, part in pairs(doorRecolorParts) do
		tweenService:Create(
			part,
			TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
			{ Color = activeColor }
		):Play()
	end

	-- Move inside and above the landing pad
	target = dockPoints.B.Position
	TargetShuttle(shuttle, target, 2, 0, 0, 2)

	wait(0.5)

	-- Move down onto the pad
	target = dockPoints.C.Position
	TargetShuttle(shuttle, target, 2, -90, 90, 2)

	-- Fade out shuttle launch sound which is just a faint roar at this point.
	fadeOutSound(shuttleLaunchSound, 1)

	shuttle.LeftThruster.PrimaryPart.ParticleEmitter.Enabled = false
	shuttle.RightThruster.PrimaryPart.ParticleEmitter.Enabled = false

	networkLib.fireToServer("shuttleLanded")

	-- Do authentication gui fade in (gui to allow other players to sync)
	local synced
	signalLib.dispatchAsync("showTransition", nil, "Authenticating", function(transitionFrame)
		local transitionTextLabel = transitionFrame.TransitionTextLabel

		local transitionTextColors = {
			Color3.fromRGB(191, 97, 106),
			Color3.fromRGB(180, 142, 173),
			Color3.fromRGB(208, 135, 112)
		}
		local colorIndex = 0

		while not synced do
			wait(1.5)
			colorIndex = colorIndex + 1
			if colorIndex > #transitionTextColors then
				colorIndex = 1
			end

			tweenService:Create(
				transitionTextLabel,
				TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
				{ TextColor3 = transitionTextColors[colorIndex] }
			):Play()
		end

		transitionTextLabel.Text = "Authenticated"

		wait(2)
		local fadeTweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
		fadeObject(true, transitionFrame, fadeTweenInfo)
		fadeObject(true, transitionTextLabel, fadeTweenInfo)

		wait(fadeTweenInfo.Time)
		transitionTextLabel.TextTransparency = 1
	end)

	networkLib.listenToServer("shuttleLandedSynced", function(detailedShuttle)
		synced = true

		wait(1)
		shuttle:Destroy()
		camera.FieldOfView = 70
		cameraLib.setFocus(detailedShuttle.PrimaryPart, Vector3.new(-60, 10, -113))

		-- Tween light colors
		wait(2)
		local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
		local recolorParts = station.dockDynamic:GetChildren()

		for _, part in pairs(detailedShuttle.shuttleBody.misc.neonDoor:GetChildren()) do
			if part:IsA("BasePart") then
				recolorParts[#recolorParts+1] = part
			end
		end

		for _, part in pairs(recolorParts) do
			if part.Name ~= "interface" and part:IsA("BasePart") then
				tweenService:Create(
					part,
					tweenInfo,
					{ Color = activeColor }
				):Play()
			else
				tweenService:Create(
					part.SurfaceGui.status,
					tweenInfo,
					{ TextColor3 = activeColor }
				):Play()
			end
		end

		-- Extend ramp
		local ramp = station.ramp.extension
		local initialRampSize = ramp.Size
		local initialRampCFrame = ramp.CFrame

		local goalRampSize = Vector3.new(initialRampSize.X, initialRampSize.Y, 39)

		local extensionTime = 2
		local startTime = tick()

		while tick() - startTime < extensionTime do
			runService.Heartbeat:Wait()
			ramp.Size = initialRampSize:Lerp(goalRampSize, (tick() - startTime)/extensionTime)
			ramp.CFrame = initialRampCFrame + (-initialRampCFrame.lookVector * ramp.Size.Z/2)
		end

		wait(1)
		cameraLib.setFocus()
		camera.CameraType = Enum.CameraType.Custom
	end)
end)

return nil
