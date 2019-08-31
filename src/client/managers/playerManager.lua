-- Services
local playersService = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local starterGui = game:GetService("StarterGui")

-- Player
local player = playersService.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

local shared = replicatedStorage.shared

local sharedLib = shared.lib
local networkLib = require(sharedLib.networkLib)

local function onLateJoin()
	camera.CameraType = Enum.CameraType.Scriptable
	camera.CFrame = CFrame.new(0, 0, 0)

	-- Destroy guis so the message is visible
	for _, gui in pairs(player.PlayerGui:GetChildren()) do
		pcall(gui.Destroy, gui)
	end

	local message = Instance.new("Message")
	message.Parent = workspace
	message.Text = [[
		Joined too late, your internet connection may not be fast enough to
		join the game within the envelope!

		Teleporting back to lobby.
	]]
end

local PlayerManager = {}

function PlayerManager.init()
	-- In case the player joins too late, prepare a message before teleport
	networkLib.listenToServer("lateJoinWarning", onLateJoin)

	pcall(function()
		starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
		starterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)

		playerGui:SetTopbarTransparency(0.5)
	end)
end

return PlayerManager
