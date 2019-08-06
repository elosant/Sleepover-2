-- Services
local playersService = game:GetService("Players")

-- Player
local player = playersService.LocalPlayer
local playerGui = player.PlayerGui

local objectiveGui = playerGui:WaitForChild("ObjectiveGui")
local objectiveMainFrame = objectiveView.MainFrame.InnerFrame

local ObjectiveView = {}
local objectives = {}

function ObjectiveView.onNewObjective()
end

function ObjectiveView.onObjectiveRemoved()
end

return ObjectiveView
