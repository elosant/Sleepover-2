-- Services
local playersService = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local runService = game:GetService("RunService")
local pathfindingService = game:GetService("PathfindingService")

-- Player
local player = playersService.LocalPlayer
local playerGui = player.PlayerGui

local objectiveGui = playerGui:WaitForChild("ObjectiveGui")
local objectiveMainFrame = objectiveGui.MainFrame.InnerFrame
local objectivesFrame = objectiveMainFrame.ObjectivesFrame

local ObjectiveView = {}
local objectives = {}

local isFrameVisible
local arrow
local worldTarget

-- Will shift any objective with the same position downards, or delete it once full
function ObjectiveView.onNewObjective(objective, position)
	if not position then
		position = math.clamp(#objectives+1, 1, 4)
	end
	if objectives[position] then
		warn("Element already exists in this position", position)
		return
	end

	objectives[position] = objective
	local objectiveFrame = objectivesFrame:FindFirstChild(tostring(position))
	if not objectiveFrame then
		return
	end

	objectiveFrame.ObjectiveText.Text = objective

	if not isFrameVisible then
		isFrameVisible = true
		objectiveMainFrame:TweenPosition(
			UDim2.new(0.5, 0, 0.5, 0),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quint,
			0.5,
			true
		)
		wait(0.5)
	end

	objectiveFrame:TweenPosition(
		UDim2.new(0, 0, objectiveFrame.Position.Y.Scale, 0),
		Enum.EasingDirection.Out,
		Enum.EasingStyle.Quint,
		0.4,
		true
	)
end

-- Arrow
function ObjectiveView.onNewWorldObjective(targetPos)
	local character = player.Character or player.CharacterAdded:Wait()

	-- Preferably try to compute a path first, before doing an arrow
	--[[
	do
		local pathObj = pathfindingService:CreatePath()
		pathObj:ComputeAsync(character.PrimaryPart.Position, targetPos)

		if pathObj.Status == Enum.PathStatus.Success then
			local pathParts = {}

			while worldTarget == targetPos do
				local tempPathObj = pathfindingService:CreatePath()
				tempPathObj:ComputeAsync(character.PrimaryPart.Position, targetPos)

				if tempPathObj.Status == Enum.PathStatus.Success then
					pathObj = tempPathObj
				else
					tempPathObj:Destroy()
				end

				local waypointArray = pathObj:GetWaypoints()
				for _, waypoint in ipairs(waypointArray) do
					print(waypoint.Position)
					if not pathParts[waypoint.Position] then
						local pathPart = Instance.new("Part")
						pathPart.Parent = workspace
						pathPart.Position = waypoint.Position
						pathPart.Size = Vector3.new(1, 1, 1)
						pathPart.Anchored = true
						pathPart.Material = Enum.Material.Neon
						pathPart.Color = Color3.new(1, 1, 1)
						pathParts[waypoint.Position] = pathPart
					end
				end
				wait(0.2)
			end

			for _, pathPart in pairs(pathParts) do
				pathPart:Destroy()
			end

			return
		end
	end
	--]]

	worldTarget = targetPos
	if not arrow then
		arrow = replicatedStorage.Arrow:Clone()
		arrow.Parent = workspace
		arrow.Anchored = false
		arrow.CanCollide = false
	end

	spawn(function()
		while worldTarget and worldTarget == targetPos do
			local normalDir = (targetPos - character.HumanoidRootPart.Position).Unit
			arrow.CFrame = CFrame.new(
				character.HumanoidRootPart.Position + 4*normalDir,
				targetPos
			)
			runService.Heartbeat:Wait()
		end
		arrow:Destroy()
	end)
end

function ObjectiveView.onObjectiveRemoved(objective)
	for index, currentObjective in pairs(objectives) do
		if currentObjective == objective then
			objectives[index] = nil

			local objectiveFrame = objectivesFrame:FindFirstChild(tostring(index))
			if objectiveFrame then
				objectiveFrame.ObjectiveText.Text = objective
				objectiveFrame:TweenPosition(
					UDim2.new(0, 0, objectiveFrame.Position.Y.Scale, 0),
					Enum.EasingDirection.Out,
					Enum.EasingStyle.Quint,
					0.4,
					true
				)
			end
		end
	end
	if #objectives == 0 then
		isFrameVisible = false

		objectiveMainFrame:TweenPosition(
			UDim2.new(-0.5, 0, 0.5, 0),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Quint,
			0.5,
			true
		)
	end
end

function ObjectiveView.onWorldObjectiveRemoved()
	worldTarget = nil
end

return ObjectiveView
