-- Services
local playersService = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")

-- Player
local player = playersService.LocalPlayer
local playerScripts = player.PlayerScripts

local client = playerScripts.client

local view = client.view
local transitionView = require(view.transitionView)

local shared = replicatedStorage.shared

local sharedLib = shared.lib
local networkLib = require(sharedLib.networkLib)
local signalLib = require(sharedLib.signalLib)

-- Inbound
networkLib.listenToServer("newChapter", transitionView.onNewChapter)
signalLib.subscribeAsync("newChapter", transitionView.onNewChapter)

networkLib.listenToServer("showTransition", transitionView.showTransition)
signalLib.subscribeAsync("showTransition", transitionView.showTransition)

return nil
