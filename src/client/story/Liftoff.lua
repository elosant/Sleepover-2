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

local sharedLib = shared.lib
local networkLib = require(sharedLib.networkLib)
local signalLib =  require(sharedLib.signalLib)

local function MoveShuttle(shuttle, target, travelTime)
	local targetDist = (target - shuttle.PrimaryPart.Position).Magnitude
	local targetDir = (target - shuttle.PrimaryPart.Position).Unit
	local minTargetDist = 40

	local currentVelocity = 0
	local currentPos = shuttle.PrimaryPart.Position

	local leftThrusterOffset = shuttle.LeftThruster.PrimaryPart.CFrame:toObjectSpace(shuttle.PrimaryPart.CFrame)
	local rightThrusterOffset = shuttle.RightThruster.PrimaryPart.CFrame:toObjectSpace(shuttle.PrimaryPart.CFrame)

	local movementCFrameValue = Instance.new("CFrameValue")
	movementCFrameValue.Value = shuttle.PrimaryPart.CFrame
	local movementTween = tweenService:Create(
		movementCFrameValue,
		TweenInfo.new(travelTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{ Value = CFrame.new(target) }
	)
	movementTween:Play()

	local steppedConnection
	steppedConnection = runService.Heartbeat:Connect(function()
		shuttle:SetPrimaryPartCFrame(movementCFrameValue.Value)
	end)
	--[[
	-- Use tween service, easier than implementing easing yourself, linear acceleration won't look as good.
	local steppedConnection
	steppedConnection = runService.Stepped:Connect(function(_, deltaTime)
		local targetDist = (target - shuttle.PrimaryPart.Position).Magnitude
		if targetDist <= minTargetDist then
			steppedConnection:Disconnect()
			return
		end

		shuttle:SetPrimaryPartCFrame(
			CFrame.new(currentPos)--, shuttle.PrimaryPart.Position + shuttle.PrimaryPart.CFrame.lookVector)
		)

		-- Start deccelerating once reached terminal velocity.
		local velocityDelta = acceleration*deltaTime
		if currentVelocity >= terminalVelocity then
			velocityDelta = velocityDelta * (targetDist/1e4)
			print(velocityDelta)
		end

		currentVelocity = math.clamp(currentVelocity + velocityDelta, 0, terminalVelocity)
		currentPos = currentVelocity > 0 and (currentPos + targetDir*currentVelocity*deltaTime) or currentPos
	end)
	--]]
	local tweenCompleted
	movementTween:GetPropertyChangedSignal("PlaybackState"):Connect(function(state)
		if state == Enum.TweenStatus.Completed then
			tweenCompleted = true
		end
	end)
	while not tweenCompleted do
		wait()
	end
	return true
end

local function RotateThruster(thruster, rotation, time) -- Give rotation in euler angles as vector.
	local vector3Value = Instance.new("Vector3Value")
	vector3Value.Parent = thruster
	vector3Value.Value = thruster.PrimaryPart.Orientation
	tweenService:Create(
		vector3Value,
		TweenInfo.new(time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
		{ Value = vector3Value.Value + Vector3.new(0, 0, rotation) }
	):Play()

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
		vector3Value:Destroy()
	end)
end

networkLib.listenToServer("moveShuttle", function(shuttle, target)
	-- Preferably replicate thruster data to client, lack of synchroninity needn't matter.
	RotateThruster(shuttle.LeftThruster, 45, 4)
	RotateThruster(shuttle.RightThruster, -45, 4)

	wait(4)

	-- Deceleration time is amount of time after terminal velocity is reached to slow down.
	local targetReached
	spawn(function()
		while not targetReached do
			cameraLib.shake(math.random(5,8), math.random(1,2.5), math.random(1,2))
			wait(math.random(2.5, 6))
		end
	end)
	spawn(function()
		local transitionToTime = 24
		while not targetReached do
			if shuttle.PrimaryPart.Position.Y > 2900 then
				tweenService:Create(
					lightingService,
					TweenInfo.new(18.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
					{ ClockTime = transitionToTime }
				):Play()
--				replicatedStorage.Sky.Parent = lightingService
				break
			end
			wait()
		end
	end)

	targetReached = MoveShuttle(shuttle, target, 30)
end)

return nil
