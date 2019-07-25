-- Services
local serverStorage = game:GetService("ServerStorage")
local replicatedStorage = game:GetService("ReplicatedStorage")
local playersService = game:GetService("Players")
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")

local server = serverStorage.server

local lib = server.lib
local dialogueLib = require(lib.dialogueLib)

local shared = replicatedStorage.shared

local sharedLib = shared.lib
local networkLib = require(sharedLib.networkLib)

local sharedUtil = shared.util
local modelUtil = sharedUtil.modelUtil
local moveModel = require(modelUtil.moveModel)

local dialogue = script.Parent.dialogue

local shuttle = workspace.Shuttle
local shuttleDockPart = workspace.ShuttleDockPoint

return function()
	-- Start intro for players
	for _, player in pairs(playersService:GetPlayers()) do
		networkLib.fireToClient(player, "startIntro")
	end
	playersService.PlayerAdded:Connect(function(player)
		networkLib.fireToClient(player, "startIntro")
	end)

	wait(18) -- temporary, should instead attempt to synchronise with all clients and use a larger max yield

	networkLib.fireAllClients("moveShuttle", shuttle, shuttleDockPart.Position)
end
