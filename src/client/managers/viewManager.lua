-- Manages ui scaling.

-- Services
local playersService = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Player
local player = playersService.LocalPlayer
local playerScripts = player:WaitForChild("PlayerScripts")
local playerGui = player:WaitForChild("PlayerGui")

local ViewManager = {}

function ViewManager.init()
	for _, viewModule in pairs(view:GetChildren()) do
		spawn(function() require(viewModule); end)
	end
end

function ViewManager.getViewClassByAspectRatio()

end

return ViewManager
