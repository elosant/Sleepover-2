-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local playersService = game:GetService("Players")

-- Player
local player = playersService.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local playerScripts = player:WaitForChild("PlayerScripts")

local client = playerScripts.client

local view = client.view
local loadingView = require(view.loadingView)

local shared = replicatedStorage.shared

local sharedLib = shared.lib
local signalLib = require(sharedLib.signalLib)
local networkLib = require(sharedLib.networkLib)

-- Outbound (from manager)
signalLib.subscribeAsync("startLoadingView", loadingView.onStartLoadingView)
signalLib.subscribeAsync("showAssetsLeft", loadingView.showAssetsLeft)
signalLib.subscribeAsync("preloadFinished", loadingView.onPreloadFinished)

-- Inbound
networkLib.listenToServer("startIntro", loadingView.onSynced)

return nil
