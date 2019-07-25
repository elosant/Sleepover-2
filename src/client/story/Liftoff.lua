-- Local story modules are essentially listeners for story specific, replicated code. They needn't have any excess information.
-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")

local shared = replicatedStorage.shared
local networkLib = require(shared.networkLib)
local signalLib =  require(shared.signalLib)

local function MoveShuttle(shuttle, target, terminalSpeed, acceleration, deccelerationTime)
	local targetDist = (target - shuttle.PrimaryPart.Position).Magnitude
	local targetDir = (target - shuttle.PrimaryPart.Position).Unit
	local minTargetDist = 40

	local currentVelocity = 0
	local currentPos = shuttle.PrimaryPart.Position

	local leftThrusterOffset = shuttle.LeftThruster.PrimaryPart.CFrame:toObjectSpace(shuttle.PrimaryPart.CFrame)
	local rightThrusterOffset = shuttle.RightThruster.PrimaryPart.CFrame:toObjectSpace(shuttle.PrimaryPart.CFrame)

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

		if currentVelocity >= terminalSpeed then
			acceleration = terminalSpeed/deccelerationTime
		end

		currentVelocity = math.clamp(currentVelocity + acceleration*deltaTime, 0, terminalSpeed)
		currentPos = currentVelocity > 0 and (currentPos + targetDir*currentVelocity*deltaTime) or currentPos
	end)
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

networkLib.ListenToServer("moveShuttle", function(shuttle, target)
	-- Preferably replicate thruster data to client, lack of synchroninity needn't matter.
	RotateThruster(shuttle.LeftThruster, 45, 4)
	RotateThruster(shuttle.RightThruster, -45, 4)

	-- Deceleration time is amount of time after terminal velocity is reached to slow down.
	MoveShuttle(shuttle, target, 200, 50, 5)
end)

return nil
