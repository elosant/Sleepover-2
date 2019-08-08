-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local playersService = game:GetService("Players")

-- Player
local player = playersService.LocalPlayer
local playerScripts = player.PlayerScripts

local client = playerScripts.client

local lib = client.lib
local decisionLib = lib.decisionLib

local shared = replicatedStorage.shared

local sharedLib = shared.lib
local networkLib = require(sharedLib.networkLib)
local signalLib = require(sharedLib.signalLib)

-- Listeners
signalLib.subscribeAsync("chooseOption", decisionLib.chooseOption)

signalLib.subscribeAsync("startVote", decisionLib.startVote)
networkLib.listenToServer("startVote", decisionLib.startVote)

-- Dispatchers
--...

return nil
