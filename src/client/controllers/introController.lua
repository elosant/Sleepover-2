-- Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local playersService = game:GetService("Players")

-- Player
local player = playersService.LocalPlayer
local playerScripts = player.PlayerScripts

local client = playerScripts.client

local view = client.view
local introView = require(view.introView)

local shared = replicatedStorage.shared

local sharedLib = shared.lib
local networkLib = require(sharedLib.networkLib)
local signalLib = require(sharedLib.signalLib)

-- Listener to network label startIntro is now held in introController to mitigate race conditions,
-- instead signalLib will be used to indicate the introController to start introView, which will
-- be dispatched by loadingController.
--networkLib.listenToServer("startIntro", introView.onStartIntro)
signalLib.subscribeAsync("loadingFinished", introView.onStartIntro)

signalLib.subscribeAsync("introFinished", function()
	signalLib.dispatchAsync("moveShuttle")
end)

return nil
