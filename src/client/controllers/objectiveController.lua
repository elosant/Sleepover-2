-- Services
local playersService = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Player
local player = playersService.LocalPlayer
local playerScripts = player.PlayerScripts

local client = playerScripts.client

local view = client.view
local objectiveView = require(view.objectiveView)

local shared = replicatedStorage.shared

local sharedLib = shared.lib
local networkLib = require(sharedLib.networkLib)
local signalLib = require(sharedLib.signalLib)

-- Inbound
networkLib.listenToServer("newObjective", objectiveView.onNewObjective)
signalLib.subscribeAsync("newObjective", objectiveView.onNewObjective)

networkLib.listenToServer("removeObjective", objectiveView.onObjectiveRemoved)
signalLib.subscribeAsync("removeObjective", objectiveView.onObjectiveRemoved)

networkLib.listenToServer("newWorldObjective", objectiveView.onNewWorldObjective)
signalLib.subscribeAsync("newWorldObjective", objectiveView.onNewWorldObjective)

networkLib.listenToServer("removeWorldObjective", objectiveView.onWorldObjectiveRemoved)
signalLib.subscribeAsync("removeWorldObjective", objectiveView.onWorldObjectiveRemoved)

return nil
